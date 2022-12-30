Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD05C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiLaCKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:10:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0004140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E16E61CE2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CF2C433EF;
        Sat, 31 Dec 2022 02:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452604;
        bh=y6ZNHtJxhTMoUx20tL/uU+id57ri25+Ux/iWhLnW7PM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WU9bID7Hx36Y8CS5QA0eRRhOxYPclOIMxowqbAX1Yfj8cUj8GPN2rZsfxjGe/Km36
         UlDm4MksqSe+1aSWctSKNCzXthRb7YdCV0sXmj4ljOydL/NoCaQHWko6scC1nv1+u4
         O6wHsYDs5GqccoA7jodGj6o28VU/K8lyKYSS8wboqr4Q91xPDf67EZQxfUCcimtVQC
         UEMPp+LQm6jk8p4K+XUIlGJ00jsme/ZUrI2AOYs24jAKb6qsWouVtQ5L/XE50FdprV
         Kn7oaN7fYkwi/qogEGxVq8fkkEL7GoAqrN47T3XBPudEABjlsmlorYqDSX/xjW4dlV
         wujDnpNlkcqJA==
Subject: [PATCH 01/46] xfs: create imeta abstractions to get and set metadata
 inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:19 -0800
Message-ID: <167243875957.725900.8939749369868213347.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create some helper routines to get and set metadata inode numbers
instead of open-coding them throughout xfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h         |    1 
 include/xfs_trace.h      |    7 +
 libxfs/Makefile          |    2 
 libxfs/init.c            |   20 ++
 libxfs/libxfs_api_defs.h |   12 +
 libxfs/libxfs_priv.h     |    2 
 libxfs/xfs_imeta.c       |  437 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |   48 +++++
 libxfs/xfs_types.c       |    5 -
 mkfs/xfs_mkfs.c          |    2 
 10 files changed, 532 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/xfs_imeta.c
 create mode 100644 libxfs/xfs_imeta.h


diff --git a/include/libxfs.h b/include/libxfs.h
index a4f6e1c2b28..b06d691e283 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -82,6 +82,7 @@ struct iomap;
 #include "xfs_btree_staging.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_ag_resv.h"
+#include "xfs_imeta.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index d94d8d29bed..78bce651a6f 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -349,6 +349,13 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_imeta_end_update(...)		((void) 0)
+#define trace_xfs_imeta_sb_link(...)		((void) 0)
+#define trace_xfs_imeta_sb_lookup(...)		((void) 0)
+#define trace_xfs_imeta_sb_create(...)		((void) 0)
+#define trace_xfs_imeta_sb_unlink(...)		((void) 0)
+#define trace_xfs_imeta_start_update(...)	((void) 0)
+
 #define trace_xfs_iunlink_update_bucket(...)	((void) 0)
 #define trace_xfs_iunlink_update_dinode(...)	((void) 0)
 #define trace_xfs_iunlink(...)			((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 94f5968e862..4296a6d9158 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -47,6 +47,7 @@ HFILES = \
 	xfs_errortag.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
+	xfs_imeta.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_util.h \
@@ -98,6 +99,7 @@ CFILES = cache.c \
 	xfs_dquot_buf.c \
 	xfs_ialloc.c \
 	xfs_iext_tree.c \
+	xfs_imeta.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
 	xfs_inode_util.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index b80f6bfd8fc..e19b4e6d4cf 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -791,6 +791,24 @@ libxfs_compute_all_maxlevels(
 	xfs_agbtree_compute_maxlevels(mp);
 }
 
