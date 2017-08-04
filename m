Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25359 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:37 -0400
Subject: [PATCH 09/22] xfs_scrub: check directory connectivity
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:31 -0700
Message-ID: <150180531172.18784.3387224679879837505.stgit@magnolia>
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

Opening directories by file handle will cause the kernel to perform
parent lookups all the way to the root directory.  Take advantage of
this to ensure that directories actually connect to the root.  Some
day we'll have parent pointers and can make this more comprehensive.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    1 +
 scrub/phase5.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c  |    1 +
 scrub/xfs.h    |    1 +
 4 files changed, 97 insertions(+)
 create mode 100644 scrub/phase5.c


diff --git a/scrub/Makefile b/scrub/Makefile
index e583cb9..13a0b55 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -31,6 +31,7 @@ ioctl.c \
 phase1.c \
 phase2.c \
 phase3.c \
+phase5.c \
 scrub.c \
 xfs.c
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
new file mode 100644
index 0000000..7ea8b58
--- /dev/null
+++ b/scrub/phase5.c
@@ -0,0 +1,94 @@
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
+#include "scrub.h"
+#include "common.h"
+#include "ioctl.h"
+#include "xfs_fs.h"
+#include "xfs.h"
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
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			fd = -1;
+	int			error = 0;
+
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu (%u/%u)"), bstat->bs_ino,
+			agno, agino);
+	background_sleep();
+
+	/* Open the dir, let the kernel try to reconnect it to the root. */
+	if (S_ISDIR(bstat->bs_mode)) {
+		fd = xfs_open_handle(handle);
+		if (fd < 0) {
+			error = errno;
+			if (error != ESTALE)
+				str_errno(ctx, descr);
+			goto out;
+		}
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	if (error)
+		return error;
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Check directory connectivity. */
+bool
+xfs_scan_connections(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem has errors, skipping connectivity checks."));
+		return true;
+	}
+	if (!xfs_scan_all_inodes(ctx, xfs_scrub_connections))
+		return false;
+	xfs_scrub_report_preen_triggers(ctx);
+	return true;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 4638281..c2385da 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -425,6 +425,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Check directory tree."),
+			.fn = xfs_scan_connections,
 		},
 		{
 			.descr = _("Verify data file integrity."),
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 8c442be..2e434c2 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -30,5 +30,6 @@ bool xfs_cleanup(struct scrub_ctx *ctx);
 bool xfs_scan_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);
+bool xfs_scan_connections(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */

