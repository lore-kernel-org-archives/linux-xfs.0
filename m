Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27440 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdHYWSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:15 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIEsH022711
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIDJm014494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:14 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMIDom023946
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:13 GMT
Subject: [PATCH 12/19] xfs: rebuild the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:12 -0700
Message-ID: <150369949210.9957.18386712677796411175.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuild the AGI header items with some help from the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h   |    1 
 fs/xfs/scrub/scrub.c    |    1 
 3 files changed, 102 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 40c31ed..0f83ea3 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -1536,3 +1536,103 @@ xfs_scrub_agi(
 out:
 	return error;
 }
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
+	struct xfs_mount		*mp = sc->mp;
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
+	if (!agf_bp)
+		return -ENOMEM;
+
+	/* Find the btree roots. */
+	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab, NULL);
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
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 6c544eb..e80f2e3 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -73,5 +73,6 @@ int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
 int xfs_repair_superblock(struct xfs_scrub_context *sc);
 int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
+int xfs_repair_agi(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3ddfe09..03da10a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -231,6 +231,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* agi */
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_agi,
+		.repair	= xfs_repair_agi,
 	},
 	{ /* bnobt */
 		.setup	= xfs_scrub_setup_ag_allocbt,

