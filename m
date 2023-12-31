Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE73C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dA2ZyRxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE41BC433C8;
	Sun, 31 Dec 2023 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065407;
	bh=pUSOy3Vw5db8rp2xHfDpNqT5KqXasGa2yJM47klWTz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dA2ZyRxOux/Q5R0Esmgb/QwqxowN+Wsev66CazgZCh11LZ0fDH03AKuipU0dgQK97
	 hFZgPXC8M9jRnsWJVmdYx5vhn2YanIl0twznSxPOq4N3R/SG25yQQL6pxCip8Ih69r
	 G7owCVMtqxjMf+Tu/c8zgwG6+Ivu/z3p5JxUDn976JzOxnUwT76PDKTq7CN680piBu
	 cpW1gOrCLVqPIzL347AFAbfySx5GhHXrEPr4HE0C5mEn1//js9ZWa2SC0YC0n7Xw4F
	 9pF9SeQPTKXVyugx9tVVxfapB1YeMd1RWoqNamzX6LuklKO2LMOQ/UX4cU+WqErxjU
	 QeiR3Ro5FFPrw==
Date: Sun, 31 Dec 2023 15:30:06 -0800
Subject: [PATCH 02/58] xfs: create imeta abstractions to get and set metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009974.1809361.11171450188551849364.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 include/libxfs.h         |    2 
 include/xfs_trace.h      |   11 +
 libxfs/Makefile          |    4 
 libxfs/imeta_utils.c     |  190 +++++++++++++++++++++
 libxfs/imeta_utils.h     |   26 +++
 libxfs/init.c            |   30 +++
 libxfs/libxfs_api_defs.h |   15 ++
 libxfs/libxfs_priv.h     |    2 
 libxfs/xfs_imeta.c       |  410 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |   46 +++++
 libxfs/xfs_types.c       |    5 -
 mkfs/xfs_mkfs.c          |    2 
 12 files changed, 739 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/imeta_utils.c
 create mode 100644 libxfs/imeta_utils.h
 create mode 100644 libxfs/xfs_imeta.c
 create mode 100644 libxfs/xfs_imeta.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 0d60b9f9f51..7fa061d5e1b 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -89,6 +89,8 @@ struct iomap;
 #include "xfs_symlink_remote.h"
 #include "xfs_ag_resv.h"
 #include "xfs_parent.h"
+#include "xfs_imeta.h"
+#include "imeta_utils.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 7dcf88b7900..dd6011af90e 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -360,6 +360,17 @@
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
 
+#define trace_xfs_imeta_teardown(...)		((void) 0)
+#define trace_xfs_imeta_sb_create(...)		((void) 0)
+#define trace_xfs_imeta_sb_link(...)		((void) 0)
+#define trace_xfs_imeta_sb_lookup(...)		((void) 0)
+#define trace_xfs_imeta_sb_unlink(...)		((void) 0)
+#define trace_xfs_imeta_start_create(...)	((void) 0)
+#define trace_xfs_imeta_start_link(...)		((void) 0)
+#define trace_xfs_imeta_start_unlink(...)	((void) 0)
+#define trace_xfs_imeta_update_cancel(...)	((void) 0)
+#define trace_xfs_imeta_update_commit(...)	((void) 0)
+
 #define trace_xfs_iunlink_update_bucket(...)	((void) 0)
 #define trace_xfs_iunlink_update_dinode(...)	((void) 0)
 #define trace_xfs_iunlink(...)			((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 26781ceb913..258ce473200 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -24,6 +24,7 @@ HFILES = \
 	defer_item.h \
 	libxfs_io.h \
 	libxfs_api_defs.h \
+	imeta_utils.h \
 	init.h \
 	iunlink.h \
 	libxfs_priv.h \
@@ -50,6 +51,7 @@ HFILES = \
 	xfs_errortag.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
+	xfs_imeta.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_util.h \
@@ -69,6 +71,7 @@ HFILES = \
 
 CFILES = cache.c \
 	defer_item.c \
+	imeta_utils.c \
 	init.c \
 	inode.c \
 	iunlink.c \
@@ -104,6 +107,7 @@ CFILES = cache.c \
 	xfs_dquot_buf.c \
 	xfs_ialloc.c \
 	xfs_iext_tree.c \
