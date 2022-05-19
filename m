Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DD3C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 06:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiESGdq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 02:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiESGdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 02:33:45 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 779135F27F
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 23:33:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 09CFC10E67F4;
        Thu, 19 May 2022 16:33:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrZj8-00Dknf-Jg; Thu, 19 May 2022 16:33:38 +1000
Date:   Thu, 19 May 2022 16:33:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fstrim and strace considered harmful?
Message-ID: <20220519063338.GY1098723@dread.disaster.area>
References: <20220518065949.GA1237408@onthe.net.au>
 <20220518070713.GA1238882@onthe.net.au>
 <YoUXxBe1d7b29wif@magnolia>
 <20220518223606.GA1343027@onthe.net.au>
 <20220519005014.GS1098723@dread.disaster.area>
 <20220519023351.GA1359964@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519023351.GA1359964@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6285e4c5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=XQkycvrNeREDh5inAcUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 12:33:51PM +1000, Chris Dunlop wrote:
> On Thu, May 19, 2022 at 10:50:14AM +1000, Dave Chinner wrote:
> > On Thu, May 19, 2022 at 08:36:06AM +1000, Chris Dunlop wrote:
> > > On Wed, May 18, 2022 at 08:59:00AM -0700, Darrick J. Wong wrote:
> > > > On Wed, May 18, 2022 at 05:07:13PM +1000, Chris Dunlop wrote:
> > > > > Oh, sorry... on linux v5.15.34
> > > > > 
> > > > > On Wed, May 18, 2022 at 04:59:49PM +1000, Chris Dunlop wrote:
> > > > > > I have an fstrim that's been running for over 48 hours on a 256T thin
> > > > > > provisioned XFS fs containing around 55T of actual data on a slow
> > > > > > subsystem (ceph 8,3 erasure-encoded rbd). I don't think there would be
> > > > > > an an enourmous amount of data to trim, maybe a few T, but I've no idea
> > > > > > how long how long it might be expected to take. In an attempt to see
> > > > > > what the what the fstrim was doing, I ran an strace on it. The strace
> > > > > > has been sitting there without output and unkillable since then, now 5+

And now I sort of understand why strace appeared hung. read below....

> > > > > > hours ago.  Since the strace, on that same filesystem I now have 123 df
> > > > > > processes and 615 rm processes -- and growing -- that are blocked in
> > > > > > xfs_inodegc_flush, e.g.:
> ...
> > I suspect that it's just that your storage device is really slow at
> > small trims. If you didn't set a minimum trim size, XFS will issue
> > discards on every free space in it's trees. If you have fragmented
> > free space (quite possible if you're using reflink and removing
> > files that have been reflinked and modified) then you could have
> > millions of tiny free spaces that XFS is now asking the storage to
> > free.
> > 
> > Dumping the free space histogram of the filesystem will tell us just
> > how much work you asked the storage to do. e.g:
> 
> # xfs_spaceman -c freesp /vol
>    from      to extents  blocks    pct
>       1       1    2368    2368   0.00
>       2       3    4493   11211   0.00
>       4       7    6827   38214   0.00
>       8      15   12656  144036   0.00
>      16      31   35988  878969   0.00
>      32      63  163747 8091729   0.01
>      64     127  248625 22572336   0.04
>     128     255  367889 71796010   0.11
>     256     511  135012 48176856   0.08
>     512    1023   92534 74126716   0.12
>    1024    2047   13464 18608536   0.03
>    2048    4095    3873 10930189   0.02
>    4096    8191    1374 7886168   0.01
>    8192   16383     598 6875977   0.01
>   16384   32767     340 7729264   0.01
>   32768   65535     146 6745043   0.01
>   65536  131071      48 4419901   0.01
>  131072  262143      12 2380800   0.00
>  262144  524287       5 1887092   0.00
>  524288 1048575       2 1105184   0.00
> 1048576 2097151       4 5316211   0.01
> 2097152 4194303       3 8747030   0.01
> 4194304 8388607      65 522142416   0.83
> 8388608 16777215       2 21411858   0.03
> 67108864 134217727       4 379247828   0.60
> 134217728 268434432     236 62042143854  98.05
> 
> I guess from/to are in units of filesystem blocks, 4kB in this case?

Yes.

> 
> Not that it makes much difference here, but the sake of accuracy... does the
> default fstrim without range/size args issue discard requests for *all* the
> extents, or, if I'm reading this right:
> 
> fs/xfs/xfs_discard.c
> --
> xfs_ioc_trim(
>         struct xfs_mount                *mp,
>         struct fstrim_range __user      *urange)
> {
>         struct request_queue    *q = bdev_get_queue(mp->m_ddev_targp->bt_bdev);
>         unsigned int            granularity = q->limits.discard_granularity;
> ...
>         if (copy_from_user(&range, urange, sizeof(range)))
>                 return -EFAULT;
> 
>         range.minlen = max_t(u64, granularity, range.minlen);
> ...
> }
> 
> ...does it take into account /sys/block/xxx/queue/discard_granularity, in

Yes, that's the sysfs file that exports the current value of
q->limits.discard_granularity.

> this case 64kB, or 16 blocks @ 4kB, so issuing discards only for extents
> > = 16 blocks?

Yes. But that's not the same on every device. My local nvme SSDs
give:

$ cat /sys/block/nvme0n1/queue/discard_granularity
512
$

So the disk has a granualrity of 1 sector or 512 bytes. Hence fstrim
will try to trim right down to single filsystem block free spaces by
default.

> 
> > > The open question is what caused the stuck processes?
> > 
> > Oh, that's easy the easy bit to explain: discard runs with the AGF
> > locked because it is iterating the free space tree directly. Hence
> > operations on that AG are blocked until all the free space in that
> > AG have been discarded. Could be smarter, never needed to be
> > smarter.
> > 
> > Now inodegc comes along, and tries to free an inode in that AG, and
> > blocks getting the AGF lock during the inode free operation (likely
> > inode chunk freeing of finobt block allocation). Everythign then
> > backs up on inodegc flushes, which is backed up on discard
> > operations....
> 
> I'm not sure that explains how the first stuck process only appeared >48
> hours after initiating the fstrim. Unless that's because it may have finally
> got to the AG(s) with a lot of free extents?

I know why now - see below. It's the same reason the strace is hung.
It took 2 days for fstrim to progress to an AG that had active inode
freeing going on in it.

> # AGs w/ at least 400 free extents: only 31 out of 256 AGs
> #
> d5# xfs_spaceman -c "freesp -gs" /chroot | awk '$2>=400 {print}'         AG
> extents     blocks
>         43      69435   29436263
>         47      14984    5623982
>         48      42482  166285283
>         49      56284  218913822
>         50      10354  240969820
> { sequential range...
>         54      60416   11292928
>         55      72742   15344807
>         56      88455   17204239
>         57      81594   15218624
>         58     126731   27719558
>         59      64525   10047593
>         60      37324    8591083
>         61      57267  113745589
>         62      36501   18360912
>         63       3998  255040699
>         64       2684  258737072
>         65       2047  263904736
>         66       1503  265467595
>         67        920  263457328
>         68       1393  264277701
> }
>         70       1150  266485834
>         72        406  267609078
>         77        429  267479272
>         79        911  267625473
>         80       1182  267354313
> { sequential range...
>        105      39345  151535709
>        106      69512   57950504
>        107      46464   10236142
>        108      40795    8666966
>        109      14431  208027543
>        110      15800  258264227
> }
> total free extents 1090313
> total free blocks 63273250933

That's 250GB of free space in 1 million extents spread across 31
AG btrees. Not a huge deal for the filesystem, but for trim on
a really slow block device....

> average free extent size 58032.2
> 
> The number of free space extents per AG seems oddly "lumpy", e.g. the
> sequential cluster ranges beginning with AGs 54 and 105 with a large number
> of extents. Is that simply due to the pattern of frees in this specific case
> or is there some underlying design to that?

