Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP5iW06225470 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:44:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C735D1A5D2F
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 21:46:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	mpyPWEBJQLyfIrCV for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 21:46:09 -0800 (PST)
Date: Thu, 25 Nov 2010 16:46:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verify filesystem is aligned to stripes
Message-ID: <20101125054607.GM13830@dastard>
References: <4CED5BFC.8000906@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CED5BFC.8000906@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 07:39:56PM +0100, Spelic wrote:
> Hi there,
> I thought there was a way to empirically check that the filesystem
> is correctly aligned to RAID stripes, but my attempts fail.
> I don't mean by looking at sunit and swidth from xfs_info, because
> that would not detect if there is some LVM offset problem.
> 
> I am particularly interested for parity RAIDs in MD.
> 
> I was thinking at "iostat -x 1": if writes are aligned I shouldn't
> see any reads from the drives in a parity RAID...
> 
> unfortunately this does not work:
> - a dd streaming write test has almost no reads even when I mount
> with "noalign", with sufficiently large stripe_cache_size such as
> 1024. If it is smaller, always reads, even if xfs is aligned.

IO may not be aligned, though allocation usually is. With a large
stripe cache, the MD device waits long enough for sequential
unaligned IO to fill a full stripe width and hence never needs to
read to calculate parity.

> - a kernel untar will show lots of reads at any stripe_cache_size
> even if I'm pretty sure I aligned the stripes correctly on my 1024k
> x 15 data disks and the .tar.bz2 file was in cache. I tried with
> both xfs stripes autodetection in 2.6.37-rc2 and by specifying su
> and sw values by hand, which turned out to be the same; I was
> without LVM so I'm pretty sure alignment was correct. Why are there
> still lots of reads in this case?

Because writes for workloads like this are never full stripe writes.
Hence reads must be done to pullin the rest of the stripe before the
new parity can be calculated. This RMW cycle for small IOs has
always been the pain point for stripe based parity protection. If
you are doing lots of small IOs, RAID1 is your friend.

> PS, OT: do you confirm it's not a good idea to have agsize multiple
> of stripe size like the mkfs warns you against? Today I offsetted it
> by +1 stripe unit (chunk) so that every AG begins on a different
> drive but performances didn't improve noticeably.

Depends on the workload and a lot of other factors. in general,
putting all the AG headers on the same spindle/lun results in that
spindle/lun becoming a hotspot, especially when you have a
filesystem with a few hundred AGs in it...

> Wouldn't that
> cause more unfilled stripes when writing?

Not for sequential IO (for the above reason), and for small IOs it
will make zero difference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
