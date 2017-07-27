Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46725 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdG0Wm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:42:27 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMgPuM012174
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMgP4r009674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:25 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMgOHq021864
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:24 GMT
Subject: [PATCH 07/26] xfs: scrub the shape of a metadata btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:42:23 -0700
Message-ID: <150119534316.15159.17865115082853260840.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a function that can check the shape of a btree -- each block
passes basic inspection and all the pointers look ok.  In the next patch
we'll add the ability to check the actual keys and records stored within
the btree.  Add some helper functions so that we report detailed scrub
errors in a uniform manner in dmesg.  These are helper functions for
subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   14 ++-
 fs/xfs/libxfs/xfs_btree.h |    6 +
 fs/xfs/scrub/btree.c      |  238 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h     |   13 ++
 4 files changed, 268 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e0bcc4a..d4637c2 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1052,7 +1052,7 @@ xfs_btree_set_ptr_null(
 /*
  * Get/set/init sibling pointers
  */
-STATIC void
+void
 xfs_btree_get_sibling(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -4905,3 +4905,15 @@ xfs_btree_count_blocks(
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
index 9c95e96..68bafae 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -516,5 +516,11 @@ int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
 		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
 struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
+int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
+				const union xfs_btree_ptr *a,
+				const union xfs_btree_ptr *b);
+void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
+			   struct xfs_btree_block *block,
+			   union xfs_btree_ptr *ptr, int lr);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 4b95909..9a9a020 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -99,6 +99,154 @@ xfs_scrub_btree_check_ok(
 	return fs_ok;
 }
 
+/* Check a btree pointer. */
+static int
+xfs_scrub_btree_ptr(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*ptr)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+
+	if (!xfs_scrub_btree_check_ok(bs->sc, cur, level,
+			xfs_btree_diff_two_ptrs(cur, ptr, &nullptr) != 0))
+		goto corrupt;
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		if (!xfs_scrub_btree_check_ok(bs->sc, cur, level,
+				cur->bc_private.a.agno != NULLAGNUMBER))
+			goto corrupt;
+
+		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->s));
+	}
+	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
+	if (!xfs_scrub_btree_check_ok(bs->sc, cur, level,
+			daddr != 0 && daddr < eofs))
+		goto corrupt;
+
+	return 0;
+
+corrupt:
+	return -EFSCORRUPTED;
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
+	struct xfs_btree_cur		*ncur;
+	union xfs_btree_ptr		*pp;
+	int				success;
+	int				error;
+
+	if (!xfs_btree_diff_two_ptrs(cur, &nullptr, sibling))
+		return 0;
+
+	error = xfs_btree_dup_cursor(cur, &ncur);
+	if (error)
+		return error;
+
+	if (direction > 0)
+		error = xfs_btree_increment(ncur, level + 1, &success);
+	else
+		error = xfs_btree_decrement(ncur, level + 1, &success);
+	if (!xfs_scrub_btree_op_ok(bs->sc, cur, level + 1, &error) ||
+	    !xfs_scrub_btree_check_ok(bs->sc, cur, level + 1, success))
+		goto out;
+
+	pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
+	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
+	error = xfs_scrub_btree_ptr(bs, level + 1, pp);
+	if (error) {
+		/*
+		 * _scrub_btree_ptr already recorded a garbage sibling.
+		 * Don't let the EFSCORRUPTED bubble up and prevent more
+		 * scanning of the data structure.
+		 */
+		error = 0;
+		goto out;
+	}
+
+	xfs_scrub_btree_check_ok(bs->sc, cur, level,
+			!xfs_btree_diff_two_ptrs(cur, pp, sibling));
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
+		xfs_scrub_btree_check_ok(bs->sc, cur, level,
+				!xfs_btree_diff_two_ptrs(cur, &nullptr,
+					&leftsib) &&
+				!xfs_btree_diff_two_ptrs(cur, &nullptr,
+					&rightsib));
+		goto out;
+	}
+
+	/* Does the left sibling match the parent level left block? */
+	error = xfs_scrub_btree_block_check_sibling(bs, level, -1, &leftsib);
+	if (error)
+		return error;
+
+	/* Does the right sibling match the parent level right block? */
+	error = xfs_scrub_btree_block_check_sibling(bs, level, 1, &rightsib);
+	if (error)
+		return error;
+out:
+	return error;
+}
+
+/* Grab and scrub a btree block. */
+STATIC int
+xfs_scrub_btree_block(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*pp,
+	struct xfs_btree_block		**pblock,
+	struct xfs_buf			**pbp)
+{
+	int				error;
+
+	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
+	if (error)
+		return error;
+
+	xfs_btree_get_block(bs->cur, level, pbp);
+	error = xfs_btree_check_block(bs->cur, *pblock, level, *pbp);
+	if (error)
+		return error;
+
+	return xfs_scrub_btree_block_check_siblings(bs, *pblock);
+}
+
 /*
  * Visit all nodes and leaves of a btree.  Check that all pointers and
  * records are in order, that the keys reflect the records, and use a callback
@@ -114,6 +262,92 @@ xfs_scrub_btree(
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
+	if (!xfs_scrub_btree_check_ok(sc, cur, 0, cur->bc_nlevels > 0 &&
+			cur->bc_nlevels <= XFS_BTREE_MAXLEVELS))
+		goto out;
+
+	/* Make sure the root isn't in the superblock. */
+	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)) {
+		cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+		error = xfs_scrub_btree_ptr(&bs, cur->bc_nlevels, &ptr);
+		if (!xfs_scrub_btree_op_ok(sc, cur, cur->bc_nlevels - 1, &error))
+			goto out;
+	}
+
+	/* Load the root of the btree. */
+	level = cur->bc_nlevels - 1;
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	error = xfs_scrub_btree_block(&bs, level, &ptr, &block, &bp);
+	if (!xfs_scrub_btree_op_ok(sc, cur, cur->bc_nlevels - 1, &error))
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
+			if (xfs_scrub_should_terminate(&error))
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
+		error = xfs_scrub_btree_ptr(&bs, level, pp);
+		if (error) {
+			error = 0;
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+		level--;
+		error = xfs_scrub_btree_block(&bs, level, pp, &block, &bp);
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
index e1bb14b..9920488 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -20,6 +20,19 @@
 #ifndef __XFS_SCRUB_COMMON_H__
 #define __XFS_SCRUB_COMMON_H__
 
+/* Should we end the scrub early? */
+static inline bool
+xfs_scrub_should_terminate(
+	int		*error)
+{
+	if (fatal_signal_pending(current)) {
+		if (*error == 0)
+			*error = -EAGAIN;
+		return true;
+	}
+	return false;
+}
+
 /*
  * Grab a transaction.  If we're going to repair something, we need to
  * ensure there's enough reservation to make all the changes.  If not,

