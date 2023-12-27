Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D516B384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6o80nU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A97C433C7;
	Mon,  1 Jan 2024 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068238;
	bh=CaYqbgZ17ZNhRxShHpe+sEjZ+6SlS9zbKdKR4cXj++Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U6o80nU+U1i3FOzeOjmoL9M+m5uLOZYZWKNaL3Ito7Hw3R/7Xsb4aLDlHK47El1h6
	 L2x8babXiX2pd1Q9OxHUDp8zlGg0xHxAQah6F5H6Up3Qc8k1zqFFkDQxkUZ3L1UCTR
	 S/Xh2eAMFHb2jiLIUAIH6ZzxS9fAckVnOTD2iLYL28SM+x1rpBJjM+EqMPf+WoSptj
	 Ih9LA4e8UTsks1gRvTxvObNaeIzhk/yNLP7pYMWqpNSFb8+hC4PNhSpkncdH2VHWxV
	 sUqkSj2SHrjrk5oqVRGZ8CmxaUbiXTxB7VZeqHZdYEZjwGUpiqIorqEeAGekmfpQcr
	 DnmHoaUNh4Zmw==
Date: Sun, 31 Dec 2023 16:17:17 +9900
Subject: [PATCH 26/47] xfs_db: make fsmap query the realtime reverse mapping
 tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015659.1815505.10556464363110963669.stgit@frogsfrogsfrogs>
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

Extend the 'fsmap' debugger command to support querying the realtime
rmap btree via a new -r argument.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c               |  164 +++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/libxfs_api_defs.h |    2 +
 2 files changed, 162 insertions(+), 4 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 7fd42df2a1c..363c159ec07 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -102,6 +102,149 @@ fsmap(
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
+static int
+fsmap_rtgroup(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*low,
+	const struct xfs_rmap_irec	*high,
+	struct fsmap_info		*info)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_imeta_path	*path;
+	struct xfs_btree_cur	*bt_cur;
+	xfs_ino_t		ino;
+	int			error;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error) {
+		dbprintf(
+ _("Cannot create path to rtgroup %u rmap inode\n"),
+				rtg->rtg_rgno);
+		return error;
+	}
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error) {
+		dbprintf(
+ _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
+				rtg->rtg_rgno);
+		goto out_path;
+	}
+		
+	error = -libxfs_imeta_lookup(tp, path, &ino);
+	if (ino == NULLFSINO)
+		error = ENOENT;
+	if (error) {
+		dbprintf(_("Cannot look up rtgroup %u rmap inode, error %d\n"),
+				rtg->rtg_rgno, error);
+		goto out_trans;
+	}
+
+	error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	if (error) {
+		dbprintf(_("Cannot load rtgroup %u rmap inode\n"),
+				rtg->rtg_rgno);
+		goto out_trans;
+	}
+
+	bt_cur = libxfs_rtrmapbt_init_cursor(mp, tp, rtg, ip);
+	if (!bt_cur) {
+		dbprintf(_("Not enough memory.\n"));
+		goto out_rele;
+	}
+
+	error = -libxfs_rmap_query_range(bt_cur, low, high, fsmap_rt_fn,
+			info);
+	if (error) {
+		dbprintf(_("Error %d while querying rt fsmap btree.\n"),
+			error);
+		goto out_cur;
+	}
+
+out_cur:
+	libxfs_btree_del_cursor(bt_cur, error);
+out_rele:
+	libxfs_imeta_irele(ip);
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
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
+		xfs_rgnumber_t		rgno;
+
+		if (rtg->rtg_rgno == end_rg)
+			high.rm_startblock = xfs_rtb_to_rgbno(mp, end_fsb,
+					&rgno);
+ 
+		error = fsmap_rtgroup(rtg, &low, &high, &info);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
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
@@ -111,14 +254,18 @@ fsmap_f(
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
@@ -141,14 +288,23 @@ fsmap_f(
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
index 4b2fbd7cac9..85a4a131c75 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -284,11 +284,13 @@
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

