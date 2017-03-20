Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53881 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754960AbdCTRdi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Mar 2017 13:33:38 -0400
Date: Mon, 20 Mar 2017 18:33:12 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170320173312.GA10436@quack2.suse.cz>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
 <20170316213134.GV17542@dastard>
 <045e06ce-ac19-6293-a62b-8ac937f753ac@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <045e06ce-ac19-6293-a62b-8ac937f753ac@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org

On Fri 17-03-17 07:23:24, Goldwyn Rodrigues wrote:
> On 03/16/2017 04:31 PM, Dave Chinner wrote:
> > On Wed, Mar 15, 2017 at 04:51:04PM -0500, Goldwyn Rodrigues wrote:
> >> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >>
> >> A new flag BIO_NOWAIT is introduced to identify bio's
> >> orignating from iocb with IOCB_NOWAIT. This flag indicates
> >> to return immediately if a request cannot be made instead
> >> of retrying.
> > 
> > So this makes a congested block device run the bio IO completion
> > callback with an -EAGAIN error present? Are all the filesystem
> > direct IO submission and completion routines OK with that? i.e. does
> > such a congestion case cause filesystems to temporarily expose stale
> > data to unprivileged users when the IO is requeued in this way?
> > 
> > e.g. filesystem does allocation without blocking, submits bio,
> > device is congested, runs IO completion with error, so nothing
> > written to allocated blocks, write gets queued, so other read
> > comes in while the write is queued, reads data from uninitialised
> > blocks that were allocated during the write....
> > 
> > Seems kinda problematic to me to have a undocumented design
> > constraint (i.e a landmine) where we submit the AIO only to have it
> > error out and then expect the filesystem to do something special and
> > different /without blocking/ on EAGAIN.
> 
> If the filesystems has to perform block allocation, we would return
> -EAGAIN early enough. However, I agree there is a problem, since not all
> filesystems know this. I worked on only three of them.

So Dave has a good point about the missing documentation explaining the
expectation from the filesystem. Other than that the filesystem is
responsible for determining in its direct IO submission routine whether it
can deal with NOWAIT direct IO without blocking (including backing out of
block layer refuses to do the IO) and if not, just return with EAGAIN right
away.

Probably we should also have a feature flag in filesystem_type telling
whether a particular filesystem knows about NOWAIT direct IO at all so that
we don't have to add stub to each and every filesystem supporting direct IO
that returns EAGAIN when NOWAIT is set (OTOH adding that stub won't be that
hard either since there are not *that* many filesystems supporting direct
IO). But one or the other has to be done.

> > Why isn't the congestion check at a higher layer like we do for page
> > cache readahead? i.e. using the bdi*congested() API at the time we
> > are doing all the other filesystem blocking checks.
> > 
> 
> Yes, that may work better. We will have to call bdi_read_congested() on
> a write path. (will have to comment that part of the code). Would it
> encompass all possible waits in the block layer?

Congestion mechanism is not really reliable. The bdi can show the device is
not congested but block layer will still block you waiting for some
resource. And for some of the stuff like tag allocation you cannot really
do a reliable check in advance so I don't think congestion checks are
really a viable alternative.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
