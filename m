Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9B7A832D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22228AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2vU8xRmhPJ8bxpmh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:20 -0700 (PDT)
Subject: [PATCH 09/24] xfs: support scrubbing free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:15 -0700
Message-ID: <147216937576.6398.3420248267786575580.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the free space btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c |  156 ++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_fs.h          |    4 +
 2 files changed, 117 insertions(+), 43 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index ff4bae4..0c4d397 100644
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
@@ -342,46 +384,76 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
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
 }
-#endif	/* DEBUG */
 
-static const struct xfs_btree_ops xfs_allocbt_ops = {
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
+}
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
+	.keys_inorder		= xfs_bnobt_keys_inorder,
+	.recs_inorder		= xfs_bnobt_recs_inorder,
+};
+
+static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -395,12 +467,11 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_allocbt_key_diff,
+	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
-	.keys_inorder		= xfs_allocbt_keys_inorder,
-	.recs_inorder		= xfs_allocbt_recs_inorder,
-#endif
+	.diff_two_keys		= xfs_cntbt_diff_two_keys,
+	.keys_inorder		= xfs_cntbt_keys_inorder,
+	.recs_inorder		= xfs_cntbt_recs_inorder,
 };
 
 /*
@@ -425,12 +496,13 @@ xfs_allocbt_init_cursor(
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
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index daf8f5d..42ea98b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -563,7 +563,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	1	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	2	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	3	/* AG inode header */
-#define XFS_SCRUB_TYPE_MAX	3
+#define XFS_SCRUB_TYPE_BNOBT	4	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	5	/* freesp by length btree */
+#define XFS_SCRUB_TYPE_MAX	5
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
