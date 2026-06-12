Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156BB3AFAEB
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781242163; cv=none; b=Ffixcmj2w8lzdrTMQQlW9wlNmapjZIKI/e3k8BVAwVTTYCuK8jyvT36dqfFZ2n23wCF4zu+8F3QAGhSfoZN5arPhltN/B7XNBp2TBST7c0KLSeN3/iOPWxbuBhcfJSytefcFJ8FLpzL13fQVQFLiWLVL96uBaevIVvui++Wj12Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781242163; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXqXvTtuLRgZzeIfUvjlqmB5Y9SFI5cT/EjPYAPqjIAHhyq3gYR/P0bpM+oWpkv2jkJ+/znvlt0Q7/VJVe+iaFOVR84rmFTHAIf+mmTLolpaHHEi4EdokgeN1GS2mt7voofrokGdP8h1h+Z+rApB/AIfT6wk16cxzDIJzwFOWNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SnPvdcGI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SnPvdcGI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SnPvdcGIlgryjhAOU03mdf9yeH
	U8GESyDY+JHMou6ScmPE46Hp7g4ilRNErBdIxD02lznapjI8nxnZsmIQm4zXPT1Qrxv0+cK/kB+0l
	cXjsSj/4DZ44nrKSTsSbWql/e9v19VSEXPlB3p5R/7RWcGEVImajtbEqNuzzoMv3+6k1C/prCti6G
	NneC33dhx/V0/ZjRHwhyaYYDQ5TOnDYasSrN26GjqivbmU5bNu6VRWnXMUUUV/FyJdsI6dlIxiupa
	HmFF+syGrPAL/EXx8myb0BHIp5xn5R/6y7/WAcffYcdAQlhUSQsUq4S7t1eR5rWr9l8zB+JfiWzUF
	q1IM+Phg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXuS6-0000000ANPb-42OK;
	Fri, 12 Jun 2026 05:29:11 +0000
Date: Thu, 11 Jun 2026 22:29:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yao Sang <sangyao@kylinos.cn>
Cc: hch@infradead.org, cem@kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: shut down zoned file systems on writeback errors
Message-ID: <aiuZJvgQNb0dtdWL@infradead.org>
References: <20260612024430.253758-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612024430.253758-1-sangyao@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

