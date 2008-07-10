Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 00:38:44 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A7cdkg017594
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:38:39 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Give a transaction to xfs_attr_set_int
Date: Thu, 10 Jul 2008 17:39:05 +1000
Message-Id: <1215675545-2707-5-git-send-email-xaiki@sgi.com>
In-Reply-To: <1215675545-2707-4-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
 <1215675545-2707-1-git-send-email-xaiki@sgi.com>
 <1215675545-2707-2-git-send-email-xaiki@sgi.com>
 <1215675545-2707-3-git-send-email-xaiki@sgi.com>
 <1215675545-2707-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

We introduce xfs_attr_set_int_trans that takes a transaction pointer
as an argument (or creates one if NULL) and only finishes the
transaction if it has created it. We use xfs_trans_roll to do the
trans_dup dance.

xfs_attr_set_int is changed to a wrapper that will only call
xfs_attr_set_int_trans with a NULL transaction.

make it use the new xfs_bmap_add_attrfork_trans(), and roll the
transaction after the call.

This is needed for Create+EA/Parent Pointers

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |  139 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 94 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 4888a35..8e9598d 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -236,9 +236,19 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/*
+ * So if the trans is given we don't have the right to dispose of it,
+ * we can't commit it either as we don't know if the caller is
+ * done with it.
+ */
 STATIC int
-xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
-		char *value, int valuelen, int flags)
+xfs_attr_set_int_trans(
+	xfs_trans_t	**tpp,
+	xfs_inode_t	*dp,
+	struct xfs_name *name,
+	char		*value,
+	int		valuelen,
+	int		flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -260,10 +270,14 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
+			XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
 
-		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
-			return(error);
+		error = xfs_bmap_add_attrfork_trans(tpp, dp, sf_size, rsvd);
+		if (error)
+			return error;
+		error = xfs_trans_roll(tpp, dp);
+		if (error)
+			return error;
 	}
 
 	/*
@@ -286,45 +300,52 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	/* Size is now blocks for attribute data */
 	args.total = xfs_attr_calc_size(dp, name->len, valuelen, &local);
 
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
 
-	if ((error = xfs_trans_reserve(args.trans, args.total,
-			XFS_ATTRSET_LOG_RES(mp, args.total), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT))) {
-		xfs_trans_cancel(args.trans, 0);
-		return(error);
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve(args.trans, args.total,
+				 XFS_ATTRSET_LOG_RES(mp, args.total), 0,
+				 XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT);
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
@@ -360,8 +381,14 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
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
@@ -370,6 +397,8 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 			if (!error && (flags & ATTR_KERNOTIME) == 0) {
 				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 			}
+			if (tpp)
+				*tpp = args.trans;
 			return(error == 0 ? err2 : error);
 		}
 
@@ -415,13 +444,13 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
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
@@ -430,8 +459,12 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
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
@@ -441,6 +474,8 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 
+	if (tpp)
+		*tpp = args.trans;
 	return(error);
 
 out:
@@ -448,9 +483,23 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (tpp)
+		*tpp = args.trans;
 	return(error);
 }
 
+STATIC int
+xfs_attr_set_int(
+	xfs_inode_t	*dp,
+	struct xfs_name *name,
+	char		*value,
+	int		valuelen,
+	int		flags)
+{
+	return xfs_attr_set_int_trans(NULL, dp, name,
+				      value, valuelen, flags);
+}
+
 int
 xfs_attr_set(
 	xfs_inode_t	*dp,
-- 
1.5.6.2
