Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbeAaDJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:09:52 -0500
Subject: [PATCH 29/29] xfs_scrub: schedule and manage optimizations/repairs
 to the filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:09:45 -0800
Message-ID: <151736818563.32164.5708637085584646793.stgit@magnolia>
In-Reply-To: <151736799098.32164.15446216987522359103.stgit@magnolia>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_scrub to remember scrub requests that failed (or indicated
that optimization is a possibility) as action items.  Depending on the
circumstances, certain items are acted upon immediately (e.g. metadata
that needs to be healthy in order to finish the scan, or files that are
already open) or deferred until later.  Expand the repair phase to
deal with the deferred actions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |   27 ++++-
 scrub/Makefile       |    2 
 scrub/phase1.c       |    7 +
 scrub/phase2.c       |   59 +++++++++-
 scrub/phase3.c       |   42 +++++--
 scrub/phase4.c       |   76 ++++++++++++-
 scrub/repair.c       |  298 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/repair.h       |   55 +++++++++
 scrub/scrub.c        |  123 +++++++++++++++------
 scrub/scrub.h        |   36 ++++--
 scrub/xfs_scrub.c    |   22 ++++
 scrub/xfs_scrub.h    |    1 
 12 files changed, 676 insertions(+), 72 deletions(-)
 create mode 100644 scrub/repair.c
 create mode 100644 scrub/repair.h


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 4c394a5..ce5d876 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -114,9 +114,27 @@ Instructing the underlying storage to discard unused extents via the
 .B FITRIM
 ioctl.
 .SH REPAIRS
-This program currently does not support making any repairs.
-Corruptions can only be fixed by unmounting the filesystem and running
-.BR xfs_repair (8).
+Repairs are performed by calling into the kernel.
+This limits the scope of repair activities to rebuilding primary data
+structures from secondary data structures, or secondary structures from
+primary structures.
+The existence of secondary data structures may require features that can
+only be turned on from
+.BR mkfs.xfs (8).
+If errors cannot be repaired, the filesystem must be
+unmounted and
+.BR xfs_repair (8)
+run.
+Repairs supported by the kernel include, but are not limited to:
+.IP \[bu] 2
+Reconstructing extent allocation data from the reverse mapping data.
+.IP \[bu]
+Reconstructing reverse mapping data from primary extent allocation data.
+.IP \[bu]
+Scheduling a quotacheck for the next mount.
+.PP
+If corrupt metadata is successfully repaired, this program will log that
+a repair has succeeded instead of a corruption report.
 .SH EXIT CODE
 The exit code returned by
 .B xfs_scrub
@@ -140,8 +158,5 @@ This program takes advantage of in-kernel scrubbing to verify a given
 data structure with locks held and can keep the filesystem busy for a
 long time.
 The kernel must be new enough to support the SCRUB_METADATA ioctl.
-.PP
-If errors are found and cannot be repaired, the filesystem must be
-unmounted and repaired.
 .SH SEE ALSO
 .BR xfs_repair (8).
diff --git a/scrub/Makefile b/scrub/Makefile
index 0632794..8075732 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -40,6 +40,7 @@ fscounters.h \
 inodes.h \
 progress.h \
 read_verify.h \
+repair.h \
 scrub.h \
 spacemap.h \
 unicrash.h \
@@ -63,6 +64,7 @@ phase6.c \
 phase7.c \
 progress.c \
 read_verify.c \
+repair.c \
 scrub.c \
 spacemap.c \
 vfs.c \
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 547767b..80931e3 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -47,6 +47,7 @@
 #include "common.h"
 #include "disk.h"
 #include "scrub.h"
+#include "repair.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -68,6 +69,7 @@ bool
 xfs_cleanup_fs(
 	struct scrub_ctx	*ctx)
 {
+	xfs_action_lists_free(&ctx->action_lists);
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
 	if (ctx->rtdev)
@@ -157,6 +159,11 @@ _("Does not appear to be an XFS filesystem!"));
 		return false;
 	}
 
