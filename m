Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE3239561
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596256; cv=none; b=C/NWvv8ZGcPwfM2rKWvRLzxdMRo7dZ4f2QL89cWAtWxWQ2kk06W0lYdtowX5Ya4BptMQKHNRtxHlqB1P8mupngERBjJog7gp/zMC8Uw0y0egK4LjQKzfrmpACUcFnPnS6k5FhIsBog8ss/3r9hbxR8oUdHrV+fsHNE9Aoj+RqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596256; c=relaxed/simple;
	bh=bqlio+U8PB1co8MCrHHUMp7ezE58zk7ONot8MDh7RpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCelqDqyz38kfkJG3PuZ5Xv+sfPg5R//P1xfgAaRXMMKoeCZWnY0A/UvqlojkP2HF0FPF6YmQxMgL1U3RgoaVVDEvgd7Zal9Nhd41bv+nq+alHwMG8ly63h1jAd1Fd8rEYf3NdHckpVd6SCsemO2BumqET0aCnaZi1QeGU6m1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SSyRZ8jc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SSyRZ8jc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=moFHOjLZ5uqU0sscRbO7Bzb/tgIt/xXxxcBvlZv4mW4=; b=SSyRZ8jcArWBjfNApRik9xTElx
	rwCB/f4RL+m1MsaLqKdFCc0g1tg/a++sdK5TlFiQ/3e0BNXjT85hjuTkxuJExdtl5coaOv2RjzF4v
	x2C8axDRZ5oDFmpaFRpgmCj23SFSWu3trtXtPDjkCyeRC5vb9AHOADbwuO6eGp1ORcX3yONmE/uV+
	RE5NGz69B5T00YLlri6lcPGXn79zcWmK0gk9C1dVyhFxuzGvr3Li7f9zgAMRIwPTfL3CCLpnGpL6w
	UN0Wjo3PEA04cZoC5IWeuf8hgVY/acXV+0mE+QSiXyMzmQm5wCGEp4k68P+5um1krOw5gA7t4caLI
	WaR90Ztw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb8-000000053wY-1Cqm;
	Wed, 26 Feb 2025 18:57:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/44] xfs: support xrep_require_rtext_inuse on zoned file systems
Date: Wed, 26 Feb 2025 10:57:05 -0800
Message-ID: <20250226185723.518867-34-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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

