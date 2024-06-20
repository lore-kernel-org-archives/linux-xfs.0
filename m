Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5619E82D83
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924461; cv=none; b=ANNsPwMtA0D9hPdv/p5KP2WOgTiP8/WI/1FtibJ82izMudeQrlGcxtF7Tgz3+k8/E58UDQH5bv4iwcC/37wWSkfAspWR8oWi0t1Sl6loTB4v85wzY4KDKKMCY85aLnuQbM425k4jYUsTySVhMbwolgRm2SxqFMBCsSmT0l3AZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924461; c=relaxed/simple;
	bh=bCKpkRU6GnQqs2J0YR11jvZCTyWdYF5Jva4pp7/ztz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GR7WVSE4+a5Dqxi778nLwS86FTyZ3ou9w4KZAmJsuirnQ2o4o0gcdRzaKNoWbEO2iP9jMoKsjjTc2WwBpch2vITlcVspvxnoNIPNFaEalh4uILjChj123cCIIERJf0qn2dTZUDWd6ORKG5wVSMqtiNm9HME3Y/gPbPzuS+7ecxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhfIGoly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhfIGoly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22183C2BD10;
	Thu, 20 Jun 2024 23:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924461;
	bh=bCKpkRU6GnQqs2J0YR11jvZCTyWdYF5Jva4pp7/ztz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OhfIGolyvZ7SJ0vtP9Zi8qByhCNHgtiPLPLBu4Rfp6xrhd20bq5ElwXHhNoz/7WXG
	 R7ANw2ZYYonJVuKIdkSYxWJex3oVENFcPvtvbh5MV4sK7OFZbih2MNgRBTugOCxD9H
	 Vovr3OXFIRYmxncB/ox8tp/sJ7ww4AQi54JfzxLUKJT6g4bVv/f+6tgeVPE6ISeRPY
	 j5RJgt3dts3WQ9aHrW4j8eKNeYoc0DKPvMpmI+42rlsxPEIiwxThbHsFI+bpKP5SXB
	 XwjomXm3ylWr9yG/jzr2Iv7Hc+O9K8pf0akO4OQnnAVUlBHbiohhMeU7GNn+VBjLLK
	 Cd34t7SNuoVpw==
Date: Thu, 20 Jun 2024 16:01:00 -0700
Subject: [PATCH 10/24] xfs: hoist new inode initialization functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418067.3183075.14394287548193780451.stgit@frogsfrogsfrogs>
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

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |  212 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   12 ++
 fs/xfs/libxfs/xfs_shared.h     |    8 --
 fs/xfs/xfs_inode.c             |  209 ---------------------------------------
 fs/xfs/xfs_trans.h             |    1 
 5 files changed, 225 insertions(+), 217 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 3b5397a3f34f2..8654cb3d79efb 100644
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
@@ -132,3 +137,210 @@ xfs_get_initial_prid(struct xfs_inode *dp)
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
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 9226482fdee8c..bf5393db4fde6 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
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
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 9a705381f9e4a..2f7413afbf46c 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dfefc473b0607..e8d4ddbfbb925 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,7 +42,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_parent.h"
 #include "xfs_xattr.h"
-#include "xfs_sb.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -564,213 +564,6 @@ xfs_lookup(
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
-	if (args->flags & XFS_ICREATE_INIT_XATTRS) {
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
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1636663707dc0..f97e8c68641f0 100644
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

