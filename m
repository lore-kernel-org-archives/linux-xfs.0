Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD59C8D6
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324503; cv=none; b=BD7Xut04fYcH4aeiMFIWOrdFMyIDUyvLd0SVEO0N8x4m1V/HjLzLfRsSe2OW/fZjmUDLzDWoYU49slXC6trWIIh5nwR2c4LsNSMq2J4vHoPRPr3/54xa6NbaUdLjAEpYiVtu7Gua1q7UsVLxt4IHfDvLHpQGEdTn1Uj61/tsDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324503; c=relaxed/simple;
	bh=xBa2lyyEcTUlaWc4D6/RDMsEcgSjhigc5Y2SqfXeGKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ubvJPEyLblhrcFchhNm74K7gD2VaOjr/G1d43hokSeuIo6jCd3X26K/duJbfZUsqKz6dP9wRBLvvuKMisZ64eL2PNnFKS+7LYN9KeXcc7Ew/68GJlMXNUwCUSbzEPNk/CcJ3ScDEtRNGt+rsA4ztUZp1lhJIQgSkxucU4Q4qzeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PY3Epdp/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PY3Epdp/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y4ISMC2WuYsswzffQTA033l9eUQhte/5S1w7lh+sNWA=; b=PY3Epdp/DXgBgjpDvUmOOKVqd1
	EUZ2o9wB+PUuDGRpnZ2RoRHyCMevgjFezSiS0aF4grZtlaIhkuu+ywxY2K1V68eh92OKQ9ig1lqjm
	62BsXzWsZzIhwfvq6Jh88AVHY5JCTciljcIyqK+g2g1i9r4+CiI17jVEFV/ueDsFBTCxssjtBC+lz
	XBbR89oigXcd60ouT8Untf88YkjsKwVFIbR2LBEoYjLt56uIEnaelA/L+5wr2K2MbZM64biCwJspa
	bJS34+JrPN6APhJslKXlJ+8/tBth26JsCw2UMmR67TAUQ8x2nMUIJeWcTxzC+bSL+kSVKmafdPhuP
	wT98fQSA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEz-00000009GNd-2V2g;
	Mon, 19 Feb 2024 06:35:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
Date: Mon, 19 Feb 2024 07:34:48 +0100
Message-Id: <20240219063450.3032254-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a check for files on the RT subvolume and use m_frextents instead
of m_fdblocks to adjust the preallocation size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b1532d..e6abe56d1f1f23 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,6 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_rtbitmap.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -398,6 +399,29 @@ xfs_quota_calc_throttle(
 	}
 }
 
+static int64_t
+xfs_iomap_freesp(
+	struct percpu_counter	*counter,
+	uint64_t		low_space[XFS_LOWSP_MAX],
+	int			*shift)
+{
+	int64_t			freesp;
+
+	freesp = percpu_counter_read_positive(counter);
+	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
+		*shift = 2;
+		if (freesp < low_space[XFS_LOWSP_4_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_3_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_2_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_1_PCNT])
+			(*shift)++;
+	}
+	return freesp;
+}
+
 /*
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows.  Cap the maximum size
@@ -480,18 +504,12 @@ xfs_iomap_prealloc_size(
 	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
 				       alloc_blocks);
 
-	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
-	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
-		shift = 2;
-		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
-			shift++;
-	}
+	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
+		freesp = xfs_rtx_to_rtb(mp, xfs_iomap_freesp(&mp->m_frextents,
+				mp->m_low_rtexts, &shift));
+	else
+		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
+				&shift);
 
 	/*
 	 * Check each quota to cap the prealloc size, provide a shift value to
-- 
2.39.2

