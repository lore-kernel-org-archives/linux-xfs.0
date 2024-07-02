Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3E84A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883440; cv=none; b=S3XcWPaBTxJGYHzPq9mfZPWFSHbFDKORwBKaHYimqNuFojoxZgx5sVXbMA4WvIIAhYmc/yG/NSVHOD1BU1tgWSXVmaQtpP6a3uEk/YSeB+cpypSEqGGvI+cP4fskfbGYfzAFbDbS6DVomaB10hSXy9fH6vMsUIHVG+84OSkMRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883440; c=relaxed/simple;
	bh=arcBTRK+D+nffItIq3REb2sVedMxpr+4mqp/9Yu2qwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LMsOvxbfBhn/RpviMo6yhTzLU/1TzPsJTZY9H2hbtDzx15fh+2MHZnQwphd6amquUiwHkLgZfY2O7PNKUPyvKRjnVh7SPTgaB5vKA3FtlndZ5u+50QmUKWru1b8ugZ5zFbMiIK0IwoCpYqOB6VrM4HpQwieuqiNmiFXElREpPS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esNZ4c1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esNZ4c1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D2CC116B1;
	Tue,  2 Jul 2024 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883439;
	bh=arcBTRK+D+nffItIq3REb2sVedMxpr+4mqp/9Yu2qwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=esNZ4c1lQAkjx6HydqloGHSvZh0aVx/GG2H3F9pySyk5Redyu4ydfFo0ndELYbILq
	 8JZBzLgwW2FeJU6pgY2jx/eVsZuK0GaLLvtw6uCASMKGMwMKcyQ4P/0klpiTcwoNbp
	 iVzhgAKxCgHdj++e1Wdh3Cbdcv4GFwNHcCgbsSJvLuczG5+tcKi1bpfai/FCEBP3dR
	 37ApbvPHKqm5dXLETpAacy/hGjrLef9brJltjWYW39+UWE4gBQBdjtoI6Dn6n+1tj3
	 ArFT48kbONVVFMTMg2EM1Q5RTh3779lUPeBq8D1AHG98X/JSw8qn938zGRWneBVQzM
	 B5OcaqoYdDkWQ==
Date: Mon, 01 Jul 2024 18:23:59 -0700
Subject: [PATCH 08/10] xfs_scrub: vectorize repair calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123257.2012546.6149607312591068968.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
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

Use the new vectorized scrub kernel calls to reduce the overhead of
performing repairs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |  268 +++++++++++++++++++++++++++----------------------
 scrub/scrub.c         |   77 +++-----------
 scrub/scrub_private.h |    9 +-
 3 files changed, 166 insertions(+), 188 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 7a710a159e69..6a5fd40fd02f 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -20,11 +20,6 @@
 #include "descr.h"
 #include "scrub_private.h"
 
-static int repair_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
-		struct scrub_item *sri, unsigned int repair_flags,
-		const struct xfs_scrub_vec *oldm,
-		const struct xfs_scrub_vec *meta);
-
 /* General repair routines. */
 
 /*
@@ -83,64 +78,14 @@ repair_want_service_downgrade(
 	return false;
 }
 
-/* Repair some metadata. */
-static int
-xfs_repair_metadata(
-	struct scrub_ctx		*ctx,
-	struct xfs_fd			*xfdp,
-	unsigned int			scrub_type,
-	struct scrub_item		*sri,
-	unsigned int			repair_flags)
+static inline void
+restore_oldvec(
+	struct xfs_scrub_vec	*oldvec,
+	const struct scrub_item	*sri,
+	unsigned int		scrub_type)
 {
-	struct xfs_scrub_metadata	meta = { 0 };
-	struct xfs_scrub_vec		oldm, vec;
-	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
-	bool				repair_only;
-
-	/*
-	 * If the caller boosted the priority of this scrub type on behalf of a
-	 * higher level repair by setting IFLAG_REPAIR, turn off REPAIR_ONLY.
-	 */
-	repair_only = (repair_flags & XRM_REPAIR_ONLY) &&
-			scrub_item_type_boosted(sri, scrub_type);
-
-	assert(scrub_type < XFS_SCRUB_TYPE_NR);
-	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	meta.sm_type = scrub_type;
-	meta.sm_flags = XFS_SCRUB_IFLAG_REPAIR;
-	if (use_force_rebuild)
-		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
-	switch (xfrog_scrubbers[scrub_type].group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = sri->sri_agno;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = sri->sri_ino;
-		meta.sm_gen = sri->sri_gen;
-		break;
-	default:
-		break;
-	}
-
-	vec.sv_type = scrub_type;
-	vec.sv_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
-	memcpy(&oldm, &vec, sizeof(struct xfs_scrub_vec));
-	if (!is_corrupt(&vec) && repair_only)
-		return 0;
-
-	descr_set(&dsc, &meta);
-
-	if (needs_repair(&vec))
-		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
-	else if (debug || verbose)
-		str_info(ctx, descr_render(&dsc),
-				_("Attempting optimization."));
-
-	vec.sv_ret = xfrog_scrub_metadata(xfdp, &meta);
-	vec.sv_flags = meta.sm_flags;
-
-	return repair_epilogue(ctx, &dsc, sri, repair_flags, &oldm, &vec);
+	oldvec->sv_type = scrub_type;
+	oldvec->sv_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
 }
 
 static int
