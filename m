Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A0C7EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ob4X5iMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F926C433C8;
	Mon,  1 Jan 2024 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068566;
	bh=06HFhubAFrWaD0QX4+r0olLKrHpzwe8D6YOj7OEbY94=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ob4X5iMRv9ueRmXkYSCTbBuzV2149fKrAXLAUhQYirf03fIMq8oERPqnw9B2vGchw
	 +PdntPF5GuHFpT5WTr90vMduwjqasYhhFGBXFoUwZ1ZV+oMvPqgY7aob6tLoAJFWlp
	 gtKnQcgOFqzElRpWYfhvWrMGszX55KRs/XiQ8TaufBcDF9krNDtdQNi7ZeN9I9xMLJ
	 C/HbtE6/A02+H58VlUiU48WcGckSxyJwVK3GEexomBUvgioqGcXuK0BAYrNN6i+0zG
	 Fg5GgPasLDtQD8PxDF2MR6gI0HbEDosTmvui6WQ0mzWYsli628e9GfBRYepAsQ4X72
	 MKe5r6aa9ZUQA==
Date: Sun, 31 Dec 2023 16:22:45 +9900
Subject: [PATCH 47/47] mkfs: create the realtime rmap inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015939.1815505.5116508316707037900.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Create a realtime rmapbt inode if we format the fs with realtime
and rmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    7 ----
 mkfs/proto.c    |   56 ++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 141 insertions(+), 12 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index ba0b9a87f2d..18bd2116c50 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -307,13 +307,6 @@ rtmount_init(
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
index 5239f9ec413..d575d9c511e 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -852,6 +852,54 @@ rtsummary_create(
 	mp->m_rsumip = rsumip;
 }
 
+/* Create the realtime rmap btree inode. */
+static void
+rtrmapbt_create(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= 0,
+		.rm_blockcount	= rtg->rtg_mount->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+		.rm_offset	= 0,
+		.rm_flags	= 0,
+	};
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
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
+	error = -libxfs_imeta_start_create(mp, path, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_rtrmapbt_create(&upd, &rtg->rtg_rmapip);
+	if (error)
+		fail(_("rtrmap inode creation failed"), error);
+
+	/* Adding an rmap for the rtgroup super should fit in the data fork */
+	cur = libxfs_rtrmapbt_init_cursor(mp, upd.tp, rtg, rtg->rtg_rmapip);
+	error = -libxfs_rmap_map_raw(cur, &rmap);
+	libxfs_btree_del_cursor(cur, error);
+	if (error)
+		fail(_("rtrmapbt initialization failed"), error);
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error)
+		fail(_("rtrmapbt commit failed"), error);
+
+	libxfs_imeta_free_path(path);
+}
+
 /* Initialize block headers of rt free space files. */
 static int
 init_rtblock_headers(
@@ -1084,9 +1132,17 @@ static void
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
index 66532b8c9b6..162546cd1e8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2474,12 +2474,18 @@ _("reflink not supported with realtime devices\n"));
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
@@ -4553,6 +4559,77 @@ cfgfile_parse(
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
@@ -4922,6 +4999,9 @@ main(
 	 */
 	check_root_ino(mp);
 
+	/* Make sure we can handle space preallocations of rt metadata btrees */
+	check_rt_meta_prealloc(mp);
+
 	/*
 	 * Re-write multiple secondary superblocks with rootinode field set
 	 */

