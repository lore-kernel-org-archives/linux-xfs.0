Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9A5B7F76
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E148304059
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TMuAcK47ecqXkMDp for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004xH-FH
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005jk-EW
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/19] xfs: vectorise DA btree operations
Date: Tue, 15 Oct 2013 09:18:02 +1100
Message-Id: <1381789085-21923-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1381789085-21923-1-git-send-email-david@fromorbit.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The remaining non-vectorised code for the directory structure is the
node format blocks. This is shared with the attribute tree, and so
is slightly more complex to vectorise.

Introduce a "non-directory" directory ops structure that is attached
to all non-directory inodes so that attribute operations can be
vectorised for all inodes.

Once we do this, we can vectorise all the da btree operations.
Because this patch adds more infrastructure than it removes the
binary size does not decrease:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
 789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
 789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_inactive.c |   3 +-
 fs/xfs/xfs_attr_leaf.c     |   3 +-
 fs/xfs/xfs_attr_list.c     |  11 ++---
 fs/xfs/xfs_da_btree.c      | 104 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_da_format.c     |  59 +++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h     |  25 -----------
 fs/xfs/xfs_dir2.c          |   7 ++-
 fs/xfs/xfs_dir2.h          |   6 +++
 fs/xfs/xfs_iops.c          |   1 +
 fs/xfs/xfs_mount.h         |   1 +
 10 files changed, 139 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f33fb62..4855085 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -40,6 +40,7 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_dinode.h"
