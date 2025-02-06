Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB852417C7
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882356; cv=none; b=dOUDr5VwMooPCUQDAmpmuUTdO4IPKL5qYNX2voqHejxjTYRdXu15CZVOgUKmLRRvL0DaDlmHK7TMQ2m7x4JKfHhNqAp5nyZjMtCTjUyvDxA6WQQq0mhluc62ktmRbiSDl746wgpLywuwp4Qz2loaF3LnFZnnAWbbxfe4l45GETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882356; c=relaxed/simple;
	bh=YKln6B6t0YiCO23iRTSU8MpqfB6Nq91EjqjOu+w8siI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uX5xAiSOgmviiPCFmYVUT7UXii1/j6V8RlcICipBJNmSCW1dLmsH5NC1A0MlGB6bd0Xd8UAj7EL2cpuNU41JESnVV81szrvRkdudp8MVYz80yCn6tDMabTc4A55KDdYCCCikV4aWOnnYioexy4ZNyceMEyB0De+t/f0U0O+Hwrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWPhzFAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWPhzFAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05E2C4CEDD;
	Thu,  6 Feb 2025 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882356;
	bh=YKln6B6t0YiCO23iRTSU8MpqfB6Nq91EjqjOu+w8siI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sWPhzFAve5Llub2f4aPtIVOhGsJtO/TGN0YPEvSGdK9pMD2QPgFMsuxNr2toOEF+g
	 ocHYbmS8NJC9m5hpNIa3snH2iofASRtHz9DEWWWzyv62tibC/zICQLAADVB9dmp+YN
	 ropa/RHb3L6RnE2HbnW0GUftS6QfbwoPHwigOnS6sF2tIWHHhKOHzx9ui77bakI/Jf
	 zSaXYb8GxfgCVEYe0p2hpU+VZDxDGbeZagw5dIcm4ON/z2jq1Jw61ZtRzNaScqnRS9
	 rJ6UxbeGDwC1wRCSIU9d58AVwfR6ATZYfyR9j099TjdpwLp4GY9Or/C+d4nZI7aEiM
	 eI6oQOdep902w==
Date: Thu, 06 Feb 2025 14:52:36 -0800
Subject: [PATCH 11/27] xfs_db: add an rgresv command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088264.2741033.15457962498927616155.stgit@frogsfrogsfrogs>
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

Create a command to dump rtgroup btree space reservations.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/info.c                |  119 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 +
 man/man8/xfs_db.8        |    5 ++
 3 files changed, 126 insertions(+)


diff --git a/db/info.c b/db/info.c
index 9a86d247839f84..ce6f358420a79d 100644
--- a/db/info.c
+++ b/db/info.c
@@ -151,9 +151,128 @@ static const struct cmdinfo agresv_cmd = {
 	.help =		agresv_help,
 };
 
+static void
+rgresv_help(void)
+{
+	dbprintf(_(
+"\n"
+" Print the size and per-rtgroup reservation information for some realtime allocation groups.\n"
+"\n"
+" Specific realtime allocation group numbers can be provided as command line\n"
+" arguments.  If no arguments are provided, all allocation groups are iterated.\n"
+"\n"
+));
+
+}
+
+static void
+print_rgresv_info(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_trans	*tp;
+	xfs_filblks_t		ask = 0;
+	xfs_filblks_t		used = 0;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error) {
+		dbprintf(
+ _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
+				rtg_rgno(rtg));
+		return;
+	}
+
+	error = -libxfs_rtginode_load_parent(tp);
+	if (error) {
+		dbprintf(_("Cannot load realtime metadir, error %d\n"),
+			error);
+		goto out_trans;
+	}
+
+	/* rtrmapbt */
+	error = -libxfs_rtginode_load(rtg, XFS_RTGI_RMAP, tp);
+	if (error) {
+		dbprintf(_("Cannot load rtgroup %u rmap inode, error %d\n"),
+			rtg_rgno(rtg), error);
+		goto out_rele_dp;
+	}
+	if (rtg_rmap(rtg))
+		used += rtg_rmap(rtg)->i_nblocks;
+	libxfs_rtginode_irele(&rtg->rtg_inodes[XFS_RTGI_RMAP]);
+
+	ask += libxfs_rtrmapbt_calc_reserves(mp);
+
+	printf(_("rtg %d: dblocks: %llu fdblocks: %llu reserved: %llu used: %llu"),
+			rtg_rgno(rtg),
+			(unsigned long long)mp->m_sb.sb_dblocks,
+			(unsigned long long)mp->m_sb.sb_fdblocks,
+			(unsigned long long)ask,
+			(unsigned long long)used);
+	if (ask - used > mp->m_sb.sb_fdblocks)
+		printf(_(" <not enough space>"));
+	printf("\n");
+out_rele_dp:
+	libxfs_rtginode_irele(&mp->m_rtdirip);
+out_trans:
+	libxfs_trans_cancel(tp);
+}
+
+static int
+rgresv_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	int			i;
+
+	if (argc > 1) {
+		for (i = 1; i < argc; i++) {
+			long	a;
+			char	*p;
+
+			errno = 0;
+			a = strtol(argv[i], &p, 0);
+			if (p == argv[i])
+				errno = ERANGE;
+			if (errno) {
+				perror(argv[i]);
+				continue;
+			}
+
+			if (a < 0 || a >= mp->m_sb.sb_rgcount) {
+				fprintf(stderr, "%ld: Not a rtgroup.\n", a);
+				continue;
+			}
+
+			rtg = libxfs_rtgroup_get(mp, a);
+			print_rgresv_info(rtg);
+			libxfs_rtgroup_put(rtg);
+		}
+		return 0;
+	}
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		print_rgresv_info(rtg);
+
+	return 0;
+}
+
+static const struct cmdinfo rgresv_cmd = {
+	.name =		"rgresv",
+	.altname =	NULL,
+	.cfunc =	rgresv_f,
+	.argmin =	0,
+	.argmax =	-1,
+	.canpush =	0,
+	.args =		NULL,
+	.oneline =	N_("print rtgroup reservation stats"),
+	.help =		rgresv_help,
+};
+
 void
 info_init(void)
 {
 	add_command(&info_cmd);
 	add_command(&agresv_cmd);
+	add_command(&rgresv_cmd);
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 3e521cd0c76063..9beea4f7ce8535 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -311,7 +311,9 @@
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_update_rtsb			libxfs_update_rtsb
+#define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
+#define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 83a8734d3c0b47..784aa3cb46c588 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1131,6 +1131,11 @@ .SH COMMANDS
 Exit
 .BR xfs_db .
 .TP
+.BI "rgresv [" rgno ]
+Displays the per-rtgroup reservation size, and per-rtgroup
+reservation usage for a given realtime allocation group.
+If no argument is given, display information for all rtgroups.
+.TP
 .BI "rtblock [" rtbno ]
 Set current address to the location on the realtime device given by
 .IR rtbno .

