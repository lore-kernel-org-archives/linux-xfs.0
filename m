Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617913;
	b=m/EkXQbJen7eie4C0z40y0inxjpKmeAjS8n6aTyfAOpmUMJ+BTEuFQ8TanOtkaZz6iRE
	 83BAhA+cTtrMvijXaVLgYUwAGKhKOfqo3Uo3wEYtYv3PXf5rSHt0xRcieUBKmhR4fcoZN
	 OZp5zLeJceha3NxP9yzpHwSOoaavFIXgblMKZUujVZRSGF9COW+oRDprV8ai0Zc5aBEIj
	 YSz5DiMqrjvtt4BxV/jtkrS5M4pEHTXCUmfeLdoJUDTcC5QcXaEVJgWEKNGwj/tA6NFE+
	 iNdSuowFxLaWRKPOsK65RODfNi5pvppo0aEwdU5xKkFy6rrW5goPNVlut5/woLU2Mmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617913;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=b+8PoCx6750SYkQ6rPUdXsg+V4/dSNGDRz2TDFhz24U=;
	b=E3H+2TpndRovoQ9RMH4Bbo/f3i9cSIJACAnrK/kASNYIU1L5xehonzLmAS6lKk9TxcQL
	 J8wKO4kUKV40PRxKlp2OuVQAYhQltCrhkvrMvgyaV9+O3YMQpX3qD9kxhIBqUtWvHkLT4
	 Pl0YaPgSoubV0AVzRw0O3enDZlOu3RHdsD4avYGmn0xMhPqE/UnWvOI9gNuCpuhkQLFW2
	 2BcbuxJt5SKO2XejfUI0BkQ/Qny9gSiQWZEw91MOMTTH6PaGpl64wHMqGcBXZH3h7AeDL
	 6NWYv7pDvQDoe6oKMopTtETI8Wkr5qtkwOrTXjLt149DjRzz81MgRuI7mBVAUbstykw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QAoltJWg;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23245606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23245606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QAoltJWg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b+8PoCx6750SYkQ6rPUdXsg+V4/dSNGDRz2TDFhz24U=; b=QAoltJWg3twS2Sbl1zwbzGUimo
	rcNZCkmxZC+j+XHQEFgzYV4yMq13MdiQtwYEkaRzmaT3j0MFPStH1Z/I3AqG3csKKgqWvJwE2H8F1
	RrR6Y2SDInB/d+cUkvjBCFNzAcBdm9VvnuW1ESIvHzTuwFJdTPJrRFideLXI0jsHSEPgd1cdW7nZW
	FtqWmelpahx8db8rNCyQt+zE3t9RyASsgY2m2kN0I5hG9OG7/n6XkEi8v/a8ZGKorVfw+pxMScya8
	vjUdOF8gzylaLthJg/Adcui/u3aW8fniLFmjezuVfZ82OyCcQhSpJmXhLpdbyCPMcXNIJlHuomiCO
	Q4zrxy6g==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEFE-0000000ADuN-1Ydm;
	Wed, 25 Nov 2026 14:45:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: make the i_len field in xfs_log_iovec an uint32_t
Date: Wed, 25 Nov 2026 15:42:31 +0100
Message-ID: <20261125144430.728485-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
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

The log region length has to be unsigned, so use an explicit type for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 529720a4984b..4ad66603b7a2 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -15,7 +15,7 @@ struct xfs_mount;
 
 struct xfs_log_iovec {
 	void			*i_addr;/* beginning address of region */
-	int			i_len;	/* length in bytes of region */
+	uint32_t		i_len;	/* length in bytes of region */
 	uint			i_type;	/* type of region */
 };
 
-- 
2.53.0

