Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8570031A547
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975817; cv=none; b=G3II7/a9QT/g6oCvEU1eXrKnNy8c3KVTxTXdYrnXyLDXriyIbohHiS0fdwTic4tGWNWbIDFjpv9rDTzypI1vVQXqbXzKaqqP3dFHvwE0gOwL/fCFd294Vs8vlwUg2rDWGMU26zNO0OtCfIQ8pQGdbgHMcfBeVwLfeDAozSYtQyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975817; c=relaxed/simple;
	bh=NDVNRxkCNFvYDd//huQurcVcswn3e1jN5CMV8ihZLxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG9yo+L94XMephr63zQSlUCIN8Ba6MuSWxoShFt0x8AvwzXdtqaPIcbrHklmN/oG/XdWa2BHITxYnp8HHrlIwIq0/MszKMtLQVJtVN37qicXwl2CZb1Lu+WbomnxypQu41KJgqnqQoxC7ebttZCos4Cel685Rej0qT8x3jrkrek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AXRCzvEc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AXRCzvEc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZhZKPS7s0zG6VUyt9kWxGXLqhsx4qe/fevc8vW+CVao=; b=AXRCzvEctaSD1fLkYCIe1M7EGc
	tWlE4jXfG38VFVFdpO0ZvBo4ovwCsmNGi4b8oOm1Jq+7AmoS0I7uXG2ldjWFMoVI6fkFnxMYWZpGT
	S9g3HOvzOgA+LI4TDvbOXKCVBaKd+JHwwnFqtO2/KYJY/PS+M3+re33XHP+caJxBhRLUvfZ3rMvi2
	9HnDv+qhk18FoaYdGHzQUvPXcKaQBWfDVJAmmHDvvNutC7UgWSMlPgKM5zoUXgo937HMTKP1XzS2Y
	0FYb9mGQA+hMW5Qmao68XzITUpw6mMLEpY1TuGRcV16V43M3RsJoBuRUup5gPYiGmLM2awYI1Voec
	ATuT0oJg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFGw-00000002cAf-2F6e;
	Fri, 09 Jan 2026 16:23:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] xfs: use blkdev_report_zones_cached()
Date: Fri,  9 Jan 2026 17:22:52 +0100
Message-ID: <20260109162324.2386829-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109162324.2386829-1-hch@lst.de>
References: <20260109162324.2386829-1-hch@lst.de>
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
 include/platform_defs.h | 4 ++++
 libxfs/xfs_zones.c      | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index da966490b0f5..cfdaca642645 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -307,4 +307,8 @@ struct kvec {
 	size_t iov_len;
 };
 
+#ifndef BLK_ZONE_COND_ACTIVE /* added in Linux 6.19 */
+#define BLK_ZONE_COND_ACTIVE	0xff
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 7a81d83f5b3e..99ae05ce7473 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -97,6 +97,7 @@ xfs_zone_validate_seq(
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
 		return xfs_zone_validate_wp(zone, rtg, write_pointer);
 	case BLK_ZONE_COND_FULL:
 		return xfs_zone_validate_full(zone, rtg, write_pointer);
-- 
2.47.3

