Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:56:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNkcv4130612
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:03 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2gyau3g0km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNu2Pp028654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:02 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNu2jf022712
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:02 GMT
Subject: [PATCH 01/20] xfs: add helpers to calculate btree size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:00 -0700
Message-ID: <152210856079.13184.1799495382406633140.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a bunch of helper functions that calculate the sizes of various
btrees.  These will be used to repair btrees and btree headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 6840b58..224dfe0 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -553,3 +553,12 @@ xfs_allocbt_maxrecs(
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
index 9faf479..42ca02c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -662,3 +662,12 @@ xfs_bmbt_change_owner(
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
index 79ee4a1..ec6a464 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4944,7 +4944,7 @@ xfs_btree_query_all(
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
  */
-xfs_extlen_t
+unsigned long long
 xfs_btree_calc_size(
 	struct xfs_mount	*mp,
 	uint			*limits,
@@ -4952,7 +4952,7 @@ xfs_btree_calc_size(
 {
 	int			level;
 	int			maxrecs;
-	xfs_extlen_t		rval;
+	unsigned long long	rval;
 
 	maxrecs = limits[0];
 	for (level = 0, rval = 0; len > 1; level++) {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 50440b5..7b5f1db 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -502,7 +502,7 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
-xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
+unsigned long long xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
 		unsigned long long len);
 
 /* return codes */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index af197a5..559fc68 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -613,3 +613,12 @@ xfs_finobt_calc_reserves(
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
+	return xfs_btree_calc_size(mp, mp->m_inobt_mnr, len);
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

