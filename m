Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRClY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:24 -0400
Subject: [PATCH 2/9] xfs: add helpers to calculate btree size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:04 -0700
Message-ID: <152401926470.11792.10260532727847797264.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a bunch of helper functions that calculate the sizes of various
btrees.  These will be used to repair btrees and btree headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c  |    9 +++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h  |    2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c   |    9 +++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h   |    3 +++
 fs/xfs/libxfs/xfs_btree.c        |    4 ++--
 fs/xfs/libxfs/xfs_btree.h        |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    9 +++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 ++
 8 files changed, 37 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index b451649..18aec7a 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -547,3 +547,12 @@ xfs_allocbt_maxrecs(
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
+	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 45e189e..2fd5472 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -61,5 +61,7 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d89d06b..ac9d4ae 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -660,3 +660,12 @@ xfs_bmbt_change_owner(
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
+	return xfs_btree_calc_size(mp->m_bmap_dmnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index e450574..fb3cd2d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -118,4 +118,7 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
+extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ac7d664..2a8e01a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4836,14 +4836,14 @@ xfs_btree_query_all(
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
  */
-xfs_extlen_t
+unsigned long long
 xfs_btree_calc_size(
 	uint			*limits,
 	unsigned long long	len)
 {
 	int			level;
 	int			maxrecs;
-	xfs_extlen_t		rval;
+	unsigned long long	rval;
 
 	maxrecs = limits[0];
 	for (level = 0, rval = 0; len > 1; level++) {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 9227159..3236b3a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -482,7 +482,7 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
-xfs_extlen_t xfs_btree_calc_size(uint *limits, unsigned long long len);
+unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
 /* return codes */
 #define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 367e9a0..ba053a4 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -608,3 +608,12 @@ xfs_finobt_calc_reserves(
 	*used += tree_len;
 	return 0;
 }
+
+/* Calculate the inobt btree size for some records. */
+xfs_extlen_t
+xfs_iallocbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_inobt_mnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index aa81e2e..4acdd54 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -74,5 +74,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 
 int xfs_finobt_calc_reserves(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_extlen_t *ask, xfs_extlen_t *used);
+extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */

