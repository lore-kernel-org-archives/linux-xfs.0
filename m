Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F0787F5A
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 18:39:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D00ADAC003
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 16:39:10 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zA9b8cjJvv60LBNv for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 16:39:08 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WqWOA-00076B-G1
	for xfs@oss.sgi.com; Sat, 31 May 2014 09:39:06 +1000
Date: Sat, 31 May 2014 09:39:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/16] xfs: remove redundant geometry information from
	xfs_da_state
Message-ID: <20140530233906.GL6677@dastard>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

It's carried in state->args->geo, so there's no need to duplicate it
and use more stack space than necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |  8 --------
 fs/xfs/xfs_attr_leaf.c | 19 ++++++++++---------
 fs/xfs/xfs_da_btree.c  | 13 +++++++------
 fs/xfs/xfs_da_btree.h  |  2 --
 fs/xfs/xfs_dir2_node.c | 13 +++----------
 5 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 470a22d..bfe36fc 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -896,8 +896,6 @@ restart:
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = mp;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
@@ -1075,8 +1073,6 @@ restart:
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
-		state->blocksize = args->geo->blksize;
-		state->node_ents = args->geo->node_ents;
 		state->inleaf = 0;
 		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
@@ -1167,8 +1163,6 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
@@ -1430,8 +1424,6 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index ae33b14..28712d2 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1494,8 +1494,8 @@ xfs_attr3_leaf_rebalance(
 
 	xfs_attr3_leaf_hdr_to_disk(leaf1, &ichdr1);
 	xfs_attr3_leaf_hdr_to_disk(leaf2, &ichdr2);
-	xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
-	xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
+	xfs_trans_log_buf(args->trans, blk1->bp, 0, args->geo->blksize - 1);
+	xfs_trans_log_buf(args->trans, blk2->bp, 0, args->geo->blksize - 1);
 
 	/*
 	 * Copy out last hashval in each block for B-tree code.
@@ -1592,7 +1592,7 @@ xfs_attr3_leaf_figure_balance(
 	half += ichdr1->usedbytes + ichdr2->usedbytes +
 			xfs_attr_leaf_newentsize(state->args, NULL);
 	half /= 2;
-	lastdelta = state->blocksize;
+	lastdelta = state->args->geo->blksize;
 	entry = xfs_attr3_leaf_entryp(leaf1);
 	for (count = index = 0; count < max; entry++, index++, count++) {
 
@@ -1690,7 +1690,7 @@ xfs_attr3_leaf_toosmall(
 	bytes = xfs_attr3_leaf_hdr_size(leaf) +
 		ichdr.count * sizeof(xfs_attr_leaf_entry_t) +
 		ichdr.usedbytes;
-	if (bytes > (state->blocksize >> 1)) {
+	if (bytes > (state->args->geo->blksize >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return(0);
 	}
@@ -1744,7 +1744,8 @@ xfs_attr3_leaf_toosmall(
 
 		xfs_attr3_leaf_hdr_from_disk(&ichdr2, bp->b_addr);
 
-		bytes = state->blocksize - (state->blocksize >> 2) -
+		bytes = state->args->geo->blksize -
+			(state->args->geo->blksize >> 2) -
 			ichdr.usedbytes - ichdr2.usedbytes -
 			((ichdr.count + ichdr2.count) *
 					sizeof(xfs_attr_leaf_entry_t)) -
@@ -1997,7 +1998,7 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kmem_zalloc(state->blocksize, KM_SLEEP);
+		tmp_leaf = kmem_zalloc(state->args->geo->blksize, KM_SLEEP);
 
 		/*
 		 * Copy the header into the temp leaf so that all the stuff
@@ -2010,7 +2011,7 @@ xfs_attr3_leaf_unbalance(
 		tmphdr.magic = savehdr.magic;
 		tmphdr.forw = savehdr.forw;
 		tmphdr.back = savehdr.back;
-		tmphdr.firstused = state->blocksize;
+		tmphdr.firstused = state->args->geo->blksize;
 
 		/* write the header to the temp buffer to initialise it */
 		xfs_attr3_leaf_hdr_to_disk(tmp_leaf, &tmphdr);
@@ -2035,14 +2036,14 @@ xfs_attr3_leaf_unbalance(
 						tmp_leaf, &tmphdr, tmphdr.count,
 						drophdr.count);
 		}