+	if (!xfs_action_lists_alloc(ctx->geo.agcount, &ctx->action_lists)) {
+		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
+		return false;
+	}
+
 	ctx->agblklog = log2_roundup(ctx->geo.agblocks);
 	ctx->blocklog = highbit32(ctx->geo.blocksize);
 	ctx->inodelog = highbit32(ctx->geo.inodesize);
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 32e2752..c6a5a26 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -30,6 +30,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
+#include "repair.h"
 
 /* Phase 2: Check internal metadata. */
 
@@ -42,24 +43,65 @@ xfs_scan_ag_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
+	struct xfs_action_list		alist;
+	struct xfs_action_list		immediate_alist;
+	unsigned long long		broken_primaries;
+	unsigned long long		broken_secondaries;
 	bool				moveon;
 	char				descr[DESCR_BUFSZ];
 
+	xfs_action_list_init(&alist);
+	xfs_action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
 
 	/*
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	moveon = xfs_scrub_ag_headers(ctx, agno);
+	moveon = xfs_scrub_ag_headers(ctx, agno, &alist);
+	if (!moveon)
+		goto err;
+
+	/* Repair header damage. */
+	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
 	if (!moveon)
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	moveon = xfs_scrub_ag_metadata(ctx, agno);
+	moveon = xfs_scrub_ag_metadata(ctx, agno, &alist);
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
+	xfs_action_list_find_mustfix(&alist, &immediate_alist,
+			&broken_primaries, &broken_secondaries);
+	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		if (broken_primaries)
+			str_info(ctx, descr,
+_("Corrupt primary and secondary block mapping metadata."));
+		else
+			str_info(ctx, descr,
+_("Corrupt secondary block mapping metadata."));
+		str_info(ctx, descr,
+_("Filesystem might not be repairable."));
+	}
+
+	/* Repair (inode) btree damage. */
+	moveon = xfs_action_list_process_or_defer(ctx, agno, &immediate_alist);
 	if (!moveon)
 		goto err;
 
+	/* Everything else gets fixed during phase 4. */
+	xfs_action_list_defer(ctx, agno, &alist);
+
 	return;
 err:
 	*pmoveon = false;
@@ -74,11 +116,15 @@ xfs_scan_fs_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
+	struct xfs_action_list		alist;
 	bool				moveon;
 
-	moveon = xfs_scrub_fs_metadata(ctx);
+	xfs_action_list_init(&alist);
+	moveon = xfs_scrub_fs_metadata(ctx, &alist);
 	if (!moveon)
 		*pmoveon = false;
+
+	xfs_action_list_defer(ctx, agno, &alist);
 }
 
 /* Scan all filesystem metadata. */
