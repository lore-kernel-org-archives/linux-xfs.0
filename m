Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6n8n160082 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52ECD15ECDA7
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xJN6BbNqonAtQOet for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPt-000415-2k
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:45 +0000
Message-Id: <20110707110645.046387162@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 23/28] xfs: byteswap constants instead of variables
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-byteswap-constants
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

Micro-optimize various comparisms by always byteswapping the constant
instead of the variable, which allows to do the swap at compile instead
of runtime.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-07-07 10:06:52.798727585 +0200
+++ xfs/fs/xfs/xfs_attr.c	2011-07-07 10:14:09.008705501 +0200
@@ -1203,7 +1203,7 @@ xfs_attr_leaf_list(xfs_attr_list_context
 		return XFS_ERROR(error);
 	ASSERT(bp != NULL);
 	leaf = bp->data;
-	if (unlikely(be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)) {
+	if (unlikely(leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
 		XFS_CORRUPTION_ERROR("xfs_attr_leaf_list", XFS_ERRLEVEL_LOW,
 				     context->dp->i_mount, leaf);
 		xfs_da_brelse(NULL, bp);
@@ -1610,9 +1610,8 @@ xfs_attr_node_removename(xfs_da_args_t *
 						     XFS_ATTR_FORK);
 		if (error)
 			goto out;
-		ASSERT(be16_to_cpu(((xfs_attr_leafblock_t *)
-				      bp->data)->hdr.info.magic)
-						       == XFS_ATTR_LEAF_MAGIC);
+		ASSERT((((xfs_attr_leafblock_t *)bp->data)->hdr.info.magic) ==
+		       cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
 			xfs_bmap_init(args->flist, args->firstblock);
@@ -1877,11 +1876,11 @@ xfs_attr_node_list(xfs_attr_list_context
 				return(XFS_ERROR(EFSCORRUPTED));
 			}
 			node = bp->data;
-			if (be16_to_cpu(node->hdr.info.magic)
-							== XFS_ATTR_LEAF_MAGIC)
+			if (node->hdr.info.magic ==
+			    cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
 				break;
-			if (unlikely(be16_to_cpu(node->hdr.info.magic)
-							!= XFS_DA_NODE_MAGIC)) {
+			if (unlikely(node->hdr.info.magic !=
+				     cpu_to_be16(XFS_DA_NODE_MAGIC))) {
 				XFS_CORRUPTION_ERROR("xfs_attr_node_list(3)",
 						     XFS_ERRLEVEL_LOW,
 						     context->dp->i_mount,
@@ -1916,8 +1915,8 @@ xfs_attr_node_list(xfs_attr_list_context
 	 */
 	for (;;) {
 		leaf = bp->data;
-		if (unlikely(be16_to_cpu(leaf->hdr.info.magic)
-						!= XFS_ATTR_LEAF_MAGIC)) {
+		if (unlikely(leaf->hdr.info.magic !=
+			     cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_node_list(4)",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, leaf);
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2011-07-07 10:06:52.808727584 +0200
+++ xfs/fs/xfs/xfs_attr_leaf.c	2011-07-07 10:14:09.008705501 +0200
@@ -731,7 +731,7 @@ xfs_attr_shortform_allfit(xfs_dabuf_t *b
 	int bytes, i;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 	entry = &leaf->entries[0];
 	bytes = sizeof(struct xfs_attr_sf_hdr);
@@ -777,7 +777,7 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *
 	ASSERT(bp != NULL);
 	memcpy(tmpbuffer, bp->data, XFS_LBSIZE(dp->i_mount));
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	memset(bp->data, 0, XFS_LBSIZE(dp->i_mount));
 
 	/*
@@ -872,7 +872,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *arg
 		goto out;
 	node = bp1->data;
 	leaf = bp2->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	/* both on-disk, don't endian-flip twice */
 	node->btree[0].hashval =
 		leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
@@ -997,7 +997,7 @@ xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_d
 	int tablesize, entsize, sum, tmp, i;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT((args->index >= 0)
 		&& (args->index <= be16_to_cpu(leaf->hdr.count)));
 	hdr = &leaf->hdr;
@@ -1070,7 +1070,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp,
 	int tmp, i;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
 	ASSERT((mapindex >= 0) && (mapindex < XFS_ATTR_LEAF_MAPSIZE));
 	ASSERT((args->index >= 0) && (args->index <= be16_to_cpu(hdr->count)));
@@ -1256,8 +1256,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *
 	ASSERT(blk2->magic == XFS_ATTR_LEAF_MAGIC);
 	leaf1 = blk1->bp->data;
 	leaf2 = blk2->bp->data;
-	ASSERT(be16_to_cpu(leaf1->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(be16_to_cpu(leaf2->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	args = state->args;
 
 	/*
@@ -1533,7 +1533,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *s
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
 	info = blk->bp->data;
-	ASSERT(be16_to_cpu(info->magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	leaf = (xfs_attr_leafblock_t *)info;
 	count = be16_to_cpu(leaf->hdr.count);
 	bytes = sizeof(xfs_attr_leaf_hdr_t) +
@@ -1596,7 +1596,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *s
 		bytes  = state->blocksize - (state->blocksize>>2);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
 		leaf = bp->data;
-		ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 		count += be16_to_cpu(leaf->hdr.count);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
 		bytes -= count * sizeof(xfs_attr_leaf_entry_t);
@@ -1650,7 +1650,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 	xfs_mount_t *mp;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
 	mp = args->trans->t_mountp;
 	ASSERT((be16_to_cpu(hdr->count) > 0)
@@ -1813,8 +1813,8 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *
 	ASSERT(save_blk->magic == XFS_ATTR_LEAF_MAGIC);
 	drop_leaf = drop_blk->bp->data;
 	save_leaf = save_blk->bp->data;
-	ASSERT(be16_to_cpu(drop_leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(be16_to_cpu(save_leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	drop_hdr = &drop_leaf->hdr;
 	save_hdr = &save_leaf->hdr;
 
@@ -1915,7 +1915,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 	xfs_dahash_t hashval;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
 					< (XFS_LBSIZE(args->dp->i_mount)/8));
 
@@ -2019,7 +2019,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp,
 	xfs_attr_leaf_name_remote_t *name_rmt;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
 					< (XFS_LBSIZE(args->dp->i_mount)/8));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
@@ -2087,8 +2087,8 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 	/*
 	 * Set up environment.
 	 */
-	ASSERT(be16_to_cpu(leaf_s->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(be16_to_cpu(leaf_d->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf_s->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	ASSERT(leaf_d->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr_s = &leaf_s->hdr;
 	hdr_d = &leaf_d->hdr;
 	ASSERT((be16_to_cpu(hdr_s->count) > 0) &&
@@ -2222,8 +2222,8 @@ xfs_attr_leaf_order(xfs_dabuf_t *leaf1_b
 
 	leaf1 = leaf1_bp->data;
 	leaf2 = leaf2_bp->data;
-	ASSERT((be16_to_cpu(leaf1->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC) &&
-	       (be16_to_cpu(leaf2->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC));
+	ASSERT((leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) &&
+	       (leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)));
 	if ((be16_to_cpu(leaf1->hdr.count) > 0) &&
 	    (be16_to_cpu(leaf2->hdr.count) > 0) &&
 	    ((be32_to_cpu(leaf2->entries[0].hashval) <
@@ -2246,7 +2246,7 @@ xfs_attr_leaf_lasthash(xfs_dabuf_t *bp,
 	xfs_attr_leafblock_t *leaf;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	if (count)
 		*count = be16_to_cpu(leaf->hdr.count);
 	if (!leaf->hdr.count)
@@ -2265,7 +2265,7 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock
 	xfs_attr_leaf_name_remote_t *name_rmt;
 	int size;
 
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	if (leaf->entries[index].flags & XFS_ATTR_LOCAL) {
 		name_loc = xfs_attr_leaf_name_local(leaf, index);
 		size = xfs_attr_leaf_entsize_local(name_loc->namelen,
@@ -2451,7 +2451,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *a
 	ASSERT(bp != NULL);
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
 	entry = &leaf->entries[ args->index ];
@@ -2515,7 +2515,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *arg
 	ASSERT(bp != NULL);
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
 	entry = &leaf->entries[ args->index ];
@@ -2585,13 +2585,13 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *a
 	}
 
 	leaf1 = bp1->data;
-	ASSERT(be16_to_cpu(leaf1->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf1->hdr.count));
 	ASSERT(args->index >= 0);
 	entry1 = &leaf1->entries[ args->index ];
 
 	leaf2 = bp2->data;
-	ASSERT(be16_to_cpu(leaf2->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index2 < be16_to_cpu(leaf2->hdr.count));
 	ASSERT(args->index2 >= 0);
 	entry2 = &leaf2->entries[ args->index2 ];
@@ -2689,9 +2689,9 @@ xfs_attr_root_inactive(xfs_trans_t **tra
 	 * This is a depth-first traversal!
 	 */
 	info = bp->data;
-	if (be16_to_cpu(info->magic) == XFS_DA_NODE_MAGIC) {
+	if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 		error = xfs_attr_node_inactive(trans, dp, bp, 1);
-	} else if (be16_to_cpu(info->magic) == XFS_ATTR_LEAF_MAGIC) {
+	} else if (info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) {
 		error = xfs_attr_leaf_inactive(trans, dp, bp);
 	} else {
 		error = XFS_ERROR(EIO);
@@ -2739,7 +2739,7 @@ xfs_attr_node_inactive(xfs_trans_t **tra
 	}
 
 	node = bp->data;
-	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	parent_blkno = xfs_da_blkno(bp);	/* save for re-read later */
 	count = be16_to_cpu(node->hdr.count);
 	if (!count) {
@@ -2773,10 +2773,10 @@ xfs_attr_node_inactive(xfs_trans_t **tra
 			 * Invalidate the subtree, however we have to.
 			 */
 			info = child_bp->data;
-			if (be16_to_cpu(info->magic) == XFS_DA_NODE_MAGIC) {
+			if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 				error = xfs_attr_node_inactive(trans, dp,
 						child_bp, level+1);
-			} else if (be16_to_cpu(info->magic) == XFS_ATTR_LEAF_MAGIC) {
+			} else if (info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) {
 				error = xfs_attr_leaf_inactive(trans, dp,
 						child_bp);
 			} else {
@@ -2836,7 +2836,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **tra
 	int error, count, size, tmp, i;
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 	/*
 	 * Count the number of "remote" value extents.
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-07-07 10:06:52.822060918 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-07-07 10:14:09.012038834 +0200
@@ -321,11 +321,11 @@ xfs_da_root_split(xfs_da_state_t *state,
 	ASSERT(bp != NULL);
 	node = bp->data;
 	oldroot = blk1->bp->data;
-	if (be16_to_cpu(oldroot->hdr.info.magic) == XFS_DA_NODE_MAGIC) {
+	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
 			     (char *)oldroot);
 	} else {
-		ASSERT(be16_to_cpu(oldroot->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+		ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 		leaf = (xfs_dir2_leaf_t *)oldroot;
 		size = (int)((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] -
 			     (char *)leaf);
@@ -352,7 +352,7 @@ xfs_da_root_split(xfs_da_state_t *state,
 	node->hdr.count = cpu_to_be16(2);
 
 #ifdef DEBUG
-	if (be16_to_cpu(oldroot->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC) {
+	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
 		ASSERT(blk1->blkno >= mp->m_dirleafblk &&
 		       blk1->blkno < mp->m_dirfreeblk);
 		ASSERT(blk2->blkno >= mp->m_dirleafblk &&
@@ -384,7 +384,7 @@ xfs_da_node_split(xfs_da_state_t *state,
 	int useextra;
 
 	node = oldblk->bp->data;
-	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 
 	/*
 	 * With V2 dirs the extra block is data or freespace.
@@ -483,8 +483,8 @@ xfs_da_node_rebalance(xfs_da_state_t *st
 		node1 = node2;
 		node2 = tmpnode;
 	}
-	ASSERT(be16_to_cpu(node1->hdr.info.magic) == XFS_DA_NODE_MAGIC);
-	ASSERT(be16_to_cpu(node2->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(node1->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	ASSERT(node2->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	count = (be16_to_cpu(node1->hdr.count) - be16_to_cpu(node2->hdr.count)) / 2;
 	if (count == 0)
 		return;
@@ -578,7 +578,7 @@ xfs_da_node_add(xfs_da_state_t *state, x
 	int tmp;
 
 	node = oldblk->bp->data;
-	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
 	ASSERT(newblk->blkno != 0);
 	if (state->args->whichfork == XFS_DATA_FORK)
@@ -714,7 +714,7 @@ xfs_da_root_join(xfs_da_state_t *state,
 	ASSERT(args != NULL);
 	ASSERT(root_blk->magic == XFS_DA_NODE_MAGIC);
 	oldroot = root_blk->bp->data;
-	ASSERT(be16_to_cpu(oldroot->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT(!oldroot->hdr.info.forw);
 	ASSERT(!oldroot->hdr.info.back);
 
@@ -737,10 +737,10 @@ xfs_da_root_join(xfs_da_state_t *state,
 	ASSERT(bp != NULL);
 	blkinfo = bp->data;
 	if (be16_to_cpu(oldroot->hdr.level) == 1) {
-		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DIR2_LEAFN_MAGIC ||
-		       be16_to_cpu(blkinfo->magic) == XFS_ATTR_LEAF_MAGIC);
+		ASSERT(blkinfo->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+		       blkinfo->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	} else {
-		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(blkinfo->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	}
 	ASSERT(!blkinfo->forw);
 	ASSERT(!blkinfo->back);
@@ -776,7 +776,7 @@ xfs_da_node_toosmall(xfs_da_state_t *sta
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
 	info = blk->bp->data;
-	ASSERT(be16_to_cpu(info->magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	node = (xfs_da_intnode_t *)info;
 	count = be16_to_cpu(node->hdr.count);
 	if (count > (state->node_ents >> 1)) {
@@ -836,7 +836,7 @@ xfs_da_node_toosmall(xfs_da_state_t *sta
 		count -= state->node_ents >> 2;
 		count -= be16_to_cpu(node->hdr.count);
 		node = bp->data;
-		ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		count -= be16_to_cpu(node->hdr.count);
 		xfs_da_brelse(state->args->trans, bp);
 		if (count >= 0)
@@ -911,7 +911,7 @@ xfs_da_fixhashpath(xfs_da_state_t *state
 	}
 	for (blk--, level--; level >= 0; blk--, level--) {
 		node = blk->bp->data;
-		ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		btree = &node->btree[ blk->index ];
 		if (be32_to_cpu(btree->hashval) == lasthash)
 			break;
@@ -979,8 +979,8 @@ xfs_da_node_unbalance(xfs_da_state_t *st
 
 	drop_node = drop_blk->bp->data;
 	save_node = save_blk->bp->data;
-	ASSERT(be16_to_cpu(drop_node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
-	ASSERT(be16_to_cpu(save_node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	ASSERT(save_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	tp = state->args->trans;
 
 	/*
@@ -1278,8 +1278,8 @@ xfs_da_node_order(xfs_dabuf_t *node1_bp,
 
 	node1 = node1_bp->data;
 	node2 = node2_bp->data;
-	ASSERT((be16_to_cpu(node1->hdr.info.magic) == XFS_DA_NODE_MAGIC) &&
-	       (be16_to_cpu(node2->hdr.info.magic) == XFS_DA_NODE_MAGIC));
+	ASSERT(node1->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) &&
+	       node2->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	if ((be16_to_cpu(node1->hdr.count) > 0) && (be16_to_cpu(node2->hdr.count) > 0) &&
 	    ((be32_to_cpu(node2->btree[0].hashval) <
 	      be32_to_cpu(node1->btree[0].hashval)) ||
@@ -1299,7 +1299,7 @@ xfs_da_node_lasthash(xfs_dabuf_t *bp, in
 	xfs_da_intnode_t *node;
 
 	node = bp->data;
-	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	if (count)
 		*count = be16_to_cpu(node->hdr.count);
 	if (!node->hdr.count)
@@ -1412,7 +1412,7 @@ xfs_da_path_shift(xfs_da_state_t *state,
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
 		ASSERT(blk->bp != NULL);
 		node = blk->bp->data;
-		ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		if (forward && (blk->index < be16_to_cpu(node->hdr.count)-1)) {
 			blk->index++;
 			blkno = be32_to_cpu(node->btree[blk->index].before);
@@ -1451,9 +1451,9 @@ xfs_da_path_shift(xfs_da_state_t *state,
 			return(error);
 		ASSERT(blk->bp != NULL);
 		info = blk->bp->data;
-		ASSERT(be16_to_cpu(info->magic) == XFS_DA_NODE_MAGIC ||
-		       be16_to_cpu(info->magic) == XFS_DIR2_LEAFN_MAGIC ||
-		       be16_to_cpu(info->magic) == XFS_ATTR_LEAF_MAGIC);
+		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+		       info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+		       info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 		blk->magic = be16_to_cpu(info->magic);
 		if (blk->magic == XFS_DA_NODE_MAGIC) {
 			node = (xfs_da_intnode_t *)info;
@@ -1704,12 +1704,12 @@ xfs_da_swap_lastblock(xfs_da_args_t *arg
 	/*
 	 * Get values from the moved block.
 	 */
-	if (be16_to_cpu(dead_info->magic) == XFS_DIR2_LEAFN_MAGIC) {
+	if (dead_info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
 		dead_level = 0;
 		dead_hash = be32_to_cpu(dead_leaf2->ents[be16_to_cpu(dead_leaf2->hdr.count) - 1].hashval);
 	} else {
-		ASSERT(be16_to_cpu(dead_info->magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		dead_node = (xfs_da_intnode_t *)dead_info;
 		dead_level = be16_to_cpu(dead_node->hdr.level);
 		dead_hash = be32_to_cpu(dead_node->btree[be16_to_cpu(dead_node->hdr.count) - 1].hashval);
@@ -1768,8 +1768,8 @@ xfs_da_swap_lastblock(xfs_da_args_t *arg
 		if ((error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w)))
 			goto done;
 		par_node = par_buf->data;
-		if (unlikely(
-		    be16_to_cpu(par_node->hdr.info.magic) != XFS_DA_NODE_MAGIC ||
+		if (unlikely(par_node->hdr.info.magic !=
+		    cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		    (level >= 0 && level != be16_to_cpu(par_node->hdr.level) + 1))) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
 					 XFS_ERRLEVEL_LOW, mp);
@@ -1820,7 +1820,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *arg
 		par_node = par_buf->data;
 		if (unlikely(
 		    be16_to_cpu(par_node->hdr.level) != level ||
-		    be16_to_cpu(par_node->hdr.info.magic) != XFS_DA_NODE_MAGIC)) {
+		    par_node->hdr.info.magic != cpu_to_be16(XFS_DA_NODE_MAGIC))) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
 					 XFS_ERRLEVEL_LOW, mp);
 			error = XFS_ERROR(EFSCORRUPTED);
@@ -2093,7 +2093,7 @@ xfs_da_do_buf(
 				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
 				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
 				   (magic1 != XFS_DIR2_DATA_MAGIC) &&
-				   (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC),
+				   (free->hdr.magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC)),
 				mp, XFS_ERRTAG_DA_READ_BUF,
 				XFS_RANDOM_DA_READ_BUF))) {
 			trace_xfs_da_btree_corrupt(rbp->bps[0], _RET_IP_);
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-07-07 10:06:52.832060917 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-07-07 10:14:09.012038834 +0200
@@ -109,7 +109,7 @@ xfs_dir2_block_addname(
 	/*
 	 * Check the magic number, corrupted if wrong.
 	 */
-	if (unlikely(be32_to_cpu(hdr->magic) != XFS_DIR2_BLOCK_MAGIC)) {
+	if (unlikely(hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))) {
 		XFS_CORRUPTION_ERROR("xfs_dir2_block_addname",
 				     XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_da_brelse(tp, bp);
@@ -255,7 +255,8 @@ xfs_dir2_block_addname(
 			highstale = lfloghigh = -1;
 		     fromidx >= 0;
 		     fromidx--) {
-			if (be32_to_cpu(blp[fromidx].address) == XFS_DIR2_NULL_DATAPTR) {
+			if (blp[fromidx].address ==
+			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
 				if (highstale == -1)
 					highstale = toidx;
 				else {
@@ -352,12 +353,14 @@ xfs_dir2_block_addname(
 	else {
 		for (lowstale = mid;
 		     lowstale >= 0 &&
-			be32_to_cpu(blp[lowstale].address) != XFS_DIR2_NULL_DATAPTR;
+			blp[lowstale].address !=
+			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
 		     lowstale--)
 			continue;
 		for (highstale = mid + 1;
 		     highstale < be32_to_cpu(btp->count) &&
-			be32_to_cpu(blp[highstale].address) != XFS_DIR2_NULL_DATAPTR &&
+			blp[highstale].address !=
+			cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
 			(lowstale < 0 || mid - lowstale > highstale - mid);
 		     highstale++)
 			continue;
@@ -899,7 +902,7 @@ xfs_dir2_leaf_to_block(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
 	 * If there are data blocks other than the first one, take this
@@ -929,7 +932,7 @@ xfs_dir2_leaf_to_block(
 		goto out;
 	}
 	hdr = dbp->data;
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 	/*
 	 * Size of the "leaf" area in the block.
 	 */
@@ -971,7 +974,8 @@ xfs_dir2_leaf_to_block(
 	 */
 	lep = xfs_dir2_block_leaf_p(btp);
 	for (from = to = 0; from < be16_to_cpu(leaf->hdr.count); from++) {
-		if (be32_to_cpu(leaf->ents[from].address) == XFS_DIR2_NULL_DATAPTR)
+		if (leaf->ents[from].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
 		lep[to++] = leaf->ents[from];
 	}
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-07 10:10:13.968717400 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-07 10:15:55.018700133 +0200
@@ -201,8 +201,8 @@ xfs_dir2_leaf_find_entry(
 		 */
 		for (lowstale = index - 1;
 		     lowstale >= 0 &&
-			be32_to_cpu(leaf->ents[lowstale].address) !=
-			XFS_DIR2_NULL_DATAPTR;
+			leaf->ents[lowstale].address !=
+			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
 		     lowstale--)
 			continue;
 
@@ -213,8 +213,8 @@ xfs_dir2_leaf_find_entry(
 		 */
 		for (highstale = index;
 		     highstale < be16_to_cpu(leaf->hdr.count) &&
-			be32_to_cpu(leaf->ents[highstale].address) !=
-			XFS_DIR2_NULL_DATAPTR &&
+			leaf->ents[highstale].address !=
+			cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
 			(lowstale < 0 ||
 			 index - lowstale - 1 >= highstale - index);
 		     highstale++)
@@ -228,8 +228,8 @@ xfs_dir2_leaf_find_entry(
 	    (highstale == be16_to_cpu(leaf->hdr.count) ||
 	     index - lowstale - 1 < highstale - index)) {
 		ASSERT(index - lowstale - 1 >= 0);
-		ASSERT(be32_to_cpu(leaf->ents[lowstale].address) ==
-		       XFS_DIR2_NULL_DATAPTR);
+		ASSERT(leaf->ents[lowstale].address ==
+		       cpu_to_be32(XFS_DIR2_NULL_DATAPTR));
 
 		/*
 		 * Copy entries up to cover the stale entry and make room
@@ -251,8 +251,8 @@ xfs_dir2_leaf_find_entry(
 	 * The high one is better, so use that one.
 	 */
 	ASSERT(highstale - index >= 0);
-	ASSERT(be32_to_cpu(leaf->ents[highstale].address) ==
-	       XFS_DIR2_NULL_DATAPTR);
+	ASSERT(leaf->ents[highstale].address ==
+	       cpu_to_be32(XFS_DIR2_NULL_DATAPTR));
 
 	/*
 	 * Copy entries down to cover the stale entry and make room for the
@@ -342,7 +342,7 @@ xfs_dir2_leaf_addname(
 			continue;
 		i = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 		ASSERT(i < be32_to_cpu(ltp->bestcount));
-		ASSERT(be16_to_cpu(bestsp[i]) != NULLDATAOFF);
+		ASSERT(bestsp[i] != cpu_to_be16(NULLDATAOFF));
 		if (be16_to_cpu(bestsp[i]) >= length) {
 			use_block = i;
 			break;
@@ -356,7 +356,8 @@ xfs_dir2_leaf_addname(
 			/*
 			 * Remember a block we see that's missing.
 			 */
-			if (be16_to_cpu(bestsp[i]) == NULLDATAOFF && use_block == -1)
+			if (bestsp[i] == cpu_to_be16(NULLDATAOFF) &&
+			    use_block == -1)
 				use_block = i;
 			else if (be16_to_cpu(bestsp[i]) >= length) {
 				use_block = i;
@@ -377,7 +378,7 @@ xfs_dir2_leaf_addname(
 	 * Now kill use_block if it refers to a missing block, so we
 	 * can use it as an indication of allocation needed.
 	 */
-	if (use_block != -1 && be16_to_cpu(bestsp[use_block]) == NULLDATAOFF)
+	if (use_block != -1 && bestsp[use_block] == cpu_to_be16(NULLDATAOFF))
 		use_block = -1;
 	/*
 	 * If we don't have enough free bytes but we can make enough
@@ -590,7 +591,7 @@ xfs_dir2_leaf_check(
 
 	leaf = bp->data;
 	mp = dp->i_mount;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	/*
 	 * This value is not restrictive enough.
 	 * Should factor in the size of the bests table as well.
@@ -610,7 +611,7 @@ xfs_dir2_leaf_check(
 		if (i + 1 < be16_to_cpu(leaf->hdr.count))
 			ASSERT(be32_to_cpu(leaf->ents[i].hashval) <=
 			       be32_to_cpu(leaf->ents[i + 1].hashval));
-		if (be32_to_cpu(leaf->ents[i].address) == XFS_DIR2_NULL_DATAPTR)
+		if (leaf->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	ASSERT(be16_to_cpu(leaf->hdr.stale) == stale);
@@ -639,7 +640,8 @@ xfs_dir2_leaf_compact(
 	 * Compress out the stale entries in place.
 	 */
 	for (from = to = 0, loglow = -1; from < be16_to_cpu(leaf->hdr.count); from++) {
-		if (be32_to_cpu(leaf->ents[from].address) == XFS_DIR2_NULL_DATAPTR)
+		if (leaf->ents[from].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
 		/*
 		 * Only actually copy the entries that are different.
@@ -696,7 +698,8 @@ xfs_dir2_leaf_compact_x1(
 	 */
 	for (lowstale = index - 1;
 	     lowstale >= 0 &&
-		be32_to_cpu(leaf->ents[lowstale].address) != XFS_DIR2_NULL_DATAPTR;
+		leaf->ents[lowstale].address !=
+		cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
 	     lowstale--)
 		continue;
 	/*
@@ -705,7 +708,8 @@ xfs_dir2_leaf_compact_x1(
 	 */
 	for (highstale = index;
 	     highstale < be16_to_cpu(leaf->hdr.count) &&
-		be32_to_cpu(leaf->ents[highstale].address) != XFS_DIR2_NULL_DATAPTR &&
+		leaf->ents[highstale].address !=
+		cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
 		(lowstale < 0 || index - lowstale > highstale - index);
 	     highstale++)
 		continue;
@@ -729,7 +733,8 @@ xfs_dir2_leaf_compact_x1(
 		if (index == from)
 			newindex = to;
 		if (from != keepstale &&
-		    be32_to_cpu(leaf->ents[from].address) == XFS_DIR2_NULL_DATAPTR) {
+		    leaf->ents[from].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
 			if (from == to)
 				*lowlogp = to;
 			continue;
@@ -1207,7 +1212,7 @@ xfs_dir2_leaf_log_bests(
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp, leaf);
 	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
 	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
@@ -1230,8 +1235,8 @@ xfs_dir2_leaf_log_ents(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC ||
-	       be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	firstlep = &leaf->ents[first];
 	lastlep = &leaf->ents[last];
 	xfs_da_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
@@ -1249,8 +1254,8 @@ xfs_dir2_leaf_log_header(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC ||
-	       be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	xfs_da_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
 		(uint)(sizeof(leaf->hdr) - 1));
 }
@@ -1269,7 +1274,7 @@ xfs_dir2_leaf_log_tail(
 
 	mp = tp->t_mountp;
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	xfs_da_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
 		(uint)(mp->m_dirblksize - 1));
@@ -1570,7 +1575,7 @@ xfs_dir2_leaf_removename(
 			 * Look for the last active entry (i).
 			 */
 			for (i = db - 1; i > 0; i--) {
-				if (be16_to_cpu(bestsp[i]) != NULLDATAOFF)
+				if (bestsp[i] != cpu_to_be16(NULLDATAOFF))
 					break;
 			}
 			/*
@@ -1740,7 +1745,7 @@ xfs_dir2_leaf_trim_data(
 {
 	struct xfs_dir2_data_hdr *hdr = dbp->data;
 
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 	ASSERT(be16_to_cpu(hdr->bestfree[0].length) ==
 	       mp->m_dirblksize - (uint)sizeof(*hdr));
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
@@ -1850,7 +1855,7 @@ xfs_dir2_node_to_leaf(
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
 	 * Read the freespace block.
 	 */
@@ -1859,7 +1864,7 @@ xfs_dir2_node_to_leaf(
 		return error;
 	}
 	free = fbp->data;
-	ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	ASSERT(!free->hdr.firstdb);
 
 	/*
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2011-07-07 10:06:52.855394248 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2011-07-07 10:17:09.442029700 +0200
@@ -73,7 +73,7 @@ xfs_dir2_free_log_bests(
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
 	free = bp->data;
-	ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	xfs_da_log_buf(tp, bp,
 		(uint)((char *)&free->bests[first] - (char *)free),
 		(uint)((char *)&free->bests[last] - (char *)free +
@@ -91,7 +91,7 @@ xfs_dir2_free_log_header(
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
 	free = bp->data;
-	ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	xfs_da_log_buf(tp, bp, (uint)((char *)&free->hdr - (char *)free),
 		(uint)(sizeof(xfs_dir2_free_hdr_t) - 1));
 }
@@ -276,14 +276,14 @@ xfs_dir2_leafn_check(
 
 	leaf = bp->data;
 	mp = dp->i_mount;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
 	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
 		if (i + 1 < be16_to_cpu(leaf->hdr.count)) {
 			ASSERT(be32_to_cpu(leaf->ents[i].hashval) <=
 			       be32_to_cpu(leaf->ents[i + 1].hashval));
 		}
-		if (be32_to_cpu(leaf->ents[i].address) == XFS_DIR2_NULL_DATAPTR)
+		if (leaf->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	ASSERT(be16_to_cpu(leaf->hdr.stale) == stale);
@@ -302,7 +302,7 @@ xfs_dir2_leafn_lasthash(
 	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
 
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	if (count)
 		*count = be16_to_cpu(leaf->hdr.count);
 	if (!leaf->hdr.count)
@@ -341,7 +341,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 #ifdef __KERNEL__
 	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
 #endif
@@ -358,7 +358,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		curbp = state->extrablk.bp;
 		curfdb = state->extrablk.blkno;
 		free = curbp->data;
-		ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	}
 	length = xfs_dir2_data_entsize(args->namelen);
 	/*
@@ -424,7 +424,8 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * If it has room, return it.
 			 */
-			if (unlikely(be16_to_cpu(free->bests[fi]) == NULLDATAOFF)) {
+			if (unlikely(free->bests[fi] ==
+			    cpu_to_be16(NULLDATAOFF))) {
 				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
 							XFS_ERRLEVEL_LOW, mp);
 				if (curfdb != newfdb)
@@ -485,7 +486,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 #ifdef __KERNEL__
 	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
 #endif
@@ -666,7 +667,8 @@ xfs_dir2_leafn_moveents(
 		int	i;			/* temp leaf index */
 
 		for (i = start_s, stale = 0; i < start_s + count; i++) {
-			if (be32_to_cpu(leaf_s->ents[i].address) == XFS_DIR2_NULL_DATAPTR)
+			if (leaf_s->ents[i].address ==
+			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
 		}
 	} else
@@ -713,8 +715,8 @@ xfs_dir2_leafn_order(
 
 	leaf1 = leaf1_bp->data;
 	leaf2 = leaf2_bp->data;
-	ASSERT(be16_to_cpu(leaf1->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
-	ASSERT(be16_to_cpu(leaf2->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	if (be16_to_cpu(leaf1->hdr.count) > 0 &&
 	    be16_to_cpu(leaf2->hdr.count) > 0 &&
 	    (be32_to_cpu(leaf2->ents[0].hashval) < be32_to_cpu(leaf1->ents[0].hashval) ||
@@ -862,7 +864,7 @@ xfs_dir2_leafn_remove(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->data;
-	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
 	 * Point to the entry we're removing.
 	 */
@@ -924,7 +926,7 @@ xfs_dir2_leafn_remove(
 			return error;
 		}
 		free = fbp->data;
-		ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
 		       XFS_DIR2_MAX_FREE_BESTS(mp) *
 		       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
@@ -976,7 +978,8 @@ xfs_dir2_leafn_remove(
 				int	i;		/* free entry index */
 
 				for (i = findex - 1;
-				     i >= 0 && be16_to_cpu(free->bests[i]) == NULLDATAOFF;
+				     i >= 0 &&
+				     free->bests[i] == cpu_to_be16(NULLDATAOFF);
 				     i--)
 					continue;
 				free->hdr.nvalid = cpu_to_be32(i + 1);
@@ -1133,7 +1136,7 @@ xfs_dir2_leafn_toosmall(
 	 */
 	blk = &state->path.blk[state->path.active - 1];
 	info = blk->bp->data;
-	ASSERT(be16_to_cpu(info->magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	leaf = (xfs_dir2_leaf_t *)info;
 	count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
 	bytes = (uint)sizeof(leaf->hdr) + count * (uint)sizeof(leaf->ents[0]);
@@ -1192,7 +1195,7 @@ xfs_dir2_leafn_toosmall(
 		count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
 		bytes = state->blocksize - (state->blocksize >> 2);
 		leaf = bp->data;
-		ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 		count += be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
 		bytes -= count * (uint)sizeof(leaf->ents[0]);
 		/*
@@ -1251,8 +1254,8 @@ xfs_dir2_leafn_unbalance(
 	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	drop_leaf = drop_blk->bp->data;
 	save_leaf = save_blk->bp->data;
-	ASSERT(be16_to_cpu(drop_leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
-	ASSERT(be16_to_cpu(save_leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
 	 * If there are any stale leaf entries, take this opportunity
 	 * to purge them.
@@ -1393,7 +1396,7 @@ xfs_dir2_node_addname_int(
 		 */
 		ifbno = fblk->blkno;
 		free = fbp->data;
-		ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		findex = fblk->index;
 		/*
 		 * This means the free entry showed that the data block had
@@ -1477,7 +1480,7 @@ xfs_dir2_node_addname_int(
 				continue;
 			}
 			free = fbp->data;
-			ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 			findex = 0;
 		}
 		/*
@@ -1609,7 +1612,7 @@ xfs_dir2_node_addname_int(
 			free->hdr.nused = 0;
 		} else {
 			free = fbp->data;
-			ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		}
 
 		/*
@@ -1632,7 +1635,7 @@ xfs_dir2_node_addname_int(
 		 * If this entry was for an empty data block
 		 * (this should always be true) then update the header.
 		 */
-		if (be16_to_cpu(free->bests[findex]) == NULLDATAOFF) {
+		if (free->bests[findex] == cpu_to_be16(NULLDATAOFF)) {
 			be32_add_cpu(&free->hdr.nused, 1);
 			xfs_dir2_free_log_header(tp, fbp);
 		}
@@ -1902,7 +1905,7 @@ xfs_dir2_node_replace(
 		 * Point to the data entry.
 		 */
 		hdr = state->extrablk.bp->data;
-		ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
@@ -1968,7 +1971,7 @@ xfs_dir2_node_trim_free(
 		return 0;
 	}
 	free = bp->data;
-	ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
+	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	/*
 	 * If there are used entries, there's nothing to do.
 	 */
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-07-07 10:06:52.865394250 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-07-07 10:19:01.592024021 +0200
@@ -167,7 +167,7 @@ xfs_imap_to_bp(
 
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_magic) == XFS_DINODE_MAGIC &&
+		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
 			    XFS_DINODE_GOOD_VERSION(dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
@@ -802,7 +802,7 @@ xfs_iread(
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
-	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
+	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC)) {
 #ifdef DEBUG
 		xfs_alert(mp,
 			"%s: dip->di_magic (0x%x) != XFS_DINODE_MAGIC (0x%x)",
@@ -1456,7 +1456,7 @@ xfs_iunlink(
 	ASSERT(agi->agi_unlinked[bucket_index]);
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
 
-	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != NULLAGINO) {
+	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
 		/*
 		 * There is already another inode in the bucket we need
 		 * to add ourselves to.  Add us at the front of the list.
@@ -1467,8 +1467,7 @@ xfs_iunlink(
 		if (error)
 			return error;
 
-		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
-		/* both on-disk, don't endian flip twice */
+		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
 		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
@@ -1533,7 +1532,7 @@ xfs_iunlink_remove(
 	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	ASSERT(agino != 0);
 	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != NULLAGINO);
+	ASSERT(agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO));
 	ASSERT(agi->agi_unlinked[bucket_index]);
 
 	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
@@ -2658,7 +2657,7 @@ xfs_iflush_int(
 	 */
 	xfs_synchronize_times(ip);
 
-	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC,
+	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-07-07 10:06:52.875394249 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-07-07 10:14:09.025372166 +0200
@@ -300,14 +300,14 @@ xlog_header_check_recover(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	ASSERT(be32_to_cpu(head->h_magicno) == XLOG_HEADER_MAGIC_NUM);
+	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
 	/*
 	 * IRIX doesn't write the h_fmt field and leaves it zeroed
 	 * (XLOG_FMT_UNKNOWN). This stops us from trying to recover
 	 * a dirty log created in IRIX.
 	 */
-	if (unlikely(be32_to_cpu(head->h_fmt) != XLOG_FMT)) {
+	if (unlikely(head->h_fmt != cpu_to_be32(XLOG_FMT))) {
 		xfs_warn(mp,
 	"dirty log written in incompatible format - can't recover");
 		xlog_header_check_dump(mp, head);
@@ -333,7 +333,7 @@ xlog_header_check_mount(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	ASSERT(be32_to_cpu(head->h_magicno) == XLOG_HEADER_MAGIC_NUM);
+	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
 	if (uuid_is_nil(&head->h_fs_uuid)) {
 		/*
@@ -534,7 +534,7 @@ xlog_find_verify_log_record(
 
 		head = (xlog_rec_header_t *)offset;
 
-		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(head->h_magicno))
+		if (head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			break;
 
 		if (!smallmem)
@@ -916,7 +916,7 @@ xlog_find_tail(
 		if (error)
 			goto done;
 
-		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
+		if (*(__be32 *)offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
 			found = 1;
 			break;
 		}
@@ -933,8 +933,8 @@ xlog_find_tail(
 			if (error)
 				goto done;
 
-			if (XLOG_HEADER_MAGIC_NUM ==
-			    be32_to_cpu(*(__be32 *)offset)) {
+			if (*(__be32 *)offset ==
+			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
 				found = 2;
 				break;
 			}
@@ -1947,7 +1947,7 @@ xfs_qm_dqcheck(
 	 * This is all fine; things are still consistent, and we haven't lost
 	 * any quota information. Just don't complain about bad dquot blks.
 	 */
-	if (be16_to_cpu(ddq->d_magic) != XFS_DQUOT_MAGIC) {
+	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC)) {
 		if (flags & XFS_QMOPT_DOWARN)
 			xfs_alert(mp,
 			"%s : XFS dquot ID 0x%x, magic 0x%x != 0x%x",
@@ -2238,7 +2238,7 @@ xlog_recover_inode_pass2(
 	 * Make sure the place we're flushing out to really looks
 	 * like an inode!
 	 */
-	if (unlikely(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)) {
+	if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
 		xfs_buf_relse(bp);
 		xfs_alert(mp,
 	"%s: Bad inode magic number, dip = 0x%p, dino bp = 0x%p, ino = %Ld",
@@ -3295,7 +3295,7 @@ xlog_valid_rec_header(
 {
 	int			hlen;
 
-	if (unlikely(be32_to_cpu(rhead->h_magicno) != XLOG_HEADER_MAGIC_NUM)) {
+	if (unlikely(rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(1)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
 		return XFS_ERROR(EFSCORRUPTED);
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-07-07 10:06:52.885394248 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-07-07 10:14:09.028705499 +0200
@@ -2127,7 +2127,7 @@ xfs_read_agf(
 	 * Validate the magic number of the agf block.
 	 */
 	agf_ok =
-		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
+		agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-07-07 10:06:52.895394247 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-07-07 10:14:09.032038832 +0200
@@ -4083,7 +4083,7 @@ xfs_bmap_sanity_check(
 {
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC ||
+	if (block->bb_magic != cpu_to_be32(XFS_BMAP_MAGIC) ||
 	    be16_to_cpu(block->bb_level) != level ||
 	    be16_to_cpu(block->bb_numrecs) == 0 ||
 	    be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2011-07-07 10:06:52.908727579 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2011-07-07 10:14:09.032038832 +0200
@@ -425,10 +425,10 @@ xfs_bmbt_to_bmdr(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
-	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_rightsib) == NULLDFSBNO);
-	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_MAGIC));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO));
+	ASSERT(rblock->bb_level != 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2011-07-07 10:06:52.918727579 +0200
+++ xfs/fs/xfs/xfs_btree.c	2011-07-07 10:14:09.035372165 +0200
@@ -66,11 +66,11 @@ xfs_btree_check_lblock(
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
 		block->bb_u.l.bb_leftsib &&
-		(be64_to_cpu(block->bb_u.l.bb_leftsib) == NULLDFSBNO ||
+		(block->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO) ||
 		 XFS_FSB_SANITY_CHECK(mp,
 		 	be64_to_cpu(block->bb_u.l.bb_leftsib))) &&
 		block->bb_u.l.bb_rightsib &&
-		(be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO ||
+		(block->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO) ||
 		 XFS_FSB_SANITY_CHECK(mp,
 		 	be64_to_cpu(block->bb_u.l.bb_rightsib)));
 	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
@@ -105,10 +105,10 @@ xfs_btree_check_sblock(
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
-		(be32_to_cpu(block->bb_u.s.bb_leftsib) == NULLAGBLOCK ||
+		(block->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) ||
 		 be32_to_cpu(block->bb_u.s.bb_leftsib) < agflen) &&
 		block->bb_u.s.bb_leftsib &&
-		(be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK ||
+		(block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK) ||
 		 be32_to_cpu(block->bb_u.s.bb_rightsib) < agflen) &&
 		block->bb_u.s.bb_rightsib;
 	if (unlikely(XFS_TEST_ERROR(!sblock_ok, cur->bc_mp,
@@ -511,9 +511,9 @@ xfs_btree_islastblock(
 	block = xfs_btree_get_block(cur, level, &bp);
 	xfs_btree_check_block(cur, block, level, bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO;
+		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO);
 	else
-		return be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK;
+		return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
 }
 
 /*
@@ -777,14 +777,14 @@ xfs_btree_setbuf(
 
 	b = XFS_BUF_TO_BLOCK(bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		if (be64_to_cpu(b->bb_u.l.bb_leftsib) == NULLDFSBNO)
+		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO))
 			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
-		if (be64_to_cpu(b->bb_u.l.bb_rightsib) == NULLDFSBNO)
+		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO))
 			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
 	} else {
-		if (be32_to_cpu(b->bb_u.s.bb_leftsib) == NULLAGBLOCK)
+		if (b->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK))
 			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
-		if (be32_to_cpu(b->bb_u.s.bb_rightsib) == NULLAGBLOCK)
+		if (b->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
 			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
 	}
 }
@@ -795,9 +795,9 @@ xfs_btree_ptr_is_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return be64_to_cpu(ptr->l) == NULLDFSBNO;
+		return ptr->l == cpu_to_be64(NULLDFSBNO);
 	else
-		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
+		return ptr->s == cpu_to_be32(NULLAGBLOCK);
 }
 
 STATIC void
@@ -923,12 +923,12 @@ xfs_btree_ptr_to_daddr(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(be64_to_cpu(ptr->l) != NULLDFSBNO);
+		ASSERT(ptr->l != cpu_to_be64(NULLDFSBNO));
 
 		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
 	} else {
 		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
-		ASSERT(be32_to_cpu(ptr->s) != NULLAGBLOCK);
+		ASSERT(ptr->s != cpu_to_be32(NULLAGBLOCK));
 
 		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
 					be32_to_cpu(ptr->s));
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-07-07 10:06:52.928727580 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2011-07-07 10:14:09.035372165 +0200
@@ -73,7 +73,7 @@ xfs_dir2_data_check(
 	bf = hdr->bestfree;
 	p = (char *)(hdr + 1);
 
-	if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
@@ -140,7 +140,7 @@ xfs_dir2_data_check(
 		       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
-		if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
+		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
@@ -160,9 +160,10 @@ xfs_dir2_data_check(
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
 	ASSERT(freeseen == 7);
-	if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
-			if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
+			if (lep[i].address ==
+			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
 			if (i > 0)
 				ASSERT(be32_to_cpu(lep[i].hashval) >= be32_to_cpu(lep[i - 1].hashval));
@@ -196,8 +197,8 @@ xfs_dir2_data_freefind(
 	 * Check order, non-overlapping entries, and if we find the
 	 * one we're looking for it has to be exact.
 	 */
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 	for (dfp = &hdr->bestfree[0], seenzero = matched = 0;
 	     dfp < &hdr->bestfree[XFS_DIR2_DATA_FD_COUNT];
 	     dfp++) {
@@ -256,8 +257,8 @@ xfs_dir2_data_freeinsert(
 	xfs_dir2_data_free_t	new;		/* new bestfree entry */
 
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 #endif
 	dfp = hdr->bestfree;
 	new.length = dup->length;
@@ -297,8 +298,8 @@ xfs_dir2_data_freeremove(
 	int			*loghead)	/* out: log data header */
 {
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 #endif
 	/*
 	 * It's the first entry, slide the next 2 up.
@@ -341,8 +342,8 @@ xfs_dir2_data_freescan(
 	char			*p;		/* current entry pointer */
 
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 #endif
 	/*
 	 * Start by clearing the table.
@@ -353,7 +354,7 @@ xfs_dir2_data_freescan(
 	 * Set up pointers.
 	 */
 	p = (char *)(hdr + 1);
-	if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
@@ -458,8 +459,8 @@ xfs_dir2_data_log_entry(
 {
 	xfs_dir2_data_hdr_t	*hdr = bp->data;
 
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
 	xfs_da_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
 		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
@@ -476,8 +477,8 @@ xfs_dir2_data_log_header(
 {
 	xfs_dir2_data_hdr_t	*hdr = bp->data;
 
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
 	xfs_da_log_buf(tp, bp, 0, sizeof(*hdr) - 1);
 }
@@ -493,8 +494,8 @@ xfs_dir2_data_log_unused(
 {
 	xfs_dir2_data_hdr_t	*hdr = bp->data;
 
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
 	/*
 	 * Log the first part of the unused entry.
@@ -539,12 +540,12 @@ xfs_dir2_data_make_free(
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	if (be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC)
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 		endptr = (char *)hdr + mp->m_dirblksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
-		ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
@@ -717,8 +718,8 @@ xfs_dir2_data_use_free(
 	int			oldlen;		/* old unused entry's length */
 
 	hdr = bp->data;
-	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
 	ASSERT(offset >= (char *)dup - (char *)hdr);
 	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)hdr);
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2011-07-07 10:06:52.938727579 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2011-07-07 10:18:00.902026708 +0200
@@ -683,7 +683,7 @@ xfs_dialloc(
 			return 0;
 		}
 		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 	} else {
 		/*
 		 * Continue where we left off before.  In this case, we
@@ -691,7 +691,7 @@ xfs_dialloc(
 		 */
 		agbp = *IO_agbp;
 		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 		ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
 	}
 	mp = tp->t_mountp;
@@ -775,7 +775,7 @@ nextag:
 		if (error)
 			goto nextag;
 		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 	}
 	/*
 	 * Here with an allocation group that has a free inode.
@@ -944,7 +944,7 @@ nextag:
 	 * See if the most recently allocated block has any free.
 	 */
 newino:
-	if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
+	if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
 		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
 					 XFS_LOOKUP_EQ, &i);
 		if (error)
@@ -1085,7 +1085,7 @@ xfs_difree(
 		return error;
 	}
 	agi = XFS_BUF_TO_AGI(agbp);
-	ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
+	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 	ASSERT(agbno < be32_to_cpu(agi->agi_length));
 	/*
 	 * Initialize the cursor.
@@ -1438,7 +1438,7 @@ xfs_ialloc_log_agi(
 	xfs_agi_t		*agi;	/* allocation group header */
 
 	agi = XFS_BUF_TO_AGI(bp);
-	ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
+	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 #endif
 	/*
 	 * Compute byte offsets for the first and last fields.
@@ -1492,7 +1492,7 @@ xfs_read_agi(
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi_ok = be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
+	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
 		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
 		be32_to_cpu(agi->agi_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-07-07 10:06:52.948727578 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-07-07 10:14:09.042038831 +0200
@@ -3521,13 +3521,13 @@ xlog_verify_iclog(xlog_t	 *log,
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
-	if (be32_to_cpu(iclog->ic_header.h_magicno) != XLOG_HEADER_MAGIC_NUM)
+	if (iclog->ic_header.h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
 
 	ptr = (xfs_caddr_t) &iclog->ic_header;
 	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&iclog->ic_header) + count;
 	     ptr += BBSIZE) {
-		if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
+		if (*(__be32 *)ptr == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			xfs_emerg(log->l_mp, "%s: unexpected magic num",
 				__func__);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
