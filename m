Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25624 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:34 -0400
Subject: [PATCH 17/22] xfs_scrub: schedule and manage repairs to the
 filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:27 -0700
Message-ID: <150180536792.18784.2277615673935278149.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_scrub to remember scrub requests that failed (or indicated
that optimization is a possibility) as repair requests that can be
deferred until later.  Add a new repair phase that deals with the
repair requests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    4 +
 scrub/ioctl.c  |  101 +++++++++++++++------
 scrub/ioctl.h  |   27 +++--
 scrub/phase1.c |    8 ++
 scrub/phase2.c |   53 ++++++++++-
 scrub/phase3.c |   44 +++++++--
 scrub/phase4.c |   91 +++++++++++++++++++
 scrub/repair.c |  275 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/repair.h |   52 +++++++++++
 scrub/scrub.c  |   47 +++++++++-
 scrub/scrub.h  |    1 
 scrub/xfs.c    |   30 ++++++
 scrub/xfs.h    |    5 +
 13 files changed, 687 insertions(+), 51 deletions(-)
 create mode 100644 scrub/phase4.c
 create mode 100644 scrub/repair.c
 create mode 100644 scrub/repair.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 461df83..a17dfa3 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -24,11 +24,13 @@ counter.h \
 disk.h \
 ioctl.h \
 read_verify.h \
+repair.h \
 scrub.h \
 vfs.h \
 xfs.h
 
 CFILES = \
+../libxfs/list_sort.c \
 ../repair/avl64.c \
 ../repair/threads.c \
 bitmap.c \
@@ -39,10 +41,12 @@ ioctl.c \
 phase1.c \
 phase2.c \
 phase3.c \
+phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
 read_verify.c \
+repair.c \
 scrub.c \
 vfs.c \
 xfs.c
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
index 3ed9758..31d2fd8 100644
--- a/scrub/ioctl.c
+++ b/scrub/ioctl.c
@@ -28,6 +28,7 @@
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
+#include "repair.h"
 
 #define FSMAP_NR		65536
 #define BMAP_NR			2048
@@ -741,12 +742,47 @@ _("Optimizations of %s are possible."), scrubbers[i].name);
 	}
 }
 
+/* Save a scrub context for later repairs. */
+bool
+xfs_scrub_save_repair(
+	struct scrub_ctx		*ctx,
+	struct xfs_repair_list		*rl,
+	struct xfs_scrub_metadata	*meta)
+{
+	struct repair_item		*ri;
+
+	/* Schedule this item for later repairs. */
+	ri = malloc(sizeof(struct repair_item));
+	if (!ri) {
+		str_errno(ctx, _("repair list"));
+		return false;
+	}
+	ri->type = meta->sm_type;
+	ri->flags = meta->sm_flags;
+	switch (scrubbers[meta->sm_type].type) {
+	case ST_AGHEADER:
+	case ST_PERAG:
+		ri->agno = meta->sm_agno;
+		break;
+	case ST_INODE:
+		ri->ino = meta->sm_ino;
+		ri->gen = meta->sm_gen;
+		break;
+	default:
+		break;
+	}
+
+	xfs_repair_list_add(rl, ri);
+	return true;
+}
+
 /* Scrub metadata, saving corruption reports for later. */
 static bool
 xfs_scrub_metadata(
 	struct scrub_ctx		*ctx,
 	enum scrub_type			scrub_type,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_repair_list		*rl)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	const struct scrub_descr	*sc;
@@ -769,6 +805,9 @@ xfs_scrub_metadata(
 		case CHECK_ABORT:
 			return false;
 		case CHECK_REPAIR:
+			if (!xfs_scrub_save_repair(ctx, rl, &meta))
+				return false;
+			/* fall through */
 		case CHECK_DONE:
 			continue;
 		case CHECK_RETRY:
@@ -784,26 +823,29 @@ xfs_scrub_metadata(
 bool
 xfs_scrub_ag_headers(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_repair_list		*rl)
 {
-	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno);
+	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno, rl);
 }
 
 /* Scrub each AG's metadata btrees. */
 bool
 xfs_scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_repair_list		*rl)
 {
-	return xfs_scrub_metadata(ctx, ST_PERAG, agno);
+	return xfs_scrub_metadata(ctx, ST_PERAG, agno, rl);
 }
 
 /* Scrub whole-FS metadata btrees. */
 bool
 xfs_scrub_fs_metadata(
-	struct scrub_ctx		*ctx)
+	struct scrub_ctx		*ctx,
+	struct xfs_repair_list		*rl)
 {
-	return xfs_scrub_metadata(ctx, ST_FS, 0);
+	return xfs_scrub_metadata(ctx, ST_FS, 0, rl);
 }
 
 /* Scrub inode metadata. */
