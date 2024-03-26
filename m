Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0633E128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423408; cv=none; b=U8QMHgzF0aVitcOkM8re/WpY2LUkBy8yQh53VpQNkeyLsvqWb+dFoCm8dVror0OLJiGaOvzuyGuJO/CH2xX2ags7nb8bk1Z8PYTr+sVFDP7CruVDsQBeCEy1ENYSPim+UTatPHMJT0YW+PWWpHVZFB2Izqg7BQg5Vs6+3L2ycwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423408; c=relaxed/simple;
	bh=AQ8ZWv56jjobJx4pS0BfObNogFzGVGPZaa+gXctsY3M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOtzHyhzCwrFREET0987iWNckfUGL4ZH1DTvvvRa68hOZ0rNNAWHiUr8OJGJh//pFZ7Xn/SOiXPI8xg8/O7GOqpXyDwnnroe7wzQkFq9Dd4cbCuYPGRFX2QD40f8t3BWQ5UZOeGO3zeCQFShTz+KpRz7/0xQMB4iMsi3ikLDjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnZd2SLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnZd2SLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899DCC433F1;
	Tue, 26 Mar 2024 03:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423407;
	bh=AQ8ZWv56jjobJx4pS0BfObNogFzGVGPZaa+gXctsY3M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lnZd2SLgkBjtYuY6GvnWnrQk6NqQV7VXpL4evx+7Ao6WRIdYncMjGJALhlbV1ZtsM
	 SwnF1canfKq4j5E+RyvlFMOBoB/AfE0hbMCEph+7bDigBvA6TmigWFr3qT2koVdZAf
	 oTmYzrNHNHFMgJehIMUy8yBM56t/QYDSuz72laTslUKsklLAWtxKs/1kN2kIf0EVIj
	 QOhlFcZ9KUg9yUrezlEZeJoaoqPGhIl6xtpsIBrRCDWMrVarlhvvPw1drFXqdgli7y
	 wd84pcqMbNQCtHeY1OKH+Bq6JchoX2UjSohBq+7SdEFdN40KBAtq85hUDTC6trM2fN
	 ky+x7htubE7EQ==
Date: Mon, 25 Mar 2024 20:23:27 -0700
Subject: [PATCH 5/5] mkfs: use a sensible log sector size default
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org
Message-ID: <171142129016.2214261.11973818284584143075.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
References: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Currently the XFS log sector size defaults to the 512 bytes unless
explicitly overriden.  Default to the device logical block size queried
by get_topology instead.  If that is also 512 nothing changes, and if
the device logical block size is larger this prevents a mkfs failure
because the libxfs buffer cache blows up and as we obviously can't
use a smaller than hardware supported sector size.  This fixes xfs/157
with a 4k block size device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 79d6eaa37a1a..18084b1cc6d1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2075,7 +2075,8 @@ static void
 validate_log_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft)
+	struct mkfs_default_params *dft,
+	struct fs_topology	*ft)
 {
 
 	if (cli->loginternal && cli->lsectorsize &&
@@ -2090,7 +2091,7 @@ _("Can't change sector size on internal log!\n"));
 	else if (cli->loginternal)
 		cfg->lsectorsize = cfg->sectorsize;
 	else
-		cfg->lsectorsize = dft->sectorsize;
+		cfg->lsectorsize = ft->log.logical_sector_size;
 	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
 
 	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
@@ -4206,7 +4207,7 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &dft);
+	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
 	validate_sb_features(&cfg, &cli);
 
 	/*

