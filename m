Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9731F143737
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924398; cv=none; b=Y74ncanL1fpwOBIWp15Pf6rKucANU9rcfwVj78vqo6b6eu6t6sS8hJwOzVShis/iKboJKJUQqV1hDvTiaSwq2Eu6NJu3c/kDx6/9ddTsBTuHC4hD0+nf1gb+OekcWfIer3mXRf6cy1NAAJAdSe1c23nmQNMxNFkA6MFIhnJCBKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924398; c=relaxed/simple;
	bh=KqJNh5o/YItoA7fsBeC2H/JE34llOt7llK1i4ZDQalg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZD+Bjtwed14RC3ezoURZBURM0bAtZdwd6MRZLm3YUYqnH5NdDVtQXBjGUxE0PE7UdHCszAlRdIcB/NsYUfpBFXQXdZBR9VILO38VpOxNN/R/ao1Gd5wXssv/DwuRaF58d2I4nCuG4HiZ8VOmRQpXSP5fZPtSpbWImL2WaOVYpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XT6sdlEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XT6sdlEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F24DC2BD10;
	Thu, 20 Jun 2024 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924398;
	bh=KqJNh5o/YItoA7fsBeC2H/JE34llOt7llK1i4ZDQalg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XT6sdlEzuD8JKHmOfaDwyA5/4GjHEfK5YBcjc9qDj2LmhOXwdNHkQbooltKbgPen8
	 CTG7PZ5Zzbhoab4FxwsvGYa9EkCZ9L9KXVmGijmyBP+Rns6DAF5/8MNUWZp2QGCaZi
	 InZHJ0cWHwfEKqJJSgs1Fsf/KKZCYzMsJ1GqHD74VwSBUSFfg9fei584+Se6g+v2dB
	 THKtP12urRq1SYuxKp+7jQPZZ720E6FlVI4q6VRK6cczKml5e4kCOQwoGz6ahFEMm+
	 EjIq+d6E5CXY9/KDh81I4a8Mca25zE91c5cKUfHkYQHW/S2NIhnUkeP3i4ePtIndnj
	 pdxSm9cSG91HQ==
Date: Thu, 20 Jun 2024 15:59:58 -0700
Subject: [PATCH 06/24] xfs: pack icreate initialization parameters into a
 separate structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417998.3183075.10914239409938164350.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_util.h |   22 ++++++++++
 fs/xfs/scrub/tempfile.c        |   12 +++--
 fs/xfs/xfs_inode.c             |   89 ++++++++++++++++++++++++++--------------
 fs/xfs/xfs_inode.h             |    6 +--
 fs/xfs/xfs_qm.c                |    6 ++-
 fs/xfs/xfs_symlink.c           |   12 ++++-
 6 files changed, 101 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index f7e4d5a8235dd..9226482fdee8c 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -13,4 +13,26 @@ uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
 prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
 