@@ -813,7 +855,8 @@ __xfs_scrub_file(
 	uint64_t			ino,
 	uint32_t			gen,
 	int				fd,
-	unsigned int			type)
+	unsigned int			type,
+	struct xfs_repair_list		*rl)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	enum check_outcome		fix;
@@ -832,7 +875,7 @@ __xfs_scrub_file(
 	if (fix == CHECK_DONE)
 		return true;
 
-	return true;
+	return xfs_scrub_save_repair(ctx, rl, &meta);
 }
 
 bool
@@ -840,9 +883,10 @@ xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE, rl);
 }
 
 bool
@@ -850,9 +894,10 @@ xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD, rl);
 }
 
 bool
@@ -860,9 +905,10 @@ xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA, rl);
 }
 
 bool
@@ -870,9 +916,10 @@ xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC, rl);
 }
 
 bool
@@ -880,9 +927,10 @@ xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR, rl);
 }
 
 bool
@@ -890,9 +938,10 @@ xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR, rl);
 }
 
 bool
@@ -900,9 +949,10 @@ xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK, rl);
 }
 
 bool
@@ -910,9 +960,10 @@ xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT, rl);
 }
 
 /* Repair some metadata. */
diff --git a/scrub/ioctl.h b/scrub/ioctl.h
index 4042f79..ab4044a 100644
--- a/scrub/ioctl.h
+++ b/scrub/ioctl.h
@@ -73,9 +73,14 @@ struct repair_item {
 };
 
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
-bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno);
-bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno);
-bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx);
+bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_repair_list *repair_list);
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_repair_list *repair_list);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+		struct xfs_repair_list *repair_list);
+enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
+		struct repair_item *ri, unsigned int flags);
 
 /* Only perform repairs; leave optimization-only actions for later. */
 #define XRM_REPAIR_ONLY		(1 << 0)
@@ -96,20 +101,20 @@ bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
 bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_repair_list *repair_list);
 
 #endif /* XFS_SCRUB_IOCTL_H_ */
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6c0a31d..d5b985d 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -30,6 +30,7 @@
 #include "common.h"
 #include "ioctl.h"
 #include "xfs_fs.h"
+#include "repair.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -38,6 +39,7 @@ bool
 xfs_cleanup(
 	struct scrub_ctx	*ctx)
 {
+	xfs_repair_lists_free(&ctx->repair_lists);
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
 	disk_close(&ctx->rtdev);
@@ -81,6 +83,11 @@ _("Does not appear to be an XFS filesystem!"));
 		goto err;
 	}
 
+	if (!xfs_repair_lists_alloc(ctx->geo.agcount, &ctx->repair_lists)) {
+		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
+		goto err;
+	}
+
 	ctx->agblklog = libxfs_log2_roundup(ctx->geo.agblocks);
 	ctx->blocklog = libxfs_highbit32(ctx->geo.blocksize);
 	ctx->inodelog = libxfs_highbit32(ctx->geo.inodesize);
@@ -181,5 +188,6 @@ _("Unable to find realtime device path."));
 
 	return true;
 err:
+	/* Everything will get cleaned up by xfs_cleanup */
 	return false;
 }
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 88136a3..8bf3ad6 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -30,6 +30,8 @@
 #include "common.h"
 #include "ioctl.h"
 #include "xfs_fs.h"
+#include "xfs.h"
+#include "repair.h"
 
 /* Phase 2: Check internal metadata. */
 
@@ -42,24 +44,65 @@ xfs_scan_ag_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
 	bool				*pmoveon = arg;
+	struct xfs_repair_list		repairs;
+	struct xfs_repair_list		repair_now;
+	unsigned long long		broken_primaries;
+	unsigned long long		broken_secondaries;
 	bool				moveon;
 	char				descr[DESCR_BUFSZ];
 