@@ -86,6 +132,7 @@ bool
 xfs_scan_metadata(
 	struct scrub_ctx	*ctx)
 {
+	struct xfs_action_list	alist;
 	struct workqueue	wq;
 	xfs_agnumber_t		agno;
 	bool			moveon = true;
@@ -103,7 +150,11 @@ xfs_scan_metadata(
 	 * upgrades (followed by a full scrub), do that before we launch
 	 * anything else.
 	 */
-	moveon = xfs_scrub_primary_super(ctx);
+	xfs_action_list_init(&alist);
+	moveon = xfs_scrub_primary_super(ctx, &alist);
+	if (!moveon)
+		return moveon;
+	moveon = xfs_action_list_process_or_defer(ctx, 0, &alist);
 	if (!moveon)
 		return moveon;
 
diff --git a/scrub/phase3.c b/scrub/phase3.c
index f4117b0..fdf7d5a 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -33,6 +33,7 @@
 #include "inodes.h"
 #include "progress.h"
 #include "scrub.h"
+#include "repair.h"
 
 /* Phase 3: Scan all inodes. */
 
@@ -45,10 +46,11 @@ static bool
 xfs_scrub_fd(
 	struct scrub_ctx	*ctx,
 	bool			(*fn)(struct scrub_ctx *, uint64_t,
-				      uint32_t, int),
-	struct xfs_bstat	*bs)
+				      uint32_t, int, struct xfs_action_list *),
+	struct xfs_bstat	*bs,
+	struct xfs_action_list	*alist)
 {
-	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd);
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd, alist);
 }
 
 struct scrub_inode_ctx {
@@ -64,11 +66,15 @@ xfs_scrub_inode(
 	struct xfs_bstat	*bstat,
 	void			*arg)
 {
+	struct xfs_action_list	alist;
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
+	xfs_agnumber_t		agno;
 	bool			moveon = true;
 	int			fd = -1;
 
+	xfs_action_list_init(&alist);
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
@@ -80,45 +86,59 @@ xfs_scrub_inode(
 	}
 
 	/* Scrub the inode. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
 	if (!moveon)
 		goto out;
 
 	/* Scrub all block mappings. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
 	if (!moveon)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
 	if (!moveon)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
+	if (!moveon)
+		goto out;
+
+	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
 	if (!moveon)
 		goto out;
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
 		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
-				bstat->bs_gen, ctx->mnt_fd);
+				bstat->bs_gen, ctx->mnt_fd, &alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat);
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
 	}
 	if (!moveon)
 		goto out;
 
 	/* Check all the extended attributes. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
 	if (!moveon)
 		goto out;
 
 	/* Check parent pointers. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat);
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
+	if (!moveon)
+		goto out;
+
+	/* Try to repair the file while it's open. */
+	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
 	if (!moveon)
 		goto out;
 
 out:
 	ptcounter_add(icount, 1);
 	progress_add(1);
+	xfs_action_list_defer(ctx, agno, &alist);
 	if (fd >= 0)
 		close(fd);
 	if (!moveon)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 3100d75..c7fcc50 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -33,16 +33,82 @@
 #include "common.h"
 #include "progress.h"
 #include "scrub.h"
+#include "repair.h"
 #include "vfs.h"
 
 /* Phase 4: Repair filesystem. */
 
+/* Fix all the problems in our per-AG list. */
+static void
+xfs_repair_ag(
+	struct workqueue		*wq,
+	xfs_agnumber_t			agno,
+	void				*priv)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	bool				*pmoveon = priv;
+	struct xfs_action_list		*alist;
+	size_t				unfixed;
+	size_t				new_unfixed;
+	unsigned int			flags = 0;
+	bool				moveon;
+
+	alist = &ctx->action_lists[agno];
+	unfixed = xfs_action_list_length(alist);
+
+	/* Repair anything broken until we fail to make progress. */
+	do {
+		moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, flags);
+		if (!moveon) {
+			*pmoveon = false;
+			return;
+		}
+		new_unfixed = xfs_action_list_length(alist);
+		if (new_unfixed == unfixed)
+			break;
+		unfixed = new_unfixed;
+	} while (unfixed > 0 && *pmoveon);
+
+	if (!*pmoveon)
+		return;
+
+	/* Try once more, but this time complain if we can't fix things. */
+	flags |= ALP_NOFIX_COMPLAIN;
+	moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, flags);
+	if (!moveon)
+		*pmoveon = false;
+}
+
 /* Process all the action items. */
 static bool
 xfs_process_action_items(
 	struct scrub_ctx		*ctx)
 {
+	struct workqueue		wq;
+	xfs_agnumber_t			agno;
 	bool				moveon = true;
+	int				ret;
+
+	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+			scrub_nproc_workqueue(ctx));
+	if (ret) {
+		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		return false;
+	}
+	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+		if (xfs_action_list_length(&ctx->action_lists[agno]) > 0) {
+			ret = workqueue_add(&wq, xfs_repair_ag, agno, &moveon);
+			if (ret) {
+				moveon = false;
+				str_error(ctx, ctx->mntpoint,
+_("Could not queue repair work."));
+				break;
+			}
+		}
+		if (!moveon)
+			break;
+	}
+	workqueue_destroy(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
 	if (moveon && ctx->errors_found == 0 && want_fstrim) {
@@ -89,8 +155,14 @@ xfs_estimate_repair_work(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 1;
-	*nr_threads = 1;
+	xfs_agnumber_t		agno;
+	size_t			need_fixing = 0;
+
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		need_fixing += xfs_action_list_length(&ctx->action_lists[agno]);
+	need_fixing++;
+	*items = need_fixing;
+	*nr_threads = scrub_nproc(ctx) + 1;
 	*rshift = 0;
 	return true;
 }
diff --git a/scrub/repair.c b/scrub/repair.c
new file mode 100644
index 0000000..ff43296
--- /dev/null
+++ b/scrub/repair.c
@@ -0,0 +1,298 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "list.h"
+#include "path.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "scrub.h"
+#include "repair.h"
+
+/*
+ * Prioritize action items in order of how long we can wait.
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
+
+/* Sort action items in severity order. */
+static int
+PRIO(
+	struct action_item	*aitem,
+	int			order)
+{
+	if (aitem->flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return order;
+	else if (aitem->flags & XFS_SCRUB_OFLAG_XCORRUPT)
+		return 100 + order;
+	else if (aitem->flags & XFS_SCRUB_OFLAG_XFAIL)
+		return 200 + order;
+	else if (aitem->flags & XFS_SCRUB_OFLAG_PREEN)
+		return 300 + order;
+	abort();
+}
+
+/* Sort the repair items in dependency order. */
+static int
+xfs_action_item_priority(
+	struct action_item	*aitem)
+{
+	switch (aitem->type) {
+	case XFS_SCRUB_TYPE_SB:
+	case XFS_SCRUB_TYPE_AGF:
+	case XFS_SCRUB_TYPE_AGFL:
+	case XFS_SCRUB_TYPE_AGI:
+	case XFS_SCRUB_TYPE_BNOBT:
+	case XFS_SCRUB_TYPE_CNTBT:
+	case XFS_SCRUB_TYPE_INOBT:
+	case XFS_SCRUB_TYPE_FINOBT:
+	case XFS_SCRUB_TYPE_REFCNTBT:
+	case XFS_SCRUB_TYPE_RMAPBT:
+	case XFS_SCRUB_TYPE_INODE:
+	case XFS_SCRUB_TYPE_BMBTD:
+	case XFS_SCRUB_TYPE_BMBTA:
+	case XFS_SCRUB_TYPE_BMBTC:
+		return PRIO(aitem, aitem->type - 1);
+	case XFS_SCRUB_TYPE_DIR:
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_SYMLINK:
+	case XFS_SCRUB_TYPE_PARENT:
+		return PRIO(aitem, XFS_SCRUB_TYPE_DIR);
+	case XFS_SCRUB_TYPE_RTBITMAP:
+	case XFS_SCRUB_TYPE_RTSUM:
+		return PRIO(aitem, XFS_SCRUB_TYPE_RTBITMAP);
+	case XFS_SCRUB_TYPE_UQUOTA:
+	case XFS_SCRUB_TYPE_GQUOTA:
+	case XFS_SCRUB_TYPE_PQUOTA:
+		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
+	}
+	abort();
+}
+
+/* Make sure that btrees get repaired before headers. */
+static int
+xfs_action_item_compare(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct action_item		*ra;
+	struct action_item		*rb;
+
+	ra = container_of(a, struct action_item, list);
+	rb = container_of(b, struct action_item, list);
+
+	return xfs_action_item_priority(ra) - xfs_action_item_priority(rb);
+}
+
+/*
+ * Figure out which AG metadata must be fixed before we can move on
+ * to the inode scan.
+ */
+void
+xfs_action_list_find_mustfix(
+	struct xfs_action_list		*alist,
+	struct xfs_action_list		*immediate_alist,
+	unsigned long long		*broken_primaries,
+	unsigned long long		*broken_secondaries)
+{
+	struct action_item		*n;
+	struct action_item		*aitem;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_RMAPBT:
+			(*broken_secondaries)++;
+			break;
+		case XFS_SCRUB_TYPE_FINOBT:
+		case XFS_SCRUB_TYPE_INOBT:
+			alist->nr--;
+			list_move_tail(&aitem->list, &immediate_alist->list);
+			immediate_alist->nr++;
+			/* fall through */
+		case XFS_SCRUB_TYPE_BNOBT:
+		case XFS_SCRUB_TYPE_CNTBT:
+		case XFS_SCRUB_TYPE_REFCNTBT:
+			(*broken_primaries)++;
+			break;
+		default:
+			abort();
+			break;
+		}
+	}
+}
+
+/* Allocate a certain number of repair lists for the scrub context. */
+bool
+xfs_action_lists_alloc(
+	size_t				nr,
+	struct xfs_action_list		**listsp)
+{
+	struct xfs_action_list		*lists;
+	xfs_agnumber_t			agno;
+
+	lists = calloc(nr, sizeof(struct xfs_action_list));
+	if (!lists)
+		return false;
+
+	for (agno = 0; agno < nr; agno++)
+		xfs_action_list_init(&lists[agno]);
+	*listsp = lists;
+
+	return true;
+}
+
+/* Free the repair lists. */
+void
+xfs_action_lists_free(
+	struct xfs_action_list		**listsp)
+{
+	free(*listsp);
+	*listsp = NULL;
+}
+
+/* Initialize repair list */
+void
+xfs_action_list_init(
+	struct xfs_action_list		*alist)
+{
+	INIT_LIST_HEAD(&alist->list);
+	alist->nr = 0;
+	alist->sorted = false;
+}
+
+/* Number of repairs in this list. */
+size_t
+xfs_action_list_length(
+	struct xfs_action_list		*alist)
+{
+	return alist->nr;
+};
+
+/* Add to the list of repairs. */
+void
+xfs_action_list_add(
+	struct xfs_action_list		*alist,
+	struct action_item		*aitem)
+{
+	list_add_tail(&aitem->list, &alist->list);
+	alist->nr++;
+	alist->sorted = false;
+}
+
+/* Splice two repair lists. */
+void
+xfs_action_list_splice(
+	struct xfs_action_list		*dest,
+	struct xfs_action_list		*src)
+{
+	if (src->nr == 0)
+		return;
+
+	list_splice_tail_init(&src->list, &dest->list);
+	dest->nr += src->nr;
+	src->nr = 0;
+	dest->sorted = false;
+}
+
+/* Repair everything on this list. */
+bool
+xfs_action_list_process(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct xfs_action_list		*alist,
+	unsigned int			repair_flags)
+{
+	struct action_item		*aitem;
+	struct action_item		*n;
+	enum check_outcome		fix;
+
+	if (!alist->sorted) {
+		list_sort(NULL, &alist->list, xfs_action_item_compare);
+		alist->sorted = true;
+	}
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		fix = xfs_repair_metadata(ctx, fd, aitem, repair_flags);
+		switch (fix) {
+		case CHECK_DONE:
+			alist->nr--;
+			list_del(&aitem->list);
+			free(aitem);
+			continue;
+		case CHECK_ABORT:
+			return false;
+		case CHECK_RETRY:
+			continue;
+		case CHECK_REPAIR:
+			abort();
+		}
+	}
+
+	return !xfs_scrub_excessive_errors(ctx);
+}
+
+/* Defer all the repairs until phase 4. */
+void
+xfs_action_list_defer(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
+{
+	ASSERT(agno < ctx->geo.agcount);
+
+	xfs_action_list_splice(&ctx->action_lists[agno], alist);
+}
+
+/* Run actions now and defer unfinished items for later. */
+bool
+xfs_action_list_process_or_defer(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
+{
+	bool				moveon;
+
+	moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, ALP_REPAIR_ONLY);
+	if (!moveon)
+		return moveon;
+
+	xfs_action_list_defer(ctx, agno, alist);
+	return true;
+}
diff --git a/scrub/repair.h b/scrub/repair.h
new file mode 100644
index 0000000..ded6f20
--- /dev/null
+++ b/scrub/repair.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#ifndef XFS_SCRUB_REPAIR_H_
+#define XFS_SCRUB_REPAIR_H_
+
+struct xfs_action_list {
+	struct list_head	list;
+	size_t			nr;
+	bool			sorted;
+};
+
+bool xfs_action_lists_alloc(size_t nr, struct xfs_action_list **listsp);
+void xfs_action_lists_free(struct xfs_action_list **listsp);
+
+void xfs_action_list_init(struct xfs_action_list *alist);
+size_t xfs_action_list_length(struct xfs_action_list *alist);
+void xfs_action_list_add(struct xfs_action_list *dest,
+		struct action_item *item);
+void xfs_action_list_splice(struct xfs_action_list *dest,
+		struct xfs_action_list *src);
+
+void xfs_action_list_find_mustfix(struct xfs_action_list *actions,
+		struct xfs_action_list *immediate_alist,
+		unsigned long long *broken_primaries,
+		unsigned long long *broken_secondaries);
+
+/* Passed through to xfs_repair_metadata() */
+#define ALP_REPAIR_ONLY	(XRM_REPAIR_ONLY)
+#define ALP_NOFIX_COMPLAIN	(XRM_NOFIX_COMPLAIN)
+
+bool xfs_action_list_process(struct scrub_ctx *ctx, int fd,
+		struct xfs_action_list *alist, unsigned int repair_flags);
+void xfs_action_list_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_action_list *alist);
+bool xfs_action_list_process_or_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_action_list *alist);
+
+#endif /* XFS_SCRUB_REPAIR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0dbe11c..e61efa3 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -35,6 +35,7 @@
 #include "progress.h"
 #include "scrub.h"
 #include "xfs_errortag.h"
