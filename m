Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409824;
	b=YftVizBoqXkN1kQFcs5bkHZpKxtlaXi1ulaS9pfMbEdxW4TgoNcEpnUzOTig2ez1aqAf
	 46G1M43Y3IcQ8OtO69m342a4tBSSPrJQXiSh0iFq2gacsajAuCBLfzUEk3/lkmS2t9gkj
	 oTeMY/az3vGeVPiBmi0vruWoY/rOr0CcTtSLdRUERKLTNWvSw2SMgwZdM7rOCoQ8v7dPL
	 6T1XSSlT39GSaIAkkwgZ+6U1ZnfdWyj7zeVpnUaB1w+7F+1xGhQjWLf9awA8tjKx6m7zb
	 6nj0TEs0Zcy2el4wMkWyrTYdw6FqE8Mc3LWjMYlcKMgMEiDqY/UF8zcA4Rzm95+3+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409824;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=o5/Uhpb1qenYtgzZqftMKGEkIg2Gl5h2hhvvU3iLa+wGaB1fGN9GJBcenMFV5swJO1WZ
	 u+euOkpzzgM//FHv+kiA6zBF55u0XHxoBfIWQD56za1f36O1mMTjZwDriTTE2DKKaA2HR
	 cTDm9eL9FuhoH9BlXxAR7Ykf2XX5oJmphLJZc0Q85yLqlgG0m44b7N7KW4vuzM0uROLaj
	 m665eTg8e8mumsw4PeRa0ryt0AhBQmbEECUJiQoS/YSjoDC62+e9gMQ8oFbpEBXz3Y/NW
	 CJKGFNdZrhfPfzVt3t2DqXVOn8yEr8XmGxcyfwgxjKkm0bJQrYTqxyQYUHxCy0HGpfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=h3+juuQI;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56827606A321
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 15:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56827606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=h3+juuQI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=h3+juuQIbLMDqrkofv1i31zcAz
	KU9XH9Wim3dohW3rUjZSAOjit7aYXN1QkhPwOOzvlAlvV+6b/FGZC3gjP78Q+iieC17EwLrkDslqm
	amfkOySPC4899batUj8u2JvbooJNa85zefCRisTmh7S2QOr5v/gRnEcaLaqhcivqXk5jgX08P1kPQ
	08cQAEkpfxu2JyDbz9rQohs/EhRQBp+WypI0tD8d/71Pt0mB3heAjoi2qJX9a66WiCbBPmlPyScA8
	GNZ2zWxRhM0hnaDDPPF5kMD4FVC8/atZrD+NmwEguCGJE7PqOp0jidfKYDBzudVzr66T3dsOrGXFg
	RstA4rag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR9xv-000000073f7-39gP;
	Wed, 11 Nov 2026 15:10:23 +0000
Date: Wed, 11 Nov 2026 07:10:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove redundant extra assert from xfs_zone_gc_query
Message-ID: <avSFX0xiZCWAEJbY@infradead.org>
References: <20261109102507.262283-1-cem@kernel.org>
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
In-Reply-To: <20261109102507.262283-1-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

