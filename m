Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26222C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXiBZlBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56B0C433C7;
	Sun, 31 Dec 2023 23:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065001;
	bh=T9tgthfhEjIHJ5EhycpTGtAGuJfF9MDtxKkoTAtwozM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YXiBZlBRzm9R7h6CuJbZyM73jOvD9y10ygl5gHw/IpEGOosanYgpyDb4R4ZN7CCrq
	 ugHbzZ5YgVXJmVCqcRgBgHRfAbj6R0xavzxCtZhkpguPwYbyXljbrK5tVEcNBpsnQb
	 dU8KHjuN/xbNG5Vceuf9l7wa3tqB8+P9c0hRiYL4/wcAnnJ1EgnDVEAHzaAMjrLIDo
	 vkf/Q/Fnjdo6Wv/buc38h9j/SQtc3x4S92JPib+vOQfGkB3JD+0lNa4vxrgwn84mB7
	 kmTsNDUH2sRaL9/XdJ0Nllh3ZMx6c5DAwHzElY5U0RmWaZl4xyqcWitiRJqOd8R9lJ
	 aVp3irAsORA1w==
Date: Sun, 31 Dec 2023 15:23:20 -0800
Subject: [PATCH 04/28] libxfs: put all the inode functions in a single file
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009231.1808635.2543248187020132417.stgit@frogsfrogsfrogs>
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

Move all the inode functions into a single source code file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile |    1 
 libxfs/inode.c  |  380 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/rdwr.c   |   95 --------------
 libxfs/util.c   |  254 -------------------------------------
 4 files changed, 381 insertions(+), 349 deletions(-)
 create mode 100644 libxfs/inode.c


diff --git a/libxfs/Makefile b/libxfs/Makefile
index bb6c2d5616c..6007353ade2 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -69,6 +69,7 @@ HFILES = \
 CFILES = cache.c \
 	defer_item.c \
 	init.c \
+	inode.c \
 	kmem.c \
 	logitem.c \
 	rdwr.c \
diff --git a/libxfs/inode.c b/libxfs/inode.c
new file mode 100644
index 00000000000..2bed1c2022e
--- /dev/null
+++ b/libxfs/inode.c
@@ -0,0 +1,380 @@
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
+ * Increment the link count on an inode & log the change.
+ */
+void
+libxfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
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
+	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
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
+		ip->i_crtime = VFS_I(ip)->__i_mtime; /* struct copy */
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
+	 * If we need to create attributes immediately after allocating the
+	 * inode, initialise an empty attribute fork right now. We use the
+	 * default fork offset for attributes here as we don't know exactly what
+	 * size or how many attributes we might be adding. We can do this
+	 * safely here because we know the data fork is completely empty and
+	 * this saves us from needing to run a separate transaction to set the
+	 * fork offset in the immediate future.
+	 */
+	if (xfs_has_parent(tp->t_mountp) && xfs_has_attr(tp->t_mountp)) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
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
+	struct xfs_perag	*pag;
+	int			error = 0;
+
+	/* reject inode numbers outside existing AGs */
+	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+		return -EINVAL;
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
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, 0);
+	xfs_perag_put(pag);
+
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
index f352225f23d..ecf10f7946b 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1117,101 +1117,6 @@ xfs_verify_magic16(
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
-	struct xfs_perag	*pag;
-	int			error = 0;
-
-	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
-		return -EINVAL;
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
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, 0);
-	xfs_perag_put(pag);
-
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
index dedf6c2a7b7..7aa92c0e4a6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -150,226 +150,6 @@ current_time(struct inode *inode)
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
- * Increment the link count on an inode & log the change.
- */
-void
-libxfs_bumplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		inc_nlink(inode);
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
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
-	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
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
-		ip->i_crtime = VFS_I(ip)->__i_mtime; /* struct copy */
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
-	 * If we need to create attributes immediately after allocating the
-	 * inode, initialise an empty attribute fork right now. We use the
-	 * default fork offset for attributes here as we don't know exactly what
-	 * size or how many attributes we might be adding. We can do this
-	 * safely here because we know the data fork is completely empty and
-	 * this saves us from needing to run a separate transaction to set the
-	 * fork offset in the immediate future.
-	 */
-	if (xfs_has_parent(tp->t_mountp) && xfs_has_attr(tp->t_mountp)) {
-		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
-		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
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
@@ -474,40 +254,6 @@ libxfs_alloc_file_space(
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

