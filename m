Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23930 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbeJRSFb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 14:05:31 -0400
Date: Thu, 18 Oct 2018 21:05:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181018100504.GH6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

[ hmmm, there's some whacky utf-8 whitespace characters in the
 copy-n-pasted text... ]

On Thu, Oct 18, 2018 at 10:55:18AM +0300, Avi Kivity wrote:
> 
> On 18/10/2018 04.37, Dave Chinner wrote:
> >On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
> >>I have a user running a 1.7TB filesystem with ~10% usage (as shown
> >>by df), getting sporadic ENOSPC errors. The disk is mounted with
> >>inode64 and has a relatively small number of large files. The disk
> >>is a single-member RAID0 array, with 1MB chunk size. There are 32

Ok, now I need to know what "single member RAID0 array" means,
becuase this is clearly related to allocation alignment and I need
to know why the FS was configured the way it was.

It's one disk? Or is it a hardware RAID0 array that presents as a
single lun with a stripe width of 1MB? if so, how many disks aer in
it? If the chunk size the stripe unit (per disk chunk size) or the
stripe width (all disks get hit by a 1MB IO)

Or something else? 

> >>AGs. Running Linux 4.9.17.
> >ENOSPC on what operation? write? open(O_CREAT)? something else?
> 
> 
> Unknown.
> 
> 
> >What's the filesystem config (xfs_info output)?
> 
> 
> (restored from metadata dump)
> 
> 
> meta-data=/dev/loop2		isize=512 agcount=32, agsize=14494720 blks
>          =                    sectsz=512 attr=2, projid32bit=1
>          =                    crc=1 finobt=0 spinodes=0 rmapbt=0
>          =                    reflink=0
> data     =                    bsize=4096 blocks=463831040, imaxpct=5
>          =                    sunit=256 swidth=256 blks

sunit=swidth is unusual for a RAID0 array, unless it's hardware RAID
and the array only reports one number to mkfs. What this chosen by
mkfs, or specifically configured by the user? If specifically
configured, why?

What is important is that it means aligned allocations will be used
for any allocation that is over sunit (1MB) and that's where all the
problems seem to come from.

> naming   =version 2           bsize=4096 ascii-ci=0 ftype=1
> log      =internal            bsize=4096 blocks=226480, version=2
>          =                    sectsz=512 sunit=8 blks, lazy-count=1
> realtime =none                extsz=4096 blocks=0, rtextents=0
> 
> > Has xfs_fsr been run on this filesystem
> >regularly?
> 
> 
> xfs_fsr has never been run, until we saw the problem (and then did
> not fix it).  IIUC the workload should be self-defragmenting: it
> consists of writing large files, then erasing them. I estimate that
> around 100 files are written concurrently (from 14 threads), and
> they are written with large extent hints. With every large file,
> another smaller (but still large) file is written, and a few
> smallish metadata files.

Do those smaller files get removed when the big files are removed?

> I understood from xfs_fsr that it attempts to defragment files, not
> free space, although that may come as a side effect. In any case I
> ran xfs_db after xfs_fsr and did not see an improvement.

xfs_fsr takes fragmented files and contiguous free space and turns
it into contiguous files and fragmented free space. You have
fragmented free space, so I needed to know if xfs_fsr was
responsible for that....

> >If the ENOSPC errors are only from files with a 32MB extent size
> >hints on them, then it may be that there isn't sufficient contiguous
> >free space to allocate an entire 32MB extent. I'm not sure what the
> >allocator behaviour here is (the code is a maze of twisty passages),
> >so I'll have to look more into this.
> 
> There are other files with 32MB hints that do not show the error
> (but on the other hand, the error has been observed few enough times
> for that to be a fluke).

*nod*

