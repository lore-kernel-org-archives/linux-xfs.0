Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfDYFsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 01:48:01 -0400
Date: Wed, 24 Apr 2019 22:47:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] xfs: always rejoin held resources during defer roll
Message-ID: <20190425054747.GG178290@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

During testing of xfs/141 on a V4 filesystem, I observed some
inconsistent behavior with regards to resources that are held (i.e.
remain locked) across a defer roll.  The transaction roll always gives
the defer roll function a new transaction, even if committing the old
transaction fails.  However, the defer roll function only rejoins the
held resources if the transaction commit succeedied.  This means that
callers of defer roll have to figure out whether the held resources are
attached to the transaction being passed back.

Worse yet, if the defer roll was part of a defer finish call, we have a
third possibility: the defer finish could pass back a dirty transaction
with dirty held resources and an error code.

The only sane way to handle all of these scenarios is to require that
the code that held the resource either cancel the transaction before
unlocking and releasing the resources, or use functions that detach
resources from a transaction properly (e.g.  xfs_trans_brelse) if they
need to drop the reference before committing or cancelling the
transaction.

In order to make this so, change the defer roll code to join held
resources to the new transaction unconditionally and fix all the bhold
callers to release the held buffers correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  |   31 ++++++++++---------------------
 fs/xfs/libxfs/xfs_attr.h  |    2 +-
 fs/xfs/libxfs/xfs_defer.c |   14 +++++++++-----
 fs/xfs/xfs_dquot.c        |   22 +++++++++++-----------
 4 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2dd9ee2a2e08..ad954138243e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -224,10 +224,10 @@ xfs_attr_try_sf_addname(
  */
 int
 xfs_attr_set_args(
-	struct xfs_da_args	*args,
-	struct xfs_buf          **leaf_bp)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf          *leaf_bp = NULL;
 	int			error;
 
 	/*
@@ -255,7 +255,7 @@ xfs_attr_set_args(
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 		if (error)
 			return error;
 
@@ -264,22 +264,15 @@ xfs_attr_set_args(
 		 * concurrent AIL push cannot grab the half-baked leaf
 		 * buffer and run into problems with the write verifier.
 		 */
-		xfs_trans_bhold(args->trans, *leaf_bp);
+		xfs_trans_bhold(args->trans, leaf_bp);
 
 		error = xfs_defer_finish(&args->trans);
-		if (error)
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 
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
+		xfs_trans_bhold_release(args->trans, leaf_bp);
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -322,7 +315,6 @@ xfs_attr_set(
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_buf		*leaf_bp = NULL;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
@@ -381,9 +373,9 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp);
+	error = xfs_attr_set_args(&args);
 	if (error)
-		goto out_release_leaf;
+		goto out_trans_cancel;
 	if (!args.trans) {
 		/* shortform attribute has already been committed */
 		goto out_unlock;
@@ -408,9 +400,6 @@ xfs_attr_set(
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
-out_release_leaf:
-	if (leaf_bp)
-		xfs_trans_brelse(args.trans, leaf_bp);
 out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 2297d8467666..3b0dce06e454 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -140,7 +140,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
-int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
+int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 94f00427de98..1c6bf2105939 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -274,13 +274,15 @@ xfs_defer_trans_roll(
 
 	trace_xfs_defer_trans_roll(tp, _RET_IP_);
 
-	/* Roll the transaction. */
+	/*
+	 * Roll the transaction.  Rolling always given a new transaction (even
+	 * if committing the old one fails!) to hand back to the caller, so we
+	 * join the held resources to the new transaction so that we always
+	 * return with the held resources joined to @tpp, no matter what
+	 * happened.
+	 */
 	error = xfs_trans_roll(tpp);
 	tp = *tpp;
-	if (error) {
-		trace_xfs_defer_trans_roll_error(tp, error);
-		return error;
-	}
 
 	/* Rejoin the joined inodes. */
 	for (i = 0; i < ipcount; i++)
@@ -292,6 +294,8 @@ xfs_defer_trans_roll(
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
+	if (error)
+		trace_xfs_defer_trans_roll_error(tp, error);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 87e6dd5326d5..7f058120a921 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -359,9 +359,8 @@ xfs_dquot_disk_alloc(
 	 */
 	xfs_trans_bhold(tp, bp);
 	error = xfs_defer_finish(tpp);
-	tp = *tpp;
 	if (error) {
-		xfs_buf_relse(bp);
+		xfs_trans_brelse(*tpp, bp);
 		return error;
 	}
 	*bpp = bp;
@@ -521,7 +520,7 @@ xfs_qm_dqread_alloc(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
+	struct xfs_buf		*bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
@@ -529,24 +528,25 @@ xfs_qm_dqread_alloc(
 	if (error)
 		goto err;
 
+	/*
+	 * This function returns with the buffer held to the transaction, so
+	 * either we pass it back to our caller still locked or cancel the
+	 * transaction and unlock it manually if we're not passing it back.
+	 */
 	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
 	if (error)
 		goto err_cancel;
 
 	error = xfs_trans_commit(tp);
-	if (error) {
-		/*
-		 * Buffer was held to the transaction, so we have to unlock it
-		 * manually here because we're not passing it back.
-		 */
-		xfs_buf_relse(bp);
-		goto err;
-	}
+	if (error)
+		goto err_cancel;
 	*bpp = bp;
 	return 0;
 
 err_cancel:
 	xfs_trans_cancel(tp);
+	if (bp)
+		xfs_buf_relse(bp);
 err:
 	return error;
 }
