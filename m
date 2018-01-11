Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22555 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753520AbeAKCOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 21:14:46 -0500
Date: Thu, 11 Jan 2018 13:14:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180111021441.GT16421@dastard>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia>
 <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk>
 <20180109222523.GJ16421@dastard>
 <5A55AFE7.3080500@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A55AFE7.3080500@youngman.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On Wed, Jan 10, 2018 at 06:17:11AM +0000, Wols Lists wrote:
> On 09/01/18 22:25, Dave Chinner wrote:
> > On Tue, Jan 09, 2018 at 09:36:49AM +0000, Wols Lists wrote:
> >> On 08/01/18 22:01, Dave Chinner wrote:
> >>> Yup, 21 devices in a RAID 10. That's a really nasty config for
> >>> RAID10 which requires an even number of disks to mirror correctly.
> >>> Why does MD even allow this sort of whacky, sub-optimal
> >>> configuration?
> >>
> >> Just to point out - if this is raid-10 (and not raid-1+0 which is a
> >> completely different beast) this is actually a normal linux config. I'm
> >> planning to set up a raid-10 across 3 devices. What happens is that is
> >> that raid-10 writes X copies across Y devices. If X = Y then it's a
> >> normal mirror config, if X > Y it makes good use of space (and if X < Y
> >> it doesn't make sense :-)
> >>
> >> SDA: 1, 2, 4, 5
> >>
> >> SDB: 1, 3, 4, 6
> >>
> >> SDC: 2, 3, 5, 6
> > 
> > It's nice to know that MD has redefined RAID-10 to be different to
> > the industry standard definition that has been used for 20 years and
> > optimised filesystem layouts for.  Rotoring data across odd numbers
> > of disks like this is going to really, really suck on filesystems
> > that are stripe layout aware..
> 
> Actually, I thought that the industry standard definition referred to
> Raid-1+0. It's just colloquially referred to as raid-10.

https://en.wikipedia.org/wiki/Nested_RAID_levels#RAID_10

"However, a nonstandard definition of "RAID 10" was created for the
Linux MD driver"

So it's not just me who thinks what MD is doing is non-standard.

> > For example, XFS has hot-spot prevention algorithms in it's
> > internal physical layout for striped devices. It aligns AGs across
> > different stripe units so that metadata and data doesn't all get
> > aligned to the one disk in a RAID0/5/6 stripe. If the stripes are
> > rotoring across disks themselves, then we're going to end up back in
> > the same position we started with - multiple AGs aligned to the
> > same disk.
> 
> Are you telling me that xfs is aware of the internal structure of an
> md-raid array?

It's aware of the /alignment/ characteristics of block devices, and
these alignment characteristics are exported by MD. e.g.  These are
exported in /sys/block/<dev>/queue in

	minimum_io_size
		- typically the stripe chunk size
	optimal_io_size
		- typically the stripe width

We get this stuff from DM and MD devices, hardware raid (via scsi
code pages), thinp devices (i.e. to tell us the allocation
granularity so we can align/size IO to match it) and any other block
device that wants to tell us about optimal IO geometry. libblkid
provides us with this information, and it's not just mkfs.xfs that
uses it. e.g. mkfs.ext4 also uses it for the exact same purpose as
XFS....

> Given that md-raid is an abstraction layer, this seems
> rather dangerous to me - you're breaking the abstraction and this could
> explain the OP's problem. Md-raid changed underneath the filesystem, on
> the assumption that the filesystem wouldn't notice, and the filesystem
> *did*. BANG!

No, we aren't breaking any abstractions. It's always been that case
that the filesystem needs to be correctly aligned to the underlying
storage geometry if performance is desired. Think about old skool
filesystems that were aware of the old C/H/S layout of drives back
in the 80s. Optimising layouts for "cylinder groups" in the hardware
gave major performance improvements and we can trace ext4's block
group concept all the way back to those specific hardware geometry
requirements.

I suspect that the problem here is that realtively few people
understand why alignment to the underlying storage geometry is
necessary and don't realise the lengths the storage stack goes to
ensuring alignment is optimal.  It's mostly hidden and automatic
these days because most users lack the knowledge to be able to set
this sort of stuff up correctly.

> > The result is that many XFS workloads are going to hotspot disks and
> > result in unbalanced load when there are an odd number of disks in a
> > RAID-10 array.  Actually, it's probably worse than having no
> > alignment, because it makes hotspot occurrence and behaviour very
> > unpredictable.
> > 
> > Worse is the fact that there's absolutely nothing we can do to
> > optimise allocation alignment or IO behaviour at the filesystem
> > level. We'll have to make mkfs.xfs aware of this clusterfuck and
> > turn off stripe alignment when we detect such a layout, but that
> > doesn't help all the existing user installations out there right
> > now.
> 
> So you're telling me that mkfs.xfs *IS* aware of the underlying raid
> structure. OOPS! What happens when that structure changes for instance a
> raid-5 is converted to raid-6, or another disk is added?

RAID-5 to RAID-6 doesn't change the stripe alignment. That's still
N data disks per stripe, so the geometry and alignment is unchanged
and has no impact on the layout.

But changing the stripe geometry (i.e. number of data disks)
completely fucks IO alignment and that impacts overall storage
performance.  None of the existing data in the filesystem is aligned
to the underlying storage anymore so overwrites will cause all sorts
of RMW storms, you'll get IO hotspots because what used to be on
separate disks is now all on the same disk, etc. And the filesystem
won't be able to fix this because unless you increase the number
data disks by an integer multiple, the alignment cannot be changed
due to fixed locations of metadata in the filesystem.

> If you have to
> have special code to deal with md-raid and changes in said raid, where's
> the problem with more code for raid-10?

I didn't stay we had code to handle "changes in said raid". That's
explicitly what we /don't have/. To handle a geometry/alignment
change in the underlying storage we have to *resilver the entire
filesystem*. And, well, we can't easily do that because that means
we'd have to completely rewrite and re-index the filesystem. It's
faster, easier and more reliable to dump/mkfs/restore the filesystem
than it is to resilver it.

There's many, many reasons why RAID reshaping is considered harmful
and is not recommended by anyone who understands the whole storage
stack intimately.

> > IMO, odd-numbered disks in RAID-10 should be considered harmful and
> > never used....
> > 
> What about when you have an odd number of mirrors? :-)

