Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33631 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:18 -0400
Subject: [PATCH 06/22] xfs_scrub: find XFS filesystem geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:13 -0700
Message-ID: <150180529336.18784.6540410261582461434.stgit@magnolia>
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

Discover the geometry of the XFS filesystem that we've been told to
scan, and set up some common functions that will be used by the
scrub phases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |   13 +++-
 scrub/common.c |   71 ++++++++++++++++++++
 scrub/common.h |   10 +++
 scrub/ioctl.c  |  195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/ioctl.h  |   94 +++++++++++++++++++++++++++
 scrub/phase1.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c  |   26 +++++++
 scrub/scrub.h  |   13 ++++
 scrub/xfs.c    |   44 +++++++++++++
 scrub/xfs.h    |   29 ++++++++
 10 files changed, 660 insertions(+), 4 deletions(-)
 create mode 100644 scrub/ioctl.c
 create mode 100644 scrub/ioctl.h
 create mode 100644 scrub/phase1.c
 create mode 100644 scrub/xfs.c
 create mode 100644 scrub/xfs.h


diff --git a/scrub/Makefile b/scrub/Makefile
index fa88e01..a797bfb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,12 +18,17 @@ endif	# scrub_prereqs
 HFILES = \
 common.h \
 disk.h \
-scrub.h
+ioctl.h \
+scrub.h \
+xfs.h
 
 CFILES = \
 common.c \
 disk.c \
-scrub.c
+ioctl.c \
+phase1.c \
+scrub.c \
+xfs.c
 
 LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXCMD) $(LIBHANDLE)
@@ -33,6 +38,10 @@ ifeq ($(HAVE_MALLINFO),yes)
 LCFLAGS += -DHAVE_MALLINFO
 endif
 
+ifeq ($(HAVE_SYNCFS),yes)
+LCFLAGS += -DHAVE_SYNCFS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/scrub/common.c b/scrub/common.c
index f650438..874f8ab 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -35,6 +35,8 @@
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
+#include "ioctl.h"
+#include "xfs.h"
 
 /*
  * Reporting Status to the Console
@@ -258,3 +260,72 @@ libxfs_log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+/*
+ * Check if the argument is either the device name or mountpoint of a mounted
+ * filesystem.
+ */
+#define MNTTYPE_XFS	"xfs"
+static bool
+find_mountpoint_check(
+	struct stat		*sb,
+	struct mntent		*t)
+{
+	struct stat		ms;
+
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat(t->mnt_dir, &ms) < 0)
+			return false;
+		if (sb->st_ino != ms.st_ino)
+			return false;
+		if (sb->st_dev != ms.st_dev)
+			return false;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
+	} else {				/* device */
+		if (stat(t->mnt_fsname, &ms) < 0)
+			return false;
+		if (sb->st_rdev != ms.st_rdev)
+			return false;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
+		/*
+		 * Make sure the mountpoint given by mtab is accessible
+		 * before using it.
+		 */
+		if (stat(t->mnt_dir, &ms) < 0)
+			return false;
+	}
+
+	return true;
+}
+
+/* Check that our alleged mountpoint is in mtab */
+bool
+find_mountpoint(
+	char			*mtab,
+	struct scrub_ctx	*ctx)
+{
+	struct mntent_cursor	cursor;
+	struct mntent		*t = NULL;
+	bool			found = false;
+
+	if (platform_mntent_open(&cursor, mtab) != 0) {
+		fprintf(stderr, "Error: can't get mntent entries.\n");
+		exit(1);
+	}
+
+	while ((t = platform_mntent_next(&cursor)) != NULL) {
+		/*
+		 * Keep jotting down matching mount details; newer mounts are
+		 * towards the end of the file (hopefully).
+		 */
+		if (find_mountpoint_check(&ctx->mnt_sb, t)) {
+			ctx->mntpoint = strdup(t->mnt_dir);
+			ctx->blkdev = strdup(t->mnt_fsname);
+			found = true;
+		}
+	}
+	platform_mntent_close(&cursor);
+	return found;
+}
diff --git a/scrub/common.h b/scrub/common.h
index 0bc6872..a8b1ff8 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -61,4 +61,14 @@ double auto_space_units(unsigned long long kilobytes, char **units);
 double auto_units(unsigned long long number, char **units);
 unsigned int scrub_nproc(struct scrub_ctx *ctx);
 
