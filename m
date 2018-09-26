Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeIZQ3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAE8e7079734
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:21 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mndpphg5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHKOZ031126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAHKXL014169
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 06/28] xfs: Add trans toggle to attr routines
Date: Wed, 26 Sep 2018 03:14:45 -0700
Message-Id: <1537956907-10244-7-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a roll_trans parameter to all attribute routines
that may roll a transaction. Calling functions may pass true to
roll transactions as normal, or false to hold them.

This patch is temporary and will be removed later when all code
paths have been made to pass a false value.  The temporary boolean
assists us to introduce changes across multiple smaller patches instead
of handling all affected code paths in one large patch.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 244 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h        |   5 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  20 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   8 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  50 ++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 6 files changed, 195 insertions(+), 136 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cecf950..03e0aff 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -49,15 +49,15 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
 
 /*
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -233,10 +233,11 @@ xfs_attr_try_sf_addname(
 int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
-	struct xfs_buf          **leaf_bp)
+	struct xfs_buf          **leaf_bp,
+	bool			roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int			error = 0;
 	int			sf_size;
 
 	/*
@@ -281,33 +282,35 @@ xfs_attr_set_args(
 		if (error)
 			goto out;
 
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, *leaf_bp);
+		if (roll_trans) {
+			/*
+			 * Prevent the leaf buffer from being unlocked so that a
+			 * concurrent AIL push cannot grab the half-baked leaf
+			 * buffer and run into problems with the write verifier.
+			 */
+			xfs_trans_bhold(args->trans, *leaf_bp);
 
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				goto out;
 
-		/*
-		 * Commit the leaf transformation.  We'll need another
-		 * (linked) transaction to add the new attribute to the
-		 * leaf.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-		xfs_trans_bjoin(args->trans, *leaf_bp);
-		*leaf_bp = NULL;
+			/*
+			 * Commit the leaf transformation.  We'll need another
+			 * (linked) transaction to add the new attribute to the
+			 * leaf.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				goto out;
+			xfs_trans_bjoin(args->trans, *leaf_bp);
+			*leaf_bp = NULL;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(args);
+		error = xfs_attr_leaf_addname(args, roll_trans);
 	else
-		error = xfs_attr_node_addname(args);
+		error = xfs_attr_node_addname(args, roll_trans);
 	if (error)
 		goto out;
 
@@ -320,7 +323,8 @@ xfs_attr_set_args(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args      *args,
+	bool                    roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
@@ -331,9 +335,9 @@ xfs_attr_remove_args(
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(args);
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args);
+		error = xfs_attr_leaf_removename(args, roll_trans);
 	} else {
-		error = xfs_attr_node_removename(args);
+		error = xfs_attr_node_removename(args, roll_trans);
 	}
 
 	return error;
@@ -410,7 +414,7 @@ xfs_attr_set(
 	}
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp);
+	error = xfs_attr_set_args(&args, &leaf_bp, true);
 	if (error)
 		goto out;
 
@@ -494,7 +498,8 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_attr_remove_args(&args, true);
+
 	if (error)
 		goto out;
 
@@ -584,7 +589,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -649,32 +655,39 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and start
-		 * a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+		}
 
 		/*
 		 * Fob the whole rest of the problem off on the Btree code.
 		 */
-		error = xfs_attr_node_addname(args);
+		error = xfs_attr_node_addname(args, roll_trans);
+
 		return error;
 	}
 
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
+
+	if (roll_trans) {
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+	}
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -683,7 +696,7 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		error = xfs_attr_rmtval_set(args, roll_trans);
 		if (error)
 			return error;
 	}
@@ -699,7 +712,7 @@ xfs_attr_leaf_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args, roll_trans);
 		if (error)
 			return error;
 
@@ -713,7 +726,7 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_remove(args, roll_trans);
 			if (error)
 				return error;
 		}
@@ -737,21 +750,25 @@ xfs_attr_leaf_addname(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out_defer_cancel;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
+
+			if (roll_trans) {
+				error = xfs_defer_finish(&args->trans);
+				if (error)
+					return error;
+			}
 		}
 
 		/*
 		 * Commit the remove and start the next trans in series.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (roll_trans)
+			error = xfs_trans_roll_inode(&args->trans, dp);
 
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args);
+		error = xfs_attr3_leaf_clearflag(args, roll_trans);
 	}
 	return error;
 out_defer_cancel:
@@ -767,7 +784,8 @@ xfs_attr_leaf_addname(
  */
 STATIC int
 xfs_attr_leaf_removename(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool roll_trans)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -800,9 +818,11 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+		}
 	}
 	return 0;
 out_defer_cancel:
