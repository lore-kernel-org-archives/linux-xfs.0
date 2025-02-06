Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4623BF95
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882341; cv=none; b=TrcRbh49WVjiLNvQiaN+NmnSWNnl7pQH8mmcTYKGy4DL6C2a2y4iHy1sv7o4NM0n00ec4SS0sUixXdp0hi3c6PcJex7qfmAgp2oMqiCw+r+WyR3/guC/cOqsb+Cv3KmHziM3ciMJ2ouGVeTLRVsvPNZEA8w+LvrsRyrsRiS7iYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882341; c=relaxed/simple;
	bh=XR/JK1aXw6FuNRChb4UMqfIJC6bAOAXYFBs+IrfrRF0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixWSAQA7atPwxl3ssRPOwUEiv9jfmWnaCx5EAenJF5UMzyvwN7de9FX3EB0kqWo+9PW6qcrU9+HY4IrtLn9bjW6UgQByHlqW+vAaZr3pSvaohp9DpFiVRIDjI9mSGSwmwTLwUdi92avBH17frLESVESvT0npuEkE7hxZjT00p0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6wBXqQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6wBXqQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09364C4CEDD;
	Thu,  6 Feb 2025 22:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882341;
	bh=XR/JK1aXw6FuNRChb4UMqfIJC6bAOAXYFBs+IrfrRF0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S6wBXqQmLo2CVRBmp01WLZfLfoTLSne2bVS//MUw8ab4s5JoU/z8fWO0FOWRFKQPO
	 L0s+cuCdTiaeVtNzMoW95l9/MHcd32EJFhtyDZRTpwOzYhRdfNzybg4hcfuQUClL9v
	 peb4BtVsvM7n2SNLtMJc0EnO7WcHBp1OOjE/ywZIAuUlgb58rRvGfEEJjGvOvT6YU/
	 vEqZ4h+UX/zzBNwCAgY4F6ny/T9GLPpHXtqJaYpuMIE2fNrthWTeKjUi9+t7xhMR2K
	 EtXIkXNs+inwuv6UKl8PiZeIYbjkTJhu2w6sWkXF2Ve+hGA9qg4VEl5u2yPUof7/QI
	 HjfR9jmH068kg==
Date: Thu, 06 Feb 2025 14:52:20 -0800
Subject: [PATCH 10/27] xfs_db: make fsmap query the realtime reverse mapping
 tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088249.2741033.5588270076246724853.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/fsmap.c               |  149 +++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/libxfs_api_defs.h |    3 +
 2 files changed, 148 insertions(+), 4 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index a9259c4632185b..ddbe4e6a3dfcfa 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -102,6 +102,134 @@ fsmap(
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
+		info->nr, cur->bc_group->xg_gno, rec->rm_startblock,
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
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_trans	*tp;
+	struct xfs_btree_cur	*bt_cur;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error) {
+		dbprintf(
+ _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
+				rtg_rgno(rtg));
+		return error;
+	}
+
+	error = -libxfs_rtginode_load_parent(tp);
+	if (error) {
+		dbprintf(_("Cannot load realtime metadir, error %d\n"),
+			error);
+		goto out_trans;
+	}
+
+	error = -libxfs_rtginode_load(rtg, XFS_RTGI_RMAP, tp);
+	if (error) {
+		dbprintf(_("Cannot load rtgroup %u rmap inode, error %d\n"),
+			rtg_rgno(rtg), error);
+		goto out_rele_dp;
+	}
+
+	bt_cur = libxfs_rtrmapbt_init_cursor(tp, rtg);
+	if (!bt_cur) {
+		dbprintf(_("Not enough memory.\n"));
+		goto out_rele_ip;
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
+out_rele_ip:
+	libxfs_rtginode_irele(&rtg->rtg_inodes[XFS_RTGI_RMAP]);
+out_rele_dp:
+	libxfs_rtginode_irele(&mp->m_rtdirip);
+out_trans:
+	libxfs_trans_cancel(tp);
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
+	struct xfs_rtgroup	*rtg = NULL;
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
+	low.rm_startblock = xfs_rtb_to_rgbno(mp, start_fsb);
+	low.rm_owner = 0;
+	low.rm_offset = 0;
+	low.rm_flags = 0;
+	high.rm_startblock = -1U;
+	high.rm_owner = ULLONG_MAX;
+	high.rm_offset = ULLONG_MAX;
+	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			XFS_RMAP_UNWRITTEN;
+
+	start_rg = xfs_rtb_to_rgno(mp, start_fsb);
+	end_rg = xfs_rtb_to_rgno(mp, end_fsb);
+
+	info.nr = 0;
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rg, end_rg))) {
+		if (rtg_rgno(rtg) == end_rg)
+			high.rm_startblock = xfs_rtb_to_rgbno(mp, end_fsb);
+
+		error = fsmap_rtgroup(rtg, &low, &high, &info);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
+			return;
+		}
+
+		if (rtg_rgno(rtg) == start_rg)
+			low.rm_startblock = 0;
+	}
+}
+
 static int
 fsmap_f(
 	int			argc,
@@ -111,14 +239,18 @@ fsmap_f(
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
@@ -141,14 +273,23 @@ fsmap_f(
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
index cf88656946ab1b..3e521cd0c76063 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -295,6 +295,7 @@
 #define xfs_rtginode_name		libxfs_rtginode_name
 #define xfs_rtsummary_create		libxfs_rtsummary_create
 
+#define xfs_rtginode_irele		libxfs_rtginode_irele
 #define xfs_rtginode_load		libxfs_rtginode_load
 #define xfs_rtginode_load_parent	libxfs_rtginode_load_parent
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
@@ -310,8 +311,10 @@
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_update_rtsb			libxfs_update_rtsb
+#define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
+#define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk

