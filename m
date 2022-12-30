Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B28C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiLaD10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:27:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBC813D49
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:27:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B413B81E73
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A777C433D2;
        Sat, 31 Dec 2022 03:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457242;
        bh=LizPYZZtsSVM78x3/9roLeaJuTP4n6sGE9xlFfWwa6Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r7qtfLgSXQnA+UM78DCZFVWazp3LYOH+c3GY/zUQHC0BoBQRfnN9zkI6UqeAgnBG/
         quY3HCst3L0Ty3lYzN6UgeqvrrplNbfUgm2plDJLln65gdAbjmT8OrxXGynmjvZGR9
         y8BM6uAWgN2K5DP92WXe9UlAPuQcrCgDwLpPo/UMd6Qvn3/puphNYX45kQLMTrg5M1
         +w5Yc19x1jktVaoReMJkFqwP4arLGierOcokWHTL4htxXizPldOiE0TOneGhOHB6f0
         48D+XFflfRTmVD36dLz6Wy5G2kJKTLP9PwcixPNrwGhhrQMIpLdnlF7wSF7SV3HROm
         Ewy3R15FB9nVA==
Subject: [PATCH 10/11] xfs_scrub: use scrub barriers to reduce kernel calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884166.739244.11995511541336261812.stgit@magnolia>
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
index a224af11ed4..e4c7d32d75e 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -99,21 +99,12 @@ scan_ag_metadata(
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
index 56a4385a408..14fff96ff77 100644
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
 
 	/* Check everything accessible via file mapping. */
 	if (S_ISLNK(bstat->bs_mode))
@@ -173,11 +159,12 @@ scrub_inode(
 
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
index 8a6263c675e..91259feb758 100644
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
@@ -730,7 +758,7 @@ repair_item_class(
 		return 0;
 	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
-	if (!scrub_item_schedule_work(sri, repair_mask))
+	if (!scrub_item_schedule_work(sri, repair_mask, repair_deps))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 76d4fa87931..6031e2b1991 100644
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
@@ -251,6 +280,21 @@ scrub_vhead_add(
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
@@ -262,6 +306,7 @@ scrub_call_kernel(
 	struct scrubv_head		bh = { };
 	struct xfs_scrub_vec		*v;
 	unsigned int			scrub_type;
+	bool				need_barrier = false;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -272,8 +317,17 @@ scrub_call_kernel(
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
@@ -284,6 +338,16 @@ scrub_call_kernel(
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
@@ -378,15 +442,25 @@ scrub_item_call_kernel_again(
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
@@ -406,7 +480,7 @@ scrub_item_check_file(
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	int				error = 0;
 
-	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK))
+	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK, scrub_deps))
 		return 0;
 
 	/*
@@ -630,6 +704,9 @@ check_scrubv(
 {
 	struct xfs_scrub_vec_head	head = { };
 
+	if (debug_tweak_on("XFS_SCRUB_FORCE_SINGLE"))
+		ctx->mnt.flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+
 	/* We set the fallback flag if this doesn't work. */
 	xfrog_scrubv_metadata(&ctx->mnt, &head);
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0db94da5281..69a37ad7bfa 100644
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
@@ -135,6 +138,20 @@ scrub_item_check(struct scrub_ctx *ctx, struct scrub_item *sri)
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
index 8daf28c26ee..b21a6ca62ba 100644
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

