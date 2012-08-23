Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53xM8135458 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:59 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9eyIhv2r4O1uXeNP for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:43 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003HY-HF
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003fg-Et
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 054/102] xfs: make xfs_inode_item_size idempotent
Date: Thu, 23 Aug 2012 15:02:12 +1000
Message-Id: <1345698180-13612-55-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 339a5f5dd9d3ac3d68a594d81507e1eab77ed223

Move all code messing with the inode log item flags into xfs_inode_item_format
to make sure xfs_inode_item_size really only calculates the the number of
vectors, but doesn't modify any state of the inode item.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_inode_item.c |  218 ++++++++++++++++++-----------------------------
 1 file changed, 83 insertions(+), 135 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6170176..d5ea2d8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -57,79 +57,28 @@ xfs_inode_item_size(
 	struct xfs_inode	*ip = iip->ili_inode;
 	uint			nvecs = 2;
 
-	/*
-	 * Only log the data/extents/b-tree root if there is something
-	 * left to log.
-	 */
-	iip->ili_format.ilf_fields |= XFS_ILOG_CORE;
-
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_DEXT) &&
-		    (ip->i_d.di_nextents > 0) &&
-		    (ip->i_df.if_bytes > 0)) {
-			ASSERT(ip->i_df.if_u1.if_extents != NULL);
+		    ip->i_d.di_nextents > 0 &&
+		    ip->i_df.if_bytes > 0)
 			nvecs++;
-		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DEXT;
-		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_df.if_ext_max ==
-		       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) &&
-		    (ip->i_df.if_broot_bytes > 0)) {
-			ASSERT(ip->i_df.if_broot != NULL);
+		    ip->i_df.if_broot_bytes > 0)
 			nvecs++;
-		} else {
-			ASSERT(!(iip->ili_format.ilf_fields &
-				 XFS_ILOG_DBROOT));
-#ifdef XFS_TRANS_DEBUG
-			if (iip->ili_root_size > 0) {
-				ASSERT(iip->ili_root_size ==
-				       ip->i_df.if_broot_bytes);
-				ASSERT(memcmp(iip->ili_orig_root,
-					    ip->i_df.if_broot,
-					    iip->ili_root_size) == 0);
-			} else {
-				ASSERT(ip->i_df.if_broot_bytes == 0);
-			}
-#endif
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DBROOT;
-		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_DDATA) &&
-		    (ip->i_df.if_bytes > 0)) {
-			ASSERT(ip->i_df.if_u1.if_data != NULL);
-			ASSERT(ip->i_d.di_size > 0);
+		    ip->i_df.if_bytes > 0)
 			nvecs++;
-		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_DDATA;
-		}
 		break;
 
 	case XFS_DINODE_FMT_DEV:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
-			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
-		break;
-
 	case XFS_DINODE_FMT_UUID:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
-			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
 		break;
 
 	default:
@@ -137,56 +86,31 @@ xfs_inode_item_size(
 		break;
 	}
 
-	/*
-	 * If there are no attributes associated with this file,
-	 * then there cannot be anything more to log.
-	 * Clear all attribute-related log flags.
-	 */
-	if (!XFS_IFORK_Q(ip)) {
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
+	if (!XFS_IFORK_Q(ip))
 		return nvecs;
-	}
+
 
 	/*
 	 * Log any necessary attribute data.
 	 */
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_AEXT) &&
-		    (ip->i_d.di_anextents > 0) &&
-		    (ip->i_afp->if_bytes > 0)) {
-			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
+		    ip->i_d.di_anextents > 0 &&
+		    ip->i_afp->if_bytes > 0)
 			nvecs++;
-		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_AEXT;
-		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) &&
-		    (ip->i_afp->if_broot_bytes > 0)) {
-			ASSERT(ip->i_afp->if_broot != NULL);
+		    ip->i_afp->if_broot_bytes > 0)
 			nvecs++;
-		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_ABROOT;
-		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		iip->ili_format.ilf_fields &=
-			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
 		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
-		    (ip->i_afp->if_bytes > 0)) {
-			ASSERT(ip->i_afp->if_u1.if_data != NULL);
+		    ip->i_afp->if_bytes > 0)
 			nvecs++;
-		} else {
-			iip->ili_format.ilf_fields &= ~XFS_ILOG_ADATA;
-		}
 		break;
 
 	default:
@@ -294,16 +218,17 @@ xfs_inode_item_format(
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_DEXT) {
-			ASSERT(ip->i_df.if_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEV | XFS_ILOG_UUID);
+
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_DEXT) &&
+		    ip->i_d.di_nextents > 0 &&
+		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
-			ASSERT(ip->i_d.di_nextents > 0);
+			ASSERT(ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) > 0);
 			ASSERT(iip->ili_extents_buf == NULL);
