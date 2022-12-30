Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4906C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbiLaBHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiLaBHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:07:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29911DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 707B0B81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3357FC433EF;
        Sat, 31 Dec 2022 01:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448864;
        bh=u3762SEX3HjXqekFYzffjbmIVKDfvo1RdEy7TYxunjM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i4cKyEFf2+37q3vZalOaSCTGL4+6SkDTBOLjIxJcB2zNIaJZs1inKoE6aUrQMcYoJ
         b3xv4BzKCeLeRe4shb8YbvJ3yeXq3RPr82oL2vJMW0/xGvhvrTmWVcb5GlJGKfb5MB
         o9gW3x7gUjNoiR4URaFE0yXNhzi5WB9QQmlwBP1FtbJcAdkGLhZaxzpwpvb6OVMAgG
         ksljgL4hQ7jC6sTHBX1hYujCd45q+7MVwjeO1Pd0hjsB7hFIOAq2x/oEtEM0a0MDKB
         d7j6qWd1MYVrlgVZLM5PUJgmTgqN8F84ZqWpFx0t4j0MMPibWNIhipUuQmQmtHtyvK
         0IGGjrnkewJ/Q==
Subject: [PATCH 10/20] xfs: push xfs_icreate_args creation out of xfs_create*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863973.707335.4090548610585011757.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the initialization of the xfs_icreate_args structure out of
xfs_create and xfs_create_tempfile into their callers so that we can set
the new inode's attributes in one place and pass that through instead of
open coding the collection of attributes all over the code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   59 +++++++++++++++++++++++-----------------------------
 fs/xfs/xfs_inode.h |    9 ++++----
 fs/xfs/xfs_iops.c  |   50 +++++++++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 270e81e12015..5350c55ac25f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -808,44 +808,34 @@ xfs_nlink_hook_del(
 
 int
 xfs_create(
-	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
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
-	bool                    unlock_dp_on_error = false;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
-	uint			resblks;
 	xfs_ino_t		ino;
+	bool			unlock_dp_on_error = false;
+	bool			is_dir = S_ISDIR(args->mode);
+	uint			resblks;
+	int			error;
 
+	ASSERT(args->pip == dp);
 	trace_xfs_create(dp, name);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	xfs_icreate_args_inherit(&args, dp, mnt_userns, mode);
-	if (init_xattrs)
-		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -884,9 +874,9 @@ xfs_create(
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
 
@@ -977,32 +967,31 @@ xfs_create(
 
 int
 xfs_create_tmpfile(
-	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
-	umode_t			mode,
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
 
-	xfs_icreate_args_inherit(&args, dp, mnt_userns, mode);
-
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
+	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1016,9 +1005,9 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,12 +2739,16 @@ xfs_rename_alloc_whiteout(
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
+	struct xfs_icreate_args	args = {
+		.nlink		= 0,
+	};
 	struct xfs_inode	*tmpfile;
 	struct qstr		name;
 	int			error;
 
-	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+	xfs_icreate_args_inherit(&args, dp, mnt_userns, S_IFCHR | WHITEOUT_MODE);
+
+	error = xfs_create_tmpfile(dp, &args, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cb4e5114bac4..9617079f0a73 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -485,12 +485,11 @@ int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-int		xfs_create(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, struct xfs_name *name,
-			   umode_t mode, dev_t rdev, bool need_xattr,
+int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
+			   const struct xfs_icreate_args *iargs,
 			   struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+int		xfs_create_tmpfile(struct xfs_inode *dp,
+			   const struct xfs_icreate_args *iargs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 80f881c69336..d580bf591d73 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -165,44 +165,56 @@ xfs_create_need_xattr(
 STATIC int
 xfs_generic_create(
 	struct user_namespace	*mnt_userns,
-	struct inode	*dir,
-	struct dentry	*dentry,
-	umode_t		mode,
-	dev_t		rdev,
-	struct file	*tmpfile)	/* unnamed file */
+	struct inode		*dir,
+	struct dentry		*dentry,
+	umode_t			mode,
+	dev_t			rdev,
+	struct file		*tmpfile)	/* unnamed file */
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
+	xfs_icreate_args_inherit(&args, XFS_I(dir), mnt_userns, mode);
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
-		error = xfs_create(mnt_userns, XFS_I(dir), &name, mode, rdev,
-				xfs_create_need_xattr(dir, default_acl, acl),
-				&ip);
+		if (xfs_create_need_xattr(dir, default_acl, acl))
+			args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+		error = xfs_create(XFS_I(dir), &name, &args, &ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(XFS_I(dir), &args, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

