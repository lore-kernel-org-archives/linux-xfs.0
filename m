Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE00E544
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 06:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705905203; cv=none; b=B8IGh7SlVxZIoLRa9cagWd3VHsTU9agLYXBIVk2cuWskz1CqFmVGZ0yhK8bv4v7WQVT3CpHGX/E0nyAohnnNv1/yaiiwElQLM8HiIEGTbETOKI2sWqVF1JY41Ervf/biX3u63kowx1IyPfLpBNO38nyT7hJlYWOggo8uUZTpa7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705905203; c=relaxed/simple;
	bh=uEE4ZJfl8pNnSvynJp1z6IYIJH7c9KSr/p4F1PCl0Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojVpc3NYn0epkPDenB79JDYenYRJM9KN51SyUP3aQ6FjVWxeXQA9ROrDvRywlvA0DWQ/aMQvXN1B3ItQ5Dy7/AcGXXx+U8OnpIyOa2mMhmCR3hfrPR3XaCa5Bk5kC95GLCoic7N9Q0ruY1Qw5/U+CYzTW/2MB+MwOqQ8l0S+YVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZekifaEf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZekifaEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+fbSQI3XhZlL9c/SfqawzZTQvsfvv5BJ+4ggeelbvro=; b=ZekifaEfzvn20BbkuoU9L0Yr2O
	zz8FifUrsig6zdgnOv1QuG7eeBXT62/pBPgoTmdR3ejx6XcTdi8Trqmp9270DnoSI0fONXc1z3QMb
	1igyDCg9DYGiN2IigBZPMJhXkD5Ij6B6wPMmNzdsTY7GhJM3HWDR6U9TX6tYvH3yRZi2V1CvEj0/8
	H5vlxcNBnTBrCELXIGQJEulyxu2BRw+bL+yct90Y/gUO9SrXUjLMcBAM2+Q+q+Ooq1wYSqxFKMvOI
	6dVMCKSry22Xsee/wxZIJNThEGj5Q2ghazqbV1qsMKtUxelU+yuXaYlmEyOQdgbRrONT4Sno87cSr
	upIWmoWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRnry-00AkR6-2P;
	Mon, 22 Jan 2024 06:33:18 +0000
Date: Sun, 21 Jan 2024 22:33:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sam James <sam@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Message-ID: <Za4MLpu/HlP60Oea@infradead.org>
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org>
 <ZYEwFUy6bFO3h7Lz@infradead.org>
 <87v88k1yeq.fsf@gentoo.org>
 <877ck2x8uc.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ck2x8uc.fsf@gentoo.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 22, 2024 at 04:58:07AM +0000, Sam James wrote:
> >>  - we don't really need this patch all
> >>  - but cleaning up xfs_assert_largefile to just use static_assert would
> >>    probably be nice to have anyway
> >
> > Thanks, I agree, but I think static_assert is C11 (and then it gets a
> > nicer name in C23). If it's still fine for us, I can then use it.
> >
> > Does it change your thinking at all or should I send a v4 with it
> > included?
> 
> ping. I don't mind doing a followup, but I'd love to get this in given
> there's a bunch of other projects still to handle with this sort of
> problem.

Well, we certainly should drop this patch from the series.  Adding
a cleanup to switch the existing odd way of asserting the size to
static_assert would be nice, but I don't think is required.

