Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386DBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiLaCGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:06:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE612AC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA75CB81DE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB5CC433D2;
        Sat, 31 Dec 2022 02:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452386;
        bh=4pM69lftUvBAQTv6GNVBzfXheV5ieRG3+QHtoFgDZAo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ACbkirLD33sGZNkJkgMuAkal6hZGWc3Vgwoof4Q99wwZe0aE8UOL0RaUNBVh7SMSd
         3NDeBOHja6Uzqm+PFrVzB4ABf2ndeu5GlQW8OQ6RGpQnKrTg6STq4GKtqMc+DifUfI
         0I/Rbpuy9B3rE9cggOKYrA+gh9Bl6N1vkNMMjGuhL6HFuU0Tp2TU3ncJVF4d/hopql
         OY3yLMGnCGr92hfCtbR+q3m4XF6AhFIGc9Kjiz+vzdDDUeux43PC8826zbou2biNOu
         YajZdsfoPq8RCCBsT+fY5Zhi/4g4N/KKNLkmIFej4q3MWsCCB0kfslasU6Mmhmh6Z7
         8C+3jipoxdhbg==
Subject: [PATCH 13/26] libxfs: backport inode init code from the kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875477.723621.59106054740264047.stgit@magnolia>
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

Reorganize the userspace inode initialization code to more closely resemble
its kernel counterpart.  This is preparation to hoist the initialization
routines to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |    2 +
 include/xfs_mount.h  |    1 +
 libxfs/inode.c       |   92 +++++++++++++++++++++++++++++++++++++++++---------
 libxfs/libxfs_priv.h |    6 +++
 4 files changed, 84 insertions(+), 17 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index bf8322ee2ec..4e8a3dc6fd8 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -295,4 +295,6 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+#define XFS_INHERIT_GID(pip)		(VFS_I(pip)->i_mode & S_ISGID)
+
 #endif /* __XFS_INODE_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index c67d0237686..1690660ed5b 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -218,6 +218,7 @@ __XFS_UNSUPP_FEAT(ikeep)
 __XFS_UNSUPP_FEAT(swalloc)
 __XFS_UNSUPP_FEAT(small_inums)
 __XFS_UNSUPP_FEAT(readonly)
+__XFS_UNSUPP_FEAT(grpid)
 
 /* Operational mount state flags */
 #define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 44d889f3f0f..d311abafd79 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -31,7 +31,7 @@
 
 /* Propagate di_flags from a parent inode to a child inode. */
 static void
-xfs_inode_propagate_flags(
+xfs_inode_inherit_flags(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
@@ -81,31 +81,47 @@ xfs_inode_init(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode	*pip = args->pip;
+	struct inode		*dir = pip ? VFS_I(pip) : NULL;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
 
-	VFS_I(ip)->i_mode = args->mode;
-	set_nlink(VFS_I(ip), args->nlink);
-	VFS_I(ip)->i_uid = args->uid;
+	set_nlink(inode, args->nlink);
+	inode->i_rdev = args->rdev;
 	ip->i_projid = args->prid;
 
-	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
-			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
-			VFS_I(ip)->i_mode |= S_ISGID;
-	} else
-		VFS_I(ip)->i_gid = args->gid;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    xfs_has_grpid(mp)) {
+		inode->i_uid = args->uid;
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = args->mode;
+	} else {
+		inode_init_owner(args->mnt_userns, inode, dir, args->mode);
+	}
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
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
+
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
+
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
 		ip->i_cowextsize = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
@@ -120,12 +136,11 @@ xfs_inode_init(
 	case S_IFBLK:
 		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
 		flags |= XFS_ILOG_DEV;
-		VFS_I(ip)->i_rdev = args->rdev;
 		break;
 	case S_IFREG:
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
-			xfs_inode_propagate_flags(ip, pip);
+			xfs_inode_inherit_flags(ip, pip);
 		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
 			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
@@ -138,6 +153,21 @@ xfs_inode_init(
 		ASSERT(0);
 	}
 
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
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
@@ -261,15 +291,15 @@ libxfs_dir_ialloc(
 		.nlink		= nlink,
 		.rdev		= rdev,
 		.mode		= mode,
+		.flags		= XFS_ICREATE_ARGS_FORCE_UID |
+				  XFS_ICREATE_ARGS_FORCE_GID |
+				  XFS_ICREATE_ARGS_FORCE_MODE,
 	};
 	struct xfs_inode	*ip;
 	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
-	if (cr->cr_flags & CRED_FORCE_GID)
-		args.flags |= XFS_ICREATE_ARGS_FORCE_GID;
-
 	/*
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
@@ -321,6 +351,7 @@ libxfs_iget(
 	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
@@ -399,3 +430,30 @@ libxfs_irele(
 		kmem_cache_free(xfs_inode_cache, ip);
 	}
 }
+
+static inline void inode_fsuid_set(struct inode *inode,
+				   struct user_namespace *mnt_userns)
+{
+	inode->i_uid = make_kuid(0);
+}
+
+static inline void inode_fsgid_set(struct inode *inode,
+				   struct user_namespace *mnt_userns)
+{
+	inode->i_gid = make_kgid(0);
+}
+
+void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
+		      const struct inode *dir, umode_t mode)
+{
+	inode_fsuid_set(inode, mnt_userns);
+	if (dir && dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+
+		/* Directories are special, and always inherit S_ISGID */
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode_fsgid_set(inode, mnt_userns);
+	inode->i_mode = mode;
+}
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 716e711cde4..acad5ccd228 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -219,6 +219,12 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
+struct inode;
+struct user_namespace;
+
+void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
+		      const struct inode *dir, umode_t mode);
+
 #define __must_check                    __attribute__((__warn_unused_result__))
 
 /*

