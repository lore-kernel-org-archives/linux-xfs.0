Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808829;
	b=tGOk+TziqvH/TnTDysyQQz3TgG3TvZGnV5XC00/tawN0r3fdGUkVv9k9HPqcMc9owyDt
	 mrQ3BMkdwalEYAKfOx0iVLtVSm8jfrrGmXWxwyXeO2hORKDLSZKIHvXPunEbrhyoBA3f9
	 TbQGKOtBFsk8/qZf2vZjyVlcx6YaVljnSbyRWkxrACG9fzbt78dDS6C+X127FFNP2f7pC
	 uXa/ZwPHiSz//XZrozu9Yz35Zv8x5kfVfdN2Gmzq0Kkb47HkJ8EpqUR0RbvkCnFTlWEtT
	 7uiALufWs8+DnXjFzlwRFhNaBZRbfcAFAnAG3jPZnEqWPaYXAoD3Orcx2TFMixaarXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808829;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=bQogJBxWP4mB9vv1+c0AlK7wb5V6ta4Gux4IVQKkgmWvYc08+On+8rWQHpp/wsC4tRef
	 pBqk/OgqTL+ljvHYcxi3qtWlHL4hKOS9hhnvk1i4Bp0y1qOWXaEa7TSY5AUHPheger/SA
	 ey9NuBfpAglAy0SPKZ6NzYyV8wxkHNuJuQ0s1mVu0YbyoZ+E04/zjKzAswDJ7lkPsVOn4
	 qQItiJT2CX20UjLOqXa8UIfTUvLsBjRRj5l4OaKcXbq8KK2u7csflSgOz6qqs/9Ft3Dqa
	 jeyb29FLNsyA6r2dq33ZK1Pkx2e+JMPy4szN4YHto9oe5ujGMkn2cnTIcvhf+kTBf/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=BETyc5Ce;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE5606A31C;
	Mon, 16 Nov 2026 06:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EAE5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=BETyc5Ce
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BETyc5CezpSz93ywpd5Oa/Ramb
	qvUp00CGC1Izty3Y5Sb9bXZxOSu61v2WYaXEYPPlx6JPvia2s9vhEUbOIm7F+R5/DXut0b1W3f1OH
	Ii7RQJkvzkBaCwxCHuroq2pOBO9vNWeGtPQnnDMB5UIrGo6xGYSva5pwCs2DFTCaC2RRdixildhe7
	pMDF1Ssd+KSkxxEHpMpxTph4889EDDtyCoOae5v3l8ofTcPgzmRIzGaPeNvRzx/psWLAiw1KMafzQ
	H4zGy34fDIUlgWVH1E9H2EbQvM6emq4cQR4ZOhZjNz5MSb8ze8bwm+cahYTKe/QDSZkmsFxN7bVIN
	+KRKka/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSplS-00000001CKG-0wu9;
	Mon, 16 Nov 2026 06:00:26 +0000
Date: Sun, 15 Nov 2026 22:00:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unused variable in
 xchk_stats_estimate_bufsize()
Message-ID: <avqb-lzKIz98IZJg@infradead.org>
References: <20261116014802.16078-1-wuyiqing@cmss.chinamobile.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116014802.16078-1-wuyiqing@cmss.chinamobile.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

