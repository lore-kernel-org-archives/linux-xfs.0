Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7100836826C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979320; cv=none; b=HSES5DswKSZ3IO3B7/5iXgga/E5NDMchGsqQ6QWkXwv7EhtXKD8SgaryUZPfUeOHeMPLg6Bms3UQ2rIbEwoQkUNrtr9ZyAX96p+59eH0KxTnqaTNHHbVUleOuDW9axXyY89QI+wpO0Sqy54dnRydna0vQw8aJZM9at7Q7ieVisM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979320; c=relaxed/simple;
	bh=j1p2WtIXreXHdcDQBmhhUpDD0kWc9KoQlathQtah3lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTpIeVWDHf6xLJiAoB1weCJCfXEqgcGOG7GIIB9rgCRY/ndpA5OcNN12Dgy78nopWypllFMqov7wCopLhZbyNmrdxrcAlYzkIj6nZ4jIlP7ILVjrSQq97acyMpQvhCeRmHmsxMZ6VieGpZbR4IAGZVI4rLO5ZApkbE10YdTsedE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WMqafKvE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WMqafKvE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QLwGr4RNKVb/I4BRO1xxxNYIuvY57ZnbF33lxJrYzG0=; b=WMqafKvEmrQlfBH9sy4hHeTBBS
	rrLHd33Z2ib/tz6TyrsCn4vUzm+vL2TtgQhd4qG7dS3X8kN5FgCfzvta/ENDswK4hYX2yzBmm3Z2V
	EE6oI5XW2I3ucS7FMU/7So8H/J6HADJBHRBkiLa5fiOKqIWXndmIXr4LpfGa2dD5ZPHF1pcOiSeuL
	DWGBav7U+QmmIaN9Rk+5bKi2AYsObTiDUREv5qLje70AQUDm/qbfaPcwUwK2ALq7vJ/ATgUgYEKTa
	0eD1TmVx9ilxq4cqNAcf9UAAsSQ9YD3C66+dRJz4J0G13fOGAy40bZ2fW1t+HdcyxXElG+FH3FY6W
	Ca/yeDbg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBR-00000002nYp-0cbY;
	Fri, 09 Jan 2026 17:21:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: check that used blocks are smaller than the write pointer
Date: Fri,  9 Jan 2026 18:20:50 +0100
Message-ID: <20260109172139.2410399-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109172139.2410399-1-hch@lst.de>
References: <20260109172139.2410399-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Any used block must have been written, this reject used blocks > write
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index d8df219fd3b4..00260f70242f 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1033,6 +1033,13 @@ xfs_init_zone(
 		return -EFSCORRUPTED;
 	}
 
+	if (used > write_pointer) {
+		xfs_warn(mp,
+"zone %u has used counter (0x%x) larger than write pointer (0x%x).",
+			 rtg_rgno(rtg), used, write_pointer);
+		return -EFSCORRUPTED;
+	}
+
 	if (write_pointer == 0 && used != 0) {
 		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
 			rtg_rgno(rtg), used);
-- 
2.47.3

