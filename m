Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCD1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbiLaD0X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:26:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3B1112C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEC561C7A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196B6C433EF;
        Sat, 31 Dec 2022 03:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457180;
        bh=4IVIFHBL/bI1p9WCFI+DozXklhDsSRsVYDN5VPF9AYE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bt/KFgrJKb8GB69YclFInR98Xe8FtMnm0QFXJroAJAkYwdq0+lSZ+37XxgePFx18b
         d2+wlay5qB00zKomgMypjFVYC6ebEHcWqdQP7M4YySkiyxkPT2eiBq7pN4OY2UQIxA
         luTe2q/g1MMsQ+VTeENZYLWjt0Cx9cyg/EfxkNtYBEjiRvfCB4Y8Qdkkhx2fdj3JzU
         lTlqpvBvz88eGtXCGTgFBwBw0hQ2zAuQBD6L9I275aex9G2n6XycB8jl/2DpxgnoLS
         NIeOo3WU2zUbGjW+QJxbYtPo/WyAwVs/8CTa7I9Z1yqHG+4XinOL4ThysfmSiGIc1u
         nnzvFrAe1GOVA==
Subject: [PATCH 06/11] xfs_scrub: split the repair epilogue code into a
 separate function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884112.739244.14416993847913051461.stgit@magnolia>
In-Reply-To: <167243884029.739244.16777239536975047510.stgit@magnolia>
References: <167243884029.739244.16777239536975047510.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the code that updates the internal state in response to a
repair ioctl() call completion into a separate function.  This will help
with vectorizing repair calls later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   61 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 20 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index cd652dc85a1..4d8552cf9d0 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -20,6 +20,11 @@
 #include "descr.h"
 #include "scrub_private.h"
 
+static int repair_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
+		struct scrub_item *sri, unsigned int repair_flags,
+		struct xfs_scrub_metadata *oldm,
+		struct xfs_scrub_metadata *meta, int error);
+
 /* General repair routines. */
 
 /*
@@ -142,6 +147,22 @@ xfs_repair_metadata(
 				_("Attempting optimization."));
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
+	return repair_epilogue(ctx, &dsc, sri, repair_flags, &oldm, &meta,
+			error);
+}
+
+static int
+repair_epilogue(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	struct scrub_item		*sri,
+	unsigned int			repair_flags,
+	struct xfs_scrub_metadata	*oldm,
+	struct xfs_scrub_metadata	*meta,
+	int				error)
+{
+	unsigned int			scrub_type = meta->sm_type;
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
@@ -150,12 +171,12 @@ xfs_repair_metadata(
 	case EBUSY:
 		/* Filesystem is busy, try again later. */
 		if (debug || verbose)
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
 _("Filesystem is busy, deferring repair."));
 		return 0;
 	case ESHUTDOWN:
 		/* Filesystem is already shut down, abort. */
-		str_error(ctx, descr_render(&dsc),
+		str_error(ctx, descr_render(dsc),
 _("Filesystem is shut down, aborting."));
 		return ECANCELED;
 	case ENOTTY:
@@ -174,7 +195,7 @@ _("Filesystem is shut down, aborting."));
 		 * If we forced repairs or this is a preen, don't
 		 * error out if the kernel doesn't know how to fix.
 		 */
-		if (is_unoptimized(&oldm) ||
+		if (is_unoptimized(oldm) ||
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
@@ -182,14 +203,14 @@ _("Filesystem is shut down, aborting."));
 		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */
-		str_corrupt(ctx, descr_render(&dsc),
+		str_corrupt(ctx, descr_render(dsc),
 _("Don't know how to fix; offline repair required."));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
-		if (verbose || debug || needs_repair(&oldm))
-			str_error(ctx, descr_render(&dsc),
+		if (verbose || debug || needs_repair(oldm))
+			str_error(ctx, descr_render(dsc),
 _("Read-only filesystem; cannot make changes."));
 		return ECANCELED;
 	case ENOENT:
@@ -199,7 +220,7 @@ _("Read-only filesystem; cannot make changes."));
 	case ENOMEM:
 	case ENOSPC:
 		/* Don't care if preen fails due to low resources. */
-		if (is_unoptimized(&oldm) && !needs_repair(&oldm)) {
+		if (is_unoptimized(oldm) && !needs_repair(oldm)) {
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
@@ -214,7 +235,7 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
 			return 0;
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
@@ -225,12 +246,12 @@ _("Read-only filesystem; cannot make changes."));
 	 * the repair again, just in case the fs was busy.  Only retry so many
 	 * times.
 	 */
-	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+	if (want_retry(meta) && scrub_item_schedule_retry(sri, scrub_type))
 		return 0;
 
 	if (repair_flags & XRM_FINAL_WARNING)
-		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta) || is_incomplete(&meta)) {
+		scrub_warn_incomplete_scrub(ctx, dsc, meta);
+	if (needs_repair(meta) || is_incomplete(meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
 		 * just requeue this and try again later.  Otherwise we
@@ -238,9 +259,9 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
 			return 0;
-		str_corrupt(ctx, descr_render(&dsc),
+		str_corrupt(ctx, descr_render(dsc),
  _("Repair unsuccessful; offline repair required."));
-	} else if (xref_failed(&meta)) {
+	} else if (xref_failed(meta)) {
 		/*
 		 * This metadata object itself looks ok, but we still noticed
 		 * inconsistencies when comparing it with the other filesystem
@@ -249,25 +270,25 @@ _("Read-only filesystem; cannot make changes."));
 		 * reverify the cross-referencing as repairs progress.
 		 */
 		if (repair_flags & XRM_FINAL_WARNING) {
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
  _("Seems correct but cross-referencing failed; offline repair recommended."));
 		} else {
 			if (verbose)
-				str_info(ctx, descr_render(&dsc),
+				str_info(ctx, descr_render(dsc),
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return 0;
 		}
-	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+	} else if (meta->sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
-			str_info(ctx, descr_render(&dsc),
+			str_info(ctx, descr_render(dsc),
 					_("No modification needed."));
 	} else {
 		/* Clean operation, no corruption detected. */
-		if (needs_repair(&oldm))
-			record_repair(ctx, descr_render(&dsc),
+		if (needs_repair(oldm))
+			record_repair(ctx, descr_render(dsc),
 					_("Repairs successful."));
 		else
-			record_preen(ctx, descr_render(&dsc),
+			record_preen(ctx, descr_render(dsc),
 					_("Optimization successful."));
 	}
 

