Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43322C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 23:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiEIXNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 19:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiEIXNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 19:13:18 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9783D29743E
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 16:09:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AE33810E685C;
        Tue, 10 May 2022 09:09:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noCVC-00A4co-S1; Tue, 10 May 2022 09:09:18 +1000
Date:   Tue, 10 May 2022 09:09:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220509230918.GP1098723@dread.disaster.area>
References: <20220509024659.GA62606@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509024659.GA62606@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62799f20
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=OLL_FvSJAAAA:8 a=7-415B0cAAAA:8
        a=8q2NJRt9hQQj-dwuChcA:9 a=CjuIK1q_8ugA:10 a=PZhDsIxkz20A:10
        a=2wtbIlPCfvEA:10 a=k94env-yiv8A:10 a=WiLHPiwbDYUA:10 a=CCiWsZzRJ6MA:10
        a=uKxFKzgTu3oA:10 a=oIrB72frpwYPwTMnlWqB:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> Hi,
> 
> Is it to be expected that removing 29TB of highly reflinked and fragmented
> data could take days, the entire time blocking other tasks like "rm" and
> "df" on the same filesystem?
> 
> - is any way to see progress and make an eta estimate?
> - would 4700+ processes blocked on the same fs slow things down or they're
> not relevant?
> - with a reboot/remount, does the log replay continue from where it left
> off, or start again?
> - is there anything that might improve the situation in newer kernels?
> 
> Some details:
> 
> # uname -r
> 5.15.34-otn-00007-g6bff5dd37abb
> 
> # xfs_info /chroot
> meta-data=/dev/mapper/vg00-chroot isize=512    agcount=282, agsize=244184192 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=68719475712, imaxpct=1
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The fs is sitting on lvm and the underlying block device is a ceph 8+3
> erasure-coded rbd.

Ok, so -slow- storage.

> This fs was originally 30T and has been expanded to 256T:
> 
>   Limits to growth
>   https://www.spinics.net/lists/linux-xfs/msg60451.html
> 
> And it's been the topic of a few other issues:
> 
>   Extreme fragmentation ho!
>   https://www.spinics.net/lists/linux-xfs/msg47707.html
> 
>   Mysterious ENOSPC
>   https://www.spinics.net/lists/linux-xfs/msg55446.html
> 
> The story...
> 
> I did an "rm -rf" of a directory containing a "du"-indicated 29TB spread
> over maybe 50 files. The data would have been highly reflinked and
> fragmented. A large part of the reflinking would be to files outside the dir
> in question, and I imagine maybe only 2-3TB of data would actually be freed
> by the "rm".

But it's still got to clean up 29TB of shared extent references.
Assuming worst case reflink extent fragmentation of 4kB filesystem
blocks, 29TB is roughly 7 *billion* references that have to be
cleaned up.

TANSTAAFL.

A single CPU running flat out that isn't limited by log space or
metadata writeback can unshare and free about 80-100k extents a
second. If you are either RAM or IO bound, then you might only be
able to remove a few thousand a second as throughput is limited by
the random metadata writeback rate to free journal space for the
next transaction.

OOOOOOH.

>          =                       crc=1        finobt=1, sparse=1, rmapbt=1

You have rmapbt enabled. That significantly increases the amount of
metadata every reflink operation has to update. Every shared extent
that is removed, the rmap index has to be updated to remove that
back-reference from rmapbt. When there is heavy extent sharing
occurring, the rmaps get *large*. e.g. share a single block 100
times, there is one refcount record for the 100 references. BUt
there are 100 rmap records - one for each of the 100 references to
to the block. IOWs, reflink is efficiently recording reference
counts, but rmap cannot as every owner/offset tuple is different for
each shared extent owner.

Likely that means that the maximum sustainable unshare rate is going
to be halved - so maybe a max of 40-50k reference removals/s

> The "rm" completed in less than a second, but an immediately following "df"
> on that fs didn't return, even 60+ hours later(!!).

At 10k refs/s removed , that's 3hrs/100M or 30hrs/billion references.

At a 1k refs/s removed, that's 3.6 million refs/hr an hour, or
~30hrs/100M refs.

At a 100 refs/s removed, that's 360k million refs/hr an hour, or
~300hrs/100M refs.

And it's entire possible you asked the filesystem to remove a
billion shared references.....

> In the meantime, other background processes where also attempting to do
> various "rm"s (small amounts of non-reflinked data) and "df"s on the same fs
> which were also hanging - building up to an load average of 4700+(!!) over

