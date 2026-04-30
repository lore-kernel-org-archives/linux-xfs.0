Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F7D4279FA;
	Thu, 30 Apr 2026 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555855; cv=none; b=H6VddR1wqychvcQyDEA1jy4zvHpVUywgTCL7KUHbMLUVD8VCLOCUw8aWd2QesUFSlkESszk0fI/z+H9yiJmOQJjKrQX6/Ymp8nYBSmwI8x2jEQyeCdQCUdavWxynH2rFGadFoA8vPWoD2iS3mjAzdzmHzTX/f5XPKgVQD39YIMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555855; c=relaxed/simple;
	bh=LpWo06lyaT3tehwX8QZtmCwHBYEX8HB61WsiJPyJWJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OfD+s/EaaO3H78lyEem456JjpjJVTl0zNxfWzh5wwrDgups9QklBUkEoTlhJLAxj4scUw+qsCmv20ThqS4vK1TwZ4gKubV1Zc6VB475lIfIWaNqEvh56gtx24ql3hhcqBiAdgRZyZyXbXvisEXuaakKJ1ukSZZhJ7HUD7UQZPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NVfKsFpe; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NVfKsFpe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z77/Zy57sD2usQRGdSGVWDD2liLPqD3H4IahNINpbjM=; b=NVfKsFpeUzZO2Zee7uxnbeyACi
	OeCMdO3PeKxgGp0Q3RyxYfrx+fNcXX9+JLsFDy3V4rsg0eXPnwEcTZBzBFxm3fxcOcXvJmfu5TKOO
	97CYf05MhsluNDjtMJqUpRI5ddcPsXIfuoxgFPTKVWEvmIB5fl37buHBfmG17AJMIDxzYCSq3GQ47
	YJSBFUuOHCEpoAE+9w6AxBW+MSHb4B3x9PlnAQ49pyfJRbA03h9wawDCMQhrZu2cHhUKFvFhNyvAE
	Mi7Yw5SG5yduJTHHzk0DSZTey7zu/Z8jvMHPi5yj2j5XRRyYXP2kB4k3sAuRUj73iWkzVf3aE1Noy
	JWs09i4A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIRTf-00000007I19-2dDi;
	Thu, 30 Apr 2026 13:30:51 +0000
Date: Thu, 30 Apr 2026 14:30:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: pass a minsize argument to bio_iov_iter_bounce
Message-ID: <afNZi5HRDWtK9Wdx@casper.infradead.org>
References: <20260430132019.312405-1-hch@lst.de>
 <20260430132019.312405-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430132019.312405-2-hch@lst.de>

On Thu, Apr 30, 2026 at 03:20:04PM +0200, Christoph Hellwig wrote:
> -static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size)
> +static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
> +		size_t minsize)
>  {
>  	struct folio *folio;
>  
> -	while (*size > PAGE_SIZE) {
> +	while (*size > minsize) {
>  		folio = folio_alloc(gfp | __GFP_NORETRY, get_order(*size));
>  		if (folio)
>  			return folio;

Seems a bit inefficient.  How about something like this:

static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size, size_t minsize)
{
        unsigned int order = get_order(*size);
        unsigned int minorder = get_order(minsize);
        struct folio *folio;

        while (order > minorder) {
                folio = folio_alloc(gfp | __GFP_NORETRY, order);
                if (folio)
                        return folio;
                order--;
                *size = 1UL << order;
        }

        return folio_alloc(gfp, order);
}

