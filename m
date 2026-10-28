Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202508;
	b=Yqn2RX3BwzPlQtTLE6R/8JfC7gqbDdXGNzJ08f0y/pGn/tnIvf60aPNC0RnnlwMM4g4G
	 qQn5QPGCuyblKUXeNs8YvHb4/8747FzFUcVkCmA4g8O12wHJa1M/nXj/1hfZoNplwh7QC
	 b7QOasY/w081vPsihs6bAdYpFlBH2fGviQbTJyHe/0Cef2wE8cI5dVtEqwfgiPGQ5TnV2
	 WJO0w/FAFuxoWy0xETHIgCf9wEv36fqqX2Xo+3UADs6ZpdGTiVUgavvayDwoXKlLlG9ez
	 5KahGKR79kACoemZO7GBORl4r+ccJq5xbEWfU0p1xhJ8SOMDj2qPiG7EXTHo8jyBm1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202508;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=JxInwhc57usOykHOILPdLdTJZr9XJ8ANu20RGqz0YNIxTLFzphoMr30nlE7r3f/PNrW1
	 ycDvQ/wSmOCsG9dsfWI1wmvr2WfRQNWXSEMYbiqJ+L+6g8owQEg07jq1q3HgvmAoUCrSP
	 2JXODPcfSMY5dg8tY7+83VADb0bSEb1y5hQE/nzBkvcE5l0GJQ2IS4H1sK/beqJsTwrQ1
	 Fv+ujdGnD/CHcLDv3gU7x4czZLTI25KbXjsDzz18IkxUTjqWLnS7lFKmFgpkSWBo9b7Dr
	 ex68RN4Wnw3AF2uPvQe5FiCGsvjIMqbJ8Oip34oihB04RSFXRpAziBUumhBpFlaHssA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="mJQUy/LO";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B715A606A330
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B715A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mJQUy/LO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mJQUy/LOZNJKasB0EGWEU5sPc/
	wExnsfj3vQ83m/SMdOL9AiTbhvshaCKOjB+ao7vRwV6AxdGIcu3yMZc7WbBOFOpbtKug5cAXm9r11
	f1AamJcUkV4uU1atcborvesz0p2nN53JZKNE7/uvbsNW3EFkSedQeJKklaTNFuYtAN7TtlBwbzuVY
	N6OxJwLa5wZOESBryEAsoT9Ulz1Vqc4GIcEHVuZVJHIv/ryEVOsTby3+e7hNazodaLtgVK1Z0tRDR
	AyJMgXliOAdEpy0YOZaMzPhZ7Vc3kTIycKjGGgWmHQgNOZpjRxzp9/zBv6qeZicy/5LPky7l0qkww
	NtUpDsYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5t5-00000007SZM-0xIb;
	Wed, 28 Oct 2026 15:48:27 +0000
Date: Wed, 28 Oct 2026 08:48:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 1/8] xfs: remove redundant stat checks after
 xfs_btree_insert()
Message-ID: <auIZS13Inq-bxQcL@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-2-sandeen@redhat.com>
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
In-Reply-To: <20261016193422.1630907-2-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

