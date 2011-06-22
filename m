Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5M76rVO064847 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 02:06:54 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9C351742C03
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 00:06:49 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id dU1rSpv5GzC99P1b for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2011 00:06:49 -0700 (PDT)
Date: Wed, 22 Jun 2011 09:06:47 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110622070647.GA1744@x4.trippels.de>
References: <20110621212201.GA1755@x4.trippels.de>
	<20110621185701.GB1723@x4.trippels.de>
	<20110622000449.GQ32466@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20110622000449.GQ32466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2011.06.22 at 10:04 +1000, Dave Chinner wrote:
> On Tue, Jun 21, 2011 at 08:57:01PM +0200, Markus Trippelsdorf wrote:
> > On 2011.06.21 at 20:24 +0200, Markus Trippelsdorf wrote:
> > > On 2011.06.21 at 10:02 +0200, Markus Trippelsdorf wrote:
> > > > On 2011.06.21 at 14:25 +1000, Dave Chinner wrote:
> > > > > That is, you really need to get a profile of the rm -rf process - or
> > > > > whatever is consuming the CPU time - (e.g. via perf or ftrace)
> > > > > across the hang to so we can narrow down the potential cause of the
> > > > > latency. Speaking of which, latencytop might be helpful in
> > > > > identifying where input is getting held up....
> > > > 
> > > > I've recorded a profile with "perf record -g /home/markus/rm_sync"
> > > > ~ % cat rm_sync
> > > > rm -fr /mnt/tmp/tmp/linux && sync
> > > 
> > > FWIW here are two links to svg time-charts produced by:
> > > 
> > > perf timechart record /home/markus/rm_sync
> > > 
> > > http://trippelsdorf.de/timechart1.svg
> > > http://trippelsdorf.de/timechart2.svg
> > > 
> > 
> > And this is what the mysterious kworker is doing during the sync.
> > It's the one consuming most of the CPU time.
> > 
> >     39.96%      kworker/3:0  [kernel.kallsyms]                            0xffffffff811da9da k [k] xfs_trans_ail_update_bulk
> >                 |
> >                 --- xfs_trans_ail_update_bulk
> >                     xfs_trans_committed_bulk
> >                     xlog_cil_committed
> >                     xlog_state_do_callback
> >                     xlog_state_done_syncing
> >                     xlog_iodone
> >                     xfs_buf_iodone_work
> >                     process_one_work
> >                     worker_thread
> >                     kthread
> >                     kernel_thread_helper
> 
> So that is inserting items into the AIL at transaction completion.
> That can consume lots of CPU time if the CIL checkpoints are being
> flushed quickly enough. Given you are doing a rm -rf at this point
> in time, I'd expect to see this trace present in the profile, though
> maybe not at that extent.
> 
> I have seen this before but have never been able to it reproduce
> reliably.  If checkpoints are completed "out of order" due to the
> way the commit records are written into the iclogs. This can cause
> extra CPU because the AIL insertion then has to skip over all the
> items that were inserted out of order before splicing each group of
> items into the AIL. I only rarely see this (maybe once every couple
> of weeks of performance testing), so I'm not sure it's the problem
> you are seeing.
> 
> Adding this debug to xfs_ail_splice() list walk will tell us if this is
> happening and how many items it had to walk when you see a hang:
> 
>  	xfs_lsn_t       lsn)
>  {
>  	xfs_log_item_t  *next_lip;
> +	int walked = 0;
>  
>  	/* If the list is empty, just insert the item.  */
>  	if (list_empty(&ailp->xa_ail)) {
>  		list_splice(list, &ailp->xa_ail);
>  		return;
>  	}
>  
>  	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
>  		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
>  			break;
> +		if (!walked++) {
> +			xfs_warn(ailp->xa_mount,
> +			 "ail: ooo splice, tail 0x%llx, item 0x%llx\n",
> +				next_lip->li_lsn, lsn);
> +		}
>  	}
> +	if (walked > 10) {
> +		xfs_warn(ailp->xa_mount,
> +			 "ail: ooo splice, walked %d items\n", walked);
> +	}
>  
>  	ASSERT(&next_lip->li_ail == &ailp->xa_ail ||
>  	       XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0);
> 
> That will at least tell us if this is the cause of your problem. If
> it is, I think I know how to avoid most of the list walk overhead
> fairly easily and that should avoid the need to change workqueue
> configurations at all.

The kernel log is attached.

> > The following patch fixes the problem for me.
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> > index 5e68099..2f34efd 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.c
> > +++ b/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -1856,7 +1856,7 @@ xfs_buf_init(void)
> >  		goto out;
> >  
> >  	xfslogd_workqueue = alloc_workqueue("xfslogd",
> > -					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
> > +					WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
> >  	if (!xfslogd_workqueue)
> >  		goto out_free_buf_zone;
> 
> That implies the source of your X/ssh hangs is a workqueue priority
> inversion.
> 
> We need the xfslogd to run with WQ_HIGHPRI because we can deadlock
> in IO completion if it is blocked by xfsdatad/xfsconvertd wq
> operations. Hence we need to process the logd workqueue ahead of
> data IO completions and we do that by making the log IO completion
> high priority.
> 
> This thing is, the CMWQ infrastructure only has one level of "high
> priority" - we can't define any other sort of dependency between
> various queues - and that queue is simply a FIFO.  IOWs, CMWQ will
> process anything that is high priority ahead of -all- other normal
> priority work items.  That means that if you get a high priority
> workqueue with lots to do and consuming CPU (as we are seeing here)
> it will starve all other work items that are queued on that CPU.
> 
> So what you end up seeing is interactive process related work being
> queued on CPU 3 which is then being starved of processing by XFS IO
> completion work on the same CPU. By setting the xfslogd workqueue to
> unbound, it no longer holds precedence over any of the other work
> and hence does not starve the queued interactive process related work.
> That's why the patch "fixes" your 1-2s hangs while log IO is in
> progress, but it will eventually deadlock and hang the filesystem
> permanently.
> 
> There are two different things you can try with the wq
> initialisation that might help prevent the problem. Firstly, try
> this:
> 
> -					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
> +					WQ_MEM_RECLAIM | WQ_HIGHPRI, 8);
> 
> To change the number of concurrent per-cpu work items that can be
> processed on the work queue. I don't think that will fix the
> inversion, but it may allow more concurrency which hides the
> inversion.
> 
> The other thing you can try is:
> 
> -					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
> +					WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
> 
> Which marks the workqueue as one that will consume a lot of CPU and
> hence it is scheduled differently and hence should avoid other
> pending work from being starved. We use this WQ_CPU_INTENSIVE flag
> on other XFS workqueues that are known to consume lots of CPU, so I
> suspect this is the right thing to do here.

Yes, that was the next combination I've tested after WQ_UNBOUND and it
solves the issue, too.

-- 
Markus

--gKMricLos+KVdGMg
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="kern.log.bz2"
Content-Transfer-Encoding: base64

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
U4UJBiJ/3SA=

--gKMricLos+KVdGMg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--gKMricLos+KVdGMg--
