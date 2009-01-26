Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XFVV203848 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50AE2B75A7
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rrdrsjGW5Ay7gwIU for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLww-00034N-HL
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:02 +0000
Message-Id: <20090126073202.440548000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/17] xfs: factor out attr fork reset handling
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-attr-delete-code
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

We currently duplicate code to reset the attribute fork after the last
attribute has been deleted.  Factor this out into a small helper.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2008-12-27 18:07:05.485688220 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2008-12-27 18:20:09.770563952 +0100
@@ -298,6 +298,26 @@ xfs_attr_shortform_add(xfs_da_args_t *ar
 }
 
 /*
+ * After the last attribute is removed revert to original inode format,
+ * making all literal area available to the data fork once more.
+ */
+STATIC void
+xfs_attr_fork_reset(
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp)
+{
+	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	ip->i_d.di_forkoff = 0;
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+
+	ASSERT(ip->i_d.di_anextents == 0);
+	ASSERT(ip->i_afp == NULL);
+
+	ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/*
  * Remove an attribute from the shortform attribute list structure.
  */
 int
@@ -344,22 +364,10 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 	 */
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
-				!(args->op_flags & XFS_DA_OP_ADDNAME) &&
-				(mp->m_flags & XFS_MOUNT_ATTR2) &&
-				(dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
-		/*
-		 * Last attribute now removed, revert to original
-		 * inode format making all literal area available
-		 * to the data fork once more.
-		 */
-		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = 0;
-		dp->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-		ASSERT(dp->i_d.di_anextents == 0);
-		ASSERT(dp->i_afp == NULL);
-		dp->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
+	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
+		xfs_attr_fork_reset(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
@@ -786,20 +794,7 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *
 	if (forkoff == -1) {
 		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
 		ASSERT(dp->i_d.di_format != XFS_DINODE_FMT_BTREE);
-
-		/*
-		 * Last attribute was removed, revert to original
-		 * inode format making all literal area available
-		 * to the data fork once more.
-		 */
-		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = 0;
-		dp->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-		ASSERT(dp->i_d.di_anextents == 0);
-		ASSERT(dp->i_afp == NULL);
-		dp->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+		xfs_attr_fork_reset(dp, args->trans);
 		goto out;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
