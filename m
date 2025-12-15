Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A833BBA0
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808941; cv=none; b=S29/esNqRS+lVtNOnc7ULR7GTrp7CrZiNvyhagHNAEC6gMKau85jmhyTqOslGu9L4aj0x/dEwcm6PWylD/WgZGC6fDB7bC6c/9m5TxyPV9jsosXr9Qyek6BkCH6y4TgUFsh+1pL5/C/MNGk0MniXwz61wIJsGTe0u8MCulVShAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808941; c=relaxed/simple;
	bh=DZMyhuMNMojnLiRo6aagQpUNvLk/yXtHVHCiT5tCfRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y21xElXDpw5rEIvYREy2ocr72udWrssKZC0ev+AZUHNLCBrxWc/R4eoulorH9Fj8sXJhPcncaxNJJDzWDCwxmx144lgEzxRtrfom+FnUU5RYC81y8Xe6/ncVYM3/CDuT01CTFvHF9GplO1tw7a5YQtvCZaJfa8G3Lxq+DDjVWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LfJlngPv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LfJlngPv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DZMyhuMNMojnLiRo6aagQpUNvLk/yXtHVHCiT5tCfRU=; b=LfJlngPv8Y0rvZPlqRMeHdjcVv
	0+/DKqqv4obVhL2/2QrKxAUjfJ3Qm7e038llO9f6NpjfNmsf38peqqcfdSPg+2xPkxACgGIDUB5RL
	v8v5e/ylfxwrhQ0ahzcgW79usMI2fT+uiiAS94dlOlRVkYuiq+1VMkpVyCQpYdIyFCCj6i0WTdMv7
	RtxZ9lVtcczHKNd7db5jJqeK1hza/7s/fxz/OUwwz5Iz1iDD6Pu2MzWo6H3pYrS6sOGKDcovHSv4j
	c4q3/ilyGWzFvWkiNofRu9L9Pf82EtrKOF8QiXUflM3ygzaDn4IrTRFJADqSGlbNoVvMXaBDablql
	yz0bWYGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV9ZJ-00000003nYe-1QJG;
	Mon, 15 Dec 2025 14:28:57 +0000
Date: Mon, 15 Dec 2025 06:28:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aUAbKbZpTafVisac@infradead.org>
References: <aRdco1GtU5BK2z6C@infradead.org>
 <20251215114811.40090-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215114811.40090-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 15, 2025 at 12:48:12PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.

Oh, I thought this got merged already.

Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

