Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755712AbeCHTfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 14:35:48 -0500
Date: Thu, 8 Mar 2018 11:35:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 03/16] xfs_scrub: log operational messages when interactive
Message-ID: <20180308193541.GB18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993159412.22223.9791048469399407816.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151993159412.22223.9791048469399407816.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Record the summary of an interactive session in the system log so that
future support requests can get a better picture of what happened.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: only log beginning and results
---
 scrub/common.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/common.h    |   10 ++++++++++
 scrub/phase1.c    |    1 +
 scrub/xfs_scrub.c |   18 +++++++++++++-----
 scrub/xfs_scrub.h |    1 +
 5 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/scrub/common.c b/scrub/common.c
index 17c3699..4f26bf8 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -21,6 +21,7 @@
 #include <pthread.h>
 #include <stdbool.h>
 #include <sys/statvfs.h>
+#include <syslog.h>
 #include "platform_defs.h"
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -29,6 +30,8 @@
 #include "common.h"
 #include "progress.h"
 
+extern char		*progname;
+
 /*
  * Reporting Status to the Console
  *
@@ -64,6 +67,12 @@ static const char *err_str[] = {
 	[S_PREEN]	= "Optimized",
 };
 
+static int log_level[] = {
+	[S_ERROR]	= LOG_ERR,
+	[S_WARN]	= LOG_WARNING,
+	[S_INFO]	= LOG_INFO,
+};
+
 /* If stream is a tty, clear to end of line to clean up progress bar. */
 static inline const char *stream_start(FILE *stream)
 {
@@ -131,6 +140,46 @@ __str_out(
 	pthread_mutex_unlock(&ctx->lock);
 }
 
+/* Log a message to syslog. */
+#define LOG_BUFSZ	4096
+#define LOGNAME_BUFSZ	256
+void
+__str_log(
+	struct scrub_ctx	*ctx,
+	enum error_level	level,
+	const char		*format,
+	...)
+{
+	va_list			args;
+	char			logname[LOGNAME_BUFSZ];
+	char			buf[LOG_BUFSZ];
+	int			sz;
+
+	/* We only want to hear about optimizing when in debug/verbose mode. */
+	if (level == S_PREEN && !debug && !verbose)
+		return;
+
+	/*
+	 * Skip logging if we're being run as a service (presumably the
+	 * service will log stdout/stderr); if we're being run in a non
+	 * interactive manner (assume we're a service); or if we're in
+	 * debug mode.
+	 */
+	if (is_service || !isatty(fileno(stdin)) || debug)
+		return;
+
+	snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname, ctx->mntpoint);
+	openlog(logname, LOG_PID, LOG_DAEMON);
+
+	sz = snprintf(buf, LOG_BUFSZ, "%s: ", _(err_str[level]));
+	va_start(args, format);
+	vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
+	va_end(args);
+	syslog(log_level[level], "%s", buf);
+
+	closelog();
+}
+
 double
 timeval_subtract(
 	struct timeval		*tv1,
diff --git a/scrub/common.h b/scrub/common.h
index 287bd4d..4f1f0cd 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -56,6 +56,16 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 #define dbg_printf(fmt, ...) \
 	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
 
+void __str_log(struct scrub_ctx *ctx, enum error_level level,
+		const char *format, ...);
+
+#define log_info(ctx, ...) \
+	__str_log(ctx, S_INFO,	__VA_ARGS__)
+#define log_warn(ctx, ...) \
+	__str_log(ctx, S_WARN,	__VA_ARGS__)
+#define log_err(ctx, ...) \
+	__str_log(ctx, S_ERROR,	__VA_ARGS__)
+
 /* Is this debug tweak enabled? */
 static inline bool
 debug_tweak_on(
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6cd5442..b856a7f 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -236,6 +236,7 @@ _("Unable to find realtime device path."));
 	 * this point are most probably corruption errors (as opposed to
 	 * purely setup errors).
 	 */
+	log_info(ctx, _("Invoking online scrub."), ctx);
 	ctx->need_repair = true;
 	return true;
 }
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index ab26e63..7ab0c3e 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -162,7 +162,7 @@ bool				stdout_isatty;
  * If we are running as a service, we need to be careful about what
  * error codes we return to the calling process.
  */
-static bool			is_service;
+bool				is_service;
 
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
@@ -501,19 +501,27 @@ report_outcome(
 
 	total_errors = ctx->errors_found + ctx->runtime_errors;
 
-	if (total_errors == 0 && ctx->warnings_found == 0)
+	if (total_errors == 0 && ctx->warnings_found == 0) {
+		log_info(ctx, _("No errors found."));
 		return;
+	}
 
-	if (total_errors == 0)
+	if (total_errors == 0) {
 		fprintf(stderr, _("%s: warnings found: %llu\n"), ctx->mntpoint,
 				ctx->warnings_found);
-	else if (ctx->warnings_found == 0)
+		log_warn(ctx, _("warnings found: %llu"), ctx->warnings_found);
+	} else if (ctx->warnings_found == 0) {
 		fprintf(stderr, _("%s: errors found: %llu\n"), ctx->mntpoint,
 				total_errors);
-	else
+		log_err(ctx, _("errors found: %llu"), total_errors);
+	} else {
 		fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu\n"),
 				ctx->mntpoint, total_errors,
 				ctx->warnings_found);
+		log_err(ctx, _("errors found: %llu; warnings found: %llu"),
+				total_errors, ctx->warnings_found);
+	}
+
 	if (ctx->need_repair)
 		fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
 				ctx->mntpoint);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 89b46a4..b455747 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -31,6 +31,7 @@ extern long			page_size;
 extern bool			want_fstrim;
 extern bool			stderr_isatty;
 extern bool			stdout_isatty;
+extern bool			is_service;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
