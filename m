Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCUla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:41:30 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KfTLY001992
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v93KfTRp011398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93KfSMx004213
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:29 GMT
Subject: [PATCH 06/25] xfs: scrub the shape of a metadata btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:41:27 -0700
Message-ID: <150706328772.19351.6405488670699092537.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
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
 fs/xfs/scrub/btree.c      |  237 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h     |   18 +++
 4 files changed, 274 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5bfb882..c4d8b47 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1027,7 +1027,7 @@ xfs_btree_setbuf(
 	}
 }
 
-STATIC int
+bool
 xfs_btree_ptr_is_null(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
@@ -1052,7 +1052,7 @@ xfs_btree_set_ptr_null(
 /*
  * Get/set/init sibling pointers
  */
-STATIC void
+void
 xfs_btree_get_sibling(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -4914,3 +4914,15 @@ xfs_btree_count_blocks(
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
index f2a88c3..0daf524 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -517,5 +517,12 @@ int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
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
index 9645f6d..899c9b1 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -92,6 +92,152 @@ xfs_scrub_btree_set_corrupt(
 				__return_address);
 }
 
+/* Check a btree pointer.  Returns true if it's ok to use this pointer. */
+static bool
+xfs_scrub_btree_ptr_ok(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*ptr)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+
+	if (xfs_btree_ptr_is_null(cur, ptr)) {
+		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		return false;
+	}
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
+		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->s));
+	}
+	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
+	if (daddr == 0 || daddr >= eofs) {
+		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		return false;
+	}
+
+	return true;
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
+	if (!xfs_scrub_btree_op_ok(bs->sc, cur, level + 1, &error) || !ncur)
+		return error;
+
+	if (direction > 0)
+		error = xfs_btree_increment(ncur, level + 1, &success);
+	else
+		error = xfs_btree_decrement(ncur, level + 1, &success);
+	if (!xfs_scrub_btree_op_ok(bs->sc, cur, level + 1, &error))
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
+	int				error;
+
+	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
+	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, level, &error) || !pblock)
+		return error;
+
+	xfs_btree_get_block(bs->cur, level, pbp);
+	error = xfs_btree_check_block(bs->cur, *pblock, level, *pbp);
+	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, level, &error))
+		return error;
+
+	/*
+	 * Check the block's siblings; this function absorbs error codes
+	 * for us.
+	 */
+	return xfs_scrub_btree_block_check_siblings(bs, *pblock);
+}
+
 /*
  * Visit all nodes and leaves of a btree.  Check that all pointers and
  * records are in order, that the keys reflect the records, and use a callback
@@ -107,6 +253,93 @@ xfs_scrub_btree(
 	struct xfs_owner_info		*oinfo,
 	void				*private)
 {
-	xfs_scrub_btree_op_ok(sc, cur, 0, false);
-	return -EOPNOTSUPP;
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
+	/* Make sure the root isn't in the superblock. */
+	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)) {
+		cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+		if (!xfs_scrub_btree_ptr_ok(&bs, cur->bc_nlevels - 1, &ptr))
+			goto out;
+	}
+
+	/*
+	 * Load the root of the btree.  The helper function absorbs
+	 * error codes for us.
+	 */
+	level = cur->bc_nlevels - 1;
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
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
+		if (!xfs_scrub_btree_op_ok(sc, cur, level, &error))
+			goto out;
+
+		cur->bc_ptrs[level] = 1;
+	}
+
+out:
+	return error;
 }
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e396aa6..309e882 100644
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

