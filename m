Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00470BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5nf1oh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F7BC433C7;
	Sun, 31 Dec 2023 21:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056586;
	bh=8bsk+KSQ5fdwkpzv0o/cqFNEsocbqdzLeQlfKbQu+Uc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B5nf1oh4FXallPCQTb9r1KDUBRKcXA3bUtJFcts+5notG0v8NLJizUbP5Ze6K6t27
	 Nu9KQiPDQ+2mLmj54wo47ttuNBspy1l2Ig978pWcRCrcaD/gO76ZIt4SEKM4gsQAQM
	 vLFJtREKgodN0lhTToNdLmQR5UR7FPF26D+uDu8bx0VlQ4SyI/m+gXNHlaQe7lbUGN
	 B/nwVjSBosPE0v6OWddGAQnm8H+m0Pwj9+nsA8RJwnaMhu0zpilLkjisi1i48PkGjp
	 +OVe6Ui9N4HNoAwI94OkiYHcrQu5m3IKdWh1VvnrR3aAXt+QpaZ31s2qPivbFY6tBe
	 jrtVlLqHmkQ5g==
Date: Sun, 31 Dec 2023 13:03:06 -0800
Subject: [PATCH 09/21] xfs: hoist new inode initialization functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844197.1759932.2304120103069080763.stgit@frogsfrogsfrogs>
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

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |  202 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   12 ++
 fs/xfs/libxfs/xfs_shared.h     |    8 --
 fs/xfs/xfs_inode.c             |  198 ---------------------------------------
 fs/xfs/xfs_trans.h             |    1 
 5 files changed, 215 insertions(+), 206 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 2624d18922c02..5ddcdd9087fed 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#include <linux/iversion.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -13,6 +14,10 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_inode_util.h"
+#include "xfs_trans.h"
+#include "xfs_ialloc.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -133,3 +138,200 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 
 	return XFS_PROJID_DEFAULT;
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
+	set_nlink(inode, args->nlink);
+	inode->i_rdev = args->rdev;
+	ip->i_projid = args->prid;
+
+	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
+		inode_fsuid_set(inode, args->idmap);
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = args->mode;
+	} else {
+		inode_init_owner(args->idmap, inode, dir, args->mode);
+	}
+
+	/*
+	 * If the group ID of the new file does not match the effective group
+	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
+	 * (and only if the irix_sgid_inherit compatibility variable is set).
+	 */
+	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
+	    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
+		inode->i_mode &= ~S_ISGID;
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
+		ip->i_df.if_u1.if_root = NULL;
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
+	if ((args->flags & XFS_ICREATE_ARGS_INIT_XATTRS) &&
+	    xfs_has_attr(mp)) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+	}
+
+	xfs_trans_log_inode(tp, ip, flags);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index a494f7c4a3fe0..54d96e1aa9e5b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -45,4 +45,16 @@ struct xfs_icreate_args {
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
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 1d327685f6ee3..2cecebe018814 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -130,14 +130,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4e027d26ebc9..a6ab37ba4f729 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,6 +42,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_parent.h"
 #include "xfs_xattr.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -585,203 +586,6 @@ xfs_lookup(
 	return error;
 }
 
