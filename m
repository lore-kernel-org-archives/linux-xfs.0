Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XGfN203855 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD9AE185E922
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iHJDnkjrn3GpBFsA for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLww-00035P-SJ
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:02 +0000
Message-Id: <20090126073202.764168000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/17] xfs: merge xfs_mkdir into xfs_create
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-merge-create
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_create and xfs_mkdir only have minor differences, so merge both of them
into a sigle function.  While we're at it also make the error handling code
more straight-forward.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-12-30 09:39:10.540493481 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-12-30 09:39:58.643618532 +0100
@@ -211,8 +211,13 @@ xfs_vn_mknod(
 	 * Irix uses Missed'em'V split, but doesn't want to see
 	 * the upper 5 bits of (14bit) major.
 	 */
-	if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
-		return -EINVAL;
+	if (S_ISCHR(mode) || S_ISBLK(mode)) {
+		if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
+			return -EINVAL;
+		rdev = sysv_encode_dev(rdev);
+	} else {
+		rdev = 0;
+	}
 
 	if (test_default_acl && test_default_acl(dir)) {
 		if (!_ACL_ALLOC(default_acl)) {
@@ -224,28 +229,11 @@ xfs_vn_mknod(
 		}
 	}
 
-	xfs_dentry_to_name(&name, dentry);
-
 	if (IS_POSIXACL(dir) && !default_acl)
 		mode &= ~current->fs->umask;
 
-	switch (mode & S_IFMT) {
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFIFO:
-	case S_IFSOCK:
-		rdev = sysv_encode_dev(rdev);
-	case S_IFREG:
-		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
-		break;
-	case S_IFDIR:
-		error = xfs_mkdir(XFS_I(dir), &name, mode, &ip, NULL);
-		break;
-	default:
-		error = EINVAL;
-		break;
-	}
-
+	xfs_dentry_to_name(&name, dentry);
+	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
 	if (unlikely(error))
 		goto out_free_acl;
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2008-12-30 09:39:53.860619009 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2008-12-30 09:39:58.648648223 +0100
@@ -1387,23 +1387,28 @@ xfs_create(
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_inode_t		*ip;
-	xfs_trans_t		*tp;
+	int			is_dir = S_ISDIR(mode);
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp = NULL;
 	int			error;
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
 	boolean_t		unlock_dp_on_error = B_FALSE;
-	int			dm_event_sent = 0;
 	uint			cancel_flags;
 	int			committed;
 	xfs_prid_t		prid;
-	struct xfs_dquot	*udqp, *gdqp;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
 	uint			resblks;
+	uint			log_res;
+	uint			log_count;
 
-	ASSERT(!*ipp);
 	xfs_itrace_entry(dp);
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 				dp, DM_RIGHT_NULL, NULL,
@@ -1412,84 +1417,97 @@ xfs_create(
 
 		if (error)
 			return error;
-		dm_event_sent = 1;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	/* Return through std_return after this point. */
-
-	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
 	else
-		prid = (xfs_prid_t)dfltprid;
+		prid = dfltprid;
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
 			current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL|XFS_QMOPT_INHERIT, &udqp, &gdqp);
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
 
-	ip = NULL;
+	if (is_dir) {
+		rdev = 0;
+		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		log_res = XFS_MKDIR_LOG_RES(mp);
+		log_count = XFS_MKDIR_LOG_COUNT;
+		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
+	} else {
+		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		log_res = XFS_CREATE_LOG_RES(mp);
+		log_count = XFS_CREATE_LOG_COUNT;
+		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
+	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, resblks, log_res, 0,
+			XFS_TRANS_PERM_LOG_RES, log_count);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_CREATE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, 0, log_res, 0,
+				XFS_TRANS_PERM_LOG_RES, log_count);
 	}
 	if (error) {
 		cancel_flags = 0;
-		goto error_return;
+		goto out_trans_cancel;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = B_TRUE;
 
-	xfs_bmap_init(&free_list, &first_block);
+	/*
+	 * Check for directory link count overflow.
+	 */
+	if (is_dir && dp->i_d.di_nlink >= XFS_MAXLINK) {
+		error = XFS_ERROR(EMLINK);
+		goto out_trans_cancel;
+	}
 
-	ASSERT(ip == NULL);
+	xfs_bmap_init(&free_list, &first_block);
 
 	/*
 	 * Reserve disk quota and the inode.
 	 */
 	error = XFS_TRANS_RESERVE_QUOTA(mp, tp, udqp, gdqp, resblks, 1, 0);
 	if (error)
-		goto error_return;
+		goto out_trans_cancel;
 
 	error = xfs_dir_canenter(tp, dp, name, resblks);
 	if (error)
-		goto error_return;
-	error = xfs_dir_ialloc(&tp, dp, mode, 1,
-			rdev, credp, prid, resblks > 0,
-			&ip, &committed);
+		goto out_trans_cancel;
+
+	/*
+	 * A newly created regular or special file just has one directory
+	 * entry pointing to them, but a directory also the "." entry
+	 * pointing to itself.
+	 */
+	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, credp,
+			       prid, resblks > 0, &ip, &committed);
 	if (error) {
 		if (error == ENOSPC)
-			goto error_return;
-		goto abort_return;
+			goto out_trans_cancel;
+		goto out_trans_abort;
 	}
-	xfs_itrace_ref(ip);
 
 	/*
 	 * At this point, we've gotten a newly allocated inode.
 	 * It is locked (and joined to the transaction).
 	 */
-
+	xfs_itrace_ref(ip);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
@@ -1508,19 +1526,28 @@ xfs_create(
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
 		ASSERT(error != ENOSPC);
-		goto abort_return;
+		goto out_trans_abort;
 	}
 	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (is_dir) {
+		error = xfs_dir_init(tp, ip, dp);
+		if (error)
+			goto out_bmap_cancel;
+
+		error = xfs_bumplink(tp, dp);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
+	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
-	}
 
 	/*
 	 * Attach the dquot(s) to the inodes and modify them incore.
@@ -1537,16 +1564,13 @@ xfs_create(
 	IHOLD(ip);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		xfs_bmap_cancel(&free_list);
-		goto abort_rele;
-	}
+	if (error)
+		goto out_abort_rele;
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error) {
 		IRELE(ip);
-		tp = NULL;
-		goto error_return;
+		goto out_dqrele;
 	}
 
 	XFS_QM_DQRELE(mp, udqp);
@@ -1555,26 +1579,22 @@ xfs_create(
 	*ipp = ip;
 
 	/* Fallthrough to std_return with error = 0  */
-
-std_return:
-	if ((*ipp || (error != 0 && dm_event_sent != 0)) &&
-	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
-			dp, DM_RIGHT_NULL,
-			*ipp ? ip : NULL,
-			DM_RIGHT_NULL, name->name, NULL,
-			mode, error, 0);
+ std_return:
+	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
+		XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE, dp, DM_RIGHT_NULL,
+				ip, DM_RIGHT_NULL, name->name, NULL, mode,
+				error, 0);
 	}
