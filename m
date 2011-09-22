Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MLo99t261649 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 16:50:09 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BCE41841F1
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 14:50:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Q3N6kK2pmKvnqi4E for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2011 14:50:00 -0700 (PDT)
Date: Fri, 23 Sep 2011 07:49:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110922214956.GX15688@dastard>
References: <4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
	<20110921122649.GA16602@infradead.org>
	<20110921230718.GS15688@dastard>
	<20110922141457.GA11929@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110922141457.GA11929@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Thu, Sep 22, 2011 at 10:14:57AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 22, 2011 at 09:07:18AM +1000, Dave Chinner wrote:
> > No, that's not possible. The XFS_AIL_PUSHING_BIT ensures that there
> > is only one instance of AIL pushing per struct xfs_ail running at
> > once. It's also backed up by the fact that I couldn't find a single
> > worker thread blocked running AIL pushing - it ran the 100 item
> > scan, got stuck, requeued itself to run again 20ms later....
> 
> True, it should prevent that - this was just my only theory based
> on the (incorrect) assumption that we'd never get to the log force.
> 
> > FYI, what we want the concurrency for in the AIL wq is for multiple
> > filesystems to be able to run AIL pushing at the same time, which
> > is why it was set up this way. If one filesystem AIL push blocks,
> > then an unblocked one will simply run.
> 
> A WQ_NON_REENTRANT workqueue will still provide that.  From the
> documentation:
> 
>         By default, a wq guarantees non-reentrance only on the same
> 	CPU.  A work item may not be executed concurrently on the same
> 	CPU by multiple workers but is allowed to be executed
> 	concurrently on multiple CPUs.  This flag makes sure
> 	non-reentrance is enforced across all CPUs.  Work items queued
> 	to a non-reentrant wq are guaranteed to be executed by at most
> 	one worker system-wide at any given time.
> 
> So this still seems to preferable for the ail workqueue, and should be
> able to replace the XFS_AIL_PUSHING_BIT protections.

No, we can't. WQ_NON_REENTRANT only protects against concurrency on
the same CPU, not across all CPUs - it still allows concurrent
per-CPU work processing on the same work item.

However, we want only a *single* AIL worker instance executing per
filesystem, not per-cpu per filesystem. Concurrent per-filesystem
workers will simply bash on the AIL lock trying to walk the AIL at
the same time, and this is precisely the issue the single AIL worker
setup is avoiding. The XFS_AIL_PUSHING_BIT is what enforces the
single per-filesystem push worker running at any time.

> I also suspect that we should mark the ail workqueue as WQ_MEM_RECLAIM -
> a lot of memory reclaim really requires moving the AIL forward.

Possibly, but I'm not sure it is necessary.

> Currently we have other ways to reclaim inodes, but e.g. for buffers
> we rely entirely on AIL pushing,

We have the xfs_buf shrinker that walks the LRU that frees clean
buffers.

> and with the proposed metadata
> writeback changes we're going to rely even more on the ail, even if
> we still keep emergency synchronous around it's going to be a lot
> less efficient than real ail pushing under actual OOM conditions.

The inode shrinker kicks the AIL pushing - if we cannot get memory
to queue the work, then the very next iteration of the shrinker will
try again. Hence I'm not sure that it is absolutely necessary,
though it probably won't hurt...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
