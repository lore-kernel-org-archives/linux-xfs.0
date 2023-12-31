Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9090BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mU/SrOef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63334C433C7;
	Sun, 31 Dec 2023 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056805;
	bh=TgUFMxRKwuXpTWn81RLKYp/eSj2NeAK29umwTzUbnEI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mU/SrOefPxDM9LsK0Qa6zYvQqyarxBSilodYd598PKKiuxhT4WO+9iKkYnXMsu5i1
	 sit6cC7WO5HXN7VCPw0XPdqki+ijW+n+B6t7lnjbrduO99mO+aH42DwhvpzW5hfDWF
	 QnR5v34KVDGzawfSIjiqpiC7sjHtCQSsxlrRTKFB3H/JWzX6FdcrEd29bm/+LmLNFI
	 9d9+mvWvoi8/DOUuP2gd6AQgCMqmmQCpHhr6e7Sb2owRi7gWbokAETIdQ64hp3PkKA
	 xRVgsMJEwRFabAmQFt2FwWnFr1GlfSpkMpps6whtr2TUTXg/YGUnXcS+k3RdUTja8j
	 xYLbPqkGhiZWQ==
Date: Sun, 31 Dec 2023 13:06:45 -0800
Subject: [PATCH 02/32] xfs: create imeta abstractions to get and set metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844895.1760491.2129749368824094459.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Create some helper routines to get and set metadata inode numbers
instead of open-coding them throughout xfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    2 
 fs/xfs/libxfs/xfs_imeta.c |  411 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |   46 +++++
 fs/xfs/libxfs/xfs_types.c |    5 -
 fs/xfs/xfs_imeta_utils.c  |  198 ++++++++++++++++++++++
 fs/xfs/xfs_imeta_utils.h  |   24 +++
 fs/xfs/xfs_mount.c        |   28 +++
 fs/xfs/xfs_trace.c        |    1 
 fs/xfs/xfs_trace.h        |   87 +++++++++-
 9 files changed, 798 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h
 create mode 100644 fs/xfs/xfs_imeta_utils.c
 create mode 100644 fs/xfs/xfs_imeta_utils.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6f7b0683a46cd..29cf5a5f8104a 100644
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
@@ -80,6 +81,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_globals.o \
 				   xfs_health.o \
 				   xfs_icache.o \
+				   xfs_imeta_utils.o \
 				   xfs_ioctl.o \
 				   xfs_iomap.o \
 				   xfs_iops.o \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
