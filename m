Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411AE37714
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390144; cv=none; b=dr1g5I/XXxP/kp3GOqRb154SFovVL4g7sfldATclOHyiO0TiA5XGAtn7tEljIc3Wd3hjLanm147v8VW67UfMSEAld84cnlboCIg6kWuZGD1mdrEoKxjg3fTtUKzdwQo1Ah14Sia2e5RQExMQkYOe0Dw4EE0gWwmAY4ik0gkYCRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390144; c=relaxed/simple;
	bh=BuQXXzld1fyoSEIpr05vO0tltqwdS/Z/GuJTjKSuQ7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAlTmPUA+g3bZpo6OlYpTADAKNS1mEtDCyEQJAA8A+bGCCCNuAWKHWyM19WepUT8zwjkjKXN4crm+XYQ+VN6UC9nXSuJNpdl/xuBAo8siaP8K9fG5GS0qqXi6Ussvx6c/KnkN2d0JWjbn7zOQPxFIUpT2tjvhO1bDsDvswakzjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAf52o8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAf52o8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C9AC072AA;
	Wed, 17 Apr 2024 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390144;
	bh=BuQXXzld1fyoSEIpr05vO0tltqwdS/Z/GuJTjKSuQ7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aAf52o8rc4RYDqP9no3seU/SWKiYZ16/EmdB+LQf25yoWZKoZlKn6kPKYTQjBSxm7
	 NOjNe4HaZ2PIOFJMa9JvH9++zf5z12GIrow06bey6IiXqHHrREjtp091gktjBLjj4R
	 DvAUmOdUONuzOp8pmLv0GC+pkDiYvnZga4WR7YkRcXdC6tc6ZB0/dXkkyqRfZOJmmX
	 FsGP+TLSoovZvHB+heLGb95oMDUhTlXwzJZ99OI3Sja8Wb5AehhMT7XDe0Vckdw8pQ
	 6BJZFr0rCXhYrKYwoE4paVEAAfUZqsY2+AjEtuXw+Mfw7Vrb0lbBKrQ/wNdvmVDyTM
	 rhcEGSivlme9w==
Date: Wed, 17 Apr 2024 14:42:23 -0700
Subject: [PATCH 5/5] mkfs: use a sensible log sector size default
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org
Message-ID: <171338844439.1856006.4504450948038965204.stgit@frogsfrogsfrogs>
In-Reply-To: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
References: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
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
index 79d6eaa37..18084b1cc 100644
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

