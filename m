Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EBD87F5D
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 15:20:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B5BDAC001
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 13:20:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C9rGMMkMqTZwy3gy for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 13:20:38 -0700 (PDT)
Date: Tue, 17 Mar 2015 07:20:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150316202023.GC28557@dastard>
References: <20150316060020.GB28557@dastard>
	<1426519733.4000.11.camel@HansenPartnership.com>
	<CAKdFiL7S=x57OzO-ak9i3E3BrEsqmiRxpNpTJY_pKKVspd_YEg@mail.gmail.com>
	<1426532787.8276.25.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426532787.8276.25.camel@HansenPartnership.com>
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
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, ext4 development <linux-ext4@vger.kernel.org>, Adrian Palmer <adrian.palmer@seagate.com>, linux-scsi <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 16, 2015 at 03:06:27PM -0400, James Bottomley wrote:
> On Mon, 2015-03-16 at 12:23 -0600, Adrian Palmer wrote:
> [...]
> > >> == Data zones
> > >>
> > >> What we need is a mechanism for tracking the location of zones (i.e. start LBA),
> > >> free space/write pointers within each zone, and some way of keeping track of
> > >> that information across mounts. If we assign a real time bitmap/summary inode
> > >> pair to each zone, we have a method of tracking free space in the zone. We can
> > >> use the existing bitmap allocator with a small tweak (sequentially ascending,
> > >> packed extent allocation only) to ensure that newly written blocks are allocated
> > >> in a sane manner.
> > >>
> > >> We're going to need userspace to be able to see the contents of these inodes;
> > >> read only access wil be needed to analyse the contents of the zone, so we're
> > >> going to need a special directory to expose this information. It would be useful
> > >> to have a ".zones" directory hanging off the root directory that contains all
> > >> the zone allocation inodes so userspace can simply open them.
> > >
> > > The ZBC standard is being constructed.  However, all revisions agree
> > > that the drive is perfectly capable of tracking the zone pointers (and
> > > even the zone status).  Rather than having you duplicate the information
> > > within the XFS metadata, surely it's better with us to come up with some
> > > block way of reading it from the disk (and caching it for faster
> > > access)?

You misunderstand my proposal - XFS doesn't track the write pointer
in it's metadata at all. It tracks a sequential allocation target
block in each zone via the per-zone allocation bitmap inode. The
assumption is that this will match the underlying zone write
pointer, as long as we verify they match when we first go to
allocate from the zone.

> > In discussions with Dr. Reinecke, it seems extremely prudent to have a
> > kernel cache somewhere.  The SD driver would be the base for updating
> > the cache, but it would need to be available to the allocators, the
> > /sys fs for userspace utilities, and possibly other processes.  In
> > EXT4, I don't think it's feasible to have the cache -- however, the
> > metadata will MIRROR the cache ( BG# = Zone#, databitmap = WP, etc)
> 
> I think I've got two points: if we're caching it, we should have a
> single cache and everyone should use it.  There may be a good reason why
> we can't do this, but I'd like to see it explained before everyone goes
> off and invents their own zone pointer cache.  If we do it in one place,
> we can make the cache properly shrinkable (the information can be purged
> under memory pressure and re-fetched if requested).

Sure, but XFS won't have it's own cache, so what the kernel does
here when we occasionally query the location of the write pointer is
irrelevant to me...

> > >> == Quantification of Random Write Zone Capacity
> > >>
> > >> A basic guideline is that for 4k blocks and zones of 256MB, we'll need 8kB of
> > >> bitmap space and two inodes, so call it 10kB per 256MB zone. That's 40MB per TB
> > >> for free space bitmaps. We'll want to suport at least 1 million inodes per TB,
> > >> so that's another 512MB per TB, plus another 256MB per TB for directory
> > >> structures. There's other bits and pieces of metadata as well (attribute space,
> > >> internal freespace btrees, reverse map btrees, etc.
> > >>
> > >> So, at minimum we will probably need at least 2GB of random write space per TB
> > >> of SMR zone data space. Plus a couple of GB for the journal if we want the easy
> > >> option. For those drive vendors out there that are listening and want good
> > >> performance, replace the CMR region with a SSD....
> > >
> > > This seems to be a place where standards work is still needed.  Right at
> > > the moment for Host Managed, the physical layout of the drives makes it
> > > reasonably simple to convert edge zones from SMR to CMR and vice versa
> > > at the expense of changing capacity.  It really sounds like we need a
> > > simple, programmatic way of doing this.  The question I'd have is: are
> > > you happy with just telling manufacturers ahead of time how much CMR
> > > space you need and hoping they comply, or should we push for a standards
> > > way of flipping end zones to CMR?

I've taken what manufacturers are already shipping and found that it
is sufficient for our purposes. They've already set the precendence,
we'll be dependent on them maintaining that same percentage of
CMR:SMR regions in their drives. Otherwise, they won't have
filesystems that run on their drives and they won't sell any of
them.

i.e. we don't need to standardise anything here - the problem is
already solved.

> possibly btrfs) will need some.  One possibility is that we let the
> drives be reformatted in place, say as part of the initial filesystem
> format, so the CMR requirements get tuned exactly.  The other is that we
> simply let the manufacturers give us "enough" and try to determine what
> "enough" is.

