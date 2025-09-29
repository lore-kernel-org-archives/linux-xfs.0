Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1824E4A8
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 06:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759128870; cv=none; b=UIAG3662156LDUdL29ZtHgAts49zxb9U0d/66B8RXMiZWQ37ehAjrvYAf+UzK5TEPAH8NaPqSWdgf0cMX8niC0mZ2zTwk4QhT7VQNA/DpaAwe5eQvdCieJB/TR06wI3yndibdjTJLBOHq3dju9bTGSiZ97a0lVLNTU4B2Jr5Qy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759128870; c=relaxed/simple;
	bh=lQqNM2q5lIGSaAE6uw/vjOfwS3SI9GA12Jod9RwgdAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiryM7/mdzuqPGTzaJIjC0RVaA0X9bCOoooo6TLIGOhqF1/21wJh0wtOh0dEydg1tzZDB8UYLvfXf3kEUlHMD1bYgnwW7nfbfu+K+JGozS1FV1nazqhicQDVUsvISp39rT6M7fDVu7ZFov7LUF6S+yz2+M7uMqDD1J28lBCKeUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q96Cxbib; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q96Cxbib"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Ht5FAe7cMm2NibQtgFMVRyk/N+LdVsBNbV06qP7bYg=; b=Q96CxbibvwmmUmIbMRDKTIAZFo
	ILjxSBOWu+XqJoC+7asM3mlr+gm7Vj9wZl/PeHC6WURHaFT4mVb75eIlyQX2suH6hyciE3pp2C4zu
	Cxn2uggC2vimhUzgvNRsN5t7nR3Ghb9FprhOu0751Q0705AoPBBLU23xMZ+/fLFQhL0SJO539WsV+
	IpjIFfCzRPxVSULDLD+8EXoc26HB2DHvQIJAWhw5Q/a1cXqOMh8Nlfc561GcbYlUPhkFSGZcEtIZQ
	u/ARqFoJbG1biM64NtdW4n+OLmw7HhTUhyQbAmDUiLYmxrxXPHaR5dlaPA30igXMFP3EMYED/cm4V
	SxUETcNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v37mF-00000001XmW-1J5b;
	Mon, 29 Sep 2025 06:54:27 +0000
Date: Sun, 28 Sep 2025 23:54:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: aalbersh@redhat.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <aNotI3z54Om5MmE1@infradead.org>
References: <20250926123829.2101207-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926123829.2101207-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 26, 2025 at 02:38:30PM +0200, Lukas Herbolt wrote:
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.

As I had to walk the code to understand (again for the nth time :))
what the lsunit actually does:  it pads every log write up to that
size.  I.e. if you set a log stripe unit, that effectively becomes the
minimum I/O size for the log.  So yes, setting it to the minimum I/O
size of the device makes sense.  But maybe the commit log should be
a bit more clear about that?  (and of course our terminology should
be as well, ast least outside the user interface that we can't touch).

> Before:

You Before/after also contain changes for metadir/zoned, looks like you
upgraded to a new xfsprogs for your patch, but not the baseline.

> index 8cd4ccd7..05268cd9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3643,6 +3643,10 @@ check_lsunit:
>  		lsu = getnum(cli->lsu, &lopts, L_SU);
>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
> +		if (cfg->dsunit){
> +			cfg->lsunit = cfg->dsunit;
> +			lsu = 0;
> +		}

I don't think just picking the data stripe unit is correct here, given
that the log can also be external and on a separate device.  Instead
we'll need to duplicate the calculation based on ft.log, preferably by
factoring it into a helper.

The lsu = 0 also drop the multiple of block size check.  If that is not
a hard requirement (and I'd have to do some research where it is coming
from) we should relax the check instead of silently disabling it like
this.
