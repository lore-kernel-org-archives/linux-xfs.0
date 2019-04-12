Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfDLWww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 18:52:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMdpnE021387
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rpmrqrs0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMq0ds100896
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rtyj2ub7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3CMqlS4002548
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:47 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 9/9] xfs: Remove roll_trans boolean
Date: Fri, 12 Apr 2019 15:50:36 -0700
Message-Id: <20190412225036.22939-10-allison.henderson@oracle.com>
In-Reply-To: <20190412225036.22939-1-allison.henderson@oracle.com>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All calls to functions using this parameter are now passing a
false value.  We can now remove the boolean and all affected
code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 178 ++++++----------------------------------
 fs/xfs/libxfs/xfs_attr.h        |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  25 +-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  34 +-------
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 fs/xfs/xfs_trans_attr.c         |   4 +-
 7 files changed, 41 insertions(+), 214 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4ddd86b..bd8fd32 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -51,16 +51,16 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
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
@@ -200,8 +200,7 @@ xfs_attr_calc_size(
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 
 	struct xfs_mount	*mp = dp->i_mount;
@@ -221,11 +220,6 @@ xfs_attr_try_sf_addname(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	if (roll_trans) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-	}
-
 	return error ? error : error2;
 }
 
@@ -236,8 +230,7 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
 	struct xfs_buf          **leaf_bp,
-	enum xfs_attr_state	*state,
-	bool			roll_trans)
+	enum xfs_attr_state	*state)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error = 0;
@@ -284,7 +277,7 @@ xfs_attr_set_args(
 		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
-		error = xfs_attr_try_sf_addname(dp, args, roll_trans);
+		error = xfs_attr_try_sf_addname(dp, args);
 		if (error != -ENOSPC)
 			return error;
 
@@ -306,23 +299,6 @@ xfs_attr_set_args(
 		 */
 		xfs_trans_bhold(args->trans, *leaf_bp);
 
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-
-			/*
-			 * Commit the leaf transformation.  We'll need another
-			 * (linked) transaction to add the new attribute to the
-			 * leaf.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				return error;
-			xfs_trans_bjoin(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
-		}
-
 		*state = XFS_ATTR_STATE3;
 		return -EAGAIN;
 state3:
@@ -331,9 +307,9 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(args, roll_trans);
+		error = xfs_attr_leaf_addname(args);
 	else
-		error = xfs_attr_node_addname(args, roll_trans);
+		error = xfs_attr_node_addname(args);
 	return error;
 }
 
@@ -365,8 +341,7 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args,
-	bool                    roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
@@ -377,9 +352,9 @@ xfs_attr_remove_args(
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
@@ -720,8 +695,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -787,37 +761,13 @@ xfs_attr_leaf_addname(
 		if (error)
 			return error;
 
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
@@ -825,7 +775,7 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args, roll_trans);
+		error = xfs_attr_rmtval_set(args);
 		if (error)
 			return error;
 	}
@@ -841,7 +791,7 @@ xfs_attr_leaf_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
 
@@ -855,7 +805,7 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -879,25 +829,13 @@ xfs_attr_leaf_addname(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				return error;
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
 }
@@ -933,8 +871,7 @@ xfs_leaf_has_attr(
  */
 STATIC int
 xfs_attr_leaf_removename(
-	struct xfs_da_args	*args,
-	bool roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -967,12 +904,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
 	}
 	return 0;
 }
@@ -1025,8 +956,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1095,20 +1025,6 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
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
 
@@ -1122,12 +1038,6 @@ xfs_attr_node_addname(
 		if (error)
 			goto out;
 
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-		}
-
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1143,23 +1053,13 @@ xfs_attr_node_addname(
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
@@ -1175,7 +1075,7 @@ xfs_attr_node_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args, roll_trans);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
 
@@ -1189,7 +1089,7 @@ xfs_attr_node_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args, roll_trans);
+			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
 		}
@@ -1223,11 +1123,6 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					goto out;
-			}
 		}
 
 		/*
@@ -1241,7 +1136,7 @@ xfs_attr_node_addname(
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args, roll_trans);
+		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
 	}
@@ -1294,8 +1189,7 @@ xfs_attr_node_hasname(
  */
 STATIC int
 xfs_attr_node_removename(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1345,10 +1239,10 @@ xfs_attr_node_removename(
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
 
@@ -1376,19 +1270,6 @@ xfs_attr_node_removename(
 		error = xfs_da3_join(state);
 		if (error)
 			goto out;
-
-		if (roll_trans) {
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-			/*
-			 * Commit the Btree join operation and start
-			 * a new trans.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-		}
 	}
 
 	/*
@@ -1412,11 +1293,6 @@ xfs_attr_node_removename(
 			if (error)
 				goto out;
 
-			if (roll_trans) {
-				error = xfs_defer_finish(&args->trans);
-				if (error)
-					goto out;
-			}
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index da95e69..f369895 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -181,11 +181,11 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 size_t namelen, unsigned char *value, int valuelen,
 		 int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
-		 enum xfs_attr_state *state, bool roll_trans);
+		 enum xfs_attr_state *state);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
 		    size_t namelen, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
+int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e9f2f53..90dfa53 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2670,8 +2670,7 @@ xfs_attr_leaf_newentsize(
  */
 int
 xfs_attr3_leaf_clearflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2729,11 +2728,6 @@ xfs_attr3_leaf_clearflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2742,8 +2736,7 @@ xfs_attr3_leaf_clearflag(
  */
 int
 xfs_attr3_leaf_setflag(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2783,11 +2776,6 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	if (roll_trans)
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	return error;
 }
 
@@ -2800,8 +2788,7 @@ xfs_attr3_leaf_setflag(
  */
 int
 xfs_attr3_leaf_flipflags(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_attr_leafblock *leaf1;
 	struct xfs_attr_leafblock *leaf2;
@@ -2904,11 +2891,5 @@ xfs_attr3_leaf_flipflags(
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
index 18fbd22..9054f98 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -435,8 +435,7 @@ xfs_attr_rmtval_get(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -490,26 +489,11 @@ xfs_attr_rmtval_set(
 		if (error)
 			return error;
 
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
@@ -569,8 +553,7 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args,
-	bool			roll_trans)
+	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
@@ -632,19 +615,6 @@ xfs_attr_rmtval_remove(
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
 			return error;
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
 }
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
index a3339ea..4144ecf 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -70,11 +70,11 @@ xfs_trans_attr(
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
 		error = xfs_attr_set_args(args, leaf_bp,
-				(enum xfs_attr_state *)state, false);
+				(enum xfs_attr_state *)state);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
-		error = xfs_attr_remove_args(args, false);
+		error = xfs_attr_remove_args(args);
 		break;
 	default:
 		error = -EFSCORRUPTED;
-- 
2.7.4
