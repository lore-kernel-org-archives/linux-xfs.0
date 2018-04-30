Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753410AbeD3TSD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 15:18:03 -0400
Date: Mon, 30 Apr 2018 15:18:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180430191801.GC22176@bfoster.bfoster>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430171945.GB22176@bfoster.bfoster>
 <24df628d-c861-6f39-96a8-d759902d1fe3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24df628d-c861-6f39-96a8-d759902d1fe3@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Mon, Apr 30, 2018 at 12:07:31PM -0600, Jens Axboe wrote:
> On 4/30/18 11:19 AM, Brian Foster wrote:
> > On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
> >> XFS recently added support for async discards. While this can be
> >> a win for some workloads and devices, there are also cases where
> >> async bursty discard will severly harm the latencies of reads
> >> and writes.
> >>
> >> Add a 'discard_sync' mount flag to revert to using sync discard,
> >> issuing them one at the time and waiting for each one. This fixes
> >> a big performance regression we had moving to kernels that include
> >> the XFS async discard support.
> >>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> > 
> > Hm, I figured the async discard stuff would have been a pretty clear win
> > all around, but then again I'm not terribly familiar with what happens
> > with discards beneath the fs. I do know that the previous behavior would
> > cause fs level latencies due to holding up log I/O completion while
> > discards completed one at a time. My understanding is that this lead to
> > online discard being pretty much universally "not recommended" in favor
> > of fstrim.
> 
> It's not a secret that most devices suck at discard. While the async
> discard is nifty and I bet works well for some cases, it can also cause
> a flood of discards on the device side which does not work well for
> other cases.
> 

Heh, Ok.

> > Do you have any more data around the workload where the old sync discard
> > behavior actually provides an overall win over the newer behavior? Is it
> > purely a matter of workload, or is it a workload+device thing with how
> > discards may be handled by certain devices?
> 
> The worse read latencies were observed on more than one device type,
> making it sync again was universally a win. We've had many issues
> with discard, one trick that is often used is to chop up file deletion
> into smaller chunks. Say you want to kill 10GB of data, you do it
> incrementally, since 10G of discard usually doesn't behave very nicely.
> If you make that async, then you're back to square one.
> 

Makes sense, so there's not much win in chopping up huge discard ranges
into smaller, async requests that cover the same overall size/range..

> > I'm ultimately not against doing this if it's useful for somebody and is
> > otherwise buried under a mount option, but it would be nice to see if
> > there's opportunity to improve the async mechanism before resorting to
> > that. Is the issue here too large bio chains, too many chains at once,
> > or just simply too many discards (regardless of chaining) at the same
> > time?
> 
> Well, ultimately you'd need better scheduling of the discards, but for
> most devices what really works the best is a simple "just do one at
> the time". The size constraint was added to further limit the impact.
> 

... but presumably there is some value in submitting some number of
requests together provided they adhere to some size constraint..? Is
there a typical size constraint for the average ssd, or is this value
all over the place? (Is there a field somewhere in the bdev that the fs
can query?)

(I guess I'll defer to Christoph's input on this, I assume he measured
some kind of improvement in the previous async work..)

> Honestly, I think the only real improvement would be on the device
> side. Most folks want discard as an advisory hint, and it should not
> impact current workloads at all. In reality, many implementations
> are much more strict and even include substantial flash writes. For
> the cases where we can't just turn it off (I'd love to), we at least
> need to make it less intrusive.
> 
> > I'm wondering if xfs could separate discard submission from log I/O
> > completion entirely and then perhaps limit/throttle submission somehow
> > or another (Christoph, thoughts?) via a background task. Perhaps doing
> > something like that may even eliminate the need for some discards on
> > busy filesystems with a lot of block free -> reallocation activity, but
> > I'm just handwaving atm.
> 
> Just having the sync vs async option is the best split imho. The async
> could potentially be scheduled. I don't think more involved logic
> belongs in the fs.
> 

The more interesting part to me is whether we can safely separate
discard from log I/O completion in XFS. Then we can release the log
buffer locks and whatnot and let the fs proceed without waiting on any
number of discards to complete. In theory, I think the background task
could issue discards one at a time (or N at a time, or N blocks at a
time, whatever..) without putting us back in a place where discards hold
up the log and subsequently lock up the rest of the fs.

If that's possible, then the whole sync/async thing is more of an
implementation detail and we have no need for separate mount options for
users to try and grok.

Brian

> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
