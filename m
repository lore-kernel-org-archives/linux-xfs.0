Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52250 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932091AbeE3Taz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:30:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UJPZp8178368
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2j9x4h9322-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJUrFq028436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:54 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJUrhH032210
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:53 GMT
Subject: [PATCH 02/14] xfs: repair the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 30 May 2018 12:30:52 -0700
Message-ID: <152770865219.11611.15383367715338540008.stgit@magnolia>
In-Reply-To: <152770863951.11611.5866814627357136911.stgit@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
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
 fs/xfs/scrub/agheader_repair.c |  108 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c          |   29 +++++++++++
 fs/xfs/scrub/repair.h          |    5 ++
 fs/xfs/scrub/scrub.c           |    2 -
 4 files changed, 143 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0f794d27382a..ba750d3d11f0 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -552,3 +552,111 @@ xfs_repair_agfl(
 				XFS_BTREE_NOERROR);
 	return error;
 }
+
+/* AGI */
+
+int
+xfs_repair_agi(
+	struct xfs_scrub_context	*sc)
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
+	xfs_scrub_perag_get(sc->mp, &sc->sa);
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
+	if (fab[0].root == NULLAGBLOCK || fab[0].height > XFS_BTREE_MAXLEVELS)
+		return -EFSCORRUPTED;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    (fab[1].root == NULLAGBLOCK || fab[1].height > XFS_BTREE_MAXLEVELS))
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
+	agi->agi_level = cpu_to_be32(fab[0].height);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agi->agi_free_root = cpu_to_be32(fab[1].root);
+		agi->agi_free_level = cpu_to_be32(fab[1].height);
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
+
+	xfs_repair_mod_ino_counts(sc, old_count, count, old_freecount,
+			freecount);
+
+	/* Write this to disk. */
+	xfs_trans_buf_set_type(sc->tp, agi_bp, XFS_BLFT_AGI_BUF);
+	xfs_trans_log_buf(sc->tp, agi_bp, 0, BBTOB(agi_bp->b_length) - 1);
+	return error;
+
+err:
+	*agi = old_agi;
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5f31dc8af505..45a91841c0ac 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1117,3 +1117,32 @@ xfs_repair_mod_fdblocks(
 	xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_FDBLOCKS, delta_fdblocks);
 	return 0;
 }
+
+/*
+ * Update in-core and superblock inode counters.
+ *
+ * XXX: Need to check the sb counters, see the comment in
+ * xfs_repair_mod_fdblocks about sb counter checking being unfinished.
+ */
+void
+xfs_repair_mod_ino_counts(
+	struct xfs_scrub_context	*sc,
+	xfs_agino_t			old_count,
+	xfs_agino_t			count,
+	xfs_agino_t			old_freecount,
+	xfs_agino_t			freecount)
+{
+	if (old_count != count) {
+		if (sc->sa.pag->pagi_init)
+			sc->sa.pag->pagi_count = count;
+		xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_ICOUNT,
+				(int64_t)count - old_count);
+	}
+
+	if (old_freecount != freecount) {
+		if (sc->sa.pag->pagi_init)
+			sc->sa.pag->pagi_freecount = freecount;
+		xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_IFREE,
+				(int64_t)freecount - old_freecount);
+	}
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 97794c281a23..9d69d03f1bfe 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -100,6 +100,9 @@ void xfs_repair_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
 int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
 int xfs_repair_mod_fdblocks(struct xfs_scrub_context *sc,
 		int64_t delta_fdblocks);
+void xfs_repair_mod_ino_counts(struct xfs_scrub_context *sc,
+		xfs_agino_t old_count, xfs_agino_t count,
+		xfs_agino_t old_freecount, xfs_agino_t freecount);
 
 /* Metadata repairers */
 
@@ -107,6 +110,7 @@ int xfs_repair_probe(struct xfs_scrub_context *sc);
 int xfs_repair_superblock(struct xfs_scrub_context *sc);
 int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
+int xfs_repair_agi(struct xfs_scrub_context *sc);
 
 #else
 
@@ -132,6 +136,7 @@ xfs_repair_calc_ag_resblks(
 #define xfs_repair_superblock		xfs_repair_notsupported
 #define xfs_repair_agf			xfs_repair_notsupported
 #define xfs_repair_agfl			xfs_repair_notsupported
+#define xfs_repair_agi			xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0b523ab9b8b0..d68cfcd31f30 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -234,7 +234,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_agi,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_agi,
 	},
 	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
 		.type	= ST_PERAG,

