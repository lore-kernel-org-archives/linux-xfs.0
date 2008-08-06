Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:10:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765AJkL006976
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:10:20 -0700
Subject: TAKE 981498 - move root inode IRELE into xfs_unmountfs
Message-Id: <20080806051132.0E58A58C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:11:32 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move root inode IRELE into xfs_unmountfs

The root inode is allocated in xfs_mountfs so it should be release in
xfs_unmountfs.  For the unmount case that means we do it after the
the xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE) in the forced shutdown case
and the dmapi unmount event.  Note that both reference the rip variable
which might be freed by that time in case inode flushing has kicked in,
so strictly speaking this might count as a bug fix


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 15:10:49 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31830a
fs/xfs/xfs_mount.c - 1.440 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.440&r2=text&tr2=1.439&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.444 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.444&r2=text&tr2=1.443&f=h
	- move root inode IRELE into xfs_unmountfs
