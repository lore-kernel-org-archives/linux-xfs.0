Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E89EC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnqhxwQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7DFC433C8;
	Sun, 31 Dec 2023 22:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062468;
	bh=KFUjHXkILOUcB+JpmoFjlA/ESaDFnjjlridN0fApeSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QnqhxwQU0ihZFYv4YMyBhZsjVBIXO4bvDo+vEv3zqCnCFld9JP5PqHrOPzjOBM0b+
	 JC3UKFcRA7v47W/6f6cl5wQXMR4+Aji9V0EYqBZQInDXtE6kqo0xLHvWxZ+1dKspbi
	 2IkCHRViQrESM/VvNSgM3VUfbv1UA1zqW1H0voKsD0nHApjFcSzCAYo7Sl0G8ROOw6
	 Uk/JzoPVXQFyQSoS05gIBb7F0QrtIP8u8RQKP9Wk40DLJ7+qE3ECzZbrwAwQ9oDmZP
	 0pJK7EzOWWEx5iQCV7T/mKxcbRuXnCdNnaGh7OjzUwvJ+2qMChgaiy7/zluqVDioCj
	 xbRNGnir6z+yg==
Date: Sun, 31 Dec 2023 14:41:08 -0800
Subject: [PATCH 3/9] xfs_scrub: remove action lists from phaseX code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999486.1797790.16655448538358333691.stgit@frogsfrogsfrogs>
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

