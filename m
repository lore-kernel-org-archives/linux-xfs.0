Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47136 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbeE1Gog (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 May 2018 02:44:36 -0400
Date: Mon, 28 May 2018 08:50:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180528065037.GA4849@lst.de>
References: <20180523144646.19159-1-hch@lst.de> <20180523144646.19159-2-hch@lst.de> <20180525171701.GA92502@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525171701.GA92502@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Fri, May 25, 2018 at 01:17:02PM -0400, Brian Foster wrote:
> > +static struct iomap_page *
> > +iomap_page_create(struct inode *inode, struct page *page)
> > +{
> > +	struct iomap_page *iop = to_iomap_page(page);
> > +
> > +	if (iop || i_blocksize(inode) == PAGE_SIZE)
> > +		return iop;
> > +
> > +	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
> > +	atomic_set(&iop->read_count, 0);
> > +	atomic_set(&iop->write_count, 0);
> > +	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
> > +	set_page_private(page, (unsigned long)iop);
> > +	SetPagePrivate(page);
> 
> The buffer head implementation does a get/put page when the private
> state is set. I'm not quite sure why that is tbh, but do you know
> whether we need that here or not?

I don't really see any good reason why that would be needed, as we need
a successfull ->releasepage return to drop the page from the page cache.
I'll look around a little more if there is any other reason for it -
adding get/put page pair here would be easy to do, so maybe we should just
cargo-cult it in to be on the safe side.

> > -	return plen;
> > +	return pos - orig_pos + plen;
> 
> A brief comment here (or above the adjust_read_range() call) to explain
> the final length calculation would be helpful. E.g., it looks like
> leading uptodate blocks are part of the read while trailing uptodate
> blocks can be truncated by the above call.

Ok.

> > +int
> > +iomap_is_partially_uptodate(struct page *page, unsigned long from,
> > +		unsigned long count)
> > +{
> > +	struct iomap_page *iop = to_iomap_page(page);
> > +	struct inode *inode = page->mapping->host;
> > +	unsigned first = from >> inode->i_blkbits;
> > +	unsigned last = (from + count - 1) >> inode->i_blkbits;
> > +	unsigned i;
> > +
> 
> block_is_partially_uptodate() has this check:
> 
>         if (from < blocksize && to > PAGE_SIZE - blocksize)
>                 return 0;
> 
> ... which looks like it checks that the range is actually partial wrt to
> block size. The only callers check the page first, but I'm still not
> sure why it returns 0 in that case. Any idea?

The calling convention is generally pretty insane.  I plan to clean
this up, but didn't want to grow my XFS-related series even more.

> > +{
> > +	/*
> > +	 * If we are invalidating the entire page, clear the dirty state from it
> > +	 * and release it to avoid unnecessary buildup of the LRU.
> > +	 */
> > +	if (offset == 0 && len == PAGE_SIZE) {
> > +		cancel_dirty_page(page);
> > +		iomap_releasepage(page, GFP_NOIO);
> 
> Seems like this should probably be calling ->releasepage().

Not really.  I don't want the fs in the loop here.  My other option
was to have a iomap_page_free helper called here and in ->releasepage.
Maybe I'll move back to that is it is less confusing.

> > @@ -333,6 +529,7 @@ static int
> >  __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
> >  		struct page *page, struct iomap *iomap)
> >  {
> > +	struct iomap_page *iop = iomap_page_create(inode, page);
> >  	loff_t block_size = i_blocksize(inode);
> >  	loff_t block_start = pos & ~(block_size - 1);
> >  	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
> > @@ -340,15 +537,29 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
> >  	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, block_end - block_start);
> 
> poff/plen are now initialized here and in iomap_adjust_read_range().
> Perhaps drop this one so the semantic of these being set by the latter
> is a bit more clear?

Yes, will do.

> > +
> > +	do {
> > +		iomap_adjust_read_range(inode, iop, &block_start,
> > +				block_end - block_start, &poff, &plen);
> > +		if (plen == 0)
> > +			break;
> > +
> > +		if ((from > poff && from < poff + plen) ||
> > +		    (to > poff && to < poff + plen)) {
> > +			status = iomap_read_page_sync(inode, block_start, page,
> > +					poff, plen, from, to, iomap);
> > +			if (status)
> > +				return status;
> > +		}
> > +
> > +		block_start += plen;
> > +	} while (poff + plen < PAGE_SIZE);
> 
> Something like while (block_start < block_end) would seem a bit more
> clear here as well.

I'll look into it.
