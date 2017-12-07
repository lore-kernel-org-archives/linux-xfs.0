Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752522AbdLGS6L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 13:58:11 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD2DFC0587FC
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F1457849F
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 3/4] xfs: defer agfl block frees on extent frees
Date: Thu,  7 Dec 2017 13:58:09 -0500
Message-Id: <20171207185810.48757-4-bfoster@redhat.com>
In-Reply-To: <20171207185810.48757-1-bfoster@redhat.com>
References: <20171207185810.48757-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Defer AGFL block frees from deferred extent free context. This means
that extents that are deferred freed via xfs_bmap_add_free() will
add additional deferred items for AGFL block frees during completion
processing. All such items complete before xfs_defer_finish()
returns.

Update xfs_trans_free_extent() and xfs_free_extent() to receive an
optional dfops pointer and pass it down to the AGFL fixup code via
the allocation arguments structure. Update
xfs_extent_free_finish_item() to pass along the dfops list currently
being processed by xfs_defer_finish(). All other callers pass a NULL
dfops and so do not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 9 ++++++---
 fs/xfs/libxfs/xfs_alloc.h          | 5 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
 fs/xfs/libxfs/xfs_rmap.c           | 2 +-
 fs/xfs/xfs_extfree_item.c          | 2 +-
 fs/xfs/xfs_fsops.c                 | 2 +-
 fs/xfs/xfs_trans.h                 | 3 ++-
 fs/xfs/xfs_trans_extfree.c         | 7 ++++---
 9 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ab636181471c..eafcef839526 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2857,7 +2857,8 @@ int
 xfs_free_extent_fix_freelist(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
-	struct xfs_buf		**agbp)
+	struct xfs_buf		**agbp,
+	struct xfs_defer_ops	*dfops)
 {
 	struct xfs_alloc_arg	args;
 	int			error;
@@ -2866,6 +2867,7 @@ xfs_free_extent_fix_freelist(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.agno = agno;
+	args.dfops = dfops;
 
 	/*
 	 * validate that the block number is legal - the enables us to detect
@@ -2898,7 +2900,8 @@ xfs_free_extent(
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	struct xfs_owner_info	*oinfo,	/* extent owner */
-	enum xfs_ag_resv_type	type)	/* block reservation type */
+	enum xfs_ag_resv_type	type,	/* block reservation type */
+	struct xfs_defer_ops	*dfops)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
@@ -2913,7 +2916,7 @@ xfs_free_extent(
 			XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
-	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+	error = xfs_free_extent_fix_freelist(tp, agno, &agbp, dfops);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 559568806265..17fc0265fbfa 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -196,7 +196,8 @@ xfs_free_extent(
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	struct xfs_owner_info	*oinfo,	/* extent owner */
-	enum xfs_ag_resv_type	type);	/* block reservation type */
+	enum xfs_ag_resv_type	type,	/* block reservation type */
+	struct xfs_defer_ops	*dfops);/* dfops for agfl frees */
 
 int				/* error */
 xfs_alloc_lookup_ge(
@@ -220,7 +221,7 @@ int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
-		struct xfs_buf **agbp);
+		struct xfs_buf **agbp, struct xfs_defer_ops *);
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 317caba9faa6..b899f02e5c5e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -155,7 +155,7 @@ xfs_inobt_free_block(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
-			&oinfo, XFS_AG_RESV_NONE);
+			&oinfo, XFS_AG_RESV_NONE, NULL);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 3c59dd3d58d7..0f1ff83d0fb8 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -136,7 +136,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_METADATA);
+			XFS_AG_RESV_METADATA, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index dd019cee1b3b..439f90d70850 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2107,7 +2107,7 @@ xfs_rmap_finish_one(
 		 * rmapbt, because a shape change could cause us to
 		 * allocate blocks.
 		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+		error = xfs_free_extent_fix_freelist(tp, agno, &agbp, NULL);
 		if (error)
 			return error;
 		if (!agbp)
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 44f8c5451210..100dce7f6f17 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -542,7 +542,7 @@ xfs_efi_recover(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &efip->efi_format.efi_extents[i];
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len, &oinfo);
+					      extp->ext_len, &oinfo, NULL);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8f22fc579dbb..c50ecf684938 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -574,7 +574,7 @@ xfs_growfs_data_private(
 		error = xfs_free_extent(tp,
 				XFS_AGB_TO_FSB(mp, agno,
 					be32_to_cpu(agf->agf_length) - new),
-				new, &oinfo, XFS_AG_RESV_NONE);
+				new, &oinfo, XFS_AG_RESV_NONE, NULL);
 		if (error)
 			goto error0;
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 815b53d20e26..88c5357d558c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -228,7 +228,8 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t, struct xfs_owner_info *);
+				      xfs_extlen_t, struct xfs_owner_info *,
+				      struct xfs_defer_ops *);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index f5620796ae25..04cd3f7e3c02 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -68,7 +68,8 @@ xfs_trans_free_extent(
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
 	xfs_extlen_t		ext_len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_owner_info	*oinfo,
+	struct xfs_defer_ops	*dfops)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	uint			next_extent;
@@ -80,7 +81,7 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
 
 	error = xfs_free_extent(tp, start_block, ext_len, oinfo,
-			XFS_AG_RESV_NONE);
+			XFS_AG_RESV_NONE, dfops);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -195,7 +196,7 @@ xfs_extent_free_finish_item(
 	error = xfs_trans_free_extent(tp, done_item,
 			free->xefi_startblock,
 			free->xefi_blockcount,
-			&free->xefi_oinfo);
+			&free->xefi_oinfo, dop);
 	kmem_free(free);
 	return error;
 }
-- 
2.13.6

