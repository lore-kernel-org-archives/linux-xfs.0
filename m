Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33610 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:12 -0400
Subject: [PATCH 05/22] xfs_scrub: bind to a mount point and a block device
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:07 -0700
Message-ID: <150180528726.18784.10381213446641918919.stgit@magnolia>
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

Create an abstraction to handle all of our low level disk operations,
then use it to bind to a fs mount point and block device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    2 +
 scrub/common.c |   27 +++++++++
 scrub/common.h |    1 
 scrub/disk.c   |  160 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/disk.h   |   40 ++++++++++++++
 scrub/scrub.c  |   67 +++++++++++++++++++++++
 scrub/scrub.h  |   14 +++++
 7 files changed, 311 insertions(+)
 create mode 100644 scrub/disk.c
 create mode 100644 scrub/disk.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 6134fe9..fa88e01 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -17,10 +17,12 @@ endif	# scrub_prereqs
 
 HFILES = \
 common.h \
+disk.h \
 scrub.h
 
 CFILES = \
 common.c \
+disk.c \
 scrub.c
 
 LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
diff --git a/scrub/common.c b/scrub/common.c
index 86e92ed..f650438 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -31,6 +31,7 @@
 #include <dirent.h>
 #include "../repair/threads.h"
 #include "path.h"
+#include "disk.h"
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
@@ -231,3 +232,29 @@ auto_units(
 	*units = "";
 	return number;
 }
