Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 11:43:25 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVJhH42024164
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:43:21 -0800
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28427BD4E4B
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:43:31 -0800 (PST)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com with ESMTP id sG7HvO1OP40ZnWdW for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:43:31 -0800 (PST)
Received: from [134.29.32.1] (j3gum-3.ITS.MNSU.EDU [134.29.32.1])
	by mail.mnsu.edu (8.13.7/8.13.7) with ESMTP id lBVJhU3r011864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 13:43:30 -0600
Message-ID: <4779466E.40104@mnsu.edu>
Date: Mon, 31 Dec 2007 13:43:42 -0600
From: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: [Fwd: linux-image-2.6.18-5-amd64 with 32bit userspace: xfs_fsr fails
 because ioctl32(xfs_fsr:15013): Unknown cmd]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I just wanted to let you folks at sgi.com know I've recently sent this 
bug report to the Debian folks about their kernel.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=458467

Sincerely,

Jeffrey Hundstad

-------- Original Message --------
Subject: 	linux-image-2.6.18-5-amd64 with 32bit userspace: xfs_fsr fails 
because ioctl32(xfs_fsr:15013): Unknown cmd
Date: 	Mon, 31 Dec 2007 12:02:31 -0600
From: 	Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
To: 	Debian Bug Tracking System <submit@bugs.debian.org>



Package: linux-image-2.6.18-5-amd64
Version: 2.6.18.dfsg.1-17
Severity: normal

The command xfs_fsr from package (xfsdump) which is used to defragment
xfs filesystems fails to defragment the filesystem.  Instead it errors
with the following message indicating:
ioctl32(xfs_fsr:15013): Unknown cmd fd(3) cmd(c01c5868){00} arg(ffa48c0c) on /

The userspace is 32 bit.


-- System Information:
Debian Release: 4.0
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: i386 (x86_64)
Shell:  /bin/sh linked to /bin/bash
Kernel: Linux 2.6.18-5-amd64
Locale: LANG=C, LC_CTYPE=C (charmap=ANSI_X3.4-1968)

Versions of packages linux-image-2.6.18-5-amd64 depends on:
ii  cor 5.97-5.3                             The GNU core utilities
ii  deb 1.5.11etch1                          Debian configuration management sy
ii  e2f 1.39+1.40-WIP-2006.11.14+dfsg-2etch1 ext2 file system utilities and lib
ii  ini 0.85h                                tools for generating an initramfs
ii  mod 3.3-pre4-2                           tools for managing Linux kernel mo

linux-image-2.6.18-5-amd64 recommends no packages.

-- debconf information:
* linux-image-2.6.18-5-amd64/postinst/create-kimage-link-2.6.18-5-amd64: false
  shared/kernel-image/really-run-bootloader: true
  linux-image-2.6.18-5-amd64/postinst/old-system-map-link-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/preinst/initrd-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/preinst/elilo-initrd-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/postinst/depmod-error-2.6.18-5-amd64: false
  linux-image-2.6.18-5-amd64/preinst/bootloader-initrd-2.6.18-5-amd64: true
* linux-image-2.6.18-5-amd64/preinst/already-running-this-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/prerm/removing-running-kernel-2.6.18-5-amd64: true
* linux-image-2.6.18-5-amd64/preinst/lilo-initrd-2.6.18-5-amd64: false
  linux-image-2.6.18-5-amd64/preinst/abort-overwrite-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/preinst/failed-to-move-modules-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/prerm/would-invalidate-boot-loader-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/postinst/bootloader-error-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/postinst/old-initrd-link-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/preinst/overwriting-modules-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/postinst/old-dir-initrd-link-2.6.18-5-amd64: true
  linux-image-2.6.18-5-amd64/preinst/lilo-has-ramdisk:
  linux-image-2.6.18-5-amd64/postinst/depmod-error-initrd-2.6.18-5-amd64: false
  linux-image-2.6.18-5-amd64/postinst/bootloader-test-error-2.6.18-5-amd64:
  linux-image-2.6.18-5-amd64/postinst/kimage-is-a-directory:
  linux-image-2.6.18-5-amd64/preinst/abort-install-2.6.18-5-amd64:
