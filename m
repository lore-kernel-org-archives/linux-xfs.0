Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35897 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbcKUNlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 08:41:35 -0500
Date: Mon, 21 Nov 2016 14:41:31 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
Message-ID: <20161121134130.GB18112@dhcp22.suse.cz>
References: <24c226a5-1a4a-173e-8b4e-5107a2baac04@molgen.mpg.de>
 <28a9fabb-c9fe-c865-016a-467a4d5e2a34@molgen.mpg.de>
 <20161108170340.GB4127@linux.vnet.ibm.com>
 <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de>
 <20161108183938.GD4127@linux.vnet.ibm.com>
 <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
 <20161116173036.GK3612@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161116173036.GK3612@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, dvteam@molgen.mpg.de

On Wed 16-11-16 09:30:36, Paul E. McKenney wrote:
> On Wed, Nov 16, 2016 at 06:01:19PM +0100, Paul Menzel wrote:
> > Dear Linux folks,
> > 
> > 
> > On 11/08/16 19:39, Paul E. McKenney wrote:
> > >On Tue, Nov 08, 2016 at 06:38:18PM +0100, Paul Menzel wrote:
> > >>On 11/08/16 18:03, Paul E. McKenney wrote:
> > >>>On Tue, Nov 08, 2016 at 01:22:28PM +0100, Paul Menzel wrote:
> > >>
> > >>>>Could you please help me shedding some light into the messages below?
> > >>>>
> > >>>>With Linux 4.4.X, these messages were not seen. When updating to
> > >>>>Linux 4.8.4, and Linux 4.8.6 they started to appear. In that
> > >>>>version, we enabled several CGROUP options.
> > >>>>
> > >>>>>$ dmesg -T
> > >>>>>[…]
> > >>>>>[Mon Nov  7 15:09:45 2016] INFO: rcu_sched detected stalls on CPUs/tasks:
> > >>>>>[Mon Nov  7 15:09:45 2016]     3-...: (493 ticks this GP) idle=515/140000000000000/0 softirq=5504423/5504423 fqs=13876
> > >>>>>[Mon Nov  7 15:09:45 2016]     (detected by 5, t=60002 jiffies, g=1363193, c=1363192, q=268508)
> > >>>>>[Mon Nov  7 15:09:45 2016] Task dump for CPU 3:
> > >>>>>[Mon Nov  7 15:09:45 2016] kswapd1         R  running task        0    87      2 0x00000008
> > >>>>>[Mon Nov  7 15:09:45 2016]  ffffffff81aabdfd ffff8810042a5cb8 ffff88080ad34000 ffff88080ad33dc8
> > >>>>>[Mon Nov  7 15:09:45 2016]  ffff88080ad33d00 0000000000003501 0000000000000000 0000000000000000
> > >>>>>[Mon Nov  7 15:09:45 2016]  0000000000000000 0000000000000000 0000000000022316 000000000002bc9f
> > >>>>>[Mon Nov  7 15:09:45 2016] Call Trace:
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81aabdfd>] ? __schedule+0x21d/0x5b0
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81106dcf>] ? shrink_node+0xbf/0x1c0
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81107865>] ? kswapd+0x315/0x5f0
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81107550>] ? mem_cgroup_shrink_node+0x90/0x90
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff8106c614>] ? kthread+0xc4/0xe0
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff81aaf64f>] ? ret_from_fork+0x1f/0x40
> > >>>>>[Mon Nov  7 15:09:45 2016]  [<ffffffff8106c550>] ? kthread_worker_fn+0x160/0x160
> > >>>>
> > >>>>Even after reading `stallwarn.txt` [1], I don’t know what could
> > >>>>cause this. All items in the backtrace seem to belong to the Linux
> > >>>>kernel.
> > >>>>
> > >>>>There is also nothing suspicious in the monitoring graphs during that time.
> > >>>
> > >>>If you let it be, do you get a later stall warning a few minutes later?
> > >>>If so, how does the stack trace compare?
> > >>
> > >>With Linux 4.8.6 this is the only occurrence since yesterday.
> > >>
> > >>With Linux 4.8.3, and 4.8.4 the following stack traces were seen.
> > >
> > >Looks to me like one or both of the loops in shrink_node() need
> > >an cond_resched_rcu_qs().
> > 
> > Thank you for the pointer. I haven’t had time yet to look into it.
> 
> In theory, it is quite straightforward, as shown by the patch below.
> In practice, the MM guys might wish to call cond_resched_rcu_qs() less
> frequently, but I will leave that to their judgment.  My guess is that
> the overhead of the cond_resched_rcu_qs() is way down in the noise,
> but I have been surprised in the past.
> 
> Anyway, please give this patch a try and let me know how it goes.

I am not seeing the full thread in my inbox but I am wondering what is
actually going on here. The reclaim path (shrink_node_memcg resp.
shrink_slab should have preemption points and there is not done much
except of iterating over all memcgs other than that. Are there
gazillions of memcgs configured (most of them with the low limit
configured)? In other words is the system configured properly?

To the patch. I cannot say I would like it. cond_resched_rcu_qs sounds
way too lowlevel for this usage. If anything cond_resched somewhere inside
mem_cgroup_iter would be more appropriate to me.
-- 
Michal Hocko
SUSE Labs
