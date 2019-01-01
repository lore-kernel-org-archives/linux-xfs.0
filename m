Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56298 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:22:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012F86w169028
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:35 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxauk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:22:35 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012MYwG012801
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:34 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012MYpB028718
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:34 GMT
Subject: [PATCH 01/13] xfs: create imeta abstractions to get and set
 metadata inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:22:32 -0800
Message-ID: <154630935225.21716.14557647854216921704.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some helper routines to get and set metadata inode numbers
instead of open-coding them throughout xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_imeta.c |  381 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |   43 +++++
 fs/xfs/libxfs/xfs_types.c |    5 -
 fs/xfs/xfs_mount.c        |   21 ++
 fs/xfs/xfs_trace.h        |   29 +++
 6 files changed, 477 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ab373aeb0c37..57651a47b5e9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -46,6 +46,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
 				   xfs_iext_tree.o \
+				   xfs_imeta.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_inode_util.o \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
new file mode 100644
index 000000000000..2599b236f6de
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -0,0 +1,381 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+
+/*
+ * Metadata Inode Number Management
+ * ================================
+ *
+ * These functions provide an abstraction layer for looking up, creating, and
+ * deleting metadata inodes.  These pointers live in the in-core superblock,
+ * so the functions moderate access to those fields and take care of logging.
+ *
+ * For the five existing metadata inodes (real time bitmap & summary; and the
+ * user, group, and quotas) we'll continue to maintain the in-core superblock
+ * inodes for reads and only require xfs_imeta_create and xfs_imeta_unlink to
+ * persist changes.  New metadata inode types must only use the xfs_imeta_*
+ * functions.
+ *
+ * Callers wishing to create or unlink a metadata inode must pass in a
+ * xfs_imeta_end structure.  After committing or cancelling the transaction,
+ * this structure must be passed to xfs_imeta_end_update to free resources that
+ * cannot be freed during the transaction.
+ *
+ * Right now we only support callers passing in the predefined metadata inode
+ * paths; the goal is that callers will some day locate metadata inodes based
+ * on a metadata inode directory structure.
+ */
+
+/* Static metadata inode paths */
+
+const struct xfs_imeta_path XFS_IMETA_RTBITMAP = {
+	.bogus = 0,
+};
+
+const struct xfs_imeta_path XFS_IMETA_RTSUMMARY = {
+	.bogus = 1,
+};
+
+const struct xfs_imeta_path XFS_IMETA_USRQUOTA = {
+	.bogus = 2,
+};
+
+const struct xfs_imeta_path XFS_IMETA_GRPQUOTA = {
+	.bogus = 3,
+};
+
+const struct xfs_imeta_path XFS_IMETA_PRJQUOTA = {
+	.bogus = 4,
+};
+
+/* Are these two paths equal? */
+STATIC bool
+xfs_imeta_path_compare(
+	const struct xfs_imeta_path	*a,
+	const struct xfs_imeta_path	*b)
+{
+	return a == b;
+}
+
+/* Is this path ok? */
+static inline bool
+xfs_imeta_path_check(
+	const struct xfs_imeta_path	*path)
+{
+	return true;
+}
+
+/* Functions for storing and retrieving superblock inode values. */
+
+/* Mapping of metadata inode paths to in-core superblock values. */
+static const struct xfs_imeta_sbmap {
+	const struct xfs_imeta_path	*path;
+	unsigned int			offset;
+} xfs_imeta_sbmaps[] = {
+	{
+		.path	= &XFS_IMETA_RTBITMAP,
+		.offset	= offsetof(struct xfs_sb, sb_rbmino),
+	},
+	{
+		.path	= &XFS_IMETA_RTSUMMARY,
+		.offset	= offsetof(struct xfs_sb, sb_rsumino),
+	},
+	{
+		.path	= &XFS_IMETA_USRQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_uquotino),
+	},
+	{
+		.path	= &XFS_IMETA_GRPQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_gquotino),
+	},
+	{
+		.path	= &XFS_IMETA_PRJQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_pquotino),
+	},
+	{ NULL, 0 },
+};
+
+/* Return a pointer to the in-core superblock inode value. */
+static inline xfs_ino_t *
+xfs_imeta_sbmap_to_inop(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_sbmap	*map)
+{
+	return (xfs_ino_t *)(((char *)&mp->m_sb) + map->offset);
+}
+
+/* Compute location of metadata inode pointer in the in-core superblock */
+static inline xfs_ino_t *
+xfs_imeta_path_to_sb_inop(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	const struct xfs_imeta_sbmap	*p;
+
+	for (p = xfs_imeta_sbmaps; p->path; p++)
+		if (xfs_imeta_path_compare(p->path, path))
+			return xfs_imeta_sbmap_to_inop(mp, p);
+
+	return NULL;
+}
+
+/* Look up a superblock metadata inode by its path. */
+STATIC int
+xfs_imeta_sb_lookup(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	trace_xfs_imeta_sb_lookup(mp, sb_inop);
+	*inop = *sb_inop;
+	return 0;
+}
+
+/*
+ * Create a new metadata inode and set a superblock pointer to this new inode.
+ * The superblock field must not already be pointing to an inode.
+ */
+STATIC int
+xfs_imeta_sb_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_ialloc_args args = {
+		.ops			= &xfs_default_ialloc_ops,
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+		.mode			= mode,
+	};
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+	int				error;
+
+	/* Reject if the sb already points to some inode. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	if (*sb_inop != NULLFSINO)
+		return -EEXIST;
+
+	/* Otherwise, create the inode and set the sb pointer. */
+	error = xfs_dir_ialloc(tpp, &args, ipp);
+	if (error)
+		return error;
+
+
+	*sb_inop = (*ipp)->i_ino;
+	trace_xfs_imeta_sb_create(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return 0;
+}
+
+/*
+ * Clear the given inode pointer from the superblock and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_sb_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	/* Reject if the sb doesn't point to the inode that was passed in. */
+	if (*sb_inop != ip->i_ino)
+		return -ENOENT;
+
+	*sb_inop = NULLFSINO;
+	trace_xfs_imeta_sb_unlink(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return xfs_droplink(*tpp, ip);
+}
+
+/* Set the given inode pointer to NULL in the superblock. */
+STATIC int
+xfs_imeta_sb_zap(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	*sb_inop = NULLFSINO;
+	trace_xfs_imeta_sb_zap(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return 0;
+}
+
+/* General functions for managing metadata inode pointers */
+
+/*
+ * Is this metadata inode pointer ok?  We allow the fields to be set to
+ * NULLFSINO if the metadata structure isn't present, and we don't allow
+ * obviously incorrect inode pointers.
+ */
+static inline bool
+xfs_imeta_verify(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (ino == NULLFSINO)
+		return true;
+	return xfs_verify_ino(mp, ino);
+}
+
+/* Look up a metadata inode by its path. */
+int
+xfs_imeta_lookup(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	xfs_ino_t			ino;
+	int				error;
+
+	ASSERT(xfs_imeta_path_check(path));
+
+	error = xfs_imeta_sb_lookup(mp, path, &ino);
+	if (error)
+		return error;
+
+	if (!xfs_imeta_verify(mp, ino))
+		return -EFSCORRUPTED;
+
+	*inop = ino;
+	return 0;
+}
+
+/*
+ * Create a metadata inode with the given @mode, and insert it into the
+ * metadata directory tree at the given @path.  The path (up to the final
+ * component) must already exist.  The new metadata inode @ipp will be ijoined
+ * and logged to @tpp, with the ILOCK held until the next transaction commit.
+ * The caller must provide a @cleanup structure.
+ *
+ * NOTE: This function may pass a child inode @ipp back to the caller along
+ * with an error status code.  The caller must always check for a non-null
+ * child inode and release it.
+ */
+int
+xfs_imeta_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	*ipp = NULL;
+
+	return xfs_imeta_sb_create(tpp, path, mode, ipp);
+}
+
+/*
+ * Unlink a metadata inode @ip from the metadata directory given by @path.  The
+ * metadata inode must not be ILOCKed.  Upon return, the inode will be ijoined
+ * and logged to @tpp, and returned with reduced link count, ready to be
+ * released.  The caller must provide a @cleanup structure.
+ */
+int
+xfs_imeta_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	ASSERT(xfs_imeta_verify((*tpp)->t_mountp, ip->i_ino));
+
+	return xfs_imeta_sb_unlink(tpp, path, ip);
+}
+
+/*
+ * Forcibly clear the metadata pointer noted by @path so that a subsequent
+ * lookup will return NULLFSINO.  If the pointer was not already NULLFSINO, the
+ * caller is responsible for cleaning up those resources; in other words, this
+ * function is only to be used when blowing out a totally destroyed metadata
+ * inode.  The caller must provide a @cleanup structure.
+ */
+int
+xfs_imeta_zap(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+
+	return xfs_imeta_sb_zap(tpp, path);
+}
+
+/*
+ * Clean up after committing (or cancelling) a metadata inode creation or
+ * removal.
+ */
+void
+xfs_imeta_end_update(
+	struct xfs_mount		*mp,
+	struct xfs_imeta_end		*cleanup,
+	int				error)
+{
+	trace_xfs_imeta_end_update(mp, 0, error, _RET_IP_);
+}
+
+/* Does this inode number refer to a static metadata inode? */
+bool
+xfs_is_static_meta_ino(
+	struct xfs_mount		*mp,
+	xfs_ino_t			ino)
+{
+	const struct xfs_imeta_sbmap	*p;
+
+	if (ino == NULLFSINO)
+		return false;
+
+	for (p = xfs_imeta_sbmaps; p->path; p++)
+		if (ino == *xfs_imeta_sbmap_to_inop(mp, p))
+			return true;
+
+	return false;
+}
+
+/* Ensure that the in-core superblock has all the values that it should. */
+int
+xfs_imeta_mount(
+	struct xfs_mount	*mp)
+{
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
new file mode 100644
index 000000000000..373d40703dec
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_IMETA_H__
+#define __XFS_IMETA_H__
+
+/* Key for looking up metadata inodes. */
+struct xfs_imeta_path {
+	/* Temporary: integer to keep the static imeta definitions unique */
+	int		bogus;
+};
+
+/* Cleanup widget for metadata inode creation and deletion. */
+struct xfs_imeta_end {
+	/* empty for now */
+};
+
+/* Lookup keys for static metadata inodes. */
+extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
+extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
+extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+
+int xfs_imeta_lookup(struct xfs_mount *mp, const struct xfs_imeta_path *path,
+		     xfs_ino_t *ino);
+
+int xfs_imeta_create(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     umode_t mode, struct xfs_inode **ipp,
+		     struct xfs_imeta_end *cleanup);
+int xfs_imeta_unlink(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     struct xfs_inode *ip, struct xfs_imeta_end *cleanup);
+int xfs_imeta_zap(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		  struct xfs_imeta_end *cleanup);
+void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_end *cleanup,
+			  int error);
+
+bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
+int xfs_imeta_mount(struct xfs_mount *mp);
+
+#endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 24715ed086e3..d05ccfabbc9c 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -20,6 +20,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_imeta.h"
 
 /* Find the size of the AG, in blocks. */
 xfs_agblock_t