+	xfs_repair_list_init(&repairs);
+	xfs_repair_list_init(&repair_now);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
 
 	/*
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	moveon = xfs_scrub_ag_headers(ctx, agno);
+	moveon = xfs_scrub_ag_headers(ctx, agno, &repairs);
+	if (!moveon)
+		goto err;
+
+	/* Repair header damage. */
+	moveon = xfs_quick_repair(ctx, agno, &repairs);
 	if (!moveon)
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	moveon = xfs_scrub_ag_metadata(ctx, agno);
+	moveon = xfs_scrub_ag_metadata(ctx, agno, &repairs);
 	if (!moveon)
 		goto err;
 
+	/*
+	 * Figure out if we need to perform early fixing.  The only
+	 * reason we need to do this is if the inobt is broken, which
+	 * prevents phase 3 (inode scan) from running.  We can rebuild
+	 * the inobt from rmapbt data, but if the rmapbt is broken even
+	 * at this early phase then we are sunk.
+	 */
+	broken_secondaries = 0;
+	broken_primaries = 0;
+	xfs_repair_find_mustfix(&repairs, &repair_now,
+			&broken_primaries, &broken_secondaries);
+	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		if (broken_primaries)
+			str_warn(ctx, descr,
+_("Corrupt primary and secondary block mapping metadata."));
+		else
+			str_warn(ctx, descr,
+_("Corrupt secondary block mapping metadata."));
+		str_warn(ctx, descr,
+_("Filesystem might not be repairable."));
+	}
+
+	/* Repair (inode) btree damage. */
+	moveon = xfs_quick_repair(ctx, agno, &repair_now);
+	if (!moveon)
+		goto err;
+
+	/* Everything else gets fixed during phase 4. */
+	xfs_defer_repairs(ctx, agno, &repairs);
+
 	return;
 err:
 	*pmoveon = false;
@@ -74,11 +117,15 @@ xfs_scan_fs_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
 	bool				*pmoveon = arg;
+	struct xfs_repair_list		repairs;
 	bool				moveon;
 
-	moveon = xfs_scrub_fs_metadata(ctx);
+	xfs_repair_list_init(&repairs);
+	moveon = xfs_scrub_fs_metadata(ctx, &repairs);
 	if (!moveon)
 		*pmoveon = false;
+
+	xfs_defer_repairs(ctx, agno, &repairs);
 }
 
 /* Scan all filesystem metadata. */
diff --git a/scrub/phase3.c b/scrub/phase3.c
index b920995..3cfbea4 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -31,6 +31,7 @@
 #include "ioctl.h"
 #include "xfs_fs.h"
 #include "xfs.h"
+#include "repair.h"
 
 /* Phase 3: Scan all inodes. */
 
@@ -43,13 +44,14 @@ static bool
 xfs_scrub_fd(
 	struct scrub_ctx	*ctx,
 	bool			(*fn)(struct scrub_ctx *, uint64_t,
-				      uint32_t, int),
+				      uint32_t, int, struct xfs_repair_list *),
 	struct xfs_bstat	*bs,
-	int			fd)
+	int			fd,
+	struct xfs_repair_list	*rl)
 {
 	if (fd < 0)
 		fd = ctx->mnt_fd;
-	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd);
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd, rl);
 }
 
 /* Verify the contents, xattrs, and extent maps of an inode. */
