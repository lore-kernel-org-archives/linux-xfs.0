Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33531 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:00 -0400
Subject: [PATCH 03/22] xfs_scrub: set up command line argument parsing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:07:55 -0700
Message-ID: <150180527516.18784.14401549617845990192.stgit@magnolia>
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

Parse command line options in order to set up the context in which we
will scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.h |    8 ++
 scrub/scrub.c  |  206 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h  |   31 ++++++++
 3 files changed, 245 insertions(+)


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
diff --git a/scrub/scrub.c b/scrub/scrub.c
index bac1e8c..2b620bf 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -33,6 +33,9 @@
 #include "path.h"
 #include "scrub.h"
 #include "common.h"
+#include "input.h"
+
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -119,11 +122,214 @@ unsigned int			debug;
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
+	struct scrub_ctx	ctx = {0};
+	unsigned long long	total_errors;
+	bool			moveon = true;
+	static bool		injected;
+	int			ret;
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
+	ctx.mntpoint = argv[optind];
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
+out:
+	if (xfs_scrub_excessive_errors(&ctx))
+		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
+
+	if (debug_tweak_on("XFS_SCRUB_FORCE_ERROR"))
+		str_error(&ctx, ctx.mntpoint, _("Injecting error."));
+
+	ret = 0;
+	if (!moveon)
+		ret |= 4;
+
+	total_errors = ctx.errors_found + ctx.runtime_errors;
+	if (total_errors && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %llu errors and %llu warnings found.  Unmount and run xfs_repair.\n"),
+			ctx.mntpoint, total_errors, ctx.warnings_found);
+	else if (total_errors && ctx.warnings_found == 0)
+		fprintf(stderr,
+_("%s: %llu errors found.  Unmount and run xfs_repair.\n"),
+			ctx.mntpoint, total_errors);
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
+
+	free(ctx.blkdev);
+	free(ctx.mntpoint);
+	return ret;
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 49de30b..669c9dc 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -20,10 +20,41 @@
 #ifndef XFS_SCRUB_SCRUB_H_
 #define XFS_SCRUB_SCRUB_H_
 
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

