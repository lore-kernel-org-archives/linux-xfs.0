Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BA763CB
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831381; cv=none; b=jBH69wH6zjbQRHTNgATSCIns3IjDl0s8II3AT1PEK0AQxMuGgWIVHZnT9s2jZeUxQ231p10JT5GKktOSABDD8ftitgrjaPjlh6Mx0VVAVx7FPp8560AVafZCN1DChR1EVTBGTukzRAj/I6WrUOtj8Kmy6XGaWPi3yxXU8LyLGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831381; c=relaxed/simple;
	bh=fgGvigtZYCGQrRyPDgm17FirI39K5vqxcUfOUbtoH5c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cfb0RpSiF4I4kRajEhquUMqjGRX0bZoaJf0K++QzRUcLd/6zw43yDGjcFpqyAcS+I9TI4s3Rhtzdcr6u+ADqNQaNQzoi5CXdqKNCLJrW4xcAA8otIMpwstiKuD+LniFYhppDM76R58LhcI2yAks9nZEWcasotWDeSdFoghRPCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6mwPazS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6mwPazS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923FFC4CEC6;
	Wed,  2 Oct 2024 01:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831380;
	bh=fgGvigtZYCGQrRyPDgm17FirI39K5vqxcUfOUbtoH5c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s6mwPazSHikPnqs6JB5u5DA6QwQNQFoZfBrAuqeV/BR8OqU5KOPIz0//jWpS5qiOp
	 w2IJk3vtCZ4MQLc8UtEGn4D9Ete5D1rE5lN4ddAHUqFLqx/lTpZPQK4w4iBDEGnNJQ
	 2zPw18EGsooIzUvSiCMHbDPx78fRllCsmrRmx67wVqJJ1kYt/0bDNASeG3g2IKsHP5
	 KIdvqOA7UUotKDmYa8L50e7wU8QVSs690i63XwAKBlsMhV7n0gvWjCB3goWW6GscBF
	 kR5VxEgeUuBfywUXvCHbFFkHEst4yykW4zKi874TGwnQEpQgI++O4wEStn97Fqme8N
	 nZPovHYjgk5LQ==
Date: Tue, 01 Oct 2024 18:09:40 -0700
Subject: [PATCH 07/64] libxfs: put all the inode functions in a single file
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101887.4036371.1929357799728465686.stgit@frogsfrogsfrogs>
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

Move all the inode functions into a single source code file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile |    1 
 libxfs/inode.c  |  383 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/rdwr.c   |   95 --------------
 libxfs/util.c   |  257 -------------------------------------
 4 files changed, 384 insertions(+), 352 deletions(-)
 create mode 100644 libxfs/inode.c


diff --git a/libxfs/Makefile b/libxfs/Makefile
index cc3312b57..8c93d7b53 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -70,6 +70,7 @@ CFILES = buf_mem.c \
 	cache.c \
 	defer_item.c \
 	init.c \
+	inode.c \
 	kmem.c \
 	listxattr.c \
 	logitem.c \
diff --git a/libxfs/inode.c b/libxfs/inode.c
new file mode 100644
index 000000000..fffca7761
--- /dev/null
+++ b/libxfs/inode.c
@@ -0,0 +1,383 @@
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
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	unsigned int		flags;
+	int			error;
+
+	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
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
+		ip->i_crtime = inode_get_mtime(VFS_I(ip)); /* struct copy */
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
+		ip->i_df.if_data = NULL;
+		break;
+	default:
+		ASSERT(0);
+	}
+
+	/*
+	 * If we're going to set a parent pointer on this file, we need to
+	 * create an attr fork to receive that parent pointer.
+	 */
+	if (pip && xfs_has_parent(mp)) {
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
index e430416f6..7d4d93e4f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1079,101 +1079,6 @@ xfs_verify_magic16(
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
index 4e96ba5ce..7aa92c0e4 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -150,229 +150,6 @@ current_time(struct inode *inode)
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
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*ip;
-	unsigned int		flags;
-	int			error;
-
-	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
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
-		ip->i_crtime = inode_get_mtime(VFS_I(ip)); /* struct copy */
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
-		ip->i_df.if_data = NULL;
-		break;
-	default:
-		ASSERT(0);
-	}
-
-	/*
-	 * If we're going to set a parent pointer on this file, we need to
-	 * create an attr fork to receive that parent pointer.
-	 */
-	if (pip && xfs_has_parent(mp)) {
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
@@ -477,40 +254,6 @@ libxfs_alloc_file_space(
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

