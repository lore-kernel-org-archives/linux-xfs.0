Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D8EC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEcEY/Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32408C433C7;
	Sun, 31 Dec 2023 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065032;
	bh=0TNEmZL/VuEz6hbZhmL4rqKMbGwYQb6stOhR4Zm+qFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oEcEY/LzPQsOlbs9SUzJnrpvNfDb/3JiYNS4LgFekuT1tLXRVIezkVDfw8sgi2zzR
	 ukyMgNgzWGsIdqkFtehOrnsgBskIYBuXTbmAA4YCoBq3pvg8Anqpa4FgIy08hmbgqB
	 GhDZYJt4qFiFvk8oktWVTRpyCtXar2pcCOxrhJR2+eC6iShGXdY86yD1X/NGd42qkO
	 htzsIAzML0Lyj3p29FF7xRYl+gGpg/0ta2lcbb8ce2+teRsBUliGDmz3wFA4eHYbSv
	 sa0fJkmGCBVBR52ddxGSXWm9ZSihVcyrzjNYcKdJrNHoiqh5F9uusoJr3fm/KW34cR
	 4gnQJItuDoD9w==
Date: Sun, 31 Dec 2023 15:23:51 -0800
Subject: [PATCH 06/28] xfs: pack icreate initialization parameters into a
 separate structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009257.1808635.16819139313808141621.stgit@frogsfrogsfrogs>
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
 include/xfs_inode.h     |   37 +++++++++++++++++++---
 libxfs/inode.c          |   78 +++++++++++++++++++++++++++++------------------
 libxfs/xfs_inode_util.h |   32 +++++++++++++++++++
 3 files changed, 111 insertions(+), 36 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index d75269cb414..04d971e744b 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -7,6 +7,31 @@
 #ifndef __XFS_INODE_H__
 #define __XFS_INODE_H__
 
+/*
+ * Borrow the kernel's uid/gid types.  These are used by xfs_inode_util.h, so
+ * they must come first in the header file.
+ */
+
+typedef struct {
+	uid_t val;
+} kuid_t;
+
+typedef struct {
+	gid_t val;
+} kgid_t;
+
+static inline kuid_t make_kuid(uid_t uid)
+{
+	kuid_t	v = { .val = uid };
+	return v;
+}
+
+static inline kgid_t make_kgid(gid_t gid)
+{
+	kgid_t	v = { .val = gid };
+	return v;
+}
+
 /* These match kernel side includes */
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
@@ -34,8 +59,8 @@ static inline bool IS_I_VERSION(const struct inode *inode) { return false; }
  */
 struct inode {
 	mode_t			i_mode;
-	uint32_t		i_uid;
-	uint32_t		i_gid;
+	kuid_t			i_uid;
+	kgid_t			i_gid;
 	uint32_t		i_nlink;
 	xfs_dev_t		i_rdev;	 /* This actually holds xfs_dev_t */
 	unsigned int		i_count;
@@ -50,19 +75,19 @@ struct inode {
 
 static inline uint32_t i_uid_read(struct inode *inode)
 {
-	return inode->i_uid;
+	return inode->i_uid.val;
 }
 static inline uint32_t i_gid_read(struct inode *inode)
 {
-	return inode->i_gid;
+	return inode->i_gid.val;
 }
 static inline void i_uid_write(struct inode *inode, uint32_t uid)
 {
-	inode->i_uid = uid;
+	inode->i_uid.val = uid;
 }
 static inline void i_gid_write(struct inode *inode, uint32_t gid)
 {
-	inode->i_gid = gid;
+	inode->i_gid.val = gid;
 }
 
 static inline void ihold(struct inode *inode)
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 68e68ee83e3..433755a18ba 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -82,17 +82,13 @@ libxfs_bumplink(
  * caller locked exclusively.
  */
 static int
-libxfs_init_new_inode(
+libxfs_icreate(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*pip,
 	xfs_ino_t		ino,
-	umode_t			mode,
-	xfs_nlink_t		nlink,
-	dev_t			rdev,
-	struct cred		*cr,
-	struct fsxattr		*fsx,
+	const struct xfs_icreate_args *args,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_inode	*pip = args->pip;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
 	int			error;
@@ -102,48 +98,41 @@ libxfs_init_new_inode(
 		return error;
 	ASSERT(ip != NULL);
 
-	VFS_I(ip)->i_mode = mode;
-	set_nlink(VFS_I(ip), nlink);
-	i_uid_write(VFS_I(ip), cr->cr_uid);
-	i_gid_write(VFS_I(ip), cr->cr_gid);
-	ip->i_projid = pip ? 0 : fsx->fsx_projid;
+	VFS_I(ip)->i_mode = args->mode;
+	set_nlink(VFS_I(ip), args->nlink);
+	VFS_I(ip)->i_uid = args->uid;
+	ip->i_projid = args->prid;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		if (!(cr->cr_flags & CRED_FORCE_GID))
+		if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
 			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
+		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
 			VFS_I(ip)->i_mode |= S_ISGID;
-	}
+	} else
+		VFS_I(ip)->i_gid = args->gid;
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
-	ip->i_extsize = pip ? 0 : fsx->fsx_extsize;
-	ip->i_diflags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
-
+	ip->i_extsize = 0;
+	ip->i_diflags = 0;
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		if (!pip)
-			ip->i_diflags2 = xfs_flags2diflags2(ip,
-							fsx->fsx_xflags);
-		ip->i_crtime = VFS_I(ip)->__i_mtime; /* struct copy */
-		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
+		ip->i_crtime = VFS_I(ip)->__i_mtime;
+		ip->i_cowextsize = 0;
 	}
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFSOCK:
-		/* doesn't make sense to set an rdev for these */
-		rdev = 0;
-		/* FALLTHROUGH */
 	case S_IFCHR:
 	case S_IFBLK:
 		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
 		flags |= XFS_ILOG_DEV;
-		VFS_I(ip)->i_rdev = rdev;
+		VFS_I(ip)->i_rdev = args->rdev;
 		break;
 	case S_IFREG:
 	case S_IFDIR:
@@ -267,10 +256,25 @@ libxfs_dir_ialloc(
 	struct fsxattr		*fsx,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.pip		= dp,
+		.uid		= make_kuid(cr->cr_uid),
+		.gid		= make_kgid(cr->cr_gid),
+		.nlink		= nlink,
+		.rdev		= rdev,
+		.mode		= mode,
+	};
+	struct xfs_inode	*ip;
 	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
+	if (cr->cr_flags & CRED_FORCE_GID)
+		args.flags |= XFS_ICREATE_ARGS_FORCE_GID;
+
+	if (dp && xfs_has_parent(dp->i_mount))
+		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+
 	/*
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
@@ -279,8 +283,22 @@ libxfs_dir_ialloc(
 	if (error)
 		return error;
 
-	return libxfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, cr,
-				fsx, ipp);
+	error = libxfs_icreate(*tpp, ino, &args, ipp);
+	if (error || dp)
+		return error;
+
+	/* If there is no parent dir, initialize the file from fsxattr data. */
+	ip = *ipp;
+	ip->i_projid = fsx->fsx_projid;
+	ip->i_extsize = fsx->fsx_extsize;
+	ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
+
+	if (xfs_has_v3inodes(ip->i_mount)) {
+		ip->i_diflags2 = xfs_flags2diflags2(ip, fsx->fsx_xflags);
+		ip->i_cowextsize = fsx->fsx_cowextsize;
+	}
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	return 0;
 }
 
 /*
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index f7e4d5a8235..a494f7c4a3f 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
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

