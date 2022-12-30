Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBF3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiLaCEK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiLaCEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA28110B64
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5856A61C99
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CEFC433D2;
        Sat, 31 Dec 2022 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452246;
        bh=0Nz1lS+yQBsStEkRAOZWFj9+npWb2MA6CONBzSr0OgA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fxXYoaS1DBDcj2PeB5zlEg/mEyrGmIdVr3Z9hYmp1uaQ5feW5q5KwJs7M/+Ch6ian
         7w3A0sbpi9qcVHaSqPHeYNTe8JF7io5Wffo/6pvHtzkxFRNH4AHXh5mE4x36aqYt0h
         9kCgV3Nfln4lFuo1fUr0o6SSYO60qErLMVrAzau+njUvBOFjrXNl3wiXUWH6qmE2/x
         AllFlG6yjWBz8lxLw5WvpyrGhk5uFSSx0E2IwavebR/G+Iuos9ZSr5+pvQmw3z3nw8
         Yyg+ABHELguW7zBQuBZayk+WEMH1+xQvjJSoDsVEVaxNXUjjVw5iR42P1oVg+oAz6i
         5Q4F+KIBKro5w==
Subject: [PATCH 04/26] libxfs: put all the inode functions in a single file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875374.723621.1245982412844488917.stgit@magnolia>
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

Move all the inode functions into a single source code file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile |    1 
 libxfs/inode.c  |  340 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/rdwr.c   |   87 --------------
 libxfs/util.c   |  222 ------------------------------------
 4 files changed, 341 insertions(+), 309 deletions(-)
 create mode 100644 libxfs/inode.c


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0d9c4adf82b..f9bc82cc9e8 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -64,6 +64,7 @@ HFILES = \
 CFILES = cache.c \
 	defer_item.c \
 	init.c \
+	inode.c \
 	kmem.c \
 	logitem.c \
 	rdwr.c \