+	xfs_imeta.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
 	xfs_inode_util.c \
diff --git a/libxfs/imeta_utils.c b/libxfs/imeta_utils.c
new file mode 100644
index 00000000000..4610c2f49c8
--- /dev/null
+++ b/libxfs/imeta_utils.c
@@ -0,0 +1,190 @@
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "imeta_utils.h"
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
diff --git a/libxfs/imeta_utils.h b/libxfs/imeta_utils.h
new file mode 100644
index 00000000000..a2afc0f37ac
--- /dev/null
+++ b/libxfs/imeta_utils.h
@@ -0,0 +1,26 @@
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
+
+
diff --git a/libxfs/init.c b/libxfs/init.c
index 397ce088d3a..c199aeea45e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -669,6 +669,34 @@ libxfs_compute_all_maxlevels(
 
 }
 
+/* Mount the metadata files under the metadata directory tree. */
+STATIC void
+libxfs_mountfs_imeta(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	/* Ignore filesystems that are under construction. */
+	if (mp->m_sb.sb_inprogress)
+		return;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return;
+
+	error = -xfs_imeta_mount(tp);
+	if (error) {
+		fprintf(stderr,
+ _("%s: Failed to load metadata inodes, error %d\n"),
+			progname, error);
+		goto err_cancel;
+	}
+
+err_cancel:
+	libxfs_trans_cancel(tp);
+}
+
 /*
  * precalculate the low space thresholds for dynamic speculative preallocation.
  */
@@ -843,6 +871,8 @@ libxfs_mount(
 	}
 	xfs_set_perag_data_loaded(mp);
 
+	libxfs_mountfs_imeta(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 3ac0afec41f..9fd53415b47 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -162,6 +162,8 @@
 #define xfs_iallocbt_calc_size		libxfs_iallocbt_calc_size
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
+#define xfs_icreate			libxfs_icreate
+#define xfs_icreate_args_rootfile	libxfs_icreate_args_rootfile
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_first			libxfs_iext_first
@@ -170,6 +172,18 @@
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
 #define xfs_imap_to_bp			libxfs_imap_to_bp
+
+#define xfs_imeta_cancel_update		libxfs_imeta_cancel_update
+#define xfs_imeta_commit_update		libxfs_imeta_commit_update
+#define xfs_imeta_create		libxfs_imeta_create
+#define xfs_imeta_link			libxfs_imeta_link
+#define xfs_imeta_lookup		libxfs_imeta_lookup
+#define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_start_create		libxfs_imeta_start_create
+#define xfs_imeta_start_link		libxfs_imeta_start_link
+#define xfs_imeta_start_unlink		libxfs_imeta_start_unlink
+#define xfs_imeta_unlink		libxfs_imeta_unlink
+
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
@@ -188,6 +202,7 @@
 
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
+#define xfs_is_meta_ino			libxfs_is_meta_ino
 #define xfs_iunlink			libxfs_iunlink
 #define xfs_link_space_res		libxfs_link_space_res
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 17e62c9fbb7..9bca059776d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -484,6 +484,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 static inline int retzero(void) { return 0; }
 #define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	retzero()
 #define xfs_quota_unreserve_blkres(i,b) 		retzero()
+#define xfs_qm_dqattach(i)				(0)
+#define xfs_qm_dqattach_locked(ip, alloc)		(0)
 
 #define xfs_quota_reserve_blkres(i,b)		(0)
 #define xfs_qm_dqattach(i)			(0)
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
new file mode 100644
index 00000000000..b89843926fe
--- /dev/null
+++ b/libxfs/xfs_imeta.c
@@ -0,0 +1,410 @@
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
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
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
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
new file mode 100644
index 00000000000..c1833b8b1c9
--- /dev/null
+++ b/libxfs/xfs_imeta.h
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
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 74ab1965a8f..88720b297d7 100644
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
index 482275e0e0d..15be7e0fb60 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3878,6 +3878,7 @@ start_superblock_setup(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_magicnum = XFS_SB_MAGIC;
 	sbp->sb_sectsize = (uint16_t)cfg->sectorsize;
 	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
@@ -3960,7 +3961,6 @@ finish_superblock_setup(
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
 	sbp->sb_rextslog = libxfs_compute_rextslog(cfg->rtextents);
-	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_imax_pct = cfg->imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;