+#include "repair.h"
 
 /* Online scrub and repair wrappers. */
 
@@ -321,12 +322,47 @@ _("Optimizations of %s are possible."), scrubbers[i].name);
 	}
 }
 
+/* Save a scrub context for later repairs. */
+bool
+xfs_scrub_save_repair(
+	struct scrub_ctx		*ctx,
+	struct xfs_action_list		*alist,
+	struct xfs_scrub_metadata	*meta)
+{
+	struct action_item		*aitem;
+
+	/* Schedule this item for later repairs. */
+	aitem = malloc(sizeof(struct action_item));
+	if (!aitem) {
+		str_errno(ctx, _("repair list"));
+		return false;
+	}
+	aitem->type = meta->sm_type;
+	aitem->flags = meta->sm_flags;
+	switch (scrubbers[meta->sm_type].type) {
+	case ST_AGHEADER:
+	case ST_PERAG:
+		aitem->agno = meta->sm_agno;
+		break;
+	case ST_INODE:
+		aitem->ino = meta->sm_ino;
+		aitem->gen = meta->sm_gen;
+		break;
+	default:
+		break;
+	}
+
+	xfs_action_list_add(alist, aitem);
+	return true;
+}
+
 /* Scrub metadata, saving corruption reports for later. */
 static bool
 xfs_scrub_metadata(
 	struct scrub_ctx		*ctx,
 	enum scrub_type			scrub_type,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	const struct scrub_descr	*sc;
@@ -350,6 +386,8 @@ xfs_scrub_metadata(
 		case CHECK_ABORT:
 			return false;
 		case CHECK_REPAIR:
+			if (!xfs_scrub_save_repair(ctx, alist, &meta))
+				return false;
 			/* fall through */
 		case CHECK_DONE:
 			continue;
@@ -369,7 +407,8 @@ xfs_scrub_metadata(
  */
 bool
 xfs_scrub_primary_super(
-	struct scrub_ctx		*ctx)
+	struct scrub_ctx		*ctx,
+	struct xfs_action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {
 		.sm_type = XFS_SCRUB_TYPE_SB,
@@ -382,6 +421,8 @@ xfs_scrub_primary_super(
 	case CHECK_ABORT:
 		return false;
 	case CHECK_REPAIR:
+		if (!xfs_scrub_save_repair(ctx, alist, &meta))
+			return false;
 		/* fall through */
 	case CHECK_DONE:
 		return true;
@@ -397,26 +438,29 @@ xfs_scrub_primary_super(
 bool
 xfs_scrub_ag_headers(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno);
+	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno, alist);
 }
 
 /* Scrub each AG's metadata btrees. */
 bool
 xfs_scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno)
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_PERAG, agno);
+	return xfs_scrub_metadata(ctx, ST_PERAG, agno, alist);
 }
 
 /* Scrub whole-FS metadata btrees. */
 bool
 xfs_scrub_fs_metadata(
-	struct scrub_ctx		*ctx)
+	struct scrub_ctx		*ctx,
+	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_FS, 0);
+	return xfs_scrub_metadata(ctx, ST_FS, 0, alist);
 }
 
 /* How many items do we have to check? */
@@ -452,7 +496,8 @@ __xfs_scrub_file(
 	uint64_t			ino,
 	uint32_t			gen,
 	int				fd,
-	unsigned int			type)
+	unsigned int			type,
+	struct xfs_action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	enum check_outcome		fix;
@@ -471,7 +516,7 @@ __xfs_scrub_file(
 	if (fix == CHECK_DONE)
 		return true;
 
-	return true;
+	return xfs_scrub_save_repair(ctx, alist, &meta);
 }
 
 bool
@@ -479,9 +524,10 @@ xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_INODE, alist);
 }
 
 bool
@@ -489,9 +535,10 @@ xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTD, alist);
 }
 
 bool
@@ -499,9 +546,10 @@ xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTA, alist);
 }
 
 bool
@@ -509,9 +557,10 @@ xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_BMBTC, alist);
 }
 
 bool
@@ -519,9 +568,10 @@ xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_DIR, alist);
 }
 
 bool
@@ -529,9 +579,10 @@ xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_XATTR, alist);
 }
 
 bool
@@ -539,9 +590,10 @@ xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_SYMLINK, alist);
 }
 
 bool
@@ -549,9 +601,10 @@ xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	int			fd)
+	int			fd,
+	struct xfs_action_list	*alist)
 {
-	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT);
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT, alist);
 }
 
 /* Test the availability of a kernel scrub command. */
