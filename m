Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeEOWeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:34:08 -0400
Subject: [PATCH 04/22] xfs: add helpers to dispose of old btree blocks after
 a repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:34:04 -0700
Message-ID: <152642364418.1556.17533271717583168316.stgit@magnolia>
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've plumbed in the ability to construct a list of dead btree
blocks following a repair, add more helpers to dispose of them.  This is
done by examining the rmapbt -- if the btree was the only owner we can
free the block, otherwise it's crosslinked and we can only remove the
rmapbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    3 +
 2 files changed, 202 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 8e8ecddd7537..d820e01d1146 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -362,6 +362,173 @@ xfs_repair_init_btblock(
 	return 0;
 }
 
+/* Ensure the freelist is the correct size. */
+int
+xfs_repair_fix_freelist(
+	struct xfs_scrub_context	*sc,
+	bool				can_shrink)
+{
+	struct xfs_alloc_arg		args = {0};
+	int				error;
+
+	args.mp = sc->mp;
+	args.tp = sc->tp;
+	args.agno = sc->sa.agno;
+	args.alignment = 1;
+	args.pag = xfs_perag_get(args.mp, sc->sa.agno);
+
+	error = xfs_alloc_fix_freelist(&args,
+			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	xfs_perag_put(args.pag);
+
+	return error;
+}
+
+/*
+ * Put a block back on the AGFL.
+ */
+STATIC int
+xfs_repair_put_freelist(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_perag		*pag;
+	int				error;
+
+	/* Make sure there's space on the freelist. */
+	error = xfs_repair_fix_freelist(sc, true);
+	if (error)
+		return error;
+	pag = xfs_perag_get(sc->mp, sc->sa.agno);
+	if (pag->pagf_flcount == 0) {
+		xfs_perag_put(pag);
+		return -EFSCORRUPTED;
+	}
+	xfs_perag_put(pag);
+
+	/*
+	 * Since we're "freeing" a lost block onto the AGFL, we have to
+	 * create an rmap for the block prior to merging it or else other
+	 * parts will break.
+	 */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
+			&oinfo);
+	if (error)
+		return error;
+
+	/* Put the block on the AGFL. */
+	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
+			agbno, 0);
+	if (error)
+		return error;
+	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
+			XFS_EXTENT_BUSY_SKIP_DISCARD);
+
+	return 0;
+}
+
+/* Dispose of a single metadata block. */
+STATIC int
+xfs_repair_dispose_btree_block(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	bool				has_other_rmap;
+	int				error;
+
+	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+
+	if (sc->ip) {
+		/* Repairing per-inode metadata, read in the AGF. */
+		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			return error;
+		if (!agf_bp)
+			return -ENOMEM;
+	} else {
+		/* Repairing per-AG btree, reuse existing AGF buffer. */
+		agf_bp = sc->sa.agf_bp;
+	}
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
+
+	/* Can we find any other rmappings? */
+	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
+	if (error)
+		goto out_cur;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/*
+	 * If there are other rmappings, this block is cross linked and must
+	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
+	 * we were the only owner of the block, so free the extent, which will
+	 * also remove the rmap.
+	 */
+	if (has_other_rmap)
+		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
+	else if (resv == XFS_AG_RESV_AGFL)
+		error = xfs_repair_put_freelist(sc, agbno);
+	else
+		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+	if (agf_bp != sc->sa.agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	if (error)
+		return error;
+
+	if (sc->ip)
+		return xfs_trans_roll_inode(&sc->tp, sc->ip);
+	return xfs_repair_roll_ag_trans(sc);
+
+out_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	if (agf_bp != sc->sa.agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/*
+ * Dispose of a given metadata extent.
+ *
+ * If the rmapbt says the extent has multiple owners, we simply remove the
+ * rmap associated with this owner hoping that we'll eventually disentangle
+ * the crosslinked metadata.  Otherwise, there's one owner, so call the
+ * regular free code to remove the rmap and free the extent.  Any existing
+ * buffers for the blocks in the extent must have been _binval'd previously.
+ */
+STATIC int
+xfs_repair_dispose_btree_extent(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error = 0;
+
+	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
+	ASSERT(sc->ip != NULL || XFS_FSB_TO_AGNO(mp, fsbno) == sc->sa.agno);
+
+	trace_xfs_repair_dispose_btree_extent(mp, XFS_FSB_TO_AGNO(mp, fsbno),
+			XFS_FSB_TO_AGBNO(mp, fsbno), len);
+
+	for (; len > 0; len--, fsbno++) {
+		error = xfs_repair_dispose_btree_block(sc, fsbno, oinfo, resv);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Collect a dead btree extent for later disposal. */
 int
 xfs_repair_collect_btree_extent(
@@ -404,7 +571,9 @@ xfs_repair_reap_btree_extents(
 	int				error = 0;
 
 	for_each_xfs_repair_extent_safe(rex, n, exlist) {
-		/* TODO: free the extent */
+		if (!error)
+			error = xfs_repair_dispose_btree_extent(sc, rex->fsbno,
+					rex->len, oinfo, type);
 		list_del(&rex->list);
 		kmem_free(rex);
 	}
@@ -568,3 +737,32 @@ xfs_repair_subtract_extents(
 }
 #undef XFS_REPAIR_EXT_LEFT_CONTIG
 #undef XFS_REPAIR_EXT_RIGHT_CONTIG
+
+/*
+ * Invalidate buffers for per-AG btree blocks we're dumping.  We assume that
+ * exlist points only to metadata blocks.
+ */
+int
+xfs_repair_invalidate_blocks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist)
+{
+	struct xfs_repair_extent	*rex;
+	struct xfs_repair_extent	*n;
+	struct xfs_buf			*bp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			i;
+
+	for_each_xfs_repair_extent_safe(rex, n, exlist) {
+		agno = XFS_FSB_TO_AGNO(sc->mp, rex->fsbno);
+		agbno = XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno);
+		for (i = 0; i < rex->len; i++) {
+			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
+					agbno + i, 0);
+			xfs_trans_binval(sc->tp, bp);
+		}
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index b288201030f8..e0e7f86d509c 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -73,6 +73,9 @@ void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
 int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
 		struct xfs_repair_extent_list *exlist,
 		struct xfs_repair_extent_list *sublist);
+int xfs_repair_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
+int xfs_repair_invalidate_blocks(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
 
 /* Metadata repairers */
 

