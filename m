Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46779 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760164AbdKQVA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:57 -0500
Subject: [PATCH 07/27] xfs_scrub: find XFS filesystem geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:51 -0800
Message-ID: <151095245157.4825.16454517003871609175.stgit@magnolia>
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

Discover the geometry of the XFS filesystem that we've been told to
scan, and set up some common functions that will be used by the
scrub phases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    5 +
 scrub/common.c    |   72 +++++++++++++++++
 scrub/common.h    |   10 ++
 scrub/disk.c      |    3 +
 scrub/phase1.c    |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |   34 ++++++++
 scrub/xfs_scrub.h |   29 +++++++
 7 files changed, 375 insertions(+), 1 deletion(-)
 create mode 100644 scrub/phase1.c


diff --git a/scrub/Makefile b/scrub/Makefile
index f810790..2d2a164 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,6 +23,7 @@ xfs_scrub.h
 CFILES = \
 common.c \
 disk.c \
+phase1.c \
 xfs_scrub.c
 
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
@@ -33,6 +34,10 @@ ifeq ($(HAVE_MALLINFO),yes)
 LCFLAGS += -DHAVE_MALLINFO
 endif
 
+ifeq ($(HAVE_SYNCFS),yes)
+LCFLAGS += -DHAVE_SYNCFS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/scrub/common.c b/scrub/common.c
index 3df6126..1d1b3e3 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -20,8 +20,11 @@
 #include <stdio.h>
 #include <pthread.h>
 #include <stdbool.h>
+#include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "xfs.h"
+#include "xfs_fs.h"
+#include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
 
@@ -248,3 +251,72 @@ scrub_nproc_workqueue(
 		x = 0;
 	return x;
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
index 145a05c..ae5da76 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -62,4 +62,14 @@ double auto_units(unsigned long long number, char **units);
 unsigned int scrub_nproc(struct scrub_ctx *ctx);
 unsigned int scrub_nproc_workqueue(struct scrub_ctx *ctx);
 
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
diff --git a/scrub/disk.c b/scrub/disk.c
index fe91842..96eaa6a 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -31,6 +31,9 @@
 #include <linux/fs.h>
 #include "platform_defs.h"
 #include "libfrog.h"
+#include "xfs.h"
+#include "path.h"
+#include "xfs_fs.h"
 #include "xfs_scrub.h"
 #include "disk.h"
 
diff --git a/scrub/phase1.c b/scrub/phase1.c
new file mode 100644
index 0000000..0a18f85
--- /dev/null
+++ b/scrub/phase1.c
@@ -0,0 +1,223 @@
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
+#include <stdint.h>
+#include <stdbool.h>
+#include <pthread.h>
+#include <errno.h>
+#include <linux/fs.h>
+#include "libfrog.h"
+#include "workqueue.h"
+#include "input.h"
+#include "path.h"
+#include "handle.h"
+#include "bitops.h"
+#include "xfs_arch.h"
+#include "xfs_format.h"
+#include "avl64.h"
+#include "list.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "disk.h"
+
+/* Phase 1: Find filesystem geometry (and clean up after) */
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
+
+/* Clean up the XFS-specific state data. */
+bool
+xfs_cleanup_fs(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->fshandle)
+		free_handle(ctx->fshandle, ctx->fshandle_len);
+	if (ctx->rtdev)
+		disk_close(ctx->rtdev);
+	if (ctx->logdev)
+		disk_close(ctx->logdev);
+	if (ctx->datadev)
+		disk_close(ctx->datadev);
+	fshandle_destroy();
+	close(ctx->mnt_fd);
+	fs_table_destroy();
+
+	return true;
+}
+
+/*
+ * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
+ * Anything we've already built will be cleaned up by xfs_cleanup_fs.
+ */
+bool
+xfs_setup_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct fs_path			*fsp;
+	int				error;
+
+	/*
+	 * Open the directory with O_NOATIME.  For mountpoints owned
+	 * by root, this should be sufficient to ensure that we have
+	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
+	 * with the (XFS driver) kernel.
+	 */
+	ctx->mnt_fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
+	if (ctx->mnt_fd < 0) {
+		if (errno == EPERM)
+			str_info(ctx, ctx->mntpoint,
+_("Must be root to run scrub."));
+		else
+			str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	error = fstat(ctx->mnt_fd, &ctx->mnt_sb);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = fstatvfs(ctx->mnt_fd, &ctx->mnt_sv);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = fstatfs(ctx->mnt_fd, &ctx->mnt_sf);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	ctx->nr_io_threads = nproc;
+	if (verbose) {
+		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
+				ctx->mntpoint, scrub_nproc(ctx));
+		fflush(stdout);
+	}
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
+	/* Retrieve XFS geometry. */
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	ctx->agblklog = log2_roundup(ctx->geo.agblocks);
+	ctx->blocklog = highbit32(ctx->geo.blocksize);
+	ctx->inodelog = highbit32(ctx->geo.inodesize);
+	ctx->inopblog = ctx->blocklog - ctx->inodelog;
+
+	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
+			&ctx->fshandle_len);
+	if (error) {
+		perror(_("getting fshandle"));
+		return false;
+	}
+
+	/* Go find the XFS devices if we have a usable fsmap. */
+	fs_table_initialise(0, NULL, 0, NULL);
+	errno = 0;
+	fsp = fs_table_lookup(ctx->mntpoint, FS_MOUNT_POINT);
+	if (!fsp) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find XFS information."));
+		return false;
+	}
+	memcpy(&ctx->fsinfo, fsp, sizeof(struct fs_path));
+
+	/* Did we find the log and rt devices, if they're present? */
+	if (ctx->geo.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find log device path."));
+		return false;
+	}
+	if (ctx->geo.rtblocks && ctx->fsinfo.fs_rt == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find realtime device path."));
+		return false;
+	}
+
+	/* Open the raw devices. */
+	ctx->datadev = disk_open(ctx->fsinfo.fs_name);
+	if (error) {
+		str_errno(ctx, ctx->fsinfo.fs_name);
+		return false;
+	}
+
+	if (ctx->fsinfo.fs_log) {
+		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
+		if (error) {
+			str_errno(ctx, ctx->fsinfo.fs_name);
+			return false;
+		}
+	}
+	if (ctx->fsinfo.fs_rt) {
+		ctx->rtdev = disk_open(ctx->fsinfo.fs_rt);
+		if (error) {
+			str_errno(ctx, ctx->fsinfo.fs_name);
+			return false;
+		}
+	}
+
+	/*
+	 * Everything's set up, which means any failures recorded after
+	 * this point are most probably corruption errors (as opposed to
+	 * purely setup errors).
+	 */
+	ctx->need_repair = true;
+	return true;
+}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 5466c58..a003e44 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -23,9 +23,12 @@
 #include <stdlib.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "xfs.h"