new file mode 100644
index 0000000000000..717e67b3264cf
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -0,0 +1,411 @@
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_ialloc.h"
+
+/*
+ * Metadata File Management
+ * ========================
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
+	struct xfs_imeta_update		*upd,
+	umode_t				mode)
+{
+	struct xfs_icreate_args		args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+	};
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	int				error;
+
+	/* Files rooted in the superblock do not have parents. */
+	xfs_icreate_args_rootfile(&args, mp, mode, false);
+
+	/* Reject if the sb already points to some inode. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	if (*sb_inop != NULLFSINO)
+		return -EEXIST;
+
+	/* Create a new inode and set the sb pointer. */
+	error = xfs_dialloc(&upd->tp, 0, mode, &ino);
+	if (error)
+		return error;
+	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
+	if (error)
+		return error;
+	upd->ip_locked = true;
+
+	/*
+	 * If we ever need the ability to create rt metadata files on a
+	 * pre-metadir filesystem, we'll need to dqattach the child here.
+	 * Currently we assume that mkfs will create the files and quotacheck
+	 * will account for them.
+	 */
+
+	/* Update superblock pointer. */
+	*sb_inop = ino;
+	xfs_imeta_log_sb(upd->tp);
+
+	trace_xfs_imeta_sb_create(upd);
+	return 0;
+}
+
+/*
+ * Clear the given inode pointer from the superblock and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_sb_unlink(
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+
+	ASSERT(xfs_isilocked(upd->ip, XFS_ILOCK_EXCL));
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	/* Reject if the sb doesn't point to the inode that was passed in. */
+	if (*sb_inop != upd->ip->i_ino)
+		return -ENOENT;
+
+	trace_xfs_imeta_sb_unlink(upd);
+
+	*sb_inop = NULLFSINO;
+	xfs_imeta_log_sb(upd->tp);
+	return xfs_droplink(upd->tp, upd->ip);
+}
+
+/* Set the given inode pointer in the superblock. */
+STATIC int
+xfs_imeta_sb_link(
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+
+	ASSERT(xfs_isilocked(upd->ip, XFS_ILOCK_EXCL));
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (!sb_inop)
+		return -EINVAL;
+	if (*sb_inop != NULLFSINO)
+		return -EEXIST;
+
+	trace_xfs_imeta_sb_link(upd);
+
+	xfs_bumplink(upd->tp, upd->ip);
+	xfs_imeta_log_sb(upd->tp);
+
+	*sb_inop = upd->ip->i_ino;
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
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
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
+ * component) must already exist.
+ *
+ * The new metadata inode will be attached to the update structure @upd->ip,
+ * with the ILOCK held until the caller releases it.  @ipp is set to upd->ip
+ * as a convenience for callers.
+ *
+ * Callers must ensure that the root dquots are allocated, if applicable.
+ *
+ * NOTE: This function may return a new inode to the caller even if it returns
+ * a negative error code.  If an inode is passed back, the caller must finish
+ * setting up the inode before releasing it.
+ */
+int
+xfs_imeta_create(
+	struct xfs_imeta_update		*upd,
+	umode_t				mode,
+	struct xfs_inode		**ipp)
+{
+	int				error;
+
+	ASSERT(xfs_imeta_path_check(upd->path));
+
+	*ipp = NULL;
+
+	error = xfs_imeta_sb_create(upd, mode);
+	*ipp = upd->ip;
+	return error;
+}
+
+/*
+ * Unlink a metadata inode @upd->ip from the metadata directory given by @path.
+ * The path must already exist.
+ */
+int
+xfs_imeta_unlink(
+	struct xfs_imeta_update		*upd)
+{
+	ASSERT(xfs_imeta_path_check(upd->path));
+	ASSERT(xfs_imeta_verify(upd->mp, upd->ip->i_ino));
+
+	return xfs_imeta_sb_unlink(upd);
+}
+
+/*
+ * Link the metadata directory given by @path to the inode @upd->ip.
+ * The path (up to the final component) must already exist, but the final
+ * component must not already exist.
+ */
+int
+xfs_imeta_link(
+	struct xfs_imeta_update		*upd)
+{
+	ASSERT(xfs_imeta_path_check(upd->path));
+
+	return xfs_imeta_sb_link(upd);
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
+/*
+ * Ensure that the in-core superblock has all the values that it should.
+ * Caller should pass in an empty transaction to avoid livelocking on btree
+ * cycles.
+ */
+int
+xfs_imeta_mount(
+	struct xfs_trans	*tp)
+{
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
new file mode 100644
index 0000000000000..c1833b8b1c977
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
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
+	struct xfs_mount	*mp;
+	struct xfs_trans	*tp;
+
+	const struct xfs_imeta_path *path;
+
+	/* Metadata inode */
+	struct xfs_inode	*ip;
+
+	unsigned int		ip_locked:1;
+};
+
+/* Lookup keys for static metadata inodes. */
+extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
+extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
+extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+
+int xfs_imeta_lookup(struct xfs_trans *tp, const struct xfs_imeta_path *path,
+		xfs_ino_t *ino);
+
+int xfs_imeta_create(struct xfs_imeta_update *upd, umode_t mode,
+		struct xfs_inode **ipp);
+int xfs_imeta_unlink(struct xfs_imeta_update *upd);
+int xfs_imeta_link(struct xfs_imeta_update *upd);
+
+bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
+int xfs_imeta_mount(struct xfs_trans *tp);
+
+#endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index c299b16c9365f..72f7e050e600a 100644
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
diff --git a/fs/xfs/xfs_imeta_utils.c b/fs/xfs/xfs_imeta_utils.c
new file mode 100644
index 0000000000000..262422daa931f
--- /dev/null
+++ b/fs/xfs/xfs_imeta_utils.c
@@ -0,0 +1,198 @@
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
+#include "xfs_da_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_trans_space.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_quota.h"
+#include "xfs_imeta.h"
+#include "xfs_imeta_utils.h"
+#include "xfs_trace.h"
+
+/* Initialize a metadata update structure. */
+static inline int
+xfs_imeta_init(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_update		*upd)
+{
+	memset(upd, 0, sizeof(struct xfs_imeta_update));
+	upd->mp = mp;
+	upd->path = path;
+	return 0;
+}
+
+/*
+ * Unlock and release resources after committing (or cancelling) a metadata
+ * directory tree operation.  The caller retains its reference to @upd->ip
+ * and must release it explicitly.
+ */
+static inline void
+xfs_imeta_teardown(
+	struct xfs_imeta_update		*upd,
+	int				error)
+{
+	trace_xfs_imeta_teardown(upd, error);
+
+	if (upd->ip) {
+		if (upd->ip_locked)
+			xfs_iunlock(upd->ip, XFS_ILOCK_EXCL);
+		upd->ip_locked = false;
+	}
+}
+
+/*
+ * Begin the process of creating a metadata file by allocating transactions
+ * and taking whatever resources we're going to need.
+ */
+int
+xfs_imeta_start_create(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_update		*upd)
+{
+	int				error;
+
+	error = xfs_imeta_init(mp, path, upd);
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
+	trace_xfs_imeta_start_create(upd);
+	return 0;
+out_teardown:
+	xfs_imeta_teardown(upd, error);
+	return error;
+}
+
+/*
+ * Begin the process of linking a metadata file by allocating transactions
+ * and locking whatever resources we're going to need.
+ */
+static inline int
+xfs_imeta_start_dir_update(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_trans_res		*tr_resv,
+	unsigned int			resblks,
+	struct xfs_imeta_update		*upd)
+{
+	int				error;
+
+	error = xfs_imeta_init(mp, path, upd);
+	if (error)
+		return error;
+
+	upd->ip = ip;
+
+	error = xfs_trans_alloc_inode(upd->ip, tr_resv, resblks, 0, false,
+			&upd->tp);
+	if (error)
+		goto out_teardown;
+
+	upd->ip_locked = true;
+	return 0;
+out_teardown:
+	xfs_imeta_teardown(upd, error);
+	return error;
+}
+
+/*
+ * Begin the process of linking a metadata file by allocating transactions
+ * and locking whatever resources we're going to need.
+ */
+int
+xfs_imeta_start_link(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	int				error;
+
+	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_link,
+			xfs_link_space_res(mp, MAXNAMELEN), upd);
+	if (error)
+		return error;
+
+	trace_xfs_imeta_start_link(upd);
+	return 0;
+}
+
+/*
+ * Begin the process of unlinking a metadata file by allocating transactions
+ * and locking whatever resources we're going to need.
+ */
+int
+xfs_imeta_start_unlink(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	int				error;
+
+	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_remove,
+			xfs_remove_space_res(mp, MAXNAMELEN), upd);
+	if (error)
+		return error;
+
+	trace_xfs_imeta_start_unlink(upd);
+	return 0;
+}
+
+/* Commit a metadir update and unlock/drop all resources. */
+int
+xfs_imeta_commit_update(
+	struct xfs_imeta_update		*upd)
+{
+	int				error;
+
+	trace_xfs_imeta_update_commit(upd);
+
+	error = xfs_trans_commit(upd->tp);
+	upd->tp = NULL;
+
+	xfs_imeta_teardown(upd, error);
+	return error;
+}
+
+/* Cancel a metadir update and unlock/drop all resources. */
+void
+xfs_imeta_cancel_update(
+	struct xfs_imeta_update		*upd,
+	int				error)
+{
+	trace_xfs_imeta_update_cancel(upd);
+
+	xfs_trans_cancel(upd->tp);
+	upd->tp = NULL;
+
+	xfs_imeta_teardown(upd, error);
+}
diff --git a/fs/xfs/xfs_imeta_utils.h b/fs/xfs/xfs_imeta_utils.h
new file mode 100644
index 0000000000000..0235f7048ff1d
--- /dev/null
+++ b/fs/xfs/xfs_imeta_utils.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_IMETA_UTILS_H__
+#define __XFS_IMETA_UTILS_H__
+
+int xfs_imeta_start_create(struct xfs_mount *mp,
+		const struct xfs_imeta_path *path,
+		struct xfs_imeta_update *upd);
+
+int xfs_imeta_start_link(struct xfs_mount *mp,
+		const struct xfs_imeta_path *path,
+		struct xfs_inode *ip, struct xfs_imeta_update *upd);
+
+int xfs_imeta_start_unlink(struct xfs_mount *mp,
+		const struct xfs_imeta_path *path,
+		struct xfs_inode *ip, struct xfs_imeta_update *upd);
+
+int xfs_imeta_commit_update(struct xfs_imeta_update *upd);
+void xfs_imeta_cancel_update(struct xfs_imeta_update *upd, int error);
+
+#endif /* __XFS_IMETA_UTILS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 85c7ca0b211b1..ab11fe9a4b4ab 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_imeta.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -610,6 +611,29 @@ xfs_mount_setup_inode_geom(
 	xfs_ialloc_setup_geometry(mp);
 }
 
