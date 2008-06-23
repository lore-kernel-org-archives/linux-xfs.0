Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 21:42:31 -0700 (PDT)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N4gJEE017140
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 21:42:20 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Move attr log alloc size calculator to another function.
Date: Mon, 23 Jun 2008 14:42:27 +1000
Message-Id: <1214196150-5427-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@debian.org>, Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@debian.org>

We will need that to be able to calculate the size of log we need for
a specific attr (for parent pointers in create). We need the local so
that we can fail if we run into ENOSPC when trying to alloc blocks

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |   78 +++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_attr.h |    2 +-
 2 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index e58f321..0d19e90 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -185,6 +185,43 @@ xfs_attr_get(
 }
 
 int
+xfs_attr_calc_size(
+	xfs_inode_t	*ip,
+	int		namelen,
+	int		valuelen,
+	int		*local)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	int		size;
+	int		nblks;
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
+			nblks <<= 1;
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
+int
 xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		 char *value, int valuelen, int flags)
 {
@@ -192,10 +229,9 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
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
@@ -232,30 +268,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	args.addname = 1;
 	args.oknoent = 1;
 
-	/*
-	 * Determine space new attribute will use, and if it would be
-	 * "local" or "remote" (note: local != inline).
-	 */
-	size = xfs_attr_leaf_newentsize(namelen, valuelen,
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
+	args.total = xfs_attr_calc_size(dp, namelen, valuelen, &local);
 
 	/*
 	 * Start our first transaction of the day.
@@ -277,18 +291,18 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans, (uint) nblks,
-				      XFS_ATTRSET_LOG_RES(mp, nblks),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRSET_LOG_COUNT))) {
+	if ((error = xfs_trans_reserve(args.trans, (uint) args.total,
+				       XFS_ATTRSET_LOG_RES(mp, args.total),
+				       0, XFS_TRANS_PERM_LOG_RES,
+				       XFS_ATTRSET_LOG_COUNT))) {
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
index 786eba3..b0b5405 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -158,11 +158,11 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
+int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
 int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
-
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
 int xfs_attr_fetch(struct xfs_inode *, const char *, int,
 			char *, int *, int, struct cred *);
-- 
1.5.5.4
