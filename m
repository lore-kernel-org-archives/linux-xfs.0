Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fkaM045664
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2hdrxp0k1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:18 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gHB7009942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:18 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gH3D026093
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:17 GMT
Subject: [PATCH 04/24] xfs: add helpers to allocate and initialize fresh
 btree roots
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:16 -0700
Message-ID: <152401933615.12079.17642135086705713269.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a pair of helper functions to allocate and initialize fresh btree
roots.  The repair functions will use these as part of recreating
corrupted metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    6 ++++
 2 files changed, 81 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ab053d0..01b9ee5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -280,3 +280,78 @@ xfs_repair_calc_ag_resblks(
 
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
+	if (resv == XFS_AG_RESV_AGFL) {
+		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
+		if (error)
+			return error;
+		if (bno == NULLAGBLOCK)
+			return -ENOSPC;
+		xfs_extent_busy_reuse(sc->mp, sc->sa.agno, bno,
+				1, false);
+		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
+		return 0;
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
index 8d181dc..40990fa 100644
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
 

