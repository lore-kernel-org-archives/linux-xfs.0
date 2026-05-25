Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B13D5C1C
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695909; cv=none; b=U6wDHL85gC7rY1+m5ApPtCIl/KB4U0ohel5EeSlFzrzQ5Angz6zQhQjlG9GhyP33Ua8OVdwftKxspnqQr+xZ5Ic6yD5RM6WU3Ecg92aFm23S99l1gf4+hanJyYvky8h0XuOu3p691wR+pAYaUd46N5g9nSMRm/0F3Bz/Siupp1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695909; c=relaxed/simple;
	bh=QZYJXdgeT6jbTsUxPadni69ElOrecSt5wvMcQItv3kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THSIzw0sbggU8yTcyTHL08MLAITyfYaBkN2UiSRU1guyA7EdBZ3rmUKRLcXWhYvmCWPT6xGoG178uAT6IJE8lTxE5qkAUL6crawEvUz+cw+P1qDYqXyg7rAqhymk9H8LcTe/0Ilvb9D9bY3CmY36mDsCnBJhS9/nJNNqheWVTHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id D780E180F2E8;
	Mon, 25 May 2026 09:58:17 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:17 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 1/5] xfsprogs: mkfs.xfs Add buildtime default cli_params as global variable
Date: Mon, 25 May 2026 09:57:48 +0200
Message-ID: <20260525075752.4159504-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525075752.4159504-1-lukas@herbolt.com>
References: <20260525075752.4159504-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch unites the settings of cli_params and mkfs_default_params
into one global variable and then it copies its value into cli.
The behavior should remain unchanged. It is preparation for next patch
implementing the default config file.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 116 +++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 66 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd8a48c3633e..349afe65c9fc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1190,17 +1190,44 @@ struct mkfs_params {
  * values directly - they are inputs to the mkfs geometry validation and
  * calculations.
  */
-struct mkfs_default_params {
-	char	*source;	/* where the defaults came from */
-
-	int	sectorsize;
-	int	blocksize;
-
-	/* feature flags that are set */
-	struct sb_feat_args	sb_feat;
-
-	/* root inode characteristics */
-	struct fsxattr		fsx;
+struct cli_params bld_dft = {
+       .sectorsize = XFS_MIN_SECTORSIZE,
+       .blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
+
+       .loginternal = 1,
+       .is_supported   = 1,
+       .data_concurrency = -1, /* auto detect non-mechanical storage */
+       .log_concurrency = -1, /* auto detect non-mechanical ddev */
+       .rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
+       .autofsck = FSPROP_AUTOFSCK_UNSET,
+       .imaxpct = -1, /* set sb_imax_pct automatically */
+
+       .sb_feat = {
+               .log_version = 2,
+               .attr_version = 2,
+               .dir_version = 2,
+               .inode_align = true,
+               .nci = false,
+               .lazy_sb_counters = true,
+               .projid32bit = true,
+               .crcs_enabled = true,
+               .dirftype = true,
+               .finobt = true,
+               .spinodes = true,
+               .rmapbt = true,
+               .reflink = true,
+               .inobtcnt = true,
+               .parent_pointers = true,
+               .nodalign = false,
+               .nortalign = false,
+               .bigtime = true,
+               .nrext64 = true,
+               .exchrange = true,
+               /*
+                * When we decide to enable a new feature by default,
+                * please remember to update the mkfs conf files.
+                */
+       },
 };
 
 static void __attribute__((noreturn))
@@ -2351,7 +2378,7 @@ static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft,
+	struct cli_params	*dft,
 	struct fs_topology	*ft,
 	int			dry_run,
 	int			force_overwrite)
@@ -2441,7 +2468,7 @@ static void
 validate_blocksize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft)
+	struct cli_params	*dft)
 {
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
@@ -2481,7 +2508,7 @@ static void
 validate_log_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft,
+	struct cli_params	*dft,
 	struct fs_topology	*ft)
 {
 
@@ -2673,7 +2700,7 @@ static void
 validate_zoned(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft,
+	struct cli_params	*dft,
 	struct zone_topology	*zt)
 {
 	if (!cli->xi->data.isfile) {
@@ -5949,17 +5976,8 @@ main(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_dsb		*dsb;
 	struct fs_topology	ft = {};
-	struct cli_params	cli = {
-		.xi = &xi,
-		.loginternal = 1,
-		.is_supported	= 1,
-		.data_concurrency = -1, /* auto detect non-mechanical storage */
-		.log_concurrency = -1, /* auto detect non-mechanical ddev */
-		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
-		.autofsck = FSPROP_AUTOFSCK_UNSET,
-		.imaxpct = -1, /* set sb_imax_pct automatically */
-	};
 	struct mkfs_params	cfg = {};
+	struct cli_params	cli;
 
 	struct option		long_options[] = {
 	{
@@ -5971,43 +5989,13 @@ main(
 	{NULL, 0, NULL, 0 },
 	};
 	int			option_index = 0;
-
-	/* build time defaults */
-	struct mkfs_default_params	dft = {
-		.source = _("package build definitions"),
-		.sectorsize = XFS_MIN_SECTORSIZE,
-		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
-		.sb_feat = {
-			.log_version = 2,
-			.attr_version = 2,
-			.dir_version = 2,
-			.inode_align = true,
-			.nci = false,
-			.lazy_sb_counters = true,
-			.projid32bit = true,
-			.crcs_enabled = true,
-			.dirftype = true,
-			.finobt = true,
-			.spinodes = true,
-			.rmapbt = true,
-			.reflink = true,
-			.inobtcnt = true,
-			.parent_pointers = true,
-			.nodalign = false,
-			.nortalign = false,
-			.bigtime = true,
-			.nrext64 = true,
-			.exchrange = true,
-			/*
-			 * When we decide to enable a new feature by default,
-			 * please remember to update the mkfs conf files.
-			 */
-		},
-	};
 	struct zone_topology zt = {};
 	struct list_head	buffer_list;
 	int			error;
 
+	/* copy builtin defaults into CLI parsing structure */
+	memcpy(&cli, &bld_dft, sizeof(cli));
+	cli.xi = &xi;
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -6028,10 +6016,6 @@ main(
 	 * printf(_("Default configuration sourced from %s\n"), dft.source);
 	 */
 
-	/* copy new defaults into CLI parsing structure */
-	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
-	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
-
 	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
 					long_options, &option_index)) != EOF) {
 		switch (c) {
@@ -6093,8 +6077,8 @@ main(
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
 	 */
-	validate_blocksize(&cfg, &cli, &dft);
-	validate_sectorsize(&cfg, &cli, &dft, &ft, dry_run, force_overwrite);
+	validate_blocksize(&cfg, &cli, &bld_dft);
+	validate_sectorsize(&cfg, &cli, &bld_dft, &ft, dry_run, force_overwrite);
 
 	/*
 	 * XXX: we still need to set block size and sector size global variables
@@ -6103,8 +6087,8 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
-	validate_zoned(&cfg, &cli, &dft, &zt);
+	validate_log_sectorsize(&cfg, &cli, &bld_dft, &ft);
+	validate_zoned(&cfg, &cli, &bld_dft, &zt);
 	validate_sb_features(&cfg, &cli);
 
 	/*
-- 
2.54.0

