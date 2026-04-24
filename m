Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF25372B2B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038730; cv=none; b=f+a+l5ZAQiqBeiykV/pTlXfXW/nbaRRTLhChRZTEE9rodavUXNHU6EbFERjyOPiZcZUsd8ext/MOSKLCji5rTawAjR1x17mvfu2IUuZ4xANNFHSMy0jrS45LbBJPkhWJNRfDg3A/kiED2ai83tpmOq8dZ6zSRuYulb9HUda1Bb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038730; c=relaxed/simple;
	bh=KQGHQtJvhoxDDj2j8QGgiK2s/s5a9DFcyXPi90+m3BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1LoWMus5iOK2AG9su2mxdPtSIMJMSDg1+9VS1GOHPiyVfgVZgplArM93foPWbudspWPmwhZ0/q3XoPR0IA/9Ypqt9LEJSypMF3fPFKlthwLgpXq8C6QvEUfdOtbFCN9jxDHWTWe/I+boc95hc1zIXh1BJPIG7KIW0Y5II+LzT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DgLber/T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DgLber/T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pgePSB3C7h3ygaYCqkGHYCApmMkVYriCrdf1zeKECN0=; b=DgLber/TmFwPXFr07qvnAmhYHn
	aCdLjXMs8IjaIIR4YHxCxQvLfK3rc0hNAFLyFSZCHXiBOL1EqCUfCh08JgI4bD9BbdSDnRUtY2zz5
	lnRKf2WmEel+AP0/l0puAcPfMEzVF4IpNeupPLvFc7ZFGHKcYcnBpKR3UCpiYJRJXxxvgPFcgXF0J
	+oGK03H+DvZkAg+lBgqRlx3Ae1TbDXSidiTsLnqX1Hu4vqV2ch+RFzp/Z3j6K3pnamC8FN3uVK0Sn
	Hlip1zQFv6Zhkh+2klmkiyP0h0rL6SODm+d6oW1OAsyb63SbIudfqWgbrtxafoQspQghxhVDOMxim
	xWFa/Tcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGGww-0000000DHFv-2LhF;
	Fri, 24 Apr 2026 13:52:06 +0000
Date: Fri, 24 Apr 2026 06:52:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3 1/3] xfs: add xfs_bmap_alloc_or_convert_range function
Message-ID: <aet1hhhRPGg5eGmK@infradead.org>
References: <20260420105539.3644999-1-p.raghav@samsung.com>
 <20260420105539.3644999-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420105539.3644999-2-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/*
> + * This function is used to allocate written extents over holes
> + * and/or convert unwritten extents to written extents based on the
> + * @flags passed to it.

You can and should use up all 80 characters for comments.

> + */
> +int
> +xfs_bmap_alloc_or_convert_range(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		count,
> +	uint32_t		flags,
> +	bool			update_isize)
> +{

Please keep this function in the same please as the generalized
version it was base on so that git diff/show shows what changed.
If you have to move it around for later patches do that in
an otherwise no-op prep patch.

> +		} else {
> +			/*
> +			 * We might allocate data blocks (needs resblks + 1 split) or
> +			 * convert an unwritten extent (needs 0 data blocks + 2 splits).
> +			 * Ensure we have enough block reservation for the worst case.
> +			 */
> +			resblks = XFS_FILBLKS_MIN(count_fsb, XFS_MAX_BMBT_EXTLEN);

Please avoid the overly long lines.

