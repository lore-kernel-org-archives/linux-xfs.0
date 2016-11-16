Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59827 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933533AbcKPRam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 12:30:42 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAGHNqUS078370
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2016 12:30:41 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26rts34aha-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2016 12:30:41 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Wed, 16 Nov 2016 10:30:40 -0700
Date: Wed, 16 Nov 2016 09:30:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
Reply-To: paulmck@linux.vnet.ibm.com
References: <24c226a5-1a4a-173e-8b4e-5107a2baac04@molgen.mpg.de>
 <28a9fabb-c9fe-c865-016a-467a4d5e2a34@molgen.mpg.de>
 <20161108170340.GB4127@linux.vnet.ibm.com>
 <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de>
 <20161108183938.GD4127@linux.vnet.ibm.com>
 <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
Message-Id: <20161116173036.GK3612@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, dvteam@molgen.mpg.de

On Wed, Nov 16, 2016 at 06:01:19PM +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> On 11/08/16 19:39, Paul E. McKenney wrote:
> >On Tue, Nov 08, 2016 at 06:38:18PM +0100, Paul Menzel wrote:
> >>On 11/08/16 18:03, Paul E. McKenney wrote:
> >>>On Tue, Nov 08, 2016 at 01:22:28PM +0100, Paul Menzel wrote:
> >>
> >>>>Could you please help me shedding some light into the messages below?
> >>>>
> >>>>With Linux 4.4.X, these messages were not seen. When updating to
> >>>>Linux 4.8.4, and Linux 4.8.6 they started to appear. In that
> >>>>version, we enabled several CGROUP options.
> >>>>
> >>>>>$ dmesg -T
> >>>>>[…]
> >>>>>[Mon Nov  7 15:09:45 2016] INFO: rcu_sched detected stalls on CPUs/tasks:
> >>>>>[Mon Nov  7 15:09:45 2016]     3-...: (493 ticks this GP) idle=515/140000000000000/0 softirq=5504423/5504423 fqs=13876
> >>>>>[Mon Nov  7 15:09:45 2016]     (detected by 5, t=60002 jiffies, g=1363193, c=1363192, q=268508)
> >>>>>[Mon Nov  7 15:09:45 2016] Task dump for CPU 3:
> >>>>>[Mon Nov  7 15:09:45 2016] kswapd1         R  running task        0    87      2 0x00000008
> >>>>>[Mon Nov  7 15:09:45 2016]  ffffffff81aabdfd ffff8810042a5cb8 ffff88080ad34000 ffff88080ad33dc8
> >>>>>[Mon Nov  7 15:09:45 2016]  ffff88080ad33d00 0000000000003501 0000000000000000 0000000000000000
> >>>>>[Mon Nov  7 15:09:45 2016]  0000000000000000 0000000000000000 0000000000022316 000000000002bc9f
> >>>>>[Mon Nov  7 15:09:45 2016] Call Trace:
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81aabdfd>] ? __schedule+0x21d/0x5b0
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81106dcf>] ? shrink_node+0xbf/0x1c0
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81107865>] ? kswapd+0x315/0x5f0
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81107550>] ? mem_cgroup_shrink_node+0x90/0x90
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff8106c614>] ? kthread+0xc4/0xe0
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81aaf64f>] ? ret_from_fork+0x1f/0x40
> >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff8106c550>] ? kthread_worker_fn+0x160/0x160
> >>>>
> >>>>Even after reading `stallwarn.txt` [1], I don’t know what could
> >>>>cause this. All items in the backtrace seem to belong to the Linux
> >>>>kernel.
> >>>>
> >>>>There is also nothing suspicious in the monitoring graphs during that time.
> >>>
> >>>If you let it be, do you get a later stall warning a few minutes later?
> >>>If so, how does the stack trace compare?
> >>
> >>With Linux 4.8.6 this is the only occurrence since yesterday.
> >>
> >>With Linux 4.8.3, and 4.8.4 the following stack traces were seen.
> >
> >Looks to me like one or both of the loops in shrink_node() need
> >an cond_resched_rcu_qs().
> 
> Thank you for the pointer. I haven’t had time yet to look into it.

In theory, it is quite straightforward, as shown by the patch below.
In practice, the MM guys might wish to call cond_resched_rcu_qs() less
frequently, but I will leave that to their judgment.  My guess is that
the overhead of the cond_resched_rcu_qs() is way down in the noise,
but I have been surprised in the past.

Anyway, please give this patch a try and let me know how it goes.

							Thanx, Paul

------------------------------------------------------------------------

commit 1a5595eec6c034c27e1c826a93292240bfea934e
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Wed Nov 16 09:26:28 2016 -0800

    mm: Prevent shrink_node() RCU CPU stall warnings
    
    This commit adds a couple cond_resched_rcu_qs() calls in the inner
    loop in shrink_node() in order to prevent RCU CPU stall warnings.
    
    Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 744f926af442..0d3b5f5a04ef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2529,8 +2529,11 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			unsigned long scanned;
 
 			if (mem_cgroup_low(root, memcg)) {
-				if (!sc->may_thrash)
+				if (!sc->may_thrash) {
+					/* Prevent CPU CPU stalls. */
+					cond_resched_rcu_qs();
 					continue;
+				}
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
 			}
 
@@ -2565,6 +2568,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
+			cond_resched_rcu_qs(); /* Prevent CPU CPU stalls. */
 		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
 
 		/*

