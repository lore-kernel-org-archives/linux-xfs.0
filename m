Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5CEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiLaCxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0018387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EDABB81E49
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C214CC433D2;
        Sat, 31 Dec 2022 02:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455187;
        bh=kaCeD074OxuQ4OelpyCZR2oiYivFD+EEJWkqqOQyg1o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ShkvfO7NiDG17+hM/ZIIvKdY7Ya6iFPLY8iY+wvuGP+8XjolahpIcvaMh/8UU0OD/
         ONfORMA1FLVJYfXHcBRiqS81q9EAqL7HwYuZslU8VfydE6fa7OjuRx+Fihal5SYcL0
         9q6aqW3JxgvrF5BrIBVHNv/gQ5kiyk8JyRBj1VaI6NGc3/qHY2pGFSZ538C2yjaUHE
         9/ncSUbCRKRMNVsuD0ss+8cLhFtdgtRUB3BXS1OMyALfBh4MZvQ8zZbRcdqp97gXeS
         GiY1/O0nwpasSBFtZ+qJ/DdLQIPv+tZcG6+JN8dZTVYFEULTIcj3VEyeZNhka4nxvu
         a97R8f5ELg79g==
Subject: [PATCH 41/41] mkfs: create the realtime rmap inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:01 -0800
Message-ID: <167243880136.732820.14784846856345197333.stgit@magnolia>
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

Create a realtime rmapbt inode if we format the fs with realtime
and rmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    7 ----
 mkfs/proto.c    |   62 ++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 147 insertions(+), 12 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 6f549996b1e..aa94c87ccd4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -455,13 +455,6 @@ rtmount_init(
 		return -1;
 	}
 
-	if (xfs_has_rmapbt(mp)) {
-		fprintf(stderr,
-	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
-				progname);
-		return -1;
-	}
-
 	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index e734269864e..36af61ed5c0 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -813,6 +813,60 @@ rtsummary_create(
 	libxfs_imeta_end_update(mp, &upd, 0);
 }
 
+/* Create the realtime rmap btree inode. */
+static void
+rtrmapbt_create(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_update	upd;
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= 0,
+		.rm_blockcount	= mp->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+		.rm_offset	= 0,
+		.rm_flags	= 0,
+	};
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		fail( _("rtrmap inode path creation failed"), error);
+
+	error = -libxfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		fail(_("rtgroup directory allocation failed"), error);
+
+	error = -libxfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_rtrmapbt_create(&tp, path, &upd, &rtg->rtg_rmapip);
+	if (error)
+		fail(_("rtrmap inode creation failed"), error);
+
+	cur = libxfs_rtrmapbt_init_cursor(mp, tp, rtg, rtg->rtg_rmapip);
+	error = -libxfs_rmap_map_raw(cur, &rmap);
+	libxfs_btree_del_cursor(cur, error);
+	if (error)
+		fail(_("rtrmapbt initialization failed"), error);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("rtrmapbt commit failed"), error);
+
+	libxfs_imeta_end_update(mp, &upd, 0);
+	libxfs_imeta_free_path(path);
+}
+
 /* Initialize block headers of rt free space files. */
 static int
 init_rtblock_headers(
@@ -1046,9 +1100,17 @@ static void
 rtinit(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
 	rtbitmap_create(mp);
 	rtsummary_create(mp);
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (xfs_has_rtrmapbt(mp))
+			rtrmapbt_create(rtg);
+	}
+
 	rtbitmap_init(mp);
 	rtsummary_init(mp);
 	if (xfs_has_rtgroups(mp))
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4f96e436d32..eebcade7d1a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2392,12 +2392,18 @@ _("reflink not supported with realtime devices\n"));
 		}
 		cli->sb_feat.reflink = false;
 
-		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
-			fprintf(stderr,
-_("rmapbt not supported with realtime devices\n"));
-			usage();
+		if (!cli->sb_feat.rtgroups && cli->sb_feat.rmapbt) {
+			if (cli_opt_set(&mopts, M_RMAPBT) &&
+			    cli_opt_set(&ropts, R_RTGROUPS)) {
+				fprintf(stderr,
+_("rmapbt not supported on realtime devices without rtgroups feature\n"));
+				usage();
+			} else if (cli_opt_set(&mopts, M_RMAPBT)) {
+				cli->sb_feat.rtgroups = true;
+			} else {
+				cli->sb_feat.rmapbt = false;
+			}
 		}
-		cli->sb_feat.rmapbt = false;
 	}
 
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
@@ -4500,6 +4506,77 @@ cfgfile_parse(
 		cli->cfgfile);
 }
 
+static inline void
+prealloc_fail(
+	struct xfs_mount	*mp,
+	int			error,
+	xfs_filblks_t		ask,
+	const char		*tag)
+{
+	if (error == ENOSPC)
+		fprintf(stderr,
+	_("%s: cannot handle expansion of %s; need %llu free blocks, have %llu\n"),
+				progname, tag, (unsigned long long)ask,
+				(unsigned long long)mp->m_sb.sb_fdblocks);
+	else
+		fprintf(stderr,
+	_("%s: error %d while checking free space for %s\n"),
+				progname, error, tag);
+	exit(1);
+}
+
+/*
+ * Make sure there's enough space on the data device to handle realtime
+ * metadata btree expansions.
+ */
+static void
+check_rt_meta_prealloc(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
+	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
+	xfs_filblks_t		ask;
+	int			error;
+
+	/*
+	 * First create all the per-AG reservations, since they take from the
+	 * free block count.  Each AG should start with enough free space for
+	 * the per-AG reservation.
+	 */
+	mp->m_finobt_nores = false;
+
+	for_each_perag(mp, agno, pag) {
+		error = -libxfs_ag_resv_init(pag, NULL);
+		if (error && error != ENOSPC) {
+			fprintf(stderr,
+	_("%s: error %d while checking AG free space for realtime metadata\n"),
+					progname, error);
+			exit(1);
+		}
+	}
+
+	/* Realtime metadata btree inode */
+	for_each_rtgroup(mp, rgno, rtg) {
+		ask = libxfs_rtrmapbt_calc_reserves(mp);
+		error = -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
+		if (error)
+			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
+	}
+
+	/* Unreserve the realtime metadata reservations. */
+	for_each_rtgroup(mp, rgno, rtg) {
+		libxfs_imeta_resv_free_inode(rtg->rtg_rmapip);
+	}
+
+	/* Unreserve the per-AG reservations. */
+	for_each_perag(mp, agno, pag)
+		libxfs_ag_resv_free(pag);
+
+	mp->m_finobt_nores = false;
+}
+
 int
 main(
 	int			argc,
@@ -4873,6 +4950,9 @@ main(
 	 */
 	check_root_ino(mp);
 
+	/* Make sure we can handle space preallocations of rt metadata btrees */
+	check_rt_meta_prealloc(mp);
+
 	/*
 	 * Re-write multiple secondary superblocks with rootinode field set
 	 */

