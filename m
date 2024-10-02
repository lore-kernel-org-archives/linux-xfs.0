Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11112107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831552; cv=none; b=ArQx/Ax77ttJjgWZxARIUMg74yXgDZeY/DIrNjG6encnu802JBRuqGbvsy+WsBnP0MgQqVKgHsqXUxd6E1A7d05tWs0FPVt0ORlHBGhgrURPs6s/bTm66yTfPmQoOFN3Ne3QRiHmmV0mRX0AThiFmocq++WqaWOjxA2C15UJbiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831552; c=relaxed/simple;
	bh=tXTqCziriNAqLRhFO0T3ae8Kfps+VE9RWp4Vt5Hey3Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ms2HnEPy1dpYzHKh7y/Kg+h/QIuYpmOd8am1TYz2fL+j+iNd81RzBmer59SSGpmgnwawGdiDnt+IjMQXMEqh7wrB/9cp6y+7bKhEYbux7f/pGbyd4tMGQVZVvNZoPkdi220oaVb36nHyjsF8Y5xM0rkuum6/A0vcmBQiBMlJkrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rsp8T1W8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rsp8T1W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F07AC4CEC6;
	Wed,  2 Oct 2024 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831552;
	bh=tXTqCziriNAqLRhFO0T3ae8Kfps+VE9RWp4Vt5Hey3Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rsp8T1W8+iXhSWcD7YDCIG9hWQ5G2u8CnwDzN2D5RJsUKK4GYmnVl7MLbBV20jCfJ
	 u4RU/NBoJNrl8rqzU0E2A8twEhIVr9pGgTM7VlEJsZnKPw7sGAnL+n38E9jyAsck5z
	 01p1kVJYerlZy7l42Wd/T9EnsAk5L4I0Db5oKWPfB5TkW4X2dZcgWst2M0OIm/MFi6
	 w11sR9F5eNHTl1Jb72ztlObLcks0qL8CqOHMQZnAECrWUGFE87EmKCFPYRzrEnJ5ge
	 Yxo1xaMNtW7Y7u9qa9ZhGy1sTxIzX8yntO47T/ZwbGo7TXrdN6JyGyxo4w1X14gR6D
	 1CHoYP/9r8r2A==
Date: Tue, 01 Oct 2024 18:12:31 -0700
Subject: [PATCH 18/64] libxfs: backport inode init code from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783102052.4036371.16066393511881832802.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Reorganize the userspace inode initialization code to more closely
resemble its kernel counterpart.  This is preparation to hoist the
initialization routines to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |   20 +++++++++++++++
 include/xfs_mount.h  |    8 ++++++
 libxfs/inode.c       |   68 +++++++++++++++++++++++++++++++++++++-------------
 libxfs/libxfs_priv.h |   10 +++++++
 4 files changed, 88 insertions(+), 18 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 4142c45e4..d2f391ea8 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -78,6 +78,12 @@ struct inode {
 	spinlock_t		i_lock;
 };
 
+static inline void
+inode_set_iversion(struct inode *inode, uint64_t version)
+{
+	inode->i_version = version;
+}
+
 static inline uint32_t i_uid_read(struct inode *inode)
 {
 	return inode->i_uid.val;
@@ -95,6 +101,18 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
 	inode->i_gid.val = gid;
 }
 
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
 static inline void ihold(struct inode *inode)
 {
 	inode->i_count++;
@@ -408,4 +426,6 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_DEFAULT_COWEXTSZ_HINT	32
 
+#define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index a9525e4e0..4492a2f28 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -228,6 +228,7 @@ __XFS_UNSUPP_FEAT(ikeep)
 __XFS_UNSUPP_FEAT(swalloc)
 __XFS_UNSUPP_FEAT(small_inums)
 __XFS_UNSUPP_FEAT(readonly)
+__XFS_UNSUPP_FEAT(grpid)
 
 /* Operational mount state flags */
 #define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
@@ -308,4 +309,11 @@ static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
 	cache_purge(btp->bcache);
 }
 
+struct mnt_idmap {
+	/* empty */
+};
+
+/* bogus idmapping so that mkfs can do directory inheritance correctly */
+#define libxfs_nop_idmap	((struct mnt_idmap *)1)
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 206b779a8..dda9b778d 100644
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
@@ -106,35 +106,52 @@ xfs_inode_init(
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
 
-	inode->i_mode = args->mode;
 	if (args->flags & XFS_ICREATE_TMPFILE)
 		set_nlink(inode, 0);
 	else if (S_ISDIR(args->mode))
 		set_nlink(inode, 2);
 	else
 		set_nlink(inode, 1);
-	inode->i_uid = GLOBAL_ROOT_UID;
-	inode->i_gid = GLOBAL_ROOT_GID;
-	ip->i_projid = 0;
+	inode->i_rdev = args->rdev;
 
-	if (pip && (dir->i_mode & S_ISGID)) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(args->mode))
-			inode->i_mode |= S_ISGID;
+	if (!args->idmap || pip == NULL) {
+		/* creating a tree root, sb rooted, or detached file */
+		inode->i_uid = GLOBAL_ROOT_UID;
+		inode->i_gid = GLOBAL_ROOT_GID;
+		ip->i_projid = 0;
+		inode->i_mode = args->mode;
+	} else {
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
 
-	if (pip)
-		ip->i_projid = libxfs_get_initial_prid(pip);
-
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
+
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
 
-	if (xfs_has_v3inodes(ip->i_mount)) {
-		inode->i_version = 1;
-		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	if (xfs_has_v3inodes(mp)) {
+		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
@@ -149,15 +166,14 @@ xfs_inode_init(
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
-		/* FALLTHROUGH */
+		fallthrough;
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_bytes = 0;
@@ -391,6 +407,7 @@ libxfs_iget(
 	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
@@ -472,3 +489,18 @@ libxfs_irele(
 		kmem_cache_free(xfs_inode_cache, ip);
 	}
 }
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
index 0bf0c54ac..ecacfff82 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -225,6 +225,12 @@ static inline bool WARN_ON(bool expr) {
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
@@ -639,4 +645,8 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 #define cond_resched()	((void)0)
 
+/* xfs_linux.h */
+#define irix_sgid_inherit		(false)
+#define vfsgid_in_group_p(...)		(false)
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */

