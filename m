Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25596 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:27 -0400
Subject: [PATCH 16/22] xfs_scrub: wire up repair ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:21 -0700
Message-ID: <150180536188.18784.15455491624369072809.stgit@magnolia>
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

Create the mechanism we need to actually call the kernel's online repair
functionality.  The interface will consume a repair description; the
descriptor management will follow in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   51 +++++++++++++++++++++++
 scrub/common.h |    2 +
 scrub/ioctl.c  |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/ioctl.h  |   20 +++++++++
 scrub/phase1.c |   15 +++++++
 scrub/scrub.h  |    2 +
 6 files changed, 211 insertions(+), 1 deletion(-)


diff --git a/scrub/common.c b/scrub/common.c
index 4ec07a0..7ca0e78 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -157,6 +157,57 @@ __str_info(
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
index 7c35f3f..2e4ff05 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -46,6 +46,8 @@ void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
 #define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define record_repair(ctx, str, ...)	__record_repair(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define record_preen(ctx, str, ...)	__record_preen(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
 
 /* Is this debug tweak enabled? */
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
index a3b7c04..3ed9758 100644
--- a/scrub/ioctl.c
+++ b/scrub/ioctl.c
@@ -457,7 +457,7 @@ xfs_can_iterate_fsmap(
 	return error == 0 && (head.fmh_oflags & FMH_OF_DEV_T);
 }
 
-/* Online scrub. */
+/* Online scrub and repair. */
 
 /* Type info and names for the scrub types. */
 enum scrub_type {
@@ -915,6 +915,119 @@ xfs_scrub_parent(
 	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_PARENT);
 }
 
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
+			if (repair_flags & XRM_NOFIX_COMPLAIN)
+				str_error(ctx, buf,
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
+
 /* Test the availability of a kernel scrub command. */
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR	30
 static bool
@@ -1019,3 +1132,10 @@ xfs_can_scrub_parent(
 {
 	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
 }
+
+bool
+xfs_can_repair(
+	struct scrub_ctx	*ctx)
+{
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_TEST, true);
+}
diff --git a/scrub/ioctl.h b/scrub/ioctl.h
index ee2ac26..4042f79 100644
--- a/scrub/ioctl.h
+++ b/scrub/ioctl.h
@@ -62,11 +62,30 @@ enum check_outcome {
 	CHECK_RETRY,	/* repair failed, try again later */
 };
 
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
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
 bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno);
 bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno);
 bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx);
 
+/* Only perform repairs; leave optimization-only actions for later. */
+#define XRM_REPAIR_ONLY		(1 << 0)
+
+/* Complain if still broken even after fix. */
+#define XRM_NOFIX_COMPLAIN	(1 << 1)
+
+enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
+		struct repair_item *ri, unsigned int repair_flags);
+
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
 bool xfs_can_scrub_bmap(struct scrub_ctx *ctx);
@@ -74,6 +93,7 @@ bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
 bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
 bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
 bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
+bool xfs_can_repair(struct scrub_ctx *ctx);
 
 bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		int fd);
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 66f4aa3..6c0a31d 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -118,6 +118,21 @@ _("Does not appear to be an XFS filesystem!"));
 	    !xfs_can_scrub_parent(ctx))
 		goto err;
 
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
+			goto err;
+		}
+	}
+
 	/* Go find the XFS devices if we have a usable fsmap. */
 	fs_table_initialise(0, NULL, 0, NULL);
 	errno = 0;
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0b82d9f..7e835ec 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -100,6 +100,8 @@ struct scrub_ctx {
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
+	unsigned long long	repairs;
+	unsigned long long	preens;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };
 

