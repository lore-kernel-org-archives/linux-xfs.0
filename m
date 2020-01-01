Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2358C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4288206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jFnRKJ+J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgAABNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Aw6v110406
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yGvub9U/OpLDL/ouGP8z2z8K1qHXn4trxBN9qX0kzU4=;
 b=jFnRKJ+JGhOszMyyMVFNeSZ7rOnv9hYgjeuXeOUNCdGaXR6Jh/ZY4mUQljlkFsp/DUDp
 UaVZo+ZDjAKDfUH2HACKGNj6+XeFhszyXG46DfcjLEIKBQzY0TRM5vSFMIFCMbDwVL3j
 /xfh35extSVsBjmplT9W3/IvmQzlKZIOVCjxJ/z2eR27wadPGixuXClZwO4iSynjfaht
 uXdvjOlZUhRzdrh4Er5YtfqIxI5qyhLHKNK1P0rtRMgWT0RMJXI1/YWKk5OyuuOBWH27
 4IVgM0i5anJRxORf89ZJHIFqvu4M/AAc9nTPK4kXgd13pegyWoAV6nLQxxIq3h7M8FYM uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118ugt190234
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg2m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Dewu007298
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:40 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:40 -0800
Subject: [PATCH 10/21] xfs: push xfs_ialloc_args creation out of
 xfs_dir_ialloc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:38 -0800
Message-ID: <157784121815.1365473.16418584721128229029.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the initialization of the xfs_ialloc_args structure out of
xfs_dir_ialloc into its callers' callers so that we can set the new
inode's parameters in one place and pass it through instead of open
coding the new uid/gid/prid all over the code.  This also prepares us
for moving xfs_dir_ialloc and xfs_create to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c   |  131 +++++++++++++++++++++++---------------------------
 fs/xfs/xfs_inode.h   |   10 ++--
 fs/xfs/xfs_iops.c    |   44 ++++++++++-------
 fs/xfs/xfs_qm.c      |    6 ++
 fs/xfs/xfs_symlink.c |   17 ++++--
 5 files changed, 107 insertions(+), 101 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 00547fdf7c15..eef85fbb6102 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -644,32 +644,16 @@ xfs_ialloc_iget(
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
@@ -689,7 +673,7 @@ xfs_dir_ialloc(
 	 * transaction commit so that no other process can steal
 	 * the inode(s) that we've just allocated.
 	 */
-	code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
+	code = xfs_ialloc(tp, args, &ialloc_context, &ip);
 
 	/*
 	 * Return an error if we were unable to allocate a new inode.
@@ -758,7 +742,7 @@ xfs_dir_ialloc(
 		 * other allocations in this allocation group,
 		 * this call should always succeed.
 		 */
-		code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
+		code = xfs_ialloc(tp, args, &ialloc_context, &ip);
 
 		/*
 		 * If we get an error at this point, return to the caller
@@ -817,38 +801,34 @@ xfs_bumplink(
 
 int
 xfs_create(
-	xfs_inode_t		*dp,
-	struct xfs_name		*name,
-	umode_t			mode,
-	dev_t			rdev,
-	xfs_inode_t		**ipp)
-{
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
-	bool			cleared_space = false;
-	uint			resblks;
-
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
+{
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
+	bool				cleared_space = false;
+	int				error;
+
+	ASSERT(args->pip == dp);
 	trace_xfs_create(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
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
@@ -917,7 +897,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
+	error = xfs_dir_ialloc(&tp, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -999,31 +979,30 @@ xfs_create(
 
 int
 xfs_create_tmpfile(
-	struct xfs_inode	*dp,
-	umode_t			mode,
-	struct xfs_inode	**ipp)
-{
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
+	struct xfs_inode		*dp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
+{
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
+	ASSERT(args->nlink == 0);
+	ASSERT(args->pip == dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
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
@@ -1041,7 +1020,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
+	error = xfs_dir_ialloc(&tp, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3086,10 +3065,18 @@ xfs_rename_alloc_whiteout(
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
+	struct xfs_ialloc_args	args = {
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= xfs_get_initial_prid(dp),
+		.nlink	= 0,
+		.mode	= S_IFCHR | WHITEOUT_MODE,
+	};
 	struct xfs_inode	*tmpfile;
 	int			error;
 
-	error = xfs_create_tmpfile(dp, S_IFCHR | WHITEOUT_MODE, &tmpfile);
+	error = xfs_create_tmpfile(dp, &args, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 336f2642336a..24e167cd9a72 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -405,8 +405,10 @@ void		xfs_inactive(struct xfs_inode *ip);
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
@@ -438,8 +440,8 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
-			       xfs_nlink_t, dev_t, prid_t,
+int		xfs_dir_ialloc(struct xfs_trans **,
+			       const struct xfs_ialloc_args *,
 			       struct xfs_inode **);
 
 static inline int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e4635b29a20d..9db69b8b8077 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -123,42 +123,52 @@ xfs_cleanup_inode(
 
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
+		.pip		= XFS_I(dir),
+		.uid		= xfs_kuid_to_uid(current_fsuid()),
+		.gid		= xfs_kgid_to_gid(current_fsgid()),
+		.prid		= xfs_get_initial_prid(XFS_I(dir)),
+		.nlink		= tmpfile ? 0 : (S_ISDIR(mode) ? 2 : 1),
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
index fb671be5ca25..22b6d47670a3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -757,6 +757,10 @@ xfs_qm_qino_alloc(
 	xfs_inode_t	**ip,
 	uint		flags)
 {
+	struct xfs_ialloc_args	args = {
+		.nlink	= 1,
+		.mode	= S_IFREG,
+	};
 	xfs_trans_t	*tp;
 	int		error;
 	bool		need_alloc = true;
@@ -806,7 +810,7 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
-		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
+		error = xfs_dir_ialloc(&tp, &args, ip);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index bc6cf78a44ef..1c6b1d4040c0 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -235,6 +235,14 @@ xfs_symlink(
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_ialloc_args	args = {
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= xfs_get_initial_prid(dp),
+		.nlink	= 1,
+		.mode	= S_IFLNK | (mode & ~S_IFMT),
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
@@ -242,7 +250,6 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -264,14 +271,11 @@ xfs_symlink(
 	ASSERT(pathlen > 0);
 
 	udqp = gdqp = NULL;
-	prid = xfs_get_initial_prid(dp);
 
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
@@ -313,8 +317,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
-			       prid, &ip);
+	error = xfs_dir_ialloc(&tp, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 

