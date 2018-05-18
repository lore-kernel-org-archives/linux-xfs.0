Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbeERDxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:53:52 -0400
Date: Thu, 17 May 2018 20:53:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180518035347.GA23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642364418.1556.17533271717583168316.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've plumbed in the ability to construct a list of dead btree
blocks following a repair, add more helpers to dispose of them.  This is
done by examining the rmapbt -- if the btree was the only owner we can
free the block, otherwise it's crosslinked and we can only remove the
rmapbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: document the design of how old btree block disposal is supposed to
    work and document some of the limitations of the buffer cache that
    we can't fix here, and reduce perag_get/put traffic
---
 fs/xfs/scrub/repair.c |  251 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    6 +
 2 files changed, 257 insertions(+)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index fca8e3c7887d..7daf0120d1bf 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -585,3 +585,254 @@ xfs_repair_subtract_extents(
 }
 #undef LEFT_ALIGNED
 #undef RIGHT_ALIGNED
+
+/*
+ * Disposal of Blocks from Old per-AG Btrees
+ *
+ * Now that we've constructed a new btree to replace the damaged one, we want
+ * to dispose of the blocks that (we think) the old btree was using.
+ * Previously, we used the rmapbt to collect the extents (exlist) with the
+ * rmap owner corresponding to the tree we rebuilt, collected extents for any
+ * blocks with the same rmap owner that are owned by another data structure
+ * (sublist), and subtracted sublist from exlist.  In theory the extents
+ * remaining in exlist are the old btree's blocks.
+ *
+ * Unfortunately, it's possible that the btree was crosslinked with other
+ * blocks on disk.  The rmap data can tell us if there are multiple owners, so
+ * if the rmapbt says there is an owner of this block other than @oinfo, then
+ * the block is crosslinked.  Remove the reverse mapping and continue.
+ *
+ * If there is one rmap record, we can free the block, which removes the
+ * reverse mapping but doesn't add the block to the free space.  Our repair
+ * strategy is to hope the other metadata objects crosslinked on this block
+ * will be rebuilt (atop different blocks), thereby removing all the cross
+ * links.
+ *
+ * If there are no rmap records at all, we also free the block.  If the btree
+ * being rebuilt lives in the free space (bnobt/cntbt/rmapbt) then there isn't
+ * supposed to be a rmap record and everything is ok.  For other btrees there
+ * had to have been an rmap entry for the block to have ended up on @exlist,
+ * so if it's gone now there's something wrong and the fs will shut down.
+ *
+ * Note: If there are multiple rmap records with only the same rmap owner as
+ * the btree we're trying to rebuild and the block is indeed owned by another
+ * data structure with the same rmap owner, then the block will be in sublist
+ * and therefore doesn't need disposal.  If there are multiple rmap records
+ * with only the same rmap owner but the block is not owned by something with
+ * the same rmap owner, the block will be freed.
+ *
+ * The caller is responsible for locking the AG headers for the entire rebuild
+ * operation so that nothing else can sneak in and change the AG state while
+ * we're not looking.  We also assume that the caller already invalidated any
+ * buffers associated with @exlist.
+ */
+
+/*
+ * Invalidate buffers for per-AG btree blocks we're dumping.  This function
+ * is not intended for use with file data repairs; we have bunmapi for that.
+ */
+int
+xfs_repair_invalidate_blocks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist)
+{
+	struct xfs_repair_extent	*rex;
+	struct xfs_repair_extent	*n;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsbno;
+	xfs_agblock_t			i;
+
+	/*
+	 * For each block in each extent, see if there's an incore buffer for
+	 * exactly that block; if so, invalidate it.  The buffer cache only
+	 * lets us look for one buffer at a time, so we have to look one block
+	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
+	 * because we never own those; and if we can't TRYLOCK the buffer we
+	 * assume it's owned by someone else.
+	 */
+	for_each_xfs_repair_extent_safe(rex, n, exlist) {
+		for (fsbno = rex->fsbno, i = rex->len; i > 0; fsbno++, i--) {
+			/* Skip AG headers and post-EOFS blocks */
+			if (!xfs_verify_fsbno(sc->mp, fsbno))
+				continue;
+			bp = xfs_buf_incore(sc->mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(sc->mp, fsbno),
+					XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
+			if (bp) {
+				xfs_trans_bjoin(sc->tp, bp);
+				xfs_trans_binval(sc->tp, bp);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/* Ensure the freelist is the correct size. */
+int
+xfs_repair_fix_freelist(
+	struct xfs_scrub_context	*sc,
+	bool				can_shrink)
+{
+	struct xfs_alloc_arg		args = {0};
+
+	args.mp = sc->mp;
+	args.tp = sc->tp;
+	args.agno = sc->sa.agno;
+	args.alignment = 1;
+	args.pag = sc->sa.pag;
+
+	return xfs_alloc_fix_freelist(&args,
+			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
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
+	int				error;
+
+	/* Make sure there's space on the freelist. */
+	error = xfs_repair_fix_freelist(sc, true);
+	if (error)
+		return error;
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
+	/*
+	 * If we are repairing per-inode metadata, we need to read in the AGF
+	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
+	 * the AGF buffer that the setup functions already grabbed.
+	 */
+	if (sc->ip) {
+		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			return error;
+		if (!agf_bp)
+			return -ENOMEM;
+	} else {
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
+	 *
+	 * XXX: XFS doesn't support detecting the case where a single block
+	 * metadata structure is crosslinked with a multi-block structure
+	 * because the buffer cache doesn't detect aliasing problems, so we
+	 * can't fix 100% of crosslinking problems (yet).  The verifiers will
+	 * blow on writeout, the filesystem will shut down, and the admin gets
+	 * to run xfs_repair.
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
+/* Dispose of btree blocks from an old per-AG btree. */
+int
+xfs_repair_reap_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		type)
+{
+	struct xfs_repair_extent	*rex;
+	struct xfs_repair_extent	*n;
+	int				error = 0;
+
+	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
+
+	/* Dispose of every block from the old btree. */
+	for_each_xfs_repair_extent_safe(rex, n, exlist) {
+		ASSERT(sc->ip != NULL ||
+		       XFS_FSB_TO_AGNO(sc->mp, rex->fsbno) == sc->sa.agno);
+
+		trace_xfs_repair_dispose_btree_extent(sc->mp,
+				XFS_FSB_TO_AGNO(sc->mp, rex->fsbno),
+				XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno), rex->len);
+
+		for (; rex->len > 0; rex->len--, rex->fsbno++) {
+			error = xfs_repair_dispose_btree_block(sc, rex->fsbno,
+					oinfo, type);
+			if (error)
+				goto out;
+		}
+		list_del(&rex->list);
+		kmem_free(rex);
+	}
+
+out:
+	xfs_repair_cancel_btree_extents(sc, exlist);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ba1fdd7b9a79..f14aaab7df9e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -70,6 +70,12 @@ void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
 int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
 		struct xfs_repair_extent_list *exlist,
 		struct xfs_repair_extent_list *sublist);
+int xfs_repair_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
+int xfs_repair_invalidate_blocks(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
+int xfs_repair_reap_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *exlist,
+		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 /* Metadata repairers */
 