diff --git a/libxfs/inode.c b/libxfs/inode.c
new file mode 100644
index 00000000000..c7843aea753
--- /dev/null
+++ b/libxfs/inode.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs_io.h"
+#include "init.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_bit.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_priv.h"
+
+/* Propagate di_flags from a parent inode to a child inode. */
+static void
+xfs_inode_propagate_flags(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	unsigned int		di_flags = 0;
+	umode_t			mode = VFS_I(ip)->i_mode;
+
+	if ((mode & S_IFMT) == S_IFDIR) {
+		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_extsize = pip->i_extsize;
+		}
+	} else {
+		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    xfs_has_realtime(ip->i_mount))
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_extsize = pip->i_extsize;
+		}
+	}
+	if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		di_flags |= XFS_DIFLAG_PROJINHERIT;
+	ip->i_diflags |= di_flags;
+}
+
+/*
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
+ */
+static int
+libxfs_init_new_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	xfs_ino_t		ino,
+	umode_t			mode,
+	xfs_nlink_t		nlink,
+	dev_t			rdev,
+	struct cred		*cr,
+	struct fsxattr		*fsx,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	unsigned int		flags;
+	int			error;
+
+	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
+	if (error != 0)
+		return error;
+	ASSERT(ip != NULL);
+
+	VFS_I(ip)->i_mode = mode;
+	set_nlink(VFS_I(ip), nlink);
+	i_uid_write(VFS_I(ip), cr->cr_uid);
+	i_gid_write(VFS_I(ip), cr->cr_gid);
+	ip->i_projid = pip ? 0 : fsx->fsx_projid;
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
+
+	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
+		if (!(cr->cr_flags & CRED_FORCE_GID))
+			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
+		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
+			VFS_I(ip)->i_mode |= S_ISGID;
+	}
+
+	ip->i_disk_size = 0;
+	ip->i_df.if_nextents = 0;
+	ASSERT(ip->i_nblocks == 0);
+	ip->i_extsize = pip ? 0 : fsx->fsx_extsize;
+	ip->i_diflags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
+
+	if (xfs_has_v3inodes(ip->i_mount)) {
+		VFS_I(ip)->i_version = 1;
+		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+		if (!pip)
+			ip->i_diflags2 = xfs_flags2diflags2(ip,
+							fsx->fsx_xflags);
+		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
+		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
+	}
+
+	flags = XFS_ILOG_CORE;
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFSOCK:
+		/* doesn't make sense to set an rdev for these */
+		rdev = 0;
+		/* FALLTHROUGH */
+	case S_IFCHR:
+	case S_IFBLK:
+		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
+		flags |= XFS_ILOG_DEV;
+		VFS_I(ip)->i_rdev = rdev;
+		break;
+	case S_IFREG:
+	case S_IFDIR:
+		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
+			xfs_inode_propagate_flags(ip, pip);
+		/* FALLTHROUGH */
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
+	 * Log the new values stuffed into the inode.
+	 */
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_log_inode(tp, ip, flags);
+	*ipp = ip;
+	return 0;
+}
+
+/*
+ * Writes a modified inode's changes out to the inode's on disk home.
+ * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
+ */
+int
+libxfs_iflush_int(
+	struct xfs_inode		*ip,
+	struct xfs_buf			*bp)
+{
+	struct xfs_inode_log_item	*iip;
+	struct xfs_dinode		*dip;
+	struct xfs_mount		*mp;
+
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
+		ip->i_df.if_nextents > ip->i_df.if_ext_max);
+
+	iip = ip->i_itemp;
+	mp = ip->i_mount;
+
+	/* set *dip = inode's place in the buffer */
+	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
+
+	if (XFS_ISREG(ip)) {
+		ASSERT( (ip->i_df.if_format == XFS_DINODE_FMT_EXTENTS) ||
+			(ip->i_df.if_format == XFS_DINODE_FMT_BTREE) );
+	} else if (XFS_ISDIR(ip)) {
+		ASSERT( (ip->i_df.if_format == XFS_DINODE_FMT_EXTENTS) ||
+			(ip->i_df.if_format == XFS_DINODE_FMT_BTREE)   ||
+			(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) );
+	}
+	ASSERT(ip->i_df.if_nextents+ip.i_af->if_nextents <= ip->i_nblocks);
+	ASSERT(ip->i_forkoff <= mp->m_sb.sb_inodesize);
+
+	/* bump the change count on v3 inodes */
+	if (xfs_has_v3inodes(mp))
+		VFS_I(ip)->i_version++;
+
+	/*
+	 * If there are inline format data / attr forks attached to this inode,
+	 * make sure they are not corrupt.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_data(ip))
+		return -EFSCORRUPTED;
+	if (xfs_inode_has_attr_fork(ip) &&
+	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_attr(ip))
+		return -EFSCORRUPTED;
+
+	/*
+	 * Copy the dirty parts of the inode into the on-disk
+	 * inode.  We always copy out the core of the inode,
+	 * because if the inode is dirty at all the core must
+	 * be.
+	 */
+	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
+
+	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
+	if (xfs_inode_has_attr_fork(ip))
+		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
+
+	/* generate the checksum. */
+	xfs_dinode_calc_crc(mp, dip);
+
+	return 0;
+}
+
+/*
+ * Wrapper around call to libxfs_ialloc. Takes care of committing and
+ * allocating a new transaction as needed.
+ *
+ * Originally there were two copies of this code - one in mkfs, the
+ * other in repair - now there is just the one.
+ */
+int
+libxfs_dir_ialloc(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*dp,
+	mode_t			mode,
+	nlink_t			nlink,
+	xfs_dev_t		rdev,
+	struct cred		*cr,
+	struct fsxattr		*fsx,
+	struct xfs_inode	**ipp)
+{
+	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
+	xfs_ino_t		ino;
+	int			error;
+
+	/*
+	 * Call the space management code to pick the on-disk inode to be
+	 * allocated.
+	 */
+	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
+	if (error)
+		return error;
+
+	return libxfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, cr,
+				fsx, ipp);
+}
+
+/*
+ * Inode cache stubs.
+ */
+
+struct kmem_cache		*xfs_inode_cache;
+extern struct kmem_cache	*xfs_ili_cache;
+
+int
+libxfs_iget(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	uint			lock_flags,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	struct xfs_buf		*bp;
+	int			error = 0;
+
+	ip = kmem_cache_zalloc(xfs_inode_cache, 0);
+	if (!ip)
+		return -ENOMEM;
+
+	VFS_I(ip)->i_count = 1;
+	ip->i_ino = ino;
+	ip->i_mount = mp;
+	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
+	spin_lock_init(&VFS_I(ip)->i_lock);
+
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
+	if (error)
+		goto out_destroy;
+
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+	if (error)
+		goto out_destroy;
+
+	error = xfs_inode_from_disk(ip,
+			xfs_buf_offset(bp, ip->i_imap.im_boffset));
+	if (!error)
+		xfs_buf_set_ref(bp, XFS_INO_REF);
+	xfs_trans_brelse(tp, bp);
+
+	if (error)
+		goto out_destroy;
+
+	*ipp = ip;
+	return 0;
+
+out_destroy:
+	kmem_cache_free(xfs_inode_cache, ip);
+	*ipp = NULL;
+	return error;
+}
+
+static void
+libxfs_idestroy(
+	struct xfs_inode	*ip)
+{
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
+		case S_IFREG:
+		case S_IFDIR:
+		case S_IFLNK:
+			libxfs_idestroy_fork(&ip->i_df);
+			break;
+	}
+
+	libxfs_ifork_zap_attr(ip);
+
+	if (ip->i_cowfp) {
+		libxfs_idestroy_fork(ip->i_cowfp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
+	}
+}
+
+void
+libxfs_irele(
+	struct xfs_inode	*ip)
+{
+	VFS_I(ip)->i_count--;
+
+	if (VFS_I(ip)->i_count == 0) {
+		ASSERT(ip->i_itemp == NULL);
+		libxfs_idestroy(ip);
+		kmem_cache_free(xfs_inode_cache, ip);
+	}
+}
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c2dbc51f3f2..2c66b84ff83 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1121,93 +1121,6 @@ xfs_verify_magic16(
 	return dmagic == bp->b_ops->magic16[idx];
 }
 
