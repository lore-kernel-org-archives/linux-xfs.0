Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFA167F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB84A8F8068
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 30Ij0WDEuZQTHKO6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcH-0000FD-Bm
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:01 +0000
Message-Id: <20131129084001.243588401@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/10] xfs: format logged extents directly into the CIL
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0007-xfs-format-logged-extents-directly-into-the-CIL.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

With the new iop_format scheme there is no need to have a temporary buffer
to format logged extents into, we can do so directly into the CIL.  This
also allows to remove the shortcut for big endian systems that probably
hasn't gotten a lot of test coverage for a long time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_fork.c |   15 ++++---
 fs/xfs/xfs_inode_item.c |  113 ++++++++---------------------------------------
 fs/xfs/xfs_inode_item.h |    4 --
 3 files changed, 26 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index cfee14a..06abaee 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -721,15 +721,16 @@ xfs_idestroy_fork(
 }
 
 /*
- * xfs_iextents_copy()
+ * Convert in-core extents to on-disk form
  *
- * This is called to copy the REAL extents (as opposed to the delayed
- * allocation extents) from the inode into the given buffer.  It
- * returns the number of bytes copied into the buffer.
+ * For either the data or attr fork in extent format, we need to endian convert
+ * the in-core extent as we place them into the on-disk inode.
  *
- * If there are no delayed allocation extents, then we can just
- * memcpy() the extents into the buffer.  Otherwise, we need to
- * examine each extent in turn and skip those which are delayed.
+ * In the case of the data fork, the in-core and on-disk fork sizes can be
+ * different due to delayed allocation extents. We only copy on-disk extents
+ * here, so callers must always use the physical fork size to determine the
+ * size of the buffer passed to this routine.  We will return the size actually
+ * used.
  */
 int
 xfs_iextents_copy(
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 35dd24a..f103dfd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -146,43 +146,6 @@ xfs_inode_item_size(
 }
 
 /*
- * xfs_inode_item_format_extents - convert in-core extents to on-disk form
- *
- * For either the data or attr fork in extent format, we need to endian convert
- * the in-core extent as we place them into the on-disk inode. In this case, we
- * need to do this conversion before we write the extents into the log. Because
- * we don't have the disk inode to write into here, we allocate a buffer and
- * format the extents into it via xfs_iextents_copy(). We free the buffer in
- * the unlock routine after the copy for the log has been made.
- *
- * In the case of the data fork, the in-core and on-disk fork sizes can be
- * different due to delayed allocation extents. We only log on-disk extents
- * here, so always use the physical fork size to determine the size of the
- * buffer we need to allocate.
- */
-STATIC int
-xfs_inode_item_format_extents(
-	struct xfs_inode	*ip,
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp,
-	int			whichfork,
-	int			type)
-{
-	xfs_bmbt_rec_t		*ext_buffer;
-	int			len;
-
-	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork), KM_SLEEP);
-	if (whichfork == XFS_DATA_FORK)
-		ip->i_itemp->ili_extents_buf = ext_buffer;
-	else
-		ip->i_itemp->ili_aextents_buf = ext_buffer;
-
-	len = xfs_iextents_copy(ip, ext_buffer, whichfork);
-	xlog_copy_iovec(lv, vecp, type, ext_buffer, len);
-	return len;
-}
-
-/*
  * If this is a v1 format inode, then we need to log it as such.  This means
  * that we have to copy the link count from the new field to the old.  We
  * don't have to worry about the new fields, because nothing trusts them as
@@ -229,30 +192,18 @@ xfs_inode_item_format_data_fork(
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_d.di_nextents > 0 &&
 		    ip->i_df.if_bytes > 0) {
+			struct xfs_bmbt_rec *p;
+
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
 			ASSERT(ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) > 0);
-			ASSERT(iip->ili_extents_buf == NULL);
-
-#ifdef XFS_NATIVE_HOST
-                       if (ip->i_d.di_nextents == ip->i_df.if_bytes /
-                                               (uint)sizeof(xfs_bmbt_rec_t)) {
-				/*
-				 * There are no delayed allocation
-				 * extents, so just point to the
-				 * real extents array.
-				 */
-				xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IEXT,
-						ip->i_df.if_u1.if_extents,
-						ip->i_df.if_bytes);
-				ilf->ilf_dsize = ip->i_df.if_bytes;
-			} else
-#endif
-			{
-				ilf->ilf_dsize =
-					xfs_inode_item_format_extents(ip, lv, vecp,
-						XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
-				ASSERT(iip->ili_format.ilf_dsize <= ip->i_df.if_bytes);
-			}
+
+			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IEXT);
+			data_bytes = xfs_iextents_copy(ip, p, XFS_DATA_FORK);
+			xlog_finish_iovec(lv, *vecp, data_bytes);
+
+			ASSERT(data_bytes <= ip->i_df.if_bytes);
+
+			ilf->ilf_dsize = data_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DEXT;
@@ -339,24 +290,17 @@ xfs_inode_item_format_attr_fork(
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
 		    ip->i_afp->if_bytes > 0) {
+			struct xfs_bmbt_rec *p;
+
 			ASSERT(ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) ==
 				ip->i_d.di_anextents);
 			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
-#ifdef XFS_NATIVE_HOST
-			/*
-			 * There are not delayed allocation extents
-			 * for attributes, so just point at the array.
-			 */
-			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT,
-					ip->i_afp->if_u1.if_extents,
-					ip->i_afp->if_bytes);
-			ilf->ilf_asize = ip->i_afp->if_bytes;
-#else
-			ASSERT(iip->ili_aextents_buf == NULL);
-			ilf->ilf_asize =
-				xfs_inode_item_format_extents(ip, lv, vecp,
-					XFS_ATTR_FORK, XLOG_REG_TYPE_IATTR_EXT);
-#endif
+
+			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
+			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
+			xlog_finish_iovec(lv, *vecp, data_bytes);
+
+			ilf->ilf_asize = data_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_AEXT;
@@ -571,27 +515,6 @@ xfs_inode_item_unlock(
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	/*
-	 * If the inode needed a separate buffer with which to log
-	 * its extents, then free it now.
-	 */
-	if (iip->ili_extents_buf != NULL) {
-		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(ip->i_d.di_nextents > 0);
-		ASSERT(iip->ili_fields & XFS_ILOG_DEXT);
-		ASSERT(ip->i_df.if_bytes > 0);
-		kmem_free(iip->ili_extents_buf);
-		iip->ili_extents_buf = NULL;
-	}
-	if (iip->ili_aextents_buf != NULL) {
-		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(ip->i_d.di_anextents > 0);
-		ASSERT(iip->ili_fields & XFS_ILOG_AEXT);
-		ASSERT(ip->i_afp->if_bytes > 0);
-		kmem_free(iip->ili_aextents_buf);
-		iip->ili_aextents_buf = NULL;
-	}
-
 	lock_flags = iip->ili_lock_flags;
 	iip->ili_lock_flags = 0;
 	if (lock_flags)
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index dce4d65..29b5f2b 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -34,10 +34,6 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
-						      data exts */
-	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
-						      attr exts */
 	xfs_inode_log_format_t	ili_format;	   /* logged structure */
 } xfs_inode_log_item_t;
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
