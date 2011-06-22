Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5M04uLD038744 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 19:04:56 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EF701E4D548
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 17:04:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Hp5ruNy6psmHfHEv for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2011 17:04:52 -0700 (PDT)
Date: Wed, 22 Jun 2011 10:04:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110622000449.GQ32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110621212201.GA1755@x4.trippels.de>
	<20110621185701.GB1723@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Tue, Jun 21, 2011 at 08:57:01PM +0200, Markus Trippelsdorf wrote:
> On 2011.06.21 at 20:24 +0200, Markus Trippelsdorf wrote:
> > On 2011.06.21 at 10:02 +0200, Markus Trippelsdorf wrote:
> > > On 2011.06.21 at 14:25 +1000, Dave Chinner wrote:
> > > > That is, you really need to get a profile of the rm -rf process - or
> > > > whatever is consuming the CPU time - (e.g. via perf or ftrace)
> > > > across the hang to so we can narrow down the potential cause of the
> > > > latency. Speaking of which, latencytop might be helpful in
> > > > identifying where input is getting held up....
> > > 
> > > I've recorded a profile with "perf record -g /home/markus/rm_sync"
> > > ~ % cat rm_sync
> > > rm -fr /mnt/tmp/tmp/linux && sync
> > 
> > FWIW here are two links to svg time-charts produced by:
> > 
> > perf timechart record /home/markus/rm_sync
> > 
> > http://trippelsdorf.de/timechart1.svg
> > http://trippelsdorf.de/timechart2.svg
> > 
> 
> And this is what the mysterious kworker is doing during the sync.
> It's the one consuming most of the CPU time.
> 
>     39.96%      kworker/3:0  [kernel.kallsyms]                            0xffffffff811da9da k [k] xfs_trans_ail_update_bulk                         
>                 |                                                                                                                                    
>                 --- xfs_trans_ail_update_bulk                                                                                                        
>                     xfs_trans_committed_bulk                                                                                                         
>                     xlog_cil_committed                                                                                                               
>                     xlog_state_do_callback                                                                                                           
>                     xlog_state_done_syncing                                                                                                          
>                     xlog_iodone                                                                                                                      
>                     xfs_buf_iodone_work                                                                                                              
>                     process_one_work                                                                                                                 
>                     worker_thread                                                                                                                    
>                     kthread                                                                                                                          
>                     kernel_thread_helper                                                                                                             

So that is inserting items into the AIL at transaction completion.
That can consume lots of CPU time if the CIL checkpoints are being
flushed quickly enough. Given you are doing a rm -rf at this point
in time, I'd expect to see this trace present in the profile, though
maybe not at that extent.

I have seen this before but have never been able to it reproduce
reliably.  If checkpoints are completed "out of order" due to the
way the commit records are written into the iclogs. This can cause
extra CPU because the AIL insertion then has to skip over all the
items that were inserted out of order before splicing each group of
items into the AIL. I only rarely see this (maybe once every couple
of weeks of performance testing), so I'm not sure it's the problem
you are seeing.

Adding this debug to xfs_ail_splice() list walk will tell us if this is
happening and how many items it had to walk when you see a hang:

 	xfs_lsn_t       lsn)
 {
 	xfs_log_item_t  *next_lip;
+	int walked = 0;
 
 	/* If the list is empty, just insert the item.  */
 	if (list_empty(&ailp->xa_ail)) {
 		list_splice(list, &ailp->xa_ail);
 		return;
 	}
 
 	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
 		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
 			break;
+		if (!walked++) {
+			xfs_warn(ailp->xa_mount,
+			 "ail: ooo splice, tail 0x%llx, item 0x%llx\n",
+				next_lip->li_lsn, lsn);
+		}
 	}
+	if (walked > 10) {
+		xfs_warn(ailp->xa_mount,
+			 "ail: ooo splice, walked %d items\n", walked);
+	}
 
 	ASSERT(&next_lip->li_ail == &ailp->xa_ail ||
 	       XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0);

That will at least tell us if this is the cause of your problem. If
it is, I think I know how to avoid most of the list walk overhead
fairly easily and that should avoid the need to change workqueue
configurations at all.

> The following patch fixes the problem for me.
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 5e68099..2f34efd 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1856,7 +1856,7 @@ xfs_buf_init(void)
>  		goto out;
>  
>  	xfslogd_workqueue = alloc_workqueue("xfslogd",
> -					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
> +					WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
>  	if (!xfslogd_workqueue)
>  		goto out_free_buf_zone;

That implies the source of your X/ssh hangs is a workqueue priority
inversion.

We need the xfslogd to run with WQ_HIGHPRI because we can deadlock
in IO completion if it is blocked by xfsdatad/xfsconvertd wq
operations. Hence we need to process the logd workqueue ahead of
data IO completions and we do that by making the log IO completion
high priority.

This thing is, the CMWQ infrastructure only has one level of "high
priority" - we can't define any other sort of dependency between
various queues - and that queue is simply a FIFO.  IOWs, CMWQ will
process anything that is high priority ahead of -all- other normal
priority work items.  That means that if you get a high priority
workqueue with lots to do and consuming CPU (as we are seeing here)
it will starve all other work items that are queued on that CPU.

So what you end up seeing is interactive process related work being
queued on CPU 3 which is then being starved of processing by XFS IO
completion work on the same CPU. By setting the xfslogd workqueue to
unbound, it no longer holds precedence over any of the other work
and hence does not starve the queued interactive process related work.
That's why the patch "fixes" your 1-2s hangs while log IO is in
progress, but it will eventually deadlock and hang the filesystem
permanently.

There are two different things you can try with the wq
initialisation that might help prevent the problem. Firstly, try
this:

-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI, 8);

To change the number of concurrent per-cpu work items that can be
processed on the work queue. I don't think that will fix the
inversion, but it may allow more concurrency which hides the
inversion.

The other thing you can try is:

-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);

Which marks the workqueue as one that will consume a lot of CPU and
hence it is scheduled differently and hence should avoid other
pending work from being starved. We use this WQ_CPU_INTENSIVE flag
on other XFS workqueues that are known to consume lots of CPU, so I
suspect this is the right thing to do here.

Hopefully one of these things will point to a potential solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
