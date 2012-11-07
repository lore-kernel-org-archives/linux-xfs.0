Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7B3eRx144608 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 05:03:40 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7bNOnSRSYb6bdAWw for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 03:05:36 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TW3Rt-0001NT-3C
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 22:05:33 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TW3Rs-0007vJ-U2
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 22:05:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: add more attribute tree trace points.
Date: Wed,  7 Nov 2012 22:05:32 +1100
Message-Id: <1352286332-30427-1-git-send-email-david@fromorbit.com>
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

Added when debugging recent attribute tree problems to more finely
trace code execution through the maze of twisty passages that makes
up the attr code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |   18 ++++++++++++++++
 fs/xfs/xfs_attr_leaf.c |   37 +++++++++++++++++++--------------
 fs/xfs/xfs_da_btree.c  |    6 ++++++
 fs/xfs/xfs_trace.h     |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 4b862ed..aaf4725 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1150,6 +1150,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	struct xfs_buf *bp;
 	int error;
 
+	trace_xfs_attr_leaf_get(args);
+
 	args->blkno = 0;
 	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
@@ -1177,6 +1179,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	int error;
 	struct xfs_buf *bp;
 
+	trace_xfs_attr_leaf_list(context);
+
 	context->cursor->blkno = 0;
 	error = xfs_attr_leaf_read(NULL, context->dp, 0, -1, &bp);
 	if (error)
@@ -1634,6 +1638,8 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	xfs_da_state_blk_t *blk;
 	int level;
 
+	trace_xfs_attr_fillstate(state->args);
+
 	/*
 	 * Roll down the "path" in the state structure, storing the on-disk
 	 * block number for those buffers in the "path".
@@ -1680,6 +1686,8 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	xfs_da_state_blk_t *blk;
 	int level, error;
 
+	trace_xfs_attr_refillstate(state->args);
+
 	/*
 	 * Roll down the "path" in the state structure, storing the on-disk
 	 * block number for those buffers in the "path".
@@ -1736,6 +1744,8 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	int error, retval;
 	int i;
 
+	trace_xfs_attr_node_get(args);
+
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
@@ -1785,6 +1795,8 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	int error, i;
 	struct xfs_buf *bp;
 
+	trace_xfs_attr_node_list(context);
+
 	cursor = context->cursor;
 	cursor->initted = 1;
 
@@ -1920,6 +1932,8 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 	int nmap, error, tmp, valuelen, blkcnt, i;
 	xfs_dablk_t lblkno;
 
+	trace_xfs_attr_rmtval_get(args);
+
 	ASSERT(!(args->flags & ATTR_KERNOVAL));
 
 	mp = args->dp->i_mount;
@@ -1975,6 +1989,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 	xfs_dablk_t lblkno;
 	int blkcnt, valuelen, nmap, error, tmp, committed;
 
+	trace_xfs_attr_rmtval_set(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	src = args->value;
@@ -2104,6 +2120,8 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 	xfs_dablk_t lblkno;
 	int valuelen, blkcnt, nmap, error, done, committed;
 
+	trace_xfs_attr_rmtval_remove(args);
+
 	mp = args->dp->i_mount;
 
 	/*
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 39eb8c6..ee24993 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -57,7 +57,8 @@ STATIC int xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t which_block,
 				struct xfs_buf **bpp);
 STATIC int xfs_attr_leaf_add_work(struct xfs_buf *leaf_buffer,
 				  xfs_da_args_t *args, int freemap_index);
-STATIC void xfs_attr_leaf_compact(xfs_trans_t *tp, struct xfs_buf *leaf_buffer);
+STATIC void xfs_attr_leaf_compact(struct xfs_da_args *args,
+				  struct xfs_buf *leaf_buffer);
 STATIC void xfs_attr_leaf_rebalance(xfs_da_state_t *state,
 						   xfs_da_state_blk_t *blk1,
 						   xfs_da_state_blk_t *blk2);
@@ -1116,7 +1117,7 @@ xfs_attr_leaf_add(
 	 * Compact the entries to coalesce free space.
 	 * This may change the hdr->count via dropping INCOMPLETE entries.
 	 */
-	xfs_attr_leaf_compact(args->trans, bp);
+	xfs_attr_leaf_compact(args, bp);
 
 	/*
 	 * After compaction, the block is guaranteed to have only one
@@ -1147,6 +1148,8 @@ xfs_attr_leaf_add_work(
 	xfs_mount_t *mp;
 	int tmp, i;
 
+	trace_xfs_attr_leaf_add_work(args);
+
 	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
@@ -1259,15 +1262,17 @@ xfs_attr_leaf_add_work(
  */
 STATIC void
 xfs_attr_leaf_compact(
-	struct xfs_trans *trans,
-	struct xfs_buf	*bp)
+	struct xfs_da_args	*args,
+	struct xfs_buf		*bp)
 {
-	xfs_attr_leafblock_t *leaf_s, *leaf_d;
-	xfs_attr_leaf_hdr_t *hdr_s, *hdr_d;
-	xfs_mount_t *mp;
-	char *tmpbuffer;
+	xfs_attr_leafblock_t	*leaf_s, *leaf_d;
+	xfs_attr_leaf_hdr_t	*hdr_s, *hdr_d;
+	struct xfs_trans	*trans = args->trans;
+	struct xfs_mount	*mp = trans->t_mountp;
+	char			*tmpbuffer;
+
+	trace_xfs_attr_leaf_compact(args);
 
-	mp = trans->t_mountp;
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(mp), KM_SLEEP);
 	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(mp));
@@ -1390,9 +1395,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		max  = be16_to_cpu(hdr2->firstused)
 						- sizeof(xfs_attr_leaf_hdr_t);
 		max -= be16_to_cpu(hdr2->count) * sizeof(xfs_attr_leaf_entry_t);
-		if (space > max) {
-			xfs_attr_leaf_compact(args->trans, blk2->bp);
-		}
+		if (space > max)
+			xfs_attr_leaf_compact(args, blk2->bp);
 
 		/*
 		 * Move high entries from leaf1 to low end of leaf2.
@@ -1423,9 +1427,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		max  = be16_to_cpu(hdr1->firstused)
 						- sizeof(xfs_attr_leaf_hdr_t);
 		max -= be16_to_cpu(hdr1->count) * sizeof(xfs_attr_leaf_entry_t);
-		if (space > max) {
-			xfs_attr_leaf_compact(args->trans, blk1->bp);
-		}
+		if (space > max)
+			xfs_attr_leaf_compact(args, blk1->bp);
 
 		/*
 		 * Move low entries from leaf2 to high end of leaf1.
@@ -1622,6 +1625,8 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	xfs_dablk_t blkno;
 	struct xfs_buf *bp;
 
+	trace_xfs_attr_leaf_toosmall(state->args);
+
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
 	 * If so, it's not worth even looking to see if we might be able
@@ -1745,6 +1750,8 @@ xfs_attr_leaf_remove(
 	int tablesize, tmp, i;
 	xfs_mount_t *mp;
 
+	trace_xfs_attr_leaf_remove(args);
+
 	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index f5a7264..43db040 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -860,6 +860,8 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	xfs_dablk_t blkno;
 	struct xfs_buf *bp;
 
+	trace_xfs_da_node_toosmall(state->args);
+
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
 	 * If so, it's not worth even looking to see if we might be able
@@ -981,6 +983,8 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
 	xfs_dahash_t lasthash=0;
 	int level, count;
 
+	trace_xfs_da_fixhashpath(state->args);
+
 	level = path->active-1;
 	blk = &path->blk[ level ];
 	switch (blk->magic) {
@@ -1498,6 +1502,8 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 	xfs_dablk_t blkno=0;
 	int level, error;
 
+	trace_xfs_da_path_shift(state->args);
+
 	/*
 	 * Roll up the Btree looking for the first block where our
 	 * current index is not at the edge of the block.  Note that
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7d36ccf..62d769f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -96,6 +96,8 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
@@ -1496,8 +1498,42 @@ DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
 DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
 DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
 
+DECLARE_EVENT_CLASS(xfs_attr_class,
+	TP_PROTO(struct xfs_da_args *args),
+	TP_ARGS(args),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__dynamic_array(char, name, args->namelen)
+		__field(int, namelen)
+		__field(int, valuelen)
+		__field(xfs_dahash_t, hashval)
+		__field(int, op_flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		if (args->namelen)
+			memcpy(__get_str(name), args->name, args->namelen);
+		__entry->namelen = args->namelen;
+		__entry->valuelen = args->valuelen;
+		__entry->hashval = args->hashval;
+		__entry->op_flags = args->op_flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
+		  "hashval 0x%x op_flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->namelen,
+		  __entry->namelen ? __get_str(name) : NULL,
+		  __entry->namelen,
+		  __entry->valuelen,
+		  __entry->hashval,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+)
+
 #define DEFINE_ATTR_EVENT(name) \
-DEFINE_EVENT(xfs_da_class, name, \
+DEFINE_EVENT(xfs_attr_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
 	TP_ARGS(args))
 DEFINE_ATTR_EVENT(xfs_attr_sf_add);
@@ -1511,10 +1547,14 @@ DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_replace);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_remove);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_removename);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_split);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_split_before);
@@ -1526,12 +1566,21 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_to_sf);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_to_node);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_rebalance);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_unbalance);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_toosmall);
 
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
+DEFINE_ATTR_EVENT(xfs_attr_node_get);
 DEFINE_ATTR_EVENT(xfs_attr_node_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
 DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
+DEFINE_ATTR_EVENT(xfs_attr_fillstate);
+DEFINE_ATTR_EVENT(xfs_attr_refillstate);
+
+DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
+DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
+DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
+
 #define DEFINE_DA_EVENT(name) \
 DEFINE_EVENT(xfs_da_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
@@ -1550,9 +1599,12 @@ DEFINE_DA_EVENT(xfs_da_node_split);
 DEFINE_DA_EVENT(xfs_da_node_remove);
 DEFINE_DA_EVENT(xfs_da_node_rebalance);
 DEFINE_DA_EVENT(xfs_da_node_unbalance);
+DEFINE_DA_EVENT(xfs_da_node_toosmall);
 DEFINE_DA_EVENT(xfs_da_swap_lastblock);
 DEFINE_DA_EVENT(xfs_da_grow_inode);
 DEFINE_DA_EVENT(xfs_da_shrink_inode);
+DEFINE_DA_EVENT(xfs_da_fixhashpath);
+DEFINE_DA_EVENT(xfs_da_path_shift);
 
 DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_PROTO(struct xfs_da_args *args, int idx),
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
