Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46955 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965376AbdKQVBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:20 -0500
Subject: [PATCH 11/27] xfs_scrub: filesystem counter collection functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:15 -0800
Message-ID: <151095247577.4825.11976657147839549161.stgit@magnolia>
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

Add a couple of helper functions to estimate the inode and block
counters on the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile     |    2 
 scrub/fscounters.c |  212 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/fscounters.h |   29 +++++++
 3 files changed, 243 insertions(+)
 create mode 100644 scrub/fscounters.c
 create mode 100644 scrub/fscounters.h


diff --git a/scrub/Makefile b/scrub/Makefile
index bf0a813..878a5d5 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -19,6 +19,7 @@ HFILES = \
 common.h \
 disk.h \
 filemap.h \
+fscounters.h \
 inodes.h \
 spacemap.h \
 xfs_scrub.h
@@ -27,6 +28,7 @@ CFILES = \
 common.c \
 disk.c \
 filemap.c \
+fscounters.c \
 inodes.c \
 phase1.c \
 spacemap.c \
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
new file mode 100644
index 0000000..33667a8
--- /dev/null
+++ b/scrub/fscounters.c
@@ -0,0 +1,212 @@
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
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/statvfs.h>
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "path.h"
+#include "workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "fscounters.h"
+
+/*
+ * Filesystem counter collection routines.  We can count the number of
+ * inodes in the filesystem, and we can estimate the block counters.
+ */
+
+/* Count the number of inodes in the filesystem. */
+
+/* INUMBERS wrapper routines. */
+struct xfs_count_inodes {
+	bool			moveon;
+	uint64_t		counters[0];
+};
+
+/*
+ * Count the number of inodes.  Use INUMBERS to figure out how many inodes
+ * exist in the filesystem, assuming we've already scrubbed that.
+ */
+static bool
+xfs_count_inodes_range(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	uint64_t		first_ino,
+	uint64_t		last_ino,
+	uint64_t		*count)
+{
+	struct xfs_fsop_bulkreq	igrpreq = {0};
+	struct xfs_inogrp	inogrp;
+	__u64			igrp_ino;
+	uint64_t		nr = 0;
+	__s32			igrplen = 0;
+	int			error;
+
+	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
+	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
+
+	igrpreq.lastip  = &igrp_ino;
+	igrpreq.icount  = 1;
+	igrpreq.ubuffer = &inogrp;
+	igrpreq.ocount  = &igrplen;
+
+	igrp_ino = first_ino;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	while (!error && igrplen && inogrp.xi_startino < last_ino) {
+		nr += inogrp.xi_alloccount;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	*count = nr;
+	return true;
+}
+
+/* Scan all the inodes in an AG. */
+static void
+xfs_count_ag_inodes(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_count_inodes	*ci = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
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
+	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
+			&ci->counters[agno]);
+	if (!moveon)
+		ci->moveon = false;
+}
+
+/* Count all the inodes in a filesystem. */
+bool
+xfs_count_all_inodes(
+	struct scrub_ctx	*ctx,
+	uint64_t		*count)
+{
+	struct xfs_count_inodes	*ci;
+	xfs_agnumber_t		agno;
+	struct workqueue	wq;
+	bool			moveon;
+	int			ret;
+
+	ci = calloc(1, sizeof(struct xfs_count_inodes) +
+			(ctx->geo.agcount * sizeof(uint64_t)));
+	if (!ci)
+		return false;
+	ci->moveon = true;
+
+	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+			scrub_nproc_workqueue(ctx));
+	if (ret) {
+		moveon = false;
+		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		goto out_free;
+	}
+	for (agno = 0; agno < ctx->geo.agcount; agno++) {
+		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
+		if (ret) {
+			moveon = false;
+			str_error(ctx, ctx->mntpoint,
+_("Could not queue AG %u icount work."), agno);
+			break;
+		}
+	}
+	workqueue_destroy(&wq);
+
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		*count += ci->counters[agno];
+	moveon = ci->moveon;
+
+out_free:
+	free(ci);
+	return moveon;
+}
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
+	*d_blocks = sfs.f_blocks + (ctx->geo.logstart ? ctx->geo.logblocks : 0);
+	*d_bfree = sfs.f_bfree;
+	*r_blocks = ctx->geo.rtblocks;
+	*r_bfree = fc.freertx;
+	*f_files = sfs.f_files;
+	*f_free = sfs.f_ffree;
+
+	return true;
+}
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
new file mode 100644
index 0000000..c181d05
--- /dev/null
+++ b/scrub/fscounters.h
@@ -0,0 +1,29 @@
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
+#ifndef XFS_SCRUB_FSCOUNTERS_H_
+#define XFS_SCRUB_FSCOUNTERS_H_
+
+bool xfs_scan_estimate_blocks(struct scrub_ctx *ctx,
+		unsigned long long *d_blocks, unsigned long long *d_bfree,
+		unsigned long long *r_blocks, unsigned long long *r_bfree,
+		unsigned long long *f_files, unsigned long long *f_free);
+bool xfs_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
+
+#endif /* XFS_SCRUB_FSCOUNTERS_H_ */

