Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18620 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754105AbcKEAZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:32 -0400
Subject: [PATCH 09/39] xfs: generic functions to scrub metadata and btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:25:29 -0700
Message-ID: <147830552967.4165.1042344470682230569.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create a function that walks a btree, checking the integrity of each
btree block (headers, keys, records) and calling back to the caller
to perform further checks on the records.  Add some helper functions
so that we report detailed scrub errors in a uniform manner in dmesg.
These are helper functions for subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c  |    2 +-
 libxfs/xfs_alloc.h  |    2 ++
 libxfs/xfs_btree.c  |   41 +++++++++++++++++++++++++++++++++++------
 libxfs/xfs_btree.h  |   17 +++++++++++++++--
 libxfs/xfs_format.h |    2 +-
 5 files changed, 54 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3bfca12..0cb8db7 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -625,7 +625,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 /*
  * Read in the allocation group free block array.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 0dc34bf..89a23be 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -217,6 +217,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index ee2e489..4a291cc 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -548,7 +548,7 @@ xfs_btree_ptr_offset(
 /*
  * Return a pointer to the n-th record in the btree block.
  */
-STATIC union xfs_btree_rec *
+union xfs_btree_rec *
 xfs_btree_rec_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -561,7 +561,7 @@ xfs_btree_rec_addr(
 /*
  * Return a pointer to the n-th key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -574,7 +574,7 @@ xfs_btree_key_addr(
 /*
  * Return a pointer to the n-th high key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_high_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -587,7 +587,7 @@ xfs_btree_high_key_addr(
 /*
  * Return a pointer to the n-th block pointer in the btree block.
  */
-STATIC union xfs_btree_ptr *
+union xfs_btree_ptr *
 xfs_btree_ptr_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -621,7 +621,7 @@ xfs_btree_get_iroot(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be an inode btree root or from a buffer.
  */
-STATIC struct xfs_btree_block *		/* generic btree block pointer */
+struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
@@ -1732,7 +1732,7 @@ xfs_btree_decrement(
 	return error;
 }
 
-STATIC int
+int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in the btree */
@@ -4862,3 +4862,32 @@ xfs_btree_count_blocks(
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
 			blocks);
 }
+
+/* If there's an extent, we're done. */
+STATIC int
+xfs_btree_has_record_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/* Is there a record covering a given range of keys? */
+int
+xfs_btree_has_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_irec	*low,
+	union xfs_btree_irec	*high,
+	bool			*exists)
+{
+	int			error;
+
+	error = xfs_btree_query_range(cur, low, high,
+			&xfs_btree_has_record_helper, NULL);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		return error;
+	*exists = error == XFS_BTREE_QUERY_RANGE_ABORT;
+
+	return 0;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6ef5373..0210662 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -197,7 +197,6 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
@@ -207,7 +206,6 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
-#endif
 };
 
 /*
@@ -539,4 +537,19 @@ int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 
 int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
 
+union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_high_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_ptr *xfs_btree_ptr_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
+		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
+struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
+		int level, struct xfs_buf **bpp);
+int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
+		union xfs_btree_irec *high, bool *exists);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e14f964..d819d00 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -518,7 +518,7 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
-static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);