+
+/* How many threads to kick off? */
+unsigned int
+scrub_nproc(
+	struct scrub_ctx	*ctx)
+{
+	if (nr_threads)
+		return nr_threads;
+	return ctx->nr_io_threads;
+}
+
+/*
+ * Return ceil(log2(i)).
+ * Avoid linking in libxfs by providing the few symbols we actually need.
+ */
+unsigned int
+libxfs_log2_roundup(unsigned int i)
+{
+	unsigned int	rval;
+
+	for (rval = 0; rval < NBBY * sizeof(i); rval++) {
+		if ((1 << rval) >= i)
+			break;
+	}
+	return rval;
+}
diff --git a/scrub/common.h b/scrub/common.h
index 70a3b9d..0bc6872 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -59,5 +59,6 @@ debug_tweak_on(
 double timeval_subtract(struct timeval *tv1, struct timeval *tv2);
 double auto_space_units(unsigned long long kilobytes, char **units);
 double auto_units(unsigned long long number, char **units);
+unsigned int scrub_nproc(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/disk.c b/scrub/disk.c
new file mode 100644
index 0000000..613e7fd
--- /dev/null
+++ b/scrub/disk.c
@@ -0,0 +1,160 @@
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
+#include "../repair/threads.h"
+#include "path.h"
+#include "disk.h"
+#include "scrub.h"
+#include "common.h"
+
+/*
+ * Disk Abstraction
+ *
+ * These routines help us to discover the geometry of a block device,
+ * estimate the amount of concurrent IOs that we can send to it, and
+ * abstract the process of performing read verification of disk blocks.
+ */
+
+/* Figure out how many disk heads are available. */
+static unsigned int
+__disk_heads(
+	struct disk		*disk)
+{
+	int			iomin;
+	int			ioopt;
+	unsigned short		rot;
+	int			error;
+
+	/* If it's not a block device, throw all the CPUs at it. */
+	if (!S_ISBLK(disk->d_sb.st_mode))
+		return nproc;
+
+	/* Non-rotational device?  Throw all the CPUs. */
+	rot = 1;
+	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
+	if (error == 0 && rot == 0)
+		return nproc;
+
+	/*
+	 * Sometimes we can infer the number of devices from the
+	 * min/optimal IO sizes.
+	 */
+	iomin = ioopt = 0;
+	if (ioctl(disk->d_fd, BLKIOMIN, &iomin) == 0 &&
+	    ioctl(disk->d_fd, BLKIOOPT, &ioopt) == 0 &&
+	    iomin > 0 && ioopt > 0) {
+		return min(nproc, max(1, ioopt / iomin));
+	}
+
+	/* Rotating device?  I guess? */
+	return 2;
+}
+
+/* Figure out how many disk heads are available. */
+unsigned int
+disk_heads(
+	struct disk		*disk)
+{
+	if (nr_threads)
+		return nr_threads;
+	return __disk_heads(disk);
+}
+
+/* Open a disk device and discover its geometry. */
+int
+disk_open(
+	const char		*pathname,
+	struct disk		*disk)
+{
+	int			lba_sz;
+	int			error;
+
+	disk->d_fd = open(pathname, O_RDONLY | O_DIRECT | O_NOATIME);
+	if (disk->d_fd < 0)
+		return -1;
+
+	/* Try to get LBA size. */
+	error = ioctl(disk->d_fd, BLKSSZGET, &lba_sz);
+	if (error)
+		lba_sz = 512;
+	disk->d_lbalog = libxfs_log2_roundup(lba_sz);
+
+	/* Obtain disk's stat info. */
+	error = fstat(disk->d_fd, &disk->d_sb);
+	if (error) {
+		error = errno;
+		close(disk->d_fd);
+		errno = error;
+		disk->d_fd = -1;
+		return -1;
+	}
+
+	/* Determine bdev size, block size, and offset. */
+	if (S_ISBLK(disk->d_sb.st_mode)) {
+		error = ioctl(disk->d_fd, BLKGETSIZE64, &disk->d_size);
+		if (error)
+			disk->d_size = 0;
+		error = ioctl(disk->d_fd, BLKBSZGET, &disk->d_blksize);
+		if (error)
+			disk->d_blksize = 0;
+		disk->d_start = 0;
+	} else {
+		disk->d_size = disk->d_sb.st_size;
+		disk->d_blksize = disk->d_sb.st_blksize;
+		disk->d_start = 0;
+	}
+
+	return 0;
+}
+
+/* Close a disk device. */
+int
+disk_close(
+	struct disk		*disk)
+{
+	int			error = 0;
+
+	if (disk->d_fd >= 0)
+		error = close(disk->d_fd);
+	disk->d_fd = -1;
+	return error;
+}
+
+/* Is this device open? */
+bool
+disk_is_open(
+	struct disk		*disk)
+{
+	return disk->d_fd >= 0;
+}
+
+/* Read-verify an extent of a disk device. */
+ssize_t
+disk_read_verify(
+	struct disk		*disk,
+	void			*buf,
+	uint64_t		start,
+	uint64_t		length)
+{
+	return pread(disk->d_fd, buf, length, start);
+}
diff --git a/scrub/disk.h b/scrub/disk.h
new file mode 100644
index 0000000..797fd71
--- /dev/null
+++ b/scrub/disk.h
@@ -0,0 +1,40 @@
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
+#ifndef XFS_SCRUB_DISK_H_
+#define XFS_SCRUB_DISK_H_
+
+struct disk {
+	struct stat	d_sb;
+	int		d_fd;
+	int		d_lbalog;
+	unsigned int	d_flags;
+	unsigned int	d_blksize;	/* bytes */
+	uint64_t	d_size;		/* bytes */
+	uint64_t	d_start;	/* bytes */
+};
+
+unsigned int disk_heads(struct disk *disk);
+bool disk_is_open(struct disk *disk);
+int disk_open(const char *pathname, struct disk *disk);
+int disk_close(struct disk *disk);
+ssize_t disk_read_verify(struct disk *disk, void *buf, uint64_t startblock,
+		uint64_t blockcount);
+
+#endif /* XFS_SCRUB_DISK_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index cb3d5f4..f492301 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -31,6 +31,7 @@
 #include <dirent.h>
 #include "../repair/threads.h"
 #include "path.h"
+#include "disk.h"
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
@@ -341,6 +342,58 @@ _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
 	return true;
 }
 
+/* Find filesystem geometry and perform any other setup functions. */
+static bool
+find_geo(
+	struct scrub_ctx	*ctx)
+{
+	bool			moveon;
+	int			error;
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
+	error = disk_open(ctx->blkdev, &ctx->datadev);
+	if (error && errno != ENOENT)
+		str_errno(ctx, ctx->blkdev);
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
+	if (verbose) {
+		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
+				ctx->mntpoint, scrub_nproc(ctx));
+		fflush(stdout);
+	}
+
+	return moveon;
+}
+
 /* Run all the phases of the scrubber. */
 static bool
 run_scrub_phases(
@@ -350,6 +403,7 @@ run_scrub_phases(
 	{
 		{
 			.descr = _("Find filesystem geometry."),
+			.fn = find_geo,
 			.must_run = true,
 		},
 		{
@@ -443,6 +497,7 @@ main(
 	textdomain(PACKAGE);
 
 	pthread_mutex_init(&ctx.lock, NULL);
+	ctx.datadev.d_fd = -1;
 	ctx.mode = SCRUB_MODE_DEFAULT;
 	ctx.error_action = ERRORS_CONTINUE;
 	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
@@ -527,6 +582,15 @@ _("Only one of the options -n or -y may be specified.\n"));
 
 	ctx.mntpoint = argv[optind];
 
+	/* Find the mount record for the passed-in argument. */
+	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
+		fprintf(stderr,
+			_("%s: could not stat: %s: %s\n"),
+			progname, argv[optind], strerror(errno));
+		ret = 8;
+		goto end;
+	}
+
 	/*
 	 * If the user did not specify an explicit mount table, try to use
 	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
@@ -599,8 +663,11 @@ _("%s: %llu warnings found.\n"),
 	if (ctx.runtime_errors)
 		ret |= 4;
 	phase_end(&all_pi, 0);
+	close(ctx.mnt_fd);
+	disk_close(&ctx.datadev);
 
 	free(ctx.blkdev);
 	free(ctx.mntpoint);
+end:
 	return ret;
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 669c9dc..3a776e1 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -49,12 +49,26 @@ struct scrub_ctx {
 	char			*mntpoint;
 	char			*blkdev;
 
+	/* Mountpoint info */
+	struct stat		mnt_sb;
+	struct statvfs		mnt_sv;
+	struct statfs		mnt_sf;
+
+	/* Open block devices */
+	struct disk		datadev;
+
 	/* What does the user want us to do? */
 	enum scrub_mode		mode;
 
 	/* How does the user want us to react to errors? */
 	enum error_action	error_action;
 
+	/* fd to filesystem mount point */
+	int			mnt_fd;
+
+	/* Number of threads for metadata scrubbing */
+	unsigned int		nr_io_threads;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;

