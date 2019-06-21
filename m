Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUT5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:05 -0400
Subject: [PATCH 1/6] xfs: refactor free space btree record initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:57:00 -0700
Message-ID: <156114702011.1643538.11896501170862991755.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Allison Collins <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that populates the free space btrees of a new AG so
that we can avoid code duplication once things start getting
complicated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_ag.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 8ee45699..fe79693e 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -57,37 +57,42 @@ xfs_btroot_init(
 	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
 }
 
-/*
- * Alloc btree root block init functions
- */
+/* Finish initializing a free space btree. */
 static void
-xfs_bnoroot_init(
+xfs_freesp_init_recs(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
 	struct xfs_alloc_rec	*arec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
 	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
 }
 
+/*
+ * Alloc btree root block init functions
+ */
 static void
-xfs_cntroot_init(
+xfs_bnoroot_init(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_alloc_rec	*arec;
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
+	xfs_freesp_init_recs(mp, bp, id);
+}
 
+static void
+xfs_cntroot_init(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct aghdr_init_data	*id)
+{
 	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
-	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
-	arec->ar_blockcount = cpu_to_be32(id->agsize -
-					  be32_to_cpu(arec->ar_startblock));
+	xfs_freesp_init_recs(mp, bp, id);
 }
 
 /*
