Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31696 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdJZFtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:49:33 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9Q5nWdG015777
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9Q5nWfa021259
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:32 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9Q5nVNa027799
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:31 GMT
Subject: [PATCH 2/4] xfs: abort dir/attr btree operation if btree is
 obviously weird
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Oct 2017 22:49:30 -0700
Message-ID: <150899697070.18095.15832412427078558395.stgit@magnolia>
In-Reply-To: <150899696463.18095.9642473908739425678.stgit@magnolia>
References: <150899696463.18095.9642473908739425678.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Abort an dir/attr btree operation if the attr btree has obvious problems
like loops back to the root or pointers don't point down the tree.
Found by fuzzing btree[0].before to zero in xfs/402, which livelocks on
the cycle in the attr btree.

Apply the same checks to xfs_da3_node_lookup_int.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |   34 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_attr_list.c       |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 6d43358..3dbeda6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1466,6 +1466,7 @@ xfs_da3_node_lookup_int(
 	int			max;
 	int			error;
 	int			retval;
+	unsigned int		expected_level = -1U;
 	struct xfs_inode	*dp = state->args->dp;
 
 	args = state->args;
@@ -1474,7 +1475,7 @@ xfs_da3_node_lookup_int(
 	 * Descend thru the B-tree searching each level for the right
 	 * node to use, until the right hashval is found.
 	 */
-	blkno = (args->whichfork == XFS_DATA_FORK)? args->geo->leafblk : 0;
+	blkno = args->geo->leafblk;
 	for (blk = &state->path.blk[0], state->path.active = 1;
 			 state->path.active <= XFS_DA_NODE_MAXDEPTH;
 			 blk++, state->path.active++) {
@@ -1496,6 +1497,8 @@ xfs_da3_node_lookup_int(
 		    blk->magic == XFS_ATTR3_LEAF_MAGIC) {
 			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
+			if (expected_level == -1U)
+				expected_level = 0;
 			break;
 		}
 
@@ -1504,6 +1507,8 @@ xfs_da3_node_lookup_int(
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
 			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
 							      blk->bp, NULL);
+			if (expected_level == -1U)
+				expected_level = 0;
 			break;
 		}
 
@@ -1517,6 +1522,26 @@ xfs_da3_node_lookup_int(
 		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
 
+		/* Tree taller than we can handle; bail out! */
+		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			return -EFSCORRUPTED;
+
+		if (blkno == args->geo->leafblk) {
+			/*
+			 * This is the root node, set up for the
+			 * next level we want to see.
+			 */
+			expected_level = nodehdr.level - 1;
+		} else if (expected_level != nodehdr.level) {
+			/*
+			 * Not the level we were expecting, which
+			 * implies that the tree is bad.
+			 */
+			return -EFSCORRUPTED;
+		} else {
+			expected_level--;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
@@ -1562,8 +1587,15 @@ xfs_da3_node_lookup_int(
 			blk->index = probe;
 			blkno = be32_to_cpu(btree[probe].before);
 		}
+
+		/* We can't point back to the root. */
+		if (blkno == args->geo->leafblk)
+			return -EFSCORRUPTED;
 	}
 
+	if (expected_level != 0)
+		return -EFSCORRUPTED;
+
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
 	 * (final hashval == search hashval) means that the next block may
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 48423eb..9a8dafc 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -222,6 +222,7 @@ xfs_attr_node_list_lookup(
 	struct xfs_trans		*tp = context->tp;
 	int				i;
 	int				error = 0;
+	unsigned int			expected_level = -1U;
 	uint16_t			magic;
 
 	ASSERT(*pbp == NULL);
@@ -236,6 +237,8 @@ xfs_attr_node_list_lookup(
 		switch (magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
+			if (expected_level == -1U)
+				expected_level = 0;
 			goto found_leaf;
 		case XFS_DA_NODE_MAGIC:
 		case XFS_DA3_NODE_MAGIC:
@@ -249,6 +252,26 @@ xfs_attr_node_list_lookup(
 
 		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 
+		/* Tree taller than we can handle; bail out! */
+		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_corruptbuf;
+
+		if (cursor->blkno == 0) {
+			/*
+			 * This is the root node, set up for the
+			 * next level we want to see.
+			 */
+			expected_level = nodehdr.level - 1;
+		} else if (expected_level != nodehdr.level) {
+			/*
+			 * Not the level we were expecting, which
+			 * implies that the tree is bad.
+			 */
+			goto out_corruptbuf;
+		} else {
+			expected_level--;
+		}
+
 		btree = dp->d_ops->node_tree_p(node);
 		for (i = 0; i < nodehdr.count; btree++, i++) {
 			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
@@ -262,15 +285,24 @@ xfs_attr_node_list_lookup(
 			goto out_buf;
 
 		xfs_trans_brelse(tp, *pbp);
+
+		/* We can't point back to the root. */
+		if (cursor->blkno == 0) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 	}
 
 found_leaf:
+	if (expected_level != 0)
+		goto out_corruptbuf;
 	return error;
 
 out_corruptbuf:
 	error = -EFSCORRUPTED;
 out_buf:
 	xfs_trans_brelse(tp, *pbp);
+out:
 	*pbp = NULL;
 	return error;
 }

