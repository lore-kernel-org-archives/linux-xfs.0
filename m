Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEA13CCFCC;
	Tue, 25 Aug 2026 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787687675; cv=none; b=hdVd1N9l/xNL1pzd1g6VA+M9R1YSeg5a3TgDEq/n4M9WZWym/cjKk/dqii37+x3D4gKvahn99ZUEy5tO9svagUZNUUcq02rZetiO37OeZZ5gVtAMvzJjSqUGAR4agFKEyyJuNvTyIEZqFeOAG38kkhlFYHHzhNrL7QfnKihRS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787687675; c=relaxed/simple;
	bh=P77EoaPsWzVp08iF7mAqw/bsYKPi/NQKnTDilvmOF7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWQs20XzOuGbXrkTvddgRpCIaAe14TDGhMDOuOamz66qITKah5+4P1AJl0Hbk8SR7yHEmR+sSlTShTTkxzGswt0lZhpb58qZtlcifl9IYbskAzex6WZkVinpA0ByUA65Myetcl+xBZ5b9rkJhjDBVjHaplWc6TE8uU74RLmAbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YTvUAr3l; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YTvUAr3l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=smFQZ2IeQKu0B72lsW5UQQWmYpl1k+vdLVb/izh96cI=; b=YTvUAr3lwCk+v4NG+erMHF4nhw
	uSFjwylmYF2u8k3IoHoSxAUwyixjRMkt2tMEKGRgQYPo8zjoklPghvFWLBmVgLyz61jWpI/yVM3p/
	4PXokLDYhj/SKZWhgbenfzKExQZ6dUC/kNvWQRdbjAeqW0I3PdzDCq9DvIz960cCJDPEEdhslq3Wk
	fOuPkUcQ/MFTk47Rjemehr1joS7Uy9w584AHCiaRqPk/fdmBQ+IVSmwAuVzNDXlbruWzeHJ4DHaK0
	VuKdf6TxBxg4lWTzC0IP7nJ2JkzU5910QTXpuFDeerQq5WFDaaqLu+giBUbV8coeS0ycSUfeE9BSJ
	YQv9z9mA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyxE1-00000009dFV-3BJr;
	Tue, 25 Aug 2026 19:54:25 +0000
Date: Tue, 25 Aug 2026 20:54:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3y8TtEGjniZ_4f@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>

On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> 
> We currently have get_user_pages*() and pin_user_pages*(), where only
> the pin_*() version is properly usable for write access, right? And
> dropping such pins should always go through unpin_*() helpers?

Right.  I'm stuffing cheese into my ears and pretending that people
aren't calling get_user_pages() to do write accesses.  We should be
able to use this work to flush out the last remaining ones -- we
can put in various assertions that folios should still be dirty where
we currently have folio_mark_dirty() calls.

> Could we strictly ban using get_user_pages*() for write access, and
> use the unpin_*() helpers to somehow enforce that folios are always
> dirtied on unpin? I guess the problem with that is that we have no
> state that tracks whether the pin was read-only, and finding free bits
> in struct page to keep track of this is hard?

We'd need a count, not just a bit or two.  A pincount for all folios
is on its way (eventually) but I wans't planning on tracking writable vs
read-only pins.

> > My proposal is this:
> >
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
> 
> I don't understand this part of the MM/VFS machinery well - would this
> mean that a long-term pin of a dirty pagecache folio could cause an
> unbounded number of disk writes in regular intervals, even if nothing
> actually writes into the folio? I'm guessing that could be bad for
> cheap flash storage, but maybe this is in the category of "yes that
> would be bad but it would be userspace's fault".

Yes.  I think the only alternative would be storing a checksum of the
contents of the folio and seeing if it changed since the last write.
As you say, this is userspace doing something incredibly odd (I really
don't think people make a habit of mmap()ing files shared writable and
then giving RDMA longterm write accesses to them.  Not on machines with
poor quality flash storage anyway).

Or we could say "these pages only get written back on requested fsync()
rather than periodically".
