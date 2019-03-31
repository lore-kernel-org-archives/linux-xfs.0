Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54209 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbfCaOZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Mar 2019 10:25:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id q16so7445221wmj.3
        for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2019 07:25:43 -0700 (PDT)
From: Alex Lyakas <alex@zadara.com>
Subject: [STABLE PATCH 2/2] xfs: hold xfs_buf locked between shortform->leaf conversion and the addition of an attribute
Date: Sun, 31 Mar 2019 17:24:52 +0300
Message-Id: <1554042292-3381-1-git-send-email-alex@zadara.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de, shyam@zadara.com

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The new attribute leaf buffer is not held locked across the transaction
roll between the shortform->leaf modification and the addition of the
new entry.  As a result, the attribute buffer modification being made is
not atomic from an operational perspective.  Hence the AIL push can grab
it in the transient state of "just created" after the initial
transaction is rolled, because the buffer has been released.  This leads
to xfs_attr3_leaf_verify() asserting that hdr.count is zero, treating
this as in-memory corruption, and shutting down the filesystem.

Darrick ported the original patch to 4.15 and reworked it use the
xfs_defer_bjoin helper and hold/join the buffer correctly across the
second transaction roll.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Alex Lyakas <alex@zadara.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 20 +++++++++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ea66f04..e4265db 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -212,6 +212,7 @@
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*leaf_bp = NULL;
 	struct xfs_da_args	args;
 	struct xfs_defer_ops	dfops;
 	struct xfs_trans_res	tres;
@@ -327,9 +328,16 @@
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
 		xfs_defer_init(args.dfops, args.firstblock);
-		error = xfs_attr_shortform_to_leaf(&args);
+		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
 		if (error)
 			goto out_defer_cancel;
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+		xfs_trans_bhold(args.trans, leaf_bp);
+		xfs_defer_bjoin(args.dfops, leaf_bp);
 		xfs_defer_ijoin(args.dfops, dp);
 		error = xfs_defer_finish(&args.trans, args.dfops);
 		if (error)
@@ -337,13 +345,14 @@
 
 		/*
 		 * Commit the leaf transformation.  We'll need another (linked)
-		 * transaction to add the new attribute to the leaf.
+		 * transaction to add the new attribute to the leaf, which
+		 * means that we have to hold & join the leaf buffer here too.
 		 */
-
 		error = xfs_trans_roll_inode(&args.trans, dp);
 		if (error)
 			goto out;
-
+		xfs_trans_bjoin(args.trans, leaf_bp);
+		leaf_bp = NULL;
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -374,8 +383,9 @@
 
 out_defer_cancel:
 	xfs_defer_cancel(&dfops);
-	args.trans = NULL;
 out:
+	if (leaf_bp)
+		xfs_trans_brelse(args.trans, leaf_bp);
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 40e53a4..73a5417 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -739,10 +739,13 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 }
 
 /*
- * Convert from using the shortform to the leaf.
+ * Convert from using the shortform to the leaf.  On success, return the
+ * buffer so that we can keep it locked until we're totally done with it.
  */
 int
-xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
+xfs_attr_shortform_to_leaf(
+	struct xfs_da_args	*args,
+	struct xfs_buf		**leaf_bp)
 {
 	xfs_inode_t *dp;
 	xfs_attr_shortform_t *sf;
@@ -821,7 +824,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
 	}
 	error = 0;
-
+	*leaf_bp = bp;
 out:
 	kmem_free(tmpbuffer);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index f7dda0c..894124e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -48,7 +48,8 @@
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
-int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
+int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
+			struct xfs_buf **leaf_bp);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
-- 
1.9.1
