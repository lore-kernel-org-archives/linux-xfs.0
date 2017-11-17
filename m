Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47552 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761942AbdKQVCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:49 -0500
Subject: [PATCH 25/27] xfs_scrub: progress indicator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:02:44 -0800
Message-ID: <151095256432.4825.7594399779351140361.stgit@magnolia>
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

Implement a progress indicator.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |   11 ++
 scrub/Makefile       |    2 
 scrub/common.c       |   23 ++++-
 scrub/phase2.c       |   14 +++
 scrub/phase3.c       |   16 ++++
 scrub/phase4.c       |   19 ++++
 scrub/phase5.c       |    2 
 scrub/phase6.c       |   28 ++++++
 scrub/progress.c     |  221 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/progress.h     |   33 +++++++
 scrub/read_verify.c  |    2 
 scrub/scrub.c        |   28 ++++++
 scrub/xfs_scrub.c    |   59 +++++++++++++
 scrub/xfs_scrub.h    |   14 +++
 14 files changed, 462 insertions(+), 10 deletions(-)
 create mode 100644 scrub/progress.c
 create mode 100644 scrub/progress.h


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 95f4fea..dee9076 100644
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
index dace31e..7d52e7d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,6 +23,7 @@ disk.h \
 filemap.h \
 fscounters.h \
 inodes.h \
+progress.h \
 read_verify.h \
 scrub.h \
 spacemap.h \
@@ -45,6 +46,7 @@ phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
+progress.c \
 read_verify.c \
 scrub.c \
 spacemap.c \
diff --git a/scrub/common.c b/scrub/common.c
index 2be17b9..54381a5 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -27,6 +27,7 @@
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "progress.h"
 
 /*
  * Reporting Status to the Console
@@ -55,6 +56,18 @@ xfs_scrub_excessive_errors(
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
@@ -66,7 +79,7 @@ __str_errno(
 	char			buf[DESCR_BUFSZ];
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Error: %s: %s."), descr,
+	fprintf(stderr, _("%sError: %s: %s."), stderr_start(), descr,
 			strerror_r(errno, buf, DESCR_BUFSZ));
 	if (debug)
 		fprintf(stderr, _(" (%s line %d)"), file, line);
@@ -86,7 +99,7 @@ __str_errno_warn(
 	char			buf[DESCR_BUFSZ];
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Warning: %s: %s."), descr,
+	fprintf(stderr, _("%sWarning: %s: %s."), stderr_start(), descr,
 			strerror_r(errno, buf, DESCR_BUFSZ));
 	if (debug)
 		fprintf(stderr, _(" (%s line %d)"), file, line);
@@ -108,7 +121,7 @@ __str_error(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Error: %s: "), descr);
+	fprintf(stderr, _("%sError: %s: "), stderr_start(), descr);
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
@@ -132,7 +145,7 @@ __str_warn(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stderr, _("Warning: %s: "), descr);
+	fprintf(stderr, _("%sWarning: %s: "), stderr_start(), descr);
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
@@ -156,7 +169,7 @@ __str_info(
 	va_list			args;
 
 	pthread_mutex_lock(&ctx->lock);
-	fprintf(stdout, _("Info: %s: "), descr);
+	fprintf(stdout, _("%sInfo: %s: "), stdout_start(), descr);
 	va_start(args, format);
 	vfprintf(stdout, format, args);
 	va_end(args);
diff --git a/scrub/phase2.c b/scrub/phase2.c
index b1f2c6e..ac4f75b 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -118,3 +118,17 @@ _("Could not queue filesystem scrub work."));
 	workqueue_destroy(&wq);
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
index 8c3748e..68a34ed 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -30,6 +30,7 @@
 #include "common.h"
 #include "counter.h"
 #include "inodes.h"
+#include "progress.h"
 #include "scrub.h"
 
 /* Phase 3: Scan all inodes. */
