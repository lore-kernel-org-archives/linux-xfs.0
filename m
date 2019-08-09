Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbfHIVhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LZGgc072437
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:46 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNLFT071981
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxjwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Lbhcp018997
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 15/18] xfs: Add delayed attribute routines
Date: Fri,  9 Aug 2019 14:37:23 -0700
Message-Id: <20190809213726.32336-16-allison.henderson@oracle.com>
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds new delayed attribute routines:

xfs_attr_da_set_args
xfs_attr_da_remove_args
xfs_attr_da_leaf_addname
xfs_attr_da_node_addname
xfs_attr_da_node_removename

These routines are similar to their existing counter parts,
but they do not roll or commit transactions.  They instead
return -EGAIN to allow the calling function to roll the
transaction and recall the function.  This allows the
attribute operations to be logged in multiple smaller
transactions.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 720 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr.h |   2 +
 2 files changed, 722 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ca57202..9931e50 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -47,6 +47,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_da_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);         
 
@@ -55,12 +56,16 @@ STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_da_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_da_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
+STATIC int
+xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 int
 xfs_attr_args_init(
@@ -282,6 +287,117 @@ xfs_attr_set_args(
 }
 
 /*
+ * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_da_set_args(
+	struct xfs_da_args	*args,
+	struct xfs_buf          **leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error = 0;
+	int			sf_size;
+	struct xfs_buf          *bp;
+	struct xfs_buf_log_item *bip;
+
+	/*
+	 * New inodes may not have an attribute fork yet. So set the attribute
+	 * fork appropriately
+	 */
+	if (XFS_IFORK_Q((args->dp)) == 0) {
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+	}
+
+	/*
+	 * If the attribute list is non-existent or a shortform list,
+	 * upgrade it to a single-leaf-block attribute list.
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_d.di_anextents == 0)) {
+		/*
+		 * Build initial attribute list (if required).
+		 */
+		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+			xfs_attr_shortform_create(args);
+
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		if (error)
+			return error;
+
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+
+		xfs_trans_bhold(args->trans, *leaf_bp);
+		return -EAGAIN;
+	}
+
+	/*
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cylce out the transaction.  When we get back, we need to release
+	 * the leaf.
+	 */
+	if (*leaf_bp != NULL) {
+		bp = *leaf_bp;
+		bip = (struct xfs_buf_log_item *)(bp->b_log_item);
+		if (bp->b_transp == args->trans)
+			xfs_trans_brelse(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
+
+	/*
+	 * If we fit in a block, or we are in the middle of adding a leaf name.
+	 * xfs_attr_da_leaf_addname will set the XFS_DC_ALLOC_LEAF to indicate
+	 * that it is not done yet, and need to be recalled to finish up from
+	 * the last EAGAIN it returned
+	 */
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) ||
+	    args->dc.flags & XFS_DC_ALLOC_LEAF) {
+		if (!(args->dc.flags & XFS_DC_FOUND_LBLK)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			args->dc.flags |= XFS_DC_FOUND_LBLK;
+
+			if (error && error != -ENOSPC)
+				return error;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_da_leaf_addname(args);
+		if (error && error != -ENOSPC)
+			return error;
+	} else {
+		error = xfs_attr_da_node_addname(args);
+	}
+
+	return error;
+}
+
+
+
+/*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
 int
@@ -331,6 +447,57 @@ xfs_attr_remove_args(
 	return error;
 }
 
+/*
+ * Remove the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_da_remove_args(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp;
+	int			forkoff, error = 0;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) &&
+		   !(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
+		/*
+		 * If we fit in a block AND we are not in the middle of
+		 * removing node blocks, remove the leaf attribute.
+		 * xfs_attr_da_node_removename will set XFS_DC_RM_NODE_BLKS to
+		 * signal that it is not done yet, and needs to be recalled to
+		 * to finish up from the last -EAGAIN
+		 */
+		error = xfs_leaf_has_attr(args, &bp);
+		if (error == -ENOATTR) {
+			xfs_trans_brelse(args->trans, bp);
+			return error;
+		}
+		error = 0;
+
+		xfs_attr3_leaf_remove(bp, args);
+
+		/* If the result is small enough, shrink it into the inode.*/
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+	} else {
+		error = xfs_attr_da_node_removename(args);
+	}
+
+	return error;
+}
+
+
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -834,6 +1001,150 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 }
 
 /*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+STATIC int
+xfs_attr_da_leaf_addname(
+	struct xfs_da_args	*args)
+{
+	int			error, forkoff, nmap;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_bmbt_irec	*map = &args->dc.map;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		if (!(args->dc.flags & XFS_DC_ALLOC_LEAF)) {
+			args->dc.lfileoff = 0;
+			args->dc.lblkno = 0;
+			args->dc.blkcnt = 0;
+			memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+			error = xfs_attr_rmt_find_hole(args, &args->dc.blkcnt,
+						       &args->dc.lfileoff);
+			if (error)
+				return error;
+
+			args->dc.lblkno = (xfs_dablk_t)args->dc.lfileoff;
+			args->dc.flags |= XFS_DC_ALLOC_LEAF;
+		}
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		while (args->dc.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+				  (xfs_fileoff_t)args->dc.lblkno,
+				  args->dc.blkcnt, XFS_BMAPI_ATTRFORK,
+				  args->total, map, &nmap);
+			if (error)
+				return error;
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dc.lblkno += map->br_blockcount;
+			args->dc.blkcnt -= map->br_blockcount;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the
+	 * incomplete flags on the "new" and "old" attribute/value pairs
+	 * so that one disappears and one appears atomically.  Then we
+	 * must remove the "old" attribute/value pair.
+	 */
+	if (args->op_flags & XFS_DA_OP_RENAME) {
+		/*
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+		if (!xfs_attr3_leaf_flagsflipped(args)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			return -EAGAIN;
+		}
+		/*
+		 * Dismantle the "old" attribute/value pair by removing
+		 * a "remote" value (if it exists).
+		 */
+		args->index = args->index2;
+		args->blkno = args->blkno2;
+		args->rmtblkno = args->rmtblkno2;
+		args->rmtblkcnt = args->rmtblkcnt2;
+		args->rmtvaluelen = args->rmtvaluelen2;
+		if (args->rmtblkno) {
+			int done = 0;
+
+			error = xfs_attr_rmtval_remove_value(args);
+			if (error)
+				return error;
+
+			while (!done && !error)
+				error = xfs_bunmapi(args->trans,
+				    args->dp, args->rmtblkno,
+				    args->rmtblkcnt, XFS_BMAPI_ATTRFORK,
+				    1, &done);
+
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then
+		 * remove the "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   -1, &bp);
+		if (error)
+			return error;
+
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff) {
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+			if (error)
+				return error;
+		}
+	} else if (args->rmtblkno > 0) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		error = xfs_attr3_leaf_clearflag(args);
+	}
+	args->dc.flags &= ~XFS_DC_ALLOC_LEAF;
+	return error;
+}
+
+/*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
 STATIC int
@@ -1329,6 +1640,415 @@ xfs_attr_node_removename(
 }
 
 /*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This will involve walking down the Btree, and may involve joining
+ * leaf nodes and even joining intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions
+ * will need to handle this, and recall the function until a successful error
+ * code is returned.
+ */
+STATIC int
+xfs_attr_da_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_buf		*bp;
+	int			error, forkoff, retval = 0;
+	struct xfs_inode	*dp = args->dp;
+	int			done = 0;
+
+	trace_xfs_attr_node_removename(args);
+
+	if (args->dc.state == NULL) {
+		error = xfs_attr_node_hasname(args, &args->dc.state);
+		if (error != -EEXIST)
+			goto out;
+		else
+			error = 0;
+
+		/*
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
+		 */
+		state = args->dc.state;
+		args->dc.blk = &state->path.blk[state->path.active - 1];
+		ASSERT(args->dc.blk->bp != NULL);
+		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
+	}
+	state = args->dc.state;
+	blk = args->dc.blk;
+
+	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
+		if (!xfs_attr3_leaf_flag_is_set(args)) {
+			/*
+			 * Fill in disk block numbers in the state structure
+			 * so that we can get the buffers back after we commit
+			 * several transactions in the following calls.
+			 */
+			error = xfs_attr_fillstate(state);
+			if (error)
+				goto out;
+
+			/*
+			 * Mark the attribute as INCOMPLETE, then bunmapi() the
+			 * remote value.
+			 */
+			error = xfs_attr3_leaf_setflag(args);
+			if (error)
+				goto out;
+
+			return -EAGAIN;
+		}
+
+		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
+			error = xfs_attr_rmtval_remove_value(args);
+			if (error)
+				goto out;
+		}
+
+		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
+		while (!done && !error) {
+			error = xfs_bunmapi(args->trans, args->dp,
+				    args->rmtblkno, args->rmtblkcnt,
+				    XFS_BMAPI_ATTRFORK, 1, &done);
+			if (error)
+				return error;
+
+			if (!done)
+				return -EAGAIN;
+		}
+
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
+		if (error)
+			goto out;
+	}
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	if (!(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
+		blk = &state->path.blk[state->path.active - 1];
+		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+		retval = xfs_attr3_leaf_remove(blk->bp, args);
+		xfs_da3_fixhashpath(state, &state->path);
+
+		args->dc.flags |= XFS_DC_RM_LEAF_BLKS;
+	}
+
+	/*
+	 * Check to see if the tree needs to be collapsed.
+	 */
+	if (retval && (state->path.active > 1)) {
+		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
+		error = xfs_da3_join(state);
+		if (error)
+			goto out;
+
+		return -EAGAIN;
+	}
+
+	/*
+	 * If the result is small enough, push it all into the inode.
+	 */
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		/*
+		 * Have to get rid of the copy of this dabuf in the state.
+		 */
+		ASSERT(state->path.active == 1);
+		ASSERT(state->path.blk[0].bp);
+		state->path.blk[0].bp = NULL;
+
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		if (error)
+			goto out;
+
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff) {
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+			if (error)
+				goto out;
+		} else
+			xfs_trans_brelse(args->trans, bp);
+	}
+out:
+	if (state != NULL)
+		xfs_da_state_free(state);
+
+	return error;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
+ */
+STATIC int
+xfs_attr_da_node_addname(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	struct xfs_mount	*mp;
+	int			retval, error = 0;
+	int			nmap;
+	int			done = 0;
+	struct xfs_bmbt_irec    *map = &args->dc.map;
+
+	trace_xfs_attr_node_addname(args);
+
+	/*
+	 * Fill in bucket of arguments/results/context to carry around.
+	 */
+	dp = args->dp;
+	mp = dp->i_mount;
+
+	if (args->dc.flags & XFS_DC_FOUND_NBLK)
+		goto found_blk;
+
+	/*
+	 * Search to see if name already exists, and get back a pointer
+	 * to where it should go.
+	 */
+	retval = xfs_attr_node_hasname(args, &state);
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+		goto out;
+	} else if (retval == -EEXIST) {
+		if (args->flags & ATTR_CREATE)
+			goto out;
+
+		trace_xfs_attr_node_replace(args);
+
+		/* save the attribute state for later removal*/
+		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
+		args->blkno2 = args->blkno;		/* set 2nd entry info*/
+		args->index2 = args->index;
+		args->rmtblkno2 = args->rmtblkno;
+		args->rmtblkcnt2 = args->rmtblkcnt;
+		args->rmtvaluelen2 = args->rmtvaluelen;
+
+		/*
+		 * clear the remote attr state now that it is saved so that the
+		 * values reflect the state of the attribute we are about to
+		 * add, not the attribute we just found and will remove later.
+		 */
+		args->rmtblkno = 0;
+		args->rmtblkcnt = 0;
+		args->rmtvaluelen = 0;
+	}
+
+	retval = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (retval == -ENOSPC) {
+		if (state->path.active == 1) {
+			/*
+			 * Its really a single leaf node, but it had
+			 * out-of-line values so it looked like it *might*
+			 * have been a b-tree.
+			 */
+			xfs_da_state_free(state);
+			state = NULL;
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				goto out;
+
+			return -EAGAIN;
+		}
+
+		/*
+		 * Split as many Btree elements as required.
+		 * This code tracks the new and old attr's location
+		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
+		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
+		 */
+		error = xfs_da3_split(state);
+		if (error)
+			goto out;
+	} else {
+		/*
+		 * Addition succeeded, update Btree hashvals.
+		 */
+		xfs_da3_fixhashpath(state, &state->path);
+	}
+
+	/*
+	 * Kill the state structure, we're done with it and need to
+	 * allow the buffers to come back later.
+	 */
+	xfs_da_state_free(state);
+	state = NULL;
+
+	args->dc.flags |= XFS_DC_FOUND_NBLK;
+	return -EAGAIN;
+found_blk:
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		if (!(args->dc.flags & XFS_DC_ALLOC_NODE)) {
+			args->dc.flags |= XFS_DC_ALLOC_NODE;
+			args->dc.lblkno = 0;
+			args->dc.lfileoff = 0;
+			args->dc.blkcnt = 0;
+			memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+			error = xfs_attr_rmt_find_hole(args, &args->dc.blkcnt,
+						       &args->dc.lfileoff);
+			if (error)
+				return error;
+
+			args->dc.lblkno = (xfs_dablk_t)args->dc.lfileoff;
+		}
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		while (args->dc.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+				(xfs_fileoff_t)args->dc.lblkno, args->dc.blkcnt,
+				XFS_BMAPI_ATTRFORK, args->total, map, &nmap);
+			if (error)
+				return error;
+
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dc.lblkno += map->br_blockcount;
+			args->dc.blkcnt -= map->br_blockcount;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the
+	 * incomplete flags on the "new" and "old" attribute/value pairs
+	 * so that one disappears and one appears atomically.  Then we
+	 * must remove the "old" attribute/value pair.
+	 */
+	if (args->op_flags & XFS_DA_OP_RENAME) {
+		/*
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+		if (!xfs_attr3_leaf_flagsflipped(args)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			return -EAGAIN;
+		}
+		/*
+		 * Dismantle the "old" attribute/value pair by removing
+		 * a "remote" value (if it exists).
+		 */
+		args->index = args->index2;
+		args->blkno = args->blkno2;
+		args->rmtblkno = args->rmtblkno2;
+		args->rmtblkcnt = args->rmtblkcnt2;
+		args->rmtvaluelen = args->rmtvaluelen2;
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_remove_value(args);
+			if (error)
+				return error;
+
+			while (!done && !error)
+				error = xfs_bunmapi(args->trans,
+				    args->dp, args->rmtblkno,
+				    args->rmtblkcnt, XFS_BMAPI_ATTRFORK,
+				    1, &done);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Re-find the "old" attribute entry after any split ops.
+		 * The INCOMPLETE flag means that we will find the "old"
+		 * attr, not the "new" one.
+		 */
+		args->flags |= XFS_ATTR_INCOMPLETE;
+		state = xfs_da_state_alloc();
+		state->args = args;
+		state->mp = mp;
+		state->inleaf = 0;
+		error = xfs_da3_node_lookup_int(state, &retval);
+		if (error)
+			goto out;
+
+		/*
+		 * Remove the name and update the hashvals in the tree.
+		 */
+		blk = &state->path.blk[state->path.active - 1];
+		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+		error = xfs_attr3_leaf_remove(blk->bp, args);
+		xfs_da3_fixhashpath(state, &state->path);
+
+		/*
+		 * Check to see if the tree needs to be collapsed.
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+		}
+	} else if (args->rmtblkno > 0) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		error = xfs_attr3_leaf_clearflag(args);
+		if (error)
+			goto out;
+	}
+	retval = error = 0;
+
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+
+	return retval;
+}
+
+
+
+/*
  * Fill in the disk block numbers in the state structure for the buffers
  * that are attached to the state structure.
  * This is done so that we can quickly reattach ourselves to those buffers
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b1172fd..d05749e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -175,9 +175,11 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
 int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_da_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_da_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.7.4
