Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22887 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752354AbeEPANp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 20:13:45 -0400
Date: Wed, 16 May 2018 10:13:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reliably measure fs usage with reflinks enabled?
Message-ID: <20180516001342.GK23861@dastard>
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
 <20180514225751.GB10363@dastard>
 <b2fe69d6216f165b2c84ca5a377d06ab@ruhr-uni-bochum.de>
 <20180515012926.GC10363@dastard>
 <CAMU1PDgMH_K1N71SmkwDj159wTjFM3js-hhFGr8uE_GhmLn5mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMU1PDgMH_K1N71SmkwDj159wTjFM3js-hhFGr8uE_GhmLn5mA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, May 15, 2018 at 02:52:30PM +0100, Mike Fleetwood wrote:
> On 15 May 2018 at 02:29, Dave Chinner <david@fromorbit.com> wrote:
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
> I'm one of the authors of GParted and it uses the reported file system
> size [1] and compares it to the block device size to see if the file
> system fills the partition or not and whether to show unallocated space
> to the user and advise them to grown the file system to fill the block
> device [2].  As such we prefer that the reported size of the file system
> match the highest offset that the file system can write to in the block
> device.

I think that's a narrow, use case specific assumption. There is
absolutely no guarantee that the filesystem on a device fills the
entire device or that the filesystem space reported by df/statvfs
accurately reflects the size of the underlying block device.

Filesystems are moving towards a virtualised world where space usage
and capacity is kept separate from the capacity of the underlying
storage provider. That's a solid direction we are moving with xfs:

https://www.spinics.net/lists/linux-xfs/msg12216.html

so we can support subvolumes:

https://www.youtube.com/watch?v=wG8FUvSGROw

via a virtual block address space that remaps the filesystem space
accounting away from the underlying physical block device:

https://lwn.net/SubscriberLink/753650/32230c15f3453808/

This will completely break any assumption that the filesystem size
is related to the underlying storage device(s).

GParted deals very firmly with a specific aspect of disk based
storage - managing partitions on a physical block device.
Filesystems need to move beyond physical block devices - sanely
supporting sparse virtual block devices has been on everyone's
enterprise filesystem wish list for years.

GParted doesn't have to support these new features - it can simply
turn them off for filesystems it creates on physical disk
partitions, but we're doing stuff to support the storage models
needed for container hosting, virtualisation, efficient backups and
cloning, etc. If that means we have to break assumptions that legacy
infrastructure make to support those new features, then so be it....

<snip>

> [2] For full disclosure, because tools for various FSs under report
>     their file system size, there is a heuristic that there must be at
>     least 2% difference before unallocated space and grow file system
>     recommendation is generated so under reporting the FS size by less
>     than 1% wouldn't actually be an issue. for us.

So, an ext3 example on a small root filesystem:

$ grep sda1 /proc/partitions 
   8        1    9984366 sda1
$ df -k /
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/root        9696448 8615892    581340  94% /
$

Just under 3% difference between fs reported size and the block
device size, and obviously GParted has been fine with this sort of
discrepancy on ext3 for the past 15+years. IIRC the XFS metadata
reservations max out at around 3% of total filesystem space, so
GParted should be just fine with us hiding them by reducing total
filesystem size...

> Just providing an app authors point of view.

*nod*.

We're aware that we need to let existing apps continue to work on
existing formats and features. But we need to break from the old
ways to do what people are asking us to do, so we're not going to
lock ourselves in. If we're not breaking old things and making
people unhappy, then we're not making sufficient progress.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
