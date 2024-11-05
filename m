Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D911DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845139; cv=none; b=tEAW5O21+XvS71QsL8Gx66F64/lKs9FDE8USkmzhLjPD4T1tvDF0JirZRtYShnoPY5rmr7B28YZAn8p3eGvy2IPRsb1++p+lBzly2NbjllwsVvVyjuR4JPB7CzNegRxNhHweTnCrZVVhildgt8e5Y3gkvgXpY/Z+tbUyUQOrlBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845139; c=relaxed/simple;
	bh=Db1uJM5g8DiEGAXgTQ00OyJZAR6MhZX7aFc+XNeFd9A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G9I8VukY1DYV/qGUhprtSb6gXH3kGQHGIzLU67v8f9q1Z9Ypgm30M+SrRxeIppUAd0obI0658zHk490hTuxpV7O9KfKE9XS86LnycbFe57uTF87Vqaew82HKPRTtXLTkTSe+qOb0UlL2lxeOt5168FoacvzhFuzNEq7VAN61KV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvg0yOKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvg0yOKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D417C4CECF;
	Tue,  5 Nov 2024 22:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845139;
	bh=Db1uJM5g8DiEGAXgTQ00OyJZAR6MhZX7aFc+XNeFd9A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kvg0yOKyjQL+Tg95EDj31T7npfvUd36aw47O1mtPLzI5CZWM5lMbcp8+bQh8lHXi+
	 /XiT+4xhfyZl9rMoJOWrVRg0B595hcasGVPiDZmCou4+sUwOBTCbfohMNI67XSK+it
	 7MmeI+s8MBjsNNYuVfTIcNGDAEz/92lyl7zmHq0wKEyGuks9A4fdlUyZltxsf0M6hK
	 /OINoOoqtUiyX/V5AVAi8Nu9lICADCUL3J9/0My7nOEBiXsbXNdOjScizpzTwheNtl
	 digfUQ/UHvFSX2k3tn2+ijqf9gcwNPekz/xUYy3zjGHVWqTvUHfvQygaItuGzd1UA7
	 uFTzwNn9Rn2nw==
