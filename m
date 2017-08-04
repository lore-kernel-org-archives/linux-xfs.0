Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33653 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:24 -0400
Subject: [PATCH 07/22] xfs_scrub: scan filesystem and AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:19 -0700
Message-ID: <150180529953.18784.9674242732829876195.stgit@magnolia>
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

Scrub the filesystem and per-AG metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    3 
 scrub/common.c |   18 ++
 scrub/common.h |    1 
 scrub/ioctl.c  |  462 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/phase2.c |   99 ++++++++++++
 scrub/scrub.c  |    1 
 scrub/xfs.h    |    1 
 7 files changed, 584 insertions(+), 1 deletion(-)
 create mode 100644 scrub/phase2.c


diff --git a/scrub/Makefile b/scrub/Makefile
index a797bfb..5ac4962 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -16,6 +16,7 @@ INSTALL_SCRUB = install-scrub
 endif	# scrub_prereqs
 
 HFILES = \
+../repair/threads.h \
 common.h \
 disk.h \
 ioctl.h \
@@ -23,10 +24,12 @@ scrub.h \
 xfs.h
 
 CFILES = \
+../repair/threads.c \
 common.c \
 disk.c \
 ioctl.c \
 phase1.c \
+phase2.c \
 scrub.c \
 xfs.c
 
diff --git a/scrub/common.c b/scrub/common.c
index 874f8ab..167d373 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -329,3 +329,21 @@ find_mountpoint(
 	platform_mntent_close(&cursor);
 	return found;
 }
+
+/*
+ * Sleep for 100ms * however many -b we got past the initial one.
+ */
+void
+background_sleep(void)
+{
+	unsigned long long	time;
+	struct timespec		tv;
+
+	if (bg_mode < 2)
+		return;
+
+	time = 100000 * (bg_mode - 1);
+	tv.tv_sec = time / 1000000;
+	tv.tv_nsec = time % 1000000;
+	nanosleep(&tv, NULL);
+}
diff --git a/scrub/common.h b/scrub/common.h
index a8b1ff8..7bbd061 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -70,5 +70,6 @@ static inline int syncfs(int fd)
 #endif
 
 bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
+void background_sleep(void);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
index 6578672..2fb039c 100644
--- a/scrub/ioctl.c
+++ b/scrub/ioctl.c
@@ -91,6 +91,464 @@ xfs_can_iterate_fsmap(
 	return error == 0 && (head.fmh_oflags & FMH_OF_DEV_T);
 }
 
