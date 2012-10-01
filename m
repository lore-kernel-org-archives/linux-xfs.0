Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91N97f1209640 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 18:09:07 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	f4jcBxzeSgMBAFdp for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 16:10:29 -0700 (PDT)
Date: Tue, 2 Oct 2012 09:10:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
Message-ID: <20121001231027.GI23520@dastard>
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120925005632.GB23520@dastard> <5061CA48.3040202@sgi.com>
	<20120928030847.GC25626@dastard> <20121001221028.766035076@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121001221028.766035076@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 01, 2012 at 05:10:23PM -0500, Mark Tinguely wrote:
>  v2 remove the architecture conditional.

Version stuff goes after the first --- line where the diffstat lies.
It doesn't belong inteh commit messages.

> The AGF hang is caused when the process that holds the AGF buffer
> lock cannot get a worker. The allocation worker pool are blocked
> waiting to take the AGF buffer lock.
> 
> Move the allocation worker call so that multiple calls to
> xfs_alloc_vextent() for a particular transaction are contained
> within a single worker.
> 			---
> With the xfs_alloc_arg structure zeroed, the AGF hang occurs in 
> xfs_bmap_btalloc() due to a secondary call to xfs_alloc_vextent().

How, exactly? You need to describe the exact hang so that everyone
understands what the problem is that is being fixed. This doesn't
tell me what the hang is that is being fixed. Document it in a call
timeline that shows when the locks are taken, and where they
subsequently hang....

> These calls to xfs_alloc_vextent() try different strategies to
> allocate the extent if the previous allocation attempt failed.

I suspect you are talking about this code chain:

        if ((error = xfs_alloc_vextent(&args)))
                return error;
        if (tryagain && args.fsbno == NULLFSBLOCK) {
.....
                if ((error = xfs_alloc_vextent(&args)))
                        return error;
        }
        if (isaligned && args.fsbno == NULLFSBLOCK) {
.....
                if ((error = xfs_alloc_vextent(&args)))
                        return error;
        }
.....

but I can't be certain from the description...

> I still prefer this patch's approach. It also limits the number
> worker context switches when xfs_alloc_ventent() is called multiple
> times within a transaction. The intent of the patch is to move the
> allocation worker as reasonably close to the xfs_trans_alloc() -
> xfs_trans_commit / xfs_trans_cancel() calls as possible.

Except, as I've said before, it also adds context switches to
unwritten extent conversion that already occurs in a worker thread
that has no stack pressure (i.e. adds unnecessary latency via
context switches to IO completion), and it also pushes all realtime
device allocation into a worker thread. Once again, that will add
unpredictable latency to the allocation path (bad for realtime) when
no stack pressure actually exists.

These were particular concerns for placing the stack switch in
xfs_alloc_vextent() in the first place - to only switch stacks when
allocation was going to occur for allocations that are likely to
smash the stack.  xfs_bmapi_write() is too high level to avoid
this problem in xfs_bmap_btalloc() with minimum impact because it
also captures operations that don't pass through the typical worst
case stack path or don't have stack pressure.

If we need to avoid the above problem in xfs_bmap_btalloc() for user
data allocation, then move the worker hand-off up one function from
xfs_alloc_vextent() to xfs_bmap_btalloc() - it's a precise fit for
the problem that (I think) has been described above. It's also a
simpler patch because it doesn't need to create a new worker args
structure - just add the completion to the struct xfs_bmalloca ....

> I have ported this patch to Linux 3.0.x. Linux 2.6.x will be the same
> as the Linux 3.0 port.

Not really relevant to a TOT commit, especially as the underlying
patch isn't in 3.0.x or 2.6.x. Indeed, if you want to back port it
and this fix to anything prior to 2.6.38, then you are going to need
the EAGAIN version I posted because the workqueue infrastructure is
vastly different and blocking workers on locks is guaranteed to have
serious performance impact, even if it doesn't deadlock.

> This patch allows an easy addition of an architecture limit on the
> allocation worker for those that choose to do so.

Not relevant. It's no different to the xfs_alloc_vextent
worker code that it replaces.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
