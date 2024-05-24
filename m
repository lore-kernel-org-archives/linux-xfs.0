Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4F1FB5
	for <linux-xfs@vger.kernel.org>; Sat, 25 May 2024 00:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716595636; cv=none; b=a3DUcJOfbREwIGz9BhoDti1bAHJLVckDi5pEI7VbsiQslOEpOHa/u/Al0Yh4ThaEdeW3McCcgkq9Iem/wZr51Ym7PPJpeFhRrqzQeiZ/NC5kNlAfauu9L2WBLXxqokovMAcuvgXHTUwfSNzjIjQ4MJB3IWJRe2VAJn/Uv0GUFLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716595636; c=relaxed/simple;
	bh=KGT5ZkD06bgXEYmTVyQlVMbHH962BrlZoGWZOuw50Yc=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=hdhH1DLLFLTDRE3hlqG9psuX+ukXtBidsJKxh0TDWD1jbIubT0yxtFb/4OBRhRSxInlW0mbBsW06xA9nM10HZHXexoPU9uFKP3Ue34xGpJsEkli6Gs2QaVaja4UexatQ+Xg08UNN18VLMUKejoDrWvcs9XXXSvwXh9ieLtVE+iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=JkUrSgMB; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="JkUrSgMB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=KGT5ZkD06bgXEYmTVyQlVMbHH962BrlZoGWZOuw50Yc=; b=JkUrSgMBTDOnAQDwi6QltjpwKt
	GH7d+IHWSAoi/p+64qBwxwHOO2XJFiQHykv3MqlyVnkpj28dTdWszS3NLoGUVAEes3moM/Ct3bALn
	IKRm6WUisCeSCmC3+sd2K3Jwx5AnaA2aKGqIlmgczXw9AdUtBeZ9g1C7yUZPGznhxqI4KI7bGiloP
	8ZUhiDPC2RJ5iXTxpcvUV8itO/FBXzj8fRIN3STuVij/2f+rtNSisdE3clSKK8fFSTnFk+sebiiSG
	fxHcCKnodZoPtSvDGI+HblVp1JNZBloVikcMXhSFyqT1txp9KTvkCyYxvx3WVN6BaAwayGh5mpVBm
	dHs6isvw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sAemp-000FLF-S1; Fri, 24 May 2024 23:57:23 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Chris Hofstaedtler <zeha@debian.org>
CC: debian-cloud@lists.debian.org, scott@kitterman.com,
 leamas.alec@gmail.com, filesystems-devel@lists.alioth.debian.org,
 bastian.blank@credativ.de, jerome@maroufle.fr,
 suntong001@users.sourceforge.net, debian-hpc@lists.debian.org,
 team+pkg-security@tracker.debian.org,
 pkg-freeipa-devel@alioth-lists.debian.net, debian-gcc@lists.debian.org,
 blade@debian.org, miriam@debian.org, axel@tty0.ch,
 pkg-java-maintainers@lists.alioth.debian.org, tomasz@debian.org,
 pkg-voip-maintainers@lists.alioth.debian.org, mpearson-lenovo@squebb.ca,
 gcs@debian.org, jscott@posteo.net, linux-xfs@vger.kernel.org,
 team+kylin@tracker.debian.org, debian@alteholz.de, rrs@debian.org,
 kaduk@mit.edu, debian-astro-maintainers@lists.alioth.debian.org,
 pkg-gtkpod-devel@alioth-lists.debian.net, ao2@ao2.it,
 glaubitz@physik.fu-berlin.de, debian-printing@lists.debian.org,
 hmh@debian.org, team+python@tracker.debian.org, bunk@debian.org,
 team+pkg-go@tracker.debian.org,
 android-tools-devel@lists.alioth.debian.org,
 debian-remote@lists.debian.org, hyperair@debian.org,
 pkg-electronics-devel@lists.alioth.debian.org,
 debian-mate@lists.debian.org, josue@debian.org,
 pkg-zfsonlinux-devel@alioth-lists.debian.net, ryan@finnie.org,
 pkg-alsa-devel@lists.alioth.debian.org,
 pkg-libvirt-maintainers@lists.alioth.debian.org,
 pkg-electronics-devel@alioth-lists.debian.net
