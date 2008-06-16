Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 23:17:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G6Hsnm016391
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:17:55 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BB191BA25DF
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:18:49 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id m3rVx5Ea4o5wQF1C for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:18:49 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5G6IdNW005401
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 08:18:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5G6Idum005399
	for xfs@oss.sgi.com; Mon, 16 Jun 2008 08:18:39 +0200
Date: Mon, 16 Jun 2008 08:18:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] merge xfs_rmdir into xfs_remove
Message-ID: <20080616061839.GA5230@lst.de>
References: <20080502105757.GB17870@lst.de> <20080521082548.GB3215@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521082548.GB3215@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, May 21, 2008 at 10:25:48AM +0200, Christoph Hellwig wrote:
> On Fri, May 02, 2008 at 12:57:57PM +0200, Christoph Hellwig wrote:
> > xfs_remove and xfs_rmdir are almost the same with a little more work
> > performed in xfs_rmdir due to the . and .. entries.  This patch merges
> > xfs_rmdir into xfs_remove and performs these actions conditionally.
> > 
> > Also clean up the error handling which was a nightmare in both versions
> > before.
> 
> Updated for the case-insensitive filename changes.

And another update for the d_invalidate added on unlink/rmdir.

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-06-16 08:11:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-06-16 08:14:16.000000000 +0200
@@ -2116,13 +2116,6 @@ again:
 #endif
 }
 
