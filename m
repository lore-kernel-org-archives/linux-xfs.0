Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935609AbeF1Qgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E98804078BA0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3CAB111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 19/24] xfs: remove xfs_btree_cur bmbt dfops field
Date: Thu, 28 Jun 2018 12:36:31 -0400
Message-Id: <20180628163636.52564-20-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All assignments of xfs_btree_cur.bc_private.b.dfops originate from
->t_dfops. Replace accesses of the former with the latter and remove
the unnecessary field. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 12 +-----------
 fs/xfs/libxfs/xfs_bmap_btree.c |  9 +++------
 fs/xfs/libxfs/xfs_btree.h      |  1 -
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 710e7d0bbf6a..6b749c1f5c4e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -624,7 +624,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo);
+	xfs_bmap_add_free(mp, cur->bc_tp->t_dfops, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -690,7 +690,6 @@ xfs_bmap_extents_to_btree(
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
-	cur->bc_private.b.dfops = tp->t_dfops;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
@@ -929,7 +928,6 @@ xfs_bmap_add_attrfork_btree(
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
-		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.firstblock = *firstblock;
 		error = xfs_bmbt_lookup_first(cur, &stat);
 		if (error)
@@ -4082,7 +4080,6 @@ xfs_bmapi_allocate(
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.dfops = bma->tp->t_dfops;
 	}
 	/*
 	 * Bump the number of extents we've allocated
@@ -4170,7 +4167,6 @@ xfs_bmapi_convert_unwritten(
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.dfops = bma->tp->t_dfops;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
@@ -4560,7 +4556,6 @@ xfs_bmapi_remap(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = firstblock;
-		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5151,7 +5146,6 @@ __xfs_bunmapi(
 	xfs_fsblock_t		*firstblock)	/* first allocated block
 						   controls a.g. for allocs */
 {
-	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
 	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	struct xfs_bmbt_irec	del;		/* extent being deleted */
 	int			error;		/* error return value */
@@ -5225,7 +5219,6 @@ __xfs_bunmapi(
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
 	} else
 		cur = NULL;
@@ -5715,7 +5708,6 @@ xfs_bmap_collapse_extents(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5837,7 +5829,6 @@ xfs_bmap_insert_extents(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5961,7 +5952,6 @@ xfs_bmap_split_extent_at(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstfsb;
-		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e1a2d9ceb615..e8b01af09db5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -176,7 +176,6 @@ xfs_bmbt_dup_cursor(
 	 * since init cursor doesn't get them.
 	 */
 	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
-	new->bc_private.b.dfops = cur->bc_private.b.dfops;
 	new->bc_private.b.flags = cur->bc_private.b.flags;
 
 	return new;
@@ -189,7 +188,6 @@ xfs_bmbt_update_cursor(
 {
 	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
 	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
-	ASSERT(dst->bc_private.b.dfops == src->bc_private.b.dfops);
 
 	dst->bc_private.b.allocated += src->bc_private.b.allocated;
 	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
@@ -230,7 +228,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-	} else if (cur->bc_private.b.dfops->dop_low) {
+	} else if (cur->bc_tp->t_dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -257,7 +255,7 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
-		cur->bc_private.b.dfops->dop_low = true;
+		cur->bc_tp->t_dfops->dop_low = true;
 	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		*stat = 0;
@@ -293,7 +291,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
+	xfs_bmap_add_free(mp, cur->bc_tp->t_dfops, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -565,7 +563,6 @@ xfs_bmbt_init_cursor(
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
 	cur->bc_private.b.firstblock = NULLFSBLOCK;
-	cur->bc_private.b.dfops = NULL;
 	cur->bc_private.b.allocated = 0;
 	cur->bc_private.b.flags = 0;
 	cur->bc_private.b.whichfork = whichfork;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0a4fdf7f11a7..cc94ac765dec 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -215,7 +215,6 @@ typedef struct xfs_btree_cur
 		} a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
-			struct xfs_defer_ops *dfops;	/* deferred updates */
 			xfs_fsblock_t	firstblock;	/* 1st blk allocated */
 			int		allocated;	/* count of alloced */
 			short		forksize;	/* fork's inode space */
-- 
2.17.1

