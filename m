Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23737 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758911AbcLCBkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:40:10 -0500
Subject: [PATCH 44/55] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:40:06 -0800
Message-ID: <148072920677.12995.16323245496758311456.stgit@birch.djwong.org>
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

If one of the backup superblocks is found to differ seriously from
superblock 0, write out a fresh copy from the in-core sb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c   |    2 +-
 fs/xfs/repair/common.h   |    4 ++++
 3 files changed, 39 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index df7c811..6bcd495 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -325,6 +325,40 @@ xfs_scrub_superblock(
 #undef XFS_SCRUB_SB_OP_ERROR_GOTO
 #undef XFS_SCRUB_SB_CHECK
 
+/* Repair the superblock. */
+int
+xfs_repair_superblock(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*bp;
+	struct xfs_dsb			*sbp;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
+	agno = sc->sm->sm_agno;
+	if (agno == 0)
+		return -ENOTTY;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+		  XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+		  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		return error;
+	bp->b_ops = &xfs_sb_buf_ops;
+
+	/* Copy AG 0's superblock to this one. */
+	sbp = XFS_BUF_TO_SBP(bp);
+	memset(sbp, 0, mp->m_sb.sb_sectsize);
+	xfs_sb_to_disk(sbp, &mp->m_sb);
+
+	/* Write this to disk. */
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(sc->tp, bp, 0, mp->m_sb.sb_sectsize - 1);
+	return error;
+}
+
 /* AGF */
 
 /* Tally freespace record lengths. */
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index acf93a5..e7b5121 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -1002,7 +1002,7 @@ struct xfs_scrub_meta_fns {
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
-	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_superblock, xfs_repair_superblock, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agfl, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 0d6c7e3..38c2fe9 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -278,4 +278,8 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc,
 					struct xfs_inode *ip,
 					struct xfs_scrub_metadata *sm);
 
+/* Metadata repairers */
+
+int xfs_repair_superblock(struct xfs_scrub_context *sc);
+
 #endif	/* __XFS_REPAIR_COMMON_H__ */