+/* Mount the metadata files under the metadata directory tree. */
+STATIC void
+libxfs_mountfs_imeta(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/* Ignore filesystems that are under construction. */
+	if (mp->m_sb.sb_inprogress)
+		return;
+
+	error = -xfs_imeta_mount(mp);
+	if (error)
+		fprintf(stderr,
+_("%s: metadata inode mounting failed, error %d\n"),
+			progname, error);
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -953,6 +971,8 @@ libxfs_mount(
 	}
 	xfs_set_perag_data_loaded(mp);
 
+	libxfs_mountfs_imeta(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a5f9c6006f6..5657fee51b8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -145,6 +145,8 @@
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
+#define xfs_icreate			libxfs_icreate
+#define xfs_icreate_args_rootfile	libxfs_icreate_args_rootfile
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_first			libxfs_iext_first
@@ -153,6 +155,15 @@
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
 #define xfs_imap_to_bp			libxfs_imap_to_bp
+
+#define xfs_imeta_create		libxfs_imeta_create
+#define xfs_imeta_end_update		libxfs_imeta_end_update
+#define xfs_imeta_link			libxfs_imeta_link
+#define xfs_imeta_lookup		libxfs_imeta_lookup
+#define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_start_update		libxfs_imeta_start_update
+#define xfs_imeta_unlink		libxfs_imeta_unlink
+
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
@@ -170,6 +181,7 @@
 
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
+#define xfs_is_meta_ino			libxfs_is_meta_ino
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 90335331cde..85b54f16803 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -528,6 +528,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 static inline int retzero(void) { return 0; }
 #define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	retzero()
 #define xfs_quota_unreserve_blkres(i,b) 		retzero()
+#define xfs_qm_dqattach(i)				(0)
+#define xfs_qm_dqattach_locked(ip, alloc)		(0)
 
 #define xfs_quota_reserve_blkres(i,b)		(0)
 #define xfs_qm_dqattach(i)			(0)
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
new file mode 100644
index 00000000000..b5c6672e7d5
--- /dev/null
+++ b/libxfs/xfs_imeta.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_ialloc.h"
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
+ * on path lookups into a metadata directory structure.
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
+/* Update inode pointers in the superblock. */
+static inline void
+xfs_imeta_log_sb(
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp = xfs_trans_getsb(tp);
+
+	/*
+	 * Update the inode flags in the ondisk superblock without touching
+	 * the summary counters.  We have not quiesced inode chunk allocation,
+	 * so we cannot coordinate with updates to the icount and ifree percpu
+	 * counters.
+	 */
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
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
+	unsigned int			flags,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_icreate_args		args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+	};
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	int				error;
+
+	xfs_icreate_args_rootfile(&args, mode);
+
+	/* Reject if the sb already points to some inode. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	if (*sb_inop != NULLFSINO)
+		return -EEXIST;
+
+	/* Create a new inode and set the sb pointer. */
+	error = xfs_dialloc(tpp, 0, mode, &ino);
+	if (error)
+		return error;
+	error = xfs_icreate(*tpp, ino, &args, ipp);
+	if (error)
+		return error;
+
+	/* Attach dquots to this file.  Caller should have allocated them! */
+	if (!(flags & XFS_IMETA_CREATE_NOQUOTA)) {
+		error = xfs_qm_dqattach_locked(*ipp, false);
+		if (error)
+			return error;
+		xfs_trans_mod_dquot_byino(*tpp, *ipp, XFS_TRANS_DQ_ICOUNT, 1);
+	}
+
+	/* Update superblock pointer. */
+	*sb_inop = ino;
+	trace_xfs_imeta_sb_create(mp, sb_inop);
+	xfs_imeta_log_sb(*tpp);
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
+	xfs_imeta_log_sb(*tpp);
+	return xfs_droplink(*tpp, ip);
+}
+
+/* Set the given inode pointer in the superblock. */
+STATIC int
+xfs_imeta_sb_link(
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+	if (*sb_inop == NULLFSINO)
+		return -EEXIST;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	inc_nlink(VFS_I(ip));
+	*sb_inop = ip->i_ino;
+	trace_xfs_imeta_sb_link(mp, sb_inop);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_imeta_log_sb(tp);
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
+ * The caller must provide a @upd structure.
+ *
+ * Callers must ensure that the root dquots are allocated, if applicable.
+ *
+ * NOTE: This function may pass a child inode @ipp back to the caller even if
+ * it returns a negative error code.  If an inode is passed back, the caller
+ * must finish setting up the incore inode before releasing it.
+ */
+int
+xfs_imeta_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	unsigned int			flags,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_update		*upd)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	*ipp = NULL;
+
+	return xfs_imeta_sb_create(tpp, path, mode, flags, ipp);
+}
+
+/*
+ * Unlink a metadata inode @ip from the metadata directory given by @path.  The
+ * metadata inode must not be ILOCKed.  Upon return, the inode will be ijoined
+ * and logged to @tpp, and returned with reduced link count, ready to be
+ * released.  The caller must provide a @upd structure.
+ */
+int
+xfs_imeta_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	ASSERT(xfs_imeta_verify((*tpp)->t_mountp, ip->i_ino));
+
+	return xfs_imeta_sb_unlink(tpp, path, ip);
+}
+
+/*
+ * Link the metadata directory given by @path point to the given inode number.
+ * The path must not already exist.  The caller must not hold the ILOCK, and
+ * the function will return with the inode joined to the transaction.
+ */
+int
+xfs_imeta_link(
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	ASSERT(xfs_imeta_path_check(path));
+
+	return xfs_imeta_sb_link(tp, path, ip);
+}
+
+/*
+ * Clean up after committing (or cancelling) a metadata inode creation or
+ * removal.
+ */
+void
+xfs_imeta_end_update(
+	struct xfs_mount		*mp,
+	struct xfs_imeta_update		*upd,
+	int				error)
+{
+	trace_xfs_imeta_end_update(mp, error, __return_address);
+}
+
+/* Start setting up for a metadata directory tree operation. */
+int
+xfs_imeta_start_update(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_update		*upd)
+{
+	trace_xfs_imeta_start_update(mp, 0, __return_address);
+
+	memset(upd, 0, sizeof(struct xfs_imeta_update));
+	return 0;
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
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
new file mode 100644
index 00000000000..b535e19ff1a
--- /dev/null
+++ b/libxfs/xfs_imeta.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
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
+struct xfs_imeta_update {
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
+/* Don't allocate quota for this file. */
+#define XFS_IMETA_CREATE_NOQUOTA	(1 << 0)
+int xfs_imeta_create(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     umode_t mode, unsigned int flags, struct xfs_inode **ipp,
+		     struct xfs_imeta_update *upd);
+int xfs_imeta_unlink(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     struct xfs_inode *ip, struct xfs_imeta_update *upd);
+int xfs_imeta_link(struct xfs_trans *tp, const struct xfs_imeta_path *path,
+		   struct xfs_inode *ip, struct xfs_imeta_update *upd);
+void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_update *upd,
+			  int error);
+int xfs_imeta_start_update(struct xfs_mount *mp,
+			   const struct xfs_imeta_path *path,
+			   struct xfs_imeta_update *upd);
+
+bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
+int xfs_imeta_mount(struct xfs_mount *mp);
+
+#endif /* __XFS_IMETA_H__ */
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 87abc824479..93eefd7b35f 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -12,6 +12,7 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_ag.h"
+#include "xfs_imeta.h"
 
 
 /*
@@ -115,9 +116,7 @@ xfs_internal_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_has_quota(mp) &&
-		 xfs_is_quota_inode(&mp->m_sb, ino));
+	return xfs_is_static_meta_ino(mp, ino);
 }
 
 /*
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cca3497ab64..bd730d6cb07 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3824,6 +3824,7 @@ start_superblock_setup(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_magicnum = XFS_SB_MAGIC;
 	sbp->sb_sectsize = (uint16_t)cfg->sectorsize;
 	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
@@ -3907,7 +3908,6 @@ finish_superblock_setup(
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
 	sbp->sb_rextslog = (uint8_t)(cfg->rtextents ?
 			libxfs_highbit32((unsigned int)cfg->rtextents) : 0);
-	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_imax_pct = cfg->imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;

