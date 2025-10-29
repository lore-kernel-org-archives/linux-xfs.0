Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C193E31158A
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761728874; cv=none; b=tvW9ToZMeIGGStsf/68pTJItNfkKO5C9vHsXFtmOgCvoKe5GxsWmuwEJ8+2VEMs+Kupjh0wBSFEVrgz5nTVB9GSqvJlZHd2DcJ1UsUS+Hsq9pBIXcF6SuirYW9FvBe0GfACkmHB2p9Fo65NHkxn2gfpwy7uPab2fnjB+sA9J+do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761728874; c=relaxed/simple;
	bh=WrnV1Rc8iozZvhc2TjrOXlYIGeCiW0rV/28jxzomSFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndToKRDD/K1sLCuTVJtNa3e8fHU6UCPNqUT9rwvlf3Hv1l6GUYsydK0qlCHHU47ko+PW7JJV9RhiL5nQs0UY/Tu22PMYXMa1QShYMbVOMRkCXaJ6NSImtO0Zk0qajynNH/ZmLRfqlMHQvyc36yZ1VNfQ2rLgkEYx/aLejZmHJtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C9S2j4Hz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C9S2j4Hz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hphCuFQfncC//CCL3FgFaMm09bOgf+A1ZdmX++gTLIc=; b=C9S2j4HzfpukcGxZ1OW7wmCrwv
	/qp4zQYXjRWrPMF4Py4SAajk/LrnrdAZh9/wfagz3X9E4nPyoREiHIq62/qA/02oxayifiQ0W63vd
	jMOqF/TYfj7liW+ptxMMgXjhR+0HQZTTARG2AvYicxXH76yBhx69PceENLPVx2TH6fGGDpXQ3jJrB
	gjkDsdB1EdeJNH3pjPfkOFMTKQ7osTj3Hlo9dbxiAqNk+IKsSsDqL2TYiOlAiujffeN1EPakulL7e
	LgjHWeRt/WQ34g0BJFV0SpFMka8nm1aD5cRqPLjqcBCd14examUMG45zy0Gpjdv8Bpm/l/SAHglKL
	Y8D+bhNA==;
Received: from [2001:4bb8:2dc:1fd0:cc53:aef5:5079:41d6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE29n-00000000QlV-3Y6t;
	Wed, 29 Oct 2025 09:07:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] mkfs: remove duplicate struct libxfs_init arguments
Date: Wed, 29 Oct 2025 10:07:31 +0100
Message-ID: <20251029090737.1164049-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029090737.1164049-1-hch@lst.de>
References: <20251029090737.1164049-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The libxfs_init structure instance is pointed to by cli_params, so use
that were it already exists instead of passing an additional argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0ba7798eccf6..09a69af31be5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4005,8 +4005,7 @@ ddev_is_solidstate(
 static void
 calc_concurrency_ag_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	struct libxfs_init	*xi)
+	struct cli_params	*cli)
 {
 	uint64_t		try_agsize;
 	uint64_t		def_agsize;
@@ -4074,11 +4073,10 @@ out:
 static void
 calculate_initial_ag_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	struct libxfs_init	*xi)
