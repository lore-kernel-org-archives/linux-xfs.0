Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0DFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 00:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiESAuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 20:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiESAuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 20:50:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7E1E14D3A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 17:50:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E7FEF5345DA;
        Thu, 19 May 2022 10:50:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrUMo-00Deou-2H; Thu, 19 May 2022 10:50:14 +1000
Date:   Thu, 19 May 2022 10:50:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fstrim and strace considered harmful?
Message-ID: <20220519005014.GS1098723@dread.disaster.area>
References: <20220518065949.GA1237408@onthe.net.au>
 <20220518070713.GA1238882@onthe.net.au>
 <YoUXxBe1d7b29wif@magnolia>
 <20220518223606.GA1343027@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518223606.GA1343027@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62859448
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=YRKQdHiFLmwDSipVSosA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 08:36:06AM +1000, Chris Dunlop wrote:
> On Wed, May 18, 2022 at 08:59:00AM -0700, Darrick J. Wong wrote:
> > On Wed, May 18, 2022 at 05:07:13PM +1000, Chris Dunlop wrote:
> > > Oh, sorry... on linux v5.15.34
> > > 
> > > On Wed, May 18, 2022 at 04:59:49PM +1000, Chris Dunlop wrote:
> > > > I have an fstrim that's been running for over 48 hours on a 256T thin
> > > > provisioned XFS fs containing around 55T of actual data on a slow
> > > > subsystem (ceph 8,3 erasure-encoded rbd). I don't think there would be
> > > > an an enourmous amount of data to trim, maybe a few T, but I've no idea
> > > > how long how long it might be expected to take. In an attempt to see
> > > > what the what the fstrim was doing, I ran an strace on it. The strace
> > > > has been sitting there without output and unkillable since then, now 5+
> > > > hours ago.  Since the strace, on that same filesystem I now have 123 df
> > > > processes and 615 rm processes -- and growing -- that are blocked in
> > > > xfs_inodegc_flush, e.g.:
> ...
> > It looks like the storage device is stalled on the discard, and most
> > everything else is stuck waiting for buffer locks?  The statfs threads
> > are the same symptom as last time.
> 
> Note: the box has been rebooted and it's back to normal after an anxious 30
> minutes waiting for the mount recovery. (Not an entirely wasted 30 minutes -
> what a thrilling stage of the Giro d'Italia!)
> 
> I'm not sure if the fstrim was stalled, unless the strace had stalled it
> somehow: it had been running for ~48 hours without apparent issues before
> the strace was attached, and then it was another hour before the first
> process stuck on xfs_inodegc_flush appeared.

I suspect that it's just that your storage device is really slow at
small trims. If you didn't set a minimum trim size, XFS will issue
discards on every free space in it's trees. If you have fragmented
free space (quite possible if you're using reflink and removing
files that have been reflinked and modified) then you could have
millions of tiny free spaces that XFS is now asking the storage to
free.

Dumping the free space histogram of the filesystem will tell us just
how much work you asked the storage to do. e.g:

# xfs_spaceman -c "freesp" /
   from      to extents  blocks    pct
      1       1   20406   20406   0.03
      2       3   14974   35666   0.06
      4       7   11773   61576   0.10
      8      15   11935  131561   0.22
     16      31   15428  359009   0.60
     32      63   13594  620194   1.04
     64     127   15354 1415541   2.38
    128     255   19269 3560215   5.98
    256     511     975  355811   0.60
    512    1023     831  610381   1.02
   1024    2047     398  580983   0.98
   2048    4095     275  827636   1.39
   4096    8191     156  911802   1.53
   8192   16383      90 1051443   1.77
  16384   32767      54 1257999   2.11
  32768   65535      17  813203   1.37
  65536  131071      13 1331349   2.24
 131072  262143      18 3501547   5.88
 262144  524287       8 2834877   4.76
 524288 1048575       8 5722448   9.61
1048576 2097151       6 9189190  15.43
2097152 4194303       4 14026658  23.55
4194304 8388607       2 10348013  17.37
#

So on this 1TB filesystem, there's ~125,000 free space extents and
the vast majority of them are less than 255 blocks in length (1MB).
Hence I run fstrim on this filesystem without a minium size limit, it
will issue roughly 125,000 discard requests.

If I set a 1MB minimum size, it will issue discards on all free
spaces 256 blocks or larger. i.e.  it will only issue ~2000 discards
and that will cover ~92% of the free space in the filesystem....

> The open question is what caused the stuck processes?

Oh, that's easy the easy bit to explain: discard runs with the AGF
locked because it is iterating the free space tree directly. Hence
operations on that AG are blocked until all the free space in that
AG have been discarded. Could be smarter, never needed to be
smarter.

Now inodegc comes along, and tries to free an inode in that AG, and
blocks getting the AGF lock during the inode free operation (likely
inode chunk freeing of finobt block allocation). Everythign then
backs up on inodegc flushes, which is backed up on discard
operations....

> It's now no mystery to me why the fstrim was taking so long, nor why the
> strace didn't produce any output: it turns out fstrim, without an explicit
> --offset --length range, issues a single ioctl() to trim from the start of
> the device to the end, and without an explicit --minimum, uses
> /sys/block/xxx/queue/discard_granularity as the minimum block size to
> discard, in this case 64kB. So it would have been issuing a metric shit-ton
> of discard requests to the underlying storage, something close to:
> 
>   (fs-size - fs-used) / discard-size
>   256T - 26T / 64k
>   3,858,759,680 requests

Won't be anywhere near that number - free space in a 256TB
filesystem with only 29TB used will have lots of really large
contiguous free spaces. Those will get broken down into max discard
length chunks, not minimum. Of course, if the bdev is setting a
really small max discard size, then that's going to be just a big a
problem for you....

> It was after figuring out all that that I hit the reset.

Yup, see above for how to actually determine what minimum size to
set for a trim....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
