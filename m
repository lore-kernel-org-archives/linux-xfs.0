Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47104 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728313AbfAHXN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 18:13:27 -0500
Date: Wed, 9 Jan 2019 10:12:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Broken dio refcounting leads to livelock?
Message-ID: <20190108231255.GY4205@dastard>
References: <20190108002633.GL12689@magnolia>
 <20190108074644.GX4205@dastard>
 <20190108200803.GS12689@magnolia>
 <x49tvii7tvk.fsf@segfault.boston.devel.redhat.com>
 <20190108210716.GV12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108210716.GV12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 08, 2019 at 01:07:16PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 08, 2019 at 03:54:23PM -0500, Jeff Moyer wrote:
> > "Darrick J. Wong" <darrick.wong@oracle.com> writes:
> > 
> > > It looks like we're issuing two bios to satisfy a particular dio.
> > > However, the first bio completes before the submitter calls finish_plug??
> > >
> > > I guess this means that blk_start_plug no longer plugs up io requests,
> > > which means that the end_io function tries to wake up the submitter
> > > before it's even had a chance to issue the second bio.
> > 
> > blk_start_plug was always a hint.  If you exceed a certain number of
> > requests (BLK_MAX_REQUEST_COUNT, which is 16) or a certain size of
> > request (BLK_PLUG_FLUSH_SIZE, which is 128k), the block layer will flush
> > the plug list.
> > 
> > > This is surprising to me, because I was under the impression that
> > > blk_{start,finish}_plug held all the bios so there was no chance that
> > > any of them would issue (let alone call end_io) before finish_plug.
> > 
> > Definitely not the case.  The plug list is just a performance
> > optimization.
> 
> Ahh, fun!  I had not realized that it was merely a suggestion.
> 
> $ git grep blk_start_plug Documentation/
> $ echo $?
> 1
> 
> In that case we definitely need something to prevent the endio from
> trying to wake up a submitter that's still submitting.  Below is the
> amended patch I'm using to run generic/013 and generic/323 in a loop.
> No crashes so far.

Bloody ugly having to take /two/ submission context reference
counts, but....

/me sees this in the block device dio path:

              if (!dio->multi_bio) {
                        /*
                         * AIO needs an extra reference to ensure the dio
                         * structure which is embedded into the first bio
                         * stays around.
                         */
                        if (!is_sync)
                                bio_get(bio);
                        dio->multi_bio = true;
                        atomic_set(&dio->ref, 2);
               } else {
                       atomic_inc(&dio->ref);
               }


This code was derived from the iomap direct IO code, but unlike the
iomap code it takes two references to the first bio in the
submission set and sets a flag to indicate there are multiple
bios in the set. because the extra bio reference is not dropped
until all the IO is completed, the struct dio is valid until
everything is done and it is no longer being referenced.

The other thing to note here is that "dio->ref" is actually an "io
remaining" counter, and it is /pre-incremented/. That is, when we
submit the first bio, the ref count is set to 2 so that if the IO
completes before the second bio is submitted the count will not go
to zero and the IO won't be completed.

So, this is /quite different/ to the iomap code it was derived from.
i.e. dio->ref is an IO counter, not a structure lifetime controller,
and the struct dio lifetime is handled by a bio reference counter
rather than an internal counter. That makes a bunch of stuff much
simpler.

OK, I'll rework the patch with this in mind....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
