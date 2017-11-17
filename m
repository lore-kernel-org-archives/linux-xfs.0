Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47335 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdKQVCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:14 -0500
Subject: [PATCH 20/27] xfs_scrub: create infrastructure to read verify data
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:02:09 -0800
Message-ID: <151095252970.4825.10852611845789321608.stgit@magnolia>
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

Manage the scheduling, issuance, and reporting of data block
verification reads.  This enables us to combine adjacent (or nearly
adjacent) read requests, and to take advantage of high-IOPS devices by
issuing IO from multiple threads.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile      |    2 
 scrub/read_verify.c |  268 +++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/read_verify.h |   50 ++++++++++
 scrub/xfs_scrub.h   |    3 +
 4 files changed, 323 insertions(+)
 create mode 100644 scrub/read_verify.c
 create mode 100644 scrub/read_verify.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 4118ab6..d1d1eb1 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,6 +23,7 @@ disk.h \
 filemap.h \
 fscounters.h \
 inodes.h \
+read_verify.h \
 scrub.h \
 spacemap.h \
 unicrash.h \
@@ -40,6 +41,7 @@ phase1.c \
 phase2.c \
 phase3.c \
 phase5.c \
+read_verify.c \
 scrub.c \
 spacemap.c \
 xfs_scrub.c
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
new file mode 100644
index 0000000..b3e79a4
--- /dev/null
+++ b/scrub/read_verify.c
@@ -0,0 +1,268 @@
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
+#include <stdlib.h>
+#include <sys/statvfs.h>
+#include "workqueue.h"
+#include "path.h"
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "counter.h"
+#include "disk.h"
+#include "read_verify.h"
+
+/*
+ * Read Verify Pool
+ *
+ * Manages the data block read verification phase.  The caller schedules
+ * verification requests, which are then scheduled to be run by a thread
+ * pool worker.  Adjacent (or nearly adjacent) requests can be combined
+ * to reduce overhead when free space fragmentation is high.  The thread
+ * pool takes care of issuing multiple IOs to the device, if possible.
+ */
+
+/*
+ * Perform all IO in 32M chunks.  This cannot exceed 65536 sectors
+ * because that's the biggest SCSI VERIFY(16) we dare to send.
+ */
+#define RVP_IO_MAX_SIZE		(33554432)
+#define RVP_IO_MAX_SECTORS	(RVP_IO_MAX_SIZE >> BBSHIFT)
+
+/* Tolerate 64k holes in adjacent read verify requests. */
+#define RVP_IO_BATCH_LOCALITY	(65536)
+
+struct read_verify_pool {
+	struct workqueue	wq;		/* thread pool */
+	struct scrub_ctx	*ctx;		/* scrub context */
+	void			*readbuf;	/* read buffer */
+	struct ptcounter	*verified_bytes;
+	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
+	size_t			miniosz;	/* minimum io size, bytes */
+};
+
+/* Create a thread pool to run read verifiers. */
+struct read_verify_pool *
+read_verify_pool_init(
+	struct scrub_ctx		*ctx,
+	size_t				miniosz,
+	read_verify_ioerr_fn_t		ioerr_fn,
+	unsigned int			nproc)
+{
+	struct read_verify_pool		*rvp;
+	bool				ret;
+	int				error;
+
+	rvp = calloc(1, sizeof(struct read_verify_pool));
+	if (!rvp)
+		return NULL;
+
+	error = posix_memalign((void **)&rvp->readbuf, page_size,
+			RVP_IO_MAX_SIZE);
+	if (error || !rvp->readbuf)
+		goto out_free;
+	rvp->verified_bytes = ptcounter_init(nproc);
+	if (!rvp->verified_bytes)
+		goto out_buf;
+	rvp->miniosz = miniosz;
+	rvp->ctx = ctx;
+	rvp->ioerr_fn = ioerr_fn;
+	/* Run in the main thread if we only want one thread. */
+	if (nproc == 1)
+		nproc = 0;
+	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp, nproc);
+	if (ret)
+		goto out_counter;
+	return rvp;
+
+out_counter:
+	ptcounter_free(rvp->verified_bytes);
+out_buf:
+	free(rvp->readbuf);
+out_free:
+	free(rvp);
+	return NULL;
+}
+
+/* Finish up any read verification work. */
+void
+read_verify_pool_flush(
+	struct read_verify_pool		*rvp)
+{
+	workqueue_destroy(&rvp->wq);
+}
+
+/* Finish up any read verification work and tear it down. */
+void
+read_verify_pool_destroy(
+	struct read_verify_pool		*rvp)
+{
+	ptcounter_free(rvp->verified_bytes);
+	free(rvp->readbuf);
+	free(rvp);
+}
+
+/*
+ * Issue a read-verify IO in big batches.
+ */
+static void
+read_verify(
+	struct workqueue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct read_verify		*rv = arg;
+	struct read_verify_pool		*rvp;
+	unsigned long long		verified = 0;
+	ssize_t				sz;
+	ssize_t				len;
+
+	rvp = (struct read_verify_pool *)wq->wq_ctx;
+	while (rv->io_length > 0) {
+		len = min(rv->io_length, RVP_IO_MAX_SIZE);
+		dbg_printf("diskverify %d %"PRIu64" %zu\n", rv->io_disk->d_fd,
+				rv->io_start, len);
+		sz = disk_read_verify(rv->io_disk, rvp->readbuf,
+				rv->io_start, len);
+		if (sz < 0) {
+			dbg_printf("IOERR %d %"PRIu64" %zu\n",
+					rv->io_disk->d_fd,
+					rv->io_start, len);
+			/* IO error, so try the next logical block. */
+			len = rvp->miniosz;
+			rvp->ioerr_fn(rvp->ctx, rv->io_disk, rv->io_start, len,
+					errno, rv->io_end_arg);
+		}
+
+		verified += len;
+		rv->io_start += len;
+		rv->io_length -= len;
+	}
+
+	free(rv);
+	ptcounter_add(rvp->verified_bytes, verified);
+}
+
+/* Queue a read verify request. */
+static bool
+read_verify_queue(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	struct read_verify		*tmp;
+	bool				ret;
+
+	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
+			rv->io_disk->d_fd, rv->io_start, rv->io_length);
+
+	tmp = malloc(sizeof(struct read_verify));
+	if (!tmp) {
+		rvp->ioerr_fn(rvp->ctx, rv->io_disk, rv->io_start,
+				rv->io_length, errno, rv->io_end_arg);
+		return true;
+	}
+	memcpy(tmp, rv, sizeof(*tmp));
+
+	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
+	if (ret) {
+		str_error(rvp->ctx, rvp->ctx->mntpoint,
+_("Could not queue read-verify work."));
+		free(tmp);
+		return false;
+	}
+	rv->io_length = 0;
+	return true;
+}
+
+/*
+ * Issue an IO request.  We'll batch subsequent requests if they're
+ * within 64k of each other
+ */
+bool
+read_verify_schedule_io(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	void				*end_arg)
+{
+	uint64_t			req_end;
+	uint64_t			rv_end;
+
+	assert(rvp->readbuf);
+	req_end = start + length;
+	rv_end = rv->io_start + rv->io_length;
+
+	/*
+	 * If we have a stashed IO, we haven't changed fds, the error
+	 * reporting is the same, and the two extents are close,
+	 * we can combine them.
+	 */
+	if (rv->io_length > 0 && disk == rv->io_disk &&
+	    end_arg == rv->io_end_arg &&
+	    ((start >= rv->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
+	     (rv->io_start >= start &&
+	      rv->io_start <= req_end + RVP_IO_BATCH_LOCALITY))) {
+		rv->io_start = min(rv->io_start, start);
+		rv->io_length = max(req_end, rv_end) - rv->io_start;
+	} else  {
+		/* Otherwise, issue the stashed IO (if there is one) */
+		if (rv->io_length > 0)
+			return read_verify_queue(rvp, rv);
+
+		/* Stash the new IO. */
+		rv->io_disk = disk;
+		rv->io_start = start;
+		rv->io_length = length;
+		rv->io_end_arg = end_arg;
+	}
+
+	return true;
+}
+
+/* Force any stashed IOs into the verifier. */
+bool
+read_verify_force_io(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	bool				moveon;
+
+	assert(rvp->readbuf);
+	if (rv->io_length == 0)
+		return true;
+
+	moveon = read_verify_queue(rvp, rv);
+	if (moveon)
+		rv->io_length = 0;
+	return moveon;
+}
+
+/* How many bytes has this process verified? */
+uint64_t
+read_verify_bytes(
+	struct read_verify_pool		*rvp)
+{
+	return ptcounter_value(rvp->verified_bytes);
+}
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
new file mode 100644
index 0000000..6b4e11b
--- /dev/null
+++ b/scrub/read_verify.h
@@ -0,0 +1,50 @@
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
+#ifndef XFS_SCRUB_READ_VERIFY_H_
+#define XFS_SCRUB_READ_VERIFY_H_
+
+struct scrub_ctx;
+struct read_verify_pool;
+
+/* Function called when an IO error happens. */
+typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
+		struct disk *disk, uint64_t start, uint64_t length,
+		int error, void *arg);
+
+struct read_verify_pool *read_verify_pool_init(struct scrub_ctx *ctx,
+		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
+		unsigned int nproc);
+void read_verify_pool_flush(struct read_verify_pool *rvp);
+void read_verify_pool_destroy(struct read_verify_pool *rvp);
+
+struct read_verify {
+	void			*io_end_arg;
+	struct disk		*io_disk;
+	uint64_t		io_start;	/* bytes */
+	uint64_t		io_length;	/* bytes */
+};
+
+bool read_verify_schedule_io(struct read_verify_pool *rvp,
+		struct read_verify *rv, struct disk *disk, uint64_t start,
+		uint64_t length, void *end_arg);
+bool read_verify_force_io(struct read_verify_pool *rvp, struct read_verify *rv);
+uint64_t read_verify_bytes(struct read_verify_pool *rvp);
+
+#endif /* XFS_SCRUB_READ_VERIFY_H_ */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index c7e8e8e..2396c6e 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -83,6 +83,9 @@ struct scrub_ctx {
 	void			*fshandle;
 	size_t			fshandle_len;
 
+	/* Data block read verification buffer */
+	void			*readbuf;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;

