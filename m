Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192482;
	b=A3K2yznmzJw3/PFJnKAeaAlK+yFoEVA/kE4Kvu1D2ID8V3uahEDuXt7Y6k5vgglBbUd5
	 7CzNQ6gpvRX04f7/Ct3z9t2ik1gcHfKkDRi+GO8SSRdtV7kfnyLG4sXb5PUSM6Zwh/50g
	 lYKNlqDc4f0DrjCtaviSRHfapSU4Tty7hdc79im1eri/eSo23xIcFT9956InRMe6Sg9vw
	 ibA1N5N5Sl+/kCMebhgHp6M539djtms5olc49l6/+iYFxlpkqdEF7C1kClyLBN6Sf9+JD
	 VIkgSCvioZNqAyVJOSKQUjXiMDwVi42hJVsiPReIriVymJWlAgfp/nPHvpsYbVd5Jag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192482;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=vw2pKbc1Nb9Jnx64P7mF3NS09AK7uF+YPtttHOOuO/M=;
	b=D41PQogjqOElaqxzXEUOlk0veaj3C45k28sS8wPLYbOs9GY/lLZJkBW9h4v6nBpEhtNa
	 Ubt0cqciYha/8tegp5Wg67lsZ5IFC4d71S6t5RZ/rMM0MMLz5EAINC5C2O6y4FyQuuVpq
	 sLHW9edFVqfwxZj/nX4dOWtXDeUad0amjdrMuM0fWFWOUVmuYjE0fdtaII9sslQ5+afZf
	 JKuyHuhoqAjaEAjhOfKItCi86+Nr8XAvtYwTfQaVbQSBkyvLHIPrUmFlZzahYw9Vb3otV
	 MamG9d7vmciV57KRGsKdco3f9WHUuI9/CqrVJLPFRwDZ32wxXJDQD7eCED0v9pie+rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="SyxW/vjo";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8A606A33C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BF8A606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SyxW/vjo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vw2pKbc1Nb9Jnx64P7mF3NS09AK7uF+YPtttHOOuO/M=; b=SyxW/vjoK51hz/KWGIMPuVs6HE
	WAceUqSKGVvxYvMQYPUUuY3fnnbYvh0rCU7ZROMgRycf8NDPozTiEcGakBXxAeRJmL3SG0QY77bJ0
	EjPcNF/EZVeIHYb+G+kKHgHalE9vKE0O6RErt7qkbU5lcn8AAzFFkpuHh3nijHSdpDfrSUq97NWrO
	whb0PdvSHEgvY44Jc54nvqFOQOX/wQKgmGW5ClZAH/gsU1+38ewaFLi8BnttPmPZ+tM0NSkRU2I/w
	Jdc2CuwzJCYmzoWSoFRFOlaDFFVGmJmNETTrmIbprffJgHCRGlmfL8KNofp0G/y7H1JUBt3R0cO8I
	qIc7zQgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURZS-0000000FZJs-0E33;
	Fri, 20 Nov 2026 16:34:42 +0000
Date: Fri, 20 Nov 2026 08:34:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 03/59] xfs: allow an empty rt refcount btree root before
 the rt volume exists
Message-ID: <awB2oiG_Ibik6mFK@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-4-dgc@kernel.org>
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
In-Reply-To: <20261116231707.3625263-4-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good modulo the commit message issue reported before (not going
to mention it for any additional patch).