@@ -149,12 +94,15 @@ repair_epilogue(
 	struct descr			*dsc,
 	struct scrub_item		*sri,
 	unsigned int			repair_flags,
-	const struct xfs_scrub_vec	*oldm,
 	const struct xfs_scrub_vec	*meta)
 {
+	struct xfs_scrub_vec		oldv;
+	struct xfs_scrub_vec		*oldm = &oldv;
 	unsigned int			scrub_type = meta->sv_type;
 	int				error = -meta->sv_ret;
 
+	restore_oldvec(oldm, sri, meta->sv_type);
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
@@ -296,6 +244,133 @@ _("Repair unsuccessful; offline repair required."));
 	return 0;
 }
 
+/* Decide if the dependent scrub types of the given scrub type are ok. */
+static bool
+repair_item_dependencies_ok(
+	const struct scrub_item	*sri,
+	unsigned int		scrub_type)
+{
+	unsigned int		dep_mask = repair_deps[scrub_type];
+	unsigned int		b;
+
+	for (b = 0; dep_mask && b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
+		if (!(dep_mask & 1))
+			continue;
+		/*
+		 * If this lower level object also needs repair, we can't fix
+		 * the higher level item.
+		 */
+		if (sri->sri_state[b] & SCRUB_ITEM_NEEDSREPAIR)
+			return false;
+	}
+
+	return true;
+}
+
+/* Decide if we want to repair a particular type of metadata. */
+static bool
+can_repair_now(
+	const struct scrub_item	*sri,
+	unsigned int		scrub_type,
+	__u32			repair_mask,
+	unsigned int		repair_flags)
+{
+	struct xfs_scrub_vec	oldvec;
+	bool			repair_only;
+
+	/* Do we even need to repair this thing? */
+	if (!(sri->sri_state[scrub_type] & repair_mask))
+		return false;
+
+	restore_oldvec(&oldvec, sri, scrub_type);
+
+	/*
+	 * If the caller boosted the priority of this scrub type on behalf of a
+	 * higher level repair by setting IFLAG_REPAIR, ignore REPAIR_ONLY.
+	 */
+	repair_only = (repair_flags & XRM_REPAIR_ONLY) &&
+		      !(sri->sri_state[scrub_type] & SCRUB_ITEM_BOOST_REPAIR);
+	if (!is_corrupt(&oldvec) && repair_only)
+		return false;
+
+	/*
+	 * Don't try to repair higher level items if their lower-level
+	 * dependencies haven't been verified, unless this is our last chance
+	 * to fix things without complaint.
+	 */
+	if (!(repair_flags & XRM_FINAL_WARNING) &&
+	    !repair_item_dependencies_ok(sri, scrub_type))
+		return false;
+
+	return true;
+}
+
+/*
+ * Repair some metadata.
+ *
+ * Returns 0 for success (or repair item deferral), or ECANCELED to abort the
+ * program.
+ */
+static int
+repair_call_kernel(
+	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
+	struct scrub_item		*sri,
+	__u32				repair_mask,
+	unsigned int			repair_flags)
+{
+	DEFINE_DESCR(dsc, ctx, format_scrubv_descr);
+	struct xfrog_scrubv		scrubv = { };
+	struct scrubv_descr		vdesc = SCRUBV_DESCR(&scrubv);
+	struct xfs_scrub_vec		*v;
+	unsigned int			scrub_type;
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+
+	xfrog_scrubv_from_item(&scrubv, sri);
+	descr_set(&dsc, &vdesc);
+
+	foreach_scrub_type(scrub_type) {
+		if (scrub_excessive_errors(ctx))
+			return ECANCELED;
+
+		if (!can_repair_now(sri, scrub_type, repair_mask,
+					repair_flags))
+			continue;
+
+		xfrog_scrubv_add_item(&scrubv, sri, scrub_type, true);
+
+		if (sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSREPAIR)
+			str_info(ctx, descr_render(&dsc),
+					_("Attempting repair."));
+		else if (debug || verbose)
+			str_info(ctx, descr_render(&dsc),
+					_("Attempting optimization."));
+
+		dbg_printf("repair %s flags %xh tries %u\n", descr_render(&dsc),
+				sri->sri_state[scrub_type],
+				sri->sri_tries[scrub_type]);
+	}
+
+	error = -xfrog_scrubv_metadata(xfdp, &scrubv);
+	if (error)
+		return error;
+
+	foreach_xfrog_scrubv_vec(&scrubv, vdesc.idx, v) {
+		error = repair_epilogue(ctx, &dsc, sri, repair_flags, v);
+		if (error)
+			return error;
+
+		/* Maybe update progress if we fixed the problem. */
+		if (!(repair_flags & XRM_NOPROGRESS) &&
+		    !(sri->sri_state[v->sv_type] & SCRUB_ITEM_REPAIR_ANY))
+			progress_add(1);
+	}
+
+	return 0;
+}
+
 /*
  * Prioritize action items in order of how long we can wait.
  *
@@ -632,29 +707,6 @@ action_list_process(
 	return ret;
 }
 
-/* Decide if the dependent scrub types of the given scrub type are ok. */
-static bool
-repair_item_dependencies_ok(
-	const struct scrub_item	*sri,
-	unsigned int		scrub_type)
-{
-	unsigned int		dep_mask = repair_deps[scrub_type];
-	unsigned int		b;
-
-	for (b = 0; dep_mask && b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
-		if (!(dep_mask & 1))
-			continue;
-		/*
-		 * If this lower level object also needs repair, we can't fix
-		 * the higher level item.
-		 */
-		if (sri->sri_state[b] & SCRUB_ITEM_NEEDSREPAIR)
-			return false;
-	}
-
-	return true;
-}
-
 /*
  * For a given filesystem object, perform all repairs of a given class
  * (corrupt, xcorrupt, xfail, preen) if the repair item says it's needed.
@@ -670,13 +722,14 @@ repair_item_class(
 	struct xfs_fd			xfd;
 	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
-	unsigned int			scrub_type;
 	int				error = 0;
 
 	if (ctx->mode == SCRUB_MODE_DRY_RUN)
 		return 0;
 	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
+	if (!scrub_item_schedule_work(sri, repair_mask))
+		return 0;
 
 	/*
 	 * If the caller passed us a file descriptor for a scrub, use it
@@ -689,39 +742,14 @@ repair_item_class(
 		xfdp = &xfd;
 	}
 
-	foreach_scrub_type(scrub_type) {
-		if (scrub_excessive_errors(ctx))
-			return ECANCELED;
-
-		if (!(sri->sri_state[scrub_type] & repair_mask))
-			continue;
-
-		/*
-		 * Don't try to repair higher level items if their lower-level
-		 * dependencies haven't been verified, unless this is our last
-		 * chance to fix things without complaint.
-		 */
-		if (!(flags & XRM_FINAL_WARNING) &&
-		    !repair_item_dependencies_ok(sri, scrub_type))
-			continue;
-
-		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
-		do {
-			memcpy(&old_sri, sri, sizeof(old_sri));
-			error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri,
-					flags);
-			if (error)
-				return error;
-		} while (scrub_item_call_kernel_again(sri, scrub_type,
-					repair_mask, &old_sri));
-
-		/* Maybe update progress if we fixed the problem. */
-		if (!(flags & XRM_NOPROGRESS) &&
-		    !(sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY))
-			progress_add(1);
-	}
-
-	return error;
+	do {
+		memcpy(&old_sri, sri, sizeof(struct scrub_item));
+		error = repair_call_kernel(ctx, xfdp, sri, repair_mask, flags);
+		if (error)
+			return error;
+	} while (scrub_item_call_kernel_again(sri, repair_mask, &old_sri));
+
+	return 0;
 }
 
 /*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0c77f947244a..d582dafbbe4e 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -64,35 +64,6 @@ format_scrubv_descr(
 	return -1;
 }
 
-/* Format a scrub description. */
-int
-format_scrub_descr(
-	struct scrub_ctx		*ctx,
-	char				*buf,
-	size_t				buflen,
-	void				*where)
-{
-	struct xfs_scrub_metadata	*meta = where;
-	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
-
-	switch (sc->group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
-				_(sc->descr));
-	case XFROG_SCRUB_GROUP_INODE:
-		return scrub_render_ino_descr(ctx, buf, buflen,
-				meta->sm_ino, meta->sm_gen, "%s",
-				_(sc->descr));
-	case XFROG_SCRUB_GROUP_FS:
-	case XFROG_SCRUB_GROUP_SUMMARY:
-	case XFROG_SCRUB_GROUP_ISCAN:
-	case XFROG_SCRUB_GROUP_NONE:
-		return snprintf(buf, buflen, _("%s"), _(sc->descr));
-	}
-	return -1;
-}
-
 /* Warn about strange circumstances after scrub. */
 void
 scrub_warn_incomplete_scrub(
@@ -271,12 +242,17 @@ void
 xfrog_scrubv_add_item(
 	struct xfrog_scrubv		*scrubv,
 	const struct scrub_item		*sri,
-	unsigned int			scrub_type)
+	unsigned int			scrub_type,
+	bool				want_repair)
 {
 	struct xfs_scrub_vec		*v;
 
 	v = xfrog_scrubv_next_vector(scrubv);
 	v->sv_type = scrub_type;
+	if (want_repair)
+		v->sv_flags |= XFS_SCRUB_IFLAG_REPAIR;
+	if (want_repair && use_force_rebuild)
+		v->sv_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
 }
 
 /* Do a read-only check of some metadata. */
