Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF2453E2D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366070; cv=none; b=AJv/7soHAR4PqQwSjeZtREvxmuo5Sv9kOdCPoFpEA464POxDmcLppwKTYJ4pi5e+ME2yo+R8uOl5zmLQIMHkwaQMevM0KpAsfmtHEKWyz0D2xVaa0xXm2tmJ0tU2h+2ko7ACPZS5RQClCpXPo8oDzHpESjuNGbbp4E13e+Ma4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366070; c=relaxed/simple;
	bh=17H7BoEeHoPlmXT09AGcC3qlK0jGSbehvhViXQ5hx/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bkjqeVWIomANwMW5aRiI3l9a/mPPw73/ZgneXbX1YZb8/PXgrbadjfehEO4rHJBkFSwsDneJIupEHRPZtSltO0LYYhEo7YqfIPUMY8nZ6Z+ytMunX8rydfu2iZ98rl/SrdXdlupTUI25VOTAJq+vV2KzzSXQJ3DO7yuOs7e3y6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=skKfXkWo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="skKfXkWo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fR3yFr9TnoTUeOUldS7KhaX2T/+fASq+jO38BPUUU7A=; b=skKfXkWo26j5QzRfXj65DhdVCA
	cV8ttS8+B6ygBlhe30irwdQjaXaR3qRFhxi+hR5mmX/oCeRvEScsBet9ju/gF+qLxRCD6T32FX3De
	R02zeGiw8y60CQ290zAGRbTOH9iAEoMUe5IKFxFAkYaRpNsrop7Af1/+XNkKfLG5Kpnz28ACCwxhW
	9XhdfZGL3dAJAHmv6OfKF9VaF+k5eT5oIAjwehNLTAOcnhpeyv/01G3lGuR9ywdCpmT7h0AfPENYW
	NjpLvzJqRp5Qxsu8YzZ1Kvy8b7kK73wmFNB10Mi97eXCBNqChsxKwyC1VH05zKY77+X/DXHp3b+bf
	rru8dzOw==;
Received: from [206.0.71.29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWLU-0000000Bxry-0eTu;
	Wed, 13 Mar 2024 21:41:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 5/5] mkfs: use a sensible log sector size default
Date: Wed, 13 Mar 2024 14:40:51 -0700
Message-Id: <20240313214051.1718117-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240313214051.1718117-1-hch@lst.de>
References: <20240313214051.1718117-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

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
---
 mkfs/xfs_mkfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index be65ccc1e..022a11a7f 100644
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
@@ -4196,7 +4197,7 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &dft);
+	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
 	validate_sb_features(&cfg, &cli);
 
 	/*
-- 
2.39.2

