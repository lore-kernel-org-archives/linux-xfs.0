Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbeKLCV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 21:21:27 -0500
Date: Sun, 11 Nov 2018 08:32:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181111163227.GA8714@infradead.org>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181109152218.GI9153@infradead.org>
 <20181111012057.GK19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181111012057.GK19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Nov 11, 2018 at 12:20:57PM +1100, Dave Chinner wrote:
> > > +	if (wbc->range_start)
> > > +		wbc->range_start = round_down(wbc->range_start, bsize);
> > > +	if (wbc->range_end != LLONG_MAX)
> > > +		wbc->range_end = round_up(wbc->range_end, bsize);
> > > +	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
> > > +		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
> > 
> > This looks fine to me, but I'd be much more comfortable it we had
> > it in the common writeback code instead of inside XFS.
> 
> Where in the common code? there's quite a few places that can call
> ->writepages...

As far as I can tell the only place calling ->writepages is
do_writepages, which sounds like the right place to me.  Maybe
conditional on a block size > page size to reduce the scare factor.
