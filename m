Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C747CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjIYV7J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E531112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F00C433C7;
        Mon, 25 Sep 2023 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679141;
        bh=viXtrW6RoFdVirbWvslrHr2+C77Tk0wskGeWmKs/dNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FD7+XGed/zfjStPdBpInbVuVGsTavaNok/Bo9OH7Di3nKYmVTd+bzG2KKOmj5sw/W
         Nf/0awAMl8Qiibmzoux48u0BZOZX/wQUwl1x67dVyjNSHFWtlhEZq9EIQAhOXPbBIR
         0rldNbsUpxKDrpU/Zx4124vIvQRNg5FXOYMrS8os7TIVqc+w71NutT2LZcC14Mnzic
         A6dXMdBYHMbu8IfhOI5+2EPo3k6+WmPJsm17kqPjPwoQPhl4iMowAFrUwjhUHRA0n+
         0Hk2DuDjYW0cSwrgmznjlNTwGcPgpBUq84FaK7avlZreSb9tOI3hm/Ztt8rDtfj/cG
         gXvMmqkDzHfXg==
Subject: [PATCH 3/3] xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:01 -0700
Message-ID: <169567914124.2320149.15117801698950181657.stgit@frogsfrogsfrogs>
In-Reply-To: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
References: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have a FORCE_REBUILD flag to the scrub ioctl, try to use
that over the (much noisier) error injection knob, which may or may not
even be enabled in the kernel config.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c    |   28 ++++++++++++++++++++++++++++
 scrub/scrub.c     |   45 +++++++++++++++++++++++----------------------
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.c |    3 +++
 scrub/xfs_scrub.h |    1 +
 5 files changed, 56 insertions(+), 22 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index fd1050c9202..2daf5c7bb38 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -27,6 +27,7 @@
 #include "scrub.h"
 #include "repair.h"
 #include "libfrog/fsgeom.h"
+#include "xfs_errortag.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -68,6 +69,27 @@ scrub_cleanup(
 	return error;
 }
 
+/* Decide if we're using FORCE_REBUILD or injecting FORCE_REPAIR. */
+static int
+enable_force_repair(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_error_injection	inject = {
+		.fd			= ctx->mnt.fd,
+		.errtag			= XFS_ERRTAG_FORCE_SCRUB_REPAIR,
+	};
+	int				error;
+
+	use_force_rebuild = can_force_rebuild(ctx);
+	if (use_force_rebuild)
+		return 0;
+
+	error = ioctl(ctx->mnt.fd, XFS_IOC_ERROR_INJECTION, &inject);
+	if (error)
+		str_errno(ctx, _("force_repair"));
+	return error;
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -156,6 +178,12 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return ECANCELED;
 	}
 
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		error = enable_force_repair(ctx);
+		if (error)
+			return error;
+	}
+
 	/* Did we find the log and rt devices, if they're present? */
 	if (ctx->mnt.fsgeom.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
 		str_error(ctx, ctx->mntpoint,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1a4506875f7..1469058bd23 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -18,7 +18,6 @@
 #include "common.h"
 #include "progress.h"
 #include "scrub.h"
-#include "xfs_errortag.h"
 #include "repair.h"
 #include "descr.h"
 
@@ -500,26 +499,16 @@ static bool
 __scrub_test(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	bool				repair)
+	unsigned int			flags)
 {
 	struct xfs_scrub_metadata	meta = {0};
-	struct xfs_error_injection	inject;
-	static bool			injected;
 	int				error;
 
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
-	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
-		inject.fd = ctx->mnt.fd;
-		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_ERROR_INJECTION, &inject);
-		if (error == 0)
-			injected = true;
-	}
 
 	meta.sm_type = type;
-	if (repair)
-		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
+	meta.sm_flags = flags;
 	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
 	switch (error) {
 	case 0:
@@ -532,13 +521,15 @@ _("Filesystem is mounted read-only; cannot proceed."));
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem is mounted norecovery; cannot proceed."));
 		return false;
+	case EINVAL:
 	case EOPNOTSUPP:
 	case ENOTTY:
 		if (debug || verbose)
 			str_info(ctx, ctx->mntpoint,
 _("Kernel %s %s facility not detected."),
 					_(xfrog_scrubbers[type].descr),
-					repair ? _("repair") : _("scrub"));
+					(flags & XFS_SCRUB_IFLAG_REPAIR) ?
+						_("repair") : _("scrub"));
 		return false;
 	case ENOENT:
 		/* Scrubber says not present on this fs; that's fine. */
@@ -553,56 +544,64 @@ bool
 can_scrub_fs_metadata(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, 0);
 }
 
 bool
 can_scrub_inode(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_INODE, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_INODE, 0);
 }
 
 bool
 can_scrub_bmap(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, 0);
 }
 
 bool
 can_scrub_dir(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_DIR, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_DIR, 0);
 }
 
 bool
 can_scrub_attr(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, 0);
 }
 
 bool
 can_scrub_symlink(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, 0);
 }
 
 bool
 can_scrub_parent(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, 0);
 }
 
 bool
 xfs_can_repair(
 	struct scrub_ctx	*ctx)
 {
-	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, true);
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, XFS_SCRUB_IFLAG_REPAIR);
+}
+
+bool
+can_force_rebuild(
+	struct scrub_ctx	*ctx)
+{
+	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
+			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
 
 /* General repair routines. */
@@ -624,6 +623,8 @@ xfs_repair_metadata(
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	meta.sm_type = aitem->type;
 	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	if (use_force_rebuild)
+		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
 	switch (xfrog_scrubbers[aitem->type].type) {
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
diff --git a/scrub/scrub.h b/scrub/scrub.h
index fccd82f2155..023069ee066 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -33,6 +33,7 @@ bool can_scrub_attr(struct scrub_ctx *ctx);
 bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
+bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
 		unsigned int type, struct action_list *alist);
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 7a0411b0cc8..597be59f9f9 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -157,6 +157,9 @@ bool				stdout_isatty;
  */
 bool				is_service;
 
+/* Set to true if the kernel supports XFS_SCRUB_IFLAG_FORCE_REBUILD */
+bool				use_force_rebuild;
+
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
 #define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index f6712d368c6..0d6b9dad2c9 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -21,6 +21,7 @@ extern bool			want_fstrim;
 extern bool			stderr_isatty;
 extern bool			stdout_isatty;
 extern bool			is_service;
+extern bool			use_force_rebuild;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,

