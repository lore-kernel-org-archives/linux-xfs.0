Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4AC523D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883455; cv=none; b=aT5FcWzndf9NOYZtA48ZI0HuR9+NVwisNrTmjMtXo5XTjNP9h3sClniZ5pofmMTQGMG4942Y3eTC/LZw4/wmID+sGbzGkl6s/FjUKPvpoIUQki2WUuxEvvv50FH59mXnh7WrPzvzwvWG2pbs1IxO2vXS+ChXTaTh2yC6ItCPIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883455; c=relaxed/simple;
	bh=vXQda1ym4ryuyWdLnZZsSqG0NvdKnBgO32U/0yhnIw8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVlBeXkIYBoNLrHEHhIeiCZnHtKyc5/QDb4eUmDVpzFwO+UxtB0zJs8L6ah83dUZN92rlI0aroo55+qFUWUEu3eOrx/V/Yc2MIAxZaNbwBr7+0SJ1q5RlXGD8VPTov2Y+LtqD7dfowkUeRnPUkP2NwXLhppatXn/IIi8qqnJ0eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/eLqkXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/eLqkXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB02C116B1;
	Tue,  2 Jul 2024 01:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883455;
	bh=vXQda1ym4ryuyWdLnZZsSqG0NvdKnBgO32U/0yhnIw8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N/eLqkXF+5+wC8d92mngQIAQBerxIYglQpKctjJSxpdvOMgFSe3PXYmRfRDr1wiBD
	 v/suS2Dq4PfMZt/fFBDHrCdoGbBYu+yOSKNdu5gNCfgQeQa/1ENM+SDVZr3JpWtQWy
	 WhPxUJ7BNhAdhwW8zvg1c60whV6ynhImUnCYPaKpXtfXWTS93MNkJ1ugdfmeIjoHsy
	 ioJ3mlZSwwJ08g72Xv7jQPBcuVNCn/2GwWaVJRUBHV+jmUG41qFOh0LP7ad3ctlTwj
	 WmOAD4cUSC9qHepPkMNxlCIsH3uZ56TfohZLEomRClv9kFeZLJ1ojv/V3sZdElPO+Z
	 1fCdqjVBqBxyg==
Date: Mon, 01 Jul 2024 18:24:15 -0700
Subject: [PATCH 09/10] xfs_scrub: use scrub barriers to reduce kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123273.2012546.4398258276146368055.stgit@frogsfrogsfrogs>
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

Use scrub barriers so that we can submit a single scrub request for a
bunch of things, and have the kernel stop midway through if it finds
anything broken.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c        |   15 ++--------
 scrub/phase3.c        |   17 +----------
 scrub/repair.c        |   32 +++++++++++++++++++-
 scrub/scrub.c         |   77 ++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h         |   17 +++++++++++
 scrub/scrub_private.h |    4 ++-
 6 files changed, 130 insertions(+), 32 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 57c6d0ef2137..d435da07125a 100644
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
index 98e5c5a1f9f4..09a1ea452bb9 100644
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
index 6a5fd40fd02f..8a28f6b13d87 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -324,6 +324,7 @@ repair_call_kernel(
 	struct scrubv_descr		vdesc = SCRUBV_DESCR(&scrubv);
 	struct xfs_scrub_vec		*v;
 	unsigned int			scrub_type;
+	bool				need_barrier = false;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -339,6 +340,11 @@ repair_call_kernel(
 					repair_flags))
 			continue;
 
+		if (need_barrier) {
+			xfrog_scrubv_add_barrier(&scrubv);
+			need_barrier = false;
+		}
+
 		xfrog_scrubv_add_item(&scrubv, sri, scrub_type, true);
 
 		if (sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSREPAIR)
