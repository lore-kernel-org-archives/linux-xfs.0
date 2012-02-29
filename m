Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T9tAKH002205 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 03:55:11 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XhgG4GA2qHN6iGt8 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 01:55:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S2gFZ-0006Bg-7N
	for xfs@oss.sgi.com; Wed, 29 Feb 2012 09:55:09 +0000
Message-Id: <20120229095509.185485494@bombadil.infradead.org>
Date: Wed, 29 Feb 2012 04:53:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/8] xfs: make xfs_inode_item_size idempotent
References: <20120229095347.009884687@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-idempotent-inode_item_size
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

Move all code messing with the inode log item flags into xfs_inode_item_format
to make sure xfs_inode_item_size really only calculates the the number of
vectors, but doesn't modify any state of the inode item.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode_item.c |  215 ++++++++++++++++++------------------------------
 1 file changed, 83 insertions(+), 132 deletions(-)

Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-02-28 12:01:00.067921209 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2012-02-28 12:02:00.899919585 +0100
@@ -57,77 +57,28 @@ xfs_inode_item_size(
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
@@ -135,56 +86,31 @@ xfs_inode_item_size(
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
@@ -292,16 +218,17 @@ xfs_inode_item_format(
 
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
@@ -323,15 +250,18 @@ xfs_inode_item_format(
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
@@ -339,15 +269,30 @@ xfs_inode_item_format(
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
 
@@ -365,13 +310,15 @@ xfs_inode_item_format(
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
@@ -379,9 +326,9 @@ xfs_inode_item_format(
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
@@ -394,31 +341,26 @@ xfs_inode_item_format(
 	}
 
 	/*
-	 * If there are no attributes associated with the file,
-	 * then we're done.
-	 * Assert that no attribute-related log flags are set.
+	 * If there are no attributes associated with the file, then we're done.
 	 */
 	if (!XFS_IFORK_Q(ip)) {
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
@@ -435,29 +377,36 @@ xfs_inode_item_format(
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
@@ -474,6 +423,8 @@ xfs_inode_item_format(
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
+		} else {
+			iip->ili_format.ilf_fields &= ~XFS_ILOG_ADATA;
 		}
 		break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
