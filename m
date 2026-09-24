Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115246C4AF
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244442; cv=none; b=uNv0Qa2GcYfIybXjPHWaRMQ4R3wqpXpuGjGc8OBjE0+yeJQuUaxG0DyYLc4jpzvhwulB4FADd1rXqu+JsnPJcpzMU1ldG0nFa+ioBkeXQPhEHhtBh5K/7qaNqwqhwUyUFOmj+bm0ByQq1aKhHyDOcUE2K3AWfaaZoXLr6KZWH+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244442; c=relaxed/simple;
	bh=e4wxDZVEc0HUua+GzxGC7lQUGZr28YY5IbKiNYy/RV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chh1nhRCda1bC0R/KBDE+bTD6Ot9+vz7z6yvQGZJFNSgXXldLorSjoBoGI3nSw+p0JrOMY7KJohUGKWYFYtYqyZr7YFehdYWPszIIHE3H05Opp29RrNqf1e42bbJ5kfn/G74g2z5bhFCDRCHybSzXvwwqnzuhJZI3gNAJ7vvk64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t66D72xw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t66D72xw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kV2WirN7FIy/v6WXpkS9Mp41LUHXlXAetXhzd88ClCk=; b=t66D72xwxxACvIFS/D4foOh5CC
	N9/qiXjqi40eq55jUahIKWfFITzeMR0lKuw+dayKHOVp5/FguuVBG7LYiqzvyvw5JyBbIn5203Pl1
	pFO2TDy0aQXVJXmHYOiG6YGq/WF6itMTDtStxcNgZ9hbFpdT2Hn39o2JrDc2HQ6pxDrLUGFEajlSR
	GfvROITgS6L6auX2NvN3ByOHR+7Qs64cwWeMRRXNeDoNTz9Njw91TZXWxojBQ0TUlu2mjD4kwfZda
	W+x+mIBsC3HPuUzG6E61Uy+gEe/frUWHxVHnXhxgk0ioLbCgrnOzF77bs7/+ivGQbhnZmdQxbvZR5
	EvhlrjxQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gMC-0000000AfXa-2tRx;
	Thu, 24 Sep 2026 10:07:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 28/32] xfs_io: report checksum information from fs geometry in statfs
Date: Thu, 24 Sep 2026 12:04:18 +0200
Message-ID: <20260924100512.2733748-29-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index e3b3574e0416..c6175298631c 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -286,8 +286,8 @@ statfs_f(
 			printf(_("geom.rgcount = %u\n"), fsgeo.rgcount);
 			printf(_("geom.rtstart = %llu\n"),
 				(unsigned long long)fsgeo.rtstart);
-			printf(_("geom.rtreserved = %llu\n"),
-				(unsigned long long)fsgeo.rtreserved);
+			printf(_("geom.rtcsum_type = %u\n"), fsgeo.rtcsum_type);
+			printf(_("geom.rtcsum_blklog = %u\n"), fsgeo.rtcsum_blklog);
 		}
 	}
 
-- 
2.53.0

