Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E26A374189
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373661; cv=none; b=Qdy0918efcDS6W+hy2q6W8i38QmqnooNZCTWgWF+SM3+heL5SHA+BuFJM3PZbPnYQ2NEla8XHVtnxJ8NY3AVVNBg51EJFCdGfOi6YtSwZkqV7Y/1wBLv9Zc8je/bb/cxhJruntfra9YRGMmuQHRo4zF8Sp/hTueny47RADu9u/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373661; c=relaxed/simple;
	bh=vv6Za9DYFxkQaBeTE4wPUX+xEc3eEAfTnyqErIBc3QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Joxr/cbBEwllPpEzND12rqgcnznZOBE7D5Fd1CB6eEb3TmFHD1fOeq+Q3fbFORrK3flsoWthGim3Ut+eQDRAIb2mmcMOQS6RSw+li1c4ZRMxhVYtXF2WknhYJzCrIT1OculQF3eTVpympTx7vdM1scaXHzRgoVYmP9vM/o/tdtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5B/qwRh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5B/qwRh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c1WGCzTHn71jQldMkzUGbphgpa0FLyUi7UWPS5pnnCw=; b=q5B/qwRhrDK558PjuPR5fZO+oS
	pwZACwLDJr/iSGggx075a8JP36nSrFf+TiZn8WdBoP37hUzceTDpoR8zX1n9jEtwU2esFWC8NEzEI
	mcNhpGTkumcdPVSCJxJO3YrzF/vyEArbSQl4UjIiDqn8fV2V2f5N/Xa3vc3t2N3bPt9dlzD/RrYU5
	l6bf48lgftHE/zo7XgieyT7tzy7T0E2vLVC7xp/NQ+9ct1sC52+tEQvVTEzOl+HqRKtq+EWDmCuOQ
	SNzh0wyWGvoUUUHWo6U+szX6K+qAvSn8l0PGleod+CTf1jCJFaMgo6glDZNvedOXzZ0ebyHnUhdnD
	INscOlQg==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfulZ-000000089iG-2uiE;
	Wed, 14 Jan 2026 06:54:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: check that used blocks are smaller than the write pointer
Date: Wed, 14 Jan 2026 07:53:28 +0100
Message-ID: <20260114065339.3392929-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114065339.3392929-1-hch@lst.de>
References: <20260114065339.3392929-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 889a681d50b6..5ad9ae368996 100644
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

