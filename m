Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54794 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012F3B9169015
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:58 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2pnxedxas7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:57 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012JqRJ025080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:52 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012JpvT007083
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:51 GMT
Subject: [PATCH 08/22] xfs: split inode allocation and initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:50 -0800
Message-ID: <154630919048.18437.3086128822464068437.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split new inode allocation and initialization into separate helpers.
Eventually we'll supply a force-reinitialization function so that
xfs_repair can use libxfs to reset the root directory and friends.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |  164 ++++++++++++++++++++++++++++------------------------
 1 file changed, 89 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 41fab97d1270..c053e1d422d5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -654,87 +654,19 @@ const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
 };
 
 /*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
+ * Initialize a newly allocated inode with the given arguments.  Heritable
+ * inode properties will be copied from the parent if one is supplied and the
+ * appropriate inode flags are set on the parent.
  */
-static int
-xfs_ialloc(
+STATIC void
+xfs_inode_init(
 	struct xfs_trans		*tp,
 	const struct xfs_ialloc_args	*args,
-	struct xfs_buf			**ialloc_context,
-	struct xfs_inode		**ipp)
+	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_inode		*pip = args->pip;
-	struct xfs_inode		*ip;
-	struct inode			*inode;
-	xfs_ino_t			ino;
+	struct inode			*inode = VFS_I(ip);
 	uint				flags;
-	int				error;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
-
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
-	 */
-	error = args->ops->iget(mp, tp, ino, &ip);
-	if (error)
-		return error;
-	ASSERT(ip != NULL);
-	inode = VFS_I(ip);
 
 	/*
 	 * We always convert v1 inodes to v2 now - we only support filesystems
@@ -884,7 +816,89 @@ xfs_ialloc(
 
 	/* now that we have an i_mode we can setup the inode structure */
 	args->ops->setup(ip);
+}
+
+/*
+ * Allocate an inode on disk and return a copy of its in-core version.
+ * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
+ * appropriately within the inode.  The uid and gid for the inode are
+ * set according to the contents of the given cred structure.
+ *
+ * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
+ * has a free inode available, call xfs_iget() to obtain the in-core
+ * version of the allocated inode.  Finally, fill in the inode and
+ * log its initial contents.  In this case, ialloc_context would be
+ * set to NULL.
+ *
+ * If xfs_dialloc() does not have an available inode, it will replenish
+ * its supply by doing an allocation. Since we can only do one
+ * allocation within a transaction without deadlocks, we must commit
+ * the current transaction before returning the inode itself.
+ * In this case, therefore, we will set ialloc_context and return.
+ * The caller should then commit the current transaction, start a new
+ * transaction, and call xfs_ialloc() again to actually get the inode.
+ *
+ * To ensure that some other process does not grab the inode that
+ * was allocated during the first call to xfs_ialloc(), this routine
+ * also returns the [locked] bp pointing to the head of the freelist
+ * as ialloc_context.  The caller should hold this buffer across
+ * the commit and pass it back into this routine on the second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode
+ * to attach to or associate with (i.e. pip == NULL) because they
+ * are not linked into the directory structure - they are attached
+ * directly to the superblock - and so have no parent.
+ */
+static int
+xfs_ialloc(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	/*
+	 * Call the space management code to pick
+	 * the on-disk inode to be allocated.
+	 */
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
+			    ialloc_context, &ino);
+	if (error)
+		return error;
+	if (*ialloc_context || ino == NULLFSINO) {
+		*ipp = NULL;
+		return 0;
+	}
+	ASSERT(*ialloc_context == NULL);
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Get the in-core inode with the lock held exclusively.
+	 * This is because we're setting fields here we need
+	 * to prevent others from looking at until we're done.
+	 */
+	error = args->ops->iget(mp, tp, ino, &ip);
+	if (error)
+		return error;
+	ASSERT(ip != NULL);
 
+	xfs_inode_init(tp, args, ip);
 	*ipp = ip;
 	return 0;
 }
