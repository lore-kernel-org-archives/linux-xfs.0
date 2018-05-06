Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeEFR1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 May 2018 13:27:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w46HR5mc165273
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:05 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2hs5931xn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 May 2018 17:27:05 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w46HR5Mi014714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:05 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w46HR4Wj024376
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:04 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 03/21] xfs: Add attibute set and helper functions
Date: Sun,  6 May 2018 10:24:36 -0700
Message-Id: <1525627494-12873-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c | 217 ++++++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr.h |   2 +
 fs/xfs/libxfs/xfs_bmap.c |  49 ++++++-----
 fs/xfs/libxfs/xfs_bmap.h |   1 +
 4 files changed, 165 insertions(+), 104 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0ade22b..99c4a31 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -168,6 +168,134 @@ xfs_attr_get(
 }
 
 /*
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
+	struct xfs_mount        *mp = dp->i_mount;
+	int			error = 0;
+	int			err2 = 0;
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
+	xfs_trans_ijoin(args->trans, dp, 0);
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
+		error = xfs_attr_shortform_addname(args, roll_trans);
+		if (error != -ENOSPC) {
+			if (roll_trans) {
+				/*
+				 * Commit the shortform mods, and we're done.
+				 * NOTE: this is also the error path (EEXIST, etc).
+				 */
+				ASSERT(args->trans != NULL);
+
+				/*
+				 * If this is a synchronous mount, make sure that
+				 * the transaction goes to disk before returning
+				 * to the user.
+				 */
+				if (mp->m_flags & XFS_MOUNT_WSYNC)
+					xfs_trans_set_sync(args->trans);
+
+				if (!error && (flags & ATTR_KERNOTIME) == 0)
+					xfs_trans_ichgtime(args->trans, dp,
+							   XFS_ICHGTIME_CHG);
+
+				err2 = xfs_trans_commit(args->trans);
+				error = error ? error : err2;
+			}
+			goto out;
+		}
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
+/*
  * Calculate how many blocks we need for the new attribute,
  */
 STATIC int
@@ -218,7 +346,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, local;
+	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -279,88 +407,11 @@ xfs_attr_set(
 
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
-		error = xfs_attr_shortform_addname(&args, true);
-		if (error != -ENOSPC) {
-			/*
-			 * Commit the shortform mods, and we're done.
-			 * NOTE: this is also the error path (EEXIST, etc).
-			 */
-			ASSERT(args.trans != NULL);
-
-			/*
-			 * If this is a synchronous mount, make sure that
-			 * the transaction goes to disk before returning
-			 * to the user.
-			 */
-			if (mp->m_flags & XFS_MOUNT_WSYNC)
-				xfs_trans_set_sync(args.trans);
-
-			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_trans_ichgtime(args.trans, dp,
-							XFS_ICHGTIME_CHG);
-			}
-			err2 = xfs_trans_commit(args.trans);
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-			return error ? error : err2;
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
+	xfs_defer_init(args.dfops, args.firstblock);
+	error = xfs_attr_set_args(&args, flags, leaf_bp, true);
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(&args, true);
-	else
-		error = xfs_attr_node_addname(&args, true);
 	if (error)
-		goto out;
+		goto out_defer_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -369,9 +420,6 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
-
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
@@ -383,7 +431,6 @@ xfs_attr_set(
 
 out_defer_cancel:
 	xfs_defer_cancel(&dfops);
-out:
 	if (leaf_bp)
 		xfs_trans_brelse(args.trans, leaf_bp);
 	if (args.trans)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d07bf27..b5dc02c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -152,6 +152,8 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_set_args(struct xfs_da_args *args, int flags,
+			struct xfs_buf *leaf_bp, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f0..4e16a5d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1031,6 +1031,34 @@ xfs_bmap_add_attrfork_local(
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
@@ -1084,26 +1112,9 @@ xfs_bmap_add_attrfork(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2b766b3..50e9115 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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

