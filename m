Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44591 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbeJFG2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 02:28:13 -0400
Date: Sat, 6 Oct 2018 09:27:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Message-ID: <20181005232710.GH12041@dastard>
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
 <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
 <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ilya Dryomov <idryomov@gmail.com>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On Fri, Oct 05, 2018 at 08:51:59AM -0500, Eric Sandeen wrote:
> On 10/5/18 6:27 AM, Ilya Dryomov wrote:
> > On Fri, Oct 5, 2018 at 12:29 AM Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
> >>> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
> >>>> rbd devices report the following geometry:
> >>>>
> >>>>   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
> >>>>   512
> >>>>   512
> >>>>   4194304
> >>>>   4194304
> >>
> >> dm-thinp does this as well. THis is from the thinp device created
> >> by tests/generic/459:
> >>
> >> 512
> >> 4096
> >> 65536
> >> 65536
> > 
> > (adding Mike)
> > 
> > ... and that 300M filesystem ends up with 8 AGs, when normally you get
> > 4 AGs for anything less than 4T.  Is that really intended?
> 
> Well, yes.  Multi-disk mode gives you more AGs, how many more is scaled
> by fs size.
> 
>         /*
>          * For the multidisk configs we choose an AG count based on the number
>          * of data blocks available, trying to keep the number of AGs higher
>          * than the single disk configurations. This makes the assumption that
>          * larger filesystems have more parallelism available to them.
>          */
> 
> For really tiny filesystems we cut down the number of AGs, but in general
> if the storage "told" us it has parallelism, mkfs uses it by default.

We only keep the number of AGs down on single disks because of the
seek penalty it causes spinning disks. It's a trade off between
parallelism and seek time.

> > AFAIK dm-thinp reports these values for the same exact reason as rbd:
> > we are passing up the information about the efficient I/O size.  In the
> > case of dm-thinp, this is the thinp block size.  If you put dm-thinp on
> > top of a RAID array, I suspect it would pass up the array's preferred
> > sizes, as long as they are a proper factor of the thinp block size.

dm-thinp is passing up it's allocation chunk size, not the
underlying device geometry. dm-thinp might be tuning it's chunk size
to match the underlying storage, but that's irrelevant to XFS.

That's because dm-thinp is a virtual mapping device in the same way
the OS provides virtually mapped memory to users. That it, there is
no relationship between the block device address space index and the
location on disk. Hence the seek times between different regions of
the block device address space are not linear or predictable. 

Hence dm-thinp completely changes the parallelism vs seek time
trade-off the filesystem layout makes.  We can't optimise for
minimal seek time anymore because we don't know the physical layout
of the storage, so all we care about is alignment to the block
device chunk size.

i.e. what we want to do is give dm-thinp IO that is optimal (e.g.
large aligned writes for streaming IO) and we don't want to leave
lots of little unused holes in the dmthinp mapping that waste space.
To do this, we need to ensure minimal allocator contention occurs,
and hence we allow more concurrency in allocation by inreasing the
AG count, knowing that we can't make the seek time problem any worse
by doing this.

i.e. we're not using sunit/swidth on dm-thinp to optimise physical
device layout. We're using it to optimise for contiguous space usage
and minimise the allocation load on dm-thinp. Optimising the layout
for physical storage is dm-thinp's problem, not ours.

> >> And I've also seen some hardware raid controllers do this, too,
> >> because they only expose the stripe width in their enquiry page
> >> rather than stripe unit and stripe width.
> 
> (which should be considered semi broken hardware, no?)

Yes. That should be fixed by the vendor or with mkfs CLI options.
We're not going to change default beahviour to cater for broken
hardware.

> >> IOWs, this behaviour isn't really specific to Ceph's rbd device, and
> >> it does occur on multi-disk devices that have something layered over
> >> the top (dm-thinp, hardware raid, etc). As such, I don't think
> >> there's a "one size fits all" solution and so someone is going to
> >> have to tweak mkfs settings to have it do the right thing for their
> >> storage subsystem....
> > 
> > FWIW I was surprised to see that calc_default_ag_geometry() doesn't
> > look at swidth and just assumes that there will be "more parallelism
> > available".  I expected it to be based on swidth to sunit ratio (i.e.
> > sw).  sw is supposed to be the multiplier equal to the number of
> > data-bearing disks, so it's the first thing that comes to mind for
> > a parallelism estimate.
> > 
> > I'd argue that hardware RAID administrators are much more likely to pay
> > attention to the output of mkfs.xfs and be able to tweak the settings
> > to work around broken controllers that only expose stripe width.
> 
> Yeah, this starts to get a little philosophical.  We don't want to second
> guess geometry or try to figure out what the raid array "really meant" if
> it's sending weird numbers. [1]
> 
> But at the end of the day, it seems reasonable to always apply the
> "swidth/sunit = number of data disks" rule  (which we apply in reverse when
> we tell people how to manually figure out stripe widths) and stop treating
> sunit==swidth as any indication of parallelism.

But swidth/sunit does not mean "number of data disks".

They represent a pair of alignment constraints that indicate how we
should align larger objects during allocation. Small objects are
filesystem block aligned, objects larger than "sunit" are sunit
aligned, and objects larger than swidth are swidth aligned if the
swalloc mount option is used.

These are /generic/ alignment characteristics. While they were
originally derived from RAID characteristics, they have far wider
scope of use than just for configuring RAID devices. e.g. thinp,
exposing image file extent size hints as filesystem allocation
alignments similar to thinp, selecting what aspect of a multi-level
stacked RAID made up of hundreds of disks the filesystem should
align to, aligning to internal SSD structures (be it raid, erase
page sizes, etc), optimising for OSD block sizes, remote replication
block size constraints, helping DAX align allocations to huge page
sizes, etc.

My point is that just looking at sunit/swidth as "the number of data
disks" completely ignores the many other uses we've found for it
over the last 20 years. In that time, it's almost always been the
case that devices requiring alignment have not been bound by the
seek time constraints of a single spinning spindle, and the default
behaviour reflects that.

> Dave, do you have any problem with changing the behavior to only go into
> multidisk if swidth > sunit?  The more I think about it, the more it makes
> sense to me.

Changing the existing behaviour doesn't make much sense to me. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
