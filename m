Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25702 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:53 -0400
Subject: [PATCH 20/22] xfs_scrub: progress indicator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:46 -0700
Message-ID: <150180538626.18784.15043826766674301741.stgit@magnolia>
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

Implement a progress indicator.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |   11 ++-
 scrub/Makefile       |    2 
 scrub/common.c       |   27 +++++-
 scrub/ioctl.c        |   28 +++++++
 scrub/ioctl.h        |    2 
 scrub/phase2.c       |   15 +++
 scrub/phase3.c       |   16 ++++
 scrub/phase4.c       |   26 ++++++
 scrub/phase5.c       |    2 
 scrub/phase6.c       |   28 +++++++
 scrub/progress.c     |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/progress.h     |   33 ++++++++
 scrub/read_verify.c  |    2 
 scrub/repair.c       |    3 +
 scrub/repair.h       |    3 +
 scrub/scrub.c        |   57 +++++++++++++
 scrub/scrub.h        |    2 
 scrub/xfs.h          |   11 +++
 18 files changed, 471 insertions(+), 12 deletions(-)
 create mode 100644 scrub/progress.c
 create mode 100644 scrub/progress.h


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index a432aed..4505c3e 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -4,7 +4,7 @@ xfs_scrub \- scrub the contents of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_scrub
 [
-.B \-abemnTvVxy
+.B \-abCemnTvVxy
 ]
 .I mount-point
 .br
@@ -47,6 +47,15 @@ time.
 If given more than once, an artificial delay of 100us is added to each
 scrub call to reduce CPU overhead even further.
 .TP
+.BI \-C " fd"
+This option causes xfs_scrub to write progress information to the
+specified file description so that the progress of the filesystem check
+can be monitored.
+If the file description is a tty, a fancy progress bar is rendered.
+Otherwise, a simple numeric status dump compatible with the
+.B fsck -C
+format is output.
+.TP
 .B \-e
 Specifies what happens when errors are detected.
 If
diff --git a/scrub/Makefile b/scrub/Makefile
index 0fbcf6b..5b3e522 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,6 +23,7 @@ common.h \
 counter.h \
 disk.h \
 ioctl.h \
+progress.h \
 read_verify.h \
 repair.h \
 scrub.h \
@@ -46,6 +47,7 @@ phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
+progress.c \
 read_verify.c \
 repair.c \
 scrub.c \
diff --git a/scrub/common.c b/scrub/common.c
index 02a8453..fca7243 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -37,6 +37,7 @@
 #include "input.h"
 #include "ioctl.h"
 #include "xfs.h"
