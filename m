Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41769 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdBRBRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 20:17:47 -0500
Subject: [PATCH 4/8] xfs: create a function to query all records in a btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Feb 2017 17:17:42 -0800
Message-ID: <148738066286.29384.6059407136436797506.stgit@birch.djwong.org>
In-Reply-To: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper function that will query all records in a btree.
This will be used by the online repair functions to examine every
record in a btree to rebuild a second btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |    2 ++
 fs/xfs/libxfs/xfs_btree.c |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 fs/xfs/libxfs/xfs_rmap.c  |   28 +++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_rmap.h  |    2 ++
 6 files changed, 57 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 526df17..ba15f30 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2917,3 +2917,18 @@ xfs_alloc_query_range(
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
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index f534998..a2101de 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -232,5 +232,7 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		struct xfs_alloc_rec_incore *low_rec,
 		struct xfs_alloc_rec_incore *high_rec,
 		xfs_alloc_query_range_fn fn, void *priv);
+int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
+		void *priv);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2849d3f..ca94b87 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4823,6 +4823,21 @@ xfs_btree_query_range(
 			fn, priv);
 }
 
+/* Query a btree for all records. */
+int
+xfs_btree_query_all(
+	struct xfs_btree_cur		*cur,
+	xfs_btree_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_rec;
+	union xfs_btree_irec		high_rec;
+
+	memset(&low_rec, 0, sizeof(low_rec));
+	memset(&high_rec, 0xFF, sizeof(high_rec));
+	return xfs_btree_query_range(cur, &low_rec, &high_rec, fn, priv);
+}
+
 /*
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 33a8f86..5114055 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -494,6 +494,8 @@ typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
 		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
 		xfs_btree_query_range_fn fn, void *priv);
+int xfs_btree_query_all(struct xfs_btree_cur *cur, xfs_btree_query_range_fn fn,
+		void *priv);
 
 typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 		void *data);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3a8cc71..3840556 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2001,14 +2001,14 @@ xfs_rmap_query_range_helper(
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
@@ -2019,6 +2019,20 @@ xfs_rmap_query_range(
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
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 7899305..faf2c1a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -162,6 +162,8 @@ typedef int (*xfs_rmap_query_range_fn)(
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
 		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
 		xfs_rmap_query_range_fn fn, void *priv);
+int xfs_rmap_query_all(struct xfs_btree_cur *cur, xfs_rmap_query_range_fn fn,
+		void *priv);
 
 enum xfs_rmap_intent_type {
 	XFS_RMAP_MAP,

