Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 806F37F72
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B7918F8052
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:22 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GZvMy7UCRa4faPyK for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DN-0000Pc-36
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DN-00087h-1h
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/15] xfs: vectorise encoding/decoding directory headers
Date: Tue, 29 Oct 2013 22:11:52 +1100
Message-Id: <1383045118-31107-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Conversion from on-disk structures to in-core header structures
currently relies on magic number checks. If the magic number is
wrong, but one of the supported values, we do the wrong thing with
the encode/decode operation. Split these functions so that there are
discrete operations for the specific directory format we are
handling.

In doing this, move all the header encode/decode functions to
xfs_da_format.c as they are directly manipulating the on-disk
format. It should be noted that all the growth in binary size is
from xfs_da_format.c - the rest of the code actaully shrinks.

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
 789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
 789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
 791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_inactive.c |   2 +-
 fs/xfs/xfs_attr_leaf.c     |   4 +-
 fs/xfs/xfs_attr_list.c     |   2 +-
 fs/xfs/xfs_da_btree.c      | 141 +++++++++++-------------------
 fs/xfs/xfs_da_format.c     | 209 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_da_format.h     |  16 ----
 fs/xfs/xfs_dir2.h          |  13 +++
 fs/xfs/xfs_dir2_block.c    |   2 +-
 fs/xfs/xfs_dir2_leaf.c     | 100 ++++++----------------
 fs/xfs/xfs_dir2_node.c     | 126 +++++++++------------------
 fs/xfs/xfs_dir2_priv.h     |   4 -
 11 files changed, 338 insertions(+), 281 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 4855085..09480c5 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -231,7 +231,7 @@ xfs_attr3_node_inactive(
 	}
 
 	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&ichdr, node);
+	dp->d_ops->node_hdr_from_disk(&ichdr, node);
 	parent_blkno = bp->b_bn;
 	if (!ichdr.count) {
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 82f1354..fdf9992 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -916,7 +916,7 @@ xfs_attr3_leaf_to_node(
 	if (error)
 		goto out;
 	node = bp1->b_addr;
-	xfs_da3_node_hdr_from_disk(&icnodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&icnodehdr, node);
 	btree = dp->d_ops->node_tree_p(node);
 
 	leaf = bp2->b_addr;
@@ -927,7 +927,7 @@ xfs_attr3_leaf_to_node(
 	btree[0].hashval = entries[icleafhdr.count - 1].hashval;
 	btree[0].before = cpu_to_be32(blkno);
 	icnodehdr.count = 1;
-	xfs_da3_node_hdr_to_disk(node, &icnodehdr);
+	dp->d_ops->node_hdr_to_disk(node, &icnodehdr);
 	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(mp) - 1);
 	error = 0;
 out:
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index ea1c4c4..2d174b1 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -311,7 +311,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 
-			xfs_da3_node_hdr_from_disk(&nodehdr, node);
+			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 			btree = dp->d_ops->node_tree_p(node);
 			for (i = 0; i < nodehdr.count; btree++, i++) {
 				if (cursor->hashval
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 26dfc42..a51762d 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -129,56 +129,6 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_zone_free(xfs_da_state_zone, state);
 }
 
-void
-xfs_da3_node_hdr_from_disk(
-	struct xfs_da3_icnode_hdr	*to,
-	struct xfs_da_intnode		*from)
-{
-	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
-	       from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
-
-	if (from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
-		struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)from;
-
-		to->forw = be32_to_cpu(hdr3->info.hdr.forw);
-		to->back = be32_to_cpu(hdr3->info.hdr.back);
-		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
-		to->count = be16_to_cpu(hdr3->__count);
-		to->level = be16_to_cpu(hdr3->__level);
-		return;
-	}
-	to->forw = be32_to_cpu(from->hdr.info.forw);
-	to->back = be32_to_cpu(from->hdr.info.back);
-	to->magic = be16_to_cpu(from->hdr.info.magic);
-	to->count = be16_to_cpu(from->hdr.__count);
-	to->level = be16_to_cpu(from->hdr.__level);
-}
-
-void
-xfs_da3_node_hdr_to_disk(
-	struct xfs_da_intnode		*to,
-	struct xfs_da3_icnode_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DA_NODE_MAGIC ||
-	       from->magic == XFS_DA3_NODE_MAGIC);
-
-	if (from->magic == XFS_DA3_NODE_MAGIC) {
-		struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)to;
-
-		hdr3->info.hdr.forw = cpu_to_be32(from->forw);
-		hdr3->info.hdr.back = cpu_to_be32(from->back);
-		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
-		hdr3->__count = cpu_to_be16(from->count);
-		hdr3->__level = cpu_to_be16(from->level);
-		return;
-	}
-	to->hdr.info.forw = cpu_to_be32(from->forw);
-	to->hdr.info.back = cpu_to_be32(from->back);
-	to->hdr.info.magic = cpu_to_be16(from->magic);
-	to->hdr.__count = cpu_to_be16(from->count);
-	to->hdr.__level = cpu_to_be16(from->level);
-}
-
 static bool
 xfs_da3_node_verify(
 	struct xfs_buf		*bp)
@@ -186,8 +136,11 @@ xfs_da3_node_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_da_intnode	*hdr = bp->b_addr;
 	struct xfs_da3_icnode_hdr ichdr;
+	const struct xfs_dir_ops *ops;
+
+	ops = xfs_dir_get_ops(mp, NULL);
 
