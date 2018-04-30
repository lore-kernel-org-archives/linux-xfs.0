Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32105 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753482AbeD3W2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 18:28:55 -0400
Date: Tue, 1 May 2018 08:28:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180430222852.GF13766@dastard>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Mon, Apr 30, 2018 at 03:42:11PM -0600, Jens Axboe wrote:
> On 4/30/18 3:31 PM, Dave Chinner wrote:
> > On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
> >> XFS recently added support for async discards. While this can be
> >> a win for some workloads and devices, there are also cases where
> >> async bursty discard will severly harm the latencies of reads
> >> and writes.
> > 
> > FWIW, convention is it document the performance regression in the
> > commit message, not leave the reader to guess at what it was....
> 
> Yeah I'll give you that, I can improve the commit message for sure.
> 
> > Did anyone analyse the pattern of discards being issued to work out
> > what pattern was worse for async vs sync discard? is it lots of
> > little discards, large extents being discarded, perhaps a problem
> > with the request request queue starving other IOs because we queue
> > so many async discards in such a short time (which is the difference
> > in behaviour vs the old code), or something else?
> 
> What was observed was a big discard which would previously have
> gone down as smaller discards now going down as either one or many
> discards. Looking at the blktrace data, it's the difference between
> 
> discard 1 queue
> discard 1 complete
> discatd 2 queue
> discard 2 complete
> [...]
> discard n queue
> discard n complete
> 
> which is now
> 
> discard 1 queue
> discard 2 queue
> [...]
> discard n queue
> [...]
> discard 1 complete
> discard 2 complete
> [...]
> discard n complete
> 
> Note that we set a max discard size of 64MB for most devices,
> since it's been shown to have less impact on latencies for
> the IO that jobs actually care about.

IOWs, this has nothing to do with XFS behaviour, and everything to
do with suboptimal scheduling control for concurrent queued discards
in the block layer....

XFS can issue discard requests of up to 8GB (on 4k block size
filesystems), and how they are optimised is completely up to the
block layer. blkdev_issue_discard() happens to be synchronous (for
historical reasons) and that does not match our asynchronous log IO
model. it's always been a cause of total filesystem stall problems
for XFS because we can't free log space until all the pending
discards have been issued. Hence we can see global filesystems
stalls of *minutes* with synchronous discards on bad devices and can
cause OOM and all sorts of other nasty cascading failures.

Async discard dispatch solves this problem for XFS - discards no
longer block forward journal progress, and we really don't want to
go back to having that ticking timebomb in XFS. Handling concurrent
discard requests in an optimal manner is not a filesystem problem -
it's an IO scheduling problem.


Essentially, we've exposed yet another limitation of the block/IO
layer handling of discard requests in the linux storage stack - it
does not have a configurable discard queue depth.

I'd much prefer these problems get handled at the IO scheduling
layer where there is visibulity of device capabilities and request
queue state. i.e. we should be throttling async discards just like
we can throttle read or write IO, especially given there are many
devices that serialise discards at the device level (i.e. not queued
device commands). This solves the problem for everyone and makes
things much better for the future where hardware implementations are
likely to get better and support more and more concurrency in
discard operations.

IMO, the way the high level code dispatches discard requests is
irrelevant here - this is a problem to do with queue depth and IO
scheduling/throttling. That's why I don't think adding permanent ABI
changes to filesystems to work around this problem is the right
solution....

> > I don't think we should be changing anything - adding an opaque,
> > user-unfriendly mount option does nothing to address the underlying
> > problem - it's just a hack to work around the symptoms being seen...
> > 
> > More details of the regression and the root cause analysis is
> > needed, please.
> 
> It brings back the same behavior as we had before, which performs
> better for us. It's preventing users of XFS+discard from upgrading,
> which is sad.

Yes, it does, but so would having the block layer to throttle device
discard requests in flight to a queue depth of 1. And then we don't
have to change XFS at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