Drive manufacturers are already giving us "enough" for market space
that we see XFS-on-SMR-drives will be seen. Making it tunable is
silly - if you are that close to the edge then DM can build you a
device that has a larger CMR from a SSD....

> I suspect forcing a tuning command through the ZBC workgroup would be a
> nice quick way of getting the manufacturers to focus on what is
> possible, but I think we do need some way of closing out this either/or
> debate (we tune or you tune).

It's already there in shipping drives...

> > >> === Crash recovery
> > >>
> > >> Write pointer location is undefined after power failure. It could be at an old
> > >> location, the current location or anywhere in between. The only guarantee that
> > >> we have is that if we flushed the cache (i.e. fsync'd a file) then they will at
> > >> least be in a position at or past the location of the fsync.
> > >>
> > >> Hence before a filesystem runs journal recovery, all it's zone allocation write
> > >> pointers need to be set to what the drive thinks they are, and all of the zone
> > >> allocation beyond the write pointer need to be cleared. We could do this during
> > >> log recovery in kernel, but that means we need full ZBC awareness in log
> > >> recovery to iterate and query all the zones.
> > >
> > > If you just use a cached zone pointer provided by block, this should
> > > never be a problem because you'd always know where the drive thought the
> > > pointer was.
> > 
> > This would require a look at the order of updating the stack
> > information, and also WCD vs WCE behavior.  As for the WP, the spec
> > says that any data after the WP is returned with a clear pattern
> > (zeros on Seagate drives) -- it is already cleared.
> 
> As long as the drive behaves to spec, our consistency algorithms should
> be able to cope.  We would expect that on a crash the write pointer
> would be further back than we think it should be, but then the FS will
> just follow its consistency recovery procedures and either roll back or
> forward the transactions from where the WP is at.

Journal recovery doesn't work that way - you can't roll back random
changes mid way through recovery and expect the result to be a
consistent filesystem.

If we run recovery fully, then we have blocks allocated to files
beyond the write pointer and that leaves us two choices:

	- writing zeros to the blocks allocated beyond the write
	  pointer during log recovery to get stuff back in sync,
	  prevent stale data exposure and double-referenced blocks
	- revoke the allocated blocks beyond the write pointer so
	  they can be allocated correctly on the next write.

Either way, it's different behaviour and we need to run write pointer
synchronisation after log recovery to detect the problems...

> In some ways, the WP
> will help us, because we do a lot of re-committing transactions that may
> be on disk currently because we don't clearly know where the device
> stopped writing data.

And therein lies the fundamental reason why write pointer
sychronisation after unclean shutdown is a really hard problem.

> > == Kernel implementation
> > 
> > The allocator will need to learn about multiple allocation zones based on
> > bitmaps. They aren't really allocation groups, but the initialisation and
> > iteration of them is going to be similar to allocation groups. To get use going
> > we can do some simple mapping between inode AG and data AZ mapping so that we
> > keep some form of locality to related data (e.g. grouping of data by parent
> > directory).
> > 
> > We can do simple things first - simply rotoring allocation across zones will get
> > us moving very quickly, and then we can refine it once we have more than just a
> > proof of concept prototype.
> > 
> > Optimising data allocation for SMR is going to be tricky, and I hope to be able
> > to leave that to drive vendor engineers....

Maybe in 5 years time....

> I think we'd all be interested in whether the write and return
> allocation position suggested at LSF/MM would prove useful for this (and
> whether the manufacturers are interested in prototyping it with us).

Right, that's where we need to head. I've got several other block
layer interfaces in mind that could use exactly this semantic to
avoid significant complexity in the filesystem layers.

> > Ideally, we won't need a zbc interface in the kernel, except to erase zones.
> > I'd like to see an interface that doesn't even require that. For example, we
> > issue a discard (TRIM) on an entire  zone and that erases it and
> > resets the write
> > pointer. This way we need no new infrastructure at the filesystem layer to
> > implement SMR awareness. In effect, the kernel isn't even aware that it's an SMR
> > drive underneath it.
> > 
> > 
> > Dr. Reinecke has already done the Discard/TRIM stuff.  However, he's
> > as of yet ignored the zone management pieces.  I have thought
> > (briefly) of the possible need for a new allocator:  the group
> > allocator.  As there can only be a few (relatively) zones available at
> > any one time, We might need a mechanism to tell which are available
> > and which are not.  The stack will have to collectively work together
> > to find a way to request and use zones in an orderly fashion.
> 
> Here I think the sense of LSF/MM was that only allowing a fixed number
> of zones to be open would get a bit unmanageable (unless the drive
> silently manages it for us).  The idea of different sized zones is also
> a complicating factor.

Not for XFS - my proposal handles variable sized zones without any
additional complexity. Indeed, it will handle zone sizes from 16MB
to 1TB without any modification - mkfs handles it all when it
queries the zones and sets up the zone allocation inodes...

And we limit the number of "open zones" by the number of zone groups
we alow concurrent allocation to....

> The other open question is that if we go for
> fully drive managed, what sort of alignment, size, trim + anything else
> should we do to make the drive's job easier.  I'm guessing we won't
> really have a practical answer to any of these until we see how the
> market responds.

I'm not aiming this proposal at drive managed, or even host-managed
drives: this proposal is for full host-aware (i.e. error on
out-of-order write) drive support. If you have drive managed SMR,
then there's pretty much nothing to change in existing filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
