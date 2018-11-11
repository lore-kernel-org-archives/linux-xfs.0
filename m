Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:12224 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbeKKK7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 05:59:00 -0500
Date: Sun, 11 Nov 2018 12:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/16] iomap: support block size > page size for direct IO
Message-ID: <20181111011201.GI19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-7-david@fromorbit.com>
 <20181109151819.GF9153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109151819.GF9153@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Nov 09, 2018 at 07:18:19AM -0800, Christoph Hellwig wrote:
> >  static blk_qc_t
> >  iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
> >  		unsigned len)
> >  {
> >  	struct page *page = ZERO_PAGE(0);
> >  	struct bio *bio;
> > +	int npages = howmany(len, PAGE_SIZE);
> > +
> > +	WARN_ON_ONCE(npages > 16);
> 
> Where does this magic 16 come from?

4k page size, 64k block size. Debug code, essentially.

> > +	WARN_ON(len != 0);
> 
> WARN_ON_ONCE please to avoid making the log unreadable if it ever
> triggers.

Debug code, too, so it'll get removed eventually.

> > +/*
> > + * This is lifted almost straight from xfs_flush_unmap_range(). Need a generic
> > + * version of the block size rounding for these purposes.
> > + */
> 
> Can you just add a generic version of this in a separate patch and
> also switch XFS over to it?

Well, they do different things. The xfs code must truncate the page
cache over the range (because we are removing the underlying
storage) while this just attempts to invalidate the pages and simply
says "have a nice day" if it fails. 

So they really are two different functions. The comment was written
when I expected that I was going to need to do lots more block size
rounding for invalidation in the generic code., but it seems that
may actually not be necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
