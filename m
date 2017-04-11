Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdDKLKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:10:41 -0400
Received: from 212095007090.public.telering.at ([212.95.7.90] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxth2-0004pi-EL
        for linux-xfs@vger.kernel.org; Tue, 11 Apr 2017 11:10:41 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] xfs: remove bmap block allocation retries
Date: Tue, 11 Apr 2017 13:10:11 +0200
Message-Id: <20170411111011.9437-7-hch@lst.de>
In-Reply-To: <20170411111011.9437-1-hch@lst.de>
References: <20170411111011.9437-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that reflink operations don't set the firstblock value we don't
need the workarounds for non-NULL firstblock values without a prior
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 29 -----------------------------
 fs/xfs/libxfs/xfs_bmap_btree.c | 17 -----------------
 2 files changed, 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 414cfa91af01..cc9feb2f5731 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -764,7 +764,6 @@ xfs_bmap_extents_to_btree(
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	} else if (dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
-try_another_ag:
 		args.fsbno = *firstblock;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -779,20 +778,6 @@ xfs_bmap_extents_to_btree(
 		return error;
 	}
 
-	/*
-	 * During a CoW operation, the allocation and bmbt updates occur in
-	 * different transactions.  The mapping code tries to put new bmbt
-	 * blocks near extents being mapped, but the only way to guarantee this
-	 * is if the alloc and the mapping happen in a single transaction that
-	 * has a block reservation.  That isn't the case here, so if we run out
-	 * of space we'll try again with another AG.
-	 */
-	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
-	    args.fsbno == NULLFSBLOCK &&
-	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		goto try_another_ag;
-	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		xfs_iroot_realloc(ip, -1, whichfork);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
@@ -925,7 +910,6 @@ xfs_bmap_local_to_extents(
 	 * file currently fits in an inode.
 	 */
 	if (*firstblock == NULLFSBLOCK) {
-try_another_ag:
 		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -938,19 +922,6 @@ xfs_bmap_local_to_extents(
 	if (error)
 		goto done;
 
-	/*
-	 * During a CoW operation, the allocation and bmbt updates occur in
-	 * different transactions.  The mapping code tries to put new bmbt
-	 * blocks near extents being mapped, but the only way to guarantee this
-	 * is if the alloc and the mapping happen in a single transaction that
-	 * has a block reservation.  That isn't the case here, so if we run out
-	 * of space we'll try again with another AG.
-	 */
-	if (xfs_sb_version_hasreflink(&ip->i_mount->m_sb) &&
-	    args.fsbno == NULLFSBLOCK &&
-	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
-		goto try_another_ag;
-	}
 	/* Can't fail, the space was reserved. */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fd55db479385..3e17ceda038c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -448,7 +448,6 @@ xfs_bmbt_alloc_block(
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
 		args.type = XFS_ALLOCTYPE_START_BNO;
-try_another_ag:
 		/*
 		 * Make sure there is sufficient room left in the AG to
 		 * complete a full tree split for an extent insert.  If
@@ -477,22 +476,6 @@ xfs_bmbt_alloc_block(
 	if (error)
 		goto error0;
 
-	/*
-	 * During a CoW operation, the allocation and bmbt updates occur in
-	 * different transactions.  The mapping code tries to put new bmbt
-	 * blocks near extents being mapped, but the only way to guarantee this
-	 * is if the alloc and the mapping happen in a single transaction that
-	 * has a block reservation.  That isn't the case here, so if we run out
-	 * of space we'll try again with another AG.
-	 */
-	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
-	    args.fsbno == NULLFSBLOCK &&
-	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
-		args.fsbno = cur->bc_private.b.firstblock;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		goto try_another_ag;
-	}
-
 	if (args.fsbno == NULLFSBLOCK && args.minleft) {
 		/*
 		 * Could not find an AG with enough free space to satisfy
-- 
2.11.0

