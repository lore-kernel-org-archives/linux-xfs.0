Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14803C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiLaCHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaCHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:07:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1FB13F97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E863CE1926
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41D2C433D2;
        Sat, 31 Dec 2022 02:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452417;
        bh=rnXY4clo3E8DXP8DqT5Jyho3hnDJrM75c8/vuYS6LHQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Di2E66foJQFe6CMmo7YFWOGdP1OsJ1E0KT/RE6vSc9EcrtpY7FM8hpCF2g1GVi8hQ
         I63fu51SHXyHxaXGQQo9QjPtEA4RBQ7FWIM9gbni7zaCdyjCkkA+Tkq+FOPbb5yOme
         I8Hx2n6+bnWjxwG8P1CTL7Wi39K36Sd+3R16VmHgH2zrQraYf4sXR/WD9Fr0F7OcQb
         DLMXsrDXXGGfyx+njdQ6gFZjmtNEPhHEHhKRwNNg5N9I6Xg4kzGWDvlDFtpMFUdqPj
         G/WNpUbBsCVIjr1pFnFBXX7FTBWQJqDG8dNMLVPiqKO/VaA/CZZOs6vOvfwq2pr09n
         RLazz/YzeF7aQ==
Subject: [PATCH 15/26] xfs: hoist new inode initialization functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875500.723621.16586773809404642237.stgit@magnolia>
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

Move all the code that initializes a new inode's attributes from the
icreate_args structure and the parent directory into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |   20 +++++
 libxfs/inode.c          |  153 ++----------------------------------
 libxfs/xfs_inode_util.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |   21 +++++
 libxfs/xfs_shared.h     |    8 --
 repair/phase6.c         |    3 -
 6 files changed, 251 insertions(+), 154 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 03add740fa7..5c806b3a58c 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -94,6 +94,20 @@ static inline void ihold(struct inode *inode)
 	inode->i_count++;
 }
 
+static inline void
+inode_fsuid_set(
+	struct inode		*inode,
+	struct user_namespace	*mnt_userns)
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
@@ -290,4 +304,10 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
 
+#define xfs_inherit_noatime	(false)
+#define xfs_inherit_nodump	(false)
+#define xfs_inherit_sync	(false)
+#define xfs_inherit_nosymlinks	(false)
+#define xfs_inherit_nodefrag	(false)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index c1fb622f306..8ef2b654769 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -29,150 +29,11 @@
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
-/* Initialise an inode's attributes. */
-static void
-xfs_inode_init(
-	struct xfs_trans	*tp,
-	const struct xfs_icreate_args *args,
+void
+xfs_setup_inode(
 	struct xfs_inode	*ip)
 {
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
-		inode_init_owner(args->mnt_userns, inode, dir, args->mode);
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
-	/*
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_trans_log_inode(tp, ip, flags);
+	/* empty */
 }
 
 /*
@@ -386,10 +247,12 @@ libxfs_irele(
 	}
 }
 
-static inline void inode_fsuid_set(struct inode *inode,
-				   struct user_namespace *mnt_userns)
+void
+xfs_inode_sgid_inherit(
+	const struct xfs_icreate_args	*args,
+	struct xfs_inode		*ip)
 {
-	inode->i_uid = make_kuid(0);
+	/* empty */
 }
 
 static inline void inode_fsgid_set(struct inode *inode,
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 89fb58807a1..21196a899da 100644
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
@@ -133,3 +137,199 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 
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
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 466f0767ab5..a73ccaea558 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
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
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index acf527eb0e1..46754fe5736 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
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
diff --git a/repair/phase6.c b/repair/phase6.c
index e7e2bf3f475..0c24cfbf144 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -824,7 +824,8 @@ mk_root_dir(xfs_mount_t *mp)
 	}
 
 	/*
-	 * take care of the core -- initialization from xfs_ialloc()
+	 * take care of the core since we didn't call the libxfs ialloc function
+	 * (comment changed to avoid tangling xfs/437)
 	 */
 	reset_inode_fields(ip);
 