@@ -60,6 +62,7 @@ xfs_scrub_inode(
 	struct xfs_bstat	*bstat,
 	void			*arg)
 {
+	struct xfs_repair_list	repairs;
 	char			descr[DESCR_BUFSZ];
 	bool			moveon = true;
 	xfs_agnumber_t		agno;
@@ -67,6 +70,7 @@ xfs_scrub_inode(
 	int			fd = -1;
 	int			error = 0;
 
+	xfs_repair_list_init(&repairs);
 	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
 	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %llu (%u/%u)"), bstat->bs_ino,
@@ -85,43 +89,61 @@ xfs_scrub_inode(
 	}
 
 	/* Scrub the inode. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_quick_repair(ctx, agno, &repairs);
 	if (!moveon)
 		goto out;
 
 	/* Scrub all block mappings. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd,
+			&repairs);
 	if (!moveon)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd,
+			&repairs);
 	if (!moveon)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_quick_repair(ctx, agno, &repairs);
 	if (!moveon)
 		goto out;
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
 		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
-				bstat->bs_gen, ctx->mnt_fd);
+				bstat->bs_gen, ctx->mnt_fd, &repairs);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd);
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd, &repairs);
 	}
 	if (!moveon)
 		goto out;
 
 	/* Check all the extended attributes. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd, &repairs);
 	if (!moveon)
 		goto out;
 
 	/* Check parent pointers. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, fd);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, fd, &repairs);
+	if (!moveon)
+		goto out;
+
+	/* Try to repair the file while it's open. */
+	moveon = xfs_quick_repair(ctx, agno, &repairs);
 	if (!moveon)
 		goto out;
 
 out:
+	xfs_defer_repairs(ctx, agno, &repairs);
 	if (fd >= 0)
 		close(fd);
 	if (error)
diff --git a/scrub/phase4.c b/scrub/phase4.c
new file mode 100644
index 0000000..7c2e0fb
--- /dev/null
+++ b/scrub/phase4.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include "disk.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "read_verify.h"
+#include "bitmap.h"
+#include "vfs.h"
+#include "scrub.h"
+#include "common.h"
+#include "ioctl.h"
+#include "xfs_fs.h"
+#include "repair.h"
+
+/* Phase 4: Repair filesystem. */
+
+/* Fix all the problems in our per-AG list. */
+static void
+xfs_repair_ag(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*priv)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
+	bool				*moveon = priv;
+	struct xfs_repair_list		*repairs;
+	size_t				unfixed;
+	size_t				new_unfixed;
+	unsigned int			flags = 0;
+
+	repairs = &ctx->repair_lists[agno];
+	unfixed = xfs_repair_list_length(repairs);
+
+	/* Repair anything broken until we fail to make progress. */
+	do {
+		*moveon = xfs_repair_list_now(ctx, ctx->mnt_fd, repairs, flags);
+		if (!*moveon)
+			return;
+		new_unfixed = xfs_repair_list_length(repairs);
+		if (new_unfixed == unfixed)
+			break;
+		unfixed = new_unfixed;
+	} while (unfixed > 0);
+
+	/* Try once more, but this time complain if we can't fix things. */
+	flags |= XRML_NOFIX_COMPLAIN;
+	*moveon = xfs_repair_list_now(ctx, ctx->mnt_fd, repairs, flags);
+}
+
+/* Fix everything that needs fixing. */
+bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct work_queue		wq;
+	xfs_agnumber_t			agno;
+	bool				moveon = true;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+		if (xfs_repair_list_length(&ctx->repair_lists[agno]) > 0)
+			queue_work(&wq, xfs_repair_ag, agno, &moveon);
+		if (!moveon)
+			break;
+	}
+	destroy_work_queue(&wq);
+
+	return moveon;
+}
diff --git a/scrub/repair.c b/scrub/repair.c
new file mode 100644
index 0000000..53706c3
--- /dev/null
+++ b/scrub/repair.c
@@ -0,0 +1,275 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <stdio.h>
+#include <mntent.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/statvfs.h>
+#include <sys/vfs.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include "../repair/threads.h"
+#include "disk.h"
+#include "path.h"
+#include "read_verify.h"
+#include "scrub.h"
+#include "common.h"
+#include "ioctl.h"
+#include "repair.h"
+
+/*
+ * Prioritize repair items in order of how long we can wait.
+ * 0 = do it now, 10000 = do it later.
+ *
+ * To minimize the amount of repair work, we want to prioritize metadata
+ * objects by perceived corruptness.  If CORRUPT is set, the fields are
+ * just plain bad; try fixing that first.  Otherwise if XCORRUPT is set,
+ * the fields could be bad, but the xref data could also be bad; we'll
+ * try fixing that next.  Finally, if XFAIL is set, some other metadata
+ * structure failed validation during xref, so we'll recheck this
+ * metadata last since it was probably fine.
+ *
+ * For metadata that lie in the critical path of checking other metadata
+ * (superblock, AG{F,I,FL}, inobt) we scrub and fix those things before
+ * we even get to handling their dependencies, so things should progress
+ * in order.
+ */
+
+/* Sort repair items in severity order. */
+static int
+PRIO(
+	struct repair_item	*ri,
+	int			order)
+{
+	if (ri->flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return order;
+	else if (ri->flags & XFS_SCRUB_OFLAG_XCORRUPT)
+		return 100 + order;
+	else if (ri->flags & XFS_SCRUB_OFLAG_XFAIL)
+		return 200 + order;
+	else if (ri->flags & XFS_SCRUB_OFLAG_PREEN)
+		return 300 + order;
+	abort();
+}
+
+/* Sort the repair items in dependency order. */
+static int
+xfs_repair_item_priority(
+	struct repair_item	*ri)
+{
+	switch (ri->type) {
+	case XFS_SCRUB_TYPE_SB:
+	case XFS_SCRUB_TYPE_AGF:
+	case XFS_SCRUB_TYPE_AGFL:
+	case XFS_SCRUB_TYPE_AGI:
+	case XFS_SCRUB_TYPE_BNOBT:
+	case XFS_SCRUB_TYPE_CNTBT:
+	case XFS_SCRUB_TYPE_INOBT:
+	case XFS_SCRUB_TYPE_FINOBT:
+	case XFS_SCRUB_TYPE_REFCNTBT:
+	case XFS_SCRUB_TYPE_RMAPBT:
+	case XFS_SCRUB_TYPE_INODE:
+	case XFS_SCRUB_TYPE_BMBTD:
+	case XFS_SCRUB_TYPE_BMBTA:
+	case XFS_SCRUB_TYPE_BMBTC:
+		return PRIO(ri, ri->type - 1);
+	case XFS_SCRUB_TYPE_DIR:
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_SYMLINK:
+	case XFS_SCRUB_TYPE_PARENT:
+		return PRIO(ri, XFS_SCRUB_TYPE_DIR);
+	case XFS_SCRUB_TYPE_RTBITMAP:
+	case XFS_SCRUB_TYPE_RTSUM:
+		return PRIO(ri, XFS_SCRUB_TYPE_RTBITMAP);
+	case XFS_SCRUB_TYPE_UQUOTA:
+	case XFS_SCRUB_TYPE_GQUOTA:
+	case XFS_SCRUB_TYPE_PQUOTA:
+		return PRIO(ri, XFS_SCRUB_TYPE_UQUOTA);
+	}
+	abort();
+}
+
+/* Make sure that btrees get repaired before headers. */
+static int
+xfs_repair_item_compare(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct repair_item		*ra;
+	struct repair_item		*rb;
+
+	ra = container_of(a, struct repair_item, list);
+	rb = container_of(b, struct repair_item, list);
+
+	return xfs_repair_item_priority(ra) - xfs_repair_item_priority(rb);
+}
+
+/*
+ * Figure out which AG metadata must be fixed before we can move on
+ * to the inode scan.
+ */
+void
+xfs_repair_find_mustfix(
+	struct xfs_repair_list		*repairs,
+	struct xfs_repair_list		*repair_now,
+	unsigned long long		*broken_primaries,
+	unsigned long long		*broken_secondaries)
+{
+	struct repair_item		*n;
+	struct repair_item		*ri;
+
+	list_for_each_entry_safe(ri, n, &repairs->list, list) {
+		switch (ri->type) {
+		case XFS_SCRUB_TYPE_RMAPBT:
+			(*broken_secondaries)++;
+			break;
+		case XFS_SCRUB_TYPE_FINOBT:
+		case XFS_SCRUB_TYPE_INOBT:
+			repairs->nr--;
+			list_del(&ri->list);
+			list_add_tail(&ri->list, &repair_now->list);
+			repair_now->nr++;
+			/* fall through */
+		case XFS_SCRUB_TYPE_BNOBT:
+		case XFS_SCRUB_TYPE_CNTBT:
+		case XFS_SCRUB_TYPE_REFCNTBT:
+			(*broken_primaries)++;
+			break;
+		default:
+			abort();
+			break;
+		}
+	}
+}
+
+/* Allocate a certain number of repair lists for the scrub context. */
+bool
+xfs_repair_lists_alloc(
+	size_t				nr,
+	struct xfs_repair_list		**listsp)
+{
+	struct xfs_repair_list		*lists;
+	xfs_agnumber_t			agno;
+
+	lists = calloc(nr, sizeof(struct xfs_repair_list));
+	if (!lists)
+		return false;
+
+	for (agno = 0; agno < nr; agno++)
+		xfs_repair_list_init(&lists[agno]);
+	*listsp = lists;
+
+	return true;
+}
+
+/* Free the repair lists. */
+void
+xfs_repair_lists_free(
+	struct xfs_repair_list		**listsp)
+{
+	free(*listsp);
+	*listsp = NULL;
+}
+
+/* Initialize repair list */
+void
+xfs_repair_list_init(
+	struct xfs_repair_list		*rl)
+{
+	INIT_LIST_HEAD(&rl->list);
+	rl->nr = 0;
+	rl->sorted = false;
+}
+
+/* Number of repairs in this list. */
+size_t
+xfs_repair_list_length(
+	struct xfs_repair_list		*rl)
+{
+	return rl->nr;
+};
+
+/* Add to the list of repairs. */
+void
+xfs_repair_list_add(
+	struct xfs_repair_list		*rl,
+	struct repair_item		*ri)
+{
+	list_add_tail(&ri->list, &rl->list);
+	rl->nr++;
+	rl->sorted = false;
+}
+
+/* Splice two repair lists. */
+void
+xfs_repair_list_splice(
+	struct xfs_repair_list		*dest,
+	struct xfs_repair_list		*src)
+{
+	if (src->nr == 0)
+		return;
+
+	list_splice_tail_init(&src->list, &dest->list);
+	dest->nr += src->nr;
+	src->nr = 0;
+	dest->sorted = false;
+}
+
+/* Repair everything on this list. */
+bool
+xfs_repair_list_now(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct xfs_repair_list		*rl,
+	unsigned int			repair_flags)
+{
+	struct repair_item		*ri;
+	struct repair_item		*n;
+	enum check_outcome		fix;
+
+	if (!rl->sorted) {
+		list_sort(NULL, &rl->list, xfs_repair_item_compare);
+		rl->sorted = true;
+	}
+
+	list_for_each_entry_safe(ri, n, &rl->list, list) {
+		fix = xfs_repair_metadata(ctx, fd, ri, repair_flags);
+		switch (fix) {
+		case CHECK_DONE:
+			rl->nr--;
+			list_del(&ri->list);
+			free(ri);
+			continue;
+		case CHECK_ABORT:
+			return false;
+		case CHECK_RETRY:
+			continue;
+		case CHECK_REPAIR:
+			abort();
+		}
+	}
+
+	return !xfs_scrub_excessive_errors(ctx);
+}
diff --git a/scrub/repair.h b/scrub/repair.h
new file mode 100644
index 0000000..3142838
--- /dev/null
+++ b/scrub/repair.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef XFS_SCRUB_REPAIR_H_
+#define XFS_SCRUB_REPAIR_H_
+
+struct xfs_repair_list {
+	struct list_head	list;
+	size_t			nr;
+	bool			sorted;
+};
+
+bool xfs_repair_lists_alloc(size_t nr, struct xfs_repair_list **listsp);
+void xfs_repair_lists_free(struct xfs_repair_list **listsp);
+
+void xfs_repair_list_init(struct xfs_repair_list *rl);
+size_t xfs_repair_list_length(struct xfs_repair_list *rl);
+void xfs_repair_list_add(struct xfs_repair_list *dest,
+			 struct repair_item *item);
+void xfs_repair_list_splice(struct xfs_repair_list *dest,
+			    struct xfs_repair_list *src);
+
+void xfs_repair_find_mustfix(struct xfs_repair_list *repairs,
+			     struct xfs_repair_list *repair_now,
+			     unsigned long long *broken_primaries,
+			     unsigned long long *broken_secondaries);
+
+/* Passed through to xfs_repair_metadata() */
+#define XRML_REPAIR_ONLY	(XRM_REPAIR_ONLY)
+#define XRML_NOFIX_COMPLAIN	(XRM_NOFIX_COMPLAIN)
+
+bool xfs_repair_list_now(struct scrub_ctx *ctx, int fd,
+			 struct xfs_repair_list *repair_list,
+			 unsigned int repair_flags);
+
+#endif /* XFS_SCRUB_REPAIR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 647e050..b654be5 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -95,6 +95,15 @@
  * the previous two phases are retried here; if there are uncorrectable
  * errors, xfs_scrub stops here.
  *
+ * To perform the actual repairs, we iterate all the items on the per-AG
+ * repair list and ask the kernel to repair them.  Items which are
+ * successfully repaired are removed from the list.  If an item is not
+ * repaired successfully (or the kernel asks us to try again), we retry
+ * the repairs until there is nothing left to fix or we fail to make
+ * forward progress.  In that event, the unrepaired items are recorded
+ * as errors.  If there are no errors at this point, we call FSTRIM on
+ * the filesystem.
+ *
  * The next phase is the "check directory tree" phase.  In this phase,
  * every directory is opened (via file handle) to confirm that each
  * directory is connected to the root.  Directory entries are checked
@@ -414,6 +423,20 @@ _("Must be root to run scrub."));
 	return moveon;
 }
 