+#ifndef HAVE_SYNCFS
+static inline int syncfs(int fd)
+{
+	sync();
+	return 0;
+}
+#endif
+
+bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
new file mode 100644
index 0000000..6578672
--- /dev/null
+++ b/scrub/ioctl.c
@@ -0,0 +1,195 @@
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
+
+/* Does the kernel support bulkstat? */
+bool
+xfs_can_iterate_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_bulkreq	bulkreq;
+	__u64			lastino;
+	__s32			bulklen = 0;
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_BULKSTAT"))
+		return false;
+
+	lastino = 0;
+	memset(&bulkreq, 0, sizeof(bulkreq));
+	bulkreq.lastip = (__u64 *)&lastino;
+	bulkreq.icount  = 0;
+	bulkreq.ubuffer = NULL;
+	bulkreq.ocount  = &bulklen;
+
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+	return error == -1 && errno == EINVAL;
+}
+
+/* Does the kernel support getbmapx? */
+bool
+xfs_can_iterate_bmap(
+	struct scrub_ctx	*ctx)
+{
+	struct getbmapx		bsm[2];
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_BMAP"))
+		return false;
+
+	memset(bsm, 0, sizeof(struct getbmapx));
+	bsm->bmv_length = ULLONG_MAX;
+	bsm->bmv_count = 2;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_GETBMAPX, bsm);
+	return error == 0;
+}
+
+/* Does the kernel support getfsmap? */
+bool
+xfs_can_iterate_fsmap(
+	struct scrub_ctx	*ctx)
+{
+	struct fsmap_head	head;
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_FSMAP"))
+		return false;
+
+	memset(&head, 0, sizeof(struct fsmap_head));
+	head.fmh_keys[1].fmr_device = UINT_MAX;
+	head.fmh_keys[1].fmr_physical = ULLONG_MAX;
+	head.fmh_keys[1].fmr_owner = ULLONG_MAX;
+	head.fmh_keys[1].fmr_offset = ULLONG_MAX;
+	error = ioctl(ctx->mnt_fd, FS_IOC_GETFSMAP, &head);
+	return error == 0 && (head.fmh_oflags & FMH_OF_DEV_T);
+}
+
+/* Test the availability of a kernel scrub command. */
+#define XFS_ERRTAG_FORCE_SCRUB_REPAIR	30
+static bool
+__xfs_scrub_test(
+	struct scrub_ctx		*ctx,
+	unsigned int			type,
+	bool				repair)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	struct xfs_error_injection	inject;
+	static bool			injected;
+	int				error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
+		return false;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		inject.fd = ctx->mnt_fd;
+		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
+		error = ioctl(ctx->mnt_fd,
+				XFS_IOC_ERROR_INJECTION, &inject);
+		if (error == 0)
+			injected = true;
+	}
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
+_("Kernel metadata scrub is required."));
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
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_TEST, false);
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
diff --git a/scrub/ioctl.h b/scrub/ioctl.h
new file mode 100644
index 0000000..c255bbb
--- /dev/null
+++ b/scrub/ioctl.h
@@ -0,0 +1,94 @@
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
+#ifndef XFS_SCRUB_IOCTL_H_
+#define XFS_SCRUB_IOCTL_H_
+
+/* inode iteration */
+#define XFS_ITERATE_INODES_ABORT	(-1)
+typedef int (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
+		struct xfs_handle *handle, struct xfs_bstat *bs, void *arg);
+bool xfs_iterate_inodes(struct scrub_ctx *ctx, const char *descr,
+		void *fshandle, uint64_t first_ino, uint64_t last_ino,
+		xfs_inode_iter_fn fn, void *arg);
+bool xfs_can_iterate_inodes(struct scrub_ctx *ctx);
+
+/* inode fork block mapping */
+struct xfs_bmap {
+	uint64_t	bm_offset;	/* file offset of segment in bytes */
+	uint64_t	bm_physical;	/* physical starting byte  */
+	uint64_t	bm_length;	/* length of segment, bytes */
+	uint32_t	bm_flags;	/* output flags */
+};
+
+typedef bool (*xfs_bmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+		int fd, int whichfork, struct fsxattr *fsx,
+		struct xfs_bmap *bmap, void *arg);
+
+bool xfs_iterate_bmap(struct scrub_ctx *ctx, const char *descr, int fd,
+		int whichfork, struct xfs_bmap *key, xfs_bmap_iter_fn fn,
+		void *arg);
+bool xfs_can_iterate_bmap(struct scrub_ctx *ctx);
+
+/* filesystem reverse mapping */
+typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+		struct fsmap *fsr, void *arg);
+bool xfs_iterate_fsmap(struct scrub_ctx *ctx, const char *descr,
+		struct fsmap *keys, xfs_fsmap_iter_fn fn, void *arg);
+bool xfs_can_iterate_fsmap(struct scrub_ctx *ctx);
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
+#endif /* XFS_SCRUB_IOCTL_H_ */
diff --git a/scrub/phase1.c b/scrub/phase1.c
new file mode 100644
index 0000000..6c3aab4
--- /dev/null
+++ b/scrub/phase1.c
@@ -0,0 +1,169 @@
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
+/* Phase 1: Find filesystem geometry (and clean up after) */
+
+/* Clean up the XFS-specific state data. */
+bool
+xfs_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->fshandle)
+		free_handle(ctx->fshandle, ctx->fshandle_len);
+	disk_close(&ctx->rtdev);
+	disk_close(&ctx->logdev);
+	disk_close(&ctx->datadev);
+
+	return true;
+}
+
+/* Read the XFS geometry. */
+bool
+xfs_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct fs_path			*fsp;
+	int				error;
+
+	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
+		str_error(ctx, ctx->mntpoint,
+_("Does not appear to be an XFS filesystem!"));
+		return false;
+	}
+
+	/*
+	 * Flush everything out to disk before we start checking.
+	 * This seems to reduce the incidence of stale file handle
+	 * errors when we open things by handle.
+	 */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	ctx->datadev.d_fd = ctx->logdev.d_fd = ctx->rtdev.d_fd = -1;
+
+	/* Retrieve XFS geometry. */
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		goto err;
+	}
+
+	ctx->agblklog = libxfs_log2_roundup(ctx->geo.agblocks);
+	ctx->blocklog = libxfs_highbit32(ctx->geo.blocksize);
+	ctx->inodelog = libxfs_highbit32(ctx->geo.inodesize);
+	ctx->inopblog = ctx->blocklog - ctx->inodelog;
+
+	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
+			&ctx->fshandle_len);
+	if (error) {
+		perror(_("getting fshandle"));
+		goto err;
+	}
+
+	/* Do we have bulkstat? */
+	if (!xfs_can_iterate_inodes(ctx)) {
+		str_info(ctx, ctx->mntpoint, _("BULKSTAT is required."));
+		goto err;
+	}
+
+	/* Do we have getbmapx? */
+	if (!xfs_can_iterate_bmap(ctx)) {
+		str_info(ctx, ctx->mntpoint, _("GETBMAPX is required."));
+		goto err;
+	}
+
+	/* Do we have getfsmap? */
+	if (!xfs_can_iterate_fsmap(ctx)) {
+		str_info(ctx, ctx->mntpoint, _("GETFSMAP is required."));
+		goto err;
+	}
+
+	/* Do we have kernel-assisted metadata scrubbing? */
+	if (!xfs_can_scrub_fs_metadata(ctx) || !xfs_can_scrub_inode(ctx) ||
+	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
+	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
+	    !xfs_can_scrub_parent(ctx))
+		goto err;
+
+	/* Go find the XFS devices if we have a usable fsmap. */
+	fs_table_initialise(0, NULL, 0, NULL);
+	errno = 0;
+	fsp = fs_table_lookup(ctx->mntpoint, FS_MOUNT_POINT);
+	if (!fsp) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find XFS information."));
+		goto err;
+	}
+	memcpy(&ctx->fsinfo, fsp, sizeof(struct fs_path));
+
+	/* Did we find the log and rt devices, if they're present? */
+	if (ctx->geo.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find log device path."));
+		goto err;
+	}
+	if (ctx->geo.rtblocks && ctx->fsinfo.fs_rt == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find realtime device path."));
+		goto err;
+	}
+
+	/* Open the raw devices. */
+	error = disk_open(ctx->fsinfo.fs_name, &ctx->datadev);
+	if (error) {
+		str_errno(ctx, ctx->fsinfo.fs_name);
+		goto err;
+	}
+	ctx->nr_io_threads = nproc;
+
+	if (ctx->fsinfo.fs_log) {
+		error = disk_open(ctx->fsinfo.fs_log, &ctx->logdev);
+		if (error) {
+			str_errno(ctx, ctx->fsinfo.fs_name);
+			goto err;
+		}
+	}
+	if (ctx->fsinfo.fs_rt) {
+		error = disk_open(ctx->fsinfo.fs_rt, &ctx->rtdev);
+		if (error) {
+			str_errno(ctx, ctx->fsinfo.fs_name);
+			goto err;
+		}
+	}
+
+	return true;
+err:
+	return false;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index f492301..4b9b4cc 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -35,6 +35,8 @@
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
+#include "ioctl.h"
+#include "xfs.h"
 
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
@@ -385,12 +387,15 @@ _("Must be root to run scrub."));
 		str_errno(ctx, ctx->mntpoint);
 		return false;
 	}
