Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17409 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbdCJXZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:25:41 -0500
Subject: [PATCH 7/9] xfs_scrub: add XFS-specific scrubbing functionality
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:25:28 -0800
Message-ID: <148918832847.8311.11487811640938454625.stgit@birch.djwong.org>
In-Reply-To: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
References: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For XFS, we perform sequential scans of each AG's metadata, inodes,
extent maps, and file data.  Being XFS specific, we can work with the
in-kernel scrubbers to perform much stronger metadata checking and
cross-referencing.  We can also take advantage of newer ioctls such as
GETFSMAP to perform faster read verification.

In the future we will be able to take advantage of (still unwritten)
features such as parent directory pointers to fully validate all
metadata.  The scrub tool can shut down the filesystem if errors are
found.  This is not a default option since scrubbing is very immature at
this time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    4 
 scrub/scrub.c     |   21 +
 scrub/scrub.h     |   26 +
 scrub/xfs.c       | 1517 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_ioctl.c |  968 ++++++++++++++++++++++++++++++++++
 scrub/xfs_ioctl.h |  103 ++++
 6 files changed, 2632 insertions(+), 7 deletions(-)
 create mode 100644 scrub/xfs.c
 create mode 100644 scrub/xfs_ioctl.c
 create mode 100644 scrub/xfs_ioctl.h


diff --git a/scrub/Makefile b/scrub/Makefile
index b1ff86a..bae2fa1 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -12,9 +12,9 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 endif	# scrub_prereqs
 
-HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h
+HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h xfs_ioctl.h
 CFILES = ../repair/avl64.c disk.c bitmap.c iocmd.c \
-	 read_verify.c scrub.c ../repair/threads.c
+	 read_verify.c scrub.c ../repair/threads.c xfs.c xfs_ioctl.c
 
 LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBHANDLE)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBHANDLE)
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 013559a..a363ac1 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -638,6 +638,9 @@ _("Must be root to run scrub."));
 		ctx->nr_io_threads = disk_heads(&ctx->datadev);
 	else
 		ctx->nr_io_threads = libxfs_nproc();
+	moveon = xfs_scan_fs(ctx);
+	if (!moveon)
+		goto out;
 	if (verbose) {
 		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
 				ctx->mntpoint, scrub_nproc(ctx));
@@ -664,7 +667,7 @@ _("Errors found, please re-run with -y."));
 		return true;
 	}
 
-	return false;
+	return xfs_repair_fs(ctx);
 }
 
 /* Run all the phases of the scrubber. */
