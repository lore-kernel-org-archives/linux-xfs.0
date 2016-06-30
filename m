Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00D197CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 18:18:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DE40AC005
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 16:18:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IFsgH34EYwOADzNf for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 16:16:03 -0700 (PDT)
Date: Fri, 1 Jul 2016 09:16:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160630231601.GU12670@dastard>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160630172239.GA23082@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 30, 2016 at 07:22:39PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 28, 2016 at 10:26:49AM +1000, Dave Chinner wrote:
> > Christoph, it look slike there's an ENOSPC+ENOMEM behavioural regression here.
> > generic/224 on my 1p/1GB RAM VM using a 1k lock size filesystem has
> > significantly different behaviour once ENOSPC is hit withi this patchset.
> > 
> > It ends up with an endless stream of errors like this:
> 
> I've spent some time trying to reproduce this.  I'm actually getting
> the OOM killer almost reproducible for for-next without the iomap
> patches as well when just using 1GB of mem.  1400 MB is the minimum
> I can reproducibly finish the test with either code base.
> 
> But with the 1400 MB setup I see a few interesting things.  Even
> with the baseline, no-iomap case I see a few errors in the log:
> 
> [   70.407465] Filesystem "vdc": reserve blocks depleted! Consider increasing
> reserve pool
> size.
> [   70.195645] XFS (vdc): page discard on page ffff88005682a988, inode 0xd3, offset 761856.
> [   70.408079] Buffer I/O error on dev vdc, logical block 1048513, lost async
> page write
> [   70.408598] Buffer I/O error on dev vdc, logical block 1048514, lost async
> page write
>  27s
> 
> With iomap I also see the spew of page discard errors your see, but while
> I see a lot of them, the rest still finishes after a reasonable time,
> just a few seconds more than the pre-iomap baseline.  I also see the
> reserve block depleted message in this case.

The reserve block pool depleted message is normal for me in this
test.  We're throwing a thousand concurrent processes at the
filesystem at ENOSPC, and so the metadata reservation for the
delayed allocation totals quite a lot. We only reserve 8192 blocks
for the reserve pool, so a delalloc reservation for one page on each
file (4 blocks per page, which means a couple of blocks for the
metadata reservation via the indlen calculation) is going to consume
the reserve pool quite quickly if the up front reservation
overshoots the XFS_ALLOC_SET_ASIDE() ENOSPC threshold.

> Digging into the reserve block depleted message - it seems we have
> too many parallel iomap_allocate transactions going on.  I suspect
> this might be because the writeback code will not finish a writeback
> context if we have multiple blocks inside a page, which can
> happen easily for this 1k ENOSPC setup.

Right - this test has regularly triggered that warning on this
particular test setup for me - it's not something new to the iomap
patchset.

> I've not had time to fully
> check if this is what really happens, but I did a quick hack (see below)
> to only allocate 1k at a time in iomap_begin, and with that generic/224
> finishes without the warning spew.  Of course this isn't a real fix,
> and I need to fully understand what's going on in writeback due to
> different allocation / dirtying patterns from the iomap change.

Which tends to indicate that the multi-block allocation has a larger
indlen reservation, and that's what is causing the code to hit
whatever edge-case that is leading to it not recovering. However,
I'm still wondering how we are not throwing ENOSPC back to userspace
at XFS_ALLOC_SET_ASIDE limits.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
