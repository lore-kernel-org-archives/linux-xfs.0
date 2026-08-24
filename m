Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925903876C6;
	Mon, 24 Aug 2026 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787605553; cv=none; b=hEFZfDQKK3RimL2lHudOoBUiDQ05lLC6d+z3FmD9RdPcgotPc5EFAc9rLw93qjqebnUDrJ77vIvApThip/qiqv1Rtd7yomBqa/vokLoERohCUL+TkroGepdOhiARUWZfvmyyV0PRu5ZgRK6HBKkuA9PSgwiLTNGT0YcMP759Eu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787605553; c=relaxed/simple;
	bh=WpBAlermHUqULVWbGWU5b/daCoPsKQvwe3gDd6bRwmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m20NdN2d7Y/7UR1mg4ZxEiIoJFQUm3ZoDhuZYi0bSsa2mw45HFzyTX+AA9WYK/wowqlfA/CF32XWOqxdM9aghlh/JT/H97QgGhLLXSvHedZBrBBHyH47AXOfDwkNdt7+omdkzXb0hsK/0gU7p6aZ0C3W1M+JmPtQdcNk2DKuGgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=acSTKIE8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="acSTKIE8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+LSKnKKqszrwqaH5kpE+1z9+lg3HT1GwCXbZtfOytxc=; b=acSTKIE8r0eFrM8rCaUyueqk/y
	x4ij5/ugleIUGdVP9alCWHtV4wohqt2sooIADen/YUA0AeBYqD8Y6K3LdnTp6+qFNYi0d+CIpySi3
	fH+hw1+bFj9873pI5/kWyEtK+M94G10GsefX6QVN0W49WH0BJdJk6GbNNs2RkVyLBd4IyPM6h/5Kn
	g/oeZpBXKFosO0M5EDSMb6yj30pwRWeWTxrfFjR67VSF7q+mYNs/XjYhk60DBpPhIlmMmRy56U6/x
	dMqM/031tSXT4CTorKkmPibgf2JrpL/dG+C57Fg7aH6dSAvExR5jIvzm9p/DaymlYNLk5EZKRgUCY
	0ahaWXbA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wybrR-00000007q0b-0jWo;
	Mon, 24 Aug 2026 21:05:41 +0000
Date: Mon, 24 Aug 2026 22:05:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <aoyyJQz4AFq-ilMV@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
 <aoye694JQLwUuqxC@casper.infradead.org>
 <764f2f23-09ba-4203-a304-94c0fba32db7@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764f2f23-09ba-4203-a304-94c0fba32db7@nvidia.com>

On Mon, Aug 24, 2026 at 12:51:43PM -0700, John Hubbard wrote:
> On 8/24/26 12:43 PM, Matthew Wilcox wrote:
> > On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> >>> My proposal is this:
> >>>
> >>>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >>>    If it's true, do the writeback, but retain/recreate whatever data
> >>>    structures you need in order to write the folio again; behave as if
> >>>    ->page_mkdirty() had been called again for each page in the folio is
> >>>    marked as dirty.
> >>
> >> Yes, that would work nicely.
> >>
> >>>  - The MM behaves similarly; we do not clear the writeback flag for
> >>>    folio_maybe_dma_pinned().
> >>>
> >>> This will have the effect of writing pinned folios back every time the
> >>> inode is scheduled for writeback.  But since we have no idea whether
> >>> the folio is actually dirty (because the GUP user won't tell us),
> >>> this is the correct behaviour.
> >>>
> >>> I'm probably missing some stuff here.  Let me know.
> >>
> >> OK, so working through the end of the pinning, I think it still is
> >> correct: device finishes writing to pinned memory, device driver
> >> unpins the memory but the page has been left marked dirty the whole
> 
> oh, I just thought of a minor hole that we need to fill: how to mark the
> page dirty in the first place, in the absence of mark_[page|folio]_dirty()?
> 
> Under this new scheme, we will need to pin first, then mark dirty, to
> set up. The filesystem can't do everything, because even if it were to
> call page_mkdirty(), a writeback could clear that before the page gets
> pinned.

The page fault path:

handle_mm_fault()
  __handle_mm_fault()
    handle_pte_fault()
      do_wp_page() [just assuming the pte is present, but !writable]
        wp_page_shared()
	  do_page_mkwrite()
	    vmf->vma->vm_ops->page_mkwrite(vmf)

and that's where the filesystem gets notified that this page is about
to become writable.

So your concern is obviously "how do we prevent the writeout from
happening before we set the pincount", and I think it's that the
writeout path will make the PTE read-only before it does writeback,
and we hold the mmap_lock which prevents the page table entry from being 
made read-only.

But I'm only about 80% sure that's what happens.

> > @@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
> >          * Here, for that overflow case, use the sign bit to count a little
> >          * bit higher via unsigned math, and thus still get an accurate result.
> >          */
> > -       return ((unsigned int)folio_ref_count(folio)) >=
> > +       mapcount = folio_mapcount(folio);
> > +       return (folio_ref_count(folio) - mapcount) >=
> 
> As long as the math works: need to not underflow. I guess mapcount is
> always less than refcount, so OK.
> 
> So it *seems* correct to me, fwiw. :)

Yeah, and if we hold the folio locked, it's true.  But we could sample
mapcount, then have a few unmaps come in before we read refcount, and
we've got an underflow.  I mean, it's only "maybe" mapped ... ;-)

Perhaps we could have two functions, one for if you have the folio
locked (like in the writeback path) where you can rely on mapcount
not changing, and thus refcount always being > mapcount.
