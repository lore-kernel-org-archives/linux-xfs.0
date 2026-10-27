Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115781;
	b=4t4OkMuQdgIICTqWqUq77BUxJ5ExTnz0YEmtNAtBlbLia/SDaNlv+0tmkpq5K5uQYJZI
	 jL54QW3YpE4qjg77PyAtEUvGDMMFFv0k/9L/mfWj887MGd/kEP7iS6hj/agz2GZ0i/NfZ
	 JL6iGtaD7g9FH1LU1JQGhMNGwlvBvFTH8FEk3BmJKhn497pvCJ2w5RWgBEhybimsBT7FE
	 cYWdeOPvLRn9E5/svWrhDncRinvUM/9BsFx0ekh8Gf/XieT3O2RLc1dVSJi+jTRNRP+75
	 YYepshLKalbsquXN76I5sX88WH8GSh7YSdpUaUlEnSglasjyJU47yt/KjpgPrfvI3+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115781;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=HnKK9wDgLx1SJm7ExSSvnXpl54NqbVBXYqp8TSLwWGM=;
	b=ZdVpyt1xjhg4mnrqQckraAk48ZDjfdP2DYDyf9rTQ1db9NEx3EDmEmTadWlnBV7j8GW5
	 4jzmqKovJD8c3pSKtM5QTu/V8RdTJ6zbbT5gCBEZV5h1y1m9+WJfZNfpX3gEMWQFtQjT0
	 o8Gevla6Y3zWDnzHclmwzYOCBvMyvfKdlYcp2RZZOk+wD7/aTtrzG3rx+ac9kG62UVNlo
	 R7fzT/eJgtXpZRdjANSSEXNY1zoIaBdK1CbEvh6ylbATLyebQSP3nxOvaYGA+gTGk7AMV
	 qFnaoNZiWctdJ2NWSkg+jVyGJaoTNSqUVghMJt5ai/9t9Y2RwBQDbE+4sijyc+2NKYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dB2Njvjk;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07916606A31B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07916606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dB2Njvjk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HnKK9wDgLx1SJm7ExSSvnXpl54NqbVBXYqp8TSLwWGM=; b=dB2NjvjkIPAJMz9ICXqotciWav
	bSNSwhBOZf5WtWWZneXtQCSoXOMQ1Wq+EdmbcQinZSEGGyjYFYLg6p4ziAZ6+dRFllQub38TT20/c
	sHpGaMAyOkOUCRde50lCK9ikcVQ9WBSHQs83G3GI+EObd2vGw9/QH5l8pIXSYr3QXBwh10VhlOAwc
	YkDABiKXNYwpxRNZxHDG6yJdIoE5/3MqyMMNKFftR9CuKIZvyGaj1r5+z7O8/uhR4VFuMEV7qyqBT
	hX+/qcnXla2ildux0g2CjxBE3ve3/lyvfb/0HwPJu5z9YD072BQona09SUo2iEcXcmHbRg++UMzr7
	DwV9tPFQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjKG-00000005FyB-0wOT;
	Tue, 27 Oct 2026 15:43:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] stubs: use more arguments to xfs_extent_busy_insert
Date: Tue, 27 Oct 2026 16:42:21 +0100
Message-ID: <20261027154237.1997484-8-hch@lst.de>
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

Also use the flags argument, and switch to the simpler (void) shutup
method for xg to make my gcc happy:

xfs_alloc.c: In function '__xfs_free_extent':
xfs_alloc.c:4017:41: warning: variable 'busy_flags' set but not used [-Wunused-but-set-variable=]
 4017 |         unsigned int                    busy_flags = 0;

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/stubs/xfs_extent_busy.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/stubs/xfs_extent_busy.h b/libxfs/stubs/xfs_extent_busy.h
index 4fbebabca124..e7d1bcdb2fab 100644
--- a/libxfs/stubs/xfs_extent_busy.h
+++ b/libxfs/stubs/xfs_extent_busy.h
@@ -7,8 +7,8 @@
 #define xfs_extent_busy_reuse(...)			((void) 0)
 /* avoid unused variable warning */
 #define xfs_extent_busy_insert(tp,xg,bno,len,flags)({ 	\
-	struct xfs_group *__foo = xg;			\
-	__foo = __foo; /* no set-but-unused warning */	\
+	(void)xg; /* no set-but-unused warning */	\
+	(void)flags;					\
 })
 #define xfs_extent_busy_trim(group,minlen,maxlen,bno,len,busy_gen) 	({	\
 	unsigned __foo = *(busy_gen);				\
-- 
2.53.0

