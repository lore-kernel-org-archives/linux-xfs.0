Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F122F50BD
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670481; cv=none; b=Y53ldvD3ol/ZUVrMia4HRWAU7WPvqzLoiLC3TbXbC44BcH/fxiR696PmBFol0rM6SN5oLHMSRJicSmXQZXtQ/ywL5e6IeaiU4TUGHgUYGPmPe5uAopRrpK8W78hm8PdoJ+wsoL6lYgRHj2eX3FlrUqmM8ONUmAcbkJhU8uFggF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670481; c=relaxed/simple;
	bh=/AswMgYGwAW0+2Ln4GsmY4Z222Q1Tsvbn8zgJY2jQ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O33Pyn+tOuBBr4G9U6FKQiu8J+JgG9T0Mv5YUfMfwbDbJ9wTJsSpDUBig1aTbzU9V7a6FoOdJwKAyrK/IsUk0qReqMfZENwK64P8bn6XI82IUynV8oTWFqKGF42GjzIzgz7krvYGqaebXrKeGGuKGsix/AawPVdmH9HgWMxg0tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=apEMfTdC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="apEMfTdC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gBQZL7pJoX+a+9fsB49+3Y6g1dnabHmlTShdpJFcNig=; b=apEMfTdCEw9AhWcJMEDtDWe4gW
	fnKU7EPFR9m4p8e+yxJQF7rMFMz43zv1zXWJxTjH1Vsol/CO5xaQIQMtT78pchpnE9U0v5QQJ/LSw
	14LAWxgXpG90+anWLrTGy/Eha6I8acz/ZPczY9yolUj0pcvksNpGO3jH0Kl4PPQDZzSNW6HNPGmDq
	GB3/B+p8rXgMJzjiZP0cdJb8SbtJZGy4I/XELnxmMBjuwEwCrk5ASBeN7hAXhMKuYhP5j9H4pqOn3
	4ruDRIS5UWej/Ahx2d1wyYhepNFch4CqUTSU9lzkYyXAd7cP4a2DudDufVSYZaU61WwT6ohbmTcWv
	0d4J8KeA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eh-00000007iPM-1Me7;
	Wed, 16 Jul 2025 12:54:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: improve the comments in xfs_max_open_zones
Date: Wed, 16 Jul 2025 14:54:06 +0200
Message-ID: <20250716125413.2148420-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Describe the rationale for the decisions a bit better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index d9e2b1411434..c1f053f4a82a 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1114,24 +1114,27 @@ xfs_get_zone_info_cb(
 }
 
 /*
- * Calculate the max open zone limit based on the of number of
- * backing zones available
+ * Calculate the max open zone limit based on the of number of backing zones
+ * available.
  */
 static inline uint32_t
 xfs_max_open_zones(
 	struct xfs_mount	*mp)
 {
 	unsigned int		max_open, max_open_data_zones;
+
 	/*
-	 * We need two zones for every open data zone,
-	 * one in reserve as we don't reclaim open zones. One data zone
-	 * and its spare is included in XFS_MIN_ZONES.
+	 * We need two zones for every open data zone, one in reserve as we
+	 * don't reclaim open zones.  One data zone and its spare is included
+	 * in XFS_MIN_ZONES to support at least one user data writer.
 	 */
 	max_open_data_zones = (mp->m_sb.sb_rgcount - XFS_MIN_ZONES) / 2 + 1;
 	max_open = max_open_data_zones + XFS_OPEN_GC_ZONES;
 
 	/*
-	 * Cap the max open limit to 1/4 of available space
+	 * Cap the max open limit to 1/4 of available space.  Without this we'd
+	 * run out of easy reclaim targets too quickly and storage devices don't
+	 * handle huge numbers of concurrent write streams overly well.
 	 */
 	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);
 }
-- 
2.47.2

