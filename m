Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46654 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965042AbdKQVAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:38 -0500
Subject: [PATCH 03/27] xfs_scrub: set up command line argument parsing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:27 -0800
Message-ID: <151095242759.4825.2544745452802547307.stgit@magnolia>
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

Parse command line options in order to set up the context in which we
will scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.h    |    8 ++
 scrub/xfs_scrub.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h |   34 +++++++++
 3 files changed, 249 insertions(+)


diff --git a/scrub/common.h b/scrub/common.h
index b7c5f47..b601680 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -48,4 +48,12 @@ void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
 #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
 
+/* Is this debug tweak enabled? */
+static inline bool
+debug_tweak_on(
+	const char		*name)
+{
+	return debug && getenv(name) != NULL;
+}
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index d32f26c..efaccad 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -20,7 +20,12 @@
 #include <stdio.h>
 #include <pthread.h>
 #include <stdbool.h>
+#include <stdlib.h>
+#include "platform_defs.h"
+#include "xfs.h"
+#include "input.h"
 #include "xfs_scrub.h"
+#include "common.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -107,11 +112,213 @@ unsigned int			debug;
 /* Should we dump core if errors happen? */
 bool				dumpcore;
 
+/* Display resource usage at the end of each phase? */
+bool				display_rusage;
+
+/* Background mode; higher values insert more pauses between scrub calls. */
+unsigned int			bg_mode;
+
+/* Maximum number of processors available to us. */
+int				nproc;
+
+/* Number of threads we're allowed to use. */
+unsigned int			nr_threads;
+
+/* Verbosity; higher values print more information. */
+bool				verbose;
+
+/* Should we scrub the data blocks? */
+bool				scrub_data;
+
+/* Size of a memory page. */
+long				page_size;
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
+	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
+	fprintf(stderr, _("-b:\tBackground mode.\n"));
+	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
+	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
+	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
+	fprintf(stderr, _("-v:\tVerbose output.\n"));
+	fprintf(stderr, _("-V:\tPrint version.\n"));
+	fprintf(stderr, _("-x:\tScrub file data too.\n"));
+	fprintf(stderr, _("-y:\tRepair all errors.\n"));
+
+	exit(16);
+}
+
 int
 main(
 	int			argc,
 	char			**argv)
 {
+	int			c;
+	char			*mtab = NULL;
+	char			*repairstr = "";
+	struct scrub_ctx	ctx = {0};
+	unsigned long long	total_errors;
+	bool			moveon = true;
+	static bool		injected;
+	int			ret = 0;
+
 	fprintf(stderr, "XXX: This program is not complete!\n");
 	return 4;
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	pthread_mutex_init(&ctx.lock, NULL);
+	ctx.mode = SCRUB_MODE_DEFAULT;
+	ctx.error_action = ERRORS_CONTINUE;
+	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
+		switch (c) {
+		case 'a':
+			ctx.max_errors = cvt_u64(optarg, 10);
+			if (errno) {
+				perror(optarg);
+				usage();
+			}
+			break;
+		case 'b':
+			nr_threads = 1;
+			bg_mode++;
+			break;
+		case 'd':
+			debug++;
+			dumpcore = true;
+			break;
+		case 'e':
+			if (!strcmp("continue", optarg))
+				ctx.error_action = ERRORS_CONTINUE;
+			else if (!strcmp("shutdown", optarg))
+				ctx.error_action = ERRORS_SHUTDOWN;
+			else
+				usage();
+			break;
+		case 'm':
+			mtab = optarg;
+			break;
+		case 'n':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				return 1;
+			}
+			ctx.mode = SCRUB_MODE_DRY_RUN;
+			break;
+		case 'T':
+			display_rusage = true;
+			break;
+		case 'v':
+			verbose = true;
+			break;
+		case 'V':
+			fprintf(stdout, _("%s version %s\n"), progname,
+					VERSION);
+			fflush(stdout);
+			exit(0);
+		case 'x':
+			scrub_data = true;
+			break;
+		case 'y':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				return 1;
+			}
+			ctx.mode = SCRUB_MODE_REPAIR;
+			break;
+		case '?':
+			/* fall through */
+		default:
+			usage();
+		}
+	}
+
+	/* Override thread count if debugger */
+	if (debug_tweak_on("XFS_SCRUB_THREADS")) {
+		unsigned int	x;
+
+		x = cvt_u32(getenv("XFS_SCRUB_THREADS"), 10);
+		if (errno) {
+			perror("nr_threads");
+			usage();
+		}
+		nr_threads = x;
+	}
+
+	if (optind != argc - 1)
+		usage();
+
+	ctx.mntpoint = strdup(argv[optind]);
+
+	/*
+	 * If the user did not specify an explicit mount table, try to use
+	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
+	 * /proc/mounts because it is kernel controlled, while /etc/mtab
+	 * may contain garbage that userspace tools like pam_mounts wrote
+	 * into it.
+	 */
+	if (!mtab) {
+		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
+			mtab = _PATH_PROC_MOUNTS;
+		else
+			mtab = _PATH_MOUNTED;
+	}
+
+	/* How many CPUs? */
+	nproc = sysconf(_SC_NPROCESSORS_ONLN);
+	if (nproc < 0)
+		nproc = 1;
+
+	/* Set up a page-aligned buffer for read verification. */
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		ctx.mode = SCRUB_MODE_REPAIR;
+		injected = true;
+	}
+
+	if (xfs_scrub_excessive_errors(&ctx))
+		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
+
+	if (debug_tweak_on("XFS_SCRUB_FORCE_ERROR"))
+		str_error(&ctx, ctx.mntpoint, _("Injecting error."));
+
+out:
+	total_errors = ctx.errors_found + ctx.runtime_errors;
+	if (ctx.need_repair)
+		repairstr = _("  Unmount and run xfs_repair.");
+	if (total_errors && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %llu errors and %llu warnings found.%s\n"),
+			ctx.mntpoint, total_errors, ctx.warnings_found,
+			repairstr);
+	else if (total_errors && ctx.warnings_found == 0)
+		fprintf(stderr,
+_("%s: %llu errors found.%s\n"),
+			ctx.mntpoint, total_errors, repairstr);
+	else if (total_errors == 0 && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %llu warnings found.\n"),
+			ctx.mntpoint, ctx.warnings_found);
+	if (ctx.errors_found)
+		ret |= 1;
+	if (ctx.warnings_found)
+		ret |= 2;
+	if (ctx.runtime_errors)
+		ret |= 4;
+	free(ctx.mntpoint);
+
+	return ret;
 }
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 6c03167..3bc2b63 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -20,16 +20,50 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
+extern unsigned int		nr_threads;
+extern unsigned int		bg_mode;
 extern unsigned int		debug;
+extern int			nproc;
+extern bool			display_rusage;
 extern bool			dumpcore;
+extern bool			verbose;
+extern bool			scrub_data;
+extern long			page_size;
+
+enum scrub_mode {
+	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
+	SCRUB_MODE_REPAIR,
+};
+#define SCRUB_MODE_DEFAULT			SCRUB_MODE_PREEN
+
+enum error_action {
+	ERRORS_CONTINUE,
+	ERRORS_SHUTDOWN,
+};
 
 struct scrub_ctx {
+	/* Immutable scrub state. */
+
+	/* Strings we need for presentation */
+	char			*mntpoint;
+	char			*blkdev;
+
+	/* What does the user want us to do? */
+	enum scrub_mode		mode;
+
+	/* How does the user want us to react to errors? */
+	enum error_action	error_action;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
+	bool			need_repair;
 };
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

