Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:60242 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752508AbdIFKa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 06:30:58 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dpXbi-0005Sx-4d
        for linux-xfs@vger.kernel.org; Wed, 06 Sep 2017 20:30:54 +1000
Date: Wed, 6 Sep 2017 20:30:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Some questions about per-ag metadata space reservations...
Message-ID: <20170906103054.GR17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I've got a bit of a problem with the per-ag reservations we are
using at the moment. The existance of them is fine, but the
implementation is problematic for something I'm working on right
now.

I've been making a couple of mods to the filesystem to separate
physical space accounting from free space accounting to allow us to
optimise the filesystem for thinly provisioned devices. That is,
the filesystem is laid out as though it is the size of the
underlying device, but then free space is artificially limited. i.e.
we have a "physical size" of the filesystem and a "logical size"
that limits the amount of data and metadata that can actually be
stored in it.

When combined with a thinly provisioned device, this enables us to
shrink the XFS filesystem simply by running fstrim to punch all the
free space out of the underlying thin device and then adjusting the
free space down appropriately. Because the thin device abstracts the
physical location of the data in the block device away from the
address space presented to the filesystem, we don't need to move any
data or metadata to free up this space - it's just an accounting
change.

The problem arises with the per AG reservations in that they are
based on the physical size of the AG, which for a thin filesystem
will always be larger than the space available. e.g. we might
allocate a 32TB thin device to give 32x1TB AGs in the filesystem,
but we might only start by allocating 1TB of space to the
filesystem. e.g.:

# mkfs.xfs -f -m rmapbt=1,reflink=1 -d size=32t,thin=1t /dev/vdc
Default configuration sourced from package build definitions
meta-data=/dev/vdc               isize=512    agcount=32, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=1, reflink=1
data     =                       bsize=4096   blocks=268435456, imaxpct=5, thin=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
#

The issue is now when we mount it:

# mount /dev/vdc /mnt/scratch ; df -h /mnt/scratch/ ; sudo umount /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc       1023G  628G  395G  62% /mnt/scratch
#

Of that 1TB of space, we immediately remove 600+GB of free space for
finobt, rmapbt and reflink metadata reservations. This is based on
the physical size and number of AGs in the filesystem, so it always
gets removed from the free block count available to the user.
This is clearly seen when I grow the filesystem to 10x the size:

# xfs_growfs -D 2684354560 /mnt/scratch
....
data blocks changed from 268435456 to 2684354560
# df -h /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc         10T  628G  9.4T   7% /mnt/scratch
#

And also shows up on shrinking back down a chunk, too:

# xfs_growfs -D 468435456 /mnt/scratch
.....
data blocks changed from 2684354560 to 468435456
# df -h /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc        1.8T  628G  1.2T  36% /mnt/scratch
#

(Oh, did I mention I have working code and that's how I came across
this problem? :P)

For a normal filesystem, there's no problem with doing this brute
force physical reservation, though it is slightly disconcerting to
see a new, empty 100TB filesystem say it's got 2TB used and only
98TB free...

The issue is that for a thin filesystem, this space reservation
come out of the *logical* free space, not the physical free space.
With 1TB of thin space, we've got 31TB of /physical free space/ the
reservation can be taken out of without the user ever seeing it. The
question is this: how on earth do I do this?

I want the available space to match the "thin=size" value on the
mkfs command line, but I don't want metadata reservations to take
away from this space. metadata allocations need to be accounted to
the available space, but the reservations should not be. So how
should I go about providing these reservations? Do we even need them
to be accounted against free space in this case where we control the
filesysetm free blocks to be a /lot/ less than the physical space?

e.g. if I limit a thin filesystem to 95% of the underlying thin
device size, then we've always got a 5% space margin and so we don't
need to take the reservations out of the global free block counter
to ensure we always have physical space for the metadata. We still
take the per-ag reservations to ensure everything still works on the
physical side, we just don't pull the space from the free block
counter. I think this will work, but I'm not sure I've fully grokked
all the conditions the per-ag reservation is protecting against or
whether there's more accounting work needed deep in allocation code
to make it work correctly.

Thoughts, anyone?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
