Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1DDO5rA052092 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 07:24:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054A22CC613
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 05:26:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wOCKeH9dzIrwC8Li for
	<xfs@oss.sgi.com>; Sun, 13 Feb 2011 05:26:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PobyM-0004mf-5Z
	for xfs@oss.sgi.com; Sun, 13 Feb 2011 13:26:42 +0000
Date: Sun, 13 Feb 2011 08:26:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: more sensible inode refcounting for ialloc
Message-ID: <20110213132642.GB18279@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently we return iodes from xfs_ialloc with just a single reference held.
But we need two references, as one is dropped during transaction commit and
the second needs to be transfered to the VFS.  Change xfs_ialloc to use
xfs_iget plus xfs_trans_ijoin_ref to grab two references to the inode,
and remove the now superflous IHOLD calls from all callers.  This also
greatly simplifies the error handling in xfs_create and also allow to remove
xfs_trans_iget as no other callers are left.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2011-01-26 19:36:57.859840167 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2011-01-26 19:39:26.000000000 +0100
@@ -1230,13 +1230,6 @@ xfs_qm_qino_alloc(
 	}
 
 	/*
-	 * Keep an extra reference to this quota inode. This inode is
-	 * locked exclusively and joined to the transaction already.
-	 */
-	ASSERT(xfs_isilocked(*ip, XFS_ILOCK_EXCL));
-	IHOLD(*ip);
-
-	/*
 	 * Make the changes in the superblock, and log those too.
 	 * sbfields arg may contain fields other than *QUOTINO;
 	 * VERSIONNUM for example.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-01-26 19:36:57.895840318 +0100
+++ xfs/fs/xfs/xfs_inode.c	2011-01-26 19:39:26.267840406 +0100
@@ -1016,8 +1016,8 @@ xfs_ialloc(
 	 * This is because we're setting fields here we need
 	 * to prevent others from looking at until we're done.
 	 */
-	error = xfs_trans_iget(tp->t_mountp, tp, ino,
-				XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
+	error = xfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE,
+			 XFS_ILOCK_EXCL, &ip);
 	if (error)
 		return error;
 	ASSERT(ip != NULL);
@@ -1166,6 +1166,7 @@ xfs_ialloc(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup inode ops and unlock */
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-01-26 19:36:57.907840533 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-01-26 19:41:49.491839927 +0100
@@ -1310,7 +1310,7 @@ xfs_create(
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
-		goto std_return;
+		return error;
 
 	if (is_dir) {
 		rdev = 0;
@@ -1390,12 +1390,6 @@ xfs_create(
 	}
 
 	/*
-	 * At this point, we've gotten a newly allocated inode.
-	 * It is locked (and joined to the transaction).
-	 */
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
 	 * earlier because xfs_dir_ialloc might commit the previous transaction
 	 * (and release all the locks).  An error from here on will result in
@@ -1440,22 +1434,13 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
 
-	/*
-	 * xfs_trans_commit normally decrements the vnode ref count
-	 * when it unlocks the inode. Since we want to return the
-	 * vnode to the caller, we bump the vnode ref count now.
-	 */
-	IHOLD(ip);
-
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
-		goto out_abort_rele;
+		goto out_bmap_cancel;
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (error) {
-		IRELE(ip);
-		goto out_dqrele;
-	}
+	if (error)
+		goto out_release_inode;
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -1469,27 +1454,21 @@ xfs_create(
 	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
- out_dqrele:
+ out_release_inode:
+	/*
+	 * Wait until after the current transaction is aborted to
+	 * release the inode.  This prevents recursive transactions
+	 * and deadlocks from xfs_inactive.
+	 */
+	if (ip)
+		IRELE(ip);
+
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
- std_return:
 	return error;
-
- out_abort_rele:
-	/*
-	 * Wait until after the current transaction is aborted to
-	 * release the inode.  This prevents recursive transactions
-	 * and deadlocks from xfs_inactive.
-	 */
-	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
-	xfs_trans_cancel(tp, cancel_flags);
-	IRELE(ip);
-	unlock_dp_on_error = B_FALSE;
-	goto out_dqrele;
 }
 
 #ifdef DEBUG
@@ -2114,9 +2093,8 @@ xfs_symlink(
 				  XFS_BMAPI_WRITE | XFS_BMAPI_METADATA,
 				  &first_block, resblks, mval, &nmaps,
 				  &free_list);
-		if (error) {
-			goto error1;
-		}
+		if (error)
+			goto error2;
 
 		if (resblks)
 			resblks -= fs_blocks;
@@ -2148,7 +2126,7 @@ xfs_symlink(
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error)
-		goto error1;
+		goto error2;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
@@ -2161,13 +2139,6 @@ xfs_symlink(
 		xfs_trans_set_sync(tp);
 	}
 
-	/*
-	 * xfs_trans_commit normally decrements the vnode ref count
-	 * when it unlocks the inode. Since we want to return the
-	 * vnode to the caller, we bump the vnode ref count now.
-	 */
-	IHOLD(ip);
-
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		goto error2;
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-01-26 19:39:37.362840058 +0100
+++ xfs/fs/xfs/xfs_trans.h	2011-01-26 19:41:49.503840367 +0100
@@ -469,8 +469,6 @@ void		xfs_trans_inode_buf(xfs_trans_t *,
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
-int		xfs_trans_iget(struct xfs_mount *, xfs_trans_t *,
-			       xfs_ino_t , uint, uint, struct xfs_inode **);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *);
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2011-01-26 19:39:46.683841024 +0100
+++ xfs/fs/xfs/xfs_trans_inode.c	2011-01-26 19:41:49.515840543 +0100
@@ -44,28 +44,6 @@ xfs_trans_inode_broot_debug(
 #endif
 
 /*
- * Get an inode and join it to the transaction.
- */
-int
-xfs_trans_iget(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	uint		flags,
-	uint		lock_flags,
-	xfs_inode_t	**ipp)
-{
-	int			error;
-
-	error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp);
-	if (!error && tp) {
-		xfs_trans_ijoin(tp, *ipp);
-		(*ipp)->i_itemp->ili_lock_flags = lock_flags;
-	}
-	return error;
-}
-
-/*
  * Add a locked inode to the transaction.
  *
  * The inode must be locked, and it cannot be associated with any transaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
