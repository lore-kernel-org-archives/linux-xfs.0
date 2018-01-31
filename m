Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57310 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbeAaDGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:06:55 -0500
Subject: [PATCH 03/29] xfs_scrub: set up command line argument parsing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:06:49 -0800
Message-ID: <151736800970.32164.11444797715744265945.stgit@magnolia>
In-Reply-To: <151736799098.32164.15446216987522359103.stgit@magnolia>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
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
 scrub/xfs_scrub.c |  227 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h |   32 +++++++
 3 files changed, 266 insertions(+), 1 deletion(-)


diff --git a/scrub/common.h b/scrub/common.h
index b383767..7a7e362 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -50,4 +50,12 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 #define dbg_printf(fmt, ...) \
 	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
 
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
index 6ed7bf6..8af640c 100644
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
@@ -98,17 +103,237 @@
  * thorough the scrub was.
  */
 
+/*
+ * Known debug tweaks (pass -d and set the environment variable):
+ * XFS_SCRUB_FORCE_ERROR	-- pretend all metadata is corrupt
+ * XFS_SCRUB_FORCE_REPAIR	-- repair all metadata even if it's ok
+ * XFS_SCRUB_NO_KERNEL		-- pretend there is no kernel ioctl
+ * XFS_SCRUB_NO_SCSI_VERIFY	-- disable SCSI VERIFY (if present)
+ * XFS_SCRUB_PHASE		-- run only this scrub phase
+ * XFS_SCRUB_THREADS		-- start exactly this number of threads
+ */
+
 /* Program name; needed for libfrog error reports. */
 char				*progname = "xfs_scrub";
 
 /* Debug level; higher values mean more verbosity. */
 unsigned int			debug;
 
+/* Display resource usage at the end of each phase? */
+static bool			display_rusage;
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
+static bool			scrub_data;
+
+/* Size of a memory page. */
+long				page_size;
+
+#define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
+#define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
+#define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
+#define SCRUB_RET_OPERROR	(4)	/* operational problems */
+#define SCRUB_RET_SYNTAX	(8)	/* cmdline args rejected */
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint | device\n"), progname);
+	fprintf(stderr, "\n");
+	fprintf(stderr, _("Options:\n"));
+	fprintf(stderr, _("  -a count     Stop after this many errors are found.\n"));
+	fprintf(stderr, _("  -b           Background mode.\n"));
+	fprintf(stderr, _("  -e behavior  What to do if errors are found.\n"));
+	fprintf(stderr, _("  -m path      Path to /etc/mtab.\n"));
+	fprintf(stderr, _("  -n           Dry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("  -T           Display timing/usage information.\n"));
+	fprintf(stderr, _("  -v           Verbose output.\n"));
+	fprintf(stderr, _("  -V           Print version.\n"));
+	fprintf(stderr, _("  -x           Scrub file data too.\n"));
+	fprintf(stderr, _("  -y           Repair all errors.\n"));
+
+	exit(SCRUB_RET_SYNTAX);
+}
+
 int
 main(
 	int			argc,
 	char			**argv)
 {
+	struct scrub_ctx	ctx = {0};
+	char			*mtab = NULL;
+	char			*repairstr = "";
+	unsigned long long	total_errors;
+	bool			moveon = true;
+	int			c;
+	int			ret = SCRUB_RET_SUCCESS;
+
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
-	return 4;
+	return SCRUB_RET_OPERROR;
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
+			break;
+		case 'e':
+			if (!strcmp("continue", optarg))
+				ctx.error_action = ERRORS_CONTINUE;
+			else if (!strcmp("shutdown", optarg))
+				ctx.error_action = ERRORS_SHUTDOWN;
+			else {
+				fprintf(stderr,
+	_("Unknown error behavior \"%s\".\n"),
+						optarg);
+				usage();
+			}
+			break;
+		case 'm':
+			mtab = optarg;
+			break;
+		case 'n':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				usage();
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
+			return SCRUB_RET_SUCCESS;
+		case 'x':
+			scrub_data = true;
+			break;
+		case 'y':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				usage();
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
+	if (nproc < 1)
+		nproc = 1;
+
+	/* Set up a page-aligned buffer for read verification. */
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+		ctx.mode = SCRUB_MODE_REPAIR;
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
+		ret |= SCRUB_RET_CORRUPT;
+	if (ctx.warnings_found)
+		ret |= SCRUB_RET_UNOPTIMIZED;
+	if (ctx.runtime_errors)
+		ret |= SCRUB_RET_OPERROR;
+	free(ctx.mntpoint);
+
+	return ret;
 }
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 811bc2d..51b8b7a 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -20,15 +20,47 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
+extern unsigned int		nr_threads;
+extern unsigned int		bg_mode;
 extern unsigned int		debug;
+extern int			nproc;
+extern bool			verbose;
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

