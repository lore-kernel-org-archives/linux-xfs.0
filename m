Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8BF1C548E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528285; cv=none; b=qqtvmDEJcEicPZtbzzeVpkbm5rd+7eHtBzGfxmOJn/xk6RT+iR5CLLCm4a+SkXSZ8pp2cVQ7MGKIn8qfCZlM0+c+aR+icAbsYjhirnUQIFP8CLQAgdujOwQryA/jU7XOioLqhzpo3LkI6TPRoihiMTPEojJ0JmYm40aP0zf21b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528285; c=relaxed/simple;
	bh=/5WWOuWXk6eoQtCJEOqgNEJCfeQnOofHmSshmckkt5Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8JlQ4zNeIMDkuqVzYEliD5wWvDjg220iLy11/BfOrY3XglmQz0mzFuXEUWmZ1ZqloEaeL5Q0ZOObfcBOs4QK2cdZ2LfMADAvd8EqLzr1BBHXTYhDaCUY3aFJoknAK40/12bTZu7G023RDfGeuU/Z42dgwuezXKqHC9I761yiY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kecMrzrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kecMrzrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63877C4CED1;
	Fri,  6 Dec 2024 23:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528285;
	bh=/5WWOuWXk6eoQtCJEOqgNEJCfeQnOofHmSshmckkt5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kecMrzrOUuIohypSJ7ksTm03LrOOcLgFjuPYtve/NR3bOmwQZBMilqZ6TC8qfpmS6
	 YnEcetjOSydCnm7LD5xj7Q27cuXVnGrWQAUcsvqiIBF4t+BLEUqZTfOu6MifNgddMf
	 4osUkhUBGbipfE7yrTgSai4+vP/tiKEGHssZAiVmAxQE33jLwkTi66s7Q4ZBhLkIon
	 dnAGq/glZmLaIgLwCIOoMjOQfUEomLboRWdyEmIT/63faTOMfApGIOrPX+lhJsOklR
	 IEFUh5b2wn/mQhAwyUrgL1EXhetEF1cTp63UFX39sa4SZ8ldSt6bslXakJXuJqDTNC
	 XhgAB6eLr7f4Q==
Date: Fri, 06 Dec 2024 15:38:04 -0800
Subject: [PATCH 30/36] xfs: read and write metadata inode directory tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747334.121772.2827186347071122552.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit e0f091c40bf1287a122dcddd8aa4e6ad06ce441f

Plumb in the bits we need to load metadata inodes from a named entry in
a metadir directory, create (or hardlink) inodes into a metadir
directory, create metadir directories, and flag inodes as being metadata
files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h         |    1 
 include/xfs_trace.h      |   10 +
 include/xfs_trans.h      |    3 
 libxfs/Makefile          |    3 
 libxfs/libxfs_api_defs.h |    7 +
 libxfs/libxfs_priv.h     |    2 
 libxfs/trans.c           |   39 ++++
 libxfs/xfs_metadir.c     |  473 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_metadir.h     |   47 +++++
 libxfs/xfs_metafile.c    |   52 +++++
 libxfs/xfs_metafile.h    |    4 
 11 files changed, 641 insertions(+)
 create mode 100644 libxfs/xfs_metadir.c
 create mode 100644 libxfs/xfs_metadir.h
 create mode 100644 libxfs/xfs_metafile.c


diff --git a/include/libxfs.h b/include/libxfs.h
index 0356bc57b956a9..348d36be192966 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -96,6 +96,7 @@ struct iomap;
 #include "xfs_parent.h"
 #include "xfs_ag_resv.h"
 #include "xfs_metafile.h"
+#include "xfs_metadir.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index de435a9d1a2a64..f3e531ef118d05 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -360,6 +360,16 @@
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
 
+#define trace_xfs_metadir_cancel(...)		((void) 0)
+#define trace_xfs_metadir_commit(...)		((void) 0)
+#define trace_xfs_metadir_create(...)		((void) 0)
+#define trace_xfs_metadir_link(...)		((void) 0)
+#define trace_xfs_metadir_lookup(...)		((void) 0)
+#define trace_xfs_metadir_start_create(...)	((void) 0)
+#define trace_xfs_metadir_start_link(...)	((void) 0)
+#define trace_xfs_metadir_teardown(...)		((void) 0)
+#define trace_xfs_metadir_try_create(...)	((void) 0)
+
 #define trace_xfs_iunlink_update_bucket(...)	((void) 0)
 #define trace_xfs_iunlink_update_dinode(...)	((void) 0)
 #define trace_xfs_iunlink(...)			((void) 0)
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 9bc4b1ef5e82f9..d508f8947a301c 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -93,6 +93,9 @@ int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 int	libxfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 			unsigned int dblocks, unsigned int rblocks, bool force,
 			struct xfs_trans **tpp);