@@ -121,6 +122,7 @@ xfs_scrub_inode(
 
 out:
 	ptcounter_add(icount, 1);
+	progress_add(1);
 	if (fd >= 0)
 		close(fd);
 	if (error)
@@ -152,3 +154,17 @@ xfs_scan_inodes(
 	ptcounter_free(icount);
 	return moveon;
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
index c7874a6..92ac276 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -31,6 +31,7 @@
 #include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "progress.h"
 #include "scrub.h"
 #include "vfs.h"
 
@@ -44,9 +45,25 @@ xfs_repair_fs(
 	bool				moveon = true;
 
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
+	*items = 1;
+	*nr_threads = 1;
+	*rshift = 0;
+	return true;
+}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index ed89266..efa27cb 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -34,6 +34,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
+#include "progress.h"
 #include "scrub.h"
 #include "unicrash.h"
 
@@ -287,6 +288,7 @@ xfs_scrub_connections(
         }
 
 out:
+	progress_add(1);
 	if (fd >= 0)
 		close(fd);
 	if (error)
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e6d9c69..37f2ebe 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -33,6 +33,7 @@
 #include "bitmap.h"
 #include "disk.h"
 #include "filemap.h"
+#include "fscounters.h"
 #include "inodes.h"
 #include "read_verify.h"
 #include "spacemap.h"
@@ -514,3 +515,30 @@ _("Could not create media verifier."));
 	ptvar_free(ve.rvstate);
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
+	*nr_threads = disk_heads(ctx->datadev);
+	*rshift = 20;
+	return moveon;
+}
diff --git a/scrub/progress.c b/scrub/progress.c
new file mode 100644
index 0000000..26920e0
--- /dev/null
+++ b/scrub/progress.c
@@ -0,0 +1,221 @@
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
+#include <pthread.h>
+#include <sys/statvfs.h>
+#include "../repair/threads.h"
+#include "path.h"
+#include "disk.h"
+#include "read_verify.h"
+#include "xfs_scrub.h"
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
+	bool			terminate;
+	pthread_t		thread;
+
+	/* static state */
+	pthread_mutex_t		lock;
+	pthread_cond_t		wakeup;
+};
+
+static struct progress_tracker pt = {
+	.lock			= PTHREAD_MUTEX_INITIALIZER,
+	.wakeup			= PTHREAD_COND_INITIALIZER,
+};
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
+#define NSEC_PER_SEC	(1000000000)
+static void *
+progress_report_thread(void *arg)
+{
+	struct timespec		abstime;
+	int			ret;
+
+	pthread_mutex_lock(&pt.lock);
+	while (1) {
+		/* Every half second. */
+		ret = clock_gettime(CLOCK_REALTIME, &abstime);
+		if (ret)
+			break;
+		abstime.tv_nsec += NSEC_PER_SEC / 2;
+		if (abstime.tv_nsec > NSEC_PER_SEC) {
+			abstime.tv_sec++;
+			abstime.tv_nsec -= NSEC_PER_SEC;
+		}
+		pthread_cond_timedwait(&pt.wakeup, &pt.lock, &abstime);
+		if (pt.terminate)
+			break;
+		progress_report(ptcounter_value(pt.ptc));
+	}
+	pthread_mutex_unlock(&pt.lock);
+	return NULL;
+}
+
+/* End a phase of progress reporting. */
+void
+progress_end_phase(void)
+{
+	if (!pt.fp)
+		return;
+
+	pthread_mutex_lock(&pt.lock);
+	pt.terminate = true;
+	pthread_mutex_unlock(&pt.lock);
+	pthread_cond_broadcast(&pt.wakeup);
+	pthread_join(pt.thread, NULL);
+
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
+	pt.terminate = false;
+
+	pt.ptc = ptcounter_init(nr_threads);
+	if (!pt.ptc)
+		goto out_max;
+
+	ret = pthread_create(&pt.thread, NULL, progress_report_thread, NULL);
+	if (ret)
+		goto out_ptcounter;
+
+	return true;
+
+out_ptcounter:
+	ptcounter_free(pt.ptc);
+	pt.ptc = NULL;
+out_max:
+	pt.max = 0;
+	pt.fp = NULL;
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
index b3e79a4..8fdf69b 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -31,6 +31,7 @@
 #include "counter.h"
 #include "disk.h"
 #include "read_verify.h"
+#include "progress.h"
 
 /*
  * Read Verify Pool
@@ -154,6 +155,7 @@ read_verify(
 					errno, rv->io_end_arg);
 		}
 
+		progress_add(len);
 		verified += len;
 		rv->io_start += len;
 		rv->io_length -= len;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2ff588c..efb1b86 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -31,6 +31,7 @@
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "progress.h"
 #include "scrub.h"
 #include "xfs_errortag.h"
 
@@ -342,6 +343,7 @@ xfs_scrub_metadata(
 
 		/* Check the item. */
 		fix = xfs_check_metadata(ctx, ctx->mnt_fd, &meta, false);
+		progress_add(1);
 		switch (fix) {
 		case CHECK_ABORT:
 			return false;
@@ -384,6 +386,32 @@ xfs_scrub_fs_metadata(
 	return xfs_scrub_metadata(ctx, ST_FS, 0);
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
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 81ec7e5..3e8021e 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -32,6 +32,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "unicrash.h"
+#include "progress.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -139,12 +140,17 @@ bool				scrub_data;
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
@@ -219,6 +225,8 @@ struct phase_rusage {
 struct phase_ops {
 	char		*descr;
 	bool		(*fn)(struct scrub_ctx *);
+	bool		(*estimate_work)(struct scrub_ctx *, uint64_t *,
+					 unsigned int *, int *);
 	bool		must_run;
 };
 
@@ -357,7 +365,8 @@ _("Errors found, please re-run with -y."));
 /* Run all the phases of the scrubber. */
 static bool
 run_scrub_phases(
-	struct scrub_ctx	*ctx)
+	struct scrub_ctx	*ctx,
+	FILE			*progress_fp)
 {
 	struct phase_ops phases[] =
 	{
@@ -369,22 +378,27 @@ run_scrub_phases(
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
@@ -397,9 +411,12 @@ run_scrub_phases(
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
@@ -433,6 +450,18 @@ run_scrub_phases(
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
@@ -440,6 +469,7 @@ _("Scrub aborted after phase %d."),
 					phase);
 			break;
 		}
+		progress_end_phase();
 		moveon = phase_end(&pi, phase);
 		if (!moveon)
 			break;
@@ -461,6 +491,7 @@ main(
 	int			c;
 	char			*mtab = NULL;
 	char			*repairstr = "";
+	FILE			*progress_fp = NULL;
 	struct scrub_ctx	ctx = {0};
 	struct phase_rusage	all_pi;
 	unsigned long long	total_errors;
@@ -477,7 +508,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_DEFAULT;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:m:nTvxVy")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -490,6 +521,19 @@ main(
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
@@ -560,6 +604,13 @@ _("Only one of the options -n or -y may be specified.\n"));
 	unicrash_setup();
 	ctx.mntpoint = strdup(argv[optind]);
 
+	stdout_isatty = isatty(STDOUT_FILENO);
+	stderr_isatty = isatty(STDERR_FILENO);
+
+	/* If interactive, start the progress bar. */
+	if (stdout_isatty && !progress_fp)
+		progress_fp = fdopen(1, "w+");
+
 	/* Find the mount record for the passed-in argument. */
 	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
@@ -614,7 +665,7 @@ _("Only one of the options -n or -y may be specified.\n"));
 	}
 
 	/* Scrub a filesystem. */
-	moveon = run_scrub_phases(&ctx);
+	moveon = run_scrub_phases(&ctx, progress_fp);
 	if (!moveon)
 		ret |= 4;
 
@@ -656,6 +707,8 @@ _("%s: %llu warnings found.\n"),
 	if (ctx.runtime_errors)
 		ret |= 4;
 	phase_end(&all_pi, 0);
+	if (progress_fp)
+		fclose(progress_fp);
 	free(ctx.blkdev);
 	free(ctx.mntpoint);
 
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 9a09dcd..da58815 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -31,6 +31,8 @@ extern bool			dumpcore;
 extern bool			verbose;
 extern bool			scrub_data;
 extern long			page_size;
+extern bool			stderr_isatty;
+extern bool			stdout_isatty;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
@@ -110,4 +112,16 @@ bool xfs_scan_blocks(struct scrub_ctx *ctx);
 bool xfs_scan_summary(struct scrub_ctx *ctx);
 bool xfs_repair_fs(struct scrub_ctx *ctx);
 
+/* Progress estimator functions */
+uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
+unsigned int xfs_scrub_estimate_ag_work(struct scrub_ctx *ctx);
+bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
+				unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_repair_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+bool xfs_estimate_verify_work(struct scrub_ctx *ctx, uint64_t *items,
+			      unsigned int *nr_threads, int *rshift);
+
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

