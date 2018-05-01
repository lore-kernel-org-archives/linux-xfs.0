Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752673AbeEALLG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 07:11:06 -0400
Date: Tue, 1 May 2018 07:11:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180501111103.GA3251@bfoster.bfoster>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
 <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
 <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
 <20180430232319.GV23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180430232319.GV23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Tue, May 01, 2018 at 09:23:20AM +1000, Dave Chinner wrote:
> On Mon, Apr 30, 2018 at 05:00:14PM -0600, Jens Axboe wrote:
> > On 4/30/18 4:40 PM, Jens Axboe wrote:
> > > On 4/30/18 4:28 PM, Dave Chinner wrote:
> > >> Yes, it does, but so would having the block layer to throttle device
> > >> discard requests in flight to a queue depth of 1. And then we don't
> > >> have to change XFS at all.
> > > 
> > > I'm perfectly fine with making that change by default, and much easier
> > > for me since I don't have to patch file systems.
> > 
> > Totally untested, but this should do the trick. It ensures we have
> > a QD of 1 (per caller), which should be sufficient.
> > 
> > If people tune down the discard size, then you'll be blocking waiting
> > for discards on issue.
> > 
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index a676084d4740..0bf9befcc863 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -11,16 +11,19 @@
> >  #include "blk.h"
> >  
> >  static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
> > -		gfp_t gfp)
> > +			    gfp_t gfp)
> >  {
> > -	struct bio *new = bio_alloc(gfp, nr_pages);
> > -
> > +	/*
> > +	 * Devices suck at discard, so if we have to break up the bio
> > +	 * size due to the max discard size setting, wait for the
> > +	 * previous one to finish first.
> > +	 */
> >  	if (bio) {
> > -		bio_chain(bio, new);
> > -		submit_bio(bio);
> > +		submit_bio_wait(bio);
> > +		bio_put(bio);
> >  	}
> 
> This only addresses the case where __blkdev_issue_discard() breaks
> up a single large discard, right? It seems like a brute force
> solution, too, because it will do so even when the underlying device
> is idle and there's no need to throttle.
> 

I think the above serializes the discards regardless of whether
__blkdev_issue_discard() splits up a single range itself or the caller
passes discontiguous ranges as part of a single chain.

That said, I agree that it seems brute force. ISTM that this wouldn't
address separate callers causing the same problem (i.e., if the discard
burst doesn't happen to be part of a single chain)...? Alternatively,
what if the discard chain is large but covers a very small range (e.g.,
consider a chain of single block discards, for example)? Given your
previous comments around the size of the range being the determining
factor, would we really want to serialize in that case?

BTW, what happens with submit_bio_wait() if the block device is plugged?
Note that xlog_discard_busy_extents() currently plugs around the discard
bio chain construction.

> Shouldn't the throttling logic at least look at device congestion?
> i.e. if the device is not backlogged, then we should be able to
> issue the discard without problems. 
> 
> I ask this because this only addresses throttling the "discard large
> extent" case when the discard limit is set low. i.e. your exact
> problem case. We know that XFS can issue large numbers of
> discontiguous async discards in a single batch - this patch does not
> address that case and so it will still cause starvation problems.
> 
> If we look at device congestion in determining how to throttle/back
> off during discard issuing, then it doesn't matter what
> max_discard_sectors is set to - it will throttle in all situations
> that cause device overloads and starvations....
> 

Indeed, this all seems more robust to me. TBH, even something more
simple like allowing one discard chain at a time where the chain itself
is size limited (and so puts the onus on the caller a bit to construct
larger chains to trade off for more simple block layer throttling logic)
seems reasonable, but I'm not sure if/how feasible that is (or if it
really is any more simple). Just a thought.

Note that however the implementation, I think that channeling the
backpressure in the form of sync submission has the potential to
reintroduce the filesystem latencies that have been brought up a couple
times in this thread. Unless I'm missing something, I still think there's
value in trying to separate discard submission from log I/O completion
in XFS.

Dave, do you have any fundamental thoughts on that? For example, I'm
wondering if there's any danger in creating a sort of intermediary busy
state between log I/O completion and some time later when a background
wq job or something discards the pending busy extents and removes them
from the pag tree. That actually might open the door for more
interesting optimizations like eliminating the need for certain discards
at all if the assocated blocks are reallocated (after the associated log
I/O completed but before the background discard happened to occur).
Actually, I'm told that explicit reuse of such blocks might be a
significant win for things like VDO (dm dedup), where discards are
apparently extra double ungood. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
