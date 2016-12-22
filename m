Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966324AbcLVUAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:00:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: fix bogus minleft manipulations
Date: Thu, 22 Dec 2016 21:00:20 +0100
Message-Id: <1482436822-31546-4-git-send-email-hch@lst.de>
In-Reply-To: <1482436822-31546-1-git-send-email-hch@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

We can't just set minleft to 0 when we're low on space - that's exactly
what we need minleft for: to protect space in the AG for btree block
allocations when we are low on free space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c      | 24 +++++++-----------------
 fs/xfs/libxfs/xfs_bmap.c       |  3 ---
 fs/xfs/libxfs/xfs_bmap_btree.c | 14 --------------
 3 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0a46f84..fe92570 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2635,12 +2635,10 @@ xfs_alloc_vextent(
 	xfs_agblock_t	agsize;	/* allocation group size */
 	int		error;
 	int		flags;	/* XFS_ALLOC_FLAG_... locking flags */
-	xfs_extlen_t	minleft;/* minimum left value, temp copy */
 	xfs_mount_t	*mp;	/* mount structure pointer */
 	xfs_agnumber_t	sagno;	/* starting allocation group number */
 	xfs_alloctype_t	type;	/* input allocation type */
 	int		bump_rotor = 0;
-	int		no_min = 0;
 	xfs_agnumber_t	rotorstep = xfs_rotorstep; /* inode32 agf stepper */
 
 	mp = args->mp;
@@ -2669,7 +2667,6 @@ xfs_alloc_vextent(
 		trace_xfs_alloc_vextent_badargs(args);
 		return 0;
 	}
-	minleft = args->minleft;
 
 	switch (type) {
 	case XFS_ALLOCTYPE_THIS_AG:
@@ -2680,9 +2677,7 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
-		args->minleft = 0;
 		error = xfs_alloc_fix_freelist(args, 0);
-		args->minleft = minleft;
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
 			goto error0;
@@ -2747,9 +2742,7 @@ xfs_alloc_vextent(
 		 */
 		for (;;) {
 			args->pag = xfs_perag_get(mp, args->agno);
-			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
-			args->minleft = minleft;
 			if (error) {
 				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
@@ -2789,20 +2782,17 @@ xfs_alloc_vextent(
 			 * or switch to non-trylock mode.
 			 */
 			if (args->agno == sagno) {
-				if (no_min == 1) {
+				if (flags == 0) {
 					args->agbno = NULLAGBLOCK;
 					trace_xfs_alloc_vextent_allfailed(args);
 					break;
 				}
-				if (flags == 0) {
-					no_min = 1;
-				} else {
-					flags = 0;
-					if (type == XFS_ALLOCTYPE_START_BNO) {
-						args->agbno = XFS_FSB_TO_AGBNO(mp,
-							args->fsbno);
-						args->type = XFS_ALLOCTYPE_NEAR_BNO;
-					}
+
+				flags = 0;
+				if (type == XFS_ALLOCTYPE_START_BNO) {
+					args->agbno = XFS_FSB_TO_AGBNO(mp,
+						args->fsbno);
+					args->type = XFS_ALLOCTYPE_NEAR_BNO;
 				}
 			}
 			xfs_perag_put(args->pag);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 19c05e9..62663a2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3812,7 +3812,6 @@ xfs_bmap_btalloc(
 		args.fsbno = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		args.total = ap->minlen;
-		args.minleft = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 		ap->dfops->dop_low = true;
@@ -4344,8 +4343,6 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->dfops->dop_low)
-		bma->minleft = 0;
 	if (bma->cur)
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
 	if (bma->blkno == NULLFSBLOCK)
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d6330c2..9581ee8 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -499,20 +499,6 @@ xfs_bmbt_alloc_block(
 		goto try_another_ag;
 	}
 
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again without minleft and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.minleft = 0;
-		error = xfs_alloc_vextent(&args);
-		if (error)
-			goto error0;
-		cur->bc_private.b.dfops->dop_low = true;
-	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
-- 
2.1.4

