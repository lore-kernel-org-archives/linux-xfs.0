Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbeBWCDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:03:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N22AZM150240
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:03:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ga9bpg27n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:03:10 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N23ASn020712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:03:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N23Ab6032070
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:03:10 GMT
Subject: [PATCH 12/20] xfs: repair the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:03:09 -0800
Message-ID: <151935138915.22097.1044282833385470052.stgit@magnolia>
In-Reply-To: <151935130484.22097.9694510081310029779.stgit@magnolia>
References: <151935130484.22097.9694510081310029779.stgit@magnolia>
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
 fs/xfs/scrub/agheader_repair.c |  112 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    2 +
 fs/xfs/scrub/scrub.c           |    1 
 3 files changed, 115 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index a694d8f..639cf88 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -568,3 +568,115 @@ xfs_repair_agfl(
 				XFS_BTREE_NOERROR);
 	return error;
 }
+
+/* AGI */
+
+int
+xfs_repair_agi(
+	struct xfs_scrub_context	*sc,
+	uint32_t			scrub_oflags)
+{
+	struct xfs_repair_find_ag_btree	fab[] = {
+		{
+			.rmap_owner = XFS_RMAP_OWN_INOBT,
+			.buf_ops = &xfs_inobt_buf_ops,
+			.magic = XFS_IBT_CRC_MAGIC,
+		},
+		{
+			.rmap_owner = XFS_RMAP_OWN_INOBT,
+			.buf_ops = &xfs_inobt_buf_ops,
+			.magic = XFS_FIBT_CRC_MAGIC,
+		},
+		{
+			.buf_ops = NULL
+		},
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
+	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
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
index 6ed568a..d89bc03 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -113,6 +113,7 @@ int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
 int xfs_repair_superblock(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
 int xfs_repair_agf(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
 int xfs_repair_agfl(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
+int xfs_repair_agi(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
 
 #else
 
@@ -137,6 +138,7 @@ xfs_repair_calc_ag_resblks(
 # define xfs_repair_superblock		(NULL)
 # define xfs_repair_agf			(NULL)
 # define xfs_repair_agfl		(NULL)
+# define xfs_repair_agi			(NULL)
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8c7967c..f3c3705 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -232,6 +232,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_agi,
+		.repair	= xfs_repair_agi,
 	},
 	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
 		.type	= ST_PERAG,