> >In the mean time, can you post the output of the freespace command
> >(both global and per-ag) so we can see just how much free space
> >there is and how badly fragmented it has become? I might be able to
> >reproduce the behaviour if I know the conditions under which it is
> >occuring.
> 
> 
> xfs_db> freesp
>  from      to  extents    blocks    pct
>  1          1     5916      5916   0.00
>  2          3    10235     22678   0.01
>  4          7    12251     66829   0.02
>  8         15     5521     59556   0.01
>  16        31     5703    132031   0.03
>  32        63     9754    463825   0.11
>  64       127    16742   1590339   0.37
>  128      255   550511 390108625  89.87
>  256      511    71516  29178504   6.72
>  512     1023       19     15355   0.00
>  1024    2047      287    461824   0.11
>  2048    4095      528   1611413   0.37
>  4096    8191     1537  10352304   2.38
>  8192   16383        2     19015   0.00
> 
> Just 2 extents >= 32MB (and they may have been freed after the error).

Yes, and the vast majority of free space is in lengths between 512kB
and 1020kB. This is what I'd expect if you have large, stripe
aligned allocations interleaved with smaller, sub-stripe unit
allocations.

As an example of behaviour that can leads to this sort of free space
fragmentation, start with 10 stripe units of contiguous free space:

  0    1    2    3    4    5    6    7    8    9    10
  +----+----+----+----+----+----+----+----+----+----+----+

Now allocate a > stripe unit extent (say 2 units):

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLL+----+----+----+----+----+----+----+----+----+

Now allocate a small file A:

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLLAA---+----+----+----+----+----+----+----+----+

Now allocate another large extent:

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLLAA---LLLLLLLLLL+----+----+----+----+----+----+

After a while, a significant part of your filesystem looks like
this repeating pattern:

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLLAA---LLLLLLLLLLBB---LLLLLLLLLLCC---LLLLLLLLLLDD---+

i.e. there are lots of small, isolated sub stripe unit free spaces.
If you now start removing large extents but leaving the small
files behind, you end up with this:

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLLAA---+---------BB---LLLLLLLLLLCC---+----+----DD---+

And now we go to allocate a new large+small file pair (M+n)
they'll get laid out like this:

  0    1    2    3    4    5    6    7    8    9    10
  LLLLLLLLLLAA---MMMMMMMMMMBB---LLLLLLLLLLCC---nn---+----DD---+

See how we lost a large aligned 2MB freespace @ 9 when the small
file "nn" was laid down? repeat this fill and free pattern over and
over again, and eventually it fragments the free space until there's
no large contiguous free spaces left, and large aligned extents can
no longer be allocated.

For this to trigger you need the small files to be larger than 1
stripe unit, but still much smaller than the extent size hint, and
the small files need to hang around as the large files come and go.

> >>Is this a known issue?

The effect and symptom is - it's a generic large aligned extent vs small unaligned extent
issue, but I've never seen it manifest in a user workload outside of
a very constrained multistream realtime video ingest/playout
workload (i.e. the workload the filestreams allocator was written
for). And before you ask, no, the filestreams allocator does not
solve this problem.

The most common manifestation of this problem has been inode
allocation on filesystems full of small files - inodes are allocated
in large aligned extents compared to small files, and so eventually
the filesystem runs out of large contigouous freespace and inodes
can't be allocated. The sparse inodes mkfs option fixed this by
allowing inodes to be allocated as sparse chunks so they could
interleave into any free space available....

> >>Would upgrading the kernel help?
> >Not that I know of. If it's an extszhint vs free space fragmentation
> >issue, then a kernel upgrade is unlikely to fix it.

Upgrading the kernel won't fix it, because it's an extszhint vs free
space fragmentation issue.

Filesystems that get into this state are generally considered
unrecoverable.  Well, you can recover them by deleting everythign
from them to reform contiguous free space, but you may as well just
mkfs and restore from backup because it's much, much faster than
waiting for rm -rf....

And, really, I expect that a different filesystem geometry and/or
mount options are going to be needed to avoid getting into this
state again. However, I don't really know enough yet about what in
the workload and allocator is triggering to cause the issue to say
yet.

Can I get access to the metadump to dig around in the filesystem
directly so I can see how everything has ended up laid out? that
will help me work out what is actually occurring and determine if
mkfs/mount options can address the problem or whether deeper
allocator algorithm changes may be necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
