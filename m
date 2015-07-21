Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 071B97F77
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 19:37:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D73AB304048
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 17:37:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hg8Hh5aaNnAB2Ibw for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 17:37:17 -0700 (PDT)
Date: Tue, 21 Jul 2015 10:36:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150721003627.GX7943@dastard>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<20150720232057.GH28135@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150720232057.GH28135@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, sandeen@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Mon, Jul 20, 2015 at 07:20:58PM -0400, Mike Snitzer wrote:
> On Mon, Jul 20 2015 at  6:36pm -0400,
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Jul 20, 2015 at 11:18:49AM -0400, Mike Snitzer wrote:
> > > If XFS fails to write metadata it will retry the write indefinitely
> > > (with the hope that the write will succeed at some point in the future).
> > > 
> > > Others can possibly speak to historic reason(s) why this is a sane
> > > default for XFS.  But when XFS is deployed ontop of DM thin provisioning
> > > this infinite retry is very unwelcome -- especially if DM thinp was
> > > configured to be automatically extended with free space but the admin
> > > hasn't provided (or restored) adequate free space.
> > > 
> > > To fix this infinite retry a new bdev_has_space () hook is added to XFS
> > > to break out of its metadata retry loop if the underlying block device
> > > reports it no longer has free space.  DM thin provisioning is now
> > > trained to respond accordingly, which enables XFS to not cause a cascade
> > > of tasks blocked on IO waiting for XFS's infinite retry.
> > > 
> > > All other block devices, which don't implement a .has_space method in
> > > block_device_operations, will always return true for bdev_has_space().
> > > 
> > > With this change XFS will fail the metadata IO, force shutdown, and the
> > > XFS filesystem may be unmounted.  This enables an admin to recover from
> > > their oversight, of not having provided enough free space, without
> > > having to force a hard reset of the system to get XFS to unwedge.
> > > 
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Shouldn't dm-thinp just return the bio with ENOSPC as it's error?
> > The scsi layers already do this for hardware thinp ENOSPC failures,
> > so dm-thinp should behave exactly the same (i.e. via
> > __scsi_error_from_host_byte())
> 
> DM thinp does return -ENOSPC (uniformly so, as of 4.2-rc3 via commit
> bcc696fac1).  Before it was more nuanced, but it would either return
> -ENOSPC or -EIO (transition from -ENOSPC to -EIO was when thinp's
> no_space_timoeut expired).

Right, which meant we couldn't get a reliable ENOSPC detection, so
we just had to retry and hope....

> Anyway, XFS doesn't care what error is returned it'll just keep
> retrying metdata IO indefinitely.

Sure, that's historical behaviour and it's a good default for most
systems. But see here for how we plan to handle this particular
issue of error catergorisation:

http://oss.sgi.com/archives/xfs/2015-02/msg00343.html

BTW, it's not just ENOSPC we need this for - ENOMEM needs the same
configurable behaviour now that the mm subsystem has started
treating GFP_NOFAIL differently to just looping outside the
allocator....

> > The behaviour of the filesystem
> > should be the same in all cases - making it conditional on whether
> > the thinp implementation can be polled for available space is wrong
> > as most hardware thinp can't be polled by the kernel forthis info..
> 
> There isn't an immediate corollary for SCSI no.  I've discussed flagging
> the SCSI block device as out of space when the equivalent HW thinp
> ASC/ASQ is returned from the SCSI target but there isn't an existing way
> to know space was added to reset this state (like is possible with DM
> thinp).
> 
> But in the past you (or others) have claimed that ENOSPC isn't a rich
> enough return to _know_ that it is a hard error.

Yes, I've said that in the past because we haven't had any agreement
on how block devices should report ENOSPC. However, this is slowly
being standardised and I've seen enough people say
"give us a knob to decide that ourselves as we know our hardware"
that means we can rely on ENOSPC on the bio to detect this issue and
handle it appropriately.

> Now you seem to be oscillating away from a richer interface between
> filesystems and the underlying block device to: a simple error code is
> enough.

Once we decided to give users the option to configure block device
error handling, the need for more information from the block device
goes away...

> > If dm-thinp just returns ENOSPC from on the BIO like other hardware
> > thinp devices, then it is up to the filesystem to handle that
> > appropriately.  i.e. whether an ENOSPC IO error is fatal to the
> > filesystem is determined by filesystem configuration and context of
> > the IO error, not whether the block device has no space (which we
> > should already know from the ENOSPC error delivered by IO
> > completion).
> 
> OK, _please_ add that configurability to XFS.  As I think you know, this
> is a long-standing XFS on thinp issue (both DM and HW thinp).

It got stuck on the side of the bikeshed, unfortunately, and then
other stuff got painted on top of it. I'll go uncover it now that
dm-thinp is returning reliable ENOSPC in ENOSPC conditions ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
