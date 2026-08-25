Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5D532ABCA;
	Tue, 25 Aug 2026 19:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787687238; cv=none; b=RQkcBgPiTzMk9uF9XTxElRFPc23FWZEa36be36QOUgmxfW6p5Y1fwJKbJDwksWzhiLLCDNDNl8L1cP8LZLUF3u3k3wwcdSuYa9nd0PLdSn4/UqherwHXve/l7sf/pDMsMtv/Ek5+FdJdfRx8l36CngAuMXjix0/Gb+oxUloE9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787687238; c=relaxed/simple;
	bh=cbEs53Bf90VigGwnZn3ZV7ZXeBm6IENjqs6hds28hoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kheWVzZt6ZQJGCsWJJ3zZSWOUQ5mjOMblgP8kIW21+QqnPHBHlG9gGtQiNY124YbyG6Fe2e51i8mbX+kaAqdSA8/SqtxQaAkAoLL0F85cK6Bf7j1h4kFjP7JmkhPAHsg5BSQNPEb/mhGnZFMyZkGpzcF43i0bxh0B7u33jXhdTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p4q5ZW0l; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p4q5ZW0l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZQQ/ppgg7VzEnzjhM9PBplFwJ2D9OdML5WexPKMbFq8=; b=p4q5ZW0lzpuJU0ltYF8/6QuqUh
	W7G5TQfNDjRDGvVJKFLAppYgk5yIO5Ud2LZN2Zhk2SDbBzVt2yTr35jc3Zn4B6KZbpYRoVOpw2Nld
	B3/bEvM+dko7aif4w5kWkiSri0z+WY+3V2zoWXuGrfeu7ofiFResDR31RetXK1VzNYZEbsiPvF6zc
	HlzhXrNYZi16UBo7FxxT5JCd2OLgFb3DfOXhuLfWoyo391yrvBZzLrQDVwR4FciwuZn7XWD6nFuIW
	yk6QNkW4+mv+A6rgrTo8xWC43gvUxiTtn8s83BJ/lkdSu9TPBfDsrVb7DfWbV343Hg9aIrr/xx7yD
	kxbXFLPA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyx6u-00000009cpV-0CbN;
	Tue, 25 Aug 2026 19:47:04 +0000
Date: Tue, 25 Aug 2026 20:47:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3xN89JJoAqwt52@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <20260824212727.GA3664690@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824212727.GA3664690@zen.localdomain>

On Mon, Aug 24, 2026 at 02:27:27PM -0700, Boris Burkov wrote:
> On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> > I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> > 
> > This is not how filesystems want to be informed of folio dirtying.
> > It was fine for ext2, but anything that's journalled or COW has work
> > to do before the folio is made dirty, and it's hard to do that work
> > under the page table spinlock (not all callers hold that lock, but the
> > filesystem has to be able to handle the cases where it is.
> > 
> > Filesystems want the page_mkwrite() entry point to be how they find out
> > about a folio being dirtied -- and that works great!  Except that we
> > can writeback the folio for a number of reasons.  If it's been dirtied
> > due to a shared writable mmap, that's fine; we map the folio read-only
> > and any subsequent writes will re-enter the page_mkwrite path.
> 
> Can you elaborate on this part a bit more? I can't tell if you are
> proposing a change or saying the existing behavior is fine if we drop
> ->dirty_folio(). I am also confused about exactly what sort of folio
> dirtying you are referring to. Sorry if I am being obtuse.

Sorry for not being clearer.  This is what happens today.  We first
tell the FS that we're going to write to the page through
page_mkwrite(), then we transfer the dirty bit from the PTE to
the folio through ->dirty_folio() ... but it's already there, thanks
to the call to page_mkwrite()!

> When I was recently adding ->dirty_folio() to btrfs, one of the main
> cases was the call to folio_mark_dirty() that came via
> __iomap_dio_bio_end_io() calling bio_check_pages_dirty() which schedules
> bio_dirty_fn(). (i.e., completion of a dio read into a shared mmap)
> 
> Is that the case you are referring to here, or are you referring to
> someone just modifying a byte they faulted in from a shared mmap? The
> latter I would expect to have called page_mkwrite in the fault and done
> fs-specific work, so I assume it's the former that you are referring to?

Right.  The former, I _believe_ already calls page_mkwrite() today, and so
the call to dirty_folio() is redundant.  Except if writeback came in
while the I/O was in progress.  So if we preserve the dirty bit for
pinned pages in the writeback code, the caall to dirty_folio() will
always be redundant and can be removed.

> Either way, I do believe that for the dio read endio case pinning is not
> involved and btrfs relies on the ->dirty_folio() call, so I think
> something would need to be done about that case too.

I traced that code path down into iov_iter_extract_user_pages() which
calls pin_user_pages_fast(), so I do think the pages you're talking
about are pinned and would be handled through page_mkwrite() already.

iomap_dio_rw
__iomap_dio_rw
iomap_dio_iter
iomap_dio_bio_iter
iomap_dio_bio_iter_one
bio_iov_iter_get_pages
iov_iter_extract_bvecs
iov_iter_extract_pages
iov_iter_extract_user_pages

> I believe you saw this patch since it was your idea for us to use
> ->dirty_folio(), but just for reference for anyone else who didn't see
> it, the btrfs patch adding ->dirty_folio():
> https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/

Yes, I want you to be able to revert that patch ;-)
> 
