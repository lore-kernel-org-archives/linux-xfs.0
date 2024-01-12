Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AAF1DDFC
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 04:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XPjmytRz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Ex8ngZz3YEIFycG5Aa2czR70KBNEJXh7WuxoJ6e9tU=; b=XPjmytRzn2XuVL4oGdM9QotTnN
	Kf28YR8NoypTBCA0Xj3kTxF+TejjjKeU4GZzrxYQvBhicoHRmOsTCs1KCwWvk14APln/+kgIJMuz5
	q9tb8bcpoLyKlKYMtEEWgGhyPE6ihMQLR7QL3jJMobkiWeC+/GNcB8gefaQXalbtO36MJp79USBbw
	DmlXjeE+PmbOWIx2b7x3nJTRe1kuFDZuSsMu+2N85Neo0ArGCk5+dc6bK5WNBb/4GjXVRViiIuLoh
	W4UYyz/XC6X4HotD6b7G793KIDss3Qf+mGAdWjEe62p35/cHa3ckp0LLNGkHzdQ7qIWHQJpTDlifT
	2RI9WNZQ==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9SY-001sYJ-1p;
	Fri, 12 Jan 2024 04:47:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] mkfs: use a sensible log sector size default
Date: Fri, 12 Jan 2024 05:47:43 +0100
Message-Id: <20240112044743.2254211-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112044743.2254211-1-hch@lst.de>
References: <20240112044743.2254211-1-hch@lst.de>
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
the device logical block size is larged this prevents a mkfs failure
because the libxfs buffer cache blows up and as we obviously can't
use a smaller than hardware supported sector size.  This fixes xfs/157
with a 4k block size device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

