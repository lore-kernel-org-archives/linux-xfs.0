Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A930AD1C;
	Tue, 27 Jan 2026 05:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769490846; cv=none; b=lQA/0eKXUscSOsvYTnYYu9UiZHLsg8vZaClM0Zbqf5+mzF4gYZLYT3vP8th25MFT2Awal9a+tonZmevoS7qFkghd3vU0ga7LhGvB1ufP/5iNG7N3XJB5jfKgm32An9Ljsj+6GuhGj20q/Kzi8FpsKnLMdWeJa78c7RqodTZ6CEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769490846; c=relaxed/simple;
	bh=qAAidTqt62wLQtqzAicedo/B6O7vF3ti36gyT7k/BSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAe49iwisGy0jCx/H5/PhZbSKbH/y5wfPsfK3UKSW7xHMPsG12ZRP9wU7B/gYaUjPFgXaR9c4znoucBfs2FJPfHggWF9umPH6YqLuS/J9tNREd0BuLmAKbTMRtDAi2XrpNKYn93yymnxSTnvsAjbwYHqSI7JsPyx/s4dnjUttqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A94D227AAE; Tue, 27 Jan 2026 06:13:53 +0100 (CET)
Date: Tue, 27 Jan 2026 06:13:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kundan Kumar <kundan.kumar@samsung.com>
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260127051352.GA24293@lst.de>
References: <20260123135858.GA24386@lst.de> <20260119074425.4005867-4-hch@lst.de> <20260119074425.4005867-1-hch@lst.de> <1754475.1769168237@warthog.procyon.org.uk> <1763225.1769180226@warthog.procyon.org.uk> <aXemDMAfgC6vCU9K@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXemDMAfgC6vCU9K@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 05:36:12PM +0000, Matthew Wilcox wrote:
> > > Hmm, this just moves around existing code added in commit ed9832bc08db
> > > ("block: introduce folio awareness and add a bigger size from folio").
> > > 
> > > How do we get these network read buffers into either a user address
> > > space or a (non-bvec) iter passed to O_DIRECT reads/writes?
> > 
> > Splice from TCP socket to pipe, vmsplice from there into process address
> > space; DIO write() from there I think should do it.
> 
> Some other ways to get something that isn't a folio mapped into a user
> address space:
> 
>  - mmap() a vmalloc-allocated buffer.  We don't have a good story here
>    yet; we could declare every driver that does this to be buggy and
>    force them to allocate folios and vmap them.  Seems a bit
>    unreasonable and likely to end up with a lot of duplicate code with
>    bugs.  I've prototyped another approach, but it's not reeady to share
>    yet.
>  - mmap() the perf ring buffer.  We could decide to refuse to do DIO to
>    this buffer.

I'm confused.  Your example are all about something that would happen if
we actually split up what is currently struct page in some way.  But I
read Dave's mail as something is broken right now already.  Which of
those is the case?

> The eventual solution is that page_folio() will return NULL for pages
> which do not belong to folios.  That's independent of whether we decide
> to make user-mappable-vmalloc contain folios, or whether we have some
> other way to map/track pages-that-belong-to-vmalloc.

vmalloc is a tiny wrapper around alloc_page* + vmap/vm_map_area, and a
lot of code all over the kernel relies on that.  Trying to have a
separate "memory type" for vmalloc is going to break things left right
and center for not much obvious gain.  I'm not going to say you can't
do it, but I doubt that is actually ends up easy and particularly
useful.
