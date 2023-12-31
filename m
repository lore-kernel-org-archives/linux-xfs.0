Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0AEC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IS8Hiphu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF92FC433C8;
	Sun, 31 Dec 2023 23:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064891;
	bh=NYKMGv6tmddyA3UelwTfD5eeBxbgTg9YcinI/7gBwoY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IS8HiphutYgThhcFHZK0/ZIpnzLx+y/u4A25YGYDeJl6+pZVCL/iuUmA0I5KMMrf3
	 Sud3oSG+wyJXWBMKka9BEloMK2q7cC2PC1PkJn2PM16pK+kcSLr5l/Nb0QMdadYj5p
	 VgrZ+P8MYdVz7Kp/3Gs23JjukPJwFnqp9sZjgls5dOBW8G+bqRDBEE1HG4wqFRv8iC
	 2tnyc+vXPNq1+Z+kedSWHjCYqqT5QNT3oIr9y4CJyoD/UZyjz1BweBYVq8By7Z4VSg
	 3S1pmYGQkvm1xgHAx+pGAQRh6mZhoxTFDd3HK/43lyfN7/b/WjqiNU1jICWB7OPhnO
	 9MrZH2ewcuADQ==
Date: Sun, 31 Dec 2023 15:21:31 -0800
Subject: [PATCH 07/10] xfs_scrub: vectorize scrub calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007936.1806194.7369999728267504344.stgit@frogsfrogsfrogs>
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

Use the new vectorized kernel scrub calls to reduce the overhead of
checking metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c        |    2 
 scrub/scrub.c         |  261 +++++++++++++++++++++++++++++++++++--------------
 scrub/scrub.h         |    2 
 scrub/scrub_private.h |   21 ++++
 4 files changed, 213 insertions(+), 73 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 095c045915a..091b59e57e7 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -216,6 +216,8 @@ _("Kernel metadata scrubbing facility is not available."));
 		return ECANCELED;
 	}
 
+	check_scrubv(ctx);
+
 	/*
 	 * Normally, callers are required to pass -n if the provided path is a
 	 * readonly filesystem or the kernel wasn't built with online repair
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2fb2293558e..ec8d5e92cea 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -22,11 +22,39 @@
 #include "descr.h"
 #include "scrub_private.h"
 
-static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
-		struct scrub_item *sri, struct xfs_scrub_vec *vec);
-
 /* Online scrub and repair wrappers. */
 
+/* Describe the current state of a vectored scrub. */
+static int
+format_scrubv_descr(
+	struct scrub_ctx		*ctx,
+	char				*buf,
+	size_t				buflen,
+	void				*where)
+{
+	struct scrubv_head		*bh = where;
+	struct xfs_scrub_vec_head	*vhead = &bh->head;
+	struct xfs_scrub_vec		*v = bh->head.svh_vecs + bh->i;
+	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[v->sv_type];
+
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		return snprintf(buf, buflen, _("AG %u %s"), vhead->svh_agno,
+				_(sc->descr));
+	case XFROG_SCRUB_GROUP_INODE:
+		return scrub_render_ino_descr(ctx, buf, buflen,
+				vhead->svh_ino, vhead->svh_gen, "%s",
+				_(sc->descr));
+	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+	case XFROG_SCRUB_GROUP_NONE:
+		return snprintf(buf, buflen, _("%s"), _(sc->descr));
+	}
+	return -1;
+}
+
 /* Format a scrub description. */
 int
 format_scrub_descr(
@@ -80,51 +108,6 @@ scrub_warn_incomplete_scrub(
 				_("Cross-referencing failed."));
 }
 
