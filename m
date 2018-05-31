Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36461 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbeEaGGu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 02:06:50 -0400
Date: Thu, 31 May 2018 08:13:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/13] iomap: add an iomap-based readpage and readpages
        implementation
Message-ID: <20180531061315.GB31350@lst.de>
References: <20180530095813.31245-1-hch@lst.de> <20180530095813.31245-12-hch@lst.de> <20180530234557.GI10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530234557.GI10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu, May 31, 2018 at 09:45:57AM +1000, Dave Chinner wrote:
> sentence ends with a ".". :)

Ok.  This was intended to point to the WARN_ON calls below, but a "."
is fine with me, too.

> 
> > +	WARN_ON_ONCE(pos != page_offset(page));
> > +	WARN_ON_ONCE(plen != PAGE_SIZE);
> > +
> > +	if (iomap->type != IOMAP_MAPPED || pos >= i_size_read(inode)) {
> 
> In what situation do we get a read request completely beyond EOF?
> (comment, please!)

This is generally to cover a racing read beyond EOF.  That being said
I'd have to look up if it can really happen for blocksize == pagesize.

All this becomes moot once small block size support is added, so I think
I'd rather skip the comment and research here for now.

> > +	if (ctx.bio) {
> > +		submit_bio(ctx.bio);
> > +		WARN_ON_ONCE(!ctx.cur_page_in_bio);
> > +	} else {
> > +		WARN_ON_ONCE(ctx.cur_page_in_bio);
> > +		unlock_page(page);
> > +	}
> > +	return 0;
> 
> Hmmm. If we had an error from iomap_apply, shouldn't we be returning
> it here instead just throwing it away? some ->readpage callers
> appear to ignore the PageError() state on return but do expect
> errors to be returned.

Both mpage_readpage and block_read_full_page always return 0, so for
now I'd like to stay compatible to them.  Might be worth a full audit
later.

> > +	loff_t pos = page_offset(list_entry(pages->prev, struct page, lru));
> > +	loff_t last = page_offset(list_entry(pages->next, struct page, lru));
> > +	loff_t length = last - pos + PAGE_SIZE, ret = 0;
> 
> Two lines, please.

I really like it that way, though..

> > +done:
> > +	if (ctx.bio)
> > +		submit_bio(ctx.bio);
> > +	if (ctx.cur_page) {
> > +		if (!ctx.cur_page_in_bio)
> > +			unlock_page(ctx.cur_page);
> > +		put_page(ctx.cur_page);
> > +	}
> > +	WARN_ON_ONCE(!ret && !list_empty(ctx.pages));
> 
> What error condition is this warning about?

Not finishing all pages without an error.  Which wasn't too hard to get
wrong given the arance readpages calling convention.
