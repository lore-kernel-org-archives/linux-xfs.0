Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfFZUqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhsv5012188
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:42 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t9brtcmy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKja7i148522
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t9accwepv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKkexE005140
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:40 GMT
Subject: [PATCH 1/6] xfs: remove more ondisk directory corruption asserts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:46:40 -0700
Message-ID: <156158199994.495944.4584531696054696463.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
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
index e2737e2ac2ae..c914ae763113 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -493,10 +493,8 @@ xfs_da3_split(
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
@@ -511,7 +509,10 @@ xfs_da3_split(
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
@@ -520,15 +521,19 @@ xfs_da3_split(
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
index 16731d2d684b..f7f3fb458019 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -743,7 +743,8 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	ASSERT(leafhdr.count > 0);
+	if (leafhdr.count <= 0)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Look up the hash value in the leaf entries.
