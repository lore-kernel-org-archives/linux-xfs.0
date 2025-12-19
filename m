Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ED3218AAB
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122732; cv=none; b=AoWVEMaGIvNwgibEIb9X56TMlQe1ldXho45IPpLzMo+aFglZAyxMEi47RXmTVCcBBQjILvDhUS4bSvN7ZQyy7J+uteYhsnJ/QoNsOf/7+aV1zEB8yYX6Lb0wOWsKHaG0TJvty4V3uGW/vowHpD7OYJsourWwwaJ81TR6K7DbMCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122732; c=relaxed/simple;
	bh=ZkJaAGPAcXN+vfEA4ReKug0BhBuGkljFeq6c3Pkuuec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmK+ftp/hTBecL2uH0yji2o11U3Ejzd5OKmRyy+D4fUFWSiIXQxMS3VwRXvlwM9uajCDbEfTs4MNH4OPMgQutq3ItqeDnMtzStBup3Lz95AQPomKEyW2+8p2QbMz9AOkVWdqkSsnmHT7P3ikIr0VpBF9bBL4wHDuUG9Knep/xLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bc6aB9oC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bc6aB9oC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w2CanY0PsD9ZHztiP23VySqunCLVFRvFi2z1orovfck=; b=Bc6aB9oCRvSj9d1JY8bvk51FRX
	AXm0URQWlSnQRd+z9th5G5SL0aYG2dxyxSMFdme4Gon1myBVEJ1i6Z5lHT2zd84a/QJStR5XQmzOX
	4YDSrMtRq/HxNzYKAVhe2urMgEWQS8yVbV6gkydyHCqkfG6JECWXahZCJ1rI5Tol+xX1dGCjBzXDD
	KzLNy8JA48LNhAyPbf3XLX5WQsyT0/Mey+9G0OTh/mm6+Q7MHizV2sdhyV5PpUOQnF/dwna1ribNt
	z2JHXDYSaAD8MIjHprwHlMwsQKr36OgYv7wEnn8uwtfg/lKBsRy/qKFiL7BfQQmZ6NjgklTnt2165
	mBXYDdsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTCR-00000009f9v-3piU;
	Fri, 19 Dec 2025 05:38:47 +0000
Date: Thu, 18 Dec 2025 21:38:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: mark data structures corrupt on EIO and ENODATA
Message-ID: <aUTk55PRcaX3uwuT@infradead.org>
References: <20251219024050.GE7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219024050.GE7725@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 18, 2025 at 06:40:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I learned a few things this year: first, blk_status_to_errno can return
> ENODATA for critical media errors; and second, the scrub code doesn't
> mark data structures as corrupt on ENODATA or EIO.
> 
> Currently, scrub failing to capture these errors isn't all that
> impactful -- the checking code will exit to userspace with EIO/ENODATA,
> and xfs_scrub will log a complaint and exit with nonzero status.  Most
> people treat fsck tools failing as a sign that the fs is corrupt, but
> online fsck should mark the metadata bad and keep moving.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although we really need to stop blindly propagating the block layer
errors.  I'll add that to my ever growing todo list.