-	xfs_da3_node_hdr_from_disk(&ichdr, hdr);
+	ops->node_hdr_from_disk(&ichdr, hdr);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
@@ -354,11 +307,12 @@ xfs_da3_node_create(
 	struct xfs_da3_icnode_hdr ichdr = {0};
 	struct xfs_buf		*bp;
 	int			error;
+	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_da_node_create(args);
 	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
 
-	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
 	if (error)
 		return(error);
 	bp->b_ops = &xfs_da3_node_buf_ops;
@@ -377,10 +331,10 @@ xfs_da3_node_create(
 	}
 	ichdr.level = level;
 
-	xfs_da3_node_hdr_to_disk(node, &ichdr);
+	dp->d_ops->node_hdr_to_disk(node, &ichdr);
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr,
-				args->dp->d_ops->node_hdr_size()));
+				dp->d_ops->node_hdr_size()));
 
 	*bpp = bp;
 	return(0);
@@ -590,7 +544,7 @@ xfs_da3_root_split(
 	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
 		struct xfs_da3_icnode_hdr nodehdr;
 
-		xfs_da3_node_hdr_from_disk(&nodehdr, oldroot);
+		dp->d_ops->node_hdr_from_disk(&nodehdr, oldroot);
 		btree = dp->d_ops->node_tree_p(oldroot);
 		size = (int)((char *)&btree[nodehdr.count] - (char *)oldroot);
 		level = nodehdr.level;
@@ -605,7 +559,7 @@ xfs_da3_root_split(
 		struct xfs_dir2_leaf_entry *ents;
 
 		leaf = (xfs_dir2_leaf_t *)oldroot;
-		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+		dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
@@ -650,14 +604,14 @@ xfs_da3_root_split(
 		return error;
 
 	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	btree = dp->d_ops->node_tree_p(node);
 	btree[0].hashval = cpu_to_be32(blk1->hashval);
 	btree[0].before = cpu_to_be32(blk1->blkno);
 	btree[1].hashval = cpu_to_be32(blk2->hashval);
 	btree[1].before = cpu_to_be32(blk2->blkno);
 	nodehdr.count = 2;
-	xfs_da3_node_hdr_to_disk(node, &nodehdr);
+	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
 
 #ifdef DEBUG
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
@@ -694,11 +648,12 @@ xfs_da3_node_split(
 	int			newcount;
 	int			error;
 	int			useextra;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_split(state->args);
 
 	node = oldblk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 
 	/*
 	 * With V2 dirs the extra block is data or freespace.
@@ -745,7 +700,7 @@ xfs_da3_node_split(
 	 * If we had double-split op below us, then add the extra block too.
 	 */
 	node = oldblk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	if (oldblk->index <= nodehdr.count) {
 		oldblk->index++;
 		xfs_da3_node_add(state, oldblk, addblk);
@@ -800,8 +755,8 @@ xfs_da3_node_rebalance(
 
 	node1 = blk1->bp->b_addr;
 	node2 = blk2->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
-	xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+	dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
+	dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
 	btree1 = dp->d_ops->node_tree_p(node1);
 	btree2 = dp->d_ops->node_tree_p(node2);
 
@@ -816,8 +771,8 @@ xfs_da3_node_rebalance(
 		tmpnode = node1;
 		node1 = node2;
 		node2 = tmpnode;
-		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
-		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+		dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
+		dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
 		btree1 = dp->d_ops->node_tree_p(node1);
 		btree2 = dp->d_ops->node_tree_p(node2);
 		swap = 1;
@@ -881,12 +836,12 @@ xfs_da3_node_rebalance(
 	/*
 	 * Log header of node 1 and all current bits of node 2.
 	 */
-	xfs_da3_node_hdr_to_disk(node1, &nodehdr1);
+	dp->d_ops->node_hdr_to_disk(node1, &nodehdr1);
 	xfs_trans_log_buf(tp, blk1->bp,
 		XFS_DA_LOGRANGE(node1, &node1->hdr,
 				dp->d_ops->node_hdr_size()));
 
-	xfs_da3_node_hdr_to_disk(node2, &nodehdr2);
+	dp->d_ops->node_hdr_to_disk(node2, &nodehdr2);
 	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
 				dp->d_ops->node_hdr_size() +
@@ -899,8 +854,8 @@ xfs_da3_node_rebalance(
 	if (swap) {
 		node1 = blk1->bp->b_addr;
 		node2 = blk2->bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
-		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+		dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
+		dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
 		btree1 = dp->d_ops->node_tree_p(node1);
 		btree2 = dp->d_ops->node_tree_p(node2);
 	}
@@ -934,7 +889,7 @@ xfs_da3_node_add(
 	trace_xfs_da_node_add(state->args);
 
 	node = oldblk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	btree = dp->d_ops->node_tree_p(node);
 
 	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
@@ -958,7 +913,7 @@ xfs_da3_node_add(
 				tmp + sizeof(*btree)));
 
 	nodehdr.count += 1;
-	xfs_da3_node_hdr_to_disk(node, &nodehdr);
+	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
 
@@ -1097,6 +1052,7 @@ xfs_da3_root_join(
 	struct xfs_da3_icnode_hdr oldroothdr;
 	struct xfs_da_node_entry *btree;
 	int			error;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_root_join(state->args);
 
@@ -1104,7 +1060,7 @@ xfs_da3_root_join(
 
 	args = state->args;
 	oldroot = root_blk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&oldroothdr, oldroot);
+	dp->d_ops->node_hdr_from_disk(&oldroothdr, oldroot);
 	ASSERT(oldroothdr.forw == 0);
 	ASSERT(oldroothdr.back == 0);
 
@@ -1118,10 +1074,10 @@ xfs_da3_root_join(
 	 * Read in the (only) child block, then copy those bytes into
 	 * the root block's buffer and free the original child block.
 	 */
-	btree = args->dp->d_ops->node_tree_p(oldroot);
+	btree = dp->d_ops->node_tree_p(oldroot);
 	child = be32_to_cpu(btree[0].before);
 	ASSERT(child != 0);
-	error = xfs_da3_node_read(args->trans, args->dp, child, -1, &bp,
+	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
 					     args->whichfork);
 	if (error)
 		return error;
@@ -1171,6 +1127,7 @@ xfs_da3_node_toosmall(
 	int			error;
 	int			retval;
 	int			i;
+	struct xfs_inode	*dp = state->args->dp;
 
 	trace_xfs_da_node_toosmall(state->args);
 
@@ -1182,7 +1139,7 @@ xfs_da3_node_toosmall(
 	blk = &state->path.blk[ state->path.active-1 ];
 	info = blk->bp->b_addr;
 	node = (xfs_da_intnode_t *)info;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	if (nodehdr.count > (state->node_ents >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return(0);	/* blk over 50%, don't try to join */
@@ -1234,13 +1191,13 @@ xfs_da3_node_toosmall(
 			blkno = nodehdr.back;
 		if (blkno == 0)
 			continue;
-		error = xfs_da3_node_read(state->args->trans, state->args->dp,
+		error = xfs_da3_node_read(state->args->trans, dp,
 					blkno, -1, &bp, state->args->whichfork);
 		if (error)
 			return(error);
 
 		node = bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&thdr, node);
+		dp->d_ops->node_hdr_from_disk(&thdr, node);
 		xfs_trans_brelse(state->args->trans, bp);
 
 		if (count - thdr.count >= 0)
@@ -1287,7 +1244,7 @@ xfs_da3_node_lasthash(
 	struct xfs_da3_icnode_hdr nodehdr;
 
 	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	if (count)
 		*count = nodehdr.count;
 	if (!nodehdr.count)
@@ -1338,7 +1295,7 @@ xfs_da3_fixhashpath(
 		struct xfs_da3_icnode_hdr nodehdr;
 
 		node = blk->bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
 		if (be32_to_cpu(btree->hashval) == lasthash)
 			break;
@@ -1370,7 +1327,7 @@ xfs_da3_node_remove(
 	trace_xfs_da_node_remove(state->args);
 
 	node = drop_blk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	ASSERT(drop_blk->index < nodehdr.count);
 	ASSERT(drop_blk->index >= 0);
 
@@ -1391,7 +1348,7 @@ xfs_da3_node_remove(
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
-	xfs_da3_node_hdr_to_disk(node, &nodehdr);
+	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
 
@@ -1426,8 +1383,8 @@ xfs_da3_node_unbalance(
 
 	drop_node = drop_blk->bp->b_addr;
 	save_node = save_blk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&drop_hdr, drop_node);
-	xfs_da3_node_hdr_from_disk(&save_hdr, save_node);
+	dp->d_ops->node_hdr_from_disk(&drop_hdr, drop_node);
+	dp->d_ops->node_hdr_from_disk(&save_hdr, save_node);
 	drop_btree = dp->d_ops->node_tree_p(drop_node);
 	save_btree = dp->d_ops->node_tree_p(save_node);
 	tp = state->args->trans;
@@ -1463,7 +1420,7 @@ xfs_da3_node_unbalance(
 	memcpy(&save_btree[sindex], &drop_btree[0], tmp);
 	save_hdr.count += drop_hdr.count;
 
-	xfs_da3_node_hdr_to_disk(save_node, &save_hdr);
+	dp->d_ops->node_hdr_to_disk(save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
 				dp->d_ops->node_hdr_size()));
@@ -1556,7 +1513,7 @@ xfs_da3_node_lookup_int(
 		 * Search an intermediate node for a match.
 		 */
 		node = blk->bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
 
 		max = nodehdr.count;
@@ -1665,8 +1622,8 @@ xfs_da3_node_order(
 
 	node1 = node1_bp->b_addr;
 	node2 = node2_bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&node1hdr, node1);
-	xfs_da3_node_hdr_from_disk(&node2hdr, node2);
+	dp->d_ops->node_hdr_from_disk(&node1hdr, node1);
+	dp->d_ops->node_hdr_from_disk(&node2hdr, node2);
 	btree1 = dp->d_ops->node_tree_p(node1);
 	btree2 = dp->d_ops->node_tree_p(node2);
 
@@ -1888,7 +1845,7 @@ xfs_da3_path_shift(
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
 		node = blk->bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
 
 		if (forward && (blk->index < nodehdr.count - 1)) {
@@ -1945,7 +1902,7 @@ xfs_da3_path_shift(
 		case XFS_DA3_NODE_MAGIC:
 			blk->magic = XFS_DA_NODE_MAGIC;
 			node = (xfs_da_intnode_t *)info;
-			xfs_da3_node_hdr_from_disk(&nodehdr, node);
+			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 			btree = dp->d_ops->node_tree_p(node);
 			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 			if (forward)
@@ -2233,7 +2190,7 @@ xfs_da3_swap_lastblock(
 		struct xfs_dir2_leaf_entry *ents;
 
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
-		xfs_dir3_leaf_hdr_from_disk(&leafhdr, dead_leaf2);
+		dp->d_ops->leaf_hdr_from_disk(&leafhdr, dead_leaf2);
 		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
@@ -2241,7 +2198,7 @@ xfs_da3_swap_lastblock(
 		struct xfs_da3_icnode_hdr deadhdr;
 
 		dead_node = (xfs_da_intnode_t *)dead_info;
-		xfs_da3_node_hdr_from_disk(&deadhdr, dead_node);
+		dp->d_ops->node_hdr_from_disk(&deadhdr, dead_node);
 		btree = dp->d_ops->node_tree_p(dead_node);
 		dead_level = deadhdr.level;
 		dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
@@ -2301,7 +2258,7 @@ xfs_da3_swap_lastblock(
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
-		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
+		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
 		if (level >= 0 && level != par_hdr.level + 1) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
 					 XFS_ERRLEVEL_LOW, mp);
@@ -2352,7 +2309,7 @@ xfs_da3_swap_lastblock(
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
-		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
+		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
 		if (par_hdr.level != level) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
 					 XFS_ERRLEVEL_LOW, mp);
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 72b48b5..b232c27 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -464,19 +464,84 @@ xfs_dir3_leaf_hdr_size(void)
 	return sizeof(struct xfs_dir3_leaf_hdr);
 }
 
-static inline int
+static int
 xfs_dir3_max_leaf_ents(struct xfs_mount *mp)
 {
 	return (mp->m_dirblksize - xfs_dir3_leaf_hdr_size()) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
-static inline struct xfs_dir2_leaf_entry *
+static struct xfs_dir2_leaf_entry *
 xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
 {
 	return ((struct xfs_dir3_leaf *)lp)->__ents;
 }
 
+static void
+xfs_dir2_leaf_hdr_from_disk(
+	struct xfs_dir3_icleaf_hdr	*to,
+	struct xfs_dir2_leaf		*from)
+{
+	to->forw = be32_to_cpu(from->hdr.info.forw);
+	to->back = be32_to_cpu(from->hdr.info.back);
+	to->magic = be16_to_cpu(from->hdr.info.magic);
+	to->count = be16_to_cpu(from->hdr.count);
+	to->stale = be16_to_cpu(from->hdr.stale);
+
+	ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
+	       to->magic == XFS_DIR2_LEAFN_MAGIC);
+}
+
+static void
+xfs_dir2_leaf_hdr_to_disk(
+	struct xfs_dir2_leaf		*to,
+	struct xfs_dir3_icleaf_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
+	       from->magic == XFS_DIR2_LEAFN_MAGIC);
+
+	to->hdr.info.forw = cpu_to_be32(from->forw);
+	to->hdr.info.back = cpu_to_be32(from->back);
+	to->hdr.info.magic = cpu_to_be16(from->magic);
+	to->hdr.count = cpu_to_be16(from->count);
+	to->hdr.stale = cpu_to_be16(from->stale);
+}
+
+static void
+xfs_dir3_leaf_hdr_from_disk(
+	struct xfs_dir3_icleaf_hdr	*to,
+	struct xfs_dir2_leaf		*from)
+{
+	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)from;
+
+	to->forw = be32_to_cpu(hdr3->info.hdr.forw);
+	to->back = be32_to_cpu(hdr3->info.hdr.back);
+	to->magic = be16_to_cpu(hdr3->info.hdr.magic);
+	to->count = be16_to_cpu(hdr3->count);
+	to->stale = be16_to_cpu(hdr3->stale);
+
+	ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
+	       to->magic == XFS_DIR3_LEAFN_MAGIC);
+}
+
+static void
+xfs_dir3_leaf_hdr_to_disk(
+	struct xfs_dir2_leaf		*to,
+	struct xfs_dir3_icleaf_hdr	*from)
+{
+	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)to;
+
+	ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
+	       from->magic == XFS_DIR3_LEAFN_MAGIC);
+
+	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
+	hdr3->info.hdr.back = cpu_to_be32(from->back);
+	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
+	hdr3->count = cpu_to_be16(from->count);
+	hdr3->stale = cpu_to_be16(from->stale);
+}
+
+
 /*
  * Directory/Attribute Node block operations
  */
@@ -504,6 +569,121 @@ xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
 	return ((struct xfs_da3_intnode *)dap)->__btree;
 }
 
+static void
+xfs_da2_node_hdr_from_disk(
+	struct xfs_da3_icnode_hdr	*to,
+	struct xfs_da_intnode		*from)
+{
+	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	to->forw = be32_to_cpu(from->hdr.info.forw);
+	to->back = be32_to_cpu(from->hdr.info.back);
+	to->magic = be16_to_cpu(from->hdr.info.magic);
+	to->count = be16_to_cpu(from->hdr.__count);
+	to->level = be16_to_cpu(from->hdr.__level);
+}
+
+static void
+xfs_da2_node_hdr_to_disk(
+	struct xfs_da_intnode		*to,
+	struct xfs_da3_icnode_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DA_NODE_MAGIC);
+	to->hdr.info.forw = cpu_to_be32(from->forw);
+	to->hdr.info.back = cpu_to_be32(from->back);
+	to->hdr.info.magic = cpu_to_be16(from->magic);
+	to->hdr.__count = cpu_to_be16(from->count);
+	to->hdr.__level = cpu_to_be16(from->level);
+}
+
+static void
+xfs_da3_node_hdr_from_disk(
+	struct xfs_da3_icnode_hdr	*to,
+	struct xfs_da_intnode		*from)
+{
+	struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)from;
+
+	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
+	to->forw = be32_to_cpu(hdr3->info.hdr.forw);
+	to->back = be32_to_cpu(hdr3->info.hdr.back);
+	to->magic = be16_to_cpu(hdr3->info.hdr.magic);
+	to->count = be16_to_cpu(hdr3->__count);
+	to->level = be16_to_cpu(hdr3->__level);
+}
+
+static void
+xfs_da3_node_hdr_to_disk(
+	struct xfs_da_intnode		*to,
+	struct xfs_da3_icnode_hdr	*from)
+{
+	struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)to;
+
+	ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
+	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
+	hdr3->info.hdr.back = cpu_to_be32(from->back);
+	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
+	hdr3->__count = cpu_to_be16(from->count);
+	hdr3->__level = cpu_to_be16(from->level);
+}
+
+
+/*
+ * Directory free space block operations
+ */
+static void
+xfs_dir2_free_hdr_from_disk(
+	struct xfs_dir3_icfree_hdr	*to,
+	struct xfs_dir2_free		*from)
+{
+	to->magic = be32_to_cpu(from->hdr.magic);
+	to->firstdb = be32_to_cpu(from->hdr.firstdb);
+	to->nvalid = be32_to_cpu(from->hdr.nvalid);
+	to->nused = be32_to_cpu(from->hdr.nused);
+	ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
+}
+
+static void
+xfs_dir2_free_hdr_to_disk(
+	struct xfs_dir2_free		*to,
+	struct xfs_dir3_icfree_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DIR2_FREE_MAGIC);
+
+	to->hdr.magic = cpu_to_be32(from->magic);
+	to->hdr.firstdb = cpu_to_be32(from->firstdb);
+	to->hdr.nvalid = cpu_to_be32(from->nvalid);
+	to->hdr.nused = cpu_to_be32(from->nused);
+}
+
+static void
+xfs_dir3_free_hdr_from_disk(
+	struct xfs_dir3_icfree_hdr	*to,
+	struct xfs_dir2_free		*from)
+{
+	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)from;
+
+	to->magic = be32_to_cpu(hdr3->hdr.magic);
+	to->firstdb = be32_to_cpu(hdr3->firstdb);
+	to->nvalid = be32_to_cpu(hdr3->nvalid);
+	to->nused = be32_to_cpu(hdr3->nused);
+
+	ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
+}
+
+static void
+xfs_dir3_free_hdr_to_disk(
+	struct xfs_dir2_free		*to,
+	struct xfs_dir3_icfree_hdr	*from)
+{
+	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)to;
+
+	ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
+
+	hdr3->hdr.magic = cpu_to_be32(from->magic);
+	hdr3->firstdb = cpu_to_be32(from->firstdb);
+	hdr3->nvalid = cpu_to_be32(from->nvalid);
+	hdr3->nused = cpu_to_be32(from->nused);
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -532,11 +712,18 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
+	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
+	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
+
+	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
+	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -567,11 +754,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
+	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
+	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
+
+	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
+	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -602,20 +796,31 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_unused_p = xfs_dir3_data_unused_p,
 
 	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
+	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
+	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
 	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
+	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
+
+	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
+	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
 };
 
 const struct xfs_dir_ops xfs_dir2_nondir_ops = {
 	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
+	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_nondir_ops = {
 	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
+	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 };
 
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 69b4c6e..1ff7b9f 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -122,16 +122,6 @@ struct xfs_da3_icnode_hdr {
 	__uint16_t	level;
 };
 
-extern void xfs_da3_node_hdr_from_disk(struct xfs_da3_icnode_hdr *to,
-				       struct xfs_da_intnode *from);
-extern void xfs_da3_node_hdr_to_disk(struct xfs_da_intnode *to,
-				     struct xfs_da3_icnode_hdr *from);
-
-extern void xfs_da3_intnode_from_disk(struct xfs_da3_icnode_hdr *to,
-				      struct xfs_da_intnode *from);
-extern void xfs_da3_intnode_to_disk(struct xfs_da_intnode *to,
-				    struct xfs_da3_icnode_hdr *from);
-
 #define	XFS_LBSIZE(mp)	(mp)->m_sb.sb_blocksize
 
 /*
@@ -523,9 +513,6 @@ struct xfs_dir3_leaf {
 
 #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
 
-extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
-					struct xfs_dir2_leaf *from);
-
 /*
  * Get address of the bestcount field in the single-leaf block.
  */
@@ -717,9 +704,6 @@ struct xfs_dir3_icfree_hdr {
 
 };
 
-void xfs_dir3_free_hdr_from_disk(struct xfs_dir3_icfree_hdr *to,
-				 struct xfs_dir2_free *from);
-
 static inline int
 xfs_dir3_free_hdr_size(struct xfs_mount *mp)
 {
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index c5cad9d..6119534 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -76,13 +76,26 @@ struct xfs_dir_ops {
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
 	int	(*leaf_hdr_size)(void);
+	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
+				    struct xfs_dir3_icleaf_hdr *from);
+	void	(*leaf_hdr_from_disk)(struct xfs_dir3_icleaf_hdr *to,
+				      struct xfs_dir2_leaf *from);
 	int	(*leaf_max_ents)(struct xfs_mount *mp);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
 	int	(*node_hdr_size)(void);
+	void	(*node_hdr_to_disk)(struct xfs_da_intnode *to,
+				    struct xfs_da3_icnode_hdr *from);
+	void	(*node_hdr_from_disk)(struct xfs_da3_icnode_hdr *to,
+				      struct xfs_da_intnode *from);
 	struct xfs_da_node_entry *
 		(*node_tree_p)(struct xfs_da_intnode *dap);
+
+	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
+				    struct xfs_dir3_icfree_hdr *from);
+	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
+				      struct xfs_dir2_free *from);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 75f8157..c1ff552 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -936,7 +936,7 @@ xfs_dir2_leaf_to_block(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 16fdc0e..2fb8db9 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -64,7 +64,7 @@ xfs_dir3_leaf1_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -79,62 +79,6 @@ xfs_dir3_leaf1_check(
 #define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
-void
-xfs_dir3_leaf_hdr_from_disk(
-	struct xfs_dir3_icleaf_hdr	*to,
-	struct xfs_dir2_leaf		*from)
-{
-	if (from->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
-	    from->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
-		to->forw = be32_to_cpu(from->hdr.info.forw);
-		to->back = be32_to_cpu(from->hdr.info.back);
-		to->magic = be16_to_cpu(from->hdr.info.magic);
-		to->count = be16_to_cpu(from->hdr.count);
-		to->stale = be16_to_cpu(from->hdr.stale);
-	} else {
-		struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)from;
-
-		to->forw = be32_to_cpu(hdr3->info.hdr.forw);
-		to->back = be32_to_cpu(hdr3->info.hdr.back);
-		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
-		to->count = be16_to_cpu(hdr3->count);
-		to->stale = be16_to_cpu(hdr3->stale);
-	}
-
-	ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR3_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR2_LEAFN_MAGIC ||
-	       to->magic == XFS_DIR3_LEAFN_MAGIC);
-}
-
-void
-xfs_dir3_leaf_hdr_to_disk(
-	struct xfs_dir2_leaf		*to,
-	struct xfs_dir3_icleaf_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
-	       from->magic == XFS_DIR3_LEAF1_MAGIC ||
-	       from->magic == XFS_DIR2_LEAFN_MAGIC ||
-	       from->magic == XFS_DIR3_LEAFN_MAGIC);
-
-	if (from->magic == XFS_DIR2_LEAF1_MAGIC ||
-	    from->magic == XFS_DIR2_LEAFN_MAGIC) {
-		to->hdr.info.forw = cpu_to_be32(from->forw);
-		to->hdr.info.back = cpu_to_be32(from->back);
-		to->hdr.info.magic = cpu_to_be16(from->magic);
-		to->hdr.count = cpu_to_be16(from->count);
-		to->hdr.stale = cpu_to_be16(from->stale);
-	} else {
-		struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)to;
-
-		hdr3->info.hdr.forw = cpu_to_be32(from->forw);
-		hdr3->info.hdr.back = cpu_to_be32(from->back);
-		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
-		hdr3->count = cpu_to_be16(from->count);
-		hdr3->stale = cpu_to_be16(from->stale);
-	}
-}
-
 bool
 xfs_dir3_leaf_check_int(
 	struct xfs_mount	*mp,
@@ -147,6 +91,7 @@ xfs_dir3_leaf_check_int(
 	int			stale;
 	int			i;
 	const struct xfs_dir_ops *ops;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	/*
 	 * we can be passed a null dp here from a verifier, so we need to go the
@@ -154,6 +99,11 @@ xfs_dir3_leaf_check_int(
 	 */
 	ops = xfs_dir_get_ops(mp, dp);
 
+	if (!hdr) {
+		ops->leaf_hdr_from_disk(&leafhdr, leaf);
+		hdr = &leafhdr;
+	}
+
 	ents = ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 
@@ -198,7 +148,6 @@ xfs_dir3_leaf_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
-	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
 
@@ -220,8 +169,7 @@ xfs_dir3_leaf_verify(
 			return false;
 	}
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	return xfs_dir3_leaf_check_int(mp, NULL, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
 }
 
 static void
@@ -474,10 +422,10 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Set the counts in the leaf header.
 	 */
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, lbp);
 
 	/*
@@ -706,7 +654,7 @@ xfs_dir2_leaf_addname(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = dp->d_ops->data_entsize(args->namelen);
 
@@ -945,7 +893,7 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Log the leaf fields and give up the buffers.
 	 */
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, lbp);
 	xfs_dir3_leaf_log_ents(tp, dp, lbp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, lbp);
@@ -968,6 +916,7 @@ xfs_dir3_leaf_compact(
 	int		loglow;		/* first leaf entry to log */
 	int		to;		/* target leaf index */
 	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_inode *dp = args->dp;
 
 	leaf = bp->b_addr;
 	if (!leafhdr->stale)
@@ -976,7 +925,7 @@ xfs_dir3_leaf_compact(
 	/*
 	 * Compress out the stale entries in place.
 	 */
-	ents = args->dp->d_ops->leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	for (from = to = 0, loglow = -1; from < leafhdr->count; from++) {
 		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
@@ -997,11 +946,10 @@ xfs_dir3_leaf_compact(
 	leafhdr->count -= leafhdr->stale;
 	leafhdr->stale = 0;
 
-	xfs_dir3_leaf_hdr_to_disk(leaf, leafhdr);
-	xfs_dir3_leaf_log_header(args->trans, args->dp, bp);
+	dp->d_ops->leaf_hdr_to_disk(leaf, leafhdr);
+	xfs_dir3_leaf_log_header(args->trans, dp, bp);
 	if (loglow != -1)
-		xfs_dir3_leaf_log_ents(args->trans, args->dp, bp,
-				       loglow, to - 1);
+		xfs_dir3_leaf_log_ents(args->trans, dp, bp, loglow, to - 1);
 }
 
 /*
@@ -1290,7 +1238,7 @@ xfs_dir2_leaf_lookup_int(
 	leaf = lbp->b_addr;
 	xfs_dir3_leaf_check(dp, lbp);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	/*
 	 * Look for the first leaf entry with our hash value.
@@ -1425,7 +1373,7 @@ xfs_dir2_leaf_removename(
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1449,7 +1397,7 @@ xfs_dir2_leaf_removename(
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
 	leafhdr.stale++;
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, lbp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
@@ -1602,7 +1550,7 @@ xfs_dir2_leaf_search_hash(
 
 	leaf = lbp->b_addr;
 	ents = args->dp->d_ops->leaf_ents_p(leaf);
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	args->dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
@@ -1791,7 +1739,7 @@ xfs_dir2_node_to_leaf(
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
@@ -1803,7 +1751,7 @@ xfs_dir2_node_to_leaf(
 	if (error)
 		return error;
 	free = fbp->b_addr;
-	xfs_dir3_free_hdr_from_disk(&freehdr, free);
+	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 	ASSERT(!freehdr.firstdb);
 
@@ -1840,7 +1788,7 @@ xfs_dir2_node_to_leaf(
 	memcpy(xfs_dir2_leaf_bests_p(ltp), xfs_dir3_free_bests_p(mp, free),
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, lbp);
 	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir3_leaf_log_tail(tp, lbp);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 3a426ed..eaee8c3 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -68,7 +68,7 @@ xfs_dir3_leafn_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -192,53 +192,6 @@ xfs_dir2_free_try_read(
 	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
 }
 
-
-void
-xfs_dir3_free_hdr_from_disk(
-	struct xfs_dir3_icfree_hdr	*to,
-	struct xfs_dir2_free		*from)
-{
-	if (from->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC)) {
-		to->magic = be32_to_cpu(from->hdr.magic);
-		to->firstdb = be32_to_cpu(from->hdr.firstdb);
-		to->nvalid = be32_to_cpu(from->hdr.nvalid);
-		to->nused = be32_to_cpu(from->hdr.nused);
-	} else {
-		struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)from;
-
-		to->magic = be32_to_cpu(hdr3->hdr.magic);
-		to->firstdb = be32_to_cpu(hdr3->firstdb);
-		to->nvalid = be32_to_cpu(hdr3->nvalid);
-		to->nused = be32_to_cpu(hdr3->nused);
-	}
-
-	ASSERT(to->magic == XFS_DIR2_FREE_MAGIC ||
-	       to->magic == XFS_DIR3_FREE_MAGIC);
-}
-
-static void
-xfs_dir3_free_hdr_to_disk(
-	struct xfs_dir2_free		*to,
-	struct xfs_dir3_icfree_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DIR2_FREE_MAGIC ||
-	       from->magic == XFS_DIR3_FREE_MAGIC);
-
-	if (from->magic == XFS_DIR2_FREE_MAGIC) {
-		to->hdr.magic = cpu_to_be32(from->magic);
-		to->hdr.firstdb = cpu_to_be32(from->firstdb);
-		to->hdr.nvalid = cpu_to_be32(from->nvalid);
-		to->hdr.nused = cpu_to_be32(from->nused);
-	} else {
-		struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)to;
-
-		hdr3->hdr.magic = cpu_to_be32(from->magic);
-		hdr3->firstdb = cpu_to_be32(from->firstdb);
-		hdr3->nvalid = cpu_to_be32(from->nvalid);
-		hdr3->nused = cpu_to_be32(from->nused);
-	}
-}
-
 static int
 xfs_dir3_free_get_buf(
 	struct xfs_trans	*tp,
@@ -276,7 +229,7 @@ xfs_dir3_free_get_buf(
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
-	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
+	dp->d_ops->free_hdr_to_disk(bp->b_addr, &hdr);
 	*bpp = bp;
 	return 0;
 }
@@ -368,7 +321,7 @@ xfs_dir2_leaf_to_node(
 		return error;
 
 	free = fbp->b_addr;
-	xfs_dir3_free_hdr_from_disk(&freehdr, free);
+	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ASSERT(be32_to_cpu(ltp->bestcount) <=
@@ -392,7 +345,7 @@ xfs_dir2_leaf_to_node(
 	freehdr.nused = n;
 	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
 
-	xfs_dir3_free_hdr_to_disk(fbp->b_addr, &freehdr);
+	dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
 	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
 	xfs_dir2_free_log_header(tp, fbp);
 
@@ -442,7 +395,7 @@ xfs_dir2_leafn_add(
 	mp = dp->i_mount;
 	tp = args->trans;
 	leaf = bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -497,7 +450,7 @@ xfs_dir2_leafn_add(
 	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp,
 				args->blkno, args->index));
 
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, bp);
 	xfs_dir3_leaf_log_ents(tp, dp, bp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, bp);
@@ -507,20 +460,20 @@ xfs_dir2_leafn_add(
 #ifdef DEBUG
 static void
 xfs_dir2_free_hdr_check(
-	struct xfs_mount *mp,
+	struct xfs_inode *dp,
 	struct xfs_buf	*bp,
 	xfs_dir2_db_t	db)
 {
 	struct xfs_dir3_icfree_hdr hdr;
 
-	xfs_dir3_free_hdr_from_disk(&hdr, bp->b_addr);
+	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
 
-	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(mp)) == 0);
+	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(dp->i_mount)) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
 #else
-#define xfs_dir2_free_hdr_check(mp, dp, db)
+#define xfs_dir2_free_hdr_check(dp, bp, db)
 #endif	/* DEBUG */
 
 /*
@@ -537,7 +490,7 @@ xfs_dir2_leafn_lasthash(
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
@@ -584,7 +537,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -655,7 +608,7 @@ xfs_dir2_leafn_lookup_for_addname(
 					return error;
 				free = curbp->b_addr;
 
-				xfs_dir2_free_hdr_check(mp, curbp, curdb);
+				xfs_dir2_free_hdr_check(dp, curbp, curdb);
 			}
 			/*
 			 * Get the index for our entry.
@@ -734,7 +687,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -969,8 +922,8 @@ xfs_dir2_leafn_order(
 	struct xfs_dir3_icleaf_hdr hdr1;
 	struct xfs_dir3_icleaf_hdr hdr2;
 
-	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
-	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
+	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
+	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1025,8 +978,8 @@ xfs_dir2_leafn_rebalance(
 	}
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
-	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
+	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
+	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1074,8 +1027,8 @@ xfs_dir2_leafn_rebalance(
 	ASSERT(hdr1.stale + hdr2.stale == oldstale);
 
 	/* log the changes made when moving the entries */
-	xfs_dir3_leaf_hdr_to_disk(leaf1, &hdr1);
-	xfs_dir3_leaf_hdr_to_disk(leaf2, &hdr2);
+	dp->d_ops->leaf_hdr_to_disk(leaf1, &hdr1);
+	dp->d_ops->leaf_hdr_to_disk(leaf2, &hdr2);
 	xfs_dir3_leaf_log_header(args->trans, dp, blk1->bp);
 	xfs_dir3_leaf_log_header(args->trans, dp, blk2->bp);
 
@@ -1124,8 +1077,9 @@ xfs_dir3_data_block_free(
 	int			logfree = 0;
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
+	struct xfs_inode	*dp = args->dp;
 
-	xfs_dir3_free_hdr_from_disk(&freehdr, free);
+	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
 	if (hdr) {
@@ -1161,7 +1115,7 @@ xfs_dir3_data_block_free(
 		logfree = 1;
 	}
 
-	xfs_dir3_free_hdr_to_disk(free, &freehdr);
+	dp->d_ops->free_hdr_to_disk(free, &freehdr);
 	xfs_dir2_free_log_header(tp, fbp);
 
 	/*
@@ -1226,7 +1180,7 @@ xfs_dir2_leafn_remove(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -1247,7 +1201,7 @@ xfs_dir2_leafn_remove(
 	 * Log the leaf block changes.
 	 */
 	leafhdr.stale++;
-	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(tp, dp, bp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
@@ -1298,7 +1252,7 @@ xfs_dir2_leafn_remove(
 #ifdef DEBUG
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
-		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		ASSERT(freehdr.firstdb == xfs_dir3_free_max_bests(mp) *
 					  (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
 	}
@@ -1449,7 +1403,7 @@ xfs_dir2_leafn_toosmall(
 	 */
 	blk = &state->path.blk[state->path.active - 1];
 	leaf = blk->bp->b_addr;
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_check(dp, blk->bp);
 
@@ -1511,7 +1465,7 @@ xfs_dir2_leafn_toosmall(
 		bytes = state->blocksize - (state->blocksize >> 2);
 
 		leaf = bp->b_addr;
-		xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf);
+		dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 		count += hdr2.count - hdr2.stale;
 		bytes -= count * sizeof(ents[0]);
@@ -1574,10 +1528,10 @@ xfs_dir2_leafn_unbalance(
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
 
-	xfs_dir3_leaf_hdr_from_disk(&savehdr, save_leaf);
-	xfs_dir3_leaf_hdr_from_disk(&drophdr, drop_leaf);
-	sents = args->dp->d_ops->leaf_ents_p(save_leaf);
-	dents = args->dp->d_ops->leaf_ents_p(drop_leaf);
+	dp->d_ops->leaf_hdr_from_disk(&savehdr, save_leaf);
+	dp->d_ops->leaf_hdr_from_disk(&drophdr, drop_leaf);
+	sents = dp->d_ops->leaf_ents_p(save_leaf);
+	dents = dp->d_ops->leaf_ents_p(drop_leaf);
 
 	/*
 	 * If there are any stale leaf entries, take this opportunity
@@ -1603,8 +1557,8 @@ xfs_dir2_leafn_unbalance(
 	save_blk->hashval = be32_to_cpu(sents[savehdr.count - 1].hashval);
 
 	/* log the changes made when moving the entries */
-	xfs_dir3_leaf_hdr_to_disk(save_leaf, &savehdr);
-	xfs_dir3_leaf_hdr_to_disk(drop_leaf, &drophdr);
+	dp->d_ops->leaf_hdr_to_disk(save_leaf, &savehdr);
+	dp->d_ops->leaf_hdr_to_disk(drop_leaf, &drophdr);
 	xfs_dir3_leaf_log_header(args->trans, dp, save_blk->bp);
 	xfs_dir3_leaf_log_header(args->trans, dp, drop_blk->bp);
 
@@ -1735,7 +1689,7 @@ xfs_dir2_node_addname_int(
 		free = fbp->b_addr;
 		findex = fblk->index;
 		bests = xfs_dir3_free_bests_p(mp, free);
-		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 		/*
 		 * This means the free entry showed that the data block had
@@ -1828,7 +1782,7 @@ xfs_dir2_node_addname_int(
 		 * there, so we have to do it here to avoid warnings. Blech.
 		 */
 		bests = xfs_dir3_free_bests_p(mp, free);
-		xfs_dir3_free_hdr_from_disk(&freehdr, free);
+		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
 		    be16_to_cpu(bests[findex]) >= length)
 			dbno = freehdr.firstdb + findex;
@@ -1927,7 +1881,7 @@ xfs_dir2_node_addname_int(
 				return error;
 			free = fbp->b_addr;
 			bests = xfs_dir3_free_bests_p(mp, free);
-			xfs_dir3_free_hdr_from_disk(&freehdr, free);
+			dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 			/*
 			 * Remember the first slot as our empty slot.
@@ -1937,7 +1891,7 @@ xfs_dir2_node_addname_int(
 		} else {
 			free = fbp->b_addr;
 			bests = xfs_dir3_free_bests_p(mp, free);
-			xfs_dir3_free_hdr_from_disk(&freehdr, free);
+			dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		}
 
 		/*
@@ -1962,7 +1916,7 @@ xfs_dir2_node_addname_int(
 		 */
 		if (bests[findex] == cpu_to_be16(NULLDATAOFF)) {
 			freehdr.nused++;
-			xfs_dir3_free_hdr_to_disk(fbp->b_addr, &freehdr);
+			dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
 			xfs_dir2_free_log_header(tp, fbp);
 		}
 		/*
@@ -2294,7 +2248,7 @@ xfs_dir2_node_trim_free(
 	if (!bp)
 		return 0;
 	free = bp->b_addr;
-	xfs_dir3_free_hdr_from_disk(&freehdr, free);
+	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 	/*
 	 * If there are used entries, there's nothing to do.
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 3e4b5ba..8b9d228 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -94,10 +94,6 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
-extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
-		struct xfs_dir2_leaf *from);
-extern void xfs_dir3_leaf_hdr_to_disk(struct xfs_dir2_leaf *to,
-		struct xfs_dir3_icleaf_hdr *from);
 extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
 		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