@@ -676,11 +679,11 @@ run_scrub_phases(
 {
 	struct scrub_phase	phases[] = {
 		{_("Find filesystem geometry."),   find_geo},
-		{_("Check internal metadata."),	   NULL},
-		{_("Scan all inodes."),		   NULL},
+		{_("Check internal metadata."),	   xfs_scan_metadata},
+		{_("Scan all inodes."),		   xfs_scan_inodes},
 		{NULL, REPAIR_DUMMY_FN},
 		{_("Verify data file integrity."), DATASCAN_DUMMY_FN},
-		{_("Check summary counters."),	   NULL},
+		{_("Check summary counters."),	   xfs_check_summary},
 		{NULL, NULL},
 	};
 	struct phase_info	pi;
@@ -698,9 +701,10 @@ run_scrub_phases(
 				phase->fn = preen;
 			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
 				phase->descr = _("Repair filesystem.");
+				phase->fn = xfs_repair_fs;
 			}
 		} else if (phase->fn == DATASCAN_DUMMY_FN && scrub_data)
-			;
+			phase->fn = xfs_scan_blocks;
 
 		if (phase->fn == REPAIR_DUMMY_FN ||
 		    phase->fn == DATASCAN_DUMMY_FN) {
@@ -906,6 +910,11 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (!moveon)
 		ret |= 4;
 
+	/* Clean up scan data. */
+	moveon = xfs_cleanup(&ctx);
+	if (!moveon)
+		ret |= 8;
+
 	if (ctx.repairs && ctx.preens)
 		fprintf(stdout,
 _("%s: %lu repairs and %lu optimizations made.\n"),
@@ -932,6 +941,8 @@ _("%s: %lu errors found.  Unmount and run xfs_repair.\n"),
 _("%s: %lu warnings found.\n"),
 			ctx.mntpoint, ctx.warnings_found);
 	if (ctx.errors_found) {
+		if (error_action == ERRORS_SHUTDOWN)
+			xfs_shutdown_fs(&ctx);
 		ret |= 1;
 	}
 	if (ctx.warnings_found) {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 114310d..c3ced73 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -56,6 +56,22 @@ struct scrub_ctx {
 	unsigned long		warnings_found;
 	unsigned long		repairs;
 	unsigned long		preens;
+
+	/* FS specific stuff */
+	struct xfs_fsop_geom	geo;
+	struct fs_path		fsinfo;
+	unsigned int		agblklog;
+	unsigned int		blocklog;
+	unsigned int		inodelog;
+	unsigned int		inopblog;
+	struct disk		logdev;
+	struct disk		rtdev;
+	void			*fshandle;
+	size_t			fshandle_len;
+	unsigned long long	capabilities;	/* see below */
+	struct read_verify_pool	rvp;
+	struct list_head	repair_list;
+	bool			preen_triggers[XFS_SCRUB_TYPE_MAX + 1];
 };
 
 enum errors_action {
@@ -124,4 +140,14 @@ static inline int syncfs(int fd)
 }
 #endif
 
+/* FS-specific functions */
+bool xfs_cleanup(struct scrub_ctx *ctx);
+bool xfs_scan_fs(struct scrub_ctx *ctx);
+bool xfs_scan_inodes(struct scrub_ctx *ctx);
+bool xfs_scan_metadata(struct scrub_ctx *ctx);
+bool xfs_check_summary(struct scrub_ctx *ctx);
+bool xfs_scan_blocks(struct scrub_ctx *ctx);
+bool xfs_repair_fs(struct scrub_ctx *ctx);
+void xfs_shutdown_fs(struct scrub_ctx *ctx);
+
 #endif /* SCRUB_H_ */
diff --git a/scrub/xfs.c b/scrub/xfs.c
new file mode 100644
index 0000000..7d6a249
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,1517 @@
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
+#include <attr/attributes.h>
+#include "disk.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "read_verify.h"
+#include "bitmap.h"
+#include "iocmd.h"
+#include "scrub.h"
+#include "xfs_ioctl.h"
+#include "xfs_fs.h"
+
+/*
+ * XFS Scrubbing Strategy
+ *
+ * The XFS scrubber uses custom XFS ioctls to probe more deeply into the
+ * internals of the filesystem.  It takes advantage of scrubbing ioctls
+ * to check all the records stored in a metadata btree and to
+ * cross-reference those records against the other metadata btrees.
+ *
+ * The "find geometry" phase queries XFS for the filesystem geometry.
+ * The block devices for the data, realtime, and log devices are opened.
+ * Kernel ioctls are queried to see if they are implemented, and a data
+ * file read-verify strategy is selected.
+ *
+ * In the "check internal metadata" phase, we call the SCRUB_METADATA
+ * ioctl to check the filesystem's internal per-AG btrees.  This
+ * includes the AG superblock, AGF, AGFL, and AGI headers, freespace
+ * btrees, the regular and free inode btrees, the reverse mapping
+ * btrees, and the reference counting btrees.  If the realtime device is
+ * enabled, the realtime bitmap and reverse mapping btrees are enabled.
+ * Each AG (and the realtime device) has its metadata checked in a
+ * separate thread for better performance.
+ *
+ * The "scan inodes" phase uses BULKSTAT to scan all the inodes in an
+ * AG in disk order.  From the BULKSTAT information, a file handle is
+ * constructed and the following items are checked:
+ *
+ *     - If it's a symlink, the target is read but not validated.
+ *     - Bulkstat data is checked.
+ *     - If the inode is a file or a directory, a file descriptor is
+ *       opened to pin the inode and for further analysis.
+ *     - Extended attribute names and values are read via the file
+ *       handle.  If this fails and we have a file descriptor open, we
+ *       retry with the generic extended attribute APIs.
+ *     - If the inode is not a file or directory, we're done.
+ *     - Extent maps are scanned to ensure that the records make sense.
+ *       We also use the SCRUB_METADATA ioctl for better checking of the
+ *       block mapping records.
+ *     - If the inode is a directory, open the directory and check that
+ *       the dirent type code and inode numbers match the stat output.
+ *
+ * Multiple threads are started to check each the inodes of each AG in
+ * parallel.
+ *
+ * In the "verify data file integrity" phase, we employ GETFSMAP to read
+ * the reverse-mappings of all AGs and issue direct-reads of the
+ * underlying disk blocks.  We rely on the underlying storage to have
+ * checksummed the data blocks appropriately.
+ *
+ * Multiple threads are started to check each AG in parallel.  A
+ * separate thread pool is used to handle the direct reads.
+ *
+ * In the "check summary counters" phase, use GETFSMAP to tally up the
+ * blocks and BULKSTAT to tally up the inodes we saw and compare that to
+ * the statfs output.  This gives the user a rough estimate of how
+ * thorough the scrub was.
+ */
+
+/* Routines to scrub an XFS filesystem. */
+
+#define XFS_SCRUB_CAP_PARENT_PTR	(1ULL << 0)	/* can find parent? */
+
+#define XFS_SCRUB_CAPABILITY_FUNCS(name, flagname) \
+static inline bool \
+xfs_scrub_can_##name(struct scrub_ctx *ctx) \
+{ \
+	return ctx->capabilities & XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_set_##name(struct scrub_ctx *ctx) \
+{ \
+	ctx->capabilities |= XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_clear_##name(struct scrub_ctx *ctx) \
+{ \
+	ctx->capabilities &= ~(XFS_SCRUB_CAP_##flagname); \
+}
+XFS_SCRUB_CAPABILITY_FUNCS(getparent,		PARENT_PTR)
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
+/* Shortcut to creating a read-verify thread pool. */
+static inline bool
+xfs_read_verify_pool_init(
+	struct scrub_ctx	*ctx,
+	read_verify_ioend_fn_t	ioend_fn)
+{
+	return read_verify_pool_init(&ctx->rvp, ctx, ctx->readbuf,
+			IO_MAX_SIZE, ctx->geo.blocksize, ioend_fn,
+			disk_heads(&ctx->datadev));
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
+/* BULKSTAT wrapper routines. */
+struct xfs_scan_inodes {
+	xfs_inode_iter_fn	fn;
+	void			*arg;
+	size_t			array_arg_size;
+	bool			moveon;
+};
+
+/* Scan all the inodes in an AG. */
+static void
+xfs_scan_ag_inodes(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_scan_inodes	*si = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	uint64_t		ag_ino;
+	uint64_t		next_ag_ino;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+				major(ctx->fsinfo.fs_datadev),
+				minor(ctx->fsinfo.fs_datadev),
+				agno);
+
+	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+
+	fn_arg = ((char *)si->arg) + si->array_arg_size * agno;
+	moveon = xfs_iterate_inodes(ctx, descr, ctx->fshandle, ag_ino,
+			next_ag_ino - 1, si->fn, fn_arg);
+	if (!moveon)
+		si->moveon = false;
+}
+
+/* How many array elements should we create to scan all the inodes? */
+static inline size_t
+xfs_scan_all_inodes_array_size(
+	struct scrub_ctx	*ctx)
+{
+	return ctx->geo.agcount;
+}
+
+/* Scan all the inodes in a filesystem. */
+static bool
+xfs_scan_all_inodes_array_arg(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	void			*arg,
+	size_t			array_arg_size)
+{
+	struct xfs_scan_inodes	si;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+
+	si.moveon = true;
+	si.fn = fn;
+	si.arg = arg;
+	si.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_inodes, agno, &si);
+	destroy_work_queue(&wq);
+
+	return si.moveon;
+}
+#define xfs_scan_all_inodes(ctx, fn) \
+	xfs_scan_all_inodes_array_arg((ctx), (fn), NULL, 0)
+#define xfs_scan_all_inodes_arg(ctx, fn, arg) \
+	xfs_scan_all_inodes_array_arg((ctx), (fn), (arg), 0)
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
+static size_t
+xfs_scan_all_blocks_array_size(
+	struct scrub_ctx	*ctx)
+{
+	return ctx->geo.agcount + 2;
+}
+
+/* Scan all the blocks in a filesystem. */
+static bool
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
+	struct bitmap			*tree;
+
+	/* Only report errors for real extents. */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		tree = vei->r_bad;
+	else
+		tree = vei->d_bad;
+
+	if (!bitmap_has_extent(tree, bmap->bm_physical, bmap->bm_length))
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
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
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
+/* Scan the inode associated with a directory entry. */
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
+	/* Open the file */
+	fd = dirent_open(dir_fd, dirent);
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
+	moveon = scan_fs_tree(ctx, NULL, xfs_report_verify_dirent, &vei);
+	if (!moveon)
+		return false;
+
+	/* Scan for unlinked files. */
+	return xfs_scan_all_inodes_arg(ctx, xfs_report_verify_inode, &vei);
+}
+
+/* Phase 1: Find filesystem geometry */
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
+	INIT_LIST_HEAD(&ctx->repair_list);
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
+	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx)) {
+		str_info(ctx, ctx->mntpoint,
+_("kernel metadata scrub is required."));
+		goto err;
+	}
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
+	ctx->nr_io_threads = libxfs_nproc();
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
+
+/* Phase 2: Check internal metadata. */
+
+/* Defer all the repairs until phase 4. */
+static void
+xfs_defer_repairs(
+	struct scrub_ctx	*ctx,
+	struct list_head	*repairs)
+{
+	if (list_empty(repairs))
+		return;
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(repairs, &ctx->repair_list);
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Repair some AG metadata; broken things are remembered for later. */
+static bool
+xfs_quick_repair(
+	struct scrub_ctx	*ctx,
+	struct list_head	*repairs)
+{
+	bool			moveon;
+
+	moveon = xfs_repair_metadata_list(ctx, ctx->mnt_fd, repairs,
+			XRML_REPAIR_ONLY);
+	if (!moveon)
+		return moveon;
+
+	xfs_defer_repairs(ctx, repairs);
+	return true;
+}
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
+	struct repair_item		*n;
+	struct repair_item		*ri;
+	struct list_head		repairs;
+	struct list_head		repair_now;
+	unsigned int			broken_primaries;
+	unsigned int			broken_secondaries;
+	bool				moveon;
+	char				descr[DESCR_BUFSZ];
+
+	INIT_LIST_HEAD(&repairs);
+	INIT_LIST_HEAD(&repair_now);
+	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
+
+	/*
+	 * First we scrub and fix the AG headers, because we need
+	 * them to work well enough to check the AG btrees.
+	 */
+	moveon = xfs_scrub_ag_headers(ctx, agno, &repairs);
+	if (!moveon)
+		goto err;
+
+	/* Repair header damage. */
+	moveon = xfs_quick_repair(ctx, &repairs);
+	if (!moveon)
+		goto err;
+
+	/* Now scrub the AG btrees. */
+	moveon = xfs_scrub_ag_metadata(ctx, agno, &repairs);
+	if (!moveon)
+		goto err;
+
+	/*
+	 * Figure out if we need to perform early fixing.  The only
+	 * reason we need to do this is if the inobt is broken, which
+	 * prevents phase 3 (inode scan) from running.  We can rebuild
+	 * the inobt from rmapbt data, but if the rmapbt is broken even
+	 * at this early phase then we are sunk.
+	 */
+	broken_secondaries = 0;
+	broken_primaries = 0;
+	list_for_each_entry_safe(ri, n, &repairs, list) {
+		switch (ri->op.sm_type) {
+		case XFS_SCRUB_TYPE_RMAPBT:
+			broken_secondaries++;
+			break;
+		case XFS_SCRUB_TYPE_FINOBT:
+		case XFS_SCRUB_TYPE_INOBT:
+			list_del(&ri->list);
+			list_add_tail(&ri->list, &repair_now);
+			/* fall through */
+		case XFS_SCRUB_TYPE_BNOBT:
+		case XFS_SCRUB_TYPE_CNTBT:
+		case XFS_SCRUB_TYPE_REFCNTBT:
+			broken_primaries++;
+			break;
+		default:
+			ASSERT(false);
+			break;
+		}
+	}
+	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		if (broken_primaries)
+			str_warn(ctx, descr,
+_("Corrupt primary and secondary block mapping metadata."));
+		else
+			str_warn(ctx, descr,
+_("Corrupt secondary block mapping metadata."));
+		str_warn(ctx, descr,
+_("Filesystem might not be repairable."));
+	}
+
+	/* Repair (inode) btree damage. */
+	moveon = xfs_quick_repair(ctx, &repair_now);
+	if (!moveon)
+		goto err;
+
+	/* Everything else gets fixed during phase 4. */
+	xfs_defer_repairs(ctx, &repairs);
+
+	return;
+err:
+	*pmoveon = false;
+	return;
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
+	struct list_head		repairs;
+	bool				moveon;
+
+	INIT_LIST_HEAD(&repairs);
+	moveon = xfs_scrub_fs_metadata(ctx, &repairs);
+	if (!moveon)
+		*pmoveon = false;
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(&repairs, &ctx->repair_list);
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Try to scan metadata via sysfs. */
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
+
+/* Phase 3: Scan all inodes. */
+
+/*
+ * Scrub part of a file.  If the user passes in a valid fd we assume
+ * that's the file to check; otherwise, pass in the inode number and
+ * let the kernel sort it out.
+ */
+static bool
+xfs_scrub_fd(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, uint64_t,
+				      uint32_t, int, struct list_head *),
+	struct xfs_bstat	*bs,
+	int			fd,
+	struct list_head	*repairs)
+{
+	if (fd < 0)
+		fd = ctx->mnt_fd;
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd, repairs);
+}
+
+/* Verify the contents, xattrs, and extent maps of an inode. */
+static int
+xfs_scrub_inode(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	void			*arg)
+{
+	struct list_head	repairs;
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	int			fd = -1;
+	int			error = 0;
+
+	INIT_LIST_HEAD(&repairs);
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu"), bstat->bs_ino);
+
+	/* Try to open the inode to pin it. */
+	if (S_ISREG(bstat->bs_mode) || S_ISDIR(bstat->bs_mode)) {
+		fd = open_by_fshandle(handle, sizeof(*handle),
+				O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+		if (fd < 0) {
+			error = errno;
+			if (error != ESTALE)
+				str_errno(ctx, descr);
+			goto out;
+		}
+	}
+
+	/* Scrub the inode. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_quick_repair(ctx, &repairs);
+	if (!moveon)
+		goto out;
+
+	/* Scrub all block mappings. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd,
+			&repairs);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_quick_repair(ctx, &repairs);
+	if (!moveon)
+		goto out;
+
+	/* XXX: Some day, check child -> parent dir -> child. */
+
+	if (S_ISLNK(bstat->bs_mode)) {
+		/* Check symlink contents. */
+		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
+				bstat->bs_gen, ctx->mnt_fd, &repairs);
+	} else if (S_ISDIR(bstat->bs_mode)) {
+		/* Check the directory entries. */
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd, &repairs);
+	}
+	if (!moveon)
+		goto out;
+
+	/*
+	 * Read all the extended attributes.  If any of the read
+	 * functions decline to move on, we can try again with the
+	 * VFS functions if we have a file descriptor.
+	 */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd, &repairs);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_quick_repair(ctx, &repairs);
+
+out:
+	xfs_defer_repairs(ctx, &repairs);
+	if (fd >= 0)
+		close(fd);
+	if (error)
+		return error;
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Verify all the inodes in a filesystem. */
+bool
+xfs_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	if (!xfs_scan_all_inodes(ctx, xfs_scrub_inode))
+		return false;
+	xfs_scrub_report_preen_triggers(ctx);
+	return true;
+}
+
+/* Phase 4: Repair filesystem. */
+
+static int
+list_length(
+	struct list_head		*head)
+{
+	struct list_head		*pos;
+	int				nr = 0;
+
+	list_for_each(pos, head) {
+		nr++;
+	}
+
+	return nr;
+}
+
+/* Fix the per-AG and per-FS metadata. */
+bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	int				len;
+	int				old_len;
+	bool				moveon;
+
+	/* Repair anything broken until we fail to make progress. */
+	len = list_length(&ctx->repair_list);
+	do {
+		old_len = len;
+		moveon = xfs_repair_metadata_list(ctx, ctx->mnt_fd,
+				&ctx->repair_list, 0);
+		if (!moveon)
+			return false;
+		len = list_length(&ctx->repair_list);
+	} while (old_len > len);
+
+	/* Try once more, but this time complain if we can't fix things. */
+	moveon = xfs_repair_metadata_list(ctx, ctx->mnt_fd,
+			&ctx->repair_list, XRML_NOFIX_COMPLAIN);
+	if (!moveon)
+		return false;
+
+	fstrim(ctx);
+	return true;
+}
+
+/* Phase 5: Verify data file integrity. */
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
+	} else if (xfs_scrub_can_getparent(ctx)) {
+		/* XXX: go find the parent path */
+		str_error(ctx, buf,
+_("XXX: inode %lld offset %llu failed read verification."),
+				map->fmr_owner, map->fmr_offset + err_off);
+	}
+	return true;
+}
+
+/* Handle a read error in the rmap-based read verify. */
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
+	if (!xfs_scrub_can_getparent(ctx)) {
+		if (dev == ctx->fsinfo.fs_datadev)
+			tree = ve->d_bad;
+		else if (dev == ctx->fsinfo.fs_rtdev)
+			tree = ve->r_bad;
+		else
+			tree = NULL;
+		if (tree) {
+			moveon = bitmap_add(tree, start, length);
+			if (!moveon)
+				str_errno(ctx, ctx->mntpoint);
+		}
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
+/* Read verify a (data block) extent. */
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
+	read_verify_schedule(&ctx->rvp, &ve->rv, disk, map->fmr_physical,
+			map->fmr_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmr_flags & FMR_OF_LAST)
+		read_verify_force(&ctx->rvp, &ve->rv);
+
+	return true;
+}
+
+/* Verify all the blocks in a filesystem. */
+bool
+xfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct bitmap			d_bad;
+	struct bitmap			r_bad;
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
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+	}
+
+	moveon = xfs_read_verify_pool_init(ctx, xfs_check_rmap_ioerr);
+	if (!moveon)
+		goto out_rbad;
+	moveon = xfs_scan_all_blocks_array_arg(ctx, xfs_check_rmap,
+			ve, sizeof(*ve));
+	if (!moveon)
+		goto out_pool;
+
+	for (i = 0, v = ve; i < groups; i++, v++)
+		read_verify_force(&ctx->rvp, &v->rv);
+	read_verify_pool_destroy(&ctx->rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!bitmap_empty(&d_bad) || !bitmap_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
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
+
+/* Phase 6: Check summary counters. */
+
+struct xfs_summary_counts {
+	unsigned long long	inodes;		/* number of inodes */
+	unsigned long long	dbytes;		/* data dev bytes */
+	unsigned long long	rbytes;		/* rt dev bytes */
+	unsigned long long	next_phys;	/* next phys bytes we see? */
+	unsigned long long	agbytes;	/* freespace bytes */
+	struct bitmap		dext;		/* data block extent bitmap */
+	struct bitmap		rext;		/* rt block extent bitmap */
+};
+
+struct xfs_inode_fork_summary {
+	struct bitmap		*tree;
+	unsigned long long	bytes;
+};
+
+/* Record inode and block usage. */
+static int
+xfs_record_inode_summary(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct xfs_summary_counts	*counts = arg;
+
+	counts->inodes++;
+	return 0;
+}
+
+/* Record block usage. */
+static bool
+xfs_record_block_summary(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct fsmap			*fsmap,
+	void				*arg)
+{
+	struct xfs_summary_counts	*counts = arg;
+	unsigned long long		len;
+
+	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
+		return true;
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == XFS_FMR_OWN_FREE)
+		return true;
+
+	len = fsmap->fmr_length;
+
+	/* freesp btrees live in free space, need to adjust counters later. */
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == XFS_FMR_OWN_AG) {
+		counts->agbytes += fsmap->fmr_length;
+	}
+	if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev) {
+		/* Count realtime extents. */
+		counts->rbytes += len;
+	} else {
+		/* Count datadev extents. */
+		if (counts->next_phys >= fsmap->fmr_physical + len)
+			return true;
+		else if (counts->next_phys > fsmap->fmr_physical)
+			len = counts->next_phys - fsmap->fmr_physical;
+		counts->dbytes += len;
+		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
+	}
+
+	return true;
+}
+
+/* Count all inodes and blocks in the filesystem, compare to superblock. */
+bool
+xfs_check_summary(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_fsop_counts		fc;
+	struct xfs_fsop_resblks		rb;
+	struct xfs_fsop_ag_resblks	arb;
+	struct statvfs			sfs;
+	struct xfs_summary_counts	*summary;
+	unsigned long long		fd;
+	unsigned long long		fr;
+	unsigned long long		fi;
+	unsigned long long		sd;
+	unsigned long long		sr;
+	unsigned long long		si;
+	unsigned long long		absdiff;
+	xfs_agnumber_t			agno;
+	bool				moveon;
+	bool				complain;
+	unsigned int			groups;
+	int				error;
+
+	groups = xfs_scan_all_blocks_array_size(ctx);
+	summary = calloc(groups, sizeof(struct xfs_summary_counts));
+	if (!summary) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Flush everything out to disk before we start counting. */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Use fsmap to count blocks. */
+	moveon = xfs_scan_all_blocks_array_arg(ctx, xfs_record_block_summary,
+			summary, sizeof(*summary));
+	if (!moveon)
+		goto out;
+
+	/* Scan the whole fs. */
+	moveon = xfs_scan_all_inodes_array_arg(ctx, xfs_record_inode_summary,
+			summary, sizeof(*summary));
+	if (!moveon)
+		goto out;
+
+	/* Sum the counts. */
+	for (agno = 1; agno < groups; agno++) {
+		summary[0].inodes += summary[agno].inodes;
+		summary[0].dbytes += summary[agno].dbytes;
+		summary[0].rbytes += summary[agno].rbytes;
+		summary[0].agbytes += summary[agno].agbytes;
+	}
+
+	/* Fetch the filesystem counters. */
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSCOUNTS, &fc);
+	if (error)
+		str_errno(ctx, ctx->mntpoint);
+
+	/* Grab the fstatvfs counters, since it has to report accurately. */
+	error = fstatvfs(ctx->mnt_fd, &sfs);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/*
+	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
+	 * blocks back to the free data counts.
+	 */
+	error = ioctl(ctx->mnt_fd, XFS_IOC_GET_RESBLKS, &rb);
+	if (error)
+		str_errno(ctx, ctx->mntpoint);
+	sfs.f_bfree += rb.resblks_avail;
+
+	/*
+	 * XFS with rmap or reflink reserves blocks in each AG to
+	 * prevent the AG from running out of space for metadata blocks.
+	 * Add those back to the free data counts.
+	 */
+	memset(&arb, 0, sizeof(arb));
+	error = ioctl(ctx->mnt_fd, XFS_IOC_GET_AG_RESBLKS, &arb);
+	if (error && errno != ENOTTY)
+		str_errno(ctx, ctx->mntpoint);
+	sfs.f_bfree += arb.resblks;
+
+	/*
+	 * If we counted blocks with fsmap, then dblocks includes
+	 * blocks for the AGFL and the freespace/rmap btrees.  The
+	 * filesystem treats them as "free", but since we scanned
+	 * them, we'll consider them used.
+	 */
+	sfs.f_bfree -= summary[0].agbytes >> ctx->blocklog;
+
+	/* Report on what we found. */
+	fd = (ctx->geo.datablocks - sfs.f_bfree) << ctx->blocklog;
+	fr = (ctx->geo.rtblocks - fc.freertx) << ctx->blocklog;
+	fi = sfs.f_files - sfs.f_ffree;
+	sd = summary[0].dbytes;
+	sr = summary[0].rbytes;
+	si = summary[0].inodes;
+
+	/*
+	 * Complain if the counts are off by more than 10% unless
+	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
+	 */
+	absdiff = 1ULL << 25;
+	complain = !within_range(ctx, sd, fd, absdiff, 1, 10, _("data blocks"));
+	complain |= !within_range(ctx, sr, fr, absdiff, 1, 10, _("realtime blocks"));
+	complain |= !within_range(ctx, si, fi, 100, 1, 10, _("inodes"));
+
+	if (complain || verbose) {
+		double		d, r, i;
+		char		*du, *ru, *iu;
+
+		if (fr || sr) {
+			d = auto_space_units(fd, &du);
+			r = auto_space_units(fr, &ru);
+			i = auto_units(fi, &iu);
+			fprintf(stdout,
+_("%.1f%s data used;  %.1f%s realtime data used;  %.2f%s inodes used.\n"),
+					d, du, r, ru, i, iu);
+			d = auto_space_units(sd, &du);
+			r = auto_space_units(sr, &ru);
+			i = auto_units(si, &iu);
+			fprintf(stdout,
+_("%.1f%s data found; %.1f%s realtime data found; %.2f%s inodes found.\n"),
+					d, du, r, ru, i, iu);
+		} else {
+			d = auto_space_units(fd, &du);
+			i = auto_units(fi, &iu);
+			fprintf(stdout,
+_("%.1f%s data used;  %.1f%s inodes used.\n"),
+					d, du, i, iu);
+			d = auto_space_units(sd, &du);
+			i = auto_units(si, &iu);
+			fprintf(stdout,
+_("%.1f%s data found; %.1f%s inodes found.\n"),
+					d, du, i, iu);
+		}
+		fflush(stdout);
+	}
+	moveon = true;
+
+out:
+	for (agno = 0; agno < groups; agno++) {
+		bitmap_free(&summary[agno].dext);
+		bitmap_free(&summary[agno].rext);
+	}
+	free(summary);
+	return moveon;
+}
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
diff --git a/scrub/xfs_ioctl.c b/scrub/xfs_ioctl.c
new file mode 100644
index 0000000..f71e1f7
--- /dev/null
+++ b/scrub/xfs_ioctl.c
@@ -0,0 +1,968 @@
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
+#include "scrub.h"
+#include "xfs_ioctl.h"
+
+#define FSMAP_NR		65536
+#define BMAP_NR			2048
+
+/* Call the handler function. */
+static int
+xfs_iterate_inode_func(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	struct xfs_bstat	*bs,
+	struct xfs_handle	*handle,
+	void			*arg)
+{
+	int			error;
+
+	handle->ha_fid.fid_ino = bs->bs_ino;
+	handle->ha_fid.fid_gen = bs->bs_gen;
+	error = fn(ctx, handle, bs, arg);
+	if (error)
+		return error;
+	if (xfs_scrub_excessive_errors(ctx))
+		return XFS_ITERATE_INODES_ABORT;
+	return 0;
+}
+
+/* Iterate a range of inodes. */
+bool
+xfs_iterate_inodes(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	void			*fshandle,
+	uint64_t		first_ino,
+	uint64_t		last_ino,
+	xfs_inode_iter_fn	fn,
+	void			*arg)
+{
+	struct xfs_fsop_bulkreq	igrpreq = {0};
+	struct xfs_fsop_bulkreq	bulkreq = {0};
+	struct xfs_fsop_bulkreq	onereq = {0};
+	struct xfs_handle	handle;
+	struct xfs_inogrp	inogrp;
+	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK] = {0};
+	char			idescr[DESCR_BUFSZ];
+	char			buf[DESCR_BUFSZ];
+	struct xfs_bstat	*bs;
+	__u64			last_stale = first_ino - 1;
+	__u64			igrp_ino;
+	__u64			oneino;
+	__u64			ino;
+	__s32			bulklen = 0;
+	__s32			onelen = 0;
+	__s32			igrplen = 0;
+	bool			moveon = true;
+	int			i;
+	int			error;
+	int			stale_count = 0;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BULKSTAT"));
+
+	onereq.lastip  = &oneino;
+	onereq.icount  = 1;
+	onereq.ocount  = &onelen;
+
+	bulkreq.lastip  = &ino;
+	bulkreq.icount  = XFS_INODES_PER_CHUNK;
+	bulkreq.ubuffer = &bstat;
+	bulkreq.ocount  = &bulklen;
+
+	igrpreq.lastip  = &igrp_ino;
+	igrpreq.icount  = 1;
+	igrpreq.ubuffer = &inogrp;
+	igrpreq.ocount  = &igrplen;
+
+	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
+	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle.ha_fid.fid_len);
+	handle.ha_fid.fid_pad = 0;
+
+	/* Find the inode chunk & alloc mask */
+	igrp_ino = first_ino;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	while (!error && igrplen) {
+		/* Load the inodes. */
+		ino = inogrp.xi_startino - 1;
+		bulkreq.icount = inogrp.xi_alloccount;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		if (error)
+			str_warn(ctx, descr, "%s", strerror_r(errno,
+						buf, DESCR_BUFSZ));
+
+		/* Did we get exactly the inodes we expected? */
+		for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
+			if (!(inogrp.xi_allocmask & (1ULL << i)))
+				continue;
+			if (bs->bs_ino == inogrp.xi_startino + i) {
+				bs++;
+				continue;
+			}
+
+			/* Load the one inode. */
+			oneino = inogrp.xi_startino + i;
+			onereq.ubuffer = bs;
+			error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT_SINGLE,
+					&onereq);
+			if (error || bs->bs_ino != inogrp.xi_startino + i) {
+				memset(bs, 0, sizeof(struct xfs_bstat));
+				bs->bs_ino = inogrp.xi_startino + i;
+				bs->bs_blksize = ctx->mnt_sv.f_frsize;
+			}
+			bs++;
+		}
+
+		/* Iterate all the inodes. */
+		for (i = 0, bs = bstat; i < inogrp.xi_alloccount; i++, bs++) {
+			if (bs->bs_ino > last_ino)
+				goto out;
+
+			error = xfs_iterate_inode_func(ctx, fn, bs, &handle,
+					arg);
+			switch (error) {
+			case 0:
+				break;
+			case ESTALE:
+				if (last_stale == inogrp.xi_startino)
+					stale_count++;
+				else {
+					last_stale = inogrp.xi_startino;
+					stale_count = 0;
+				}
+				if (stale_count < 30) {
+					igrp_ino = inogrp.xi_startino;
+					goto igrp_retry;
+				}
+				snprintf(idescr, DESCR_BUFSZ, "inode %llu",
+						bs->bs_ino);
+				str_warn(ctx, idescr, "%s", strerror_r(error,
+						buf, DESCR_BUFSZ));
+				break;
+			case XFS_ITERATE_INODES_ABORT:
+				error = 0;
+				/* fall thru */
+			default:
+				moveon = false;
+				errno = error;
+				goto err;
+			}
+		}
+
+igrp_retry:
+		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	}
+
+err:
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	return moveon;
+}
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
+/* Iterate all the extent block mappings between the two keys. */
+bool
+xfs_iterate_bmap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	int			whichfork,
+	struct xfs_bmap		*key,
+	xfs_bmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsxattr		fsx;
+	struct getbmapx		*map;
+	struct getbmapx		*p;
+	struct xfs_bmap		bmap;
+	char			bmap_descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_off_t		new_off;
+	int			getxattr_type;
+	int			i;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BMAP"));
+
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s attr"), descr);
+		break;
+	case XFS_COW_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s CoW"), descr);
+		break;
+	case XFS_DATA_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s data"), descr);
+		break;
+	default:
+		assert(0);
+	}
+
+	map = calloc(BMAP_NR, sizeof(struct getbmapx));
+	if (!map) {
+		str_errno(ctx, bmap_descr);
+		return false;
+	}
+
+	map->bmv_offset = BTOBB(key->bm_offset);
+	map->bmv_block = BTOBB(key->bm_physical);
+	if (key->bm_length == 0)
+		map->bmv_length = ULLONG_MAX;
+	else
+		map->bmv_length = BTOBB(key->bm_length);
+	map->bmv_count = BMAP_NR;
+	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
+			  BMV_OF_DELALLOC | BMV_IF_NO_HOLES;
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		getxattr_type = XFS_IOC_FSGETXATTRA;
+		map->bmv_iflags |= BMV_IF_ATTRFORK;
+		break;
+	case XFS_COW_FORK:
+		map->bmv_iflags |= BMV_IF_COWFORK;
+		getxattr_type = FS_IOC_FSGETXATTR;
+		break;
+	case XFS_DATA_FORK:
+		getxattr_type = FS_IOC_FSGETXATTR;
+		break;
+	default:
+		abort();
+	}
+
+	error = ioctl(fd, getxattr_type, &fsx);
+	if (error < 0) {
+		str_errno(ctx, bmap_descr);
+		moveon = false;
+		goto out;
+	}
+
+	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
+		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
+			bmap.bm_offset = BBTOB(p->bmv_offset);
+			bmap.bm_physical = BBTOB(p->bmv_block);
+			bmap.bm_length = BBTOB(p->bmv_length);
+			bmap.bm_flags = p->bmv_oflags;
+			moveon = fn(ctx, bmap_descr, fd, whichfork, &fsx,
+					&bmap, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+
+		if (map->bmv_entries == 0)
+			break;
+		p = map + map->bmv_entries;
+		if (p->bmv_oflags & BMV_OF_LAST)
+			break;
+
+		new_off = p->bmv_offset + p->bmv_length;
+		map->bmv_length -= new_off - map->bmv_offset;
+		map->bmv_offset = new_off;
+	}
+
+	/* Pre-reflink filesystems don't know about CoW forks. */
+	if (whichfork == XFS_COW_FORK && error && errno == EINVAL)
+		error = 0;
+
+	if (error)
+		str_errno(ctx, bmap_descr);
+out:
+	memcpy(key, map, sizeof(struct getbmapx));
+	free(map);
+	return moveon;
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
+/* Iterate all the fs block mappings between the two keys. */
+bool
+xfs_iterate_fsmap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fsmap		*keys,
+	xfs_fsmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsmap_head	*head;
+	struct fsmap		*p;
+	bool			moveon = true;
+	int			i;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_FSMAP"));
+
+	head = malloc(fsmap_sizeof(FSMAP_NR));
+	if (!head) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	memset(head, 0, sizeof(*head));
+	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
+	head->fmh_count = FSMAP_NR;
+
+	while ((error = ioctl(ctx->mnt_fd, FS_IOC_GETFSMAP, head)) == 0) {
+		for (i = 0, p = head->fmh_recs;
+		     i < head->fmh_entries;
+		     i++, p++) {
+			moveon = fn(ctx, descr, p, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+
+		if (head->fmh_entries == 0)
+			break;
+		p = &head->fmh_recs[head->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(head);
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	free(head);
+	return moveon;
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
+/* Online scrub and repair. */
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
+	{"dummy",				ST_NONE},
+	{"superblock",				ST_AGHEADER},
+	{"free space header",			ST_AGHEADER},
+	{"free list",				ST_AGHEADER},
+	{"inode header",			ST_AGHEADER},
+	{"freesp by block btree",		ST_PERAG},
+	{"freesp by length btree",		ST_PERAG},
+	{"inode btree",				ST_PERAG},
+	{"free inode btree",			ST_PERAG},
+	{"reverse mapping btree",		ST_PERAG},
+	{"reference count btree",		ST_PERAG},
+	{"inode record",			ST_INODE},
+	{"data block map",			ST_INODE},
+	{"attr block map",			ST_INODE},
+	{"CoW block map",			ST_INODE},
+	{"directory entries",			ST_INODE},
+	{"extended attributes",			ST_INODE},
+	{"symbolic link",			ST_INODE},
+	{"realtime bitmap",			ST_FS},
+	{"realtime summary",			ST_FS},
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
+static inline bool
+IS_CORRUPT(
+	__u32				flags)
+{
+	return flags & (XFS_SCRUB_FLAG_CORRUPT | XFS_SCRUB_FLAG_XCORRUPT);
+}
+
+/* Do we need to repair something? */
+static inline bool
+xfs_scrub_needs_repair(
+	struct xfs_scrub_metadata	*sm)
+{
+	return IS_CORRUPT(sm->sm_flags);
+}
+
+/* Can we optimize something? */
+static inline bool
+xfs_scrub_needs_preen(
+	struct xfs_scrub_metadata	*sm)
+{
+	return sm->sm_flags & XFS_SCRUB_FLAG_PREEN;
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
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	assert(meta->sm_type <= XFS_SCRUB_TYPE_MAX);
+	format_scrub_descr(buf, DESCR_BUFSZ, meta, &scrubbers[meta->sm_type]);
+
+	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, meta);
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
+		meta->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	if (error) {
+		/* Metadata not present, just skip it. */
+		if (errno == ENOENT)
+			return CHECK_DONE;
+		else if (errno == ESHUTDOWN) {
+			/* FS already crashed, give up. */
+			str_error(ctx, buf,
+_("Filesystem is shut down, aborting."));
+			return CHECK_ABORT;
+		}
+
+		/* Operational error. */
+		str_errno(ctx, buf);
+		return CHECK_DONE;
+	} else if (!xfs_scrub_needs_repair(meta) &&
+		   !xfs_scrub_needs_preen(meta)) {
+		/* Clean operation, no corruption or preening detected. */
+		return CHECK_DONE;
+	} else if (xfs_scrub_needs_repair(meta) &&
+		   ctx->mode < SCRUB_MODE_REPAIR) {
+		/* Corrupt, but we're not in repair mode. */
+		str_error(ctx, buf, _("Repairs are required."));
+		return CHECK_DONE;
+	} else if (xfs_scrub_needs_preen(meta) &&
+		   ctx->mode < SCRUB_MODE_PREEN) {
+		/* Preenable, but we're not in preen mode. */
+		if (!is_inode) {
+			/* AG or FS metadata, always warn. */
+			str_info(ctx, buf, _("Optimization is possible."));
+		} else if (!ctx->preen_triggers[meta->sm_type]) {
+			/* File metadata, only warn once per type. */
+			pthread_mutex_lock(&ctx->lock);
+			if (!ctx->preen_triggers[meta->sm_type])
+				ctx->preen_triggers[meta->sm_type] = true;
+			pthread_mutex_unlock(&ctx->lock);
+		}
+		return CHECK_DONE;
+	}
+
+	return CHECK_REPAIR;
+}
+
+/* Bulk-notify user about things that could be optimized. */
+void
+xfs_scrub_report_preen_triggers(
+	struct scrub_ctx		*ctx)
+{
+	int				i;
+
+	for (i = 0; i <= XFS_SCRUB_TYPE_MAX; i++) {
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
+	xfs_agnumber_t			agno,
+	struct list_head		*repair_list)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	const struct scrub_descr	*sc;
+	struct repair_item		*ri;
+	enum check_outcome		fix;
+	int				type;
+
+	sc = scrubbers;
+	for (type = 0; type <= XFS_SCRUB_TYPE_MAX; type++, sc++) {
+		if (sc->type != scrub_type)
+			continue;
+
+		meta.sm_type = type;
+		meta.sm_flags = 0;
+		meta.sm_agno = agno;
+
+		/* Check the item. */
+		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+		if (fix == CHECK_ABORT)
+			return false;
+		if (fix == CHECK_DONE)
+			continue;
+
+		/* Schedule this item for later repairs. */
+		ri = malloc(sizeof(struct repair_item));
+		if (!ri) {
+			str_errno(ctx, _("repair list"));
+			return false;
+		}
+		ri->op = meta;
+		list_add_tail(&ri->list, repair_list);
+	}
+
+	return true;
+}
+
+/* Scrub each AG's header blocks. */
+bool
+xfs_scrub_ag_headers(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct list_head		*repair_list)
+{
+	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno, repair_list);
+}
+
+/* Scrub each AG's metadata btrees. */
+bool
+xfs_scrub_ag_metadata(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct list_head		*repair_list)
+{
+	return xfs_scrub_metadata(ctx, ST_PERAG, agno, repair_list);
+}
+
+/* Scrub whole-FS metadata btrees. */
+bool
+xfs_scrub_fs_metadata(
+	struct scrub_ctx		*ctx,
+	struct list_head		*repair_list)
+{
+	return xfs_scrub_metadata(ctx, ST_FS, 0, repair_list);
+}
+
+/* Scrub inode metadata. */
+static bool
+__xfs_scrub_file(
+	struct scrub_ctx		*ctx,
+	uint64_t			ino,
+	uint32_t			gen,
+	int				fd,
+	unsigned int			type,
+	struct list_head		*repair_list)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	struct repair_item		*ri;
+	enum check_outcome		fix;
+
+	assert(type <= XFS_SCRUB_TYPE_MAX);
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
+	/* Schedule this item for later repairs. */
+	ri = malloc(sizeof(struct repair_item));
+	if (!ri) {
+		str_errno(ctx, _("repair list"));
+		return false;
+	}
+	ri->op = meta;
+	list_add_tail(&ri->list, repair_list);
+	return true;
+}
+
+#define XFS_SCRUB_FILE_PART(name, flagname) \
+bool \
+xfs_scrub_##name( \
+	struct scrub_ctx		*ctx, \
+	uint64_t			ino, \
+	uint32_t			gen, \
+	int				fd, \
+	struct list_head		*repair_list) \
+{ \
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_##flagname, \
+			repair_list); \
+}
+XFS_SCRUB_FILE_PART(inode_fields,	INODE)
+XFS_SCRUB_FILE_PART(data_fork,		BMBTD)
+XFS_SCRUB_FILE_PART(attr_fork,		BMBTA)
+XFS_SCRUB_FILE_PART(cow_fork,		BMBTC)
+XFS_SCRUB_FILE_PART(dir,		DIR)
+XFS_SCRUB_FILE_PART(attr,		XATTR)
+XFS_SCRUB_FILE_PART(symlink,		SYMLINK)
+
+/*
+ * Prioritize repair items in order of how long we can wait.
+ * 0 = do it now, 10000 = do it later.
+ *
+ * To minimize the amount of repair work, we want to prioritize metadata
+ * objects by perceived corruptness.  If CORRUPT is set, the fields are
+ * just plain bad; try fixing that first.  Otherwise if XCORRUPT is set,
+ * the fields could be bad, but the xref data could also be bad; we'll
+ * try fixing that next.  Finally, if XFAIL is set, some other metadata
+ * structure failed validation during xref, so we'll recheck this
+ * metadata last since it was probably fine.
+ *
+ * For metadata that lie in the critical path of checking other metadata
+ * (superblock, AG{F,I,FL}, inobt) we scrub and fix those things before
+ * we even get to handling their dependencies, so things should progress
+ * in order.
+ */
+static int
+PRIO(
+	struct xfs_scrub_metadata	*op,
+	int				order)
+{
+	if (op->sm_flags & XFS_SCRUB_FLAG_CORRUPT)
+		return order;
+	else if (op->sm_flags & XFS_SCRUB_FLAG_XCORRUPT)
+		return 100 + order;
+	else if (op->sm_flags & XFS_SCRUB_FLAG_XFAIL)
+		return 200 + order;
+	else if (op->sm_flags & XFS_SCRUB_FLAG_PREEN)
+		return 300 + order;
+	abort();
+}
+
+static int
+xfs_repair_item_priority(
+	struct repair_item		*ri)
+{
+	switch (ri->op.sm_type) {
+	case XFS_SCRUB_TYPE_SB:
+		return PRIO(&ri->op, 0);
+	case XFS_SCRUB_TYPE_AGF:
+		return PRIO(&ri->op, 1);
+	case XFS_SCRUB_TYPE_AGFL:
+		return PRIO(&ri->op, 2);
+	case XFS_SCRUB_TYPE_AGI:
+		return PRIO(&ri->op, 3);
+	case XFS_SCRUB_TYPE_BNOBT:
+	case XFS_SCRUB_TYPE_CNTBT:
+	case XFS_SCRUB_TYPE_INOBT:
+	case XFS_SCRUB_TYPE_FINOBT:
+	case XFS_SCRUB_TYPE_REFCNTBT:
+		return PRIO(&ri->op, 4);
+	case XFS_SCRUB_TYPE_RMAPBT:
+		return PRIO(&ri->op, 5);
+	case XFS_SCRUB_TYPE_INODE:
+		return PRIO(&ri->op, 6);
+	case XFS_SCRUB_TYPE_BMBTD:
+	case XFS_SCRUB_TYPE_BMBTA:
+	case XFS_SCRUB_TYPE_BMBTC:
+		return PRIO(&ri->op, 7);
+	case XFS_SCRUB_TYPE_DIR:
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_SYMLINK:
+		return PRIO(&ri->op, 8);
+	case XFS_SCRUB_TYPE_RTBITMAP:
+	case XFS_SCRUB_TYPE_RTSUM:
+		return PRIO(&ri->op, 9);
+	}
+	abort();
+}
+
+/* Make sure that btrees get repaired before headers. */
+static int
+xfs_repair_item_compare(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct repair_item		*ra;
+	struct repair_item		*rb;
+
+	ra = container_of(a, struct repair_item, list);
+	rb = container_of(b, struct repair_item, list);
+
+	return xfs_repair_item_priority(ra) - xfs_repair_item_priority(rb);
+}
+
+/* Repair some metadata. */
+static enum check_outcome
+xfs_repair_metadata(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct xfs_scrub_metadata	*meta,
+	bool				complain_if_still_broken)
+{
+	char				buf[DESCR_BUFSZ];
+	__u32				oldf = meta->sm_flags;
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	meta->sm_flags |= XFS_SCRUB_FLAG_REPAIR;
+	assert(meta->sm_type <= XFS_SCRUB_TYPE_MAX);
+	format_scrub_descr(buf, DESCR_BUFSZ, meta, &scrubbers[meta->sm_type]);
+
+	if (xfs_scrub_needs_repair(meta))
+		str_info(ctx, buf, _("Attempting repair."));
+	else if (debug || verbose)
+		str_info(ctx, buf, _("Attempting optimization."));
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, meta);
+	if (error) {
+		switch (errno) {
+		case ESHUTDOWN:
+			/* Filesystem is already shut down, abort. */
+			str_error(ctx, buf,
+_("Filesystem is shut down, aborting."));
+			return CHECK_ABORT;
+		case ENOTTY:
+		case EOPNOTSUPP:
+			/*
+			 * If we forced repairs, don't complain if kernel
+			 * doesn't know how to fix.
+			 */
+			if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+				return CHECK_DONE;
+			/* fall through */
+		case EINVAL:
+			/* Kernel doesn't know how to repair this? */
+			if (complain_if_still_broken)
+				str_error(ctx, buf,
+_("Don't know how to fix; offline repair required."));
+			return CHECK_REPAIR;
+		case EROFS:
+			/* Read-only filesystem, can't fix. */
+			if (verbose || debug || IS_CORRUPT(oldf))
+				str_info(ctx, buf,
+_("Read-only filesystem; cannot make changes."));
+			return CHECK_DONE;
+		case ENOENT:
+			/* Metadata not present, just skip it. */
+			return CHECK_DONE;
+		case ENOMEM:
+		case ENOSPC:
+			/* Don't care if preen fails due to low resources. */
+			if (oldf & XFS_SCRUB_FLAG_PREEN)
+				return CHECK_DONE;
+			/* fall through */
+		default:
+			/* Operational error. */
+			str_errno(ctx, buf);
+			return CHECK_DONE;
+		}
+	} else if (xfs_scrub_needs_repair(meta)) {
+		/* Still broken, try again or fix offline. */
+		if (complain_if_still_broken)
+			str_error(ctx, buf,
+_("Repair unsuccessful; offline repair required."));
+		return CHECK_REPAIR;
+	} else {
+		/* Clean operation, no corruption detected. */
+		if (IS_CORRUPT(oldf))
+			record_repair(ctx, buf, _("Repairs successful."));
+		else
+			record_preen(ctx, buf, _("Optimization successful."));
+		return CHECK_DONE;
+	}
+}
+
+/* Repair everything on this list. */
+bool
+xfs_repair_metadata_list(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct list_head		*repair_list,
+	unsigned int			flags)
+{
+	struct repair_item		*ri;
+	struct repair_item		*n;
+	enum check_outcome		fix;
+
+	list_sort(NULL, repair_list, xfs_repair_item_compare);
+
+	list_for_each_entry_safe(ri, n, repair_list, list) {
+		if (!IS_CORRUPT(ri->op.sm_flags) &&
+		    (flags & XRML_REPAIR_ONLY))
+			continue;
+		fix = xfs_repair_metadata(ctx, fd, &ri->op,
+				flags & XRML_NOFIX_COMPLAIN);
+		if (fix == CHECK_ABORT)
+			return false;
+		else if (fix == CHECK_REPAIR)
+			continue;
+
+		list_del(&ri->list);
+		free(ri);
+	}
+
+	return !xfs_scrub_excessive_errors(ctx);
+}
+
+/* Test the availability of a kernel scrub command. */
+static bool
+__xfs_scrub_test(
+	struct scrub_ctx		*ctx,
+	unsigned int			type)
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
+#define XFS_ERRTAG_FORCE_REPAIR	28
+		inject.errtag = XFS_ERRTAG_FORCE_REPAIR;
+		error = ioctl(ctx->mnt_fd,
+				XFS_IOC_ERROR_INJECTION, &inject);
+		if (error == 0)
+			injected = true;
+	}
+
+	meta.sm_type = type;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_SCRUB_METADATA, &meta);
+	return error == 0 || (error && errno != EOPNOTSUPP && errno != ENOTTY);
+}
+
+#define XFS_CAN_SCRUB_TEST(name, flagname) \
+bool \
+xfs_can_scrub_##name( \
+	struct scrub_ctx		*ctx) \
+{ \
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_##flagname); \
+}
+XFS_CAN_SCRUB_TEST(fs_metadata,		SB)
+XFS_CAN_SCRUB_TEST(inode,		INODE)
+XFS_CAN_SCRUB_TEST(bmap,		BMBTD)
+XFS_CAN_SCRUB_TEST(dir,			DIR)
+XFS_CAN_SCRUB_TEST(attr,		XATTR)
+XFS_CAN_SCRUB_TEST(symlink,		SYMLINK)
diff --git a/scrub/xfs_ioctl.h b/scrub/xfs_ioctl.h
new file mode 100644
index 0000000..78eec51
--- /dev/null
+++ b/scrub/xfs_ioctl.h
@@ -0,0 +1,103 @@
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
+#ifndef XFS_IOCTL_H_
+#define XFS_IOCTL_H_
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
+	CHECK_DONE,
+	CHECK_REPAIR,
+	CHECK_ABORT,
+};
+
+struct repair_item {
+	struct list_head		list;
+	struct xfs_scrub_metadata	op;
+};
+
+void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
+bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct list_head *repair_list);
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct list_head *repair_list);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+		struct list_head *repair_list);
+
+#define XRML_REPAIR_ONLY	1 /* no optimizations */
+#define XRML_NOFIX_COMPLAIN	2 /* complain if still corrupt */
+bool xfs_repair_metadata_list(struct scrub_ctx *ctx, int fd,
+		struct list_head *repair_list, unsigned int flags);
+
+bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
+bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
+bool xfs_can_scrub_bmap(struct scrub_ctx *ctx);
+bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
+bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
+bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
+
+bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd, struct list_head *repair_list);
+
+#endif /* XFS_IOCTL_H_ */

