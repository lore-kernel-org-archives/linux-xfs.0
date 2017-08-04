Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25522 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:08 -0400
Subject: [PATCH 13/22] xfs_scrub: scrub file data blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:55 -0700
Message-ID: <150180533589.18784.12836811939197659509.stgit@magnolia>
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

Read all data blocks from the disk, hoping to catch IO errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    2 
 include/builddefs.in  |    2 
 m4/package_libcdev.m4 |   28 +++
 scrub/Makefile        |    7 -
 scrub/phase6.c        |  539 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |    4 
 scrub/vfs.c           |  199 ++++++++++++++++++
 scrub/vfs.h           |   33 +++
 scrub/xfs.c           |  140 +++++++++++++
 scrub/xfs.h           |    4 
 10 files changed, 956 insertions(+), 2 deletions(-)
 create mode 100644 scrub/phase6.c
 create mode 100644 scrub/vfs.c
 create mode 100644 scrub/vfs.h


diff --git a/configure.ac b/configure.ac
index e7ea99e..b2b4566 100644
--- a/configure.ac
+++ b/configure.ac
@@ -144,6 +144,8 @@ AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_HAVE_GETFSMAP
 AC_HAVE_MALLINFO
+AC_HAVE_OPENAT
+AC_HAVE_FSTATAT
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index c178556..65d3d20 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -114,6 +114,8 @@ HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MALLINFO = @have_mallinfo@
+HAVE_OPENAT = @have_openat@
+HAVE_FSTATAT = @have_fstatat@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 3ccdea5..540633a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -315,3 +315,31 @@ AC_DEFUN([AC_HAVE_MALLINFO],
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
index 5df3e95..18a65b9 100644
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
@@ -25,6 +25,7 @@ disk.h \
 ioctl.h \
 read_verify.h \
 scrub.h \
+vfs.h \
 xfs.h
 
 CFILES = \
@@ -39,8 +40,10 @@ phase1.c \
 phase2.c \
 phase3.c \
 phase5.c \
+phase6.c \
 read_verify.c \
 scrub.c \
+vfs.c \
 xfs.c
 
 LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
diff --git a/scrub/phase6.c b/scrub/phase6.c
new file mode 100644
index 0000000..d60a044
--- /dev/null
+++ b/scrub/phase6.c
@@ -0,0 +1,539 @@
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
+#include "xfs.h"
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
+		return &ctx->datadev;
+	else if (dev == ctx->fsinfo.fs_logdev)
+		return &ctx->logdev;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		return &ctx->rtdev;
+	abort();
+}
+
+/* Find the device major/minor for a given file descriptor. */
+static dev_t
+xfs_disk_to_dev(
+	struct scrub_ctx	*ctx,
+	struct disk		*disk)
+{
+	if (disk == &ctx->datadev)
+		return ctx->fsinfo.fs_datadev;
+	else if (disk == &ctx->logdev)
+		return ctx->fsinfo.fs_logdev;
+	else if (disk == &ctx->rtdev)
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
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_report_verify_inode_bmap, arg);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
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
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu (unlinked)"), bstat->bs_ino);
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
+	/* Ignore . and .. */
+	if (dirent && (!strcmp(".", dirent->d_name) ||
+		       !strcmp("..", dirent->d_name)))
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
+	return xfs_scan_all_inodes_arg(ctx, xfs_report_verify_inode, &vei);
+}
+
+/* Verify disk blocks with GETFSMAP */
+
+struct xfs_verify_extent {
+	/* Maintain state for the lazy read verifier. */
+	struct read_verify	rv;
+
+	/* Store bad extents if we don't have parent pointers. */
+	struct bitmap		*d_bad;		/* bytes */
+	struct bitmap		*r_bad;		/* bytes */
+
+	/* Track the last extent we saw. */
+	uint64_t		laststart;	/* bytes */
+	uint64_t		lastlength;	/* bytes */
+	bool			lastshared;	/* bytes */
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
+	snprintf(buf, 32, _("disk offset %llu"),
+			BTOBB(map->fmr_physical + err_off));
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
+	struct read_verify_pool	*rvp,
+	struct disk		*disk,
+	uint64_t		start,
+	uint64_t		length,
+	int			error,
+	void			*arg)
+{
+	struct fsmap		keys[2];
+	char			descr[DESCR_BUFSZ];
+	struct scrub_ctx	*ctx = rvp->rvp_ctx;
+	struct xfs_verify_extent	*ve;
+	struct bitmap		*tree;
+	dev_t			dev;
+	bool			moveon;
+
+	ve = arg;
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
+	dbg_printf("rmap dev %d:%d phys %llu owner %lld offset %llu "
+			"len %llu flags 0x%x\n", major(map->fmr_device),
+			minor(map->fmr_device), map->fmr_physical,
+			map->fmr_owner, map->fmr_offset,
+			map->fmr_length, map->fmr_flags);
+
+	/* Remember this extent. */
+	ve->lastshared = (map->fmr_flags & FMR_OF_SHARED);
+	ve->laststart = map->fmr_physical;
+	ve->lastlength = map->fmr_length;
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
+	read_verify_schedule(ctx->rvp, &ve->rv, disk, map->fmr_physical,
+			map->fmr_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmr_flags & FMR_OF_LAST)
+		read_verify_force(ctx->rvp, &ve->rv);
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
+	struct bitmap			*d_bad;
+	struct bitmap			*r_bad;
+	struct xfs_verify_extent	*ve;
+	struct xfs_verify_extent	*v;
+	int				i;
+	unsigned int			groups;
+	bool				moveon;
+
+	/*
+	 * Initialize our per-thread context.  By convention,
+	 * the log device comes first, then the rt device, and then
+	 * the AGs.
+	 */
+	groups = xfs_scan_all_blocks_array_size(ctx);
+	ve = calloc(groups, sizeof(struct xfs_verify_extent));
+	if (!ve) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_ve;
+	}
+
+	moveon = bitmap_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	for (i = 0, v = ve; i < groups; i++, v++) {
+		v->d_bad = d_bad;
+		v->r_bad = r_bad;
+	}
+
+	moveon = read_verify_pool_init(&ctx->rvp, ctx, ctx->readbuf,
+			IO_MAX_SIZE, ctx->geo.blocksize, xfs_check_rmap_ioerr,
+			disk_heads(&ctx->datadev));
+	if (!moveon)
+		goto out_rbad;
+	moveon = xfs_scan_all_blocks_array_arg(ctx, xfs_check_rmap,
+			ve, sizeof(*ve));
+	if (!moveon)
+		goto out_pool;
+
+	for (i = 0, v = ve; i < groups; i++, v++)
+		read_verify_force(ctx->rvp, &v->rv);
+	read_verify_pool_destroy(&ctx->rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!bitmap_empty(d_bad) || !bitmap_empty(r_bad))
+		moveon = xfs_report_verify_errors(ctx, d_bad, r_bad);
+
+	bitmap_free(&r_bad);
+	bitmap_free(&d_bad);
+	free(ve);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(&ctx->rvp);
+out_rbad:
+	bitmap_free(&r_bad);
+out_dbad:
+	bitmap_free(&d_bad);
+out_ve:
+	free(ve);
+	return moveon;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d4527e4..97bd795 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -464,6 +464,10 @@ run_scrub_phases(
 
 	/* Run all phases of the scrub tool. */
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
+		/* Turn on certain phases if user said to. */
+		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
+			sp->fn = xfs_scan_blocks;
+
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
 		    sp->fn == DATASCAN_DUMMY_FN)
