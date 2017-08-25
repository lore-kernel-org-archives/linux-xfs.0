Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41973 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWSC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:02 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMI1oq013668
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMI11H023384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:01 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMI0O8023867
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:00 GMT
Subject: [PATCH 10/19] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:58 -0700
Message-ID: <150369947847.9957.11507815067026296270.stgit@magnolia>
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

If one of the backup superblocks is found to differ seriously from
superblock 0, write out a fresh copy from the in-core sb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h   |    1 +
 fs/xfs/scrub/scrub.c    |    1 +
 3 files changed, 37 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 8507153..d59444c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -472,6 +472,41 @@ xfs_scrub_superblock(
 	return error;
 }
 
+/* Repair the superblock. */
+int
+xfs_repair_superblock(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
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
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e0d3690..fc5dcaa 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -70,5 +70,6 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
 int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
+int xfs_repair_superblock(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9c2372e..401a446 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -216,6 +216,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* superblock */
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_superblock,
+		.repair	= xfs_repair_superblock,
 	},
 	{ /* agf */
 		.setup	= xfs_scrub_setup_ag_header,

