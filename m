Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5LLM4CT026600 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 16:22:04 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEE455B8C
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:22:03 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 2imX6CQRBEMN2YBf for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2011 14:22:03 -0700 (PDT)
Date: Tue, 21 Jun 2011 23:22:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110621212201.GA1755@x4.trippels.de>
References: <20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de>
	<20110621042513.GN32466@dastard>
	<20110621080219.GA1684@x4.trippels.de>
	<20110621182414.GA1723@x4.trippels.de>
	<20110621185701.GB1723@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110621185701.GB1723@x4.trippels.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.21 at 20:57 +0200, Markus Trippelsdorf wrote:
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
>            

The following patch fixes the problem for me.

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e68099..2f34efd 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1856,7 +1856,7 @@ xfs_buf_init(void)
 		goto out;
 
 	xfslogd_workqueue = alloc_workqueue("xfslogd",
-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+					WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
