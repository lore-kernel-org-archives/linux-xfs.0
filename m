Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47367 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761986AbdKQVCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:20 -0500
Subject: [PATCH 21/27] xfs_scrub: scrub file data blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:02:15 -0800
Message-ID: <151095253567.4825.8831459891771463031.stgit@magnolia>
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

Read all data blocks from the disk, hoping to catch IO errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    2 
 include/builddefs.in  |    2 
 m4/package_libcdev.m4 |   28 +++
 scrub/Makefile        |    7 -
 scrub/phase6.c        |  516 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c           |  221 +++++++++++++++++++++
 scrub/vfs.h           |   31 +++
 scrub/xfs_scrub.c     |    4 
 scrub/xfs_scrub.h     |    2 
 9 files changed, 811 insertions(+), 2 deletions(-)
 create mode 100644 scrub/phase6.c
 create mode 100644 scrub/vfs.c
 create mode 100644 scrub/vfs.h


diff --git a/configure.ac b/configure.ac
index b96d7a7..2a86767 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,6 +167,8 @@ AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
 AC_PACKAGE_WANT_UNINORM_H
 AC_HAVE_U8NORMALIZE
+AC_HAVE_OPENAT
+AC_HAVE_FSTATAT
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index e63e232..a7034d8 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -119,6 +119,8 @@ HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_LIBATTR = @have_libattr@
 HAVE_U8NORMALIZE = @have_u8normalize@
+HAVE_OPENAT = @have_openat@
+HAVE_FSTATAT = @have_fstatat@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 91e1959..d111fd1 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -332,3 +332,31 @@ AC_DEFUN([AC_HAVE_MALLINFO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_mallinfo)
   ])
