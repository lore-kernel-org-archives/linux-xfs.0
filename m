Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D568DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiLaBHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiLaBHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:07:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5B2186E8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9EC61D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988ABC433D2;
        Sat, 31 Dec 2022 01:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448848;
        bh=F5SU62ZhG7Ny3K8VBDdZOrPK3M/90vlDNDDAuslZbSQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qWQlYZq9fA4ZlGQUysGRHpkTbiUm+vIE+UgRQ1B5I++rGffUCZTsPkQ0UM6MztU1i
         R8Wkrh9O76fhHMIU0sKp5Q5w1E64EN0AmjBptiGkQt49X/kmLAiaFn2XwI3/ayMxA0
         r+hzAcnsntyTltj4o6U4XK/L5jo7sx8Qkca2LG+Jl1xpnp8tBK17e8nF2fjDTJInlS
         sS18SPdav3+5Rrv5LjCEzt9yLTfMxt8ajADBrRaL103UcYUxPQsM+JWb7LVtRPXber
         8wXE5ddwuTlVNeQ2SkyjIiw9nzrTkqE8IFZO7H3vqDOUJ+kZFp6w5qlKd2J/dAovhV
         1T8Zf+seUhskw==
Subject: [PATCH 09/20] xfs: hoist new inode initialization functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863959.707335.16099575596205543812.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |  201 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   21 ++++
 fs/xfs/libxfs/xfs_shared.h     |    8 --
 fs/xfs/xfs_inode.c             |  198 +--------------------------------------
 fs/xfs/xfs_inode.h             |    1 
 fs/xfs/xfs_trans.h             |    1 
 6 files changed, 228 insertions(+), 202 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 2624d18922c0..5c9954dd20b3 100644
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
@@ -133,3 +138,199 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 
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
+		inode_fsuid_set(inode, args->mnt_userns);
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = args->mode;
+	} else {
+		inode_init_owner(args->mnt_userns, inode, dir, args->mode);
+	}
+	xfs_inode_sgid_inherit(args, ip);
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
+	/*
+	 * Log the new values stuffed into the inode.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, flags);
+
+	/* now that we have an i_mode we can setup the inode structure */
+	xfs_setup_inode(ip);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 466f0767ab5d..a73ccaea5582 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -44,4 +44,25 @@ struct xfs_icreate_args {
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
+/* The libxfs client must provide this group of helper functions. */
+
+/* Handle legacy Irix sgid inheritance quirks. */
+void xfs_inode_sgid_inherit(const struct xfs_icreate_args *args,
+		struct xfs_inode *ip);
+
+/* Initialize the incore inode. */
+void xfs_setup_inode(struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index acf527eb0e1c..46754fe57361 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -131,14 +131,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_RCBAG_BTREE_REF	1
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
index 1352599fee4c..270e81e12015 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -39,6 +39,7 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_inode_util.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -583,123 +584,12 @@ xfs_lookup(
 	return error;
 }
 
-/* Propagate di_flags from a parent inode to a child inode. */
-static void
-xfs_inode_inherit_flags(
-	struct xfs_inode	*ip,
-	const struct xfs_inode	*pip)
+void
+xfs_inode_sgid_inherit(
+	const struct xfs_icreate_args	*args,
+	struct xfs_inode		*ip)
 {
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
-		inode_fsuid_set(inode, args->mnt_userns);
-		inode->i_gid = dir->i_gid;
-		inode->i_mode = args->mode;
-	} else {
-		inode_init_owner(args->mnt_userns, inode, dir, args->mode);
-	}
+	struct inode			*inode = VFS_I(ip);
 
 	/*
 	 * If the group ID of the new file does not match the effective group
@@ -709,82 +599,6 @@ xfs_inode_init(
 	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
 	    !vfsgid_in_group_p(i_gid_into_vfsgid(args->mnt_userns, inode)))
 		inode->i_mode &= ~S_ISGID;
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
-	/*
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, flags);
-
-	/* now that we have an i_mode we can setup the inode structure */
-	xfs_setup_inode(ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cb627543e9fb..cb4e5114bac4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -542,7 +542,6 @@ int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
 /* from xfs_iops.c */
-extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a43d6465b9d4..0a9ec6929bbc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -228,7 +228,6 @@ void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
-void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
 				  uint);

