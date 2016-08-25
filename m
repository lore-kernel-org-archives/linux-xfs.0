Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 012E882F0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:55:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E3A7AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zDauS3hBwV4E8cW7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:50 -0700 (PDT)
Subject: [PATCH 04/24] xfs: generic functions to scrub metadata and btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:55:44 -0700
Message-ID: <147216934437.6398.12209563310605493987.stgit@birch.djwong.org>
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

Create a function that walks a btree, checking the integrity of each
btree block (headers, keys, records) and calling back to the caller
to perform further checks on the records.

v2: Prefix function names with xfs_

v3: Add some helper functions to report errors in a more standard
way, including non-btree metadata errors.  Rework scrub dispatching
into a central routine (for the ioctl in the next patch) instead of
using sysfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c  |   41 +++++++++++++++++++++++++++++++++++------
 libxfs/xfs_btree.h  |   17 +++++++++++++++--
 libxfs/xfs_format.h |    2 +-
 3 files changed, 51 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0468a9e..ad205c0 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -548,7 +548,7 @@ xfs_btree_ptr_offset(
 /*
  * Return a pointer to the n-th record in the btree block.
  */
-STATIC union xfs_btree_rec *
+union xfs_btree_rec *
 xfs_btree_rec_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -561,7 +561,7 @@ xfs_btree_rec_addr(
 /*
  * Return a pointer to the n-th key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -574,7 +574,7 @@ xfs_btree_key_addr(
 /*
  * Return a pointer to the n-th high key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_high_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -587,7 +587,7 @@ xfs_btree_high_key_addr(
 /*
  * Return a pointer to the n-th block pointer in the btree block.
  */
-STATIC union xfs_btree_ptr *
+union xfs_btree_ptr *
 xfs_btree_ptr_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -621,7 +621,7 @@ xfs_btree_get_iroot(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be an inode btree root or from a buffer.
  */
-STATIC struct xfs_btree_block *		/* generic btree block pointer */
+struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
@@ -1732,7 +1732,7 @@ error0:
 	return error;
 }
 
-STATIC int
+int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in the btree */
@@ -4848,3 +4848,32 @@ xfs_btree_count_blocks(
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
 			blocks);
 }
+
+/* If there's an extent, we're done. */
+STATIC int
+xfs_btree_has_record_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/* Is there a record covering a given range of keys? */
+int
+xfs_btree_has_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_irec	*low,
+	union xfs_btree_irec	*high,
+	bool			*exists)
+{
+	int			error;
+
+	error = xfs_btree_query_range(cur, low, high,
+			&xfs_btree_has_record_helper, NULL);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		return error;
+	*exists = error == XFS_BTREE_QUERY_RANGE_ABORT;
+
+	return 0;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index eb20376..f81b2a8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -197,7 +197,6 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
@@ -207,7 +206,6 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
-#endif
 };
 
 /*
@@ -537,4 +535,19 @@ int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 
 int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
 
+union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_high_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_ptr *xfs_btree_ptr_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
+		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
+struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
+		int level, struct xfs_buf **bpp);
+int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
+		union xfs_btree_irec *high, bool *exists);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f2b9737..df6518e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -518,7 +518,7 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
-static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
