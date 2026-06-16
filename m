Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F03CF1EC;
	Tue, 16 Jun 2026 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587251; cv=none; b=NZB7sFJiKbCpOwsjARunXnv/yj7qbeLBfA/aZmcORwwhBVtqBHo6clUypFqQdo2b2B/ie1TPHNopJsrxsSMytm4CgtkaDmbXYp0rb+vO1A/uRAw1ShWrfzktGDkp3FpQeb+wilOOQrte8SNlnLNR5bg18ZnbKWSg09fPJvTwrYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587251; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJ/pdw4vu6oyS3/S5aMlyRBPWQ/nueWuMwxMCcjtIHkXXVAZvI57jDfRM4UVsygOMagv6aIgzqE2X6OOOPyWgBbFRboK/TiDGt1/3tqoBOGw9RZJBq9ST5FN7QLeOBRqW+h/I/acgbEg9BJfk83LCQH74DioWwTDAewhIrlj/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UCzPBOMz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UCzPBOMz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UCzPBOMzd8TJ1MwwOFMSJQE8N2
	axVj+b3Ka8OTD8ERG57C4kaN+XVeh8Jw4fkwLQOC+wn1zycfDc2OSTuHM5JGC9XA9Slb/8AeZa82G
	mfHWYLAvAVAzhRQfZtHO+DEcI9DFcn7KnVFcPwawvfnFoG8RpFqIHXkIgcwNnzu4Z/a6byzKhVRvZ
	laOy4nZWcEmB29XJVlI5Nr7rlJcNMB+I4nE5eGWCPuV6zYdZoK76EOLSUPJagJ6tS/4BovnpT1Qhw
	b0XasvNxCDjP0X5uOG2YJ2NOYBjoKy163tMRYesBdxkkGKN7hrrtQGggATMr2LBIcdVWTL46n1Vxo
	Uv3JVRAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZMEE-0000000FF6g-0s1z;
	Tue, 16 Jun 2026 05:20:50 +0000
Date: Mon, 15 Jun 2026 22:20:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Message-ID: <ajDdMgZAQX6eQoMI@infradead.org>
References: <20260616033821.2238-1-aditya.ansh182@gmail.com>
 <20260616033821.2238-2-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616033821.2238-2-aditya.ansh182@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

