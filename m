Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18516 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbcKEAY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:24:56 -0400
Subject: [PATCH 03/39] xfs: create a function to query all records in a btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:24:46 -0700
Message-ID: <147830548623.4165.4315642921105526788.stgit@birch.djwong.org>
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

Create a helper function that will query all records in a btree.
This will be used by the online repair functions to examine every
record in a btree to rebuild a second btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   15 +++++++++++++++
 libxfs/xfs_alloc.h |    2 ++
 libxfs/xfs_btree.c |   14 ++++++++++++++
 libxfs/xfs_btree.h |    2 ++
 libxfs/xfs_rmap.c  |   28 +++++++++++++++++++++-------
 libxfs/xfs_rmap.h  |    2 ++
 6 files changed, 56 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 382a507..3bfca12 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2969,3 +2969,18 @@ xfs_alloc_query_range(
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
+
+/* Find all free space records. */
+int
+xfs_alloc_query_all(
+	struct xfs_btree_cur			*cur,
+	xfs_alloc_query_range_fn		fn,
+	void					*priv)
+{
+	struct xfs_alloc_query_range_info	query;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
+}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index f9f8b81..0dc34bf 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -232,5 +232,7 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		struct xfs_alloc_rec_incore *low_rec,
 		struct xfs_alloc_rec_incore *high_rec,
 		xfs_alloc_query_range_fn fn, void *priv);
+int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
+		void *priv);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3dea6bd..ee2e489 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4802,6 +4802,20 @@ xfs_btree_query_range(
 			fn, priv);
 }
 
+/* Query a btree for all records. */
+int
+xfs_btree_query_all(
+	struct xfs_btree_cur		*cur,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_rec = {0};
+	union xfs_btree_irec		high_rec;
+
+	memset(&high_rec, 0xFF, sizeof(high_rec));
+	return xfs_btree_query_range(cur, &low_rec, &high_rec, fn, priv);
+}
+
 /*
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index eb20376..6ef5373 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -529,6 +529,8 @@ typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
 		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
 		xfs_btree_query_range_fn fn, void *priv);
+int xfs_btree_query_all(struct xfs_btree_cur *cur, xfs_btree_query_range_fn fn,
+		void *priv);
 
 typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 		void *data);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 7a75e26..7738f50 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1999,14 +1999,14 @@ xfs_rmap_query_range_helper(
 /* Find all rmaps between two keys. */
 int
 xfs_rmap_query_range(
-	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*low_rec,
-	struct xfs_rmap_irec		*high_rec,
-	xfs_rmap_query_range_fn	fn,
-	void				*priv)
+	struct xfs_btree_cur			*cur,
+	struct xfs_rmap_irec			*low_rec,
+	struct xfs_rmap_irec			*high_rec,
+	xfs_rmap_query_range_fn			fn,
+	void					*priv)
 {
-	union xfs_btree_irec		low_brec;
-	union xfs_btree_irec		high_brec;
+	union xfs_btree_irec			low_brec;
+	union xfs_btree_irec			high_brec;
 	struct xfs_rmap_query_range_info	query;
 
 	low_brec.r = *low_rec;
@@ -2017,6 +2017,20 @@ xfs_rmap_query_range(
 			xfs_rmap_query_range_helper, &query);
 }
 
+/* Find all rmaps. */
+int
+xfs_rmap_query_all(
+	struct xfs_btree_cur			*cur,
+	xfs_rmap_query_range_fn			fn,
+	void					*priv)
+{
+	struct xfs_rmap_query_range_info	query;
+
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_all(cur, xfs_rmap_query_range_helper, &query);
+}
+
 /* Clean up after calling xfs_rmap_finish_one. */
 void
 xfs_rmap_finish_one_cleanup(
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 7899305..faf2c1a 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -162,6 +162,8 @@ typedef int (*xfs_rmap_query_range_fn)(
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
 		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
 		xfs_rmap_query_range_fn fn, void *priv);
+int xfs_rmap_query_all(struct xfs_btree_cur *cur, xfs_rmap_query_range_fn fn,
+		void *priv);
 
 enum xfs_rmap_intent_type {
 	XFS_RMAP_MAP,