-#ifdef	DEBUG
-#define	REMOVE_DEBUG_TRACE(x)	{remove_which_error_return = (x);}
-int remove_which_error_return = 0;
-#else /* ! DEBUG */
-#define	REMOVE_DEBUG_TRACE(x)
-#endif	/* ! DEBUG */
-
 int
 xfs_remove(
 	xfs_inode_t             *dp,
@@ -2131,6 +2124,7 @@ xfs_remove(
 {
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
+	int			is_dir = S_ISDIR(ip->i_d.di_mode);
 	int                     error = 0;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
@@ -2138,8 +2132,11 @@ xfs_remove(
 	int			committed;
 	int			link_zero;
 	uint			resblks;
+	uint			trans;
+	uint			log_count;
 
 	xfs_itrace_entry(dp);
+	xfs_itrace_entry(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2152,19 +2149,25 @@ xfs_remove(
 			return error;
 	}
 
-	xfs_itrace_entry(ip);
-	xfs_itrace_ref(ip);
-
 	error = XFS_QM_DQATTACH(mp, dp, 0);
-	if (!error)
-		error = XFS_QM_DQATTACH(mp, ip, 0);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
+	if (error)
+		goto std_return;
+
+	error = XFS_QM_DQATTACH(mp, ip, 0);
+	if (error)
 		goto std_return;
+
+	if (is_dir) {
+		trans = XFS_TRANS_RMDIR;
+		log_count = XFS_DEFAULT_LOG_COUNT;
+	} else {
+		trans = XFS_TRANS_REMOVE;
+		log_count = XFS_REMOVE_LOG_COUNT;
 	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_REMOVE);
+	tp = xfs_trans_alloc(mp, trans);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+
 	/*
 	 * We try to get the real space reservation first,
 	 * allowing for directory btree deletion(s) implying
@@ -2176,25 +2179,21 @@ xfs_remove(
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
 	error = xfs_trans_reserve(tp, resblks, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+				  XFS_TRANS_PERM_LOG_RES, log_count);
 	if (error == ENOSPC) {
 		resblks = 0;
 		error = xfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+					  XFS_TRANS_PERM_LOG_RES, log_count);
 	}
 	if (error) {
 		ASSERT(error != ENOSPC);
-		REMOVE_DEBUG_TRACE(__LINE__);
-		xfs_trans_cancel(tp, 0);
-		return error;
+		cancel_flags = 0;
+		goto out_trans_cancel;
 	}
 
 	error = xfs_lock_dir_and_entry(dp, ip);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		xfs_trans_cancel(tp, cancel_flags);
-		goto std_return;
-	}
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * At this point, we've gotten both the directory and the entry
@@ -2207,6 +2206,21 @@ xfs_remove(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
+	 * If we're removing a directory perform some additional validation.
+	 */
+	if (is_dir) {
+		ASSERT(ip->i_d.di_nlink >= 2);
+		if (ip->i_d.di_nlink != 2) {
+			error = XFS_ERROR(ENOTEMPTY);
+			goto out_trans_cancel;
+		}
+		if (!xfs_dir_isempty(ip)) {
+			error = XFS_ERROR(ENOTEMPTY);
+			goto out_trans_cancel;
+		}
+	}
+
+	/*
 	 * Entry must exist since we did a lookup in xfs_lock_dir_and_entry.
 	 */
 	XFS_BMAP_INIT(&free_list, &first_block);
@@ -2214,39 +2228,64 @@ xfs_remove(
 					&first_block, &free_list, resblks);
 	if (error) {
 		ASSERT(error != ENOENT);
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto error1;
+		goto out_bmap_cancel;
 	}
 	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
+	/*
+	 * Bump the in memory generation count on the parent
+	 * directory so that other can know that it has changed.
+	 */
 	dp->i_gen++;
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
-	error = xfs_droplink(tp, ip);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto error1;
+	if (is_dir) {
+		/*
+		 * Drop the link from ip's "..".
+		 */
+		error = xfs_droplink(tp, dp);
+		if (error)
+			goto out_bmap_cancel;
+
+		/*
+		 * Drop the link from dp to ip.
+		 */
+		error = xfs_droplink(tp, ip);
+		if (error)
+			goto out_bmap_cancel;
+	} else {
+		/*
+		 * When removing a non-directory we need to log the parent
+		 * inode here for the i_gen update.  For a directory this is
+		 * done implicitly by the xfs_droplink call for the ".." entry.
+		 */
+		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
 
-	/* Determine if this is the last link while
+	/*
+	 * Drop the "." link from ip to self.
+	 */
+	error = xfs_droplink(tp, ip);
+	if (error)
+		goto out_bmap_cancel;
+
+	/*
+	 * Determine if this is the last link while
 	 * we are in the transaction.
 	 */
-	link_zero = (ip)->i_d.di_nlink==0;
+	link_zero = (ip->i_d.di_nlink == 0);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
+	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
-	}
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto error_rele;
-	}
+	if (error)
+		goto out_bmap_cancel;
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error)
@@ -2258,39 +2297,27 @@ xfs_remove(
 	 * will get killed on last close in xfs_close() so we don't
 	 * have to worry about that.
 	 */
-	if (link_zero && xfs_inode_is_filestream(ip))
+	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
 	xfs_itrace_exit(ip);
+	xfs_itrace_exit(dp);
 
-/*	Fall through to std_return with error = 0 */
  std_return:
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
-				dp, DM_RIGHT_NULL,
-				NULL, DM_RIGHT_NULL,
-				name->name, NULL, ip->i_d.di_mode, error, 0);
+		XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE, dp, DM_RIGHT_NULL,
+				NULL, DM_RIGHT_NULL, name->name, NULL,
+				ip->i_d.di_mode, error, 0);
 	}
+
 	return error;
 
- error1:
+ out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 	cancel_flags |= XFS_TRANS_ABORT;
+ out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
 	goto std_return;
-
- error_rele:
-	/*
-	 * In this case make sure to not release the inode until after
-	 * the current transaction is aborted.  Releasing it beforehand
-	 * can cause us to go to xfs_inactive and start a recursive
-	 * transaction which can easily deadlock with the current one.
-	 */
-	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
-	xfs_trans_cancel(tp, cancel_flags);
-
-	goto std_return;
 }
 
 int
@@ -2656,186 +2683,6 @@ std_return:
 }
 
 int
