Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27078 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbeKKLIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 06:08:02 -0500
Date: Sun, 11 Nov 2018 12:20:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181111012057.GK19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181109152218.GI9153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109152218.GI9153@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Nov 09, 2018 at 07:22:18AM -0800, Christoph Hellwig wrote:
> > +	unsigned		bsize =	i_blocksize(mapping->host);
> >  
> >  	/*
> >  	 * Refuse to write pages out if we are called from reclaim context.
> > @@ -922,6 +923,19 @@ xfs_vm_writepages(
> >  	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> >  		return 0;
> >  
> > +	/*
> > +	 * If the block size is larger than page size, extent the incoming write
> > +	 * request to fsb granularity and alignment. This is a requirement for
> > +	 * data integrity operations and it doesn't hurt for other write
> > +	 * operations, so do it unconditionally.
> > +	 */
> > +	if (wbc->range_start)
> > +		wbc->range_start = round_down(wbc->range_start, bsize);
> > +	if (wbc->range_end != LLONG_MAX)
> > +		wbc->range_end = round_up(wbc->range_end, bsize);
> > +	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
> > +		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
> 
> This looks fine to me, but I'd be much more comfortable it we had
> it in the common writeback code instead of inside XFS.

Where in the common code? there's quite a few places that can call
->writepages...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