+
+#
+# Check if we have a openat call
+#
+AC_DEFUN([AC_HAVE_OPENAT],
+  [ AC_CHECK_DECL([openat],
+       have_openat=yes,
+       [],
+       [#include <sys/types.h>
+        #include <sys/stat.h>
+        #include <fcntl.h>]
+       )
+    AC_SUBST(have_openat)
+  ])
+
+#
+# Check if we have a fstatat call
+#
+AC_DEFUN([AC_HAVE_FSTATAT],
+  [ AC_CHECK_DECL([fstatat],
+       have_fstatat=yes,
+       [],
+       [#define _GNU_SOURCE
+       #include <sys/types.h>
+       #include <sys/stat.h>
+       #include <unistd.h>])
+    AC_SUBST(have_fstatat)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index d1d1eb1..ce3aa9d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,9 +8,9 @@ include $(TOPDIR)/include/builddefs
 # On linux we get fsmap from the system or define it ourselves
 # so include this based on platform type.  If this reverts to only
 # the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
-SCRUB_PREREQS=$(PKG_PLATFORM)
+SCRUB_PREREQS=$(PKG_PLATFORM)$(HAVE_OPENAT)$(HAVE_FSTATAT)
 
-ifeq ($(SCRUB_PREREQS),linux)
+ifeq ($(SCRUB_PREREQS),linuxyesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 endif	# scrub_prereqs
@@ -27,6 +27,7 @@ read_verify.h \
 scrub.h \
 spacemap.h \
 unicrash.h \
+vfs.h \
 xfs_scrub.h
 
 CFILES = \
@@ -41,9 +42,11 @@ phase1.c \
 phase2.c \
 phase3.c \
 phase5.c \
+phase6.c \
 read_verify.c \
 scrub.c \
 spacemap.c \
+vfs.c \
 xfs_scrub.c
 
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING)
diff --git a/scrub/phase6.c b/scrub/phase6.c
new file mode 100644
index 0000000..e6d9c69
--- /dev/null
+++ b/scrub/phase6.c
@@ -0,0 +1,516 @@
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
+#include <stdint.h>
+#include <stdbool.h>
+#include <dirent.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "handle.h"
+#include "path.h"
+#include "ptvar.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "bitmap.h"
+#include "disk.h"
+#include "filemap.h"
+#include "inodes.h"
+#include "read_verify.h"
+#include "spacemap.h"
+#include "vfs.h"
+
+/*
+ * Phase 6: Verify data file integrity.
+ *
+ * Identify potential data block extents with GETFSMAP, then feed those
+ * extents to the read-verify pool to get the verify commands batched,
+ * issued, and (if there are problems) reported back to us.  If there
+ * are errors, we'll record the bad regions and (if available) use rmap
+ * to tell us if metadata are now corrupt.  Otherwise, we'll scan the
+ * whole directory tree looking for files that overlap the bad regions
+ * and report the paths of the now corrupt files.
+ */
+
+/* Find the fd for a given device identifier. */
+static struct disk *
+xfs_dev_to_disk(
+	struct scrub_ctx	*ctx,
+	dev_t			dev)
+{
+	if (dev == ctx->fsinfo.fs_datadev)
+		return ctx->datadev;
+	else if (dev == ctx->fsinfo.fs_logdev)
+		return ctx->logdev;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		return ctx->rtdev;
+	abort();
+}
+
+/* Find the device major/minor for a given file descriptor. */
+static dev_t
+xfs_disk_to_dev(
+	struct scrub_ctx	*ctx,
+	struct disk		*disk)
+{
+	if (disk == ctx->datadev)
+		return ctx->fsinfo.fs_datadev;
+	else if (disk == ctx->logdev)
+		return ctx->fsinfo.fs_logdev;
+	else if (disk == ctx->rtdev)
+		return ctx->fsinfo.fs_rtdev;
+	abort();
+}
+
+struct owner_decode {
+	uint64_t		owner;
+	const char		*descr;
+};
+
+static const struct owner_decode special_owners[] = {
+	{XFS_FMR_OWN_FREE,	"free space"},
+	{XFS_FMR_OWN_UNKNOWN,	"unknown owner"},
+	{XFS_FMR_OWN_FS,	"static FS metadata"},
+	{XFS_FMR_OWN_LOG,	"journalling log"},
+	{XFS_FMR_OWN_AG,	"per-AG metadata"},
+	{XFS_FMR_OWN_INOBT,	"inode btree blocks"},
+	{XFS_FMR_OWN_INODES,	"inodes"},
+	{XFS_FMR_OWN_REFC,	"refcount btree"},
+	{XFS_FMR_OWN_COW,	"CoW staging"},
+	{XFS_FMR_OWN_DEFECTIVE,	"bad blocks"},
+	{0, NULL},
+};
+
+/* Decode a special owner. */
+static const char *
+xfs_decode_special_owner(
+	uint64_t			owner)
+{
+	const struct owner_decode	*od = special_owners;
+
+	while (od->descr) {
+		if (od->owner == owner)
+			return od->descr;
+		od++;
+	}
+
+	return NULL;
+}
+
+/* Routines to translate bad physical extents into file paths and offsets. */
+
+struct xfs_verify_error_info {
+	struct bitmap			*d_bad;		/* bytes */
+	struct bitmap			*r_bad;		/* bytes */
+};
+
+/* Report if this extent overlaps a bad region. */
+static bool
+xfs_report_verify_inode_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct xfs_verify_error_info	*vei = arg;
+	struct bitmap			*bmp;
+
+	/* Only report errors for real extents. */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		bmp = vei->r_bad;
+	else
+		bmp = vei->d_bad;
+
+	if (!bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
+		return true;
+
+	str_error(ctx, descr,
+_("offset %llu failed read verification."), bmap->bm_offset);
+	return true;
+}
+
+/* Iterate the extent mappings of a file to report errors. */
+static bool
+xfs_report_verify_fd(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	void				*arg)
+{
+	struct xfs_bmap			key = {0};
+	bool				moveon;
+
+	/* data fork */
+	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_report_verify_inode_bmap, arg);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_report_verify_inode_bmap, arg);
+	if (!moveon)
+		return false;
+	return true;
+}
+
+/* Report read verify errors in unlinked (but still open) files. */
+static int
+xfs_report_verify_inode(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	char				descr[DESCR_BUFSZ];
+	char				buf[DESCR_BUFSZ];
+	bool				moveon;
+	int				fd;
+	int				error;
+
+	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (unlinked)"),
+			(uint64_t)bstat->bs_ino);
+
+	/* Ignore linked files and things we can't open. */
+	if (bstat->bs_nlink != 0)
+		return 0;
+	if (!S_ISREG(bstat->bs_mode) && !S_ISDIR(bstat->bs_mode))
+		return 0;
+
+	/* Try to open the inode. */
+	fd = xfs_open_handle(handle);
+	if (fd < 0) {
+		error = errno;
+		if (error == ESTALE)
+			return error;
+
+		str_warn(ctx, descr, "%s", strerror_r(error, buf, DESCR_BUFSZ));
+		return error;
+	}
+
+	/* Go find the badness. */
+	moveon = xfs_report_verify_fd(ctx, descr, fd, arg);
+	close(fd);
+
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Scan a directory for matches in the read verify error list. */
+static bool
+xfs_report_verify_dir(
+	struct scrub_ctx	*ctx,
+	const char		*path,
+	int			dir_fd,
+	void			*arg)
+{
+	return xfs_report_verify_fd(ctx, path, dir_fd, arg);
+}
+
+/*
+ * Scan the inode associated with a directory entry for matches with
+ * the read verify error list.
+ */
+static bool
+xfs_report_verify_dirent(
+	struct scrub_ctx	*ctx,
+	const char		*path,
+	int			dir_fd,
+	struct dirent		*dirent,
+	struct stat		*sb,
+	void			*arg)
+{
+	bool			moveon;
+	int			fd;
+
+	/* Ignore things we can't open. */
+	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
+		return true;
+
+	/* Ignore . and .. */
+	if (!strcmp(".", dirent->d_name) || !strcmp("..", dirent->d_name))
+		return true;
+
+	/*
+	 * If we were given a dirent, open the associated file under
+	 * dir_fd for badblocks scanning.  If dirent is NULL, then it's
+	 * the directory itself we want to scan.
+	 */
+	fd = openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0)
+		return true;
+
+	/* Go find the badness. */
+	moveon = xfs_report_verify_fd(ctx, path, fd, arg);
+	if (moveon)
+		goto out;
+
+out:
+	close(fd);
+
+	return moveon;
+}
+
+/* Given bad extent lists for the data & rtdev, find bad files. */
+static bool
+xfs_report_verify_errors(
+	struct scrub_ctx		*ctx,
+	struct bitmap			*d_bad,
+	struct bitmap			*r_bad)
+{
+	struct xfs_verify_error_info	vei;
+	bool				moveon;
+
+	vei.d_bad = d_bad;
+	vei.r_bad = r_bad;
+
+	/* Scan the directory tree to get file paths. */
+	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
+			xfs_report_verify_dirent, &vei);
+	if (!moveon)
+		return false;
+
+	/* Scan for unlinked files. */
+	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, &vei);
+}
+
+/* Verify disk blocks with GETFSMAP */
+
+struct xfs_verify_extent {
+	struct read_verify_pool	*readverify;
+	struct ptvar		*rvstate;
+	struct bitmap		*d_bad;		/* bytes */
+	struct bitmap		*r_bad;		/* bytes */
+};
+
+/* Report an IO error resulting from read-verify based off getfsmap. */
+static bool
+xfs_check_rmap_error_report(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fsmap		*map,
+	void			*arg)
+{
+	const char		*type;
+	char			buf[32];
+	uint64_t		err_physical = *(uint64_t *)arg;
+	uint64_t		err_off;
+
+	if (err_physical > map->fmr_physical)
+		err_off = err_physical - map->fmr_physical;
+	else
+		err_off = 0;
+
+	snprintf(buf, 32, _("disk offset %"PRIu64),
+			(uint64_t)BTOBB(map->fmr_physical + err_off));
+
+	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
+		type = xfs_decode_special_owner(map->fmr_owner);
+		str_error(ctx, buf,
+_("%s failed read verification."),
+				type);
+	}
+
+	/*
+	 * XXX: If we had a getparent() call we could report IO errors
+	 * efficiently.  Until then, we'll have to scan the dir tree
+	 * to find the bad file's pathname.
+	 */
+
+	return true;
+}
+
+/*
+ * Remember a read error for later, and see if rmap will tell us about the
+ * owner ahead of time.
+ */
+void
+xfs_check_rmap_ioerr(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	int				error,
+	void				*arg)
+{
+	struct fsmap			keys[2];
+	char				descr[DESCR_BUFSZ];
+	struct xfs_verify_extent	*ve = arg;
+	struct bitmap			*tree;
+	dev_t				dev;
+	bool				moveon;
+
+	dev = xfs_disk_to_dev(ctx, disk);
+
+	/*
+	 * If we don't have parent pointers, save the bad extent for
+	 * later rescanning.
+	 */
+	if (dev == ctx->fsinfo.fs_datadev)
+		tree = ve->d_bad;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		tree = ve->r_bad;
+	else
+		tree = NULL;
+	if (tree) {
+		moveon = bitmap_set(tree, start, length);
+		if (!moveon)
+			str_errno(ctx, ctx->mntpoint);
+	}
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
+			major(dev), minor(dev), start, length);
+
+	/* Go figure out which blocks are bad from the fsmap. */
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = dev;
+	keys->fmr_physical = start;
+	(keys + 1)->fmr_device = dev;
+	(keys + 1)->fmr_physical = start + length - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+	xfs_iterate_fsmap(ctx, descr, keys, xfs_check_rmap_error_report,
+			&start);
+}
+
+/* Schedule a read-verify of a (data block) extent. */
+static bool
+xfs_check_rmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct fsmap			*map,
+	void				*arg)
+{
+	struct xfs_verify_extent	*ve = arg;
+	struct disk			*disk;
+
+	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
+			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
+			major(map->fmr_device), minor(map->fmr_device),
+			(uint64_t)map->fmr_physical, (int64_t)map->fmr_owner,
+			(uint64_t)map->fmr_offset, (uint64_t)map->fmr_length,
+			map->fmr_flags);
+
+	/* "Unknown" extents should be verified; they could be data. */
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+			map->fmr_owner == XFS_FMR_OWN_UNKNOWN)
+		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+
+	/*
+	 * We only care about read-verifying data extents that have been
+	 * written to disk.  This means we can skip "special" owners
+	 * (metadata), xattr blocks, unwritten extents, and extent maps.
+	 * These should all get checked elsewhere in the scrubber.
+	 */
+	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+			      FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
+		goto out;
+
+	/* XXX: Filter out directory data blocks. */
+
+	/* Schedule the read verify command for (eventual) running. */
+	disk = xfs_dev_to_disk(ctx, map->fmr_device);
+
+	read_verify_schedule_io(ve->readverify, ptvar_get(ve->rvstate), disk,
+			map->fmr_physical, map->fmr_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmr_flags & FMR_OF_LAST)
+		read_verify_force_io(ve->readverify, ptvar_get(ve->rvstate));
+
+	return true;
+}
+
+/*
+ * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
+ * do data checksums, we trust that the underlying storage will pass back
+ * an IO error if it can't retrieve whatever we previously stored there.
+ * If we hit an IO error, we'll record the bad blocks in a bitmap and then
+ * scan the extent maps of the entire fs tree to figure (and the unlinked
+ * inodes) out which files are now broken.
+ */
+bool
+xfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_verify_extent	ve;
+	bool				moveon;
+
+	ve.rvstate = ptvar_init(scrub_nproc(ctx), sizeof(struct read_verify));
+	if (!ve.rvstate) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&ve.d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_ve;
+	}
+
+	moveon = bitmap_init(&ve.r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	ve.readverify = read_verify_pool_init(ctx, ctx->geo.blocksize,
+			xfs_check_rmap_ioerr, disk_heads(ctx->datadev));
+	if (!ve.readverify) {
+		moveon = false;
+		str_error(ctx, ctx->mntpoint,
+_("Could not create media verifier."));
+		goto out_rbad;
+	}
+	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &ve);
+	if (!moveon)
+		goto out_pool;
+	read_verify_pool_flush(ve.readverify);
+	ctx->bytes_checked += read_verify_bytes(ve.readverify);
+	read_verify_pool_destroy(ve.readverify);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!bitmap_empty(ve.d_bad) || !bitmap_empty(ve.r_bad))
+		moveon = xfs_report_verify_errors(ctx, ve.d_bad, ve.r_bad);
+
+	bitmap_free(&ve.r_bad);
+	bitmap_free(&ve.d_bad);
+	ptvar_free(ve.rvstate);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(ve.readverify);
+out_rbad:
+	bitmap_free(&ve.r_bad);
+out_dbad:
+	bitmap_free(&ve.d_bad);
+out_ve:
+	ptvar_free(ve.rvstate);
+	return moveon;
+}
diff --git a/scrub/vfs.c b/scrub/vfs.c
new file mode 100644
index 0000000..6afeca0
--- /dev/null
+++ b/scrub/vfs.c
@@ -0,0 +1,221 @@
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
+#include <stdint.h>
+#include <stdbool.h>
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "handle.h"
+#include "path.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "vfs.h"
+
+/*
+ * Helper functions to assist in traversing a directory tree using regular
+ * VFS calls.
+ */
+
+/* Scan a filesystem tree. */
+struct scan_fs_tree {
+	unsigned int		nr_dirs;
+	pthread_mutex_t		lock;
+	pthread_cond_t		wakeup;
+	struct stat		root_sb;
+	bool			moveon;
+	scan_fs_tree_dir_fn	dir_fn;
+	scan_fs_tree_dirent_fn	dirent_fn;
+	void			*arg;
+};
+
+/* Per-work-item scan context. */
+struct scan_fs_tree_dir {
+	char			*path;
+	struct scan_fs_tree	*sft;
+	bool			rootdir;
+};
+
+/* Scan a directory sub tree. */
+static void
+scan_fs_dir(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_fs_tree_dir	*sftd = arg;
+	struct scan_fs_tree	*sft = sftd->sft;
+	DIR			*dir;
+	struct dirent		*dirent;
+	char			newpath[PATH_MAX];
+	struct scan_fs_tree_dir	*new_sftd;
+	struct stat		sb;
+	int			dir_fd;
+	int			error;
+
+	/* Open the directory. */
+	dir_fd = open(sftd->path, O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (dir_fd < 0) {
+		if (errno != ENOENT)
+			str_errno(ctx, sftd->path);
+		goto out;
+	}
+
+	/* Caller-specific directory checks. */
+	if (!sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
+		sft->moveon = false;
+		goto out;
+	}
+
+	/* Iterate the directory entries. */
+	dir = fdopendir(dir_fd);
+	if (!dir) {
+		str_errno(ctx, sftd->path);
+		goto out;
+	}
+	rewinddir(dir);
+	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
+		snprintf(newpath, PATH_MAX, "%s/%s", sftd->path,
+				dirent->d_name);
+
+		/* Get the stat info for this directory entry. */
+		error = fstatat(dir_fd, dirent->d_name, &sb,
+				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
+		if (error) {
+			str_errno(ctx, newpath);
+			continue;
+		}
+
+		/* Ignore files on other filesystems. */
+		if (sb.st_dev != sft->root_sb.st_dev)
+			continue;
+
+		/* Caller-specific directory entry function. */
+		if (!sft->dirent_fn(ctx, newpath, dir_fd, dirent, &sb,
+				sft->arg)) {
+			sft->moveon = false;
+			break;
+		}
+
+		if (xfs_scrub_excessive_errors(ctx)) {
+			sft->moveon = false;
+			break;
+		}
+
+		/* If directory, call ourselves recursively. */
+		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
+		    strcmp("..", dirent->d_name)) {
+			new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
+			if (!new_sftd) {
+				str_errno(ctx, newpath);
+				sft->moveon = false;
+				break;
+			}
+			new_sftd->path = strdup(newpath);
+			new_sftd->sft = sft;
+			new_sftd->rootdir = false;
+			pthread_mutex_lock(&sft->lock);
+			sft->nr_dirs++;
+			pthread_mutex_unlock(&sft->lock);
+			error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
+			if (error) {
+				str_error(ctx, ctx->mntpoint,
+_("Could not queue subdirectory scan work."));
+				sft->moveon = false;
+				break;
+			}
+		}
+	}
+
+	/* Close dir, go away. */
+	error = closedir(dir);
+	if (error)
+		str_errno(ctx, sftd->path);
+
+out:
+	pthread_mutex_lock(&sft->lock);
+	sft->nr_dirs--;
+	if (sft->nr_dirs == 0)
+		pthread_cond_signal(&sft->wakeup);
+	pthread_mutex_unlock(&sft->lock);
+
+	free(sftd->path);
+	free(sftd);
+}
+
+/* Scan the entire filesystem. */
+bool
+scan_fs_tree(
+	struct scrub_ctx	*ctx,
+	scan_fs_tree_dir_fn	dir_fn,
+	scan_fs_tree_dirent_fn	dirent_fn,
+	void			*arg)
+{
+	struct workqueue	wq;
+	struct scan_fs_tree	sft;
+	struct scan_fs_tree_dir	*sftd;
+	int			ret;
+
+	sft.moveon = true;
+	sft.nr_dirs = 1;
+	sft.root_sb = ctx->mnt_sb;
+	sft.dir_fn = dir_fn;
+	sft.dirent_fn = dirent_fn;
+	sft.arg = arg;
+	pthread_mutex_init(&sft.lock, NULL);
+	pthread_cond_init(&sft.wakeup, NULL);
+
+	sftd = malloc(sizeof(struct scan_fs_tree_dir));
+	if (!sftd) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	sftd->path = strdup(ctx->mntpoint);
+	sftd->sft = &sft;
+	sftd->rootdir = true;
+
+	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+			scrub_nproc_workqueue(ctx));
+	if (ret) {
+		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		goto out_free;
+	}
+	ret = workqueue_add(&wq, scan_fs_dir, 0, sftd);
+	if (ret) {
+		str_error(ctx, ctx->mntpoint,
+_("Could not queue directory scan work."));
+		goto out_free;
+	}
+
+	pthread_mutex_lock(&sft.lock);
+	pthread_cond_wait(&sft.wakeup, &sft.lock);
+	assert(sft.nr_dirs == 0);
+	pthread_mutex_unlock(&sft.lock);
+	workqueue_destroy(&wq);
+
+	return sft.moveon;
+out_free:
+	free(sftd->path);
+	free(sftd);
+	return false;
+}
diff --git a/scrub/vfs.h b/scrub/vfs.h
new file mode 100644
index 0000000..d565039
--- /dev/null
+++ b/scrub/vfs.h
@@ -0,0 +1,31 @@
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
+#ifndef XFS_SCRUB_VFS_H_
+#define XFS_SCRUB_VFS_H_
+
+typedef bool (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
+		int, void *);
+typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
+		int, struct dirent *, struct stat *, void *);
+
+bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
+		scan_fs_tree_dirent_fn dirent_fn, void *arg);
+
+#endif /* XFS_SCRUB_VFS_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index f224784..0d40e1f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -390,6 +390,10 @@ run_scrub_phases(
 
 	/* Run all phases of the scrub tool. */
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
+		/* Turn on certain phases if user said to. */
+		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
+			sp->fn = xfs_scan_blocks;
+
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
 		    sp->fn == DATASCAN_DUMMY_FN)
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 2396c6e..b7102de 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -93,6 +93,7 @@ struct scrub_ctx {
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
 	unsigned long long	inodes_checked;
+	unsigned long long	bytes_checked;
 	unsigned long long	naming_warnings;
 	bool			need_repair;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
@@ -105,5 +106,6 @@ bool xfs_setup_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
+bool xfs_scan_blocks(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

