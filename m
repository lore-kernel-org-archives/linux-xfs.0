Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 00:38:23 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A7cKxq017250
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:38:21 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Move attr log alloc size calculator to another function.
Date: Thu, 10 Jul 2008 17:39:02 +1000
Message-Id: <1215675545-2707-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1215675545-2707-1-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
 <1215675545-2707-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

We will need that to be able to calculate the size of log we need for
a specific attr (for Create+EA). The local flag is needed so that we
can fail if we run into ENOSPC when trying to alloc blocks.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |   80 +++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_attr.h |    1 +
 2 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index df151a8..4036bdc 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -196,6 +196,46 @@ xfs_attr_get(
 	return(error);
 }
 
+/*
+ * Calculate how many blocks we need for the new attribute,
+ */
+int
+xfs_attr_calc_size(
+	struct xfs_inode 	*ip,
+	int			namelen,
+	int			valuelen,
+	int			*local)
+{
+	struct xfs_mount 	*mp = ip->i_mount;
+	int			size;
+	int			nblks;
+
+	/*
+	 * Determine space new attribute will use, and if it would be
+	 * "local" or "remote" (note: local != inline).
+	 */
+	size = xfs_attr_leaf_newentsize(namelen, valuelen,
+					mp->m_sb.sb_blocksize, local);
+
+	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	if (*local) {
+		if (size > (mp->m_sb.sb_blocksize >> 1)) {
+			/* Double split possible */
+			nblks *= 2;
+		}
+	} else {
+		/*
+		 * Out of line attribute, cannot double split, but
+		 * make room for the attribute value itself.
+		 */
+		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
+		nblks += dblocks;
+		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
+	}
+
+	return nblks;
+}
+
 STATIC int
 xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 		char *value, int valuelen, int flags)
@@ -204,10 +244,9 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	xfs_fsblock_t	firstblock;
 	xfs_bmap_free_t flist;
 	int		error, err2, committed;
-	int		local, size;
-	uint		nblks;
 	xfs_mount_t	*mp = dp->i_mount;
 	int             rsvd = (flags & ATTR_ROOT) != 0;
+	int		local;
 
 	/*
 	 * Attach the dquots to the inode.
@@ -244,30 +283,8 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	args.addname = 1;
 	args.oknoent = 1;
 
-	/*
-	 * Determine space new attribute will use, and if it would be
-	 * "local" or "remote" (note: local != inline).
-	 */
-	size = xfs_attr_leaf_newentsize(name->len, valuelen,
-					mp->m_sb.sb_blocksize, &local);
-
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	if (local) {
-		if (size > (mp->m_sb.sb_blocksize >> 1)) {
-			/* Double split possible */
-			nblks <<= 1;
-		}
-	} else {
-		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
-		/* Out of line attribute, cannot double split, but make
-		 * room for the attribute value itself.
-		 */
-		nblks += dblocks;
-		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
-	}
-
 	/* Size is now blocks for attribute data */
-	args.total = nblks;
+	args.total = xfs_attr_calc_size(dp, name->len, valuelen, &local);
 
 	/*
 	 * Start our first transaction of the day.
@@ -289,18 +306,17 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans, (uint) nblks,
-				      XFS_ATTRSET_LOG_RES(mp, nblks),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRSET_LOG_COUNT))) {
+	if ((error = xfs_trans_reserve(args.trans, args.total,
+			XFS_ATTRSET_LOG_RES(mp, args.total), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, nblks, 0,
-			 rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-				XFS_QMOPT_RES_REGBLKS);
+	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, args.total, 0,
+				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
+				       XFS_QMOPT_RES_REGBLKS);
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 6cfc938..f99395c 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -158,6 +158,7 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
+int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
-- 
1.5.6.2
