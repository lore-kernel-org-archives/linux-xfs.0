Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:15:08 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5F6PZ004312
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:15:06 -0700
Subject: TAKE 988142 - Prevent looping in xfs_sync_inodes_ag
Message-Id: <20081015051646.CB89858FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:16:46 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Prevent looping in xfs_sync_inodes_ag

If the last  block of the AG has inodes in it and the AG is an
exactly power-of-2 size then the last inode in the AG points
to the last block in the AG. If we try to find the next inode
in the AG by adding one to the inode number, we increment the
inode number past the size of the AG. The result is that the
macro XFS_INO_TO_AGINO() will strip the AG portion of the inode
number and return an inode number of zero.

That is, instead of terminating the lookup loop because we hit the
inode number went outside the valid range for the AG, the search
index returns to zero and we start traversing the radix tree from
the start again. This results in an endless loop in
xfs_sync_inodes_ag().

Fix it be detecting if the new search index decreases as a result of
incrementing the current inode number. That indicate an overflow and
hence that we have finished processing the AG so we can terminate
the loop.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:16:29 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32335a
fs/xfs/linux-2.6/xfs_sync.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Prevent looping in xfs_sync_inodes_ag