+STATIC int
+xfs_mount_setup_metadir(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_imeta_mount(tp);
+	if (error) {
+		xfs_warn(mp, "Failed to load metadata inodes, error %d",
+				error);
+		goto err_cancel;
+	}
+
+err_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 /* Compute maximum possible height for per-AG btree types for this fs. */
 static inline void
 xfs_agbtree_compute_maxlevels(
@@ -846,6 +870,10 @@ xfs_mountfs(
 		mp->m_features |= XFS_FEAT_ATTR2;
 	}
 
+	error = xfs_mount_setup_metadir(mp);
+	if (error)
+		goto out_log_dealloc;
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 7ccb7b3473943..453cf7ffdea03 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -43,6 +43,7 @@
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
 #include "xfs_parent.h"
+#include "xfs_imeta.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 070c76f443737..bedfed2ef3e60 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -86,6 +86,7 @@ struct xfs_swapext_req;
 struct xfs_getparents;
 struct xfs_parent_name_irec;
 struct xfs_attrlist_cursor_kern;
+struct xfs_imeta_update;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -153,7 +154,7 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
-TRACE_EVENT(xlog_intent_recovery_failed,
+DECLARE_EVENT_CLASS(xfs_fs_error_class,
 	TP_PROTO(struct xfs_mount *mp, int error, void *function),
 	TP_ARGS(mp, error, function),
 	TP_STRUCT__entry(
@@ -170,6 +171,11 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->error, __entry->function)
 );
+#define DEFINE_FS_ERROR_EVENT(name)	\
+DEFINE_EVENT(xfs_fs_error_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, int error, void *function), \
+	TP_ARGS(mp, error, function))
+DEFINE_FS_ERROR_EVENT(xlog_intent_recovery_failed);
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip),
@@ -5054,6 +5060,85 @@ TRACE_EVENT(xfs_getparent_pointers,
 		  __entry->offset)
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
+
+DECLARE_EVENT_CLASS(xfs_imeta_update_class,
+	TP_PROTO(const struct xfs_imeta_update *upd),
+	TP_ARGS(upd),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = upd->mp->m_super->s_dev;
+		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+	),
+	TP_printk("dev %d:%d ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+)
+
+#define DEFINE_IMETA_UPDATE_EVENT(name) \
+DEFINE_EVENT(xfs_imeta_update_class, name, \
+	TP_PROTO(const struct xfs_imeta_update *upd), \
+	TP_ARGS(upd))
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_start_create);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_start_link);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_start_unlink);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_update_commit);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_update_cancel);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_sb_create);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_sb_unlink);
+DEFINE_IMETA_UPDATE_EVENT(xfs_imeta_sb_link);
+
+DECLARE_EVENT_CLASS(xfs_imeta_update_error_class,
+	TP_PROTO(const struct xfs_imeta_update *upd, int error),
+	TP_ARGS(upd, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = upd->mp->m_super->s_dev;
+		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d ino 0x%llx error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->error)
+)
+
+#define DEFINE_IMETA_UPDATE_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_imeta_update_error_class, name, \
+	TP_PROTO(const struct xfs_imeta_update *upd, int error), \
+	TP_ARGS(upd, error))
+DEFINE_IMETA_UPDATE_ERROR_EVENT(xfs_imeta_teardown);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

