Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A66Tdo155153 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 01:06:29 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D7E01C7A1E6
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 23:06:25 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id xQGgWBJEOLXNAnG8
	for <xfs@oss.sgi.com>; Sun, 09 Oct 2011 23:06:25 -0700 (PDT)
Message-ID: <4E928B61.8080107@profihost.ag>
Date: Mon, 10 Oct 2011 08:06:25 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
In-Reply-To: <20111010055546.GA1641@x4.trippels.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, xfs@oss.sgi.com

Am 10.10.2011 07:55, schrieb Markus Trippelsdorf:
> Wouldn't it be possible to verify that the problem also goes away with
> this simple one liner?
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2366c54..daf30c9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1654,7 +1654,7 @@ xfs_init_workqueues(void)
>   	if (!xfs_syncd_wq)
>   		goto out;
>
> -	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
> +	xfs_ail_wq = alloc_workqueue("xfsail", WQ_HIGHPRI | WQ_CPU_INTENSIVE, 8);
>   	if (!xfs_ail_wq)
>   		goto out_destroy_syncd;
>
>  From Documentation/workqueue.txt:
>
>    WQ_HIGHPRI | WQ_CPU_INTENSIVE
>
> 	This combination makes the wq avoid interaction with
> 	concurrency management completely and behave as a simple
> 	per-CPU execution context provider.  Work items queued on a
> 	highpri CPU-intensive wq start execution as soon as resources
> 	are available and don't affect execution of other work items.
>
> So this should be identical to reverting back to the kthread. No?
> CCing Tejun, maybe he can comment on this?

We already tested this patch and it still fails / deadlocks:

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a1a881e..6377f51 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1669,7 +1669,7 @@ xfs_init_workqueues(void)
  	if (!xfs_syncd_wq)
  		goto out;

-	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
+	xfs_ail_wq = alloc_workqueue("xfsail", WQ_MEM_RECLAIM | WQ_HIGHPRI, 512);
  	if (!xfs_ail_wq)
  		goto out_destroy_syncd;

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 953b142..638ea8b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -600,7 +600,7 @@ out_done:
  	}

  	/* There is more to do, requeue us.  */
-	queue_delayed_work(xfs_syncd_wq, &ailp->xa_work,
+	queue_delayed_work(xfs_ail_wq, &ailp->xa_work,
  					msecs_to_jiffies(tout));
  }

@@ -637,7 +637,7 @@ xfs_ail_push(
  	smp_wmb();
  	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
  	if (!test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
-		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, 0);
+		queue_delayed_work(xfs_ail_wq, &ailp->xa_work, 0);
  }

  /*


Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
