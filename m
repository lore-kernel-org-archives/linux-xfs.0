Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E0C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiLaAa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiLaAaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081EB1EAC9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9754561D49
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11A3C433D2;
        Sat, 31 Dec 2022 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446607;
        bh=6incI2MCs/Tczc2JspzIea5KJuaXbI+jl6jhS3ZABog=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jpmSqGkucuHCIv7vyW25lWRxBcVMif66QgQvFgHA6VziwRT7MCI/Ejytd+6p7qjII
         EROOz/h350Yn23iCC3ciClhkZW+c2YuONylgsUnvrUuaoZlQiS3zI2olx+UYK6b54J
         qA7acaEHyFyPyUrXrEOgsHAPgZgqqXa2FL2PuY+SFmDILd/H+wRpNwDy5GfRldmwEo
         uau14CJ3OcswmUkROrT/6U490nZn4L5JnOCxhT/qeGCzlbvDC5w6fYHCeQO7vH2bIu
         Dbg04mNLTgJNT5CZRAsguOyi9f0xwxANlqKk9+HoG7cF6RZm8///B5X0Na4LghcXoA
         rDTT2ZiwkXoQQ==
Subject: [PATCH 2/5] xfs_scrub: remove enum check_outcome
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870127.716382.594721188903094401.stgit@magnolia>
In-Reply-To: <167243870099.716382.3489355808439125232.stgit@magnolia>
References: <167243870099.716382.3489355808439125232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of this enumeration, and just do what we will directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   56 ++++++++++++++++++++++----------------------------
 scrub/scrub.c  |   63 +++++++++++++++++++++++++++++---------------------------
 scrub/scrub.h  |    8 -------
 3 files changed, 58 insertions(+), 69 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index a552b445e90..9cce421223b 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -45,7 +45,7 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
 #undef DEP
 
 /* Repair some metadata. */
-static enum check_outcome
+static int
 xfs_repair_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
@@ -87,7 +87,7 @@ xfs_repair_metadata(
 	}
 
 	if (!is_corrupt(&meta) && repair_only)
-		return CHECK_RETRY;
+		return 0;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
 	oldm.sm_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
@@ -111,12 +111,12 @@ xfs_repair_metadata(
 		if (debug || verbose)
 			str_info(ctx, descr_render(&dsc),
 _("Filesystem is busy, deferring repair."));
-		return CHECK_RETRY;
+		return 0;
 	case ESHUTDOWN:
 		/* Filesystem is already shut down, abort. */
 		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case ENOTTY:
 	case EOPNOTSUPP:
 		/*
@@ -128,7 +128,7 @@ _("Filesystem is shut down, aborting."));
 		 * again to see if another repair fixed it.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		/*
 		 * If we forced repairs or this is a preen, don't
 		 * error out if the kernel doesn't know how to fix.
@@ -136,7 +136,7 @@ _("Filesystem is shut down, aborting."));
 		if (is_unoptimized(&oldm) ||
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 			scrub_item_clean_state(sri, scrub_type);
-			return CHECK_DONE;
+			return 0;
 		}
 		fallthrough;
 	case EINVAL:
@@ -144,23 +144,23 @@ _("Filesystem is shut down, aborting."));
 		str_corrupt(ctx, descr_render(&dsc),
 _("Don't know how to fix; offline repair required."));
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
 		if (verbose || debug || needs_repair(&oldm))
 			str_error(ctx, descr_render(&dsc),
 _("Read-only filesystem; cannot make changes."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	case ENOMEM:
 	case ENOSPC:
 		/* Don't care if preen fails due to low resources. */
 		if (is_unoptimized(&oldm) && !needs_repair(&oldm)) {
 			scrub_item_clean_state(sri, scrub_type);
-			return CHECK_DONE;
+			return 0;
 		}
 		fallthrough;
 	default:
@@ -172,10 +172,10 @@ _("Read-only filesystem; cannot make changes."));
 		 * trying to repair it, and bail out.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		str_liberror(ctx, error, descr_render(&dsc));
 		scrub_item_clean_state(sri, scrub_type);
-		return CHECK_DONE;
+		return 0;
 	}
 
 	/*
@@ -198,7 +198,7 @@ _("Read-only filesystem; cannot make changes."));
 		 * log the error loudly and don't try again.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
+			return 0;
 		str_corrupt(ctx, descr_render(&dsc),
  _("Repair unsuccessful; offline repair required."));
 	} else if (xref_failed(&meta)) {
@@ -216,7 +216,7 @@ _("Read-only filesystem; cannot make changes."));
 			if (verbose)
 				str_info(ctx, descr_render(&dsc),
  _("Seems correct but cross-referencing failed; will keep checking."));
-			return CHECK_RETRY;
+			return 0;
 		}
 	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
@@ -233,7 +233,7 @@ _("Read-only filesystem; cannot make changes."));
 	}
 
 	scrub_item_clean_state(sri, scrub_type);
-	return CHECK_DONE;
+	return 0;
 }
 
 /*
@@ -534,6 +534,7 @@ repair_item_class(
 	struct xfs_fd			xfd;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
+	int				error = 0;
 
 	if (ctx->mode < SCRUB_MODE_REPAIR)
 		return 0;
@@ -550,8 +551,6 @@ repair_item_class(
 	}
 
 	foreach_scrub_type(scrub_type) {
-		enum check_outcome	fix;
-
 		if (scrub_excessive_errors(ctx))
 			return ECANCELED;
 
@@ -567,22 +566,17 @@ repair_item_class(
 		    !repair_item_dependencies_ok(sri, scrub_type))
 			continue;
 
-		fix = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
-		switch (fix) {
-		case CHECK_DONE:
-			if (!(flags & XRM_NOPROGRESS))
-				progress_add(1);
-			continue;
-		case CHECK_ABORT:
-			return ECANCELED;
-		case CHECK_RETRY:
-			continue;
-		case CHECK_REPAIR:
-			abort();
-		}
+		error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
+		if (error)
+			break;
+
+		/* Maybe update progress if we fixed the problem. */
+		if (!(flags & XRM_NOPROGRESS) &&
+		    !(sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY))
+			progress_add(1);
 	}
 
