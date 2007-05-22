Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 17:44:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M0iIfB030309
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 17:44:21 -0700
Date: Tue, 22 May 2007 10:44:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070522004414.GL85884050@sgi.com>
References: <20070520233417.GA85884050@sgi.com> <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, May 21, 2007 at 04:34:26PM +1000, Timothy Shimmin wrote:
> Hi,
> 
> Trying to understand how the initialisers prior to the loop
> are used during the loop.
> It looks like the initial "type" isn't used now with this change
> as we always assign to it near to where we access it.

Yes.

> Previously, we did access it in the already mapped case (type != 
> IOMAP_READ).
> So why do we initialise "type" prior to the loop then?

Because it's good practise - it's not obvious that it gets
initialised in all cases within the loop, so lets make sure
that it is....

> The inited "flags" var is 1st accessed in the unmapped/allocated
> codepath to set iomap_valid to zero on BMAPI_READ
> or now also in the other path where it is already mapped.
.....
> Nor sure if there are any ramifications of this but just trying to see 
> differences.

There is no difference in behaviour....

> So, xfs_add_to_ioend() sets up the io completion handlers.
> Previously, we would have set up xfs_end_bio_read (for IOMAP_READ)
> and now we set up xfs_end_bio_written (for IOMAP_NEW).
> xfs_end_bio_written does an xfs_setfilesize(ioend)
> which an xfs_end_bio_read does not.
> Which I guess is the crux of this change and
> that is apparent.

Yes.

> I'm having trouble following the existing code to understand what
> it is currently doing.  So you are better off with a reviewer that
> knows this code (but thought I'd have a look:)

It's not obvious at all, is it?

> We seem to be continually testing for iomap_valid which I believe
> checks whether the offset is within the mapped range.  If the
> offset is not within the mapping then we try mapping the <offset,
> size> and then retest for validity.  So what happens when it is
> not valid even after mapping and why wouldn't it be valid.  I need
> a better understanding of the background code I guess.

The iomap that we get is a mapping of a range that is the same type
as the current bufferhead we are processing. Hence the mapping may
extend much further than the current buffer (e.g. delalloc or
unwritten mapping will extend to the end of the extent). therefore
as we walk each buffer, we need to check that it falls within the
current mapping and if it doesn't we need to map a new range.

We also need to invalidate the mapping if the buffer changes from
a mapped buffer to an unmapped/unwritten/delalloc buffer as we
need to do extra work there....

I guess I need to ping Christoph and Nathan on this one....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