+/* Run the preening phase if there are no errors. */
+static bool
+preen(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Errors found, please re-run with -y."));
+		return true;
+	}
+
+	return xfs_repair_fs(ctx);
+}
+
 /* Run all the phases of the scrubber. */
 static bool
 run_scrub_phases(
@@ -466,8 +489,17 @@ run_scrub_phases(
 	/* Run all phases of the scrub tool. */
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
 		/* Turn on certain phases if user said to. */
-		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
+		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+		} else if (sp->fn == REPAIR_DUMMY_FN) {
+			if (ctx->mode == SCRUB_MODE_PREEN) {
+				sp->descr = _("Preen filesystem.");
+				sp->fn = preen;
+			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
+				sp->descr = _("Repair filesystem.");
+				sp->fn = xfs_repair_fs;
+			}
+		}
 
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
@@ -691,6 +723,19 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (!moveon)
 		ret |= 8;
 
+	if (ctx.repairs && ctx.preens)
+		fprintf(stdout,
+_("%s: %llu repairs and %llu optimizations made.\n"),
+			ctx.mntpoint, ctx.repairs, ctx.preens);
+	else if (ctx.repairs && ctx.preens == 0)
+		fprintf(stdout,
+_("%s: %llu repairs made.\n"),
+			ctx.mntpoint, ctx.repairs);
+	else if (ctx.repairs == 0 && ctx.preens)
+		fprintf(stdout,
+_("%s: %llu optimizations made.\n"),
+			ctx.mntpoint, ctx.preens);
+
 	total_errors = ctx.errors_found + ctx.runtime_errors;
 	if (total_errors && ctx.warnings_found)
 		fprintf(stderr,
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 7e835ec..0561044 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -96,6 +96,7 @@ struct scrub_ctx {
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	struct read_verify_pool	*rvp;
+	struct xfs_repair_list	*repair_lists;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
diff --git a/scrub/xfs.c b/scrub/xfs.c
index 4db0267..10f7e54 100644
--- a/scrub/xfs.c
+++ b/scrub/xfs.c
@@ -30,6 +30,7 @@
 #include "common.h"
 #include "ioctl.h"
 #include "xfs_fs.h"
+#include "repair.h"
 
 /* Shut down the filesystem. */
 void
@@ -331,3 +332,32 @@ xfs_scan_estimate_blocks(
 
 	return true;
 }
+
+/* Defer all the repairs until phase 4. */
+void
+xfs_defer_repairs(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_repair_list		*rl)
+{
+	ASSERT(agno < ctx->geo.agcount);
+
+	xfs_repair_list_splice(&ctx->repair_lists[agno], rl);
+}
+
+/* Quickly try to repair AG metadata; broken things are remembered for later. */
+bool
+xfs_quick_repair(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_repair_list		*rl)
+{
+	bool				moveon;
+
+	moveon = xfs_repair_list_now(ctx, ctx->mnt_fd, rl, XRML_REPAIR_ONLY);
+	if (!moveon)
+		return moveon;
+
+	xfs_defer_repairs(ctx, agno, rl);
+	return true;
+}
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 996f791..8a7d32e 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -33,6 +33,10 @@ bool xfs_scan_estimate_blocks(struct scrub_ctx *ctx,
 		unsigned long long *d_blocks, unsigned long long *d_bfree,
 		unsigned long long *r_blocks, unsigned long long *r_bfree,
 		unsigned long long *f_files, unsigned long long *f_free);
+void xfs_defer_repairs(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_repair_list *rl);
+bool xfs_quick_repair(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_repair_list *rl);
 
 /* Phase-specific functions. */
 bool xfs_cleanup(struct scrub_ctx *ctx);
@@ -42,5 +46,6 @@ bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
 bool xfs_scan_blocks(struct scrub_ctx *ctx);
 bool xfs_scan_summary(struct scrub_ctx *ctx);
+bool xfs_repair_fs(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */

