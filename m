Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82FC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jk6h17Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E73C433C7;
	Sun, 31 Dec 2023 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065141;
	bh=JLB5CB7tkvBIA4CC5BHgcfwcrqpo0HZo7BKx2LlzeS0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jk6h17Ohtf3qrjdIAaz5gm8nUjKscgrkDIJXSXBQHFS6g8hXK3mz5CVvpWTgu3yuv
	 Zl1UC3M/NMSKWw6arAEa/k0bNhkr2dWqU+at9OmMifismkwDoJrBw5ho2NLKnkeHxB
	 5NvVMKwGGb/41K5kUjpnGUTakpgIqg+jOylYrB3JX/Zsdl+Ll1L44Zad4/4060Mqom
	 vHzKOgPEkdd6VR4qSOBc0+9cI1y/w4TsEZpp0ysauMV0b2lr0/kmNf7UvDXPzsPFLC
	 jr829xT2V5bkf9h0YJCgp954gaYE+mMOjItIoQQAoe+zZKBnktM9yytN4RPzsrYuP3
	 /iKdU1Qqb1jAg==
Date: Sun, 31 Dec 2023 15:25:41 -0800
Subject: [PATCH 13/28] libxfs: backport inode init code from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009349.1808635.5205988806153690005.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Reorganize the userspace inode initialization code to more closely resemble
its kernel counterpart.  This is preparation to hoist the initialization
routines to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |    2 +
 include/xfs_mount.h  |    1 +
 libxfs/inode.c       |   80 +++++++++++++++++++++++++++++++++++++++-----------
 libxfs/libxfs_priv.h |    6 ++++
 4 files changed, 71 insertions(+), 18 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 04d971e744b..45d53d1eb00 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -398,4 +398,6 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+#define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ec63c525fd4..da621f3b992 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -232,6 +232,7 @@ __XFS_UNSUPP_FEAT(ikeep)
 __XFS_UNSUPP_FEAT(swalloc)
 __XFS_UNSUPP_FEAT(small_inums)
 __XFS_UNSUPP_FEAT(readonly)
+__XFS_UNSUPP_FEAT(grpid)
 
 /* Operational mount state flags */
 #define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index b61ad0f9e09..3d92e888a16 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -31,7 +31,7 @@
 
 /* Propagate di_flags from a parent inode to a child inode. */
 static void
-xfs_inode_propagate_flags(
+xfs_inode_inherit_flags(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
@@ -99,31 +99,47 @@ xfs_inode_init(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode	*pip = args->pip;
+	struct inode		*dir = pip ? VFS_I(pip) : NULL;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
 
-	VFS_I(ip)->i_mode = args->mode;
-	set_nlink(VFS_I(ip), args->nlink);
-	VFS_I(ip)->i_uid = args->uid;
+	set_nlink(inode, args->nlink);
+	inode->i_rdev = args->rdev;
 	ip->i_projid = args->prid;
 
-	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
-			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
-			VFS_I(ip)->i_mode |= S_ISGID;
-	} else
-		VFS_I(ip)->i_gid = args->gid;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    xfs_has_grpid(mp)) {
+		inode->i_uid = args->uid;
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = args->mode;
+	} else {
+		inode_init_owner(args->idmap, inode, dir, args->mode);
+	}
+
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
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
+
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
+
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
 		ip->i_cowextsize = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
@@ -138,12 +154,11 @@ xfs_inode_init(
 	case S_IFBLK:
 		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
 		flags |= XFS_ILOG_DEV;
-		VFS_I(ip)->i_rdev = args->rdev;
 		break;
 	case S_IFREG:
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
-			xfs_inode_propagate_flags(ip, pip);
+			xfs_inode_inherit_flags(ip, pip);
 		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
 			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
@@ -165,7 +180,8 @@ xfs_inode_init(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (xfs_has_parent(tp->t_mountp) && xfs_has_attr(tp->t_mountp)) {
+	if ((args->flags & XFS_ICREATE_ARGS_INIT_XATTRS) &&
+	    xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -293,15 +309,15 @@ libxfs_dir_ialloc(
 		.nlink		= nlink,
 		.rdev		= rdev,
 		.mode		= mode,
+		.flags		= XFS_ICREATE_ARGS_FORCE_UID |
+				  XFS_ICREATE_ARGS_FORCE_GID |
+				  XFS_ICREATE_ARGS_FORCE_MODE,
 	};
 	struct xfs_inode	*ip;
 	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
-	if (cr->cr_flags & CRED_FORCE_GID)
-		args.flags |= XFS_ICREATE_ARGS_FORCE_GID;
-
 	if (dp && xfs_has_parent(dp->i_mount))
 		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 
@@ -361,6 +377,7 @@ libxfs_iget(
 	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
@@ -442,3 +459,30 @@ libxfs_irele(
 		kmem_cache_free(xfs_inode_cache, ip);
 	}
 }
+
+static inline void inode_fsuid_set(struct inode *inode,
+				   struct mnt_idmap *idmap)
+{
+	inode->i_uid = make_kuid(0);
+}
+
+static inline void inode_fsgid_set(struct inode *inode,
+				   struct mnt_idmap *idmap)
+{
+	inode->i_gid = make_kgid(0);
+}
+
+void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
+		      const struct inode *dir, umode_t mode)
+{
+	inode_fsuid_set(inode, idmap);
+	if (dir && dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+
+		/* Directories are special, and always inherit S_ISGID */
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode_fsgid_set(inode, idmap);
+	inode->i_mode = mode;
+}
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 90149b60c57..1609a8fd03f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -220,6 +220,12 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
+struct inode;
+struct mnt_idmap;
+
+void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
+		      const struct inode *dir, umode_t mode);
+
 #define __must_check	__attribute__((__warn_unused_result__))
 
 /*

