Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:37757 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750979AbcLDWqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 17:46:37 -0500
Date: Mon, 5 Dec 2016 09:46:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161204224604.GN31101@dastard>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 04, 2016 at 02:07:18PM -0800, Cyril Peponnet wrote:
> Hi here is the details. The issue is on the scratch RAID array
> (used to store kvm snapshots). The other raid array is fine (no
> snapshot storage).

How do you know that? There's no indication which filesystem is
generating the warnings....

FWIW, the only gluster snapshot proposal that I was aware of
was this one:

https://lists.gnu.org/archive/html/gluster-devel/2013-08/msg00004.html

Which used LVM snapshots to take snapshots of the entire brick. I
don't see any LVM in your config, so I'm not sure what snapshot
implementation you are using here. What are you using to take the
snapshots of your VM image files? Are you actually using the
qemu qcow2 snapshot functionality rather than anything native to
gluster?

Also, can you attach the 'xfs_bmap -vp' output of some of these
image files and their snapshots?

> MemTotal:       65699268 kB

64GB RAM...

> MemFree:         2058304 kB
> MemAvailable:   62753028 kB
> Buffers:              12 kB
> Cached:         57664044 kB

56GB of cached file data. If you're getting high order allocation
failures (which I suspect is the problem) then this is a memory
fragmentation problem more than anything.

> ----------------------------------------------------------------
> DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
> ----------------------------------------------------------------
> 0/0   RAID0 Optl  RW     Yes     RAWBC -   ON  7.275 TB scratch
> ----------------------------------------------------------------
> 
> Cac=CacheCade|Rec=Recovery|OfLn=OffLine|Pdgd=Partially Degraded|dgrd=Degraded
> Optl=Optimal|RO=Read Only|RW=Read Write|HD=Hidden|B=Blocked|Consist=Consistent|
> R=Read Ahead Always|NR=No Read Ahead|WB=WriteBack|
> AWB=Always WriteBack|WT=WriteThrough|C=Cached IO|D=Direct IO|sCC=Scheduled

IIRC, AWB means that if the cache goes into degraded/offline mode,
you're vulnerable to corruption/loss on power failure...

> xfs_info /export/raid/scratch/
> meta-data=/dev/sdb               isize=256    agcount=32, agsize=61030368 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0
> data     =                       bsize=4096   blocks=1952971776, imaxpct=5
>          =                       sunit=32     swidth=128 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=32 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Nothing unusual there.

> Nothing relevant in dmesg except several occurences of the following.
> 
> [7649583.386283] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [7649585.370830] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [7649587.241290] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [7649589.243881] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

Ah, the kernel is old enough it doesn't have the added reporting to
tell us what the process and size of the allocation being requested
is.

Hmm - it's an xfs_err() call, thet means we should be able to get a
stack trace out of the kernel if we turn the error level up to 11.

# echo 11 > /proc/sys/fs/xfs/error_level

And wait for it to happena again. that should give a stack trace
telling us where the issue is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
