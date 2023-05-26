Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3EEC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbjEZBos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbjEZBor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D9194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB2664A68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D716C433D2;
        Fri, 26 May 2023 01:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065479;
        bh=g3NGNlaUnLIKfpiacdNq/lYTM1wkl7q2R7OIqw+t+v4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VpU3IfcN8FpGvEjbV0M1zsGRbcC9eQNECLX5a+NyS/4BPu91mpXFirsZN4+MhxVHA
         QQORyT2CXGE/vF2wWFmxkomEWGRTbJHaz5B1b5SpF/Yf5a6rrIyF0E5EFIb/QVnurs
         Xmh/4GNxPvGjYQdmGjWFu/yxv/JiUuBz6vcIrec0iVcmupm+HM0ZnQKSfLQpANEOw3
         1sLaNt0/xaTPGUandqdDgnKl9w1p9WuuL0ZHuhFv5piYevTJgv3TLpeLsjXJQZx1qO
         XHisbw8tMalNzWvAMvoBb2fWjnh3uL28bHd/7U8kiVS3XTUcZjAm/cJLn+3x8II6oU
         gixpr9Qm5OzZQ==
Date:   Thu, 25 May 2023 18:44:39 -0700
Subject: [PATCH 3/9] xfs_scrub: remove action lists from phaseX code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072060.3743400.12331688387009504338.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
References: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index f9085f5c1b4..915ff3c68ea 100644
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
index a295b5dd114..bbe61372469 100644
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
 
@@ -126,7 +122,6 @@ scan_metafile(
 	void			*arg)
 {
 	struct scrub_item	sri;
-	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
 	unsigned int		difficulty;
@@ -136,8 +131,7 @@ scan_metafile(
 		goto out;
 
 	scrub_item_init_fs(&sri);
-	action_list_init(&alist);
-	ret = scrub_metadata_file(ctx, type, &alist, &sri);
+	ret = scrub_metadata_file(ctx, type, &sri);
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
index f417da68ff7..d33659bd52a 100644
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
 
@@ -172,22 +170,21 @@ scrub_inode(
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
 		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
-				&alist, &sri);
+				&sri);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist,
-				&sri);
+		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &sri);
 	}
 	if (error)
 		goto out;
 
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
index 7c4715f1583..1c8aeb5c6af 100644
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
index 23699cccaa4..17432b8a476 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -385,7 +385,6 @@ check_fs_label(
 
 struct iscan_item {
 	struct scrub_item	sri;
-	struct action_list	alist;
 	bool			*abortedp;
 	unsigned int		scrub_type;
 };
@@ -412,16 +411,14 @@ iscan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist,
-			&item->sri);
+	ret = scrub_meta_type(ctx, item->scrub_type, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking iscan metadata"));
 		*item->abortedp = true;
 		goto out;
 	}
 
-	ret = action_list_process(ctx, &item->alist,
-			XRM_FINAL_WARNING | XRM_NOPROGRESS);
+	ret = repair_item_completely(ctx, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("repairing iscan metadata"));
 		*item->abortedp = true;
@@ -452,7 +449,6 @@ queue_iscan(
 		return ret;
 	}
 	scrub_item_init_fs(&item->sri);
-	action_list_init(&item->alist);
 	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 1e5c376c1cf..f9c59f9dfc1 100644
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
index eb45073e351..77a0da25373 100644
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
+	case XFROG_SCRUB_GROUP_METAFILES:
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
 
 /* Scrub one metadata file */
@@ -316,22 +322,20 @@ int
 scrub_metadata_file(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	struct action_list		*alist,
 	struct scrub_item		*sri)
 {
 	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_METAFILES);
 
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
index eb38ce1c43f..b584f7ec7de 100644
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
 int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
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

