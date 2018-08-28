Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbeH1XSC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJD9n125081
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:57 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2m2y2pdwjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOtYx032035
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOtxB012747
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 12/28] xfs: Remove roll_trans boolean
Date: Tue, 28 Aug 2018 12:22:25 -0700
Message-Id: <1535484161-11059-13-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All calls to functions using this parameter are now passing a
false value.  We can now remove the boolean and all affected
code

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 168 ++++++----------------------------------
 fs/xfs/libxfs/xfs_attr.h        |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  25 +-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  34 +-------
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 fs/xfs/xfs_trans_attr.c         |   4 +-
 7 files changed, 39 insertions(+), 206 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0e5bce9..79e7650 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -50,16 +50,16 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
-STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_leaf_has_attr(xfs_da_args_t *args);
 
 /*
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
@@ -237,8 +237,7 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
 	struct xfs_buf          **leaf_bp,
-	xfs_attr_state_t	*state,
-	bool			roll_trans)
+	xfs_attr_state_t	*state)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error = 0;
@@ -302,23 +301,6 @@ xfs_attr_set_args(
 		 */
 		xfs_trans_bhold(args->trans, *leaf_bp);
 
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-
-			/*
-			 * Commit the leaf transformation.  We'll need another
-			 * (linked) transaction to add the new attribute to the
-			 * leaf.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-			xfs_trans_bjoin(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
-		}
-
 		*state = XFS_ATTR_STATE2;
 		return -EAGAIN;
 state2:
@@ -327,9 +309,9 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(args, roll_trans);
+		error = xfs_attr_leaf_addname(args);
 	else
-		error = xfs_attr_node_addname(args, roll_trans);
+		error = xfs_attr_node_addname(args);
 	if (error)
 		goto out;
 
@@ -365,8 +347,7 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args,
-	bool                    roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
@@ -377,9 +358,9 @@ xfs_attr_remove_args(
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(args);
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args, roll_trans);
+		error = xfs_attr_leaf_removename(args);
 	} else {
-		error = xfs_attr_node_removename(args, roll_trans);
+		error = xfs_attr_node_removename(args);
 	}
 
 	return error;
@@ -717,8 +698,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -784,39 +764,14 @@ xfs_attr_leaf_addname(
 		if (error)
 			goto out_defer_cancel;
 
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-
-			/*
-			 * Commit the current trans (including the inode) and
-			 * start a new one.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				return error;
-		}
-
 		/*
 		 * Fob the whole rest of the problem off on the Btree code.
 		 */
-		error = xfs_attr_node_addname(args, roll_trans);
+		error = xfs_attr_node_addname(args);
 
 		return error;
 	}
 
-
-	if (roll_trans) {
-		/*
-		 * Commit the transaction that added the attr name so that
-		 * later routines can manage their own transactions.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
 	 * identified for its storage and copy the value.  This is done
@@ -824,7 +779,7 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args, roll_trans);
+		error = xfs_attr_rmtval_set(args);
 		if (error)
 			return error;
 	}
@@ -840,7 +795,7 @@ xfs_attr_leaf_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
 
@@ -854,7 +809,7 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -878,25 +833,13 @@ xfs_attr_leaf_addname(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out_defer_cancel;
-
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					return error;
-			}
 		}
 
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		if (roll_trans)
-			error = xfs_trans_roll_inode(&args->trans, dp);
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args, roll_trans);
+		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
 out_defer_cancel:
@@ -937,8 +880,7 @@ xfs_leaf_has_attr(
  */
 STATIC int
 xfs_attr_leaf_removename(
-	struct xfs_da_args	*args,
-	bool roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -971,11 +913,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			goto out_defer_cancel;
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
 	}
 	return 0;
 out_defer_cancel:
@@ -1031,8 +968,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1102,20 +1038,6 @@ xfs_attr_node_addname(
 			if (error)
 				goto out_defer_cancel;
 
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					goto out;
-
-				/*
-				 * Commit the node conversion and start the next
-				 * trans in the chain.
-				 */
-				error = xfs_trans_roll_inode(&args->trans, dp);
-				if (error)
-					goto out;
-			}
-
 			goto restart;
 		}
 
