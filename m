Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:45:27 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5jNV0008669
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:45:24 -0700
Subject: TAKE 988144 - Account for allocated blocks when expanding directories
Message-Id: <20081015054704.3D60158FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:47:04 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Account for allocated blocks when expanding directories

When we create a directory, we reserve a number of blocks for
the maximum possible expansion of of the directory due to
various btree splits, freespace allocation, etc. Unfortunately,
each allocation is not reflected in the total number of blocks
still available to the transaction, so the maximal reservation
is used over and over again.

This leads to problems where an allocation group has only
enough blocks for *some* of the allocations required for the
directory modification. After the first N allocations, the
remaining blocks in the allocation group drops below the total
reservation, and subsequent allocations fail because the allocator
will not allow the allocation to proceed if the AG does not have
the enough blocks available for the entire allocation total.

This results in an ENOSPC occurring after an allocation has
already occurred. This results in aborting the directory
operation (leaving the directory in an inconsistent state)
and cancelling a dirty transaction, which results in a filesystem
shutdown.

Avoid the problem by reflecting the number of blocks allocated in
any directory expansion in the total number of blocks available to
the modification in progress. This prevents a directory modification
from being aborted part way through with an ENOSPC.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:46:37 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32340a
fs/xfs/xfs_da_btree.c - 1.184 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.184&r2=text&tr2=1.183&f=h
fs/xfs/xfs_dir2.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- Account for allocated blocks when expanding directories