Nothing wrong with a load average of 4700 - it's common to see that
sort of thing when there is lots of IO operations in flight.  All it
is telling you is that the system has a massive IO backlog.

> time. A flame graph showed the kernel with 75% idle and 3.75% xfsaild as the
> largest users, and the rest a wide variety of other uninteresting stuff. A
> "sysrq w" showed the tasks blocking in xfs_inodegc_flush, e.g.:

Yeah, I've been considering removing that blocking flush for reasons
like this.  That's not your problem, though.

i.e. If the unlink hadn't been put in the background, you'd be
complaining that rm had hung, the system is overloaded, IO bound
and you can't kill the rm. ANd then after reboot, log recovery
caused the same problem....

So what you see really has nothing to do with background inodegc
at all...

> Iostat showed consistent high %util and high latencies. E.g. a combined load
> average and iostat output at 66 hours after the initial "df" started:
> 
>            load %user %nice  %sys  %iow  %stl %idle  dev rrqm/s wrqm/s    r/s    w/s    rkB/s    wkB/s  arq-sz  aqu-sz    await   rwait   wwait %util
> 07:55:32 4772.3   0.0   0.0   0.2   0.8   0.0  98.8 rbd0    0.0    0.0    0.5   27.9     1.80   530.20   37.46   25.87   911.07   34.67   925.2  97.0
> 07:55:52 4772.1   0.0   0.0   0.2   0.0   0.0  99.7 rbd0    0.0    0.0    0.9   17.2     3.60   548.20   60.97    7.64   422.22   11.83   443.7  99.2
> 07:56:12 4772.1   0.0   0.0   0.3   1.9   0.0  97.6 rbd0    0.0    0.5    0.2   46.9     1.00   513.00   21.80   46.06   976.91  304.40   980.5  96.3
> 07:56:32 4773.1   0.0   0.0   0.3   1.7   0.0  97.8 rbd0    0.0    0.0    0.5   12.9     1.80   306.20   45.97    6.81   508.09    4.67   525.6  57.8
> 07:56:52 4773.8   0.0   0.0   0.3   1.4   0.0  98.0 rbd0    0.0    0.1    0.7   40.4     2.60   591.80   28.96   32.70   796.60  163.23   806.8  92.2
> 07:57:12 4774.4   0.1   0.0   0.3   1.8   0.0  97.7 rbd0    0.0    0.3    0.2   43.1     0.80   541.80   25.06   42.13   973.05   15.25   977.5  84.0
> 07:57:32 4774.8   0.2   0.0   0.7   2.3   0.0  96.5 rbd0    0.0    0.1    0.5   35.2     2.00   496.40   27.92   30.25   847.35    9.00   859.3  85.7
> 07:57:52 4775.4   0.0   0.0   0.4   1.6   0.0  97.7 rbd0    0.0    0.2    0.7   45.1     2.80   510.80   22.43   42.88   936.33   76.21   949.7  73.6

Yup, the system is IO bound on 4kB random write IO, managing a
healthy total of about _200 IOPS_ and less than 4MB/s to disk.
In short, I don't think you system is even managing 100 reference
removals a second - maybe 50 refs/s are being removed because it is
completely IO bound on dirty metadata writeback...

IOWs, the problem here is that  you asked the filesystem to perform
*billions* of update operations by running that rm -rf command and
your storage simply isn't up to performing such operations.

What reflink giveth you, reflink taketh away.

> Apart from the iostat there was no other indication any progress was being
> made.
> 
> Eventually I thought that perhaps the excessive numbers of blocked processes
> might be adding to the woes by causing thundering herd problems and the
> like, and decided to reboot the box as the only way to remove those tasks,
> with the understanding the journal to be replayed before the fs mount would
> complete.

Nope, I'd put my house on it not completing journal replay....

> There were few more reboots and mount(-attempts) over the next day as I was
> messing around with things - turning off the background processes causing
> the ever-increasing loads, taking lvm snapshots, upgrading to the latest
> stable version of the kernel etc.
> 
> I'm now wondering if each mount continues from whence the previous
> mount(-attempt) left off, or does it start processing the replay log again
> from the very beginning?

.... because log recovery runs garbage collection of unlinked
inodes, which was what was running when you rebooted the system.
Only now, you can't access the filesystem at all because it won't
complete the mount process....

