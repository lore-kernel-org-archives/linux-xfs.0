Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 22:24:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L5NgCm003355
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 22:23:44 -0700
Subject: PARTIAL TAKE 976035 - kill usesless IHOLD calls in xfs_rename
Message-Id: <20080421052419.E52E458C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 15:24:19 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill usesless IHOLD calls in xfs_rename

Similar to to the previous patch for remove and rmdir only grab
a reference to inodes when we join them to transaction to balance the
decrement on transaction completion.  Everything else it taken care of
by the VFS.

Note that the old case had leaks of inode count when src == target or
src or target == one of the parent inodes, but these cases are
fortunately already rejected by the VFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 15:23:49 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30904a
fs/xfs/xfs_rename.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
	- kill usesless IHOLD calls in xfs_rename
