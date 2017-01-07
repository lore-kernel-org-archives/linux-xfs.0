Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16420 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162018AbdAGAjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:39:42 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070dfiM024278
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v070de0P015272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:40 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070de54016662
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:40 GMT
Subject: [PATCH 36/47] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:39:39 -0800
Message-ID: <148374957966.30431.14700999824559848265.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If one of the backup superblocks is found to differ seriously from
superblock 0, write out a fresh copy from the in-core sb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c   |    2 +-
 fs/xfs/repair/common.h   |    4 ++++
 3 files changed, 40 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 5a3d4c1..b2a85df 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -343,6 +343,41 @@ xfs_scrub_superblock(
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
+		return -EOPNOTSUPP;
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
+	sbp->sb_bad_features2 = sbp->sb_features2;
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
index a3efaf0..2f7a0a3 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -754,7 +754,7 @@ struct xfs_scrub_meta_fns {
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
-	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_superblock, xfs_repair_superblock, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agfl, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 1f01ab3..5ee7472 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -324,4 +324,8 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc,
 					struct xfs_inode *ip,
 					struct xfs_scrub_metadata *sm);
 
+/* Metadata repairers */
+
+int xfs_repair_superblock(struct xfs_scrub_context *sc);
+
 #endif	/* __XFS_REPAIR_COMMON_H__ */

