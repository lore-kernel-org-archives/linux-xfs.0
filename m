Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:19312 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932099AbeA2Bty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jan 2018 20:49:54 -0500
Date: Mon, 29 Jan 2018 12:50:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20180129015043.5bshqr76hrgepxgg@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
 <10612480.yRmMisqFVa@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10612480.yRmMisqFVa@merkaba>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 28, 2018 at 01:59:56PM +0100, Martin Steigerwald wrote:
> Dave Chinner - 25.01.18, 06:51:
> > The video from my talk at LCA 2018 yesterday about the XFS
> > subvolume and snapshot support I'm working on has been uploaded
> > and can be found here:
> > 
> > https://www.youtube.com/watch?v=wG8FUvSGROw
> 
> I somehow knew that something about snapshots would be coming for
> XFS after seeing the reflink / COW and online scrub/repair work by
> Darrick. But I am highly surprised on the how. I also did not
> really expect pNFS file layout of Christoph to play a role here.

Once I realised the similarities in isolation a pNFS client and
subvolumes it started to make sense. i.e. they are a 3rd party fs
on top of XFS that needs XFS to tell it how it can access the file
data on underlying block device directly...

> It totally makes sense to me right now, but on the other hand I
> found myself thinking "It can´t be that easy, can it?" after
> watching your talk.

You're not the only one who's asked that question. I have, too, many
times :P

> Easy not in amount of coding work needed and some complexities you
> mentioned, so I totally get that it is a lot of work needed to
> pull this off, but easy in terms of the concept behind it. Yet, if
> a concept is easy that is quite a hint that it might actually be a
> good one. And if you really can get away with it… then by all
> means, have a go at it!
> 
> I am looking forward to this new "extraordinary way to eat your
> data" (Darrick) or create "blammo" and "kaboom" (Dave). :)
> 
> From what I understand it is also way less of a "layering
> violation" than the approach in taken in BTRFS or ZFS. Actually it
> might not be a "layering violation" at all, since the different
> layers are still there and communicating with each other. Which
> opens a lot of potential on applying this to other filesystems and
> storage subsystems of the kernel.

I had a bonus slide in anticipation of the first question being
about "layering violations". :)

I, personally, don't think there are any layering violations because
what I've actually done is add a *new layer to the stack*. The
architectural layer I've added is a virtual block address space
layer - it's a similar concept to ZFS's virtual device layer(*) -
and I avoided re-implementing the wheel (again) by realising that we
could just use a file to provide that virtual block address space
mapping layer.

Old stack			New stack
vfs				vfs
				subvolume (fs)
				virtual address space (file)
filesystem			filesystem
block device			block device
IO remapping (DM, MD, etc)	IO remapping
storage drivers			storage drivers

I've chosen to implement that new layer as a filesystem image in a
file because that directly provides a virtual-to-physical
translation layer without having to implment one. There is no need
to make this more complex than it needs to be by re-inventing the
wheel unnecessarily.

As it is, the kernel itself doesn't care what type of device the
filesystem sits on - filesystems make that choice themselves by
using FS_REQUIRES_BDEV in their fstype definition.  Removing that
flag means XFS is free to parse the "source device" string however
it wants.

Indeed, mount(2) says:

	"mount()  attaches the filesystem specified by source (which
	is often a pathname referring to a device, but can also be
	the pathname of a directory or file, or a dummy string) to
	the location (a directory or  file) specified by the
	pathname in target."

So the mount syscall documentation specifically documents that a
file can be passed to the kernel as a source.

Not only that, users are now accustomed to passing mount(8) image
files directly. i.e.

# mount /path/to/image/file /mntpt

Will automatically mount the image file on the mount point. The
mount(8) binary will quietly create a loopback device behind the
scenes and mount the fs on that loopback device. So from a
management POV, this "mount image files directly" management model
already has widespread acceptance.

Cheers,

Dave.

(*) Despite what most people claim, ZFS is has a very well thought
out, strongly layered architecture - they are just *different
layers* when compared to the traditional filesystem and IO stack.
Maybe I see it differently because I think mostly at the
architectural level, but that's the level at which layering really
matters....

-- 
Dave Chinner
david@fromorbit.com
