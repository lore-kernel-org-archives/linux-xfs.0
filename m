Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeAaDGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:06:47 -0500
Subject: [PATCH 02/29] xfs_scrub: common error handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:06:43 -0800
Message-ID: <151736800357.32164.4895881100208773213.stgit@magnolia>
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

Standardize how we record and report errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/common.h    |   30 ++++++++++++++++++
 scrub/xfs_scrub.c |    5 +++
 scrub/xfs_scrub.h |   11 +++++++
 4 files changed, 133 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 0a58c16..8137881 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -17,4 +17,91 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
+#include <stdio.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_scrub.h"
 #include "common.h"
+
+/*
+ * Reporting Status to the Console
+ *
+ * We aim for a roughly standard reporting format -- the severity of the
+ * status being reported, a textual description of the object being
+ * reported, and whatever the status happens to be.
+ *
+ * Errors are the most severe and reflect filesystem corruption.
+ * Warnings indicate that something is amiss and needs the attention of
+ * the administrator, but does not constitute a corruption.  Information
+ * is merely advisory.
+ */
+
+/* Too many errors? Bail out. */
+bool
+xfs_scrub_excessive_errors(
+	struct scrub_ctx	*ctx)
+{
+	bool			ret;
+
+	pthread_mutex_lock(&ctx->lock);
+	ret = ctx->max_errors > 0 && ctx->errors_found >= ctx->max_errors;
+	pthread_mutex_unlock(&ctx->lock);
+
+	return ret;
+}
+
+static const char *err_str[] = {
+	[S_ERROR]	= "Error",
+	[S_WARN]	= "Warning",
+	[S_INFO]	= "Info",
+};
+
+/* Print a warning string and some warning text. */
+void
+__str_out(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	enum error_level	level,
+	int			error,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	FILE			*stream = stderr;
+	va_list			args;
+	char			buf[DESCR_BUFSZ];
+
+	/* print strerror or format of choice but not both */
+	assert(!(error && format));
+
+	if (level >= S_INFO)
+		stream = stdout;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stream, "%s: %s: ", _(err_str[level]), descr);
+	if (error) {
+		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
+	} else {
+		va_start(args, format);
+		vfprintf(stream, format, args);
+		va_end(args);
+	}
+
+	if (debug)
+		fprintf(stream, _(" (%s line %d)"), file, line);
+	fprintf(stream, "\n");
+	if (stream == stdout)
+		fflush(stream);
+
+	if (error)      /* A syscall failed */
+		ctx->runtime_errors++;
+	else if (level == S_ERROR)
+		ctx->errors_found++;
+	else if (level == S_WARN)
+		ctx->warnings_found++;
+
+	pthread_mutex_unlock(&ctx->lock);
+}
diff --git a/scrub/common.h b/scrub/common.h
index 1082296..b383767 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -20,4 +20,34 @@
 #ifndef XFS_SCRUB_COMMON_H_
 #define XFS_SCRUB_COMMON_H_
 
+/*
+ * When reporting a defective metadata object to the console, this
+ * is the size of the buffer to use to store the description of that
+ * item.
+ */
+#define DESCR_BUFSZ	256
+
+bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
+
+enum error_level {
+	S_ERROR	= 0,
+	S_WARN,
+	S_INFO,
+};
+
+void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
+	       int error, const char *file, int line, const char *format, ...);
+
+#define str_errno(ctx, str) \
+	__str_out(ctx, str, S_ERROR,	errno,	__FILE__, __LINE__, NULL)
+#define str_error(ctx, str, ...) \
+	__str_out(ctx, str, S_ERROR,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define str_warn(ctx, str, ...) \
+	__str_out(ctx, str, S_WARN,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define str_info(ctx, str, ...) \
+	__str_out(ctx, str, S_INFO,	0,	__FILE__, __LINE__, __VA_ARGS__)
+
+#define dbg_printf(fmt, ...) \
+	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index a4b9c71..6ed7bf6 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -18,6 +18,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 #include <stdio.h>
+#include <pthread.h>
+#include <stdbool.h>
 #include "xfs_scrub.h"
 
 /*
@@ -99,6 +101,9 @@
 /* Program name; needed for libfrog error reports. */
 char				*progname = "xfs_scrub";
 
+/* Debug level; higher values mean more verbosity. */
+unsigned int			debug;
+
 int
 main(
 	int			argc,
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index ff9c24d..811bc2d 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -20,4 +20,15 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+extern unsigned int		debug;
+
+struct scrub_ctx {
+	/* Mutable scrub state; use lock. */
+	pthread_mutex_t		lock;
+	unsigned long long	max_errors;
+	unsigned long long	runtime_errors;
+	unsigned long long	errors_found;
+	unsigned long long	warnings_found;
+};
+
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

