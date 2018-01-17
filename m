Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753808AbeAQWGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 17:06:25 -0500
Subject: [PATCH 13/29] xfs_scrub: scan filesystem and AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 14:03:14 -0800
Message-ID: <151622659440.31925.9409310697989741930.stgit@magnolia>
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

Scrub the filesystem and per-AG metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    1 
 scrub/phase2.c    |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |    1 
 scrub/xfs_scrub.h |    1 
 4 files changed, 136 insertions(+)
 create mode 100644 scrub/phase2.c


diff --git a/scrub/Makefile b/scrub/Makefile
index 915b801..9edc933 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -32,6 +32,7 @@ filemap.c \
 fscounters.c \
 inodes.c \
 phase1.c \
+phase2.c \
 scrub.c \
 spacemap.c \
 xfs_scrub.c
diff --git a/scrub/phase2.c b/scrub/phase2.c
new file mode 100644
index 0000000..153ae02
--- /dev/null
+++ b/scrub/phase2.c
@@ -0,0 +1,133 @@
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
+#include "scrub.h"
+
+/* Phase 2: Check internal metadata. */
+
+/* Scrub each AG's metadata btrees. */
+static void
+xfs_scan_ag_metadata(
+	struct workqueue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	bool				*pmoveon = arg;
+	bool				moveon;
+	char				descr[DESCR_BUFSZ];
+
+	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
+
+	/*
+	 * First we scrub and fix the AG headers, because we need
+	 * them to work well enough to check the AG btrees.
+	 */
+	moveon = xfs_scrub_ag_headers(ctx, agno);
+	if (!moveon)
+		goto err;
+
+	/* Now scrub the AG btrees. */
+	moveon = xfs_scrub_ag_metadata(ctx, agno);
+	if (!moveon)
+		goto err;
+
+	return;
+err:
+	*pmoveon = false;
+}
+
+/* Scrub whole-FS metadata btrees. */
+static void
+xfs_scan_fs_metadata(
+	struct workqueue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	bool				*pmoveon = arg;
+	bool				moveon;
+
+	moveon = xfs_scrub_fs_metadata(ctx);
+	if (!moveon)
+		*pmoveon = false;
+}
+
+/* Scan all filesystem metadata. */
+bool
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	struct workqueue	wq;
+	xfs_agnumber_t		agno;
+	bool			moveon = true;
+	int			ret;
+
+	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+			scrub_nproc_workqueue(ctx));
+	if (ret) {
+		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		return false;
+	}
+
+	/*
+	 * In case we ever use the primary super scrubber to perform fs
+	 * upgrades (followed by a full scrub), do that before we launch
+	 * anything else.
+	 */
+	moveon = xfs_scrub_primary_super(ctx);
+	if (!moveon)
+		return moveon;
+
+	for (agno = 0; moveon && agno < ctx->geo.agcount; agno++) {
+		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
+		if (ret) {
+			moveon = false;
+			str_error(ctx, ctx->mntpoint,
+_("Could not queue AG %u scrub work."), agno);
+			goto out;
+		}
+	}
+
+	if (!moveon)
+		goto out;
+
+	ret = workqueue_add(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	if (ret) {
+		moveon = false;
+		str_error(ctx, ctx->mntpoint,
+_("Could not queue filesystem scrub work."));
+		goto out;
+	}
+
+out:
+	workqueue_destroy(&wq);
+	return moveon;
+}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c3ad82f..2755d97 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -362,6 +362,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Check internal metadata."),
+			.fn = xfs_scan_metadata,
 		},
 		{
 			.descr = _("Scan all inodes."),
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 914490a..7802101 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -94,5 +94,6 @@ struct scrub_ctx {
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
 bool xfs_cleanup_fs(struct scrub_ctx *ctx);
 bool xfs_setup_fs(struct scrub_ctx *ctx);
+bool xfs_scan_metadata(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

