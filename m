Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 21:42:33 -0700 (PDT)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N4gJA0017141
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 21:42:20 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Move xfs_attr_rolltrans to xfs_trans_roll
Date: Mon, 23 Jun 2008 14:42:28 +1000
Message-Id: <1214196150-5427-3-git-send-email-xaiki@sgi.com>
In-Reply-To: <1214196150-5427-2-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
 <1214196150-5427-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

Move it from the attr code to the transaction code and make the attr
code call the new function.

We rolltrans is really usefull whenever we want to use rolling
transaction, should be generic, it isn't dependent on any part of the
attr code anyway.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c      |   22 ++++++++-------
 fs/xfs/xfs_attr_leaf.c |   69 ++++-------------------------------------------
 fs/xfs/xfs_attr_leaf.h |    2 -
 fs/xfs/xfs_trans.c     |   57 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h     |    1 +
 5 files changed, 76 insertions(+), 75 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 0d19e90..be6bfc4 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -389,7 +389,9 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		 * Commit the leaf transformation.  We'll need another (linked)
 		 * transaction to add the new attribute to the leaf.
 		 */
-		if ((error = xfs_attr_rolltrans(&args.trans, dp)))
+
+		error = xfs_trans_roll(&args.trans, dp);
+		if (error)
 			goto out;
 
 	}
@@ -1019,7 +1021,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit the current trans (including the inode) and start
 		 * a new one.
 		 */
-		if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+		if ((error = xfs_trans_roll(&args->trans, dp)))
 			return (error);
 
 		/*
@@ -1033,7 +1035,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 * Commit the transaction that added the attr name so that
 	 * later routines can manage their own transactions.
 	 */
-	if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+	if ((error = xfs_trans_roll(&args->trans, dp)))
 		return (error);
 
 	/*
@@ -1122,7 +1124,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		/*
 		 * Commit the remove and start the next trans in series.
 		 */
-		error = xfs_attr_rolltrans(&args->trans, dp);
+		error = xfs_trans_roll(&args->trans, dp);
 
 	} else if (args->rmtblkno > 0) {
 		/*
@@ -1353,7 +1355,7 @@ restart:
 			 * Commit the node conversion and start the next
 			 * trans in the chain.
 			 */
-			if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+			if ((error = xfs_trans_roll(&args->trans, dp)))
 				goto out;
 
 			goto restart;
@@ -1404,7 +1406,7 @@ restart:
 	 * Commit the leaf addition or btree split and start the next
 	 * trans in the chain.
 	 */
-	if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+	if ((error = xfs_trans_roll(&args->trans, dp)))
 		goto out;
 
 	/*
@@ -1504,7 +1506,7 @@ restart:
 		/*
 		 * Commit and start the next trans in the chain.
 		 */
-		if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+		if ((error = xfs_trans_roll(&args->trans, dp)))
 			goto out;
 
 	} else if (args->rmtblkno > 0) {
@@ -1636,7 +1638,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
-		if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+		if ((error = xfs_trans_roll(&args->trans, dp)))
 			goto out;
 	}
 
@@ -2137,7 +2139,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Start the next trans in the chain.
 		 */
-		if ((error = xfs_attr_rolltrans(&args->trans, dp)))
+		if ((error = xfs_trans_roll(&args->trans, dp)))
 			return (error);
 	}
 
@@ -2287,7 +2289,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 		/*
 		 * Close out trans and start the next one in the chain.
 		 */
-		if ((error = xfs_attr_rolltrans(&args->trans, args->dp)))
+		if ((error = xfs_trans_roll(&args->trans, args->dp)))
 			return (error);
 	}
 	return(0);
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index b08e2a2..9465807 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2543,7 +2543,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_attr_rolltrans(&args->trans, args->dp);
+	error = xfs_trans_roll(&args->trans, args->dp);
 
 	return(error);
 }
@@ -2592,7 +2592,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_attr_rolltrans(&args->trans, args->dp);
+	error = xfs_trans_roll(&args->trans, args->dp);
 
 	return(error);
 }
@@ -2710,7 +2710,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_attr_rolltrans(&args->trans, args->dp);
+	error = xfs_trans_roll(&args->trans, args->dp);
 
 	return(error);
 }
@@ -2768,7 +2768,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	/*
 	 * Commit the invalidate and start the next transaction.
 	 */
-	error = xfs_attr_rolltrans(trans, dp);
+	error = xfs_trans_roll(trans, dp);
 
 	return (error);
 }
@@ -2870,7 +2870,7 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
 		/*
 		 * Atomically commit the whole invalidate stuff.
 		 */
-		if ((error = xfs_attr_rolltrans(trans, dp)))
+		if ((error = xfs_trans_roll(trans, dp)))
 			return (error);
 	}
 