-xfs_rmdir(
-	xfs_inode_t             *dp,
-	struct xfs_name		*name,
-	xfs_inode_t		*cdp)
-{
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp;
-	int                     error;
-	xfs_bmap_free_t         free_list;
-	xfs_fsblock_t           first_block;
-	int			cancel_flags;
-	int			committed;
-	int			last_cdp_link;
-	uint			resblks;
-
-	xfs_itrace_entry(dp);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
-					dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL, name->name,
-					NULL, cdp->i_d.di_mode, 0, 0);
-		if (error)
-			return XFS_ERROR(error);
-	}
-
-	/*
-	 * Get the dquots for the inodes.
-	 */
-	error = XFS_QM_DQATTACH(mp, dp, 0);
-	if (!error)
-		error = XFS_QM_DQATTACH(mp, cdp, 0);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto std_return;
-	}
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_RMDIR);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
-	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_reserve(tp, resblks, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_DEFAULT_LOG_COUNT);
-	if (error == ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_DEFAULT_LOG_COUNT);
-	}
-	if (error) {
-		ASSERT(error != ENOSPC);
-		cancel_flags = 0;
-		goto error_return;
-	}
-	XFS_BMAP_INIT(&free_list, &first_block);
-
-	/*
-	 * Now lock the child directory inode and the parent directory
-	 * inode in the proper order.  This will take care of validating
-	 * that the directory entry for the child directory inode has
-	 * not changed while we were obtaining a log reservation.
-	 */
-	error = xfs_lock_dir_and_entry(dp, cdp);
-	if (error) {
-		xfs_trans_cancel(tp, cancel_flags);
-		goto std_return;
-	}
-
-	IHOLD(dp);
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-
-	IHOLD(cdp);
-	xfs_trans_ijoin(tp, cdp, XFS_ILOCK_EXCL);
-
-	ASSERT(cdp->i_d.di_nlink >= 2);
-	if (cdp->i_d.di_nlink != 2) {
-		error = XFS_ERROR(ENOTEMPTY);
-		goto error_return;
-	}
-	if (!xfs_dir_isempty(cdp)) {
-		error = XFS_ERROR(ENOTEMPTY);
-		goto error_return;
-	}
-
-	error = xfs_dir_removename(tp, dp, name, cdp->i_ino,
-					&first_block, &free_list, resblks);
-	if (error)
-		goto error1;
-
-	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	/*
-	 * Bump the in memory generation count on the parent
-	 * directory so that other can know that it has changed.
-	 */
-	dp->i_gen++;
-
-	/*
-	 * Drop the link from cdp's "..".
-	 */
-	error = xfs_droplink(tp, dp);
-	if (error) {
-		goto error1;
-	}
-
-	/*
-	 * Drop the link from dp to cdp.
-	 */
-	error = xfs_droplink(tp, cdp);
-	if (error) {
-		goto error1;
-	}
-
-	/*
-	 * Drop the "." link from cdp to self.
-	 */
-	error = xfs_droplink(tp, cdp);
-	if (error) {
-		goto error1;
-	}
-
-	/* Determine these before committing transaction */
-	last_cdp_link = (cdp)->i_d.di_nlink==0;
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * rmdir transaction goes to disk before returning to
-	 * the user.
-	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
-		xfs_trans_set_sync(tp);
-	}
-
-	error = xfs_bmap_finish (&tp, &free_list, &committed);
-	if (error) {
-		xfs_bmap_cancel(&free_list);
-		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
-				 XFS_TRANS_ABORT));
-		goto std_return;
-	}
-
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (error) {
-		goto std_return;
-	}
-
-
-	/* Fall through to std_return with error = 0 or the errno
-	 * from xfs_trans_commit. */
- std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
-					dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL,
-					name->name, NULL, cdp->i_d.di_mode,
-					error, 0);
-	}
-	return error;
-
- error1:
-	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
-	/* FALLTHROUGH */
-
- error_return:
-	xfs_trans_cancel(tp, cancel_flags);
-	goto std_return;
-}
-
-int
 xfs_symlink(
 	xfs_inode_t		*dp,
 	struct xfs_name		*link_name,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-06-16 08:14:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-06-16 08:15:00.000000000 +0200
@@ -252,8 +252,7 @@ STATIC void
 xfs_cleanup_inode(
 	struct inode	*dir,
 	struct inode	*inode,
-	struct dentry	*dentry,
-	int		mode)
+	struct dentry	*dentry)
 {
 	struct xfs_name	teardown;
 
@@ -264,10 +263,7 @@ xfs_cleanup_inode(
 	 */
 	xfs_dentry_to_name(&teardown, dentry);
 
-	if (S_ISDIR(mode))
-		xfs_rmdir(XFS_I(dir), &teardown, XFS_I(inode));
-	else
-		xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
+	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
 	iput(inode);
 }
 
@@ -349,7 +345,7 @@ xfs_vn_mknod(
 	return -error;
 
  out_cleanup_inode:
-	xfs_cleanup_inode(dir, inode, dentry, mode);
+	xfs_cleanup_inode(dir, inode, dentry);
  out_free_acl:
 	if (default_acl)
 		_ACL_FREE(default_acl);
@@ -525,38 +521,12 @@ xfs_vn_symlink(
 	return 0;
 
  out_cleanup_inode:
-	xfs_cleanup_inode(dir, inode, dentry, 0);
+	xfs_cleanup_inode(dir, inode, dentry);
  out:
 	return -error;
 }
 
 STATIC int
-xfs_vn_rmdir(
-	struct inode	*dir,
-	struct dentry	*dentry)
-{
-	struct inode	*inode = dentry->d_inode;
-	struct xfs_name	name;
-	int		error;
-
-	xfs_dentry_to_name(&name, dentry);
-
-	error = xfs_rmdir(XFS_I(dir), &name, XFS_I(inode));
-	if (likely(!error)) {
-		xfs_validate_fields(inode);
-		xfs_validate_fields(dir);
-		/*
-		 * With rmdir, the VFS makes the dentry "negative": no inode,
-		 * but still hashed. This is incompatible with case-insensitive
-		 * mode, so invalidate (unhash) the dentry in CI-mode.
-		 */
-		if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
-			d_invalidate(dentry);
-	}
-	return -error;
-}
-
-STATIC int
 xfs_vn_rename(
 	struct inode	*odir,
 	struct dentry	*odentry,
@@ -850,7 +820,13 @@ static const struct inode_operations xfs
 	.unlink			= xfs_vn_unlink,
 	.symlink		= xfs_vn_symlink,
 	.mkdir			= xfs_vn_mkdir,
-	.rmdir			= xfs_vn_rmdir,
+	/*
+	 * Yes, XFS uses the same method for rmdir and unlink.
+	 *
+	 * There are some subtile differences deeper in the code,
+	 * but we use S_ISDIR to check for those.
+	 */
+	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
 	.permission		= xfs_vn_permission,
@@ -869,7 +845,13 @@ static const struct inode_operations xfs
 	.unlink			= xfs_vn_unlink,
 	.symlink		= xfs_vn_symlink,
 	.mkdir			= xfs_vn_mkdir,
-	.rmdir			= xfs_vn_rmdir,
+	/*
+	 * Yes, XFS uses the same method for rmdir and unlink.
+	 *
+	 * There are some subtile differences deeper in the code,
+	 * but we use S_ISDIR to check for those.
+	 */
+	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
 	.permission		= xfs_vn_permission,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-06-16 08:11:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-06-16 08:14:16.000000000 +0200
@@ -31,8 +31,6 @@ int xfs_link(struct xfs_inode *tdp, stru
 		struct xfs_name *target_name);
 int xfs_mkdir(struct xfs_inode *dp, struct xfs_name *dir_name,
 		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
-int xfs_rmdir(struct xfs_inode *dp, struct xfs_name *name,
-		struct xfs_inode *cdp);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
