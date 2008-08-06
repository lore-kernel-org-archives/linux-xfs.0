Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:45:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m764jVsK022249
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:45:32 -0700
Subject: TAKE 981498 - update timestamp in xfs_ialloc manually
Message-Id: <20080806044643.6DC7858C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 14:46:43 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

update timestamp in xfs_ialloc manually

In xfs_ialloc we just want to set all timestamps to the current time.
We don't need to mark the inode dirty like xfs_ichgtime does, and we
don't need nor want the opimizations in xfs_ichgtime that I will
introduce in the next patch.

So just opencode the timestamp update in xfs_ialloc, and remove the new
unused XFS_ICHGTIME_ACC case in xfs_ichgtime.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 14:44:59 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31825a
fs/xfs/xfs_vnodeops.c - 1.772 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.772&r2=text&tr2=1.771&f=h
fs/xfs/xfs_inode.c - 1.517 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.517&r2=text&tr2=1.516&f=h
fs/xfs/xfs_inode.h - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.297 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.297&r2=text&tr2=1.296&f=h
	- update timestamp in xfs_ialloc manually