+
 	return error;
 
- abort_return:
+ out_bmap_cancel:
+	xfs_bmap_cancel(&free_list);
+ out_trans_abort:
 	cancel_flags |= XFS_TRANS_ABORT;
-	/* FALLTHROUGH */
-
- error_return:
-	if (tp != NULL)
-		xfs_trans_cancel(tp, cancel_flags);
-
+ out_trans_cancel:
+	xfs_trans_cancel(tp, cancel_flags);
+ out_dqrele:
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
@@ -1583,20 +1603,18 @@ std_return:
 
 	goto std_return;
 
- abort_rele:
+ out_abort_rele:
 	/*
 	 * Wait until after the current transaction is aborted to
 	 * release the inode.  This prevents recursive transactions
 	 * and deadlocks from xfs_inactive.
 	 */
+	xfs_bmap_cancel(&free_list);
 	cancel_flags |= XFS_TRANS_ABORT;
 	xfs_trans_cancel(tp, cancel_flags);
 	IRELE(ip);
-
-	XFS_QM_DQRELE(mp, udqp);
-	XFS_QM_DQRELE(mp, gdqp);
-
-	goto std_return;
+	unlock_dp_on_error = B_FALSE;
+	goto out_dqrele;
 }
 
 #ifdef DEBUG
@@ -2112,209 +2130,6 @@ std_return:
 	goto std_return;
 }
 
