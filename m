Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6631494B9
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924477; cv=none; b=d8v37Micw0XkQXPMnhBMK3kmwqtPtElAA5ETEiJFhOGYGetCFiXVTSj2Z1TqYiwtLZZQrRCisXyBMRJOKrGQM/Y8kIy0T5WO3sA/zXzUCx4fXEULL6kgQsOl+2Kq8/Tj7lbuDjzYhaEYNp75S4LuwfchzEhtooNaE2DwHS5X/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924477; c=relaxed/simple;
	bh=zuXFRQE/KdRiQ2SpDZDGE/pEaGGqaVrHySmLCJcTrOE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtO6nFZfeEMrODNm3y6Fbafr9ZrPLga8tLBwjhSI6h5akhez+rVY06dG0ZZFNYYYQAMGgy7LnpnpQOs9mHyGdv0XlfV8Dz7A2UIm2iCvVkyd3YxrgWWPz1bOS/YjhfEDBZaT+eqiO5vNo9GpqGWWZFGZC4GKpM4z8JmvNmrX42M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sfZhYzj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sfZhYzj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C8C2BD10;
	Thu, 20 Jun 2024 23:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924476;
	bh=zuXFRQE/KdRiQ2SpDZDGE/pEaGGqaVrHySmLCJcTrOE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sfZhYzj46nnd8c64cuQ1MkeSu7aZtetLGhxKnwMVwocigpWTx6FVhuujBP9qRN4IR
	 QDGKD1ClJsrDBl/4zTbAKd/bQRfgpR3U1iIKVQXLfGduPSTAQDLm1+oQ0nLrybz2N0
	 xW/nsszum3tmHXx+OSOYiU5Rs7NPNUFXX8EbrgvKrNGSJHB3ptFd1EcHRVVo04e/Cc
	 AYGcjoG4CV4kOqslzUlWruyfUw5d6F1GSqPIxa5gMZUiCQS+qkD6XJ9pXvhfKU0f6G
	 5B5nYl01GsZiHpTEi9iEvIbzU8dqFfFDjmdkHfC1AEyToMvfYgqwnUpi7LoS7/tVji
	 LbFZQmXCbEA5A==
