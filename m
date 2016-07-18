Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80FB07CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:14:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53FE88F8035
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 04:14:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bpCbehTeB95cM8OB for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 04:14:02 -0700 (PDT)
Date: Mon, 18 Jul 2016 21:14:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160718111400.GC16044@dastard>
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
> 
> Digging into the reserve block depleted message - it seems we have
> too many parallel iomap_allocate transactions going on.  I suspect
> this might be because the writeback code will not finish a writeback
> context if we have multiple blocks inside a page, which can
> happen easily for this 1k ENOSPC setup.  I've not had time to fully
> check if this is what really happens, but I did a quick hack (see below)
> to only allocate 1k at a time in iomap_begin, and with that generic/224
> finishes without the warning spew.  Of course this isn't a real fix,
> and I need to fully understand what's going on in writeback due to
> different allocation / dirtying patterns from the iomap change.

Any progress here, Christoph? The current test run has been running
generic/224 on the 1GB mem test Vm for almost 6 hours now, and it's
still discarding pages. This doesn't always happen - sometimes it
takes the normal amount of time to run, but every so often it falls
into this "discard every page" loop and it takes hours to
complete...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
