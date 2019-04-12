Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726850AbfDLWwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 18:52:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMeO2I010804
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkhtgtwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMq3VL100992
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rtyj2ub79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3CMqjel017242
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:45 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 3/9] xfs: Add trans toggle to attr routines
Date: Fri, 12 Apr 2019 15:50:30 -0700
Message-Id: <20190412225036.22939-4-allison.henderson@oracle.com>
In-Reply-To: <20190412225036.22939-1-allison.henderson@oracle.com>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c        | 257 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h        |   5 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  20 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   8 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  50 ++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 6 files changed, 203 insertions(+), 141 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3da6b0d..c50bbf6 100644
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
 
@@ -196,11 +196,12 @@ xfs_attr_calc_size(
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 
 	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error, error2 = 0;
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -216,8 +217,11 @@ xfs_attr_try_sf_addname(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
+	if (roll_trans) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+	}
+
 	return error ? error : error2;
 }
 
@@ -227,10 +231,11 @@ xfs_attr_try_sf_addname(
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
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -249,7 +254,7 @@ xfs_attr_set_args(
 		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
-		error = xfs_attr_try_sf_addname(dp, args);
+		error = xfs_attr_try_sf_addname(dp, args, roll_trans);
 		if (error != -ENOSPC)
 			return error;
 
@@ -261,33 +266,35 @@ xfs_attr_set_args(
 		if (error)
 			return error;
 
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
-			return error;
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
 
-		/*
-		 * Commit the leaf transformation.  We'll need another
-		 * (linked) transaction to add the new attribute to the
-		 * leaf.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-		xfs_trans_bjoin(args->trans, *leaf_bp);
-		*leaf_bp = NULL;
+			/*
+			 * Commit the leaf transformation.  We'll need another
+			 * (linked) transaction to add the new attribute to the
+			 * leaf.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
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
 	return error;
 }
 
@@ -296,7 +303,8 @@ xfs_attr_set_args(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args      *args,
+	bool                    roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
@@ -307,9 +315,9 @@ xfs_attr_remove_args(
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
@@ -384,7 +392,7 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp);
+	error = xfs_attr_set_args(&args, &leaf_bp, true);
 	if (error)
 		goto out_release_leaf;
 	if (!args.trans) {
@@ -473,7 +481,8 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_attr_remove_args(&args, true);
+
 	if (error)
 		goto out;
 
@@ -563,7 +572,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -628,32 +638,37 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
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
 		return error;
 	}
 
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
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
@@ -662,7 +677,7 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		error = xfs_attr_rmtval_set(args, roll_trans);
 		if (error)
 			return error;
 	}
@@ -678,7 +693,7 @@ xfs_attr_leaf_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args, roll_trans);
 		if (error)
 			return error;
 
@@ -692,7 +707,7 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_remove(args, roll_trans);
 			if (error)
 				return error;
 		}
@@ -716,21 +731,25 @@ xfs_attr_leaf_addname(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				return error;
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
 }
@@ -743,7 +762,8 @@ xfs_attr_leaf_addname(
  */
 STATIC int
 xfs_attr_leaf_removename(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool roll_trans)
 {
 	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
@@ -776,9 +796,12 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+		}
 	}
 	return 0;
 }
@@ -831,7 +854,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -899,17 +923,20 @@ xfs_attr_node_addname(
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
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
@@ -923,9 +950,13 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				goto out;
+		}
+
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -944,9 +975,11 @@ xfs_attr_node_addname(
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
@@ -955,7 +988,7 @@ xfs_attr_node_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		error = xfs_attr_rmtval_set(args, roll_trans);
 		if (error)
 			return error;
 	}
@@ -971,7 +1004,7 @@ xfs_attr_node_addname(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args, roll_trans);
 		if (error)
 			goto out;
 
@@ -985,7 +1018,7 @@ xfs_attr_node_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_remove(args, roll_trans);
 			if (error)
 				return error;
 		}
@@ -1019,9 +1052,11 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
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
@@ -1035,7 +1070,7 @@ xfs_attr_node_addname(
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr3_leaf_clearflag(args);
+		error = xfs_attr3_leaf_clearflag(args, roll_trans);
 		if (error)
 			goto out;
 	}
@@ -1058,7 +1093,8 @@ xfs_attr_node_addname(
  */
 STATIC int
 xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
@@ -1108,10 +1144,10 @@ xfs_attr_node_removename(
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
 
@@ -1139,15 +1175,19 @@ xfs_attr_node_removename(
 		error = xfs_da3_join(state);
 		if (error)
 			goto out;
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
+			 * Commit the Btree join operation and start
+			 * a new trans.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				goto out;
+		}
 	}
 
 	/*
@@ -1170,9 +1210,12 @@ xfs_attr_node_removename(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out;
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
index 52f63dc..f0e91bf 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -142,10 +142,11 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 size_t namelen, unsigned char *value, int valuelen,
 		 int flags);
-int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
+int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
+		 bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
 		    size_t namelen, int flags);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1f6e396..128bfe9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2637,7 +2637,8 @@ xfs_attr_leaf_newentsize(
  */
 int
 xfs_attr3_leaf_clearflag(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2698,7 +2699,9 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	if (roll_trans)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
@@ -2706,7 +2709,8 @@ xfs_attr3_leaf_clearflag(
  */
 int
 xfs_attr3_leaf_setflag(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
@@ -2749,7 +2753,9 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	if (roll_trans)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
@@ -2761,7 +2767,8 @@ xfs_attr3_leaf_setflag(
  */
 int
 xfs_attr3_leaf_flipflags(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_attr_leafblock *leaf1;
 	struct xfs_attr_leafblock *leaf2;
@@ -2867,7 +2874,8 @@ xfs_attr3_leaf_flipflags(
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
index 65ff600..18fbd22 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -435,7 +435,8 @@ xfs_attr_rmtval_get(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -488,9 +489,12 @@ xfs_attr_rmtval_set(
 				  &nmap);
 		if (error)
 			return error;
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
@@ -498,12 +502,14 @@ xfs_attr_rmtval_set(
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
@@ -563,7 +569,8 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	bool			roll_trans)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
@@ -625,16 +632,19 @@ xfs_attr_rmtval_remove(
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
 			return error;
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
 }
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