Date: Thu, 20 Jun 2024 16:01:16 -0700
Subject: [PATCH 11/24] xfs: push xfs_icreate_args creation out of xfs_create*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418085.3183075.6634714056147736408.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the initialization of the xfs_icreate_args structure out of
xfs_create and xfs_create_tempfile into their callers so that we can set
the new inode's attributes in one place and pass that through instead of
open coding the collection of attributes all over the code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   86 ++++++++++++++++++++++++----------------------------
 fs/xfs/xfs_inode.h |    9 ++---
 fs/xfs/xfs_iops.c  |   41 +++++++++++++++----------
 3 files changed, 66 insertions(+), 70 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e8d4ddbfbb925..d026e377fcafa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -730,35 +730,25 @@ xfs_dir_hook_setup(
 
 int
 xfs_create(
-	struct mnt_idmap	*idmap,
-	struct xfs_inode	*dp,
+	const struct xfs_icreate_args *args,
 	struct xfs_name		*name,
-	umode_t			mode,
-	dev_t			rdev,
-	bool			init_xattrs,
-	xfs_inode_t		**ipp)
+	struct xfs_inode	**ipp)
 {
-	struct xfs_icreate_args	args = {
-		.idmap		= idmap,
-		.pip		= dp,
-		.rdev		= rdev,
-		.mode		= mode,
-		.flags		= init_xattrs ? XFS_ICREATE_INIT_XATTRS : 0,
-	};
-	int			is_dir = S_ISDIR(mode);
+	struct xfs_inode	*dp = args->pip;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	int			error;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	*tres;
+	struct xfs_parent_args	*ppargs;
+	xfs_ino_t		ino;
+	prid_t			prid;
 	bool			unlock_dp_on_error = false;
-	prid_t			prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
+	bool			is_dir = S_ISDIR(args->mode);
 	uint			resblks;
-	xfs_ino_t		ino;
-	struct xfs_parent_args	*ppargs;
+	int			error;
 
 	trace_xfs_create(dp, name);
 
@@ -774,8 +764,9 @@ xfs_create(
 	 * computation code must match what the VFS uses to assign i_[ug]id.
 	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
-			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			mapped_fsuid(args->idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(args->idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -818,9 +809,9 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -922,44 +913,37 @@ xfs_create(
 
 int
 xfs_create_tmpfile(
-	struct mnt_idmap	*idmap,
-	struct xfs_inode	*dp,
-	umode_t			mode,
-	bool			init_xattrs,
+	const struct xfs_icreate_args *args,
 	struct xfs_inode	**ipp)
 {
-	struct xfs_icreate_args	args = {
-		.idmap		= idmap,
-		.pip		= dp,
-		.mode		= mode,
-		.flags		= XFS_ICREATE_TMPFILE,
-	};
+	struct xfs_inode	*dp = args->pip;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	int			error;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
-	uint			resblks;
 	xfs_ino_t		ino;
+	prid_t			prid;
+	uint			resblks;
+	int			error;
+
+	ASSERT(args->flags & XFS_ICREATE_TMPFILE);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
-	if (init_xattrs)
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
 	 * computation code must match what the VFS uses to assign i_[ug]id.
 	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
-			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			mapped_fsuid(args->idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(args->idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -973,9 +957,9 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2839,12 +2823,20 @@ xfs_rename_alloc_whiteout(
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
+	struct xfs_icreate_args	args = {
+		.idmap		= idmap,
+		.pip		= dp,
+		.mode		= S_IFCHR | WHITEOUT_MODE,
+		.flags		= XFS_ICREATE_TMPFILE,
+	};
 	struct xfs_inode	*tmpfile;
 	struct qstr		name;
 	int			error;
 
-	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-			xfs_has_parent(dp->i_mount), &tmpfile);
+	if (xfs_has_parent(dp->i_mount))
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
+
+	error = xfs_create_tmpfile(&args, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7d3fea66e069e..bc48e81829b5a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -516,12 +516,9 @@ int		xfs_release(struct xfs_inode *ip);
 int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-int		xfs_create(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, struct xfs_name *name,
-			   umode_t mode, dev_t rdev, bool need_xattr,
-			   struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
+int		xfs_create(const struct xfs_icreate_args *iargs,
+			   struct xfs_name *name, struct xfs_inode **ipp);
+int		xfs_create_tmpfile(const struct xfs_icreate_args *iargs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 35a84790d26e6..4563ba440570b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -173,38 +173,46 @@ xfs_generic_create(
 	dev_t			rdev,
 	struct file		*tmpfile)	/* unnamed file */
 {
-	struct inode	*inode;
-	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl, *acl;
-	struct xfs_name	name;
-	int		error;
+	struct xfs_icreate_args	args = {
+		.idmap		= idmap,
+		.pip		= XFS_I(dir),
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
-		error = xfs_create(idmap, XFS_I(dir), &name, mode, rdev,
-				xfs_create_need_xattr(dir, default_acl, acl),
-				&ip);
+		if (xfs_create_need_xattr(dir, default_acl, acl))
+			args.flags |= XFS_ICREATE_INIT_XATTRS;
+
+		error = xfs_create(&args, &name, &ip);
 	} else {
-		bool	init_xattrs = false;
+		args.flags |= XFS_ICREATE_TMPFILE;
 
 		/*
 		 * If this temporary file will be linkable, set up the file
@@ -212,10 +220,9 @@ xfs_generic_create(
 		 */
 		if (!(tmpfile->f_flags & O_EXCL) &&
 		    xfs_has_parent(XFS_I(dir)->i_mount))
-			init_xattrs = true;
+			args.flags |= XFS_ICREATE_INIT_XATTRS;
 
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode,
-				init_xattrs, &ip);
+		error = xfs_create_tmpfile(&args, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