diff --git a/scrub/vfs.c b/scrub/vfs.c
new file mode 100644
index 0000000..1cff2ab
--- /dev/null
+++ b/scrub/vfs.c
@@ -0,0 +1,199 @@
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
+#include <sys/xattr.h>
+#include "../repair/threads.h"
+#include "path.h"
+#include "disk.h"
+#include "read_verify.h"
+#include "scrub.h"
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
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
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
+			queue_work(wq, scan_fs_dir, 0, new_sftd);
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
+	struct work_queue	wq;
+	struct scan_fs_tree	sft;
+	struct scan_fs_tree_dir	*sftd;
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
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	queue_work(&wq, scan_fs_dir, 0, sftd);
+
+	pthread_mutex_lock(&sft.lock);
+	pthread_cond_wait(&sft.wakeup, &sft.lock);
+	assert(sft.nr_dirs == 0);
+	pthread_mutex_unlock(&sft.lock);
+	destroy_work_queue(&wq);
+
+	return sft.moveon;
+}
diff --git a/scrub/vfs.h b/scrub/vfs.h
new file mode 100644
index 0000000..3a3b2dc
--- /dev/null
+++ b/scrub/vfs.h
@@ -0,0 +1,33 @@
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
+struct scrub_ctx;
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
diff --git a/scrub/xfs.c b/scrub/xfs.c
index 882bd28..36a5ba1 100644
--- a/scrub/xfs.c
+++ b/scrub/xfs.c
@@ -25,6 +25,7 @@
 #include "../repair/threads.h"
 #include "handle.h"
 #include "path.h"
