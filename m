Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:33310 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbeJGVC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Oct 2018 17:02:27 -0400
Received: by mail-io1-f65.google.com with SMTP id l25-v6so14007485ioj.0
        for <linux-xfs@vger.kernel.org>; Sun, 07 Oct 2018 06:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20181004175839.18736-1-idryomov@gmail.com> <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard> <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
 <67627995-714c-5c38-a796-32b503de7d13@sandeen.net> <20181005232710.GH12041@dastard>
 <CAOi1vP-Z7xZk1YvWHYWQGOHfyWccFCkyn8je0HBvGhGuUrXmaQ@mail.gmail.com> <20181006232037.GB18095@dastard>
In-Reply-To: <20181006232037.GB18095@dastard>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 7 Oct 2018 15:54:57 +0200
Message-ID: <CAOi1vP_cZi9zDKYbgdq6T2uiPEwTjsP35Qdzi4DPcbvatrvMEQ@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On Sun, Oct 7, 2018 at 1:20 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Oct 06, 2018 at 02:17:54PM +0200, Ilya Dryomov wrote:
> > On Sat, Oct 6, 2018 at 1:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Oct 05, 2018 at 08:51:59AM -0500, Eric Sandeen wrote:
> > > > On 10/5/18 6:27 AM, Ilya Dryomov wrote:
> > > > > On Fri, Oct 5, 2018 at 12:29 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > >>
> > > > >> On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
> > > > >>> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
> > > > >>>> rbd devices report the following geometry:
> > > > >>>>
> > > > >>>>   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
> > > > >>>>   512
> > > > >>>>   512
> > > > >>>>   4194304
> > > > >>>>   4194304
> > > > >>
> > > > >> dm-thinp does this as well. THis is from the thinp device created
> > > > >> by tests/generic/459:
> > > > >>
> > > > >> 512
> > > > >> 4096
> > > > >> 65536
> > > > >> 65536
> > > > >
> > > > > (adding Mike)
> > > > >
> > > > > ... and that 300M filesystem ends up with 8 AGs, when normally you get
> > > > > 4 AGs for anything less than 4T.  Is that really intended?
> > > >
> > > > Well, yes.  Multi-disk mode gives you more AGs, how many more is scaled
> > > > by fs size.
> > > >
> > > >         /*
> > > >          * For the multidisk configs we choose an AG count based on the number
> > > >          * of data blocks available, trying to keep the number of AGs higher
> > > >          * than the single disk configurations. This makes the assumption that
> > > >          * larger filesystems have more parallelism available to them.
> > > >          */
> > > >
> > > > For really tiny filesystems we cut down the number of AGs, but in general
> > > > if the storage "told" us it has parallelism, mkfs uses it by default.
> > >
> > > We only keep the number of AGs down on single disks because of the
> > > seek penalty it causes spinning disks. It's a trade off between
> > > parallelism and seek time.
> >
> > If it's primarily about seek times, why aren't you looking at rotational
> > attribute for that?
>
> Historically speaking, "rotational" hasn't been a reliable indicator
> of device seek behaviour or alignment requirements. It was anasty
> hack for people wanting to optimise for SSDs and most of those
> optimisations were things we could already do with sunit/swidth
> (such as aligning to internal SSD page sizes and/or erase blocks).

Thank you for the detailed replies, Dave.  Some excerpts definitely
deserve a big block comment near calc_default_ag_geometry().

>
> > > > > AFAIK dm-thinp reports these values for the same exact reason as rbd:
> > > > > we are passing up the information about the efficient I/O size.  In the
> > > > > case of dm-thinp, this is the thinp block size.  If you put dm-thinp on
> > > > > top of a RAID array, I suspect it would pass up the array's preferred
> > > > > sizes, as long as they are a proper factor of the thinp block size.
> > >
> > > dm-thinp is passing up it's allocation chunk size, not the
> > > underlying device geometry. dm-thinp might be tuning it's chunk size
> > > to match the underlying storage, but that's irrelevant to XFS.
> >
> > I think the thinp chunk size is more about whether you just want thin
> > provisioning or plan to do a lot of snapshotting, etc.  dm-thinp passes
> > up the underlying device geometry if it's more demanding than the thinp
> > chunk size.  Here is dm-thinp with 64K chunk size on top of mdraid:
> >
> >   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/mapper/vg1-thin1
> >   512
> >   512
> >   524288
> >   1048576
>
> That's how iomin/ioopt are supposed to be propagated on layered
> devices. i.e. the layer with the largest values bubbles to the top,
> and the filesystem aligns to that.
>
> That doesn't change the fact that thinp and other COW-based block
> devices fundamentally isolate the filesystem from the physical
> storage properties. The filesystem sees the result of the COW
> behaviour in the block device and it's allocated algorithm, not the
> physical block device properties.
>
> Last time I looked, dm-thinp did first-free allocation, which means
> it fills the block device from one end to the other regardless of
> how many widely spaced IOs are in progress from the filesystems.
> That means all the new writes end up being sequential from dm-thinp
> rather than causing seek storms because they are being written to 32
> different locations across the block device. IOWs, a properly
> implemented COW-based thinp device should be able to handle much
> higher random write IO workloads than if the filesystem was placed
> directly on the same block device.
>
> IOWs, dm-thinp does not behave how one expects a rotational device
> to behave even when it is placed on a rotational device. We have to
> optimise filesystem behaviour differently for dm-thinp.
>
> > > That's because dm-thinp is a virtual mapping device in the same way
> > > the OS provides virtually mapped memory to users. That it, there is
> > > no relationship between the block device address space index and the
> > > location on disk. Hence the seek times between different regions of
> > > the block device address space are not linear or predictable.
> > >
> > > Hence dm-thinp completely changes the parallelism vs seek time
> > > trade-off the filesystem layout makes.  We can't optimise for
> > > minimal seek time anymore because we don't know the physical layout
> > > of the storage, so all we care about is alignment to the block
> > > device chunk size.
> > >
> > > i.e. what we want to do is give dm-thinp IO that is optimal (e.g.
> > > large aligned writes for streaming IO) and we don't want to leave
> > > lots of little unused holes in the dmthinp mapping that waste space.
> > > To do this, we need to ensure minimal allocator contention occurs,
> > > and hence we allow more concurrency in allocation by inreasing the
> > > AG count, knowing that we can't make the seek time problem any worse
> > > by doing this.
> >
> > And yet dm-thinp presents itself as rotational if (at least one of) the
> > underlying disk(s) is marked as rotational.
>
> Which, as per above, means rotational devices don't all behave like
> you'd expect a spinning spindle to behave. i.e. It's not an
> indication of a specific, consistent device model that we can
> optimise for.
>
> > As it is, we get the nomultidisk trade-parallelism-for-seek-times
> > behaviour on bare SSD devices, but dm-thinp on top of a single HDD
> > device is regarded up to 8 (XFS_MULTIDISK_AGLOG - XFS_NOMULTIDISK_AGLOG)
> > times more parallel...
>
> Yes, that's expected. The single SSD case has to take into account
> the really slow, cheap SSDs that aren't much better than spinning
> disks right through to high end nvme drives.
>
> It's easy to drown a slow SSD, just like it's easy to drown a single
> spindle. But there's /very few/ applications that can drive a high
> end nvme SSD to be allocation bound on a 4 AG XFS filesystem because
> of how fast the IO is. As such, I'm yet to hear of reports of XFS
> allocation concurrency bottlenecks in production workloads on nvme
> SSDs.
>
> Defaults are a trade off.  There is no "one size fits all" solution,
> so we end up with defaults that are a compromise of "doesn't suck
> for the majority of use cases". That means there might be some
> unexpected default behaviours, but that doesn't mean they are wrong.
>
> > > These are /generic/ alignment characteristics. While they were
> > > originally derived from RAID characteristics, they have far wider
> > > scope of use than just for configuring RAID devices. e.g. thinp,
> > > exposing image file extent size hints as filesystem allocation
> > > alignments similar to thinp, selecting what aspect of a multi-level
> > > stacked RAID made up of hundreds of disks the filesystem should
> > > align to, aligning to internal SSD structures (be it raid, erase
> > > page sizes, etc), optimising for OSD block sizes, remote replication
> > > block size constraints, helping DAX align allocations to huge page
> > > sizes, etc.
> >
> > Exactly, they are generic data alignment characteristics useful for
> > both physical and virtual devices.  However, mkfs.xfs uses a heuristic
> > that conflates them with agcount through the physics of the underlying
> > device which it can't really reason about, especially in the virtual
> > or network case.
>
> Yet it's a heuristic that has served use well for 20 years. Yes,
> we'v been madly conflating allocation concurrency with storage that
> requires alignment since long before XFS was ported to Linux.
>
> The defaults are appropriate for the vast majority of installations
> and use cases. The defaults are not ideal for everyone, but there's
> years of thought, observation, problem solving and knowledge behind
> them.
>
> If you don't like the defaults, then override them on the command
> line, post your benchmarked improvements and make the argument why
> this particular workload and tuning is better to everyone.

