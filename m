Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B063CF4B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929569; cv=none; b=p06FejXcp7zEDo/Iyqfca//tv4/shMEigbXK9G3yC/3rsYB3p9lmV/3wLZIM5IhUiButLmro4jeAIMVXUxtfAHE0HtDo5NHSZpomceYXCKDoKYqn9ubMA/F4rkw9NkkCZNkYInqnYj9UgnFiGo+BnGCXcrPPhrDaCV+B4N2sJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929569; c=relaxed/simple;
	bh=Maj6IJwoMh9Z67a2lCJ0r2fxB85hUCARfTPU+S4E+eI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muaMDzCOqXySBCswQGmkqMz65NjIBPWAjHh8QA1BX2F/dStbj41QrEZeFSqmCqcEqyaOPJx6RzLEvN2TnkU+Y1YajmfWxpNW0Zm2h84qejAwBwV7C4Q1wMkTGDHGnyDSNs0/5hsVRtjFU6ul6tZcXU0I7CrX7w0xLBn58tYlcm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4iHweo9U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4iHweo9U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d1Z88MF5EGIom09k/BK6rmRHYbu17PtYl+yBuSl5XQU=; b=4iHweo9U0YowonvdGy/52phYOc
	KSFXiE7xMqt6F9nTPJQ2xEmGNJ1/Qd9ojusJYOrDHbgf2eINFmU16FsfC0BvSQAJbLPBmpybNagiZ
	5qc2sS8rpzde55WNBlBriD5RilPtn+VtenomL6IiG6w7jigJX87gpVme66Ru/nrtEREn0nU5PW1FP
	vVV3aLzFSHtfuoK6b2UQrUFP8oesDnuunqbDgNMLMFQn9XvUqGlWXuMtZcF6eqjUG5q3d9hqdMDGz
	oEcREygTvAIwBdXmDti4Nla4llmWonrbZw97bG5JVgfHqXrbkdnHwWibz62L1RyV8cyPcaXAiO6Fs
	WQlFSuuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRuCY-00CGWb-13;
	Mon, 22 Jan 2024 13:18:58 +0000
Date: Mon, 22 Jan 2024 05:18:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <Za5rQnj6NPqTE+CN@infradead.org>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
 <20240119012624.GQ674499@frogsfrogsfrogs>
 <Za4NkMYRhYrVnb1l@infradead.org>
 <Za5aANHuptzLrS6Z@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za5aANHuptzLrS6Z@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 22, 2024 at 11:05:20PM +1100, Dave Chinner wrote:
> I haven't looked at what using vmalloc means for packing the buffer
> into a bio - we currently use bio_add_page(), so does that mean we
> have to use some variant of virt_to_page() to break the vmalloc
> region up into it's backing pages to feed them to the bio? Or is
> there some helper that I'm unaware of that does it all for us
> magically?

We have a kmem_to_page helper for chuking any kind of kernel virtual
address space into pages.  xfs_rw_bdev in fs/xfs/xfs_bio_io.c uses
that for a bio, we should probably hav an async version of that
and maybe move it to the block layer instead of duplicating the
logic in various places.

> Yeah, that's kind of where I'm going with this. Large folios already
> turn off unmapped buffers, and I'd really like to get rid of that
> page straddling mess that unmapped buffers require in the buffer
> item dirty region tracking. That means we have to get rid of
> unmapped buffers....

I actually have an old series to kill unmapped buffers and use
vmalloc, but decided I'd need use folios for the fast path instead
of paying the vmalloc overhead.  I can dust it off and you can decide
if you want to pick up parts of it.
