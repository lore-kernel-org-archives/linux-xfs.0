Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDAC23AD
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831427; cv=none; b=Smfy7ztIV+36FgpjnmtjhBO2974fn3cxJz1HaFPYueObh/HK1TdqaFhzfCTSetWWi0WLe+h1OQAkz/d+rVEaxKvMjdUU5yVcpwOr8c0NR72FrBUxbdGhRTSAaFPm19TgBs9OTxa2aoMD7k8GHxsG+zKZ4t5/Q6CtnVIVflBTN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831427; c=relaxed/simple;
	bh=ed4t1GB13HVItfVJkjLBJh4xtspGMnKzIqinhJ1kHKA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/dnBwjEvECRFq4qoEEniDOWvpTRAe416Y7dFsuC+Z1AOsIx3DdHDWS0sYKPBAANE2rJqM20U4c9us+ygbNp0rt1AwT8k+R+TmU0fkRHnDKUvzWqB7p9s9/1uJhtfUd7KPRIVgqJV+XdRCoRhAayu86w+ZDwccPgsGhi72uCA20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoadVuIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoadVuIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FCDC4CEC6;
	Wed,  2 Oct 2024 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831427;
	bh=ed4t1GB13HVItfVJkjLBJh4xtspGMnKzIqinhJ1kHKA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hoadVuIWp7WU9qPS0fHWjH/Bk2/Eu0t4ONO/7kEEXkVyuNxFsbaCd7YC3z0wIq+AB
	 bE3tLHjj9/YPqG+7/vlP3fVdyuL8tjOgXaywj54NjZGBDE8vyVKocAgK41gJl2ziBH
	 3nKVOsLgNYDPUSC4J1yZ5Jo2Q/wm7f68kAYhvQ1RHl+X8IA3Z7W99lHyZVUaNPV9sG
	 gXvInsfVbQcO4hvHacXHCvJeCwhkRXP/8RYCVdEGALfvAmI535A/5r1Mc+irWUyKUP
	 FUTkhTKfA4H9CqlEuW5GvL7kdJvSNiCOYvem19+tUoMiyn+EwQdTIh3X+8uU82Trhe
	 MCaN5dootU1Ow==
Date: Tue, 01 Oct 2024 18:10:26 -0700
Subject: [PATCH 10/64] libxfs: pack icreate initialization parameters into a
 separate structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101931.4036371.14344135580605192716.stgit@frogsfrogsfrogs>
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

