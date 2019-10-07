#!/bin/bash

# Theme Init - Wp Pro Club
# by DimaMinka (https://dimaminka.com)
# https://github.com/wp-pro-club/init

source ${PWD}/lib/app-init.sh

version=""
zip="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/([^\/:]+)\/([^\/:]+)\/(.+).zip$"
# Get the theme and run install by type
printf "${GRN}=============================================${NC}\n"
printf "${GRN}Installing theme $conf_app_theme_name${NC}\n"
printf "${GRN}=============================================${NC}\n"
# Running theme install via wp-cli
if [ "$conf_app_theme_package" == "wp-cli" ]; then
    # Install from zip
    if [[ $conf_app_theme_zip =~ $zip ]]; then
        wp theme install $conf_app_theme_zip
    else
        # Get theme version from config
        if [ "$conf_app_theme_ver" != "*" ]; then
            version="--version=$conf_app_theme_ver --force"
        fi
        # Default theme install via wp-cli
        wp theme install $conf_app_theme_name ${version}
    fi
elif [ "$conf_app_theme_package" == "wpackagist" ]; then
    # Install theme from wpackagist via composer
    composer require wpackagist-theme/$conf_app_theme_name:$conf_app_theme_ver --update-no-dev
elif [ "$conf_app_theme_package" == "composer_bitbucket" ]; then
    ## Install plugin from private bitbacket repository via composer
    project=$conf_app_theme_name
    project_ver=$conf_app_theme_ver
    if [ ! -z "$conf_app_theme_branch" ]; then
        package_name=$conf_app_theme_branch
    else
        package_name=$project_ver
    fi
    project_zip="https://bitbucket.org/$project/get/$package_name.zip"
    # Rename the package if config exist
    if [ ! -z "$conf_app_theme_rename" ]; then
        project=$conf_app_theme_rename
    fi
    composer config repositories.$project '{"type":"package","package": {"name": "'$project'","version": "'$project_ver'","type": "wordpress-theme","dist": {"url": "'$project_zip'","type": "zip"}}}'
    composer require $project:$project_ver --update-no-dev
fi