@@ -858,7 +878,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -923,20 +944,24 @@ xfs_attr_node_addname(
 			 */
 			xfs_da_state_free(state);
 			state = NULL;
+
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out_defer_cancel;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
-			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
+			if (roll_trans) {
+				error = xfs_defer_finish(&args->trans);
+				if (error)
+					goto out;
+
+				/*
+				 * Commit the node conversion and start the next
+				 * trans in the chain.
+				 */
+				error = xfs_trans_roll_inode(&args->trans, dp);
+				if (error)
+					goto out;
+			}
 
 			goto restart;
 		}
@@ -950,9 +975,12 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				goto out;
+		}
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -971,9 +999,11 @@ xfs_attr_node_addname(
 	 * Commit the leaf addition or btree split and start the next
 	 * trans in the chain.
 	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+	if (roll_trans) {
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			goto out;
+	}
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -982,7 +1012,7 @@ xfs_attr_node_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		error = xfs_attr_rmtval_set(args, roll_trans);
 		if (error)
 			return error;
 	}
@@ -998,7 +1028,7 @@ xfs_attr_node_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args, roll_trans);
 		if (error)
 			goto out;
 
@@ -1012,7 +1042,7 @@ xfs_attr_node_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_remove(args, roll_trans);
 			if (error)
 				return error;
 		}
@@ -1046,9 +1076,11 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out_defer_cancel;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
+			if (roll_trans) {
+				error = xfs_defer_finish(&args->trans);
+				if (error)
+					goto out;
+			}
 		}
 
 		/*
@@ -1062,7 +1094,7 @@ xfs_attr_node_addname(
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args);
+		error = xfs_attr3_leaf_clearflag(args, roll_trans);
 		if (error)
 			goto out;
 	}
@@ -1088,7 +1120,8 @@ xfs_attr_node_addname(
  */
 STATIC int
 xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1138,10 +1171,10 @@ xfs_attr_node_removename(
 		 * Mark the attribute as INCOMPLETE, then bunmapi() the
 		 * remote value.
 		 */
-		error = xfs_attr3_leaf_setflag(args);
+		error = xfs_attr3_leaf_setflag(args, roll_trans);
 		if (error)
 			goto out;
-		error = xfs_attr_rmtval_remove(args);
+		error = xfs_attr_rmtval_remove(args, roll_trans);
 		if (error)
 			goto out;
 
@@ -1169,15 +1202,19 @@ xfs_attr_node_removename(
 		error = xfs_da3_join(state);
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
+
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				goto out;
+			/*
+			 * Commit the Btree join operation and
+			 * start a new trans.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				goto out;
+		}
 	}
 
 	/*
@@ -1200,9 +1237,12 @@ xfs_attr_node_removename(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out_defer_cancel;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
+
+			if (roll_trans) {
+				error = xfs_defer_finish(&args->trans);
+				if (error)
+					goto out;
+			}
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index bdf52a3..92a796a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -140,9 +140,10 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
-int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
+int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
+		 bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6fc5425..d127f2c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2639,7 +2639,8 @@ xfs_attr_leaf_newentsize(
  */
 int
 xfs_attr3_leaf_clearflag(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2700,7 +2701,9 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	if (roll_trans)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
@@ -2708,7 +2711,8 @@ xfs_attr3_leaf_clearflag(
  */
 int
 xfs_attr3_leaf_setflag(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2751,7 +2755,9 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	if (roll_trans)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
@@ -2763,7 +2769,8 @@ xfs_attr3_leaf_setflag(
  */
 int
 xfs_attr3_leaf_flipflags(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf1;
 	struct xfs_attr_leafblock *leaf2;
@@ -2869,7 +2876,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (roll_trans)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18..9d830ec 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -49,10 +49,10 @@ void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
  */
 int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
 int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
-				   struct xfs_da_args *args, int forkoff);
-int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
-int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
-int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+			struct xfs_da_args *args, int forkoff);
+int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args, bool roll_trans);
+int	xfs_attr3_leaf_setflag(struct xfs_da_args *args, bool roll_trans);
+int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args, bool roll_trans);
 
 /*
  * Routines used for growing the Btree.
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index af09406..e13000a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -433,7 +433,8 @@ xfs_attr_rmtval_get(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -486,9 +487,12 @@ xfs_attr_rmtval_set(
 				  &nmap);
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+		}
 
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
@@ -496,12 +500,14 @@ xfs_attr_rmtval_set(
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
 
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
+		if (roll_trans) {
+			/*
+			 * Start the next trans in the chain.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+		}
 	}
 
 	/*
@@ -564,7 +570,8 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
@@ -626,16 +633,19 @@ xfs_attr_rmtval_remove(
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
 			goto out_defer_cancel;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Close out trans and start the next one in the chain.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, args->dp);
+			if (error)
+				return error;
+		}
 	}
 	return 0;
 out_defer_cancel:
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66..c7c073d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -9,7 +9,7 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_set(struct xfs_da_args *args, bool roll_trans);
+int xfs_attr_rmtval_remove(struct xfs_da_args *args, bool roll_trans);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4
