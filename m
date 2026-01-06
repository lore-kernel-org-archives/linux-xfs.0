Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4742427CB04
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 08:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767687907; cv=none; b=bmyDDPPNdDGHpf1K82wOljY/ZeyiAjRRLO2iHqIkp2YxE2U6lNI7yuSOJAOiX8cKRpWoSPvHbYIKw4mnA5679Wr8+Jitix/i3FI6hE0bM3F5ii4rlzmN0Tts7ZNtB1wuRtbCi0aswCjVkhRe0RFBPjUB+9Bko4yuOm0L5+vTQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767687907; c=relaxed/simple;
	bh=Bqr5IFkI+pRB0A7FvriBSYsd+wx0yfVZZjEl1w79CZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBdRUCYa88baVV600uWzWCjYqdIIH9XdTDAX2C35dNx4rs1rC4WOp21m5PjpB6XGHIjGQDtfMCjRSLF06aIFVkaeVueSFmha5CA0WHFtbhScoZaBNMQOtKcHy8ZunrM/jp3lRotN8fuMWlRPeOnDTFZJzfPwjilbXequmrao+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U/qQpxOt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U/qQpxOt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bqr5IFkI+pRB0A7FvriBSYsd+wx0yfVZZjEl1w79CZs=; b=U/qQpxOtRt83sxN0Dom2ie1/fd
	6Npk3Hw4hvuIWnEIsxcA9cYK7ghdBWouxIhNsFpJNOC82fnge4E4CC27cCd1CNoNxnlbcQIbs025+
	/WwGrLXAMzqqAJx+dVzRapWDEY1SkcJed9UCUxP7MPArcrHAPm1+rF6qXpwufgCcnnooT1fI90JLC
	ioZ3BsG1KJ9A5cHzwNUeXDRVN/CayEoB/6SRRqfdu7rFwLNybpdLPBKtnOPZIp5YQ8+HRGfdorgQe
	RzNit21XC57MNXkt8ZJfJ3519/JeXIHlG2lNq/xJQuQgvZOWUS8wS5i5NrEGJZIyyGHRUyUJXe+EH
	BqkX2QTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd2NF-0000000CbtC-3Fot;
	Tue, 06 Jan 2026 08:25:05 +0000
Date: Tue, 6 Jan 2026 00:25:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: add power-of-two check for allocsize mount
 option
Message-ID: <aVzG4X2bLxSSegI6@infradead.org>
References: <20251225144138.150882-1-dmantipov@yandex.ru>
 <20251225144138.150882-2-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225144138.150882-2-dmantipov@yandex.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 25, 2025 at 05:41:38PM +0300, Dmitry Antipov wrote:
> Since the value of 'allocsize' mount option is expected
> to be a power-of-two, adjust 'xfs_fs_parse_param()' to
> add extra 'is_power_of_2()' check to catch bogus values
> may be accidentally passed via mount.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