+/*
+ * File creation context.
+ *
+ * Due to our only partial reliance on the VFS to propagate uid and gid values
+ * according to accepted Unix behaviors, callers must initialize idmap to the
+ * correct idmapping structure to get the correct inheritance behaviors when
+ * XFS_MOUNT_GRPID is set.
+ *
+ * To create files detached from the directory tree (e.g. quota inodes), set
+ * idmap to NULL.  To create a tree root, set pip to NULL.
+ */
+struct xfs_icreate_args {
+	struct mnt_idmap	*idmap;
+	struct xfs_inode	*pip;	/* parent inode or null */
+	dev_t			rdev;
+	umode_t			mode;
+
+#define XFS_ICREATE_TMPFILE	(1U << 0)  /* create an unlinked file */
+#define XFS_ICREATE_INIT_XATTRS	(1U << 1)  /* will set xattrs immediately */
+	uint16_t		flags;
+};
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index b747b625c5ee4..ee6f93e9f7cba 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -40,6 +40,11 @@ xrep_tempfile_create(
 	struct xfs_scrub	*sc,
 	uint16_t		mode)
 {
+	struct xfs_icreate_args	args = {
+		.pip		= sc->mp->m_rootip,
+		.mode		= mode,
+		.flags		= XFS_ICREATE_TMPFILE,
+	};
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_dquot	*udqp = NULL;
@@ -87,14 +92,11 @@ xrep_tempfile_create(
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
index e98b636731417..4ceefe32b5854 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -662,18 +662,13 @@ xfs_inode_inherit_flags2(
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
@@ -706,27 +701,44 @@ xfs_init_new_inode(
 
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	set_nlink(inode, nlink);
-	inode->i_rdev = rdev;
-	ip->i_projid = prid;
 
-	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
-		inode_fsuid_set(inode, idmap);
-		inode->i_gid = dir->i_gid;
-		inode->i_mode = mode;
+	if (args->flags & XFS_ICREATE_TMPFILE)
+		set_nlink(inode, 0);
+	else if (S_ISDIR(args->mode))
+		set_nlink(inode, 2);
+	else
+		set_nlink(inode, 1);
+	inode->i_rdev = args->rdev;
+
+	if (!args->idmap || pip == NULL) {
+		/* creating a tree root, sb rooted, or detached file */
+		inode->i_uid = GLOBAL_ROOT_UID;
+		inode->i_gid = GLOBAL_ROOT_GID;
+		ip->i_projid = 0;
+		inode->i_mode = args->mode;
 	} else {
-		inode_init_owner(idmap, inode, dir, mode);
+		/* creating a child in the directory tree */
+		if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
+			inode_fsuid_set(inode, args->idmap);
+			inode->i_gid = dir->i_gid;
+			inode->i_mode = args->mode;
+		} else {
+			inode_init_owner(args->idmap, inode, dir, args->mode);
+		}
+
+		/*
+		 * If the group ID of the new file does not match the effective
+		 * group ID or one of the supplementary group IDs, the S_ISGID
+		 * bit is cleared (and only if the irix_sgid_inherit
+		 * compatibility variable is set).
+		 */
+		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
+		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
+			inode->i_mode &= ~S_ISGID;
+
+		ip->i_projid = pip ? xfs_get_initial_prid(pip) : 0;
 	}
 
-	/*
-	 * If the group ID of the new file does not match the effective group
-	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
-	 * (and only if the irix_sgid_inherit compatibility variable is set).
-	 */
-	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-	    !vfsgid_in_group_p(i_gid_into_vfsgid(idmap, inode)))
-		inode->i_mode &= ~S_ISGID;
-
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
@@ -745,7 +757,7 @@ xfs_init_new_inode(
 	}
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
@@ -778,7 +790,7 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs) {
+	if (args->flags & XFS_ICREATE_INIT_XATTRS) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 
@@ -941,6 +953,13 @@ xfs_create(
 	bool			init_xattrs,
 	xfs_inode_t		**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.idmap		= idmap,
+		.pip		= dp,
+		.rdev		= rdev,
+		.mode		= mode,
+		.flags		= init_xattrs ? XFS_ICREATE_INIT_XATTRS : 0,
+	};
 	int			is_dir = S_ISDIR(mode);
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
@@ -1016,8 +1035,7 @@ xfs_create(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1125,11 +1143,17 @@ xfs_create_tmpfile(
 	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.idmap		= idmap,
+		.pip		= dp,
+		.mode		= mode,
+		.flags		= XFS_ICREATE_TMPFILE,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	prid_t                  prid;
+	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
@@ -1141,6 +1165,8 @@ xfs_create_tmpfile(
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
+	if (init_xattrs)
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
@@ -1164,8 +1190,7 @@ xfs_create_tmpfile(
 
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, init_xattrs, &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 15ab7a1c79a60..7d3fea66e069e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -554,10 +554,8 @@ int		xfs_iflush_cluster(struct xfs_buf *);
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
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 47120b745c47f..78f839630c624 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -793,12 +793,14 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
+		struct xfs_icreate_args	args = {
+			.mode		= S_IFREG,
+		};
 		xfs_ino_t	ino;
 
 		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
 		if (!error)
-			error = xfs_init_new_inode(&nop_mnt_idmap, tp, NULL, ino,
-					S_IFREG, 1, 0, 0, false, ipp);
+			error = xfs_icreate(tp, ino, &args, ipp);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 53ed512c6f211..3b797a39950d5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -90,6 +90,11 @@ xfs_symlink(
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_icreate_args	args = {
+		.idmap		= idmap,
+		.pip		= dp,
+		.mode		= S_IFLNK | (mode & ~S_IFMT),
+	};
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
 	int			error = 0;
@@ -111,6 +116,9 @@ xfs_symlink(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	if (xfs_has_parent(mp))
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
+
 	/*
 	 * Check component lengths of the target path name.
 	 */
@@ -170,9 +178,7 @@ xfs_symlink(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
 	if (!error)
-		error = xfs_init_new_inode(idmap, tp, dp, ino,
-				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				xfs_has_parent(mp), &ip);
+		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)
 		goto out_trans_cancel;
 

