Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeEOWd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:33:56 -0400
Subject: [PATCH 02/22] xfs: add helpers to allocate and initialize fresh
 btree roots
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:33:51 -0700
Message-ID: <152642363169.1556.14593532407537096653.stgit@magnolia>
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

Add a pair of helper functions to allocate and initialize fresh btree
roots.  The repair functions will use these as part of recreating
corrupted metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    6 ++++
 2 files changed, 87 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 486e6e319b1f..72f04a717150 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -280,3 +280,84 @@ xfs_repair_calc_ag_resblks(
 
 	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
 }
+
+/* Allocate a block in an AG. */
+int
+xfs_repair_alloc_ag_block(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	xfs_fsblock_t			*fsbno,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_alloc_arg		args = {0};
+	xfs_agblock_t			bno;
+	int				error;
+
+	switch (resv) {
+	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_RMAPBT:
+		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
+		if (error)
+			return error;
+		if (bno == NULLAGBLOCK)
+			return -ENOSPC;
+		xfs_extent_busy_reuse(sc->mp, sc->sa.agno, bno,
+				1, false);
+		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
+		if (resv == XFS_AG_RESV_RMAPBT)
+			xfs_ag_resv_rmapbt_alloc(sc->mp, sc->sa.agno);
+		return 0;
+	default:
+		break;
+	}
+
+	args.tp = sc->tp;
+	args.mp = sc->mp;
+	args.oinfo = *oinfo;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);
+	args.minlen = 1;
+	args.maxlen = 1;
+	args.prod = 1;
+	args.type = XFS_ALLOCTYPE_THIS_AG;
+	args.resv = resv;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+	if (args.fsbno == NULLFSBLOCK)
+		return -ENOSPC;
+	ASSERT(args.len == 1);
+	*fsbno = args.fsbno;
+
+	return 0;
+}
+
+/* Initialize a new AG btree root block with zero entries. */
+int
+xfs_repair_init_btblock(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsb,
+	struct xfs_buf			**bpp,
+	xfs_btnum_t			btnum,
+	const struct xfs_buf_ops	*ops)
+{
+	struct xfs_trans		*tp = sc->tp;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+
+	trace_xfs_repair_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
+			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
+
+	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
+	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
+			XFS_FSB_TO_BB(mp, 1), 0);
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno,
+			XFS_BTREE_CRC_BLOCKS);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
+	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
+	bp->b_ops = ops;
+	*bpp = bp;
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 8d181dce6171..40990fa5f381 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -36,6 +36,12 @@ int xfs_repair_roll_ag_trans(struct xfs_scrub_context *sc);
 bool xfs_repair_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
+int xfs_repair_alloc_ag_block(struct xfs_scrub_context *sc,
+		struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
+		enum xfs_ag_resv_type resv);
+int xfs_repair_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
+		struct xfs_buf **bpp, xfs_btnum_t btnum,
+		const struct xfs_buf_ops *ops);
 
 /* Metadata repairers */
 