@@ -140,9 +141,7 @@ xfs_internal_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 xfs_is_quota_inode(&mp->m_sb, ino));
+	return xfs_is_static_meta_ino(mp, ino);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0bcab017b12b..b895368c64fb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
+#include "xfs_imeta.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -665,6 +666,22 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+STATIC int
+xfs_mountfs_imeta(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_imeta_mount(mp);
+	if (error) {
+		xfs_warn(mp, "Failed to load metadata inode info, error %d",
+				error);
+		return error;
+	}
+
+	return 0;
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -902,6 +919,10 @@ xfs_mountfs(
 	if (error)
 		goto out_log_dealloc;
 
+	error = xfs_mountfs_imeta(mp);
+	if (error)
+		goto out_log_dealloc;
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 02683ec06164..5392cc85e951 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3381,6 +3381,35 @@ DEFINE_TRANS_EVENT(xfs_trans_roll);
 DEFINE_TRANS_EVENT(xfs_trans_add_item);
 DEFINE_TRANS_EVENT(xfs_trans_free_items);
 
+DECLARE_EVENT_CLASS(xfs_imeta_sb_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t *sb_inop),
+	TP_ARGS(mp, sb_inop),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, sb_offset)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->sb_offset = (char *)sb_inop - (char *)&mp->m_sb;
+		__entry->ino = *sb_inop;
+	),
+	TP_printk("dev %d:%d sb_offset 0x%x ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->sb_offset,
+		  __entry->ino)
+)
+
+#define DEFINE_IMETA_SB_EVENT(name) \
+DEFINE_EVENT(xfs_imeta_sb_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t *sb_inop), \
+	TP_ARGS(mp, sb_inop))
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_lookup);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_create);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_unlink);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_zap);
+DEFINE_AG_ERROR_EVENT(xfs_imeta_end_update);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
