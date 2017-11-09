Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64631 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752289AbdKIBra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 20:47:30 -0500
Date: Thu, 9 Nov 2017 12:47:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Message-ID: <20171109014726.GI4094@dastard>
References: <59FA4499.2030502@tlinx.org>
 <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
 <59FEC912.4000005@tlinx.org>
 <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com>
 <20171105223445.GA5858@dastard>
 <5A03754E.5070903@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A03754E.5070903@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <lkml@tlinx.org>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Nov 08, 2017 at 01:21:18PM -0800, L A Walsh wrote:
> Dave Chinner wrote:
> >Are you still getting all worked up about how metadata CRCs and
> >the v5 on-disk format is going to make the sky fall, Linda? It's
> >time to give in and come join us on the dark side...
> ---
>    I don't believe I've heard that the sky would fall.  I only had
> 2 issues -- 1 that metadata that I that I didn't care about or that I
> wanted to change would be crc'd and prevent changing meta data I wanted
> to change or would flag errors in meta data I didn't care about
> (file last access time being a nanosecond or a day off due to bit rot
> and crc flagging it as an error.
> 
>    Maybe you might remember, I first ran into this when,  as part of
> my mkfs procedure, I assigned my own value to my disk's UUID, and at the
> time, the crc-feature claimed the disk had a fault in it.

Yes, but changing the UUID was documented as "not currently
supported" on v5 filesystems *when it was originally released*.
IOWs, it was documented as "will be supported in future", but it
wasn't a critical feature for the initial release of CRC enabled
filesystems.

If someone manually changed the UUID (which was the only way to do
it because the xfs_db commands would refuse to do it) then *it broke
the filesystem* and so it was correct behaviour to report
corruption.

Changing the UUID on v5 filesystems is now implemented and
supported:

$ sudo mkfs.xfs -f /dev/pmem0
Default configuration sourced from package build definitions
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25, thinblocks=0
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$
$ sudo blkid -c /dev/null /dev/pmem0
/dev/pmem0: UUID="7073fe11-4b44-4160-a8a0-dec492f61a14" TYPE="xfs"
$
$ sudo xfs_admin -U generate /dev/pmem0
Clearing log and setting UUID
writing all SBs
new UUID = c3a4f999-b76a-4597-bb62-df11c5e3fc04
$
$ sudo blkid -c /dev/null /dev/pmem0
/dev/pmem0: UUID="c3a4f999-b76a-4597-bb62-df11c5e3fc04" TYPE="xfs"
$

IOWs, this problem is ancient history. Move on, nothing to see here.

>    My second issue was it being tied to the finobt feature in a way that
> precluded benchmarking changes on our own filesystems and workload.

[....]

>    I would expect that, especially since finobt would benefit more mature
> file systems more than newer ones.  While on newer file systems, finobt+crc
> comes out to about the same performance.
> 
>    My issue was the inability to bench or use them separately.

<sigh>

Not an XFS problem:

$ mkfs.xfs -f -m finobt=0 /dev/pmem0
....
         =                       crc=1        finobt=0, sparse=0, rmapbt=0, reflink=0
.....

Yup, crc's enabled, finobt is not. As documented in the mkfs.xfs man
page.

IOWs, We can directly measure the impact of the finobt on
workloads/benchamrks. And if we want to compare the impact of CRCs,
then 'mkfs.xfs -f -isize=512, -m crc=0 <dev>' will be directly
comparable to the above non-finobt filesystem. THis is how we
benchmarked the changes in the first place....

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
