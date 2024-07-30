Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E98F5B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303114; cv=none; b=mr770S3a7gaAlIMHXjNLUHQSCk6cZh6VZPj0gmXoPc5Ue2u/YLW8zfvRra/32AoEqHA7RVXRtbExzPxn5rBrk81PEuzZF07DoPl7bbFPua7EkFYEmDArVKW4v4Oz8fGWjzbYV6ruyHiu0suR/T1ZVO1LxVmohDW4Qyo6UYgz5vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303114; c=relaxed/simple;
	bh=+Y+EumgM2dqNjECiJP/mMqFmvV8F0keB+ct5PI/GIUo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mpkbn62B9sIyC+sfyJQNS/zd/jBZ9zv/Bgdyg5EIsOb/5yObXbRZ+GehwepgRk76S66kxoE0tpdwoI2h0KsAQu/E1Pt/18uwpOlD0vtJFXAwIf7++xAHm2FGxL50jfvucBWInV4nHgwpsQ9THYC/4j4haBi32BIAt9cK+Qs5zd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biYgu8ED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biYgu8ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013B2C32786;
	Tue, 30 Jul 2024 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303114;
	bh=+Y+EumgM2dqNjECiJP/mMqFmvV8F0keB+ct5PI/GIUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=biYgu8EDG017iDsjHg2f8KvhU+2xRlaK9ydpAmbQ3LBTyQPV/V7zD/JCaAIlzBSo7
	 h53czYF7mQqrpvSYjPA7A80hmWDqQpe0D+l63+ueFyF1Cqd6xsMEmNdGeJCWGQnhjC
	 JGKkNS/dJH69Tvc+tDr4r0D30MQQ1EYIBZDm2ztKzq3cbOrhY7Yol22CZeieitIKuU
	 AEzYKTwZqrUtvxg0amJBVXC6HJLfmORTp7gT76BVQc7bWoRLPptA5rTXgRUML1mZTz
	 QtqmoTB1MatPdjUPFeg0BuUVPlheKwFkno6O9YMczwIUtcTu8jZ0OLfiDbB/2JuskO
	 zcO9Nx+/Jo7ug==
Date: Mon, 29 Jul 2024 18:31:53 -0700
Subject: [PATCH 07/10] xfs_scrub: vectorize scrub calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852449.1353240.2984511445243968937.stgit@frogsfrogsfrogs>
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

Use the new vectorized kernel scrub calls to reduce the overhead of
checking metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase1.c        |    2 
 scrub/scrub.c         |  277 ++++++++++++++++++++++++++++++++++++-------------
 scrub/scrub.h         |    2 
 scrub/scrub_private.h |   16 +++
 scrub/xfs_scrub.c     |    1 
 5 files changed, 225 insertions(+), 73 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 095c04591..091b59e57 100644
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
index 2fb229355..0c77f9472 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -22,11 +22,48 @@
 #include "descr.h"
 #include "scrub_private.h"
 
-static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
-		struct scrub_item *sri, struct xfs_scrub_vec *vec);
-
 /* Online scrub and repair wrappers. */
 
+/* Describe the current state of a vectored scrub. */
+int
+format_scrubv_descr(
+	struct scrub_ctx		*ctx,
+	char				*buf,
+	size_t				buflen,
+	void				*where)
+{
+	struct scrubv_descr		*vdesc = where;
+	struct xfrog_scrubv		*scrubv = vdesc->scrubv;
+	struct xfs_scrub_vec_head	*vhead = &scrubv->head;
+	const struct xfrog_scrub_descr	*sc;
+	unsigned int			scrub_type;
+
+	if (vdesc->idx >= 0)
+		scrub_type = scrubv->vectors[vdesc->idx].sv_type;
+	else if (scrubv->head.svh_nr > 0)
+		scrub_type = scrubv->vectors[scrubv->head.svh_nr - 1].sv_type;
+	else
+		scrub_type = XFS_SCRUB_TYPE_PROBE;
+	sc = &xfrog_scrubbers[scrub_type];
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
@@ -80,51 +117,6 @@ scrub_warn_incomplete_scrub(
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
@@ -256,6 +248,87 @@ _("Optimization is possible."));
 	return 0;
 }
 
