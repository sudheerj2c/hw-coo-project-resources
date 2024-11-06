#!/bin/bash
repo="https://github.com/nanidevsecops"
env="bld"
workstreamlist="coo"
tempaltelist="workstream-jcl-template"
rm -rf wtemp
mkdir wtemp
cd wtemp
for workstream_template in ${workstreamlist//,/ }
do
mkdir ${workstream_template}
cd ${workstream_template}
workstream=hw-${workstream_template}-project-resources
echo "cloning ${repo}/${workstream}"
git clone ${repo}/${workstream}/

#for latest_template in ${tempaltelist//,/ }
#do
#template=$(echo "${latest_template}" | cut -d '_' -f 2)
#latest_version=$(gh release list --repo "${repo}/${latest_template}"/ | awk NR==1{'print $1'} | sed 's/^/"/;s/$/"/')
latest_version="v19.36.0"
echo "$latest_template" latest version is "$latest_version" >>result.txt
echo "checking template: ${template}"

current_version=$(gh repo view "${repo}/${workstream}"/ | find ./ type f -name "terraform.tfvars" -exec grep -r "template = {
version = " {}} \;| egrep -w "${env}/${template}"| awk '{print $NF}')

if [ "$template" = "jcl" ]; then
 echo "processing jcl template"
 if [ "${latest_version}" > "${current_version}" ]; then
   echo "Latest version ($latest_version) is greater then current version ($current_version)
   cd ${workstream}
   pwd
   read -p "selected branch is:" branch_name
   git checkout -b "${branch_name}
   git branch -a 
   echo "starting..........."
   git status
   gh repo view "${repo}"/${workstream}"/ | find ./ -type f -name "terraform.tfvars" -exec grep -r "template = {
   version = " {} \; egrep -w "${env}/${template}" | sed -i -e "s/version = \"${current_version}\"/version = \"\${latest_version}\"/"
   echo "final............."
   git status
   git diff
   git add .
   read -p "selected commit_msg is:" commit_msg
   git commit -m "dummy:${commit_msg}"
   git push origin "${branch_name}
   git checkout "${branch_name}"
   git log
   git pull origin master
   gh pr create --base main --head ${branch_name}  --title ${commit_msg} --body "pr creation"
   else
   echo "Latest version {$latest_version} is not greater than current version ($current_version)" 
   fi
   fi
   done
   done