Be a smart-ass all you want, but it doesn't change the fact that the
"grow-by-one-disk" clusterfuck occurs when you have an odd number of
mirrors, too.

> Seriously, can't you just make sure that xfs rotates the stripe units
> using a number that is relatively prime to the number of disks?

Who said we don't already rotate through stripe units?

And, well, there are situations where ignoring geometry is good
(e.g. delayed allocation allows us to pack lots of small files
together so they aggregate into full stripe writes and avoid RMW
cycles) and there are situations where stripe width rather than
stripe unit alignment is desirable for a single allocation (e.g.
large sequential direct IO writes so we avoid RMW cycles due to
partial stripe overlaps in IO).

These IO alignment optimisations are all done on-the-fly by
filesystems.  Filesystems do far more than you realise with the
geometry information they are provided with and that's why assuming
that you can transparently change the storage geometry without the
filesystem (and hence users) caring about such changes is
fundamentally wrong.

> (Just so's you know who I am, I've taken over editorship of the raid
> wiki. This is exactly the stuff that belongs on there, so as soon as I
> understand what's going on I'll write it up, and I'm happy to be
> educated :-) But I do like to really grasp what's going on, so expect
> lots of naive questions ... There's not a lot of information on how raid
> and filesystems interact, and I haven't really got to grips wioth any of
> that at the moment, and I don't use xfs. I use ext4 on gentoo, and the
> default btrfs on SUSE.)

You've got an awful lot of learning to do, then.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
