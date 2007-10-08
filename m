Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 23:43:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l986hB48025626
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 23:43:13 -0700
Subject: PARTIAL TAKE 971186 - fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
Message-Id: <20071008064308.B7D9958C38F1@chook.melbourne.sgi.com>
Date: Mon,  8 Oct 2007 16:43:08 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION

XFS_IOC_GETVERSION, XFS_IOC_GETXFLAGS and XFS_IOC_SETXFLAGS all
take a "long" which changes size between 32 and 64 bit platforms.

So, the ioctl cmds that come in from a 32-bit app aren't as expected, 
for example on GETXFLAGS,

        unknown cmd fd(3) cmd(80046601){t:'f';sz:4}

due to the size mismatch.

So, use instead the 32-bit version of the commands for compat ioctls,
and other than that it doesn't take any more manipulation.

Also, for both native and compat versions, just define them to
the values as defined in fs.h

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Mon Oct  8 16:42:26 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29849a
fs/xfs/xfs_fs.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
fs/xfs/linux-2.6/xfs_ioctl32.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
