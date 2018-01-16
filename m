Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbeAPTYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 14:24:22 -0500
Date: Tue, 16 Jan 2018 11:21:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/27] xfs_scrub: wire up repair ioctl
Message-ID: <20180116192132.GR5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151520348769.2027.9860697266310422360.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the mechanism we need to actually call the kernel's online repair
functionality.  The interface will consume a repair description; the
descriptor management will follow in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |   51 +++++++++++++++++++
 scrub/common.h    |    2 +
 scrub/phase1.c    |   15 ++++++
 scrub/phase2.c    |    1 
 scrub/phase3.c    |    1 
 scrub/phase5.c    |    1 
 scrub/scrub.c     |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h     |   20 ++++++++
 scrub/xfs_scrub.h |    2 +
 9 files changed, 232 insertions(+)

diff --git a/scrub/common.c b/scrub/common.c
index 48ee01c..bd3e939 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -180,6 +180,57 @@ __str_info(
 	pthread_mutex_unlock(&ctx->lock);
 }
 
+/* Increment the repair count. */
+void
+__record_repair(
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
+	fprintf(stderr, _("Repaired: %s: "), descr);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, _(" (%s line %d)"), file, line);
+	fprintf(stderr, "\n");
+	ctx->repairs++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Increment the optimization (preening) count. */
+void
+__record_preen(
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
+	if (debug || verbose) {
+		fprintf(stdout, _("Optimized: %s: "), descr);
+		va_start(args, format);
+		vfprintf(stdout, format, args);
+		va_end(args);
+		if (debug)
+			fprintf(stdout, _(" (%s line %d)"), file, line);
+		fprintf(stdout, "\n");
+		fflush(stdout);
+	}
+	ctx->preens++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
 /* Catch fatal errors from pieces we import from xfs_repair. */
 void __attribute__((noreturn))
 do_error(char const *msg, ...)
diff --git a/scrub/common.h b/scrub/common.h
index bd67a17..ea3bc3f 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -49,6 +49,8 @@ void __str_errno_warn(struct scrub_ctx *, const char *descr, const char *file,
 #define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_errno_warn(ctx, str)	__str_errno_warn(ctx, str, __FILE__, __LINE__)
+#define record_repair(ctx, str, ...)	__record_repair(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define record_preen(ctx, str, ...)	__record_preen(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
 
 /* Is this debug tweak enabled? */
diff --git a/scrub/phase1.c b/scrub/phase1.c
index d7a321f..3a2fbd7 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -176,6 +176,21 @@ _("Does not appear to be an XFS filesystem!"));
 	    !xfs_can_scrub_parent(ctx))
 		return false;
 
+	/* Do we have kernel-assisted metadata repair? */
+	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
+		if (ctx->mode == SCRUB_MODE_PREEN) {
+			/* w/o repair, demote preen to dry run. */
+			if (debug || verbose)
+				str_info(ctx, ctx->mntpoint,
+_("Metadata repairing not supported; demoting to scan mode.")
+						);
+			ctx->mode = SCRUB_MODE_DRY_RUN;
+		} else {
+			/* Repair mode w/o repair; abort. */
+			return false;
+		}
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
index bc4eab4..5729b9b 100644
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
@@ -561,10 +562,20 @@ __xfs_scrub_test(
 	bool				repair)
 {
 	struct xfs_scrub_metadata	meta = {0};
+	struct xfs_error_injection	inject;
+	static bool			injected;
 	int				error;
 
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		inject.fd = ctx->mnt_fd;
+		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
+		error = ioctl(ctx->mnt_fd,
+				XFS_IOC_ERROR_INJECTION, &inject);
+		if (error == 0)
+			injected = true;
+	}
 
 	meta.sm_type = type;
 	if (repair)
@@ -646,3 +657,131 @@ xfs_can_scrub_parent(
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
index 9b5e490..83b8ae2 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -97,6 +97,8 @@ struct scrub_ctx {
 	unsigned long long	inodes_checked;
 	unsigned long long	bytes_checked;
 	unsigned long long	naming_warnings;
+	unsigned long long	repairs;
+	unsigned long long	preens;
 	bool			need_repair;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };
