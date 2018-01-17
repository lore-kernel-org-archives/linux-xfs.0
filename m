Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeAQWDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 17:03:37 -0500
Subject: [PATCH 16/29] xfs_scrub: check directory connectivity
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 14:03:33 -0800
Message-ID: <151622661310.31925.10254288208119496968.stgit@magnolia>
In-Reply-To: <151622651142.31925.4179778330985746435.stgit@magnolia>
References: <151622651142.31925.4179778330985746435.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Opening directories by file handle will cause the kernel to perform
parent lookups all the way to the root directory.  Take advantage of
this to ensure that directories actually connect to the root.  Some
day we'll have parent pointers and can make this more comprehensive.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    1 +
 scrub/phase5.c    |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |    1 +
 scrub/xfs_scrub.h |    1 +
 4 files changed, 104 insertions(+)
 create mode 100644 scrub/phase5.c


diff --git a/scrub/Makefile b/scrub/Makefile
index e0d15d8..adb868e 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -36,6 +36,7 @@ inodes.c \
 phase1.c \
 phase2.c \
 phase3.c \
+phase5.c \
 scrub.c \
 spacemap.c \
 xfs_scrub.c
diff --git a/scrub/phase5.c b/scrub/phase5.c
new file mode 100644
index 0000000..0b161e3
--- /dev/null
+++ b/scrub/phase5.c
@@ -0,0 +1,101 @@
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
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "path.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "inodes.h"
+#include "scrub.h"
+
+/* Phase 5: Check directory connectivity. */
+
+/*
+ * Verify the connectivity of the directory tree.
+ * We know that the kernel's open-by-handle function will try to reconnect
+ * parents of an opened directory, so we'll accept that as sufficient.
+ */
+static int
+xfs_scrub_connections(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	void			*arg)
+{
+	bool			*pmoveon = arg;
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			fd = -1;
+
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
+			(uint64_t)bstat->bs_ino, agno, agino);
+	background_sleep();
+
+	/* Open the dir, let the kernel try to reconnect it to the root. */
+	if (S_ISDIR(bstat->bs_mode)) {
+		fd = xfs_open_handle(handle);
+		if (fd < 0) {
+			if (errno == ESTALE)
+				return ESTALE;
+			str_errno(ctx, descr);
+			goto out;
+		}
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	if (!moveon)
+		*pmoveon = false;
+	return *pmoveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Check directory connectivity. */
+bool
+xfs_scan_connections(
+	struct scrub_ctx	*ctx)
+{
+	bool			moveon = true;
+	bool			ret;
+
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem has errors, skipping connectivity checks."));
+		return true;
+	}
+
+	ret = xfs_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
+	if (!ret)
+		moveon = false;
+	if (!moveon)
+		return false;
+	xfs_scrub_report_preen_triggers(ctx);
+	return true;
+}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index ffb7c16..af7fdac 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -374,6 +374,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Check directory tree."),
+			.fn = xfs_scan_connections,
 		},
 		{
 			.descr = _("Verify data file integrity."),
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 462b590..fd7d7aa 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -97,5 +97,6 @@ bool xfs_cleanup_fs(struct scrub_ctx *ctx);
 bool xfs_setup_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);
+bool xfs_scan_connections(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