@@ -301,7 +277,7 @@ scrub_call_kernel(
 	foreach_scrub_type(scrub_type) {
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
-		xfrog_scrubv_add_item(&scrubv, sri, scrub_type);
+		xfrog_scrubv_add_item(&scrubv, sri, scrub_type, false);
 
 		dbg_printf("check %s flags %xh tries %u\n", descr_render(&dsc),
 				sri->sri_state[scrub_type],
@@ -365,8 +341,8 @@ scrub_item_schedule_group(
 }
 
 /* Decide if we call the kernel again to finish scrub/repair activity. */
-static inline bool
-scrub_item_call_kernel_again_future(
+bool
+scrub_item_call_kernel_again(
 	struct scrub_item	*sri,
 	uint8_t			work_mask,
 	const struct scrub_item	*old)
@@ -382,6 +358,11 @@ scrub_item_call_kernel_again_future(
 	if (!nr)
 		return false;
 
+	/*
+	 * We are willing to go again if the last call had any effect on the
+	 * state of the scrub item that the caller cares about or if the kernel
+	 * asked us to try again.
+	 */
 	foreach_scrub_type(scrub_type) {
 		uint8_t		statex = sri->sri_state[scrub_type] ^
 					 old->sri_state[scrub_type];
@@ -395,34 +376,6 @@ scrub_item_call_kernel_again_future(
 	return false;
 }
 
-/* Decide if we call the kernel again to finish scrub/repair activity. */
-bool
-scrub_item_call_kernel_again(
-	struct scrub_item	*sri,
-	unsigned int		scrub_type,
-	uint8_t			work_mask,
-	const struct scrub_item	*old)
-{
-	uint8_t			statex;
-
-	/* If there's nothing to do, we're done. */
-	if (!(sri->sri_state[scrub_type] & work_mask))
-		return false;
-
-	/*
-	 * We are willing to go again if the last call had any effect on the
-	 * state of the scrub item that the caller cares about, if the freeze
-	 * flag got set, or if the kernel asked us to try again...
-	 */
-	statex = sri->sri_state[scrub_type] ^ old->sri_state[scrub_type];
-	if (statex & work_mask)
-		return true;
-	if (sri->sri_tries[scrub_type] != old->sri_tries[scrub_type])
-		return true;
-
-	return false;
-}
-
 /*
  * For each scrub item whose state matches the state_flags, set up the item
  * state for a kernel call.  Returns true if any work was scheduled.
@@ -477,7 +430,7 @@ scrub_item_check_file(
 		error = scrub_call_kernel(ctx, xfdp, sri);
 		if (error)
 			return error;
-	} while (scrub_item_call_kernel_again_future(sri, SCRUB_ITEM_NEEDSCHECK,
+	} while (scrub_item_call_kernel_again(sri, SCRUB_ITEM_NEEDSCHECK,
 				&old_sri));
 
 	return 0;
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index bf53ee5af2cf..d9de18ce1795 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -11,10 +11,8 @@
 void xfrog_scrubv_from_item(struct xfrog_scrubv *scrubv,
 		const struct scrub_item *sri);
 void xfrog_scrubv_add_item(struct xfrog_scrubv *scrubv,
-		const struct scrub_item *sri, unsigned int scrub_type);
-
-int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
-		void *where);
+		const struct scrub_item *sri, unsigned int scrub_type,
+		bool want_repair);
 
 struct scrubv_descr {
 	struct xfrog_scrubv	*scrubv;
@@ -116,8 +114,7 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 	return true;
 }
 
-bool scrub_item_call_kernel_again(struct scrub_item *sri,
-		unsigned int scrub_type, uint8_t work_mask,
+bool scrub_item_call_kernel_again(struct scrub_item *sri, uint8_t work_mask,
 		const struct scrub_item *old);
 bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags);
 