Now that we track repair schedules by filesystem object (and not
individual repairs) we can get rid of all the onstack list heads and
whatnot in the phaseX code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    5 +----
 scrub/phase2.c |   16 ++++------------
 scrub/phase3.c |   19 ++++++++-----------
 scrub/phase4.c |    8 ++------
 scrub/phase5.c |    8 ++------
 scrub/phase7.c |    4 +---
 scrub/scrub.c  |   37 ++++++++++++++++++++-----------------
 scrub/scrub.h  |   16 +++++-----------
 8 files changed, 43 insertions(+), 70 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index b1bbc694e64..1e56f9fb1ee 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -53,7 +53,6 @@ report_to_kernel(
 	struct scrub_ctx	*ctx)
 {
 	struct scrub_item	sri;
-	struct action_list	alist;
 	int			ret;
 
 	if (!ctx->scrub_setup_succeeded || ctx->corruptions_found ||
@@ -62,8 +61,7 @@ report_to_kernel(
 		return 0;
 
 	scrub_item_init_fs(&sri);
-	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, &alist, &sri);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, &sri);
 	if (ret)
 		return ret;
 
@@ -74,7 +72,6 @@ report_to_kernel(
 	if (repair_item_count_needsrepair(&sri) != 0 &&
 	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 		str_info(ctx, _("Couldn't upload clean bill of health."), NULL);
-		action_list_discard(&alist);
 	}
 
 	return 0;
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 26ce5818030..4d4552d8477 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -61,8 +61,6 @@ scan_ag_metadata(
 	struct scrub_item		fix_now;
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl			*sctl = arg;
-	struct action_list		alist;
-	struct action_list		immediate_alist;
 	char				descr[DESCR_BUFSZ];
 	unsigned int			difficulty;
 	int				ret;
@@ -71,15 +69,13 @@ scan_ag_metadata(
 		return;
 
 	scrub_item_init_ag(&sri, agno);
-	action_list_init(&alist);
-	action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
 
 	/*
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	ret = scrub_ag_headers(ctx, agno, &alist, &sri);
+	ret = scrub_ag_headers(ctx, &sri);
 	if (ret)
 		goto err;
 
@@ -89,7 +85,7 @@ scan_ag_metadata(
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	ret = scrub_ag_metadata(ctx, agno, &alist, &sri);
+	ret = scrub_ag_metadata(ctx, &sri);
 	if (ret)
 		goto err;
 
@@ -126,7 +122,6 @@ scan_fs_metadata(
 	void			*arg)
 {
 	struct scrub_item	sri;
-	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
 	unsigned int		difficulty;
@@ -136,8 +131,7 @@ scan_fs_metadata(
 		goto out;
 
 	scrub_item_init_fs(&sri);
-	action_list_init(&alist);
-	ret = scrub_fs_metadata(ctx, type, &alist, &sri);
+	ret = scrub_fs_metadata(ctx, type, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
@@ -172,7 +166,6 @@ phase2_func(
 		.aborted	= false,
 		.rbm_done	= false,
 	};
-	struct action_list	alist;
 	struct scrub_item	sri;
 	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
@@ -196,8 +189,7 @@ phase2_func(
 	 * If errors occur, this function will log them and return nonzero.
 	 */
 	scrub_item_init_ag(&sri, 0);
-	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist, &sri);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, &sri);
 	if (ret)
 		goto out_wq;
 	ret = repair_item_completely(ctx, &sri);
diff --git a/scrub/phase3.c b/scrub/phase3.c
index e602d8c7ec4..fa2eef4dea1 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -107,7 +107,6 @@ scrub_inode(
 	struct xfs_bulkstat	*bstat,
 	void			*arg)
 {
-	struct action_list	alist;
 	struct scrub_item	sri;
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
@@ -115,7 +114,6 @@ scrub_inode(
 	int			error;
 
 	scrub_item_init_file(&sri, bstat);
-	action_list_init(&alist);
 	background_sleep();
 
 	/*
@@ -146,7 +144,7 @@ scrub_inode(
 		fd = scrub_open_handle(handle);
 
 	/* Scrub the inode. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &sri);
 	if (error)
 		goto out;
 
@@ -155,13 +153,13 @@ scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &sri);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &sri);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &sri);
 	if (error)
 		goto out;
 
@@ -182,25 +180,24 @@ scrub_inode(
 	if (S_ISLNK(bstat->bs_mode) || !bstat->bs_mode) {
 		/* Check symlink contents. */
 		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
-				&alist, &sri);
+				&sri);
 		if (error)
 			goto out;
 	}
 	if (S_ISDIR(bstat->bs_mode) || !bstat->bs_mode) {
 		/* Check the directory entries. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist,
-				&sri);
+		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &sri);
 		if (error)
 			goto out;
 	}
 
 	/* Check all the extended attributes. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &sri);
 	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &alist, &sri);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &sri);
 	if (error)
 		goto out;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 98518635b2b..230c559f07f 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -129,7 +129,6 @@ phase4_func(
 	struct scrub_ctx	*ctx)
 {
 	struct xfs_fsop_geom	fsgeom;
-	struct action_list	alist;
 	struct scrub_item	sri;
 	int			ret;
 
@@ -144,8 +143,7 @@ phase4_func(
 	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
 	scrub_item_init_fs(&sri);
-	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, &alist, &sri);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, &sri);
 	if (ret)
 		return ret;
 
@@ -160,8 +158,7 @@ phase4_func(
 		return ret;
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0,
-				&alist, &sri);
+		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, &sri);
 		if (ret)
 			return ret;
 	}
@@ -170,7 +167,6 @@ phase4_func(
 	ret = repair_item_corruption(ctx, &sri);
 	if (ret)
 		return ret;
-	action_list_discard(&alist);
 
 	ret = repair_everything(ctx);
 	if (ret)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 79bfea8f6b5..6c9a518db4d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -386,7 +386,6 @@ check_fs_label(
 
 struct fs_scan_item {
 	struct scrub_item	sri;
-	struct action_list	alist;
 	bool			*abortedp;
 	unsigned int		scrub_type;
 };
@@ -413,16 +412,14 @@ fs_scan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist,
-			&item->sri);
+	ret = scrub_meta_type(ctx, item->scrub_type, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking fs scan metadata"));
 		*item->abortedp = true;
 		goto out;
 	}
 
-	ret = action_list_process(ctx, &item->alist,
-			XRM_FINAL_WARNING | XRM_NOPROGRESS);
+	ret = repair_item_completely(ctx, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("repairing fs scan metadata"));
 		*item->abortedp = true;
@@ -453,7 +450,6 @@ queue_fs_scan(
 		return ret;
 	}
 	scrub_item_init_fs(&item->sri);
-	action_list_init(&item->alist);
 	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 404bfb82243..02da6b42beb 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -100,7 +100,6 @@ phase7_func(
 {
 	struct summary_counts	totalcount = {0};
 	struct scrub_item	sri;
-	struct action_list	alist;
 	struct ptvar		*ptvar;
 	unsigned long long	used_data;
 	unsigned long long	used_rt;
@@ -119,8 +118,7 @@ phase7_func(
 
 	/* Check and fix the summary metadata. */
 	scrub_item_init_fs(&sri);
-	action_list_init(&alist);
-	error = scrub_summary_metadata(ctx, &alist, &sri);
+	error = scrub_summary_metadata(ctx, &sri);
 	if (error)
 		return error;
 	error = repair_item_completely(ctx, &sri);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 54f397fb92a..ca3eea42ece 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -219,6 +219,7 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 
 /*
  * Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later.
+ * Do not call this function to repair file metadata.
  *
  * Returns 0 for success.  If errors occur, this function will log them and
  * return a positive error code.
@@ -227,18 +228,29 @@ int
 scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
 	struct xfs_scrub_metadata	meta = {
 		.sm_type		= type,
-		.sm_agno		= agno,
 	};
 	enum check_outcome		fix;
 
 	background_sleep();
 
+	switch (xfrog_scrubbers[type].group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		meta.sm_agno = sri->sri_agno;
+		break;
+	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_NONE:
+		break;
+	default:
+		assert(0);
+		break;
+	}
+
 	/* Check the item. */
 	fix = xfs_check_metadata(ctx, &ctx->mnt, &meta, false);
 	progress_add(1);
@@ -267,8 +279,6 @@ static bool
 scrub_group(
 	struct scrub_ctx		*ctx,
 	enum xfrog_scrub_group		group,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
 	const struct xfrog_scrub_descr	*sc;
@@ -281,7 +291,7 @@ scrub_group(
 		if (sc->group != group)
 			continue;
 
-		ret = scrub_meta_type(ctx, type, agno, alist, sri);
+		ret = scrub_meta_type(ctx, type, sri);
 		if (ret)
 			return ret;
 	}
@@ -293,22 +303,18 @@ scrub_group(
 int
 scrub_ag_headers(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, agno, alist, sri);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, sri);
 }
 
 /* Scrub each AG's metadata btrees. */
 int
 scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
-	xfs_agnumber_t			agno,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist, sri);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, sri);
 }
 
 /* Scrub whole-filesystem metadata. */
