Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD3341AA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670465; cv=none; b=HjolXkris34DG1fQ9mVIPJVglWA9bWkbpotsC15qzc8YAHpPC2w5WYLN/+CB4J0JtvW8nrRhawZKRZCI9UowKz1lnVDvHH+64KmUzICoN1iCttq5duREnMg8WdXlMJ1YJJgO/D3MPToLs3m1BEGq5Y6IfPxwUuvOBWI6CMCgocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670465; c=relaxed/simple;
	bh=X1stq9lPTvCA0CzYuPRcbyPZLJlG0j9fHj5xR5a+Rvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqWVVBeNIY/q2mCnO5q95Mfio8wkrxNPNsxR/NspceVuHsBBLQdnb/0zAUpKysRZ6cbYnv5m77C6ZYfErWbBieG3DWDzOd1V/1xo7FYcmI1oWdxker9YiIwrXpbT3f6xSP0fX1YocJJnXVINnYo1t8slYxP8ds8vCtK1r/1OgOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZG6rOC0H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZG6rOC0H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S13+wWfDhJfr+G2DkeYb6rxcFph9IP5QnBlUSpz/skI=; b=ZG6rOC0Hs+MYozAHWlItAbmwfG
	neXq1q9X7BNlf98EbYFbhy290iYbbIMJcPwWlYOp1h7OlFW2KV+DiblNnhxCi8lTbju8nR4BQJuLu
	DwjrMGWPalPTxJm/YeEw6vA5B8NuZlq5+XmXcrZ+cqdf/8/Ghx5dJqEMLfs/6Dp3K1cPKZiyIEgqC
	2I2lF5h0xXqZwQdcix15z2s+9ZZ5VYGWz+TF7JDBoVcBw+fRmP53Pg5lLbp51IX6zDr424GVl74Rp
	FhrWnGWJuazbJcvHPYcoUhb8ZLOOryaJfuD7HnjOnAgjIfoD7NvZeNB2jFIbuFC0YRYbUm7h06EQG
	s3SlPkYA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eR-00000007iMh-0TTZ;
	Wed, 16 Jul 2025 12:54:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
Date: Wed, 16 Jul 2025 14:54:02 +0200
Message-ID: <20250716125413.2148420-3-hch@lst.de>
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

i_used_blocks is a uint32_t, so use the same value for the local variable
caching it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 01315ed75502..867465b5b5fe 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1017,7 +1017,7 @@ xfs_init_zone(
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_zone_info	*zi = mp->m_zone_info;
-	uint64_t		used = rtg_rmap(rtg)->i_used_blocks;
+	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
 	xfs_rgblock_t		write_pointer, highest_rgbno;
 	int			error;
 
-- 
2.47.2