-		memcpy(save_leaf, tmp_leaf, state->blocksize);
+		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
 		savehdr = tmphdr; /* struct copy */
 		kmem_free(tmp_leaf);
 	}
 
 	xfs_attr3_leaf_hdr_to_disk(save_leaf, &savehdr);
 	xfs_trans_log_buf(state->args->trans, save_blk->bp, 0,
-					   state->blocksize - 1);
+					   state->args->geo->blksize - 1);
 
 	/*
 	 * Copy out last hashval in each block for B-tree code.
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index f935370..2da9922 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -663,7 +663,7 @@ xfs_da3_node_split(
 	/*
 	 * Do we have to split the node?
 	 */
-	if (nodehdr.count + newcount > state->node_ents) {
+	if (nodehdr.count + newcount > state->args->geo->node_ents) {
 		/*
 		 * Allocate a new node, add to the doubly linked chain of
 		 * nodes, then move some of our excess entries into it.
@@ -1089,14 +1089,15 @@ xfs_da3_root_join(
 	 * that could occur. For dir3 blocks we also need to update the block
 	 * number in the buffer header.
 	 */
-	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
+	memcpy(root_blk->bp->b_addr, bp->b_addr, state->args->geo->blksize);
 	root_blk->bp->b_ops = bp->b_ops;
 	xfs_trans_buf_copy_type(root_blk->bp, bp);
 	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
 		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
 		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
 	}
-	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
+	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
+			  state->args->geo->blksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
 	return(error);
 }
@@ -1139,7 +1140,7 @@ xfs_da3_node_toosmall(
 	info = blk->bp->b_addr;
 	node = (xfs_da_intnode_t *)info;
 	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
-	if (nodehdr.count > (state->node_ents >> 1)) {
+	if (nodehdr.count > (state->args->geo->node_ents >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return(0);	/* blk over 50%, don't try to join */
 	}
@@ -1176,8 +1177,8 @@ xfs_da3_node_toosmall(
 	 * We prefer coalescing with the lower numbered sibling so as
 	 * to shrink a directory over time.
 	 */
-	count  = state->node_ents;
-	count -= state->node_ents >> 2;
+	count  = state->args->geo->node_ents;
+	count -= state->args->geo->node_ents >> 2;
 	count -= nodehdr.count;
 
 	/* start with smaller blk num */
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 0ac63ad..6e153e3 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -128,8 +128,6 @@ typedef struct xfs_da_state_path {
 typedef struct xfs_da_state {
 	xfs_da_args_t		*args;		/* filename arguments */
 	struct xfs_mount	*mp;		/* filesystem mount point */
-	unsigned int		blocksize;	/* logical block size */
-	unsigned int		node_ents;	/* how many entries in danode */
 	xfs_da_state_path_t	path;		/* search/split paths */
 	xfs_da_state_path_t	altpath;	/* alternate path for join */
 	unsigned char		inleaf;		/* insert into 1->lf, 0->splf */
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 65df8cb..da43d30 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1414,7 +1414,7 @@ xfs_dir2_leafn_toosmall(
 
 	count = leafhdr.count - leafhdr.stale;
 	bytes = dp->d_ops->leaf_hdr_size + count * sizeof(ents[0]);
-	if (bytes > (state->blocksize >> 1)) {
+	if (bytes > (state->args->geo->blksize >> 1)) {
 		/*
 		 * Blk over 50%, don't try to join.
 		 */
@@ -1467,7 +1467,8 @@ xfs_dir2_leafn_toosmall(
 		 * Count bytes in the two blocks combined.
 		 */
 		count = leafhdr.count - leafhdr.stale;
-		bytes = state->blocksize - (state->blocksize >> 2);
+		bytes = state->args->geo->blksize -
+			(state->args->geo->blksize >> 2);
 
 		leaf = bp->b_addr;
 		dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf);
@@ -1591,8 +1592,6 @@ xfs_dir2_node_addname(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 	/*
 	 * Look up the name.  We're not supposed to find it, but
 	 * this gives us the insertion point.
@@ -2037,8 +2036,6 @@ xfs_dir2_node_lookup(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 	/*
 	 * Fill in the path to the entry in the cursor.
 	 */
@@ -2092,8 +2089,6 @@ xfs_dir2_node_removename(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 
 	/* Look up the entry we're deleting, set up the cursor. */
 	error = xfs_da3_node_lookup_int(state, &rval);
@@ -2162,8 +2157,6 @@ xfs_dir2_node_replace(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = args->geo->blksize;
-	state->node_ents = args->geo->node_ents;
 	inum = args->inumber;
 	/*
 	 * Lookup the entry to change in the btree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
