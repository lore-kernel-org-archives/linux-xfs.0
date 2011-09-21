Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LN7Na2183803 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 18:07:23 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB12F1807BB
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 16:07:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JXX1X8dUtYgOOAai for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 16:07:21 -0700 (PDT)
Date: Thu, 22 Sep 2011 09:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110921230718.GS15688@dastard>
References: <4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
	<20110921122649.GA16602@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110921122649.GA16602@infradead.org>
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

On Wed, Sep 21, 2011 at 08:26:49AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 21, 2011 at 09:42:37PM +1000, Dave Chinner wrote:
> > So, the log force not triggering in the AIL code looks to be the
> > problem. That, I simply cannot explain right now - it makes no sense
> > but that is what all the stats and trace events point to. I need to
> > do more investigation.
> 
> Could it be that we have a huge amount of instances of xfs_ail_worker
> running at the same time?  xfs_sync_wq is marked as WQ_CPU_INTENSIVE,
> so running/runnable workers are not counted towards the concurrency
> limit.  From my look at the workqueue code this means we'll spawn new
> instances fairly quickly if the others are stuck.  This means more
> and more of them hammering the pinned items, and we'll rarely reach
> the limit where we'd need to do a log force.

No, that's not possible. The XFS_AIL_PUSHING_BIT ensures that there
is only one instance of AIL pushing per struct xfs_ail running at
once. It's also backed up by the fact that I couldn't find a single
worker thread blocked running AIL pushing - it ran the 100 item
scan, got stuck, requeued itself to run again 20ms later....

FYI, what we want the concurrency for in the AIL wq is for multiple
filesystems to be able to run AIL pushing at the same time, which
is why it was set up this way. If one filesystem AIL push blocks,
then an unblocked one will simply run.

> What is also strange is that we allocate a xfs_ail_wq, but don't
> actually use it, although it would have the same idea.  Stefan,
> can you try the following patch?  This moves the ail work to it's
> explicit queue, and makes sure we never have the same work item
> (= same fs to be pushed) concurrently.

Oh, that's a bug. My bad. That definitely needs fixing.

> Note that before Linux 3.1-rc you'll need to edit fs/xfs/xfs_super.c
> to be fs/xfs/linux-2.6/xfs_super.c in the patch manually.
> 
> 
> Index: linux-2.6/fs/xfs/xfs_super.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_super.c	2011-09-21 08:00:01.864768359 -0400
> +++ linux-2.6/fs/xfs/xfs_super.c	2011-09-21 08:04:01.335266079 -0400
> @@ -1654,7 +1654,7 @@ xfs_init_workqueues(void)
>  	if (!xfs_syncd_wq)
>  		goto out;
>  
> -	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
> +	xfs_ail_wq = alloc_workqueue("xfsail", WQ_NON_REENTRANT, 8);
>  	if (!xfs_ail_wq)
>  		goto out_destroy_syncd;

Drop this hunk....

>  
> Index: linux-2.6/fs/xfs/xfs_trans_ail.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_trans_ail.c	2011-09-21 08:02:28.172765827 -0400
> +++ linux-2.6/fs/xfs/xfs_trans_ail.c	2011-09-21 08:02:46.843266108 -0400
> @@ -538,7 +538,7 @@ out_done:
>  	}
>  
>  	/* There is more to do, requeue us.  */
> -	queue_delayed_work(xfs_syncd_wq, &ailp->xa_work,
> +	queue_delayed_work(xfs_ail_wq, &ailp->xa_work,
>  					msecs_to_jiffies(tout));
>  }
>  
> @@ -575,7 +575,7 @@ xfs_ail_push(
>  	smp_wmb();
>  	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
>  	if (!test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
> -		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, 0);
> +		queue_delayed_work(xfs_ail_wq, &ailp->xa_work, 0);
>  }

just keep these. Can you repost with a sign-off?

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
