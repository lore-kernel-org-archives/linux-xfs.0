Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E84FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiLaD1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:27:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D4E13D49
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21CABB81E5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECEAC433EF;
        Sat, 31 Dec 2022 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457257;
        bh=ObR+DQwouU/7/H8MVzgsFr3kpjWcTLoWBClV6Ut4laY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MBzt7aC8rzdSWOqwKrEu9Xow20tTka6bv5ZRyLVCqAw+zmDMBUVy5PsyRNcnyqm8G
         3rjeqAEWo6Qv3mqJ4y2J/676f0hWCQ7FCKTq6IiSN1Z3kOfXU7+UrU7aIQm6kNs249
         d66C0Z/Ututifb89Iiqh7MIdEsoaiprqVTmwWP1mVqrbAhMw5puSE9KZsz0sHUgZUw
         ffYMjGYShW3OKf7KmIuMWsItYmfQwzXq0HxrO0DNj2WfYQLjBTpzkMAk2nc423xx90
         doKjssX/XpUNMNdBqHQYor7ykzMyI0jEC92Ue6ifBl1Nx0sGYeYUVjFBsklqu+O0/T
         Jm4y125gk9n8Q==
Subject: [PATCH 11/11] xfs_scrub: try spot repairs of metadata items to make
 scrub progress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884179.739244.14046030541432078868.stgit@magnolia>
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

Now that we've enabled scrub dependency barriers, it's possible that a
scrub_item_check call will return with some of the scrub items still in
NEEDSCHECK state.  If, for example, scrub type B depends on scrub type
A being clean and A is not clean, B will still be in NEEDSCHECK state.

