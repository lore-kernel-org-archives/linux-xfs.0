Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC6CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiLaA1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbiLaA1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E871EAF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39EEC61D2F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAFFC433EF;
        Sat, 31 Dec 2022 00:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446451;
        bh=SIXqsmji5aPkWUHC/tY/HcaiXEhzLXTS6EetHWoXSQ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B5VjabgLEkHlyqUaXtuLj+rDjHeLhql65S+b4UHcRE/r+UmHDpKf7xJeGkcioCGza
         8+os369e07Zx+MvpTugzNgsgjz2bG+cdv7Pk7zjk1D+9Xui1hkZTLiyPoFRB8p5Ldc
         D4QA2DLAKyhuj5b94KCOIhMRMC42xNz6FviF2Cfx0tVdTto1FLX42VjWklAz6uCcSP
         59T+o7TvYksQZXEGVTLSf9+r6ni8FwZak70kf6nZ+QjTXJ/w4dCHkZ0ET3zWjbltL7
         NlSlg1MUHf6YSGxczoEcYAGItBWUpgGodvXePTj1vuUlIwg9zYvtaRFJL2sSabLfSY
         7m3B7LYkWA3TA==
Subject: [PATCH 1/9] xfs_scrub: track repair items by principal,
 not by individual repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869726.715746.4221238033641226521.stgit@magnolia>
In-Reply-To: <167243869711.715746.14725730988345960302.stgit@magnolia>
References: <167243869711.715746.14725730988345960302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new structure to track scrub and repair state by principal
filesystem object (e.g. ag number or inode number/generation) so that we
can more easily examine and ensure that we satisfy repair order
dependencies.  This transposition will eventually enable bulk scrub
operations and will also save a lot of memory if a given object needs a
lot of work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c        |    4 ++
 scrub/phase2.c        |   14 ++++++--
 scrub/phase3.c        |   19 ++++++-----
 scrub/phase4.c        |    6 ++--
 scrub/phase5.c        |    5 ++-
 scrub/phase7.c        |    4 ++
 scrub/scrub.c         |   68 ++++++++++++++++++++++++++++++++--------
 scrub/scrub.h         |   83 +++++++++++++++++++++++++++++++++++++++++++++----
 scrub/scrub_private.h |   19 +++++++++++
 9 files changed, 185 insertions(+), 37 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 047631802e4..3113fc5ccf6 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -52,6 +52,7 @@ static int
 report_to_kernel(
 	struct scrub_ctx	*ctx)
 {
+	struct scrub_item	sri;
 	struct action_list	alist;
 	int			ret;
 
@@ -60,8 +61,9 @@ report_to_kernel(
 	    ctx->warnings_found)
 		return 0;
 
+	scrub_item_init_fs(&sri);
 	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, &alist, &sri);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase2.c b/scrub/phase2.c
