Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F906AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712118924; cv=none; b=tnD1EOjbExWIdSI45eddK8fEbpyBgUds2WFaF0ErD2SpMzU5cjCwsL2QSF0kfwse93dudLOuDHl2zeBh3AMd1Q9N9ksyy1k+np/II8BHiP+sViS6nTtj7jlpAEHVRsifAFWvXfal1KgYdXN4/NSTsPM6Jb2DBetYBuJXpSLzlwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712118924; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijm4T962zzel4Q8I7CZ+sB7PTYtISPD2Lrlntlvtx8hiv1JYTl9CsGOW+hi3/CHurhQk5Zi77AGJqRIAiycMtURgLPgKvLVmmOpKOPuGgfJ3NhHLld4EolpbQYU1FuUkVsGWo/+UVCVf+Kgw8JKQ55GzLXRCgnpWxTeRoqQAGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z1cVKJiI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z1cVKJiI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z1cVKJiI6shI3k989tvT/k5aaS
	a+PwTfkINQ688ccEwdF71MRzOaPQGV6lixjQW0V6+eXiLHT8METfftl0U3d5Vono2fHu+aPvKyJtV
	xHySfuCyuMZYKwBH7MuYnR/ITUVUzPNJaw+p6ZxmErGlHK2rUx14vWWGEmN7Typ3v+dK0/W4qCZkS
	zcy0tPsD0+vmWAd+GzCSTbC1VW0isQYiUCzVfp7B9OdbNHr9cCgEo4AuTlPIhqXq34sOc4y6FSu7A
	mCaBAtyxCatdHtOosp90R43jH2UHsdVBFOX3ZM61BVSkg+pFEIybM65LjpiVlI1tpBewfxmTZLuXI
	0ZrJiR4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsLK-0000000Dy1f-1IsR;
	Wed, 03 Apr 2024 04:35:22 +0000
Date: Tue, 2 Apr 2024 21:35:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: silence sparse warning when checking version
 number
Message-ID: <ZgzcigCpMCPEarGr@infradead.org>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
