Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38376 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbeAaDJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:09:19 -0500
Subject: [PATCH 24/29] xfs_scrub: fstrim the free areas if there are no
 errors on the filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:09:14 -0800
Message-ID: <151736815437.32164.12988576947993941031.stgit@magnolia>
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

If the filesystem scan comes out clean or fixes all the problems, call
fstrim to clean out the free areas (if it's an ssd/thinp/whatever).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |    3 ++
 scrub/Makefile       |    1 +
 scrub/phase4.c       |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c          |   23 +++++++++++++++
 scrub/vfs.h          |    2 +
 scrub/xfs_scrub.c    |   22 +++++++++++++-
 scrub/xfs_scrub.h    |    3 ++
 7 files changed, 131 insertions(+), 2 deletions(-)
 create mode 100644 scrub/phase4.c


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index c9df7d6..b6e1560 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -63,6 +63,9 @@ If
 is given, no action is taken if errors are found; this is the default
 behavior.
 .TP
+.B \-k
+Do not call FITRIM on the free space.
+.TP
 .BI \-m " file"
 Search this file for mounted filesystems instead of /etc/mtab.
 .TP
diff --git a/scrub/Makefile b/scrub/Makefile
index fd26624..91f99ff 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -41,6 +41,7 @@ inodes.c \
 phase1.c \
 phase2.c \
 phase3.c \
+phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
diff --git a/scrub/phase4.c b/scrub/phase4.c
new file mode 100644
index 0000000..31211f6
--- /dev/null
+++ b/scrub/phase4.c
@@ -0,0 +1,79 @@
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
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "list.h"
+#include "path.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "scrub.h"
+#include "vfs.h"
+
+/* Phase 4: Repair filesystem. */
+
+/* Process all the action items. */
+static bool
+xfs_process_action_items(
+	struct scrub_ctx		*ctx)
+{
+	bool				moveon = true;
+
+	pthread_mutex_lock(&ctx->lock);
+	if (moveon && ctx->errors_found == 0 && want_fstrim)
+		fstrim(ctx);
+	pthread_mutex_unlock(&ctx->lock);
+
+	return moveon;
+}
+
+/* Fix everything that needs fixing. */
+bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	return xfs_process_action_items(ctx);
+}
+
+/* Run the optimize-only phase if there are no errors. */
+bool
+xfs_optimize_fs(
+	struct scrub_ctx	*ctx)
+{
+	/*
+	 * In preen mode, corruptions are immediately recorded as errors,
+	 * so if there are any corruptions on the filesystem errors_found
+	 * will be non-zero and we won't do anything.
+	 */
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Errors found, please re-run with -y."));
+		return true;
+	}
+
+	return xfs_process_action_items(ctx);
+}
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 3c0c2f3..e3c8e62 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -223,3 +223,26 @@ _("Could not queue directory scan work."));
 	free(sftd);
 	return false;
 }
+
+#ifndef FITRIM
+struct fstrim_range {
+	__u64 start;
+	__u64 len;
+	__u64 minlen;
+};
+#define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#endif
+
+/* Call FITRIM to trim all the unused space in a filesystem. */
+void
+fstrim(
+	struct scrub_ctx	*ctx)
+{
+	struct fstrim_range	range = {0};
+	int			error;
+
+	range.len = ULLONG_MAX;
+	error = ioctl(ctx->mnt_fd, FITRIM, &range);
+	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
+		perror(_("fstrim"));
+}
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 100eb18..3305159 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -28,4 +28,6 @@ typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
+void fstrim(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_VFS_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index f6f5f0d..85fd893 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -146,6 +146,9 @@ static bool			scrub_data;
 /* Size of a memory page. */
 long				page_size;
 
+/* Should we FSTRIM after a successful run? */
+bool				want_fstrim = true;
+
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
 #define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
@@ -161,6 +164,7 @@ usage(void)
 	fprintf(stderr, _("  -a count     Stop after this many errors are found.\n"));
 	fprintf(stderr, _("  -b           Background mode.\n"));
 	fprintf(stderr, _("  -e behavior  What to do if errors are found.\n"));
+	fprintf(stderr, _("  -k           Do not FITRIM the free space.\n"));
 	fprintf(stderr, _("  -m path      Path to /etc/mtab.\n"));
 	fprintf(stderr, _("  -n           Dry run.  Do not modify anything.\n"));
 	fprintf(stderr, _("  -T           Display timing/usage information.\n"));
@@ -408,8 +412,19 @@ run_scrub_phases(
 	/* Run all phases of the scrub tool. */
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
 		/* Turn on certain phases if user said to. */
-		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
+		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+		} else if (sp->fn == REPAIR_DUMMY_FN) {
+			if (ctx->mode == SCRUB_MODE_PREEN) {
+				sp->descr = _("Optimize filesystem.");
+				sp->fn = xfs_optimize_fs;
+				sp->must_run = true;
+			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
+				sp->descr = _("Repair filesystem.");
+				sp->fn = xfs_repair_fs;
+				sp->must_run = true;
+			}
+		}
 
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
@@ -469,7 +484,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_DEFAULT;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bde:km:nTvxVy")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -497,6 +512,9 @@ main(
 				usage();
 			}
 			break;
+		case 'k':
+			want_fstrim = false;
+			break;
 		case 'm':
 			mtab = optarg;
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 91f4577..47d63de 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -28,6 +28,7 @@ extern unsigned int		debug;
 extern int			nproc;
 extern bool			verbose;
 extern long			page_size;
+extern bool			want_fstrim;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
@@ -105,5 +106,7 @@ bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
 bool xfs_scan_blocks(struct scrub_ctx *ctx);
 bool xfs_scan_summary(struct scrub_ctx *ctx);
+bool xfs_repair_fs(struct scrub_ctx *ctx);
+bool xfs_optimize_fs(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

