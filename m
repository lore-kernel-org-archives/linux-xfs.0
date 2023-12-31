Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA4FC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNheJDL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A5EC433C8;
	Sun, 31 Dec 2023 23:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064923;
	bh=/C02IGY70ojP2czbtAy9C4sWPGvH7pk1kdjWyk81X/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BNheJDL8pgwRH51E49bjD4f0PkSAEjLVRk5yCgghy+qPW0mb7WpVhg9MAj5JQIhV5
	 sU8sqWn8ItVCwObTXMLYL8xY7D5UUj6K0FmaH1G7JV9r7lQly+9saxSX/hIADb6bzZ
	 3j1lOH1qYGWY9LjOm0iQWrPSNHKg843lyEGMK260RsXk2QWC2hmx8HWwteh0YP1rtz
	 u1Q2W/LGKylsiBePCwnTFVFPQR4HWlEQD1n38sLFA+PheLaC8cx8qfr/ckRTL+Nhts
	 +vcgzSAlCS8M5gbwwcxSdQSLwj3fILJOu8mh47oi2DVbT5IvEEm2+U8YOhz9FR/9r4
	 oWIf/PbxNta8w==
Date: Sun, 31 Dec 2023 15:22:02 -0800
Subject: [PATCH 09/10] xfs_scrub: use scrub barriers to reduce kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007962.1806194.8270072828641970979.stgit@frogsfrogsfrogs>
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

Use scrub barriers so that we can submit a single scrub request for a
bunch of things, and have the kernel stop midway through if it finds
anything broken.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c        |   15 ++-------
 scrub/phase3.c        |   17 +---------
 scrub/repair.c        |   32 ++++++++++++++++++-
 scrub/scrub.c         |   81 ++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h         |   17 ++++++++++
 scrub/scrub_private.h |    4 ++
 6 files changed, 134 insertions(+), 32 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 57c6d0ef213..d435da07125 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -91,21 +91,12 @@ scan_ag_metadata(
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
 
 	/*
-	 * First we scrub and fix the AG headers, because we need
-	 * them to work well enough to check the AG btrees.
+	 * First we scrub and fix the AG headers, because we need them to work
+	 * well enough to check the AG btrees.  Then scrub the AG btrees.
 	 */
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_AGHEADER);
-	ret = scrub_item_check(ctx, &sri);
-	if (ret)
-		goto err;
-
-	/* Repair header damage. */
-	ret = repair_item_corruption(ctx, &sri);
-	if (ret)
-		goto err;
-
-	/* Now scrub the AG btrees. */
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_PERAG);
+
 	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		goto err;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 98e5c5a1f9f..09a1ea452bb 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -145,25 +145,11 @@ scrub_inode(
 
 	/* Scrub the inode. */
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_INODE);
-	error = scrub_item_check_file(ctx, &sri, fd);
-	if (error)
-		goto out;
-
-	error = try_inode_repair(ictx, &sri, fd);
-	if (error)
-		goto out;
 
 	/* Scrub all block mappings. */
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTD);
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTA);
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTC);
-	error = scrub_item_check_file(ctx, &sri, fd);
-	if (error)
-		goto out;
-
-	error = try_inode_repair(ictx, &sri, fd);
-	if (error)
-		goto out;
 
 	/*
 	 * Check file data contents, e.g. symlink and directory entries.
@@ -182,11 +168,12 @@ scrub_inode(
 
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_XATTR);
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_PARENT);
+
+	/* Try to check and repair the file while it's open. */
 	error = scrub_item_check_file(ctx, &sri, fd);
 	if (error)
 		goto out;
 
-	/* Try to repair the file while it's open. */
 	error = try_inode_repair(ictx, &sri, fd);
 	if (error)
 		goto out;
diff --git a/scrub/repair.c b/scrub/repair.c
index a8e61255c5f..1ce0283cb7f 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -323,6 +323,7 @@ repair_call_kernel(
 	struct scrubv_head		bh = { };
 	struct xfs_scrub_vec		*v;
 	unsigned int			scrub_type;
+	bool				need_barrier = false;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -338,6 +339,11 @@ repair_call_kernel(
 					repair_flags))
 			continue;
 
+		if (need_barrier) {
+			scrub_vhead_add_barrier(&bh);
+			need_barrier = false;
+		}
+
 		scrub_vhead_add(&bh, sri, scrub_type, true);
 
 		if (sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSREPAIR)
@@ -350,6 +356,17 @@ repair_call_kernel(
 		dbg_printf("repair %s flags %xh tries %u\n", descr_render(&dsc),
 				sri->sri_state[scrub_type],
 				sri->sri_tries[scrub_type]);
+
+		/*
+		 * One of the other scrub types depends on this one.  Set us up
+		 * to add a repair barrier if we decide to schedule a repair
+		 * after this one.  If the UNFIXED flag is set, that means this
+		 * is our last chance to fix things, so we skip the barriers
+		 * just let everything run.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING) &&
+		    (sri->sri_state[scrub_type] & SCRUB_ITEM_BARRIER))
+			need_barrier = true;
 	}
 
 	error = -xfrog_scrubv_metadata(xfdp, &bh.head);
@@ -357,6 +374,16 @@ repair_call_kernel(
 		return error;
 
 	foreach_bighead_vec(&bh, v) {
+		/* Deal with barriers separately. */
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			/* -ECANCELED means the kernel stopped here. */
+			if (v->sv_ret == -ECANCELED)
+				return 0;
+			if (v->sv_ret)
+				return -v->sv_ret;
+			continue;
+		}
+
 		error = repair_epilogue(ctx, &dsc, sri, repair_flags, v);
 		if (error)
 			return error;
@@ -445,7 +472,8 @@ repair_item_boost_priorities(
  * bits are left untouched to force a rescan in phase 4.
  */
 #define MUSTFIX_STATES	(SCRUB_ITEM_CORRUPT | \
-			 SCRUB_ITEM_BOOST_REPAIR)
+			 SCRUB_ITEM_BOOST_REPAIR | \
+			 SCRUB_ITEM_BARRIER)
 /*
  * Figure out which AG metadata must be fixed before we can move on
  * to the inode scan.
@@ -727,7 +755,7 @@ repair_item_class(
 		return 0;
 	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
-	if (!scrub_item_schedule_work(sri, repair_mask))
+	if (!scrub_item_schedule_work(sri, repair_mask, repair_deps))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 9f982eee701..2ec3cbc9aac 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -24,6 +24,35 @@
 
 /* Online scrub and repair wrappers. */
 
