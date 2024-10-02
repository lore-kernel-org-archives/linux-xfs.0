Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379A55227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831599; cv=none; b=DQXlS6geEOIDqXB9+AdTKsEzSWYyIl6lOWZvhryuhj3t/EPOFVLCMwm6EQ8g09BTpN4yxXuUugUZyUXdpAY/EvZVwWoIudYPV6bJVI8D+55nDP7tisfin57Myam/EhEnotBL63xij2r7PU5qNYqWnIM9sIPkK6HGQOMA/KWeztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831599; c=relaxed/simple;
	bh=9jf1RQCM5ISJec5x0fQLODEQOt+Ll56Bf9FHvs7Cd4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hv4zAFDrI4IDIKEW+Gvz+KjdJ103L0kMACZAK6gq8JHwAda5QoxcWPUDNAzlSF7TzVZOLPUG6Cta9hHtSwmBIK5F1WtdM+JgO2kZQiIYHra41M0NLcefTvUvKKsjlNCTywsRzpVu5C3eKG4jn7w7/FEmIcvE0EVrYBDqJnp6V5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZliJRHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZliJRHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A082C4CEC6;
	Wed,  2 Oct 2024 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831599;
	bh=9jf1RQCM5ISJec5x0fQLODEQOt+Ll56Bf9FHvs7Cd4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AZliJRHjoZZH77zan2tEzZw8OH643I27UlKeZN5OBUusozrKP7omAfM7d/TSejCta
	 UMP0xf77mfMh6LuNZP3srIbxpuoxGRvDywtK/DWf10WbqEntWcTtaHVV/M+C3v9N5e
	 tgizTAJ9yb3ZJ9igUE1nKvjudt7ds8RPU3W6hCRcMBVZxYO6dJDaUy5vC4ENlzXeXn
	 sYTau/NlF6eFD81NkZaqbala/er5EWiST3kn/vnTuU8GQ/2vfnn8mewxEsh27nNIZN
	 ++efXcoB3CO3ebMKwc7PdfPeaLFewAZDDWHJTt5sqqpEv7yDs+5HClbfCEPp9zGJnU
	 GBtW5L7DTrgCA==
Date: Tue, 01 Oct 2024 18:13:18 -0700
Subject: [PATCH 21/64] xfs: hoist new inode initialization functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102097.4036371.10921999929547033243.stgit@frogsfrogsfrogs>
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

Source kernel commit: e9d2b35bb9d3ff372fad27998fc3969ced3f563d

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h     |    6 +
 libxfs/inode.c          |  161 ------------------------------------
 libxfs/xfs_inode_util.c |  211 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |   12 +++
 libxfs/xfs_shared.h     |    8 --
 repair/phase6.c         |    3 -
 6 files changed, 231 insertions(+), 170 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 1f9b07a53..7ce6f0183 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -420,4 +420,10 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
 
+#define xfs_inherit_noatime		(false)
+#define xfs_inherit_nodump		(false)
+#define xfs_inherit_sync		(false)
+#define xfs_inherit_nosymlinks		(false)
+#define xfs_inherit_nodefrag		(false)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index eb71f90bc..61068078a 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -29,50 +29,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 
-/* Propagate di_flags from a parent inode to a child inode. */
-static void
-xfs_inode_inherit_flags(
-	struct xfs_inode	*ip,
-	const struct xfs_inode	*pip)
-{
-	unsigned int		di_flags = 0;
-	umode_t			mode = VFS_I(ip)->i_mode;
-
-	if ((mode & S_IFMT) == S_IFDIR) {
-		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-			ip->i_extsize = pip->i_extsize;
-		}
-	} else {
-		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    xfs_has_realtime(ip->i_mount))
-			di_flags |= XFS_DIFLAG_REALTIME;
-		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSIZE;
-			ip->i_extsize = pip->i_extsize;
-		}
-	}
-	if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
-		di_flags |= XFS_DIFLAG_PROJINHERIT;
-	ip->i_diflags |= di_flags;
-}
-
-/* Propagate di_flags2 from a parent inode to a child inode. */
-static void
-xfs_inode_inherit_flags2(
-	struct xfs_inode	*ip,
-	const struct xfs_inode	*pip)
-{
-	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
-		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
-		ip->i_cowextsize = pip->i_cowextsize;
-	}
-	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
-		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
-}
-
 /*
  * Increment the link count on an inode & log the change.
  */