+/* Online scrub. */
+
+/* Type info and names for the scrub types. */
+enum scrub_type {
+	ST_NONE,	/* disabled */
+	ST_AGHEADER,	/* per-AG header */
+	ST_PERAG,	/* per-AG metadata */
+	ST_FS,		/* per-FS metadata */
+	ST_INODE,	/* per-inode metadata */
+};
+struct scrub_descr {
+	const char	*name;
+	enum scrub_type	type;
+};
+
+/* These must correspond to XFS_SCRUB_TYPE_ */
+static const struct scrub_descr scrubbers[] = {
+	[XFS_SCRUB_TYPE_TEST] =
+		{"metadata",				ST_NONE},
+	[XFS_SCRUB_TYPE_SB] =
+		{"superblock",				ST_AGHEADER},
+	[XFS_SCRUB_TYPE_AGF] =
+		{"free space header",			ST_AGHEADER},
+	[XFS_SCRUB_TYPE_AGFL] =
+		{"free list",				ST_AGHEADER},
+	[XFS_SCRUB_TYPE_AGI] =
+		{"inode header",			ST_AGHEADER},
+	[XFS_SCRUB_TYPE_BNOBT] =
+		{"freesp by block btree",		ST_PERAG},
+	[XFS_SCRUB_TYPE_CNTBT] =
+		{"freesp by length btree",		ST_PERAG},
+	[XFS_SCRUB_TYPE_INOBT] =
+		{"inode btree",				ST_PERAG},
+	[XFS_SCRUB_TYPE_FINOBT] =
+		{"free inode btree",			ST_PERAG},
+	[XFS_SCRUB_TYPE_RMAPBT] =
+		{"reverse mapping btree",		ST_PERAG},
+	[XFS_SCRUB_TYPE_REFCNTBT] =
+		{"reference count btree",		ST_PERAG},
+	[XFS_SCRUB_TYPE_INODE] =
+		{"inode record",			ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTD] =
+		{"data block map",			ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTA] =
+		{"attr block map",			ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTC] =
+		{"CoW block map",			ST_INODE},
+	[XFS_SCRUB_TYPE_DIR] =
+		{"directory entries",			ST_INODE},
+	[XFS_SCRUB_TYPE_XATTR] =
+		{"extended attributes",			ST_INODE},
+	[XFS_SCRUB_TYPE_SYMLINK] =
+		{"symbolic link",			ST_INODE},
+	[XFS_SCRUB_TYPE_PARENT] =
+		{"parent pointer",			ST_INODE},
+	[XFS_SCRUB_TYPE_RTBITMAP] =
+		{"realtime bitmap",			ST_FS},
+	[XFS_SCRUB_TYPE_RTSUM] =
+		{"realtime summary",			ST_FS},
+	[XFS_SCRUB_TYPE_UQUOTA] =
+		{"user quotas",				ST_FS},
+	[XFS_SCRUB_TYPE_GQUOTA] =
+		{"group quotas",			ST_FS},
+	[XFS_SCRUB_TYPE_PQUOTA] =
+		{"project quotas",			ST_FS},
+};
+
+/* Format a scrub description. */
+static void
+format_scrub_descr(
+	char				*buf,
+	size_t				buflen,
+	struct xfs_scrub_metadata	*meta,
+	const struct scrub_descr	*sc)
+{
+	switch (sc->type) {
+	case ST_AGHEADER:
+	case ST_PERAG:
+		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
+				_(sc->name));
+		break;
+	case ST_INODE:
+		snprintf(buf, buflen, _("Inode %llu %s"), meta->sm_ino,
+				_(sc->name));
+		break;
+	case ST_FS:
+		snprintf(buf, buflen, _("%s"), _(sc->name));
+		break;
+	case ST_NONE:
+		assert(0);
+		break;
+	}
+}
+
+/* Predicates for scrub flag state. */
+
+static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
+}
+
+static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
+}
+
+static inline bool xref_failed(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
+}
+
+static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
+}
+
+static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
+}
+
+static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
+}
+
+/* Should we fix it? */
+static inline bool needs_repair(struct xfs_scrub_metadata *sm)
+{
+	return is_corrupt(sm) || xref_disagrees(sm);
+}
+
+/* Warn about strange circumstances after scrub. */
+static inline void
+xfs_scrub_warn_incomplete_scrub(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct xfs_scrub_metadata	*meta)
+{
+	if (is_incomplete(meta))
+		str_info(ctx, descr, _("Check incomplete."));
+
+	if (is_suspicious(meta)) {
+		if (debug)
+			str_info(ctx, descr, _("Possibly suspect metadata."));
+		else
+			str_warn(ctx, descr, _("Possibly suspect metadata."));
+	}
+
+	if (xref_failed(meta))
+		str_info(ctx, descr, _("Cross-referencing failed."));
+}
+
+/* Do a read-only check of some metadata. */
+static enum check_outcome
+xfs_check_metadata(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct xfs_scrub_metadata	*meta,
+	bool				is_inode)
+{
+	char				buf[DESCR_BUFSZ];
+	unsigned int			tries = 0;
+	int				code;
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
+	format_scrub_descr(buf, DESCR_BUFSZ, meta, &scrubbers[meta->sm_type]);
+
+	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
+retry:
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, meta);
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
+		meta->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	if (error) {
+		code = errno;
+		switch (code) {
+		case ENOENT:
+			/* Metadata not present, just skip it. */
+			return CHECK_DONE;
+		case ESHUTDOWN:
+			/* FS already crashed, give up. */
+			str_error(ctx, buf,
+_("Filesystem is shut down, aborting."));
+			return CHECK_ABORT;
+		case ENOMEM:
+			/* Ran out of memory, just give up. */
+			str_errno(ctx, buf);
+			return CHECK_ABORT;
+		case EDEADLOCK:
+		case EBUSY:
+		case EFSBADCRC:
+		case EFSCORRUPTED:
+			/*
+			 * The first two should never escape the kernel,
+			 * and the other two should be reported via sm_flags.
+			 */
+			str_error(ctx, buf,
+_("Kernel bug!  errno=%d"), code);
+			/* fall through */
+		default:
+			/* Operational error. */
+			str_errno(ctx, buf);
+			return CHECK_DONE;
+		}
+	}
+
+	/*
+	 * If the kernel says the test was incomplete or that there was
+	 * a cross-referencing discrepancy but no obvious corruption,
+	 * we'll try the scan again, just in case the fs was busy.
+	 * Only retry so many times.
+	 */
+	if (tries < 10 && (is_incomplete(meta) ||
+			   (xref_disagrees(meta) && !is_corrupt(meta)))) {
+		tries++;
+		goto retry;
+	}
+
+	/* Complain about incomplete or suspicious metadata. */
+	xfs_scrub_warn_incomplete_scrub(ctx, buf, meta);
+
+	/*
+	 * If we need repairs or there were discrepancies, schedule a
+	 * repair if desired, otherwise complain.
+	 */
+	if (is_corrupt(meta) || xref_disagrees(meta)) {
+		if (ctx->mode < SCRUB_MODE_REPAIR) {
+			str_error(ctx, buf,
+_("Repairs are required."));
+			return CHECK_DONE;
+		}
+
+		return CHECK_REPAIR;
+	}
+
+	/*
+	 * If we could optimize, schedule a repair if desired,
+	 * otherwise complain.
+	 */
+	if (is_unoptimized(meta)) {
+		if (ctx->mode < SCRUB_MODE_PREEN) {
+			if (!is_inode) {
+				/* AG or FS metadata, always warn. */
+				str_info(ctx, buf,
+_("Optimization is possible."));
+			} else if (!ctx->preen_triggers[meta->sm_type]) {
+				/* File metadata, only warn once per type. */
+				pthread_mutex_lock(&ctx->lock);
+				if (!ctx->preen_triggers[meta->sm_type])
+					ctx->preen_triggers[meta->sm_type] = true;
+				pthread_mutex_unlock(&ctx->lock);
+			}
+			return CHECK_DONE;
+		}
+
+		return CHECK_REPAIR;
+	}
+
+	/* Everything is ok. */
+	return CHECK_DONE;
+}
+
+/* Bulk-notify user about things that could be optimized. */
+void
+xfs_scrub_report_preen_triggers(
+	struct scrub_ctx		*ctx)
+{
+	int				i;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++) {
+		pthread_mutex_lock(&ctx->lock);
+		if (ctx->preen_triggers[i]) {
+			ctx->preen_triggers[i] = false;
+			pthread_mutex_unlock(&ctx->lock);
+			str_info(ctx, ctx->mntpoint,
+_("Optimizations of %s are possible."), scrubbers[i].name);
+		} else {
+			pthread_mutex_unlock(&ctx->lock);
+		}
+	}
+}
+
+/* Scrub metadata, saving corruption reports for later. */
+static bool
+xfs_scrub_metadata(
+	struct scrub_ctx		*ctx,
+	enum scrub_type			scrub_type,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	const struct scrub_descr	*sc;
+	enum check_outcome		fix;
+	int				type;
+
+	sc = scrubbers;
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->type != scrub_type)
+			continue;
+
+		meta.sm_type = type;
+		meta.sm_flags = 0;
+		meta.sm_agno = agno;
+		background_sleep();
+
+		/* Check the item. */
+		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+		switch (fix) {
+		case CHECK_ABORT:
+			return false;
+		case CHECK_REPAIR:
+		case CHECK_DONE:
+			continue;
+		case CHECK_RETRY:
+			abort();
+			break;
+		}
+	}
+
+	return true;
+}
+
+/* Scrub each AG's header blocks. */
+bool
+xfs_scrub_ag_headers(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno)
+{
+	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno);
+}
+
+/* Scrub each AG's metadata btrees. */
+bool
+xfs_scrub_ag_metadata(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno)
+{
+	return xfs_scrub_metadata(ctx, ST_PERAG, agno);
+}
+
+/* Scrub whole-FS metadata btrees. */
+bool
+xfs_scrub_fs_metadata(
+	struct scrub_ctx		*ctx)
+{
+	return xfs_scrub_metadata(ctx, ST_FS, 0);
+}
+
+/* Scrub inode metadata. */
+static bool
+__xfs_scrub_file(
+	struct scrub_ctx		*ctx,
+	uint64_t			ino,
+	uint32_t			gen,
+	int				fd,
+	unsigned int			type)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	enum check_outcome		fix;
+
+	assert(type < XFS_SCRUB_TYPE_NR);
+	assert(scrubbers[type].type == ST_INODE);
+
+	meta.sm_type = type;
+	meta.sm_ino = ino;
+	meta.sm_gen = gen;
+
+	/* Scrub the piece of metadata. */
+	fix = xfs_check_metadata(ctx, fd, &meta, true);
+	if (fix == CHECK_ABORT)
+		return false;
+	if (fix == CHECK_DONE)
+		return true;
+
+	return true;
+}
+
+bool
+xfs_scrub_inode_fields(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE);
+}
+
+bool
+xfs_scrub_data_fork(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD);
+}
+
+bool
+xfs_scrub_attr_fork(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA);
+}
+
+bool
+xfs_scrub_cow_fork(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC);
+}
+
+bool
+xfs_scrub_dir(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR);
+}
+
+bool
+xfs_scrub_attr(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR);
+}
+
+bool
+xfs_scrub_symlink(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK);
+}
+
+bool
+xfs_scrub_parent(
+	struct scrub_ctx	*ctx,
+	uint64_t		ino,
+	uint32_t		gen,
+	int			fd)
+{
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT);
+}
+
 /* Test the availability of a kernel scrub command. */
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR	30
 static bool
