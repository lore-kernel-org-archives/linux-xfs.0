Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500D3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiLaCEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:04:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1E9140DE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C34561CAA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7193C433D2;
        Sat, 31 Dec 2022 02:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452277;
        bh=VdSItYacWaQFCe8dud2wFaM30HEoSzH9jW3/e5UxbAg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IkzNZYe7ocw96jVw+iQOqIJNPPLuOhqmcd4wz2EslYD1ddVVXD0MD12d7inQdGM1d
         DkNXp6/6Q2zAkaayiPxHAlQDUfIoEdci5CjwwoW8XrugemynBylXHEsCOxyGngz86+
         xV6OFGYByRh+951ppMMAf53joUkHNbYVyO0Qx2pjNY+31I6zCekDFA6TfofdDKQ2OV
         9bTFRA0kbVm+HTrhxMkemDkLeEplS6ChRj4NJtEc20oLKJ5OECAlYEnI8DM6UCNfh/
         Di3lQOwMcehMUTK7u8llDMBR98VXPjgstFQkiAM+9CXTgx2RqPzcki3waqbCvVuJSj
         a462ctxnY47QQ==
Subject: [PATCH 06/26] libxfs: pack icreate initialization parameters into a
 separate structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875397.723621.6141500117189027371.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
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

(A subsequent cleanup will also fix the quota alloc calls and remove
libxfs_dir_ialloc entirely.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |   37 +++++++++++++++++++----
 libxfs/inode.c          |   75 ++++++++++++++++++++++++++++-------------------
 libxfs/xfs_inode_util.h |   31 +++++++++++++++++++
 3 files changed, 107 insertions(+), 36 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index ef62ac50912..bf8322ee2ec 100644
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
@@ -33,8 +58,8 @@ struct xfs_inode_log_item;
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
@@ -49,19 +74,19 @@ struct inode {
 
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
index 588aff33ef4..63150422b01 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -64,17 +64,13 @@ xfs_inode_propagate_flags(
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
@@ -84,48 +80,41 @@ libxfs_init_new_inode(
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
-		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
-		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
+		ip->i_crtime = VFS_I(ip)->i_mtime;
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
@@ -235,10 +224,22 @@ libxfs_dir_ialloc(
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
 	/*
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
@@ -247,8 +248,22 @@ libxfs_dir_ialloc(
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
index f7e4d5a8235..466f0767ab5 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
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