That's likely showing how the allocator uses locality for related
inodes.  The underlying locality algorithm will give files in the
same directory the same target AG.  So if you have a directory with
100 100GB files in them, they will largely all be allocated from AGs
target to target + 10. When you reflink and overwrite, the overwrite
allocations  will also get targetted to the same locality, and so
you'll get lots of small extents allocated across the same AGs, too.
When you then remove one of the reflinked files, only the overwrites
unique to that copy are freed, and now you get new small free spaces
in amongst largely full AGs. DO taht often enough, and you get a
significant number of small free spaces occurring.

IIRC, you last problem was one directory with 50 highly reflinked
files totalling 29TB of capacity - the above is pretty much the sort
of allocation and free space patterns I'd expect to see for that
pattern of data storage....

> > Won't be anywhere near that number - free space in a 256TB
> > filesystem with only 29TB used will have lots of really large
> > contiguous free spaces. Those will get broken down into max discard
> > length chunks, not minimum. Of course, if the bdev is setting a
> > really small max discard size, then that's going to be just a big a
> > problem for you....
> 
> Is this the bdev's max discard size?

Yup.

> # cat /sys/block/dm-0/queue/discard_max_bytes
> 4194304

And that's the problem right there.

What is the value for the underlying ceph rbds? That will tell us
if this number comes from the ceph rbds or the dm layers you have
above the ceph rbds. What are you using for thin provisioning? Is
that the dm layer (dm-thin) or something you are getting from the
ceph rbds?

FWIW, the 1TB nvme drive I mentioned above?

$ cat /sys/block/nvme0n1/queue/discard_max_bytes 
2199023255040
$ echo $(((2**32 - 1 ) * 512))
2199023255040
$

That can handle one sector short of 2TB per discard, which I think
is the maximum the nvme protocol allows in a single discard
operation. IOWs, I can issue a single discard request to free the
entire device.

> And does that mean, for instance, these 236 extents will be split into
> somewhere between 131072 and 262143 individual discard requests (i.e. size
> of extent in bytes divided by discard_max_bytes) being sent to the
> underlying "device" (ceph rbd)?
> 
> # xfs_spaceman -c freesp /vol
>      from        to extents      blocks    pct
> ...
> 134217728 268434432     236 62042143854  98.05

Yes. these are largely empty AGs - most of them have more than half
their space in one large contiguous free extent. And this will be
why the strace appears hung - discarding a single AG full of free
space (1TB) will be done as 250,000+ individual discard operations.

So that's something like 55 million discards for the ~220TB of free
space you have in that filesystem....

As to the strace that has hung - the discard loop has this in it:

                if (fatal_signal_pending(current)) {
                        error = -ERESTARTSYS;
                        goto out_del_cursor;
                }

So if you ctrl-c the fstrim and we are doing discards on small free
spaces, it should abort almost straight away.  However, if we've
issued a single discard for an entirely empty AG - we've called
blkdev_issue_discard() with a 1TB length.  blkdev_issue_discard()
does the slice and dice into device length and aligned discards,
and it has no checks for signals in it's main loop.

So strace/fstrim are stuck until those 250,000+ discards are issued
and completed - however many hours that will take. I suspect that
we should push a signal check into blkdev_issue_discard() and
friends.

If you've got a recent iostat on your system:

$ iostat -dxyzm 5

<trimmed read/write output for reability>

Device                 d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme0n1          0    0.00      0.00     0.00   0.00    0.00     0.00    5.60    1.21    0.01   2.56
nvme0n1          0  367.60    204.51     0.00   0.00    2.58   569.69    0.80    8.75    0.96  97.04
nvme0n1          0  362.20    579.89     0.00   0.00    2.71  1639.44    3.60    1.89    1.00 100.00
nvme0n1          0  376.20   2070.96     0.00   0.00    2.59  5637.08    0.60    0.67    0.98  99.44
....

You can see what sort of progress the discards are making.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