Subject: Processed: bump severity for usr-merge bugs
Message-ID: <handler.s.C.171659491058537.transcript@bugs.debian.org>
References: <ZlEovuxZOeT8rmv8@per>
X-Debian-PR-Package: fuse src:mbpfan src:dahdi-firmware src:waagent
 src:gcc-snapshot amazon-ec2-net-utils src:ukui-settings-daemon
 src:chasquid src:squeak-plugins-scratch src:open-ath9k-htc-firmware
 src:linux-minidisc guestfsd src:libpsm2 src:opencpn src:alsa-tools
 src:snoopy src:qlcplus ntfs-3g src:kinect-audio-setup src:libmicam
 src:libfli src:libirecovery src:libplayerone src:x2gothinclient
 src:firmware-sof src:atmel-firmware src:f2fs-tools src:mate-settings-daemon
 src:xfsprogs src:libasi src:zfs-linux src:apt-cacher-ng src:openafs
 src:rpcbind src:mergerfs src:libinovasdk src:signify-openbsd
 src:teensy-loader-cli src:btrbk src:xperia-flashtool libunwind8
 src:apcupsd src:intel-microcode src:fpga-icestorm src:ecryptfs-utils
 src:hfsprogs r4d dbab src:android-sdk-meta src:opendmarc fuse3
 src:amd64-microcode src:389-ds-base src:ipp-usb
X-Debian-PR-Source: 389-ds-base alsa-tools amazon-ec2-net-utils
 amd64-microcode android-sdk-meta apcupsd apt-cacher-ng atmel-firmware
 btrbk chasquid dahdi-firmware dbab ecryptfs-utils f2fs-tools firmware-sof
 fpga-icestorm fuse fuse3 gcc-snapshot hfsprogs intel-microcode ipp-usb
 kinect-audio-setup libasi libfli libguestfs libinovasdk libirecovery
 libmicam libplayerone libpsm2 libunwind linux-minidisc mate-settings-daemon
 mbpfan mergerfs ntfs-3g open-ath9k-htc-firmware openafs opencpn opendmarc
 qlcplus r4d rpcbind signify-openbsd snoopy squeak-plugins-scratch
 teensy-loader-cli ukui-settings-daemon waagent x2gothinclient xfsprogs
 xperia-flashtool zfs-linux
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Fri, 24 May 2024 23:57:23 +0000

Processing commands for control@bugs.debian.org:

> severity 1057743 important
Bug #1057743 [src:android-sdk-meta] android-sdk-meta: delegate placement of=
 udev files to udev.pc
Severity set to 'important' from 'normal'
> severity 1057752 important
Bug #1057752 [src:fpga-icestorm] fpga-icestorm: delegate placement of udev =
files to pkg-config data
Severity set to 'important' from 'normal'
> severity 1057793 important
Bug #1057793 [src:ipp-usb] ipp-usb: delegate placement of systemd/udev file=
s to pkg-config data
Severity set to 'important' from 'normal'
> severity 1057803 important
Bug #1057803 [src:libfli] libfli: delegate placement of udev files to pkg-c=
onfig data
Severity set to 'important' from 'normal'
> severity 1057818 important
Bug #1057818 [src:libirecovery] libirecovery: delegate placement of udev fi=
les to pkg-config data
Severity set to 'important' from 'normal'
> severity 1057822 important
Bug #1057822 [src:libpsm2] libpsm2: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1057827 important
Bug #1057827 [src:linux-minidisc] linux-minidisc: use udev.pc to place udev=
 rules
Severity set to 'important' from 'normal'
> severity 1057900 important
Bug #1057900 [src:apcupsd] apcupsd: move files from / to /usr
Severity set to 'important' from 'normal'
> severity 1058769 important
Bug #1058769 [amazon-ec2-net-utils] amazon-ec2-net-utils: please move syste=
md service files (again)
Severity set to 'important' from 'normal'
> severity 1058772 important
Bug #1058772 [src:btrbk] btrbk: let debhelper pick location of systemd serv=
ice
Severity set to 'important' from 'normal'
> severity 1058820 important
Bug #1058820 [src:xperia-flashtool] xperia-flashtool: let dh_installudev pi=
ck location of udev rules
Severity set to 'important' from 'normal'
> severity 1058821 important
Bug #1058821 [src:x2gothinclient] x2gothinclient: use udev.pc to place udev=
 rules