+#include "vfs.h"
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
@@ -130,3 +131,142 @@ xfs_scan_all_inodes_arg(
 {
 	return xfs_scan_all_inodes_array_arg(ctx, fn, arg, 0);
 }
+
+/* GETFSMAP wrappers routines. */
+struct xfs_scan_blocks {
+	xfs_fsmap_iter_fn	fn;
+	void			*arg;
+	size_t			array_arg_size;
+	bool			moveon;
+};
+
+/* Iterate all the reverse mappings of an AG. */
+static void
+xfs_scan_ag_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scan_blocks	*sbx = arg;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	struct fsmap		keys[2];
+	off64_t			bperag;
+	bool			moveon;
+
+	bperag = (off64_t)ctx->geo.agblocks *
+		 (off64_t)ctx->geo.blocksize;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+				major(ctx->fsinfo.fs_datadev),
+				minor(ctx->fsinfo.fs_datadev),
+				agno);
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = ctx->fsinfo.fs_datadev;
+	keys->fmr_physical = agno * bperag;
+	(keys + 1)->fmr_device = ctx->fsinfo.fs_datadev;
+	(keys + 1)->fmr_physical = ((agno + 1) * bperag) - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	fn_arg = ((char *)sbx->arg) + sbx->array_arg_size * agno;
+	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, fn_arg);
+	if (!moveon)
+		sbx->moveon = false;
+}
+
+/* Iterate all the reverse mappings of a standalone device. */
+static void
+xfs_scan_dev_blocks(
+	struct scrub_ctx	*ctx,
+	int			idx,
+	dev_t			dev,
+	struct xfs_scan_blocks	*sbx)
+{
+	struct fsmap		keys[2];
+	char			descr[DESCR_BUFSZ];
+	void			*fn_arg;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
+			major(dev), minor(dev));
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = dev;
+	(keys + 1)->fmr_device = dev;
+	(keys + 1)->fmr_physical = ULLONG_MAX;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	fn_arg = ((char *)sbx->arg) + sbx->array_arg_size * idx;
+	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, fn_arg);
+	if (!moveon)
+		sbx->moveon = false;
+}
+
+/* Iterate all the reverse mappings of the realtime device. */
+static void
+xfs_scan_rt_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+
+	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+}
+
+/* Iterate all the reverse mappings of the log device. */
+static void
+xfs_scan_log_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+
+	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+}
+
+/* How many array elements should we create to scan all the blocks? */
+size_t
+xfs_scan_all_blocks_array_size(
+	struct scrub_ctx	*ctx)
+{
+	return ctx->geo.agcount + 2;
+}
+
+/* Scan all the blocks in a filesystem. */
+bool
+xfs_scan_all_blocks_array_arg(
+	struct scrub_ctx	*ctx,
+	xfs_fsmap_iter_fn	fn,
+	void			*arg,
+	size_t			array_arg_size)
+{
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	struct xfs_scan_blocks	sbx;
+
+	sbx.moveon = true;
+	sbx.fn = fn;
+	sbx.arg = arg;
+	sbx.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	if (ctx->fsinfo.fs_rt)
+		queue_work(&wq, xfs_scan_rt_blocks, ctx->geo.agcount + 1,
+				&sbx);
+	if (ctx->fsinfo.fs_log)
+		queue_work(&wq, xfs_scan_log_blocks, ctx->geo.agcount + 2,
+				&sbx);
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_blocks, agno, &sbx);
+	destroy_work_queue(&wq);
+
+	return sbx.moveon;
+}
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 2e434c2..7d087db 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -24,6 +24,9 @@ void xfs_shutdown_fs(struct scrub_ctx *ctx);
 bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn);
 bool xfs_scan_all_inodes_arg(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
 		void *arg);
+size_t xfs_scan_all_blocks_array_size(struct scrub_ctx *ctx);
+bool xfs_scan_all_blocks_array_arg(struct scrub_ctx *ctx, xfs_fsmap_iter_fn fn,
+		void *arg, size_t array_arg_size);
 
 /* Phase-specific functions. */
 bool xfs_cleanup(struct scrub_ctx *ctx);
@@ -31,5 +34,6 @@ bool xfs_scan_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
+bool xfs_scan_blocks(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */

