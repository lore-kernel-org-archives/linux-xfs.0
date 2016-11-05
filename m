Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40054 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754336AbcKEA1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:47 -0400
Subject: [PATCH 30/39] xfs: add helper routines for the repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:43 -0700
Message-ID: <147830566302.4165.9641638696775205705.stgit@birch.djwong.org>
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

Add some helper functions for repair functions that will help us to
allocate and initialize new metadata blocks for btrees that we're
rebuilding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c  |    9 ++++++++
 libxfs/xfs_alloc_btree.h  |    2 ++
 libxfs/xfs_bmap_btree.c   |    9 ++++++++
 libxfs/xfs_bmap_btree.h   |    3 +++
 libxfs/xfs_btree.c        |    4 ++--
 libxfs/xfs_btree.h        |    2 +-
 libxfs/xfs_ialloc_btree.c |    9 ++++++++
 libxfs/xfs_ialloc_btree.h |    3 +++
 libxfs/xfs_rmap.c         |   51 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h         |    3 +++
 10 files changed, 92 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 41e2eac..2f4491f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -530,3 +530,12 @@ xfs_allocbt_maxrecs(
 		return blocklen / sizeof(xfs_alloc_rec_t);
 	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
 }
+
+/* Calculate the freespace btree size for some records. */
+xfs_extlen_t
+xfs_allocbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_alloc_mnr, len);
+}
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 45e189e..2fd5472 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -61,5 +61,7 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 78a0440..c7c11aa 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -909,3 +909,12 @@ xfs_bmbt_change_owner(
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	return error;
 }
+
+/* Calculate the bmap btree size for some records. */
+unsigned long long
+xfs_bmbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_bmap_dmnr, len);
+}
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 819a8a4..835f0a3 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -140,4 +140,7 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
+extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4a291cc..0c7d549 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4820,7 +4820,7 @@ xfs_btree_query_all(
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
  */
-xfs_extlen_t
+unsigned long long
 xfs_btree_calc_size(
 	struct xfs_mount	*mp,
 	uint			*limits,
@@ -4828,7 +4828,7 @@ xfs_btree_calc_size(
 {
 	int			level;
 	int			maxrecs;
-	xfs_extlen_t		rval;
+	unsigned long long	rval;
 
 	maxrecs = limits[0];
 	for (level = 0, rval = 0; len > 1; level++) {
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 0210662..52714f0 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -515,7 +515,7 @@ bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
-xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
+unsigned long long xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
 		unsigned long long len);
 
 /* return codes */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 4795f08..978685e 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -497,3 +497,12 @@ xfs_inobt_rec_check_count(
 	return 0;
 }
 #endif	/* DEBUG */
+
+/* Calculate the inobt btree size for some records. */
+xfs_extlen_t
+xfs_iallocbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_inobt_mnr, len);
+}
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index bd88453..3046c11 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -72,4 +72,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #define xfs_inobt_rec_check_count(mp, rec)	0
 #endif	/* DEBUG */
 
+extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 0b8eed1..c7d8aac 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2362,3 +2362,54 @@ xfs_rmap_record_exists(
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
 }
+
+struct xfs_rmap_has_other_keys {
+	uint64_t			owner;
+	uint64_t			offset;
+	bool				*has_rmap;
+	unsigned int			flags;
+};
+
+/* For each rmap given, figure out if it doesn't match the key we want. */
+STATIC int
+xfs_rmap_has_other_keys_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_rmap_has_other_keys	*rhok = priv;
+
+	if (rhok->owner == rec->rm_owner && rhok->offset == rec->rm_offset &&
+	    ((rhok->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rhok->flags)
+		return 0;
+	*rhok->has_rmap = true;
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/*
+ * Given an extent and some owner info, can we find records overlapping
+ * the extent whose owner info does not match the given owner?
+ */
+int
+xfs_rmap_has_other_keys(
+	struct xfs_btree_cur		*cur,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	struct xfs_owner_info		*oinfo,
+	bool				*has_rmap)
+{
+	struct xfs_rmap_irec		low = {0};
+	struct xfs_rmap_irec		high;
+	struct xfs_rmap_has_other_keys	rhok;
+
+	xfs_owner_info_unpack(oinfo, &rhok.owner, &rhok.offset, &rhok.flags);
+	*has_rmap = false;
+	rhok.has_rmap = has_rmap;
+
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	return xfs_rmap_query_range(cur, &low, &high,
+			xfs_rmap_has_other_keys_helper, &rhok);
+}
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index ea359ab..606efe3 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -222,5 +222,8 @@ int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */

