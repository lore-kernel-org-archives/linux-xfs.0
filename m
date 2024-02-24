Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F6B1FAA
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 06:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708754502; cv=none; b=ZluYrzhONVBt0e2PdissN7LMFmAQ70tFyiI9HC7NcSIxBKdvTCXWK4anNJPGdAbCD0jb2+qIo66ibFn0znrRItlSw95T9YTxeLz5jRVQPd1gZK7/f/lPxsqa2M+/QFtdnRxwMQjhwyG0NXFrtIGT618FZ/4rgpgQaK+zI1Uez9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708754502; c=relaxed/simple;
	bh=B9Df3Vn44QPzqip/PRdq1l0YNbHKeytn4u0tRHmvI1c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=azwj/YuR/GiyUqQMw4+vtBhooXWPkXJLxVMC+Ia8MCacCOSl6AAATVc7ZDzM6iFPQoqQ52nbi0FVNGYTXYqna2PCrqehGh3NRocEW51AgiAZuyEUdd+7a9gcg9MBAfP46erWxVkgjf+xGnmlu4IPjqoEvftmhW7IP8jyS8LP3Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yga8ET9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yga8ET9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676A1C433C7;
	Sat, 24 Feb 2024 06:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708754501;
	bh=B9Df3Vn44QPzqip/PRdq1l0YNbHKeytn4u0tRHmvI1c=;
	h=Date:From:To:Cc:Subject:From;
	b=Yga8ET9xeL463kUigdNDfLpkZC5o1cugUH2G21KsN7xzjk9rMQY1zw9TagPt+lMoO
	 4icK225dBUwPMSFyWBbc3txdtVhzPR3Uhrsmn1+tgodkN7Zn6W/wHiVP/aMf58Crdg
	 5Hz2OiTkN70Pd+Di2wNoLS6yIVnBVsK2eS5C7JF4a+V6Uc0DRDQcLmJw3jRLLFQMtC
	 TyReRmwLvkxt/alj8odqZ2NPGcZsdNaOVeudBnGGP1+VCsY21PFVVtqUwDT5TPnrME
	 E8GO6XQoXDsobhyCvDkoaG/lFTwWZPwUqymX83sM8n3Vj974XpJI895OnOx158UftJ
	 zUkN578e3TZGQ==
Date: Fri, 23 Feb 2024 22:01:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix scrub stats file permissions
Message-ID: <20240224060140.GD616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

When the kernel is in lockdown mode, debugfs will only show files that
are world-readable and cannot be written, mmaped, or used with ioctl.
That more or less describes the scrub stats file, except that the
permissions are wrong -- they should be 0444, not 0644.  You can't write
the stats file, so the 0200 makes no sense.

Meanwhile, the clear_stats file is only writable, but it got mode 0400
instead of 0200, which would make more sense.

Fix both files so that they make sense.

Fixes: d7a74cad8f451 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 12f6ebbda3758..02f7645d0c44a 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -464,9 +464,9 @@ xchk_stats_register(
 	if (!cs->cs_debugfs)
 		return;
 
-	debugfs_create_file("stats", 0644, cs->cs_debugfs, cs,
+	debugfs_create_file("stats", 0444, cs->cs_debugfs, cs,
 			&scrub_stats_fops);
-	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
+	debugfs_create_file("clear_stats", 0200, cs->cs_debugfs, cs,
 			&clear_scrub_stats_fops);
 
 	xchk_timestats_register(cs);
