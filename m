Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AB1168BD;
	Mon, 26 Jan 2026 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769448985; cv=none; b=H6bPzc0L/s2vQO7gsWbVgS1MGH22pwkDzJeUbpscIvzJWEAzUHci1mZsyCJJinRAGGVb6m3Fmm58b/q6YaSaagOd81PoXZCg9ICXYmd6vJ6IaKM2czpL0DhYS6l95XoHvbR15059ek+lkGf2tUc6pwJCbdeW95k/x7U8z9qBF/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769448985; c=relaxed/simple;
	bh=IR0RiDtRQxTU5cFZWnSpngyOZ5KIXKQAiOq7J1bRe1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkYT+hXUxO6WLDo2aAGyW8IgmWm7oCB6zyMox9he/EGLljvhUOgOpQfYyCpBjoS/4ewWf0zkf6xZlikMNuzbt66RA+wSYIBFAFBsv3IWTKjDsmN3GxFrkv5WNE8J2vcJu/qdQv/QeXUBVW7ESmaz63l/nR9Jit3xgPE/a1xj/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZdGEOhbh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZdGEOhbh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aOwxYhMrFGZ9qZqMNlKYd/PzK3JSyijS2/c7mOvz79I=; b=ZdGEOhbhsQBDNoujaXcJJsynRG
	7m90rQePpb8HU1v0zFrD/R+zUJXABXymJvWhL9jMOtocsqPxkxAzMQSC35g27D9d9QUlHf2V7PM5a
	e4Vnr9gi/yetTTTfrsJRamH1iXRzeoZfcAgxc146JADzgurDi2s0b5x8ZmhXMEmozh2QTt+dWwDwL
	uRjQPCg2SCiLkMmGFmAozYkXpHm/78fqR+tjClhgj3yxvXjYuBYGvOO2AOHxbFxf0Dee3S7T/LSh6
	F+r+qt42haSXx4NpOeVF6JGyvf5AR4Tr1wzraAahfIRVB7TXB+6zLDqHhCVl7blncMP2VTv5Fdvg7
	sgQQpDaw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkQVY-00000006EY8-46mD;
	Mon, 26 Jan 2026 17:36:13 +0000
Date: Mon, 26 Jan 2026 17:36:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kundan Kumar <kundan.kumar@samsung.com>
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs helper
 from bio code
Message-ID: <aXemDMAfgC6vCU9K@casper.infradead.org>
References: <20260123135858.GA24386@lst.de>
 <20260119074425.4005867-4-hch@lst.de>
 <20260119074425.4005867-1-hch@lst.de>
 <1754475.1769168237@warthog.procyon.org.uk>
 <1763225.1769180226@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1763225.1769180226@warthog.procyon.org.uk>

On Fri, Jan 23, 2026 at 02:57:06PM +0000, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Fri, Jan 23, 2026 at 11:37:17AM +0000, David Howells wrote:
> > > Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > +static unsigned int get_contig_folio_len(struct page **pages,
> > > > +		unsigned int *num_pages, size_t left, size_t offset)
> > > > +{
> > > > +	struct folio *folio = page_folio(pages[0]);
> > > 
> > > You can't do this.  You cannot assume that pages[0] is of folio type.
> > > vmsplice() is unfortunately a thing and the page could be a network read
> > > buffer.
> > 
> > Hmm, this just moves around existing code added in commit ed9832bc08db
> > ("block: introduce folio awareness and add a bigger size from folio").
> > 
> > How do we get these network read buffers into either a user address
> > space or a (non-bvec) iter passed to O_DIRECT reads/writes?
> 
> Splice from TCP socket to pipe, vmsplice from there into process address
> space; DIO write() from there I think should do it.

Some other ways to get something that isn't a folio mapped into a user
address space:

 - mmap() a vmalloc-allocated buffer.  We don't have a good story here
   yet; we could declare every driver that does this to be buggy and
   force them to allocate folios and vmap them.  Seems a bit
   unreasonable and likely to end up with a lot of duplicate code with
   bugs.  I've prototyped another approach, but it's not reeady to share
   yet.
 - mmap() the perf ring buffer.  We could decide to refuse to do DIO to
   this buffer.

> > How do we find out if a given page is a folio and that we can do this?
> 
> That's a question for Willy.

Today there's no way.  Although you could test for page_has_type()?

The eventual solution is that page_folio() will return NULL for pages
which do not belong to folios.  That's independent of whether we decide
to make user-mappable-vmalloc contain folios, or whether we have some
other way to map/track pages-that-belong-to-vmalloc.
