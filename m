Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11286AA7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303098; cv=none; b=EZ2domLySzGRiNSrH34oSSeB8V/qna7gq9fYZ8GDWAFjMgiU75ZPo7G2xMNgWV+nlzlPtoj1/E+38LOjaWjN4hAA4+H7dC58rugA9OJUruCDkzuzqIyviT04yCCCnZjKHhc2SmB5q62PnLMkVfloopgJ4HPZmSXDvEBUbPfRrwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303098; c=relaxed/simple;
	bh=cV/WrfbniphVNpYgN1MDqKooakHCt6C1VTJ2OOcWz4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIUVF7vf+uSYbXV4Jo90dxdRkETKbx9D1pfBDHwApxxHzQUSPC6Unzohe4U/HLqSKuX7pEuzY4h2+HIjakFmcyxitzsPKAOgmZmYGIGMb69GyQu88lO8CWleK6cAWDkpRqEFOwsQFnujw3bM/Qcmt6dwfpVkOoSkdx9eUYTN2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNCJz1Pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNCJz1Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573F3C4AF07;
	Tue, 30 Jul 2024 01:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303098;
	bh=cV/WrfbniphVNpYgN1MDqKooakHCt6C1VTJ2OOcWz4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tNCJz1Pb7JULUxgCIyHvosbSffQ2acK6Rt/DsLEiBDmEiSudvYxQ5cvua5X1+ZtHN
	 LhCdSspinPwwNd1+OvlR8pJmPSPo7l6o7XE6U0/7tKmkIvlWPe0a4Q3uf8Ig+r5k7X
	 H6ZfaBvJFJMfSLV2bT74UPRmrBOFyUU2F8aGFCVTiZZClNL76osfJaREfZz5dFZP1s
	 ggAfJtyeVtqsaoVrEp2egPKXhB2XtrOXD9vPTCI4eAwcimfIvx4EN3O7R7fqhdMMLf
	 CiCr3KJ/fkDnFYsfTGenPjfyXL4n1rBFtWiEz5Y4OV33QC7ZHWk1Shtzb0KlwFyO2i
	 HCX4/SuYEp1jQ==
Date: Mon, 29 Jul 2024 18:31:37 -0700
Subject: [PATCH 06/10] xfs_scrub: convert scrub and repair epilogues to use
 xfs_scrub_vec
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852436.1353240.13074822861769407704.stgit@frogsfrogsfrogs>
In-Reply-To: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
References: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c        |   35 ++++++++++++++++++-----------------
 scrub/scrub.c         |   27 ++++++++++++++-------------
 scrub/scrub_private.h |   34 +++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 47 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 0b99e3351..7a710a159 100644
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
index c4b4367e4..2fb229355 100644
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
index bcfabda16..98a9238f2 100644
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
 