+#include "progress.h"
 
 /*
  * Reporting Status to the Console
@@ -65,6 +66,18 @@ xfs_scrub_excessive_errors(
 	return ret;
 }
 
+/* If stderr is a tty, clear to end of line to clean up progress bar. */
+static inline const char *stderr_start(void)
+{
+	return stderr_isatty ? CLEAR_EOL : "";
+}
+
+/* If stdout is a tty, clear to end of line to clean up progress bar. */
+static inline const char *stdout_start(void)
+{
+	return stdout_isatty ? CLEAR_EOL : "";
+}
+
 /* Print an error string and whatever error is stored in errno. */
 void
 __str_errno(
@@ -76,7 +89,7 @@ __str_errno(
 	char			buf[DESCR_BUFSZ];
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Error: %s: %s."), descr,
+	fprintf(stderr, _("%sError: %s: %s."), stderr_start(), descr,
 			strerror_r(errno, buf, DESCR_BUFSZ));
 	if (debug)
 		fprintf(stderr, _(" (%s line %d)"), file, line);
@@ -96,7 +109,7 @@ __str_errno_warn(
 	char			buf[DESCR_BUFSZ];
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Warning: %s: %s."), descr,
+	fprintf(stderr, _("%sWarning: %s: %s."), stderr_start(), descr,
 			strerror_r(errno, buf, DESCR_BUFSZ));
 	if (debug)
 		fprintf(stderr, _(" (%s line %d)"), file, line);
@@ -118,7 +131,7 @@ __str_error(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Error: %s: "), descr);
+	fprintf(stderr, _("%sError: %s: "), stderr_start(), descr);
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
@@ -142,7 +155,7 @@ __str_warn(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Warning: %s: "), descr);
+	fprintf(stderr, _("%sWarning: %s: "), stderr_start(), descr);
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
@@ -166,7 +179,7 @@ __str_info(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stdout, _("Info: %s: "), descr);
+	fprintf(stdout, _("%sInfo: %s: "), stdout_start(), descr);
 	va_start(args, format);
 	vfprintf(stdout, format, args);
 	va_end(args);
@@ -190,7 +203,7 @@ __record_repair(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Repaired: %s: "), descr);
+	fprintf(stderr, _("%sRepaired: %s: "), stderr_start(), descr);
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
@@ -215,7 +228,7 @@ __record_preen(
 
 	pthread_mutex_lock(&ctx->lock);
 	if (debug || verbose) {
-		fprintf(stdout, _("Optimized: %s: "), descr);
+		fprintf(stdout, _("%sOptimized: %s: "), stdout_start(), descr);
 		va_start(args, format);
 		vfprintf(stdout, format, args);
 		va_end(args);
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
index 31d2fd8..914ec79 100644
--- a/scrub/ioctl.c
+++ b/scrub/ioctl.c
@@ -29,6 +29,7 @@
 #include "common.h"
 #include "ioctl.h"
 #include "repair.h"
+#include "progress.h"
 
 #define FSMAP_NR		65536
 #define BMAP_NR			2048
@@ -801,6 +802,7 @@ xfs_scrub_metadata(
 
 		/* Check the item. */
 		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+		progress_add(1);
 		switch (fix) {
 		case CHECK_ABORT:
 			return false;
@@ -848,6 +850,32 @@ xfs_scrub_fs_metadata(
 	return xfs_scrub_metadata(ctx, ST_FS, 0, rl);
 }
 
+/* How many items do we have to check? */
+unsigned int
+xfs_scrub_estimate_ag_work(
+	struct scrub_ctx		*ctx)
+{
+	const struct scrub_descr	*sc;
+	int				type;
+	unsigned int			estimate = 0;
+
+	sc = scrubbers;
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		switch (sc->type) {
+		case ST_AGHEADER:
+		case ST_PERAG:
+			estimate += ctx->geo.agcount;
+			break;
+		case ST_FS:
+			estimate++;
+			break;
+		default:
+			break;
+		}
+	}
+	return estimate;
+}
+
 /* Scrub inode metadata. */
 static bool
 __xfs_scrub_file(
diff --git a/scrub/ioctl.h b/scrub/ioctl.h
index ab4044a..283445e 100644
--- a/scrub/ioctl.h
+++ b/scrub/ioctl.h
@@ -117,4 +117,6 @@ bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		int fd, struct xfs_repair_list *repair_list);
 
+unsigned int xfs_scrub_estimate_ag_work(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_IOCTL_H_ */
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 8bf3ad6..91c0d8f 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -32,6 +32,7 @@
 #include "xfs_fs.h"
 #include "xfs.h"
 #include "repair.h"
+#include "progress.h"
 
 /* Phase 2: Check internal metadata. */
 
@@ -145,3 +146,17 @@ xfs_scan_metadata(
 
 	return moveon;
 }
+
+/* Estimate how much work we're going to do. */
+bool
+xfs_estimate_metadata_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	*items = xfs_scrub_estimate_ag_work(ctx);
+	*nr_threads = scrub_nproc(ctx);
+	*rshift = 0;
+	return true;
+}
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 3cfbea4..bcc848f 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -32,6 +32,7 @@
 #include "xfs_fs.h"
 #include "xfs.h"
 #include "repair.h"
+#include "progress.h"
 
 /* Phase 3: Scan all inodes. */
 
@@ -143,6 +144,7 @@ xfs_scrub_inode(
 		goto out;
 
 out:
+	progress_add(1);
 	xfs_defer_repairs(ctx, agno, &repairs);
 	if (fd >= 0)
 		close(fd);
@@ -161,3 +163,17 @@ xfs_scan_inodes(
 	xfs_scrub_report_preen_triggers(ctx);
 	return true;
 }
+
+/* Estimate how much work we're going to do. */
+bool
+xfs_estimate_inodes_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*nr_threads = scrub_nproc(ctx);
+	*rshift = 0;
+	return true;
+}
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 606f3fd..e6c39d6 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -33,6 +33,7 @@
 #include "ioctl.h"
 #include "xfs_fs.h"
 #include "repair.h"
+#include "progress.h"
 
 /* Phase 4: Repair filesystem. */
 
@@ -52,6 +53,7 @@ xfs_repair_ag(
 
 	repairs = &ctx->repair_lists[agno];
 	unfixed = xfs_repair_list_length(repairs);
+	flags |= XRML_REPORT_PROGRESS;
 
 	/* Repair anything broken until we fail to make progress. */
 	do {
@@ -88,9 +90,31 @@ xfs_repair_fs(
 	destroy_work_queue(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
-	if (moveon && ctx->errors_found == 0)
+	if (moveon && ctx->errors_found == 0) {
 		fstrim(ctx);
+		progress_add(1);
+	}
 	pthread_mutex_unlock(&ctx->lock);
 
 	return moveon;
 }
+
+/* Estimate how much work we're going to do. */
+bool
+xfs_estimate_repair_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	xfs_agnumber_t		agno;
+	size_t			need_fixing = 0;
+
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		need_fixing += xfs_repair_list_length(&ctx->repair_lists[agno]);
+	need_fixing++;
+	*items = need_fixing;
+	*nr_threads = scrub_nproc(ctx) + 1;
+	*rshift = 0;
+	return true;
+}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 9010a08..8b8e314 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -32,6 +32,7 @@
 #include "xfs_fs.h"
 #include "xfs.h"
 #include "unicrash.h"
+#include "progress.h"
 
 /* Phase 5: Check directory connectivity. */
 
@@ -86,6 +87,7 @@ xfs_scrub_connections(
 	}
 
 out:
+	progress_add(1);
 	if (fd >= 0)
 		close(fd);
 	if (error)
diff --git a/scrub/phase6.c b/scrub/phase6.c
index d60a044..f8713a9 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -33,6 +33,7 @@
 #include "ioctl.h"
 #include "xfs_fs.h"
 #include "xfs.h"
+#include "progress.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -537,3 +538,30 @@ xfs_scan_blocks(
 	free(ve);
 	return moveon;
 }
+
+/* Estimate how much work we're going to do. */
+bool
+xfs_estimate_verify_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	unsigned long long	d_blocks;
+	unsigned long long	d_bfree;
+	unsigned long long	r_blocks;
+	unsigned long long	r_bfree;
+	unsigned long long	f_files;
+	unsigned long long	f_free;
+	bool			moveon;
+
+	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
+				&r_blocks, &r_bfree, &f_files, &f_free);
+	if (!moveon)
+		return moveon;
+
+	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
+	*nr_threads = disk_heads(&ctx->datadev);
+	*rshift = 20;
+	return moveon;
+}
diff --git a/scrub/progress.c b/scrub/progress.c
new file mode 100644
index 0000000..80947ef
--- /dev/null
+++ b/scrub/progress.c
@@ -0,0 +1,215 @@
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
+#include <stdio.h>
+#include <dirent.h>
+#include <sys/statvfs.h>
+#include "../repair/threads.h"
+#include "path.h"
+#include "disk.h"
+#include "read_verify.h"
+#include "scrub.h"
+#include "common.h"
+#include "counter.h"
+#include "progress.h"
+
+/*
+ * Progress Tracking
+ *
+ * For scrub phases that expect to take a long time, this facility uses
+ * the threaded counter and some phase/state information to report the
+ * progress of a particular phase to stdout.  Each phase that wants
+ * progress information needs to set up the tracker with an estimate of
+ * the work to be done and periodic updates when work items finish.  In
+ * return, the progress tracker will print a pretty progress bar and
+ * twiddle to a tty, or a raw numeric output compatible with fsck -C.
+ */
+struct progress_tracker {
+	FILE			*fp;
+	const char		*tag;
+	struct ptcounter	*ptc;
+	uint64_t		max;
+	unsigned int		phase;
+	int			rshift;
+	int			twiddle;
+	bool			isatty;
+};
+
+static struct progress_tracker pt;
+
+/* Add some progress. */
+void
+progress_add(
+	uint64_t		x)
+{
+	if (pt.fp)
+		ptcounter_add(pt.ptc, x);
+}
+
+static const char twiddles[] = "|/-\\";
+
+static void
+progress_report(
+	uint64_t		sum)
+{
+	char			buf[80];
+	int			tag_len;
+	int			num_len;
+	int			pbar_len;
+	int			plen;
+
+	if (!pt.fp)
+		return;
+
+	if (sum > pt.max)
+		sum = pt.max;
+
+	/* Emulate fsck machine-readable output (phase, cur, max, label) */
+	if (!pt.isatty) {
+		snprintf(buf, sizeof(buf), _("%u %"PRIu64" %"PRIu64" %s"),
+				pt.phase, sum, pt.max, pt.tag);
+		fprintf(pt.fp, "%s\n", buf);
+		fflush(pt.fp);
+		return;
+	}
+
+	/* Interactive twiddle progress bar. */
+	tag_len = snprintf(buf, sizeof(buf), _("Phase %u: |"), pt.phase);
+	num_len = snprintf(buf, sizeof(buf),
+			"%c %"PRIu64"/%"PRIu64" (%.1f%%)",
+			twiddles[pt.twiddle],
+			sum >> pt.rshift,
+			pt.max >> pt.rshift,
+			100.0 * sum / pt.max) + 1;
+	pbar_len = sizeof(buf) - (num_len + tag_len);
+	snprintf(buf, sizeof(buf), _("Phase %u: |"), pt.phase);
+	snprintf(buf + sizeof(buf) - num_len, num_len,
+			"%c %"PRIu64"/%"PRIu64" (%.1f%%)",
+			twiddles[pt.twiddle],
+			sum >> pt.rshift,
+			pt.max >> pt.rshift,
+			100.0 * sum / pt.max);
+	plen = (int)((double)pbar_len * sum / pt.max);
+	memset(buf + tag_len, '=', plen);
+	memset(buf + tag_len + plen, ' ', pbar_len - plen);
+	pt.twiddle = (pt.twiddle + 1) % 4;
+	fprintf(pt.fp, "%c%s\r%c", START_IGNORE, buf, END_IGNORE);
+	fflush(pt.fp);
+}
+
+static void
+progress_report_handler(
+	int			sig)
+{
+	if (!pt.fp)
+		return;
+
+	progress_report(ptcounter_value(pt.ptc));
+}
+
+/* End a phase of progress reporting. */
+void
+progress_end_phase(void)
+{
+	struct sigaction	sa = {
+		.sa_handler = SIG_DFL,
+	};
+	struct itimerval	itimer = {
+		.it_interval = {
+			.tv_sec = 0,
+		},
+		.it_value = {
+			.tv_sec = 0,
+		},
+	};
+
+	if (!pt.fp)
+		return;
+
+	setitimer(ITIMER_REAL, &itimer, NULL);
+	sigaction(SIGALRM, &sa, NULL);
+	progress_report(pt.max);
+	ptcounter_free(pt.ptc);
+	pt.max = 0;
+	pt.ptc = NULL;
+	if (pt.fp) {
+		fprintf(pt.fp, CLEAR_EOL);
+		fflush(pt.fp);
+	}
+	pt.fp = NULL;
+}
+
+/* Set ourselves up to report progress. */
+bool
+progress_init_phase(
+	struct scrub_ctx	*ctx,
+	FILE			*fp,
+	unsigned int		phase,
+	uint64_t		max,
+	int			rshift,
+	unsigned int		nr_threads)
+{
+	struct sigaction	sa = {
+		.sa_handler = progress_report_handler,
+	};
+	struct itimerval	itimer = {
+		.it_interval = {
+			.tv_sec = 0,
+			.tv_usec = 500000,
+		},
+		.it_value = {
+			.tv_sec = 0,
+			.tv_usec = 500000,
+		},
+	};
+	int			ret;
+
+	assert(pt.fp == NULL);
+	if (fp == NULL || max == 0) {
+		pt.fp = NULL;
+		return true;
+	}
+	pt.fp = fp;
+	pt.isatty = isatty(fileno(fp));
+	pt.tag = ctx->mntpoint;
+	pt.max = max;
+	pt.phase = phase;
+	pt.rshift = rshift;
+	pt.twiddle = 0;
+	pt.ptc = ptcounter_init(nr_threads);
+	if (!pt.ptc)
+		goto out_max;
+	ret = sigaction(SIGALRM, &sa, NULL);
+	if (ret)
+		goto out_ptcounter;
+	ret = setitimer(ITIMER_REAL, &itimer, NULL);
+	if (ret)
+		goto out_sigaction;
+	return true;
+out_sigaction:
+	sa.sa_handler = SIG_DFL;
+	sigaction(SIGALRM, &sa, NULL);
+out_ptcounter:
+	ptcounter_free(pt.ptc);
+	pt.ptc = NULL;
+out_max:
+	pt.max = 0;
+	return false;
+}
diff --git a/scrub/progress.h b/scrub/progress.h
new file mode 100644
index 0000000..1fbbf77
--- /dev/null
+++ b/scrub/progress.h
@@ -0,0 +1,33 @@
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
+#ifndef XFS_SCRUB_PROGRESS_H_
+#define XFS_SCRUB_PROGRESS_H_
+
+#define CLEAR_EOL	"\033[K"
+#define START_IGNORE	'\001'
+#define END_IGNORE	'\002'
+
+bool progress_init_phase(struct scrub_ctx *ctx, FILE *progress_fp,
+			 unsigned int phase, uint64_t max, int rshift,
+			 unsigned int nr_threads);
+void progress_end_phase(void);
+void progress_add(uint64_t x);
+
+#endif /* XFS_SCRUB_PROGRESS_H_ */
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 18ba73a..b4fa081 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -29,6 +29,7 @@
 #include "scrub.h"
 #include "common.h"
 #include "counter.h"
+#include "progress.h"
 
 /*
  * Read Verify Pool
@@ -123,6 +124,7 @@ read_verify(
 					errno, rv->io_end_arg);
 		}
 
+		progress_add(len);
 		verified += len;
 		rv->io_start += len;
 		rv->io_length -= len;
diff --git a/scrub/repair.c b/scrub/repair.c
index 53706c3..2dbd413 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -37,6 +37,7 @@
 #include "common.h"
 #include "ioctl.h"
 #include "repair.h"
+#include "progress.h"
 
 /*
  * Prioritize repair items in order of how long we can wait.
@@ -261,6 +262,8 @@ xfs_repair_list_now(
 			rl->nr--;
 			list_del(&ri->list);
 			free(ri);
+			if (repair_flags & XRML_REPORT_PROGRESS)
+				progress_add(1);
 			continue;
 		case CHECK_ABORT:
 			return false;
diff --git a/scrub/repair.h b/scrub/repair.h
index 3142838..4eaf5f5 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -45,6 +45,9 @@ void xfs_repair_find_mustfix(struct xfs_repair_list *repairs,
 #define XRML_REPAIR_ONLY	(XRM_REPAIR_ONLY)
 #define XRML_NOFIX_COMPLAIN	(XRM_NOFIX_COMPLAIN)
 
+/* Report progress */
+#define XRML_REPORT_PROGRESS	(1 << 31)
+
 bool xfs_repair_list_now(struct scrub_ctx *ctx, int fd,
 			 struct xfs_repair_list *repair_list,
 			 unsigned int repair_flags);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index b654be5..f319f5b 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -38,6 +38,7 @@
 #include "input.h"
 #include "ioctl.h"
 #include "xfs.h"
+#include "progress.h"
 
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
@@ -156,12 +157,17 @@ bool				scrub_data;
 /* Size of a memory page. */
 long				page_size;
 
+/* If stdout/stderr are ttys, we can use richer terminal control. */
+bool				stderr_isatty;
+bool				stdout_isatty;
+
 static void __attribute__((noreturn))
 usage(void)
 {
 	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
 	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
 	fprintf(stderr, _("-b:\tBackground mode.\n"));
+	fprintf(stderr, _("-C:\tPrint progress information to this fd.\n"));
 	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
 	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
 	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
@@ -236,6 +242,8 @@ struct phase_rusage {
 struct phase_ops {
 	char		*descr;
 	bool		(*fn)(struct scrub_ctx *);
+	bool		(*estimate_work)(struct scrub_ctx *, uint64_t *,
+					 unsigned int *, int *);
 	bool		must_run;
 };
 
@@ -440,7 +448,8 @@ _("Errors found, please re-run with -y."));
 /* Run all the phases of the scrubber. */
 static bool
 run_scrub_phases(
-	struct scrub_ctx	*ctx)
+	struct scrub_ctx	*ctx,
+	FILE			*progress_fp)
 {
 	struct phase_ops phases[] =
 	{
@@ -452,22 +461,27 @@ run_scrub_phases(
 		{
 			.descr = _("Check internal metadata."),
 			.fn = xfs_scan_metadata,
+			.estimate_work = xfs_estimate_metadata_work,
 		},
 		{
 			.descr = _("Scan all inodes."),
 			.fn = xfs_scan_inodes,
+			.estimate_work = xfs_estimate_inodes_work,
 		},
 		{
 			.descr = _("Defer filesystem repairs."),
 			.fn = REPAIR_DUMMY_FN,
+			.estimate_work = xfs_estimate_repair_work,
 		},
 		{
 			.descr = _("Check directory tree."),
 			.fn = xfs_scan_connections,
+			.estimate_work = xfs_estimate_inodes_work,
 		},
 		{
 			.descr = _("Verify data file integrity."),
 			.fn = DATASCAN_DUMMY_FN,
+			.estimate_work = xfs_estimate_verify_work,
 		},
 		{
 			.descr = _("Check summary counters."),
@@ -479,9 +493,12 @@ run_scrub_phases(
 	};
 	struct phase_rusage	pi;
 	struct phase_ops	*sp;
+	uint64_t		max_work;
 	bool			moveon = true;
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
+	unsigned int		nr_threads;
+	int			rshift;
 
 	if (debug && debug_tweak_on("XFS_SCRUB_PHASE"))
 		debug_phase = atoi(getenv("XFS_SCRUB_PHASE"));
@@ -514,6 +531,18 @@ run_scrub_phases(
 		moveon = phase_start(&pi, phase, sp->descr);
 		if (!moveon)
 			break;
+		if (sp->estimate_work) {
+			moveon = sp->estimate_work(ctx, &max_work, &nr_threads,
+					&rshift);
+			if (!moveon)
+				break;
+			moveon = progress_init_phase(ctx, progress_fp, phase,
+					max_work, rshift, nr_threads);
+		} else {
+			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
+		}
+		if (!moveon)
+			break;
 		moveon = sp->fn(ctx);
 		if (!moveon) {
 			str_info(ctx, ctx->mntpoint,
@@ -521,6 +550,7 @@ _("Scrub aborted after phase %d."),
 					phase);
 			break;
 		}
+		progress_end_phase();
 		moveon = phase_end(&pi, phase);
 		if (!moveon)
 			break;
@@ -541,6 +571,7 @@ main(
 {
 	int			c;
 	char			*mtab = NULL;
+	FILE			*progress_fp = NULL;
 	struct scrub_ctx	ctx = {0};
 	struct phase_rusage	all_pi;
 	unsigned long long	total_errors;
@@ -559,7 +590,7 @@ main(
 	ctx.datadev.d_fd = -1;
 	ctx.mode = SCRUB_MODE_DEFAULT;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:m:nTvxVy")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -572,6 +603,19 @@ main(
 			nr_threads = 1;
 			bg_mode++;
 			break;
+		case 'C':
+			errno = 0;
+			ret = cvt_u32(optarg, 10);
+			if (errno) {
+				perror(optarg);
+				usage();
+			}
+			progress_fp = fdopen(ret, "w");
+			if (!progress_fp) {
+				perror(optarg);
+				usage();
+			}
+			break;
 		case 'd':
 			debug++;
 			dumpcore = true;
@@ -624,6 +668,13 @@ _("Only one of the options -n or -y may be specified.\n"));
 		}
 	}
 
+	stdout_isatty = isatty(STDOUT_FILENO);
+	stderr_isatty = isatty(STDERR_FILENO);
+
+	/* If interactive, start the progress bar. */
+	if (stdout_isatty && !progress_fp)
+		progress_fp = fdopen(1, "w+");
+
 	/* Override thread count if debugger */
 	if (debug_tweak_on("XFS_SCRUB_THREADS")) {
 		unsigned int	x;
@@ -703,7 +754,7 @@ _("Only one of the options -n or -y may be specified.\n"));
 	}
 
 	/* Scrub a filesystem. */
-	moveon = run_scrub_phases(&ctx);
+	moveon = run_scrub_phases(&ctx, progress_fp);
 	if (!moveon)
 		goto out;
 
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0561044..4050b73 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -29,6 +29,8 @@ extern bool			dumpcore;
 extern bool			verbose;
 extern bool			scrub_data;
 extern long			page_size;
+extern bool			stderr_isatty;
+extern bool			stdout_isatty;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
diff --git a/scrub/xfs.h b/scrub/xfs.h
index 8a7d32e..448a536 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -48,4 +48,15 @@ bool xfs_scan_blocks(struct scrub_ctx *ctx);
 bool xfs_scan_summary(struct scrub_ctx *ctx);
 bool xfs_repair_fs(struct scrub_ctx *ctx);
 
+uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
+
+bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
+				unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_repair_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_verify_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+
 #endif /* XFS_SCRUB_XFS_H_ */

