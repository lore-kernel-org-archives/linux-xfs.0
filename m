Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D772C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiLaBK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiLaBK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:10:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8BC312
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DED62B81DCA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D7C433EF;
        Sat, 31 Dec 2022 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449051;
        bh=xMzNgPC+O4GXh5V4jqbUEgWJrLEsTs1CAJqHUgLzuNM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M+pXwI7Uq0NvpQFK5HFZUEXpQTAxv+P/HuPNxgL8AHKFPyYPvTBkRoXDDKqBpfqQp
         b3d+cyl8OYLXPQXu1PbxZ800gJpMM7CUn3TlSXIzzthO31Aoo6CTtWFxtX9S7CSrSw
         m7M2rpI6FGJqpqUrnXGz7S4kM1ktR8CZ8Y4Zetymxf0ZtyvtVE6e7FYx0fTqoOsRkG
         U3cs0QRJRjDzxDw28Ddjb+gdEPDiWL5zkagALkTitzT4Nt/6kgPHpvzPrh8R7jWIdk
         9tkZL/HnT2jLpXbK0LWfRxIQrJwCJBAKbZw75ly1cqKN/5NoaDP6FaQcm7iNwSw8EV
         pAtuzHNtEzpZg==
Subject: [PATCH 02/23] xfs: create imeta abstractions to get and set metadata
 inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:24 -0800
Message-ID: <167243864485.708110.13281129419393879317.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
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
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_imeta.c |  438 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |   48 +++++
 fs/xfs/libxfs/xfs_types.c |    5 -
 fs/xfs/xfs_mount.c        |   21 ++
 fs/xfs/xfs_trace.h        |   37 ++++
 6 files changed, 546 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index dac4165b02c0..3d74696755c3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -37,6 +37,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
 				   xfs_iext_tree.o \
+				   xfs_imeta.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_inode_util.o \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
new file mode 100644
index 000000000000..0a1cd0c5c15b
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -0,0 +1,438 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
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
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
new file mode 100644
index 000000000000..b535e19ff1a0
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.h
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
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 5c2765934732..50efa181b26d 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 54cd47882991..0ee6a856f1e4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_imeta.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -609,6 +610,22 @@ xfs_mount_setup_inode_geom(
 	xfs_ialloc_setup_geometry(mp);
 }
 
+STATIC int
+xfs_mount_setup_metadir(
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
 /* Compute maximum possible height for per-AG btree types for this fs. */
 static inline void
 xfs_agbtree_compute_maxlevels(
@@ -843,6 +860,10 @@ xfs_mountfs(
 		mp->m_features |= XFS_FEAT_ATTR2;
 	}
 
+	error = xfs_mount_setup_metadir(mp);
+	if (error)
+		goto out_log_dealloc;
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 147dbdf73d92..1a3176932de8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -148,7 +148,7 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
-TRACE_EVENT(xlog_intent_recovery_failed,
+DECLARE_EVENT_CLASS(xfs_fs_error_class,
 	TP_PROTO(struct xfs_mount *mp, int error, void *function),
 	TP_ARGS(mp, error, function),
 	TP_STRUCT__entry(
@@ -165,6 +165,11 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->error, __entry->function)
 );
+#define DEFINE_FS_ERROR_EVENT(name)	\
+DEFINE_EVENT(xfs_fs_error_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, int error, void *function), \
+	TP_ARGS(mp, error, function))
+DEFINE_FS_ERROR_EVENT(xlog_intent_recovery_failed);
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
@@ -4917,6 +4922,36 @@ TRACE_EVENT(xfs_swapext_delta_nextents,
 		  __entry->d_nexts1, __entry->d_nexts2)
 );
 
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
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_link);
+DEFINE_FS_ERROR_EVENT(xfs_imeta_start_update);
+DEFINE_FS_ERROR_EVENT(xfs_imeta_end_update);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

