Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 153358028
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9961304051
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8FNK1vYKd8qdVixu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:44 -0700 (PDT)
Subject: [PATCH 018/145] xfs: introduce interval queries on btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:37 -0700
Message-ID: <146612715724.16048.14399268311501387097.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Create a function to enable querying of btree records mapping to a
range of keys.  This will be used in subsequent patches to allow
querying the reverse mapping btree to find the extents mapped to a
range of physical blocks, though the generic code can be used for
any range query.

v2: add some shortcuts so that we can jump out of processing once
we know there won't be any more records to find.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    1 
 libxfs/xfs_btree.c  |  249 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree.h  |   22 +++--
 3 files changed, 267 insertions(+), 5 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index aea41bc..56c4533 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -167,6 +167,7 @@
 #define trace_xfs_bunmap(a,b,c,d,e)	((void) 0)
 
 #define trace_xfs_btree_updkeys(...)		((void) 0)
+#define trace_xfs_btree_overlapped_query_range(...)	((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 7fa0226..7a34aa1 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4505,3 +4505,252 @@ xfs_btree_calc_size(
 	}
 	return rval;
 }
+
+/* Query a regular btree for all records overlapping a given interval. */
+STATIC int
+xfs_btree_simple_query_range(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_irec		*low_rec,
+	union xfs_btree_irec		*high_rec,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_rec		*recp;
+	union xfs_btree_rec		rec;
+	union xfs_btree_key		low_key;
+	union xfs_btree_key		high_key;
+	union xfs_btree_key		rec_key;
+	__int64_t			diff;
+	int				stat;
+	bool				firstrec = true;
+	int				error;
+
+	ASSERT(cur->bc_ops->init_high_key_from_rec);
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
+	/* Find the leftmost record. */
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
+
+		/* Can we tell if this record is too low? */
+		if (firstrec) {
+			cur->bc_rec = *low_rec;
+			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
+			diff = cur->bc_ops->key_diff(cur, &rec_key);
+			if (diff < 0)
+				goto advloop;
+		}
+		firstrec = false;
+
+		/* Have we gone past the end? */
+		cur->bc_rec = *high_rec;
+		cur->bc_ops->init_key_from_rec(&rec_key, recp);
+		diff = cur->bc_ops->key_diff(cur, &rec_key);
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
+ * interval.
+ */
+STATIC int
+xfs_btree_overlapped_query_range(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_irec		*low_rec,
+	union xfs_btree_irec		*high_rec,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	union xfs_btree_key		rec_key;
+	union xfs_btree_key		low_key;
+	union xfs_btree_key		high_key;
+	union xfs_btree_key		*lkp;
+	union xfs_btree_key		*hkp;
+	union xfs_btree_rec		rec;
+	union xfs_btree_rec		*recp;
+	struct xfs_btree_block		*block;
+	__int64_t			ldiff;
+	__int64_t			hdiff;
+	int				level;
+	struct xfs_buf			*bp;
+	int				i;
+	int				error;
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
+		block = XFS_BUF_TO_BLOCK(cur->bc_bufs[level]);
+
+		if (level == 0) {
+			/* End of leaf, pop back towards the root. */
+			if (cur->bc_ptrs[level] >
+			    be16_to_cpu(block->bb_numrecs)) {
+leaf_pop_up:
+				if (level < cur->bc_nlevels - 1)
+					cur->bc_ptrs[level + 1]++;
+				level++;
+				continue;
+			}
+
+			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+
+			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
+			ldiff = cur->bc_ops->diff_two_keys(cur, &low_key,
+					&rec_key);
+
+			cur->bc_ops->init_key_from_rec(&rec_key, recp);
+			hdiff = cur->bc_ops->diff_two_keys(cur, &rec_key,
+					&high_key);
+
+			/* If the record matches, callback */
+			if (ldiff >= 0 && hdiff >= 0) {
+				error = fn(cur, recp, priv);
+				if (error < 0 ||
+				    error == XFS_BTREE_QUERY_RANGE_ABORT)
+					break;
+			} else if (hdiff < 0) {
+				/* Record is larger than high key; pop. */
+				goto leaf_pop_up;
+			}
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+
+		/* End of node, pop back towards the root. */
+		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+node_pop_up:
+			if (level < cur->bc_nlevels - 1)
+				cur->bc_ptrs[level + 1]++;
+			level++;
+			continue;
+		}
+
+		lkp = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
+		hkp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
+		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+
+		ldiff = cur->bc_ops->diff_two_keys(cur, &low_key, hkp);
+		hdiff = cur->bc_ops->diff_two_keys(cur, lkp, &high_key);
+
+		/* If the key matches, drill another level deeper. */
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
+			goto node_pop_up;
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
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return xfs_btree_simple_query_range(cur, low_rec,
+				high_rec, fn, priv);
+	return xfs_btree_overlapped_query_range(cur, low_rec, high_rec,
+			fn, priv);
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index a5ec6c7..898fee5 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -206,6 +206,12 @@ struct xfs_btree_ops {
 #define LASTREC_DELREC	2
 
 
+union xfs_btree_irec {
+	xfs_alloc_rec_incore_t		a;
+	xfs_bmbt_irec_t			b;
+	xfs_inobt_rec_incore_t		i;
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -216,11 +222,7 @@ typedef struct xfs_btree_cur
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
@@ -494,4 +496,14 @@ xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 		unsigned long len);
 
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
