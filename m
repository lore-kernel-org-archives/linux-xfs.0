Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33315 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752188AbeETAKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 May 2018 20:10:17 -0400
Date: Sun, 20 May 2018 10:10:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reliably measure fs usage with reflinks enabled?
Message-ID: <20180520001015.GM23861@dastard>
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
 <20180514225751.GB10363@dastard>
 <b2fe69d6216f165b2c84ca5a377d06ab@ruhr-uni-bochum.de>
 <20180515012926.GC10363@dastard>
 <20180518145713.GF23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180518145713.GF23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Fri, May 18, 2018 at 07:58:04AM -0700, Darrick J. Wong wrote:
> On Tue, May 15, 2018 at 11:29:26AM +1000, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 01:37:32AM +0200, Tarik Ceylan wrote:
> > > Am 2018-05-15 00:57, schrieb Dave Chinner:
> > > >On Mon, May 14, 2018 at 05:02:53PM -0500, Eric Sandeen wrote:
> > > >>
> > > >>
> > > >>On 5/14/18 3:02 PM, Tarik Ceylan wrote:
> > > >>> How can one reliably measure filesystem usage on partitions that were compiled with -m reflink=1 ?
> > > >>> Here are some numbers i am measuring with df -h (on different partitions holding the same data):
> > > >>> 7.7G of 36G  (-b size=512  -m crc=0 )
> > > >>> 8.6G of 36G  (-b size=4096 -m crc=1 )
> > > >>
> > > >>8x larger inodes will take 8x more space, but you didn't say how many
> > > >>inodes you have allocated.
> > > >>
> > > >>> 11G  of 36G  (-b size=1024 -m crc=1,reflink=1,rmapbt=1 -i sparse=1 )
> > > >>> 32G  of 864G (-b size=4096 -m crc=1,reflink=1 )
> > > >>
> > > >>In that last case, you have a wildly different total fs size, so
> > > >>probably
> > > >>no fair comparison here either.
> > > >>
> > > >>The reverse mapping btree also takes up space.  You're turning
> > > >>too many
> > > >>knobs at once.  ;)
> > > 
> > > Thanks,
> > > here's a test in which i only compare reflink=0 to reflink=1, all other
> > > variables being the same:
> > > 
> > > mkfs.xfs -f -m reflink=0 /dev/sdc4
> > > meta-data=/dev/sdc4              isize=512    agcount=4,
> > > agsize=58687982 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=0,
> > > rmapbt=0, reflink=0
> > > data     =                       bsize=4096   blocks=234751926,
> > > imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > log      =internal log           bsize=4096   blocks=114624, version=2
> > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > "df -h" shows a usage of 8.8G of 896G
> > > 
> > > mkfs.xfs -f -m reflink=1 /dev/sdc4
> > > [output same as before except the reflink parameter]
> > > 15G of 896G
> > 
> > So the reflink code reserved ~7GB of space in the filesystem (less
> > than 1%) for it's own reflink related metadata if it ever needs it.
> > It hasn't used it yet but we need to make sure that it's available
> > when the filesystem is near ENOSPC. Hence it's considered used space
> > because users cannot store user data in that space.
> > 
> > The change I plan to make is to reduce the user reported filesystem
> > size rather than account for it as used space. IOWs, you'd see a
> > filesystem size of 889G instead of 896G, but have only 8.8GB used.
> > It means exactly the same thingi and will behave exactly the same
> > way, it's just a different space accounting technique....
> 
> FWIW generic/260 also assumes that f_blocks reflects the size of the
> device and stumbles when we tell it to fstrim (0..ULLONG_MAX) and the
> number of bytes returned is greater than the f_blocks size of the fs,
> which is what (I think) will happen if we start reducing f_blocks by the
> size of the per-AG reservations.

That's trivial to fix, though. Just clamp the return bytes to the
size reported to userspace via statfs().

> I think the underlying problem is confusion over the definition of the
> address space that fstrim's range parameters run over.

I think it's pretty clear in the man page by the offset and length
parameters. Specifically, the length parameter:

	[....] If the specified value extends past  the  end of the
	filesystem, fstrim will stop at the filesystem size boundary

IOWs, the filesystem decides what the filesystem size is, not the
caller. That means if the fs is smaller than the block device it
sits on, it will not discard the region of the block device beyond
the end of the filesystem....

Really, I think you're conflating /filesystem storage capacity/ with
/device address space/.  They are two different things.  statfs()
reports filesystem capacity, not the size of the underlying device
(because the filesystem may not have an "underlying device").
/proc/partitions reports the size of the underlying device for block
based filesystems, but tells us nothing about how much of that space
the filesystem will present to the user as available storage.

And when we get subvolumes on XFS what, exactly, is the "underlying
device"? It's not a block device....

Filesystem storage capacity is not the same thing as the size of
the linear block address space it sits on. That association was
broken a long, long time ago, so can we please stop acting as though
they are one-and-the-same?

> The current
> usage in ext4/xfs suggests that the units are byte offsets into the main
> block device, but there's no uniform way to find out the maximum
> physical address that the filesystem uses, is there?

For XFS: XFS_IOC_FSGEOMETRY. Even after we change the accounting, we
will still be able to get the physical address space size the
filesystem is using from this.

> And what of
> multi-device filesystems like btrfs and xfs+realtime?  Do we just
> concatenate the block devices in a virtual address space?

IMO, hacks like that are a path to certain insanity. :/

Unfortunately, fstrim was not written with multidevice filesystems
in mind, so if we want to support them, we need a new syscall/ioctl
to make these work sanely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
