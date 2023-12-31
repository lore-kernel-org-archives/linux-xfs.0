Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B64C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnSWTBUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A68C433C8;
	Sun, 31 Dec 2023 22:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062453;
	bh=s02EnlVfrr146cQ5lboSnMNd7fNRQtQ+ZHExKtxa2iA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GnSWTBUaryf3HZpvu9sHFNi8TIdeYv7hJN/Mc7S+NrlqX3jx38TRV+qqJwr5GA8OR
	 1OSi3Z7LrbjlM/6W88dM/FgBNpFPneR4w4YniqAGkTY62OMzYonh9BKc0fb4qQoxGV
	 szF9cWtxCx4E99VUJdbFUCsmOQF/R9PkSmvqGWT23d/1uDQhb89w1HiSZxH+FX6FED
	 D/9MnYunrhbetH7DeLAEbmH8193KCKkqDnF5+iu+gaztIcQmYC2v39akALal1HnlXd
	 5hnhSMKcsboTlqBzM0Usf7NMRoBo5KArYuwZnEkTS4IJHMh4BuXXE7SSnCKXlAovRJ
	 yoYp6x5jvLRJA==
Date: Sun, 31 Dec 2023 14:40:52 -0800
Subject: [PATCH 2/9] xfs_scrub: use repair_item to direct repair activities
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999472.1797790.14608691085754775710.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
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

