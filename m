Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23788 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759149AbcLCBkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:40:24 -0500
Subject: [PATCH 46/55] xfs: rebuild the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:40:19 -0800
Message-ID: <148072921942.12995.9245945604129994364.stgit@birch.djwong.org>
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

Rebuild the AGI header items with some help from the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c   |    2 -
 fs/xfs/repair/common.h   |    1 
 3 files changed, 100 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index dc8b463..24ae439 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -1298,3 +1298,101 @@ xfs_scrub_agi(
 	return error;
 }
 #undef XFS_SCRUB_AGI_CHECK
+
+/* Repair the AGI. */
+int
+xfs_repair_agi(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_find_ag_btree	fab[] = {
+		{XFS_RMAP_OWN_INOBT, &xfs_inobt_buf_ops, XFS_IBT_CRC_MAGIC, 0, 0},
+		{XFS_RMAP_OWN_INOBT, &xfs_inobt_buf_ops, XFS_FIBT_CRC_MAGIC, 0, 0},
+		{0, NULL, 0, 0, 0},
+	};
+	struct xfs_agi			old_agi;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*agi_bp;
+	struct xfs_buf			*agf_bp;
+	struct xfs_agi			*agi;
+	struct xfs_btree_cur		*cur;
+	struct xfs_perag		*pag;
+	xfs_agino_t			old_count;
+	xfs_agino_t			old_freecount;
+	xfs_agino_t			count;
+	xfs_agino_t			freecount;
+	int				bucket;
+	int				error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGI_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
+	if (error)
+		return error;
+	agi_bp->b_ops = &xfs_agi_buf_ops;
+
+	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
+	if (error)
+		return error;
+
+	/* Find the btree roots. */
+	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab);
+	if (error)
+		return error;
+	if (fab[0].root == NULLAGBLOCK || fab[0].level > XFS_BTREE_MAXLEVELS)
+		return -EFSCORRUPTED;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    (fab[1].root == NULLAGBLOCK || fab[1].level > XFS_BTREE_MAXLEVELS))
+		return -EFSCORRUPTED;
+
+	/* Start rewriting the header. */
+	agi = XFS_BUF_TO_AGI(agi_bp);
+	old_agi = *agi;
+	old_count = be32_to_cpu(old_agi.agi_count);
+	old_freecount = be32_to_cpu(old_agi.agi_freecount);
+	memset(agi, 0, mp->m_sb.sb_sectsize);
+	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
+	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
+	agi->agi_seqno = cpu_to_be32(sc->sa.agno);
+	agi->agi_length = cpu_to_be32(xfs_scrub_ag_blocks(mp, sc->sa.agno));
+	agi->agi_newino = cpu_to_be32(NULLAGINO);
+	agi->agi_dirino = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
+		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	agi->agi_root = cpu_to_be32(fab[0].root);
+	agi->agi_level = cpu_to_be32(fab[0].level);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agi->agi_free_root = cpu_to_be32(fab[1].root);
+		agi->agi_free_level = cpu_to_be32(fab[1].level);
+	}
+
+	/* Update the AGI counters. */
+	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
+			XFS_BTNUM_INO);
+	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	if (error)
+		goto err;
+	agi->agi_count = cpu_to_be32(count);
+	agi->agi_freecount = cpu_to_be32(freecount);
+	if (old_count != count || old_freecount != freecount) {
+		pag = xfs_perag_get(mp, sc->sa.agno);
+		pag->pagi_init = 0;
+		xfs_perag_put(pag);
+		sc->reset_counters = true;
+	}
+
+	/* Write this to disk. */
+	xfs_trans_buf_set_type(sc->tp, agi_bp, XFS_BLFT_AGI_BUF);
+	xfs_trans_log_buf(sc->tp, agi_bp, 0, mp->m_sb.sb_sectsize - 1);
+	return error;
+
+err:
+	*agi = old_agi;
+	return error;
+}
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 5143f49..1f3bf95 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -1005,7 +1005,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag, xfs_scrub_superblock, xfs_repair_superblock, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agf, xfs_repair_agf, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agfl, xfs_repair_agfl, NULL},
-	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_agi, xfs_repair_agi, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 02bce24..5adac6a 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -283,5 +283,6 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc,
 int xfs_repair_superblock(struct xfs_scrub_context *sc);
 int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
+int xfs_repair_agi(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */

