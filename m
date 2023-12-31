Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FACC8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4ehAoW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B20C433C8;
	Sun, 31 Dec 2023 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061842;
	bh=KbI2zZj+pu4iq7XYYj1vMzH7fiOD8HnB1h1tXFvANPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A4ehAoW6VQpdBVCI8Vwf84PbaBicvKJ73A/piHEV4L1qg3o7xDWP3hC9DgFAnQ7bH
	 glRCFdikr4lnu37Hx5xKeWQwOprcj42akdsy3LdFrG8imkOhEiYhGvLM96V58SD17x
	 AJFO37TjleGWXyy+MS0ZBKIuTs9AQbehZZsId8FbjqUXGpW9GVBJPgSV/+KDIPvZ1C
	 rXlqPR0O7MQkvSOxKO8dkp5Vr0gdRNl1ohj15p2XYYS+mj/yfcV4BqMkkiapLCcM66
	 vr41TxxfeRaShNDUOBnKaPzo2YyAcmnbsggf0pzkA5J+b+lEzboe6brK6rjNSkwKcO
	 QTDOLTarEGJ2g==
Date: Sun, 31 Dec 2023 14:30:42 -0800
Subject: [PATCH 14/20] libfrog: convert xfs_io swapext command to use new
 libfrog wrapper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996462.1796128.4278002541789320850.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Create an abstraction layer for the two swapext ioctls and port xfs_io
to use it.  Now we're insulated from the differences between the XFS v0
ioctl and the new vfs ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/swapext.c            |   54 ++++++++-------
 libfrog/Makefile        |    2 +
 libfrog/file_exchange.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_exchange.h |   14 ++++
 libfrog/fsgeom.h        |    6 ++
 5 files changed, 218 insertions(+), 27 deletions(-)
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h


diff --git a/io/swapext.c b/io/swapext.c
index a4153bb7d42..15ed3559398 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -10,7 +10,7 @@
 #include "io.h"
 #include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
-#include "libfrog/bulkstat.h"
+#include "libfrog/file_exchange.h"
 
 static cmdinfo_t swapext_cmd;
 
@@ -28,47 +28,47 @@ swapext_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
-	struct xfs_bulkstat	bulkstat;
-	int			fd;
-	int			error;
-	struct xfs_swapext	sx;
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_exch_range	fxr;
 	struct stat		stat;
+	uint64_t		flags = XFS_EXCH_RANGE_FILE2_FRESH |
+					XFS_EXCH_RANGE_FULL_FILES;
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
index dcfd1fb8a93..f8bb39f2712 100644
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
@@ -42,6 +43,7 @@ crc32defs.h \
 crc32table.h \
 dahashselftest.h \
 div64.h \
+file_exchange.h \
 fsgeom.h \
 logging.h \
 paths.h \
diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
new file mode 100644
index 00000000000..4a66aa752fc
--- /dev/null
+++ b/libfrog/file_exchange.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "file_exchange.h"
+
+/* Prepare the freshness component of a swapext request. */
+static int
+xfrog_file_exchange_prep_freshness(
+	struct xfs_fd		*dest,
+	struct xfs_exch_range	*req)
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
+	struct xfs_exch_range	*req)
+{
+	memset(req, 0, sizeof(*req));
+	req->file1_fd = file1_fd;
+	req->file1_offset = file1_offset;
+	req->length = length;
+	req->file2_offset = file2_offset;
+	req->flags = flags;
+
+	if (flags & XFS_EXCH_RANGE_FILE2_FRESH)
+		return xfrog_file_exchange_prep_freshness(dest, req);
+
+	return 0;
+}
+
+/* Swap two files' extents with the new exchange range ioctl. */
+static int
+xfrog_file_exchange_range(
+	struct xfs_fd		*xfd,
+	struct xfs_exch_range	*req)
+{
+	int			ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_EXCHANGE_RANGE, req);
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
+#define XFS_EXCH_RANGE_SWAPEXT	(XFS_EXCH_RANGE_NONATOMIC | \
+				 XFS_EXCH_RANGE_FULL_FILES | \
+				 XFS_EXCH_RANGE_FILE2_FRESH)
+
+/* Swap two files' extents with the old xfs swapext ioctl. */
+static int
+xfrog_file_exchange_swapext(
+	struct xfs_fd		*xfd,
+	struct xfs_exch_range	*req)
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
+	if (req->flags != XFS_EXCH_RANGE_SWAPEXT)
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
+	struct xfs_exch_range	*req)
+{
+	int			error;
+
+	if (xfd->flags & XFROG_FLAG_FORCE_SWAPEXT)
+		goto try_swapext;
+
+	error = xfrog_file_exchange_range(xfd, req);
+	if ((error != -ENOTTY && error != -EOPNOTSUPP) ||
+	    (xfd->flags & XFROG_FLAG_FORCE_EXCH_RANGE))
+		return error;
+
+	/*
+	 * If the new exchange range ioctl wasn't found, punt to the old
+	 * swapext ioctl.
+	 */
+	switch (error) {
+	case -EOPNOTSUPP:
+	case -ENOTTY:
+		xfd->flags |= XFROG_FLAG_FORCE_SWAPEXT;
+		break;
+	}
+
+try_swapext:
+	return xfrog_file_exchange_swapext(xfd, req);
+}
diff --git a/libfrog/file_exchange.h b/libfrog/file_exchange.h
new file mode 100644
index 00000000000..7b6ce11810b
--- /dev/null
+++ b/libfrog/file_exchange.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All rights reserved.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_FILE_EXCHANGE_H__
+#define __LIBFROG_FILE_EXCHANGE_H__
+
+int xfrog_file_exchange_prep(struct xfs_fd *file2, uint64_t flags,
+		int64_t file2_offset, int file1_fd, int64_t file1_offset,
+		int64_t length, struct xfs_exch_range *req);
+int xfrog_file_exchange(struct xfs_fd *xfd, struct xfs_exch_range *req);
+
+#endif	/* __LIBFROG_FILE_EXCHANGE_H__ */
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index ca38324e853..2ff748caaf4 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -50,6 +50,12 @@ struct xfs_fd {
 /* Only use v5 bulkstat/inumbers ioctls. */
 #define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
 
+/* Only use XFS_IOC_SWAPEXT for file data exchanges. */
+#define XFROG_FLAG_FORCE_SWAPEXT	(1 << 2)
+
+/* Only use XFS_IOC_EXCHANGE_RANGE for file data exchanges. */
+#define XFROG_FLAG_FORCE_EXCH_RANGE	(1 << 3)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)

