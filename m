Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C17B57F74
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 18:21:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 470CBAC005
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 16:21:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lsNU5uNTDEFxC1Bf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 16:21:00 -0700 (PDT)
Date: Mon, 20 Jul 2015 19:20:58 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150720232057.GH28135@redhat.com>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150720223610.GV7943@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, sandeen@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Mon, Jul 20 2015 at  6:36pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jul 20, 2015 at 11:18:49AM -0400, Mike Snitzer wrote:
> > If XFS fails to write metadata it will retry the write indefinitely
> > (with the hope that the write will succeed at some point in the future).
> > 
> > Others can possibly speak to historic reason(s) why this is a sane
> > default for XFS.  But when XFS is deployed ontop of DM thin provisioning
> > this infinite retry is very unwelcome -- especially if DM thinp was
> > configured to be automatically extended with free space but the admin
> > hasn't provided (or restored) adequate free space.
> > 
> > To fix this infinite retry a new bdev_has_space () hook is added to XFS
> > to break out of its metadata retry loop if the underlying block device
> > reports it no longer has free space.  DM thin provisioning is now
> > trained to respond accordingly, which enables XFS to not cause a cascade
> > of tasks blocked on IO waiting for XFS's infinite retry.
> > 
> > All other block devices, which don't implement a .has_space method in
> > block_device_operations, will always return true for bdev_has_space().
> > 
> > With this change XFS will fail the metadata IO, force shutdown, and the
> > XFS filesystem may be unmounted.  This enables an admin to recover from
> > their oversight, of not having provided enough free space, without
> > having to force a hard reset of the system to get XFS to unwedge.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Shouldn't dm-thinp just return the bio with ENOSPC as it's error?
> The scsi layers already do this for hardware thinp ENOSPC failures,
> so dm-thinp should behave exactly the same (i.e. via
> __scsi_error_from_host_byte())

DM thinp does return -ENOSPC (uniformly so, as of 4.2-rc3 via commit
bcc696fac1).  Before it was more nuanced, but it would either return
-ENOSPC or -EIO (transition from -ENOSPC to -EIO was when thinp's
no_space_timoeut expired).

Anyway, XFS doesn't care what error is returned it'll just keep
retrying metdata IO indefinitely.

> The behaviour of the filesystem
> should be the same in all cases - making it conditional on whether
> the thinp implementation can be polled for available space is wrong
> as most hardware thinp can't be polled by the kernel forthis info..

There isn't an immediate corollary for SCSI no.  I've discussed flagging
the SCSI block device as out of space when the equivalent HW thinp
ASC/ASQ is returned from the SCSI target but there isn't an existing way
to know space was added to reset this state (like is possible with DM
thinp).

But in the past you (or others) have claimed that ENOSPC isn't a rich
enough return to _know_ that it is a hard error.

Now you seem to be oscillating away from a richer interface between
filesystems and the underlying block device to: a simple error code is
enough.

> If dm-thinp just returns ENOSPC from on the BIO like other hardware
> thinp devices, then it is up to the filesystem to handle that
> appropriately.  i.e. whether an ENOSPC IO error is fatal to the
> filesystem is determined by filesystem configuration and context of
> the IO error, not whether the block device has no space (which we
> should already know from the ENOSPC error delivered by IO
> completion).

OK, _please_ add that configurability to XFS.  As I think you know, this
is a long-standing XFS on thinp issue (both DM and HW thinp).

Mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