We were doing some tests with XFS on top of rbd, with multiple rbd
devices on the same client machine (pretty beefy in terms of number of
cores and RAM).  We ran the smallfile benchmark and found that with
just a dozen devices mkfs.xfs with -d agcount=4 improved per device
throughput by over 2x, with no degradation but rather a small bump on
a single device.  Mark (CCed) can share the details.

This prompted me to look at what mkfs.xfs was doing.  The default
behaviour just didn't make much sense until now, particularly the SSD
case.

>
> > > My point is that just looking at sunit/swidth as "the number of data
> > > disks" completely ignores the many other uses we've found for it
> > > over the last 20 years. In that time, it's almost always been the
> > > case that devices requiring alignment have not been bound by the
> > > seek time constraints of a single spinning spindle, and the default
> > > behaviour reflects that.
> > >
> > > > Dave, do you have any problem with changing the behavior to only go into
> > > > multidisk if swidth > sunit?  The more I think about it, the more it makes
> > > > sense to me.
> > >
> > > Changing the existing behaviour doesn't make much sense to me. :)
> >
> > The existing behaviour is to create 4 AGs on both spinning rust and
> > e.g. Intel DC P3700.
>
> That's a really bad example.  The p3700 has internal RAID with a
> 128k page size that it doesn't expose to iomin/ioopt. It has
> *really* bad IO throughput for sub-128k sized or aligned IO (think
> 100x slower, not just a little). It's a device that absolutely
> should be exposing preferred alignment characteristics to the
> filesystem...

That was deliberate, as an example of a device that is generally
considered to be pretty good -- even though the internal stripe size is
public information, it's not passed through the stack.

>
> > If I then put dm-thinp on top of that spinner,
> > it's suddenly deemed worthy of 32 AGs.  The issue here is that unlike
> > other filesystems, XFS is inherently parallel and perfectly capable of
> > subjecting it to 32 concurrent write streams.  This is pretty silly.
>
> COW algorithms linearise and serialise concurrent write streams -
> that's exactly what they are designed to do and why they perform so
> well on random write workloads.  Optimising the filesystem layout
> and characteristics to take advantage of COW algorithms in the
> storage laye is not "pretty silly" - it's the smart thing to do
> because the dm-thinp COW algorithms are only as good as the garbage
> they are fed.

Right, that's pretty much what I expected to hear.  But I picked on
dm-thinp because Mike has attempted to make mkfs.xfs go with the lower
agcount for dm-thinp in fdfb4c8c1a9f ("dm thin: set minimum_io_size to
pool's data block size").  Both the commit message and his reply in
this thread indicate that he wasn't just following your suggestion to
set both iomin and ioopt to the same value, but actually intended it to
defeat the agcount heuristic.  Mike, are there different expectations
here?

>
> > You agreed that broken RAID controllers that expose "sunit == swidth"
> > are their vendor's or administrator's problem.
>
> No I didn't - I said that raid controllers that only advertise sunit
> or swidth are broken. Advertising sunit == swidth is a valid thing
> to do - we really only need a single alignment value for hardware
> RAID w/ NVRAM caches: the IO size/alignment needed to avoid RMW
> cycles.
>
> > The vast majority of
> > SSD devices in wide use either expose nothing or lie.  The information
> > about internal page size or erase block size is either hard to get or
> > not public.
>
> Hence, like the broken RAID controller case, we don't try to
> optimise for them.  If they expose those things (and the p3700 case
> demonstrates that they should!) then we'll automatically optimise
> the filesystem for their physical characteristics.
>
> > Can you give an example of a use case that would be negatively affected
> > if this heuristic was switched from "sunit" to "sunit < swidth"?
>
> Any time you only know a single alignment characteristic of the
> underlying multi-disk storage. e.g. hardware RAID0/5/6 that sets
> iomin = ioopt, multi-level RAID constructs where only the largest
> alignment requirement is exposed, RAID1 devices exposing their chunk
> size, remote replication chunk alignment (because remote rep. is
> slow and so we need more concurrency to keep the pipeline full),
> etc.

That's a good point, I didn't think of arrays with battery/flash
backed caches.

Can you poke holes in "sunit && swidth"?  It sounds like under "RAID
controllers that only advertise sunit or swidth are broken" it wouldn't
affect any RAID cases we care to optimize for and given that single HDD
and single SSD cases are considered to be the same and that most
devices report ioopt = 0 anyway that front is covered too.

Thanks,

                Ilya
