Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BC4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiLaD0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:26:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CA32DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:26:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4937C612E3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C06C433EF;
        Sat, 31 Dec 2022 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457195;
        bh=FLPg68dFqVZsYvxVTJo5uuABz38w9exOZkak41dK7zs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qy09x6PfvD4Dvz9fY++YJaRRAe4V9gVJv2lCN7GQU/YJ2hTTtLarYbr8oEXNq2axW
         9pOa3V8ZDtAHLG4tU4rByWrA0CwCFJzqh/BED1MFbjykPwobSUyS3xalBJwNDGSUCr
         L+Q4Zu/PZKujI2Qbpzsko2Z0jf4DEJTFrn8TXFXJOvk6osxO46LE0dv2VfEgedXZ8o
         5NWue2csXLn7KtTN8dssswHdPRSRyyxw8W8Gt1nRGGU/V5lT2qdlKuDtVZYPP0dxAQ
         RuRyfnUlvOPVdlAQ4FvhegZCThVq7dF579yKCkMKNFpBRZ4HmpzY8oeML01aNWaJQe
         2ogkYOw13H5Fw==
Subject: [PATCH 07/11] xfs_scrub: convert scrub and repair epilogues to use
 xfs_scrub_vec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884126.739244.10663679183976658897.stgit@magnolia>
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

Convert the scrub and repair epilogue code to pass around xfs_scrub_vecs
as we prepare for vectorized operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   35 ++++++++++++++++++-----------------
 scrub/scrub.c         |   27 ++++++++++++++-------------
 scrub/scrub_private.h |   34 +++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 47 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 4d8552cf9d0..7c4fc6143f0 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -22,8 +22,8 @@
 
 static int repair_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
 		struct scrub_item *sri, unsigned int repair_flags,
-		struct xfs_scrub_metadata *oldm,
-		struct xfs_scrub_metadata *meta, int error);
+		const struct xfs_scrub_vec *oldm,
+		const struct xfs_scrub_vec *meta);
 
 /* General repair routines. */
 