@@ -133,7 +591,9 @@ _("Filesystem is mounted norecovery; cannot proceed."));
 	case EOPNOTSUPP:
 	case ENOTTY:
 		str_info(ctx, ctx->mntpoint,
-_("Kernel metadata scrub is required."));
+_("Kernel %s %s facility is required."),
+				_(scrubbers[type].name),
+				repair ? _("repair") : _("scrub"));
 		return false;
 	case ENOENT:
 		/* Scrubber says not present on this fs; that's fine. */
diff --git a/scrub/phase2.c b/scrub/phase2.c
new file mode 100644
index 0000000..b8b44ac
--- /dev/null
+++ b/scrub/phase2.c
@@ -0,0 +1,99 @@
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
+#include "scrub.h"
+#include "common.h"
+#include "ioctl.h"
+#include "xfs_fs.h"
+
+/* Phase 2: Check internal metadata. */
+
+/* Scrub each AG's metadata btrees. */
+static void
+xfs_scan_ag_metadata(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
+	bool				*pmoveon = arg;
+	bool				moveon;
+	char				descr[DESCR_BUFSZ];
+
+	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
+
+	/*
+	 * First we scrub and fix the AG headers, because we need
+	 * them to work well enough to check the AG btrees.
+	 */
+	moveon = xfs_scrub_ag_headers(ctx, agno);
+	if (!moveon)
+		goto err;
+
+	/* Now scrub the AG btrees. */
+	moveon = xfs_scrub_ag_metadata(ctx, agno);
+	if (!moveon)
+		goto err;
+
+	return;
+err:
+	*pmoveon = false;
+}
+
+/* Scrub whole-FS metadata btrees. */
+static void
+xfs_scan_fs_metadata(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
+	bool				*pmoveon = arg;
+	bool				moveon;
+
+	moveon = xfs_scrub_fs_metadata(ctx);
+	if (!moveon)
+		*pmoveon = false;
+}
+
+/* Scan all filesystem metadata. */
+bool
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	bool			moveon = true;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	queue_work(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_metadata, agno, &moveon);
+	destroy_work_queue(&wq);
+
+	return moveon;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 4b9b4cc..c068835 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -413,6 +413,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Check internal metadata."),
+			.fn = xfs_scan_metadata,
 		},
 		{
 			.descr = _("Scan all inodes."),
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 24709f3..d3c5782 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -25,5 +25,6 @@ void xfs_shutdown_fs(struct scrub_ctx *ctx);
 /* Phase-specific functions. */
 bool xfs_cleanup(struct scrub_ctx *ctx);
 bool xfs_scan_fs(struct scrub_ctx *ctx);
+bool xfs_scan_metadata(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */

