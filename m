Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42425 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966646AbdKQVBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:43 -0500
Subject: [PATCH 15/27] xfs_scrub: scan inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:39 -0800
Message-ID: <151095249965.4825.1210484925404226649.stgit@magnolia>
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

Scan all the inodes in the system for problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    1 
 scrub/phase3.c    |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |    1 
 scrub/xfs_scrub.h |    2 +
 4 files changed, 158 insertions(+)
 create mode 100644 scrub/phase3.c


diff --git a/scrub/Makefile b/scrub/Makefile
index 71d80fb..eca2c56 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -35,6 +35,7 @@ fscounters.c \
 inodes.c \
 phase1.c \
 phase2.c \
+phase3.c \
 scrub.c \
 spacemap.c \
 xfs_scrub.c
diff --git a/scrub/phase3.c b/scrub/phase3.c
new file mode 100644
index 0000000..8c3748e
--- /dev/null
+++ b/scrub/phase3.c
@@ -0,0 +1,154 @@
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
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "path.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "counter.h"
+#include "inodes.h"
+#include "scrub.h"
+
+/* Phase 3: Scan all inodes. */
+
+/*
+ * Run a per-file metadata scanner.  We use the ino/gen interface to
+ * ensure that the inode we're checking matches what the inode scan
+ * told us to look at.
+ */
+static bool
+xfs_scrub_fd(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, uint64_t,
+				      uint32_t, int),
+	struct xfs_bstat	*bs)
+{
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd);
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
+	char			descr[DESCR_BUFSZ];
+	struct ptcounter	*icount = arg;
+	bool			moveon = true;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			fd = -1;
+	int			error = 0;
+
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
+			(uint64_t)bstat->bs_ino, agno, agino);
+	background_sleep();
+
+	/* Try to open the inode to pin it. */
+	if (S_ISREG(bstat->bs_mode)) {
+		fd = xfs_open_handle(handle);
+		if (fd < 0) {
+			error = errno;
+			if (error != ESTALE)
+				str_errno(ctx, descr);
+			goto out;
+		}
+	}
+
+	/* Scrub the inode. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat);
+	if (!moveon)
+		goto out;
+
+	/* Scrub all block mappings. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat);
+	if (!moveon)
+		goto out;
+
+	if (S_ISLNK(bstat->bs_mode)) {
+		/* Check symlink contents. */
+		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
+				bstat->bs_gen, ctx->mnt_fd);
+	} else if (S_ISDIR(bstat->bs_mode)) {
+		/* Check the directory entries. */
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat);
+	}
+	if (!moveon)
+		goto out;
+
+	/* Check all the extended attributes. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat);
+	if (!moveon)
+		goto out;
+
+	/* Check parent pointers. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat);
+	if (!moveon)
+		goto out;
+
+out:
+	ptcounter_add(icount, 1);
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
+	struct ptcounter	*icount;
+	bool			moveon;
+
+	icount = ptcounter_init(scrub_nproc(ctx));
+	if (!icount) {
+		str_error(ctx, ctx->mntpoint, _("Could not create counter."));
+		return false;
+	}
+
+	moveon = xfs_scan_all_inodes(ctx, xfs_scrub_inode, icount);
+	if (!moveon)
+		goto free;
+	xfs_scrub_report_preen_triggers(ctx);
+	ctx->inodes_checked = ptcounter_value(icount);
+
+free:
+	ptcounter_free(icount);
+	return moveon;
+}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c5e8368..592fc35 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -357,6 +357,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Scan all inodes."),
+			.fn = xfs_scan_inodes,
 		},
 		{
 			.descr = _("Defer filesystem repairs."),
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 8ebe097..8407a46 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -89,6 +89,7 @@ struct scrub_ctx {
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
+	unsigned long long	inodes_checked;
 	bool			need_repair;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };
@@ -98,5 +99,6 @@ void xfs_shutdown_fs(struct scrub_ctx *ctx);
 bool xfs_cleanup_fs(struct scrub_ctx *ctx);
 bool xfs_setup_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
+bool xfs_scan_inodes(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

