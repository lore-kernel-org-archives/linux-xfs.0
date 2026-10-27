Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115778;
	b=SVO797lI+Cq4GimxUIEWXhMdFJuKch8DVvyslkfAxCr7DDhMYombFsB8c5oD2IX0Gm4h
	 ud4iEgu9aoo0AbNgfSZ17FvpMzS0NgurRXx14i5i1THCwwjZqghLi03kBDPSuJtbXlZiL
	 1gasYN8C+nfa+OHIsKC6RUayfVAqUT5Xl3hfKAJQo+/3ObpDSQJp/+tCurKmx2CVcMnjT
	 ADCfspUHo5EUUtYsA9mQt5kG/pWruRleK/szlxsZWeaV06hHyT32mzRqM/0bW8Su1TqpJ
	 Cn9ZJwJxoAIQnNnccGBEesufFZm9/yYawztmQzHlsYRkhMW6Ef9INUuFPWKm/L4M/9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115778;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Yw8k0po94PXd6UVJYFR9/HDepqCnUdii4cZY7Iog8vI=;
	b=HyqXmE9Ir4Ool/2NhknIsdTm688qmBgJ81ob3CkaSr7hS+bVCjYxp0G2LAcM0TMTtRCj
	 Zl5vnAwjqPDBFLY9QX6HVRPRW/907FBtmATTwHZfEZSlHIOfYhGI0JPoLqZ1Re7vx3QQZ
	 v2gUzKxVw3vkQGemXzik9SlgIrbRcRyviRHKfpTSSHeequ/9BwXCToD67jtEYjQGJQPNW
	 WFie+/M5SI1vag5EhkYQsHp8ndfYjyGjbYNUvnJtc0/HIY+0q7rTNmB9u/Itllx5z5EOp
	 0+SsKwbLx08KOrWrhi4G4kvEwU9dggZyfISRMg4K616O5cEci86DFXZw55yIHdardgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zTK8PJrE;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155F606A31B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1155F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zTK8PJrE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Yw8k0po94PXd6UVJYFR9/HDepqCnUdii4cZY7Iog8vI=; b=zTK8PJrESjmd1GSDOms4QJv2Fs
	etcdbHjwPeZdmlG3P/U5QjH3qF9A3bo8QO4jGbsuqUJV0cFcTuLlSZP1/GliOshoCkOeL41+IVLoD
	3HxGgxMMIywnRLWdFUogrCQcNvcfI+ahl+g2qPZPEKqit7iGF3BJD6iHefNUDwqq4IsZ2Z9RB1S+R
	QXF6sT1CZtSNOU7O4LLs+ejzAX3A2VF9hQIv1uMGzxkaENB2C/sC2dsgg/48ngS/znVtD3DUDdy8Q
	xTAQcGFCKFY6c9hR0o71zYXpViRQRf0MqYWkqiTpEiLM5M996SdPa/ADeRv71ccEX8cmw+FfWd7r4
	jmJDt4PQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjKD-00000005Fxz-0qzg;
	Tue, 27 Oct 2026 15:42:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] platform: use the iomap_flags argument to xfs_bmbt_to_iomap
Date: Tue, 27 Oct 2026 16:42:20 +0100
Message-ID: <20261027154237.1997484-7-hch@lst.de>
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
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this my gcc is unhappy:

xfs_bmap.c: In function 'xfs_bmapi_convert_one_delalloc':
xfs_bmap.c:4360:33: warning: variable 'flags' set but not used [-Wunused-but-set-variable=]
 4360 |         uint16_t                flags = 0;

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_platform.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 4f4990a20dad..f71b9d702c84 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -51,7 +51,8 @@ extern struct kmem_cache *xfs_trans_cache;
 
 /* fake up iomap, (not) used in xfs_bmap.[ch] */
 #define IOMAP_F_SHARED				0x04
-#define xfs_bmbt_to_iomap(a, b, c, d, e, f)	((void) 0)
+#define xfs_bmbt_to_iomap(ip, iomap, got, mapping_flags, iomap_flags, seq) \
+		((void)iomap_flags)
 
 /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
 struct iomap {
-- 
2.53.0

