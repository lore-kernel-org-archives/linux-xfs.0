Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48431 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754065AbcL3OUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2016 09:20:02 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Date: Fri, 30 Dec 2016 15:19:58 +0100
Message-Id: <1483107598-6779-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Currently we try to rely on the global reserved block pool for block
allocations for the free inode btree, but I have customer reports
(fairly complex workload, need to find an easier reproducer) where that
is not enough as the AG where we free an inode that requires a new
finobt block is entirely full.  This causes us to cancel a dirty
transaction and thus a file system shutdown.

I think the right way to guard against this is to treat the finot the same
way as the refcount btree and have a per-AG reservations for the possible
worst case size of it, and the patch below implements that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag_resv.c      |  6 +++
 fs/xfs/libxfs/xfs_ialloc.h       |  1 -
 fs/xfs/libxfs/xfs_ialloc_btree.c | 96 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.h |  3 ++
 fs/xfs/libxfs/xfs_trans_space.h  |  3 --
 fs/xfs/xfs_inode.c               | 25 ++---------
 6 files changed, 105 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e5ebc37..592754b 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -39,6 +39,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_ialloc_btree.h"
 
 /*
  * Per-AG Block Reservations
@@ -236,6 +237,11 @@ xfs_ag_resv_init(
 		if (error)
 			goto out;
 
+		error = xfs_finobt_calc_reserves(pag->pag_mount,
+				pag->pag_agno, &ask, &used);
+		if (error)
+			goto out;
+
 		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA,
 				ask, used);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 0bb8966..3f24725 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -168,5 +168,4 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
-
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 0fd086d..3aba153 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -82,11 +82,12 @@ xfs_finobt_set_root(
 }
 
 STATIC int
-xfs_inobt_alloc_block(
+__xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*start,
 	union xfs_btree_ptr	*new,
-	int			*stat)
+	int			*stat,
+	enum xfs_ag_resv_type	resv)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
 	int			error;		/* error return value */
@@ -103,6 +104,7 @@ xfs_inobt_alloc_block(
 	args.maxlen = 1;
 	args.prod = 1;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.resv = resv;
 
 	error = xfs_alloc_vextent(&args);
 	if (error) {
@@ -123,6 +125,27 @@ xfs_inobt_alloc_block(
 }
 
 STATIC int
+xfs_inobt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	return __xfs_inobt_alloc_block(cur, start, new, stat, XFS_AG_RESV_NONE);
+}
+
+STATIC int
+xfs_finobt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	return __xfs_inobt_alloc_block(cur, start, new, stat,
+			XFS_AG_RESV_METADATA);
+}
+
+STATIC int
 xfs_inobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
@@ -328,7 +351,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
-	.alloc_block		= xfs_inobt_alloc_block,
+	.alloc_block		= xfs_finobt_alloc_block,
 	.free_block		= xfs_inobt_free_block,
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
@@ -480,3 +503,70 @@ xfs_inobt_rec_check_count(
 	return 0;
 }
 #endif	/* DEBUG */
+
+static xfs_extlen_t
+xfs_inobt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_inobt_mnr, len);
+}
+
+static xfs_extlen_t
+xfs_inobt_max_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_inobt_mxr[0] == 0)
+		return 0;
+
+	return xfs_inobt_calc_size(mp, mp->m_sb.sb_agblocks);
+}
+
+static int
+xfs_inobt_count_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
+	if (error)
+		return error;
+
+	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
+	error = xfs_btree_count_blocks(cur, tree_blocks);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+
+	return error;
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+int
+xfs_finobt_calc_reserves(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	xfs_extlen_t		tree_len = 0;
+	int			error;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return 0;
+
+	error = xfs_inobt_count_blocks(mp, agno, XFS_BTNUM_FINO, &tree_len);
+	if (error)
+		return error;
+
+	*ask += xfs_inobt_max_size(mp);
+	*used += tree_len;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index bd88453..aa81e2e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -72,4 +72,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #define xfs_inobt_rec_check_count(mp, rec)	0
 #endif	/* DEBUG */
 
+int xfs_finobt_calc_reserves(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_extlen_t *ask, xfs_extlen_t *used);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 7917f6e..6db3e2d 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -94,8 +94,5 @@
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
-#define XFS_IFREE_SPACE_RES(mp)		\
-	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
-
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b955779..0283ab6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1792,30 +1792,11 @@ xfs_inactive_ifree(
 	int			error;
 
 	/*
-	 * The ifree transaction might need to allocate blocks for record
-	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
-	 * allow ifree to dip into the reserved block pool if necessary.
-	 *
-	 * Freeing large sets of inodes generally means freeing inode chunks,
-	 * directory and file data blocks, so this should be relatively safe.
-	 * Only under severe circumstances should it be possible to free enough
-	 * inodes to exhaust the reserve block pool via finobt expansion while
-	 * at the same time not creating free space in the filesystem.
-	 *
-	 * Send a warning if the reservation does happen to fail, as the inode
-	 * now remains allocated and sits on the unlinked list until the fs is
-	 * repaired.
+	 * We use a per-AG reservation for any block needed by the finobt tree.
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
-			XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree, 0, 0, 0, &tp);
 	if (error) {
-		if (error == -ENOSPC) {
-			xfs_warn_ratelimited(mp,
-			"Failed to remove inode(s) from unlinked list. "
-			"Please free space, unmount and run xfs_repair.");
-		} else {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		}
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		return error;
 	}
 
-- 
2.1.4