> It's now been 40 hours since the most recent reboot/mount and the mount
> process is still running. The load average is a more reasonable <10, and the
> iostat is similar to above.

Yup, because there's only hte background inodegc workers operating
on the filesystem and you don't have other processes trying to do
data IO on it as it hasn't finished mounting yet. The filesystem is
doing the same amount of work, making the same progress, yet the
load average is only 10.

Load average is a very poor measure of the load that is actually on
the system......

> Is there any way to see where the log replay is up to, and from there make a
> judgement on how much longer it might take, e.g. something in xfs_db, or
> some eBPF wizardry?

Not really. tracepoints can tell you the operations going on, and if
you know enough about the internals of XFS they might tell you how
many extents still remain on the inodes to remove....

> I tried using xfs_logprint but I'm not sure what it's telling me, and
> multiple versions taken 10 minutes apart don't show any differences that are
> obviously "progress" - the only differences are in q:0x[[:xdigit:]]+ in the
> TRANS entries, and in a:0x[[:xdigit:]]+ in the INO entries, e.g.:

logprint just dumps the active transactions in the log - the ones
that are waiting on metadata writeback to move the tail of the log
forwards and retire the transaction.

What you see here:

> t1:
> TRANS: tid:0xcf6e0775  #items:50029  trans:0xcf6e0775  q:0x563417886560
> ...
> t1+10s:
> TRANS: tid:0xcf6e0775  #items:50029  trans:0xcf6e0775  q:0x55b5d8815560

Is the same transaction in the journal. all that changed was the
"a:" fields which are the memory address of the region buffer in
logprint and have nothing to do with what is in the journal itself.
It's largely logprint debug information.

IOWs, all this tells us is that the tail of the log is not moving
very fast, which tallies with the really slow storage doing random
writes and being unable to move the tail of the log forwards very
quickly.

Indeed, let me put that in context - this transaction has 50,000
items in it. THat's going to take at _least_ 10,000 IOs to write
back all that metadata. at maybe 100 IOs/s, just clearing this
transaction to free up the log space (maybe 32MB of journal space
out of 2GB) will take at least 2 minutes.....

And the rest of the journal will have a similar density of items to
be flushed, so 2GB/32MB = 128 * 2 minutes = 4 hours. SO even if the
unlinks stopped right now, there's a backlog of at least 4 hours
worth of dirty metadata to flush to disk. Either unmount of log
recovery would take this long to run at that point.

Also, that inode had 1.6 million extents and mapped just under 1TB
of data. At 100 refs/s being removed, that's 16,000 seconds to clean
up that inode. If that is representative of the other files, then 50
x 16,0000 is roughly 10 days....

At some point, you have to pay the price of creating billions of
random fine-grained cross references in tens of TBs of data spread
across weeks and months of production. You don't notice the scale of
the cross-reference because it's taken weeks and months of normal
operations to get there. It's only when you finally have to perform
an operation that needs to iterate all those references that the
scale suddenly becomes apparent. XFS scales to really large numbers
without significant degradation, so people don't notice things like
object counts or cross references until something like this
happens.

I don't think there's much we can do at the filesystem level to help
you at this point - the inode output in the transaction dump above
indicates that you haven't been using extent size hints to limit
fragmentation or extent share/COW sizes, so the damage is already
present and we can't really do anything to fix that up.

I'm also not sure that xfs_repair will help at this point because it
has to pull the entire filesystem metadata into memory.  I suspect
that you don't have a couple of TB of RAM or really fast SSD swap
space to throw at that problem (might need both!). I've seen repair
take 3 weeks and 250GB of RAM to resolve a corrupted 14TB hardlink
farm containing a couple of billion hardlinks on similar slow RAID 6
storage. I don't expect repair will be any faster resolving a couple
of billion reflink and rmap references, but I do expect that to
require a whole lot more memory than hardlink resolution. repair
will garbage collect the unlinked inodes without any additional
overhead, but the baseline overhead is likely prohibitive....

Another option might be to get a fast 1-2TB NVMe SSD (or two or 3)
and build a cache teir over the top of the ceph rbds using dm-cache.
That way the cache teir can suck up all the small random writes and
the garbage collection will run much faster. When it is done, run a
fstrim on the filesystem to clear all the previously written but now
free space from the cache device, then flush the cache device back
to storage. That last flush will likely take a long, long time
because it will all be small random writes, but should be many less
than what the filesystem needed to run to clean up the billions of
cross references the reflinks created....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
