Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51011 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750769AbdKEWet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2017 17:34:49 -0500
Date: Mon, 6 Nov 2017 09:34:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Message-ID: <20171105223445.GA5858@dastard>
References: <59FA4499.2030502@tlinx.org>
 <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
 <59FEC912.4000005@tlinx.org>
 <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: L A Walsh <lkml@tlinx.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Nov 05, 2017 at 10:55:40AM +0200, Amir Goldstein wrote:
> [adding cc: linux-xfs]
> 
> On Sun, Nov 5, 2017 at 10:17 AM, L A Walsh <lkml@tlinx.org> wrote:
> > Amir Goldstein wrote:
> >>
> >>
> >>
> >>>
> >>> I then created a new xfs file system and mounted it on '/edge';
> >>>
> >>>    Ishtar:/edge> xfs_info .
> >>>    meta-data=/dev/Data/Edge     isize=256    agcount=32,
> >>>    agsize=16777200 blks     =                   sectsz=4096  attr=2
> >>>    data     =                   bsize=4096   blocks=536870400, imaxpct=5
> >>>             =                   sunit=16     swidth=64 blks
> >>>    naming   =version 2          bsize=4096   ascii-ci=0
> >>>    log      =internal           bsize=4096   blocks=262143, version=2
> >>>             =                   sectsz=4096  sunit=1 blks, lazy-count=1
> >>>    realtime =none               extsz=4096   blocks=0, rtextents=0
> >>>
> >>>
> >>
> >>
> >> Your problem is that you do not have "ftype" feature in directory
> >> name format, like this:
> >>
> >> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> >>
> >> Perhaps you have an old version of mkfs.xfs, not sure when
> >> ftype=1 became the default format, but you can try to
> >>   mkfs.xfs -n ftype=1
> >>
> >
> > ----  Ah... no .. last I was told, if you turned on ftype=1,
> > you had to also pull in crc'ing of all the meta-info.
> > That has problems -- causes errors where there would be no
> > problem, and was never tested on mature file systems that were
> > already fragmented.
> >
> >
> > Do you know if it was separated from crc32 -- for some inexplicable reason,
> > if you wanted ftype, then the crc option would be forced on for you.

Are you still getting all worked up about how metadata CRCs and
the v5 on-disk format is going to make the sky fall, Linda? It's
time to give in and come join us on the dark side...

> I don't know if there was a specific reason, but that's the way it is.

ftype was implemented as part of the format changes for the v5
format so it's always enabled for v5 filesystems.  It was introduced
as a mkfs option for the v4 format in early 2014, and since mid-2015
it's been the default for non-crc filesystems:

# mkfs.xfs -f -m crc=0 /dev/vdb
.....
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
.....

Users should try to keep your userspace tools up to date with the
kernel being run.... :)

> > I didn't want it as I didn't want it to flag errors in metadata that
> > wasn't crucial and didn't want the speed slowdown.  Sigh.
> >
> > The problem on crc'ing the meta data, is that there is ALOT more meta
> > data where detecting it will do more harm than good (like what nanosecond
> > the file was last changed, for example).  I first ran into it
> > taking the disk offline when I changed the guid on a newly formatted disk.
> > That was fixed, but that was a warning shot...   How annoying.
> >
> 
> I have never heard about those issues that you raise.
> It sounds like a myth about XFS metadata CRC that should be debunked
> so forwarding your message on to XFS list.

FYI, Amir.

Keep in mind that a lot of people didn't like the concept of
metadata CRCs in XFS because .... reasons.  There has been a history
of people jumping on bugs and/or not-yet-implemented feature as
justification for their opposition to the change. Call it the nature
of the vocal minority - most users haven't noticed and don't care
that their new install of their distro of choice is now using CRC
enabled filesystems by default....

As to the issue that Linda raised, yes, it *did* exist.  We baked
the UUID into the metadata format so we knew what filesystem owns a
specific metadata block. Handy for detecting stale metadata on a
reused device as well as misdirected writes.  We knew about it from
the start (all the tools had to be modified to disallow changing
UUIDS on v5 filesystems!) but it just wasn't an important enough
requirement to have this functionality up front for CRC enabled
filesystems.

However, it wasn't clear what the solution was to the "change UUID"
problem when CRCs were ready, and we also needed to understand the
behaviour of cloned v5 filesystems on COW based snapshots before we
made any sort of change that could require rewriting all the
metadata in the filesystem. So it took some time for the issue to
come to the top of the "remaining problems to solve" and when it did
we had already built up enough knowledge about v5 filesystem
behaviour to determine the best way to solve the problem.

IOWs, it was always the plan to support it so that tools like
xfs_copy worked properly with v5 filesystems, but it wasn't a
primary concern compared to making CRCs robust. It was fixed
a couple of years ago:

commit 9c4e12fb60c15dc9c5e54041c9679454b42cb23e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon Aug 3 10:45:00 2015 +1000

    xfsprogs: Add new sb_meta_uuid field, update userspace tools to manipulate it
    
    This adds a new superblock field, sb_meta_uuid.  This allows us to
    change the use-visible UUID on crc-enabled filesytems from userspace
    if desired, by copying the existing UUID to the new location for
    metadata comparisons.  If this is done, an incompat flag must be
    set to prevent older filesystems from mounting the filesystem, but
    the original UUID can be restored, and the incompat flag removed,
    with a new xfs_db / xfs_admin UUID command, "restore."
    
    Much of this patch mirrors the kernel patch in simply renaming
    the field used for metadata uuid comparison; other bits:
    
    * Teach xfs_db to print the new meta_uuid field
    * Allow xfs_db to generate a new UUID for CRC-enabled filesystems
    * Allow xfs_db to revert to the original UUID and clear the flag
    * Fix up xfs_copy to work with CRC-enabled filesystems
    * Update the xfs_admin manpage to show the UUID "restore" command
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

> See also https://www.spinics.net/lists/xfs/msg19079.html

Yeah, that was in reaction to the loud claims that "CRCs are going
to slow everything down". Late last year we significantly reduced
the CPU overhead of CRC calculation on the write side , so it drops
off the CPU profiles in the workloads described in that like above
almost entirely. This was the commit:

commit cae028df53449905c944603df624ac94bc619661
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Dec 5 14:40:32 2016 +1100

    xfs: optimise CRC updates
    
    Nick Piggin reported that the CRC overhead in an fsync heavy
    workload was higher than expected on a Power8 machine. Part of this
    was to do with the fact that the power8 CRC implementation is not
    efficient for CRC lengths of less than 512 bytes, and so the way we
    split the CRCs over the CRC field means a lot of the CRCs are
    reduced to being less than than optimal size.
    
    To optimise this, change the CRC update mechanism to zero the CRC
    field first, and then compute the CRC in one pass over the buffer
    and write the result back into the buffer. We can do this safely
    because anything writing a CRC has exclusive access to the buffer
    the CRC is being calculated over.
    
    We leave the CRC verify code the same - it still splits the CRC
    calculation - because we do not want read-only operations modifying
    the underlying buffer. This is because read-only operations may not
    have an exclusive access to the buffer guaranteed, and so temporary
    modifications could leak out to to other processes accessing the
    buffer concurrently.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
