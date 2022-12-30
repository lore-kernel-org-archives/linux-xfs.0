Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C41C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiLaBG3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:06:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7205164E5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F32E861D30
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609CCC433EF;
        Sat, 31 Dec 2022 01:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448786;
        bh=/Hzg1eitKeaWuD22u5EPXcIKtbW3bIbstHP6Nec1ZJc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nLVsxZWDZHXv2QFQ7e3QhBIu6KoCazaGegffq/PjCezQRPGTr0QZN0L2y/UrQhX9y
         KqH3NYc7UIfJUrYQQpV1gXKdpZKXf+xgfV/A43886AWCFrM5m24Yp6uw6NqQgpWwMs
         at89m4Le0mfM2Nu03O6P3iyyXA6VkYx8iiudnzjvlifBCZqwti5DF4zZlwkNm8MFAw
         QHHi7fhk7QH/88GL+0fFCcgcl/+XXQuZ9r8adbZdr5nxRwlXBODRgPyncNLwJjbH1O
         Eh3N73/odHS99xucUnAGQarUP/e7Di4axeEaMZPz4yxAmCQaHQhicGQ+0yFBjS79Cg
         ihLbwEJud3eeQ==
Subject: [PATCH 05/20] xfs: pack icreate initialization parameters into a
 separate structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863904.707335.15969998887616204747.stgit@magnolia>
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

Callers that want to create an inode currently pass all possible file
attribute values for the new inode into xfs_init_new_inode as ten
separate parameters.  This causes two code maintenance issues: first, we
have large multi-line call sites which programmers must read carefully
to make sure they did not accidentally invert a value.  Second, all
three file id parameters must be passed separately to the quota
functions; any discrepancy results in quota count errors.

Clean this up by creating a new icreate_args structure to hold all this
information, some helpers to initialize them properly, and make the
callers pass this structure through to the creation function, whose name
we shorten to xfs_icreate.  This eliminates the issues, enables us to
keep the inode init code in sync with userspace via libxfs, and is
needed for future metadata directory tree management.

