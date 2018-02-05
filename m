Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbeBEXWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:22:25 -0500
Subject: [PATCH 1/7] xfs_scrub: log operational messages when interactive
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:22:20 -0800
Message-ID: <151787294062.3743.16150442240772340999.stgit@magnolia>
In-Reply-To: <151787293446.3743.11110014829952400444.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Record the output of an interactive session in the system log so that
future support requests can get a better picture of what happened.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 17c3699..672f286 100644
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
@@ -73,6 +82,8 @@ static inline const char *stream_start(FILE *stream)
 }
 
 /* Print a warning string and some warning text. */
+#define LOG_BUFSZ	4096
+#define LOGNAME_BUFSZ	256
 void
 __str_out(
 	struct scrub_ctx	*ctx,
@@ -110,6 +121,32 @@ __str_out(
 		va_end(args);
 	}
 
+	/* If we're running interactively, log the message to syslog too. */
+	if (isatty(fileno(stdin)) && !debug) {
+		char	logname[LOGNAME_BUFSZ];
+
+		snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname,
+				ctx->mntpoint);
+		openlog(logname, LOG_PID, LOG_DAEMON);
+
+		if (error) {
+			syslog(LOG_ERR, "%s: %s: %s.",
+					_(err_str[level]), descr,
+					strerror_r(error, buf, DESCR_BUFSZ));
+		} else {
+			char	buf[LOG_BUFSZ];
+			int	sz;
+
+			sz = snprintf(buf, LOG_BUFSZ, "%s: %s: ",
+					_(err_str[level]), descr);
+			va_start(args, format);
+			vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
+			va_end(args);
+			syslog(log_level[level], "%s", buf);
+		}
+		closelog();
+	}
+
 	if (debug)
 		fprintf(stream, _(" (%s line %d)"), file, line);
 	fprintf(stream, "\n");