-
-int
-xfs_mkdir(
-	xfs_inode_t             *dp,
-	struct xfs_name		*dir_name,
-	mode_t			mode,
-	xfs_inode_t		**ipp,
-	cred_t			*credp)
-{
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_inode_t		*cdp;	/* inode of created dir */
-	xfs_trans_t		*tp;
-	int			cancel_flags;
-	int			error;
-	int			committed;
-	xfs_bmap_free_t         free_list;
-	xfs_fsblock_t           first_block;
-	boolean_t		unlock_dp_on_error = B_FALSE;
-	boolean_t		created = B_FALSE;
-	int			dm_event_sent = 0;
-	xfs_prid_t		prid;
-	struct xfs_dquot	*udqp, *gdqp;
-	uint			resblks;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	tp = NULL;
-
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
-					dp, DM_RIGHT_NULL, NULL,
-					DM_RIGHT_NULL, dir_name->name, NULL,
-					mode, 0, 0);
-		if (error)
-			return error;
-		dm_event_sent = 1;
-	}
-
-	/* Return through std_return after this point. */
-
-	xfs_itrace_entry(dp);
-
-	mp = dp->i_mount;
-	udqp = gdqp = NULL;
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = dp->i_d.di_projid;
-	else
-		prid = (xfs_prid_t)dfltprid;
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.
-	 */
-	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
-	if (error)
-		goto std_return;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	resblks = XFS_MKDIR_SPACE_RES(mp, dir_name->len);
-	error = xfs_trans_reserve(tp, resblks, XFS_MKDIR_LOG_RES(mp), 0,
-				  XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT);
-	if (error == ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_MKDIR_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_MKDIR_LOG_COUNT);
-	}
-	if (error) {
-		cancel_flags = 0;
-		goto error_return;
-	}
-
-	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
-	unlock_dp_on_error = B_TRUE;
-
-	/*
-	 * Check for directory link count overflow.
-	 */
-	if (dp->i_d.di_nlink >= XFS_MAXLINK) {
-		error = XFS_ERROR(EMLINK);
-		goto error_return;
-	}
-
-	/*
-	 * Reserve disk quota and the inode.
-	 */
-	error = XFS_TRANS_RESERVE_QUOTA(mp, tp, udqp, gdqp, resblks, 1, 0);
-	if (error)
-		goto error_return;
-
-	error = xfs_dir_canenter(tp, dp, dir_name, resblks);
-	if (error)
-		goto error_return;
-	/*
-	 * create the directory inode.
-	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, 2,
-			0, credp, prid, resblks > 0,
-		&cdp, NULL);
-	if (error) {
-		if (error == ENOSPC)
-			goto error_return;
-		goto abort_return;
-	}
-	xfs_itrace_ref(cdp);
-
-	/*
-	 * Now we add the directory inode to the transaction.
-	 * We waited until now since xfs_dir_ialloc might start
-	 * a new transaction.  Had we joined the transaction
-	 * earlier, the locks might have gotten released. An error
-	 * from here on will result in the transaction cancel
-	 * unlocking dp so don't do it explicitly in the error path.
-	 */
-	IHOLD(dp);
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = B_FALSE;
-
-	xfs_bmap_init(&free_list, &first_block);
-
-	error = xfs_dir_createname(tp, dp, dir_name, cdp->i_ino,
-					&first_block, &free_list, resblks ?
-					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
-	if (error) {
-		ASSERT(error != ENOSPC);
-		goto error1;
-	}
-	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	error = xfs_dir_init(tp, cdp, dp);
-	if (error)
-		goto error2;
-
-	error = xfs_bumplink(tp, dp);
-	if (error)
-		goto error2;
-
-	created = B_TRUE;
-
-	*ipp = cdp;
-	IHOLD(cdp);
-
-	/*
-	 * Attach the dquots to the new inode and modify the icount incore.
-	 */
-	XFS_QM_DQVOPCREATE(mp, tp, cdp, udqp, gdqp);
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * mkdir transaction goes to disk before returning to
-	 * the user.
-	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
-		xfs_trans_set_sync(tp);
-	}
-
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		IRELE(cdp);
-		goto error2;
-	}
-
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	XFS_QM_DQRELE(mp, udqp);
-	XFS_QM_DQRELE(mp, gdqp);
-	if (error) {
-		IRELE(cdp);
-	}
-
-	/* Fall through to std_return with error = 0 or errno from
-	 * xfs_trans_commit. */
-
-std_return:
-	if ((created || (error != 0 && dm_event_sent != 0)) &&
-	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
-					dp, DM_RIGHT_NULL,
-					created ? cdp : NULL,
-					DM_RIGHT_NULL,
-					dir_name->name, NULL,
-					mode, error, 0);
-	}
-	return error;
-
- error2:
- error1:
-	xfs_bmap_cancel(&free_list);
- abort_return:
-	cancel_flags |= XFS_TRANS_ABORT;
- error_return:
-	xfs_trans_cancel(tp, cancel_flags);
-	XFS_QM_DQRELE(mp, udqp);
-	XFS_QM_DQRELE(mp, gdqp);
-
-	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-	goto std_return;
-}
-
 int
 xfs_symlink(
 	xfs_inode_t		*dp,
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2008-12-30 09:40:04.508493447 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2008-12-30 09:40:24.893621257 +0100
@@ -31,8 +31,6 @@ int xfs_remove(struct xfs_inode *dp, str
 		struct xfs_inode *ip);
 int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 		struct xfs_name *target_name);
-int xfs_mkdir(struct xfs_inode *dp, struct xfs_name *dir_name,
-		mode_t mode, struct xfs_inode **ipp, cred_t *credp);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
