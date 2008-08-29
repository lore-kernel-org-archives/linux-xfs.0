Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Aug 2008 18:59:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7T1xaxS014632
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 18:59:38 -0700
Subject: TAKE 986238 - Prevent lockdep false positives when locking two inodes.
Message-Id: <20080829020059.16E3F3D642A7@chapter11.melbourne.sgi.com>
Date: Fri, 29 Aug 2008 12:00:59 +1000 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Prevent lockdep false positives when locking two inodes.

If we call xfs_lock_two_inodes() to grab both the iolock and
the ilock, then drop the ilocks on both inodes, then grab
them again (as xfs_swap_extents() does) then lockdep will
report a locking order problem. This is a false positive.

To avoid this, disallow xfs_lock_two_inodes() fom locking both
inode locks at once - force calers to make two separate calls.
This means that nested dropping and regaining of the ilocks
will retain the same lockdep subclass and so lockdep will
not see anything wrong with this code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 29 11:53:42 AEST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/pleckie/2.6.x-xfs
Inspected by:  pleckie,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31999a
fs/xfs/xfs_vnodeops.c - 1.773 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.773&r2=text&tr2=1.772&f=h
	- Prevent lockdep false positives when locking two inodes.

fs/xfs/xfs_dfrag.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- Prevent lockdep false positives when locking two inodes.
