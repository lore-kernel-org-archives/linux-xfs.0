Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 098ED7CF7
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:19:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC8B3304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:19:24 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id W99Or6Yj2h7iRM9y (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:19:20 -0700 (PDT)
Subject: [PATCH 013/119] xfs: support btrees with overlapping intervals for
	keys
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:19:15 -0700
Message-ID: <146612635526.12839.13865365567940815077.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On a filesystem with both reflink and reverse mapping enabled, it's
possible to have multiple rmap records referring to the same blocks on
disk.  When overlapping intervals are possible, querying a classic
btree to find all records intersecting a given interval is inefficient
because we cannot use the left side of the search interval to filter
out non-matching records the same way that we can use the existing
btree key to filter out records coming after the right side of the
search interval.  This will become important once we want to use the
rmap btree to rebuild BMBTs, or implement the (future) fsmap ioctl.

(For the non-overlapping case, we can perform such queries trivially
by starting at the left side of the interval and walking the tree
until we pass the right side.)

Therefore, extend the btree code to come closer to supporting
intervals as a first-class record attribute.  This involves widening
the btree node's key space to store both the lowest key reachable via
the node pointer (as the btree does now) and the highest key reachable
via the same pointer and teaching the btree modifying functions to
keep the highest-key records up to date.

This behavior can be turned on via a new btree ops flag so that btrees
that cannot store overlapping intervals don't pay the overhead costs
in terms of extra code and disk format changes.

v2: When we're deleting a record in a btree that supports overlapped
interval records and the deletion results in two btree blocks being
joined, we defer updating the high/low keys until after all possible
joining (at higher levels in the tree) have finished.  At this point,
the btree pointers at all levels have been updated to remove the empty
blocks and we can update the low and high keys.

When we're doing this, we must be careful to update the keys of all
node pointers up to the root instead of stopping at the first set of
keys that don't need updating.  This is because it's possible for a
single deletion to cause joining of multiple levels of tree, and so
we need to update everything going back to the root.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  379 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h |   16 ++
 fs/xfs/xfs_trace.h        |   36 ++++
 3 files changed, 395 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a096539..afcafd6 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -52,6 +52,11 @@ static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
 
 
+struct xfs_btree_double_key {
+	union xfs_btree_key	low;
+	union xfs_btree_key	high;
+};
+
 STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
@@ -428,6 +433,30 @@ xfs_btree_dup_cursor(
  * into a btree block (xfs_btree_*_offset) or return a pointer to the given
  * record, key or pointer (xfs_btree_*_addr).  Note that all addressing
  * inside the btree block is done using indices starting at one, not zero!
+ *
+ * If XFS_BTREE_OVERLAPPING is set, then this btree supports keys containing
+ * overlapping intervals.  In such a tree, records are still sorted lowest to
+ * highest and indexed by the smallest key value that refers to the record.
+ * However, nodes are different: each pointer has two associated keys -- one
+ * indexing the lowest key available in the block(s) below (the same behavior
+ * as the key in a regular btree) and another indexing the highest key
+ * available in the block(s) below.  Because records are /not/ sorted by the
+ * highest key, all leaf block updates require us to compute the highest key
+ * that matches any record in the leaf and to recursively update the high keys
+ * in the nodes going further up in the tree, if necessary.  Nodes look like
+ * this:
+ *
+ *		+--------+-----+-----+-----+-----+-----+-------+-------+-----+
+ * Non-Leaf:	| header | lo1 | hi1 | lo2 | hi2 | ... | ptr 1 | ptr 2 | ... |
+ *		+--------+-----+-----+-----+-----+-----+-------+-------+-----+
+ *
+ * To perform an interval query on an overlapped tree, perform the usual
+ * depth-first search and use the low and high keys to decide if we can skip
+ * that particular node.  If a leaf node is reached, return the records that
+ * intersect the interval.  Note that an interval query may return numerous
+ * entries.  For a non-overlapped tree, simply search for the record associated
+ * with the lowest key and iterate forward until a non-matching record is
+ * found.
  */
 
 /*
@@ -445,6 +474,17 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 	return XFS_BTREE_SBLOCK_LEN;
 }
 
+/* Return size of btree block keys for this btree instance. */
+static inline size_t xfs_btree_key_len(struct xfs_btree_cur *cur)
+{
+	size_t			len;
+
+	len = cur->bc_ops->key_len;
+	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
+		len *= 2;
+	return len;
+}
+
 /*
  * Return size of btree block pointers for this btree instance.
  */
@@ -475,7 +515,19 @@ xfs_btree_key_offset(
 	int			n)
 {
 	return xfs_btree_block_len(cur) +
-		(n - 1) * cur->bc_ops->key_len;
+		(n - 1) * xfs_btree_key_len(cur);
+}
+
+/*
+ * Calculate offset of the n-th high key in a btree block.
+ */
+STATIC size_t
+xfs_btree_high_key_offset(
+	struct xfs_btree_cur	*cur,
+	int			n)
+{
+	return xfs_btree_block_len(cur) +
+		(n - 1) * xfs_btree_key_len(cur) + cur->bc_ops->key_len;
 }
 
 /*
@@ -488,7 +540,7 @@ xfs_btree_ptr_offset(
 	int			level)
 {
 	return xfs_btree_block_len(cur) +
-		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
+		cur->bc_ops->get_maxrecs(cur, level) * xfs_btree_key_len(cur) +
 		(n - 1) * xfs_btree_ptr_len(cur);
 }
 
@@ -519,6 +571,19 @@ xfs_btree_key_addr(
 }
 
 /*
+ * Return a pointer to the n-th high key in the btree block.
+ */
+STATIC union xfs_btree_key *
+xfs_btree_high_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			n,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		((char *)block + xfs_btree_high_key_offset(cur, n));
+}
+
+/*
  * Return a pointer to the n-th block pointer in the btree block.
  */
 STATIC union xfs_btree_ptr *
@@ -1217,7 +1282,7 @@ xfs_btree_copy_keys(
 	int			numkeys)
 {
 	ASSERT(numkeys >= 0);
-	memcpy(dst_key, src_key, numkeys * cur->bc_ops->key_len);
+	memcpy(dst_key, src_key, numkeys * xfs_btree_key_len(cur));
 }
 
 /*
@@ -1263,8 +1328,8 @@ xfs_btree_shift_keys(
 	ASSERT(numkeys >= 0);
 	ASSERT(dir == 1 || dir == -1);
 
-	dst_key = (char *)key + (dir * cur->bc_ops->key_len);
-	memmove(dst_key, key, numkeys * cur->bc_ops->key_len);
+	dst_key = (char *)key + (dir * xfs_btree_key_len(cur));
+	memmove(dst_key, key, numkeys * xfs_btree_key_len(cur));
 }
 
 /*
@@ -1879,6 +1944,180 @@ error0:
 	return error;
 }
 
+/* Determine the low and high keys of a leaf block */
+STATIC void
+xfs_btree_find_leaf_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*low,
+	union xfs_btree_key	*high)
+{
+	int			n;
+	union xfs_btree_rec	*rec;
+	union xfs_btree_key	max_hkey;
+	union xfs_btree_key	hkey;
+
+	rec = xfs_btree_rec_addr(cur, 1, block);
+	cur->bc_ops->init_key_from_rec(low, rec);
+
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return;
+
+	cur->bc_ops->init_high_key_from_rec(&max_hkey, rec);
+	for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
+		rec = xfs_btree_rec_addr(cur, n, block);
+		cur->bc_ops->init_high_key_from_rec(&hkey, rec);
+		if (cur->bc_ops->diff_two_keys(cur, &max_hkey, &hkey) > 0)
+			max_hkey = hkey;
+	}
+
+	*high = max_hkey;
+}
+
+/* Determine the low and high keys of a node block */
+STATIC void
+xfs_btree_find_node_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*low,
+	union xfs_btree_key	*high)
+{
+	int			n;
+	union xfs_btree_key	*hkey;
+	union xfs_btree_key	*max_hkey;
+
+	*low = *xfs_btree_key_addr(cur, 1, block);
+
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return;
+
+	max_hkey = xfs_btree_high_key_addr(cur, 1, block);
+	for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
+		hkey = xfs_btree_high_key_addr(cur, n, block);
+		if (cur->bc_ops->diff_two_keys(cur, max_hkey, hkey) > 0)
+			max_hkey = hkey;
+	}
+
+	*high = *max_hkey;
+}
+
+/*
+ * Update parental low & high keys from some block all the way back to the
+ * root of the btree.
+ */
+STATIC int
+__xfs_btree_updkeys(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	struct xfs_btree_block	*block,
+	struct xfs_buf		*bp0,
+	bool			force_all)
+{
+	union xfs_btree_key	lkey;	/* keys from current level */
+	union xfs_btree_key	hkey;
+	union xfs_btree_key	*nlkey;	/* keys from the next level up */
+	union xfs_btree_key	*nhkey;
+	struct xfs_buf		*bp;
+	int			ptr = -1;
+
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return 0;
+
+	if (level + 1 >= cur->bc_nlevels)
+		return 0;
+
+	trace_xfs_btree_updkeys(cur, level, bp0);
+
+	if (level == 0)
+		xfs_btree_find_leaf_keys(cur, block, &lkey, &hkey);
+	else
+		xfs_btree_find_node_keys(cur, block, &lkey, &hkey);
+	for (level++; level < cur->bc_nlevels; level++) {
+		block = xfs_btree_get_block(cur, level, &bp);
+		trace_xfs_btree_updkeys(cur, level, bp);
+		ptr = cur->bc_ptrs[level];
+		nlkey = xfs_btree_key_addr(cur, ptr, block);
+		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
+		if (!(cur->bc_ops->diff_two_keys(cur, nlkey, &lkey) != 0 ||
+		      cur->bc_ops->diff_two_keys(cur, nhkey, &hkey) != 0) &&
+		    !force_all)
+			break;
+		memcpy(nlkey, &lkey, cur->bc_ops->key_len);
+		memcpy(nhkey, &hkey, cur->bc_ops->key_len);
+		xfs_btree_log_keys(cur, bp, ptr, ptr);
+		if (level + 1 >= cur->bc_nlevels)
+			break;
+		xfs_btree_find_node_keys(cur, block, &lkey, &hkey);
+	}
+
+	return 0;
+}
+
+/*
+ * Update all the keys from a sibling block at some level in the cursor back
+ * to the root, stopping when we find a key pair that doesn't need updating.
+ */
+STATIC int
+xfs_btree_sibling_updkeys(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			ptr,
+	struct xfs_btree_block	*block,
+	struct xfs_buf		*bp0)
+{
+	struct xfs_btree_cur	*ncur;
+	int			stat;
+	int			error;
+
+	error = xfs_btree_dup_cursor(cur, &ncur);
+	if (error)
+		return error;
+
+	if (level + 1 >= ncur->bc_nlevels)
+		error = -EDOM;
+	else if (ptr == XFS_BB_RIGHTSIB)
+		error = xfs_btree_increment(ncur, level + 1, &stat);
+	else if (ptr == XFS_BB_LEFTSIB)
+		error = xfs_btree_decrement(ncur, level + 1, &stat);
+	else
+		error = -EBADE;
+	if (error || !stat)
+		return error;
+
+	error = __xfs_btree_updkeys(ncur, level, block, bp0, false);
+	xfs_btree_del_cursor(ncur, XFS_BTREE_NOERROR);
+	return error;
+}
+
+/*
+ * Update all the keys from some level in cursor back to the root, stopping
+ * when we find a key pair that don't need updating.
+ */
+STATIC int
+xfs_btree_updkeys(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfs_buf		*bp;
+	struct xfs_btree_block	*block;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+	return __xfs_btree_updkeys(cur, level, block, bp, false);
+}
+
+/* Update all the keys from some level in cursor back to the root. */
+STATIC int
+xfs_btree_updkeys_force(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfs_buf		*bp;
+	struct xfs_btree_block	*block;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+	return __xfs_btree_updkeys(cur, level, block, bp, true);
+}
+
 /*
  * Update keys at all levels from here to the root along the cursor's path.
  */
