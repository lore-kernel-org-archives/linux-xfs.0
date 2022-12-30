Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8538C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiLaD0H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:26:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6346112C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:26:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FFF961C7A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C6C433EF;
        Sat, 31 Dec 2022 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457164;
        bh=W/kKXhrJ7IGToBylBD4kRjqto5d63izvnyW9Pq6yoBQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s82BHKW2Qa3DHtMxEnRdsDSdUC5ls8hAnaL1Ygqd7bI/Ekw9OH6Tob0L3d8XFhHuS
         EUM/e9FxBheqaIsARdywlN1C54KZc+o7SH7aHlCOVXxUxbIoJ362o6xG/0WYo/yrMU
         /tvoZXj16PPH6nyX/SP/EnngpvDxrWurSF4OaRVgdrXGpK4qtXuaajQUM6z8zF3Jsm
         hRSGQngDOzCQZpMSFJOR/1uUstZIgeppg5Wdfby1DpnS3QH3q0u4S7UVxMBJJW2ZQr
         EH9wvlV//Zkkcff4LcgGb9JLBR7c989vGZ4tVHlrdWbiQcGRS2mleMWkkNWPbHizmy
         QzeChRAfrPVEg==
Subject: [PATCH 05/11] xfs_scrub: split the scrub epilogue code into a
 separate function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884099.739244.5199836162131265706.stgit@magnolia>
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

Move all the code that updates the internal state in response to a scrub
ioctl() call completion into a separate function.  This will help with
vectorizing scrub calls later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 14 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index a6d5ec056c8..b102a457cc2 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -22,6 +22,10 @@
 #include "descr.h"
 #include "scrub_private.h"
 
+static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
+		struct scrub_item *sri, struct xfs_scrub_metadata *meta,
+		int error);
+
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
@@ -121,12 +125,32 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
+	return scrub_epilogue(ctx, &dsc, sri, &meta, error);
+}
+
+/*
+ * Update all internal state after a scrub ioctl call.
+ * Returns 0 for success, or ECANCELED to abort the program.
+ */
+static int
+scrub_epilogue(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	struct scrub_item		*sri,
+	struct xfs_scrub_metadata	*meta,
+	int				error)
+{
+	unsigned int			scrub_type = meta->sm_type;
+	enum xfrog_scrub_group		group;
+
+	group = xfrog_scrubbers[scrub_type].group;
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
 		if (!sri->sri_revalidate &&
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
@@ -134,13 +158,13 @@ xfs_check_metadata(
 		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
-		str_error(ctx, descr_render(&dsc),
+		str_error(ctx, descr_render(dsc),
 _("Filesystem is shut down, aborting."));
 		return ECANCELED;
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		return ECANCELED;
 	case EDEADLOCK:
 	case EBUSY:
@@ -156,7 +180,7 @@ _("Filesystem is shut down, aborting."));
 		return 0;
 	default:
 		/* Operational error.  Log it and move on. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
@@ -167,27 +191,27 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+	if (want_retry(meta) && scrub_item_schedule_retry(sri, scrub_type))
 		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
-	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
+	scrub_warn_incomplete_scrub(ctx, dsc, meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
 	 * repair if desired, otherwise complain.
 	 */
-	if (is_corrupt(&meta) || xref_disagrees(&meta)) {
+	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
-			str_corrupt(ctx, descr_render(&dsc),
+			str_corrupt(ctx, descr_render(dsc),
 _("Repairs are required."));
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -195,12 +219,12 @@ _("Repairs are required."));
 	 * If we could optimize, schedule a repair if desired,
 	 * otherwise complain.
 	 */
-	if (is_unoptimized(&meta)) {
+	if (is_unoptimized(meta)) {
 		if (ctx->mode == SCRUB_MODE_DRY_RUN) {
 			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
-				str_info(ctx, descr_render(&dsc),
+				str_info(ctx, descr_render(dsc),
 _("Optimization is possible."));
 			} else if (!ctx->preen_triggers[scrub_type]) {
 				/* File metadata, only warn once per type. */
@@ -214,7 +238,7 @@ _("Optimization is possible."));
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -225,8 +249,8 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(&meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 

