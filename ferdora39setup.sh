#!/bin/bash


#Setting variables according to user preferences.
echo "What is it going to be your hostname?"
read -r yourname
echo "Is this a laptop, (1)YES, (0)NO?"
read -r laptopyn
echo "the CPU is INTEL(1) or AMD(0)"
read -r cpu

		
		####echo "If you would like to reenter the information type (1)YES; (2)NO"
		####read -r again
		####Loop back to first echo if again -eq 1
		####if [ $again -eq 1 ] 
		####then


#Setting hostname.
echo ">>>>Setting you up Champ"
echo "$yourname are you sure?"
	sleep 2
		hostnamectl set-hostname "$yourname"
echo "Your hostname is set to:" 
		hostname
	sleep 2


#Updating OS & disable NtwrkMngr-wait
echo ">>>>Starting updates"
	sudo dnf -y upgrade
	sudo dnf -y upgrade --refresh
	sudo dnf -y update
	sudo dnf -y groupupdate core
	sudo fwupdmgr refresh --force
	sudo fwupdmgr update --force
	sudo systemctl disable NetworkManager-wait-online.service
	echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
	gsettings set org.gnome.desktop.interface show-battery-percentage true
echo ">>>>You are up to date 1/11"
	sleep 1


#Downloading, Installing & Cp already customized conf file to correct path
echo ">>>>Installing Kitty terminal"
	sudo dnf -y install wget
	sudo dnf -y install vim
#	sudo dnf -y install neovim
#	sudo dnf -y install kitty
#conf file missing the correct font:.Iosevak
#	sudo cp -r ~/basicfedorasetup/kitty.conf ~/.config/kitty/
#echo ">>>>Kitty INSTALLED and setup 2/11"


#Enabling rpm-fusion & flatpak Repositories
echo ">>>>Sarting with the repo's"
	sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E 	%fedora)".noarch.rpm
echo ">>>>rpmfusion INSTALLED 3/11"
	sudo dnf install -y flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo ">>>>flatpack INSTALLED 4/11"
	sleep 2


#Installing essential software "for my use case & preferences"
echo ">>>>Installing essentials"
	sudo dnf install -y 'google-roboto*' 'mozilla-fira*' fira-code-fonts
	sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
	flatpak install flathub -y com.mattjakeman.ExtensionManager
	sudo dnf install -y unzip p7zip p7zip-plugins unrar
	sudo dnf install -y gnome-tweaks
#	sudo dnf install -y gimp
#	sudo dnf install -y gimp-devel
	sudo dnf install -y nautilus-python
	sudo rpm -i --force https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
echo ">>>>google-roboto mozilla-firra,flathpak,unzip,gnome-tweaks,gimp,nautilus-python; INSTALLED 5/11"


#Installing some of my most ,non native, used commands
echo ">>>>Installing Commands"
	sudo dnf install -y tmux
	sudo dnf install -y sysstat
	sudo dnf install -y htop
	sudo dnf install -y copr-cli
#	rpm -q cronie
#	rpm -q cronie-anacron
#	sudo dnf install -y cronie
#	sudo dnf install -y cronie-anacron
echo ">>>>tmux,iostat,htop,copr-cli,cronie,cronie-anacron; INSTALLED 6/11"


#Installing most of the software with visual interface that i'm using
echo ">>>>Installing Basic Software"
	flatpak install -y flathub com.google.Chrome
	flatpak install -y flathub com.discordapp.Discord
	flatpak install -y flathub com.spotify.Client
	sudo dnf install -y vlc
	#####flatpak install -y flathub org.qbittorrent.qBittorrent
	sudo dnf copr enable -y jerrycasiano/FontManager
	sudo dnf install -y font-manager
echo ">>>Chrome,Discord,Spotify,Font-Manager; INSTALLED 7/11"
	sleep 2


#Intalling Docker engine & desktop
#echo ">>>>Installing Docker and Docker-Desktop"
#	sudo dnf remove -y docker docker-engine docker-client docker-common docker-logrotate docker-latest
#	sudo wget -r https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm?utm_source=docker & utm_medium=webreferral & utm_campaign=docs-driven-download-linux-amd64
#	sudo dnf install -y dnf-plugins-core
#	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#	sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
#	sudo systemctl --force start docker
#	sudo systemctl --force enable docker
#	sudo dnf install -y ./Downloads/docker-desktop-x86_64.rpm
		###to upgrade your Docker Desktop for Linux app, you need to download the latest package and run:
		###sudo dnf install ./docker-desktop-<version>-<arch>.rpm
#echo ">>>>Docker INTALLED 8/11"


#If marked as 1(YES), then installing battery optimization for laptops
if [ "$laptopyn" -eq 1 ]; then
	echo ">>>>Starting Laptop Optimization"
		sudo dnf install -y tlp tlp-rdw
		sudo systemctl --force mask power-profiles-daemon
		sudo dnf install -y powertop
		sudo powertop --auto-tune
	echo ">>>>Laptop Optimazation DONE 9/11"
else
	echo ">>>>This isn't a laptop"
	echo ">>>>OK  10/11"
	sleep 2
fi


#Multimedia drivers
echo ">>>>Sound&Video"
	sudo dnf update -y @sound-and-video
	sudo dnf install -y Multimedia
	sudo dnf install -y ffmpeg ffmpeg-libs libva libva-utils --allowerasing
echo ">>>>Sound&Video drivers DONE 10/11"


#CPU brand specific drivers.
if [ "$cpu" -eq 1 ]; then
	echo ">>>>Installing Intel drivers"
		sudo dnf -y swap libva-intel-media-driver intel-media-driver --allowerasing
else
	echo ">>>>Installing AMD drivers"
		sudo dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
		sudo dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
fi
	echo ">>>>CPU drivers DONE 11/11"


#All Steps are Done
echo ">>>>ALL SET AND READY"
	sleep 2
echo ">>>>>YOUR MACHINE WILL BE RESTARTED IN 5 seconds for all changes to take place"
	sleep 5
		sudo reboot
