Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307A41C280
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116427; cv=none; b=iNOG9dM+n67orGgcBJO83+NEe9KbOLP9rPBLZnjRFCYp+OSxeLnWJSCHqGGBhMkBSCIhJwYvXK7wdz1NHTXYN3822dRzXuTA1jc3b58/DcPJ1X45/UX+N4ViAOOtNdk4HxTmBW8CAdBVbhB87T9Ra13n7W0O4AkqXk5HfICm3CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116427; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRUF3cflQinkvx/GDGcmHjWfch9i+YK4IxtwfYDpGQ9ihsEtwYFw9ClLcnaVrb+tXwqvfcd70teltjv5PsNMighb3Jd09KXsXIM33+YPW0UW9Sg8LY18fgeHaLWcQ1v58NNi9zbyIxojBr+E1tDwq3KfF11s02ahrR0IjwdL8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SSGSajC+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SSGSajC+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SSGSajC+AlJi4MnTSlT/nUOmR+
	nJPjTWoZ6auLwJLjlMf4SN3dg6ssgmS76g6M+Fzanpe2iwWIbST6azLF1550O0xvfDMcpFK57apQN
	mQDZH23DmYsoC4VBAuzPkhNlHa0bcsdonsJq3w4eJ8Sz2tZQF1i1Qf0JdOISryNMhganQoSbEIjTC
	+S8CsVxpU4LYXgPfMMcY5IBPtS/TWNyX9PyZ297i1ZdKVZctCHmGH2/T+2mtw40bvf0hAv5r9FYEp
	pZ+0cY2VUPUaPqbhdJtHiLVkdtPczM32/+5UKTsqTmIDHH3ifvVy/KJMwgRPqYRLQ0Wp+mM0MbXKJ
	WUVVJMzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrrh3-0000000DqvO-2lPW;
	Wed, 03 Apr 2024 03:53:45 +0000
Date: Tue, 2 Apr 2024 20:53:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: fix CIL sparse lock context warnings
Message-ID: <ZgzSyTLlc2sR1qW4@infradead.org>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

