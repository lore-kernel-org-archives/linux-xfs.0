Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04AC8CE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574816; cv=none; b=FMDm1iC2V195V46rVwL5vxiZN0Ame9AV5YwXQMaVwsfXEDBzZRDrf0RPodymwZfoAmNAbdQz2er8zmYLXhxBDQ0NQWJ6BhK1iUvJB0zfrKh0Haadx6y3nT1CtM2SRPXmStLutOdtOlirxdV/HfnyDgcUb+0dtAGpx9i3sHpArik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574816; c=relaxed/simple;
	bh=3WEj87hr4A/JFTHnx6FuDbaUHlLZ56taS7RRyaCQI0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rStHWUQqlAqH0NqeupUoH2Lk112Pjd+ynk/vSMaD6sFgkmrfLtYTW63JFmp825CspoZSrWxe8AnRuXAiXlvr+cqy+xQG/Ka8uPiPZXdtU1Vj1hMu/+6P4vUGTJbIjYh6RbZzZONoShIDk10VvX6nHEl6kZKGVl2IZFPVxj5E4AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HT24LWqs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HT24LWqs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YbySidBqCyAbbdV5hytvGlHGSqAd70AZXYLh6z9OyRE=; b=HT24LWqsbzxX2rJT3hqx7wmupc
	MdoRGvOo9QTMPiGGgN0jWDQo9SLTnoGYB1Awero10kT7lUJqu/RfNfE/bMnHC+c7zooCdrRefLA/I
	FPqdAh3hK+dye6yu9c+QTytHSlV5p1TY9tTitygIY1B2Cn/vlGqkDfGIytGauA4yMSAob618BU7io
	iIJJC/eesw+R2yF18oZ8/DzWn/hSJok/AcB3VC9okVQrMyVX5L5ROVp5ByCZmsHswLTt69VTJYPju
	T3jJsIbRP+f2vPvpJTvA+h+YDkL7rI/B1CQcdMSDHE6iwqKk2TDPbBSLiPIgXA49BXhgvZbr794Aj
	ZboOS/MA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxFG-0000000FQb0-2z66;
	Wed, 28 Jan 2026 04:33:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] mkfs: remove unnecessary return value affectation
Date: Wed, 28 Jan 2026 05:32:57 +0100
Message-ID: <20260128043318.522432-4-hch@lst.de>
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

The function report_zones() in mkfs/xfs_mkfs.c is a void function. So
there is no need to set the variable ret to -EIO before returning if
fstat() fails.

Fixes: 2e5a737a61d3 ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 46f4faf4de5a..b5caa83a799d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2586,10 +2586,8 @@ report_zones(
 		exit(1);
 	}
 
-	if (fstat(fd, &st) < 0) {
-		ret = -EIO;
+	if (fstat(fd, &st) < 0)
 		goto out_close;
-	}
 	if (!S_ISBLK(st.st_mode))
 		goto out_close;
 
-- 
2.47.3

