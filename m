Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B53C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiLaAY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLaAY6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:24:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF88BE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:24:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C486661D23
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B75C433D2;
        Sat, 31 Dec 2022 00:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446296;
        bh=+oR2F53/XCqncTaoU9XVKAEkgvvIZsdZuSXFpbgAyf0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f7RE+p1t30s6dWFtw8lzAjOqblzNFohHAmIMynIXczVjizx3gTkLRG95ANoy7LBN4
         7BiItyGlTdh1TlKxeX6GyR24d66/n3MNwjLkOkPCCv2cdIAeeIOVg87ZjPfYg+GHXH
         DZpKmFTQNukVf54deoiEV6D/3u9dpgXsoLPGkT/SL1RJ/YHiceToASM9J6vBDSbPlP
         Ow6NFw6+cKC05+c7VTXcpA3bEghMJBeLOFLPp0KzlxH2yzZ4de4TksOMpR9O3PWl4f
         Uk4Q4qDx7Fvjvq8SSTAzz7wLCGeZE05Twetxzolh7f0sO/DycNzMCRIV8tMGihrf+r
         /E87XathrnIsg==
Subject: [PATCH 3/6] xfs_scrub: move repair functions to repair.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869063.714771.7071370028761975033.stgit@magnolia>
In-Reply-To: <167243869023.714771.3955258526251265287.stgit@magnolia>
References: <167243869023.714771.3955258526251265287.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the repair functions to repair.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c        |    2 
 scrub/repair.c        |  161 +++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |  202 +------------------------------------------------
 scrub/scrub.h         |    6 -
 scrub/scrub_private.h |   55 +++++++++++++
 5 files changed, 222 insertions(+), 204 deletions(-)
 create mode 100644 scrub/scrub_private.h


diff --git a/scrub/phase1.c b/scrub/phase1.c
index cecb5e861f4..2d258a1a182 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -210,7 +210,7 @@ _("Kernel metadata scrubbing facility is not available."));
 	}
 
 	/* Do we need kernel-assisted metadata repair? */
-	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
+	if (ctx->mode != SCRUB_MODE_DRY_RUN && !can_repair(ctx)) {
 		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return ECANCELED;
diff --git a/scrub/repair.c b/scrub/repair.c
index 54016337896..a6fbdcb638d 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -10,11 +10,172 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
 #include "progress.h"
 #include "repair.h"
+#include "descr.h"
+#include "scrub_private.h"
+
+/* General repair routines. */
+
+/* Repair some metadata. */
+static enum check_outcome
+xfs_repair_metadata(
+	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
+	struct action_item		*aitem,
+	unsigned int			repair_flags)
+{
+	struct xfs_scrub_metadata	meta = { 0 };
+	struct xfs_scrub_metadata	oldm;
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
+	int				error;
+
+	assert(aitem->type < XFS_SCRUB_TYPE_NR);
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	meta.sm_type = aitem->type;
+	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	if (use_force_rebuild)
+		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
+	switch (xfrog_scrubbers[aitem->type].group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		meta.sm_agno = aitem->agno;
+		break;
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = aitem->ino;
+		meta.sm_gen = aitem->gen;
+		break;
+	default:
+		break;
+	}
+
+	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
+		return CHECK_RETRY;
+
+	memcpy(&oldm, &meta, sizeof(oldm));
+	descr_set(&dsc, &oldm);
+
+	if (needs_repair(&meta))
+		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
+	else if (debug || verbose)
+		str_info(ctx, descr_render(&dsc),
+				_("Attempting optimization."));
+
+	error = -xfrog_scrub_metadata(xfdp, &meta);
+	switch (error) {
+	case 0:
+		/* No operational errors encountered. */
+		break;
+	case EDEADLOCK:
+	case EBUSY:
+		/* Filesystem is busy, try again later. */
+		if (debug || verbose)
+			str_info(ctx, descr_render(&dsc),
+_("Filesystem is busy, deferring repair."));
+		return CHECK_RETRY;
+	case ESHUTDOWN:
+		/* Filesystem is already shut down, abort. */
+		str_error(ctx, descr_render(&dsc),
+_("Filesystem is shut down, aborting."));
+		return CHECK_ABORT;
+	case ENOTTY:
+	case EOPNOTSUPP:
+		/*
+		 * If we're in no-complain mode, requeue the check for
+		 * later.  It's possible that an error in another
+		 * component caused us to flag an error in this
+		 * component.  Even if the kernel didn't think it
+		 * could fix this, it's at least worth trying the scan
+		 * again to see if another repair fixed it.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		/*
+		 * If we forced repairs or this is a preen, don't
+		 * error out if the kernel doesn't know how to fix.
+		 */
+		if (is_unoptimized(&oldm) ||
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			return CHECK_DONE;
+		fallthrough;
+	case EINVAL:
+		/* Kernel doesn't know how to repair this? */
+		str_corrupt(ctx, descr_render(&dsc),
+_("Don't know how to fix; offline repair required."));
+		return CHECK_DONE;
+	case EROFS:
+		/* Read-only filesystem, can't fix. */
+		if (verbose || debug || needs_repair(&oldm))
+			str_error(ctx, descr_render(&dsc),
+_("Read-only filesystem; cannot make changes."));
+		return CHECK_ABORT;
+	case ENOENT:
+		/* Metadata not present, just skip it. */
+		return CHECK_DONE;
+	case ENOMEM:
+	case ENOSPC:
+		/* Don't care if preen fails due to low resources. */
+		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
+			return CHECK_DONE;
+		fallthrough;
+	default:
+		/*
+		 * Operational error.  If the caller doesn't want us
+		 * to complain about repair failures, tell the caller
+		 * to requeue the repair for later and don't say a
+		 * thing.  Otherwise, print error and bail out.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		str_liberror(ctx, error, descr_render(&dsc));
+		return CHECK_DONE;
+	}
+
+	if (repair_flags & XRM_FINAL_WARNING)
+		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
+	if (needs_repair(&meta)) {
+		/*
+		 * Still broken; if we've been told not to complain then we
+		 * just requeue this and try again later.  Otherwise we
+		 * log the error loudly and don't try again.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		str_corrupt(ctx, descr_render(&dsc),
+ _("Repair unsuccessful; offline repair required."));
+	} else if (xref_failed(&meta)) {
+		/*
+		 * This metadata object itself looks ok, but we still noticed
+		 * inconsistencies when comparing it with the other filesystem
+		 * metadata.  If we're in "final warning" mode, advise the
+		 * caller to run xfs_repair; otherwise, we'll keep trying to
+		 * reverify the cross-referencing as repairs progress.
+		 */
+		if (repair_flags & XRM_FINAL_WARNING) {
+			str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; offline repair recommended."));
+		} else {
+			if (verbose)
+				str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; will keep checking."));
+			return CHECK_RETRY;
+		}
+	} else {
+		/* Clean operation, no corruption detected. */
+		if (needs_repair(&oldm))
+			record_repair(ctx, descr_render(&dsc),
+					_("Repairs successful."));
+		else
+			record_preen(ctx, descr_render(&dsc),
+					_("Optimization successful."));
+	}
+	return CHECK_DONE;
+}
 
 /*
  * Prioritize action items in order of how long we can wait.
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 7b9c360f796..0f080028879 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -20,11 +20,12 @@
 #include "scrub.h"
 #include "repair.h"
 #include "descr.h"
+#include "scrub_private.h"
 
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
-static int
+int
 format_scrub_descr(
 	struct scrub_ctx		*ctx,
 	char				*buf,
@@ -52,46 +53,8 @@ format_scrub_descr(
 	return -1;
 }
 
-/* Predicates for scrub flag state. */
-
-static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
-}
-
-static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
-}
-
-static inline bool xref_failed(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
-}
-
-static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
-}
-
-static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
-}
-
-static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
-}
-
-/* Should we fix it? */
-static inline bool needs_repair(struct xfs_scrub_metadata *sm)
-{
-	return is_corrupt(sm) || xref_disagrees(sm);
-}
-
 /* Warn about strange circumstances after scrub. */
-static inline void
+void
 scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
@@ -647,7 +610,7 @@ can_scrub_parent(
 }
 
 bool
-xfs_can_repair(
+can_repair(
 	struct scrub_ctx	*ctx)
 {
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, XFS_SCRUB_IFLAG_REPAIR);
@@ -660,160 +623,3 @@ can_force_rebuild(
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
 			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
-
-/* General repair routines. */
-
-/* Repair some metadata. */
-enum check_outcome
-xfs_repair_metadata(
-	struct scrub_ctx		*ctx,
-	struct xfs_fd			*xfdp,
-	struct action_item		*aitem,
-	unsigned int			repair_flags)
-{
-	struct xfs_scrub_metadata	meta = { 0 };
-	struct xfs_scrub_metadata	oldm;
-	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
-	int				error;
-
-	assert(aitem->type < XFS_SCRUB_TYPE_NR);
-	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	meta.sm_type = aitem->type;
-	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
-	if (use_force_rebuild)
-		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
-	switch (xfrog_scrubbers[aitem->type].group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = aitem->agno;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = aitem->ino;
-		meta.sm_gen = aitem->gen;
-		break;
-	default:
-		break;
-	}
-
-	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
-		return CHECK_RETRY;
-
-	memcpy(&oldm, &meta, sizeof(oldm));
-	descr_set(&dsc, &oldm);
-
-	if (needs_repair(&meta))
-		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
-	else if (debug || verbose)
-		str_info(ctx, descr_render(&dsc),
-				_("Attempting optimization."));
-
-	error = -xfrog_scrub_metadata(xfdp, &meta);
-	switch (error) {
-	case 0:
-		/* No operational errors encountered. */
-		break;
-	case EDEADLOCK:
-	case EBUSY:
-		/* Filesystem is busy, try again later. */
-		if (debug || verbose)
-			str_info(ctx, descr_render(&dsc),
-_("Filesystem is busy, deferring repair."));
-		return CHECK_RETRY;
-	case ESHUTDOWN:
-		/* Filesystem is already shut down, abort. */
-		str_error(ctx, descr_render(&dsc),
-_("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
-	case ENOTTY:
-	case EOPNOTSUPP:
-		/*
-		 * If we're in no-complain mode, requeue the check for
-		 * later.  It's possible that an error in another
-		 * component caused us to flag an error in this
-		 * component.  Even if the kernel didn't think it
-		 * could fix this, it's at least worth trying the scan
-		 * again to see if another repair fixed it.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		/*
-		 * If we forced repairs or this is a preen, don't
-		 * error out if the kernel doesn't know how to fix.
-		 */
-		if (is_unoptimized(&oldm) ||
-		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			return CHECK_DONE;
-		fallthrough;
-	case EINVAL:
-		/* Kernel doesn't know how to repair this? */
-		str_corrupt(ctx, descr_render(&dsc),
-_("Don't know how to fix; offline repair required."));
-		return CHECK_DONE;
-	case EROFS:
-		/* Read-only filesystem, can't fix. */
-		if (verbose || debug || needs_repair(&oldm))
-			str_error(ctx, descr_render(&dsc),
-_("Read-only filesystem; cannot make changes."));
-		return CHECK_ABORT;
-	case ENOENT:
-		/* Metadata not present, just skip it. */
-		return CHECK_DONE;
-	case ENOMEM:
-	case ENOSPC:
-		/* Don't care if preen fails due to low resources. */
-		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
-			return CHECK_DONE;
-		fallthrough;
-	default:
-		/*
-		 * Operational error.  If the caller doesn't want us
-		 * to complain about repair failures, tell the caller
-		 * to requeue the repair for later and don't say a
-		 * thing.  Otherwise, print error and bail out.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_DONE;
-	}
-
-	if (repair_flags & XRM_FINAL_WARNING)
-		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta)) {
-		/*
-		 * Still broken; if we've been told not to complain then we
-		 * just requeue this and try again later.  Otherwise we
-		 * log the error loudly and don't try again.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		str_corrupt(ctx, descr_render(&dsc),
-_("Repair unsuccessful; offline repair required."));
-	} else if (xref_failed(&meta)) {
-		/*
-		 * This metadata object itself looks ok, but we still noticed
-		 * inconsistencies when comparing it with the other filesystem
-		 * metadata.  If we're in "final warning" mode, advise the
-		 * caller to run xfs_repair; otherwise, we'll keep trying to
-		 * reverify the cross-referencing as repairs progress.
-		 */
-		if (repair_flags & XRM_FINAL_WARNING) {
-			str_info(ctx, descr_render(&dsc),
- _("Seems correct but cross-referencing failed; offline repair recommended."));
-		} else {
-			if (verbose)
-				str_info(ctx, descr_render(&dsc),
- _("Seems correct but cross-referencing failed; will keep checking."));
-			return CHECK_RETRY;
-		}
-	} else {
-		/* Clean operation, no corruption detected. */
-		if (needs_repair(&oldm))
-			record_repair(ctx, descr_render(&dsc),
-					_("Repairs successful."));
-		else
-			record_preen(ctx, descr_render(&dsc),
-					_("Optimization successful."));
-	}
-	return CHECK_DONE;
-}
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 751f2c8e9c1..9558c29f32d 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -38,7 +38,7 @@ bool can_scrub_dir(struct scrub_ctx *ctx);
 bool can_scrub_attr(struct scrub_ctx *ctx);
 bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
-bool xfs_can_repair(struct scrub_ctx *ctx);
+bool can_repair(struct scrub_ctx *ctx);
 bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
@@ -54,8 +54,4 @@ struct action_item {
 	__u32			agno;
 };
 
-enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx,
-		struct xfs_fd *xfdp, struct action_item *aitem,
-		unsigned int repair_flags);
-
 #endif /* XFS_SCRUB_SCRUB_H_ */
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
new file mode 100644
index 00000000000..8bc0c521463
--- /dev/null
+++ b/scrub/scrub_private.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef XFS_SCRUB_SCRUB_PRIVATE_H_
+#define XFS_SCRUB_SCRUB_PRIVATE_H_
+
+/* Shared code between scrub.c and repair.c. */
+
+int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
+		void *where);
+
+/* Predicates for scrub flag state. */
+
+static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
+}
+
+static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
+}
+
+static inline bool xref_failed(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
+}
+
+static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
+}
+
+static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
+}
+
+static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
+}
+
+/* Should we fix it? */
+static inline bool needs_repair(struct xfs_scrub_metadata *sm)
+{
+	return is_corrupt(sm) || xref_disagrees(sm);
+}
+
+void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
+		struct xfs_scrub_metadata *meta);
+
+#endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

