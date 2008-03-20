Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 22:20:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K5KXHA025670
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 22:20:35 -0700
Date: Thu, 20 Mar 2008 16:21:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2/2] Prevent shutdown on inode allocation failure
Message-ID: <20080320052100.GA95344431@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

At ENOSPC, we can get a filesystem shutdown due to a cancelling a
dirty transaction in xfs_mkdir or xfs_create. This is due to the
initial allocation attempt not taking into inode alignment and hence
we can prepare the AGF freelist for allocation when it's not actually
possible to do an allocation. This results in inode allocation returning
ENOSPC with a dirty transaction, and hence we shut down the filesystem.

Because the first allocation is an exact allocation attempt, we must tell
the allocator that the alignment does not affect the allocation attempt.
i.e. we will accept any extent alignment as long as the extent starts
at the block we want. Unfortunately, this means that if the longest
free extent is less than the length + alignment necessary for fallback
allocation attempts but is long enough to attempt a non-aligned allocation,
we will modify the free list.

If we then have the exact allocation fail, all other allocation attempts
will also fail due to the alignment constraint being taken into account.
Hence the initial attempt needs to set the "alignment slop" field so
that alignment, while not required, must be taken into account when
determining if there is enough space left in the AG to do the allocation.

That means if the exact allocation fails, we will not dirty the freelist
if there is not enough space available fo a subsequent allocation to
succeed. Hence we get an ENOSPC error back to userspace without shutting
down the filesystem.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_ialloc.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-03-14 09:28:15.998038053 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-03-14 09:33:42.000000000 +1100
@@ -177,10 +177,24 @@ xfs_ialloc_ag_alloc(
 		args.mod = args.total = args.wasdel = args.isfl =
 			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
-		args.alignment = 1;
+
 		/*
-		 * Allow space for the inode btree to split.
+		 * We need to take into account alignment here to ensure that
+		 * we don't modify the free list if we fail to have an exact
+		 * block. If we don't have an exact match, and every oher
+		 * attempt allocation attempt fails, we'll end up cancelling
+		 * a dirty transaction and shutting down.
+		 *
+		 * For an exact allocation, alignment must be 1,
+		 * however we need to take cluster alignment into account when
+		 * fixing up the freelist. Use the minalignslop field to
+		 * indicate that extra blocks might be required for alignment,
+		 * but not to use them in the actual exact allocation.
 		 */
+		args.alignment = 1;
+		args.minalignslop = xfs_ialloc_cluster_alignment(&args) - 1;
+
+		/* Allow space for the inode btree to split. */
 		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