+/*
+ * Bitmap showing the correctness dependencies between scrub types for scrubs.
+ * Dependencies cannot cross scrub groups.
+ */
+#define DEP(x) (1U << (x))
+static const unsigned int scrub_deps[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_AGF]		= DEP(XFS_SCRUB_TYPE_SB),
+	[XFS_SCRUB_TYPE_AGFL]		= DEP(XFS_SCRUB_TYPE_SB) |
+					  DEP(XFS_SCRUB_TYPE_AGF),
+	[XFS_SCRUB_TYPE_AGI]		= DEP(XFS_SCRUB_TYPE_SB),
+	[XFS_SCRUB_TYPE_BNOBT]		= DEP(XFS_SCRUB_TYPE_AGF),
+	[XFS_SCRUB_TYPE_CNTBT]		= DEP(XFS_SCRUB_TYPE_AGF),
+	[XFS_SCRUB_TYPE_INOBT]		= DEP(XFS_SCRUB_TYPE_AGI),
+	[XFS_SCRUB_TYPE_FINOBT]		= DEP(XFS_SCRUB_TYPE_AGI),
+	[XFS_SCRUB_TYPE_RMAPBT]		= DEP(XFS_SCRUB_TYPE_AGF),
+	[XFS_SCRUB_TYPE_REFCNTBT]	= DEP(XFS_SCRUB_TYPE_AGF),
+	[XFS_SCRUB_TYPE_BMBTD]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_BMBTA]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_BMBTC]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_DIR]		= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_XATTR]		= DEP(XFS_SCRUB_TYPE_BMBTA),
+	[XFS_SCRUB_TYPE_SYMLINK]	= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_PARENT]		= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_QUOTACHECK]	= DEP(XFS_SCRUB_TYPE_UQUOTA) |
+					  DEP(XFS_SCRUB_TYPE_GQUOTA) |
+					  DEP(XFS_SCRUB_TYPE_PQUOTA),
+};
+#undef DEP
+
 /* Describe the current state of a vectored scrub. */
 int
 format_scrubv_descr(
@@ -248,6 +277,21 @@ scrub_vhead_add(
 	bighead->i = v - vhead->svh_vecs;
 }
 
+/* Add a barrier to the scrub vector. */
+void
+scrub_vhead_add_barrier(
+	struct scrubv_head		*bighead)
+{
+	struct xfs_scrub_vec_head	*vhead = &bighead->head;
+	struct xfs_scrub_vec		*v;
+
+	v = &vhead->svh_vecs[vhead->svh_nr++];
+	v->sv_type = XFS_SCRUB_TYPE_BARRIER;
+	v->sv_flags = XFS_SCRUB_OFLAG_CORRUPT | XFS_SCRUB_OFLAG_XFAIL |
+		      XFS_SCRUB_OFLAG_XCORRUPT | XFS_SCRUB_OFLAG_INCOMPLETE;
+	bighead->i = v - vhead->svh_vecs;
+}
+
 /* Do a read-only check of some metadata. */
 static int
 scrub_call_kernel(
@@ -259,6 +303,7 @@ scrub_call_kernel(
 	struct scrubv_head		bh = { };
 	struct xfs_scrub_vec		*v;
 	unsigned int			scrub_type;
+	bool				need_barrier = false;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -269,8 +314,17 @@ scrub_call_kernel(
 	foreach_scrub_type(scrub_type) {
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
+
+		if (need_barrier) {
+			scrub_vhead_add_barrier(&bh);
+			need_barrier = false;
+		}
+
 		scrub_vhead_add(&bh, sri, scrub_type, false);
 
+		if (sri->sri_state[scrub_type] & SCRUB_ITEM_BARRIER)
+			need_barrier = true;
+
 		dbg_printf("check %s flags %xh tries %u\n", descr_render(&dsc),
 				sri->sri_state[scrub_type],
 				sri->sri_tries[scrub_type]);
@@ -281,6 +335,16 @@ scrub_call_kernel(
 		return error;
 
 	foreach_bighead_vec(&bh, v) {
+		/* Deal with barriers separately. */
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			/* -ECANCELED means the kernel stopped here. */
+			if (v->sv_ret == -ECANCELED)
+				return 0;
+			if (v->sv_ret)
+				return -v->sv_ret;
+			continue;
+		}
+
 		error = scrub_epilogue(ctx, &dsc, sri, v);
 		if (error)
 			return error;
@@ -375,15 +439,25 @@ scrub_item_call_kernel_again(
 bool
 scrub_item_schedule_work(
 	struct scrub_item	*sri,
-	uint8_t			state_flags)
+	uint8_t			state_flags,
+	const unsigned int	*schedule_deps)
 {
 	unsigned int		scrub_type;
 	unsigned int		nr = 0;
 
 	foreach_scrub_type(scrub_type) {
+		unsigned int	j;
+
+		sri->sri_state[scrub_type] &= ~SCRUB_ITEM_BARRIER;
+
 		if (!(sri->sri_state[scrub_type] & state_flags))
 			continue;
 
+		foreach_scrub_type(j) {
+			if (schedule_deps[scrub_type] & (1U << j))
+				sri->sri_state[j] |= SCRUB_ITEM_BARRIER;
+		}
+
 		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
 		nr++;
 	}
@@ -403,7 +477,7 @@ scrub_item_check_file(
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	int				error = 0;
 
-	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK))
+	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK, scrub_deps))
 		return 0;
 
 	/*
@@ -627,6 +701,9 @@ check_scrubv(
 {
 	struct xfs_scrub_vec_head	head = { };
 
+	if (debug_tweak_on("XFS_SCRUB_FORCE_SINGLE"))
+		ctx->mnt.flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+
 	/* We set the fallback flag if this doesn't work. */
 	xfrog_scrubv_metadata(&ctx->mnt, &head);
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 183b89379cb..c3eed1b261d 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -30,6 +30,9 @@ enum xfrog_scrub_group;
 /* This scrub type needs to be checked. */
 #define SCRUB_ITEM_NEEDSCHECK	(1 << 5)
 
+/* Scrub barrier. */
+#define SCRUB_ITEM_BARRIER	(1 << 6)
+
 /* All of the state flags that we need to prioritize repair work. */
 #define SCRUB_ITEM_REPAIR_ANY	(SCRUB_ITEM_CORRUPT | \
 				 SCRUB_ITEM_PREEN | \
@@ -126,6 +129,20 @@ scrub_item_check(struct scrub_ctx *ctx, struct scrub_item *sri)
 	return scrub_item_check_file(ctx, sri, -1);
 }
 
+/* Count the number of metadata objects still needing a scrub. */
+static inline unsigned int
+scrub_item_count_needscheck(
+	const struct scrub_item		*sri)
+{
+	unsigned int			ret = 0;
+	unsigned int			i;
+
+	foreach_scrub_type(i)
+		if (sri->sri_state[i] & SCRUB_ITEM_NEEDSCHECK)
+			ret++;
+	return ret;
+}
+
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index ceda8ea1505..5014feee515 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -27,6 +27,7 @@ void scrub_item_to_vhead(struct scrubv_head *bighead,
 		const struct scrub_item *sri);
 void scrub_vhead_add(struct scrubv_head *bighead, const struct scrub_item *sri,
 		unsigned int scrub_type, bool repair);
+void scrub_vhead_add_barrier(struct scrubv_head *bighead);
 
 int format_scrubv_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
 		void *where);
@@ -123,6 +124,7 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 
 bool scrub_item_call_kernel_again(struct scrub_item *sri, uint8_t work_mask,
 		const struct scrub_item *old);
-bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags);
+bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags,
+		const unsigned int *schedule_deps);
 
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

