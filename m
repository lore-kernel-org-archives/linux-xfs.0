Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40930 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbeIGFIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 01:08:23 -0400
Date: Fri, 7 Sep 2018 10:30:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] mkfs: Use AIO for batched writeback
Message-ID: <20180907003016.GK27618@dastard>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-5-david@fromorbit.com>
 <20180906133224.GD3311@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906133224.GD3311@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 06, 2018 at 09:32:24AM -0400, Brian Foster wrote:
> On Wed, Sep 05, 2018 at 06:19:32PM +1000, Dave Chinner wrote:
> > +int
> > +get_write_completions(
> > +	int	threshold)
> > +{
> > +	int	error = 0;
> > +	int	i, r;
> > +
> > +	while (aio_flight > threshold) {
> > +		/* gather up some completions */
> > +		r = io_getevents(ctxp, 1, MAX_AIO_EVENTS, ioevents, NULL);
> > +		if (r < 0)  {
> > +			printf("FAIL! io_getevents returned %d\n", r);
> > +			exit(1);
> > +		}
> > +
> > +		aio_flight -= r;
> > +		for (i = 0; i < r; ++i) {
> > +			struct xfs_buf *bp = ioevents[i].data;
> > +			if (ioevents[i].res < 0)
> > +				bp->b_error = ioevents[i].res;
> > +			else if (ioevents[i].res != bp->b_bcount)
> > +				bp->b_error = -EIO;
> > +
> > +			if (--bp->b_io_count == 0 && !bp->b_error) {
> > +				bp->b_flags |= LIBXFS_B_UPTODATE;
> > +				bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
> > +						 LIBXFS_B_UNCHECKED);
> 
> I'd think we need these flags updates on the submission side
> ->b_io_count decrement as well, but I guess the single-threadedness of
> the whole things dictates that I/O will only ever complete here.

Yup - I made lots of shortcuts and hacks because it is a tight
single threaded AIO dispatch/complete loop.

> 
> Which begs the question.. why elevate ->b_io_count in the delwri submit
> path at all?

So we don't drop the reference to the buffer before we've completed
all the individual IOs on a discontiguous buffer.

> FWIW, I can see writing this consistently either way: take
> the I/O ref and handle completion in both places, or rely on the fact
> that completion occurs in one place and the flush only needs to know if
> the buffer count is still elevated immediately after submission.

Sure, but for a quick and dirty AIO ring implementation like this
that's not needed. Of course, none of this code would make it into a
proper AIO engine implementation, so don't get too hung up on all
the shortcuts and simplifications I've taken in this RFCRAP code
to prove the concept is worth persuing....

> > +				libxfs_putbuf(bp);
> > +			} else if (!error) {
> > +				error = bp->b_error;
> > +			}
> > +		}
> > +		/* wait for a short while */
> > +		usleep(1000);

Like this :P

> > +	}
> > +	return error;
> > +}
> > +
> > +static int
> > +__aio_write(
> > +	struct xfs_buf  *bp,
> > +	void *buf,
> > +	int len,
> > +	off64_t offset)
> > +{
> > +	int	r, i;
> > +	int	fd = libxfs_device_to_fd(bp->b_target->dev);
> > +
> > +	i = aio_next++ % MAX_AIO_EVENTS;
> > +	aio_flight++;
> > +	bp->b_io_count++;
> > +
> > +	io_prep_pwrite(iocbs[i], fd, buf, len, offset);
> > +	iocbs[i]->data = bp;
> > +	r = io_submit(ctxp, 1, &iocbs[i]);
> > +	if (r != 1) {
> > +		aio_flight--;
> 
> Probably need to decrement ->b_io_count here as well..?

Yup, that'd be a bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
