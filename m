Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190B4C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIXxLQt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B1C433C8;
	Sun, 31 Dec 2023 23:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065188;
	bh=j4pmANq1gusxl246W2j0PUPULGvpF0OUhvuODFa9N44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JIXxLQt3qrJ1KpYtS63r3YixTo+oI7+oqLdUlthW4mKMcPjsiLGg7BqW8nq3Ry2j9
	 2zQXhGcf7zbx2qZ0Z1vUyjcBNXMBYaVDqx16AK8V1TtumIO154RavayQOEqKiCOOyV
	 iLNl36KjhadqXQ6nqpRhm1Vp11x5ZZCkcb913r9C2qbKjztPKMmhH1mLWLrw3LuRKT
	 dI7MYI9hG4Km4BMM+4smLbXLcLS5+rG4q9TJEfOlh3/B7fWlq2aoEgrlrmqWHg1jKN
	 dDwcCGZM7Y/MVFcLwkwnzlng1Qpcxg0Vx/4bLOE14emAqaHwVO4V2ti4FAS9vES/fE
	 ujMQYBHYv5W/g==
Date: Sun, 31 Dec 2023 15:26:28 -0800
Subject: [PATCH 16/28] xfs: hoist new inode initialization functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009390.1808635.17443594766145582260.stgit@frogsfrogsfrogs>
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

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |   20 +++++
 libxfs/inode.c          |  148 -----------------------------------
 libxfs/libxfs_priv.h    |    4 +
 libxfs/xfs_inode_util.c |  201 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |   12 +++
 libxfs/xfs_shared.h     |    8 --
 repair/phase6.c         |    3 -
 7 files changed, 239 insertions(+), 157 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index e0bf5dcc2c2..2af5f79e31e 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -187,6 +187,20 @@ static inline struct timespec64 inode_set_ctime_current(struct inode *inode)
 	return now;
 }
 
+static inline void
+inode_fsuid_set(
+	struct inode		*inode,
+	struct mnt_idmap	*idmap)
+{
+	inode->i_uid = make_kuid(0);
+}
+
+static inline void
+inode_set_iversion(struct inode *inode, uint64_t version)
+{
+	inode->i_version = version;
+}
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
@@ -394,4 +408,10 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
 
+#define xfs_inherit_noatime	(false)
+#define xfs_inherit_nodump	(false)
+#define xfs_inherit_sync	(false)
+#define xfs_inherit_nosymlinks	(false)
+#define xfs_inherit_nodefrag	(false)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 17bdc0bffb2..ec005bbbf5e 100644
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
@@ -91,104 +47,6 @@ libxfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
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
-	if (dir && !(dir->i_mode & S_ISGID) &&
-	    xfs_has_grpid(mp)) {
-		inode->i_uid = args->uid;
-		inode->i_gid = dir->i_gid;
-		inode->i_mode = args->mode;
-	} else {
-		inode_init_owner(args->idmap, inode, dir, args->mode);
-	}
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
-	if (xfs_has_v3inodes(ip->i_mount)) {
-		VFS_I(ip)->i_version = 1;
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
-		/* FALLTHROUGH */
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
@@ -416,12 +274,6 @@ libxfs_irele(
 	}
 }
 
-static inline void inode_fsuid_set(struct inode *inode,
-				   struct mnt_idmap *idmap)
-{
-	inode->i_uid = make_kuid(0);
-}
-
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct mnt_idmap *idmap)
 {
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e9c6bbf16ee..8faf63a8a67 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -612,4 +612,8 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 /* xfs_inode.h */
 #define xfs_iflags_set(ip, flags)	do { } while (0)
 
+/* xfs_linux.h */
+#define irix_sgid_inherit		(0)
+#define vfsgid_in_group_p(...)		(false)
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 89fb58807a1..184da10db71 100644
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
@@ -133,3 +137,200 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 
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
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index a494f7c4a3f..54d96e1aa9e 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
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
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 1d327685f6e..2cecebe0188 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
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
diff --git a/repair/phase6.c b/repair/phase6.c
index 51e1ea92dd6..13f2fb2290b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -841,7 +841,8 @@ mk_root_dir(xfs_mount_t *mp)
 	}
 
 	/*
-	 * take care of the core -- initialization from xfs_ialloc()
+	 * take care of the core since we didn't call the libxfs ialloc function
+	 * (comment changed to avoid tangling xfs/437)
 	 */
 	reset_inode_fields(ip);
 