@@ -316,22 +322,20 @@ int
 scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
 	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_FS);
 
-	return scrub_meta_type(ctx, type, 0, alist, sri);
+	return scrub_meta_type(ctx, type, sri);
 }
 
 /* Scrub all FS summary metadata. */
 int
 scrub_summary_metadata(
 	struct scrub_ctx		*ctx,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist, sri);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, sri);
 }
 
 /* How many items do we have to check? */
@@ -393,7 +397,6 @@ scrub_file(
 	int				fd,
 	const struct xfs_bulkstat	*bstat,
 	unsigned int			type,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
 	struct xfs_scrub_metadata	meta = {0};
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0d6825a5a95..b2e91efac70 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -80,18 +80,13 @@ void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 		const char *tag);
 
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist, struct scrub_item *sri);
-int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist, struct scrub_item *sri);
+int scrub_ag_headers(struct scrub_ctx *ctx, struct scrub_item *sri);
+int scrub_ag_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
-		struct action_list *alist, struct scrub_item *sri);
-int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist,
-		struct scrub_item *sri);
-int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist,
 		struct scrub_item *sri);
+int scrub_iscan_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
+int scrub_summary_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
-		xfs_agnumber_t agno, struct action_list *alist,
 		struct scrub_item *sri);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
@@ -105,7 +100,6 @@ bool can_repair(struct scrub_ctx *ctx);
 bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
-		unsigned int type, struct action_list *alist,
-		struct scrub_item *sri);
+		unsigned int type, struct scrub_item *sri);
 
 #endif /* XFS_SCRUB_SCRUB_H_ */

