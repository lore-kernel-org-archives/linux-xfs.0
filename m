Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18482 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbcKEAYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:24:39 -0400
Subject: [PATCH 01/39] xfs: plumb in needed functions for range querying of
 the freespace btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:24:34 -0700
Message-ID: <147830547407.4165.5202751159160715187.stgit@birch.djwong.org>
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

Plumb in the pieces (init_high_key, diff_two_keys) necessary to call
query_range on the free space btrees.  Remove the debugging asserts
so that we can make queries starting from block 0.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c |  156 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 117 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index ff4bae4..273ea5b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -203,19 +203,28 @@ xfs_allocbt_init_key_from_rec(
 	union xfs_btree_key	*key,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(rec->alloc.ar_startblock != 0);
-
 	key->alloc.ar_startblock = rec->alloc.ar_startblock;
 	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
 }
 
 STATIC void
+xfs_bnobt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->alloc.ar_startblock);
+	x += be32_to_cpu(rec->alloc.ar_blockcount) - 1;
+	key->alloc.ar_startblock = cpu_to_be32(x);
+	key->alloc.ar_blockcount = 0;
+}
+
+STATIC void
 xfs_allocbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(cur->bc_rec.a.ar_startblock != 0);
-
 	rec->alloc.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
 	rec->alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
 }
@@ -234,18 +243,24 @@ xfs_allocbt_init_ptr_from_cur(
 }
 
 STATIC __int64_t
-xfs_allocbt_key_diff(
+xfs_bnobt_key_diff(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*key)
 {
 	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
 	xfs_alloc_key_t		*kp = &key->alloc;
-	__int64_t		diff;
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
-		return (__int64_t)be32_to_cpu(kp->ar_startblock) -
-				rec->ar_startblock;
-	}
+	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+}
+
+STATIC __int64_t
+xfs_cntbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
+	xfs_alloc_key_t		*kp = &key->alloc;
+	__int64_t		diff;
 
 	diff = (__int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
 	if (diff)
@@ -254,6 +269,33 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
+STATIC __int64_t
+xfs_bnobt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
+			  be32_to_cpu(k2->alloc.ar_startblock);
+}
+
+STATIC __int64_t
+xfs_cntbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	__int64_t		diff;
+
+	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
+		be32_to_cpu(k2->alloc.ar_blockcount);
+	if (diff)
+		return diff;
+
+	return  be32_to_cpu(k1->alloc.ar_startblock) -
+		be32_to_cpu(k2->alloc.ar_startblock);
+}
+
 static bool
 xfs_allocbt_verify(
 	struct xfs_buf		*bp)
@@ -344,44 +386,78 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 
 #if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
-xfs_allocbt_keys_inorder(
+xfs_bnobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*k1,
 	union xfs_btree_key	*k2)
 {
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
-		return be32_to_cpu(k1->alloc.ar_startblock) <
-		       be32_to_cpu(k2->alloc.ar_startblock);
-	} else {
-		return be32_to_cpu(k1->alloc.ar_blockcount) <
-			be32_to_cpu(k2->alloc.ar_blockcount) ||
-			(k1->alloc.ar_blockcount == k2->alloc.ar_blockcount &&
-			 be32_to_cpu(k1->alloc.ar_startblock) <
-			 be32_to_cpu(k2->alloc.ar_startblock));
-	}
+	return be32_to_cpu(k1->alloc.ar_startblock) <
+	       be32_to_cpu(k2->alloc.ar_startblock);
 }
 
 STATIC int
-xfs_allocbt_recs_inorder(
+xfs_bnobt_recs_inorder(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*r1,
 	union xfs_btree_rec	*r2)
 {
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
-		return be32_to_cpu(r1->alloc.ar_startblock) +
-			be32_to_cpu(r1->alloc.ar_blockcount) <=
-			be32_to_cpu(r2->alloc.ar_startblock);
-	} else {
-		return be32_to_cpu(r1->alloc.ar_blockcount) <
-			be32_to_cpu(r2->alloc.ar_blockcount) ||
-			(r1->alloc.ar_blockcount == r2->alloc.ar_blockcount &&
-			 be32_to_cpu(r1->alloc.ar_startblock) <
-			 be32_to_cpu(r2->alloc.ar_startblock));
-	}
+	return be32_to_cpu(r1->alloc.ar_startblock) +
+		be32_to_cpu(r1->alloc.ar_blockcount) <=
+		be32_to_cpu(r2->alloc.ar_startblock);
+}
+
+STATIC int
+xfs_cntbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->alloc.ar_blockcount) <
+		be32_to_cpu(k2->alloc.ar_blockcount) ||
+		(k1->alloc.ar_blockcount == k2->alloc.ar_blockcount &&
+		 be32_to_cpu(k1->alloc.ar_startblock) <
+		 be32_to_cpu(k2->alloc.ar_startblock));
+}
+
+STATIC int
+xfs_cntbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return be32_to_cpu(r1->alloc.ar_blockcount) <
+		be32_to_cpu(r2->alloc.ar_blockcount) ||
+		(r1->alloc.ar_blockcount == r2->alloc.ar_blockcount &&
+		 be32_to_cpu(r1->alloc.ar_startblock) <
+		 be32_to_cpu(r2->alloc.ar_startblock));
 }
-#endif	/* DEBUG */
+#endif /* DEBUG */
+
+static const struct xfs_btree_ops xfs_bnobt_ops = {
+	.rec_len		= sizeof(xfs_alloc_rec_t),
+	.key_len		= sizeof(xfs_alloc_key_t),
+
+	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.set_root		= xfs_allocbt_set_root,
+	.alloc_block		= xfs_allocbt_alloc_block,
+	.free_block		= xfs_allocbt_free_block,
+	.update_lastrec		= xfs_allocbt_update_lastrec,
+	.get_minrecs		= xfs_allocbt_get_minrecs,
+	.get_maxrecs		= xfs_allocbt_get_maxrecs,
+	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_bnobt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
+	.key_diff		= xfs_bnobt_key_diff,
+	.buf_ops		= &xfs_allocbt_buf_ops,
+	.diff_two_keys		= xfs_bnobt_diff_two_keys,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_bnobt_keys_inorder,
+	.recs_inorder		= xfs_bnobt_recs_inorder,
+#endif
+};
 
-static const struct xfs_btree_ops xfs_allocbt_ops = {
+static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -395,11 +471,12 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_allocbt_key_diff,
+	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
+	.diff_two_keys		= xfs_cntbt_diff_two_keys,
 #if defined(DEBUG) || defined(XFS_WARN)
-	.keys_inorder		= xfs_allocbt_keys_inorder,
-	.recs_inorder		= xfs_allocbt_recs_inorder,
+	.keys_inorder		= xfs_cntbt_keys_inorder,
+	.recs_inorder		= xfs_cntbt_recs_inorder,
 #endif
 };
 
@@ -425,12 +502,13 @@ xfs_allocbt_init_cursor(
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_allocbt_ops;
 
 	if (btnum == XFS_BTNUM_CNT) {
+		cur->bc_ops = &xfs_cntbt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
+		cur->bc_ops = &xfs_bnobt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	}
 

