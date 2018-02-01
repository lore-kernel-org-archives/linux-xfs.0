Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752960AbeBASRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 13:17:36 -0500
Date: Thu, 1 Feb 2018 10:17:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_scrub: log operational messages when interactive
Message-ID: <20180201181731.GQ4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Record the output of an interactive session in the system log so that
future support requests can get a better picture of what happened.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/scrub/common.c b/scrub/common.c
index 18171d1..7af7677 100644
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
@@ -62,6 +65,12 @@ static const char *err_str[] = {
 	[S_INFO]	= "Info",
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
@@ -71,6 +80,8 @@ static inline const char *stream_start(FILE *stream)
 }
 
 /* Print a warning string and some warning text. */
+#define LOG_BUFSZ	4096
+#define LOGNAME_BUFSZ	256
 void
 __str_out(
 	struct scrub_ctx	*ctx,
@@ -103,6 +114,32 @@ __str_out(
 		va_end(args);
 	}
 
+	/* If we're running interactively, log the message to syslog too. */
+	if (isatty(fileno(stdin))) {
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