+#include "xfs_fs.h"
 #include "input.h"
+#include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
 
@@ -345,6 +348,8 @@ run_scrub_phases(
 	{
 		{
 			.descr = _("Find filesystem geometry."),
+			.fn = xfs_setup_fs,
+			.must_run = true,
 		},
 		{
 			.descr = _("Check internal metadata."),
@@ -426,6 +431,7 @@ main(
 	struct phase_rusage	all_pi;
 	unsigned long long	total_errors;
 	bool			moveon = true;
+	bool			ismnt;
 	static bool		injected;
 	int			ret = 0;
 
@@ -522,6 +528,15 @@ _("Only one of the options -n or -y may be specified.\n"));
 
 	ctx.mntpoint = strdup(argv[optind]);
 
+	/* Find the mount record for the passed-in argument. */
+	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
+		fprintf(stderr,
+			_("%s: could not stat: %s: %s\n"),
+			progname, argv[optind], strerror(errno));
+		ret |= 8;
+		goto out;
+	}
+
 	/*
 	 * If the user did not specify an explicit mount table, try to use
 	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
@@ -541,6 +556,14 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (!moveon)
 		goto out;
 
+	ismnt = find_mountpoint(mtab, &ctx);
+	if (!ismnt) {
+		fprintf(stderr, _("%s: Not a mount point or block device.\n"),
+			ctx.mntpoint);
+		ret |= 8;
+		goto out;
+	}
+
 	/* How many CPUs? */
 	nproc = sysconf(_SC_NPROCESSORS_ONLN);
 	if (nproc < 0)
@@ -569,6 +592,11 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (debug_tweak_on("XFS_SCRUB_FORCE_ERROR"))
 		str_error(&ctx, ctx.mntpoint, _("Injecting error."));
 
+	/* Clean up scan data. */
+	moveon = xfs_cleanup_fs(&ctx);
+	if (!moveon)
+		ret |= 8;
+
 out:
 	total_errors = ctx.errors_found + ctx.runtime_errors;
 	if (ctx.need_repair)
@@ -586,13 +614,17 @@ _("%s: %llu errors found.%s\n"),
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
 		ret |= 4;
 	phase_end(&all_pi, 0);
+	free(ctx.blkdev);
 	free(ctx.mntpoint);
 
 	return ret;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 8e2fa54..037452e 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -51,15 +51,38 @@ struct scrub_ctx {
 	char			*mntpoint;
 	char			*blkdev;
 
+	/* Mountpoint info */
+	struct stat		mnt_sb;
+	struct statvfs		mnt_sv;
+	struct statfs		mnt_sf;
+
+	/* Open block devices */
+	struct disk		*datadev;
+	struct disk		*logdev;
+	struct disk		*rtdev;
+
 	/* What does the user want us to do? */
 	enum scrub_mode		mode;
 
 	/* How does the user want us to react to errors? */
 	enum error_action	error_action;
 
+	/* fd to filesystem mount point */
+	int			mnt_fd;
+
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
@@ -67,6 +90,12 @@ struct scrub_ctx {
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
 	bool			need_repair;
+	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };
 
+/* Phase helper functions */
+void xfs_shutdown_fs(struct scrub_ctx *ctx);
+bool xfs_cleanup_fs(struct scrub_ctx *ctx);
+bool xfs_setup_fs(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

