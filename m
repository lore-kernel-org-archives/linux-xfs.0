Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F193B37B010;
	Tue, 25 Aug 2026 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682932; cv=none; b=DNHFKGiIC9yoVpkzWfPxDHr8ozehUToEReA6GzpV2rKk9Pdwi7653mMavu+VDp2nV+a5o2ZXEqtzeTs7EDHQH/1FMdhGID7vjIXEv3o+AXd0emGwZFc3/NZyhgwzvA5TjczTFK5DU7va7icMXkKZC5Lq+TsAIyMoHSrIFL5NLa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682932; c=relaxed/simple;
	bh=pZ4mfsgKRGFTaaqzSNMXArPfYaaJEFy2hCV2prTkb3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZ1seROyURGXuIWeySt4JbRo8ZkBWR+iWjyW5/zZTcoEBELW57p+Pvpx66PmbyrZaznmIZeSMrsDM5PpIqO1jraQx0Ra2jd1c1QpepUSCzWFBw2cObd8J2fQJt8OCUQ1Cwxm82snlW8lcxLZLKrQYr+D8bRt+nRW/Rs85fLaMtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LXRyEqv3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LXRyEqv3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NzdQdDzy9an+ad2ujHM4K87j7IVbsCNSw+/FSI8vDqQ=; b=LXRyEqv3luyRGaNhx9QcZkACii
	0DKvqLDdWONegOg3YmykHdEwYxNA9R2kquCB42nIt6EHrA52otHoe1WjbQaoNFK2aqqtusT/gQeXJ
	JFYkgLHg/zad0zJTzOD3lPUyJ/0d610qpC4N7p+Cca9zrtE0GoEpBhjIy8mxRyWc7WCMe3atU/7aL
	J+ijmZJBfx98iQhq+I1AnO1TilXv/52BDJqbhElR8iF9vCIUpYc4rH2jhdxbgIeCHeuP7o17REHnW
	soR2dy9Jws0Ymq/BznZz1WeI/jfpgBbeA8Qhyx/qceFGgSJybEJf75RNf9waPdG7MwxL/Zokf2XRc
	QvpQTY/A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyvzR-00000009XHS-2xcn;
	Tue, 25 Aug 2026 18:35:17 +0000
Date: Tue, 25 Aug 2026 19:35:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3gZRa7HOEg209P@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <ao1Lo6TKhPcqV42B@pedro-suse>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao1Lo6TKhPcqV42B@pedro-suse>

On Tue, Aug 25, 2026 at 09:25:53AM +0100, Pedro Falcato wrote:
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
> > 
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> > 
> > There's also the problem that GUP users bypass the folio_wait_stable()
> > mechanism.  If a page is written to while somebody is creating a
> > checksum over that page, the checksum will be corrupted.  If we want
> > to fix this, we have to bounce-buffer the page.  There's no way to
> > prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> > 
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> 
> I don't think you can do this for stable writes. It's probably ok for
> !stable writes filesystem stacks, as long as the filesystem & writeback
> can handle making no progress at all. But since stable writes' writeback
> can't race with "writes", I don't think you can Just Do It as long as the
> folio is DMA pinned.

Ah, yes, I forgot to specify that.  For mappings which need stable pages,
we have to bounce buffer them.  I wonder if that's something we should
do inside the VFS or if each filesystem should try to do it itself?

> Perhaps we should give up trying to writeback these folios, and start
> writeback right after they're unpinned? at least on the stable case.

The thing is, what do we do for somebody calling fsync()?  I don't
think that "Oh, sorry, someone gave its address to an RDMA device
so we just didn't bother" is acceptable as an answer.

> >    marked as dirty.
> >  - The MM behaves similarly; we do not clear the writeback flag for
> >    folio_maybe_dma_pinned().
> 
> This sounds like a problem. You don't want users expecting writeback to make
> progress to suddenly stall on e.g folio_wait_writeback() indefinitely.

I should have written "the dirty flag" there.  I do not propose to keep
the writeback flag set indefinitely; it should be cleared after I/O has
completed, as it is now.

> I don't quite understand what your plan for getting rid of dirty_folio,
> et al is. page_mkwrite has the fatal flaw of being directly tied to VM
> page faults; I don't think it's the ideal interface for notifying filesystems.
> It's also the case that page_mkwrite can trivially sleep, and GUP calls it under
> the PTE lock. So how can we replace that? Would callers need to manually dirty
> folios after GUP, in process context?

GUP doesn't call page_mkwrite() under the PTL.  See my reply to John,
or just look at do_page_mkwrite():

 * We do this without the lock held, so that it can sleep if it needs to.
 */
static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)

folio_mark_dirty() is called under the PTE lock.  My point is that (with
the proposed changes) we won't need to call it in zap_present_folio_ptes()
because the filesystem will already know that this page is dirty.
