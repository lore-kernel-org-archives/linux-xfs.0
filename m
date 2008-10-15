Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:10:30 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5AOsA002687
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:10:24 -0700
Subject: TAKE 988142 - rename inode reclaim functions
Message-Id: <20081015051159.902A958FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:11:59 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

rename inode reclaim functions

The function names xfs_finish_reclaim and xfs_finish_reclaim_all
are not very descriptive of what they are reclaiming. Rename to
xfs_reclaim_inode[s] to match the xfs_sync_inodes() function.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:11:42 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32330a
fs/xfs/xfs_vnodeops.c - 1.779 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.779&r2=text&tr2=1.778&f=h
fs/xfs/xfs_mount.c - 1.450 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.450&r2=text&tr2=1.449&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- rename inode reclaim functions
