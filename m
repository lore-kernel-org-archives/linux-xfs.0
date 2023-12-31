Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B5BC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAPHtO7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153C1C433C7;
	Sun, 31 Dec 2023 23:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064876;
	bh=sd58QA+xdwFy8ktarkAyrpavhOWVfkA/oM/SVGY+IKE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YAPHtO7LpnX/tYFOlUCsbZsCO3ey+eKhPENEtTYSoSw71vUZxO35d5HlrFiYGBTTx
	 I1vyTEtPbsfBbSWfl9P5H16ToS5qhrGAMyh31/d0/MUawBcXh5Z5juDE2FgUzYzbN6
	 dSHoIYIYWT4njhSkZ7StJ4XBDdgdO3WYMqCt5fLDH2gRr0cy9ddzpA68riv4qnfK8f
	 X7vkh2vXojQdEtKyErqBWLGs+hq89+HJF0tdlLuIBS6SDI3UcO8kvLz8SsU4LwlUDv
	 /KV3WCA/di5mrZT4HEHRfjiPVuSYZ+MKKcJRyyvFiDqhIxfC7aMl39g29xL2yPIlpf
	 T/a046q/BtSlA==
Date: Sun, 31 Dec 2023 15:21:15 -0800
Subject: [PATCH 06/10] xfs_scrub: convert scrub and repair epilogues to use
 xfs_scrub_vec
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007922.1806194.16626028776825292187.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
References: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index 0b99e335191..7a710a159e6 100644
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
 
@@ -93,10 +93,9 @@ xfs_repair_metadata(
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
@@ -124,22 +123,24 @@ xfs_repair_metadata(
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
@@ -148,11 +149,11 @@ repair_epilogue(
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
@@ -271,7 +272,7 @@ _("Repair unsuccessful; offline repair required."));
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return 0;
 		}
-	} else if (meta->sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+	} else if (meta->sv_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
 		if (verbose)
 			str_info(ctx, descr_render(dsc),
 					_("No modification needed."));
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c4b4367e458..2fb2293558e 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -23,8 +23,7 @@
 #include "scrub_private.h"
 
 static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
-		struct scrub_item *sri, struct xfs_scrub_metadata *meta,
-		int error);
+		struct scrub_item *sri, struct xfs_scrub_vec *vec);
 
 /* Online scrub and repair wrappers. */
 
@@ -62,7 +61,7 @@ void
 scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
-	struct xfs_scrub_metadata	*meta)
+	const struct xfs_scrub_vec	*meta)
 {
 	if (is_incomplete(meta))
 		str_info(ctx, descr_render(dsc), _("Check incomplete."));
@@ -91,8 +90,8 @@ xfs_check_metadata(
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	struct xfs_scrub_metadata	meta = { };
+	struct xfs_scrub_vec		vec;
 	enum xfrog_scrub_group		group;
-	int				error;
 
 	background_sleep();
 
@@ -120,8 +119,10 @@ xfs_check_metadata(
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
-	error = -xfrog_scrub_metadata(xfdp, &meta);
-	return scrub_epilogue(ctx, &dsc, sri, &meta, error);
+	vec.sv_ret = xfrog_scrub_metadata(xfdp, &meta);
+	vec.sv_type = scrub_type;
+	vec.sv_flags = meta.sm_flags;
+	return scrub_epilogue(ctx, &dsc, sri, &vec);
 }
 
 /*
@@ -133,11 +134,11 @@ scrub_epilogue(
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
 
@@ -146,7 +147,7 @@ scrub_epilogue(
 		/* No operational errors encountered. */
 		if (!sri->sri_revalidate &&
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			meta->sv_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
@@ -207,7 +208,7 @@ _("Repairs are required."));
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
@@ -234,7 +235,7 @@ _("Optimization is possible."));
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
@@ -246,7 +247,7 @@ _("Optimization is possible."));
 	 * deem it completely consistent at some point.
 	 */
 	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sv_flags);
 		return 0;
 	}
 
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index bcfabda16be..98a9238f2aa 100644
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
 