-			ASSERT((ip->i_df.if_bytes /
-				(uint)sizeof(xfs_bmbt_rec_t)) > 0);
+
 #ifdef XFS_NATIVE_HOST
                        if (ip->i_d.di_nextents == ip->i_df.if_bytes /
                                                (uint)sizeof(xfs_bmbt_rec_t)) {
@@ -325,15 +250,18 @@ xfs_inode_item_format(
 			iip->ili_format.ilf_dsize = vecp->i_len;
 			vecp++;
 			nvecs++;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_DEXT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_DDATA | XFS_ILOG_DEXT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) {
-			ASSERT(ip->i_df.if_broot_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
+			  XFS_ILOG_DEV | XFS_ILOG_UUID);
+
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) &&
+		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
 			vecp->i_addr = ip->i_df.if_broot;
 			vecp->i_len = ip->i_df.if_broot_bytes;
@@ -341,15 +269,30 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
+		} else {
+			ASSERT(!(iip->ili_format.ilf_fields &
+				 XFS_ILOG_DBROOT));
+#ifdef XFS_TRANS_DEBUG
+			if (iip->ili_root_size > 0) {
+				ASSERT(iip->ili_root_size ==
+				       ip->i_df.if_broot_bytes);
+				ASSERT(memcmp(iip->ili_orig_root,
+					    ip->i_df.if_broot,
+					    iip->ili_root_size) == 0);
+			} else {
+				ASSERT(ip->i_df.if_broot_bytes == 0);
+			}
+#endif
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_DBROOT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
-			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_DDATA) {
-			ASSERT(ip->i_df.if_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEV | XFS_ILOG_UUID);
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_DDATA) &&
+		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
 
@@ -367,13 +310,15 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_DDATA;
 		}
 		break;
 
 	case XFS_DINODE_FMT_DEV:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
-			  XFS_ILOG_DDATA | XFS_ILOG_UUID)));
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
 			iip->ili_format.ilf_u.ilfu_rdev =
 				ip->i_df.if_u2.if_rdev;
@@ -381,9 +326,9 @@ xfs_inode_item_format(
 		break;
 
 	case XFS_DINODE_FMT_UUID:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
-			  XFS_ILOG_DDATA | XFS_ILOG_DEV)));
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
 		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
 			iip->ili_format.ilf_u.ilfu_uuid =
 				ip->i_df.if_u2.if_uuid;
@@ -396,32 +341,26 @@ xfs_inode_item_format(
 	}
 
 	/*
-	 * If there are no attributes associated with the file,
-	 * then we're done.
-	 * Assert that no attribute-related log flags are set.
+	 * If there are no attributes associated with the file, then we're done.
 	 */
 	if (!XFS_IFORK_Q(ip)) {
-		ASSERT(nvecs == lip->li_desc->lid_size);
 		iip->ili_format.ilf_size = nvecs;
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
 		return;
 	}
 
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_AEXT) {
-#ifdef DEBUG
-			int nrecs = ip->i_afp->if_bytes /
-				(uint)sizeof(xfs_bmbt_rec_t);
-			ASSERT(nrecs > 0);
-			ASSERT(nrecs == ip->i_d.di_anextents);
-			ASSERT(ip->i_afp->if_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
+
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_AEXT) &&
+		    ip->i_d.di_anextents > 0 &&
+		    ip->i_afp->if_bytes > 0) {
+			ASSERT(ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) ==
+				ip->i_d.di_anextents);
 			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
-			ASSERT(ip->i_d.di_anextents > 0);
-#endif
 #ifdef XFS_NATIVE_HOST
 			/*
 			 * There are not delayed allocation extents
@@ -438,29 +377,36 @@ xfs_inode_item_format(
 			iip->ili_format.ilf_asize = vecp->i_len;
 			vecp++;
 			nvecs++;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_AEXT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_ADATA | XFS_ILOG_AEXT)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) {
-			ASSERT(ip->i_afp->if_broot_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
+
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) &&
+		    ip->i_afp->if_broot_bytes > 0) {
 			ASSERT(ip->i_afp->if_broot != NULL);
+
 			vecp->i_addr = ip->i_afp->if_broot;
 			vecp->i_len = ip->i_afp->if_broot_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_ABROOT;
 		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
-		ASSERT(!(iip->ili_format.ilf_fields &
-			 (XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
-		if (iip->ili_format.ilf_fields & XFS_ILOG_ADATA) {
-			ASSERT(ip->i_afp->if_bytes > 0);
+		iip->ili_format.ilf_fields &=
+			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
+
+		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
+		    ip->i_afp->if_bytes > 0) {
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 
 			vecp->i_addr = ip->i_afp->if_u1.if_data;
@@ -477,6 +423,8 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_ADATA;
 		}
 		break;
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
