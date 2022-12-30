Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B778C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiLaCst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiLaCsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:48:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D5120B6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86B17B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C71C433EF;
        Sat, 31 Dec 2022 02:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454923;
        bh=nvbBly5Ntx3m1HNMtAYcYw2otx3+NrtNXdMC5nwBAx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bGKn0CFMiyAP9iv8xXW401B9rs5aCLKnyIwPFkp1AM5m6/WtptyMfrpJV4VWQtC42
         GyRYGR6hlrxfrKgEmof2/8l/w7ViJfnAOTO85wPILzVAYKpj9DQ/i0DV1OQVTSesj4
         7IUCqYnRR9UjnJy9H/Xm6JPtAFEtP7WpA6pzvVcLJ9JWoIXaB+6wTYK0yrt8x9//Ib
         HlVU93snGUda9sD3FDygqVsVutSevOLsqot0ODSDgtL5XrxnIyXwci6KvWuy9ZWhr8
         JQ9MRDk3DOLxaDmRIwb6Rnf5rTbEcQR+fSpqyrbpspYSEYIxAhDVMdl1SXWGSFOV//
         ysAFPrfjNMWSw==
Subject: [PATCH 24/41] xfs_db: make fsmap query the realtime reverse mapping
 tree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879912.732820.12106848728769249432.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extend the 'fsmap' debugger command to support querying the realtime
rmap btree via a new -r argument.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c               |  135 +++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/libxfs_api_defs.h |    2 +
 2 files changed, 133 insertions(+), 4 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 7fd42df2a1c..8d06f3638d6 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -102,6 +102,120 @@ fsmap(
 	}
 }
 
+static int
+fsmap_rt_fn(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct fsmap_info		*info = priv;
+
+	dbprintf(_("%llu: %u/%u len %u owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
+		info->nr, cur->bc_ino.rtg->rtg_rgno, rec->rm_startblock,
+		rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+		!!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK),
+		!!(rec->rm_flags & XFS_RMAP_ATTR_FORK),
+		!!(rec->rm_flags & XFS_RMAP_UNWRITTEN));
+	info->nr++;
+
+	return 0;
+}
+
+static void
+fsmap_rt(
+	xfs_fsblock_t		start_fsb,
+	xfs_fsblock_t		end_fsb)
+{
+	struct fsmap_info	info;
+	xfs_daddr_t		eofs;
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	struct xfs_btree_cur	*bt_cur;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		start_rg;
+	xfs_rgnumber_t		end_rg;
+	int			error;
+
+	if (mp->m_sb.sb_rblocks == 0)
+		return;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (XFS_FSB_TO_DADDR(mp, end_fsb) >= eofs)
+		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
+
+	low.rm_startblock = xfs_rtb_to_rgbno(mp, start_fsb, &start_rg);
+	low.rm_owner = 0;
+	low.rm_offset = 0;
+	low.rm_flags = 0;
+	high.rm_startblock = -1U;
+	high.rm_owner = ULLONG_MAX;
+	high.rm_offset = ULLONG_MAX;
+	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			XFS_RMAP_UNWRITTEN;
+
+	end_rg = xfs_rtb_to_rgno(mp, end_fsb);
+
+	info.nr = 0;
+	for_each_rtgroup_range(mp, start_rg, end_rg, rtg) {
+		struct xfs_inode	*ip;
+		struct xfs_imeta_path	*path;
+		xfs_ino_t		ino;
+		xfs_rgnumber_t		rgno;
+
+		if (rtg->rtg_rgno == end_rg)
+			high.rm_startblock = xfs_rtb_to_rgbno(mp, end_fsb,
+					&rgno);
+
+		error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+		if (error) {
+			dbprintf(
+	_("Cannot create path to rtgroup %u rmap inode\n"),
+					rtg->rtg_rgno);
+			libxfs_rtgroup_put(rtg);
+			return;
+		}
+
+		error = -libxfs_imeta_lookup(mp, path, &ino);
+		libxfs_imeta_free_path(path);
+		if (error) {
+			dbprintf(_("Cannot look up rtgroup %u rmap inode\n"),
+					rtg->rtg_rgno);
+			libxfs_rtgroup_put(rtg);
+			return;
+		}
+
+		error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+		if (error) {
+			dbprintf(_("Cannot load rtgroup %u rmap inode\n"),
+					rtg->rtg_rgno);
+			libxfs_rtgroup_put(rtg);
+			return;
+		}
+
+		bt_cur = libxfs_rtrmapbt_init_cursor(mp, NULL, rtg, ip);
+		if (!bt_cur) {
+			libxfs_imeta_irele(ip);
+			libxfs_rtgroup_put(rtg);
+			dbprintf(_("Not enough memory.\n"));
+			return;
+		}
+
+		error = -libxfs_rmap_query_range(bt_cur, &low, &high,
+				fsmap_rt_fn, &info);
+		libxfs_btree_del_cursor(bt_cur, error);
+		libxfs_imeta_irele(ip);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
+			dbprintf(_("Error %d while querying rt fsmap btree.\n"),
+				error);
+			return;
+		}
+
+		if (rtg->rtg_rgno == start_rg)
+			low.rm_startblock = 0;
+	}
+}
+
 static int
 fsmap_f(
 	int			argc,
@@ -111,14 +225,18 @@ fsmap_f(
 	int			c;
 	xfs_fsblock_t		start_fsb = 0;
 	xfs_fsblock_t		end_fsb = NULLFSBLOCK;
+	bool			isrt = false;
 
 	if (!xfs_has_rmapbt(mp)) {
 		dbprintf(_("Filesystem does not support reverse mapping btree.\n"));
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "")) != EOF) {
+	while ((c = getopt(argc, argv, "r")) != EOF) {
 		switch (c) {
+		case 'r':
+			isrt = true;
+			break;
 		default:
 			dbprintf(_("Bad option for fsmap command.\n"));
 			return 0;
@@ -141,14 +259,23 @@ fsmap_f(
 		}
 	}
 
-	fsmap(start_fsb, end_fsb);
+	if (argc > optind + 2) {
+		exitcode = 1;
+		dbprintf(_("Too many arguments to fsmap.\n"));
+		return 0;
+	}
+
+	if (isrt)
+		fsmap_rt(start_fsb, end_fsb);
+	else
+		fsmap(start_fsb, end_fsb);
 
 	return 0;
 }
 
 static const cmdinfo_t	fsmap_cmd =
-	{ "fsmap", NULL, fsmap_f, 0, 2, 0,
-	  N_("[start_fsb] [end_fsb]"),
+	{ "fsmap", NULL, fsmap_f, 0, -1, 0,
+	  N_("[-r] [start_fsb] [end_fsb]"),
 	  N_("display reverse mapping(s)"), NULL };
 
 void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0e284e515d8..f59f9aa2060 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -241,11 +241,13 @@
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
+#define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk

