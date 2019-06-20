Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFTSm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 14:42:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KIcfwE162703
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:58 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t7809jqtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KIgYKO083886
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t7rdxau7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KIguN8026275
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:57 GMT
Subject: [PATCH 1/2] xfs: refactor free space btree record initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 11:42:55 -0700
Message-ID: <156105617569.1200596.13164807309283607454.stgit@magnolia>
In-Reply-To: <156105616866.1200596.7212155126558008316.stgit@magnolia>
References: <156105616866.1200596.7212155126558008316.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that populates the free space btrees of a new AG so
that we can avoid code duplication once things start getting
complicated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5efb82744664..80a3df7ccab3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -56,37 +56,42 @@ xfs_btroot_init(
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
