Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbeGZBeT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 21:34:19 -0400
Subject: [PATCH 05/16] xfs: repair the AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Jul 2018 17:20:01 -0700
Message-ID: <153256440143.29021.10996727150978290944.stgit@magnolia>
In-Reply-To: <153256436688.29021.4638459579042241728.stgit@magnolia>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair the AGFL from the rmap data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |  272 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.c          |   92 ++++++++++++++
 fs/xfs/scrub/bitmap.h          |    4 +
 fs/xfs/scrub/scrub.c           |    2 
 4 files changed, 369 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 938af216cb1c..407fee8d94dd 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -420,3 +420,275 @@ xrep_agf(
 	memcpy(agf, &old_agf, sizeof(old_agf));
 	return error;
 }
+
+/* AGFL */
+
+struct xrep_agfl {
+	/* Bitmap of other OWN_AG metadata blocks. */
+	struct xfs_bitmap	agmetablocks;
+
+	/* Bitmap of free space. */
+	struct xfs_bitmap	*freesp;
+
+	struct xfs_scrub	*sc;
+};
+
+/* Record all OWN_AG (free space btree) information from the rmap data. */
+STATIC int
+xrep_agfl_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_agfl	*ra = priv;
+	xfs_fsblock_t		fsb;
+	int			error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
+
+	/* Record all the OWN_AG blocks. */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xfs_bitmap_set(ra->freesp, fsb, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	return xfs_bitmap_set_btcur_path(&ra->agmetablocks, cur);
+}
+
+/*
+ * Map out all the non-AGFL OWN_AG space in this AG so that we can deduce
+ * which blocks belong to the AGFL.
+ *
+ * Compute the set of old AGFL blocks by subtracting from the list of OWN_AG
+ * blocks the list of blocks owned by all other OWN_AG metadata (bnobt, cntbt,
+ * rmapbt).  These are the old AGFL blocks, so return that list and the number
+ * of blocks we're actually going to put back on the AGFL.
+ */
+STATIC int
+xrep_agfl_collect_blocks(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*agf_bp,
+	struct xfs_bitmap	*agfl_extents,
+	xfs_agblock_t		*flcount)
+{
+	struct xrep_agfl	ra;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_bitmap_range	*br;
+	struct xfs_bitmap_range	*n;
+	int			error;
+
+	ra.sc = sc;
+	ra.freesp = agfl_extents;
+	xfs_bitmap_init(&ra.agmetablocks);
+
+	/* Find all space used by the free space btrees & rmapbt. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xrep_agfl_walk_rmap, &ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+
+	/* Find all blocks currently being used by the bnobt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_BNO);
+	error = xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+
+	/* Find all blocks currently being used by the cntbt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_CNT);
+	error = xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
+	if (error)
+		goto err;
+
+	xfs_btree_del_cursor(cur, error);
+
+	/*
+	 * Drop the freesp meta blocks that are in use by btrees.
+	 * The remaining blocks /should/ be AGFL blocks.
+	 */
+	error = xfs_bitmap_disunion(agfl_extents, &ra.agmetablocks);
+	xfs_bitmap_destroy(&ra.agmetablocks);
+	if (error)
+		return error;
+
+	/*
+	 * Calculate the new AGFL size.  If we found more blocks than fit in
+	 * the AGFL we'll free them later.
+	 */
+	*flcount = 0;
+	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
+		*flcount += br->len;
+		if (*flcount > xfs_agfl_size(mp))
+			break;
+	}
+	if (*flcount > xfs_agfl_size(mp))
+		*flcount = xfs_agfl_size(mp);
+	return 0;
+
+err:
+	xfs_bitmap_destroy(&ra.agmetablocks);
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/* Update the AGF and reset the in-core state. */
+STATIC int
+xrep_agfl_update_agf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*agf_bp,
+	xfs_agblock_t		flcount)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
+
+	ASSERT(flcount <= xfs_agfl_size(sc->mp));
+
+	/* Trigger fdblocks recalculation */
+	xfs_force_summary_recalc(sc->mp);
+
+	/* Update the AGF counters. */
+	if (sc->sa.pag->pagf_init)
+		sc->sa.pag->pagf_flcount = flcount;
+	agf->agf_flfirst = cpu_to_be32(0);
+	agf->agf_flcount = cpu_to_be32(flcount);
+	agf->agf_fllast = cpu_to_be32(flcount - 1);
+
+	xfs_alloc_log_agf(sc->tp, agf_bp,
+			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
+	return 0;
+}
+
+/* Write out a totally new AGFL. */
+STATIC void
+xrep_agfl_init_header(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*agfl_bp,
+	struct xfs_bitmap	*agfl_extents,
+	xfs_agblock_t		flcount)
+{
+	struct xfs_mount	*mp = sc->mp;
+	__be32			*agfl_bno;
+	struct xfs_bitmap_range	*br;
+	struct xfs_bitmap_range	*n;
+	struct xfs_agfl		*agfl;
+	xfs_agblock_t		agbno;
+	unsigned int		fl_off;
+
+	ASSERT(flcount <= xfs_agfl_size(mp));
+
+	/* Start rewriting the header. */
+	agfl = XFS_BUF_TO_AGFL(agfl_bp);
+	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
+	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
+	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
+
+	/*
+	 * Fill the AGFL with the remaining blocks.  If agfl_extents has more
+	 * blocks than fit in the AGFL, they will be freed in a subsequent
+	 * step.
+	 */
+	fl_off = 0;
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
+	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
+		agbno = XFS_FSB_TO_AGBNO(mp, br->fsbno);
+
+		trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
+
+		while (br->len > 0 && fl_off < flcount) {
+			agfl_bno[fl_off] = cpu_to_be32(agbno);
+			fl_off++;
+			agbno++;
+			br->fsbno++;
+			br->len--;
+		}
+
+		if (br->len)
+			break;
+		list_del(&br->list);
+		kmem_free(br);
+	}
+
+	/* Write new AGFL to disk. */
+	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
+	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
+}
+
+/* Repair the AGFL. */
+int
+xrep_agfl(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_bitmap	agfl_extents;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_buf		*agfl_bp;
+	xfs_agblock_t		flcount;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+	xfs_bitmap_init(&agfl_extents);
+
+	/*
+	 * Read the AGF so that we can query the rmapbt.  We hope that there's
+	 * nothing wrong with the AGF, but all the AG header repair functions
+	 * have this chicken-and-egg problem.
+	 */
+	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
+	if (error)
+		return error;
+	if (!agf_bp)
+		return -ENOMEM;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
+	if (error)
+		return error;
+	agfl_bp->b_ops = &xfs_agfl_buf_ops;
+
+	/* Gather all the extents we're going to put on the new AGFL. */
+	error = xrep_agfl_collect_blocks(sc, agf_bp, &agfl_extents, &flcount);
+	if (error)
+		goto err;
+
+	/*
+	 * Update AGF and AGFL.  We reset the global free block counter when
+	 * we adjust the AGF flcount (which can fail) so avoid updating any
+	 * buffers until we know that part works.
+	 */
+	error = xrep_agfl_update_agf(sc, agf_bp, flcount);
+	if (error)
+		goto err;
+	xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
+
+	/*
+	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
+	 * make the new AGFL permanent before we start using it to return
+	 * freespace overflow to the freespace btrees.
+	 */
+	sc->sa.agf_bp = agf_bp;
+	sc->sa.agfl_bp = agfl_bp;
+	error = xrep_roll_ag_trans(sc);
+	if (error)
+		goto err;
+
+	/* Dump any AGFL overflow. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	return xrep_reap_extents(sc, &agfl_extents, &oinfo, XFS_AG_RESV_AGFL);
+err:
+	xfs_bitmap_destroy(&agfl_extents);
+	return error;
+}
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 4840f5a1e179..046ee63982c9 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -9,6 +9,7 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -209,3 +210,94 @@ xfs_bitmap_disunion(
 }
 #undef LEFT_ALIGNED
 #undef RIGHT_ALIGNED
+
+/*
+ * Record all btree blocks seen while iterating all records of a btree.
+ *
+ * We know that the btree query_all function starts at the left edge and walks
+ * towards the right edge of the tree.  Therefore, we know that we can walk up
+ * the btree cursor towards the root; if the pointer for a given level points
+ * to the first record/key in that block, we haven't seen this block before;
+ * and therefore we need to remember that we saw this block in the btree.
+ *
+ * So if our btree is:
+ *
+ *    4
+ *  / | \
+ * 1  2  3
+ *
+ * Pretend for this example that each leaf block has 100 btree records.  For
+ * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
+ * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
+ * block 4.  The list is [1, 4].
+ *
+ * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
+ * loop.  The list remains [1, 4].
+ *
+ * For the 101st btree record, we've moved onto leaf block 2.  Now
+ * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
+ * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
+ *
+ * For the 102nd record, bc_ptrs[0] == 2, so we continue.
+ *
+ * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
+ * we add 3 to the list.  Now it is [1, 4, 2, 3].
+ *
+ * For the 300th record we just exit, with the list being [1, 4, 2, 3].
+ */
+
+/*
+ * Record all the buffers pointed to by the btree cursor.  Callers already
+ * engaged in a btree walk should call this function to capture the list of
+ * blocks going from the leaf towards the root.
+ */
+int
+xfs_bitmap_set_btcur_path(
+	struct xfs_bitmap	*bitmap,
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsb;
+	int			i;
+	int			error;
+
+	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
+		xfs_btree_get_block(cur, i, &bp);
+		if (!bp)
+			continue;
+		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+		error = xfs_bitmap_set(bitmap, fsb, 1);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Collect a btree's block in the bitmap. */
+STATIC int
+xfs_bitmap_collect_btblock(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xfs_bitmap	*bitmap = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsbno;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	return xfs_bitmap_set(bitmap, fsbno, 1);
+}
+
+/* Walk the btree and mark the bitmap wherever a btree block is found. */
+int
+xfs_bitmap_set_btblocks(
+	struct xfs_bitmap	*bitmap,
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap);
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 3c39900e9269..b5df433b6e9c 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -29,5 +29,9 @@ void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
 int xfs_bitmap_set(struct xfs_bitmap *bitmap, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
 int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *sub);
+int xfs_bitmap_set_btcur_path(struct xfs_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
+int xfs_bitmap_set_btblocks(struct xfs_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1e8a17c8e2b9..2670f4cf62f4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -220,7 +220,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_fs,
 		.scrub	= xchk_agfl,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_agfl,
 	},
 	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
 		.type	= ST_PERAG,

