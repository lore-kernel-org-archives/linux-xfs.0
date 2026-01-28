Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E75C8CE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574814; cv=none; b=MhmH7UcGghCbmGX8e1tK7F2vcw8mo2wHlicRW8QWDQQIpEtE5x3R51OjEePRTLAFO3c1mxJmjzlWwxDGol4ayJtHw61laH0Rb5NTT/sO2tbWxgojs8as03VUqBoGkeNUf8wDBCUdrMiefSLHVCK+BTh6uW8SFp+JTIAjCNOmfKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574814; c=relaxed/simple;
	bh=VHeaSN2G39PvrTJbYydB7z97ytHve/EasEzS1yrIhEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4CNF61l1zAfGIkEXxtRRpLVdB7dsaKekiguFapsPnPc/qIwxA4RsgeGbeKx/Bt8QwK4Nyvznm+QjVfgezZ1cRrRC42yHJE71yeSRAHw+CsfVDZShH4CpxCmg5/7PJ2B246sCWQrLxf6pczxgaP6HOMbLoQcgGP0d1tzV3VuPzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tg5HwXPx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tg5HwXPx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+f/UbriC4kyOY/9LgK5JNDkIzJOW5ieZrgVB4hwdWYE=; b=tg5HwXPxvPey7tQrZhPH3oNlsU
	m0gpjOlsspc0bJYHHOPcuIRw8ZDGRnOXIAZlMlBZLOSo/pGsZMLW6uUlITej2Qr/S/sXfYiIFTZtM
	HIS6lQFNlkLBC3lmVoYkniWczG8ci/7bgd/BDg+NBUEkcUy3krJa0XnRQmDh3i5uIJA12I06Qi9OU
	ybgxZxDhBSkyp6qUgpkQMPkCAoE7HetezPMmG2b/ZJYohP5p86idFll29Mo+RGo8jf5w3rqXtfxas
	DhBLSVi6CzWlPdURCjAR25QwdCzcJxDPBVtBTPnlRrVznyX4HhpC1UQl3LCAcV8yUMTBLgyEor7n6
	spG2IOVw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxFD-0000000FQar-2Hhf;
	Wed, 28 Jan 2026 04:33:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] xfs: use blkdev_report_zones_cached()
Date: Wed, 28 Jan 2026 05:32:56 +0100
Message-ID: <20260128043318.522432-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128043318.522432-1-hch@lst.de>
References: <20260128043318.522432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: e04ccfc28252f181ea8d469d834b48e7dece65b2

Modify xfs_mount_zones() to replace the call to blkdev_report_zones()
with blkdev_report_zones_cached() to speed-up mount operations.
Since this causes xfs_zone_validate_seq() to see zones with the
BLK_ZONE_COND_ACTIVE condition, this function is also modified to acept
this condition as valid.

With this change, mounting a freshly formatted large capacity (30 TB)
SMR HDD completes under 2s compared to over 4.7s before.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h | 8 ++++++++
 libxfs/xfs_zones.c      | 1 +
 2 files changed, 9 insertions(+)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index 1152f0622ccf..1a9f401fc11c 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -308,4 +308,12 @@ struct kvec {
 	size_t iov_len;
 };
 
+/*
+ * Local definitions for the new cached report zones added in Linux 6.19 in case
+ * the system <linux/blkzoned.h> doesn't provide them yet.
+ */
+#ifndef BLK_ZONE_COND_ACTIVE
+#define BLK_ZONE_COND_ACTIVE	0xff
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index c1ad7075329c..90e2ba0908be 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -96,6 +96,7 @@ xfs_zone_validate_seq(
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
 		return xfs_zone_validate_wp(zone, rtg, write_pointer);
 	case BLK_ZONE_COND_FULL:
 		return xfs_zone_validate_full(zone, rtg, write_pointer);
-- 
2.47.3

