Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 00:19:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J7JbnW001630
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 00:19:38 -0700
Subject: PARTIAL TAKE 981498 - merge xfs_mntupdate into xfs_fs_remount
Message-Id: <20080519072021.2085558C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 17:20:21 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

merge xfs_mntupdate into xfs_fs_remount

xfs_mntupdate already is completely Linux specific due to the VFS flags
passed in, so it might aswell be merged into xfs_fs_remount.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon May 19 17:19:59 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31185a
fs/xfs/xfs_vfsops.c - 1.565 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.565&r2=text&tr2=1.564&f=h
	- merge xfs_mntupdate into xfs_fs_remount.

fs/xfs/linux-2.6/xfs_super.c - 1.418 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.418&r2=text&tr2=1.417&f=h
	- merge xfs_mntupdate into xfs_fs_remount.

fs/xfs/xfs_vfsops.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- merge xfs_mntupdate into xfs_fs_remount.
