Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67CC681BB
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:50:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5655AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ki1OwKT8Unoj9IzV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:33 -0700 (PDT)
Subject: [PATCH 36/71] xfs: try other AGs to allocate a BMBT block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:50:26 -0700
Message-ID: <147216902624.4420.1687447903576954909.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Prior to the introduction of reflink, allocating a block and mapping
it into a file was performed in a single transaction with a single
block reservation, and the allocator was supposed to find enough
blocks to allocate the extent and any BMBT blocks that might be
necessary (unless we're low on space).

However, due to the way copy on write works, allocation and mapping
have been split into two transactions, which means that we must be
able to handle the case where we allocate an extent for CoW but that
AG runs out of free space before the blocks can be mapped into a file,
and the mapping requires a new BMBT block.  When this happens, look in
one of the other AGs for a BMBT block instead of taking the FS down.

The same applies to the functions that convert a data fork to extents
and later btree format.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c       |   30 ++++++++++++++++++++++++++++++
 libxfs/xfs_bmap_btree.c |   17 +++++++++++++++++
 2 files changed, 47 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 875a15f..4721cff 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -745,6 +745,7 @@ xfs_bmap_extents_to_btree(
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	} else if (dfops->dop_low) {
+try_another_ag:
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = *firstblock;
 	} else {
@@ -759,6 +760,21 @@ xfs_bmap_extents_to_btree(
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return error;
 	}
+
+	/*
+	 * During a CoW operation, the allocation and bmbt updates occur in
+	 * different transactions.  The mapping code tries to put new bmbt
+	 * blocks near extents being mapped, but the only way to guarantee this
+	 * is if the alloc and the mapping happen in a single transaction that
+	 * has a block reservation.  That isn't the case here, so if we run out
+	 * of space we'll try again with another AG.
+	 */
+	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
+	    args.fsbno == NULLFSBLOCK &&
+	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
+		dfops->dop_low = true;
+		goto try_another_ag;
+	}
 	/*
 	 * Allocation can't fail, the space was reserved.
 	 */
@@ -894,6 +910,7 @@ xfs_bmap_local_to_extents(
 	 * file currently fits in an inode.
 	 */
 	if (*firstblock == NULLFSBLOCK) {
+try_another_ag:
 		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -906,6 +923,19 @@ xfs_bmap_local_to_extents(
 	if (error)
 		goto done;
 
+	/*
+	 * During a CoW operation, the allocation and bmbt updates occur in
+	 * different transactions.  The mapping code tries to put new bmbt
+	 * blocks near extents being mapped, but the only way to guarantee this
+	 * is if the alloc and the mapping happen in a single transaction that
+	 * has a block reservation.  That isn't the case here, so if we run out
+	 * of space we'll try again with another AG.
+	 */
+	if (xfs_sb_version_hasreflink(&ip->i_mount->m_sb) &&
+	    args.fsbno == NULLFSBLOCK &&
+	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
+		goto try_another_ag;
+	}
 	/* Can't fail, the space was reserved. */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 3d1a02e..601385d 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -450,6 +450,7 @@ xfs_bmbt_alloc_block(
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
+try_another_ag:
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		/*
 		 * Make sure there is sufficient room left in the AG to
@@ -479,6 +480,22 @@ xfs_bmbt_alloc_block(
 	if (error)
 		goto error0;
 
+	/*
+	 * During a CoW operation, the allocation and bmbt updates occur in
+	 * different transactions.  The mapping code tries to put new bmbt
+	 * blocks near extents being mapped, but the only way to guarantee this
+	 * is if the alloc and the mapping happen in a single transaction that
+	 * has a block reservation.  That isn't the case here, so if we run out
+	 * of space we'll try again with another AG.
+	 */
+	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
+	    args.fsbno == NULLFSBLOCK &&
+	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
+		cur->bc_private.b.dfops->dop_low = true;
+		args.fsbno = cur->bc_private.b.firstblock;
+		goto try_another_ag;
+	}
+
 	if (args.fsbno == NULLFSBLOCK && args.minleft) {
 		/*
 		 * Could not find an AG with enough free space to satisfy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
