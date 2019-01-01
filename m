Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EEYF173608
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:06 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx438-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012K5os025742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:06 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012K59Y027310
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:05 GMT
Subject: [PATCH 10/22] xfs: push xfs_ialloc_args creation out of
 xfs_dir_ialloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:03 -0800
Message-ID: <154630920312.18437.2650440061747886863.stgit@magnolia>
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

Move the initialization of the xfs_ialloc_args structure out of
xfs_dir_ialloc into its callers' callers so that we can set the new
inode's parameters in one place and pass it through instead of open
coding the new uid/gid/prid all over the code.  This also prepares us
for moving xfs_dir_ialloc and xfs_create to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c   |  127 ++++++++++++++++++++++----------------------------
 fs/xfs/xfs_inode.h   |   10 ++--
 fs/xfs/xfs_iops.c    |   45 +++++++++++-------
 fs/xfs/xfs_qm.c      |    7 ++-
 fs/xfs/xfs_symlink.c |   18 ++++---
 5 files changed, 108 insertions(+), 99 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 28d794300cdd..e6fda8777fe1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -665,33 +665,16 @@ const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
  */
 int
 xfs_dir_ialloc(
-	xfs_trans_t	**tpp,		/* input: current transaction;
-					   output: may be a new transaction. */
-	xfs_inode_t	*dp,		/* directory within whose allocate
-					   the inode. */
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	dev_t		rdev,
-	prid_t		prid,		/* project id */
-	xfs_inode_t	**ipp)		/* pointer to inode; it will be
-					   locked. */
+	struct xfs_trans		**tpp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
 {
-	struct xfs_ialloc_args	args = {
-		.ops	= &xfs_default_ialloc_ops,
-		.pip	= dp,
-		.uid	= xfs_kuid_to_uid(current_fsuid()),
-		.gid	= xfs_kgid_to_gid(current_fsgid()),
-		.prid	= prid,
-		.nlink	= nlink,
-		.rdev	= rdev,
-		.mode	= mode,
-	};
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
-	int		code;
-	void		*dqinfo;
-	uint		tflags;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	struct xfs_buf			*ialloc_context = NULL;
+	void				*dqinfo;
+	uint				tflags;
+	int				code;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -711,7 +694,7 @@ xfs_dir_ialloc(
 	 * transaction commit so that no other process can steal
 	 * the inode(s) that we've just allocated.
 	 */
-	code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
+	code = xfs_ialloc(tp, args, &ialloc_context, &ip);
 
 	/*
 	 * Return an error if we were unable to allocate a new inode.
@@ -780,7 +763,7 @@ xfs_dir_ialloc(
 		 * other allocations in this allocation group,
 		 * this call should always succeed.
 		 */
-		code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
+		code = xfs_ialloc(tp, args, &ialloc_context, &ip);
 
 		/*
 		 * If we get an error at this point, return to the caller
@@ -840,37 +823,33 @@ xfs_bumplink(
 
 int
 xfs_create(
-	xfs_inode_t		*dp,
-	struct xfs_name		*name,
-	umode_t			mode,
-	dev_t			rdev,
-	xfs_inode_t		**ipp)
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
 {
-	int			is_dir = S_ISDIR(mode);
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_inode	*ip = NULL;
-	struct xfs_trans	*tp = NULL;
-	int			error;
-	bool                    unlock_dp_on_error = false;
-	prid_t			prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
-	uint			resblks;
-
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	struct xfs_trans_res		*tres;
+	uint				resblks;
+	bool				unlock_dp_on_error = false;
+	bool				is_dir = S_ISDIR(args->mode);
+	int				error;
+
+	ASSERT(args->pip == dp);
 	trace_xfs_create(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(&dp->i_d);
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-					xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
 	if (error)
@@ -916,7 +895,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
+	error = xfs_dir_ialloc(&tp, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1000,31 +979,30 @@ xfs_create(
 
 int
 xfs_create_tmpfile(
-	struct xfs_inode	*dp,
-	umode_t			mode,
-	struct xfs_inode	**ipp)
+	struct xfs_inode		*dp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
 {
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_inode	*ip = NULL;
-	struct xfs_trans	*tp = NULL;
-	int			error;
-	prid_t                  prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
-	uint			resblks;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	struct xfs_trans_res		*tres;
+	uint				resblks;
+	int				error;
+
+	ASSERT(args->nlink == 1);
+	ASSERT(args->pip == dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(&dp->i_d);
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 				&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1042,7 +1020,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
+	error = xfs_dir_ialloc(&tp, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2687,10 +2665,19 @@ xfs_rename_alloc_whiteout(
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
+	struct xfs_ialloc_args	args = {
+		.ops	= &xfs_default_ialloc_ops,
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= xfs_get_initial_prid(&dp->i_d),
+		.nlink	= 1,
+		.mode	= S_IFCHR | WHITEOUT_MODE,
+	};
 	struct xfs_inode	*tmpfile;
 	int			error;
 
-	error = xfs_create_tmpfile(dp, S_IFCHR | WHITEOUT_MODE, &tmpfile);
+	error = xfs_create_tmpfile(dp, &args, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fb55e3b74b34..08aa747d07cf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -386,8 +386,10 @@ void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
-			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
+			   const struct xfs_ialloc_args *iargs,
+			   struct xfs_inode **ipp);
+int		xfs_create_tmpfile(struct xfs_inode *dp,
+			   const struct xfs_ialloc_args *iargs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
@@ -419,8 +421,8 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
-			       xfs_nlink_t, dev_t, prid_t,
+int		xfs_dir_ialloc(struct xfs_trans **,
+			       const struct xfs_ialloc_args *,
 			       struct xfs_inode **);
 
 static inline int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1081dd376f86..2ea77189bc9f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -130,42 +130,53 @@ xfs_cleanup_inode(
 
 STATIC int
 xfs_generic_create(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	umode_t		mode,
-	dev_t		rdev,
-	bool		tmpfile)	/* unnamed file */
+	struct inode		*dir,
+	struct dentry		*dentry,
+	umode_t			mode,
+	dev_t			rdev,
+	bool			tmpfile)	/* unnamed file */
 {
-	struct inode	*inode;
-	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl, *acl;
-	struct xfs_name	name;
-	int		error;
+	struct xfs_ialloc_args args = {
+		.ops		= &xfs_default_ialloc_ops,
+		.pip		= XFS_I(dir),
+		.uid		= xfs_kuid_to_uid(current_fsuid()),
+		.gid		= xfs_kgid_to_gid(current_fsgid()),
+		.prid		= xfs_get_initial_prid(&XFS_I(dir)->i_d),
+		.nlink		= S_ISDIR(mode) ? 2 : 1,
+		.rdev		= rdev,
+		.mode		= mode,
+	};
+	struct inode		*inode;
+	struct xfs_inode	*ip = NULL;
+	struct posix_acl	*default_acl, *acl;
+	struct xfs_name		name;
+	int			error;
 
 	/*
 	 * Irix uses Missed'em'V split, but doesn't want to see
 	 * the upper 5 bits of (14bit) major.
 	 */
-	if (S_ISCHR(mode) || S_ISBLK(mode)) {
-		if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
+	if (S_ISCHR(args.mode) || S_ISBLK(args.mode)) {
+		if (unlikely(!sysv_valid_dev(args.rdev) ||
+			     MAJOR(args.rdev) & ~0x1ff))
 			return -EINVAL;
 	} else {
-		rdev = 0;
+		args.rdev = 0;
 	}
 
-	error = posix_acl_create(dir, &mode, &default_acl, &acl);
+	error = posix_acl_create(dir, &args.mode, &default_acl, &acl);
 	if (error)
 		return error;
 
 	/* Verify mode is valid also for tmpfile case */
-	error = xfs_dentry_mode_to_name(&name, dentry, mode);
+	error = xfs_dentry_mode_to_name(&name, dentry, args.mode);
 	if (unlikely(error))
 		goto out_free_acl;
 
 	if (!tmpfile) {
-		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
+		error = xfs_create(XFS_I(dir), &name, &args, &ip);
 	} else {
-		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(XFS_I(dir), &args, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 32f400867727..58be2ef90351 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -752,6 +752,11 @@ xfs_qm_qino_alloc(
 	xfs_inode_t	**ip,
 	uint		flags)
 {
+	struct xfs_ialloc_args	args = {
+		.ops	= &xfs_default_ialloc_ops,
+		.nlink	= 1,
+		.mode	= S_IFREG,
+	};
 	xfs_trans_t	*tp;
 	int		error;
 	bool		need_alloc = true;
@@ -793,7 +798,7 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
-		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
+		error = xfs_dir_ialloc(&tp, &args, ip);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 0096cdbad34e..a34e79b57790 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -238,6 +238,15 @@ xfs_symlink(
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_ialloc_args	args = {
+		.ops	= &xfs_default_ialloc_ops,
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= xfs_get_initial_prid(&dp->i_d),
+		.nlink	= 1,
+		.mode	= S_IFLNK | (mode & ~S_IFMT),
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
@@ -245,7 +254,6 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -267,14 +275,11 @@ xfs_symlink(
 	ASSERT(pathlen > 0);
 
 	udqp = gdqp = NULL;
-	prid = xfs_get_initial_prid(&dp->i_d);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			xfs_kuid_to_uid(current_fsuid()),
-			xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -316,8 +321,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
-			       prid, &ip);
+	error = xfs_dir_ialloc(&tp, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