Severity set to 'important' from 'normal'
> severity 1058825 important
Bug #1058825 [src:waagent] waagent: places udev rule into /lib (hard-coded =
path)
Severity set to 'important' from 'normal'
> severity 1058827 important
Bug #1058827 [src:ukui-settings-daemon] ukui-settings-daemon: let dh_instal=
ludev pick location of udev rules
Severity set to 'important' from 'normal'
> severity 1058831 important
Bug #1058831 [src:squeak-plugins-scratch] squeak-plugins-scratch: let dh_in=
stalludev pick location of udev rules
Severity set to 'important' from 'normal'
> severity 1058833 important
Bug #1058833 [src:qlcplus] qlcplus: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1058839 important
Bug #1058839 [src:opencpn] opencpn: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1058840 important
Bug #1058840 [src:libplayerone] libplayerone: use udev.pc to place udev rul=
es
Severity set to 'important' from 'normal'
> severity 1058842 important
Bug #1058842 [src:libmicam] libmicam: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1058844 important
Bug #1058844 [src:libinovasdk] libinovasdk: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1058845 important
Bug #1058845 [src:libasi] libasi: use udev.pc to place udev rules
Severity set to 'important' from 'normal'
> severity 1058846 important
Bug #1058846 [src:kinect-audio-setup] kinect-audio-setup: use udev.pc to pl=
ace udev rules
Severity set to 'important' from 'normal'
> severity 1058856 important
Bug #1058856 [src:mbpfan] mbpfan: installs an empty /lib/systemd/system
Severity set to 'important' from 'normal'
> severity 1058857 important
Bug #1058857 [src:alsa-tools] alsa-tools: use udev.pc to place udev rules a=
nd helpers
Severity set to 'important' from 'normal'
> severity 1058859 important
Bug #1058859 [src:teensy-loader-cli] teensy-loader-cli: use udev.pc to plac=
e udev rules
Severity set to 'important' from 'normal'
> severity 1059190 important
Bug #1059190 [src:apt-cacher-ng] apt-cacher-ng: installs empty /lib/systemd=
/system directory
Severity set to 'important' from 'normal'
> severity 1059283 important
Bug #1059283 [src:mate-settings-daemon] mate-settings-daemon: use udev.pc t=
o place udev rules
Severity set to 'important' from 'normal'
> severity 1059365 important
Bug #1059365 [src:mergerfs] mergerfs: install files into /usr (instead of /)
Severity set to 'important' from 'normal'
> severity 1059372 important
Bug #1059372 [src:amd64-microcode] amd64-microcode: install files into /usr=
 (instead of /)
Severity set to 'important' from 'normal'
> severity 1059378 important
Bug #1059378 [src:dahdi-firmware] dahdi-firmware: install files into /usr (=
instead of /)
Severity set to 'important' from 'normal'
> severity 1059379 important
Bug #1059379 [src:f2fs-tools] f2fs-tools: install files into /usr (instead =
of /)
Severity set to 'important' from 'normal'
> severity 1059414 important
Bug #1059414 [src:open-ath9k-htc-firmware] open-ath9k-htc-firmware: install=
 files into /usr (instead of /)
Severity set to 'important' from 'normal'
> severity 1059432 important
Bug #1059432 [src:openafs] openafs: install afsd into /usr/sbin
Severity set to 'important' from 'normal'
> severity 1059516 important
Bug #1059516 [src:chasquid] chasquid: install systemd units into /usr
Severity set to 'important' from 'normal'
> severity 1060195 important
Bug #1060195 [src:hfsprogs] hfsprogs: install files into /usr (DEP17)
Severity set to 'important' from 'normal'
> severity 1060200 important
Bug #1060200 [src:intel-microcode] intel-microcode: install files into /usr=
 (DEP17)
