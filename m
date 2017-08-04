Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33481 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:07:53 -0400
Subject: [PATCH 02/22] xfs_scrub: common error handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:07:49 -0700
Message-ID: <150180526916.18784.5355456583517444164.stgit@magnolia>
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

Standardize how we record and report errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/common.h |   28 ++++++++++++
 scrub/scrub.c  |    6 +++
 scrub/scrub.h  |   12 +++++
 4 files changed, 180 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 7f2b4d2..4e47332 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -34,3 +34,137 @@
 #include "scrub.h"
 #include "common.h"
 #include "input.h"
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
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 4fe1590..bac1e8c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -113,6 +113,12 @@
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
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b07029b..49de30b 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -20,4 +20,16 @@
 #ifndef XFS_SCRUB_SCRUB_H_
 #define XFS_SCRUB_SCRUB_H_
 
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
 #endif /* XFS_SCRUB_SCRUB_H_ */