-/*
- * Inode cache stubs.
- */
-
-struct kmem_cache		*xfs_inode_cache;
-extern struct kmem_cache	*xfs_ili_cache;
-
-int
-libxfs_iget(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	xfs_ino_t		ino,
-	uint			lock_flags,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_inode	*ip;
-	struct xfs_buf		*bp;
-	int			error = 0;
-
-	ip = kmem_cache_zalloc(xfs_inode_cache, 0);
-	if (!ip)
-		return -ENOMEM;
-
-	VFS_I(ip)->i_count = 1;
-	ip->i_ino = ino;
-	ip->i_mount = mp;
-	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
-	spin_lock_init(&VFS_I(ip)->i_lock);
-
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
-	if (error)
-		goto out_destroy;
-
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
-	if (error)
-		goto out_destroy;
-
-	error = xfs_inode_from_disk(ip,
-			xfs_buf_offset(bp, ip->i_imap.im_boffset));
-	if (!error)
-		xfs_buf_set_ref(bp, XFS_INO_REF);
-	xfs_trans_brelse(tp, bp);
-
-	if (error)
-		goto out_destroy;
-
-	*ipp = ip;
-	return 0;
-
-out_destroy:
-	kmem_cache_free(xfs_inode_cache, ip);
-	*ipp = NULL;
-	return error;
-}
-
-static void
-libxfs_idestroy(xfs_inode_t *ip)
-{
-	switch (VFS_I(ip)->i_mode & S_IFMT) {
-		case S_IFREG:
-		case S_IFDIR:
-		case S_IFLNK:
-			libxfs_idestroy_fork(&ip->i_df);
-			break;
-	}
-
-	libxfs_ifork_zap_attr(ip);
-
-	if (ip->i_cowfp) {
-		libxfs_idestroy_fork(ip->i_cowfp);
-		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
-	}
-}
-
-void
-libxfs_irele(
-	struct xfs_inode	*ip)
-{
-	VFS_I(ip)->i_count--;
-
-	if (VFS_I(ip)->i_count == 0) {
-		ASSERT(ip->i_itemp == NULL);
-		libxfs_idestroy(ip);
-		kmem_cache_free(xfs_inode_cache, ip);
-	}
-}
-
 /*
  * Flush everything dirty in the kernel and disk write caches to stable media.
  * Returns 0 for success or a negative error code.
diff --git a/libxfs/util.c b/libxfs/util.c
index 6b888e9f996..51a0f513e7a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -150,194 +150,6 @@ current_time(struct inode *inode)
 	return tv;
 }
 
-/* Propagate di_flags from a parent inode to a child inode. */
-static void
-xfs_inode_propagate_flags(
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
-/*
- * Initialise a newly allocated inode and return the in-core inode to the
- * caller locked exclusively.
- */
-static int
-libxfs_init_new_inode(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*pip,
-	xfs_ino_t		ino,
-	umode_t			mode,
-	xfs_nlink_t		nlink,
-	dev_t			rdev,
-	struct cred		*cr,
-	struct fsxattr		*fsx,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_inode	*ip;
-	unsigned int		flags;
-	int			error;
-
-	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
-	if (error != 0)
-		return error;
-	ASSERT(ip != NULL);
-
-	VFS_I(ip)->i_mode = mode;
-	set_nlink(VFS_I(ip), nlink);
-	i_uid_write(VFS_I(ip), cr->cr_uid);
-	i_gid_write(VFS_I(ip), cr->cr_gid);
-	ip->i_projid = pip ? 0 : fsx->fsx_projid;
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
-
-	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		if (!(cr->cr_flags & CRED_FORCE_GID))
-			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
-			VFS_I(ip)->i_mode |= S_ISGID;
-	}
-
-	ip->i_disk_size = 0;
-	ip->i_df.if_nextents = 0;
-	ASSERT(ip->i_nblocks == 0);
-	ip->i_extsize = pip ? 0 : fsx->fsx_extsize;
-	ip->i_diflags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
-
-	if (xfs_has_v3inodes(ip->i_mount)) {
-		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		if (!pip)
-			ip->i_diflags2 = xfs_flags2diflags2(ip,
-							fsx->fsx_xflags);
-		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
-		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
-	}
-
-	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFSOCK:
-		/* doesn't make sense to set an rdev for these */
-		rdev = 0;
-		/* FALLTHROUGH */
-	case S_IFCHR:
-	case S_IFBLK:
-		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
-		flags |= XFS_ILOG_DEV;
-		VFS_I(ip)->i_rdev = rdev;
-		break;
-	case S_IFREG:
-	case S_IFDIR:
-		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
-			xfs_inode_propagate_flags(ip, pip);
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
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_trans_log_inode(tp, ip, flags);
-	*ipp = ip;
-	return 0;
-}
-
-/*
- * Writes a modified inode's changes out to the inode's on disk home.
- * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
- */
-int
-libxfs_iflush_int(
-	xfs_inode_t			*ip,
-	struct xfs_buf			*bp)
-{
-	struct xfs_inode_log_item	*iip;
-	struct xfs_dinode		*dip;
-	xfs_mount_t			*mp;
-
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
-		ip->i_df.if_nextents > ip->i_df.if_ext_max);
-
-	iip = ip->i_itemp;
-	mp = ip->i_mount;
-
-	/* set *dip = inode's place in the buffer */
-	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
-
-	if (XFS_ISREG(ip)) {
-		ASSERT( (ip->i_df.if_format == XFS_DINODE_FMT_EXTENTS) ||
-			(ip->i_df.if_format == XFS_DINODE_FMT_BTREE) );
-	} else if (XFS_ISDIR(ip)) {
-		ASSERT( (ip->i_df.if_format == XFS_DINODE_FMT_EXTENTS) ||
-			(ip->i_df.if_format == XFS_DINODE_FMT_BTREE)   ||
-			(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) );
-	}
-	ASSERT(ip->i_df.if_nextents+ip.i_af->if_nextents <= ip->i_nblocks);
-	ASSERT(ip->i_forkoff <= mp->m_sb.sb_inodesize);
-
-	/* bump the change count on v3 inodes */
-	if (xfs_has_v3inodes(mp))
-		VFS_I(ip)->i_version++;
-
-	/*
-	 * If there are inline format data / attr forks attached to this inode,
-	 * make sure they are not corrupt.
-	 */
-	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
-	    xfs_ifork_verify_local_data(ip))
-		return -EFSCORRUPTED;
-	if (xfs_inode_has_attr_fork(ip) &&
-	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
-	    xfs_ifork_verify_local_attr(ip))
-		return -EFSCORRUPTED;
-
-	/*
-	 * Copy the dirty parts of the inode into the on-disk
-	 * inode.  We always copy out the core of the inode,
-	 * because if the inode is dirty at all the core must
-	 * be.
-	 */
-	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
-
-	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
-	if (xfs_inode_has_attr_fork(ip))
-		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
-
-	/* generate the checksum. */
-	xfs_dinode_calc_crc(mp, dip);
-
-	return 0;
-}
-
 int
 libxfs_mod_incore_sb(
 	struct xfs_mount *mp,
@@ -442,40 +254,6 @@ libxfs_alloc_file_space(
 	return error;
 }
 
-/*
- * Wrapper around call to libxfs_ialloc. Takes care of committing and
- * allocating a new transaction as needed.
- *
- * Originally there were two copies of this code - one in mkfs, the
- * other in repair - now there is just the one.
- */
-int
-libxfs_dir_ialloc(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp,
-	mode_t			mode,
-	nlink_t			nlink,
-	xfs_dev_t		rdev,
-	struct cred		*cr,
-	struct fsxattr		*fsx,
-	struct xfs_inode	**ipp)
-{
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
-	xfs_ino_t		ino;
-	int			error;
-
-	/*
-	 * Call the space management code to pick the on-disk inode to be
-	 * allocated.
-	 */
-	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
-	if (error)
-		return error;
-
-	return libxfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, cr,
-				fsx, ipp);
-}
-
 void
 cmn_err(int level, char *fmt, ...)
 {

