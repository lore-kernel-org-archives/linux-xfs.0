Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42314 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965376AbdKQVB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:26 -0500
Subject: [PATCH 12/27] xfs_scrub: wrap the scrub ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:21 -0800
Message-ID: <151095248173.4825.4424369338791306820.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some wrappers to call the scrub ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    2 
 scrub/common.c |   19 ++
 scrub/common.h |    1 
 scrub/phase1.c |    8 +
 scrub/scrub.c  |  588 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h  |   61 ++++++
 6 files changed, 679 insertions(+)
 create mode 100644 scrub/scrub.c
 create mode 100644 scrub/scrub.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 878a5d5..b3f5220 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -21,6 +21,7 @@ disk.h \
 filemap.h \
 fscounters.h \
 inodes.h \
+scrub.h \
 spacemap.h \
 xfs_scrub.h
 
@@ -31,6 +32,7 @@ filemap.c \
 fscounters.c \
 inodes.c \
 phase1.c \
+scrub.c \
 spacemap.c \
 xfs_scrub.c
 
diff --git a/scrub/common.c b/scrub/common.c
index 1d1b3e3..18c060d 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -320,3 +320,22 @@ find_mountpoint(
 	platform_mntent_close(&cursor);
 	return found;
 }
+
+/*
+ * Sleep for 100ms * however many -b we got past the initial one.
+ * This is an (albeit clumsy) way to throttle scrub activity.
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
index ae5da76..e63f711 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -71,5 +71,6 @@ static inline int syncfs(int fd)
 #endif
 
 bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
+void background_sleep(void);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 0a18f85..5003f29 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -46,6 +46,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "disk.h"
+#include "scrub.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -168,6 +169,13 @@ _("Does not appear to be an XFS filesystem!"));
 		return false;
 	}
 
+	/* Do we have kernel-assisted metadata scrubbing? */
+	if (!xfs_can_scrub_fs_metadata(ctx) || !xfs_can_scrub_inode(ctx) ||
+	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
+	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
+	    !xfs_can_scrub_parent(ctx))
+		return false;
+
 	/* Go find the XFS devices if we have a usable fsmap. */
 	fs_table_initialise(0, NULL, 0, NULL);
 	errno = 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
new file mode 100644
index 0000000..2ff588c
--- /dev/null
+++ b/scrub/scrub.c
@@ -0,0 +1,588 @@
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
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "path.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "scrub.h"
+#include "xfs_errortag.h"
+
+/* Online scrub and repair wrappers. */
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
+static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_PROBE] =
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
+		snprintf(buf, buflen, _("Inode %"PRIu64" %s"),
+				(uint64_t)meta->sm_ino, _(sc->name));
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
+		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
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
+			/* fall through */
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
+/* Test the availability of a kernel scrub command. */
+static bool
+__xfs_scrub_test(
+	struct scrub_ctx		*ctx,
+	unsigned int			type,
+	bool				repair)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	int				error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
+		return false;
+
+	meta.sm_type = type;
+	if (repair)
+		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (!error)
+		return true;
+	switch (errno) {
+	case EROFS:
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem is mounted read-only; cannot proceed."));
+		return false;
+	case ENOTRECOVERABLE:
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem is mounted norecovery; cannot proceed."));
+		return false;
+	case EOPNOTSUPP:
+	case ENOTTY:
+		str_info(ctx, ctx->mntpoint,
+_("Kernel %s %s facility is required."),
+				_(scrubbers[type].name),
+				repair ? _("repair") : _("scrub"));
+		return false;
+	case ENOENT:
+		/* Scrubber says not present on this fs; that's fine. */
+		return true;
+	default:
+		str_info(ctx, ctx->mntpoint, "%s", strerror(errno));
+		return true;
+	}
+	return error == 0 || (error && errno != EOPNOTSUPP && errno != ENOTTY);
+}
+
+bool
+xfs_can_scrub_fs_metadata(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, false);
+}
+
+bool
+xfs_can_scrub_inode(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_INODE, false);
+}
+
+bool
+xfs_can_scrub_bmap(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, false);
+}
+
+bool
+xfs_can_scrub_dir(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_DIR, false);
+}
+
+bool
+xfs_can_scrub_attr(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, false);
+}
+
+bool
+xfs_can_scrub_symlink(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, false);
+}
+
+bool
+xfs_can_scrub_parent(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
new file mode 100644
index 0000000..4d687de
--- /dev/null
+++ b/scrub/scrub.h
@@ -0,0 +1,61 @@
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
+#ifndef XFS_SCRUB_SCRUB_H_
+#define XFS_SCRUB_SCRUB_H_
+
+/* Online scrub and repair. */
+enum check_outcome {
+	CHECK_DONE,	/* no further processing needed */
+	CHECK_REPAIR,	/* schedule this for repairs */
+	CHECK_ABORT,	/* end program */
+	CHECK_RETRY,	/* repair failed, try again later */
+};
+
+void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
+bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno);
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx);
+
+bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
+bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
+bool xfs_can_scrub_bmap(struct scrub_ctx *ctx);
+bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
+bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
+bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
+bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
+
+bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+
+#endif /* XFS_SCRUB_SCRUB_H_ */

