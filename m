Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41941 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965042AbdKQVA2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:28 -0500
Subject: [PATCH 02/27] xfs_scrub: common error handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:21 -0800
Message-ID: <151095242168.4825.1743669714008564606.stgit@magnolia>
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

Standardize how we record and report errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |  141 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/common.h    |   28 +++++++++++
 scrub/xfs_scrub.c |    8 +++
 scrub/xfs_scrub.h |   12 +++++
 4 files changed, 189 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 57ad182..d739169 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -17,4 +17,145 @@
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
+ * status being reported, a textual description of the objecting being
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
+/* Print an error string and whatever error is stored in errno. */
+void
+__str_errno(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*file,
+	int			line)
+{
+	char			buf[DESCR_BUFSZ];
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, _("Error: %s: %s."), descr,
+			strerror_r(errno, buf, DESCR_BUFSZ));
+	if (debug)
+		fprintf(stderr, _(" (%s line %d)"), file, line);
+	fprintf(stderr, "\n");
+	ctx->runtime_errors++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print an error string and some error text. */
+void
+__str_error(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, _("Error: %s: "), descr);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, _(" (%s line %d)"), file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print a warning string and some warning text. */
+void
+__str_warn(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, _("Warning: %s: "), descr);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, _(" (%s line %d)"), file, line);
+	fprintf(stderr, "\n");
+	ctx->warnings_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print an informational string and some informational text. */
+void
+__str_info(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stdout, _("Info: %s: "), descr);
+	va_start(args, format);
+	vfprintf(stdout, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stdout, _(" (%s line %d)"), file, line);
+	fprintf(stdout, "\n");
+	fflush(stdout);
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Catch fatal errors from pieces we import from xfs_repair. */
+void __attribute__((noreturn))
+do_error(char const *msg, ...)
+{
+	va_list args;
+
+	fprintf(stderr, _("\nfatal error -- "));
+
+	va_start(args, msg);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	if (dumpcore)
+		abort();
+	exit(1);
+}
diff --git a/scrub/common.h b/scrub/common.h
index f29e4d3..b7c5f47 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -20,4 +20,32 @@
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
+void __str_errno(struct scrub_ctx *ctx, const char *descr, const char *file,
+		 int line);
+void __str_error(struct scrub_ctx *ctx, const char *descr, const char *file,
+		 int line, const char *format, ...);
+void __str_warn(struct scrub_ctx *ctx, const char *descr, const char *file,
+		int line, const char *format, ...);
+void __str_info(struct scrub_ctx *ctx, const char *descr, const char *file,
+		int line, const char *format, ...);
+void __record_repair(struct scrub_ctx *ctx, const char *descr, const char *file,
+		int line, const char *format, ...);
+void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
+		int line, const char *format, ...);
+
+#define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
+#define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 6344428..d32f26c 100644
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
@@ -99,6 +101,12 @@
 /* Program name; needed for libxcmd error reports. */
 char				*progname = "xfs_scrub";
 
+/* Debug level; higher values mean more verbosity. */
+unsigned int			debug;
+
+/* Should we dump core if errors happen? */
+bool				dumpcore;
+
 int
 main(
 	int			argc,
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index f1ce4d2..6c03167 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -20,4 +20,16 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
+extern unsigned int		debug;
+extern bool			dumpcore;
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