-	return 0;
+	return error;
 }
 
 /*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1a60631eddc..da49285be78 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -78,12 +78,12 @@ scrub_warn_incomplete_scrub(
 }
 
 /* Do a read-only check of some metadata. */
-static enum check_outcome
+static int
 xfs_check_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
 	struct xfs_scrub_metadata	*meta,
-	bool				is_inode)
+	struct scrub_item		*sri)
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	enum xfrog_scrub_group		group;
@@ -106,17 +106,18 @@ xfs_check_metadata(
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
 		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
 		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_ABORT;
+		return ECANCELED;
 	case EDEADLOCK:
 	case EBUSY:
 	case EFSBADCRC:
@@ -124,13 +125,16 @@ _("Filesystem is shut down, aborting."));
 		/*
 		 * The first two should never escape the kernel,
 		 * and the other two should be reported via sm_flags.
+		 * Log it and move on.
 		 */
 		str_liberror(ctx, error, _("Kernel bug"));
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	default:
-		/* Operational error. */
+		/* Operational error.  Log it and move on. */
 		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_DONE;
+		scrub_item_clean_state(sri, meta->sm_type);
+		return 0;
 	}
 
 	/*
@@ -153,12 +157,16 @@ _("Filesystem is shut down, aborting."));
 	 */
 	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
+			/* Dry-run mode, so log an error and forget it. */
 			str_corrupt(ctx, descr_render(&dsc),
 _("Repairs are required."));
-			return CHECK_DONE;
+			scrub_item_clean_state(sri, meta->sm_type);
+			return 0;
 		}
 
-		return CHECK_REPAIR;
+		/* Schedule repairs. */
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
 	}
 
 	/*
@@ -167,6 +175,7 @@ _("Repairs are required."));
 	 */
 	if (is_unoptimized(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
+			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
 				str_info(ctx, descr_render(&dsc),
@@ -178,10 +187,13 @@ _("Optimization is possible."));
 					ctx->preen_triggers[meta->sm_type] = true;
 				pthread_mutex_unlock(&ctx->lock);
 			}
-			return CHECK_DONE;
+			scrub_item_clean_state(sri, meta->sm_type);
+			return 0;
 		}
 
-		return CHECK_REPAIR;
+		/* Schedule optimizations. */
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
 	}
 
 	/*
@@ -191,11 +203,14 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR)
-		return CHECK_REPAIR;
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		return 0;
+	}
 
 	/* Everything is ok. */
-	return CHECK_DONE;
+	scrub_item_clean_state(sri, meta->sm_type);
+	return 0;
 }
 
 /* Bulk-notify user about things that could be optimized. */
@@ -235,7 +250,7 @@ scrub_meta_type(
 	struct xfs_scrub_metadata	meta = {
 		.sm_type		= type,
 	};
-	enum check_outcome		fix;
+	int				error;
 
 	background_sleep();
 
@@ -256,24 +271,12 @@ scrub_meta_type(
 	}
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, xfdp, &meta, false);
+	error = xfs_check_metadata(ctx, xfdp, &meta, sri);
 
 	if (xfrog_scrubbers[type].group != XFROG_SCRUB_GROUP_INODE)
 		progress_add(1);
 
-	switch (fix) {
-	case CHECK_ABORT:
-		return ECANCELED;
-	case CHECK_REPAIR:
-		scrub_item_save_state(sri, type, meta.sm_flags);
-		return 0;
-	case CHECK_DONE:
-		scrub_item_clean_state(sri, type);
-		return 0;
-	default:
-		/* CHECK_RETRY should never happen. */
-		abort();
-	}
+	return error;
 }
 
 /* Schedule scrub for all metadata of a given group. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 1c24b054fd9..797b872246d 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -8,14 +8,6 @@
 
 enum xfrog_scrub_group;
 
-/* Online scrub and repair. */
-enum check_outcome {
-	CHECK_DONE,	/* no further processing needed */
-	CHECK_REPAIR,	/* schedule this for repairs */
-	CHECK_ABORT,	/* end program */
-	CHECK_RETRY,	/* repair failed, try again later */
-};
-
 /*
  * This flag boosts the repair priority of a scrub item when a dependent scrub
  * item is scheduled for repair.  Use a separate flag to preserve the