@@ -91,123 +47,6 @@ libxfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
-/* Initialise an inode's attributes. */
-static void
-xfs_inode_init(
-	struct xfs_trans	*tp,
-	const struct xfs_icreate_args *args,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*pip = args->pip;
-	struct inode		*dir = pip ? VFS_I(pip) : NULL;
-	struct inode		*inode = VFS_I(ip);
-	unsigned int		flags;
-	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
-					XFS_ICHGTIME_ACCESS;
-
-	if (args->flags & XFS_ICREATE_TMPFILE)
-		set_nlink(inode, 0);
-	else if (S_ISDIR(args->mode))
-		set_nlink(inode, 2);
-	else
-		set_nlink(inode, 1);
-	inode->i_rdev = args->rdev;
-
-	if (!args->idmap || pip == NULL) {
-		/* creating a tree root, sb rooted, or detached file */
-		inode->i_uid = GLOBAL_ROOT_UID;
-		inode->i_gid = GLOBAL_ROOT_GID;
-		ip->i_projid = 0;
-		inode->i_mode = args->mode;
-	} else {
-		/* creating a child in the directory tree */
-		if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
-			inode_fsuid_set(inode, args->idmap);
-			inode->i_gid = dir->i_gid;
-			inode->i_mode = args->mode;
-		} else {
-			inode_init_owner(args->idmap, inode, dir, args->mode);
-		}
-
-		/*
-		 * If the group ID of the new file does not match the effective
-		 * group ID or one of the supplementary group IDs, the S_ISGID
-		 * bit is cleared (and only if the irix_sgid_inherit
-		 * compatibility variable is set).
-		 */
-		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
-			inode->i_mode &= ~S_ISGID;
-
-		ip->i_projid = pip ? xfs_get_initial_prid(pip) : 0;
-	}
-
-	ip->i_disk_size = 0;
-	ip->i_df.if_nextents = 0;
-	ASSERT(ip->i_nblocks == 0);
-
-	ip->i_extsize = 0;
-	ip->i_diflags = 0;
-
-	if (xfs_has_v3inodes(mp)) {
-		inode_set_iversion(inode, 1);
-		ip->i_cowextsize = 0;
-		times |= XFS_ICHGTIME_CREATE;
-	}
-
-	xfs_trans_ichgtime(tp, ip, times);
-
-	flags = XFS_ILOG_CORE;
-	switch (args->mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFSOCK:
-	case S_IFCHR:
-	case S_IFBLK:
-		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
-		flags |= XFS_ILOG_DEV;
-		break;
-	case S_IFREG:
-	case S_IFDIR:
-		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
-			xfs_inode_inherit_flags(ip, pip);
-		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
-			xfs_inode_inherit_flags2(ip, pip);
-		fallthrough;
-	case S_IFLNK:
-		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
-		ip->i_df.if_bytes = 0;
-		ip->i_df.if_data = NULL;
-		break;
-	default:
-		ASSERT(0);
-	}
-
-	/*
-	 * If we need to create attributes immediately after allocating the
-	 * inode, initialise an empty attribute fork right now. We use the
-	 * default fork offset for attributes here as we don't know exactly what
-	 * size or how many attributes we might be adding. We can do this
-	 * safely here because we know the data fork is completely empty and
-	 * this saves us from needing to run a separate transaction to set the
-	 * fork offset in the immediate future.
-	 */
-	if ((args->flags & XFS_ICREATE_INIT_XATTRS) &&
-	    (xfs_has_attr(tp->t_mountp) || xfs_has_attr2(tp->t_mountp))) {
-		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
-		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
-
-		if (!xfs_has_attr(mp)) {
-			spin_lock(&mp->m_sb_lock);
-			xfs_add_attr(mp);
-			spin_unlock(&mp->m_sb_lock);
-			xfs_log_sb(tp);
-		}
-	}
-
-	xfs_trans_log_inode(tp, ip, flags);
-}
-
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 0a9ea03e2..633c7616c 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -13,6 +13,10 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_inode_util.h"
+#include "xfs_trans.h"
+#include "xfs_ialloc.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -132,3 +136,210 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 	/* Assign to the root project by default. */
 	return 0;
 }
