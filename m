Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884641F416F
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866420; cv=none; b=AS2cSoYuggBHI+HZzoKfli9wbT6tgMJMlbOiMCCUTs6LnICCuiGLVIOxL3qMQiD19S0udHfUEuD25blPUp9fcstS2IH164d275CANBI+LvGfoLPBzrQ8JZdxdNDgkGmbIfoB+sdV2KryOWckHg7T5MsM29kHbTbzzaz11IJZ6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866420; c=relaxed/simple;
	bh=bqlio+U8PB1co8MCrHHUMp7ezE58zk7ONot8MDh7RpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJBywWBjJ9++TkGjeZzwGxUCOCKMlop1OPPSiTJ6kLOR/i62ZmfrrIa2/XM0CIWp35y4l3PB9gbpMKKGJ9oj8zl0sKKjDXeCwSmOdjUFOXczBB74yXL70NK6DRN512hAWRedI27nx8pf1PXVk7puO8bowflczT4bMq/PdQp0+xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fYvEwggC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fYvEwggC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=moFHOjLZ5uqU0sscRbO7Bzb/tgIt/xXxxcBvlZv4mW4=; b=fYvEwggChrtPpOx5Rqi8cl+L0j
	hO46Q5ns5/xR5aCuQxC5/aiykjyB32rjtQZRaoISnTWOzsRwoGqHcsd/XEaHALfMGXEVkBLWEWTBf
	65OUAFxX1yacF2CTHGDNr0TytdUAhIl5U3zwSLT7FRnhdy6s55osKsWVLyyrQF8jGiX6RT8sEFlux
	gvThak7B3kK2F62nzrHnYL5mi0YDZtpbYOuf/eyMPbhuP2o3Ot9gshZhuRnIwZNum0lGvqG2CAmTe
	PzU4j4eC5ICSq3jr0PbOGUnD/epYU80nHmPU2NcqhF+aktGUQKErs7XIFYGSDHfP21bPvae24c+pK
	5jEpWIhA==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIja-00000007CkJ-2Oay;
	Tue, 18 Feb 2025 08:13:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 34/45] xfs: support xrep_require_rtext_inuse on zoned file systems
Date: Tue, 18 Feb 2025 09:10:37 +0100
Message-ID: <20250218081153.3889537-35-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Space usage is tracked by the rmap, which already is separately
cross-referenced.  But on top of that we have the write pointer and can
do a basic sanity check here that the block is not beyond the write
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2705c3cba0d..f8f9ed30f56b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -43,6 +43,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_zone_alloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1050,7 +1051,13 @@ xrep_require_rtext_inuse(
 	xfs_rtxnum_t		startrtx;
 	xfs_rtxnum_t		endrtx;
 	bool			is_free = false;
-	int			error;
+	int			error = 0;
+
+	if (xfs_has_zoned(mp)) {
+		if (!xfs_zone_rgbno_is_valid(sc->sr.rtg, rgbno + len - 1))
+			return -EFSCORRUPTED;
+		return 0;
+	}
 
 	startrtx = xfs_rgbno_to_rtx(mp, rgbno);
 	endrtx = xfs_rgbno_to_rtx(mp, rgbno + len - 1);
-- 
2.45.2

