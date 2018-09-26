Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZQiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANs54087775
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mndpphh7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPlgB004789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPltQ032130
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 11/30] xfsprogs: Remove roll_trans boolean
Date: Wed, 26 Sep 2018 03:23:14 -0700
Message-Id: <1537957413-10630-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All calls to functions using this parameter are now passing a
false value.  We can now remove the boolean and all affected
code

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        | 168 +++++++----------------------------------------
 libxfs/xfs_attr.h        |   4 +-
 libxfs/xfs_attr_leaf.c   |  25 +------
 libxfs/xfs_attr_leaf.h   |   6 +-
 libxfs/xfs_attr_remote.c |  34 +---------
 libxfs/xfs_attr_remote.h |   4 +-
 6 files changed, 37 insertions(+), 204 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1935128..b71d9ed 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -46,16 +46,16 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
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
@@ -233,8 +233,7 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
 	struct xfs_buf          **leaf_bp,
-	xfs_attr_state_t	*state,
-	bool			roll_trans)
+	xfs_attr_state_t	*state)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error = 0;
@@ -298,23 +297,6 @@ state1:
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
@@ -323,9 +305,9 @@ state2:
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(args, roll_trans);
+		error = xfs_attr_leaf_addname(args);
 	else
-		error = xfs_attr_node_addname(args, roll_trans);
+		error = xfs_attr_node_addname(args);
 	if (error)
 		goto out;
 
@@ -361,8 +343,7 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args,
-	bool                    roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
@@ -373,9 +354,9 @@ xfs_attr_remove_args(
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
@@ -713,8 +694,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -780,39 +760,14 @@ xfs_attr_leaf_addname(
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
@@ -820,7 +775,7 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args, roll_trans);
+		error = xfs_attr_rmtval_set(args);
 		if (error)
 			return error;
 	}
@@ -836,7 +791,7 @@ xfs_attr_leaf_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
 
@@ -850,7 +805,7 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -874,25 +829,13 @@ xfs_attr_leaf_addname(
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
@@ -931,8 +874,7 @@ xfs_leaf_has_attr(
  */
 STATIC int
 xfs_attr_leaf_removename(
-	struct xfs_da_args	*args,
-	bool roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -965,11 +907,6 @@ xfs_attr_leaf_removename(
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
@@ -1025,8 +962,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1096,20 +1032,6 @@ restart:
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
 
@@ -1122,12 +1044,6 @@ restart:
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
@@ -1143,23 +1059,13 @@ restart:
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
@@ -1175,7 +1081,7 @@ restart:
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
 
@@ -1189,7 +1095,7 @@ restart:
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -1223,11 +1129,6 @@ restart:
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
@@ -1241,7 +1142,7 @@ restart:
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args, roll_trans);
+		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
 	}
@@ -1297,8 +1198,7 @@ xfs_attr_node_hasname(
  */
 STATIC int
 xfs_attr_node_removename(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1348,10 +1248,10 @@ xfs_attr_node_removename(
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
 
@@ -1379,19 +1279,6 @@ xfs_attr_node_removename(
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
@@ -1415,11 +1302,6 @@ xfs_attr_node_removename(
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index ee4bc13..c076f0c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -175,10 +175,10 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
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
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index d84cd59..7942aee 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2667,8 +2667,7 @@ xfs_attr_leaf_newentsize(
  */
 int
 xfs_attr3_leaf_clearflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2726,11 +2725,6 @@ xfs_attr3_leaf_clearflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2739,8 +2733,7 @@ xfs_attr3_leaf_clearflag(
  */
 int
 xfs_attr3_leaf_setflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2780,11 +2773,6 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2797,8 +2785,7 @@ xfs_attr3_leaf_setflag(
  */
 int
 xfs_attr3_leaf_flipflags(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf1;
 	struct xfs_attr_leafblock *leaf2;
@@ -2901,11 +2888,5 @@ xfs_attr3_leaf_flipflags(
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
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 98dd169..d38c558 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 6446607..ad018a4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -428,8 +428,7 @@ xfs_attr_rmtval_get(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -483,26 +482,11 @@ xfs_attr_rmtval_set(
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
@@ -565,8 +549,7 @@ out_defer_cancel:
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
@@ -628,19 +611,6 @@ xfs_attr_rmtval_remove(
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
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index c7c073d..9d20b66 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -9,7 +9,7 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args, bool roll_trans);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args, bool roll_trans);
+int xfs_attr_rmtval_set(struct xfs_da_args *args);
+int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4
