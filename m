Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30418 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdJLBl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:41:59 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1fw7n027947
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1fvs8005721
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:58 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C1fv5d020519
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:57 GMT
Subject: [PATCH 11/30] xfs: scrub the shape of a metadata btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:41:56 -0700
Message-ID: <150777251646.1724.4676276998721808182.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a function that can check the shape of a btree -- each block
passes basic inspection and all the pointers look ok.  In the next patch
we'll add the ability to check the actual keys and records stored within
the btree.  Add some helper functions so that we report detailed scrub
errors in a uniform manner in dmesg.  These are helper functions for
subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   16 +++
 fs/xfs/libxfs/xfs_btree.h |    7 +
 fs/xfs/scrub/btree.c      |  249 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.h     |   18 +++
 4 files changed, 283 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2266a5a..dc23407 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1051,7 +1051,7 @@ xfs_btree_setbuf(
 	}
 }
 
-STATIC int
+bool
 xfs_btree_ptr_is_null(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
@@ -1076,7 +1076,7 @@ xfs_btree_set_ptr_null(
 /*
  * Get/set/init sibling pointers
  */
-STATIC void
+void
 xfs_btree_get_sibling(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -4938,3 +4938,15 @@ xfs_btree_count_blocks(
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
 			blocks);
 }
+
+/* Compare two btree pointers. */
+int64_t
+xfs_btree_diff_two_ptrs(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*a,
+	const union xfs_btree_ptr	*b)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
+	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index baf7064..a8431bc 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -531,5 +531,12 @@ int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
 		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
 struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
+bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur, union xfs_btree_ptr *ptr);
+int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
+				const union xfs_btree_ptr *a,
+				const union xfs_btree_ptr *b);
+void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
+			   struct xfs_btree_block *block,
+			   union xfs_btree_ptr *ptr, int lr);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 28539081..68dec6a 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -93,11 +93,170 @@ xfs_scrub_btree_set_corrupt(
 }
 
 /*
+ * Check a btree pointer.  Returns true if it's ok to use this pointer.
+ * Callers do not need to set the corrupt flag.
+ */
+static bool
+xfs_scrub_btree_ptr_ok(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*ptr)
+{
+	bool				res;
+
+	/* A btree rooted in an inode has no block pointer to the root. */
+	if ((bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == bs->cur->bc_nlevels)
+		return true;
+
+	/* Otherwise, check the pointers. */
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		res = xfs_btree_check_lptr(bs->cur, be64_to_cpu(ptr->l), level);
+		if (!res)
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+	} else {
+		res = xfs_btree_check_sptr(bs->cur, be32_to_cpu(ptr->s), level);
+		if (!res)
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+	}
+
+	return res;
+}
+
+/* Check that a btree block's sibling matches what we expect it. */
+STATIC int
+xfs_scrub_btree_block_check_sibling(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	int				direction,
+	union xfs_btree_ptr		*sibling)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	struct xfs_btree_block		*pblock;
+	struct xfs_buf			*pbp;
+	struct xfs_btree_cur		*ncur = NULL;
+	union xfs_btree_ptr		*pp;
+	int				success;
+	int				error;
+
+	if (xfs_btree_ptr_is_null(cur, sibling))
+		return 0;
+
+	error = xfs_btree_dup_cursor(cur, &ncur);
+	if (!xfs_scrub_btree_process_error(bs->sc, cur, level + 1, &error) ||
+	    !ncur)
+		return error;
+
+	if (direction > 0)
+		error = xfs_btree_increment(ncur, level + 1, &success);
+	else
+		error = xfs_btree_decrement(ncur, level + 1, &success);
+	if (!xfs_scrub_btree_process_error(bs->sc, cur, level + 1, &error))
+		goto out;
+	if (!success) {
+		xfs_scrub_btree_set_corrupt(bs->sc, cur, level + 1);
+		goto out;
+	}
+
+	pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
+	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
+	if (!xfs_scrub_btree_ptr_ok(bs, level + 1, pp))
+		goto out;
+
+	if (xfs_btree_diff_two_ptrs(cur, pp, sibling))
+		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+out:
+	xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Check the siblings of a btree block. */
+STATIC int
+xfs_scrub_btree_block_check_siblings(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_btree_block		*block)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	union xfs_btree_ptr		leftsib;
+	union xfs_btree_ptr		rightsib;
+	int				level;
+	int				error = 0;
+
+	xfs_btree_get_sibling(cur, block, &leftsib, XFS_BB_LEFTSIB);
+	xfs_btree_get_sibling(cur, block, &rightsib, XFS_BB_RIGHTSIB);
+	level = xfs_btree_get_level(block);
+
+	/* Root block should never have siblings. */
+	if (level == cur->bc_nlevels - 1) {
+		if (!xfs_btree_ptr_is_null(cur, &leftsib) ||
+		    !xfs_btree_ptr_is_null(cur, &rightsib))
+			xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		goto out;
+	}
+
+	/*
+	 * Does the left & right sibling pointers match the adjacent
+	 * parent level pointers?
+	 * (These function absorbs error codes for us.)
+	 */
+	error = xfs_scrub_btree_block_check_sibling(bs, level, -1, &leftsib);
+	if (error)
+		return error;
+	error = xfs_scrub_btree_block_check_sibling(bs, level, 1, &rightsib);
+	if (error)
+		return error;
+out:
+	return error;
+}
+
+/*
+ * Grab and scrub a btree block given a btree pointer.  Returns block
+ * and buffer pointers (if applicable) if they're ok to use.
+ */
+STATIC int
+xfs_scrub_btree_get_block(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*pp,
+	struct xfs_btree_block		**pblock,
+	struct xfs_buf			**pbp)
+{
+	void				*failed_at;
+	int				error;
+
+	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
+	if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, level, &error) ||
+	    !pblock)
+		return error;
+
+	xfs_btree_get_block(bs->cur, level, pbp);
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		failed_at = __xfs_btree_check_lblock(bs->cur, *pblock,
+				level, *pbp);
+		if (failed_at) {
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+			return 0;
+		}
+	} else {
+		failed_at = __xfs_btree_check_sblock(bs->cur, *pblock,
+				 level, *pbp);
+		if (failed_at) {
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+			return 0;
+		}
+	}
+
+	/*
+	 * Check the block's siblings; this function absorbs error codes
+	 * for us.
+	 */
+	return xfs_scrub_btree_block_check_siblings(bs, *pblock);
+}
+
+/*
  * Visit all nodes and leaves of a btree.  Check that all pointers and
  * records are in order, that the keys reflect the records, and use a callback
- * so that the caller can verify individual records.  The callback is the same
- * as the one for xfs_btree_query_range, so therefore this function also
- * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
+ * so that the caller can verify individual records.
  */
 int
 xfs_scrub_btree(
@@ -107,8 +266,88 @@ xfs_scrub_btree(
 	struct xfs_owner_info		*oinfo,
 	void				*private)
 {
-	int				error = -EOPNOTSUPP;
+	struct xfs_scrub_btree		bs = {0};
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	struct xfs_btree_block		*block;
+	int				level;
+	struct xfs_buf			*bp;
+	int				i;
+	int				error = 0;
+
+	/* Initialize scrub state */
+	bs.cur = cur;
+	bs.scrub_rec = scrub_fn;
+	bs.oinfo = oinfo;
+	bs.firstrec = true;
+	bs.private = private;
+	bs.sc = sc;
+	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
+		bs.firstkey[i] = true;
+	INIT_LIST_HEAD(&bs.to_check);
+
+	/* Don't try to check a tree with a height we can't handle. */
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
+		xfs_scrub_btree_set_corrupt(sc, cur, 0);
+		goto out;
+	}
+
+	/*
+	 * Load the root of the btree.  The helper function absorbs
+	 * error codes for us.
+	 */
+	level = cur->bc_nlevels - 1;
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	if (!xfs_scrub_btree_ptr_ok(&bs, cur->bc_nlevels, &ptr))
+		goto out;
+	error = xfs_scrub_btree_get_block(&bs, level, &ptr, &block, &bp);
+	if (error)
+		goto out;
+
+	cur->bc_ptrs[level] = 1;
+
+	while (level < cur->bc_nlevels) {
+		block = xfs_btree_get_block(cur, level, &bp);
+
+		if (level == 0) {
+			/* End of leaf, pop back towards the root. */
+			if (cur->bc_ptrs[level] >
+			    be16_to_cpu(block->bb_numrecs)) {
+				if (level < cur->bc_nlevels - 1)
+					cur->bc_ptrs[level + 1]++;
+				level++;
+				continue;
+			}
+
+			if (xfs_scrub_should_terminate(sc, &error))
+				break;
+
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+
+		/* End of node, pop back towards the root. */
+		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+			if (level < cur->bc_nlevels - 1)
+				cur->bc_ptrs[level + 1]++;
+			level++;
+			continue;
+		}
+
+		/* Drill another level deeper. */
+		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+		if (!xfs_scrub_btree_ptr_ok(&bs, level, pp)) {
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+		level--;
+		error = xfs_scrub_btree_get_block(&bs, level, pp, &block, &bp);
+		if (!xfs_scrub_btree_process_error(sc, cur, level, &error))
+			goto out;
+
+		cur->bc_ptrs[level] = 1;
+	}
 
-	xfs_scrub_btree_process_error(sc, cur, 0, &error);
+out:
 	return error;
 }
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index a7c3361..414bbb8 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -21,6 +21,24 @@
 #define __XFS_SCRUB_COMMON_H__
 
 /*
+ * We /could/ terminate a scrub/repair operation early.  If we're not
+ * in a good place to continue (fatal signal, etc.) then bail out.
+ * Note that we're careful not to make any judgements about *error.
+ */
+static inline bool
+xfs_scrub_should_terminate(
+	struct xfs_scrub_context	*sc,
+	int				*error)
+{
+	if (fatal_signal_pending(current)) {
+		if (*error == 0)
+			*error = -EAGAIN;
+		return true;
+	}
+	return false;
+}
+
+/*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
  */

