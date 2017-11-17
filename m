Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47498 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762010AbdKQVCm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:42 -0500
Subject: [PATCH 24/27] xfs_scrub: fstrim the free areas if there are no
 errors on the filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:02:37 -0800
Message-ID: <151095255765.4825.9872651897056761214.stgit@magnolia>
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

If the filesystem scan comes out clean or fixes all the problems, call
fstrim to clean out the free areas (if it's an ssd/thinp/whatever).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    1 +
 scrub/phase4.c    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   23 +++++++++++++++++++++++
 scrub/vfs.h       |    2 ++
 scrub/xfs_scrub.c |   26 +++++++++++++++++++++++++-
 scrub/xfs_scrub.h |    1 +
 6 files changed, 104 insertions(+), 1 deletion(-)
 create mode 100644 scrub/phase4.c


diff --git a/scrub/Makefile b/scrub/Makefile
index c442c12..dace31e 100644
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
index 0000000..c7874a6
--- /dev/null
+++ b/scrub/phase4.c
@@ -0,0 +1,52 @@
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
+/* Fix everything that needs fixing. */
+bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	bool				moveon = true;
+
+	pthread_mutex_lock(&ctx->lock);
+	if (moveon && ctx->errors_found == 0)
+		fstrim(ctx);
+	pthread_mutex_unlock(&ctx->lock);
+
+	return moveon;
+}
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 6afeca0..cc2f483 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -219,3 +219,26 @@ _("Could not queue directory scan work."));
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
index d565039..99da6b5 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -28,4 +28,6 @@ typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
+void fstrim(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_VFS_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 786e2b3..81ec7e5 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -340,6 +340,20 @@ _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
 	return true;
 }
 
+/* Run the preening phase if there are no errors. */
+static bool
+preen(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Errors found, please re-run with -y."));
+		return true;
+	}
+
+	return xfs_repair_fs(ctx);
+}
+
 /* Run all the phases of the scrubber. */
 static bool
 run_scrub_phases(
@@ -393,8 +407,18 @@ run_scrub_phases(
 	/* Run all phases of the scrub tool. */
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
 		/* Turn on certain phases if user said to. */
-		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data)
+		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+		} else if (sp->fn == REPAIR_DUMMY_FN) {
+			if (ctx->mode == SCRUB_MODE_PREEN) {
+				sp->descr = _("Preen filesystem.");
+				sp->fn = preen;
+			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
+				sp->descr = _("Repair filesystem.");
+				sp->fn = xfs_repair_fs;
+			}
+			sp->must_run = true;
+		}
 
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index d7b8900..9a09dcd 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -108,5 +108,6 @@ bool xfs_scan_inodes(struct scrub_ctx *ctx);
 bool xfs_scan_connections(struct scrub_ctx *ctx);
 bool xfs_scan_blocks(struct scrub_ctx *ctx);
 bool xfs_scan_summary(struct scrub_ctx *ctx);
+bool xfs_repair_fs(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

