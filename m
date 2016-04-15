Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A7217CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 23:46:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CACA304032
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 21:46:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vYeanLktXBqzGfkY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 21:46:07 -0700 (PDT)
Date: Thu, 14 Apr 2016 21:45:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC] xfs_scrub: create online filesystem scrub program
Message-ID: <20160415044553.GE18517@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Create a toy filesystem scrubbing tool that walks the directory tree,
queries every file's extents, extended attributes, and stat data.  For
generic (non-XFS) filesystems this depends on the kernel to do nearly
all the validation.  Optionally, we can (try to) read all the file
data.

Future XFS extensions to this program will perform much stronger
metadata checking and cross-referencing.  In the future we might be
able to do such things like lock a directory, check the entries and
back pointers, and unlock it; or lock an inode to check the extent map
and cross-reference the entries therein with a reverse-mapping index.

However, this tool /should/ work for most non-XFS filesystems.  I've
done rough testing on XFS, ext4, fuse-NTFS, vfat, hfsplus, and iso,
and it seems to run reasonably well.  In any case, let's discuss at LSF.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile             |    2 
 man/man8/xfs_scrub.8 |   82 +++++
 scrub/Makefile       |   26 ++
 scrub/generic.c      |  370 +++++++++++++++++++++++
 scrub/scrub.c        |  816 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h        |   98 ++++++
 scrub/xfs.c          |  239 +++++++++++++++
 7 files changed, 1632 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/generic.c
 create mode 100644 scrub/scrub.c
 create mode 100644 scrub/scrub.h
 create mode 100644 scrub/xfs.c