+/* Fill out the scrub vector header from a scrub item. */
+void
+xfrog_scrubv_from_item(
+	struct xfrog_scrubv		*scrubv,
+	const struct scrub_item		*sri)
+{
+	xfrog_scrubv_init(scrubv);
+
+	if (bg_mode > 1)
+		scrubv->head.svh_rest_us = bg_mode - 1;
+	if (sri->sri_agno != -1)
+		scrubv->head.svh_agno = sri->sri_agno;
+	if (sri->sri_ino != -1ULL) {
+		scrubv->head.svh_ino = sri->sri_ino;
+		scrubv->head.svh_gen = sri->sri_gen;
+	}
+}
+
+/* Add a scrubber to the scrub vector. */
+void
+xfrog_scrubv_add_item(
+	struct xfrog_scrubv		*scrubv,
+	const struct scrub_item		*sri,
+	unsigned int			scrub_type)
+{
+	struct xfs_scrub_vec		*v;
+
+	v = xfrog_scrubv_next_vector(scrubv);
+	v->sv_type = scrub_type;
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
+		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
+			continue;
+		xfrog_scrubv_add_item(&scrubv, sri, scrub_type);
+
+		dbg_printf("check %s flags %xh tries %u\n", descr_render(&dsc),
+				sri->sri_state[scrub_type],
+				sri->sri_tries[scrub_type]);
+	}
+
+	error = -xfrog_scrubv_metadata(xfdp, &scrubv);
+	if (error)
+		return error;
+
+	foreach_xfrog_scrubv_vec(&scrubv, vdesc.idx, v) {
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
@@ -291,6 +364,37 @@ scrub_item_schedule_group(
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
@@ -319,6 +423,29 @@ scrub_item_call_kernel_again(
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
@@ -329,8 +456,10 @@ scrub_item_check_file(
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
@@ -343,31 +472,15 @@ scrub_item_check_file(
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
@@ -562,3 +675,21 @@ can_force_rebuild(
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
 			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
+
+void
+check_scrubv(
+	struct scrub_ctx	*ctx)
+{
+	struct xfrog_scrubv	scrubv = { };
+
+	xfrog_scrubv_init(&scrubv);
+
+	if (debug_tweak_on("XFS_SCRUB_FORCE_SINGLE"))
+		ctx->mnt.flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+
+	/*
+	 * We set the fallback flag if calling the kernel with a zero-length
+	 * vector doesn't work.
+	 */
+	xfrog_scrubv_metadata(&ctx->mnt, &scrubv);
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 90578108a..183b89379 100644
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
index 98a9238f2..bf53ee5af 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -8,9 +8,24 @@
 
 /* Shared code between scrub.c and repair.c. */
 
+void xfrog_scrubv_from_item(struct xfrog_scrubv *scrubv,
+		const struct scrub_item *sri);
+void xfrog_scrubv_add_item(struct xfrog_scrubv *scrubv,
+		const struct scrub_item *sri, unsigned int scrub_type);
+
 int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
 		void *where);
 
+struct scrubv_descr {
+	struct xfrog_scrubv	*scrubv;
+	int			idx;
+};
+
+#define SCRUBV_DESCR(sv)	{ .scrubv = (sv), .idx = -1 }
+
+int format_scrubv_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
+		void *where);
+
 /* Predicates for scrub flag state. */
 
 static inline bool is_corrupt(const struct xfs_scrub_vec *sv)
@@ -104,5 +119,6 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 bool scrub_item_call_kernel_again(struct scrub_item *sri,
 		unsigned int scrub_type, uint8_t work_mask,
 		const struct scrub_item *old);
+bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags);
 
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index bb316f73e..f5b58de12 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -115,6 +115,7 @@
  * XFS_SCRUB_THREADS		-- start exactly this number of threads
  * XFS_SCRUB_DISK_ERROR_INTERVAL-- simulate a disk error every this many bytes
  * XFS_SCRUB_DISK_VERIFY_SKIP	-- pretend disk verify read calls succeeded
+ * XFS_SCRUB_FORCE_SINGLE	-- fall back to ioctl-per-item scrubbing
  *
  * Available even in non-debug mode:
  * SERVICE_MODE			-- compress all error codes to 1 for LSB

