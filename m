Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 02:57:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k969v3aI025887
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 02:57:11 -0700
Received: from puffy.melbourne.sgi.com (puffy.melbourne.sgi.com [134.14.55.166]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA05439 for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 18:55:07 +1000
Subject: TAKE 954482 956881 - copy fix and mkfs/libxfs fix
Message-Id: <20061006084804.033FA11F@puffy.melbourne.sgi.com>
Date: Fri,  6 Oct 2006 18:48:04 +1000 (EST)
From: tes@puffy.melbourne.sgi.com (Timothy Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@puffy.melbourne.sgi.com, xfs@oss.sgi.com

Copy fix.
Fix up variable argument handling around vfprintf's.
Crashing on x86_64 otherwise and is just plain wrong.


Date:  Fri Oct  6 17:36:19 AEST 2006
Workarea:  puffy.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27143a
xfsprogs/copy/xfs_copy.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Fix up variable argument handling around vfprintf's.
	  Crashing on x86_64 otherwise and is just plain wrong.

-----------

Libxfs/mkfs blocksize fix 

Allow the requested sector size to be set for the ioctl setting the
blocksize on the device.

Date:  Fri Oct  6 17:50:50 AEST 2006
Workarea:  puffy.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27144a
xfsprogs/VERSION - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
	- bump

xfsprogs/doc/CHANGES - 1.222 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.222&r2=text&tr2=1.221&f=h
	- Add blocksize libxfs changes and xfs_copy changes for this version.

xfsprogs/mkfs/xfs_mkfs.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- Pass on the mkfs -s option size to libxfs.

xfsprogs/libxfs/init.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- Pass in a given blksize to the platform_set_blocksize() instead of always
	  512 bytes.

xfsprogs/libxfs/init.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Add fatal param to proto.

xfsprogs/libxfs/linux.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/linux.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Change platform_set_blocksize to return an error and
	  to print either an error msg or warning msg depending on fatal param.

xfsprogs/libxfs/darwin.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/darwin.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- handle extra fatal param

xfsprogs/libxfs/irix.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/irix.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Add fatal param to proto.

xfsprogs/libxfs/freebsd.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/freebsd.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- handle extra fatal param
