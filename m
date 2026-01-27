Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74372DC77B;
	Tue, 27 Jan 2026 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769492653; cv=none; b=DCg5tKXIurGvXXdSM1wbLO8zL0PGB/kzdeeeCEF1pMlQz6noPcy/UMwLGlGyPj6AC815E7j9rsVPEHtnSwP0U+mkTqkVPkDspaJ2TbOAHKcw59iyUfWKpluixeNJUfW0A6n1h4oIQE4YP/r/+kbpaN1av2YVlwy1G2GvuP287QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769492653; c=relaxed/simple;
	bh=4QYxIldizak+IcGdceVk9zex2ee/a2uBLc11TAMHOjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpCqW8S46SzlAYYbw3AcaVIRoWOqKSGhXbVtfp9hvjmDNcchMyKAKL5/nxAL5vwYopSuKI6Nno6lzDt6h6kxvkw7FICtSMfuGziYx9U5mRj20DCCUNMxPoAVIUs5YY1bjJaDh9xIty2d1eZT7MVviAFzSC8qAL69S1PFFTg5Dnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SNme6y8X; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SNme6y8X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7d7ZyPTaNMZTgFdupgqJ3mF/Au4wmZTx97BavE6JNHc=; b=SNme6y8X2dGONmwHIUULP1aDP/
	Tah+DBMyF2YDDS/QHQNrf/LKakhqibSZSCtmK47SuIDBIFJUPNlI4M4368wzPi04Ps6B3cn7W5kpH
	Ef4gY+yBe4tQQwdfTARTdY91h7TC5XuOlJKOsCYoo20ctO0rAr4uTWjV92Tux7ixX4yRCzQUfS4Xl
	yEzzYlifTVuB8EQxaVb4GjlxFl1zqX8Pc+MvSTb6fgkGoGBO1cZe7UzeeBMs5NeiRkxXj5eJTXGTU
	LMBGyMudgrC8xgSAd7EPZ252s0emGdstjDrtSnHe6dURp55mrqOmeAjQX1+qQPM5JAh1mtMVMObUV
	lOm8TEQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkbrt-00000006zBa-3oSR;
	Tue, 27 Jan 2026 05:44:01 +0000
Date: Tue, 27 Jan 2026 05:44:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kundan Kumar <kundan.kumar@samsung.com>
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs helper
 from bio code
Message-ID: <aXhQoa8QsQfMvyZk@casper.infradead.org>
References: <20260123135858.GA24386@lst.de>
 <20260119074425.4005867-4-hch@lst.de>
 <20260119074425.4005867-1-hch@lst.de>
 <1754475.1769168237@warthog.procyon.org.uk>
 <1763225.1769180226@warthog.procyon.org.uk>
 <aXemDMAfgC6vCU9K@casper.infradead.org>
 <20260127051352.GA24293@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127051352.GA24293@lst.de>

On Tue, Jan 27, 2026 at 06:13:52AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 26, 2026 at 05:36:12PM +0000, Matthew Wilcox wrote:
> > > > Hmm, this just moves around existing code added in commit ed9832bc08db
> > > > ("block: introduce folio awareness and add a bigger size from folio").
> > > > 
> > > > How do we get these network read buffers into either a user address
> > > > space or a (non-bvec) iter passed to O_DIRECT reads/writes?
> > > 
> > > Splice from TCP socket to pipe, vmsplice from there into process address
> > > space; DIO write() from there I think should do it.
> > 
> > Some other ways to get something that isn't a folio mapped into a user
> > address space:
> > 
> >  - mmap() a vmalloc-allocated buffer.  We don't have a good story here
> >    yet; we could declare every driver that does this to be buggy and
> >    force them to allocate folios and vmap them.  Seems a bit
> >    unreasonable and likely to end up with a lot of duplicate code with
> >    bugs.  I've prototyped another approach, but it's not reeady to share
> >    yet.
> >  - mmap() the perf ring buffer.  We could decide to refuse to do DIO to
> >    this buffer.
> 
> I'm confused.  Your example are all about something that would happen if
> we actually split up what is currently struct page in some way.  But I
> read Dave's mail as something is broken right now already.  Which of
> those is the case?

What's broken right now is that the network buffers are now using frozen
pages, so they have a zero refcount (Dave, do I remember the current
state of play correctly?)

> > The eventual solution is that page_folio() will return NULL for pages
> > which do not belong to folios.  That's independent of whether we decide
> > to make user-mappable-vmalloc contain folios, or whether we have some
> > other way to map/track pages-that-belong-to-vmalloc.
> 
> vmalloc is a tiny wrapper around alloc_page* + vmap/vm_map_area, and a
> lot of code all over the kernel relies on that.  Trying to have a
> separate "memory type" for vmalloc is going to break things left right
> and center for not much obvious gain.  I'm not going to say you can't
> do it, but I doubt that is actually ends up easy and particularly
> useful.

Most of the code in the kernel doesn't drill down from vmalloc to page.
I don't think it's going to be all that painful, but I also don't think
I'll need to address vmalloc in the first half of this year.  Just trying
to fill you in on the current plans.