@@ -1893,6 +2132,9 @@ xfs_btree_updkey(
 	union xfs_btree_key	*kp;
 	int			ptr;
 
+	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
+		return 0;
+
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
 
@@ -1970,7 +2212,8 @@ xfs_btree_update(
 					    ptr, LASTREC_UPDATE);
 	}
 
-	/* Updating first rec in leaf. Pass new key value up to our parent. */
+	/* Pass new key value up to our parent. */
+	xfs_btree_updkeys(cur, 0);
 	if (ptr == 1) {
 		union xfs_btree_key	key;
 
@@ -2149,7 +2392,9 @@ xfs_btree_lshift(
 		rkp = &key;
 	}
 
-	/* Update the parent key values of right. */
+	/* Update the parent key values of left and right. */
+	xfs_btree_sibling_updkeys(cur, level, XFS_BB_LEFTSIB, left, lbp);
+	xfs_btree_updkeys(cur, level);
 	error = xfs_btree_updkey(cur, rkp, level + 1);
 	if (error)
 		goto error0;
@@ -2321,6 +2566,9 @@ xfs_btree_rshift(
 	if (error)
 		goto error1;
 
+	/* Update left and right parent pointers */
+	xfs_btree_updkeys(cur, level);
+	xfs_btree_updkeys(tcur, level);
 	error = xfs_btree_updkey(tcur, rkp, level + 1);
 	if (error)
 		goto error1;
@@ -2356,7 +2604,7 @@ __xfs_btree_split(
 	struct xfs_btree_cur	*cur,
 	int			level,
 	union xfs_btree_ptr	*ptrp,
-	union xfs_btree_key	*key,
+	struct xfs_btree_double_key	*key,
 	struct xfs_btree_cur	**curp,
 	int			*stat)		/* success/failure */
 {
@@ -2452,9 +2700,6 @@ __xfs_btree_split(
 
 		xfs_btree_log_keys(cur, rbp, 1, rrecs);
 		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
-
-		/* Grab the keys to the entries moved to the right block */
-		xfs_btree_copy_keys(cur, key, rkp, 1);
 	} else {
 		/* It's a leaf.  Move records.  */
 		union xfs_btree_rec	*lrp;	/* left record pointer */
@@ -2465,12 +2710,8 @@ __xfs_btree_split(
 
 		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
 		xfs_btree_log_recs(cur, rbp, 1, rrecs);
-
-		cur->bc_ops->init_key_from_rec(key,
-			xfs_btree_rec_addr(cur, 1, right));
 	}
 
-
 	/*
 	 * Find the left block number by looking in the buffer.
 	 * Adjust numrecs, sibling pointers.
@@ -2484,6 +2725,12 @@ __xfs_btree_split(
 	xfs_btree_set_numrecs(left, lrecs);
 	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
 
+	/* Find the low & high keys for the new block. */
+	if (level > 0)
+		xfs_btree_find_node_keys(cur, right, &key->low, &key->high);
+	else
+		xfs_btree_find_leaf_keys(cur, right, &key->low, &key->high);
+
 	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
 	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 
@@ -2499,6 +2746,10 @@ __xfs_btree_split(
 		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
 		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
 	}
+
+	/* Update the left block's keys... */
+	xfs_btree_updkeys(cur, level);
+
 	/*
 	 * If the cursor is really in the right block, move it there.
 	 * If it's just pointing past the last entry in left, then we'll
@@ -2537,7 +2788,7 @@ struct xfs_btree_split_args {
 	struct xfs_btree_cur	*cur;
 	int			level;
 	union xfs_btree_ptr	*ptrp;
-	union xfs_btree_key	*key;
+	struct xfs_btree_double_key	*key;
 	struct xfs_btree_cur	**curp;
 	int			*stat;		/* success/failure */
 	int			result;
@@ -2586,7 +2837,7 @@ xfs_btree_split(
 	struct xfs_btree_cur	*cur,
 	int			level,
 	union xfs_btree_ptr	*ptrp,
-	union xfs_btree_key	*key,
+	struct xfs_btree_double_key	*key,
 	struct xfs_btree_cur	**curp,
 	int			*stat)		/* success/failure */
 {
@@ -2806,27 +3057,27 @@ xfs_btree_new_root(
 		bp = lbp;
 		nptr = 2;
 	}
+
 	/* Fill in the new block's btree header and log it. */
 	xfs_btree_init_block_cur(cur, nbp, cur->bc_nlevels, 2);
 	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
 	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
 			!xfs_btree_ptr_is_null(cur, &rptr));
-
 	/* Fill in the key data in the new root. */
 	if (xfs_btree_get_level(left) > 0) {
-		xfs_btree_copy_keys(cur,
+		xfs_btree_find_node_keys(cur, left,
 				xfs_btree_key_addr(cur, 1, new),
-				xfs_btree_key_addr(cur, 1, left), 1);
-		xfs_btree_copy_keys(cur,
+				xfs_btree_high_key_addr(cur, 1, new));
+		xfs_btree_find_node_keys(cur, right,
 				xfs_btree_key_addr(cur, 2, new),
-				xfs_btree_key_addr(cur, 1, right), 1);
+				xfs_btree_high_key_addr(cur, 2, new));
 	} else {
-		cur->bc_ops->init_key_from_rec(
-				xfs_btree_key_addr(cur, 1, new),
-				xfs_btree_rec_addr(cur, 1, left));
-		cur->bc_ops->init_key_from_rec(
-				xfs_btree_key_addr(cur, 2, new),
-				xfs_btree_rec_addr(cur, 1, right));
+		xfs_btree_find_leaf_keys(cur, left,
+			xfs_btree_key_addr(cur, 1, new),
+			xfs_btree_high_key_addr(cur, 1, new));
+		xfs_btree_find_leaf_keys(cur, right,
+			xfs_btree_key_addr(cur, 2, new),
+			xfs_btree_high_key_addr(cur, 2, new));
 	}
 	xfs_btree_log_keys(cur, nbp, 1, 2);
 
@@ -2837,6 +3088,7 @@ xfs_btree_new_root(
 		xfs_btree_ptr_addr(cur, 2, new), &rptr, 1);
 	xfs_btree_log_ptrs(cur, nbp, 1, 2);
 
+
 	/* Fix up the cursor. */
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_ptrs[cur->bc_nlevels] = nptr;
@@ -2862,7 +3114,7 @@ xfs_btree_make_block_unfull(
 	int			*index,	/* new tree index */
 	union xfs_btree_ptr	*nptr,	/* new btree ptr */
 	struct xfs_btree_cur	**ncur,	/* new btree cursor */
-	union xfs_btree_key	*key, /* key of new block */
+	struct xfs_btree_double_key	*key,	/* key of new block */
 	int			*stat)
 {
 	int			error = 0;
@@ -2918,6 +3170,22 @@ xfs_btree_make_block_unfull(
 	return 0;
 }
 
+/* Copy a double key into a btree block. */
+static void
+xfs_btree_copy_double_keys(
+	struct xfs_btree_cur	*cur,
+	int			ptr,
+	struct xfs_btree_block	*block,
+	struct xfs_btree_double_key	*key)
+{
+	memcpy(xfs_btree_key_addr(cur, ptr, block), &key->low,
+			cur->bc_ops->key_len);
+
+	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
+		memcpy(xfs_btree_high_key_addr(cur, ptr, block), &key->high,
+				cur->bc_ops->key_len);
+}
+
 /*
  * Insert one record/level.  Return information to the caller
  * allowing the next level up to proceed if necessary.
@@ -2927,7 +3195,7 @@ xfs_btree_insrec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level to insert record at */
 	union xfs_btree_ptr	*ptrp,	/* i/o: block number inserted */
-	union xfs_btree_key	*key,	/* i/o: block key for ptrp */
+	struct xfs_btree_double_key	*key, /* i/o: block key for ptrp */
 	struct xfs_btree_cur	**curp,	/* output: new cursor replacing cur */
 	int			*stat)	/* success/failure */
 {
@@ -2935,7 +3203,7 @@ xfs_btree_insrec(
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
 	struct xfs_btree_cur	*ncur;	/* new btree cursor */
-	union xfs_btree_key	nkey;	/* new block key */
+	struct xfs_btree_double_key	nkey;	/* new block key */
 	union xfs_btree_rec	rec;	/* record to insert */
 	int			optr;	/* old key/record index */
 	int			ptr;	/* key/record index */
@@ -2944,11 +3212,12 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	int			i;
 #endif
+	xfs_daddr_t		old_bn;
 
 	/* Make a key out of the record data to be inserted, and save it. */
 	if (level == 0) {
 		cur->bc_ops->init_rec_from_cur(cur, &rec);
-		cur->bc_ops->init_key_from_rec(key, &rec);
+		cur->bc_ops->init_key_from_rec(&key->low, &rec);
 	}
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
@@ -2983,6 +3252,7 @@ xfs_btree_insrec(
 
 	/* Get pointers to the btree buffer and block. */
 	block = xfs_btree_get_block(cur, level, &bp);
+	old_bn = bp ? bp->b_bn : XFS_BUF_DADDR_NULL;
 	numrecs = xfs_btree_get_numrecs(block);
 
 #ifdef DEBUG
@@ -2996,7 +3266,7 @@ xfs_btree_insrec(
 			ASSERT(cur->bc_ops->recs_inorder(cur, &rec,
 				xfs_btree_rec_addr(cur, ptr, block)));
 		} else {
-			ASSERT(cur->bc_ops->keys_inorder(cur, key,
+			ASSERT(cur->bc_ops->keys_inorder(cur, &key->low,
 				xfs_btree_key_addr(cur, ptr, block)));
 		}
 	}
@@ -3059,7 +3329,7 @@ xfs_btree_insrec(
 #endif
 
 		/* Now put the new data in, bump numrecs and log it. */
-		xfs_btree_copy_keys(cur, kp, key, 1);
+		xfs_btree_copy_double_keys(cur, ptr, block, key);
 		xfs_btree_copy_ptrs(cur, pp, ptrp, 1);
 		numrecs++;
 		xfs_btree_set_numrecs(block, numrecs);
@@ -3095,8 +3365,24 @@ xfs_btree_insrec(
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
 	/* If we inserted at the start of a block, update the parents' keys. */
+	if (ncur && bp->b_bn != old_bn) {
+		/*
+		 * We just inserted into a new tree block, which means that
+		 * the key for the block is in nkey, not the tree.
+		 */
+		if (level == 0)
+			xfs_btree_find_leaf_keys(cur, block, &nkey.low,
+					&nkey.high);
+		else
+			xfs_btree_find_node_keys(cur, block, &nkey.low,
+					&nkey.high);
+	} else {
+		/* Updating the left block, do it the standard way. */
+		xfs_btree_updkeys(cur, level);
+	}
+
 	if (optr == 1) {
-		error = xfs_btree_updkey(cur, key, level + 1);
+		error = xfs_btree_updkey(cur, &key->low, level + 1);
 		if (error)
 			goto error0;
 	}
@@ -3147,7 +3433,7 @@ xfs_btree_insert(
 	union xfs_btree_ptr	nptr;	/* new block number (split result) */
 	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
 	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
-	union xfs_btree_key	key;	/* key of block to insert */
+	struct xfs_btree_double_key	key;	/* key of block to insert */
 
 	level = 0;
 	ncur = NULL;
@@ -3552,6 +3838,7 @@ xfs_btree_delrec(
 	 * If we deleted the leftmost entry in the block, update the
 	 * key values above us in the tree.
 	 */
+	xfs_btree_updkeys(cur, level);
 	if (ptr == 1) {
 		error = xfs_btree_updkey(cur, keyp, level + 1);
 		if (error)
@@ -3882,6 +4169,16 @@ xfs_btree_delrec(
 	if (level > 0)
 		cur->bc_ptrs[level]--;
 
+	/*
+	 * We combined blocks, so we have to update the parent keys if the
+	 * btree supports overlapped intervals.  However, bc_ptrs[level + 1]
+	 * points to the old block so that the caller knows which record to
+	 * delete.  Therefore, the caller must be savvy enough to call updkeys
+	 * for us if we return stat == 2.  The other exit points from this
+	 * function don't require deletions further up the tree, so they can
+	 * call updkeys directly.
+	 */
+
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	/* Return value means the next level up has something to do. */
 	*stat = 2;
@@ -3907,6 +4204,7 @@ xfs_btree_delete(
 	int			error;	/* error return value */
 	int			level;
 	int			i;
+	bool			joined = false;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 
@@ -3920,8 +4218,17 @@ xfs_btree_delete(
 		error = xfs_btree_delrec(cur, level, &i);
 		if (error)
 			goto error0;
+		if (i == 2)
+			joined = true;
 	}
 
+	/*
+	 * If we combined blocks as part of deleting the record, delrec won't
+	 * have updated the parent keys so we have to do that here.
+	 */
+	if (joined)
+		xfs_btree_updkeys_force(cur, 0);
+
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
 			if (cur->bc_ptrs[level] == 0) {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b99c018..a5ec6c7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -126,6 +126,9 @@ struct xfs_btree_ops {
 	size_t	key_len;
 	size_t	rec_len;
 
+	/* flags */
+	uint	flags;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -162,11 +165,21 @@ struct xfs_btree_ops {
 				     union xfs_btree_rec *rec);
 	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
 				     union xfs_btree_ptr *ptr);
+	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
+					  union xfs_btree_rec *rec);
 
 	/* difference between key value and cursor value */
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
+	/*
+	 * Difference between key2 and key1 -- positive if key2 > key1,
+	 * negative if key2 < key1, and zero if equal.
+	 */
+	__int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
+				   union xfs_btree_key *key1,
+				   union xfs_btree_key *key2);
+
 	const struct xfs_buf_ops	*buf_ops;
 
 #if defined(DEBUG) || defined(XFS_WARN)
@@ -182,6 +195,9 @@ struct xfs_btree_ops {
 #endif
 };
 
+/* btree ops flags */
+#define XFS_BTREE_OPS_OVERLAPPING	(1<<0)	/* overlapping intervals */
+
 /*
  * Reasons for the update_lastrec method to be called.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 68f27f7..ffea28c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -38,6 +38,7 @@ struct xlog_recover_item;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
+struct xfs_btree_cur;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -2183,6 +2184,41 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
+/* btree cursor events */
+DECLARE_EVENT_CLASS(xfs_btree_cur_class,
+	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
+	TP_ARGS(cur, level, bp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(int, level)
+		__field(int, nlevels)
+		__field(int, ptr)
+		__field(xfs_daddr_t, daddr)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->nlevels = cur->bc_nlevels;
+		__entry->ptr = cur->bc_ptrs[level];
+		__entry->daddr = bp->b_bn;
+	),
+	TP_printk("dev %d:%d btnum %d level %d/%d ptr %d daddr 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->btnum,
+		  __entry->level,
+		  __entry->nlevels,
+		  __entry->ptr,
+		  (unsigned long long)__entry->daddr)
+)
+
+#define DEFINE_BTREE_CUR_EVENT(name) \
+DEFINE_EVENT(xfs_btree_cur_class, name, \
+	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp), \
+	TP_ARGS(cur, level, bp))
+DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