-/* Do a read-only check of some metadata. */
-static int
-xfs_check_metadata(
-	struct scrub_ctx		*ctx,
-	struct xfs_fd			*xfdp,
-	unsigned int			scrub_type,
-	struct scrub_item		*sri)
-{
-	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
-	struct xfs_scrub_metadata	meta = { };
-	struct xfs_scrub_vec		vec;
-	enum xfrog_scrub_group		group;
-
-	background_sleep();
-
-	group = xfrog_scrubbers[scrub_type].group;
-	meta.sm_type = scrub_type;
-	switch (group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = sri->sri_agno;
-		break;
-	case XFROG_SCRUB_GROUP_FS:
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
-	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	assert(scrub_type < XFS_SCRUB_TYPE_NR);
-	descr_set(&dsc, &meta);
-
-	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
-
-	vec.sv_ret = xfrog_scrub_metadata(xfdp, &meta);
-	vec.sv_type = scrub_type;
-	vec.sv_flags = meta.sm_flags;
-	return scrub_epilogue(ctx, &dsc, sri, &vec);
-}
-
 /*
  * Update all internal state after a scrub ioctl call.
  * Returns 0 for success, or ECANCELED to abort the program.
@@ -256,6 +239,88 @@ _("Optimization is possible."));
 	return 0;
 }
 
+/* Fill out the scrub vector header. */
+void
+scrub_item_to_vhead(
+	struct scrubv_head		*bighead,
+	const struct scrub_item		*sri)
+{
+	struct xfs_scrub_vec_head	*vhead = &bighead->head;
+
+	if (bg_mode > 1)
+		vhead->svh_rest_us = bg_mode - 1;
+	if (sri->sri_agno != -1)
+		vhead->svh_agno = sri->sri_agno;
+	if (sri->sri_ino != -1ULL) {
+		vhead->svh_ino = sri->sri_ino;
+		vhead->svh_gen = sri->sri_gen;
+	}
+}
+
+/* Add a scrubber to the scrub vector. */
+void
+scrub_vhead_add(
+	struct scrubv_head		*bighead,
+	const struct scrub_item		*sri,
+	unsigned int			scrub_type)
+{
+	struct xfs_scrub_vec_head	*vhead = &bighead->head;
+	struct xfs_scrub_vec		*v;
+
+	v = &vhead->svh_vecs[vhead->svh_nr++];
+	v->sv_type = scrub_type;
+	bighead->i = v - vhead->svh_vecs;
+}
+
+/* Do a read-only check of some metadata. */
+static int
+scrub_call_kernel(
+	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
+	struct scrub_item		*sri)
+{
+	DEFINE_DESCR(dsc, ctx, format_scrubv_descr);
+	struct scrubv_head		bh = { };
+	struct xfs_scrub_vec		*v;
+	unsigned int			scrub_type;
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+
+	scrub_item_to_vhead(&bh, sri);
+	descr_set(&dsc, &bh);
+
+	foreach_scrub_type(scrub_type) {
+		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
+			continue;
+		scrub_vhead_add(&bh, sri, scrub_type);
+
+		dbg_printf("check %s flags %xh tries %u\n", descr_render(&dsc),
+				sri->sri_state[scrub_type],
+				sri->sri_tries[scrub_type]);
+	}
+
+	error = -xfrog_scrubv_metadata(xfdp, &bh.head);
+	if (error)
+		return error;
+
+	foreach_bighead_vec(&bh, v) {
+		error = scrub_epilogue(ctx, &dsc, sri, v);
+		if (error)
+			return error;
+
+		/*
+		 * Progress is counted by the inode for inode metadata; for
+		 * everything else, it's counted for each scrub call.
+		 */
+		if (!(sri->sri_state[v->sv_type] & SCRUB_ITEM_NEEDSCHECK) &&
+		    sri->sri_ino == -1ULL)
+			progress_add(1);
+	}
+
+	return 0;
+}
+
 /* Bulk-notify user about things that could be optimized. */
 void
 scrub_report_preen_triggers(
@@ -291,6 +356,37 @@ scrub_item_schedule_group(
 	}
 }
 
+/* Decide if we call the kernel again to finish scrub/repair activity. */
+static inline bool
+scrub_item_call_kernel_again_future(
+	struct scrub_item	*sri,
+	uint8_t			work_mask,
+	const struct scrub_item	*old)
+{
+	unsigned int		scrub_type;
+	unsigned int		nr = 0;
+
+	/* If there's nothing to do, we're done. */
+	foreach_scrub_type(scrub_type) {
+		if (sri->sri_state[scrub_type] & work_mask)
+			nr++;
+	}
+	if (!nr)
+		return false;
+
+	foreach_scrub_type(scrub_type) {
+		uint8_t		statex = sri->sri_state[scrub_type] ^
+					 old->sri_state[scrub_type];
+
+		if (statex & work_mask)
+			return true;
+		if (sri->sri_tries[scrub_type] != old->sri_tries[scrub_type])
+			return true;
+	}
+
+	return false;
+}
+
 /* Decide if we call the kernel again to finish scrub/repair activity. */
 bool
 scrub_item_call_kernel_again(
@@ -319,6 +415,29 @@ scrub_item_call_kernel_again(
 	return false;
 }
 
+/*
+ * For each scrub item whose state matches the state_flags, set up the item
+ * state for a kernel call.  Returns true if any work was scheduled.
+ */
+bool
+scrub_item_schedule_work(
+	struct scrub_item	*sri,
+	uint8_t			state_flags)
+{
+	unsigned int		scrub_type;
+	unsigned int		nr = 0;
+
+	foreach_scrub_type(scrub_type) {
+		if (!(sri->sri_state[scrub_type] & state_flags))
+			continue;
+
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		nr++;
+	}
+
+	return nr > 0;
+}
+
 /* Run all the incomplete scans on this scrub principal. */
 int
 scrub_item_check_file(
@@ -329,8 +448,10 @@ scrub_item_check_file(
 	struct xfs_fd			xfd;
 	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
-	unsigned int			scrub_type;
-	int				error;
+	int				error = 0;
+
+	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK))
+		return 0;
 
 	/*
 	 * If the caller passed us a file descriptor for a scrub, use it
@@ -343,31 +464,15 @@ scrub_item_check_file(
 		xfdp = &xfd;
 	}
 
-	foreach_scrub_type(scrub_type) {
-		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
-			continue;
-
-		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
-		do {
-			memcpy(&old_sri, sri, sizeof(old_sri));
-			error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
-			if (error)
-				return error;
-		} while (scrub_item_call_kernel_again(sri, scrub_type,
-					SCRUB_ITEM_NEEDSCHECK, &old_sri));
-
-		/*
-		 * Progress is counted by the inode for inode metadata; for
-		 * everything else, it's counted for each scrub call.
-		 */
-		if (sri->sri_ino == -1ULL)
-			progress_add(1);
-
+	do {
+		memcpy(&old_sri, sri, sizeof(old_sri));
+		error = scrub_call_kernel(ctx, xfdp, sri);
 		if (error)
-			break;
-	}
+			return error;
+	} while (scrub_item_call_kernel_again_future(sri, SCRUB_ITEM_NEEDSCHECK,
+				&old_sri));
 
-	return error;
+	return 0;
 }
 
 /* How many items do we have to check? */