-/* Propagate di_flags from a parent inode to a child inode. */
-static void
-xfs_inode_inherit_flags(
-	struct xfs_inode	*ip,
-	const struct xfs_inode	*pip)
-{
-	unsigned int		di_flags = 0;
-	xfs_failaddr_t		failaddr;
-	umode_t			mode = VFS_I(ip)->i_mode;
-
-	if (S_ISDIR(mode)) {
-		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-			ip->i_extsize = pip->i_extsize;
-		}
-		if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
-			di_flags |= XFS_DIFLAG_PROJINHERIT;
-	} else if (S_ISREG(mode)) {
-		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    xfs_has_realtime(ip->i_mount))
-			di_flags |= XFS_DIFLAG_REALTIME;
-		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSIZE;
-			ip->i_extsize = pip->i_extsize;
-		}
-	}
-	if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
-	    xfs_inherit_noatime)
-		di_flags |= XFS_DIFLAG_NOATIME;
-	if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
-	    xfs_inherit_nodump)
-		di_flags |= XFS_DIFLAG_NODUMP;
-	if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
-	    xfs_inherit_sync)
-		di_flags |= XFS_DIFLAG_SYNC;
-	if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
-	    xfs_inherit_nosymlinks)
-		di_flags |= XFS_DIFLAG_NOSYMLINKS;
-	if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
-	    xfs_inherit_nodefrag)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
-
-	ip->i_diflags |= di_flags;
-
-	/*
-	 * Inode verifiers on older kernels only check that the extent size
-	 * hint is an integer multiple of the rt extent size on realtime files.
-	 * They did not check the hint alignment on a directory with both
-	 * rtinherit and extszinherit flags set.  If the misaligned hint is
-	 * propagated from a directory into a new realtime file, new file
-	 * allocations will fail due to math errors in the rt allocator and/or
-	 * trip the verifiers.  Validate the hint settings in the new file so
-	 * that we don't let broken hints propagate.
-	 */
-	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
-			VFS_I(ip)->i_mode, ip->i_diflags);
-	if (failaddr) {
-		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
-				   XFS_DIFLAG_EXTSZINHERIT);
-		ip->i_extsize = 0;
-	}
-}
-
-/* Propagate di_flags2 from a parent inode to a child inode. */
-static void
-xfs_inode_inherit_flags2(
-	struct xfs_inode	*ip,
-	const struct xfs_inode	*pip)
-{
-	xfs_failaddr_t		failaddr;
-
-	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
-		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
-		ip->i_cowextsize = pip->i_cowextsize;
-	}
-	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
-		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
-
-	/* Don't let invalid cowextsize hints propagate. */
-	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
-			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
-	if (failaddr) {
-		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
-		ip->i_cowextsize = 0;
-	}
-}
-
-/* Initialise an inode's attributes. */
-static void
-xfs_inode_init(
-	struct xfs_trans	*tp,
-	const struct xfs_icreate_args *args,
-	struct xfs_inode	*ip)
-{
-	struct xfs_inode	*pip = args->pip;
-	struct inode		*dir = pip ? VFS_I(pip) : NULL;
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct inode		*inode = VFS_I(ip);
-	unsigned int		flags;
-	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
-					XFS_ICHGTIME_ACCESS;
-
-	set_nlink(inode, args->nlink);
-	inode->i_rdev = args->rdev;
-	ip->i_projid = args->prid;
-
-	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
-		inode_fsuid_set(inode, args->idmap);
-		inode->i_gid = dir->i_gid;
-		inode->i_mode = args->mode;
-	} else {
-		inode_init_owner(args->idmap, inode, dir, args->mode);
-	}
-
-	/*
-	 * If the group ID of the new file does not match the effective group
-	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
-	 * (and only if the irix_sgid_inherit compatibility variable is set).
-	 */
-	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-	    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
-		inode->i_mode &= ~S_ISGID;
-
-	/* struct copies */
-	if (args->flags & XFS_ICREATE_ARGS_FORCE_UID)
-		inode->i_uid = args->uid;
-	else
-		ASSERT(uid_eq(inode->i_uid, args->uid));
-	if (args->flags & XFS_ICREATE_ARGS_FORCE_GID)
-		inode->i_gid = args->gid;
-	else if (!pip || !XFS_INHERIT_GID(pip))
-		ASSERT(gid_eq(inode->i_gid, args->gid));
-	if (args->flags & XFS_ICREATE_ARGS_FORCE_MODE)
-		inode->i_mode = args->mode;
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
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
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
-		ip->i_df.if_u1.if_root = NULL;
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
-	if ((args->flags & XFS_ICREATE_ARGS_INIT_XATTRS) &&
-	    xfs_has_attr(mp)) {
-		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
-		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
-	}
-
-	xfs_trans_log_inode(tp, ip, flags);
-}
-
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3f7e3a09a49ff..3cffc3cb41814 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -224,7 +224,6 @@ void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
-void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
 				  uint);