+	struct cli_params	*cli)
 {
 	if (cli->data_concurrency > 0) {
-		calc_concurrency_ag_geometry(cfg, cli, xi);
+		calc_concurrency_ag_geometry(cfg, cli);
 	} else if (cli->agsize) {	/* User-specified AG size */
 		cfg->agsize = getnum(cli->agsize, &dopts, D_AGSIZE);
 
@@ -4099,8 +4097,9 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
 		cfg->agcount = cli->agcount;
 		cfg->agsize = cfg->dblocks / cfg->agcount +
 				(cfg->dblocks % cfg->agcount != 0);
-	} else if (cli->data_concurrency == -1 && ddev_is_solidstate(xi)) {
-		calc_concurrency_ag_geometry(cfg, cli, xi);
+	} else if (cli->data_concurrency == -1 &&
+		   ddev_is_solidstate(cli->xi)) {
+		calc_concurrency_ag_geometry(cfg, cli);
 	} else {
 		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
 					 cfg->dsunit, &cfg->agsize,
@@ -4360,8 +4359,7 @@ rtdev_is_solidstate(
 static void
 calc_concurrency_rtgroup_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	struct libxfs_init	*xi)
+	struct cli_params	*cli)
 {
 	uint64_t		try_rgsize;
 	uint64_t		def_rgsize;
@@ -4468,8 +4466,7 @@ _("realtime group count (%llu) must be less than the maximum (%u)\n"),
 static void
 calculate_rtgroup_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	struct libxfs_init	*xi)
+	struct cli_params	*cli)
 {
 	if (!cli->sb_feat.metadir) {
 		cfg->rgcount = 0;
@@ -4510,8 +4507,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		cfg->rgsize = cfg->rtblocks;
 		cfg->rgcount = 0;
 	} else if (cli->rtvol_concurrency > 0 ||
-		   (cli->rtvol_concurrency == -1 && rtdev_is_solidstate(xi))) {
-		calc_concurrency_rtgroup_geometry(cfg, cli, xi);
+		   (cli->rtvol_concurrency == -1 &&
+		    rtdev_is_solidstate(cli->xi))) {
+		calc_concurrency_rtgroup_geometry(cfg, cli);
 	} else if (is_power_of_2(cfg->rtextblocks)) {
 		cfg->rgsize = calc_rgsize_extsize_power(cfg);
 		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
@@ -4538,7 +4536,6 @@ static void
 adjust_nr_zones(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct libxfs_init	*xi,
 	struct zone_topology	*zt)
 {
 	uint64_t		new_rtblocks, slack;
@@ -4547,7 +4544,8 @@ adjust_nr_zones(
 	if (zt->rt.nr_zones)
 		max_zones = zt->rt.nr_zones;
 	else
-		max_zones = DTOBT(xi->rt.size, cfg->blocklog) / cfg->rgsize;
+		max_zones = DTOBT(cli->xi->rt.size, cfg->blocklog) /
+				cfg->rgsize;
 
 	if (!cli->rgcount)
 		cfg->rgcount += XFS_RESERVED_ZONES;
@@ -4576,7 +4574,6 @@ static void
 calculate_zone_geometry(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct libxfs_init	*xi,
 	struct zone_topology	*zt)
 {
 	if (cfg->rtblocks == 0) {
@@ -4645,7 +4642,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 	}
 
 	if (cli->rtsize || cli->rgcount)
-		adjust_nr_zones(cfg, cli, xi, zt);
+		adjust_nr_zones(cfg, cli, zt);
 
 	if (cfg->rgcount < XFS_MIN_ZONES)  {
 		fprintf(stderr,
@@ -4984,7 +4981,6 @@ static uint64_t
 calc_concurrency_logblocks(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct libxfs_init	*xi,
 	unsigned int		max_tx_bytes)
 {
 	uint64_t		log_bytes;
@@ -4992,7 +4988,7 @@ calc_concurrency_logblocks(
 	unsigned int		new_logblocks;
 
 	if (cli->log_concurrency < 0) {
-		if (!ddev_is_solidstate(xi))
+		if (!ddev_is_solidstate(cli->xi))
 			goto out;
 
 		cli->log_concurrency = nr_cpus();
@@ -5160,7 +5156,6 @@ static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct libxfs_init	*xi,
 	struct xfs_mount	*mp)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
@@ -5225,8 +5220,8 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		if (cfg->lsunit) {
 			uint64_t	max_logblocks;
 
-			max_logblocks = min(DTOBT(xi->log.size, cfg->blocklog),
-					    XFS_MAX_LOG_BLOCKS);
+			max_logblocks = min(XFS_MAX_LOG_BLOCKS,
+				DTOBT(cli->xi->log.size, cfg->blocklog));
 			align_log_size(cfg, cfg->lsunit, max_logblocks);
 		}
 
@@ -5261,7 +5256,7 @@ _("max log size %d smaller than min log size %d, filesystem is too small\n"),
 
 		if (cli->log_concurrency != 0)
 			cfg->logblocks = calc_concurrency_logblocks(cfg, cli,
-							xi, max_tx_bytes);
+							max_tx_bytes);
 
 		/* But don't go below a reasonable size */
 		cfg->logblocks = max(cfg->logblocks,
@@ -6135,12 +6130,12 @@ main(
 	 * dependent on device sizes. Once calculated, make sure everything
 	 * aligns to device geometry correctly.
 	 */
-	calculate_initial_ag_geometry(&cfg, &cli, &xi);
+	calculate_initial_ag_geometry(&cfg, &cli);
 	align_ag_geometry(&cfg, &ft);
 	if (cfg.sb_feat.zoned)
-		calculate_zone_geometry(&cfg, &cli, &xi, &zt);
+		calculate_zone_geometry(&cfg, &cli, &zt);
 	else
-		calculate_rtgroup_geometry(&cfg, &cli, &xi);
+		calculate_rtgroup_geometry(&cfg, &cli);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -6164,7 +6159,7 @@ main(
 	 * With the mount set up, we can finally calculate the log size
 	 * constraints and do default size calculations and final validation
 	 */
-	calculate_log_size(&cfg, &cli, &xi, mp);
+	calculate_log_size(&cfg, &cli, mp);
 
 	finish_superblock_setup(&cfg, mp, sbp);
 
-- 
2.47.3

