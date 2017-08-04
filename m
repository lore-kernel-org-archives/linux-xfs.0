Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25568 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:21 -0400
Subject: [PATCH 15/22] xfs_scrub: check summary counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:15 -0700
Message-ID: <150180535573.18784.10402300673291394579.stgit@magnolia>
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

Make sure the filesystem summary counters are somewhat close to what
we can find by scanning the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    1 
 scrub/common.c |   28 +++++++
 scrub/common.h |    3 +
 scrub/phase7.c |  236 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c  |    4 -
 scrub/xfs.c    |   63 +++++++++++++++
 scrub/xfs.h    |    7 ++
 7 files changed, 338 insertions(+), 4 deletions(-)
 create mode 100644 scrub/phase7.c


diff --git a/scrub/Makefile b/scrub/Makefile
index e8864cc..461df83 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -41,6 +41,7 @@ phase2.c \
 phase3.c \
 phase5.c \
 phase6.c \
+phase7.c \
 read_verify.c \
 scrub.c \
 vfs.c \
diff --git a/scrub/common.c b/scrub/common.c
index 167d373..4ec07a0 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -347,3 +347,31 @@ background_sleep(void)
 	tv.tv_nsec = time % 1000000;
 	nanosleep(&tv, NULL);
 }
+
+/* Decide if a value is within +/- (n/d) of a desired value. */
+bool
+within_range(
+	struct scrub_ctx	*ctx,
+	unsigned long long	value,
+	unsigned long long	desired,
+	unsigned long long	abs_threshold,
+	unsigned int		n,
+	unsigned int		d,
+	const char		*descr)
+{
+	assert(n < d);
+
+	/* Don't complain if difference does not exceed an absolute value. */
+	if (value < desired && desired - value < abs_threshold)
+		return true;
+	if (value > desired && value - desired < abs_threshold)
+		return true;
+
+	/* Complain if the difference exceeds a certain percentage. */
+	if (value < desired * (d - n) / d)
+		return false;
+	if (value > desired * (d + n) / d)
+		return false;
+
+	return true;
+}
diff --git a/scrub/common.h b/scrub/common.h
index 7bbd061..7c35f3f 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -71,5 +71,8 @@ static inline int syncfs(int fd)
 
 bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
 void background_sleep(void);
