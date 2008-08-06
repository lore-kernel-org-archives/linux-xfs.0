Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:31:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765VI9U010699
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:31:19 -0700
Subject: TAKE 981498 - don't call xfs_freesb from xfs_unmountfs
Message-Id: <20080806053230.7444A58C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:32:30 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

don't call xfs_freesb from xfs_unmountfs

xfs_readsb is called before xfs_mount so xfs_freesb should be called
after xfs_unmountfs, too.  This means it now happens after a few things
during the of xfs_unmount which all have nothing to do with the
superblock.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Aug  6 15:31:50 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31835a
fs/xfs/xfs_mount.c - 1.443 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.443&r2=text&tr2=1.442&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.446 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.446&r2=text&tr2=1.445&f=h
	- don't call xfs_freesb from xfs_unmountfs
