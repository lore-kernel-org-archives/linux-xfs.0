Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbeAaDJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:09:44 -0500
Subject: [PATCH 28/29] xfs_scrub: wire up repair ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:09:39 -0800
Message-ID: <151736817940.32164.16979915543351450047.stgit@magnolia>
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

Create the mechanism we need to actually call the kernel's online repair
functionality.  The interface will consume a repair description; the
descriptor management will follow in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |   12 +++++
 scrub/common.h    |    6 ++
 scrub/phase1.c    |   11 ++++
 scrub/phase2.c    |    1 
 scrub/phase3.c    |    1 
 scrub/phase5.c    |    1 
 scrub/scrub.c     |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h     |   20 ++++++++
 scrub/xfs_scrub.h |    2 +
 9 files changed, 188 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 18171d1..17c3699 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -59,7 +59,9 @@ xfs_scrub_excessive_errors(
 static const char *err_str[] = {
 	[S_ERROR]	= "Error",
 	[S_WARN]	= "Warning",
+	[S_REPAIR]	= "Repaired",
 	[S_INFO]	= "Info",
+	[S_PREEN]	= "Optimized",
 };
 
 /* If stream is a tty, clear to end of line to clean up progress bar. */
@@ -93,6 +95,11 @@ __str_out(
 		stream = stdout;
 
 	pthread_mutex_lock(&ctx->lock);
+
+	/* We only want to hear about optimizing when in debug/verbose mode. */
+	if (level == S_PREEN && !debug && !verbose)
+		goto out_record;
+
 	fprintf(stream, "%s%s: %s: ", stream_start(stream), _(err_str[level]),
 			descr);
 	if (error) {
@@ -109,12 +116,17 @@ __str_out(
 	if (stream == stdout)
 		fflush(stream);
 
+out_record:
 	if (error)      /* A syscall failed */
 		ctx->runtime_errors++;
 	else if (level == S_ERROR)
 		ctx->errors_found++;
 	else if (level == S_WARN)
 		ctx->warnings_found++;
+	else if (level == S_REPAIR)
+		ctx->repairs++;
+	else if (level == S_PREEN)
+		ctx->preens++;
 
 	pthread_mutex_unlock(&ctx->lock);
 }
diff --git a/scrub/common.h b/scrub/common.h
index 29b4332..287bd4d 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -32,7 +32,9 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
 enum error_level {
 	S_ERROR	= 0,
 	S_WARN,
+	S_REPAIR,
 	S_INFO,
+	S_PREEN,
 };
 
 void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
@@ -46,6 +48,10 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 	__str_out(ctx, str, S_WARN,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define str_info(ctx, str, ...) \
 	__str_out(ctx, str, S_INFO,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define record_repair(ctx, str, ...) \
+	__str_out(ctx, str, S_REPAIR,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define record_preen(ctx, str, ...) \
+	__str_out(ctx, str, S_PREEN,	0,	__FILE__, __LINE__, __VA_ARGS__)
 
 #define dbg_printf(fmt, ...) \
 	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6b986dd..547767b 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -179,6 +179,17 @@ _("Kernel metadata scrubbing facility is required."));
 		return false;
 	}
 
+	/* Do we need kernel-assisted metadata repair? */
+	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
+		if (ctx->mode == SCRUB_MODE_PREEN)
+			str_error(ctx, ctx->mntpoint,
+_("Kernel metadata optimization facility is required."));
+		else
+			str_error(ctx, ctx->mntpoint,
+_("Kernel metadata repair facility is required."));
+		return false;
+	}
+
 	/* Go find the XFS devices if we have a usable fsmap. */
 	fs_table_initialise(0, NULL, 0, NULL);
 	errno = 0;
diff --git a/scrub/phase2.c b/scrub/phase2.c
index e8eb1ca..32e2752 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <sys/statvfs.h>
 #include "xfs.h"
+#include "list.h"
 #include "path.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 43697c6..f4117b0 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <sys/statvfs.h>
 #include "xfs.h"
+#include "list.h"
 #include "path.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index fc3308b..703b279 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -29,6 +29,7 @@
 #endif
 #include "xfs.h"
 #include "handle.h"
+#include "list.h"
 #include "path.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c4b7694..0dbe11c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -28,6 +28,7 @@
 #include <sys/statvfs.h>
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "list.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
@@ -561,10 +562,15 @@ __xfs_scrub_test(
 	bool				repair)
 {
 	struct xfs_scrub_metadata	meta = {0};
+	static bool			injected;
 	int				error;
 
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		str_error(ctx, "XFS_SCRUB_FORCE_REPAIR", "Not supported.");
+		return false;
+	}
 
 	meta.sm_type = type;
 	if (repair)
@@ -647,3 +653,131 @@ xfs_can_scrub_parent(
 {
 	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
 }
+
+bool
+xfs_can_repair(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, true);
+}
+
+/* General repair routines. */
+
+/* Repair some metadata. */
+enum check_outcome
+xfs_repair_metadata(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	struct repair_item		*ri,
+	unsigned int			repair_flags)
+{
+	char				buf[DESCR_BUFSZ];
+	struct xfs_scrub_metadata	meta = { 0 };
+	struct xfs_scrub_metadata	oldm;
+	int				error;
+
+	assert(ri->type < XFS_SCRUB_TYPE_NR);
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	meta.sm_type = ri->type;
+	meta.sm_flags = ri->flags | XFS_SCRUB_IFLAG_REPAIR;
+	switch (scrubbers[ri->type].type) {
+	case ST_AGHEADER:
+	case ST_PERAG:
+		meta.sm_agno = ri->agno;
+		break;
+	case ST_INODE:
+		meta.sm_ino = ri->ino;
+		meta.sm_gen = ri->gen;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * If this is a preen operation but we're only repairing
+	 * critical items, defer the preening until later.
+	 */
+	if (!needs_repair(&meta) && (repair_flags & XRM_REPAIR_ONLY))
+		return CHECK_RETRY;
+
+	memcpy(&oldm, &meta, sizeof(oldm));
+	format_scrub_descr(buf, DESCR_BUFSZ, &meta, &scrubbers[meta.sm_type]);
+
+	if (needs_repair(&meta))
+		str_info(ctx, buf, _("Attempting repair."));
+	else if (debug || verbose)
+		str_info(ctx, buf, _("Attempting optimization."));
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	/*
+	 * If the caller doesn't want us to complain, tell the caller to
+	 * requeue the repair for later and don't say a thing.
+	 */
+	if (!(repair_flags & XRM_NOFIX_COMPLAIN) &&
+	    (error || needs_repair(&meta)))
+		return CHECK_RETRY;
+	if (error) {
+		switch (errno) {
+		case EDEADLOCK:
+		case EBUSY:
+			/* Filesystem is busy, try again later. */
+			if (debug || verbose)
+				str_info(ctx, buf,
+_("Filesystem is busy, deferring repair."));
+			return CHECK_RETRY;
+		case ESHUTDOWN:
+			/* Filesystem is already shut down, abort. */
+			str_error(ctx, buf,
+_("Filesystem is shut down, aborting."));
+			return CHECK_ABORT;
+		case ENOTTY:
+		case EOPNOTSUPP:
+			/*
+			 * If we forced repairs, don't complain if kernel
+			 * doesn't know how to fix.
+			 */
+			if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+				return CHECK_DONE;
+			/* fall through */
+		case EINVAL:
+			/* Kernel doesn't know how to repair this? */
+			str_error(ctx, buf,
+_("Don't know how to fix; offline repair required."));
+			return CHECK_DONE;
+		case EROFS:
+			/* Read-only filesystem, can't fix. */
+			if (verbose || debug || needs_repair(&oldm))
+				str_info(ctx, buf,
+_("Read-only filesystem; cannot make changes."));
+			return CHECK_DONE;
+		case ENOENT:
+			/* Metadata not present, just skip it. */
+			return CHECK_DONE;
+		case ENOMEM:
+		case ENOSPC:
+			/* Don't care if preen fails due to low resources. */
+			if (is_unoptimized(&oldm) && !needs_repair(&oldm))
+				return CHECK_DONE;
+			/* fall through */
+		default:
+			/* Operational error. */
+			str_errno(ctx, buf);
+			return CHECK_DONE;
+		}
+	}
+	if (repair_flags & XRM_NOFIX_COMPLAIN)
+		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
+	if (needs_repair(&meta)) {
+		/* Still broken, try again or fix offline. */
+		if (repair_flags & XRM_NOFIX_COMPLAIN)
+			str_error(ctx, buf,
+_("Repair unsuccessful; offline repair required."));
+	} else {
+		/* Clean operation, no corruption detected. */
+		if (needs_repair(&oldm))
+			record_repair(ctx, buf, _("Repairs successful."));
+		else
+			record_preen(ctx, buf, _("Optimization successful."));
+	}
+	return CHECK_DONE;
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0b454df..1c44fba 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -41,6 +41,7 @@ bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
 bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
 bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
 bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
+bool xfs_can_repair(struct scrub_ctx *ctx);
 
 bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		int fd);
@@ -59,4 +60,23 @@ bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		int fd);
 
+/* Repair parameters are the scrub inputs and retry count. */
+struct repair_item {
+	struct list_head	list;
+	__u64			ino;
+	__u32			type;
+	__u32			flags;
+	__u32			gen;
+	__u32			agno;
+};
+
+/* Only perform repairs; leave optimization-only actions for later. */
+#define XRM_REPAIR_ONLY		(1U << 0)
+
+/* Complain if still broken even after fix. */
+#define XRM_NOFIX_COMPLAIN	(1U << 1)
+
+enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
+		struct repair_item *ri, unsigned int repair_flags);
+
 #endif /* XFS_SCRUB_SCRUB_H_ */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 16cd1aa..8407885 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -95,6 +95,8 @@ struct scrub_ctx {
 	unsigned long long	inodes_checked;
 	unsigned long long	bytes_checked;
 	unsigned long long	naming_warnings;
+	unsigned long long	repairs;
+	unsigned long long	preens;
 	bool			need_repair;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };

