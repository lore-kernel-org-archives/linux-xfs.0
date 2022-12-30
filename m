Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B833C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbiLaAWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiLaAWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:22:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8481FBE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCF59CE1A94
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0242AC433D2;
        Sat, 31 Dec 2022 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446125;
        bh=TgFB244fqhEMJG4dxkHLWCzi/qz1JeG+As2pSS4gWSo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N3PGfGm29iYSXjfmAYXmy6np81/TMWkimny1VqLN4capoCr3tziU1WTvl5XsrD+H+
         3PmzbEu0ABbK7TCVxr6difPFwFti9kJEKX2XleRtDS44b2AIEGmeKewd5n1iDyL9gZ
         TEXT0/4QyDK9YRZmj+rqsPb4fyUYm6OdePRY7gjJOP9HMImjNHVOtaP8ohwo79i9YG
         K7Oty1m6SYXczR+6f4vh3o9BdkPoFjO5/adHJJv1oSm/0wznj1/BjMO7qxP5FgTmvm
         QD2aOjsgms+IPYXYciJ2mQCKJ7pRc06GLXu8nBsHxFWT7kxYXpDN3oit+PP4SrqBh6
         N+HtitSzggYbA==
Subject: [PATCH 13/19] libfrog: convert xfs_io swapext command to use new
 libfrog wrapper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868109.713817.8340604425330156691.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an abstraction layer for the two swapext ioctls and port xfs_io
to use it.  Now we're insulated from the differences between the XFS v0
ioctl and the new vfs ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac            |    1 
 include/builddefs.in    |    1 
 io/Makefile             |    4 +
 io/swapext.c            |   55 ++++++++-------
 libfrog/Makefile        |    6 ++
 libfrog/fiexchange.h    |  105 ++++++++++++++++++++++++++++++
 libfrog/file_exchange.c |  167 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_exchange.h |   14 ++++
 libfrog/fsgeom.h        |    6 ++
 m4/package_libcdev.m4   |   20 ++++++
 10 files changed, 352 insertions(+), 27 deletions(-)
 create mode 100644 libfrog/fiexchange.h
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h


diff --git a/configure.ac b/configure.ac
index 6c704464061..f4f1563da8b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -254,6 +254,7 @@ AC_HAVE_LIBURCU_ATOMIC64
 AC_HAVE_MEMFD_CLOEXEC
 AC_HAVE_O_TMPFILE
 AC_HAVE_MKOSTEMP_CLOEXEC
+AC_HAVE_FIEXCHANGE
 
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/include/builddefs.in b/include/builddefs.in
index 60c1320af37..c0de6000c2a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -130,6 +130,7 @@ HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 HAVE_MEMFD_CLOEXEC = @have_memfd_cloexec@
 HAVE_O_TMPFILE = @have_o_tmpfile@
 HAVE_MKOSTEMP_CLOEXEC = @have_mkostemp_cloexec@
+HAVE_FIEXCHANGE = @have_fiexchange@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/Makefile b/io/Makefile
index 498174cfc43..229f8f377b3 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -112,6 +112,10 @@ ifeq ($(HAVE_STATFS_FLAGS),yes)
 LCFLAGS += -DHAVE_STATFS_FLAGS
 endif
 
+ifeq ($(HAVE_FIEXCHANGE),yes)
+LCFLAGS += -DHAVE_FIEXCHANGE
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/swapext.c b/io/swapext.c
index a4153bb7d42..3f8a5c7b4d4 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -10,7 +10,8 @@
 #include "io.h"
 #include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
-#include "libfrog/bulkstat.h"
+#include "libfrog/fiexchange.h"
+#include "libfrog/file_exchange.h"
 
 static cmdinfo_t swapext_cmd;
 
@@ -28,47 +29,47 @@ swapext_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
-	struct xfs_bulkstat	bulkstat;
-	int			fd;
-	int			error;
-	struct xfs_swapext	sx;
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct file_xchg_range	fxr;
 	struct stat		stat;
+	uint64_t		flags = FILE_XCHG_RANGE_FILE2_FRESH |
+					FILE_XCHG_RANGE_FULL_FILES;
+	int			fd;
+	int			ret;
 
 	/* open the donor file */
 	fd = openfile(argv[1], NULL, 0, 0, NULL);
 	if (fd < 0)
 		return 0;
 
-	/*
-	 * stat the target file to get the inode number and use the latter to
-	 * get the bulkstat info for the swapext cmd.
-	 */
-	error = fstat(file->fd, &stat);
-	if (error) {
+	ret = -xfd_prepare_geometry(&xfd);
+	if (ret) {
+		xfrog_perror(ret, "xfd_prepare_geometry");
+		exitcode = 1;
+		goto out;
+	}
+
+	ret = fstat(file->fd, &stat);
+	if (ret) {
 		perror("fstat");
+		exitcode = 1;
 		goto out;
 	}
 
-	error = -xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
-	if (error) {
-		xfrog_perror(error, "bulkstat");
+	ret = xfrog_file_exchange_prep(&xfd, flags, 0, fd, 0, stat.st_size,
+			&fxr);
+	if (ret) {
+		xfrog_perror(ret, "xfrog_file_exchange_prep");
+		exitcode = 1;
 		goto out;
 	}
-	error = -xfrog_bulkstat_v5_to_v1(&fxfd, &sx.sx_stat, &bulkstat);
-	if (error) {
-		xfrog_perror(error, "bulkstat conversion");
+
+	ret = xfrog_file_exchange(&xfd, &fxr);
+	if (ret) {
+		xfrog_perror(ret, "swapext");
+		exitcode = 1;
 		goto out;
 	}
-	sx.sx_version = XFS_SX_VERSION;
-	sx.sx_fdtarget = file->fd;
-	sx.sx_fdtmp = fd;
-	sx.sx_offset = 0;
-	sx.sx_length = stat.st_size;
-	error = ioctl(file->fd, XFS_IOC_SWAPEXT, &sx);
-	if (error)
-		perror("swapext");
-
 out:
 	close(fd);
 	return 0;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 0110708239a..66d2afe56fe 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -18,6 +18,7 @@ bitmap.c \
 bulkstat.c \
 convert.c \
 crc32.c \
+file_exchange.c \
 fsgeom.c \
 list_sort.c \
 linux.c \
@@ -39,6 +40,7 @@ crc32c.h \
 crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
+file_exchange.h \
 fsgeom.h \
 logging.h \
 paths.h \
@@ -54,6 +56,10 @@ ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
+ifeq ($(HAVE_FIEXCHANGE),yes)
+LCFLAGS += -DHAVE_FIEXCHANGE
+endif
+
 LDIRT = gen_crc32table crc32table.h crc32selftest
 
 default: crc32selftest ltdepend $(LTLIBRARY)
diff --git a/libfrog/fiexchange.h b/libfrog/fiexchange.h
new file mode 100644
index 00000000000..04ec42777d7
--- /dev/null
+++ b/libfrog/fiexchange.h
@@ -0,0 +1,105 @@
+#ifdef HAVE_FIEXCHANGE
+# include <linux/fiexchange.h>
+#endif
+
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
+/*
+ * FIEXCHANGE ioctl definitions, to facilitate exchanging parts of files.
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef _LINUX_FIEXCHANGE_H
+#define _LINUX_FIEXCHANGE_H
+
+#include <linux/types.h>
+
+/*
+ * Exchange part of file1 with part of the file that this ioctl that is being
+ * called against (which we'll call file2).  Filesystems must be able to
+ * restart and complete the operation even after the system goes down.
+ */
+struct file_xchg_range {
+	__s64		file1_fd;
+	__s64		file1_offset;	/* file1 offset, bytes */
+	__s64		file2_offset;	/* file2 offset, bytes */
+	__s64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see FILE_XCHG_RANGE_* below */
+
+	/* file2 metadata for optional freshness checks */
+	__s64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+
+	__u64		pad[6];		/* must be zeroes */
+};
+
+/*
+ * Atomic exchange operations are not required.  This relaxes the requirement
+ * that the filesystem must be able to complete the operation after a crash.
+ */
+#define FILE_XCHG_RANGE_NONATOMIC	(1 << 0)
+
+/*
+ * Check that file2's inode number, mtime, and ctime against the values
+ * provided, and return -EBUSY if there isn't an exact match.
+ */
+#define FILE_XCHG_RANGE_FILE2_FRESH	(1 << 1)
+
+/*
+ * Check that the file1's length is equal to file1_offset + length, and that
+ * file2's length is equal to file2_offset + length.  Returns -EDOM if there
+ * isn't an exact match.
+ */
+#define FILE_XCHG_RANGE_FULL_FILES	(1 << 2)
+
+/*
+ * Exchange file data all the way to the ends of both files, and then exchange
+ * the file sizes.  This flag can be used to replace a file's contents with a
+ * different amount of data.  length will be ignored.
+ */
+#define FILE_XCHG_RANGE_TO_EOF		(1 << 3)
+
+/* Flush all changes in file data and file metadata to disk before returning. */
+#define FILE_XCHG_RANGE_FSYNC		(1 << 4)
+
+/* Dry run; do all the parameter verification but do not change anything. */
+#define FILE_XCHG_RANGE_DRY_RUN		(1 << 5)
+
+/*
+ * Do not exchange any part of the range where file1's mapping is a hole.  This
+ * can be used to emulate scatter-gather atomic writes with a temp file.
+ */
+#define FILE_XCHG_RANGE_SKIP_FILE1_HOLES (1 << 6)
+
+/*
+ * Commit the contents of file1 into file2 if file2 has the same inode number,
+ * mtime, and ctime as the arguments provided to the call.  The old contents of
+ * file2 will be moved to file1.
+ *
+ * With this flag, all committed information can be retrieved even if the
+ * system crashes or is rebooted.  This includes writing through or flushing a
+ * disk cache if present.  The call blocks until the device reports that the
+ * commit is complete.
+ *
+ * This flag should not be combined with NONATOMIC.  It can be combined with
+ * SKIP_FILE1_HOLES.
+ */
+#define FILE_XCHG_RANGE_COMMIT		(FILE_XCHG_RANGE_FILE2_FRESH | \
+					 FILE_XCHG_RANGE_FSYNC)
+
+#define FILE_XCHG_RANGE_ALL_FLAGS	(FILE_XCHG_RANGE_NONATOMIC | \
+					 FILE_XCHG_RANGE_FILE2_FRESH | \
+					 FILE_XCHG_RANGE_FULL_FILES | \
+					 FILE_XCHG_RANGE_TO_EOF | \
+					 FILE_XCHG_RANGE_FSYNC | \
+					 FILE_XCHG_RANGE_DRY_RUN | \
+					 FILE_XCHG_RANGE_SKIP_FILE1_HOLES)
+
+#define FIEXCHANGE_RANGE	_IOWR('X', 129, struct file_xchg_range)
+
+#endif /* _LINUX_FIEXCHANGE_H */
diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
new file mode 100644
index 00000000000..00277f8f0fc
--- /dev/null
+++ b/libfrog/file_exchange.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <string.h>
+#include "xfs.h"
+#include "fsgeom.h"
+#include "bulkstat.h"
+#include "fiexchange.h"
+#include "file_exchange.h"
+
+/* Prepare the freshness component of a swapext request. */
+static int
+xfrog_file_exchange_prep_freshness(
+	struct xfs_fd		*dest,
+	struct file_xchg_range	*req)
+{
+	struct stat		stat;
+	struct xfs_bulkstat	bulkstat;
+	int			error;
+
+	error = fstat(dest->fd, &stat);
+	if (error)
+		return -errno;
+	req->file2_ino = stat.st_ino;
+
+	/*
+	 * Try to fill out the [cm]time data from bulkstat.  We prefer this
+	 * approach because bulkstat v5 gives us 64-bit time even on 32-bit.
+	 *
+	 * However, we'll take our chances on the C library if the filesystem
+	 * supports 64-bit time but we ended up with bulkstat v5 emulation.
+	 */
+	error = xfrog_bulkstat_single(dest, stat.st_ino, 0, &bulkstat);
+	if (!error &&
+	    !((dest->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_BIGTIME) &&
+	      bulkstat.bs_version < XFS_BULKSTAT_VERSION_V5)) {
+		req->file2_mtime = bulkstat.bs_mtime;
+		req->file2_ctime = bulkstat.bs_ctime;
+		req->file2_mtime_nsec = bulkstat.bs_mtime_nsec;
+		req->file2_ctime_nsec = bulkstat.bs_ctime_nsec;
+		return 0;
+	}
+
+	/* Otherwise, use the stat information and hope for the best. */
+	req->file2_mtime = stat.st_mtime;
+	req->file2_ctime = stat.st_ctime;
+	req->file2_mtime_nsec = stat.st_mtim.tv_nsec;
+	req->file2_ctime_nsec = stat.st_ctim.tv_nsec;
+	return 0;
+}
+
+/* Prepare an extent swap request. */
+int
+xfrog_file_exchange_prep(
+	struct xfs_fd		*dest,
+	uint64_t		flags,
+	int64_t			file2_offset,
+	int			file1_fd,
+	int64_t			file1_offset,
+	int64_t			length,
+	struct file_xchg_range	*req)
+{
+	memset(req, 0, sizeof(*req));
+	req->file1_fd = file1_fd;
+	req->file1_offset = file1_offset;
+	req->length = length;
+	req->file2_offset = file2_offset;
+	req->flags = flags;
+
+	if (flags & FILE_XCHG_RANGE_FILE2_FRESH)
+		return xfrog_file_exchange_prep_freshness(dest, req);
+
+	return 0;
+}
+
+/* Swap two files' extents with the vfs swaprange ioctl. */
+static int
+xfrog_file_exchange_vfs(
+	struct xfs_fd		*xfd,
+	struct file_xchg_range	*req)
+{
+	int			ret;
+
+	ret = ioctl(xfd->fd, FIEXCHANGE_RANGE, req);
+	if (ret) {
+		/* the old swapext ioctl returned EFAULT for bad length */
+		if (errno == EDOM)
+			return -EFAULT;
+		return -errno;
+	}
+	return 0;
+}
+
+/*
+ * The old swapext ioctl did not provide atomic swap; it required that the
+ * supplied offset and length matched both files' lengths; and it also required
+ * that the sx_stat information match the dest file.  It doesn't support any
+ * other flags.
+ */
+#define FILE_XCHG_RANGE_SWAPEXT0	(FILE_XCHG_RANGE_NONATOMIC | \
+					 FILE_XCHG_RANGE_FULL_FILES | \
+					 FILE_XCHG_RANGE_FILE2_FRESH)
+
+/* Swap two files' extents with the old xfs swaprange ioctl. */
+static int
+xfrog_file_exchange0(
+	struct xfs_fd		*xfd,
+	struct file_xchg_range	*req)
+{
+	struct xfs_swapext	sx = {
+		.sx_version	= XFS_SX_VERSION,
+		.sx_fdtarget	= xfd->fd,
+		.sx_fdtmp	= req->file1_fd,
+		.sx_length	= req->length,
+	};
+	int			ret;
+
+	if (req->file1_offset != req->file2_offset)
+		return -EINVAL;
+	if (req->flags != FILE_XCHG_RANGE_SWAPEXT0)
+		return -EOPNOTSUPP;
+
+	sx.sx_stat.bs_ino = req->file2_ino;
+	sx.sx_stat.bs_ctime.tv_sec = req->file2_ctime;
+	sx.sx_stat.bs_ctime.tv_nsec = req->file2_ctime_nsec;
+	sx.sx_stat.bs_mtime.tv_sec = req->file2_mtime;
+	sx.sx_stat.bs_mtime.tv_nsec = req->file2_mtime_nsec;
+
+	ret = ioctl(xfd->fd, XFS_IOC_SWAPEXT, &sx);
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+/* Swap extents between an XFS file and a donor fd. */
+int
+xfrog_file_exchange(
+	struct xfs_fd		*xfd,
+	struct file_xchg_range	*req)
+{
+	int			error;
+
+	if (xfd->flags & XFROG_FLAG_FORCE_SWAPEXT)
+		goto try_v1;
+
+	error = xfrog_file_exchange_vfs(xfd, req);
+	if ((error != -ENOTTY && error != -EOPNOTSUPP) ||
+	    (xfd->flags & XFROG_FLAG_FORCE_FIEXCHANGE))
+		return error;
+
+	/* If the vfs ioctl wasn't found, we punt to v0. */
+	switch (error) {
+	case -EOPNOTSUPP:
+	case -ENOTTY:
+		xfd->flags |= XFROG_FLAG_FORCE_SWAPEXT;
+		break;
+	}
+
+try_v1:
+	return xfrog_file_exchange0(xfd, req);
+}
diff --git a/libfrog/file_exchange.h b/libfrog/file_exchange.h
new file mode 100644
index 00000000000..a77d67514e8
--- /dev/null
+++ b/libfrog/file_exchange.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022 Oracle. Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_FILE_EXCHANGE_H__
+#define __LIBFROG_FILE_EXCHANGE_H__
+
+int xfrog_file_exchange_prep(struct xfs_fd *file2, uint64_t flags,
+		int64_t file2_offset, int file1_fd, int64_t file1_offset,
+		int64_t length, struct file_xchg_range *req);
+int xfrog_file_exchange(struct xfs_fd *xfd, struct file_xchg_range *req);
+
+#endif	/* __LIBFROG_FILE_EXCHANGE_H__ */
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index ca38324e853..9dfa986ff08 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -50,6 +50,12 @@ struct xfs_fd {
 /* Only use v5 bulkstat/inumbers ioctls. */
 #define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
 
+/* Only use the old XFS swapext ioctl for file data exchanges. */
+#define XFROG_FLAG_FORCE_SWAPEXT	(1 << 2)
+
+/* Only use FIEXCHANGE_RANGE for file data exchanges. */
+#define XFROG_FLAG_FORCE_FIEXCHANGE	(1 << 3)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 119d1bda74d..062730a1f06 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -557,3 +557,23 @@ AC_DEFUN([AC_HAVE_MKOSTEMP_CLOEXEC],
        AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
     AC_SUBST(have_mkostemp_cloexec)
   ])
+
+#
+# Check if we have a FIEXCHANGE_RANGE ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_FIEXCHANGE],
+  [ AC_MSG_CHECKING([for FIEXCHANGE_RANGE])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/fiexchange.h>
+    ]], [[
+         struct file_xchg_range fxr;
+         ioctl(-1, FIEXCHANGE_RANGE, &fxr);
+    ]])],[have_fiexchange=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_fiexchange)
+  ])

