Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 21:42:31 -0700 (PDT)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N4gJQL017143
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 21:42:20 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Give a transaction to xfs_attr_set_int
Date: Mon, 23 Jun 2008 14:42:30 +1000
Message-Id: <1214196150-5427-5-git-send-email-xaiki@sgi.com>
In-Reply-To: <1214196150-5427-4-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
 <1214196150-5427-2-git-send-email-xaiki@sgi.com>
 <1214196150-5427-3-git-send-email-xaiki@sgi.com>
 <1214196150-5427-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@debian.org>, Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@debian.org>

We introduce xfs_trans_attr_set_int that takes a transaction pointer
as an argument (or creates one if NULL) and only finishes the
transaction if it has created it. We use xfs_attr_rolltrans to do the
tranS_dup dance.

xfs_attr_set_int is changed to a wrapper that will only call
xfs_trans_attr_set_int with a NULL transaction.

make it use the new xfs_trans_bmap_add_attrfork();

This is needed for Create+EA/Parent Pointers

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |  140 +++++++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_attr.h |    2 +
 2 files changed, 96 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index be6bfc4..a4787f7 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -209,7 +209,7 @@ xfs_attr_calc_size(
 			nblks <<= 1;
 		}
 	} else {
-		/* 
+		/*
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
@@ -221,9 +221,20 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/*
+ * So if the trans is given we don't have the right to dispose of it,
+ * we can't commit it either as we don't know if the upper class is
+ * done with it.
+ */
 int
-xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
-		 char *value, int valuelen, int flags)
+xfs_trans_attr_set_int(
+	xfs_trans_t	**tpp,
+	xfs_inode_t	*dp,
+	const char	*name,
+	int		namelen,
+	char		*value,
+	int		valuelen,
+	int		flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -247,8 +258,9 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
 			      XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
 
-		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
-			return(error);
+		error = xfs_trans_bmap_add_attrfork(tpp, dp, sf_size, rsvd);
+		if (error)
+			return error;
 	}
 
 	/*
@@ -271,46 +283,53 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	/* Size is now blocks for attribute data */
 	args.total = xfs_attr_calc_size(dp, namelen, valuelen, &local);
 
-	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_SET);
+	if (tpp) {
+		ASSERT(*tpp);
+		args.trans = *tpp;
+	} else {
+		/*
+		 * Start our first transaction of the day.
+		 *
+		 * All future transactions during this code must be "chained" off
+		 * this one via the trans_dup() call.  All transactions will contain
+		 * the inode, and the inode will always be marked with trans_ihold().
+		 * Since the inode will be locked in all transactions, we must log
+		 * the inode in every transaction to let it float upward through
+		 * the log.
+		 */
+		args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_SET);
 
-	/*
-	 * Root fork attributes can use reserved data blocks for this
-	 * operation if necessary
-	 */
+		/*
+		 * Root fork attributes can use reserved data blocks for this
+		 * operation if necessary
+		 */
 
-	if (rsvd)
-		args.trans->t_flags |= XFS_TRANS_RESERVE;
+		if (rsvd)
+			args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans, (uint) args.total,
-				       XFS_ATTRSET_LOG_RES(mp, args.total),
-				       0, XFS_TRANS_PERM_LOG_RES,
-				       XFS_ATTRSET_LOG_COUNT))) {
-		xfs_trans_cancel(args.trans, 0);
-		return(error);
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve(args.trans, args.total,
+					  XFS_ATTRSET_LOG_RES(mp, args.total),
+					  0, XFS_TRANS_PERM_LOG_RES,
+					  XFS_ATTRSET_LOG_COUNT);
+		if (error) {
+			xfs_trans_cancel(args.trans, 0);
+			return(error);
+		}
+		xfs_ilock(dp, XFS_ILOCK_EXCL);
 
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, args.total, 0,
-				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
+		error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp,
+					args.total, 0,
+				rsvd?XFS_QMOPT_RES_REGBLKS|XFS_QMOPT_FORCE_RES:
 				       XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
-		return (error);
-	}
+		if (error) {
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+			return (error);
+		}
 
-	xfs_trans_ijoin(args.trans, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(args.trans, dp);
+		xfs_trans_ijoin(args.trans, dp, XFS_ILOCK_EXCL);
+		xfs_trans_ihold(args.trans, dp);
+	}
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -346,8 +365,14 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 			if (mp->m_flags & XFS_MOUNT_WSYNC) {
 				xfs_trans_set_sync(args.trans);
 			}
-			err2 = xfs_trans_commit(args.trans,
-						 XFS_TRANS_RELEASE_LOG_RES);
+
+			/* Only finish trans if it's ours */
+			if (tpp) {
+				err2 = xfs_trans_roll(&args.trans, dp);
+			} else {
+				err2 = xfs_trans_commit(args.trans,
+							XFS_TRANS_RELEASE_LOG_RES);
+			}
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 			/*
@@ -356,6 +381,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 			if (!error && (flags & ATTR_KERNOTIME) == 0) {
 				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 			}
+			if (tpp)
+				tpp = &args.trans;
 			return(error == 0 ? err2 : error);
 		}
 
@@ -401,13 +428,13 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	} else {
 		error = xfs_attr_node_addname(&args);
 	}
-	if (error) {
+	if (error)
 		goto out;
-	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
+	 * transaction goes to disk before returning to the user. If
+	 * this is not our transaction, the allocator should do this.
 	 */
 	if (mp->m_flags & XFS_MOUNT_WSYNC) {
 		xfs_trans_set_sync(args.trans);
@@ -416,8 +443,12 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	if (tpp) {
+		xfs_trans_roll(&args.trans, dp);
+	} else {
+		xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
+		error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	}
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 	/*
@@ -427,6 +458,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 
+	if (tpp)
+		tpp = &args.trans;
 	return(error);
 
 out:
@@ -434,10 +467,25 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (tpp)
+		tpp = &args.trans;
 	return(error);
 }
 
 int
+xfs_attr_set_int(
+	xfs_inode_t	*dp,
+	const char	*name,
+	int		namelen,
+	char		*value,
+	int		valuelen,
+	int		flags)
+{
+	return xfs_trans_attr_set_int(NULL, dp, name, namelen,
+				      value, valuelen, flags);
+}
+
+int
 xfs_attr_set(
 	xfs_inode_t	*dp,
 	const char	*name,
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index b0b5405..c076c85 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -160,6 +160,8 @@ struct xfs_da_args;
  */
 int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
+ int xfs_trans_attr_set_int(struct xfs_trans **, struct xfs_inode *, const char *,
+			    int, char *, int, int);
 int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
-- 
1.5.5.4