@@ -562,3 +667,13 @@ can_force_rebuild(
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
 			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
+
+void
+check_scrubv(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_vec_head	head = { };
+
+	/* We set the fallback flag if this doesn't work. */
+	xfrog_scrubv_metadata(&ctx->mnt, &head);
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 90578108a1c..183b89379cb 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -138,6 +138,8 @@ bool can_scrub_parent(struct scrub_ctx *ctx);
 bool can_repair(struct scrub_ctx *ctx);
 bool can_force_rebuild(struct scrub_ctx *ctx);
 
+void check_scrubv(struct scrub_ctx *ctx);
+
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
 		unsigned int type, struct scrub_item *sri);
 
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 98a9238f2aa..ecdce680d81 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -8,6 +8,26 @@
 
 /* Shared code between scrub.c and repair.c. */
 
+/*
+ * Declare a structure big enough to handle all scrub types + barriers, and
+ * an iteration pointer.  So far we only need two barriers.
+ */
+struct scrubv_head {
+	struct xfs_scrub_vec_head	head;
+	struct xfs_scrub_vec		__vecs[XFS_SCRUB_TYPE_NR + 2];
+	unsigned int			i;
+};
+
+#define foreach_bighead_vec(bh, v) \
+	for ((bh)->i = 0, (v) = (bh)->head.svh_vecs; \
+	     (bh)->i < (bh)->head.svh_nr; \
+	     (bh)->i++, (v)++)
+
+void scrub_item_to_vhead(struct scrubv_head *bighead,
+		const struct scrub_item *sri);
+void scrub_vhead_add(struct scrubv_head *bighead, const struct scrub_item *sri,
+		unsigned int scrub_type);
+
 int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
 		void *where);
 
@@ -104,5 +124,6 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 bool scrub_item_call_kernel_again(struct scrub_item *sri,
 		unsigned int scrub_type, uint8_t work_mask,
 		const struct scrub_item *old);
+bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags);
 
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

