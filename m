Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D9BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiKYy38z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13CDC433C8;
	Sun, 31 Dec 2023 21:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056524;
	bh=zcR9siDiJCpHxDfhZTwoq+CGxtHvTPpRlYGQ4b5mi2w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FiKYy38zz075Fr+yMhiK+zykgqS8iwNsymnQEKK1U0JV+Jq86htjLQ4xSprhsa3sd
	 alfAH9D3cDf5i3C9r7oqAZ3nG/AMCi++Xc70jlBg+mLplnxJypNKxbxap2KPyI9FI7
	 lnsYSMJZ4vZyvZ40atlO+VdXEHsw9xAAF/izGfmFK/8oFXCOoNv7j/JqZ2cYRtjsWR
	 iOwldXTl6qk7Bs5fjeeQxRWUgtBFW8is+XVzPU9hdZ5ZWHKrCEuMWF5mJzV9Ey3E8p
	 SDnUPaCLsZlLqW6ymiRbktRBLbWB4zL4VFTWbII2JTl6tTygoTtKDJUC9KPRjbvzxn
	 gEhDlZgvtdLgw==
Date: Sun, 31 Dec 2023 13:02:03 -0800
Subject: [PATCH 05/21] xfs: pack icreate initialization parameters into a
 separate structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844133.1759932.14422964088498012083.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_util.h |   32 ++++++++++++
 fs/xfs/scrub/tempfile.c        |   13 +++--
 fs/xfs/xfs_inode.c             |  106 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_inode.h             |   12 +++--
 fs/xfs/xfs_qm.c                |    9 +++
 fs/xfs/xfs_symlink.c           |   14 +++--
 6 files changed, 138 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index f7e4d5a8235dd..a494f7c4a3fe0 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -13,4 +13,36 @@ uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
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
+	struct mnt_idmap	*idmap;
+
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
index 43d48f1e331de..c326cf66dea5c 100644
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
+	xfs_icreate_args_rootfile(&args, mp, mode, false);
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
-	error = xfs_init_new_inode(&nop_mnt_idmap, tp, dp, ino, mode, 0, 0,
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
index 3f69379bfef59..72d2441b65a78 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -683,18 +683,13 @@ xfs_inode_inherit_flags2(
  * Caller is responsible for unlocking the inode manually upon return
  */
 int
-xfs_init_new_inode(
-	struct mnt_idmap	*idmap,
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
@@ -727,16 +722,16 @@ xfs_init_new_inode(
 
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	set_nlink(inode, nlink);
-	inode->i_rdev = rdev;
-	ip->i_projid = prid;
+	set_nlink(inode, args->nlink);
+	inode->i_rdev = args->rdev;
+	ip->i_projid = args->prid;
 
 	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
-		inode_fsuid_set(inode, idmap);
+		inode_fsuid_set(inode, args->idmap);
 		inode->i_gid = dir->i_gid;
-		inode->i_mode = mode;
+		inode->i_mode = args->mode;
 	} else {
-		inode_init_owner(idmap, inode, dir, mode);
+		inode_init_owner(args->idmap, inode, dir, args->mode);
 	}
 
 	/*
@@ -745,9 +740,21 @@ xfs_init_new_inode(
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
 	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-	    !vfsgid_in_group_p(i_gid_into_vfsgid(idmap, inode)))
+	    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
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
@@ -766,7 +773,7 @@ xfs_init_new_inode(
 	}
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
@@ -799,7 +806,8 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if ((args->flags & XFS_ICREATE_ARGS_INIT_XATTRS) &&
+	    xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -817,6 +825,47 @@ xfs_init_new_inode(
 	return 0;
 }
 
+/* Set up inode attributes for newly created children of a directory. */
+void
+xfs_icreate_args_inherit(
+	struct xfs_icreate_args	*args,
+	struct xfs_inode	*dp,
+	struct mnt_idmap	*idmap,
+	umode_t			mode,
+	bool			init_xattrs)
+{
+	args->idmap = idmap;
+	args->pip = dp;
+	args->uid = mapped_fsuid(idmap, &init_user_ns);
+	args->gid = mapped_fsgid(idmap, &init_user_ns);
+	args->prid = xfs_get_initial_prid(dp);
+	args->mode = mode;
+
+	/* Don't clobber the caller's flags */
+	if (init_xattrs)
+		args->flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+}
+
+/* Set up inode attributes for newly created internal files. */
+void
+xfs_icreate_args_rootfile(
+	struct xfs_icreate_args	*args,
+	struct xfs_mount	*mp,
+	umode_t			mode,
+	bool			init_xattrs)
+{
+	args->idmap = &nop_mnt_idmap;
+	args->uid = GLOBAL_ROOT_UID;
+	args->gid = GLOBAL_ROOT_GID;
+	args->prid = 0;
+	args->mode = mode;
+	args->flags = XFS_ICREATE_ARGS_FORCE_UID |
+		      XFS_ICREATE_ARGS_FORCE_GID |
+		      XFS_ICREATE_ARGS_FORCE_MODE;
+	if (init_xattrs)
+		args->flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+}
+
 /*
  * Decrement the link count on an inode & log the change.  If this causes the
  * link count to go to zero, move the inode to AGI unlinked list so that it can
@@ -946,13 +995,16 @@ xfs_create(
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
 	bool			unlock_dp_on_error = false;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -968,13 +1020,12 @@ xfs_create(
 	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, idmap, mode, init_xattrs);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1019,8 +1070,7 @@ xfs_create(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1126,11 +1176,11 @@ xfs_create_tmpfile(
 	bool			init_xattrs,
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
@@ -1141,13 +1191,12 @@ xfs_create_tmpfile(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, idmap, mode, init_xattrs);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1163,8 +1212,7 @@ xfs_create_tmpfile(
 
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, init_xattrs, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f4937d57ad7da..8ccf4cf049709 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -550,10 +550,8 @@ int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int xfs_init_new_inode(struct mnt_idmap *idmap, struct xfs_trans *tp,
-		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
-		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
-		struct xfs_inode **ipp);
+int xfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
 
 static inline int
 xfs_itruncate_extents(
@@ -661,4 +659,10 @@ void xfs_dir_hook_del(struct xfs_mount *mp, struct xfs_dir_hook *hook);
 # define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+void xfs_icreate_args_inherit(struct xfs_icreate_args *args,
+		struct xfs_inode *dp, struct mnt_idmap *idmap, umode_t mode,
+		bool init_xattrs);
+void xfs_icreate_args_rootfile(struct xfs_icreate_args *args,
+		struct xfs_mount *mp, umode_t mode, bool init_xattrs);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c25d917487f0e..07d0d0231252a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -792,12 +792,17 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
+		struct xfs_icreate_args	args = {
+			.nlink		= 1,
+		};
 		xfs_ino_t	ino;
 
+		xfs_icreate_args_rootfile(&args, mp, S_IFREG,
+				xfs_has_parent(mp));
+
 		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
 		if (!error)
-			error = xfs_init_new_inode(&nop_mnt_idmap, tp, NULL, ino,
-					S_IFREG, 1, 0, 0, false, ipp);
+			error = xfs_icreate(tp, ino, &args, ipp);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ced29d8c48c0a..f40fa37302829 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -90,6 +90,9 @@ xfs_symlink(
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.nlink		= 1,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
@@ -97,7 +100,6 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -120,13 +122,13 @@ xfs_symlink(
 		return -ENAMETOOLONG;
 	ASSERT(pathlen > 0);
 
-	prid = xfs_get_initial_prid(dp);
+	xfs_icreate_args_inherit(&args, dp, idmap, S_IFLNK | (mode & ~S_IFMT),
+			xfs_has_parent(mp));
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -169,9 +171,7 @@ xfs_symlink(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino,
-				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				xfs_has_parent(mp), &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 

