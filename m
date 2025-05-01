Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8554315E;
	Thu,  1 May 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106745; cv=none; b=n++Z42YMCGfytvR71Ma/n7K3QYXe3HrzCM61azRazO7bgfah9vJPHuWofaR3FGIzpNj3poeR/Y8RJSMlUsoVgT+A+osp1QfYRBw0jhUBOHJ7T4+Id1Ss1GzFm9qfW6uwFa8Gip8EhxcwMqafRvmz/OS8iTWOJyUb7dXHryBGTGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106745; c=relaxed/simple;
	bh=Itx7oSDlqj47+5VBh9kRD2RA9zQE9zDgTCCEa1s73Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MesPqipP34LagDLp6UheeqjF1EkDSHEwsyH9iFOEzxdGFcs4sz5vVbEcWC9hcM5sk/XcXF82f7cuqJVHNXQyWPjUsx92yePIriW+SDyn5c3+cgQh4hsa7NQ04wmmSIiSZqw/lPofRTrrYULv5vNVwWdTM4TjE227rp6NUcvbHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i2xzLK+y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i2xzLK+y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8vXrBzuTlL5SmSkXBnExmnl+H7GZgQS9xb+6Ld8DA/8=; b=i2xzLK+yyQRIJWKJmW7wnzebeI
	afEFHZ7jH0OwJaEYVaWPnCVfGYfwRUQwX6IJlCRuzTAtAFyZy8tYu104DYHWtLxT/bTIL1mmcJewM
	9EaP6HObbpbvc7L1g2XArQ34ZT7gW3j/nzUWEOMRhGWTUrylhFzharGaF86j0SWf4Do7NGkFcvBT5
	hBZZTWTOhuYr9oFxxou3bh+shj7BfwSX1UigBoPLAIfAHZt2ZR71XujBDUA/Rcvc5AQoZxtgJDaX5
	JOR60akxXtcXadFbbbPsg/yiHcyR9hRKn77JKEfRqgf4o5ohMlX24zfEre7dCNKS8uI9UlmSr53lg
	byzR9w9Q==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAU7y-0000000Fqem-36KQ;
	Thu, 01 May 2025 13:39:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: check for zoned-specific errors in _try_scratch_mkfs_xfs
Date: Thu,  1 May 2025 08:38:55 -0500
Message-ID: <20250501133900.2880958-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501133900.2880958-1-hch@lst.de>
References: <20250501133900.2880958-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check for a few errors issued for unsupported zoned configurations in
_try_scratch_mkfs_xfs so that the test is not run instead of failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/xfs b/common/xfs
index 96c15f3c7bb0..39650bac6c23 100644
--- a/common/xfs
+++ b/common/xfs
@@ -160,6 +160,11 @@ _try_scratch_mkfs_xfs()
 
 	grep -q crc=0 $tmp.mkfsstd && _force_xfsv4_mount_options
 
+	grep -q "zoned file systems do not support" $tmp.mkfserr && \
+		_notrun "Not supported on zoned file systems"
+	grep -q "must be greater than the minimum zone count" $tmp.mkfserr && \
+		_notrun "Zone count too small"
+
 	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
 		# manually parse the mkfs output to get the fs size in bytes
 		local fs_size
-- 
2.47.2

