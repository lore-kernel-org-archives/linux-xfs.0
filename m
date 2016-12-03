Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20272 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758911AbcLCBkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:40:17 -0500
Subject: [PATCH 45/55] xfs: repair the AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:40:13 -0800
Message-ID: <148072921316.12995.9282612387517513837.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Regenerate the AGF and AGFL from the rmap data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |  392 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c   |    4 
 fs/xfs/repair/common.h   |    2 
 3 files changed, 396 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 6bcd495..dc8b463 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -31,9 +31,13 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 #include "repair/common.h"
 
 /* Find the size of the AG, in blocks. */
@@ -589,6 +593,182 @@ xfs_scrub_agf(
 #undef XFS_SCRUB_AGF_OP_ERROR_GOTO
 #undef XFS_SCRUB_AGF_CHECK
 
+struct xfs_repair_agf_allocbt {
+	xfs_agblock_t			freeblks;
+	xfs_agblock_t			longest;
+};
+
+/* Record free space shape information. */
+STATIC int
+xfs_repair_agf_walk_allocbt(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	struct xfs_repair_agf_allocbt	*raa = priv;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
+
+	raa->freeblks += rec->ar_blockcount;
+	if (rec->ar_blockcount > raa->longest)
+		raa->longest = rec->ar_blockcount;
+	return error;
+}
+
+/* Repair the AGF. */
+int
+xfs_repair_agf(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_find_ag_btree	fab[] = {
+		{XFS_RMAP_OWN_AG, &xfs_allocbt_buf_ops, XFS_ABTB_CRC_MAGIC, 0, 0},
+		{XFS_RMAP_OWN_AG, &xfs_allocbt_buf_ops, XFS_ABTC_CRC_MAGIC, 0, 0},
+		{XFS_RMAP_OWN_AG, &xfs_rmapbt_buf_ops, XFS_RMAP_CRC_MAGIC, 0, 0},
+		{XFS_RMAP_OWN_REFC, &xfs_refcountbt_buf_ops, XFS_REFC_CRC_MAGIC, 0, 0},
+		{0, NULL, 0, 0, 0},
+	};
+	struct xfs_repair_agf_allocbt	raa = {0};
+	struct xfs_agf			old_agf;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*agf_bp;
+	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_perag		*pag;
+	xfs_agblock_t			blocks;
+	xfs_agblock_t			freesp_blocks;
+	int				error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
+	if (error)
+		return error;
+	agf_bp->b_ops = &xfs_agf_buf_ops;
+
+	/* Find the btree roots. */
+	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab);
+	if (error)
+		return error;
+	if (fab[0].root == NULLAGBLOCK || fab[0].level > XFS_BTREE_MAXLEVELS ||
+	    fab[1].root == NULLAGBLOCK || fab[1].level > XFS_BTREE_MAXLEVELS ||
+	    fab[2].root == NULLAGBLOCK || fab[2].level > XFS_BTREE_MAXLEVELS)
+		return -EFSCORRUPTED;
+
+	/* Start rewriting the header. */
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	old_agf = *agf;
+	memset(agf, 0, mp->m_sb.sb_sectsize);
+	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
+	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
+	agf->agf_seqno = cpu_to_be32(sc->sa.agno);
+	agf->agf_length = cpu_to_be32(xfs_scrub_ag_blocks(mp, sc->sa.agno));
+	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(fab[0].root);
+	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(fab[1].root);
+	agf->agf_roots[XFS_BTNUM_RMAPi] = cpu_to_be32(fab[2].root);
+	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(fab[0].level);
+	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(fab[1].level);
+	agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(fab[2].level);
+	agf->agf_flfirst = old_agf.agf_flfirst;
+	agf->agf_fllast = old_agf.agf_fllast;
+	agf->agf_flcount = old_agf.agf_flcount;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agf->agf_refcount_root = cpu_to_be32(fab[3].root);
+		agf->agf_refcount_level = cpu_to_be32(fab[3].level);
+	}
+
+	/* Update the AGF counters from the bnobt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_BNO);
+	error = xfs_alloc_query_all(cur, xfs_repair_agf_walk_allocbt, &raa);
+	if (error)
+		goto err;
+	error = xfs_btree_count_blocks(cur, &blocks);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	freesp_blocks = blocks - 1;
+	agf->agf_freeblks = cpu_to_be32(raa.freeblks);
+	agf->agf_longest = cpu_to_be32(raa.longest);
+
+	/* Update the AGF counters from the cntbt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_CNT);
+	error = xfs_btree_count_blocks(cur, &blocks);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	freesp_blocks += blocks - 1;
+
+	/* Update the AGF counters from the rmapbt. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
+	error = xfs_btree_count_blocks(cur, &blocks);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	agf->agf_rmap_blocks = cpu_to_be32(blocks);
+	freesp_blocks += blocks - 1;
+
+	/* Update the AGF counters from the refcountbt. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
+				sc->sa.agno, NULL);
+		error = xfs_btree_count_blocks(cur, &blocks);
+		if (error)
+			goto err;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		agf->agf_refcount_blocks = cpu_to_be32(blocks);
+	}
+	agf->agf_btreeblks = cpu_to_be32(freesp_blocks);
+	cur = NULL;
+
+	/* Trigger reinitialization of the in-core data. */
+	if (raa.freeblks != be32_to_cpu(old_agf.agf_freeblks) ||
+	    freesp_blocks != be32_to_cpu(old_agf.agf_btreeblks) ||
+	    raa.longest != be32_to_cpu(old_agf.agf_longest) ||
+	    fab[0].level != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_BNOi]) ||
+	    fab[1].level != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_CNTi]) ||
+	    fab[2].level != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_RMAPi]) ||
+	    fab[3].level != be32_to_cpu(old_agf.agf_refcount_level)) {
+		pag = xfs_perag_get(mp, sc->sa.agno);
+		if (pag->pagf_init) {
+			pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
+			pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
+			pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
+			pag->pagf_longest = be32_to_cpu(agf->agf_longest);
+			pag->pagf_levels[XFS_BTNUM_BNOi] =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+			pag->pagf_levels[XFS_BTNUM_CNTi] =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+			pag->pagf_levels[XFS_BTNUM_RMAPi] =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+			pag->pagf_refcount_level =
+				be32_to_cpu(agf->agf_refcount_level);
+		}
+		xfs_perag_put(pag);
+		sc->reset_counters = true;
+	}
+
+	/* Write this to disk. */
+	xfs_trans_buf_set_type(sc->tp, agf_bp, XFS_BLFT_AGF_BUF);
+	xfs_trans_log_buf(sc->tp, agf_bp, 0, mp->m_sb.sb_sectsize - 1);
+	return error;
+
+err:
+	if (cur)
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+	*agf = old_agf;
+	return error;
+}
+
 /* AGFL */
 
 #define XFS_SCRUB_AGFL_CHECK(fs_ok) \
@@ -744,6 +924,218 @@ xfs_scrub_agfl(
 #undef XFS_SCRUB_AGFL_OP_ERROR_GOTO
 #undef XFS_SCRUB_AGFL_CHECK
 
+/* AGFL repair. */
+
+struct xfs_repair_agfl {
+	struct list_head		freesp_list;
+	struct list_head		agmeta_list;
+};
+
+/* Record all freespace information. */
+STATIC int
+xfs_repair_agfl_rmap_fn(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_agfl		*ra = priv;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+	int				i;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xfs_repair_collect_btree_extent(cur->bc_mp,
+				&ra->freesp_list, fsb, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
+		xfs_btree_get_block(cur, i, &bp);
+		if (!bp)
+			continue;
+		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+		error = xfs_repair_collect_btree_extent(cur->bc_mp,
+				&ra->agmeta_list, fsb, 1);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Add a btree block to the agmeta list. */
+STATIC int
+xfs_repair_agfl_visit_btblock(
+	struct xfs_btree_cur		*cur,
+	int				level,
+	void				*priv)
+{
+	struct xfs_repair_agfl		*ra = priv;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	return xfs_repair_collect_btree_extent(cur->bc_mp, &ra->agmeta_list,
+			fsb, 1);
+}
+
+/* Repair the AGFL. */
+int
+xfs_repair_agfl(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_agfl		ra;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*agf_bp;
+	struct xfs_buf			*agfl_bp;
+	struct xfs_agf			*agf;
+	struct xfs_agfl			*agfl;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_perag		*pag;
+	__be32				*agfl_bno;
+	struct xfs_repair_btree_extent	*rbe;
+	struct xfs_repair_btree_extent	*n;
+	xfs_agblock_t			flcount;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			bno;
+	xfs_agblock_t			old_flcount;
+	int				error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	INIT_LIST_HEAD(&ra.freesp_list);
+	INIT_LIST_HEAD(&ra.agmeta_list);
+	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
+	if (error)
+		return error;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
+	if (error)
+		return error;
+	agfl_bp->b_ops = &xfs_agfl_buf_ops;
+
+	/* Find all space used by the free space btrees & rmapbt. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_agfl_rmap_fn, &ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Find all space used by bnobt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_BNO);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock,
+			&ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Find all space used by cntbt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
+			XFS_BTNUM_CNT);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock,
+			&ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/*
+	 * Drop the freesp meta blocks that are in use by btrees.
+	 * The remaining blocks /should/ be AGFL blocks.
+	 */
+	error = xfs_repair_subtract_extents(mp, &ra.freesp_list,
+			&ra.agmeta_list);
+	if (error)
+		goto err;
+	xfs_repair_cancel_btree_extents(sc, &ra.agmeta_list);
+
+	/* Start rewriting the header. */
+	agfl = XFS_BUF_TO_AGFL(agfl_bp);
+	memset(agfl, 0xFF, mp->m_sb.sb_sectsize);
+	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
+	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
+
+	/* Fill the AGFL with the remaining blocks. */
+	flcount = 0;
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
+	list_for_each_entry_safe(rbe, n, &ra.freesp_list, list) {
+		agbno = XFS_FSB_TO_AGBNO(mp, rbe->fsbno);
+
+		trace_xfs_repair_agfl_insert(mp, sc->sa.agno, agbno, rbe->len);
+
+		for (bno = 0; bno < rbe->len; bno++) {
+			if (flcount >= XFS_AGFL_SIZE(mp))
+				break;
+			agfl_bno[flcount] = cpu_to_be32(agbno + bno);
+			flcount++;
+		}
+		rbe->fsbno += bno;
+		rbe->len -= bno;
+		if (rbe->len)
+			break;
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+
+	/* Update the AGF counters. */
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	old_flcount = be32_to_cpu(agf->agf_flcount);
+	agf->agf_flfirst = 0;
+	agf->agf_flcount = cpu_to_be32(flcount);
+	agf->agf_fllast = cpu_to_be32(flcount - 1);
+
+	/* Trigger reinitialization of the in-core data. */
+	if (flcount != old_flcount) {
+		pag = xfs_perag_get(mp, sc->sa.agno);
+		if (pag->pagf_init)
+			pag->pagf_flcount = flcount;
+		xfs_perag_put(pag);
+		sc->reset_counters = true;
+	}
+
+	/* Write AGF and AGFL to disk. */
+	xfs_alloc_log_agf(sc->tp, agf_bp,
+			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
+	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
+	xfs_trans_log_buf(sc->tp, agfl_bp, 0, mp->m_sb.sb_sectsize - 1);
+
+	/* Dump any AGFL overflow. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	return xfs_repair_reap_btree_extents(sc, &ra.freesp_list, &oinfo,
+			XFS_AG_RESV_AGFL);
+err:
+	xfs_repair_cancel_btree_extents(sc, &ra.agmeta_list);
+	xfs_repair_cancel_btree_extents(sc, &ra.freesp_list);
+	if (cur)
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+	return error;
+}
+
 /* AGI */
 
 #define XFS_SCRUB_AGI_CHECK(fs_ok) \
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index e7b5121..5143f49 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -1003,8 +1003,8 @@ struct xfs_scrub_meta_fns {
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_superblock, xfs_repair_superblock, NULL},
-	{xfs_scrub_setup_ag, xfs_scrub_agf, NULL, NULL},
-	{xfs_scrub_setup_ag, xfs_scrub_agfl, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_agf, xfs_repair_agf, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_agfl, xfs_repair_agfl, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 38c2fe9..02bce24 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -281,5 +281,7 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc,
 /* Metadata repairers */
 
 int xfs_repair_superblock(struct xfs_scrub_context *sc);
+int xfs_repair_agf(struct xfs_scrub_context *sc);
+int xfs_repair_agfl(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */

