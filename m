Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25473 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:55 -0400
Subject: [PATCH 12/22] xfs_scrub: create infrastructure to read verify data
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:49 -0700
Message-ID: <150180532980.18784.10263073309779099054.stgit@magnolia>
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

Manage the scheduling, issuance, and reporting of data block
verification reads.  This enables us to combine adjacent (or nearly
adjacent) read requests, and to take advantage of high-IOPS devices by
issuing IO from multiple threads.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile      |    2 
 scrub/phase1.c      |    1 
 scrub/phase2.c      |    1 
 scrub/phase3.c      |    1 
 scrub/phase5.c      |    1 
 scrub/read_verify.c |  224 +++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/read_verify.h |   58 +++++++++++++
 scrub/scrub.c       |   25 ++++++
 scrub/scrub.h       |   13 +++
 9 files changed, 326 insertions(+)
 create mode 100644 scrub/read_verify.c
 create mode 100644 scrub/read_verify.h


diff --git a/scrub/Makefile b/scrub/Makefile
index b1cd393..5df3e95 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,6 +23,7 @@ common.h \
 counter.h \
 disk.h \
 ioctl.h \
+read_verify.h \
 scrub.h \
 xfs.h
 
@@ -38,6 +39,7 @@ phase1.c \
 phase2.c \
 phase3.c \
 phase5.c \
+read_verify.c \
 scrub.c \
 xfs.c
 
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6c3aab4..66f4aa3 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -25,6 +25,7 @@
 #include "../repair/threads.h"
 #include "handle.h"
 #include "path.h"
+#include "bitmap.h"
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index b8b44ac..88136a3 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -25,6 +25,7 @@
 #include "../repair/threads.h"
 #include "handle.h"
 #include "path.h"
+#include "bitmap.h"
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index cdd8a7c..b920995 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -25,6 +25,7 @@
 #include "../repair/threads.h"
 #include "handle.h"
 #include "path.h"
+#include "bitmap.h"
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 7ea8b58..e5a5835 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -25,6 +25,7 @@
 #include "../repair/threads.h"
 #include "handle.h"
 #include "path.h"
+#include "bitmap.h"
 #include "scrub.h"
 #include "common.h"
 #include "ioctl.h"
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
new file mode 100644
index 0000000..18ba73a
--- /dev/null
+++ b/scrub/read_verify.c
@@ -0,0 +1,224 @@
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
+#include "path.h"
+#include "disk.h"
+#include "read_verify.h"
+#include "scrub.h"
+#include "common.h"
+#include "counter.h"
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
+/* How many bytes have we verified? */
+static struct ptcounter		*verified_bytes;
+
+/* Tolerate 64k holes in adjacent read verify requests. */
+#define IO_BATCH_LOCALITY	(65536)
+
+/* Create a thread pool to run read verifiers. */
+bool
+read_verify_pool_init(
+	struct read_verify_pool		**rvpp,
+	struct scrub_ctx		*ctx,
+	void				*readbuf,
+	size_t				readbufsz,
+	size_t				miniosz,
+	read_verify_ioerr_fn_t		ioerr_fn,
+	unsigned int			nproc)
+{
+	struct read_verify_pool		*rvp;
+
+	rvp = calloc(sizeof(struct read_verify_pool), 1);
+	if (!rvp)
+		return false;
+	verified_bytes = ptcounter_init(nproc);
+	if (!verified_bytes) {
+		free(rvp);
+		return false;
+	}
+	rvp->rvp_readbuf = readbuf;
+	rvp->rvp_readbufsz = readbufsz;
+	rvp->rvp_miniosz = miniosz;
+	rvp->rvp_ctx = ctx;
+	rvp->rvp_ioerr_fn = ioerr_fn;
+	rvp->rvp_nproc = nproc;
+	create_work_queue(&rvp->rvp_wq, (struct xfs_mount *)rvp, nproc);
+	*rvpp = rvp;
+	return true;
+}
+
+/* Finish up any read verification work and tear it down. */
+void
+read_verify_pool_destroy(
+	struct read_verify_pool		**rvpp)
+{
+	struct read_verify_pool		*rvp = *rvpp;
+
+	destroy_work_queue(&rvp->rvp_wq);
+	ptcounter_free(verified_bytes);
+	verified_bytes = NULL;
+	*rvpp = NULL;
+}
+
+/*
+ * Issue a read-verify IO in big batches.
+ */
+static void
+read_verify(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct read_verify		*rv = arg;
+	struct read_verify_pool		*rvp;
+	unsigned long long		verified = 0;
+	ssize_t				sz;
+	ssize_t				len;
+
+	rvp = (struct read_verify_pool *)wq->mp;
+	while (rv->io_length > 0) {
+		len = min(rv->io_length, rvp->rvp_readbufsz);
+		dbg_printf("diskverify %d %"PRIu64" %zu\n", rv->io_disk->d_fd,
+				rv->io_start, len);
+		sz = disk_read_verify(rv->io_disk, rvp->rvp_readbuf,
+				rv->io_start, len);
+		if (sz < 0) {
+			dbg_printf("IOERR %d %"PRIu64" %zu\n",
+					rv->io_disk->d_fd,
+					rv->io_start, len);
+			/* IO error, so try the next logical block. */
+			len = rvp->rvp_miniosz;
+			rvp->rvp_ioerr_fn(rvp, rv->io_disk, rv->io_start, len,
+					errno, rv->io_end_arg);
+		}
+
+		verified += len;
+		rv->io_start += len;
+		rv->io_length -= len;
+	}
+
+	free(rv);
+	ptcounter_add(verified_bytes, verified);
+}
+
+/* Queue a read verify request. */
+static void
+read_verify_queue(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	struct read_verify		*tmp;
+
+	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
+			rv->io_disk->d_fd, rv->io_start, rv->io_length);
+
+	tmp = malloc(sizeof(struct read_verify));
+	if (!tmp) {
+		rvp->rvp_ioerr_fn(rvp, rv->io_disk, rv->io_start, rv->io_length,
+				errno, rv->io_end_arg);
+		return;
+	}
+	*tmp = *rv;
+
+	queue_work(&rvp->rvp_wq, read_verify, 0, tmp);
+}
+
+/*
+ * Issue an IO request.  We'll batch subsequent requests if they're
+ * within 64k of each other
+ */
+void
+read_verify_schedule(
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
+	assert(rvp->rvp_readbuf);
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
+	    ((start >= rv->io_start && start <= rv_end + IO_BATCH_LOCALITY) ||
+	     (rv->io_start >= start &&
+	      rv->io_start <= req_end + IO_BATCH_LOCALITY))) {
+		rv->io_start = min(rv->io_start, start);
+		rv->io_length = max(req_end, rv_end) - rv->io_start;
+	} else  {
+		/* Otherwise, issue the stashed IO (if there is one) */
+		if (rv->io_length > 0)
+			read_verify_queue(rvp, rv);
+
+		/* Stash the new IO. */
+		rv->io_disk = disk;
+		rv->io_start = start;
+		rv->io_length = length;
+		rv->io_end_arg = end_arg;
+	}
+}
+
+/* Force any stashed IOs into the verifier. */
+void
+read_verify_force(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	assert(rvp->rvp_readbuf);
+	if (rv->io_length == 0)
+		return;
+
+	read_verify_queue(rvp, rv);
+	rv->io_length = 0;
+}
+
+/* How many bytes has this process verified? */
+unsigned long long
+read_verify_bytes(void)
+{
+	if (!verified_bytes)
+		return 0;
+	return ptcounter_value(verified_bytes);
+}
+
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
new file mode 100644
index 0000000..59cddd7
--- /dev/null
+++ b/scrub/read_verify.h
@@ -0,0 +1,58 @@
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
+struct read_verify_pool;
+
+/* Function called when an IO error happens. */
+typedef void (*read_verify_ioerr_fn_t)(struct read_verify_pool *rvp,
+		struct disk *disk, uint64_t start, uint64_t length,
+		int error, void *arg);
+
+struct read_verify_pool {
+	struct work_queue	rvp_wq;		/* thread pool */
+	struct scrub_ctx	*rvp_ctx;	/* scrub context */
+	void			*rvp_readbuf;	/* read buffer */
+	read_verify_ioerr_fn_t	rvp_ioerr_fn;	/* io error callback */
+	size_t			rvp_miniosz;	/* minimum io size, bytes */
+	size_t			rvp_readbufsz;	/* read buffer size, bytes */
+	int			rvp_nproc;	/* number of threads */
+};
+
+bool read_verify_pool_init(struct read_verify_pool **rvpp, struct scrub_ctx *ctx,
+		void *readbuf, size_t readbufsz, size_t miniosz,
+		read_verify_ioerr_fn_t ioerr_fn, unsigned int nproc);
+void read_verify_pool_destroy(struct read_verify_pool **rvpp);
+
+struct read_verify {
+	void			*io_end_arg;
+	struct disk		*io_disk;
+	uint64_t		io_start;	/* bytes */
+	uint64_t		io_length;	/* bytes */
+};
+
+void read_verify_schedule(struct read_verify_pool *rvp, struct read_verify *rv,
+		struct disk *disk, uint64_t start, uint64_t length,
+		void *end_arg);
+void read_verify_force(struct read_verify_pool *rvp, struct read_verify *rv);
+unsigned long long read_verify_bytes(void);
+
+#endif /* XFS_SCRUB_READ_VERIFY_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c2385da..d4527e4 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -32,6 +32,7 @@
 #include "../repair/threads.h"
 #include "path.h"
 #include "disk.h"
+#include "read_verify.h"
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
@@ -251,6 +252,8 @@ phase_start(
 		return false;
 	}
 
+	pi->verified_bytes = read_verify_bytes();
+
 	pi->descr = descr;
 	if ((verbose || display_rusage) && descr) {
 		fprintf(stdout, _("Phase %u: %s\n"), phase, descr);
@@ -272,11 +275,14 @@ phase_end(
 	struct timeval		time_now;
 	char			phasebuf[DESCR_BUFSZ];
 	double			dt;
+	unsigned long long	verified;
 	long			in, out;
 	long			io;
 	double			i, o, t;
 	double			din, dout, dtot;
 	char			*iu, *ou, *tu, *dinu, *doutu, *dtotu;
+	double			v, dv;
+	char			*vu, *dvu;
 	int			error;
 
 	if (!display_rusage)
@@ -339,6 +345,15 @@ _("%sI/O: %.1f%s in, %.1f%s out, %.1f%s tot\n"),
 _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
 			phasebuf, din, dinu, dout, doutu, dtot, dtotu);
 	}
+
+	/* How many bytes were read-verified? */
+	verified = read_verify_bytes() - pi->verified_bytes;
+	if (verified) {
+		v = auto_space_units(verified, &vu);
+		dv = auto_space_units(verified / dt, &dvu);
+		fprintf(stdout, _("Phase %u: Verify: %.1f%s, rate: %.1f%s/s\n"),
+			phase, v, vu, dv, dvu);
+	}
 	fflush(stdout);
 
 	return true;
@@ -496,6 +511,7 @@ main(
 	bool			ismnt;
 	static bool		injected;
 	int			ret;
+	int			error;
 
 	fprintf(stderr, "XXX: This program is not complete!\n");
 	return 4;
@@ -639,6 +655,14 @@ _("Only one of the options -n or -y may be specified.\n"));
 		goto out;
 	}
 
+	/* Try to allocate a read buffer if we don't have one. */
+	error = posix_memalign((void **)&ctx.readbuf, page_size,
+			IO_MAX_SIZE);
+	if (error || !ctx.readbuf) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
 		ctx.mode = SCRUB_MODE_REPAIR;
 		injected = true;
@@ -692,6 +716,7 @@ _("%s: %llu warnings found.\n"),
 	disk_close(&ctx.datadev);
 
 	free(ctx.blkdev);
+	free(ctx.readbuf);
 	free(ctx.mntpoint);
 end:
 	return ret;
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 87f59d6..0b82d9f 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -42,6 +42,15 @@ enum error_action {
 	ERRORS_SHUTDOWN,
 };
 
+/*
+ * Perform all IO in 32M chunks.  This cannot exceed 65536 sectors
+ * because that's the biggest SCSI VERIFY(16) we dare to send.
+ */
+#define IO_MAX_SIZE		33554432
+#define IO_MAX_SECTORS		(IO_MAX_SIZE >> BBSHIFT)
+
+struct read_verify_pool;
+
 struct scrub_ctx {
 	/* Immutable scrub state. */
 
@@ -81,8 +90,12 @@ struct scrub_ctx {
 	void			*fshandle;
 	size_t			fshandle_len;
 
+	/* Data block read verification buffer */
+	void			*readbuf;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
+	struct read_verify_pool	*rvp;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;