@@ -101,10 +101,9 @@ xfs_repair_metadata(
 	unsigned int			repair_flags)
 {
 	struct xfs_scrub_metadata	meta = { 0 };
-	struct xfs_scrub_metadata	oldm;
+	struct xfs_scrub_vec		oldm, vec;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
-	int				error;
 
 	/*
 	 * If the caller boosted the priority of this scrub type on behalf of a
@@ -133,22 +132,24 @@ xfs_repair_metadata(
 		break;
 	}
 
-	if (!is_corrupt(&meta) && repair_only)
+	vec.sv_type = scrub_type;
+	vec.sv_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
+	memcpy(&oldm, &vec, sizeof(struct xfs_scrub_vec));
+	if (!is_corrupt(&vec) && repair_only)
 		return 0;
 
-	memcpy(&oldm, &meta, sizeof(oldm));
-	oldm.sm_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
-	descr_set(&dsc, &oldm);
+	descr_set(&dsc, &meta);
 
-	if (needs_repair(&oldm))
+	if (needs_repair(&vec))
 		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
 	else if (debug || verbose)
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-	error = -xfrog_scrub_metadata(xfdp, &meta);
-	return repair_epilogue(ctx, &dsc, sri, repair_flags, &oldm, &meta,
-			error);
+	vec.sv_ret = xfrog_scrub_metadata(xfdp, &meta);
+	vec.sv_flags = meta.sm_flags;
+
+	return repair_epilogue(ctx, &dsc, sri, repair_flags, &oldm, &vec);
 }
 
 static int
@@ -157,11 +158,11 @@ repair_epilogue(
 	struct descr			*dsc,
 	struct scrub_item		*sri,
 	unsigned int			repair_flags,
-	struct xfs_scrub_metadata	*oldm,
-	struct xfs_scrub_metadata	*meta,
-	int				error)
+	const struct xfs_scrub_vec	*oldm,
+	const struct xfs_scrub_vec	*meta)
 {
-	unsigned int			scrub_type = meta->sm_type;
+	unsigned int			scrub_type = meta->sv_type;
+	int				error = -meta->sv_ret;
 
 	switch (error) {
 	case 0:
@@ -278,7 +279,7 @@ _("Read-only filesystem; cannot make changes."));
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return 0;
 		}
-	} else if (meta->sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+	} else if (meta->sv_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
 			str_info(ctx, descr_render(dsc),
 					_("No modification needed."));
diff --git a/scrub/scrub.c b/scrub/scrub.c
index b102a457cc2..37cc97cdfda 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -23,8 +23,7 @@
 #include "scrub_private.h"
 
 static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
-		struct scrub_item *sri, struct xfs_scrub_metadata *meta,
-		int error);
+		struct scrub_item *sri, struct xfs_scrub_vec *vec);
 
 /* Online scrub and repair wrappers. */
 
@@ -65,7 +64,7 @@ void
 scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
-	struct xfs_scrub_metadata	*meta)
+	const struct xfs_scrub_vec	*meta)
 {
 	if (is_incomplete(meta))
 		str_info(ctx, descr_render(dsc), _("Check incomplete."));
@@ -94,8 +93,8 @@ xfs_check_metadata(
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	struct xfs_scrub_metadata	meta = { };
+	struct xfs_scrub_vec		vec;
 	enum xfrog_scrub_group		group;
-	int				error;
 
 	background_sleep();
 
@@ -124,8 +123,10 @@ xfs_check_metadata(
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
-	error = -xfrog_scrub_metadata(xfdp, &meta);
-	return scrub_epilogue(ctx, &dsc, sri, &meta, error);
+	vec.sv_ret = xfrog_scrub_metadata(xfdp, &meta);
+	vec.sv_type = scrub_type;
+	vec.sv_flags = meta.sm_flags;
+	return scrub_epilogue(ctx, &dsc, sri, &vec);
 }
 
 /*
@@ -137,11 +138,11 @@ scrub_epilogue(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
 	struct scrub_item		*sri,
-	struct xfs_scrub_metadata	*meta,
-	int				error)
+	struct xfs_scrub_vec		*meta)
 {
-	unsigned int			scrub_type = meta->sm_type;
+	unsigned int			scrub_type = meta->sv_type;
 	enum xfrog_scrub_group		group;
+	int				error = -meta->sv_ret;
 
 	group = xfrog_scrubbers[scrub_type].group;
 
@@ -150,7 +151,7 @@ scrub_epilogue(
 		/* No operational errors encountered. */
 		if (!sri->sri_revalidate &&
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			meta->sv_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
@@ -211,7 +212,7 @@ _("Repairs are required."));
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
@@ -238,7 +239,7 @@ _("Optimization is possible."));
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
@@ -250,7 +251,7 @@ _("Optimization is possible."));
 	 * deem it completely consistent at some point.
 	 */
 	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index c60ea555885..383bc17a567 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -13,40 +13,40 @@ int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
 
 /* Predicates for scrub flag state. */
 
-static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
+static inline bool is_corrupt(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_CORRUPT;
 }
 
-static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
+static inline bool is_unoptimized(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_PREEN;
 }
 
-static inline bool xref_failed(struct xfs_scrub_metadata *sm)
+static inline bool xref_failed(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_XFAIL;
 }
 
-static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
+static inline bool xref_disagrees(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_XCORRUPT;
 }
 
-static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
+static inline bool is_incomplete(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
 }
 
-static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
+static inline bool is_suspicious(const struct xfs_scrub_vec *sv)
 {
-	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
+	return sv->sv_flags & XFS_SCRUB_OFLAG_WARNING;
 }
 
 /* Should we fix it? */
-static inline bool needs_repair(struct xfs_scrub_metadata *sm)
+static inline bool needs_repair(const struct xfs_scrub_vec *sv)
 {
-	return is_corrupt(sm) || xref_disagrees(sm);
+	return is_corrupt(sv) || xref_disagrees(sv);
 }
 
 /*
@@ -54,13 +54,13 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
  * scan/repair; or if there were cross-referencing problems but the object was
  * not obviously corrupt.
  */
-static inline bool want_retry(struct xfs_scrub_metadata *sm)
+static inline bool want_retry(const struct xfs_scrub_vec *sv)
 {
-	return is_incomplete(sm) || (xref_disagrees(sm) && !is_corrupt(sm));
+	return is_incomplete(sv) || (xref_disagrees(sv) && !is_corrupt(sv));
 }
 
 void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
-		struct xfs_scrub_metadata *meta);
+		const struct xfs_scrub_vec *meta);
 
 /* Scrub item functions */
 

