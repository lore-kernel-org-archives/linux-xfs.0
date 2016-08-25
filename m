Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE6B98342
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67E0AAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:34 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id u2V8fcKz2ciiR4k5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:32 -0700 (PDT)
Subject: [PATCH 11/24] xfs: support scrubbing rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:28 -0700
Message-ID: <147216938852.6398.18199178103372916204.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h         |    3 ++-
 libxfs/xfs_rmap.c       |    3 ++-
 libxfs/xfs_rmap.h       |    3 +++
 libxfs/xfs_rmap_btree.c |    4 ----
 4 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 03fdfb5..bfc3940 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -567,7 +567,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_CNTBT	5	/* freesp by length btree */
 #define XFS_SCRUB_TYPE_INOBT	6	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
-#define XFS_SCRUB_TYPE_MAX	7
+#define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	8
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 7a75e26..4ce2025 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -177,7 +177,8 @@ done:
 	return error;
 }
 
-static int
+/* Convert an internal btree record to an rmap record. */
+int
 xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 7899305..188db38 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -212,5 +212,8 @@ int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
+union xfs_btree_rec;
+int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_rmap_irec *irec);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 02ceace..42a6bad 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -375,7 +375,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -435,7 +434,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -454,10 +452,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
