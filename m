Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LNU3jW165157 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 18:30:03 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lLFrVQPmZ9GuJ602 for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 16:30:01 -0700 (PDT)
Date: Fri, 22 Jun 2012 09:29:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120621232957.GE10673@dastard>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<4FE1BDF3.4080702@shiftmail.org> <20120620225327.GL30705@dastard>
	<20120621174742.GA27837@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120621174742.GA27837@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, hch@infradead.org, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org

On Thu, Jun 21, 2012 at 01:47:43PM -0400, Mike Snitzer wrote:
> On Wed, Jun 20 2012 at  6:53pm -0400,
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Jun 20, 2012 at 02:11:31PM +0200, Spelic wrote:
> > > Ok guys, I think I found the bug. One or more bugs.
> > > 
> > > 
> > > Pool has chunksize 1MB.
> > > In sysfs the thin volume has: queue/discard_max_bytes and
> > > queue/discard_granularity are 1048576 .
> > > And it has discard_alignment = 0, which based on sysfs-block
> > > documentation is correct (a less misleading name would have been
> > > discard_offset imho).
> > > Here is the blktrace from ext4 fstrim:
> > > ...
> > > 252,9   17      498     0.030466556   841  Q   D 19898368 + 2048 [fstrim]
> > > 252,9   17      499     0.030467501   841  Q   D 19900416 + 2048 [fstrim]
> > > 252,9   17      500     0.030468359   841  Q   D 19902464 + 2048 [fstrim]
....
> > > Here is the blktrace from xfs fstrim:
> > > 252,12  16        1     0.000000000   554  Q   D 96 + 2048 [fstrim]
> > > 252,12  16        2     0.000010149   554  Q   D 2144 + 2048 [fstrim]
> > > 252,12  16        3     0.000011349   554  Q   D 4192 + 2048 [fstrim]
.....
> > It looks like blkdev_issue_discard() has reduced each discard to
> > bios of a single "granule" (1MB), and not aligned them, hence they
> > are ignore by dm-thinp.
> > 
> > what are the discard parameters exposed by dm-thinp in
> > /sys/block/<thinp-blkdev>/queue/discard*
> > 
> > It looks to me that dmthinp might be setting discard_max_bytes to
> > 1MB rather than discard_granularity. Looking at dm-thin.c:
> > 
> > static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
> > {
> >         /*
> >          * FIXME: these limits may be incompatible with the pool's data device
> >          */
> >         limits->max_discard_sectors = pool->sectors_per_block;
> > 
> >         /*
> >          * This is just a hint, and not enforced.  We have to cope with
> >          * bios that overlap 2 blocks.
> >          */
> >         limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
> >         limits->discard_zeroes_data = pool->pf.zero_new_blocks;
> > }
> > 
> > 
> > Yes - discard_max_bytes == discard_granularity, and so
> > blkdev_issue_discard fails to align the request properly. As it is,
> > setting discard_max_bytes to the thinp block size is silly - it
> > means you'll never get range requests, and we sent a discard for
> > every single block in a range rather than having the thinp code
> > iterate over a range itself.
> 
> So 2 different issues:
> 1) blkdev_issue_discard isn't properly aligning
> 2) thinp should accept larger discards (up to the stacked
>    discard_max_bytes rather than setting an override)

Yes, in effect, but there's no real reason I can see why thinp can't
accept large discard requests than the underlying stack and break
them up appropriately itself....

> > i.e. this is not a filesystem bug that is causing the problem....
> 
> Paolo Bonzini fixed blkdev_issue_discard to properly align some time
> ago; unfortunately the patches slipped through the cracks (cc'ing Paolo,
> Jens, and Christoph).
> 
> Here are references to Paolo's patches:
> 0/2 https://lkml.org/lkml/2012/3/14/323
> 1/2 https://lkml.org/lkml/2012/3/14/324
> 2/2 https://lkml.org/lkml/2012/3/14/325
> 
> Patch 2/2 specifically addresses the case where:
>  discard_max_bytes == discard_granularity 
> 
> Paolo, any chance you could resend to Jens (maybe with hch's comments on
> patch#2 accounted for)?  Also, please add hch's Reviewed-by when
> reposting.
> 
> (would love to see this fixed for 3.5-rcX but if not 3.6 it is?)

That would be good...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