@@ -1128,12 +1050,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out_defer_cancel;
-
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-		}
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1149,23 +1065,13 @@ xfs_attr_node_addname(
 	state = NULL;
 
 	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	if (roll_trans) {
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
-
-	/*
 	 * If there was an out-of-line value, allocate the blocks we
 	 * identified for its storage and copy the value.  This is done
 	 * after we create the attribute so that we don't overflow the
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args, roll_trans);
+		error = xfs_attr_rmtval_set(args);
 		if (error)
 			return error;
 	}
@@ -1181,7 +1087,7 @@ xfs_attr_node_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
 
@@ -1195,7 +1101,7 @@ xfs_attr_node_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -1229,11 +1135,6 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out_defer_cancel;
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					goto out;
-			}
 		}
 
 		/*
@@ -1247,7 +1148,7 @@ xfs_attr_node_addname(
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args, roll_trans);
+		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
 	}
@@ -1303,8 +1204,7 @@ xfs_attr_node_hasname(
  */
 STATIC int
 xfs_attr_node_removename(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1354,10 +1254,10 @@ xfs_attr_node_removename(
 		 * Mark the attribute as INCOMPLETE, then bunmapi() the
 		 * remote value.
 		 */
-		error = xfs_attr3_leaf_setflag(args, roll_trans);
+		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
-		error = xfs_attr_rmtval_remove(args, roll_trans);
+		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
 
@@ -1385,19 +1285,6 @@ xfs_attr_node_removename(
 		error = xfs_da3_join(state);
 		if (error)
 			goto out_defer_cancel;
-
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-			/*
-			 * Commit the Btree join operation and
-			 * start a new trans.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-		}
 	}
 
 	/*
@@ -1421,11 +1308,6 @@ xfs_attr_node_removename(
 			if (error)
 				goto out_defer_cancel;
 
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					goto out;
-			}
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 76fad8f..3a51c84 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -178,10 +178,10 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
-		 xfs_attr_state_t *state, bool roll_trans);
+		 xfs_attr_state_t *state);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
+int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 43fafa9..09483fe 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2673,8 +2673,7 @@ xfs_attr_leaf_newentsize(
  */
 int
 xfs_attr3_leaf_clearflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2732,11 +2731,6 @@ xfs_attr3_leaf_clearflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2745,8 +2739,7 @@ xfs_attr3_leaf_clearflag(
  */
 int
 xfs_attr3_leaf_setflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2786,11 +2779,6 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2803,8 +2791,7 @@ xfs_attr3_leaf_setflag(
  */
 int
 xfs_attr3_leaf_flipflags(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf1;
 	struct xfs_attr_leafblock *leaf2;
@@ -2907,11 +2894,5 @@ xfs_attr3_leaf_flipflags(
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 98dd169..d38c558 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -51,9 +51,9 @@ void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
 int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 			struct xfs_da_args *args, int forkoff);
-int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args, bool roll_trans);
-int	xfs_attr3_leaf_setflag(struct xfs_da_args *args, bool roll_trans);
-int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args, bool roll_trans);
+int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
 
 /*
  * Routines used for growing the Btree.
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e13000a..0e91605 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -433,8 +433,7 @@ xfs_attr_rmtval_get(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -488,26 +487,11 @@ xfs_attr_rmtval_set(
 		if (error)
 			goto out_defer_cancel;
 
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
-
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
-
-		if (roll_trans) {
-			/*
-			 * Start the next trans in the chain.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				return error;
-		}
 	}
 
 	/*
@@ -570,8 +554,7 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
@@ -633,19 +616,6 @@ xfs_attr_rmtval_remove(
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
 			goto out_defer_cancel;
-
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-
-			/*
-			 * Close out trans and start the next one in the chain.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, args->dp);
-			if (error)
-				return error;
-		}
 	}
 	return 0;
 out_defer_cancel:
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index c7c073d..9d20b66 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -9,7 +9,7 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args, bool roll_trans);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args, bool roll_trans);
+int xfs_attr_rmtval_set(struct xfs_da_args *args);
+int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
index db6cb6d..4d138a9 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -81,11 +81,11 @@ xfs_trans_attr(
 		case XFS_ATTR_OP_FLAGS_SET:
 			args->op_flags |= XFS_DA_OP_ADDNAME;
 			error = xfs_attr_set_args(args, leaf_bp,
-					(xfs_attr_state_t *)state, false);
+					(xfs_attr_state_t *)state);
 			break;
 		case XFS_ATTR_OP_FLAGS_REMOVE:
 			ASSERT(XFS_IFORK_Q((args->dp)));
-			error = xfs_attr_remove_args(args, false);
+			error = xfs_attr_remove_args(args);
 			break;
 		default:
 			error = -EFSCORRUPTED;
-- 
2.7.4
