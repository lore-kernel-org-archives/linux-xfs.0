Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370FBC53210
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiLaAaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiLaAaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:30:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A098E1EAD5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E2F561D4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A64AC433D2;
        Sat, 31 Dec 2022 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446622;
        bh=EECEGy1bNpmFzXRQoZ9ZNgn0ECzP2sK+ngabsdLPi4w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K/SjfdmDyRNv5ELMHmTQcbYi6LkIwgPJNHarZxsKta+M4GrHLvc/2VIQrxvLKccu/
         tV4hWAuXbumkWx4zt4zfIhFOnMyJlDMj/hj/RLVVCacublWq+hiqKO8eQhz5bBStyx
         PGMCMUGCT9Upr2OY9xDwYI+Ts8MW3Bbg6yBc5w7xH6nmbez9CWPOYV+nE0deTMqF1s
         HF+gtq1SfiRsdVnlevfKfuNrjYKPsqSA3fA6IhLxkVBj2fn7Cn1GIdu3g+dLYrvZlS
         xd7qn2iwRae1EGr3RhfMoZE1NOImdEPsDVMN2G4o8/Bmvtu9rQNiWG82n7/luAo/eb
         c0fYE44+tPACw==
Subject: [PATCH 3/5] xfs_scrub: refactor scrub_meta_type out of existence
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870140.716382.10039594047134474291.stgit@magnolia>
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

Remove this helper function since it's trivial now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |  124 ++++++++++++++++++++++++---------------------------------
 1 file changed, 53 insertions(+), 71 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index da49285be78..ccc6a7a4047 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -82,31 +82,51 @@ static int
 xfs_check_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
-	struct xfs_scrub_metadata	*meta,
+	unsigned int			scrub_type,
 	struct scrub_item		*sri)
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
+	struct xfs_scrub_metadata	meta = { };
 	enum xfrog_scrub_group		group;
 	unsigned int			tries = 0;
 	int				error;
 
-	group = xfrog_scrubbers[meta->sm_type].group;
+	background_sleep();
+
+	group = xfrog_scrubbers[scrub_type].group;
+	meta.sm_type = scrub_type;
+	switch (group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		meta.sm_agno = sri->sri_agno;
+		break;
+	case XFROG_SCRUB_GROUP_METAFILES:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+	case XFROG_SCRUB_GROUP_NONE:
+		break;
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = sri->sri_ino;
+		meta.sm_gen = sri->sri_gen;
+		break;
+	}
+
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	descr_set(&dsc, meta);
+	assert(scrub_type < XFS_SCRUB_TYPE_NR);
+	descr_set(&dsc, &meta);
 
-	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
+	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 retry:
-	error = -xfrog_scrub_metadata(xfdp, meta);
+	error = -xfrog_scrub_metadata(xfdp, &meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
-		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
-		scrub_item_clean_state(sri, meta->sm_type);
+		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
@@ -128,12 +148,12 @@ _("Filesystem is shut down, aborting."));
 		 * Log it and move on.
 		 */
 		str_liberror(ctx, error, _("Kernel bug"));
-		scrub_item_clean_state(sri, meta->sm_type);
+		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	default:
 		/* Operational error.  Log it and move on. */
 		str_liberror(ctx, error, descr_render(&dsc));
-		scrub_item_clean_state(sri, meta->sm_type);
+		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
 
@@ -143,29 +163,29 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(meta) && tries < 10) {
+	if (want_retry(&meta) && tries < 10) {
 		tries++;
 		goto retry;
 	}
 
 	/* Complain about incomplete or suspicious metadata. */
-	scrub_warn_incomplete_scrub(ctx, &dsc, meta);
+	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
 	 * repair if desired, otherwise complain.
 	 */
-	if (is_corrupt(meta) || xref_disagrees(meta)) {
+	if (is_corrupt(&meta) || xref_disagrees(&meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
 			str_corrupt(ctx, descr_render(&dsc),
 _("Repairs are required."));
-			scrub_item_clean_state(sri, meta->sm_type);
+			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
 		return 0;
 	}
 
@@ -173,26 +193,26 @@ _("Repairs are required."));
 	 * If we could optimize, schedule a repair if desired,
 	 * otherwise complain.
 	 */
-	if (is_unoptimized(meta)) {
+	if (is_unoptimized(&meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
 				str_info(ctx, descr_render(&dsc),
 _("Optimization is possible."));
-			} else if (!ctx->preen_triggers[meta->sm_type]) {
+			} else if (!ctx->preen_triggers[scrub_type]) {
 				/* File metadata, only warn once per type. */
 				pthread_mutex_lock(&ctx->lock);
-				if (!ctx->preen_triggers[meta->sm_type])
-					ctx->preen_triggers[meta->sm_type] = true;
+				if (!ctx->preen_triggers[scrub_type])
+					ctx->preen_triggers[scrub_type] = true;
 				pthread_mutex_unlock(&ctx->lock);
 			}
-			scrub_item_clean_state(sri, meta->sm_type);
+			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
 		return 0;
 	}
 
@@ -203,13 +223,13 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, meta->sm_type, meta->sm_flags);
+	if (xref_failed(&meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
 		return 0;
 	}
 
 	/* Everything is ok. */
-	scrub_item_clean_state(sri, meta->sm_type);
+	scrub_item_clean_state(sri, scrub_type);
 	return 0;
 }
 
@@ -233,52 +253,6 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 	}
 }
 
-/*
- * Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later.
- * Do not call this function to repair file metadata.
- *
- * Returns 0 for success.  If errors occur, this function will log them and
- * return a positive error code.
- */
-static int
-scrub_meta_type(
-	struct scrub_ctx		*ctx,
-	struct xfs_fd			*xfdp,
-	unsigned int			type,
-	struct scrub_item		*sri)
-{
-	struct xfs_scrub_metadata	meta = {
-		.sm_type		= type,
-	};
-	int				error;
-
-	background_sleep();
-
-	switch (xfrog_scrubbers[type].group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = sri->sri_agno;
-		break;
-	case XFROG_SCRUB_GROUP_METAFILES:
-	case XFROG_SCRUB_GROUP_SUMMARY:
-	case XFROG_SCRUB_GROUP_ISCAN:
-	case XFROG_SCRUB_GROUP_NONE:
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = sri->sri_ino;
-		meta.sm_gen = sri->sri_gen;
-		break;
-	}
-
-	/* Check the item. */
-	error = xfs_check_metadata(ctx, xfdp, &meta, sri);
-
-	if (xfrog_scrubbers[type].group != XFROG_SCRUB_GROUP_INODE)
-		progress_add(1);
-
-	return error;
-}
-
 /* Schedule scrub for all metadata of a given group. */
 void
 scrub_item_schedule_group(
@@ -321,7 +295,15 @@ scrub_item_check_file(
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
 
-		error = scrub_meta_type(ctx, xfdp, scrub_type, sri);
+		error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+
+		/*
+		 * Progress is counted by the inode for inode metadata; for
+		 * everything else, it's counted for each scrub call.
+		 */
+		if (sri->sri_ino == -1ULL)
+			progress_add(1);
+
 		if (error)
 			break;
 	}