Source kernel commit: ba4b39fe4c011078469dcd28f51447d75852d21c

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
 include/xfs_inode.h |   46 +++++++++++++++++----
 libxfs/inode.c      |  114 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 117 insertions(+), 43 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 17d3da6ae..4142c45e4 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -7,6 +7,36 @@
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
+#define KUIDT_INIT(value) (kuid_t){ value }
+#define KGIDT_INIT(value) (kgid_t){ value }
+#define GLOBAL_ROOT_UID KUIDT_INIT(0)
+#define GLOBAL_ROOT_GID KGIDT_INIT(0)
+
 /* These match kernel side includes */
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
@@ -34,8 +64,8 @@ static inline bool IS_I_VERSION(const struct inode *inode) { return false; }
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
@@ -50,19 +80,19 @@ struct inode {
 
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
-static inline void i_uid_write(struct inode *inode, uint32_t uid)
+static inline void i_uid_write(struct inode *inode, uid_t uid)
 {
-	inode->i_uid = uid;
+	inode->i_uid.val = uid;
 }
-static inline void i_gid_write(struct inode *inode, uint32_t gid)
+static inline void i_gid_write(struct inode *inode, gid_t gid)
 {
-	inode->i_gid = gid;
+	inode->i_gid.val = gid;
 }
 
 static inline void ihold(struct inode *inode)
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 2af7e8fe9..9ccc22adf 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -82,18 +82,16 @@ libxfs_bumplink(
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
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*pip = args->pip;
+	struct inode		*dir = pip ? VFS_I(pip) : NULL;
+	struct inode		*inode;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
 	int			error;
@@ -103,48 +101,47 @@ libxfs_init_new_inode(
 		return error;
 	ASSERT(ip != NULL);
 
-	VFS_I(ip)->i_mode = mode;
-	set_nlink(VFS_I(ip), nlink);
-	i_uid_write(VFS_I(ip), cr->cr_uid);
-	i_gid_write(VFS_I(ip), cr->cr_gid);
-	ip->i_projid = pip ? 0 : fsx->fsx_projid;
+	inode = VFS_I(ip);
+	inode->i_mode = args->mode;
+	if (args->flags & XFS_ICREATE_TMPFILE)
+		set_nlink(inode, 0);
+	else if (S_ISDIR(args->mode))
+		set_nlink(inode, 2);
+	else
+		set_nlink(inode, 1);
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
+	ip->i_projid = 0;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
-	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		if (!(cr->cr_flags & CRED_FORCE_GID))
-			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
-			VFS_I(ip)->i_mode |= S_ISGID;
+	if (pip && (dir->i_mode & S_ISGID)) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(args->mode))
+			inode->i_mode |= S_ISGID;
 	}
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
-	ip->i_extsize = pip ? 0 : fsx->fsx_extsize;
-	ip->i_diflags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
+	ip->i_extsize = 0;
+	ip->i_diflags = 0;
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
-		VFS_I(ip)->i_version = 1;
+		inode->i_version = 1;
 		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		if (!pip)
-			ip->i_diflags2 = xfs_flags2diflags2(ip,
-							fsx->fsx_xflags);
-		ip->i_crtime = inode_get_mtime(VFS_I(ip)); /* struct copy */
-		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
+		ip->i_crtime = inode_get_mtime(inode); /* struct copy */
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
@@ -161,10 +158,16 @@ libxfs_init_new_inode(
 	}
 
 	/*
-	 * If we're going to set a parent pointer on this file, we need to
-	 * create an attr fork to receive that parent pointer.
+	 * If we need to create attributes immediately after allocating the
+	 * inode, initialise an empty attribute fork right now. We use the
+	 * default fork offset for attributes here as we don't know exactly what
+	 * size or how many attributes we might be adding. We can do this
+	 * safely here because we know the data fork is completely empty and
+	 * this saves us from needing to run a separate transaction to set the
+	 * fork offset in the immediate future.
 	 */
-	if (pip && xfs_has_parent(mp)) {
+	if ((args->flags & XFS_ICREATE_INIT_XATTRS) &&
+	    (xfs_has_attr(tp->t_mountp) || xfs_has_attr2(tp->t_mountp))) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 
@@ -270,10 +273,27 @@ libxfs_dir_ialloc(
 	struct fsxattr		*fsx,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_icreate_args	args = {
+		.pip		= dp,
+		.mode		= mode,
+	};
+	struct xfs_inode	*ip;
+	struct inode		*inode;
 	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
+	if (dp && xfs_has_parent(dp->i_mount))
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
+
+	/* Only devices get rdev numbers */
+	switch (mode & S_IFMT) {
+	case S_IFCHR:
+	case S_IFBLK:
+		args.rdev = rdev;
+		break;
+	}
+
 	/*
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
@@ -282,8 +302,32 @@ libxfs_dir_ialloc(
 	if (error)
 		return error;
 
-	return libxfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, cr,
-				fsx, ipp);
+	error = libxfs_icreate(*tpp, ino, &args, &ip);
+	if (error)
+		return error;
+
+	inode = VFS_I(ip);
+	i_uid_write(inode, cr->cr_uid);
+	if (cr->cr_flags & CRED_FORCE_GID)
+		i_gid_write(inode, cr->cr_gid);
+	set_nlink(inode, nlink);
+
+	/* If there is no parent dir, initialize the file from fsxattr data. */
+	if (dp == NULL) {
+		ip->i_projid = fsx->fsx_projid;
+		ip->i_extsize = fsx->fsx_extsize;
+		ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
+
+		if (xfs_has_v3inodes(ip->i_mount)) {
+			ip->i_diflags2 = xfs_flags2diflags2(ip,
+							fsx->fsx_xflags);
+			ip->i_cowextsize = fsx->fsx_cowextsize;
+		}
+	}
+
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	*ipp = ip;
+	return 0;
 }
 
 /*