+bool within_range(struct scrub_ctx *ctx, unsigned long long value,
+		unsigned long long desired, unsigned long long abs_threshold,
+		unsigned int n, unsigned int d, const char *descr);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/phase7.c b/scrub/phase7.c
new file mode 100644
index 0000000..bdb4a79
--- /dev/null
+++ b/scrub/phase7.c
@@ -0,0 +1,236 @@
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
+/* Phase 7: Check summary counters. */
+
+struct xfs_summary_counts {
+	unsigned long long	inodes;		/* number of inodes */
+	unsigned long long	dbytes;		/* data dev bytes */
+	unsigned long long	rbytes;		/* rt dev bytes */
+	unsigned long long	next_phys;	/* next phys bytes we see? */
+	unsigned long long	agbytes;	/* freespace bytes */
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
+/*
+ * Count all inodes and blocks in the filesystem as told by GETFSMAP and
+ * BULKSTAT, and compare that to summary counters.  Since this is a live
+ * filesystem we'll be content if the summary counts are within 10% of
+ * what we observed.
+ */
+bool
+xfs_scan_summary(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_summary_counts	*summary;
+	unsigned long long		fd;
+	unsigned long long		fr;
+	unsigned long long		fi;
+	unsigned long long		sd;
+	unsigned long long		sr;
+	unsigned long long		si;
+	unsigned long long		absdiff;
+	unsigned long long		d_blocks;
+	unsigned long long		d_bfree;
+	unsigned long long		r_blocks;
+	unsigned long long		r_bfree;
+	unsigned long long		f_files;
+	unsigned long long		f_free;
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
+	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
+			&r_bfree, &f_files, &f_free);
+	if (!moveon)
+		return moveon;
+
+	/*
+	 * If we counted blocks with fsmap, then dblocks includes
+	 * blocks for the AGFL and the freespace/rmap btrees.  The
+	 * filesystem treats them as "free", but since we scanned
+	 * them, we'll consider them used.
+	 */
+	d_bfree -= summary[0].agbytes >> ctx->blocklog;
+
+	/* Report on what we found. */
+	fd = (d_blocks - d_bfree) << ctx->blocklog;
+	fr = (r_blocks - r_bfree) << ctx->blocklog;
+	fi = f_files - f_free;
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
+	free(summary);
+	return moveon;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 97bd795..647e050 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -448,6 +448,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Check summary counters."),
+			.fn = xfs_scan_summary,
 		},
 		{
 			NULL
@@ -517,9 +518,6 @@ main(
 	int			ret;
 	int			error;
 
-	fprintf(stderr, "XXX: This program is not complete!\n");
-	return 4;
-
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
diff --git a/scrub/xfs.c b/scrub/xfs.c
index 36a5ba1..4db0267 100644
--- a/scrub/xfs.c
+++ b/scrub/xfs.c
@@ -91,7 +91,7 @@ xfs_scan_all_inodes_array_size(
 }
 
 /* Scan all the inodes in a filesystem. */
-static bool
+bool
 xfs_scan_all_inodes_array_arg(
 	struct scrub_ctx	*ctx,
 	xfs_inode_iter_fn	fn,
@@ -270,3 +270,64 @@ xfs_scan_all_blocks_array_arg(
 
 	return sbx.moveon;
 }
+
+/* Estimate the number of blocks and inodes in the filesystem. */
+bool
+xfs_scan_estimate_blocks(
+	struct scrub_ctx		*ctx,
+	unsigned long long		*d_blocks,
+	unsigned long long		*d_bfree,
+	unsigned long long		*r_blocks,
+	unsigned long long		*r_bfree,
+	unsigned long long		*f_files,
+	unsigned long long		*f_free)
+{
+	struct xfs_fsop_counts		fc;
+	struct xfs_fsop_resblks		rb;
+	struct xfs_fsop_ag_resblks	arb;
+	struct statvfs			sfs;
+	int				error;
+
+	/* Grab the fstatvfs counters, since it has to report accurately. */
+	error = fstatvfs(ctx->mnt_fd, &sfs);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Fetch the filesystem counters. */
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSCOUNTS, &fc);
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
+	sfs.f_bfree += arb.ar_current_resv;
+
+	*d_blocks = ctx->geo.datablocks;
+	*d_bfree = sfs.f_bfree;
+	*r_blocks = ctx->geo.rtblocks;
+	*r_bfree = fc.freertx;
+	*f_files = sfs.f_files;
+	*f_free = sfs.f_ffree;
+
+	return true;
+}
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 7d087db..996f791 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -24,9 +24,15 @@ void xfs_shutdown_fs(struct scrub_ctx *ctx);
 bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn);
 bool xfs_scan_all_inodes_arg(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
 		void *arg);
+bool xfs_scan_all_inodes_array_arg(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
+		void *arg, size_t array_arg_size);
 size_t xfs_scan_all_blocks_array_size(struct scrub_ctx *ctx);
 bool xfs_scan_all_blocks_array_arg(struct scrub_ctx *ctx, xfs_fsmap_iter_fn fn,
 		void *arg, size_t array_arg_size);
+bool xfs_scan_estimate_blocks(struct scrub_ctx *ctx,
+		unsigned long long *d_blocks, unsigned long long *d_bfree,
+		unsigned long long *r_blocks, unsigned long long *r_bfree,
+		unsigned long long *f_files, unsigned long long *f_free);
 
 /* Phase-specific functions. */
 bool xfs_cleanup(struct scrub_ctx *ctx);
@@ -35,5 +41,6 @@ bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
 bool xfs_scan_blocks(struct scrub_ctx *ctx);
+bool xfs_scan_summary(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */

