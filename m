Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 855097CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:57:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 594A68F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bjYZW5BBaZwVhK2d (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:08 -0700 (PDT)
Subject: [PATCH 09/47] xfs: introduce interval queries on btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:56:59 -0700
Message-ID: <146907701913.25461.16492865819245768513.stgit@birch.djwong.org>
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

Create a function to enable querying of btree records mapping to a
range of keys.  This will be used in subsequent patches to allow
querying the reverse mapping btree to find the extents mapped to a
range of physical blocks, though the generic code can be used for
any range query.

v2: add some shortcuts so that we can jump out of processing once
we know there won't be any more records to find.

v3: document the range query algorithm, refactor the pop-up code,
fix the diff_two_keys usage.

v4: The overlapped query range function should use the btree get_block
helper because the root block could be an inode, in which case
bc_bufs[nlevels-1] will be NULL.  Refactor the key calculations
so that we can return -EINVAL if low > high.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  264 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |   22 +++-
 fs/xfs/xfs_trace.h        |    1 
 3 files changed, 282 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1881536..3780128 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4522,3 +4522,267 @@ xfs_btree_compute_maxlevels(
 		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
 	return level;
 }
+
+/*
+ * Query a regular btree for all records overlapping a given interval.
+ * Start with a LE lookup of the key of low_rec and return all records
+ * until we find a record with a key greater than the key of high_rec.
+ */
+STATIC int
+xfs_btree_simple_query_range(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*low_key,
+	union xfs_btree_key		*high_key,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_rec		*recp;
+	union xfs_btree_key		rec_key;
+	__int64_t			diff;
+	int				stat;
+	bool				firstrec = true;
+	int				error;
+
+	ASSERT(cur->bc_ops->init_high_key_from_rec);
+	ASSERT(cur->bc_ops->diff_two_keys);
+
+	/*
+	 * Find the leftmost record.  The btree cursor must be set
+	 * to the low record used to generate low_key.
+	 */
+	stat = 0;
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		goto out;
+
+	while (stat) {
+		/* Find the record. */
+		error = xfs_btree_get_rec(cur, &recp, &stat);
+		if (error || !stat)
+			break;
+		cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
+
+		/* Skip if high_key(rec) < low_key. */
+		if (firstrec) {
+			firstrec = false;
+			diff = cur->bc_ops->diff_two_keys(cur, low_key,
+					&rec_key);
+			if (diff > 0)
+				goto advloop;
+		}
+
+		/* Stop if high_key < low_key(rec). */
+		diff = cur->bc_ops->diff_two_keys(cur, &rec_key, high_key);
+		if (diff > 0)
+			break;
+
+		/* Callback */
+		error = fn(cur, recp, priv);
+		if (error < 0 || error == XFS_BTREE_QUERY_RANGE_ABORT)
+			break;
+
+advloop:
+		/* Move on to the next record. */
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			break;
+	}
+
+out:
+	return error;
+}
+
+/*
+ * Query an overlapped interval btree for all records overlapping a given
+ * interval.  This function roughly follows the algorithm given in
+ * "Interval Trees" of _Introduction to Algorithms_, which is section
+ * 14.3 in the 2nd and 3rd editions.
+ *
+ * First, generate keys for the low and high records passed in.
+ *
+ * For any leaf node, generate the high and low keys for the record.
+ * If the record keys overlap with the query low/high keys, pass the
+ * record to the function iterator.
+ *
+ * For any internal node, compare the low and high keys of each
+ * pointer against the query low/high keys.  If there's an overlap,
+ * follow the pointer.
+ *
+ * As an optimization, we stop scanning a block when we find a low key
+ * that is greater than the query's high key.
+ */
+STATIC int
+xfs_btree_overlapped_query_range(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*low_key,
+	union xfs_btree_key		*high_key,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	union xfs_btree_key		rec_key;
+	union xfs_btree_key		rec_hkey;
+	union xfs_btree_key		*lkp;
+	union xfs_btree_key		*hkp;
+	union xfs_btree_rec		*recp;
+	struct xfs_btree_block		*block;
+	__int64_t			ldiff;
+	__int64_t			hdiff;
+	int				level;
+	struct xfs_buf			*bp;
+	int				i;
+	int				error;
+
+	/* Load the root of the btree. */
+	level = cur->bc_nlevels - 1;
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	error = xfs_btree_lookup_get_block(cur, level, &ptr, &block);
+	if (error)
+		return error;
+	xfs_btree_get_block(cur, level, &bp);
+	trace_xfs_btree_overlapped_query_range(cur, level, bp);
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto out;
+#endif
+	cur->bc_ptrs[level] = 1;
+
+	while (level < cur->bc_nlevels) {
+		block = xfs_btree_get_block(cur, level, &bp);
+
+		/* End of node, pop back towards the root. */
+		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+pop_up:
+			if (level < cur->bc_nlevels - 1)
+				cur->bc_ptrs[level + 1]++;
+			level++;
+			continue;
+		}
+
+		if (level == 0) {
+			/* Handle a leaf node. */
+			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+
+			cur->bc_ops->init_high_key_from_rec(&rec_hkey, recp);
+			ldiff = cur->bc_ops->diff_two_keys(cur, &rec_hkey,
+					low_key);
+
+			cur->bc_ops->init_key_from_rec(&rec_key, recp);
+			hdiff = cur->bc_ops->diff_two_keys(cur, high_key,
+					&rec_key);
+
+			/*
+			 * If (record's high key >= query's low key) and
+			 *    (query's high key >= record's low key), then
+			 * this record overlaps the query range; callback.
+			 */
+			if (ldiff >= 0 && hdiff >= 0) {
+				error = fn(cur, recp, priv);
+				if (error < 0 ||
+				    error == XFS_BTREE_QUERY_RANGE_ABORT)
+					break;
+			} else if (hdiff < 0) {
+				/* Record is larger than high key; pop. */
+				goto pop_up;
+			}
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+
+		/* Handle an internal node. */
+		lkp = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
+		hkp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
+		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+
+		ldiff = cur->bc_ops->diff_two_keys(cur, hkp, low_key);
+		hdiff = cur->bc_ops->diff_two_keys(cur, high_key, lkp);
+
+		/*
+		 * If (pointer's high key >= query's low key) and
+		 *    (query's high key >= pointer's low key), then
+		 * this record overlaps the query range; follow pointer.
+		 */
+		if (ldiff >= 0 && hdiff >= 0) {
+			level--;
+			error = xfs_btree_lookup_get_block(cur, level, pp,
+					&block);
+			if (error)
+				goto out;
+			xfs_btree_get_block(cur, level, &bp);
+			trace_xfs_btree_overlapped_query_range(cur, level, bp);
+#ifdef DEBUG
+			error = xfs_btree_check_block(cur, block, level, bp);
+			if (error)
+				goto out;
+#endif
+			cur->bc_ptrs[level] = 1;
+			continue;
+		} else if (hdiff < 0) {
+			/* The low key is larger than the upper range; pop. */
+			goto pop_up;
+		}
+		cur->bc_ptrs[level]++;
+	}
+
+out:
+	/*
+	 * If we don't end this function with the cursor pointing at a record
+	 * block, a subsequent non-error cursor deletion will not release
+	 * node-level buffers, causing a buffer leak.  This is quite possible
+	 * with a zero-results range query, so release the buffers if we
+	 * failed to return any results.
+	 */
+	if (cur->bc_bufs[0] == NULL) {
+		for (i = 0; i < cur->bc_nlevels; i++) {
+			if (cur->bc_bufs[i]) {
+				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
+				cur->bc_bufs[i] = NULL;
+				cur->bc_ptrs[i] = 0;
+				cur->bc_ra[i] = 0;
+			}
+		}
+	}
+
+	return error;
+}
+
+/*
+ * Query a btree for all records overlapping a given interval of keys.  The
+ * supplied function will be called with each record found; return one of the
+ * XFS_BTREE_QUERY_RANGE_{CONTINUE,ABORT} values or the usual negative error
+ * code.  This function returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a
+ * negative error code.
+ */
+int
+xfs_btree_query_range(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_irec		*low_rec,
+	union xfs_btree_irec		*high_rec,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_rec		rec;
+	union xfs_btree_key		low_key;
+	union xfs_btree_key		high_key;
+
+	/* Find the keys of both ends of the interval. */
+	cur->bc_rec = *high_rec;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(&high_key, &rec);
+
+	cur->bc_rec = *low_rec;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(&low_key, &rec);
+
+	/* Enforce low key < high key. */
+	if (cur->bc_ops->diff_two_keys(cur, &low_key, &high_key) > 0)
+		return -EINVAL;
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return xfs_btree_simple_query_range(cur, &low_key,
+				&high_key, fn, priv);
+	return xfs_btree_overlapped_query_range(cur, &low_key, &high_key,
+			fn, priv);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3645d91..4b1c04c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -227,6 +227,12 @@ struct xfs_btree_ops {
 #define LASTREC_DELREC	2
 
 
+union xfs_btree_irec {
+	struct xfs_alloc_rec_incore	a;
+	struct xfs_bmbt_irec		b;
+	struct xfs_inobt_rec_incore	i;
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -237,11 +243,7 @@ typedef struct xfs_btree_cur
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
 	uint			bc_flags; /* btree features - below */
-	union {
-		xfs_alloc_rec_incore_t	a;
-		xfs_bmbt_irec_t		b;
-		xfs_inobt_rec_incore_t	i;
-	}		bc_rec;		/* current insert/search record value */
+	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
 	__uint8_t	bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
@@ -524,4 +526,14 @@ void xfs_btree_get_node_keys_overlapped(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, union xfs_btree_key *key);
 int xfs_btree_update_keys_overlapped(struct xfs_btree_cur *cur, int level);
 
+/* return codes */
+#define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
+#define XFS_BTREE_QUERY_RANGE_ABORT	1	/* stop iterating */
+typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
+		union xfs_btree_rec *rec, void *priv);
+
+int xfs_btree_query_range(struct xfs_btree_cur *cur,
+		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
+		xfs_btree_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8fb59e6..a586268 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2220,6 +2220,7 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp), \
 	TP_ARGS(cur, level, bp))
 DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
+DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
 
 #endif /* _TRACE_XFS_H */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
