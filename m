Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 03:27:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k96AR5aG029221
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 03:27:07 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA05947 for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 19:22:46 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k969Mj7Y844082
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 19:22:46 +1000 (AEST)
Received: (from tes@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k969Mj9M849212
	for xfs@oss.sgi.com; Fri, 6 Oct 2006 19:22:45 +1000 (AEST)
Date: Fri, 6 Oct 2006 19:22:45 +1000 (AEST)
From: Timothy Shimmin <tes@snort.melbourne.sgi.com>
Message-Id: <200610060922.k969Mj9M849212@snort.melbourne.sgi.com>
Subject: TAKE 954482 956881 - copy fix and mkfs/libxfs fix
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

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
