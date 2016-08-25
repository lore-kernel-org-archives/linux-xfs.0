Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17383834A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B45EB304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id hv42dd95ZZBDsA02 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:41 -0700 (PDT)
Subject: [PATCH 12/24] xfs: support scrubbing refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:34 -0700
Message-ID: <147216939468.6398.12957432650994916456.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

v2: Handle the case where the rmap records are not all at least the
length of the refcount extent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h             |    3 ++-
 libxfs/xfs_refcount_btree.c |   33 +++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index bfc3940..45e0800 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -568,7 +568,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_INOBT	6	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
-#define XFS_SCRUB_TYPE_MAX	8
+#define XFS_SCRUB_TYPE_REFCNTBT	9	/* reference count btree */
+#define XFS_SCRUB_TYPE_MAX	9
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index d2dbdbd..7975abc 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -163,18 +163,26 @@ xfs_refcountbt_init_key_from_rec(
 	union xfs_btree_key	*key,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(rec->refc.rc_startblock != 0);
-
 	key->refc.rc_startblock = rec->refc.rc_startblock;
 }
 
 STATIC void
+xfs_refcountbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->refc.rc_startblock);
+	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
+	key->refc.rc_startblock = cpu_to_be32(x);
+}
+
+STATIC void
 xfs_refcountbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(cur->bc_rec.rc.rc_startblock != 0);
-
 	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
 	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
 	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
@@ -204,6 +212,16 @@ xfs_refcountbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
 }
 
+STATIC __int64_t
+xfs_refcountbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->refc.rc_startblock) -
+			  be32_to_cpu(k2->refc.rc_startblock);
+}
+
 STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
@@ -266,7 +284,6 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -295,13 +312,13 @@ xfs_refcountbt_recs_inorder(
 		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
 		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
 		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		a = a; b = b;
 		trace_xfs_refcount_rec_order_error(cur->bc_mp,
 				cur->bc_private.a.agno, &a, &b);
 	}
 
 	return ret;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
@@ -314,14 +331,14 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.get_minrecs		= xfs_refcountbt_get_minrecs,
 	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
 	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
-#endif
 };
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