@@ -351,6 +357,17 @@ repair_call_kernel(
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
 
 	error = -xfrog_scrubv_metadata(xfdp, &scrubv);
@@ -358,6 +375,16 @@ repair_call_kernel(
 		return error;
 
 	foreach_xfrog_scrubv_vec(&scrubv, vdesc.idx, v) {
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
@@ -446,7 +473,8 @@ repair_item_boost_priorities(
  * bits are left untouched to force a rescan in phase 4.
  */
 #define MUSTFIX_STATES	(SCRUB_ITEM_CORRUPT | \
-			 SCRUB_ITEM_BOOST_REPAIR)
+			 SCRUB_ITEM_BOOST_REPAIR | \
+			 SCRUB_ITEM_BARRIER)
 /*
  * Figure out which AG metadata must be fixed before we can move on
  * to the inode scan.
@@ -728,7 +756,7 @@ repair_item_class(
 		return 0;
 	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
-	if (!scrub_item_schedule_work(sri, repair_mask))
+	if (!scrub_item_schedule_work(sri, repair_mask, repair_deps))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d582dafbbe4e..44c4049899d2 100644
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
@@ -255,6 +284,20 @@ xfrog_scrubv_add_item(
 		v->sv_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
 }
 
+/* Add a barrier to the scrub vector. */
+void
+xfrog_scrubv_add_barrier(
+	struct xfrog_scrubv		*scrubv)
+{
+	struct xfs_scrub_vec		*v;
+
+	v = xfrog_scrubv_next_vector(scrubv);
+
+	v->sv_type = XFS_SCRUB_TYPE_BARRIER;
+	v->sv_flags = XFS_SCRUB_OFLAG_CORRUPT | XFS_SCRUB_OFLAG_XFAIL |
+		      XFS_SCRUB_OFLAG_XCORRUPT | XFS_SCRUB_OFLAG_INCOMPLETE;
+}
+
 /* Do a read-only check of some metadata. */
 static int
 scrub_call_kernel(
@@ -267,6 +310,7 @@ scrub_call_kernel(
 	struct scrubv_descr		vdesc = SCRUBV_DESCR(&scrubv);
 	struct xfs_scrub_vec		*v;
 	unsigned int			scrub_type;
+	bool				need_barrier = false;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -277,8 +321,17 @@ scrub_call_kernel(
 	foreach_scrub_type(scrub_type) {
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
+
+		if (need_barrier) {
+			xfrog_scrubv_add_barrier(&scrubv);
+			need_barrier = false;
+		}
+
 		xfrog_scrubv_add_item(&scrubv, sri, scrub_type, false);
 
+		if (sri->sri_state[scrub_type] & SCRUB_ITEM_BARRIER)
+			need_barrier = true;
+
 		dbg_printf("check %s flags %xh tries %u\n", descr_render(&dsc),
 				sri->sri_state[scrub_type],
 				sri->sri_tries[scrub_type]);
@@ -289,6 +342,16 @@ scrub_call_kernel(
 		return error;
 
 	foreach_xfrog_scrubv_vec(&scrubv, vdesc.idx, v) {
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
@@ -383,15 +446,25 @@ scrub_item_call_kernel_again(
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
@@ -411,7 +484,7 @@ scrub_item_check_file(
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	int				error = 0;
 
-	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK))
+	if (!scrub_item_schedule_work(sri, SCRUB_ITEM_NEEDSCHECK, scrub_deps))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 183b89379cb4..c3eed1b261d5 100644
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
index d9de18ce1795..c5e0a7c08be0 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -13,6 +13,7 @@ void xfrog_scrubv_from_item(struct xfrog_scrubv *scrubv,
 void xfrog_scrubv_add_item(struct xfrog_scrubv *scrubv,
 		const struct scrub_item *sri, unsigned int scrub_type,
 		bool want_repair);
+void xfrog_scrubv_add_barrier(struct xfrog_scrubv *scrubv);
 
 struct scrubv_descr {
 	struct xfrog_scrubv	*scrubv;
@@ -116,6 +117,7 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 
 bool scrub_item_call_kernel_again(struct scrub_item *sri, uint8_t work_mask,
 		const struct scrub_item *old);
-bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags);
+bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags,
+		const unsigned int *schedule_deps);
 
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

