Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E81F47F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903067; cv=none; b=cyqMToeUyxT08YQOlZ80faWtlj/Km1776Fu+iKSXCWDmnzyNhU3swrrY9Pdue26gz/yddFiKHQ9CocojzCUsbdAZBCseg2HsYIs0Rtla7lcnCIcrc5kivIhy9pRKrQYP+XjpYJe//RA9/QI4v9Ldptwraq/eXgvjkB0SbAID8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903067; c=relaxed/simple;
	bh=d8rQK5ixhQYBAM1P6QtslLDBs6ekZtlE1kUip97LqMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QutYL4v9bqWMx2UAGW5j3b3D9h0nXJ2/DzNCCTm4ymLJdgS8XAaDFyWzHAqgFnYgLz23DIrdrsRs0CALfzdkYGUYgUUxFxmueb7wSUCkrJN8yhkxdl0jWl+3DREbD861oocqZiKA8qXkDiZoSqLpTiSY6up2dfaG3jPaFRvy0/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1yBZyV2o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1yBZyV2o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nVzocCMrHxmAYC20lj3Ve+zscMTkdb1kxhU5Vv5q/ug=; b=1yBZyV2oa3iHme+N3fof80KaUM
	InmQmhCNGuHATSNP7b5qrOs0ZXIIgCrzO2VqsDNKDLohOdxflJDwDht6ITk1giuSkw6KtAjnp6maD
	mOSOr1lHLTh+6XzVoLi48zbFVT3B1F97lV5K0CciC5SaRAf/henHcWTrjvlGfejBLQCdtnbSC9mpy
	7DzWxP0NKymaB3+A5ySKtnx/+Fa1+jYbJsrsnZdJpAJOuRFDVlFgye5zVPul5TvX53DjpROoskfNl
	uNW6NUEJXtaWGJ4lfeYpbCtNhnTtibKvNwF/IRizOTU7uS0eIUDTfeLiwLCEGlnrAAmkVk13wI3CB
	WmxBpSTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG7e-00000008J0o-0ViL;
	Fri, 07 Feb 2025 04:37:46 +0000
Date: Thu, 6 Feb 2025 20:37:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] xfs_scrub: call bulkstat directly if we're only
 scanning user files
Message-ID: <Z6WOGmWidIw7xnJK@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086151.2738568.86305255846191106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086151.2738568.86305255846191106.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Iterate all the user files returned by a bulkstat. */
> +static void
> +scan_user_files(
> +	struct workqueue	*wq,
> +	xfs_agnumber_t		agno,
> +	void			*arg)
> +{
> +	struct xfs_handle	handle;
> +	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;

No need for the cast - wq_ctx is a void pointer.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
