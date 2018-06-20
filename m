Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45373 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753774AbeFTI0w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:26:52 -0400
Date: Wed, 20 Jun 2018 09:56:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180620075655.GA2668@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-24-hch@lst.de> <20180619165211.GD2806@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619165211.GD2806@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 19, 2018 at 12:52:11PM -0400, Brian Foster wrote:
> > +	/*
> > +	 * Move the caller beyond our range so that it keeps making progress.
> > +	 * For that we have to include any leading non-uptodate ranges, but
> 
> Do you mean "leading uptodate ranges" here? E.g., pos is pushed forward
> past those ranges we don't have to read, so (pos - orig_pos) reflects
> the initial uptodate range while plen reflects the length we have to
> read..?

Yes.

> > +
> > +	do {
> 
> Kind of a nit, but this catches my eye and manages to confuse me every
> time I look at it. A comment along the lines of:
> 
>                 /*
> 		 * Pass in the block aligned start/end so we get back block
> 		 * aligned/adjusted poff/plen and can compare with unaligned
> 		 * from/to below.
>                  */
> 
> ... would be nice here, IMO.

Fine with me.

> > +		iomap_adjust_read_range(inode, iop, &block_start,
> > +				block_end - block_start, &poff, &plen);
> > +		if (plen == 0)
> > +			break;
> > +
> > +		if ((from > poff && from < poff + plen) ||
> > +		    (to > poff && to < poff + plen)) {
> > +			status = iomap_read_page_sync(inode, block_start, page,
> > +					poff, plen, from, to, iomap);
> 
> After taking another look at the buffer head path, it does look like we
> have slightly different behavior here. IIUC, the former reads only the
> !uptodate blocks that fall along the from/to boundaries. Here, if say
> from = 1, to = PAGE_SIZE and the page is fully !uptodate, it looks like
> we'd read the entire page worth of blocks (assuming contiguous 512b
> blocks, for example). Intentional? Doesn't seem like a big deal, but
> could be worth a followup fix.

It wasn't actuall intentional, but I actually think it is the right thing
in then end, as it means we'll often do a single read instead of two
separate ones.
