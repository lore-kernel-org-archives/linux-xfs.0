Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E683AD51A
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695916; cv=none; b=fdv2iT60muvWNy6pfYTTswR1zWo2j2Ii50s3C0TL5Um+mJP1pwNdxsJIXZfxJeyU4yQIdCHlrHR6YufqxBKmx7Ol5t8ZB2qbeVZSZV3zKVFZYovKy9pkVVUulF2SLBvq+nUvaOYRzHNg8fPeBJu0ll18BGR4rL+nRnIRoZAYXRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695916; c=relaxed/simple;
	bh=c0tNzFZE5LyovI1SYbZVltwE791+ggqBjaz2beBdWWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYIPGU3+CNCWxpcGEzL3rKVCUJ+cG6QiU6SqHwn0H+hBXzglxGE/sz8XpOeP2kiB0i/3BttNcPhqW27oivpeoM8OXAdci0BJCFw0kEqFZIlIT3OhTHfMqZOunwWSsh0wimlYu6JXzBmJGcFGJPV/xkY4rRtXirz7oX+Yxef0lv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 260DA180F2D5;
	Mon, 25 May 2026 09:58:31 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA:T6
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:31 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 5/5] xfsprogs: mkfs.xfs clean up unused dft option in various validators
Date: Mon, 25 May 2026 09:57:52 +0200
Message-ID: <20260525075752.4159504-6-lukas@herbolt.com>
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

The struct cli_params dft was only used in validate_blocksize().
Now the cli.blocksize is always set either over bld_dflt or
file_dflt or from command line/config file. All the other functions
are not accessing the dft in their body.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cb9c528021d6..5d1d27235a72 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2392,7 +2392,6 @@ static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct cli_params	*dft,
 	struct fs_topology	*ft,
 	int			dry_run,
 	int			force_overwrite)
@@ -2481,18 +2480,19 @@ _("block size %d cannot be smaller than sector size %d\n"),
 static void
 validate_blocksize(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	struct cli_params	*dft)
+	struct cli_params	*cli)
 {
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
+	 *
+	 * The cli->blocksize size is already set from the bld_dflt
+	 * or from file_dflt or via command line. We just need to check
+	 * if the value is within our limits.
 	 */
-	if (!cli->blocksize)
-		cfg->blocksize = dft->blocksize;
-	else
-		cfg->blocksize = cli->blocksize;
+
+	cfg->blocksize = cli->blocksize;
 	cfg->blocklog = libxfs_highbit32(cfg->blocksize);
 
 	/* validate block sizes are in range */
@@ -2522,7 +2522,6 @@ static void
 validate_log_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct cli_params	*dft,
 	struct fs_topology	*ft)
 {
 
@@ -2714,7 +2713,6 @@ static void
 validate_zoned(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct cli_params	*dft,
 	struct zone_topology	*zt)
 {
 	if (!cli->xi->data.isfile) {
@@ -6163,8 +6161,8 @@ main(
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
 	 */
-	validate_blocksize(&cfg, &cli, &bld_dft);
-	validate_sectorsize(&cfg, &cli, &bld_dft, &ft, dry_run, force_overwrite);
+	validate_blocksize(&cfg, &cli);
+	validate_sectorsize(&cfg, &cli, &ft, dry_run, force_overwrite);
 
 	/*
 	 * XXX: we still need to set block size and sector size global variables
@@ -6173,8 +6171,8 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &bld_dft, &ft);
-	validate_zoned(&cfg, &cli, &bld_dft, &zt);
+	validate_log_sectorsize(&cfg, &cli, &ft);
+	validate_zoned(&cfg, &cli, &zt);
 	validate_sb_features(&cfg, &cli);
 
 	/*
-- 
2.54.0

