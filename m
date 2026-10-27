Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115770;
	b=FMCWV1aAqm09lpDyr34CObLab82puh4gpwK8WeChNjUgn1N/kgnZzRGruwGIuVtUpZv3
	 iCZGTUZhSvhbAurNBXm2SPbE43uUW/Yi4or61QVl4HAs9HHiG12lCpAkMtdxPgiJ792Ht
	 i14M/YPtf7SEMCP50YKIJtGtW/Ib+VB5RNipY8y3uq2umti4++7hOPLbnKfgGWMxNPilV
	 P9/+tS0hwRGRUGrjJ2Da/bly+Qz4NX1l749EXx6+zSa2XfaaoTuEj9B0ilq6R6aDja/aQ
	 t/OqP0Y2i8uE8wkCjPiM95Fc6PSyPdYD7jNEYRpi9TgidBtJVOAE9yhrblWaLt1Y9pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115770;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Gesbq8HNePl0d9HQi5A5z18d4BamVkoOK2NevS+iIuI=;
	b=KBXr4ChFhFFTjT+i7cC1nQURa9DmJsE5FyEOLEpzcRsLkO2pvZvdRgbOudJf7GgcSu1M
	 V9kL/lKdTb8EwP+oDJBfB6IXvtzKLVMNnWQzBlmoxfD5Ldd4aqPV5ymSDAXpCCR8jjaeY
	 hxDxNzi5oqWDVcVzwBagKU/tTOgd988NZH4a8iwmSmbJzirFlfyR//2Es7iw1pBZPx85q
	 Pq+iPKib96ev+IgQqAtV/3FjyXJHtnsnpPQ/IrbXZAVL+uUSmXbWT9A3w0K1Z9GTWYaSG
	 +J4hb1C6hR2WNPcdzysLp6aVI+W4hVCVhM6h2oRYAsUUnQBd2b+RGBhCgrhQVVGWkXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vREPHGpA;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF48B606A31D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF48B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vREPHGpA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=Gesbq8HNePl0d9HQi5A5z18d4BamVkoOK2NevS+iIuI=; b=vREPHGpAFrp4UDlHuyucXxlIkn
	HG98USRFJnobXKPfV9ThAtklcF2wXTBdKPV+8VnrdpngqMUmZY/2OkCkaePIdBAJTi4mmnmEI4mY+
	YHyFx8QVBY/AqTuytSduxWGorxCKsGsOtsCJxGUHyOIyL1NzlgORTV25FpThaP66TjVapjQG7XVyD
	YuKUYUFetjvMMOi10bgffUjjs10bYNpvc0fwDySeRxb959jadPAB2mGLgJSSU8m9pXvmVNK/6xzaL
	zHpuMZrXEOex0a/LuLzF6dXGLfxQpd59dHQWf7M6xHpesdUac9SFDV+kHw5LYyW+ztxQczvR9wTTv
	uljYkBbg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjK5-00000005Fvy-0OhF;
	Tue, 27 Oct 2026 15:42:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] db: constify construct_records_per_block
Date: Tue, 27 Oct 2026 16:42:17 +0100
Message-ID: <20261027154237.1997484-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>
References: <20261027154237.1997484-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this Debian's gcc 16.2.0-3 is unhappy:

btheight.c: In function ‘construct_records_per_block’:
btheight.c:158:11: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  158 |         p = strchr(tag, ':');
      |           ^

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/btheight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/btheight.c b/db/btheight.c
index 14081c969a92..a1e8ee6f183a 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -144,7 +144,7 @@ construct_records_per_block(
 	char		*toktag;
 	struct btmap	*m;
 	unsigned int	record_size, key_size, ptr_size;
-	char		*p;
+	const char	*p;
 	int		i, ret;
 
 	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++) {
-- 
2.53.0

