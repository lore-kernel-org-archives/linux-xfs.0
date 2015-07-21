Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 085DF7F95
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 12:47:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21248F8049
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 10:47:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h6H1n4AUywAS2xCa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 10:47:55 -0700 (PDT)
Date: Tue, 21 Jul 2015 13:47:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150721174753.GA8563@redhat.com>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<55AE6670.40903@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55AE6670.40903@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jul 21 2015 at 11:34am -0400,
Eric Sandeen <sandeen@redhat.com> wrote:

> On 7/20/15 5:36 PM, Dave Chinner wrote:
> > On Mon, Jul 20, 2015 at 11:18:49AM -0400, Mike Snitzer wrote:
> >> If XFS fails to write metadata it will retry the write indefinitely
> >> (with the hope that the write will succeed at some point in the future).
> >>
> >> Others can possibly speak to historic reason(s) why this is a sane
> >> default for XFS.  But when XFS is deployed ontop of DM thin provisioning
> >> this infinite retry is very unwelcome -- especially if DM thinp was
> >> configured to be automatically extended with free space but the admin
> >> hasn't provided (or restored) adequate free space.
> >>
> >> To fix this infinite retry a new bdev_has_space () hook is added to XFS
> >> to break out of its metadata retry loop if the underlying block device
> >> reports it no longer has free space.  DM thin provisioning is now
> >> trained to respond accordingly, which enables XFS to not cause a cascade
> >> of tasks blocked on IO waiting for XFS's infinite retry.
> >>
> >> All other block devices, which don't implement a .has_space method in
> >> block_device_operations, will always return true for bdev_has_space().
> >>
> >> With this change XFS will fail the metadata IO, force shutdown, and the
> >> XFS filesystem may be unmounted.  This enables an admin to recover from
> >> their oversight, of not having provided enough free space, without
> >> having to force a hard reset of the system to get XFS to unwedge.
> >>
> >> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Shouldn't dm-thinp just return the bio with ENOSPC as it's error?
> > The scsi layers already do this for hardware thinp ENOSPC failures,
> > so dm-thinp should behave exactly the same (i.e. via
> > __scsi_error_from_host_byte()). The behaviour of the filesystem
> > should be the same in all cases - making it conditional on whether
> > the thinp implementation can be polled for available space is wrong
> > as most hardware thinp can't be polled by the kernel forthis info..
> > 
> > 
> > If dm-thinp just returns ENOSPC from on the BIO like other hardware
> > thinp devices, then it is up to the filesystem to handle that
> > appropriately.  i.e. whether an ENOSPC IO error is fatal to the
> > filesystem is determined by filesystem configuration and context of
> > the IO error, not whether the block device has no space (which we
> > should already know from the ENOSPC error delivered by IO
> > completion).
> 
> The issue we had discussed previously is that there is no agreement
> across block devices about whether ENOSPC is a permanent or temporary
> condition.  Asking the admin to tune  the fs to each block device's
> behavior sucks, IMHO.

It does suck, but it beats the alternative of XFS continuing to do
nothing about the problem.

Disucssing more with Vivek, might be that XFS would be best served to
model what dm-thinp has provided with its 'no_space_timeout'.  It
defaults to queueing IO for 60 seconds, once the timeout expires the
queued IOs getted errored.  If set to 0 dm-thinp will queue IO
indefinitely.

So for XFS's use-case: s/queue/retry/

> This interface could at least be defined to reflect a permanent and
> unambiguous state...

The proposed bdev_has_space() interface enabled XFS to defer to the
block device.  But it obviously doesn't help at all if the blockdevice
isn't providing a .has_space method -- so I can see value in XFS
having something like a 'no_space_timeout' knob.

But something needs to happen.  No more bike-shedding allowed on this
one.. PLEASE DO SOMETHING! :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
