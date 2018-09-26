Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZQiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANd2b036956
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:44 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtur9b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:44 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPisI027014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:44 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPhcH018303
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:43 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 03/30] xfsprogs: Add attibute set and helper functions
Date: Wed, 26 Sep 2018 03:23:06 -0700
Message-Id: <1537957413-10630-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
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
 libxfs/xfs_attr.c | 152 ++++++++++++++++++++++++++++++++----------------------
 libxfs/xfs_attr.h |   1 +
 libxfs/xfs_bmap.c |  49 +++++++++++-------
 libxfs/xfs_bmap.h |   1 +
 4 files changed, 122 insertions(+), 81 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cc5bde2..f863fab 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -222,6 +222,94 @@ xfs_attr_try_sf_addname(
 	return error;
 }
 
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args,
+	struct xfs_buf          **leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error;
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
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC)
+			goto out;
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		if (error)
+			goto out;
+
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+		xfs_trans_bhold(args->trans, *leaf_bp);
+
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			goto out;
+
+		/*
+		 * Commit the leaf transformation.  We'll need another
+		 * (linked) transaction to add the new attribute to the
+		 * leaf.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			goto out;
+		xfs_trans_bjoin(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_leaf_addname(args);
+	else
+		error = xfs_attr_node_addname(args);
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
@@ -235,7 +323,7 @@ xfs_attr_set(
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, local;
+	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -293,67 +381,7 @@ xfs_attr_set(
 	}
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-
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
-		error = xfs_attr_try_sf_addname(dp, &args);
-		if (error != -ENOSPC) {
-			err2 = xfs_trans_commit(args.trans);
-			error = error ? error : err2;
-
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-			return error;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
-		if (error)
-			goto out;
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args.trans, leaf_bp);
-		error = xfs_defer_finish(&args.trans);
-		if (error)
-			goto out;
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
-		error = xfs_attr_leaf_addname(&args);
-	else
-		error = xfs_attr_node_addname(&args);
+	error = xfs_attr_set_args(&args, &leaf_bp);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 525935c..a57630f 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -137,6 +137,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8902ab8..45ba56f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1008,6 +1008,34 @@ xfs_bmap_add_attrfork_local(
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
@@ -1059,26 +1087,9 @@ xfs_bmap_add_attrfork(
 
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
index b6e9b63..488dc88 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -183,6 +183,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
-- 
2.7.4