Now that the new scrub_item tracks the state of any filesystem object
needing any kind of repair, use it to drive filesystem repairs and
updates to the in-kernel health status when repair finishes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    2 
 scrub/phase2.c |   24 ++--
 scrub/phase3.c |   57 ++++----
 scrub/phase4.c |    7 -
 scrub/phase5.c |    2 
 scrub/phase7.c |    3 
 scrub/repair.c |  381 +++++++++++++++++++++++++++++++-------------------------
 scrub/repair.h |   45 +++++--
 scrub/scrub.c  |   44 ------
 scrub/scrub.h  |   12 --
 10 files changed, 298 insertions(+), 279 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 9920f29a693..b1bbc694e64 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -71,7 +71,7 @@ report_to_kernel(
 	 * Complain if we cannot fail the clean bill of health, unless we're
 	 * just testing repairs.
 	 */
-	if (action_list_length(&alist) > 0 &&
+	if (repair_item_count_needsrepair(&sri) != 0 &&
 	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 		str_info(ctx, _("Couldn't upload clean bill of health."), NULL);
 		action_list_discard(&alist);
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 518923d6628..26ce5818030 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -58,6 +58,7 @@ scan_ag_metadata(
 	void				*arg)
 {
 	struct scrub_item		sri;
+	struct scrub_item		fix_now;
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
@@ -83,7 +84,7 @@ scan_ag_metadata(
 		goto err;
 
 	/* Repair header damage. */
-	ret = action_list_process_or_defer(ctx, agno, &alist);
+	ret = repair_item_corruption(ctx, &sri);
 	if (ret)
 		goto err;
 
@@ -99,17 +100,19 @@ scan_ag_metadata(
 	 * the inobt from rmapbt data, but if the rmapbt is broken even
 	 * at this early phase then we are sunk.
 	 */
-	difficulty = action_list_difficulty(&alist);
-	action_list_find_mustfix(&alist, &immediate_alist);
+	difficulty = repair_item_difficulty(&sri);
+	repair_item_mustfix(&sri, &fix_now);
 	warn_repair_difficulties(ctx, difficulty, descr);
 
 	/* Repair (inode) btree damage. */
-	ret = action_list_process_or_defer(ctx, agno, &immediate_alist);
+	ret = repair_item_corruption(ctx, &fix_now);
 	if (ret)
 		goto err;
 
 	/* Everything else gets fixed during phase 4. */
-	action_list_defer(ctx, agno, &alist);
+	ret = repair_item_defer(ctx, &sri);
+	if (ret)
+		goto err;
 	return;
 err:
 	sctl->aborted = true;
@@ -141,10 +144,14 @@ scan_fs_metadata(
 	}
 
 	/* Complain about metadata corruptions that might not be fixable. */
-	difficulty = action_list_difficulty(&alist);
+	difficulty = repair_item_difficulty(&sri);
 	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
 
-	action_list_defer(ctx, 0, &alist);
+	ret = repair_item_defer(ctx, &sri);
+	if (ret) {
+		sctl->aborted = true;
+		goto out;
+	}
 
 out:
 	if (type == XFS_SCRUB_TYPE_RTBITMAP) {
@@ -193,8 +200,7 @@ phase2_func(
 	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist, &sri);
 	if (ret)
 		goto out_wq;
-	ret = action_list_process(ctx, -1, &alist,
-			XRM_FINAL_WARNING | XRM_NOPROGRESS);
+	ret = repair_item_completely(ctx, &sri);
 	if (ret)
 		goto out_wq;
 
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 642b8406e5b..e602d8c7ec4 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -55,45 +55,48 @@ report_close_error(
  * Defer all the repairs until phase 4, being careful about locking since the
  * inode scrub threads are not per-AG.
  */
-static void
+static int
 defer_inode_repair(
-	struct scrub_inode_ctx	*ictx,
-	xfs_agnumber_t		agno,
-	struct action_list	*alist)
+	struct scrub_inode_ctx		*ictx,
+	const struct xfs_bulkstat	*bstat,
+	struct scrub_item		*sri)
 {
-	if (alist->nr == 0)
-		return;
+	struct action_item		*aitem = NULL;
+	xfs_agnumber_t			agno;
+	int				ret;
 
+	ret = repair_item_to_action_item(ictx->ctx, sri, &aitem);
+	if (ret || !aitem)
+		return ret;
+
+	agno = cvt_ino_to_agno(&ictx->ctx->mnt, bstat->bs_ino);
 	pthread_mutex_lock(&ictx->locks[agno]);
-	action_list_defer(ictx->ctx, agno, alist);
+	action_list_add(&ictx->ctx->action_lists[agno], aitem);
 	pthread_mutex_unlock(&ictx->locks[agno]);
+	return 0;
 }
 
-/* Run repair actions now and defer unfinished items for later. */
+/* Run repair actions now and leave unfinished items for later. */
 static int
 try_inode_repair(
-	struct scrub_inode_ctx	*ictx,
-	int			fd,
-	xfs_agnumber_t		agno,
-	struct action_list	*alist)
+	struct scrub_inode_ctx		*ictx,
+	struct scrub_item		*sri,
+	int				fd,
+	const struct xfs_bulkstat	*bstat)
 {
-	int			ret;
-
 	/*
 	 * If at the start of phase 3 we already had ag/rt metadata repairs
 	 * queued up for phase 4, leave the action list untouched so that file
-	 * metadata repairs will be deferred in scan order until phase 4.
+	 * metadata repairs will be deferred until phase 4.
 	 */
 	if (ictx->always_defer_repairs)
 		return 0;
 
-	ret = action_list_process(ictx->ctx, fd, alist,
-			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
-	if (ret)
-		return ret;
-
-	defer_inode_repair(ictx, agno, alist);
-	return 0;
+	/*
+	 * Try to repair the file metadata.  Unfixed metadata will remain in
+	 * the scrub item state to be queued as a single action item.
+	 */
+	return repair_file_corruption(ictx->ctx, sri, fd);
 }
 
 /* Verify the contents, xattrs, and extent maps of an inode. */
@@ -108,13 +111,11 @@ scrub_inode(
 	struct scrub_item	sri;
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
-	xfs_agnumber_t		agno;
 	int			fd = -1;
 	int			error;
 
 	scrub_item_init_file(&sri, bstat);
 	action_list_init(&alist);
-	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
 
 	/*
@@ -149,7 +150,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, fd, agno, &alist);
+	error = try_inode_repair(ictx, &sri, fd, bstat);
 	if (error)
 		goto out;
 
@@ -164,7 +165,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, fd, agno, &alist);
+	error = try_inode_repair(ictx, &sri, fd, bstat);
 	if (error)
 		goto out;
 
@@ -204,7 +205,7 @@ scrub_inode(
 		goto out;
 
 	/* Try to repair the file while it's open. */
-	error = try_inode_repair(ictx, fd, agno, &alist);
+	error = try_inode_repair(ictx, &sri, fd, bstat);
 	if (error)
 		goto out;
 
@@ -221,7 +222,7 @@ scrub_inode(
 	progress_add(1);
 
 	if (!error && !ictx->aborted)
-		defer_inode_repair(ictx, agno, &alist);
+		error = defer_inode_repair(ictx, bstat, &sri);
 
 	if (fd >= 0) {
 		int	err2;
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 1c4aab996ab..98518635b2b 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -40,7 +40,7 @@ repair_ag(
 
 	/* Repair anything broken until we fail to make progress. */
 	do {
-		ret = action_list_process(ctx, -1, alist, flags);
+		ret = action_list_process(ctx, alist, flags);
 		if (ret) {
 			*aborted = true;
 			return;
@@ -55,7 +55,7 @@ repair_ag(
 
 	/* Try once more, but this time complain if we can't fix things. */
 	flags |= XRM_FINAL_WARNING;
-	ret = action_list_process(ctx, -1, alist, flags);
+	ret = action_list_process(ctx, alist, flags);
 	if (ret)
 		*aborted = true;
 }
@@ -167,8 +167,7 @@ phase4_func(
 	}
 
 	/* Repair counters before starting on the rest. */
-	ret = action_list_process(ctx, -1, &alist,
-			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
+	ret = repair_item_corruption(ctx, &sri);
 	if (ret)
 		return ret;
 	action_list_discard(&alist);
diff --git a/scrub/phase5.c b/scrub/phase5.c
index ace6c3a9843..79bfea8f6b5 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -421,7 +421,7 @@ fs_scan_worker(
 		goto out;
 	}
 
-	ret = action_list_process(ctx, ctx->mnt.fd, &item->alist,
+	ret = action_list_process(ctx, &item->alist,
 			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret) {
 		str_liberror(ctx, ret, _("repairing fs scan metadata"));
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 314a886b091..404bfb82243 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -123,8 +123,7 @@ phase7_func(
 	error = scrub_summary_metadata(ctx, &alist, &sri);
 	if (error)
 		return error;
-	error = action_list_process(ctx, -1, &alist,
-			XRM_FINAL_WARNING | XRM_NOPROGRESS);
+	error = repair_item_completely(ctx, &sri);
 	if (error)
 		return error;
 
diff --git a/scrub/repair.c b/scrub/repair.c
index 30817d268d6..6e09c592ed4 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -27,7 +27,8 @@ static enum check_outcome
 xfs_repair_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_fd			*xfdp,
-	struct action_item		*aitem,
+	unsigned int			scrub_type,
+	struct scrub_item		*sri,
 	unsigned int			repair_flags)
 {
 	struct xfs_scrub_metadata	meta = { 0 };
@@ -35,20 +36,20 @@ xfs_repair_metadata(
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	int				error;
 
-	assert(aitem->type < XFS_SCRUB_TYPE_NR);
+	assert(scrub_type < XFS_SCRUB_TYPE_NR);
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	meta.sm_type = aitem->type;
-	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	meta.sm_type = scrub_type;
+	meta.sm_flags = XFS_SCRUB_IFLAG_REPAIR;
 	if (use_force_rebuild)
 		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
-	switch (xfrog_scrubbers[aitem->type].group) {
+	switch (xfrog_scrubbers[scrub_type].group) {
 	case XFROG_SCRUB_GROUP_AGHEADER:
 	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = aitem->agno;
+		meta.sm_agno = sri->sri_agno;
 		break;
 	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = aitem->ino;
-		meta.sm_gen = aitem->gen;
+		meta.sm_ino = sri->sri_ino;
+		meta.sm_gen = sri->sri_gen;
 		break;
 	default:
 		break;
@@ -58,9 +59,10 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
+	oldm.sm_flags = sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY;
 	descr_set(&dsc, &oldm);
 
-	if (needs_repair(&meta))
+	if (needs_repair(&oldm))
 		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
 	else if (debug || verbose)
 		str_info(ctx, descr_render(&dsc),
@@ -92,8 +94,10 @@ _("Filesystem is shut down, aborting."));
 		 * it done and move on.
 		 */
 		if (is_unoptimized(&oldm) ||
-		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+			scrub_item_clean_state(sri, scrub_type);
 			return CHECK_DONE;
+		}
 		/*
 		 * If we're in no-complain mode, requeue the check for
 		 * later.  It's possible that an error in another
@@ -109,6 +113,7 @@ _("Filesystem is shut down, aborting."));
 		/* Kernel doesn't know how to repair this? */
 		str_corrupt(ctx, descr_render(&dsc),
 _("Don't know how to fix; offline repair required."));
+		scrub_item_clean_state(sri, scrub_type);
 		return CHECK_DONE;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
@@ -118,23 +123,28 @@ _("Read-only filesystem; cannot make changes."));
 		return CHECK_ABORT;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
+		scrub_item_clean_state(sri, scrub_type);
 		return CHECK_DONE;
 	case ENOMEM:
 	case ENOSPC:
 		/* Don't care if preen fails due to low resources. */
-		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
+		if (is_unoptimized(&oldm) && !needs_repair(&oldm)) {
+			scrub_item_clean_state(sri, scrub_type);
 			return CHECK_DONE;
+		}
 		fallthrough;
 	default:
 		/*
-		 * Operational error.  If the caller doesn't want us
-		 * to complain about repair failures, tell the caller
-		 * to requeue the repair for later and don't say a
-		 * thing.  Otherwise, print error and bail out.
+		 * Operational error.  If the caller doesn't want us to
+		 * complain about repair failures, tell the caller to requeue
+		 * the repair for later and don't say a thing.  Otherwise,
+		 * print an error, mark the item clean because we're done with
+		 * trying to repair it, and bail out.
 		 */
 		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		str_liberror(ctx, error, descr_render(&dsc));
+		scrub_item_clean_state(sri, scrub_type);
 		return CHECK_DONE;
 	}
 
@@ -186,12 +196,13 @@ _("Repair unsuccessful; offline repair required."));
 			record_preen(ctx, descr_render(&dsc),
  _("Optimization successful."));
 	}
+
+	scrub_item_clean_state(sri, scrub_type);
 	return CHECK_DONE;
 }
 
 /*
  * Prioritize action items in order of how long we can wait.
- * 0 = do it now, 10000 = do it later.
  *
  * To minimize the amount of repair work, we want to prioritize metadata
  * objects by perceived corruptness.  If CORRUPT is set, the fields are
@@ -207,104 +218,34 @@ _("Repair unsuccessful; offline repair required."));
  * in order.
  */
 
-/* Sort action items in severity order. */
-static int
-PRIO(
-	const struct action_item *aitem,
-	int			order)
-{
-	if (aitem->flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return order;
-	else if (aitem->flags & XFS_SCRUB_OFLAG_XCORRUPT)
-		return 100 + order;
-	else if (aitem->flags & XFS_SCRUB_OFLAG_XFAIL)
-		return 200 + order;
-	else if (aitem->flags & XFS_SCRUB_OFLAG_PREEN)
-		return 300 + order;
-	abort();
-}
-
-/* Sort the repair items in dependency order. */
-static int
-xfs_action_item_priority(
-	const struct action_item	*aitem)
-{
-	switch (aitem->type) {
-	case XFS_SCRUB_TYPE_SB:
-	case XFS_SCRUB_TYPE_AGF:
-	case XFS_SCRUB_TYPE_AGFL:
-	case XFS_SCRUB_TYPE_AGI:
-	case XFS_SCRUB_TYPE_BNOBT:
-	case XFS_SCRUB_TYPE_CNTBT:
-	case XFS_SCRUB_TYPE_INOBT:
-	case XFS_SCRUB_TYPE_FINOBT:
-	case XFS_SCRUB_TYPE_REFCNTBT:
-	case XFS_SCRUB_TYPE_RMAPBT:
-	case XFS_SCRUB_TYPE_INODE:
-	case XFS_SCRUB_TYPE_BMBTD:
-	case XFS_SCRUB_TYPE_BMBTA:
-	case XFS_SCRUB_TYPE_BMBTC:
-		return PRIO(aitem, aitem->type - 1);
-	case XFS_SCRUB_TYPE_DIR:
-	case XFS_SCRUB_TYPE_XATTR:
-	case XFS_SCRUB_TYPE_SYMLINK:
-	case XFS_SCRUB_TYPE_PARENT:
-		return PRIO(aitem, XFS_SCRUB_TYPE_DIR);
-	case XFS_SCRUB_TYPE_RTBITMAP:
-	case XFS_SCRUB_TYPE_RTSUM:
-		return PRIO(aitem, XFS_SCRUB_TYPE_RTBITMAP);
-	case XFS_SCRUB_TYPE_UQUOTA:
-	case XFS_SCRUB_TYPE_GQUOTA:
-	case XFS_SCRUB_TYPE_PQUOTA:
-		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
-	case XFS_SCRUB_TYPE_QUOTACHECK:
-		/* This should always go after [UGP]QUOTA no matter what. */
-		return PRIO(aitem, aitem->type);
-	case XFS_SCRUB_TYPE_FSCOUNTERS:
-		/* This should always go after AG headers no matter what. */
-		return PRIO(aitem, INT_MAX);
-	}
-	abort();
-}
-
-/* Make sure that btrees get repaired before headers. */
-static int
-xfs_action_item_compare(
-	void				*priv,
-	const struct list_head		*a,
-	const struct list_head		*b)
-{
-	const struct action_item	*ra;
-	const struct action_item	*rb;
-
-	ra = container_of(a, struct action_item, list);
-	rb = container_of(b, struct action_item, list);
-
-	return xfs_action_item_priority(ra) - xfs_action_item_priority(rb);
-}
+struct action_item {
+	struct list_head	list;
+	struct scrub_item	sri;
+};
 
 /*
  * Figure out which AG metadata must be fixed before we can move on
  * to the inode scan.
  */
 void
-action_list_find_mustfix(
-	struct action_list		*alist,
-	struct action_list		*immediate_alist)
+repair_item_mustfix(
+	struct scrub_item	*sri,
+	struct scrub_item	*fix_now)
 {
-	struct action_item		*n;
-	struct action_item		*aitem;
+	unsigned int		scrub_type;
 
-	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+	assert(sri->sri_agno != -1U);
+	scrub_item_init_ag(fix_now, sri->sri_agno);
+
+	foreach_scrub_type(scrub_type) {
+		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_CORRUPT))
 			continue;
-		switch (aitem->type) {
+
+		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
-			alist->nr--;
-			list_move_tail(&aitem->list, &immediate_alist->list);
-			immediate_alist->nr++;
+			fix_now->sri_state[scrub_type] |= SCRUB_ITEM_CORRUPT;
 			break;
 		}
 	}
@@ -312,19 +253,19 @@ action_list_find_mustfix(
 
 /* Determine if primary or secondary metadata are inconsistent. */
 unsigned int
-action_list_difficulty(
-	const struct action_list	*alist)
+repair_item_difficulty(
+	const struct scrub_item	*sri)
 {
-	struct action_item		*aitem, *n;
-	unsigned int			ret = 0;
+	unsigned int		scrub_type;
+	unsigned int		ret = 0;
 
-	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & (XFS_SCRUB_OFLAG_CORRUPT |
-				      XFS_SCRUB_OFLAG_XCORRUPT |
-				      XFS_SCRUB_OFLAG_XFAIL)))
+	foreach_scrub_type(scrub_type) {
+		if (!(sri->sri_state[scrub_type] & (XFS_SCRUB_OFLAG_CORRUPT |
+						    XFS_SCRUB_OFLAG_XCORRUPT |
+						    XFS_SCRUB_OFLAG_XFAIL)))
 			continue;
 
-		switch (aitem->type) {
+		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_RMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
@@ -404,13 +345,19 @@ action_list_init(
 	alist->sorted = false;
 }
 
-/* Number of repairs in this list. */
+/* Number of pending repairs in this list. */
 unsigned long long
 action_list_length(
 	struct action_list		*alist)
 {
-	return alist->nr;
-};
+	struct action_item		*aitem;
+	unsigned long long		ret = 0;
+
+	list_for_each_entry(aitem, &alist->list, list)
+		ret += repair_item_count_needsrepair(&aitem->sri);
+
+	return ret;
+}
 
 /* Add to the list of repairs. */
 void
@@ -423,60 +370,78 @@ action_list_add(
 	alist->sorted = false;
 }
 
-/* Splice two repair lists. */
-void
-action_list_splice(
-	struct action_list		*dest,
-	struct action_list		*src)
-{
-	if (src->nr == 0)
-		return;
-
-	list_splice_tail_init(&src->list, &dest->list);
-	dest->nr += src->nr;
-	src->nr = 0;
-	dest->sorted = false;
-}
-
 /* Repair everything on this list. */
 int
 action_list_process(
 	struct scrub_ctx		*ctx,
-	int				fd,
 	struct action_list		*alist,
 	unsigned int			repair_flags)
+{
+	struct action_item		*aitem;
+	struct action_item		*n;
+	int				ret;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		if (scrub_excessive_errors(ctx))
+			return ECANCELED;
+
+		ret = repair_item(ctx, &aitem->sri, repair_flags);
+		if (ret)
+			break;
+
+		if (repair_item_count_needsrepair(&aitem->sri) == 0) {
+			list_del(&aitem->list);
+			free(aitem);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * For a given filesystem object, perform all repairs of a given class
+ * (corrupt, xcorrupt, xfail, preen) if the repair item says it's needed.
+ */
+static int
+repair_item_class(
+	struct scrub_ctx		*ctx,
+	struct scrub_item		*sri,
+	int				override_fd,
+	uint8_t				repair_mask,
+	unsigned int			flags)
 {
 	struct xfs_fd			xfd;
 	struct xfs_fd			*xfdp = &ctx->mnt;
-	struct action_item		*aitem;
-	struct action_item		*n;
-	enum check_outcome		fix;
+	unsigned int			scrub_type;
+
+	if (ctx->mode < SCRUB_MODE_REPAIR)
+		return 0;
 
 	/*
 	 * If the caller passed us a file descriptor for a scrub, use it
 	 * instead of scrub-by-handle because this enables the kernel to skip
 	 * costly inode btree lookups.
 	 */
-	if (fd >= 0) {
+	if (override_fd >= 0) {
 		memcpy(&xfd, xfdp, sizeof(xfd));
-		xfd.fd = fd;
+		xfd.fd = override_fd;
 		xfdp = &xfd;
 	}
 
-	if (!alist->sorted) {
-		list_sort(NULL, &alist->list, xfs_action_item_compare);
-		alist->sorted = true;
-	}
+	foreach_scrub_type(scrub_type) {
+		enum check_outcome	fix;
 
-	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		fix = xfs_repair_metadata(ctx, xfdp, aitem, repair_flags);
+		if (scrub_excessive_errors(ctx))
+			return ECANCELED;
+
+		if (!(sri->sri_state[scrub_type] & repair_mask))
+			continue;
+
+		fix = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
 		switch (fix) {
 		case CHECK_DONE:
-			if (!(repair_flags & XRM_NOPROGRESS))
+			if (!(flags & XRM_NOPROGRESS))
 				progress_add(1);
-			alist->nr--;
-			list_del(&aitem->list);
-			free(aitem);
 			continue;
 		case CHECK_ABORT:
 			return ECANCELED;
@@ -487,37 +452,113 @@ action_list_process(
 		}
 	}
 
-	if (scrub_excessive_errors(ctx))
-		return ECANCELED;
+	return 0;
+}
+
+/*
+ * Repair all parts (i.e. scrub types) of this filesystem object for which
+ * corruption has been observed directly.  Other types of repair work (fixing
+ * cross referencing problems and preening) are deferred.
+ *
+ * This function should only be called to perform spot repairs of fs objects
+ * during phase 2 and 3 while we still have open handles to those objects.
+ */
+int
+repair_item_corruption(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri)
+{
+	return repair_item_class(ctx, sri, -1, SCRUB_ITEM_CORRUPT,
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
+}
+
+/* Repair all parts of this file, similar to repair_item_corruption. */
+int
+repair_file_corruption(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri,
+	int			override_fd)
+{
+	return repair_item_class(ctx, sri, override_fd, SCRUB_ITEM_CORRUPT,
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
+}
+
+/*
+ * Repair everything in this filesystem object that needs it.  This includes
+ * cross-referencing and preening.
+ */
+int
+repair_item(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri,
+	unsigned int		flags)
+{
+	int			ret;
+
+	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_CORRUPT, flags);
+	if (ret)
+		return ret;
+
+	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_XCORRUPT, flags);
+	if (ret)
+		return ret;
+
+	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_XFAIL, flags);
+	if (ret)
+		return ret;
+
+	return repair_item_class(ctx, sri, -1, SCRUB_ITEM_PREEN, flags);
+}
+
+/* Create an action item around a scrub item that needs repairs. */
+int
+repair_item_to_action_item(
+	struct scrub_ctx	*ctx,
+	const struct scrub_item	*sri,
+	struct action_item	**aitemp)
+{
+	struct action_item	*aitem;
+
+	if (repair_item_count_needsrepair(sri) == 0)
+		return 0;
+
+	aitem = malloc(sizeof(struct action_item));
+	if (!aitem) {
+		int		error = errno;
+
+		str_liberror(ctx, error, _("creating repair action item"));
+		return error;
+	}
+
+	INIT_LIST_HEAD(&aitem->list);
+	memcpy(&aitem->sri, sri, sizeof(struct scrub_item));
+
+	*aitemp = aitem;
 	return 0;
 }
 
 /* Defer all the repairs until phase 4. */
-void
-action_list_defer(
-	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist)
+int
+repair_item_defer(
+	struct scrub_ctx	*ctx,
+	const struct scrub_item	*sri)
 {
+	struct action_item	*aitem = NULL;
+	unsigned int		agno;
+	int			error;
+
+	error = repair_item_to_action_item(ctx, sri, &aitem);
+	if (error || !aitem)
+		return error;
+
+	if (sri->sri_agno != -1U)
+		agno = sri->sri_agno;
+	else if (sri->sri_ino != -1ULL && sri->sri_gen != -1U)
+		agno = cvt_ino_to_agno(&ctx->mnt, sri->sri_ino);
+	else
+		agno = 0;
 	ASSERT(agno < ctx->mnt.fsgeom.agcount);
 
-	action_list_splice(&ctx->action_lists[agno], alist);
-}
-
-/* Run actions now and defer unfinished items for later. */
-int
-action_list_process_or_defer(
-	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist)
-{
-	int				ret;
-
-	ret = action_list_process(ctx, -1, alist,
-			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
-	if (ret)
-		return ret;
-
-	action_list_defer(ctx, agno, alist);
+	action_list_add(&ctx->action_lists[agno], aitem);
 	return 0;
 }
diff --git a/scrub/repair.h b/scrub/repair.h
index b61bd29c860..463a3f9bfef 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -12,6 +12,8 @@ struct action_list {
 	bool			sorted;
 };
 
+struct action_item;
+
 int action_lists_alloc(size_t nr, struct action_list **listsp);
 void action_lists_free(struct action_list **listsp);
 
@@ -25,16 +27,14 @@ static inline bool action_list_empty(const struct action_list *alist)
 unsigned long long action_list_length(struct action_list *alist);
 void action_list_add(struct action_list *dest, struct action_item *item);
 void action_list_discard(struct action_list *alist);
-void action_list_splice(struct action_list *dest, struct action_list *src);
 
-void action_list_find_mustfix(struct action_list *actions,
-		struct action_list *immediate_alist);
+void repair_item_mustfix(struct scrub_item *sri, struct scrub_item *fix_now);
 
 /* Primary metadata is corrupt */
 #define REPAIR_DIFFICULTY_PRIMARY	(1U << 0)
 /* Secondary metadata is corrupt */
 #define REPAIR_DIFFICULTY_SECONDARY	(1U << 1)
-unsigned int action_list_difficulty(const struct action_list *actions);
+unsigned int repair_item_difficulty(const struct scrub_item *sri);
 
 /*
  * Only ask the kernel to repair this object if the kernel directly told us it
@@ -49,11 +49,36 @@ unsigned int action_list_difficulty(const struct action_list *actions);
 /* Don't call progress_add after repairing an item. */
 #define XRM_NOPROGRESS		(1U << 2)
 
-int action_list_process(struct scrub_ctx *ctx, int fd,
-		struct action_list *alist, unsigned int repair_flags);
-void action_list_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist);
-int action_list_process_or_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist);
+int action_list_process(struct scrub_ctx *ctx, struct action_list *alist,
+		unsigned int repair_flags);
+int repair_item_corruption(struct scrub_ctx *ctx, struct scrub_item *sri);
+int repair_file_corruption(struct scrub_ctx *ctx, struct scrub_item *sri,
+		int override_fd);
+int repair_item(struct scrub_ctx *ctx, struct scrub_item *sri,
+		unsigned int repair_flags);
+int repair_item_to_action_item(struct scrub_ctx *ctx,
+		const struct scrub_item *sri, struct action_item **aitemp);
+int repair_item_defer(struct scrub_ctx *ctx, const struct scrub_item *sri);
+
+static inline unsigned int
+repair_item_count_needsrepair(
+	const struct scrub_item	*sri)
+{
+	unsigned int		scrub_type;
+	unsigned int		nr = 0;
+
+	foreach_scrub_type(scrub_type)
+		if (sri->sri_state[scrub_type] & SCRUB_ITEM_REPAIR_ANY)
+			nr++;
+	return nr;
+}
+
+static inline int
+repair_item_completely(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri)
+{
+	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
+}
 
 #endif /* XFS_SCRUB_REPAIR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index e242e38ed0c..54f397fb92a 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -217,42 +217,6 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 	}
 }
 
-/* Save a scrub context for later repairs. */
-static int
-scrub_save_repair(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist,
-	struct xfs_scrub_metadata	*meta)
-{
-	struct action_item		*aitem;
-
-	/* Schedule this item for later repairs. */
-	aitem = malloc(sizeof(struct action_item));
-	if (!aitem) {
-		str_errno(ctx, _("adding item to repair list"));
-		return errno;
-	}
-
-	memset(aitem, 0, sizeof(*aitem));
-	aitem->type = meta->sm_type;
-	aitem->flags = meta->sm_flags;
-	switch (xfrog_scrubbers[meta->sm_type].group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		aitem->agno = meta->sm_agno;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		aitem->ino = meta->sm_ino;
-		aitem->gen = meta->sm_gen;
-		break;
-	default:
-		break;
-	}
-
-	action_list_add(alist, aitem);
-	return 0;
-}
-
 /*
  * Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later.
  *
@@ -272,7 +236,6 @@ scrub_meta_type(
 		.sm_agno		= agno,
 	};
 	enum check_outcome		fix;
-	int				ret;
 
 	background_sleep();
 
@@ -285,10 +248,7 @@ scrub_meta_type(
 		return ECANCELED;
 	case CHECK_REPAIR:
 		scrub_item_save_state(sri, type, meta.sm_flags);
-		ret = scrub_save_repair(ctx, alist, &meta);
-		if (ret)
-			return ret;
-		fallthrough;
+		return 0;
 	case CHECK_DONE:
 		scrub_item_clean_state(sri, type);
 		return 0;
@@ -469,7 +429,7 @@ scrub_file(
 	}
 
 	scrub_item_save_state(sri, type, meta.sm_flags);
-	return scrub_save_repair(ctx, alist, &meta);
+	return 0;
 }
 
 /* Dump a scrub item for debugging purposes. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 21ea4147e0f..0d6825a5a95 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -14,8 +14,6 @@ enum check_outcome {
 	CHECK_RETRY,	/* repair failed, try again later */
 };
 
-struct action_item;
-
 /*
  * These flags record the metadata object state that the kernel returned.
  * We want to remember if the object was corrupt, if the cross-referencing
@@ -110,14 +108,4 @@ int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
 		unsigned int type, struct action_list *alist,
 		struct scrub_item *sri);
 
-/* Repair parameters are the scrub inputs and retry count. */
-struct action_item {
-	struct list_head	list;
-	__u64			ino;
-	__u32			type;
-	__u32			flags;
-	__u32			gen;
-	__u32			agno;
-};
-
 #endif /* XFS_SCRUB_SCRUB_H_ */

