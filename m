Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF9A38355
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7677D304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LGHvBDkk2NlVrivD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:53 -0700 (PDT)
Subject: [PATCH 14/24] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:49 -0700
Message-ID: <147216940951.6398.12992976318472582887.stgit@birch.djwong.org>
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

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.h       |   12 ++++++------
 libxfs/xfs_bmap_btree.c |   26 ++++++++++++++++++++++----
 libxfs/xfs_fs.h         |    5 ++++-
 3 files changed, 32 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index e60be02..4afa21c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -235,12 +235,6 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 
-struct xfs_bmbt_rec_host *
-	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
-				int fork, int *eofp, xfs_extnum_t *lastxp,
-				struct xfs_bmbt_irec *gotp,
-				struct xfs_bmbt_irec *prevp);
-
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP,
 	XFS_BMAP_UNMAP,
@@ -265,4 +259,10 @@ int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 
+struct xfs_bmbt_rec_host *
+	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
+				int fork, int *eofp, xfs_extnum_t *lastxp,
+				struct xfs_bmbt_irec *gotp,
+				struct xfs_bmbt_irec *prevp);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 601385d..54306b1 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -620,6 +620,16 @@ xfs_bmbt_init_key_from_rec(
 }
 
 STATIC void
+xfs_bmbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff = cpu_to_be64(
+			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
+			xfs_bmbt_disk_get_blockcount(&rec->bmbt) - 1);
+}
+
+STATIC void
 xfs_bmbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -644,6 +654,16 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+STATIC __int64_t
+xfs_bmbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
+			  be64_to_cpu(k2->bmbt.br_startoff);
+}
+
 static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
@@ -734,7 +754,6 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -755,7 +774,6 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
@@ -769,14 +787,14 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
+	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f8301c8..9829a6a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -570,7 +570,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	9	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	10	/* inode record */
-#define XFS_SCRUB_TYPE_MAX	10
+#define XFS_SCRUB_TYPE_BMBTD	11	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	12	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	13	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_MAX	13
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
