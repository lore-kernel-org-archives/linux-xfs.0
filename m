Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387769AbfHHOrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 10:47:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Ehc5G094907
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:04 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8has9sjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:47:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Egv9C100142
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u75bxrsf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:47:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x78El3Yk007354
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:03 GMT
Subject: [PATCH 2/3] xfs: remove more ondisk directory corruption asserts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Aug 2019 07:47:02 -0700
Message-ID: <156527562244.1960675.10725983010213633067.stgit@magnolia>
In-Reply-To: <156527561023.1960675.17007470833732765300.stgit@magnolia>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Continue our game of replacing ASSERTs for corrupt ondisk metadata with
EFSCORRUPTED returns.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
 2 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index d1c77fd0815d..0bf56e94bfe9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -487,10 +487,8 @@ xfs_da3_split(
 	ASSERT(state->path.active == 0);
 	oldblk = &state->path.blk[0];
 	error = xfs_da3_root_split(state, oldblk, addblk);
-	if (error) {
-		addblk->bp = NULL;
-		return error;	/* GROT: dir is inconsistent */
-	}
+	if (error)
+		goto out;
 
 	/*
 	 * Update pointers to the node which used to be block 0 and just got
@@ -505,7 +503,10 @@ xfs_da3_split(
 	 */
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
-		ASSERT(be32_to_cpu(node->hdr.info.forw) == addblk->blkno);
+		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		node = addblk->bp->b_addr;
 		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
 		xfs_trans_log_buf(state->args->trans, addblk->bp,
@@ -514,15 +515,19 @@ xfs_da3_split(
 	}
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
-		ASSERT(be32_to_cpu(node->hdr.info.back) == addblk->blkno);
+		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		node = addblk->bp->b_addr;
 		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
 		xfs_trans_log_buf(state->args->trans, addblk->bp,
 				  XFS_DA_LOGRANGE(node, &node->hdr.info,
 				  sizeof(node->hdr.info)));
 	}
+out:
 	addblk->bp = NULL;
-	return 0;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index afcc6642690a..1fc44efc344d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -741,7 +741,8 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	ASSERT(leafhdr.count > 0);
+	if (leafhdr.count <= 0)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Look up the hash value in the leaf entries.