+#include "xfs_dir2.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -236,7 +237,7 @@ xfs_attr3_node_inactive(
 		xfs_trans_brelse(*trans, bp);
 		return 0;
 	}
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 	child_fsb = be32_to_cpu(btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index a0f9019..82f1354 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -41,6 +41,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 #include "xfs_dinode.h"
+#include "xfs_dir2.h"
 
 
 /*
@@ -916,7 +917,7 @@ xfs_attr3_leaf_to_node(
 		goto out;
 	node = bp1->b_addr;
 	xfs_da3_node_hdr_from_disk(&icnodehdr, node);
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 
 	leaf = bp2->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(&icleafhdr, leaf);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 46c4ce1..ea1c4c4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -40,6 +40,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 #include "xfs_dinode.h"
+#include "xfs_dir2.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
@@ -226,6 +227,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	struct xfs_da_node_entry *btree;
 	int error, i;
 	struct xfs_buf *bp;
+	struct xfs_inode	*dp = context->dp;
 
 	trace_xfs_attr_node_list(context);
 
@@ -239,7 +241,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da3_node_read(NULL, context->dp, cursor->blkno, -1,
+		error = xfs_da3_node_read(NULL, dp, cursor->blkno, -1,
 					      &bp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
@@ -289,7 +291,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		for (;;) {
 			__uint16_t magic;
 
-			error = xfs_da3_node_read(NULL, context->dp,
+			error = xfs_da3_node_read(NULL, dp,
 						      cursor->blkno, -1, &bp,
 						      XFS_ATTR_FORK);
 			if (error)
@@ -310,7 +312,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			}
 
 			xfs_da3_node_hdr_from_disk(&nodehdr, node);
-			btree = xfs_da3_node_tree_p(node);
+			btree = dp->d_ops->node_tree_p(node);
 			for (i = 0; i < nodehdr.count; btree++, i++) {
 				if (cursor->hashval
 						<= be32_to_cpu(btree->hashval)) {
@@ -346,8 +348,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(NULL, bp);
-		error = xfs_attr3_leaf_read(NULL, context->dp, cursor->blkno, -1,
-					   &bp);
+		error = xfs_attr3_leaf_read(NULL, dp, cursor->blkno, -1, &bp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index df3759c..26dfc42 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -379,7 +379,8 @@ xfs_da3_node_create(
 
 	xfs_da3_node_hdr_to_disk(node, &ichdr);
 	xfs_trans_log_buf(tp, bp,
-		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
+		XFS_DA_LOGRANGE(node, &node->hdr,
+				args->dp->d_ops->node_hdr_size()));
 
 	*bpp = bp;
 	return(0);
@@ -590,7 +591,7 @@ xfs_da3_root_split(
 		struct xfs_da3_icnode_hdr nodehdr;
 
 		xfs_da3_node_hdr_from_disk(&nodehdr, oldroot);
-		btree = xfs_da3_node_tree_p(oldroot);
+		btree = dp->d_ops->node_tree_p(oldroot);
 		size = (int)((char *)&btree[nodehdr.count] - (char *)oldroot);
 		level = nodehdr.level;
 
@@ -650,7 +651,7 @@ xfs_da3_root_split(
 
 	node = bp->b_addr;
 	xfs_da3_node_hdr_from_disk(&nodehdr, node);
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 	btree[0].hashval = cpu_to_be32(blk1->hashval);
 	btree[0].before = cpu_to_be32(blk1->blkno);
 	btree[1].hashval = cpu_to_be32(blk2->hashval);
@@ -793,6 +794,7 @@ xfs_da3_node_rebalance(
 	int			count;
 	int			tmp;
 	int			swap = 0;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_rebalance(state->args);
 
@@ -800,8 +802,8 @@ xfs_da3_node_rebalance(
 	node2 = blk2->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
 	xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
-	btree1 = xfs_da3_node_tree_p(node1);
-	btree2 = xfs_da3_node_tree_p(node2);
+	btree1 = dp->d_ops->node_tree_p(node1);
+	btree2 = dp->d_ops->node_tree_p(node2);
 
 	/*
 	 * Figure out how many entries need to move, and in which direction.
@@ -816,8 +818,8 @@ xfs_da3_node_rebalance(
 		node2 = tmpnode;
 		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
-		btree1 = xfs_da3_node_tree_p(node1);
-		btree2 = xfs_da3_node_tree_p(node2);
+		btree1 = dp->d_ops->node_tree_p(node1);
+		btree2 = dp->d_ops->node_tree_p(node2);
 		swap = 1;
 	}
 
@@ -882,12 +884,12 @@ xfs_da3_node_rebalance(
 	xfs_da3_node_hdr_to_disk(node1, &nodehdr1);
 	xfs_trans_log_buf(tp, blk1->bp,
 		XFS_DA_LOGRANGE(node1, &node1->hdr,
-				xfs_da3_node_hdr_size(node1)));
+				dp->d_ops->node_hdr_size()));
 
 	xfs_da3_node_hdr_to_disk(node2, &nodehdr2);
 	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
-				xfs_da3_node_hdr_size(node2) +
+				dp->d_ops->node_hdr_size() +
 				(sizeof(btree2[0]) * nodehdr2.count)));
 
 	/*
@@ -899,8 +901,8 @@ xfs_da3_node_rebalance(
 		node2 = blk2->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
-		btree1 = xfs_da3_node_tree_p(node1);
-		btree2 = xfs_da3_node_tree_p(node2);
+		btree1 = dp->d_ops->node_tree_p(node1);
+		btree2 = dp->d_ops->node_tree_p(node2);
 	}
 	blk1->hashval = be32_to_cpu(btree1[nodehdr1.count - 1].hashval);
 	blk2->hashval = be32_to_cpu(btree2[nodehdr2.count - 1].hashval);
@@ -927,12 +929,13 @@ xfs_da3_node_add(
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_node_entry *btree;
 	int			tmp;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_add(state->args);
 
 	node = oldblk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(&nodehdr, node);
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 
 	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
 	ASSERT(newblk->blkno != 0);
@@ -957,7 +960,7 @@ xfs_da3_node_add(
 	nodehdr.count += 1;
 	xfs_da3_node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
-		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
+		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
 
 	/*
 	 * Copy the last hash value from the oldblk to propagate upwards.
@@ -1115,7 +1118,7 @@ xfs_da3_root_join(
 	 * Read in the (only) child block, then copy those bytes into
 	 * the root block's buffer and free the original child block.
 	 */
-	btree = xfs_da3_node_tree_p(oldroot);
+	btree = args->dp->d_ops->node_tree_p(oldroot);
 	child = be32_to_cpu(btree[0].before);
 	ASSERT(child != 0);
 	error = xfs_da3_node_read(args->trans, args->dp, child, -1, &bp,
@@ -1275,6 +1278,7 @@ xfs_da3_node_toosmall(
  */
 STATIC uint
 xfs_da3_node_lasthash(
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp,
 	int			*count)
 {
@@ -1288,7 +1292,7 @@ xfs_da3_node_lasthash(
 		*count = nodehdr.count;
 	if (!nodehdr.count)
 		return 0;
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 	return be32_to_cpu(btree[nodehdr.count - 1].hashval);
 }
 
@@ -1307,6 +1311,7 @@ xfs_da3_fixhashpath(
 	xfs_dahash_t		lasthash=0;
 	int			level;
 	int			count;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_fixhashpath(state->args);
 
@@ -1319,13 +1324,12 @@ xfs_da3_fixhashpath(
 			return;
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
-		lasthash = xfs_dir2_leafn_lasthash(state->args->dp,
-						   blk->bp, &count);
+		lasthash = xfs_dir2_leafn_lasthash(dp, blk->bp, &count);
 		if (count == 0)
 			return;
 		break;
 	case XFS_DA_NODE_MAGIC:
-		lasthash = xfs_da3_node_lasthash(blk->bp, &count);
+		lasthash = xfs_da3_node_lasthash(dp, blk->bp, &count);
 		if (count == 0)
 			return;
 		break;
@@ -1335,7 +1339,7 @@ xfs_da3_fixhashpath(
 
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
-		btree = xfs_da3_node_tree_p(node);
+		btree = dp->d_ops->node_tree_p(node);
 		if (be32_to_cpu(btree->hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
@@ -1361,6 +1365,7 @@ xfs_da3_node_remove(
 	struct xfs_da_node_entry *btree;
 	int			index;
 	int			tmp;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_remove(state->args);
 
@@ -1373,7 +1378,7 @@ xfs_da3_node_remove(
 	 * Copy over the offending entry, or just zero it out.
 	 */
 	index = drop_blk->index;
-	btree = xfs_da3_node_tree_p(node);
+	btree = dp->d_ops->node_tree_p(node);
 	if (index < nodehdr.count - 1) {
 		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
@@ -1388,7 +1393,7 @@ xfs_da3_node_remove(
 	nodehdr.count -= 1;
 	xfs_da3_node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
+	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
@@ -1415,6 +1420,7 @@ xfs_da3_node_unbalance(
 	struct xfs_trans	*tp;
 	int			sindex;
 	int			tmp;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_unbalance(state->args);
 
@@ -1422,8 +1428,8 @@ xfs_da3_node_unbalance(
 	save_node = save_blk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(&drop_hdr, drop_node);
 	xfs_da3_node_hdr_from_disk(&save_hdr, save_node);
-	drop_btree = xfs_da3_node_tree_p(drop_node);
-	save_btree = xfs_da3_node_tree_p(save_node);
+	drop_btree = dp->d_ops->node_tree_p(drop_node);
+	save_btree = dp->d_ops->node_tree_p(save_node);
 	tp = state->args->trans;
 
 	/*
@@ -1460,7 +1466,7 @@ xfs_da3_node_unbalance(
 	xfs_da3_node_hdr_to_disk(save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
-				xfs_da3_node_hdr_size(save_node)));
+				dp->d_ops->node_hdr_size()));
 
 	/*
 	 * Save the last hashval in the remaining block for upward propagation.
@@ -1502,6 +1508,7 @@ xfs_da3_node_lookup_int(
 	int			max;
 	int			error;
 	int			retval;
+	struct xfs_inode	*dp = state->args->dp;
 
 	args = state->args;
 
@@ -1550,7 +1557,7 @@ xfs_da3_node_lookup_int(
 		 */
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
-		btree = xfs_da3_node_tree_p(node);
+		btree = dp->d_ops->node_tree_p(node);
 
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
@@ -1645,6 +1652,7 @@ xfs_da3_node_lookup_int(
  */
 STATIC int
 xfs_da3_node_order(
+	struct xfs_inode *dp,
 	struct xfs_buf	*node1_bp,
 	struct xfs_buf	*node2_bp)
 {
@@ -1659,8 +1667,8 @@ xfs_da3_node_order(
 	node2 = node2_bp->b_addr;
 	xfs_da3_node_hdr_from_disk(&node1hdr, node1);
 	xfs_da3_node_hdr_from_disk(&node2hdr, node2);
-	btree1 = xfs_da3_node_tree_p(node1);
-	btree2 = xfs_da3_node_tree_p(node2);
+	btree1 = dp->d_ops->node_tree_p(node1);
+	btree2 = dp->d_ops->node_tree_p(node2);
 
 	if (node1hdr.count > 0 && node2hdr.count > 0 &&
 	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
@@ -1687,6 +1695,7 @@ xfs_da3_blk_link(
 	struct xfs_buf		*bp;
 	int			before = 0;
 	int			error;
+	struct xfs_inode	*dp = state->args->dp;
 
 	/*
 	 * Set up environment.
@@ -1704,10 +1713,10 @@ xfs_da3_blk_link(
 		before = xfs_attr_leaf_order(old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
-		before = xfs_dir2_leafn_order(args->dp, old_blk->bp, new_blk->bp);
+		before = xfs_dir2_leafn_order(dp, old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DA_NODE_MAGIC:
-		before = xfs_da3_node_order(old_blk->bp, new_blk->bp);
+		before = xfs_da3_node_order(dp, old_blk->bp, new_blk->bp);
 		break;
 	}
 
@@ -1722,7 +1731,7 @@ xfs_da3_blk_link(
 		new_info->forw = cpu_to_be32(old_blk->blkno);
 		new_info->back = old_info->back;
 		if (old_info->back) {
-			error = xfs_da3_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1743,7 +1752,7 @@ xfs_da3_blk_link(
 		new_info->forw = old_info->forw;
 		new_info->back = cpu_to_be32(old_blk->blkno);
 		if (old_info->forw) {
-			error = xfs_da3_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1863,6 +1872,7 @@ xfs_da3_path_shift(
 	xfs_dablk_t		blkno = 0;
 	int			level;
 	int			error;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_path_shift(state->args);
 
@@ -1879,7 +1889,7 @@ xfs_da3_path_shift(
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
-		btree = xfs_da3_node_tree_p(node);
+		btree = dp->d_ops->node_tree_p(node);
 
 		if (forward && (blk->index < nodehdr.count - 1)) {
 			blk->index++;
@@ -1913,7 +1923,7 @@ xfs_da3_path_shift(
 		 * Read the next child block.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da3_node_read(args->trans, args->dp, blkno, -1,
+		error = xfs_da3_node_read(args->trans, dp, blkno, -1,
 					&blk->bp, args->whichfork);
 		if (error)
 			return(error);
@@ -1936,7 +1946,7 @@ xfs_da3_path_shift(
 			blk->magic = XFS_DA_NODE_MAGIC;
 			node = (xfs_da_intnode_t *)info;
 			xfs_da3_node_hdr_from_disk(&nodehdr, node);
-			btree = xfs_da3_node_tree_p(node);
+			btree = dp->d_ops->node_tree_p(node);
 			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 			if (forward)
 				blk->index = 0;
@@ -2164,7 +2174,7 @@ xfs_da3_swap_lastblock(
 	struct xfs_dir2_leaf	*dead_leaf2;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr par_hdr;
-	struct xfs_inode	*ip;
+	struct xfs_inode	*dp;
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp;
 	struct xfs_buf		*dead_buf;
@@ -2188,12 +2198,12 @@ xfs_da3_swap_lastblock(
 	dead_buf = *dead_bufp;
 	dead_blkno = *dead_blknop;
 	tp = args->trans;
-	ip = args->dp;
+	dp = args->dp;
 	w = args->whichfork;
 	ASSERT(w == XFS_DATA_FORK);
-	mp = ip->i_mount;
+	mp = dp->i_mount;
 	lastoff = mp->m_dirfreeblk;
-	error = xfs_bmap_last_before(tp, ip, &lastoff, w);
+	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
 	if (unlikely(lastoff == 0)) {
@@ -2205,7 +2215,7 @@ xfs_da3_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
-	error = xfs_da3_node_read(tp, ip, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -2224,7 +2234,7 @@ xfs_da3_swap_lastblock(
 
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
 		xfs_dir3_leaf_hdr_from_disk(&leafhdr, dead_leaf2);
-		ents = ip->d_ops->leaf_ents_p(dead_leaf2);
+		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
 	} else {
@@ -2232,7 +2242,7 @@ xfs_da3_swap_lastblock(
 
 		dead_node = (xfs_da_intnode_t *)dead_info;
 		xfs_da3_node_hdr_from_disk(&deadhdr, dead_node);
-		btree = xfs_da3_node_tree_p(dead_node);
+		btree = dp->d_ops->node_tree_p(dead_node);
 		dead_level = deadhdr.level;
 		dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
 	}
@@ -2241,7 +2251,7 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da3_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2263,7 +2273,7 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da3_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2287,7 +2297,7 @@ xfs_da3_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2299,7 +2309,7 @@ xfs_da3_swap_lastblock(
 			goto done;
 		}
 		level = par_hdr.level;
-		btree = xfs_da3_node_tree_p(par_node);
+		btree = dp->d_ops->node_tree_p(par_node);
 		for (entno = 0;
 		     entno < par_hdr.count &&
 		     be32_to_cpu(btree[entno].hashval) < dead_hash;
@@ -2338,7 +2348,7 @@ xfs_da3_swap_lastblock(
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2349,7 +2359,7 @@ xfs_da3_swap_lastblock(
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		btree = xfs_da3_node_tree_p(par_node);
+		btree = dp->d_ops->node_tree_p(par_node);
 		entno = 0;
 	}
 	/*
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index ff8b503..72b48b5 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -477,6 +477,33 @@ xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
 	return ((struct xfs_dir3_leaf *)lp)->__ents;
 }
 
+/*
+ * Directory/Attribute Node block operations
+ */
+static inline int
+xfs_da2_node_hdr_size(void)
+{
+	return sizeof(struct xfs_da_node_hdr);
+}
+
+static struct xfs_da_node_entry *
+xfs_da2_node_tree_p(struct xfs_da_intnode *dap)
+{
+	return dap->__btree;
+}
+
+static inline int
+xfs_da3_node_hdr_size(void)
+{
+	return sizeof(struct xfs_da3_node_hdr);
+}
+
+static inline struct xfs_da_node_entry *
+xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
+{
+	return ((struct xfs_da3_intnode *)dap)->__btree;
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -508,6 +535,8 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
+	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -540,6 +569,9 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
+
+	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -572,6 +604,19 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
+
+	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_tree_p = xfs_da3_node_tree_p,
+};
+
+const struct xfs_dir_ops xfs_dir2_nondir_ops = {
+	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_tree_p = xfs_da2_node_tree_p,
+};
+
+const struct xfs_dir_ops xfs_dir3_nondir_ops = {
+	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_tree_p = xfs_da3_node_tree_p,
 };
 
 /*
@@ -594,3 +639,17 @@ xfs_dir_get_ops(
 		return &xfs_dir2_ftype_ops;
 	return &xfs_dir2_ops;
 }
+
+const struct xfs_dir_ops *
+xfs_nondir_get_ops(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*dp)
+{
+	if (dp)
+		return dp->d_ops;
+	if (mp->m_nondir_inode_ops)
+		return mp->m_nondir_inode_ops;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return &xfs_dir3_nondir_ops;
+	return &xfs_dir2_nondir_ops;
+}
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 0a567e2..69b4c6e 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -127,31 +127,6 @@ extern void xfs_da3_node_hdr_from_disk(struct xfs_da3_icnode_hdr *to,
 extern void xfs_da3_node_hdr_to_disk(struct xfs_da_intnode *to,
 				     struct xfs_da3_icnode_hdr *from);
 
-static inline int
-__xfs_da3_node_hdr_size(bool v3)
-{
-	if (v3)
-		return sizeof(struct xfs_da3_node_hdr);
-	return sizeof(struct xfs_da_node_hdr);
-}
-static inline int
-xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
-{
-	bool	v3 = dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC);
-
-	return __xfs_da3_node_hdr_size(v3);
-}
-
-static inline struct xfs_da_node_entry *
-xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
-{
-	if (dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
-		struct xfs_da3_intnode *dap3 = (struct xfs_da3_intnode *)dap;
-		return dap3->__btree;
-	}
-	return dap->__btree;
-}
-
 extern void xfs_da3_intnode_from_disk(struct xfs_da3_icnode_hdr *to,
 				      struct xfs_da_intnode *from);
 extern void xfs_da3_intnode_to_disk(struct xfs_da_intnode *to,
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 2b98a33..1b44e83 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -95,13 +95,17 @@ xfs_dir_mount(
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 	ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
 	       XFS_MAX_BLOCKSIZE);
+
+	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
+	mp->m_nondir_inode_ops = xfs_nondir_get_ops(mp, NULL);
+
 	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
 	mp->m_dirblkfsbs = 1 << mp->m_sb.sb_dirblklog;
 	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
 	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
 	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
 
-	nodehdr_size = __xfs_da3_node_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
+	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size();
 	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_node_ents = (mp->m_dirblksize - nodehdr_size) /
@@ -113,7 +117,6 @@ xfs_dir_mount(
 	else
 		mp->m_dirnameops = &xfs_default_nameops;
 
-	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 9ba9db7..c5cad9d 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -79,10 +79,16 @@ struct xfs_dir_ops {
 	int	(*leaf_max_ents)(struct xfs_mount *mp);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
+
+	int	(*node_hdr_size)(void);
+	struct xfs_da_node_entry *
+		(*node_tree_p)(struct xfs_da_intnode *dap);
 };
 
 extern const struct xfs_dir_ops *
 	xfs_dir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
+extern const struct xfs_dir_ops *
+	xfs_nondir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
 
 /*
  * Generic directory interface routines
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 66cfdbf..6cd5c16 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1200,6 +1200,7 @@ xfs_setup_inode(
 	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
 	xfs_diflags_to_iflags(inode, ip);
 
+	ip->d_ops = ip->i_mount->m_nondir_inode_ops;
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 973397f..1d8101a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -150,6 +150,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
+	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