Severity set to 'important' from 'normal'
> severity 1060333 important
Bug #1060333 [src:atmel-firmware] atmel-firmware: install files into /usr (=
DEP17)
Severity set to 'important' from 'normal'
> severity 1060335 important
Bug #1060335 [src:389-ds-base] 389-ds-base: install files into /usr (DEP17 =
M2)
Severity set to 'important' from 'normal'
> severity 1060344 important
Bug #1060344 [src:ecryptfs-utils] ecryptfs-utils: install files into /usr (=
DEP17 M2)
Severity set to 'important' from 'normal'
> severity 1060352 important
Bug #1060352 [src:xfsprogs] xfsprogs: install all files into /usr (DEP17 M2)
Severity set to 'important' from 'normal'
> severity 1060356 important
Bug #1060356 [src:signify-openbsd] signify-openbsd: install into /usr (DEP1=
7)
Severity set to 'important' from 'normal'
> severity 1060358 important
Bug #1060358 [src:rpcbind] rpcbind: install rpcbind into /usr (DEP17 M2)
Severity set to 'important' from 'normal'
> severity 1057804 important
Bug #1057804 [guestfsd] guestfsd: move /lib/udev/rules.d/99-guestfs-serial.=
rules into /usr
Severity set to 'important' from 'normal'
> severity 1058764 important
Bug #1058764 [src:opendmarc] opendmarc: installs deprecated /lib/opendmarc/=
opendmarc.service.generate
Severity set to 'important' from 'normal'
> severity 1059371 important
Bug #1059371 [src:snoopy] snoopy: installs library into /lib
Severity set to 'important' from 'normal'
> severity 1059757 important
Bug #1059757 [src:firmware-sof] firmware-sof: please install into /usr
Severity set to 'important' from 'normal'
> severity 1060080 important
Bug #1060080 [src:gcc-snapshot] gcc-snapshot: please stop creating empty di=
rs in /lib
Severity set to 'important' from 'normal'
> severity 1060229 important
Bug #1060229 [fuse,fuse3,ntfs-3g] fuse,fuse3,ntfs-3g: migrate dpkg-statover=
ride for UsrMerge?
Severity set to 'important' from 'normal'
> severity 1060315 important
Bug #1060315 [src:mbpfan] mbpfan: installs new files outside of /usr (DEP17=
 M2)
Severity set to 'important' from 'normal'
> severity 1060799 important
Bug #1060799 [libunwind8] libunwind8: installs empty /lib directory
Severity set to 'important' from 'normal'
> severity 1061359 important
Bug #1061359 [src:zfs-linux] zfs-linux: please install files into /usr
Severity set to 'important' from 'normal'
> severity 1065306 important
Bug #1065306 [dbab] dbab: installs systemd unit files into /
Severity set to 'important' from 'normal'
> severity 1065307 important
Bug #1065307 [r4d] r4d: installs systemd unit files into /lib
Severity set to 'important' from 'normal'
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1057743: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057743
1057752: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057752
1057793: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057793
1057803: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057803
1057804: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057804
1057818: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057818
1057822: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057822
1057827: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057827
1057900: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1057900
1058764: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058764
1058769: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058769
1058772: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058772
1058820: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058820
1058821: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058821
1058825: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058825
1058827: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058827
1058831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058831
1058833: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058833
1058839: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058839
1058840: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058840
1058842: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058842
1058844: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058844
1058845: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058845
1058846: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058846
1058856: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058856
1058857: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058857
1058859: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1058859
1059190: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059190
1059283: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059283
1059365: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059365
1059371: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059371
1059372: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059372
1059378: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059378
1059379: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059379
1059414: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059414
1059432: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059432
1059516: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059516
1059757: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059757
1060080: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060080
1060195: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060195
1060200: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060200
1060229: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060229
1060315: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060315
1060333: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060333
1060335: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060335
1060344: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060344
1060352: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060352
1060356: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060356
1060358: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060358
1060799: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1060799
1061359: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1061359
1065306: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1065306
1065307: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1065307
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