@@ -668,7 +721,7 @@ enum check_outcome
 xfs_repair_metadata(
 	struct scrub_ctx		*ctx,
 	int				fd,
-	struct repair_item		*ri,
+	struct action_item		*aitem,
 	unsigned int			repair_flags)
 {
 	char				buf[DESCR_BUFSZ];
@@ -676,18 +729,18 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	int				error;
 
-	assert(ri->type < XFS_SCRUB_TYPE_NR);
+	assert(aitem->type < XFS_SCRUB_TYPE_NR);
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	meta.sm_type = ri->type;
-	meta.sm_flags = ri->flags | XFS_SCRUB_IFLAG_REPAIR;
-	switch (scrubbers[ri->type].type) {
+	meta.sm_type = aitem->type;
+	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	switch (scrubbers[aitem->type].type) {
 	case ST_AGHEADER:
 	case ST_PERAG:
-		meta.sm_agno = ri->agno;
+		meta.sm_agno = aitem->agno;
 		break;
 	case ST_INODE:
-		meta.sm_ino = ri->ino;
-		meta.sm_gen = ri->gen;
+		meta.sm_ino = aitem->ino;
+		meta.sm_gen = aitem->gen;
 		break;
 	default:
 		break;
@@ -769,7 +822,7 @@ _("Read-only filesystem; cannot make changes."));
 		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
 	if (needs_repair(&meta)) {
 		/* Still broken, try again or fix offline. */
-		if (repair_flags & XRM_NOFIX_COMPLAIN)
+		if ((repair_flags & XRM_NOFIX_COMPLAIN) || debug)
 			str_error(ctx, buf,
 _("Repair unsuccessful; offline repair required."));
 	} else {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 1c44fba..a719571 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -28,11 +28,19 @@ enum check_outcome {
 	CHECK_RETRY,	/* repair failed, try again later */
 };
 
+struct action_item;
+
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
-bool xfs_scrub_primary_super(struct scrub_ctx *ctx);
-bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno);
-bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno);
-bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx);
+bool xfs_scrub_primary_super(struct scrub_ctx *ctx,
+		struct xfs_action_list *alist);
+bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_action_list *alist);
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct xfs_action_list *alist);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+		struct xfs_action_list *alist);
+enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
+		struct action_item *aitem, unsigned int flags);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
@@ -44,24 +52,24 @@ bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
 bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		int fd);