+	moveon = xfs_scan_fs(ctx);
+	if (!moveon)
+		goto out;
 	if (verbose) {
 		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
 				ctx->mntpoint, scrub_nproc(ctx));
 		fflush(stdout);
 	}
-
+out:
 	return moveon;
 }
 
@@ -485,6 +490,7 @@ main(
 	struct phase_rusage	all_pi;
 	unsigned long long	total_errors;
 	bool			moveon = true;
+	bool			ismnt;
 	static bool		injected;
 	int			ret;
 
@@ -610,6 +616,14 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (!moveon)
 		goto out;
 
+	ismnt = find_mountpoint(mtab, &ctx);
+	if (!ismnt) {
+		fprintf(stderr, _("%s: Not a mount point or block device.\n"),
+			ctx.mntpoint);
+		ret = 8;
+		goto end;
+	}
+
 	/* How many CPUs? */
 	nproc = sysconf(_SC_NPROCESSORS_ONLN);
 	if (nproc < 0)
@@ -643,6 +657,11 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (!moveon)
 		ret |= 4;
 
+	/* Clean up scan data. */
+	moveon = xfs_cleanup(&ctx);
+	if (!moveon)
+		ret |= 8;
+
 	total_errors = ctx.errors_found + ctx.runtime_errors;
 	if (total_errors && ctx.warnings_found)
 		fprintf(stderr,
@@ -656,8 +675,11 @@ _("%s: %llu errors found.  Unmount and run xfs_repair.\n"),
 		fprintf(stderr,
 _("%s: %llu warnings found.\n"),
 			ctx.mntpoint, ctx.warnings_found);
-	if (ctx.errors_found)
+	if (ctx.errors_found) {
+		if (ctx.error_action == ERRORS_SHUTDOWN)
+			xfs_shutdown_fs(&ctx);
 		ret |= 1;
+	}
 	if (ctx.warnings_found)
 		ret |= 2;
 	if (ctx.runtime_errors)
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 3a776e1..87f59d6 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -56,6 +56,8 @@ struct scrub_ctx {
 
 	/* Open block devices */
 	struct disk		datadev;
+	struct disk		logdev;
+	struct disk		rtdev;
 
 	/* What does the user want us to do? */
 	enum scrub_mode		mode;
@@ -69,12 +71,23 @@ struct scrub_ctx {
 	/* Number of threads for metadata scrubbing */
 	unsigned int		nr_io_threads;
 
+	/* XFS specific geometry */
+	struct xfs_fsop_geom	geo;
+	struct fs_path		fsinfo;
+	unsigned int		agblklog;
+	unsigned int		blocklog;
+	unsigned int		inodelog;
+	unsigned int		inopblog;
+	void			*fshandle;
+	size_t			fshandle_len;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
+	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };
 
 #endif /* XFS_SCRUB_SCRUB_H_ */
diff --git a/scrub/xfs.c b/scrub/xfs.c
new file mode 100644
index 0000000..e9ad15c
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,44 @@
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
+/* Shut down the filesystem. */
+void
+xfs_shutdown_fs(
+	struct scrub_ctx		*ctx)
+{
+	int				flag;
+
+	flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
+	str_info(ctx, ctx->mntpoint, _("Shutting down filesystem!"));
+	if (ioctl(ctx->mnt_fd, XFS_IOC_GOINGDOWN, &flag))
+		str_errno(ctx, ctx->mntpoint);
+}
diff --git a/scrub/xfs.h b/scrub/xfs.h
new file mode 100644
index 0000000..24709f3
--- /dev/null
+++ b/scrub/xfs.h
@@ -0,0 +1,29 @@
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
+#ifndef XFS_SCRUB_XFS_H_
+#define XFS_SCRUB_XFS_H_
+
+void xfs_shutdown_fs(struct scrub_ctx *ctx);
+
+/* Phase-specific functions. */
+bool xfs_cleanup(struct scrub_ctx *ctx);
+bool xfs_scan_fs(struct scrub_ctx *ctx);
+
+#endif /* XFS_SCRUB_XFS_H_ */

