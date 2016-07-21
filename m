Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71C797CCB
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:56:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35AD38F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3Hk2qdBcer6MHXRb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:56 -0700 (PDT)
Subject: [PATCH 07/47] xfs: add function pointers for get/update keys to the
	btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:56:46 -0700
Message-ID: <146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Add some function pointers to bc_ops to get the btree keys for
leaf and node blocks, and to update parent keys of a block.
Convert the _btree_updkey calls to use our new pointer, and
modify the tree shape changing code to call the appropriate
get_*_keys pointer instead of _btree_copy_keys because the
overlapping btree has to calculate high key values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c  |    4 +
 fs/xfs/libxfs/xfs_bmap_btree.c   |    4 +
 fs/xfs/libxfs/xfs_btree.c        |  159 +++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_btree.h        |   19 +++++
 fs/xfs/libxfs/xfs_ialloc_btree.c |    8 ++
 5 files changed, 133 insertions(+), 61 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 5ba2dac..c60eeb8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -403,6 +403,10 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
 #endif
+
+	.get_leaf_keys		= xfs_btree_get_leaf_keys,
+	.get_node_keys		= xfs_btree_get_node_keys,
+	.update_keys		= xfs_btree_update_keys,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 714b387..4f1a98e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -757,6 +757,10 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 #endif
+
+	.get_leaf_keys		= xfs_btree_get_leaf_keys,
+	.get_node_keys		= xfs_btree_get_node_keys,
+	.update_keys		= xfs_btree_update_keys,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8d8e362..70d1c60 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1879,24 +1879,73 @@ error0:
 	return error;
 }
 
+/* Determine the low key of a leaf block (simple) */
+void
+xfs_btree_get_leaf_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*key)
+{
+	union xfs_btree_rec	*rec;
+
+	rec = xfs_btree_rec_addr(cur, 1, block);
+	cur->bc_ops->init_key_from_rec(key, rec);
+}
+
+/* Determine the low key of a node block (simple) */
+void
+xfs_btree_get_node_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*key)
+{
+	memcpy(key, xfs_btree_key_addr(cur, 1, block), cur->bc_ops->key_len);
+}
+
+/* Derive the keys for any btree block. */
+STATIC void
+xfs_btree_get_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*key)
+{
+	if (be16_to_cpu(block->bb_level) == 0)
+		cur->bc_ops->get_leaf_keys(cur, block, key);
+	else
+		cur->bc_ops->get_node_keys(cur, block, key);
+}
+
 /*
- * Update keys at all levels from here to the root along the cursor's path.
+ * Decide if we need to update the parent keys of a btree block.  For
+ * a standard btree this is only necessary if we're updating the first
+ * record/key.
  */