Date: Tue, 05 Nov 2024 14:18:58 -0800
Subject: [PATCH 09/28] xfs: read and write metadata inode directory tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396175.1870066.5084498985477395223.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the bits we need to load metadata inodes from a named entry in
a metadir directory, create (or hardlink) inodes into a metadir
directory, create metadir directories, and flag inodes as being metadata
files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |    4 
 fs/xfs/libxfs/xfs_metadir.c  |  474 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metadir.h  |   47 ++++
 fs/xfs/libxfs/xfs_metafile.c |   52 +++++
 fs/xfs/libxfs/xfs_metafile.h |    4 
 fs/xfs/xfs_icache.c          |    2 
 fs/xfs/xfs_trace.c           |    2 
 fs/xfs/xfs_trace.h           |  102 +++++++++
 8 files changed, 685 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_metadir.c
 create mode 100644 fs/xfs/libxfs/xfs_metadir.h
 create mode 100644 fs/xfs/libxfs/xfs_metafile.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 94cb8ca9f9da77..ba418a40aeb528 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,6 +16,7 @@ xfs-y				+= xfs_trace.o
 xfs-y				+= $(addprefix libxfs/, \
 				   xfs_group.o \
 				   xfs_ag.o \
+				   xfs_ag_resv.o \
 				   xfs_alloc.o \
 				   xfs_alloc_btree.o \
 				   xfs_attr.o \
@@ -43,7 +44,8 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_inode_util.o \
 				   xfs_log_rlimit.o \
-				   xfs_ag_resv.o \
+				   xfs_metadir.o \
+				   xfs_metafile.o \
 				   xfs_parent.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
new file mode 100644
index 00000000000000..0a61316b4f520f
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_metafile.h"
+#include "xfs_metadir.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_parent.h"
+
+/*
+ * Metadata Directory Tree
+ * =======================
+ *
+ * These functions provide an abstraction layer for looking up, creating, and
+ * deleting metadata inodes that live within a special metadata directory tree.
+ *
+ * This code does not manage the five existing metadata inodes: real time
+ * bitmap & summary; and the user, group, and quotas.  All other metadata
+ * inodes must use only the xfs_meta{dir,file}_* functions.
+ *
+ * Callers wishing to create or hardlink a metadata inode must create an
+ * xfs_metadir_update structure, call the appropriate xfs_metadir* function,
+ * and then call xfs_metadir_commit or xfs_metadir_cancel to commit or cancel
+ * the update.  Files in the metadata directory tree currently cannot be
+ * unlinked.
+ *
+ * When the metadir feature is enabled, all metadata inodes must have the
+ * "metadata" inode flag set to prevent them from being exposed to the outside
+ * world.
+ *
+ * Callers must take the ILOCK of any inode in the metadata directory tree to
+ * synchronize access to that inode.  It is never necessary to take the IOLOCK
+ * or the MMAPLOCK since metadata inodes must not be exposed to user space.
+ */
+
+static inline void
+xfs_metadir_set_xname(
+	struct xfs_name		*xname,
+	const char		*path,
+	unsigned char		ftype)
+{
+	xname->name = (const unsigned char *)path;
+	xname->len = strlen(path);
+	xname->type = ftype;
+}
+
+/*
+ * Given a parent directory @dp and a metadata inode path component @xname,
+ * Look up the inode number in the directory, returning it in @ino.
+ * @xname.type must match the directory entry's ftype.
+ *
+ * Caller must hold ILOCK_EXCL.
+ */
+static inline int
+xfs_metadir_lookup(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_name		*xname,
+	xfs_ino_t		*ino)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_args	args = {
+		.trans		= tp,
+		.dp		= dp,
+		.geo		= mp->m_dir_geo,
+		.name		= xname->name,
+		.namelen	= xname->len,
+		.hashval	= xfs_dir2_hashname(mp, xname),
+		.whichfork	= XFS_DATA_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
+	};
+	int			error;
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode))
+		return -EFSCORRUPTED;
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	error = xfs_dir_lookup_args(&args);
+	if (error)
+		return error;
+
+	if (!xfs_verify_ino(mp, args.inumber))
+		return -EFSCORRUPTED;
+	if (xname->type != XFS_DIR3_FT_UNKNOWN && xname->type != args.filetype)
+		return -EFSCORRUPTED;
+
+	trace_xfs_metadir_lookup(dp, xname, args.inumber);
+	*ino = args.inumber;
+	return 0;
+}
+
+/*
+ * Look up and read a metadata inode from the metadata directory.  If the path
+ * component doesn't exist, return -ENOENT.
+ */
+int
+xfs_metadir_load(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	const char		*path,
+	enum xfs_metafile_type	metafile_type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_name		xname;
+	xfs_ino_t		ino;
+	int			error;
+
+	xfs_metadir_set_xname(&xname, path, XFS_DIR3_FT_UNKNOWN);
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
+	error = xfs_metadir_lookup(tp, dp, &xname, &ino);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+	return xfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
+}
+
+/*
+ * Unlock and release resources after committing (or cancelling) a metadata
+ * directory tree operation.  The caller retains its reference to @upd->ip
+ * and must release it explicitly.
+ */
+static inline void
+xfs_metadir_teardown(
+	struct xfs_metadir_update	*upd,
+	int				error)
+{
+	trace_xfs_metadir_teardown(upd, error);
+
+	if (upd->ppargs) {
+		xfs_parent_finish(upd->dp->i_mount, upd->ppargs);
+		upd->ppargs = NULL;
+	}
+
+	if (upd->ip) {
+		if (upd->ip_locked)
+			xfs_iunlock(upd->ip, XFS_ILOCK_EXCL);
+		upd->ip_locked = false;
+	}
+
+	if (upd->dp_locked)
+		xfs_iunlock(upd->dp, XFS_ILOCK_EXCL);
+	upd->dp_locked = false;
+}
+
+/*
+ * Begin the process of creating a metadata file by allocating transactions
+ * and taking whatever resources we're going to need.
+ */
+int
+xfs_metadir_start_create(
+	struct xfs_metadir_update	*upd)
+{
+	struct xfs_mount		*mp = upd->dp->i_mount;
+	int				error;
+
+	ASSERT(upd->dp != NULL);
+	ASSERT(upd->ip == NULL);
+	ASSERT(xfs_has_metadir(mp));
+	ASSERT(upd->metafile_type != XFS_METAFILE_UNKNOWN);
+
+	error = xfs_parent_start(mp, &upd->ppargs);
+	if (error)
+		return error;
+
+	/*
+	 * If we ever need the ability to create rt metadata files on a
+	 * pre-metadir filesystem, we'll need to dqattach the parent here.
+	 * Currently we assume that mkfs will create the files and quotacheck
+	 * will account for them.
+	 */
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+			xfs_create_space_res(mp, MAXNAMELEN), 0, 0, &upd->tp);
+	if (error)
+		goto out_teardown;
+
+	/*
+	 * Lock the parent directory if there is one.  We can't ijoin it to
+	 * the transaction until after the child file has been created.
+	 */
+	xfs_ilock(upd->dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	upd->dp_locked = true;
+
+	trace_xfs_metadir_start_create(upd);
+	return 0;
+out_teardown:
+	xfs_metadir_teardown(upd, error);
+	return error;
+}
+
+/*
+ * Create a metadata inode with the given @mode, and insert it into the
+ * metadata directory tree at the given @upd->path.  The path up to the final
+ * component must already exist.  The final path component must not exist.
+ *
+ * The new metadata inode will be attached to the update structure @upd->ip,
+ * with the ILOCK held until the caller releases it.
+ *
+ * NOTE: This function may return a new inode to the caller even if it returns
+ * a negative error code.  If an inode is passed back, the caller must finish
+ * setting up the inode before releasing it.
+ */
+int
+xfs_metadir_create(
+	struct xfs_metadir_update	*upd,
+	umode_t				mode)
+{
+	struct xfs_icreate_args		args = {
+		.pip			= upd->dp,
+		.mode			= mode,
+	};
+	struct xfs_name			xname;
+	struct xfs_dir_update		du = {
+		.dp			= upd->dp,
+		.name			= &xname,
+		.ppargs			= upd->ppargs,
+	};
+	struct xfs_mount		*mp = upd->dp->i_mount;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	xfs_assert_ilocked(upd->dp, XFS_ILOCK_EXCL);
+
+	/* Check that the name does not already exist in the directory. */
+	xfs_metadir_set_xname(&xname, upd->path, XFS_DIR3_FT_UNKNOWN);
+	error = xfs_metadir_lookup(upd->tp, upd->dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	/*
+	 * A newly created regular or special file just has one directory
+	 * entry pointing to them, but a directory also the "." entry
+	 * pointing to itself.
+	 */
+	error = xfs_dialloc(&upd->tp, &args, &ino);
+	if (error)
+		return error;
+	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
+	if (error)
+		return error;
+	du.ip = upd->ip;
+	xfs_metafile_set_iflag(upd->tp, upd->ip, upd->metafile_type);
+	upd->ip_locked = true;
+
+	/*
+	 * Join the directory inode to the transaction.  We do not do it
+	 * earlier because xfs_dialloc rolls the transaction.
+	 */
+	xfs_trans_ijoin(upd->tp, upd->dp, 0);
+
+	/* Create the entry. */
+	if (S_ISDIR(args.mode))
+		resblks = xfs_mkdir_space_res(mp, xname.len);
+	else
+		resblks = xfs_create_space_res(mp, xname.len);
+	xname.type = xfs_mode_to_ftype(args.mode);
+
+	trace_xfs_metadir_try_create(upd);
+
+	error = xfs_dir_create_child(upd->tp, resblks, &du);
+	if (error)
+		return error;
+
+	/* Metadir files are not accounted to quota. */
+
+	trace_xfs_metadir_create(upd);
+
+	return 0;
+}
+
+#ifndef __KERNEL__
+/*
+ * Begin the process of linking a metadata file by allocating transactions
+ * and locking whatever resources we're going to need.
+ */
+int
+xfs_metadir_start_link(
+	struct xfs_metadir_update	*upd)
+{
+	struct xfs_mount		*mp = upd->dp->i_mount;
+	unsigned int			resblks;
+	int				nospace_error = 0;
+	int				error;
+
+	ASSERT(upd->dp != NULL);
+	ASSERT(upd->ip != NULL);
+	ASSERT(xfs_has_metadir(mp));
+
+	error = xfs_parent_start(mp, &upd->ppargs);
+	if (error)
+		return error;
+
+	resblks = xfs_link_space_res(mp, MAXNAMELEN);
+	error = xfs_trans_alloc_dir(upd->dp, &M_RES(mp)->tr_link, upd->ip,
+			&resblks, &upd->tp, &nospace_error);
+	if (error)
+		goto out_teardown;
+	if (!resblks) {
+		/* We don't allow reservationless updates. */
+		xfs_trans_cancel(upd->tp);
+		upd->tp = NULL;
+		xfs_iunlock(upd->dp, XFS_ILOCK_EXCL);
+		xfs_iunlock(upd->ip, XFS_ILOCK_EXCL);
+		error = nospace_error;
+		goto out_teardown;
+	}
+
+	upd->dp_locked = true;
+	upd->ip_locked = true;
+
+	trace_xfs_metadir_start_link(upd);
+	return 0;
+out_teardown:
+	xfs_metadir_teardown(upd, error);
+	return error;
+}
+
+/*
+ * Link the metadata directory given by @path to the inode @upd->ip.
+ * The path (up to the final component) must already exist, but the final
+ * component must not already exist.
+ */
+int
+xfs_metadir_link(
+	struct xfs_metadir_update	*upd)
+{
+	struct xfs_name			xname;
+	struct xfs_dir_update		du = {
+		.dp			= upd->dp,
+		.name			= &xname,
+		.ip			= upd->ip,
+		.ppargs			= upd->ppargs,
+	};
+	struct xfs_mount		*mp = upd->dp->i_mount;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	xfs_assert_ilocked(upd->dp, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(upd->ip, XFS_ILOCK_EXCL);
+
+	/* Look up the name in the current directory. */
+	xfs_metadir_set_xname(&xname, upd->path,
+			xfs_mode_to_ftype(VFS_I(upd->ip)->i_mode));
+	error = xfs_metadir_lookup(upd->tp, upd->dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	resblks = xfs_link_space_res(mp, xname.len);
+	error = xfs_dir_add_child(upd->tp, resblks, &du);
+	if (error)
+		return error;
+
+	trace_xfs_metadir_link(upd);
+
+	return 0;
+}
+#endif /* ! __KERNEL__ */
+
+/* Commit a metadir update and unlock/drop all resources. */
+int
+xfs_metadir_commit(
+	struct xfs_metadir_update	*upd)
+{
+	int				error;
+
+	trace_xfs_metadir_commit(upd);
+
+	error = xfs_trans_commit(upd->tp);
+	upd->tp = NULL;
+
+	xfs_metadir_teardown(upd, error);
+	return error;
+}
+
+/* Cancel a metadir update and unlock/drop all resources. */
+void
+xfs_metadir_cancel(
+	struct xfs_metadir_update	*upd,
+	int				error)
+{
+	trace_xfs_metadir_cancel(upd);
+
+	xfs_trans_cancel(upd->tp);
+	upd->tp = NULL;
+
+	xfs_metadir_teardown(upd, error);
+}
+
+/* Create a metadata for the last component of the path. */
+int
+xfs_metadir_mkdir(
+	struct xfs_inode		*dp,
+	const char			*path,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.path			= path,
+		.metafile_type		= XFS_METAFILE_DIR,
+	};
+	int				error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	/* Allocate a transaction to create the last directory. */
+	error = xfs_metadir_start_create(&upd);
+	if (error)
+		return error;
+
+	/* Create the subdirectory and take our reference. */
+	error = xfs_metadir_create(&upd, S_IFDIR);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_metadir_commit(&upd);
+	if (error)
+		goto out_irele;
+
+	xfs_finish_inode_setup(upd.ip);
+	*ipp = upd.ip;
+	return 0;
+
+out_cancel:
+	xfs_metadir_cancel(&upd, error);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (upd.ip) {
+		xfs_finish_inode_setup(upd.ip);
+		xfs_irele(upd.ip);
+	}
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
new file mode 100644
index 00000000000000..bfecac7d3d1472
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_metadir.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_METADIR_H__
+#define __XFS_METADIR_H__
+
+/* Cleanup widget for metadata inode creation and deletion. */
+struct xfs_metadir_update {
+	/* Parent directory */
+	struct xfs_inode	*dp;
+
+	/* Path to metadata file */
+	const char		*path;
+
+	/* Parent pointer update context */
+	struct xfs_parent_args	*ppargs;
+
+	/* Child metadata file */
+	struct xfs_inode	*ip;
+
+	struct xfs_trans	*tp;
+
+	enum xfs_metafile_type	metafile_type;
+
+	unsigned int		dp_locked:1;
+	unsigned int		ip_locked:1;
+};
+
+int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
+		const char *path, enum xfs_metafile_type metafile_type,
+		struct xfs_inode **ipp);
+
+int xfs_metadir_start_create(struct xfs_metadir_update *upd);
+int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
+
+int xfs_metadir_start_link(struct xfs_metadir_update *upd);
+int xfs_metadir_link(struct xfs_metadir_update *upd);
+
+int xfs_metadir_commit(struct xfs_metadir_update *upd);
+void xfs_metadir_cancel(struct xfs_metadir_update *upd, int error);
+
+int xfs_metadir_mkdir(struct xfs_inode *dp, const char *path,
+		struct xfs_inode **ipp);
+
+#endif /* __XFS_METADIR_H__ */
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
new file mode 100644
index 00000000000000..adeb25d1a444ca
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_metafile.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+
+/* Set up an inode to be recognized as a metadata directory inode. */
+void
+xfs_metafile_set_iflag(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	enum xfs_metafile_type	metafile_type)
+{
+	VFS_I(ip)->i_mode &= ~0777;
+	VFS_I(ip)->i_uid = GLOBAL_ROOT_UID;
+	VFS_I(ip)->i_gid = GLOBAL_ROOT_GID;
+	if (S_ISDIR(VFS_I(ip)->i_mode))
+		ip->i_diflags |= XFS_METADIR_DIFLAGS;
+	else
+		ip->i_diflags |= XFS_METAFILE_DIFLAGS;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
+	ip->i_metatype = metafile_type;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/* Clear the metadata directory inode flag. */
+void
+xfs_metafile_clear_iflag(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+
+	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index c66b0c51b461a8..acec400123db05 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -17,6 +17,10 @@
 #define XFS_METADIR_DIFLAGS	(XFS_METAFILE_DIFLAGS | \
 				 XFS_DIFLAG_NOSYMLINKS)
 
+void xfs_metafile_set_iflag(struct xfs_trans *tp, struct xfs_inode *ip,
+		enum xfs_metafile_type metafile_type);
+void xfs_metafile_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 48543bf0f5ce83..5171ad93fc40e6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -850,7 +850,7 @@ xfs_trans_metafile_iget(
 	int			error;
 
 	error = xfs_iget(mp, tp, ino, 0, 0, &ip);
-	if (error == -EFSCORRUPTED)
+	if (error == -EFSCORRUPTED || error == -EINVAL)
 		goto whine;
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 17164b2d0472d4..1b9d75a54c5ea2 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -46,6 +46,8 @@
 #include "xfs_parent.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
+#include "xfs_metafile.h"
+#include "xfs_metadir.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8aa6af5c9c0174..e2db13ed08b59c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -95,6 +95,7 @@ struct xfs_attrlist_cursor_kern;
 struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
+struct xfs_metadir_update;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -5352,6 +5353,107 @@ DEFINE_EVENT(xfs_getparents_class, name, \
 DEFINE_XFS_GETPARENTS_EVENT(xfs_getparents_begin);
 DEFINE_XFS_GETPARENTS_EVENT(xfs_getparents_end);
 
+DECLARE_EVENT_CLASS(xfs_metadir_update_class,
+	TP_PROTO(const struct xfs_metadir_update *upd),
+	TP_ARGS(upd),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dp_ino)
+		__field(xfs_ino_t, ino)
+		__string(fname, upd->path)
+	),
+	TP_fast_assign(
+		__entry->dev = upd->dp->i_mount->m_super->s_dev;
+		__entry->dp_ino = upd->dp->i_ino;
+		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__assign_str(fname);
+	),
+	TP_printk("dev %d:%d dp 0x%llx fname '%s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dp_ino,
+		  __get_str(fname),
+		  __entry->ino)
+)
+
+#define DEFINE_METADIR_UPDATE_EVENT(name) \
+DEFINE_EVENT(xfs_metadir_update_class, name, \
+	TP_PROTO(const struct xfs_metadir_update *upd), \
+	TP_ARGS(upd))
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_start_create);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_start_link);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_commit);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_cancel);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_try_create);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_create);
+DEFINE_METADIR_UPDATE_EVENT(xfs_metadir_link);
+
+DECLARE_EVENT_CLASS(xfs_metadir_update_error_class,
+	TP_PROTO(const struct xfs_metadir_update *upd, int error),
+	TP_ARGS(upd, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dp_ino)
+		__field(xfs_ino_t, ino)
+		__field(int, error)
+		__string(fname, upd->path)
+	),
+	TP_fast_assign(
+		__entry->dev = upd->dp->i_mount->m_super->s_dev;
+		__entry->dp_ino = upd->dp->i_ino;
+		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__entry->error = error;
+		__assign_str(fname);
+	),
+	TP_printk("dev %d:%d dp 0x%llx fname '%s' ino 0x%llx error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dp_ino,
+		  __get_str(fname),
+		  __entry->ino,
+		  __entry->error)
+)
+
+#define DEFINE_METADIR_UPDATE_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_metadir_update_error_class, name, \
+	TP_PROTO(const struct xfs_metadir_update *upd, int error), \
+	TP_ARGS(upd, error))
+DEFINE_METADIR_UPDATE_ERROR_EVENT(xfs_metadir_teardown);
+
+DECLARE_EVENT_CLASS(xfs_metadir_class,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name,
+		 xfs_ino_t ino),
+	TP_ARGS(dp, name, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dp_ino)
+		__field(xfs_ino_t, ino)
+		__field(int, ftype)
+		__field(int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(dp)->i_sb->s_dev;
+		__entry->dp_ino = dp->i_ino;
+		__entry->ino = ino,
+		__entry->ftype = name->type;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d dir 0x%llx type %s name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dp_ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+)
+
+#define DEFINE_METADIR_EVENT(name) \
+DEFINE_EVENT(xfs_metadir_class, name, \
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name, \
+		 xfs_ino_t ino), \
+	TP_ARGS(dp, name, ino))
+DEFINE_METADIR_EVENT(xfs_metadir_lookup);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