@@ -3009,7 +3009,7 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 			/*
 			 * Roll to next transaction.
 			 */
-			if ((error = xfs_attr_rolltrans(trans, dp)))
+			if ((error = xfs_trans_roll(trans, dp)))
 				return (error);
 		}
 
@@ -3019,60 +3019,3 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 
 	return(0);
 }
-
-
-/*
- * Roll from one trans in the sequence of PERMANENT transactions to the next.
- */
-int
-xfs_attr_rolltrans(xfs_trans_t **transp, xfs_inode_t *dp)
-{
-	xfs_trans_t *trans;
-	unsigned int logres, count;
-	int	error;
-
-	/*
-	 * Ensure that the inode is always logged.
-	 */
-	trans = *transp;
-	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
-
-	/*
-	 * Copy the critical parameters from one trans to the next.
-	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
-	*transp = xfs_trans_dup(trans);
-
-	/*
-	 * Commit the current transaction.
-	 * If this commit failed, then it'd just unlock those items that
-	 * are not marked ihold. That also means that a filesystem shutdown
-	 * is in progress. The caller takes the responsibility to cancel
-	 * the duplicate transaction that gets returned.
-	 */
-	if ((error = xfs_trans_commit(trans, 0)))
-		return (error);
-
-	trans = *transp;
-
-	/*
-	 * Reserve space in the log for th next transaction.
-	 * This also pushes items in the "AIL", the list of logged items,
-	 * out to disk if they are taking up space at the tail of the log
-	 * that we want to use.  This requires that either nothing be locked
-	 * across this call, or that anything that is locked be logged in
-	 * the prior and the next transactions.
-	 */
-	error = xfs_trans_reserve(trans, 0, logres, 0,
-				  XFS_TRANS_PERM_LOG_RES, count);
-	/*
-	 *  Ensure that the inode is in the new transaction and locked.
-	 */
-	if (!error) {
-		xfs_trans_ijoin(trans, dp, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(trans, dp);
-	}
-	return (error);
-
-}
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 040f732..698e078 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -301,6 +301,4 @@ int	xfs_attr_leaf_order(struct xfs_dabuf *leaf1_bp,
 				   struct xfs_dabuf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 					int *local);
-int	xfs_attr_rolltrans(struct xfs_trans **transp, struct xfs_inode *dp);
-
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1403864..9e5e0c2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -43,6 +43,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
+#include "xfs_inode_item.h"
 
 
 STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
@@ -1216,6 +1217,62 @@ xfs_trans_free(
 	kmem_zone_free(xfs_trans_zone, tp);
 }
 
+/*
+ * Roll from one trans in the sequence of PERMANENT transactions to the next.
+ */
+int
+xfs_trans_roll(
+	xfs_trans_t	**tpp,
+	xfs_inode_t	*dp)
+{
+	xfs_trans_t	*trans;
+	unsigned int	logres, count;
+	int		error;
+
+	/*
+	 * Ensure that the inode is always logged.
+	 */
+	trans = *tpp;
+	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
+
+	/*
+	 * Copy the critical parameters from one trans to the next.
+	 */
+	logres = trans->t_log_res;
+	count = trans->t_log_count;
+	*tpp = xfs_trans_dup(trans);
+
+	/*
+	 * Commit the current transaction.
+	 * If this commit failed, then it'd just unlock those items that
+	 * are not marked ihold. That also means that a filesystem shutdown
+	 * is in progress. The caller takes the responsibility to cancel
+	 * the duplicate transaction that gets returned.
+	 */
+	if ((error = xfs_trans_commit(trans, 0)))
+		return (error);
+
+	trans = *tpp;
+
+	/*
+	 * Reserve space in the log for th next transaction.
+	 * This also pushes items in the "AIL", the list of logged items,
+	 * out to disk if they are taking up space at the tail of the log
+	 * that we want to use.  This requires that either nothing be locked
+	 * across this call, or that anything that is locked be logged in
+	 * the prior and the next transactions.
+	 */
+	error = xfs_trans_reserve(trans, 0, logres, 0,
+				  XFS_TRANS_PERM_LOG_RES, count);
+	/*
+	 *  Ensure that the inode is in the new transaction and locked.
+	 */
+	if (!error) {
+		xfs_trans_ijoin(trans, dp, XFS_ILOCK_EXCL);
+		xfs_trans_ihold(trans, dp);
+	}
+	return (error);
+}
 
 /*
  * THIS SHOULD BE REWRITTEN TO USE xfs_trans_next_item().
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7f40628..7b4299e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -992,6 +992,7 @@ int		_xfs_trans_commit(xfs_trans_t *,
 				  int *);
 #define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
 void		xfs_trans_cancel(xfs_trans_t *, int);
+int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-- 
1.5.5.4
