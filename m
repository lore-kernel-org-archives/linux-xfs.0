Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BAEC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vNX5AiQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930E5C433C7;
	Sun, 31 Dec 2023 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064938;
	bh=HNPSLdnNtHz9GJXQzMX8HxLYqrcLBTCz5nv6bhh0tpk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vNX5AiQSTMWuC7piWU7IlmR1RVvBPRcNNZfoGrd0q5j1dd/djX7w8LtMGty3sBVJ+
	 gKU88tyAlHEFSHJ2uhWOUotQLiJmOrUATvQmtnCYAwb35VqpHlwctPNeEcs38lQzDd
	 9D3Ilh2urhHPQf9nmEYj5Z/LtHE1XxhVI7v+CJY+pvAys0GnfZ5UBSMjb4KdWOQ4Ua
	 bI/xxSeXdrRYezo+zCnz4VLNi+Ib5xSJhEW/yxPR5ItoNThsMPQKtfkhpUxHubaAx0
	 4dHaaBUCsVDGkCTh19+777iBkDr35pr4f28TmUfH1WGRPQPRjUU5TKF0WykxzWwTiz
	 j4OskFI1tzWJg==
Date: Sun, 31 Dec 2023 15:22:18 -0800
Subject: [PATCH 10/10] xfs_scrub: try spot repairs of metadata items to make
 scrub progress
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007976.1806194.11727403919106349460.stgit@frogsfrogsfrogs>
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
 scrub/phase2.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/phase3.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/repair.c |   15 +++++++++++
 3 files changed, 163 insertions(+), 1 deletion(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index d435da07125..c24d137358c 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -69,6 +69,53 @@ defer_fs_repair(
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
@@ -82,6 +129,7 @@ scan_ag_metadata(
 	struct scan_ctl			*sctl = arg;
 	char				descr[DESCR_BUFSZ];
 	unsigned int			difficulty;
+	bool				defer_repairs;
 	int				ret;
 
 	if (sctl->aborted)
@@ -97,10 +145,22 @@ scan_ag_metadata(
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
@@ -117,6 +177,7 @@ scan_ag_metadata(
 	if (ret)
 		goto err;
 
+defer:
 	/* Everything else gets fixed during phase 4. */
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret)
@@ -137,11 +198,18 @@ scan_fs_metadata(
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
@@ -150,10 +218,20 @@ scan_fs_metadata(
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
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 09a1ea452bb..046a42c1da8 100644
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
@@ -169,11 +221,28 @@ scrub_inode(
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
index 1ce0283cb7f..7e131001e13 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -859,6 +859,7 @@ repair_item_to_action_item(
 	struct action_item	**aitemp)
 {
 	struct action_item	*aitem;
+	unsigned int		scrub_type;
 
 	if (repair_item_count_needsrepair(sri) == 0)
 		return 0;
@@ -874,6 +875,20 @@ repair_item_to_action_item(
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