diff --git a/Makefile b/Makefile
index b6cda36..cf5ccc2 100644
--- a/Makefile
+++ b/Makefile
@@ -46,7 +46,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian
+		mdrestore repair rtcp m4 man doc debian scrub
 
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
new file mode 100644
index 0000000..95d7169
--- /dev/null
+++ b/man/man8/xfs_scrub.8
@@ -0,0 +1,82 @@
+.TH xfs_scrub 8
+.SH NAME
+xfs_scrub \- scrub the contents of an XFS filesystem
+.SH SYNOPSIS
+.B xfs_scrub
+[
+.B \-dvx
+] [
+.B \-t
+.I fstype
+]
+.I mountpoint
+.br
+.B xfs_scrub \-V
+.SH DESCRIPTION
+.B xfs_scrub
+attempts to read and check all the metadata in a Linux filesystem.
+.PP
+If
+.B xfs_scrub
+does not detect an XFS filesystem, it will use a generic backend to
+scrub the filesystem.  This involves walking the directory tree,
+querying the data and extended attribute extent maps, performing
+limited checks of directory and inode data, reading all of an
+inode's extended attributes, and optionally reading all data in
+a file.
+.PP
+If an XFS filesystem is detected, then
+.B xfs_scrub
+will use private XFS ioctls and sysfs interfaces to perform more
+rigorous scrubbing of the internal metadata.  Currently this is
+limited to asking the kernel to check the per-AG btrees, which
+also performs limited cross-referencing.
+.SH OPTIONS
+.TP
+.B \-d
+Enable debugging mode, which augments error reports with the exact file
+and line where the scrub failure occurred.  This also enables verbose
+mode.
+.TP
+.B \-v
+Enable verbose mode, which prints periodic status updates.
+.TP
+.BI \-t " fstype"
+Force the use of a particular type of filesystem scrubber.  Currently
+supported backends are
+.I xfs
+and
+.I generic
+scrubbers.
+.TP
+.B \-V
+Prints the version number and exits.
+.TP
+.B \-x
+Scrub file data.  This reads every block of every file on disk.
+.SH EXIT CODE
+The exit code returned by
+.B xfs_scrub
+is the sum of the following conditions:
+.br
+\	0\	\-\ No errors
+.br
+\	4\	\-\ File system errors left uncorrected
+.br
+\	8\	\-\ Operational error
+.br
+\	16\	\-\ Usage or syntax error
+.br
+.SH CAVEATS
+.B xfs_scrub
+is a very immature utility!  The generic scrub backend walks the directory
+tree, reads file extents and data, and queries every extended attribute it
+can find.  The generic scrub does not grab exclusive locks on the objects
+it is examining, nor does it have any way to cross-reference what it sees
+against the internal filesystem metadata.
+.PP
+The XFS backend will some day learn how to do all those things, but for
+now its only advantage over the generic backend is that it knows how to
+ask the kernel to perform a basic scrub of the XFS AG metadata.
+.SH SEE ALSO
+.BR xfs_repair (8).
diff --git a/scrub/Makefile b/scrub/Makefile
new file mode 100644
index 0000000..52b2838
--- /dev/null
+++ b/scrub/Makefile
@@ -0,0 +1,26 @@
+#
+# Copyright (c) 2016 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = xfs_scrub
+
+HFILES = scrub.h
+CFILES = scrub.c generic.c xfs.c
+
+LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LTDEPENDENCIES += $(LIBXFS)
+LLDFLAGS = -static-libtool-libs
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+install-dev:
+
+-include .dep
diff --git a/scrub/generic.c b/scrub/generic.c
new file mode 100644
index 0000000..eeff85a
--- /dev/null
+++ b/scrub/generic.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2016 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <attr/xattr.h>
+#include "libxfs.h"
+#include "scrub.h"
+
+/* Routines to scrub a generic filesystem with nothing but the VFS. */
+
+bool
+generic_scan_fs(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+bool
+generic_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+bool
+generic_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+bool
+generic_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Check all entries in a directory. */
+bool
+generic_check_dir(
+	struct scrub_ctx	*ctx,
+	int			dir_fd)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Check an inode's extents... the hard way. */
+static bool
+generic_scan_extents_fibmap(
+	struct scrub_ctx	*ctx,
+	int			fd,
+	struct stat64		*sb)
+{
+	unsigned int		blk;
+	unsigned int		b;
+	off_t			numblocks;
+	int			error;
+
+	if (!(ctx->quirks & SCRUB_QUIRK_FIBMAP_WORKS))
+		return true;
+
+	numblocks = (sb->st_size + sb->st_blksize - 1) / sb->st_blksize;
+	if (numblocks > UINT_MAX)
+		numblocks = UINT_MAX;
+	for (blk = 0; blk < numblocks; blk++) {
+		b = blk;
+		error = ioctl(fd, FIBMAP, &b);
+		if (error) {
+			if (errno == EOPNOTSUPP) {
+				path_warn(ctx,
+_("data block FIEMAP/FIBMAP not supported, will not check extent map."));
+				ctx->quirks &= ~SCRUB_QUIRK_FIBMAP_WORKS;
+				return true;
+			}
+			path_errno(ctx);
+		}
+	}
+
+	return true;
+}
+
+/* Check an inode's extents. */
+#define NR_EXTENTS	512
+bool
+generic_scan_extents(
+	struct scrub_ctx	*ctx,
+	int			fd,
+	struct stat64		*sb,
+	bool			attr_fork)
+{
+	struct fiemap		*fiemap;
+	size_t			sz;
+	struct fiemap_extent	*extent;
+	__u64			next_logical;
+	bool			last = false;
+	int			error;
+	unsigned int		i;
+
+	/* FIEMAP only works for files. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+
+	if (!attr_fork && !(ctx->quirks & SCRUB_QUIRK_FIEMAP_WORKS))
+		return generic_scan_extents_fibmap(ctx, fd, sb);
+	else if (attr_fork && !(ctx->quirks & SCRUB_QUIRK_FIEMAP_ATTR_WORKS))
+		return true;
+
+	sz = sizeof(struct fiemap) + sizeof(struct fiemap_extent) * NR_EXTENTS;
+	fiemap = calloc(sz, 1);
+	if (!fiemap) {
+		path_errno(ctx);
+		return false;
+	}
+
+	fiemap->fm_length = ~0ULL;
+	fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+	if (attr_fork)
+		fiemap->fm_flags |= FIEMAP_FLAG_XATTR;
+	fiemap->fm_extent_count = NR_EXTENTS;
+	fiemap->fm_reserved = 0;
+	next_logical = 0;
+
+	while (!last) {
+		fiemap->fm_start = next_logical;
+		error = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+		if (error < 0 && errno == EOPNOTSUPP) {
+			if (attr_fork) {
+				path_warn(ctx,
+_("extended attribute FIEMAP not supported, will not check extent map."));
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_WORKS;
+			} else
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_ATTR_WORKS;
+			break;
+		}
+		if (error < 0) {
+			path_errno(ctx);
+			break;
+		}
+
+		/* No more extents to map, exit */
+		if (!fiemap->fm_mapped_extents)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			extent = &fiemap->fm_extents[i];
+
+			if (extent->fe_length == 0)
+				path_error(ctx,
+_("zero-length extent at offset %llu\n"),
+					extent->fe_logical);
+
+			next_logical = extent->fe_logical + extent->fe_length;
+			if (extent->fe_flags & FIEMAP_EXTENT_LAST)
+				last = true;
+		}
+	}
+
+	free(fiemap);
+	return true;
+}
+
+/* Check the fields of an inode. */
+bool
+generic_check_inode(
+	struct scrub_ctx	*ctx,
+	int			fd,
+	struct stat64		*sb)
+{
+	if (sb->st_nlink == 0)
+		path_error(ctx,
+_("nlinks should not be 0."));
+
+	return true;
+}
+
+/* Try to read all the extended attributes. */
+bool
+generic_scan_xattrs(
+	struct scrub_ctx	*ctx,
+	int			fd)
+{
+	char			*buf = NULL;
+	char			*p;
+	ssize_t			buf_sz;
+	ssize_t			sz;
+	char			*valbuf = NULL;
+	ssize_t			valbuf_sz = 0;
+	ssize_t			val_sz;
+	ssize_t			sz2;
+	bool			moveon = true;
+	char			*x;
+
+	buf_sz = flistxattr(fd, NULL, 0);
+	if (buf_sz == -EOPNOTSUPP)
+		return true;
+	else if (buf_sz == 0)
+		return true;
+	else if (buf_sz < 0) {
+		path_errno(ctx);
+		return true;
+	}
+
+	buf = malloc(buf_sz);
+	if (!buf) {
+		path_errno(ctx);
+		return false;
+	}
+
+	sz = flistxattr(fd, buf, buf_sz);
+	if (sz < 0) {
+		path_errno(ctx);
+		goto out;
+	} else if (sz != buf_sz) {
+		path_error(ctx,
+_("read %zu bytes of xattr names, expected %zu bytes."),
+				sz, buf_sz);
+	}
+
+	/* Read all the attrs and values. */
+	for (p = buf; p < buf + sz; p += strlen(p) + 1) {
+		val_sz = fgetxattr(fd, p, NULL, 0);
+		if (val_sz < 0) {
+			if (errno != ENODATA)
+				path_errno(ctx);
+			continue;
+		}
+		if (val_sz > valbuf_sz) {
+			x = realloc(valbuf, val_sz);
+			if (!x) {
+				path_errno(ctx);
+				moveon = false;
+				break;
+			}
+			valbuf = x;
+			valbuf_sz = val_sz;
+		}
+		sz2 = fgetxattr(fd, p, valbuf, val_sz);
+		if (sz2 < 0) {
+			path_errno(ctx);
+			continue;
+		} else if (sz2 != val_sz)
+			path_error(ctx,
+_("read %zu bytes from xattr %s value, expected %zu bytes."),
+					sz2, p, val_sz);
+	}
+out:
+	free(valbuf);
+	free(buf);
+	return moveon;
+}
+
+/* Try to read all the extended attributes of things that have no fd. */
+bool
+generic_scan_special_xattrs(
+	struct scrub_ctx	*ctx)
+{
+	char			*buf = NULL;
+	char			*p;
+	ssize_t			buf_sz;
+	ssize_t			sz;
+	char			*valbuf = NULL;
+	ssize_t			valbuf_sz = 0;
+	ssize_t			val_sz;
+	ssize_t			sz2;
+	bool			moveon = true;
+	char			*x;
+	char			path[PATH_MAX];
+	int			error;
+
+	/* Construct the full path to this file. */
+	error = construct_path(ctx, path, PATH_MAX);
+	if (error) {
+		path_errno(ctx);
+		return false;
+	}
+
+	buf_sz = llistxattr(path, NULL, 0);
+	if (buf_sz == -EOPNOTSUPP)
+		return true;
+	else if (buf_sz == 0)
+		return true;
+	else if (buf_sz < 0) {
+		path_errno(ctx);
+		return true;
+	}
+
+	buf = malloc(buf_sz);
+	if (!buf) {
+		path_errno(ctx);
+		return false;
+	}
+
+	sz = llistxattr(path, buf, buf_sz);
+	if (sz < 0) {
+		path_errno(ctx);
+		goto out;
+	} else if (sz != buf_sz) {
+		path_error(ctx,
+_("read %zu bytes of xattr names, expected %zu bytes."),
+				sz, buf_sz);
+	}
+
+	/* Read all the attrs and values. */
+	for (p = buf; p < buf + sz; p += strlen(p) + 1) {
+		val_sz = lgetxattr(path, p, NULL, 0);
+		if (val_sz < 0) {
+			path_errno(ctx);
+			continue;
+		}
+		if (val_sz > valbuf_sz) {
+			x = realloc(valbuf, val_sz);
+			if (!x) {
+				path_errno(ctx);
+				moveon = false;
+				break;
+			}
+			valbuf = x;
+			valbuf_sz = val_sz;
+		}
+		sz2 = lgetxattr(path, p, valbuf, val_sz);
+		if (sz2 < 0) {
+			path_errno(ctx);
+			continue;
+		} else if (sz2 != val_sz)
+			path_error(ctx,
+_("read %zu bytes from xattr %s value, expected %zu bytes."),
+					sz2, p, val_sz);
+	}
+out:
+	free(valbuf);
+	free(buf);
+	return moveon;
+}
+
+struct scrub_ops generic_scrub_ops = {
+	.name			= "generic",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= generic_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+};
diff --git a/scrub/scrub.c b/scrub/scrub.c
new file mode 100644
index 0000000..035b474
--- /dev/null
+++ b/scrub/scrub.c
@@ -0,0 +1,816 @@
+/*
+ * Copyright (c) 2016 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
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
+#include "scrub.h"
+
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
+bool				verbose;
+bool				debug;
+bool				scrub_data;
+
+static void __attribute__((noreturn))
+usage( void )
+{
+	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
+	fprintf(stderr, _("-d:\tRun program in debug mode.\n"));
+	fprintf(stderr, _("-t:\tUse this filesystem backend for scrubbing.\n"));
+	fprintf(stderr, _("-v:\tVerbose output.\n"));
+	fprintf(stderr, _("-x:\tScrub file data too.\n"));
+
+	exit(16);
+}
+
+/*
+ * Check if the argument is either the device name or mountpoint of a mounted
+ * filesystem.
+ */
+static bool
+find_mountpoint_check(struct stat64 *sb, struct mntent *t)
+{
+	struct stat64 ms;
+
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return false;
+		if (sb->st_ino != ms.st_ino)
+			return false;
+		if (sb->st_dev != ms.st_dev)
+			return false;
+		/*
+		 * Make sure the device given by mtab is accessible
+		 * before using it.
+		 */
+		if (stat64(t->mnt_fsname, &ms) < 0)
+			return false;
+	} else {				/* device */
+		if (stat64(t->mnt_fsname, &ms) < 0)
+			return false;
+		if (sb->st_rdev != ms.st_rdev)
+			return false;
+		/*
+		 * Make sure the mountpoint given by mtab is accessible
+		 * before using it.
+		 */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return false;
+	}
+
+	return true;
+}
+
+/* Check that our alleged mountpoint is in mtab */
+static bool
+find_mountpoint(char *mtab, struct stat64 *sb, struct mntent *mnt)
+{
+	struct mntent_cursor cursor;
+	struct mntent *t = NULL;
+	bool found = false;
+
+	if (platform_mntent_open(&cursor, mtab) != 0){
+		fprintf(stderr, "Error: can't get mntent entries.\n");
+		exit(1);
+	}
+
+	while ((t = platform_mntent_next(&cursor)) != NULL) {
+		if (find_mountpoint_check(sb, t)) {
+			*mnt = *t;
+			found = true;
+			break;
+		}
+	}
+	platform_mntent_close(&cursor);
+	return found;
+}
+
+/* Print a string and whatever error is stored in errno. */
+void
+__str_errno(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line)
+{
+	char			buf[256];
+
+	fprintf(stderr, "%s: %s.", str, strerror_r(errno, buf, 256));
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+}
+
+/* Print a string and some error text. */
+void
+__str_error(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	fprintf(stderr, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+}
+
+/* Print a string and some warning text. */
+void
+__str_warn(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	fprintf(stderr, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->warnings_found++;
+}
+
+/* Print the current path and whatever error is stored in errno. */
+void
+__path_errno(
+	struct scrub_ctx	*ctx,
+	const char		*file,
+	int			line)
+{
+	char			buf[256];
+	struct list_head	*l;
+	struct path_piece	*pp;
+	int			err;
+
+	err = errno;
+	fprintf(stderr, "%s", ctx->mntpoint);
+	list_for_each(l, &ctx->path_stack) {
+		pp = container_of(l, struct path_piece, list);
+		fprintf(stderr, "/%s", pp->name);
+	}
+	fprintf(stderr, ": %s.", strerror_r(err, buf, 256));
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+}
+
+/* Print the current path and some error text. */
+void
+__path_error(
+	struct scrub_ctx	*ctx,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+	struct list_head	*l;
+	struct path_piece	*pp;
+
+	fprintf(stderr, "%s", ctx->mntpoint);
+	list_for_each(l, &ctx->path_stack) {
+		pp = container_of(l, struct path_piece, list);
+		fprintf(stderr, "/%s", pp->name);
+	}
+	fprintf(stderr, ": ");
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+}
+
+/* Print the current path and some warning text. */
+void
+__path_warn(
+	struct scrub_ctx	*ctx,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+	struct list_head	*l;
+	struct path_piece	*pp;
+
+	fprintf(stderr, "%s", ctx->mntpoint);
+	list_for_each(l, &ctx->path_stack) {
+		pp = container_of(l, struct path_piece, list);
+		fprintf(stderr, "/%s", pp->name);
+	}
+	fprintf(stderr, ": ");
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->warnings_found++;
+}
+
+/* Construct the current path. */
+int
+construct_path(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen)
+{
+	size_t			nr = 0;
+	struct list_head	*l;
+	struct path_piece	*pp;
+	int			sz;
+
+	/* Mountpoint */
+	sz = snprintf(buf + nr, buflen - nr, "%s", ctx->mntpoint);
+	if (sz < 0)
+		return -1;
+	else if(sz > buflen - nr) {
+		errno = ENOMEM;
+		return -1;
+	}
+	nr += sz;
+
+	/* Intermediate path components. */
+	list_for_each(l, &ctx->path_stack) {
+		pp = container_of(l, struct path_piece, list);
+
+		sz = snprintf(buf + nr, buflen - nr, "/%s", pp->name);
+		if (sz < 0)
+			return -1;
+		else if(sz > buflen - nr) {
+			errno = ENOMEM;
+			return -1;
+		}
+		nr += sz;
+	}
+
+	return 0;
+}
+
+#define CHECK_TYPE(type) \
+	case DT_##type: \
+		if (!S_IS##type(sb->st_mode)) { \
+			path_error(ctx, \
+_("dtype of block does not match mode 0x%x\n"), \
+				sb->st_mode & S_IFMT); \
+		} \
+		break;
+
+/* Ensure that the directory entry matches the stat info. */
+static bool
+verify_dirent(
+	struct scrub_ctx	*ctx,
+	struct dirent		*dirent,
+	struct stat64		*sb)
+{
+	if (dirent->d_ino != sb->st_ino)
+		path_error(ctx,
+_("inode numbers (%llu != %llu) do not match!"),
+			(unsigned long long)dirent->d_ino,
+			(unsigned long long)sb->st_ino);
+
+	switch (dirent->d_type) {
+	case DT_UNKNOWN:
+		break;
+	CHECK_TYPE(BLK)
+	CHECK_TYPE(CHR)
+	CHECK_TYPE(DIR)
+	CHECK_TYPE(FIFO)
+	CHECK_TYPE(LNK)
+	CHECK_TYPE(REG)
+	CHECK_TYPE(SOCK)
+	}
+
+	return true;
+}
+#undef CHECK_TYPE
+
+/* Read all the data in a file. */
+#define READ_BUF_SIZE		262144
+static bool
+read_file(
+	struct scrub_ctx	*ctx,
+	int			fd,
+	struct stat64		*sb)
+{
+	off_t			data_end = 0;
+	off_t			data_start;
+	off_t			start;
+	ssize_t			sz;
+	size_t			count;
+	static char		*readbuf = NULL;
+	bool			reports_holes = true;
+	bool			direct_io = false;
+	int			flags;
+	int			error;
+	static long		page_size = 0;
+
+	/* Find the page size. */
+	if (!page_size) {
+		page_size = sysconf(_SC_PAGESIZE);
+		if (page_size < 0) {
+			path_errno(ctx);
+			return false;
+		}
+	}
+
+	/* Try to allocate a read buffer if we don't have one. */
+	if (!readbuf) {
+		error = posix_memalign((void **)&readbuf, page_size,
+				READ_BUF_SIZE);
+		if (error || !readbuf) {
+			path_errno(ctx);
+			return false;
+		}
+	}
+
+	/* Can we set O_DIRECT? */
+	flags = fcntl(fd, F_GETFL);
+	error = fcntl(fd, F_SETFL, flags | O_DIRECT);
+	if (!error)
+		direct_io = true;
+
+	/* See if SEEK_DATA/SEEK_HOLE work... */
+	data_start = lseek(fd, data_end, SEEK_DATA);
+	if (data_start < 0)
+		reports_holes = false;
+
+	if (reports_holes) {
+		data_end = lseek(fd, data_start, SEEK_HOLE);
+		if (data_end < 0)
+			reports_holes = false;
+	}
+
+	/* ...or just read everything if they don't. */
+	if (!reports_holes) {
+		data_start = 0;
+		data_end = sb->st_size;
+	}
+
+	if (!direct_io) {
+		posix_fadvise(fd, 0, sb->st_size, POSIX_FADV_SEQUENTIAL);
+		posix_fadvise(fd, 0, sb->st_size, POSIX_FADV_WILLNEED);
+	}
+	/* Read the non-hole areas. */
+	while (data_start < data_end) {
+		start = data_start;
+
+		if (direct_io && (start & (page_size - 1)))
+			start &= ~(page_size - 1);
+		count = min(READ_BUF_SIZE, data_end - start);
+		if (direct_io && (count & (page_size - 1)))
+			count = (count + page_size) & ~(page_size - 1);
+		sz = pread(fd, readbuf, count, start);
+		if (sz < 0)
+			path_errno(ctx);
+		else if (sz == 0) {
+			path_error(ctx,
+_("Read zero bytes, expected %zu."),
+					count);
+			break;
+		} else if (sz != count && start + sz != data_end) {
+			path_warn(ctx,
+_("Short read of %zu bytes, expected %zu."),
+					sz, count);
+		}
+		data_start = start + sz;
+
+		if (data_start >= data_end && reports_holes) {
+			data_start = lseek(fd, data_end, SEEK_DATA);
+			if (data_start < 0) {
+				if (errno != ENXIO)
+					path_errno(ctx);
+				break;
+			}
+			data_end = lseek(fd, data_start, SEEK_HOLE);
+			if (data_end < 0) {
+				if (errno != ENXIO)
+					path_errno(ctx);
+				break;
+			}
+		}
+	}
+
+	/* Turn off O_DIRECT. */
+	if (direct_io) {
+		flags = fcntl(fd, F_GETFL);
+		error = fcntl(fd, F_SETFL, flags & ~O_DIRECT);
+		if (error)
+			path_errno(ctx);
+	}
+
+	return true;
+}
+
+/* Scrub a directory. */
+static bool
+check_dir(
+	struct scrub_ctx	*ctx,
+	int			dir_fd)
+{
+	DIR			*dir;
+	struct dirent		*dirent;
+	struct path_piece	pp;
+	int			fd = -1;
+	struct stat64		sb;
+	struct stat64		fd_sb;
+	bool			moveon;
+	static char		linkbuf[PATH_MAX];
+	ssize_t			len;
+	int			error;
+
+	/* FS-specific directory checks. */
+	moveon = ctx->ops->check_dir(ctx, dir_fd);
+	if (!moveon)
+		return moveon;
+
+	/* Iterate the directory entries. */
+	dir = fdopendir(dir_fd);
+	if (!dir) {
+		path_errno(ctx);
+		return true;
+	}
+
+	/* Iterate every directory entry. */
+	INIT_LIST_HEAD(&pp.list);
+	list_add_tail(&pp.list, &ctx->path_stack);
+	dirent = readdir(dir);
+	while (dirent) {
+		if (!strcmp(".", dirent->d_name) ||
+		    !strcmp("..", dirent->d_name))
+			goto next;
+
+		pp.name = dirent->d_name;
+		error = fstatat64(dir_fd, dirent->d_name, &sb,
+				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
+		if (error) {
+			path_errno(ctx);
+			break;
+		}
+
+		/* Ignore files on other filesystems. */
+		if (sb.st_dev != ctx->mnt_sb.st_dev)
+			goto next;
+
+		/* Check the directory entry itself. */
+		moveon = verify_dirent(ctx, dirent, &sb);
+		if (!moveon)
+			break;
+
+		/* If symlink, read the target value. */
+		if (S_ISLNK(sb.st_mode)) {
+			len = readlinkat(dir_fd, dirent->d_name, linkbuf,
+					PATH_MAX);
+			if (len < 0)
+				path_errno(ctx);
+			else if (len != sb.st_size)
+				path_error(ctx,
+_("read %zu bytes from a %zu byte symlink?"),
+					len, sb.st_size);
+		}
+
+		/* Read the xattrs without a file descriptor. */
+		if (S_ISSOCK(sb.st_mode) || S_ISFIFO(sb.st_mode) ||
+		    S_ISBLK(sb.st_mode) || S_ISCHR(sb.st_mode) ||
+		    S_ISLNK(sb.st_mode)) {
+			moveon = ctx->ops->scan_special_xattrs(ctx);
+			if (!moveon)
+				break;
+		}
+
+		/* If not dir or file, move on to the next dirent. */
+		if (!S_ISDIR(sb.st_mode) && !S_ISREG(sb.st_mode))
+			goto next;
+
+		/* Open the file */
+		fd = openat(dir_fd, dirent->d_name,
+				O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+		if (fd < 0) {
+			path_errno(ctx);
+			goto next;
+		}
+
+		/* Did the fstatat and the open race? */
+		if (fstat64(fd, &fd_sb) < 0) {
+			path_errno(ctx);
+			goto close;
+		}
+		if (fd_sb.st_ino != sb.st_ino || fd_sb.st_dev != sb.st_dev)
+			path_warn(ctx,
+_("inode changed out from under us!"));
+
+		/* Check the inode. */
+		moveon = ctx->ops->check_inode(ctx, fd, &fd_sb);
+		if (!moveon)
+			break;
+
+		/* Scan the extent maps. */
+		moveon = ctx->ops->scan_extents(ctx, fd, &fd_sb, false);
+		if (!moveon)
+			break;
+		moveon = ctx->ops->scan_extents(ctx, fd, &fd_sb, true);
+		if (!moveon)
+			break;
+
+		/* Read all the file data. */
+		if (scrub_data && S_ISREG(fd_sb.st_mode)) {
+			moveon = read_file(ctx, fd, &fd_sb);
+			if (!moveon)
+				break;
+		}
+
+		/* Read all the extended attributes. */
+		moveon = ctx->ops->scan_xattrs(ctx, fd);
+		if (!moveon)
+			break;
+
+		/* If directory, call ourselves recursively. */
+		if (S_ISDIR(fd_sb.st_mode)) {
+			moveon = check_dir(ctx, fd);
+			if (!moveon)
+				break;
+			/* closedir already closed fd for us */
+			fd = -1;
+			goto next;
+		}
+
+		/* Close file. */
+close:
+		error = close(fd);
+		if (error)
+			path_errno(ctx);
+		fd = -1;
+		
+next:
+		dirent = readdir(dir);
+	}
+
+	if (fd >= 0) {
+		error = close(fd);
+		if (error)
+			path_errno(ctx);
+	}
+	list_del(&pp.list);
+
+	/* Close dir, go away. */
+	error = closedir(dir);
+	if (error)
+		path_errno(ctx);
+
+	return moveon;
+}
+
+
+
+/* Traverse the directory tree. */
+static bool
+traverse_fs(
+	struct scrub_ctx	*ctx)
+{
+	bool			moveon;
+
+	/* Check the inode. */
+	moveon = ctx->ops->check_inode(ctx, ctx->mnt_fd, &ctx->mnt_sb);
+	if (!moveon)
+		return moveon;
+
+	/* Scan the extent maps. */
+	moveon = ctx->ops->scan_extents(ctx, ctx->mnt_fd, &ctx->mnt_sb, false);
+	if (!moveon)
+		return moveon;
+	moveon = ctx->ops->scan_extents(ctx, ctx->mnt_fd, &ctx->mnt_sb, true);
+	if (!moveon)
+		return moveon;
+
+	/* Check the mountpoint directory. */
+	moveon = check_dir(ctx, ctx->mnt_fd);
+	if (!moveon)
+		return moveon;
+
+	return true;
+}
+
+static struct scrub_ops *scrub_impl[] = {
+	&xfs_scrub_ops,
+	&generic_scrub_ops,
+	NULL
+};
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	char			*mtab = NULL;
+	struct scrub_ctx	ctx;
+	bool			ismnt;
+	bool			moveon;
+	int			ret;
+	struct scrub_ops	**ops;
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	ctx.ops = NULL;
+	while ((c = getopt(argc, argv, "dt:vxV")) != EOF) {
+		switch (c) {
+		case 'd':
+			debug = true;
+			break;
+		case 't':
+			for (ops = scrub_impl; *ops; ops++) {
+				if (!strcmp(optarg, (*ops)->name)) {
+					ctx.ops = *ops;
+					break;
+				}
+			}
+			if (!ctx.ops) {
+				fprintf(stderr,
+_("Unknown filesystem driver '%s'.\n"),
+						optarg);
+				return 1;
+			}
+			break;
+		case 'v':
+			verbose = true;
+			break;
+		case 'x':
+			scrub_data = true;
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), progname, VERSION);
+			exit(0);
+		case '?':
+		default:
+			usage();
+		}
+	}
+
+	if (optind != argc - 1)
+		usage();
+
+	ctx.errors_found = 0;
+	ctx.warnings_found = 0;
+	ctx.mntpoint = argv[optind];
+	ctx.quirks = SCRUB_QUIRK_FIEMAP_WORKS | SCRUB_QUIRK_FIEMAP_ATTR_WORKS |
+		     SCRUB_QUIRK_FIBMAP_WORKS;
+
+	/* Find the mount record for the passed-in argument. */
+
+	if (stat64(argv[optind], &ctx.mnt_sb) < 0) {
+		fprintf(stderr,
+			_("%s: could not stat: %s: %s\n"),
+			progname, argv[optind], strerror(errno));
+		return 16;
+	}
+
+	/*
+	 * If the user did not specify an explicit mount table, try to use
+	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
+	 * /proc/mounts because it is kernel controlled, while /etc/mtab
+	 * may contain garbage that userspace tools like pam_mounts wrote
+	 * into it.
+	 */
+	if (!mtab) {
+		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
+			mtab = _PATH_PROC_MOUNTS;
+		else
+			mtab = _PATH_MOUNTED;
+	}
+
+	ismnt = find_mountpoint(mtab, &ctx.mnt_sb, &ctx.mnt_ent);
+	if (!ismnt) {
+		fprintf(stderr, _("%s: Not a mount point or block device.\n"),
+			ctx.mntpoint);
+		return 16;
+	}
+	ctx.mntpoint = ctx.mnt_ent.mnt_dir;
+
+	/* Find an appropriate scrub backend. */
+	for (ops = scrub_impl; !ctx.ops && *ops; ops++) {
+		if (!strcmp(ctx.mnt_ent.mnt_type, (*ops)->name))
+			ctx.ops = *ops;
+	}
+	if (!ctx.ops)
+		ctx.ops = &generic_scrub_ops;
+	INIT_LIST_HEAD(&ctx.path_stack);
+	if (verbose)
+		printf(_("%s: scrubbing %s filesystem with %s driver.\n"),
+			ctx.mntpoint, ctx.mnt_ent.mnt_type, ctx.ops->name);
+
+	/* Phase 1: Find and verify filesystem */
+	if (verbose)
+		printf(_("Phase 1: Find filesystem.\n"));
+	ctx.mnt_fd = open(ctx.mntpoint, O_RDONLY | O_NOATIME);
+	if (ctx.mnt_fd < 0) {
+		perror(ctx.mntpoint);
+		return 8;
+	}
+	ret = fstat64(ctx.mnt_fd, &ctx.mnt_sb);
+	if (ret) {
+		path_errno(&ctx);
+		moveon = false;
+		goto out;
+	}
+	moveon = ctx.ops->scan_fs(&ctx);
+	if (!moveon)
+		goto out;
+
+	/* Phase 2: Check inodes, blocks, and sizes */
+	if (verbose)
+		printf(_("Phase 2: Scanning inodes.\n"));
+	moveon = ctx.ops->scan_inodes(&ctx);
+	if (!moveon)
+		goto out;
+
+	/* Phase 3: Check the directory structure. */
+	if (verbose)
+		printf(_("Phase 3: Check the directory structure.\n"));
+	moveon = traverse_fs(&ctx);
+	if (!moveon)
+		goto out;
+
+	/* Phase X: Check for duplicate blocks(??) */
+
+	/* Phase Y: Verify link counts(??) */
+
+	/* Phase 4: Check internal group metadata. */
+	if (verbose)
+		printf(_("Phase 4: Check internal metadata.\n"));
+	moveon = ctx.ops->scan_metadata(&ctx);
+	if (!moveon)
+		goto out;
+
+	/* Clean up scan data. */
+	moveon = ctx.ops->cleanup(&ctx);
+	if (!moveon)
+		goto out;
+
+out:
+	ret = 0;
+	if (!moveon)
+		ret |= 8;
+
+	if (ctx.errors_found && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu errors and %lu warnings found.  Unmount and run fsck.\n"),
+			ctx.mntpoint, ctx.errors_found, ctx.warnings_found);
+	else if (ctx.errors_found && ctx.warnings_found == 0)
+		fprintf(stderr,
+_("%s: %lu errors found.  Unmount and run fsck.\n"),
+			ctx.mntpoint, ctx.errors_found);
+	else if (ctx.errors_found == 0 && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu warnings found.\n"),
+			ctx.mntpoint, ctx.warnings_found);
+	if (ctx.errors_found)
+		ret |= 4;
+
+	return ret;
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
new file mode 100644
index 0000000..69cd93c
--- /dev/null
+++ b/scrub/scrub.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c) 2016 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef SCRUB_H_
+#define SCRUB_H_
+
+struct scrub_ctx;
+
+struct scrub_ops {
+	const char	*name;
+	bool (*cleanup)(struct scrub_ctx *ctx);
+	bool (*scan_fs)(struct scrub_ctx *ctx);
+	bool (*scan_inodes)(struct scrub_ctx *ctx);
+	bool (*check_dir)(struct scrub_ctx *ctx, int dir_fd);
+	bool (*check_inode)(struct scrub_ctx *ctx, int fd, struct stat64 *sb);
+	bool (*scan_extents)(struct scrub_ctx *ctx, int fd, struct stat64 *sb,
+			     bool attr_fork);
+	bool (*scan_xattrs)(struct scrub_ctx *ctx, int fd);
+	bool (*scan_special_xattrs)(struct scrub_ctx *ctx);
+	bool (*scan_metadata)(struct scrub_ctx *ctx);
+};
+
+#define SCRUB_QUIRK_FIEMAP_WORKS	(1 << 0)
+#define SCRUB_QUIRK_FIEMAP_ATTR_WORKS	(1 << 1)
+#define SCRUB_QUIRK_FIBMAP_WORKS	(1 << 2)
+struct scrub_ctx {
+	struct scrub_ops	*ops;
+	char			*mntpoint;
+	int			mnt_fd;
+	struct mntent		mnt_ent;
+	struct stat64		mnt_sb;
+	struct statvfs		mnt_sv;
+	struct statfs		mnt_sf;
+	unsigned long		errors_found;
+	unsigned long		warnings_found;
+	unsigned long		quirks;
+
+	struct list_head	path_stack;
+	void			*priv;
+};
+
+struct path_piece {
+	struct list_head	list;
+	const char		*name;
+};
+
+extern bool		verbose;
+extern bool		debug;
+extern bool		scrub_data;
+
+void __path_errno(struct scrub_ctx *, const char *, int);
+void __path_error(struct scrub_ctx *, const char *, int, const char *, ...);
+void __path_warn(struct scrub_ctx *, const char *, int, const char *, ...);
+void __str_errno(struct scrub_ctx *, const char *, const char *, int);
+void __str_error(struct scrub_ctx *, const char *, const char *, int, const char *, ...);
+void __str_warn(struct scrub_ctx *, const char *, const char *, int, const char *, ...);
+
+#define path_errno(ctx)		__path_errno(ctx, __FILE__, __LINE__)
+#define path_error(ctx, ...)	__path_error(ctx, __FILE__, __LINE__, __VA_ARGS__)
+#define path_warn(ctx, ...)	__path_warn(ctx, __FILE__, __LINE__, __VA_ARGS__)
+#define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
+#define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+
+int construct_path(struct scrub_ctx *ctx, char *buf, size_t buflen);
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+		(type *)( (char *)__mptr - offsetof(type,member) );})
+
+extern struct scrub_ops	generic_scrub_ops;
+extern struct scrub_ops	xfs_scrub_ops;
+
+bool generic_cleanup(struct scrub_ctx *ctx);
+bool generic_scan_fs(struct scrub_ctx *ctx);
+bool generic_scan_inodes(struct scrub_ctx *ctx);
+bool generic_check_dir(struct scrub_ctx *ctx, int dir_fd);
+bool generic_check_inode(struct scrub_ctx *ctx, int fd, struct stat64 *sb);
+bool generic_scan_extents(struct scrub_ctx *ctx, int fd, struct stat64 *sb,
+		bool attr_fork);
+bool generic_scan_xattrs(struct scrub_ctx *ctx, int fd);
+bool generic_scan_special_xattrs(struct scrub_ctx *ctx);
+
+#endif /* SCRUB_H_ */
diff --git a/scrub/xfs.c b/scrub/xfs.c
new file mode 100644
index 0000000..7f078e5
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (c) 2016 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include "scrub.h"
+
+/* Routines to scrub an XFS filesystem. */
+#define XFS_SYSFS_DIR		"/sys/fs/xfs"
+
+struct xfs_scrub_ctx {
+	xfs_fsop_geom_t		geo;
+	int			check_fd;
+};
+
+static bool
+xfs_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	free(ctx->priv);
+	ctx->priv = NULL;
+
+	return generic_cleanup(ctx);
+}
+
+/* Find the /sys/fs/xfs/$dev/check path that corresponds to this fs. */
+static bool
+xfs_find_sysfs_check(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	char			path[PATH_MAX];
+	char			buf[PATH_MAX];
+	int			sz;
+	ssize_t			ssz;
+	char			*p;
+
+	/* /dev/block/$major:$minor usually points "../$kernel_name" */
+	sz = snprintf(path, PATH_MAX, "/dev/block/%d:%d",
+			major(ctx->mnt_sb.st_dev), minor(ctx->mnt_sb.st_dev));
+	if (sz < 0) {
+		path_errno(ctx);
+		return false;
+	}
+
+	ssz = readlink(path, buf, PATH_MAX);
+	if (ssz < 0) {
+		perror(path);
+		return false;
+	}
+	buf[PATH_MAX - 1] = 0;
+
+	p = strchr(buf, '/');
+	p = NULL ? buf : p + 1;
+
+	/* See if we can find a pointer to /sys/fs/xfs/$p/check */
+	sz = snprintf(path, PATH_MAX, "/sys/fs/xfs/%s/check", p);
+	if (sz < 0) {
+		path_errno(ctx);
+		return false;
+	}
+
+	xctx->check_fd = open(path, O_RDONLY | O_DIRECTORY);
+	if (xctx->check_fd < 0) {
+		if (errno != ENOENT)
+			perror(path);
+		return false;
+	}
+
+	return true;
+}
+
+/* Read the XFS geometry. */
+static bool
+xfs_scan_fs(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx;
+	int			error;
+
+	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
+		path_error(ctx,
+_("Does not appear to be an XFS filesystem!"));
+		return false;
+	}
+
+	xctx = malloc(sizeof(struct xfs_scrub_ctx));
+	if (!ctx) {
+		path_errno(ctx);
+		return false;
+	}
+	xctx->check_fd = -1;
+
+	/* Retrieve XFS geometry. */
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSGEOMETRY,
+			&xctx->geo);
+	if (error) {
+		path_errno(ctx);
+		xfs_cleanup(ctx);
+		return false;
+	}
+	ctx->priv = xctx;
+
+	if (!xfs_find_sysfs_check(ctx))
+		path_warn(ctx,
+_("Couldn't find sysfs check path for filesystem.  Metadata cannot be checked."));
+
+	return generic_scan_fs(ctx);
+}
+
+/* Scrub a piece of metadata in a particular AG. */
+static bool
+xfs_scan_ag_metadata(
+	struct scrub_ctx	*ctx,
+	const char		*name,
+	xfs_agnumber_t		ag)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	char			descr[256];
+	char			cmd[256];
+	int			fd;
+	int			sz;
+	ssize_t			ssz;
+
+	sz = snprintf(descr, 256, "AG %d %s", ag, name);
+	if (sz < 0) {
+		str_errno(ctx, name);
+		return false;
+	}
+
+	fd = openat(xctx->check_fd, name, O_WRONLY);
+	if (fd < 0) {
+		str_errno(ctx, descr);
+		return true;
+	}
+
+	sz = snprintf(cmd, 256, "%d", ag);
+	if (sz < 0) {
+		str_errno(ctx, descr);
+		goto out;
+	}
+
+	ssz = write(fd, cmd, strlen(cmd));
+	if (ssz < 0) {
+		str_errno(ctx, descr);
+		goto out;
+	} else if (ssz != strlen(cmd)) {
+		str_error(ctx, descr,
+_("Strange output length %zu (expected %zu)\n"),
+				ssz, strlen(cmd));
+		ctx->errors_found++;
+		goto out;
+	}
+
+out:
+	sz = close(fd);
+	if (sz)
+		str_errno(ctx, descr);
+
+	return true;
+}
+
+/* Try to scan metadata via sysfs. */
+static bool
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		ag;
+	DIR			*checkdir;
+	bool			moveon = true;
+	struct dirent		*dirent;
+	int			error;
+
+	if (xctx->check_fd < 0)
+		return true;
+
+	/* Open the check controls. */
+	checkdir = fdopendir(xctx->check_fd);
+	if (!checkdir) {
+		path_error(ctx,
+_("Failed to open the check control."));
+		return false;
+	}
+
+	/* Scan everything we can in here. */
+	while ((dirent = readdir(checkdir)) != NULL) {
+		if (!strcmp(".", dirent->d_name) ||
+		    !strcmp("..", dirent->d_name))
+			continue;
+
+		for (ag = 0; ag < xctx->geo.agcount; ag++) {
+			moveon = xfs_scan_ag_metadata(ctx, dirent->d_name, ag);
+			if (!moveon)
+				break;
+		}
+	}
+
+	/* Done with metadata scrub. */
+	error = closedir(checkdir);
+	if (error)
+		path_errno(ctx);
+	xctx->check_fd = -1;
+
+	return moveon;
+}
+
+/*
+ * XXX: eventually we'll want to do better checking here, but the generic
+ * tree walk + metadata scrub is good enough for now.
+ */
+struct scrub_ops xfs_scrub_ops = {
+	.name			= "xfs",
+	.cleanup		= xfs_cleanup,
+	.scan_fs		= xfs_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= xfs_scan_metadata,
+};

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
