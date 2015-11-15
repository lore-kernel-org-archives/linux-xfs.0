Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1D4D7F47
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2015 20:35:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D630304039
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2015 18:35:32 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id DcGjIfTf8lcvYnsC (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2015 18:35:25 -0800 (PST)
Subject: Re: memory reclaim problems on fs usage
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201511102313.36685.arekm@maven.pl>
	<56449E44.7020407@I-love.SAKURA.ne.jp>
	<201511122228.26399.arekm@maven.pl>
	<201511142140.38245.arekm@maven.pl>
In-Reply-To: <201511142140.38245.arekm@maven.pl>
Message-Id: <201511151135.JGD81717.OFOOSMFJFQHVtL@I-love.SAKURA.ne.jp>
Date: Sun, 15 Nov 2015 11:35:11 +0900
Mime-Version: 1.0
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
To: arekm@maven.pl
Cc: linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, mhocko@suse.com, xfs@oss.sgi.com

Arkadiusz Miskiewicz wrote:
> > > vmstat_update() and submit_flushes() remained pending for about 110
> > > seconds. If xlog_cil_push_work() were spinning inside GFP_NOFS
> > > allocation, it should be reported as MemAlloc: traces, but no such lines
> > > are recorded. I don't know why xlog_cil_push_work() did not call
> > > schedule() for so long. Anyway, applying
> > > http://lkml.kernel.org/r/20151111160336.GD1432@dhcp22.suse.cz should
> > > solve vmstat_update() part.
> > 
> > To apply that patch on top of 4.1.13 I also had to apply patches listed
> > below.
> > 
> > So in summary appllied:
> > http://sprunge.us/GYBb
> > http://sprunge.us/XWUX
> > http://sprunge.us/jZjV
> 
> I've tried more to trigger "page allocation failure" with usual actions that 
> triggered it previously but couldn't reproduce. With these patches applied it 
> doesn't happen.
> 
> Logs from my tests:
> 
> http://ixion.pld-linux.org/~arekm/log-mm-3.txt.gz
> http://ixion.pld-linux.org/~arekm/log-mm-4.txt.gz (with swap added)
> 
Good.

vmstat_update() and submit_flushes() are no longer pending for long.

log-mm-4.txt:Nov 14 16:40:08 srv kernel: [167753.393960]     pending: vmstat_shepherd, vmpressure_work_fn
log-mm-4.txt:Nov 14 16:40:08 srv kernel: [167753.393984]     pending: submit_flushes [md_mod]
log-mm-4.txt:Nov 14 16:41:08 srv kernel: [167813.439405]     pending: submit_flushes [md_mod]
log-mm-4.txt:Nov 14 17:17:19 srv kernel: [169985.104806]     pending: vmstat_shepherd

I think that the vmstat statistics now have correct values.

> But are these patches solving the problem or just hiding it?
> 
Excuse me but I can't judge.

If you are interested in monitoring how vmstat statistics are changing
under stalled condition, you can try below patch.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 35a46b4..3de3a14 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2794,8 +2794,7 @@ static int kmallocwd(void *unused)
 	rcu_read_unlock();
 	preempt_enable();
 	show_workqueue_state();
-	if (dump_target_pid <= 0)
-		dump_target_pid = -pid;
+	show_mem(0);
 	/* Wait until next timeout duration. */
 	schedule_timeout_interruptible(kmallocwd_timeout);
 	if (memalloc_counter[index])

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
