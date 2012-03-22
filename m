Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2M5Fchb180481 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 00:15:38 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5sSouYck8Y6ScXIb for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 22:15:35 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAaN4-000361-3M
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:34 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAaMw-0000Wi-Lh
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: add lots of attribute trace points
Date: Thu, 22 Mar 2012 16:15:13 +1100
Message-Id: <1332393313-1955-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1332393313-1955-1-git-send-email-david@fromorbit.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |   16 ++++++++++++
 fs/xfs/xfs_attr_leaf.c |   40 +++++++++++++++++++++++++++---
 fs/xfs/xfs_da_btree.c  |   32 ++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |   62 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 144 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 08b9ac6..65d61b9 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -853,6 +853,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 {
 	int newsize, forkoff, retval;
 
+	trace_xfs_attr_sf_addname(args);
+
 	retval = xfs_attr_shortform_lookup(args);
 	if ((args->flags & ATTR_REPLACE) && (retval == ENOATTR)) {
 		return(retval);
@@ -896,6 +898,8 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int retval, error, committed, forkoff;
 
+	trace_xfs_attr_leaf_addname(args);
+
 	/*
 	 * Read the (only) block in the attribute list in.
 	 */
@@ -920,6 +924,9 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			xfs_da_brelse(args->trans, bp);
 			return(retval);
 		}
+
+		trace_xfs_attr_leaf_replace(args);
+
 		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
@@ -1090,6 +1097,8 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int error, committed, forkoff;
 
+	trace_xfs_attr_leaf_removename(args);
+
 	/*
 	 * Remove the attribute.
 	 */
@@ -1223,6 +1232,8 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	xfs_mount_t *mp;
 	int committed, retval, error;
 
+	trace_xfs_attr_node_addname(args);
+
 	/*
 	 * Fill in bucket of arguments/results/context to carry around.
 	 */
@@ -1249,6 +1260,9 @@ restart:
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			goto out;
+
+		trace_xfs_attr_node_replace(args);
+
 		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
@@ -1480,6 +1494,8 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int retval, error, committed, forkoff;
 
+	trace_xfs_attr_node_removename(args);
+
 	/*
 	 * Tie a string around our finger to remind us where we are.
 	 */
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index d25eafd..76d93dc 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -235,6 +235,8 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 	xfs_inode_t *dp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_create(args);
+
 	dp = args->dp;
 	ASSERT(dp != NULL);
 	ifp = dp->i_afp;
@@ -268,6 +270,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	xfs_inode_t *dp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_add(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	dp->i_d.di_forkoff = forkoff;
@@ -337,6 +341,8 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	xfs_mount_t *mp;
 	xfs_inode_t *dp;
 
+	trace_xfs_attr_sf_remove(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	base = sizeof(xfs_attr_sf_hdr_t);
@@ -405,6 +411,8 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	int i;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_lookup(args);
+
 	ifp = args->dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
@@ -476,6 +484,8 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_to_leaf(args);
+
 	dp = args->dp;
 	ifp = dp->i_afp;
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
@@ -775,6 +785,8 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 	char *tmpbuffer;
 	int error, i;
 
+	trace_xfs_attr_leaf_to_sf(args);
+
 	dp = args->dp;
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(dp->i_mount), KM_SLEEP);
 	ASSERT(tmpbuffer != NULL);
@@ -848,6 +860,8 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	xfs_dablk_t blkno;
 	int error;
 
+	trace_xfs_attr_leaf_to_node(args);
+
 	dp = args->dp;
 	bp1 = bp2 = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
@@ -911,6 +925,8 @@ xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t blkno, xfs_dabuf_t **bpp)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_attr_leaf_create(args);
+
 	dp = args->dp;
 	ASSERT(dp != NULL);
 	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
@@ -948,6 +964,8 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	xfs_dablk_t blkno;
 	int error;
 
+	trace_xfs_attr_leaf_split(state->args);
+
 	/*
 	 * Allocate space for a new leaf node.
 	 */
@@ -977,10 +995,13 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 *
 	 * Insert the "new" entry in the correct block.
 	 */
-	if (state->inleaf)
+	if (state->inleaf) {
+		trace_xfs_attr_leaf_add_old(state->args);
 		error = xfs_attr_leaf_add(oldblk->bp, state->args);
-	else
+	} else {
+		trace_xfs_attr_leaf_add_new(state->args);
 		error = xfs_attr_leaf_add(newblk->bp, state->args);
+	}
 
 	/*
 	 * Update last hashval in each block since we added the name.
@@ -1001,6 +1022,8 @@ xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	xfs_attr_leaf_map_t *map;
 	int tablesize, entsize, sum, tmp, i;
 
+	trace_xfs_attr_leaf_add(args);
+
 	leaf = bp->data;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT((args->index >= 0)
@@ -1128,8 +1151,6 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 	       (be32_to_cpu(entry->hashval) <= be32_to_cpu((entry+1)->hashval)));
 
 	/*
-	 * Copy the attribute name and value into the new space.
-	 *
 	 * For "remote" attribute values, simply note that we need to
 	 * allocate space for the "remote" value.  We can't actually
 	 * allocate the extents in this transaction, and we can't decide
@@ -1265,6 +1286,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	args = state->args;
 
+	trace_xfs_attr_leaf_rebalance(args);
+
 	/*
 	 * Check ordering of blocks, reverse if it makes things simpler.
 	 *
@@ -1810,6 +1833,8 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	xfs_mount_t *mp;
 	char *tmpbuffer;
 
+	trace_xfs_attr_leaf_unbalance(state->args);
+
 	/*
 	 * Set up environment.
 	 */
@@ -1919,6 +1944,8 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	int probe, span;
 	xfs_dahash_t hashval;
 
+	trace_xfs_attr_leaf_lookup(args);
+
 	leaf = bp->data;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
@@ -2445,6 +2472,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	char *name;
 #endif /* DEBUG */
 
+	trace_xfs_attr_leaf_clearflag(args);
 	/*
 	 * Set up the operation.
 	 */
@@ -2509,6 +2537,8 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_attr_leaf_setflag(args);
+
 	/*
 	 * Set up the operation.
 	 */
@@ -2565,6 +2595,8 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	char *name1, *name2;
 #endif /* DEBUG */
 
+	trace_xfs_attr_leaf_flipflags(args);
+
 	/*
 	 * Read the block containing the "old" attr
 	 */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 77c7425..7f1a6f5 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -108,6 +108,8 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	int error;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_create(args);
+
 	tp = args->trans;
 	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
 	if (error)
@@ -140,6 +142,8 @@ xfs_da_split(xfs_da_state_t *state)
 	xfs_dabuf_t *bp;
 	int max, action, error, i;
 
+	trace_xfs_da_split(state->args);
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
@@ -178,10 +182,12 @@ xfs_da_split(xfs_da_state_t *state)
 			state->extravalid = 1;
 			if (state->inleaf) {
 				state->extraafter = 0;	/* before newblk */
+				trace_xfs_attr_leaf_split_before(state->args);
 				error = xfs_attr_leaf_split(state, oldblk,
 							    &state->extrablk);
 			} else {
 				state->extraafter = 1;	/* after newblk */
+				trace_xfs_attr_leaf_split_after(state->args);
 				error = xfs_attr_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
@@ -300,6 +306,8 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	xfs_mount_t *mp;
 	xfs_dir2_leaf_t *leaf;
 
+	trace_xfs_da_root_split(state->args);
+
 	/*
 	 * Copy the existing (incorrect) block from the root node position
 	 * to a free space somewhere.
@@ -380,6 +388,8 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	int newcount, error;
 	int useextra;
 
+	trace_xfs_da_node_split(state->args);
+
 	node = oldblk->bp->data;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 
@@ -466,6 +476,8 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	int count, tmp;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_rebalance(state->args);
+
 	node1 = blk1->bp->data;
 	node2 = blk2->bp->data;
 	/*
@@ -574,6 +586,8 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	xfs_da_node_entry_t *btree;
 	int tmp;
 
+	trace_xfs_da_node_add(state->args);
+
 	node = oldblk->bp->data;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
@@ -619,6 +633,8 @@ xfs_da_join(xfs_da_state_t *state)
 	xfs_da_state_blk_t *drop_blk, *save_blk;
 	int action, error;
 
+	trace_xfs_da_join(state->args);
+
 	action = 0;
 	drop_blk = &state->path.blk[ state->path.active-1 ];
 	save_blk = &state->altpath.blk[ state->path.active-1 ];
@@ -723,6 +739,8 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_da_root_join(state->args);
+
 	args = state->args;
 	ASSERT(args != NULL);
 	ASSERT(root_blk->magic == XFS_DA_NODE_MAGIC);
@@ -941,6 +959,8 @@ xfs_da_node_remove(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk)
 	xfs_da_node_entry_t *btree;
 	int tmp;
 
+	trace_xfs_da_node_remove(state->args);
+
 	node = drop_blk->bp->data;
 	ASSERT(drop_blk->index < be16_to_cpu(node->hdr.count));
 	ASSERT(drop_blk->index >= 0);
@@ -984,6 +1004,8 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	int tmp;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_unbalance(state->args);
+
 	drop_node = drop_blk->bp->data;
 	save_node = save_blk->bp->data;
 	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
@@ -1230,6 +1252,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		/*
 		 * Link new block in before existing block.
 		 */
+		trace_xfs_da_link_before(args);
 		new_info->forw = cpu_to_be32(old_blk->blkno);
 		new_info->back = old_info->back;
 		if (old_info->back) {
@@ -1251,6 +1274,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		/*
 		 * Link new block in after existing block.
 		 */
+		trace_xfs_da_link_after(args);
 		new_info->forw = old_info->forw;
 		new_info->back = cpu_to_be32(old_blk->blkno);
 		if (old_info->forw) {
@@ -1348,6 +1372,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	 * Unlink the leaf block from the doubly linked chain of leaves.
 	 */
 	if (be32_to_cpu(save_info->back) == drop_blk->blkno) {
+		trace_xfs_da_unlink_back(args);
 		save_info->back = drop_info->back;
 		if (drop_info->back) {
 			error = xfs_da_read_buf(args->trans, args->dp,
@@ -1365,6 +1390,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 			xfs_da_buf_done(bp);
 		}
 	} else {
+		trace_xfs_da_unlink_forward(args);
 		save_info->forw = drop_info->forw;
 		if (drop_info->forw) {
 			error = xfs_da_read_buf(args->trans, args->dp,
@@ -1652,6 +1678,8 @@ xfs_da_grow_inode(
 	int			count;
 	int			error;
 
+	trace_xfs_da_grow_inode(args);
+
 	if (args->whichfork == XFS_DATA_FORK) {
 		bno = args->dp->i_mount->m_dirleafblk;
 		count = args->dp->i_mount->m_dirblkfsbs;
@@ -1690,6 +1718,8 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	xfs_dir2_leaf_t *dead_leaf2;
 	xfs_dahash_t dead_hash;
 
+	trace_xfs_da_swap_lastblock(args);
+
 	dead_buf = *dead_bufp;
 	dead_blkno = *dead_blknop;
 	tp = args->trans;
@@ -1878,6 +1908,8 @@ xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 	xfs_trans_t *tp;
 	xfs_mount_t *mp;
 
+	trace_xfs_da_shrink_inode(args);
+
 	dp = args->dp;
 	w = args->whichfork;
 	tp = args->trans;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 75eb54a..270775f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1408,7 +1408,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
-DECLARE_EVENT_CLASS(xfs_dir2_class,
+DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),
 	TP_STRUCT__entry(
@@ -1443,7 +1443,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_class,
 )
 
 #define DEFINE_DIR2_EVENT(name) \
-DEFINE_EVENT(xfs_dir2_class, name, \
+DEFINE_EVENT(xfs_da_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
 	TP_ARGS(args))
 DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
@@ -1472,6 +1472,64 @@ DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
 DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
 DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
 
+#define DEFINE_ATTR_EVENT(name) \
+DEFINE_EVENT(xfs_da_class, name, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args))
+DEFINE_ATTR_EVENT(xfs_attr_sf_add);
+DEFINE_ATTR_EVENT(xfs_attr_sf_addname);
+DEFINE_ATTR_EVENT(xfs_attr_sf_create);
+DEFINE_ATTR_EVENT(xfs_attr_sf_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_sf_remove);
+DEFINE_ATTR_EVENT(xfs_attr_sf_removename);
+DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
+
+DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_replace);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_removename);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_split);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_split_before);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_split_after);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_clearflag);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_setflag);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_flipflags);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_to_sf);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_to_node);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_rebalance);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_unbalance);
+
+DEFINE_ATTR_EVENT(xfs_attr_node_addname);
+DEFINE_ATTR_EVENT(xfs_attr_node_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_node_replace);
+DEFINE_ATTR_EVENT(xfs_attr_node_removename);
+
+#define DEFINE_DA_EVENT(name) \
+DEFINE_EVENT(xfs_da_class, name, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args))
+DEFINE_DA_EVENT(xfs_da_split);
+DEFINE_DA_EVENT(xfs_da_join);
+DEFINE_DA_EVENT(xfs_da_link_before);
+DEFINE_DA_EVENT(xfs_da_link_after);
+DEFINE_DA_EVENT(xfs_da_unlink_back);
+DEFINE_DA_EVENT(xfs_da_unlink_forward);
+DEFINE_DA_EVENT(xfs_da_root_split);
+DEFINE_DA_EVENT(xfs_da_root_join);
+DEFINE_DA_EVENT(xfs_da_node_add);
+DEFINE_DA_EVENT(xfs_da_node_create);
+DEFINE_DA_EVENT(xfs_da_node_split);
+DEFINE_DA_EVENT(xfs_da_node_remove);
+DEFINE_DA_EVENT(xfs_da_node_rebalance);
+DEFINE_DA_EVENT(xfs_da_node_unbalance);
+DEFINE_DA_EVENT(xfs_da_swap_lastblock);
+DEFINE_DA_EVENT(xfs_da_grow_inode);
+DEFINE_DA_EVENT(xfs_da_shrink_inode);
+
 DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_PROTO(struct xfs_da_args *args, int idx),
 	TP_ARGS(args, idx),
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
