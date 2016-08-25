Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 878EA7CE2
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:32:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 597D3304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RJ5q6svmGrIh1KKO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:06 -0700 (PDT)
Subject: [PATCH 01/71] xfs: remove xfs_btree_bigkey
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:32:02 -0700
Message-ID: <147216792277.867.4345768462787186616.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Remove the xfs_btree_bigkey mess and simply make xfs_btree_key big enough
to hold both keys in-core.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.h |   24 ++++++------------------
 2 files changed, 12 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 67fd2ce..d1155ca 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2070,7 +2070,7 @@ __xfs_btree_updkeys(
 	struct xfs_buf		*bp0,
 	bool			force_all)
 {
-	union xfs_btree_bigkey	key;	/* keys from current level */
+	union xfs_btree_key	key;	/* keys from current level */
 	union xfs_btree_key	*lkey;	/* keys from the next level up */
 	union xfs_btree_key	*hkey;
 	union xfs_btree_key	*nlkey;	/* keys from the next level up */
@@ -2086,7 +2086,7 @@ __xfs_btree_updkeys(
 
 	trace_xfs_btree_updkeys(cur, level, bp0);
 
-	lkey = (union xfs_btree_key *)&key;
+	lkey = &key;
 	hkey = xfs_btree_high_key_from_key(cur, lkey);
 	xfs_btree_get_keys(cur, block, lkey);
 	for (level++; level < cur->bc_nlevels; level++) {
@@ -3230,7 +3230,7 @@ xfs_btree_insrec(
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
 	struct xfs_btree_cur	*ncur;	/* new btree cursor */
-	union xfs_btree_bigkey	nkey;	/* new block key */
+	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
 	int			ptr;	/* key/record index */
@@ -3245,7 +3245,7 @@ xfs_btree_insrec(
 	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
 
 	ncur = NULL;
-	lkey = (union xfs_btree_key *)&nkey;
+	lkey = &nkey;
 
 	/*
 	 * If we have an external root pointer, and we've made it to the
@@ -3448,14 +3448,14 @@ xfs_btree_insert(
 	union xfs_btree_ptr	nptr;	/* new block number (split result) */
 	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
 	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
-	union xfs_btree_bigkey	bkey;	/* key of block to insert */
+	union xfs_btree_key	bkey;	/* key of block to insert */
 	union xfs_btree_key	*key;
 	union xfs_btree_rec	rec;	/* record to insert */
 
 	level = 0;
 	ncur = NULL;
 	pcur = cur;
-	key = (union xfs_btree_key *)&bkey;
+	key = &bkey;
 
 	xfs_btree_set_ptr_null(cur, &nptr);
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 72f8b3c..870a5ab 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -37,30 +37,18 @@ union xfs_btree_ptr {
 	__be64			l;	/* long form ptr */
 };
 
-union xfs_btree_key {
-	struct xfs_bmbt_key		bmbt;
-	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
-	xfs_alloc_key_t			alloc;
-	struct xfs_inobt_key		inobt;
-	struct xfs_rmap_key		rmap;
-};
-
 /*
- * In-core key that holds both low and high keys for overlapped btrees.
- * The two keys are packed next to each other on disk, so do the same
- * in memory.  Preserve the existing xfs_btree_key as a single key to
- * avoid the mental model breakage that would happen if we passed a
- * bigkey into a function that operates on a single key.
+ * The in-core btree key.  Overlapping btrees actually store two keys
+ * per pointer, so we reserve enough memory to hold both.  The __*bigkey
+ * items should never be accessed directly.
  */
-union xfs_btree_bigkey {
+union xfs_btree_key {
 	struct xfs_bmbt_key		bmbt;
 	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
 	xfs_alloc_key_t			alloc;
 	struct xfs_inobt_key		inobt;
-	struct {
-		struct xfs_rmap_key	rmap;
-		struct xfs_rmap_key	rmap_hi;
-	};
+	struct xfs_rmap_key		rmap;
+	struct xfs_rmap_key		__rmap_bigkey[2];
 };
 
 union xfs_btree_rec {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