+		int fd, struct xfs_action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
-struct repair_item {
+struct action_item {
 	struct list_head	list;
 	__u64			ino;
 	__u32			type;
@@ -77,6 +85,6 @@ struct repair_item {
 #define XRM_NOFIX_COMPLAIN	(1U << 1)
 
 enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
-		struct repair_item *ri, unsigned int repair_flags);
+		struct action_item *aitem, unsigned int repair_flags);
 
 #endif /* XFS_SCRUB_SCRUB_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 5ab557d..c83f4a2 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -88,6 +88,15 @@
  * the previous two phases are retried here; if there are uncorrectable
  * errors, xfs_scrub stops here.
  *
+ * To perform the actual repairs (or optimizations), we iterate all the
+ * items on the per-AG action item list and ask the kernel to repair
+ * them.  Items which are successfully repaired are removed from the
+ * list.  If an item is not acted upon successfully (or the kernel asks us
+ * to try again), we retry the actions until there is nothing left to
+ * fix or we fail to make forward progress.  In that event, the
+ * unfinished items are recorded as errors.  If there are no errors at
+ * this point, we call FSTRIM on the filesystem.
+ *
  * The next phase is the "check directory tree" phase.  In this phase,
  * every directory is opened (via file handle) to confirm that each
  * directory is connected to the root.  Directory entries are checked
@@ -711,6 +720,19 @@ _("%s: Not a XFS mount point or block device.\n"),
 		ctx.runtime_errors++;
 
 out:
+	if (ctx.repairs && ctx.preens)
+		fprintf(stdout,
+_("%s: %llu repairs and %llu optimizations made.\n"),
+			ctx.mntpoint, ctx.repairs, ctx.preens);
+	else if (ctx.repairs && ctx.preens == 0)
+		fprintf(stdout,
+_("%s: %llu repairs made.\n"),
+			ctx.mntpoint, ctx.repairs);
+	else if (ctx.repairs == 0 && ctx.preens)
+		fprintf(stdout,
+_("%s: %llu optimizations made.\n"),
+			ctx.mntpoint, ctx.preens);
+
 	total_errors = ctx.errors_found + ctx.runtime_errors;
 	if (ctx.need_repair)
 		repairstr = _("  Unmount and run xfs_repair.");
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 8407885..8c75f69 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -88,6 +88,7 @@ struct scrub_ctx {
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
+	struct xfs_action_list	*action_lists;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;

