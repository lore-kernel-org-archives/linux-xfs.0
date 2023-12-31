Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F6ABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/R0vw8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22382C433C7;
	Sun, 31 Dec 2023 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056602;
	bh=+iYCva6Q0T9LdkZHanNCaWcrZR8G+CCW1LeMgeevlhM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C/R0vw8DVFrcryQ1eZqoPm+RvgeTV3Q5nDU3Mu5jioKT62q6vTbpPYdW19HEF9Boh
	 89TYKaaeVv3Y2FGDd6xM+ZuZd09Vrzd3woyAHhNuw9McJTfpaPEXrogbjIrCO96yFE
	 GSWhKelYgzLcMRib0ZKeCp8puBk7rGtXcfbb/pdDXNkpDVX0i5ceScsMe9DkkURGJO
	 P1WLY1Ib4aP+fYeD1oF2RD3p1kRV0Kl8B4odSUuo9HGrL8EL64hnQERUGcFcbUJOb4
	 lmmbM6khjoKie/9BxrAnqn0JcRIMnxZVlrJTqwnuaMEXj9DpuVwas6+rZAVX+TB1AQ
	 rZBdbBZMFQNIA==
Date: Sun, 31 Dec 2023 13:03:21 -0800
Subject: [PATCH 10/21] xfs: push xfs_icreate_args creation out of xfs_create*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844213.1759932.14842099952133799462.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_inode.c |   65 ++++++++++++++++++++++++----------------------------
 fs/xfs/xfs_inode.h |    9 +++----
 fs/xfs/xfs_iops.c  |   46 ++++++++++++++++++++++---------------
 3 files changed, 62 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a6ab37ba4f729..a95f05cd06ba6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -784,32 +784,26 @@ xfs_dir_hook_del(
 
 int
 xfs_create(
-	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	umode_t			mode,
-	dev_t			rdev,
-	bool			init_xattrs,
-	xfs_inode_t		**ipp)
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	**ipp)
 {
-	struct xfs_icreate_args	args = {
-		.rdev		= rdev,
-		.nlink		= S_ISDIR(mode) ? 2 : 1,
-	};
-	int			is_dir = S_ISDIR(mode);
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
 	bool			unlock_dp_on_error = false;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
+	bool			is_dir = S_ISDIR(args->mode);
 	uint			resblks;
-	xfs_ino_t		ino;
-	struct xfs_parent_args	*ppargs;
+	int			error;
 
+	ASSERT(args->pip == dp);
 	trace_xfs_create(dp, name);
 
 	if (xfs_is_shutdown(mp))
@@ -817,12 +811,10 @@ xfs_create(
 	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
 		return -EIO;
 
-	xfs_icreate_args_inherit(&args, dp, idmap, mode, init_xattrs);
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -865,9 +857,9 @@ xfs_create(
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
 
@@ -967,33 +959,31 @@ xfs_create(
 
 int
 xfs_create_tmpfile(
-	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
-	umode_t			mode,
-	bool			init_xattrs,
+	const struct xfs_icreate_args *args,
 	struct xfs_inode	**ipp)
 {
-	struct xfs_icreate_args	args = { NULL };
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	int			error;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
-	uint			resblks;
 	xfs_ino_t		ino;
+	uint			resblks;
+	int			error;
+
+	ASSERT(args->nlink == 0);
+	ASSERT(args->pip == dp);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	xfs_icreate_args_inherit(&args, dp, idmap, mode, init_xattrs);
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1007,9 +997,9 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2858,12 +2848,17 @@ xfs_rename_alloc_whiteout(
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
+	struct xfs_icreate_args	args = {
+		.nlink		= 0,
+	};
 	struct xfs_inode	*tmpfile;
 	struct qstr		name;
 	int			error;
 
-	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-			xfs_has_parent(dp->i_mount), &tmpfile);
+	xfs_icreate_args_inherit(&args, dp, idmap, S_IFCHR | WHITEOUT_MODE,
+			xfs_has_parent(dp->i_mount));
+
+	error = xfs_create_tmpfile(dp, &args, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8ccf4cf049709..f9530494dd873 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -512,12 +512,11 @@ int		xfs_release(struct xfs_inode *ip);
 int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-int		xfs_create(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, struct xfs_name *name,
-			   umode_t mode, dev_t rdev, bool need_xattr,
+int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
+			   const struct xfs_icreate_args *iargs,
 			   struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
+int		xfs_create_tmpfile(struct xfs_inode *dp,
+			   const struct xfs_icreate_args *iargs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8f5b8f8973a5f..90296b3c838aa 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -174,49 +174,59 @@ xfs_generic_create(
 	dev_t			rdev,
 	struct file		*tmpfile)	/* unnamed file */
 {
-	struct inode	*inode;
-	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl, *acl;
-	struct xfs_name	name;
-	int		error;
+	struct xfs_icreate_args args = {
+		.rdev		= rdev,
+	};
+	struct inode		*inode;
+	struct xfs_inode	*ip = NULL;
+	struct posix_acl	*default_acl, *acl;
+	struct xfs_name		name;
+	int			error;
+
+	xfs_icreate_args_inherit(&args, XFS_I(dir), idmap, mode, false);
+	if (tmpfile)
+		args.nlink = 0;
+	else if (S_ISDIR(mode))
+		args.nlink = 2;
+	else
+		args.nlink = 1;
 
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
-	} else {
-		bool	init_xattrs = false;
+		if (xfs_create_need_xattr(dir, default_acl, acl))
+			args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 
+		error = xfs_create(XFS_I(dir), &name, &args, &ip);
+	} else {
 		/*
 		 * If this temporary file will be linkable, set up the file
 		 * with an attr fork to receive a parent pointer.
 		 */
 		if (!(tmpfile->f_flags & O_EXCL) &&
 		    xfs_has_parent(XFS_I(dir)->i_mount))
-			init_xattrs = true;
+			args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode,
-				init_xattrs, &ip);
+		error = xfs_create_tmpfile(XFS_I(dir), &args, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