+int	libxfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+			struct xfs_inode *ip, unsigned int *dblocks,
+			struct xfs_trans **tpp, int *nospace_error);
 int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
 				    struct xfs_trans **tpp);
 int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 765c84a16408f8..c8267841e77b01 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -55,6 +55,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_util.h \
+	xfs_metadir.h \
 	xfs_metafile.h \
 	xfs_parent.h \
 	xfs_quota_defs.h \
@@ -114,6 +115,8 @@ CFILES = buf_mem.c \
 	xfs_inode_fork.c \
 	xfs_inode_util.c \
 	xfs_ialloc_btree.c \
+	xfs_metadir.c \
+	xfs_metafile.c \
 	xfs_log_rlimit.c \
 	xfs_parent.c \
 	xfs_refcount.c \
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index fefae9256555a0..dd163709fe07df 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -176,6 +176,7 @@
 #define xfs_iallocbt_calc_size		libxfs_iallocbt_calc_size
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
+#define xfs_icreate			libxfs_icreate
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_first			libxfs_iext_first
@@ -212,6 +213,11 @@
 
 #define xfs_metafile_iget		libxfs_metafile_iget
 #define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
+#define xfs_metadir_link		libxfs_metadir_link
+#define xfs_metadir_lookup		libxfs_metadir_lookup
+#define xfs_metadir_start_create	libxfs_metadir_start_create
+#define xfs_metadir_start_link		libxfs_metadir_start_link
+
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
 
@@ -285,6 +291,7 @@
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
 #define xfs_trans_alloc			libxfs_trans_alloc
+#define xfs_trans_alloc_dir		libxfs_trans_alloc_dir
 #define xfs_trans_alloc_inode		libxfs_trans_alloc_inode
 #define xfs_trans_bdetach		libxfs_trans_bdetach
 #define xfs_trans_bhold			libxfs_trans_bhold
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1b6bb961b7ac06..631abf266ad526 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -181,6 +181,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ILOCK_SHARED		0
 #define XFS_ILOCK_RTBITMAP		0
 #define XFS_ILOCK_RTSUM			0
+#define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
@@ -632,6 +633,7 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* xfs_inode.h */
 #define xfs_iflags_set(ip, flags)	do { } while (0)
+#define xfs_finish_inode_setup(ip)	((void) 0)
 
 /* linux/wordpart.h */
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7e36205c6a3d50..72f26591053716 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1185,6 +1185,45 @@ libxfs_trans_alloc_inode(
 	return 0;
 }
 
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  @resblks must point to the number
+ * of blocks to reserve; if not enough space is available, -ENOSPC will be
+ * returned.  @nospace_error is always set to zero here.  Userspace does not
+ * support reservationless creation at all, unlike the kernel.
+ *
+ * The ILOCKs will be dropped when the transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
+ */
+int
+libxfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*resblks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	*nospace_error = 0;
+
+	error = xfs_trans_alloc(mp, resv, *resblks, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	*tpp = tp;
+	return 0;
+}
+
 /*
  * Try to reserve more blocks for a transaction.  The single use case we
  * support is for offline repair -- use a transaction to gather data without
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
new file mode 100644
index 00000000000000..b52abf12d20511
--- /dev/null
+++ b/libxfs/xfs_metadir.c
@@ -0,0 +1,473 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
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
diff --git a/libxfs/xfs_metadir.h b/libxfs/xfs_metadir.h
new file mode 100644
index 00000000000000..bfecac7d3d1472
--- /dev/null
+++ b/libxfs/xfs_metadir.h
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
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
new file mode 100644
index 00000000000000..3bd9493373115a
--- /dev/null
+++ b/libxfs/xfs_metafile.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
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
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
index c66b0c51b461a8..acec400123db05 100644
--- a/libxfs/xfs_metafile.h
+++ b/libxfs/xfs_metafile.h
@@ -17,6 +17,10 @@
 #define XFS_METADIR_DIFLAGS	(XFS_METAFILE_DIFLAGS | \
 				 XFS_DIFLAG_NOSYMLINKS)
 
+void xfs_metafile_set_iflag(struct xfs_trans *tp, struct xfs_inode *ip,
+		enum xfs_metafile_type metafile_type);
+void xfs_metafile_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,