In order to make as much scanning progress as possible during phase 2
and phase 3, allow ourselves to try some spot repairs in the hopes that
it will enable us to make progress towards at least scanning the whole
metadata item.  If we can't make any forward progress, we'll queue the
scrub item for repair in phase 4, which means that anything still in in
NEEDSCHECK state becomes CORRUPT state.  (At worst, the NEEDSCHECK item
will actually be clean by phase 4, and xfs_scrub will report that it
didn't need any work after all.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/phase3.c |   71 +++++++++++++++++++++++++++++++++++++++++++-
 scrub/repair.c |   15 +++++++++
 3 files changed, 176 insertions(+), 1 deletion(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index e4c7d32d75e..e2d46cba640 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -77,6 +77,53 @@ defer_fs_repair(
 	return 0;
 }
 
+/*
+ * If we couldn't check all the scheduled metadata items, try performing spot
+ * repairs until we check everything or stop making forward progress.
+ */
+static int
+repair_and_scrub_loop(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri,
+	const char		*descr,
+	bool			*defer)
+{
+	unsigned int		to_check;
+	int			ret;
+
+	*defer = false;
+	if (ctx->mode != SCRUB_MODE_REPAIR)
+		return 0;
+
+	to_check = scrub_item_count_needscheck(sri);
+	while (to_check > 0) {
+		unsigned int	nr;
+
+		ret = repair_item_corruption(ctx, sri);
+		if (ret)
+			return ret;
+
+		ret = scrub_item_check(ctx, sri);
+		if (ret)
+			return ret;
+
+		nr = scrub_item_count_needscheck(sri);
+		if (nr == to_check) {
+			/*
+			 * We cannot make forward scanning progress with this
+			 * metadata, so defer the rest until phase 4.
+			 */
+			str_info(ctx, descr,
+ _("Unable to make forward checking progress; will try again in phase 4."));
+			*defer = true;
+			return 0;
+		}
+		to_check = nr;
+	}
+
+	return 0;
+}
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -90,6 +137,7 @@ scan_ag_metadata(
 	struct scan_ctl			*sctl = arg;
 	char				descr[DESCR_BUFSZ];
 	unsigned int			difficulty;
+	bool				defer_repairs;
 	int				ret;
 
 	if (sctl->aborted)
@@ -105,10 +153,22 @@ scan_ag_metadata(
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_AGHEADER);
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_PERAG);
 
+	/*
+	 * Try to check all of the AG metadata items that we just scheduled.
+	 * If we return with some types still needing a check, try repairing
+	 * any damaged metadata that we've found so far, and try again.  Abort
+	 * if we stop making forward progress.
+	 */
 	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		goto err;
 
+	ret = repair_and_scrub_loop(ctx, &sri, descr, &defer_repairs);
+	if (ret)
+		goto err;
+	if (defer_repairs)
+		goto defer;
+
 	/*
 	 * Figure out if we need to perform early fixing.  The only
 	 * reason we need to do this is if the inobt is broken, which
@@ -125,6 +185,7 @@ scan_ag_metadata(
 	if (ret)
 		goto err;
 
+defer:
 	/* Everything else gets fixed during phase 4. */
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret)
@@ -145,11 +206,18 @@ scan_metafile(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
 	unsigned int		difficulty;
+	bool			defer_repairs;
 	int			ret;
 
 	if (sctl->aborted)
 		goto out;
 
+	/*
+	 * Try to check all of the metadata files that we just scheduled.  If
+	 * we return with some types still needing a check, try repairing any
+	 * damaged metadata that we've found so far, and try again.  Abort if
+	 * we stop making forward progress.
+	 */
 	scrub_item_init_fs(&sri);
 	scrub_item_schedule(&sri, type);
 	ret = scrub_item_check(ctx, &sri);
@@ -158,10 +226,20 @@ scan_metafile(
 		goto out;
 	}
 
+	ret = repair_and_scrub_loop(ctx, &sri, xfrog_scrubbers[type].descr,
+			&defer_repairs);
+	if (ret) {
+		sctl->aborted = true;
+		goto out;
+	}
+	if (defer_repairs)
+		goto defer;
+
 	/* Complain about metadata corruptions that might not be fixable. */
 	difficulty = repair_item_difficulty(&sri);
 	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
 
+defer:
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret) {
 		sctl->aborted = true;
@@ -188,6 +266,7 @@ scan_rtgroup_metadata(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
 	char			descr[DESCR_BUFSZ];
+	bool			defer_repairs;
 	int			ret;
 
 	if (sctl->aborted)
@@ -196,6 +275,12 @@ scan_rtgroup_metadata(
 	scrub_item_init_rtgroup(&sri, rgno);
 	snprintf(descr, DESCR_BUFSZ, _("rtgroup %u"), rgno);
 
+	/*
+	 * Try to check all of the rtgroup metadata items that we just
+	 * scheduled.  If we return with some types still needing a check, try
+	 * repairing any damaged metadata that we've found so far, and try
+	 * again.  Abort if we stop making forward progress.
+	 */
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_RTGROUP);
 	ret = scrub_item_check(ctx, &sri);
 	if (ret) {
@@ -203,6 +288,12 @@ scan_rtgroup_metadata(
 		goto out;
 	}
 
+	ret = repair_and_scrub_loop(ctx, &sri, descr, &defer_repairs);
+	if (ret) {
+		sctl->aborted = true;
+		goto out;
+	}
+
 	/* Everything else gets fixed during phase 4. */
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret) {
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 14fff96ff77..43495b3b746 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -99,6 +99,58 @@ try_inode_repair(
 	return repair_file_corruption(ictx->ctx, sri, fd);
 }
 
+/*
+ * If we couldn't check all the scheduled file metadata items, try performing
+ * spot repairs until we check everything or stop making forward progress.
+ */
+static int
+repair_and_scrub_inode_loop(
+	struct scrub_ctx	*ctx,
+	struct xfs_bulkstat	*bstat,
+	int			fd,
+	struct scrub_item	*sri,
+	bool			*defer)
+{
+	unsigned int		to_check;
+	int			error;
+
+	*defer = false;
+	if (ctx->mode != SCRUB_MODE_REPAIR)
+		return 0;
+
+	to_check = scrub_item_count_needscheck(sri);
+	while (to_check > 0) {
+		unsigned int	nr;
+
+		error = repair_file_corruption(ctx, sri, fd);
+		if (error)
+			return error;
+
+		error = scrub_item_check_file(ctx, sri, fd);
+		if (error)
+			return error;
+
+		nr = scrub_item_count_needscheck(sri);
+		if (nr == to_check) {
+			char	descr[DESCR_BUFSZ];
+
+			/*
+			 * We cannot make forward scanning progress with this
+			 * inode, so defer the rest until phase 4.
+			 */
+			scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ,
+					bstat->bs_ino, bstat->bs_gen, NULL);
+			str_info(ctx, descr,
+ _("Unable to make forward checking progress; will try again in phase 4."));
+			*defer = true;
+			return 0;
+		}
+		to_check = nr;
+	}
+
+	return 0;
+}
+
 /* Verify the contents, xattrs, and extent maps of an inode. */
 static int
 scrub_inode(
@@ -160,11 +212,28 @@ scrub_inode(
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_XATTR);
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_PARENT);
 
-	/* Try to check and repair the file while it's open. */
+	/*
+	 * Try to check all of the metadata items that we just scheduled.  If
+	 * we return with some types still needing a check and the space
+	 * metadata isn't also in need of repairs, try repairing any damaged
+	 * file metadata that we've found so far, and try checking the file
+	 * again.  Worst case, defer the repairs and the checks to phase 4 if
+	 * we can't make any progress on anything.
+	 */
 	error = scrub_item_check_file(ctx, &sri, fd);
 	if (error)
 		goto out;
 
+	if (!ictx->always_defer_repairs) {
+		bool	defer_repairs;
+
+		error = repair_and_scrub_inode_loop(ctx, bstat, fd, &sri,
+				&defer_repairs);
+		if (error || defer_repairs)
+			goto out;
+	}
+
+	/* Try to repair the file while it's open. */
 	error = try_inode_repair(ictx, &sri, fd);
 	if (error)
 		goto out;
diff --git a/scrub/repair.c b/scrub/repair.c
index 91259feb758..bf843522993 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -849,6 +849,7 @@ repair_item_to_action_item(
 	struct action_item	**aitemp)
 {
 	struct action_item	*aitem;
+	unsigned int		scrub_type;
 
 	if (repair_item_count_needsrepair(sri) == 0)
 		return 0;
@@ -864,6 +865,20 @@ repair_item_to_action_item(
 	INIT_LIST_HEAD(&aitem->list);
 	memcpy(&aitem->sri, sri, sizeof(struct scrub_item));
 
+	/*
+	 * If the scrub item indicates that there is unchecked metadata, assume
+	 * that the scrub type checker depends on something that couldn't be
+	 * fixed.  Mark that type as corrupt so that phase 4 will try it again.
+	 */
+	foreach_scrub_type(scrub_type) {
+		__u8		*state = aitem->sri.sri_state;
+
+		if (state[scrub_type] & SCRUB_ITEM_NEEDSCHECK) {
+			state[scrub_type] &= ~SCRUB_ITEM_NEEDSCHECK;
+			state[scrub_type] |= SCRUB_ITEM_CORRUPT;
+		}
+	}
+
 	*aitemp = aitem;
 	return 0;
 }