(A subsequent cleanup will also fix the quota alloc calls.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.h |   31 +++++++++++++
 fs/xfs/scrub/tempfile.c        |   13 +++--
 fs/xfs/xfs_inode.c             |   99 ++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h             |   10 ++--
 fs/xfs/xfs_qm.c                |    8 ++-
 fs/xfs/xfs_symlink.c           |   14 +++---
 6 files changed, 127 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index f7e4d5a8235d..466f0767ab5d 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -13,4 +13,35 @@ uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
 prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
 
+/*
+ * Initial ids, link count, device number, and mode of a new inode.
+ *
+ * Due to our only partial reliance on the VFS to propagate uid and gid values
+ * according to accepted Unix behaviors, callers must initialize mnt_userns to
+ * the appropriate namespace, uid to fsuid_into_mnt(), and gid to
+ * fsgid_into_mnt() to get the correct inheritance behaviors when
+ * XFS_MOUNT_GRPID is set.  Use the xfs_ialloc_inherit_args() helper.
+ *
+ * To override the default ids, use the FORCE flags defined below.
+ */
+struct xfs_icreate_args {
+	struct user_namespace	*mnt_userns;
+	struct xfs_inode	*pip;	/* parent inode or null */
+
+	kuid_t			uid;
+	kgid_t			gid;
+	prid_t			prid;
+
+	xfs_nlink_t		nlink;
+	dev_t			rdev;
+
+	umode_t			mode;
+
+#define XFS_ICREATE_ARGS_FORCE_UID	(1 << 0)
+#define XFS_ICREATE_ARGS_FORCE_GID	(1 << 1)
+#define XFS_ICREATE_ARGS_FORCE_MODE	(1 << 2)
+#define XFS_ICREATE_ARGS_INIT_XATTRS	(1 << 3)
+	uint16_t		flags;
+};
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index e5087f14343b..2c630a5e23ea 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -40,6 +40,7 @@ xrep_tempfile_create(
 	struct xfs_scrub	*sc,
 	uint16_t		mode)
 {
+	struct xfs_icreate_args	args = { .pip = sc->mp->m_rootip, };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_dquot	*udqp = NULL;
@@ -60,12 +61,15 @@ xrep_tempfile_create(
 	ASSERT(sc->tp == NULL);
 	ASSERT(sc->tempip == NULL);
 
+	/* Force everything to have the root ids and mode we want. */
+	xfs_icreate_args_rootfile(&args, mode);
+
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.  The temporary
 	 * inode should be completely root owned so that we don't fail due to
 	 * quota limits.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
@@ -87,14 +91,11 @@ xrep_tempfile_create(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (error)
 		goto out_trans_cancel;
-	error = xfs_init_new_inode(&init_user_ns, tp, dp, ino, mode, 0, 0,
-			0, false, &sc->tempip);
+	error = xfs_icreate(tp, ino, &args, &sc->tempip);
 	if (error)
 		goto out_trans_cancel;
 
-	/* Change the ownership of the inode to root. */
-	VFS_I(sc->tempip)->i_uid = GLOBAL_ROOT_UID;
-	VFS_I(sc->tempip)->i_gid = GLOBAL_ROOT_GID;
+	/* We don't touch file data, so drop the realtime flags. */
 	sc->tempip->i_diflags &= ~(XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT);
 	xfs_trans_log_inode(tp, sc->tempip, XFS_ILOG_CORE);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cd1d742a8a81..ffbf504891aa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -679,18 +679,13 @@ xfs_inode_inherit_flags2(
  * caller locked exclusively.
  */
 int
-xfs_init_new_inode(
-	struct user_namespace	*mnt_userns,
+xfs_icreate(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*pip,
 	xfs_ino_t		ino,
-	umode_t			mode,
-	xfs_nlink_t		nlink,
-	dev_t			rdev,
-	prid_t			prid,
-	bool			init_xattrs,
+	const struct xfs_icreate_args *args,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_inode	*pip = args->pip;
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip;
@@ -723,16 +718,16 @@ xfs_init_new_inode(
 
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	set_nlink(inode, nlink);
-	inode->i_rdev = rdev;
-	ip->i_projid = prid;
+	set_nlink(inode, args->nlink);
+	inode->i_rdev = args->rdev;
+	ip->i_projid = args->prid;
 
 	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
-		inode_fsuid_set(inode, mnt_userns);
+		inode_fsuid_set(inode, args->mnt_userns);
 		inode->i_gid = dir->i_gid;
-		inode->i_mode = mode;
+		inode->i_mode = args->mode;
 	} else {
-		inode_init_owner(mnt_userns, inode, dir, mode);
+		inode_init_owner(args->mnt_userns, inode, dir, args->mode);
 	}
 
 	/*
@@ -741,9 +736,21 @@ xfs_init_new_inode(
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
 	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-	    !vfsgid_in_group_p(i_gid_into_vfsgid(mnt_userns, inode)))
+	    !vfsgid_in_group_p(i_gid_into_vfsgid(args->mnt_userns, inode)))
 		inode->i_mode &= ~S_ISGID;
 
+	/* struct copies */
+	if (args->flags & XFS_ICREATE_ARGS_FORCE_UID)
+		inode->i_uid = args->uid;
+	else
+		ASSERT(uid_eq(inode->i_uid, args->uid));
+	if (args->flags & XFS_ICREATE_ARGS_FORCE_GID)
+		inode->i_gid = args->gid;
+	else if (!pip || !XFS_INHERIT_GID(pip))
+		ASSERT(gid_eq(inode->i_gid, args->gid));
+	if (args->flags & XFS_ICREATE_ARGS_FORCE_MODE)
+		inode->i_mode = args->mode;
+
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
@@ -763,7 +770,7 @@ xfs_init_new_inode(
 	}
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
@@ -796,7 +803,8 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if ((args->flags & XFS_ICREATE_ARGS_INIT_XATTRS) &&
+	    xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -814,6 +822,38 @@ xfs_init_new_inode(
 	return 0;
 }
 
+/* Set up inode attributes for newly created children of a directory. */
+void
+xfs_icreate_args_inherit(
+	struct xfs_icreate_args	*args,
+	struct xfs_inode	*dp,
+	struct user_namespace	*mnt_userns,
+	umode_t			mode)
+{
+	args->mnt_userns = mnt_userns;
+	args->pip = dp;
+	args->uid = mapped_fsuid(mnt_userns, &init_user_ns);
+	args->gid = mapped_fsgid(mnt_userns, &init_user_ns);
+	args->prid = xfs_get_initial_prid(dp);
+	args->mode = mode;
+}
+
+/* Set up inode attributes for newly created internal files. */
+void
+xfs_icreate_args_rootfile(
+	struct xfs_icreate_args	*args,
+	umode_t			mode)
+{
+	args->mnt_userns = &init_user_ns;
+	args->uid = GLOBAL_ROOT_UID;
+	args->gid = GLOBAL_ROOT_GID;
+	args->prid = 0;
+	args->mode = mode;
+	args->flags = XFS_ICREATE_ARGS_FORCE_UID |
+		      XFS_ICREATE_ARGS_FORCE_GID |
+		      XFS_ICREATE_ARGS_FORCE_MODE;
+}
+
 /*
  * Decrement the link count on an inode & log the change.  If this causes the
  * link count to go to zero, move the inode to AGI unlinked list so that it can
@@ -970,13 +1010,16 @@ xfs_create(
 	bool			init_xattrs,
 	xfs_inode_t		**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.rdev		= rdev,
+		.nlink		= S_ISDIR(mode) ? 2 : 1,
+	};
 	int			is_dir = S_ISDIR(mode);
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
 	bool                    unlock_dp_on_error = false;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -989,13 +1032,14 @@ xfs_create(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, mnt_userns, mode);
+	if (init_xattrs)
+		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1036,8 +1080,7 @@ xfs_create(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1133,11 +1176,11 @@ xfs_create_tmpfile(
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = { NULL };
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	prid_t                  prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -1148,13 +1191,12 @@ xfs_create_tmpfile(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, mnt_userns, mode);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1170,8 +1212,7 @@ xfs_create_tmpfile(
 
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4803904686f5..cb627543e9fb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -523,10 +523,8 @@ int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int xfs_init_new_inode(struct user_namespace *mnt_userns, struct xfs_trans *tp,
-		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
-		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
-		struct xfs_inode **ipp);
+int xfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
 
 static inline int
 xfs_itruncate_extents(
@@ -626,4 +624,8 @@ void xfs_nlink_hook_del(struct xfs_mount *mp, struct xfs_nlink_hook *hook);
 # define xfs_nlink_dirent_delta(dp, ip, delta, name)	((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+void xfs_icreate_args_inherit(struct xfs_icreate_args *args, struct xfs_inode *dp,
+		struct user_namespace *mnt_userns, umode_t mode);
+void xfs_icreate_args_rootfile(struct xfs_icreate_args *args, umode_t mode);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 59ace2eedf69..da6c6f0e1ced 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -791,12 +791,16 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
+		struct xfs_icreate_args	args = {
+			.nlink		= 1,
+		};
 		xfs_ino_t	ino;
 
+		xfs_icreate_args_rootfile(&args, S_IFREG);
+
 		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
 		if (!error)
-			error = xfs_init_new_inode(&init_user_ns, tp, NULL, ino,
-					S_IFREG, 1, 0, 0, false, ipp);
+			error = xfs_icreate(tp, ino, &args, ipp);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8cf69ca4bd7c..c27bf49de7bf 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -88,6 +88,9 @@ xfs_symlink(
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.nlink		= 1,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
@@ -95,7 +98,6 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -117,13 +119,13 @@ xfs_symlink(
 		return -ENAMETOOLONG;
 	ASSERT(pathlen > 0);
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, mnt_userns,
+			S_IFLNK | (mode & ~S_IFMT));
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -160,9 +162,7 @@ xfs_symlink(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
 	if (!error)
-		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
-				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 

