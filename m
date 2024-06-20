Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE039856
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924539; cv=none; b=o7/XIAdNOihpfP7cFEYYbU1EiJCEMbWS7Uxrmoq9v1RqpEHbCime9asiHtR5rdzPd5vEynQLaHJpeMJzY8lMAXvzWPGKmhqPoT3WGib9AhA2Lx6bgFG105KmGM1Qt3b0wY7VoXnAIh5MGfpNN9ib1RJejMKAsmMrZOd1yAJxMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924539; c=relaxed/simple;
	bh=EiMC1Mxil1ldr7UujNtMLHhzc2+sSi0OdZ9pg212Qn0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+YBmkjV6UVXSZc411E4S7RsDY8WZEQ1H/z0G6LGBDDSpPcA6RYYSJdoetvePwq908cwfMju1uYhcXQFloFaRrK1Dmvar60dYBLkgQq78TapROiMLM4sjv5osKLu1R4yeq7tA2q8+4fNT1kJNQCnLoYAwqBV9JI3GRC2XWvDOmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxvXtL0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxvXtL0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C413C2BD10;
	Thu, 20 Jun 2024 23:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924539;
	bh=EiMC1Mxil1ldr7UujNtMLHhzc2+sSi0OdZ9pg212Qn0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VxvXtL0TzldQuXbkVcGVBE2E1Zdnfn85axJSdPlryHHuGMpzF4oqe3xbJtyv06qH6
	 0YjpLN0VpMrP+CvLxCzx7woobuCgngCfFwK10C5Vp28ShYv4ed5xLBsB3+/syMOJ5q
	 SAHcHs/ZbWFd/Omy+lnyIYdSLxQdpriNMFbyGzDbT/t03+Sxkr6eQ92mU78RgOxhwX
	 25rZ/4Kcl24LvOBkFI3yQJ9OuXTLFhr2K2GTMZQKGo5MoHIF8HrclCzl/2mVVCq/CS
	 U5GpWOAMPcPnYWgkJv3rzwbNXWLUCJHiiXq7fRrqFdZtDRZYkxYCAwfNVs/2Sb1XAP
	 Zil4aa65fXacA==
Date: Thu, 20 Jun 2024 16:02:18 -0700
Subject: [PATCH 15/24] xfs: separate the icreate logic around INIT_XATTRS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418155.3183075.2421928430504613482.stgit@frogsfrogsfrogs>
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

INIT_XATTRS is overloaded here -- it's set during the creat process when
we think that we're immediately going to set some ACL xattrs to save
time.  However, it's also used by the parent pointers code to enable the
attr fork in preparation to receive ppptr xattrs.  This results in
xfs_has_parent() branches scattered around the codebase to turn on
INIT_XATTRS.

Linkable files are created far more commonly than unlinkable temporary
files or directory tree roots, so we should centralize this logic in
xfs_inode_init.  For the three callers that don't want parent pointers
(online repiar tempfiles, unlinkable tempfiles, rootdir creation) we
provide an UNLINKABLE flag to skip attr fork initialization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   36 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_inode_util.h |    1 +
 fs/xfs/scrub/tempfile.c        |    2 +-
 fs/xfs/xfs_inode.c             |    3 ---
 fs/xfs/xfs_iops.c              |   11 ++++-------
 fs/xfs/xfs_qm.c                |    1 +
 fs/xfs/xfs_symlink.c           |    3 ---
 7 files changed, 33 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 214976ecefd77..5795445ef4bd2 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -233,6 +233,31 @@ xfs_inode_inherit_flags2(
 	}
 }
 
+/*
+ * If we need to create attributes immediately after allocating the inode,
+ * initialise an empty attribute fork right now. We use the default fork offset
+ * for attributes here as we don't know exactly what size or how many
+ * attributes we might be adding. We can do this safely here because we know
+ * the data fork is completely empty and this saves us from needing to run a
+ * separate transaction to set the fork offset in the immediate future.
+ *
+ * If we have parent pointers and the caller hasn't told us that the file will
+ * never be linked into a directory tree, we /must/ create the attr fork.
+ */
+static inline bool
+xfs_icreate_want_attrfork(
+	struct xfs_mount		*mp,
+	const struct xfs_icreate_args	*args)
+{
+	if (args->flags & XFS_ICREATE_INIT_XATTRS)
+		return true;
+
+	if (!(args->flags & XFS_ICREATE_UNLINKABLE) && xfs_has_parent(mp))
+		return true;
+
+	return false;
+}
+
 /* Initialise an inode's attributes. */
 void
 xfs_inode_init(
@@ -325,16 +350,7 @@ xfs_inode_init(
 		ASSERT(0);
 	}
 
-	/*
-	 * If we need to create attributes immediately after allocating the
-	 * inode, initialise an empty attribute fork right now. We use the
-	 * default fork offset for attributes here as we don't know exactly what
-	 * size or how many attributes we might be adding. We can do this
-	 * safely here because we know the data fork is completely empty and
-	 * this saves us from needing to run a separate transaction to set the
-	 * fork offset in the immediate future.
-	 */
-	if (args->flags & XFS_ICREATE_INIT_XATTRS) {
+	if (xfs_icreate_want_attrfork(mp, args)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 50c14ba6ca5a2..1c54c3b0cf262 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -32,6 +32,7 @@ struct xfs_icreate_args {
 
 #define XFS_ICREATE_TMPFILE	(1U << 0)  /* create an unlinked file */
 #define XFS_ICREATE_INIT_XATTRS	(1U << 1)  /* will set xattrs immediately */
+#define XFS_ICREATE_UNLINKABLE	(1U << 2)  /* cannot link into dir tree */
 	uint16_t		flags;
 };
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 523971a15a72a..d390d56cd8751 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -43,7 +43,7 @@ xrep_tempfile_create(
 	struct xfs_icreate_args	args = {
 		.pip		= sc->mp->m_rootip,
 		.mode		= mode,
-		.flags		= XFS_ICREATE_TMPFILE,
+		.flags		= XFS_ICREATE_TMPFILE | XFS_ICREATE_UNLINKABLE,
 	};
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = NULL;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c59c6321e361a..dd8e189175d53 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2512,9 +2512,6 @@ xfs_rename_alloc_whiteout(
 	struct qstr		name;
 	int			error;
 
-	if (xfs_has_parent(dp->i_mount))
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
-
 	error = xfs_create_tmpfile(&args, &tmpfile);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4563ba440570b..07f736c42460b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -158,8 +158,6 @@ xfs_create_need_xattr(
 	if (dir->i_sb->s_security)
 		return true;
 #endif
-	if (xfs_has_parent(XFS_I(dir)->i_mount))
-		return true;
 	return false;
 }
 
@@ -215,12 +213,11 @@ xfs_generic_create(
 		args.flags |= XFS_ICREATE_TMPFILE;
 
 		/*
-		 * If this temporary file will be linkable, set up the file
-		 * with an attr fork to receive a parent pointer.
+		 * If this temporary file will not be linkable, don't bother
+		 * creating an attr fork to receive a parent pointer.
 		 */
-		if (!(tmpfile->f_flags & O_EXCL) &&
-		    xfs_has_parent(XFS_I(dir)->i_mount))
-			args.flags |= XFS_ICREATE_INIT_XATTRS;
+		if (tmpfile->f_flags & O_EXCL)
+			args.flags |= XFS_ICREATE_UNLINKABLE;
 
 		error = xfs_create_tmpfile(&args, &ip);
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 78f839630c624..9490b913a4ab4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -795,6 +795,7 @@ xfs_qm_qino_alloc(
 	if (need_alloc) {
 		struct xfs_icreate_args	args = {
 			.mode		= S_IFREG,
+			.flags		= XFS_ICREATE_UNLINKABLE,
 		};
 		xfs_ino_t	ino;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 6ff736e5c4e7f..e471369f6b634 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -115,9 +115,6 @@ xfs_symlink(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	if (xfs_has_parent(mp))
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
-
 	/*
 	 * Check component lengths of the target path name.
 	 */

