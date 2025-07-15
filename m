Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E392DA77D
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582743; cv=none; b=HbbjFBHXC8BymzyfVnUNw2xiz5r6NDLZAHjEThz9oh2oSMN790sMP8pKUQWY+/WCDoj6xOSXFBo0w+nTG66MZ56yibRa65b2ZADLPB0HBsY1iAEPDTand4RCXWgo3yVLCiWCgdCqjLSFJWSIzJvcfliYGZ14xudUUAA30yRlUf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582743; c=relaxed/simple;
	bh=9mA7qyo9Uy93TgXB9mI7ctF/8cDafZyllGyht4cSHEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMQZlH4Y2xSilmW7YDtjaZd6BV9CuP2t2BFx9OJbPVVJl7QZbysnrWcDj2A9eCv7cIT66xIvtcAz6gEeuYXB/RbgbU+go5rnKL9FqJsQeIb9/XDdbEJg6TcrxTNFLI2qlzx0BvQdUqkHIKuyi0n3t15hXWW2FA+kykrh3rcsF4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NGUXJbMI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NGUXJbMI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dAiT4ULBwwJoWMnTUD4UyHZEASaGAhDgxteKtIuHL3I=; b=NGUXJbMI8Hg+Q9IFzB1rJgaLli
	VU8KncP7LmU5Pp8c+oC00QdreSS4ZC0kiNG5XFp9pAuaD3qJM0aIGz9oULTQnJwa+77Aj6e/vRPhf
	RkmWsQMwP63QF1qJ1efLRSgf70cq8EZmxUVdhwKN0n/NaNlcow9yHRXGf9GP83+HTaIlq/7rTFCtB
	v2namOHHES9yq34vNJ4nR2LE6wVQHPR0CcNaYXjfzzjfQ71Le5Jba8lWx4CGfzvnx9IXFiPqKVude
	MhA+O9v99pKcxf3zRZotXhkjlyPpg24Uguf5IpPkZiReaysg2hx3egCjPbTXMWXdoDrCqfrb9WR5L
	2xrRzURA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepZ-000000054xZ-1t9a;
	Tue, 15 Jul 2025 12:32:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/18] xfs: improve the iclog space assert in xlog_write_iovec
Date: Tue, 15 Jul 2025 14:30:22 +0200
Message-ID: <20250715123125.1945534-18-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We need enough space for the length we copy into the iclog, not just
some space, so tighten up the check a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 062eefac1a36..48fc17cad60a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1920,7 +1920,7 @@ xlog_write_iovec(
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(xlog_write_space_left(data) > 0);
+	ASSERT(xlog_write_space_left(data) >= buf_len);
 	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(buf_len % sizeof(int32_t) == 0);
 
-- 
2.47.2