-STATIC int
-xfs_btree_updkey(
+static inline bool
+xfs_btree_needs_key_update(
+	struct xfs_btree_cur	*cur,
+	int			ptr)
+{
+	return ptr == 1;
+}
+
+/*
+ * Update the parent keys of the given level, progressing towards the root.
+ */
+int
+xfs_btree_update_keys(
 	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*keyp,
 	int			level)
 {
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
 	union xfs_btree_key	*kp;
+	union xfs_btree_key	key;
 	int			ptr;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
 
-	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level >= 1);
+	ASSERT(level >= 0);
 
 	/*
 	 * Go up the tree from this level toward the root.
@@ -1904,7 +1953,9 @@ xfs_btree_updkey(
 	 * Stop when we reach a level where the cursor isn't pointing
 	 * at the first entry in the block.
 	 */
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
+	block = xfs_btree_get_block(cur, level, &bp);
+	xfs_btree_get_keys(cur, block, &key);
+	for (level++, ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
 #ifdef DEBUG
 		int		error;
 #endif
@@ -1918,7 +1969,7 @@ xfs_btree_updkey(
 #endif
 		ptr = cur->bc_ptrs[level];
 		kp = xfs_btree_key_addr(cur, ptr, block);
-		xfs_btree_copy_keys(cur, kp, keyp, 1);
+		xfs_btree_copy_keys(cur, kp, &key, 1);
 		xfs_btree_log_keys(cur, bp, ptr, ptr);
 	}
 
@@ -1971,11 +2022,8 @@ xfs_btree_update(
 	}
 
 	/* Updating first rec in leaf. Pass new key value up to our parent. */
-	if (ptr == 1) {
-		union xfs_btree_key	key;
-
-		cur->bc_ops->init_key_from_rec(&key, rec);
-		error = xfs_btree_updkey(cur, &key, 1);
+	if (xfs_btree_needs_key_update(cur, ptr)) {
+		error = cur->bc_ops->update_keys(cur, 0);
 		if (error)
 			goto error0;
 	}
@@ -2149,8 +2197,8 @@ xfs_btree_lshift(
 		rkp = &key;
 	}
 
-	/* Update the parent key values of right. */
-	error = xfs_btree_updkey(cur, rkp, level + 1);
+	/* Update the parent keys of the right block. */
+	error = cur->bc_ops->update_keys(cur, level);
 	if (error)
 		goto error0;
 
@@ -2321,7 +2369,8 @@ xfs_btree_rshift(
 	if (error)
 		goto error1;
 
-	error = xfs_btree_updkey(tcur, rkp, level + 1);
+	/* Update the parent keys of the right block. */
+	error = cur->bc_ops->update_keys(tcur, level);
 	if (error)
 		goto error1;
 
@@ -2422,6 +2471,10 @@ __xfs_btree_split(
 
 	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
 
+	lrecs -= rrecs;
+	xfs_btree_set_numrecs(left, lrecs);
+	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
+
 	/*
 	 * Copy btree block entries from the left block over to the
 	 * new block, the right. Update the right block and log the
@@ -2447,14 +2500,15 @@ __xfs_btree_split(
 		}
 #endif
 
+		/* Copy the keys & pointers to the new block. */
 		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
 		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
 
 		xfs_btree_log_keys(cur, rbp, 1, rrecs);
 		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
 
-		/* Grab the keys to the entries moved to the right block */
-		xfs_btree_copy_keys(cur, key, rkp, 1);
+		/* Stash the keys of the new block for later insertion. */
+		cur->bc_ops->get_node_keys(cur, right, key);
 	} else {
 		/* It's a leaf.  Move records.  */
 		union xfs_btree_rec	*lrp;	/* left record pointer */
@@ -2463,14 +2517,14 @@ __xfs_btree_split(
 		lrp = xfs_btree_rec_addr(cur, src_index, left);
 		rrp = xfs_btree_rec_addr(cur, 1, right);
 
+		/* Copy records to the new block. */
 		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
 		xfs_btree_log_recs(cur, rbp, 1, rrecs);
 
-		cur->bc_ops->init_key_from_rec(key,
-			xfs_btree_rec_addr(cur, 1, right));
+		/* Stash the keys of the new block for later insertion. */
+		cur->bc_ops->get_leaf_keys(cur, right, key);
 	}
 
-
 	/*
 	 * Find the left block number by looking in the buffer.
 	 * Adjust numrecs, sibling pointers.
@@ -2480,10 +2534,6 @@ __xfs_btree_split(
 	xfs_btree_set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
 	xfs_btree_set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
 
-	lrecs -= rrecs;
-	xfs_btree_set_numrecs(left, lrecs);
-	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
-
 	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
 	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 
@@ -2802,6 +2852,7 @@ xfs_btree_new_root(
 		bp = lbp;
 		nptr = 2;
 	}
+
 	/* Fill in the new block's btree header and log it. */
 	xfs_btree_init_block_cur(cur, nbp, cur->bc_nlevels, 2);
 	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
@@ -2810,19 +2861,24 @@ xfs_btree_new_root(
 
 	/* Fill in the key data in the new root. */
 	if (xfs_btree_get_level(left) > 0) {
-		xfs_btree_copy_keys(cur,
-				xfs_btree_key_addr(cur, 1, new),
-				xfs_btree_key_addr(cur, 1, left), 1);
-		xfs_btree_copy_keys(cur,
-				xfs_btree_key_addr(cur, 2, new),
-				xfs_btree_key_addr(cur, 1, right), 1);
+		/*
+		 * Get the keys for the left block's keys and put them directly
+		 * in the parent block.  Do the same for the right block.
+		 */
+		cur->bc_ops->get_node_keys(cur, left,
+				xfs_btree_key_addr(cur, 1, new));
+		cur->bc_ops->get_node_keys(cur, right,
+				xfs_btree_key_addr(cur, 2, new));
 	} else {
-		cur->bc_ops->init_key_from_rec(
-				xfs_btree_key_addr(cur, 1, new),
-				xfs_btree_rec_addr(cur, 1, left));
-		cur->bc_ops->init_key_from_rec(
-				xfs_btree_key_addr(cur, 2, new),
-				xfs_btree_rec_addr(cur, 1, right));
+		/*
+		 * Get the keys for the left block's records and put them
+		 * directly in the parent block.  Do the same for the right
+		 * block.
+		 */
+		cur->bc_ops->get_leaf_keys(cur, left,
+			xfs_btree_key_addr(cur, 1, new));
+		cur->bc_ops->get_leaf_keys(cur, right,
+			xfs_btree_key_addr(cur, 2, new));
 	}
 	xfs_btree_log_keys(cur, nbp, 1, 2);
 
@@ -2858,7 +2914,7 @@ xfs_btree_make_block_unfull(
 	int			*index,	/* new tree index */
 	union xfs_btree_ptr	*nptr,	/* new btree ptr */
 	struct xfs_btree_cur	**ncur,	/* new btree cursor */
-	union xfs_btree_key	*key, /* key of new block */
+	union xfs_btree_key	*key,	/* key of new block */
 	int			*stat)
 {
 	int			error = 0;
@@ -3086,8 +3142,8 @@ xfs_btree_insrec(
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
 	/* If we inserted at the start of a block, update the parents' keys. */
-	if (optr == 1) {
-		error = xfs_btree_updkey(cur, key, level + 1);
+	if (xfs_btree_needs_key_update(cur, optr)) {
+		error = cur->bc_ops->update_keys(cur, level);
 		if (error)
 			goto error0;
 	}
@@ -3107,7 +3163,7 @@ xfs_btree_insrec(
 	 */
 	*ptrp = nptr;
 	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
-		*key = nkey;
+		xfs_btree_copy_keys(cur, key, &nkey, 1);
 		*curp = ncur;
 	}
 
@@ -3386,8 +3442,6 @@ xfs_btree_delrec(
 	struct xfs_buf		*bp;		/* buffer for block */
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
-	union xfs_btree_key	key;		/* storage for keyp */
-	union xfs_btree_key	*keyp = &key;	/* passed to the next level */
 	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
 	struct xfs_buf		*lbp;		/* left buffer pointer */
 	struct xfs_btree_block	*left;		/* left btree block */
@@ -3458,13 +3512,6 @@ xfs_btree_delrec(
 			xfs_btree_log_keys(cur, bp, ptr, numrecs - 1);
 			xfs_btree_log_ptrs(cur, bp, ptr, numrecs - 1);
 		}
-
-		/*
-		 * If it's the first record in the block, we'll need to pass a
-		 * key up to the next level (updkey).
-		 */
-		if (ptr == 1)
-			keyp = xfs_btree_key_addr(cur, 1, block);
 	} else {
 		/* It's a leaf. operate on records */
 		if (ptr < numrecs) {
@@ -3473,16 +3520,6 @@ xfs_btree_delrec(
 				-1, numrecs - ptr);
 			xfs_btree_log_recs(cur, bp, ptr, numrecs - 1);
 		}
-
-		/*
-		 * If it's the first record in the block, we'll need a key
-		 * structure to pass up to the next level (updkey).
-		 */
-		if (ptr == 1) {
-			cur->bc_ops->init_key_from_rec(&key,
-					xfs_btree_rec_addr(cur, 1, block));
-			keyp = &key;
-		}
 	}
 
 	/*
@@ -3549,8 +3586,8 @@ xfs_btree_delrec(
 	 * If we deleted the leftmost entry in the block, update the
 	 * key values above us in the tree.
 	 */
-	if (ptr == 1) {
-		error = xfs_btree_updkey(cur, keyp, level + 1);
+	if (xfs_btree_needs_key_update(cur, ptr)) {
+		error = cur->bc_ops->update_keys(cur, level);
 		if (error)
 			goto error0;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b4f3035..bb40457 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -180,6 +180,19 @@ struct xfs_btree_ops {
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
 #endif
+
+	/* derive the low & high keys from the records in a leaf block */
+	void	(*get_leaf_keys)(struct xfs_btree_cur *cur,
+				 struct xfs_btree_block *block,
+				 union xfs_btree_key *key);
+
+	/* derive the low & high keys from the keys in a node block */
+	void	(*get_node_keys)(struct xfs_btree_cur *cur,
+				 struct xfs_btree_block *block,
+				 union xfs_btree_key *key);
+
+	/* update the parent keys of given btree level */
+	int	(*update_keys)(struct xfs_btree_cur *cur, int level);
 };
 
 /*
@@ -474,5 +487,11 @@ bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
+ 
+void xfs_btree_get_leaf_keys(struct xfs_btree_cur *cur,
+		struct xfs_btree_block *block, union xfs_btree_key *key);
+void xfs_btree_get_node_keys(struct xfs_btree_cur *cur,
+		struct xfs_btree_block *block, union xfs_btree_key *key);
+int xfs_btree_update_keys(struct xfs_btree_cur *cur, int level);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 88da2ad..a48f448 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -314,6 +314,10 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
+
+	.get_leaf_keys		= xfs_btree_get_leaf_keys,
+	.get_node_keys		= xfs_btree_get_node_keys,
+	.update_keys		= xfs_btree_update_keys,
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -335,6 +339,10 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
+
+	.get_leaf_keys		= xfs_btree_get_leaf_keys,
+	.get_node_keys		= xfs_btree_get_node_keys,
+	.update_keys		= xfs_btree_update_keys,
 };
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