+
+/* Propagate di_flags from a parent inode to a child inode. */
+static inline void
+xfs_inode_inherit_flags(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	unsigned int		di_flags = 0;
+	xfs_failaddr_t		failaddr;
+	umode_t			mode = VFS_I(ip)->i_mode;
+
+	if (S_ISDIR(mode)) {
+		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_extsize = pip->i_extsize;
+		}
+		if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
+			di_flags |= XFS_DIFLAG_PROJINHERIT;
+	} else if (S_ISREG(mode)) {
+		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    xfs_has_realtime(ip->i_mount))
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_extsize = pip->i_extsize;
+		}
+	}
+	if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
+	    xfs_inherit_noatime)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
+	    xfs_inherit_nodump)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
+	    xfs_inherit_sync)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
+	    xfs_inherit_nosymlinks)
+		di_flags |= XFS_DIFLAG_NOSYMLINKS;
+	if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
+	    xfs_inherit_nodefrag)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+
+	ip->i_diflags |= di_flags;
+
+	/*
+	 * Inode verifiers on older kernels only check that the extent size
+	 * hint is an integer multiple of the rt extent size on realtime files.
+	 * They did not check the hint alignment on a directory with both
+	 * rtinherit and extszinherit flags set.  If the misaligned hint is
+	 * propagated from a directory into a new realtime file, new file
+	 * allocations will fail due to math errors in the rt allocator and/or
+	 * trip the verifiers.  Validate the hint settings in the new file so
+	 * that we don't let broken hints propagate.
+	 */
+	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
+			VFS_I(ip)->i_mode, ip->i_diflags);
+	if (failaddr) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+				   XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+	}
+}
+
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static inline void
+xfs_inode_inherit_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	xfs_failaddr_t		failaddr;
+
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = pip->i_cowextsize;
+	}
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+
+	/* Don't let invalid cowextsize hints propagate. */
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
+			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
+	if (failaddr) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+	}
+}
+
+/* Initialise an inode's attributes. */
+void
+xfs_inode_init(
+	struct xfs_trans	*tp,
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	*ip)
+{
+	struct xfs_inode	*pip = args->pip;
+	struct inode		*dir = pip ? VFS_I(pip) : NULL;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct inode		*inode = VFS_I(ip);
+	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
+
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
+	}
+
+	ip->i_disk_size = 0;
+	ip->i_df.if_nextents = 0;
+	ASSERT(ip->i_nblocks == 0);
+
+	ip->i_extsize = 0;
+	ip->i_diflags = 0;
+
+	if (xfs_has_v3inodes(mp)) {
+		inode_set_iversion(inode, 1);
+		ip->i_cowextsize = 0;
+		times |= XFS_ICHGTIME_CREATE;
+	}
+
+	xfs_trans_ichgtime(tp, ip, times);
+
+	flags = XFS_ILOG_CORE;
+	switch (args->mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
+		flags |= XFS_ILOG_DEV;
+		break;
+	case S_IFREG:
+	case S_IFDIR:
+		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
+			xfs_inode_inherit_flags(ip, pip);
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_inherit_flags2(ip, pip);
+		fallthrough;
+	case S_IFLNK:
+		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_df.if_bytes = 0;
+		ip->i_df.if_data = NULL;
+		break;
+	default:
+		ASSERT(0);
+	}
+
+	/*
+	 * If we need to create attributes immediately after allocating the
+	 * inode, initialise an empty attribute fork right now. We use the
+	 * default fork offset for attributes here as we don't know exactly what
+	 * size or how many attributes we might be adding. We can do this
+	 * safely here because we know the data fork is completely empty and
+	 * this saves us from needing to run a separate transaction to set the
+	 * fork offset in the immediate future.
+	 */
+	if (args->flags & XFS_ICREATE_INIT_XATTRS) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+
+		if (!xfs_has_attr(mp)) {
+			spin_lock(&mp->m_sb_lock);
+			xfs_add_attr(mp);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_log_sb(tp);
+		}
+	}
+
+	xfs_trans_log_inode(tp, ip, flags);
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 9226482fd..bf5393db4 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -35,4 +35,16 @@ struct xfs_icreate_args {
 	uint16_t		flags;
 };
 
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
+void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
+
+void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
+		struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 9a705381f..2f7413afb 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -177,14 +177,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_REFC_BTREE_REF	1
 #define	XFS_SSB_REF		0
 
-/*
- * Flags for xfs_trans_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
-
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
 	/* Maximum inode count in this filesystem. */
diff --git a/repair/phase6.c b/repair/phase6.c
index 7a5694284..52e42d4c0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -842,7 +842,8 @@ mk_root_dir(xfs_mount_t *mp)
 	}
 
 	/*
-	 * take care of the core -- initialization from xfs_ialloc()
+	 * take care of the core since we didn't call the libxfs ialloc function
+	 * (comment changed to avoid tangling xfs/437)
 	 */
 	reset_inode_fields(ip);
 