index a78d15aac1f..50c2c88276f 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -57,6 +57,7 @@ scan_ag_metadata(
 	xfs_agnumber_t			agno,
 	void				*arg)
 {
+	struct scrub_item		sri;
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
@@ -68,6 +69,7 @@ scan_ag_metadata(
 	if (sctl->aborted)
 		return;
 
+	scrub_item_init_ag(&sri, agno);
 	action_list_init(&alist);
 	action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
@@ -76,7 +78,7 @@ scan_ag_metadata(
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	ret = scrub_ag_headers(ctx, agno, &alist);
+	ret = scrub_ag_headers(ctx, agno, &alist, &sri);
 	if (ret)
 		goto err;
 
@@ -86,7 +88,7 @@ scan_ag_metadata(
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	ret = scrub_ag_metadata(ctx, agno, &alist);
+	ret = scrub_ag_metadata(ctx, agno, &alist, &sri);
 	if (ret)
 		goto err;
 
@@ -120,6 +122,7 @@ scan_metafile(
 	xfs_agnumber_t		type,
 	void			*arg)
 {
+	struct scrub_item	sri;
 	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
@@ -129,8 +132,9 @@ scan_metafile(
 	if (sctl->aborted)
 		goto out;
 
+	scrub_item_init_fs(&sri);
 	action_list_init(&alist);
-	ret = scrub_metadata_file(ctx, type, &alist);
+	ret = scrub_metadata_file(ctx, type, &alist, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
@@ -162,6 +166,7 @@ phase2_func(
 		.rbm_done	= false,
 	};
 	struct action_list	alist;
+	struct scrub_item	sri;
 	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
 	unsigned int		type;
@@ -183,8 +188,9 @@ phase2_func(
 	 * upgrades) off of the sb 0 scrubber (which currently does nothing).
 	 * If errors occur, this function will log them and return nonzero.
 	 */
+	scrub_item_init_ag(&sri, 0);
 	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist, &sri);
 	if (ret)
 		goto out_wq;
 	ret = action_list_process(ctx, -1, &alist,
diff --git a/scrub/phase3.c b/scrub/phase3.c
index ef41ee8049d..ef22a1d11c1 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -105,12 +105,14 @@ scrub_inode(
 	void			*arg)
 {
 	struct action_list	alist;
+	struct scrub_item	sri;
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
 	xfs_agnumber_t		agno;
 	int			fd = -1;
 	int			error;
 
+	scrub_item_init_file(&sri, bstat);
 	action_list_init(&alist);
 	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
@@ -143,7 +145,7 @@ scrub_inode(
 		fd = scrub_open_handle(handle);
 
 	/* Scrub the inode. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &alist, &sri);
 	if (error)
 		goto out;
 
@@ -152,13 +154,13 @@ scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &alist, &sri);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &alist, &sri);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &alist, &sri);
 	if (error)
 		goto out;
 
@@ -169,21 +171,22 @@ scrub_inode(
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
 		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
-				&alist);
+				&alist, &sri);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist);
+		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist,
+				&sri);
 	}
 	if (error)
 		goto out;
 
 	/* Check all the extended attributes. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &alist, &sri);
 	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &alist, &sri);
 	if (error)
 		goto out;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index df9b066cfd2..31939653bda 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -130,6 +130,7 @@ phase4_func(
 {
 	struct xfs_fsop_geom	fsgeom;
 	struct action_list	alist;
+	struct scrub_item	sri;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -142,8 +143,9 @@ phase4_func(
 	 * chance that repairs of primary metadata fail due to secondary
 	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
+	scrub_item_init_fs(&sri);
 	action_list_init(&alist);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, &alist, &sri);
 	if (ret)
 		return ret;
 
@@ -159,7 +161,7 @@ phase4_func(
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
 		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0,
-				&alist);
+				&alist, &sri);
 		if (ret)
 			return ret;
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index e598ffd3985..ea77c2a5298 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -384,6 +384,7 @@ check_fs_label(
 }
 
 struct iscan_item {
+	struct scrub_item	sri;
 	struct action_list	alist;
 	bool			*abortedp;
 	unsigned int		scrub_type;
@@ -411,7 +412,8 @@ iscan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist);
+	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist,
+			&item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking iscan metadata"));
 		*item->abortedp = true;
@@ -449,6 +451,7 @@ queue_iscan(
 		str_liberror(ctx, ret, _("setting up iscan"));
 		return ret;
 	}
+	scrub_item_init_fs(&item->sri);
 	action_list_init(&item->alist);
 	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index e9cb40f48d8..ddc1e3b24e3 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -99,6 +99,7 @@ phase7_func(
 	struct scrub_ctx	*ctx)
 {
 	struct summary_counts	totalcount = {0};
+	struct scrub_item	sri;
 	struct action_list	alist;
 	struct ptvar		*ptvar;
 	unsigned long long	used_data;
@@ -117,8 +118,9 @@ phase7_func(
 	int			error;
 
 	/* Check and fix the summary metadata. */
+	scrub_item_init_fs(&sri);
 	action_list_init(&alist);
-	error = scrub_summary_metadata(ctx, &alist);
+	error = scrub_summary_metadata(ctx, &alist, &sri);
 	if (error)
 		return error;
 	error = action_list_process(ctx, -1, &alist,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index fe4603f863b..55653b31c4c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -264,7 +264,8 @@ scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
 	xfs_agnumber_t			agno,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
 	struct xfs_scrub_metadata	meta = {
 		.sm_type		= type,
@@ -283,11 +284,13 @@ scrub_meta_type(
 	case CHECK_ABORT:
 		return ECANCELED;
 	case CHECK_REPAIR:
+		scrub_item_save_state(sri, type, meta.sm_flags);
 		ret = scrub_save_repair(ctx, alist, &meta);
 		if (ret)
 			return ret;
 		fallthrough;
 	case CHECK_DONE:
+		scrub_item_clean_state(sri, type);
 		return 0;
 	default:
 		/* CHECK_RETRY should never happen. */
@@ -305,7 +308,8 @@ scrub_group(
 	struct scrub_ctx		*ctx,
 	enum xfrog_scrub_group		group,
 	xfs_agnumber_t			agno,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
 	const struct xfrog_scrub_descr	*sc;
 	unsigned int			type;
@@ -317,7 +321,7 @@ scrub_group(
 		if (sc->group != group)
 			continue;
 
-		ret = scrub_meta_type(ctx, type, agno, alist);
+		ret = scrub_meta_type(ctx, type, agno, alist, sri);
 		if (ret)
 			return ret;
 	}
@@ -330,9 +334,10 @@ int
 scrub_ag_headers(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, agno, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, agno, alist, sri);
 }
 
 /* Scrub each AG's metadata btrees. */
@@ -340,9 +345,10 @@ int
 scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist, sri);
 }
 
 /* Scrub one metadata file */
@@ -350,20 +356,22 @@ int
 scrub_metadata_file(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
 	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_METAFILES);
 
-	return scrub_meta_type(ctx, type, 0, alist);
+	return scrub_meta_type(ctx, type, 0, alist, sri);
 }
 
 /* Scrub all FS summary metadata. */
 int
 scrub_summary_metadata(
 	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist, sri);
 }
 
 /* How many items do we have to check? */
@@ -425,7 +433,8 @@ scrub_file(
 	int				fd,
 	const struct xfs_bulkstat	*bstat,
 	unsigned int			type,
-	struct action_list		*alist)
+	struct action_list		*alist,
+	struct scrub_item		*sri)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	struct xfs_fd			xfd;
@@ -454,12 +463,45 @@ scrub_file(
 	fix = xfs_check_metadata(ctx, xfdp, &meta, true);
 	if (fix == CHECK_ABORT)
 		return ECANCELED;
-	if (fix == CHECK_DONE)
+	if (fix == CHECK_DONE) {
+		scrub_item_clean_state(sri, type);
 		return 0;
+	}
 
+	scrub_item_save_state(sri, type, meta.sm_flags);
 	return scrub_save_repair(ctx, alist, &meta);
 }
 
+/* Dump a scrub item for debugging purposes. */
+void
+scrub_item_dump(
+	struct scrub_item	*sri,
+	unsigned int		group_mask,
+	const char		*tag)
+{
+	unsigned int		i;
+
+	if (group_mask == 0)
+		group_mask = -1U;
+
+	printf("DUMP SCRUB ITEM FOR %s\n", tag);
+	if (sri->sri_ino != -1ULL)
+		printf("ino 0x%llx gen %u\n", (unsigned long long)sri->sri_ino,
+				sri->sri_gen);
+	if (sri->sri_agno != -1U)
+		printf("agno %u\n", sri->sri_agno);
+
+	foreach_scrub_type(i) {
+		unsigned int	g = 1U << xfrog_scrubbers[i].group;
+
+		if (g & group_mask)
+			printf("[%u]: type '%s' state 0x%x\n", i,
+					xfrog_scrubbers[i].name,
+					sri->sri_state[i]);
+	}
+	fflush(stdout);
+}
+
 /*
  * Test the availability of a kernel scrub command.  If errors occur (or the
  * scrub ioctl is rejected) the errors will be logged and this function will
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b02e8f16815..546651b2818 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -16,17 +16,85 @@ enum check_outcome {
 
 struct action_item;
 
+/*
+ * These flags record the metadata object state that the kernel returned.
+ * We want to remember if the object was corrupt, if the cross-referencing
+ * revealed inconsistencies (xcorrupt), if the cross referencing itself failed
+ * (xfail) or if the object is correct but could be optimised (preen).
+ */
+#define SCRUB_ITEM_CORRUPT	(XFS_SCRUB_OFLAG_CORRUPT)	/* (1 << 1) */
+#define SCRUB_ITEM_PREEN	(XFS_SCRUB_OFLAG_PREEN)		/* (1 << 2) */
+#define SCRUB_ITEM_XFAIL	(XFS_SCRUB_OFLAG_XFAIL)		/* (1 << 3) */
+#define SCRUB_ITEM_XCORRUPT	(XFS_SCRUB_OFLAG_XCORRUPT)	/* (1 << 4) */
+
+/* All of the state flags that we need to prioritize repair work. */
+#define SCRUB_ITEM_REPAIR_ANY	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_PREEN | \
+				 SCRUB_ITEM_XFAIL | \
+				 SCRUB_ITEM_XCORRUPT)
+
+struct scrub_item {
+	/*
+	 * Information we need to call the scrub and repair ioctls.  Per-AG
+	 * items should set the ino/gen fields to -1; per-inode items should
+	 * set sri_agno to -1; and per-fs items should set all three fields to
+	 * -1.  Or use the macros below.
+	 */
+	__u64			sri_ino;
+	__u32			sri_gen;
+	__u32			sri_agno;
+
+	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
+	__u8			sri_state[XFS_SCRUB_TYPE_NR];
+};
+
+#define foreach_scrub_type(loopvar) \
+	for ((loopvar) = 0; (loopvar) < XFS_SCRUB_TYPE_NR; (loopvar)++)
+
+static inline void
+scrub_item_init_ag(struct scrub_item *sri, xfs_agnumber_t agno)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = agno;
+	sri->sri_ino = -1ULL;
+	sri->sri_gen = -1U;
+}
+
+static inline void
+scrub_item_init_fs(struct scrub_item *sri)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = -1U;
+	sri->sri_ino = -1ULL;
+	sri->sri_gen = -1U;
+}
+
+static inline void
+scrub_item_init_file(struct scrub_item *sri, struct xfs_bulkstat *bstat)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = -1U;
+	sri->sri_ino = bstat->bs_ino;
+	sri->sri_gen = bstat->bs_gen;
+}
+
+void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
+		const char *tag);
+
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
 int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist);
+		struct action_list *alist, struct scrub_item *sri);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct action_list *alist);
+		struct action_list *alist, struct scrub_item *sri);
 int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
-		struct action_list *alist);
-int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
+		struct action_list *alist, struct scrub_item *sri);
+int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist,
+		struct scrub_item *sri);
+int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist,
+		struct scrub_item *sri);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
-		xfs_agnumber_t agno, struct action_list *alist);
+		xfs_agnumber_t agno, struct action_list *alist,
+		struct scrub_item *sri);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);
@@ -39,7 +107,8 @@ bool can_repair(struct scrub_ctx *ctx);
 bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
-		unsigned int type, struct action_list *alist);
+		unsigned int type, struct action_list *alist,
+		struct scrub_item *sri);
 
 /* Repair parameters are the scrub inputs and retry count. */
 struct action_item {
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 8bc0c521463..f91c65383d1 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -52,4 +52,23 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
 		struct xfs_scrub_metadata *meta);
 
+/* Scrub item functions */
+
+static inline void
+scrub_item_save_state(
+	struct scrub_item		*sri,
+	unsigned  int			scrub_type,
+	unsigned  int			scrub_flags)
+{
+	sri->sri_state[scrub_type] = scrub_flags & SCRUB_ITEM_REPAIR_ANY;
+}
+
+static inline void
+scrub_item_clean_state(
+	struct scrub_item		*sri,
+	unsigned  int			scrub_type)
+{
+	sri->sri_state[scrub_type] = 0;
+}
+
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

