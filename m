Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EF13B8BA4;
	Tue,  7 Apr 2026 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570347; cv=none; b=mIRqsn4SdHRVuaWD1NdYhxevw0BaOfu275yeq+GREod2KQtEqECo75a8xTlig+TrE1lOP3uUsuClp9w4iaxjIAtDhyVbmG+rQ0EwPgpUqHLbOceDacJyD0/rNWaQST5I7gu0bVIGasYoEsyMm9cU6L9G9EAD/cJWbaH392uKAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570347; c=relaxed/simple;
	bh=q3wkF/qz0+k+IFDvSGaCzDCjxC6/4ChSl/GFEaxzw6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+n9VbCWbdeNoo49nMuA+BGNSYChmQjfLpPJzti4K7ut+h5njnUeVTcT7iHGevURpj2OmhvCW8ak4mt4giBjHlOIIeDQidRhQNTGWcTbDxhA7NOeQCbDirHyzZdXYmmWafM4MdGWlCUsd9z/KN6/sABI4brMSAfyXYVw7ZGvcVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P5Boa1NJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P5Boa1NJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qywpj/TgsB4lCeyuvDBJjkFieyKeIvYdPInIrebtvNI=; b=P5Boa1NJt4w3SzymoJs/yRlDE1
	CCmlAa4BKQfh/pz3NNsYdPN0LMp6e/HQgO0Zzp/GcD6HoyDSi2KtKiJqo065sqLPH6PKmNl55c2eP
	WpdYtszqkH6sCDruVDboIg8Q7Htm/oEP+OdGvG6u91CrBprCWMF0IDJ12bGKgBocURNFf9jnnEipx
	LkgQKfgghhdbfsV8jlsYzw4mEwt0fzqefuainSiZ/Fpp2H9uh0qFPUDyhVh+ZwPSGYNbirKqkLtNQ
	cAMUG2ifKvyyxpXmLyLpkyMJera5SbJfb2JcFIJ8cBXBXU5/mzd5Aev9GQH8zTeRDpvpcKuH0z70c
	d909/p+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA6xL-00000006YXy-2Mgx;
	Tue, 07 Apr 2026 13:59:03 +0000
Date: Tue, 7 Apr 2026 06:59:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, kbusch@kernel.org
Subject: Re: [PATCH 3/4] block: add a bio_submit_or_kill helper
Message-ID: <adUNpy-RlCD0eaMq@infradead.org>
References: <20260406055728.472919-1-hch@lst.de>
 <20260406055728.472919-4-hch@lst.de>
 <2b2998f6-260d-426d-9ea5-1019bdb8c77d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b2998f6-260d-426d-9ea5-1019bdb8c77d@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 06, 2026 at 09:08:16AM +0200, Damien Le Moal wrote:
> > +{
> > +	if ((flags & BLKDEV_ZERO_KILLABLE) && fatal_signal_pending(current)) {
> > +		bio_await(bio, NULL, bio_endio_cb);
> > +		return -EINTR;
> 
> This was like this in the previous code, so not big deal, but should we perhaps
> return the bio error if there was one ? And return -EINTR if there was no error.

This only happens when the process was killed.  In which case -EINTR as
a syscall return makes sense, independent of any previous error.

