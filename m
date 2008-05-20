Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:24:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1NrDf031180
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:23:56 -0700
Subject: PARTIAL TAKE 981951 - sort out opening and closing of the block devices
Message-Id: <20080520012439.28F6558C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:24:39 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

sort out opening and closing of the block devices

Currently closing the rt/log block device is done in the wrong spot, and
far too early.  So revampt it:

 - xfs_blkdev_put moved out of xfs_free_buftarg into the caller so that
   it is done after tearing down the buftarg completely.
 - call to xfs_unmountfs_close moved from xfs_mountfs into caller so
   that it's done after tearing down the filesystem completely.
 - xfs_unmountfs_close is renamed to xfs_close_devices and made static
   in xfs_super.c
 - opening of the block devices is split into a helper xfs_open_devices
   that is symetric in use to xfs_close_devices
 - xfs_unmountfs can now lose struct cred
 - error handling around device opening sanitized in xfs_fs_fill_super


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue May 20 11:24:15 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31193a
fs/xfs/xfs_mount.h - 1.267 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.267&r2=text&tr2=1.266&f=h
	- sort out opening and closing of the block devices

fs/xfs/xfs_mount.c - 1.435 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.435&r2=text&tr2=1.434&f=h
	- sort out opening and closing of the block devices

fs/xfs/linux-2.6/xfs_super.h - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- sort out opening and closing of the block devices

fs/xfs/linux-2.6/xfs_super.c - 1.421 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.421&r2=text&tr2=1.420&f=h
	- sort out opening and closing of the block devices

fs/xfs/linux-2.6/xfs_buf.h - 1.126 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.126&r2=text&tr2=1.125&f=h
	- sort out opening and closing of the block devices

fs/xfs/linux-2.6/xfs_buf.c - 1.257 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.257&r2=text&tr2=1.256&f=h
	- sort out opening and closing of the block devices
