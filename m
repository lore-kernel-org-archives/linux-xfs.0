Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753675AbeFJFKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A58CkG072293
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:08 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2jg6b19w81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:08 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5A7da004282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:07 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5A6jo013897
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:07 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 04/27] xfsprogs: Add attibute set and helper functions
Date: Sat,  9 Jun 2018 22:07:29 -0700
Message-Id: <1528607272-11122-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds xfs_attr_set_args and xfs_bmap_set_attrforkoff.
These sub-routines set the attributes specified in @args.
We will use this later for setting parent pointers as a deferred
attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 169 +++++++++++++++++++++++++++++++++---------------------
 libxfs/xfs_attr.h |   2 +
 libxfs/xfs_bmap.c |  49 ++++++++++------
 libxfs/xfs_bmap.h |   1 +
 4 files changed, 137 insertions(+), 84 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7ef35f3..02b73ad 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -237,6 +237,108 @@ xfs_attr_try_sf_addname(
 	return error;
 }
 
+/*
+ * Set the attribute specified in @args. In the case of the parent attribute
+ * being set, we do not want to roll the transaction on shortform-to-leaf
+ * conversion, as the attribute must be added in the same transaction as the
+ * parent directory modifications. Hence @roll_trans needs to be set
+ * appropriately to control whether the transaction is committed during this
+ * function.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args,
+	int			flags,
+	struct xfs_buf          *leaf_bp,
+	bool			roll_trans)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error = 0;
+	int			sf_size;
+
+	/*
+	 * New inodes setting the parent pointer attr will
+	 * not have an attribute fork yet. So set the attribute
+	 * fork appropriately
+	 */
+	if (XFS_IFORK_Q((args->dp)) == 0) {
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+	}
+
+	/*
+	 * If the attribute list is non-existent or a shortform list,
+	 * upgrade it to a single-leaf-block attribute list.
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_d.di_anextents == 0)) {
+
+		/*
+		 * Build initial attribute list (if required).
+		 */
+		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+			xfs_attr_shortform_create(args);
+
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args, flags, roll_trans);
+		if (error != -ENOSPC)
+			goto out;
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			goto out;
+
+		xfs_defer_bjoin(args->dfops, leaf_bp);
+		xfs_defer_ijoin(args->dfops, dp);
+		if (roll_trans) {
+			/*
+			 * Prevent the leaf buffer from being unlocked so that a
+			 * concurrent AIL push cannot grab the half-baked leaf
+			 * buffer and run into problems with the write verifier.
+			 */
+			xfs_trans_bhold(args->trans, leaf_bp);
+
+			error = xfs_defer_finish(&args->trans, args->dfops);
+			if (error) {
+				args->trans = NULL;
+				goto out;
+			}
+
+			/*
+			 * Commit the leaf transformation.  We'll need another
+			 * (linked) transaction to add the new attribute to the
+			 * leaf.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				goto out;
+			xfs_defer_ijoin(args->dfops, dp);
+			xfs_trans_bjoin(args->trans, leaf_bp);
+				leaf_bp = NULL;
+		}
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_leaf_addname(args, roll_trans);
+	else
+		error = xfs_attr_node_addname(args, roll_trans);
+	if (error)
+		goto out;
+
+out:
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -313,68 +415,9 @@ xfs_attr_set(
 
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
-	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
-
-		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(&args);
-
-		/*
-		 * Try to add the attr to the attribute list in
-		 * the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, &args, flags, true);
-		if (error != -ENOSPC) {
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-			return error;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		xfs_defer_init(args.dfops, args.firstblock);
-		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
-		if (error)
-			goto out_defer_cancel;
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args.trans, leaf_bp);
-		xfs_defer_bjoin(args.dfops, leaf_bp);
-		xfs_defer_ijoin(args.dfops, dp);
-		error = xfs_defer_finish(&args.trans, args.dfops);
-		if (error)
-			goto out_defer_cancel;
-
-		/*
-		 * Commit the leaf transformation.  We'll need another (linked)
-		 * transaction to add the new attribute to the leaf, which
-		 * means that we have to hold & join the leaf buffer here too.
-		 */
-		error = xfs_trans_roll_inode(&args.trans, dp);
-		if (error)
-			goto out;
-		xfs_trans_bjoin(args.trans, leaf_bp);
-		leaf_bp = NULL;
-	}
-
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(&args, true);
-	else
-		error = xfs_attr_node_addname(&args, true);
+	error = xfs_attr_set_args(&args, flags, leaf_bp, true);
 	if (error)
-		goto out;
+		goto out_defer_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -383,9 +426,6 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
-
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
@@ -397,7 +437,6 @@ xfs_attr_set(
 
 out_defer_cancel:
 	xfs_defer_cancel(&dfops);
-out:
 	if (leaf_bp)
 		xfs_trans_brelse(args.trans, leaf_bp);
 	if (args.trans)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8abf398..adb1619 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -149,6 +149,8 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_set_args(struct xfs_da_args *args, int flags,
+			struct xfs_buf *leaf_bp, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index afc569c..79fcaf0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1022,6 +1022,34 @@ xfs_bmap_add_attrfork_local(
 	return -EFSCORRUPTED;
 }
 
+/* Set an inode attr fork off based on the format */
+int
+xfs_bmap_set_attrforkoff(
+	struct xfs_inode	*ip,
+	int			size,
+	int			*version)
+{
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_DEV:
+		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_d.di_forkoff)
+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
+			*version = 2;
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Convert inode from non-attributed to attributed.
  * Must not be in a transaction, ip must not be locked.
@@ -1075,26 +1103,9 @@ xfs_bmap_add_attrfork(
 
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	switch (ip->i_d.di_format) {
-	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
-		break;
-	case XFS_DINODE_FMT_LOCAL:
-	case XFS_DINODE_FMT_EXTENTS:
-	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
-		else if (mp->m_flags & XFS_MOUNT_ATTR2)
-			version = 2;
-		break;
-	default:
-		ASSERT(0);
-		error = -EINVAL;
+	error = xfs_bmap_set_attrforkoff(ip, size, &version);
+	if (error)
 		goto trans_cancel;
-	}
-
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index e36d757..f7e51e6 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -191,6 +191,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 			  xfs_fsblock_t bno, xfs_filblks_t len,
-- 
2.7.4

