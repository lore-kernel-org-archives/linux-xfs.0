Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26136 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdAUIJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:09:59 -0500
Subject: [PATCH 15/17] xfs_scrub: add XFS-specific scrubbing functionality
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:09:48 -0800
Message-ID: <148498618889.16675.2231803665220653597.stgit@birch.djwong.org>
In-Reply-To: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
References: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
 scrub/scrub.c     |    1 
 scrub/scrub.h     |    1 
 scrub/xfs.c       | 2641 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_ioctl.c |  942 +++++++++++++++++++
 scrub/xfs_ioctl.h |  102 ++
 6 files changed, 3689 insertions(+), 2 deletions(-)
 create mode 100644 scrub/xfs.c
 create mode 100644 scrub/xfs_ioctl.c
 create mode 100644 scrub/xfs_ioctl.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 4639eed..d5d58de 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -12,9 +12,9 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 endif
 
-HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h
+HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h xfs_ioctl.h
 CFILES = ../repair/avl64.c disk.c bitmap.c generic.c iocmd.c \
-	 read_verify.c scrub.c ../repair/threads.c
+	 read_verify.c scrub.c ../repair/threads.c xfs.c xfs_ioctl.c
 
 LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBHANDLE)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBHANDLE)
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 7ed5374..1dcca66 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -308,6 +308,7 @@ __record_preen(
  * generic_scrub_ops will be selected if nothing else is.
  */
 static struct scrub_ops *scrub_impl[] = {
+	&xfs_scrub_ops,
 	NULL
 };
 
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 6ab53c1..e2376a5 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -151,6 +151,7 @@ debug_tweak_on(
 }
 
 extern struct scrub_ops	generic_scrub_ops;
+extern struct scrub_ops	xfs_scrub_ops;
 
 /* Generic implementations of the ops functions */
 bool generic_cleanup(struct scrub_ctx *ctx);
diff --git a/scrub/xfs.c b/scrub/xfs.c
new file mode 100644
index 0000000..bed6549
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,2641 @@
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
+#include "scrub.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "xfs_ioctl.h"
+#include "read_verify.h"
+#include "bitmap.h"
+#include "iocmd.h"
+#include "xfs_fs.h"
+
+/*
+ * XFS Scrubbing Strategy
+ *
+ * The XFS scrubber is much more thorough than the generic scrubber
+ * because we can use custom XFS ioctls to probe more deeply into the
+ * internals of the filesystem.  Furthermore, we can take advantage of
+ * scrubbing ioctls to check all the records stored in a metadata btree
+ * and cross-reference those records against the other btrees.
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
+ * If BULKSTAT is available, we can skip the "check directory structure"
+ * phase because directories were checked during the inode scan.
+ * Otherwise, the generic directory structure check is used.
+ *
+ * In the "verify data file integrity" phase, we can employ multiple
+ * strategies to read-verify the data blocks:
+ *
+ *     - If GETFSMAP is available, use it to read the reverse-mappings of
+ *       all AGs and issue direct-reads of the underlying disk blocks.
+ *       We rely on the underlying storage to have checksummed the data
+ *       blocks appropriately.
+ *     - If GETBMAPX is available, we use BULKSTAT (or a directory tree
+ *       walk) to iterate all inodes and issue direct-reads of the
+ *       underlying data.  Similar to the generic read-verify, the data
+ *       extents are buffered through a bitmap, which is used to issue
+ *       larger IOs.  Errors are recorded and cross-referenced through
+ *       a second BULKSTAT/GETBMAPX run.
+ *     - Otherwise, call the generic handler to verify file data.
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
+enum data_scrub_type {
+	DS_NOSCRUB,		/* no data scrub */
+	DS_READ,		/* generic_scan_blocks */
+	DS_BULKSTAT_READ,	/* bulkstat and generic_file_read */
+	DS_BMAPX,		/* bulkstat, getbmapx, and read_verify */
+	DS_FSMAP,		/* getfsmap and read_verify */
+};
+
+struct xfs_scrub_ctx {
+	struct xfs_fsop_geom	geo;
+	struct fs_path		fsinfo;
+	unsigned int		agblklog;
+	unsigned int		blocklog;
+	unsigned int		inodelog;
+	unsigned int		inopblog;
+	struct disk		datadev;
+	struct disk		logdev;
+	struct disk		rtdev;
+	void			*fshandle;
+	size_t			fshandle_len;
+	unsigned long long	capabilities;	/* see below */
+	struct read_verify_pool	rvp;
+	enum data_scrub_type	data_scrubber;
+	struct list_head	repair_list;
+};
+
+#define XFS_SCRUB_CAP_KSCRUB_FS		(1ULL << 0)	/* can scrub fs meta? */
+#define XFS_SCRUB_CAP_GETFSMAP		(1ULL << 1)	/* have getfsmap? */
+#define XFS_SCRUB_CAP_BULKSTAT		(1ULL << 2)	/* have bulkstat? */
+#define XFS_SCRUB_CAP_BMAPX		(1ULL << 3)	/* have bmapx? */
+#define XFS_SCRUB_CAP_KSCRUB_INODE	(1ULL << 4)	/* can scrub inode? */
+#define XFS_SCRUB_CAP_KSCRUB_BMAP	(1ULL << 5)	/* can scrub bmap? */
+#define XFS_SCRUB_CAP_KSCRUB_DIR	(1ULL << 6)	/* can scrub dirs? */
+#define XFS_SCRUB_CAP_KSCRUB_XATTR	(1ULL << 7)	/* can scrub attrs?*/
+#define XFS_SCRUB_CAP_PARENT_PTR	(1ULL << 8)	/* can find parent? */
+/* If the fast xattr checks fail, we have to use the slower generic scan. */
+#define XFS_SCRUB_CAP_SKIP_SLOW_XATTR	(1ULL << 9)
+#define XFS_SCRUB_CAP_KSCRUB_SYMLINK	(1ULL << 10)	/* can scrub symlink? */
+
+#define XFS_SCRUB_CAPABILITY_FUNCS(name, flagname) \
+static inline bool \
+xfs_scrub_can_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	return xctx->capabilities & XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_set_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	xctx->capabilities |= XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_clear_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	xctx->capabilities &= ~(XFS_SCRUB_CAP_##flagname); \
+}
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_fs,		KSCRUB_FS)
+XFS_SCRUB_CAPABILITY_FUNCS(getfsmap,		GETFSMAP)
+XFS_SCRUB_CAPABILITY_FUNCS(bulkstat,		BULKSTAT)
+XFS_SCRUB_CAPABILITY_FUNCS(bmapx,		BMAPX)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_inode,	KSCRUB_INODE)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_bmap,		KSCRUB_BMAP)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_dir,		KSCRUB_DIR)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_xattr,	KSCRUB_XATTR)
+XFS_SCRUB_CAPABILITY_FUNCS(getparent,		PARENT_PTR)
+XFS_SCRUB_CAPABILITY_FUNCS(skip_slow_xattr,	SKIP_SLOW_XATTR)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_symlink,	KSCRUB_SYMLINK)
+
+/* Find the fd for a given device identifier. */
+static struct disk *
+xfs_dev_to_disk(
+	struct xfs_scrub_ctx	*xctx,
+	dev_t			dev)
+{
+	if (dev == xctx->fsinfo.fs_datadev)
+		return &xctx->datadev;
+	else if (dev == xctx->fsinfo.fs_logdev)
+		return &xctx->logdev;
+	else if (dev == xctx->fsinfo.fs_rtdev)
+		return &xctx->rtdev;
+	abort();
+}
+
+/* Find the device major/minor for a given file descriptor. */
+static dev_t
+xfs_disk_to_dev(
+	struct xfs_scrub_ctx	*xctx,
+	struct disk		*disk)
+{
+	if (disk == &xctx->datadev)
+		return xctx->fsinfo.fs_datadev;
+	else if (disk == &xctx->logdev)
+		return xctx->fsinfo.fs_logdev;
+	else if (disk == &xctx->rtdev)
+		return xctx->fsinfo.fs_rtdev;
+	abort();
+}
+
+/* Shortcut to creating a read-verify thread pool. */
+static inline bool
+xfs_read_verify_pool_init(
+	struct scrub_ctx	*ctx,
+	read_verify_ioend_fn_t	ioend_fn)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	return read_verify_pool_init(&xctx->rvp, ctx, ctx->readbuf,
+			IO_MAX_SIZE, xctx->geo.blocksize, ioend_fn,
+			disk_heads(&xctx->datadev));
+}
+
+struct owner_decode {
+	uint64_t		owner;
+	const char		*descr;
+};
+
+static const struct owner_decode special_owners[] = {
+	{FMR_OWN_FREE,		"free space"},
+	{FMR_OWN_UNKNOWN,	"unknown owner"},
+	{FMR_OWN_FS,		"static FS metadata"},
+	{FMR_OWN_LOG,		"journalling log"},
+	{FMR_OWN_AG,		"per-AG metadata"},
+	{FMR_OWN_INOBT,		"inode btree blocks"},
+	{FMR_OWN_INODES,	"inodes"},
+	{FMR_OWN_REFC,		"refcount btree"},
+	{FMR_OWN_COW,		"CoW staging"},
+	{FMR_OWN_DEFECTIVE,	"bad blocks"},
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	uint64_t		ag_ino;
+	uint64_t		next_ag_ino;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+				major(xctx->fsinfo.fs_datadev),
+				minor(xctx->fsinfo.fs_datadev),
+				agno);
+
+	ag_ino = (__u64)agno << (xctx->inopblog + xctx->agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (xctx->inopblog + xctx->agblklog);
+
+	fn_arg = ((char *)si->arg) + si->array_arg_size * agno;
+	moveon = xfs_iterate_inodes(ctx, descr, xctx->fshandle, ag_ino,
+			next_ag_ino - 1, si->fn, fn_arg);
+	if (!moveon)
+		si->moveon = false;
+}
+
+/* How many array elements should we create to scan all the inodes? */
+static inline size_t
+xfs_scan_all_inodes_array_size(
+	struct xfs_scrub_ctx	*xctx)
+{
+	return xctx->geo.agcount;
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_scan_inodes	si;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return true;
+
+	si.moveon = true;
+	si.fn = fn;
+	si.arg = arg;
+	si.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_scan_blocks	*sbx = arg;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	struct fsmap		keys[2];
+	off64_t			bperag;
+	bool			moveon;
+
+	bperag = (off64_t)xctx->geo.agblocks *
+		 (off64_t)xctx->geo.blocksize;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+				major(xctx->fsinfo.fs_datadev),
+				minor(xctx->fsinfo.fs_datadev),
+				agno);
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = xctx->fsinfo.fs_datadev;
+	keys->fmr_physical = agno * bperag;
+	(keys + 1)->fmr_device = xctx->fsinfo.fs_datadev;
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	xfs_scan_dev_blocks(ctx, agno, xctx->fsinfo.fs_rtdev, arg);
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	xfs_scan_dev_blocks(ctx, agno, xctx->fsinfo.fs_logdev, arg);
+}
+
+/* How many array elements should we create to scan all the blocks? */
+static size_t
+xfs_scan_all_blocks_array_size(
+	struct xfs_scrub_ctx	*xctx)
+{
+	return xctx->geo.agcount + 2;
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
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
+	if (xctx->fsinfo.fs_rt)
+		queue_work(&wq, xfs_scan_rt_blocks, xctx->geo.agcount + 1,
+				&sbx);
+	if (xctx->fsinfo.fs_log)
+		queue_work(&wq, xfs_scan_log_blocks, xctx->geo.agcount + 2,
+				&sbx);
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
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
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
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
+/* Phase 1 */
+
+/* Clean up the XFS-specific state data. */
+static bool
+xfs_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (!xctx)
+		goto out;
+	if (xctx->fshandle)
+		free_handle(xctx->fshandle, xctx->fshandle_len);
+	disk_close(&xctx->rtdev);
+	disk_close(&xctx->logdev);
+	disk_close(&xctx->datadev);
+	free(ctx->priv);
+	ctx->priv = NULL;
+
+out:
+	return generic_cleanup(ctx);
+}
+
+/* Test what kernel functions we can call for this filesystem. */
+static void
+xfs_test_capability(
+	struct scrub_ctx		*ctx,
+	bool				(*test_fn)(struct scrub_ctx *),
+	void				(*set_fn)(struct xfs_scrub_ctx *),
+	const char			*errmsg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+
+	if (test_fn(ctx))
+		set_fn(xctx);
+	else
+		str_info(ctx, ctx->mntpoint, errmsg);
+}
+
+/* Read the XFS geometry. */
+static bool
+xfs_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx;
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
+	xctx = calloc(1, sizeof(struct xfs_scrub_ctx));
+	if (!xctx) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	INIT_LIST_HEAD(&xctx->repair_list);
+	xctx->datadev.d_fd = xctx->logdev.d_fd = xctx->rtdev.d_fd = -1;
+
+	/* Retrieve XFS geometry. */
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSGEOMETRY,
+			&xctx->geo);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		goto err;
+	}
+	ctx->priv = xctx;
+
+	xctx->agblklog = libxfs_log2_roundup(xctx->geo.agblocks);
+	xctx->blocklog = libxfs_highbit32(xctx->geo.blocksize);
+	xctx->inodelog = libxfs_highbit32(xctx->geo.inodesize);
+	xctx->inopblog = xctx->blocklog - xctx->inodelog;
+
+	error = path_to_fshandle(ctx->mntpoint, &xctx->fshandle,
+			&xctx->fshandle_len);
+	if (error) {
+		perror(_("getting fshandle"));
+		goto err;
+	}
+
+	/* Do we have bulkstat? */
+	xfs_test_capability(ctx, xfs_can_iterate_inodes, xfs_scrub_set_bulkstat,
+_("Kernel lacks BULKSTAT; scrub will be incomplete."));
+
+	/* Do we have getbmapx? */
+	xfs_test_capability(ctx, xfs_can_iterate_bmap, xfs_scrub_set_bmapx,
+_("Kernel lacks GETBMAPX; scrub will be less efficient."));
+
+	/* Do we have getfsmap? */
+	xfs_test_capability(ctx, xfs_can_iterate_fsmap, xfs_scrub_set_getfsmap,
+_("Kernel lacks GETFSMAP; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted metadata scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_fs_metadata,
+			xfs_scrub_set_kscrub_fs,
+_("Kernel cannot help scrub metadata; scrub will be incomplete."));
+
+	/* Do we have kernel-assisted inode scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_inode,
+			xfs_scrub_set_kscrub_inode,
+_("Kernel cannot help scrub inodes; scrub will be incomplete."));
+
+	/* Do we have kernel-assisted bmap scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_bmap,
+			xfs_scrub_set_kscrub_bmap,
+_("Kernel cannot help scrub extent map; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted dir scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_dir,
+			xfs_scrub_set_kscrub_dir,
+_("Kernel cannot help scrub directories; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted xattr scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_attr,
+			xfs_scrub_set_kscrub_xattr,
+_("Kernel cannot help scrub extended attributes; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted symlink scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_symlink,
+			xfs_scrub_set_kscrub_symlink,
+_("Kernel cannot help scrub symbolic links; scrub will be less efficient."));
+
+	/*
+	 * We don't need to use the slow generic xattr scan unless all
+	 * of the fast scanners fail.
+	 */
+	xfs_scrub_set_skip_slow_xattr(xctx);
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
+	memcpy(&xctx->fsinfo, fsp, sizeof(struct fs_path));
+
+	/* Did we find the log and rt devices, if they're present? */
+	if (xctx->geo.logstart == 0 && xctx->fsinfo.fs_log == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find log device path."));
+		goto err;
+	}
+	if (xctx->geo.rtblocks && xctx->fsinfo.fs_rt == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find realtime device path."));
+		goto err;
+	}
+
+	/* Open the raw devices. */
+	error = disk_open(xctx->fsinfo.fs_name, &xctx->datadev);
+	if (error) {
+		str_errno(ctx, xctx->fsinfo.fs_name);
+		xfs_scrub_clear_getfsmap(xctx);
+	}
+	ctx->nr_io_threads = libxfs_nproc();
+
+	if (xctx->fsinfo.fs_log) {
+		error = disk_open(xctx->fsinfo.fs_log, &xctx->logdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xfs_scrub_clear_getfsmap(xctx);
+		}
+	}
+	if (xctx->fsinfo.fs_rt) {
+		error = disk_open(xctx->fsinfo.fs_rt, &xctx->rtdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xfs_scrub_clear_getfsmap(xctx);
+		}
+	}
+
+	/* Figure out who gets to scrub data extents... */
+	if (scrub_data) {
+		if (xfs_scrub_can_getfsmap(xctx))
+			xctx->data_scrubber = DS_FSMAP;
+		else if (xfs_scrub_can_bmapx(xctx))
+			xctx->data_scrubber = DS_BMAPX;
+		else  if (xfs_scrub_can_bulkstat(xctx))
+			xctx->data_scrubber = DS_BULKSTAT_READ;
+		else
+			xctx->data_scrubber = DS_READ;
+	} else
+		xctx->data_scrubber = DS_NOSCRUB;
+
+	return generic_scan_fs(ctx);
+err:
+	xfs_cleanup(ctx);
+	return false;
+}
+
+/* Phase 2 */
+
+/* Defer all the repairs until phase 7. */
+static void
+xfs_defer_repairs(
+	struct scrub_ctx	*ctx,
+	struct list_head	*repairs)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (list_empty(repairs))
+		return;
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(repairs, &xctx->repair_list);
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
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
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
+	if (!xfs_scrub_can_kscrub_fs(xctx))
+		return;
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
+	if (broken_secondaries) {
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
+	/* Everything else gets fixed during phase 7. */
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
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	bool				*pmoveon = arg;
+	struct list_head		repairs;
+	bool				moveon;
+
+	if (!xfs_scrub_can_kscrub_fs(xctx))
+		return;
+
+	INIT_LIST_HEAD(&repairs);
+	moveon = xfs_scrub_fs_metadata(ctx, &repairs);
+	if (!moveon)
+		*pmoveon = false;
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(&repairs, &xctx->repair_list);
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Try to scan metadata via sysfs. */
+static bool
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	bool			moveon = true;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	queue_work(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_metadata, agno, &moveon);
+	destroy_work_queue(&wq);
+
+	return moveon;
+}
+
+/* Phase 3 */
+
+/* Scrub an inode extent, report if it's bad. */
+static bool
+xfs_scrub_inode_extent(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	unsigned long long		*nextoff = arg;		/* bytes */
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	unsigned long long		eofs;
+	bool				badmap = false;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		eofs = xctx->geo.rtblocks;
+	else
+		eofs = xctx->geo.datablocks;
+	eofs <<= xctx->blocklog;
+
+	if (bmap->bm_length == 0) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has zero length."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (bmap->bm_physical >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length, eofs);
+	}
+
+	if (bmap->bm_offset < *nextoff) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overlaps another extent."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (bmap->bm_physical + bmap->bm_length < bmap->bm_physical ||
+	    bmap->bm_physical + bmap->bm_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length, eofs);
+	}
+
+	if (bmap->bm_offset + bmap->bm_length < bmap->bm_offset) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overflows file offset."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if ((bmap->bm_flags & BMV_OF_SHARED) &&
+	    (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length,
+				bmap->bm_flags);
+	}
+
+	if ((bmap->bm_flags & BMV_OF_SHARED) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK)) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) is shared but filesystem does not support sharing."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (!badmap)
+		*nextoff = bmap->bm_offset + bmap->bm_length;
+
+	return true;
+}
+
+/* Scrub an inode's data, xattr, and CoW extent records. */
+static bool
+xfs_scan_inode_extents(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd)
+{
+	struct xfs_bmap			key = {0};
+	bool				moveon;
+	unsigned long long		nextoff;	/* bytes */
+
+	/* data fork */
+	nextoff = 0;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_scrub_inode_extent, &nextoff);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	nextoff = 0;
+	return xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_scrub_inode_extent, &nextoff);
+}
+
+enum xfs_xattr_ns {
+	RXT_USER	= 0,
+	RXT_ROOT	= ATTR_ROOT,
+	RXT_TRUST	= ATTR_TRUST,
+	RXT_SECURE	= ATTR_SECURE,
+	RXT_MAX		= 4,
+};
+
+static const enum xfs_xattr_ns known_attr_ns[RXT_MAX] = {
+	RXT_USER,
+	RXT_ROOT,
+	RXT_TRUST,
+	RXT_SECURE,
+};
+
+/*
+ * Read all the extended attributes of a file handle.
+ * This function can return false if the get-attr-by-handle function
+ * does not work correctly; callers must be able to work around that.
+ */
+static int
+xfs_read_handle_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct xfs_handle	*handle,
+	enum xfs_xattr_ns	ns)
+{
+	struct attrlist_cursor	cur;
+	struct attr_multiop	mop;
+	char			attrbuf[XFS_XATTR_LIST_MAX];
+	char			*firstname = NULL;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist_ent	*ent;
+	bool			moveon = true;
+	int			i;
+	int			flags = 0;
+	int			error;
+
+	flags |= ns;
+	memset(&attrbuf, 0, XFS_XATTR_LIST_MAX);
+	memset(&cur, 0, sizeof(cur));
+	mop.am_opcode = ATTR_OP_GET;
+	mop.am_flags = flags;
+	while ((error = attr_list_by_handle(handle, sizeof(*handle),
+			attrbuf, XFS_XATTR_LIST_MAX, flags, &cur)) == 0) {
+		for (i = 0; i < attrlist->al_count; i++) {
+			ent = ATTR_ENTRY(attrlist, i);
+
+			/*
+			 * XFS has a longstanding bug where the attr cursor
+			 * never gets updated, causing an infinite loop.
+			 * Detect this and bail out.
+			 */
+			if (i == 0 && xfs_scrub_can_skip_slow_xattr(xctx)) {
+				if (firstname == NULL) {
+					firstname = malloc(ent->a_valuelen);
+					memcpy(firstname, ent->a_name,
+							ent->a_valuelen);
+				} else if (memcmp(firstname, ent->a_name,
+							ent->a_valuelen) == 0) {
+					str_error(ctx, descr,
+_("duplicate extended attribute \"%s\", buggy XFS?"),
+							ent->a_name);
+					moveon = false;
+					goto out;
+				}
+			}
+
+			mop.am_attrname = ent->a_name;
+			mop.am_attrvalue = ctx->readbuf;
+			mop.am_length = IO_MAX_SIZE;
+			error = attr_multi_by_handle(handle, sizeof(*handle),
+					&mop, 1, flags);
+			if (error) {
+				error = errno;
+				goto out;
+			}
+		}
+
+		if (!attrlist->al_more)
+			break;
+	}
+	if (error)
+		error = errno;
+
+	/* ATTR_TRUST doesn't currently work on Linux... */
+	if (ns == RXT_TRUST && error == EINVAL)
+		error = 0;
+
+out:
+	if (firstname)
+		free(firstname);
+	if (error == ESTALE)
+		return ESTALE;
+	if (error) {
+		str_errno(ctx, descr);
+		return error;
+	}
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
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
+	struct stat		fd_sb;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct list_head	repairs;
+	static char		linkbuf[PATH_MAX];
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	int			fd = -1;
+	int			i;
+	int			error = 0;
+
+	INIT_LIST_HEAD(&repairs);
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu"), bstat->bs_ino);
+
+	/* Check block sizes. */
+	if (!S_ISBLK(bstat->bs_mode) && !S_ISCHR(bstat->bs_mode) &&
+	    bstat->bs_blksize != xctx->geo.blocksize)
+		str_error(ctx, descr,
+_("Block size mismatch %u, expected %u"),
+				bstat->bs_blksize, xctx->geo.blocksize);
+	if (bstat->bs_xflags & FS_XFLAG_EXTSIZE) {
+		if (bstat->bs_extsize > (MAXEXTLEN << xctx->blocklog))
+			str_error(ctx, descr,
+_("Extent size hint %u too large"), bstat->bs_extsize);
+		if (!(bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize > (xctx->geo.agblocks << (xctx->blocklog - 1)))
+			str_error(ctx, descr,
+_("Extent size hint %u too large for AG"), bstat->bs_extsize);
+		if (!(bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize % xctx->geo.blocksize)
+			str_error(ctx, descr,
+_("Extent size hint %u not a multiple of blocksize"), bstat->bs_extsize);
+		if ((bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize % (xctx->geo.rtextsize << xctx->blocklog))
+			str_error(ctx, descr,
+_("Extent size hint %u not a multiple of rt extent size"), bstat->bs_extsize);
+	}
+	if ((bstat->bs_xflags & FS_XFLAG_COWEXTSIZE) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		str_error(ctx, descr,
+_("Has a CoW extent size hint on a non-reflink filesystem?"), 0);
+	if (bstat->bs_xflags & FS_XFLAG_COWEXTSIZE) {
+		if (bstat->bs_cowextsize > (MAXEXTLEN << xctx->blocklog))
+			str_error(ctx, descr,
+_("CoW Extent size hint %u too large"), bstat->bs_cowextsize);
+		if (bstat->bs_cowextsize > (xctx->geo.agblocks << (xctx->blocklog - 1)))
+			str_error(ctx, descr,
+_("CoW Extent size hint %u too large for AG"), bstat->bs_cowextsize);
+		if (bstat->bs_cowextsize % xctx->geo.blocksize)
+			str_error(ctx, descr,
+_("CoW Extent size hint %u not a multiple of blocksize"), bstat->bs_cowextsize);
+	}
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
+	if (xfs_scrub_can_kscrub_inode(xctx)) {
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd,
+				&repairs);
+		if (!moveon)
+			goto out;
+
+		moveon = xfs_quick_repair(ctx, &repairs);
+		if (!moveon)
+			goto out;
+	}
+
+	/* Scrub all block mappings. */
+	if (xfs_scrub_can_kscrub_bmap(xctx)) {
+		/* Use the kernel scrubbers. */
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd,
+				&repairs);
+		if (!moveon)
+			goto out;
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd,
+				&repairs);
+		if (!moveon)
+			goto out;
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd,
+				&repairs);
+		if (!moveon)
+			goto out;
+
+		moveon = xfs_quick_repair(ctx, &repairs);
+		if (!moveon)
+			goto out;
+	} else if (fd >= 0 && xfs_scrub_can_bmapx(xctx)) {
+		/* Scan the extent maps with GETBMAPX. */
+		moveon = xfs_scan_inode_extents(ctx, descr, fd);
+		if (!moveon)
+			goto out;
+	} else if (fd >= 0) {
+		/* Fall back to the FIEMAP scanner. */
+		error = fstat(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, false);
+		if (!moveon)
+			goto out;
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, true);
+		if (!moveon)
+			goto out;
+	} else {
+		/*
+		 * If this is a file or dir, we have no way to scan the
+		 * extent maps.  Complain.
+		 */
+		if (S_ISREG(bstat->bs_mode) || S_ISDIR(bstat->bs_mode))
+			str_error(ctx, descr,
+_("Unable to open inode to scrub extent maps."));
+	}
+
+	/* XXX: Some day, check child -> parent dir -> child. */
+
+	if (S_ISLNK(bstat->bs_mode)) {
+		/* Check symlink contents. */
+		if (xfs_scrub_can_kscrub_symlink(xctx))
+			moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
+					bstat->bs_gen, ctx->mnt_fd, &repairs);
+		else {
+			error = readlink_by_handle(handle, sizeof(*handle),
+					linkbuf, PATH_MAX);
+			if (error < 0) {
+				error = errno;
+				if (error != ESTALE)
+					str_errno(ctx, descr);
+				goto out;
+			}
+		}
+		if (!moveon)
+			goto out;
+	} else if (S_ISDIR(bstat->bs_mode)) {
+		/* Check the directory entries. */
+		if (xfs_scrub_can_kscrub_dir(xctx))
+			moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd,
+					&repairs);
+		else if (fd >= 0)
+			moveon = generic_check_directory(ctx, descr, &fd);
+		else {
+			str_error(ctx, descr,
+_("Unable to open directory to scrub."));
+			moveon = true;
+		}
+		if (!moveon)
+			goto out;
+	}
+
+	/*
+	 * Read all the extended attributes.  If any of the read
+	 * functions decline to move on, we can try again with the
+	 * VFS functions if we have a file descriptor.
+	 */
+	if (xfs_scrub_can_kscrub_xattr(xctx))
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd, &repairs);
+	else {
+		moveon = true;
+		for (i = 0; i < RXT_MAX; i++) {
+			error = xfs_read_handle_xattrs(ctx, descr, handle,
+					known_attr_ns[i]);
+			if (error == XFS_ITERATE_INODES_ABORT) {
+				moveon = false;
+				error = 0;
+				break;
+			}
+			if (error)
+				break;
+		}
+		if (!moveon && fd >= 0) {
+			moveon = generic_scan_xattrs(ctx, descr, fd);
+			if (!moveon)
+				goto out;
+		}
+		if (!moveon)
+			xfs_scrub_clear_skip_slow_xattr(xctx);
+		moveon = true;
+	}
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
+static bool
+xfs_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return generic_scan_inodes(ctx);
+
+	return xfs_scan_all_inodes(ctx, xfs_scrub_inode);
+}
+
+/* Phase 4 */
+
+/* Check an inode's extents. */
+static bool
+xfs_scan_extents(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat		*sb,
+	bool			attr_fork)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/*
+	 * If we have bulkstat and either bmap or kernel scrubbing,
+	 * we already checked the extents.
+	 */
+	if (xfs_scrub_can_bulkstat(xctx) &&
+	    (xfs_scrub_can_bmapx(xctx) || xfs_scrub_can_kscrub_fs(xctx)))
+		return true;
+
+	return generic_scan_extents(ctx, descr, fd, sb, attr_fork);
+}
+
+/* Try to read all the extended attributes. */
+static bool
+xfs_scan_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
+		return true;
+
+	return generic_scan_xattrs(ctx, descr, fd);
+}
+
+/* Try to read all the extended attributes of things that have no fd. */
+static bool
+xfs_scan_special_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*path)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
+		return true;
+
+	return generic_scan_special_xattrs(ctx, path);
+}
+
+/* Traverse the directory tree. */
+static bool
+xfs_scan_fs_tree(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
+		return true;
+
+	return generic_scan_fs_tree(ctx);
+}
+
+/* Phase 5 */
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
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
+	} else if (xfs_scrub_can_getparent(xctx)) {
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
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve;
+	struct bitmap		*tree;
+	dev_t			dev;
+	bool			moveon;
+
+	ve = arg;
+	dev = xfs_disk_to_dev(xctx, disk);
+
+	/*
+	 * If we don't have parent pointers, save the bad extent for
+	 * later rescanning.
+	 */
+	if (!xfs_scrub_can_getparent(xctx)) {
+		if (dev == xctx->fsinfo.fs_datadev)
+			tree = ve->d_bad;
+		else if (dev == xctx->fsinfo.fs_rtdev)
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
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve = arg;
+	struct disk			*disk;
+	uint64_t			eofs;
+	uint64_t			min_physical;
+	bool				badflags = false;
+	bool				badmap = false;
+
+	dbg_printf("rmap dev %d:%d phys %llu owner %lld offset %llu "
+			"len %llu flags 0x%x\n", major(map->fmr_device),
+			minor(map->fmr_device), map->fmr_physical,
+			map->fmr_owner, map->fmr_offset,
+			map->fmr_length, map->fmr_flags);
+
+	/* If kernel already checked this... */
+	if (xfs_scrub_can_kscrub_fs(xctx))
+		goto skip_check;
+
+	if (map->fmr_device == xctx->fsinfo.fs_datadev)
+		eofs = xctx->geo.datablocks;
+	else if (map->fmr_device == xctx->fsinfo.fs_rtdev)
+		eofs = xctx->geo.rtblocks;
+	else if (map->fmr_device == xctx->fsinfo.fs_logdev)
+		eofs = xctx->geo.logblocks;
+	else
+		abort();
+	eofs <<= xctx->blocklog;
+
+	/* Don't go past EOFS */
+	if (map->fmr_physical >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, eofs);
+	}
+
+	if (map->fmr_physical + map->fmr_length < map->fmr_physical ||
+	    map->fmr_physical + map->fmr_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, eofs);
+	}
+
+	/* Check for illegal overlapping. */
+	if (ve->lastshared && (map->fmr_flags & FMR_OF_SHARED))
+		min_physical = ve->laststart;
+	else
+		min_physical = ve->laststart + ve->lastlength;
+
+	if (map->fmr_physical < min_physical) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) overlaps another rmap."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length);
+	}
+
+	/* can't have shared on non-reflink */
+	if ((map->fmr_flags & FMR_OF_SHARED) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		badflags = true;
+
+	/* unwritten can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_PREALLOC) &&
+	     (map->fmr_flags & (FMR_OF_ATTR_FORK | FMR_OF_EXTENT_MAP |
+				 FMR_OF_SHARED | FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* attr fork can't be shared or uwnritten or special */
+	if ((map->fmr_flags & FMR_OF_ATTR_FORK) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_SHARED |
+				 FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* extent maps can only have attrfork */
+	if ((map->fmr_flags & FMR_OF_EXTENT_MAP) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_SHARED |
+				 FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* shared maps can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_SHARED) &&
+	    (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+				FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER)))
+
+	/* special owners can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+				 FMR_OF_EXTENT_MAP | FMR_OF_SHARED)))
+		badflags = true;
+
+	if (badflags) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, map->fmr_flags);
+	}
+
+	/* If this rmap is suspect, don't bother verifying it. */
+	if (badmap)
+		goto out;
+
+skip_check:
+	/* Remember this extent. */
+	ve->lastshared = (map->fmr_flags & FMR_OF_SHARED);
+	ve->laststart = map->fmr_physical;
+	ve->lastlength = map->fmr_length;
+
+	/* "Unknown" extents should be verified; they could be data. */
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+			map->fmr_owner == FMR_OWN_UNKNOWN)
+		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+
+	/*
+	 * We only care about read-verifying data extents that have been
+	 * written to disk.  This means we can skip "special" owners
+	 * (metadata), xattr blocks, unwritten extents, and extent maps.
+	 * These should all get checked elsewhere in the scrubber.
+	 */
+	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+			       FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
+		goto out;
+
+	/* XXX: Filter out directory data blocks. */
+
+	/* Schedule the read verify command for (eventual) running. */
+	disk = xfs_dev_to_disk(xctx, map->fmr_device);
+
+	read_verify_schedule(&xctx->rvp, &ve->rv, disk, map->fmr_physical,
+			map->fmr_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmr_flags & FMR_OF_LAST)
+		read_verify_force(&xctx->rvp, &ve->rv);
+
+	return true;
+}
+
+/* Verify all the blocks in a filesystem. */
+static bool
+xfs_scan_rmaps(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
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
+	groups = xfs_scan_all_blocks_array_size(xctx);
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
+		read_verify_force(&xctx->rvp, &v->rv);
+	read_verify_pool_destroy(&xctx->rvp);
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
+	read_verify_pool_destroy(&xctx->rvp);
+out_rbad:
+	bitmap_free(&r_bad);
+out_dbad:
+	bitmap_free(&d_bad);
+out_ve:
+	free(ve);
+	return moveon;
+}
+
+/* Read-verify with BULKSTAT + GETBMAPX */
+struct xfs_verify_inode {
+	struct bitmap			d_good;		/* bytes */
+	struct bitmap			r_good;		/* bytes */
+	struct bitmap			*d_bad;		/* bytes */
+	struct bitmap			*r_bad;		/* bytes */
+};
+
+struct xfs_verify_submit {
+	struct read_verify_pool		*rvp;
+	struct bitmap			*bad;
+	struct disk			*disk;
+	struct read_verify		rv;
+};
+
+/* Finish a inode block scan. */
+void
+xfs_verify_inode_bmap_ioerr(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	int				error,
+	void				*arg)
+{
+	struct bitmap			*tree = arg;
+
+	bitmap_add(tree, start, length);
+}
+
+/* Scrub an inode extent and read-verify it. */
+bool
+xfs_verify_inode_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct bitmap			*tree = arg;
+
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	return bitmap_add(tree, bmap->bm_physical, bmap->bm_length);
+}
+
+/* Read-verify the data blocks of a file via BMAP. */
+static int
+xfs_verify_inode(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct stat			fd_sb;
+	struct xfs_bmap			key = {0};
+	struct xfs_verify_inode		*vi = arg;
+	struct bitmap			*tree;
+	char				descr[DESCR_BUFSZ];
+	bool				moveon = true;
+	int				fd = -1;
+	int				error;
+
+	if (!S_ISREG(bstat->bs_mode))
+		return true;
+
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
+
+	/* Try to open the inode to pin it. */
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		error = errno;
+		if (error == ESTALE)
+			return error;
+
+		str_errno(ctx, descr);
+		return 0;
+	}
+
+	if (vi) {
+		/* Use BMAPX */
+		if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+			tree = &vi->r_good;
+		else
+			tree = &vi->d_good;
+
+		/* data fork */
+		moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+				xfs_verify_inode_bmap, tree);
+	} else {
+		error = fstat(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		/* Use generic_file_read */
+		moveon = read_verify_file(ctx, descr, fd, &fd_sb);
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Schedule a read verification from an extent tree record. */
+static bool
+xfs_schedule_read_verify(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	struct xfs_verify_submit	*rvs = arg;
+
+	read_verify_schedule(rvs->rvp, &rvs->rv, rvs->disk, start, length,
+			rvs->bad);
+	return true;
+}
+
+/* Verify all the file data in a filesystem. */
+static bool
+xfs_verify_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct bitmap		d_good;
+	struct bitmap		d_bad;
+	struct bitmap		r_good;
+	struct bitmap		r_bad;
+	struct xfs_verify_inode	*vi;
+	struct xfs_verify_inode	*v;
+	struct xfs_verify_submit	vs;
+	int			i;
+	unsigned int		groups;
+	bool			moveon;
+
+	groups = xfs_scan_all_inodes_array_size(xctx);
+	vi = calloc(groups, sizeof(struct xfs_verify_inode));
+	if (!vi) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&d_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_vi;
+	}
+
+	moveon = bitmap_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dgood;
+	}
+
+	moveon = bitmap_init(&r_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	moveon = bitmap_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_rgood;
+	}
+
+	for (i = 0, v = vi; i < groups; i++, v++) {
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+
+		moveon = bitmap_init(&v->d_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+
+		moveon = bitmap_init(&v->r_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+	}
+
+	/* Scan all the inodes for extent information. */
+	moveon = xfs_scan_all_inodes_array_arg(ctx, xfs_verify_inode,
+			vi, sizeof(*vi));
+	if (!moveon)
+		goto out_varray;
+
+	/* Merge all the IOs. */
+	for (i = 0, v = vi; i < groups; i++, v++) {
+		bitmap_merge(&d_good, &v->d_good);
+		bitmap_free(&v->d_good);
+		bitmap_merge(&r_good, &v->r_good);
+		bitmap_free(&v->r_good);
+	}
+
+	/* Run all the IO in batches. */
+	memset(&vs, 0, sizeof(struct xfs_verify_submit));
+	vs.rvp = &xctx->rvp;
+	moveon = xfs_read_verify_pool_init(ctx, xfs_verify_inode_bmap_ioerr);
+	if (!moveon)
+		goto out_varray;
+	vs.disk = &xctx->datadev;
+	vs.bad = &d_bad;
+	moveon = bitmap_iterate(&d_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	vs.disk = &xctx->rtdev;
+	vs.bad = &r_bad;
+	moveon = bitmap_iterate(&r_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	read_verify_force(&xctx->rvp, &vs.rv);
+	read_verify_pool_destroy(&xctx->rvp);
+
+	/* Re-scan the file bmaps to see if they match the bad. */
+	if (!bitmap_empty(&d_bad) || !bitmap_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
+
+	goto out_varray;
+
+out_pool:
+	read_verify_pool_destroy(&xctx->rvp);
+out_varray:
+	for (i = 0, v = vi; i < xctx->geo.agcount; i++, v++) {
+		bitmap_free(&v->d_good);
+		bitmap_free(&v->r_good);
+	}
+	bitmap_free(&r_bad);
+out_rgood:
+	bitmap_free(&r_good);
+out_dbad:
+	bitmap_free(&d_bad);
+out_dgood:
+	bitmap_free(&d_good);
+out_vi:
+	free(vi);
+	return moveon;
+}
+
+/* Verify all the file data in a filesystem with the generic verifier. */
+static bool
+xfs_verify_inodes_generic(
+	struct scrub_ctx	*ctx)
+{
+	return xfs_scan_all_inodes(ctx, xfs_verify_inode);
+}
+
+/* Scan all the blocks in a filesystem. */
+static bool
+xfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+
+	switch (xctx->data_scrubber) {
+	case DS_NOSCRUB:
+		return true;
+	case DS_READ:
+		return generic_scan_blocks(ctx);
+	case DS_BULKSTAT_READ:
+		return xfs_verify_inodes_generic(ctx);
+	case DS_BMAPX:
+		return xfs_verify_inodes(ctx);
+	case DS_FSMAP:
+		return xfs_scan_rmaps(ctx);
+	default:
+		abort();
+	}
+}
+
+/* Read an entire file's data. */
+static bool
+xfs_read_file(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat		*sb)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (xctx->data_scrubber != DS_READ)
+		return true;
+
+	return read_verify_file(ctx, descr, fd, sb);
+}
+
+/* Phase 6 */
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
+/* Record data block extents in a bitmap. */
+bool
+xfs_record_inode_summary_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct xfs_inode_fork_summary	*ifs = arg;
+
+	/* Only record real extents. */
+	if (bmap->bm_flags & BMV_OF_DELALLOC)
+		return true;
+
+	bitmap_add(ifs->tree, bmap->bm_physical, bmap->bm_length);
+	ifs->bytes += bmap->bm_length;
+
+	return true;
+}
+
+/* Record inode and block usage. */
+static int
+xfs_record_inode_summary(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_summary_counts	*counts = arg;
+	struct xfs_inode_fork_summary	ifs = {0};
+	struct xfs_bmap			key = {0};
+	char				descr[DESCR_BUFSZ];
+	int				fd;
+	bool				moveon;
+
+	counts->inodes++;
+	if (xfs_scrub_can_getfsmap(xctx) || bstat->bs_blocks == 0)
+		return 0;
+
+	if (!xfs_scrub_can_bmapx(xctx) || !S_ISREG(bstat->bs_mode)) {
+		counts->dbytes += (bstat->bs_blocks << xctx->blocklog);
+		return 0;
+	}
+
+	/* Potentially a reflinked file, so collect the bitmap... */
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
+
+	/* Try to open the inode to pin it. */
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		if (errno == ESTALE)
+			return errno;
+
+		str_errno(ctx, descr);
+		return 0;
+	}
+
+	/* data fork */
+	if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+		ifs.tree = &counts->rext;
+	else
+		ifs.tree = &counts->dext;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_record_inode_summary_bmap, &ifs);
+	if (!moveon)
+		goto out;
+
+	/* attr fork */
+	ifs.tree = &counts->dext;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_record_inode_summary_bmap, &ifs);
+	if (!moveon)
+		goto out;
+
+	/*
+	 * bs_blocks tracks the number of sectors assigned to this file
+	 * for data, xattrs, and block mapping metadata.  ifs.bytes tracks
+	 * the data and xattr storage space used, so the diff between the
+	 * two is the space used for block mapping metadata.  Add that to
+	 * the data usage.
+	 */
+	counts->dbytes += (bstat->bs_blocks << xctx->blocklog) - ifs.bytes;
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
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
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	unsigned long long		len;
+
+	if (fsmap->fmr_device == xctx->fsinfo.fs_logdev)
+		return true;
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == FMR_OWN_FREE)
+		return true;
+
+	len = fsmap->fmr_length;
+
+	/* freesp btrees live in free space, need to adjust counters later. */
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == FMR_OWN_AG) {
+		counts->agbytes += fsmap->fmr_length;
+	}
+	if (fsmap->fmr_device == xctx->fsinfo.fs_rtdev) {
+		/* Count realtime extents. */
+		counts->rbytes += len;
+	} else {
+		/* Count data extents. */
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
+/* Sum the bytes in each extent. */
+static bool
+xfs_summary_count_helper(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	unsigned long long		*count = arg;
+
+	*count += length;
+	return true;
+}
+
+/* Count all inodes and blocks in the filesystem, compare to superblock. */
+static bool
+xfs_check_summary(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
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
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return generic_check_summary(ctx);
+
+	groups = xfs_scan_all_blocks_array_size(xctx);
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
+	if (xfs_scrub_can_getfsmap(xctx)) {
+		/* Use fsmap to count blocks. */
+		moveon = xfs_scan_all_blocks_array_arg(ctx,
+				xfs_record_block_summary,
+				summary, sizeof(*summary));
+		if (!moveon)
+			goto out;
+	} else {
+		/* Reflink w/o rmap; have to collect extents in a bitmap. */
+		for (agno = 0; agno < groups; agno++) {
+			moveon = bitmap_init(&summary[agno].dext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+			moveon = bitmap_init(&summary[agno].rext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+		}
+	}
+
+	/* Scan the whole fs. */
+	moveon = xfs_scan_all_inodes_array_arg(ctx, xfs_record_inode_summary,
+			summary, sizeof(*summary));
+	if (!moveon)
+		goto out;
+
+	if (!xfs_scrub_can_getfsmap(xctx)) {
+		/* Reflink w/o rmap; merge the bitmaps. */
+		for (agno = 1; agno < groups; agno++) {
+			bitmap_merge(&summary[0].dext, &summary[agno].dext);
+			bitmap_free(&summary[agno].dext);
+			bitmap_merge(&summary[0].rext, &summary[agno].rext);
+			bitmap_free(&summary[agno].rext);
+		}
+		moveon = bitmap_iterate(&summary[0].dext,
+				xfs_summary_count_helper, &summary[0].dbytes);
+		moveon = bitmap_iterate(&summary[0].rext,
+				xfs_summary_count_helper, &summary[0].rbytes);
+		bitmap_free(&summary[0].dext);
+		bitmap_free(&summary[0].rext);
+		if (!moveon)
+			goto out;
+	}
+
+	/* Sum the counts. */
+	for (agno = 1; agno < groups; agno++) {
+		summary[0].inodes += summary[agno].inodes;
+		summary[0].dbytes += summary[agno].dbytes;
+		summary[0].rbytes += summary[agno].rbytes;
+		summary[0].agbytes += summary[agno].agbytes;
+	}
+
+	/* Account for an internal log, if present. */
+	if (!xfs_scrub_can_getfsmap(xctx) && xctx->fsinfo.fs_log == NULL)
+		summary[0].dbytes += (unsigned long long)xctx->geo.logblocks <<
+				xctx->blocklog;
+
+	/* Account for hidden rt metadata inodes. */
+	summary[0].inodes += 2;
+	if ((xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT) &&
+			xctx->geo.rtblocks > 0)
+		summary[0].inodes++;
+
+	/* Fetch the filesystem counters. */
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_FSCOUNTS, &fc);
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
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_GET_RESBLKS, &rb);
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
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_GET_AG_RESBLKS, &arb);
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
+	sfs.f_bfree -= summary[0].agbytes >> xctx->blocklog;
+
+	/* Report on what we found. */
+	fd = (xctx->geo.datablocks - sfs.f_bfree) << xctx->blocklog;
+	fr = (xctx->geo.rtblocks - fc.freertx) << xctx->blocklog;
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
+/* Phase 7: Preen filesystem. */
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
+static bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	int				len;
+	int				old_len;
+	bool				moveon;
+
+	/* Repair anything broken until we fail to make progress. */
+	len = list_length(&xctx->repair_list);
+	do {
+		old_len = len;
+		moveon = xfs_repair_metadata_list(ctx, ctx->mnt_fd,
+				&xctx->repair_list, 0);
+		if (!moveon)
+			return false;
+		len = list_length(&xctx->repair_list);
+	} while (old_len > len);
+
+	/* Try once more, but this time complain if we can't fix things. */
+	moveon = xfs_repair_metadata_list(ctx, ctx->mnt_fd,
+			&xctx->repair_list, XRML_NOFIX_COMPLAIN);
+	if (!moveon)
+		return false;
+
+	fstrim(ctx);
+	return true;
+}
+
+/* Shut down the filesystem. */
+static void
+xfs_shutdown_fs(
+	struct scrub_ctx		*ctx)
+{
+	int				flag;
+
+	flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
+	if (xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GOINGDOWN, &flag))
+		str_errno(ctx, ctx->mntpoint);
+}
+
+struct scrub_ops xfs_scrub_ops = {
+	.name			= "xfs",
+	.repair_tool		= "xfs_repair",
+	.cleanup		= xfs_cleanup,
+	.scan_fs		= xfs_scan_fs,
+	.scan_inodes		= xfs_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= xfs_scan_extents,
+	.scan_xattrs		= xfs_scan_xattrs,
+	.scan_special_xattrs	= xfs_scan_special_xattrs,
+	.scan_metadata		= xfs_scan_metadata,
+	.check_summary		= xfs_check_summary,
+	.scan_blocks		= xfs_scan_blocks,
+	.read_file		= xfs_read_file,
+	.scan_fs_tree		= xfs_scan_fs_tree,
+	.shutdown_fs		= xfs_shutdown_fs,
+	.preen_fs		= xfs_repair_fs,
+	.repair_fs		= xfs_repair_fs,
+};
diff --git a/scrub/xfs_ioctl.c b/scrub/xfs_ioctl.c
new file mode 100644
index 0000000..d69a4eb
--- /dev/null
+++ b/scrub/xfs_ioctl.c
@@ -0,0 +1,942 @@
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
+#include "scrub.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+
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
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSINUMBERS,
+			&igrpreq);
+	while (!error && igrplen) {
+		/* Load the inodes. */
+		ino = inogrp.xi_startino - 1;
+		bulkreq.icount = inogrp.xi_alloccount;
+		error = xfsctl(ctx->mntpoint, ctx->mnt_fd,
+				XFS_IOC_FSBULKSTAT, &bulkreq);
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
+			error = xfsctl(ctx->mntpoint, ctx->mnt_fd,
+					XFS_IOC_FSBULKSTAT_SINGLE,
+					&onereq);
+			if (error || bs->bs_ino != inogrp.xi_startino + i) {
+				memset(bs, 0, sizeof(struct xfs_bstat));
+				bs->bs_ino = inogrp.xi_startino;
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
+		error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSINUMBERS,
+				&igrpreq);
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
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSBULKSTAT,
+			&bulkreq);
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
+		getxattr_type = XFS_IOC_FSGETXATTR;
+		break;
+	case XFS_DATA_FORK:
+		getxattr_type = XFS_IOC_FSGETXATTR;
+		break;
+	default:
+		abort();
+	}
+
+	error = xfsctl("", fd, getxattr_type, &fsx);
+	if (error < 0) {
+		str_errno(ctx, bmap_descr);
+		moveon = false;
+		goto out;
+	}
+
+	while ((error = xfsctl(bmap_descr, fd, XFS_IOC_GETBMAPX, map)) == 0) {
+
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
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETBMAPX, bsm);
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
+	while ((error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP,
+				head)) == 0) {
+
+		for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
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
+
+		head->fmh_keys[0] = *p;
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
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP, &head);
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
+	{"record",				ST_INODE},
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
+	struct xfs_scrub_metadata	*meta)
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
+		str_info(ctx, buf, _("Optimization is possible."));
+		return CHECK_DONE;
+	}
+
+	return CHECK_REPAIR;
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
+		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta);
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
+	fix = xfs_check_metadata(ctx, fd, &meta);
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
+		error = xfsctl(ctx->mntpoint, ctx->mnt_fd,
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
index 0000000..539804d
--- /dev/null
+++ b/scrub/xfs_ioctl.h
@@ -0,0 +1,102 @@
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

