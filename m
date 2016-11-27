Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:50555 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753563AbcK0Jh4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Nov 2016 04:37:56 -0500
Message-ID: <1480239444.3654.5.camel@molgen.mpg.de>
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
From: Paul Menzel <pmenzel@molgen.mpg.de>
Date: Sun, 27 Nov 2016 10:37:24 +0100
In-Reply-To: <918a163c-52af-3c5e-85db-9829cce9ae2b@molgen.mpg.de>
References: <20161108170340.GB4127@linux.vnet.ibm.com>
         <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de>
         <20161108183938.GD4127@linux.vnet.ibm.com>
         <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
         <20161116173036.GK3612@linux.vnet.ibm.com>
         <20161121134130.GB18112@dhcp22.suse.cz>
         <20161121140122.GU3612@linux.vnet.ibm.com>
         <20161121141818.GD18112@dhcp22.suse.cz>
         <20161121142901.GV3612@linux.vnet.ibm.com>
         <68025f6c-6801-ab46-b0fc-a9407353d8ce@molgen.mpg.de>
         <20161124101525.GB20668@dhcp22.suse.cz>
         <918a163c-52af-3c5e-85db-9829cce9ae2b@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Donald Buczek <buczek@molgen.mpg.de>, dvteam@molgen.mpg.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, "Christopher S. Aker" <caker@theshore.net>

Am Donnerstag, den 24.11.2016, 19:50 +0100 schrieb Donald Buczek:
> On 24.11.2016 11:15, Michal Hocko wrote:
> 
> > On Mon 21-11-16 16:35:53, Donald Buczek wrote:
> > [...]

> >> Let me add some information from the reporting site:
> >>
> >> * We've tried the patch from Paul E. McKenney (the one posted Wed, 16 Nov
> >> 2016) and it doesn't shut up the rcu stall warnings.
> >>
> >> * Log file from a boot with the patch applied ( grep kernel
> >> /var/log/messages ) is here :

[…]

> >> * This system is a backup server and walks over thousands of files sometimes
> >> with multiple parallel rsync processes.
> >>
> >> * No rcu_* warnings on that machine with 4.7.2, but with 4.8.4 , 4.8.6 ,
> >> 4.8.8 and now 4.9.0-rc5+Pauls patch
> > I assume you haven't tried the Linus 4.8 kernel without any further
> > stable patches? Just to be sure we are not talking about some later
> > regression which found its way to the stable tree.

We tried, and the problem also shows up with the plain 4.8 kernel.

```
$ dmesg
[…]
[77554.135657] INFO: rcu_sched detected stalls on CPUs/tasks:
[77554.135662]  1-...: (222 ticks this GP) idle=7dd/140000000000000/0 softirq=30962751/30962968 fqs=12961
[77554.135663]  (detected by 10, t=60002 jiffies, g=7958132, c=7958131, q=90237)
[77554.135667] Task dump for CPU 1:
[77554.135669] kswapd1         R  running task        0    86      2 0x00000008
[77554.135672]  ffff88080ad87c58 ffff88080ad87c58 ffff88080ad87cf8 ffff88100c1e5200
[77554.135674]  0000000000000003 0000000000000000 ffff88080ad87e60 ffff88080ad87d90
[77554.135675]  ffffffff811345f5 ffff88080ad87da0 ffff88080ad87db0 ffff88100c1e5200
[77554.135677] Call Trace:
[77554.135684]  [<ffffffff811345f5>] ? shrink_node_memcg+0x605/0x870
[77554.135686]  [<ffffffff8113491f>] ? shrink_node+0xbf/0x1c0
[77554.135687]  [<ffffffff81135642>] ? kswapd+0x342/0x6b0
[77554.135689]  [<ffffffff81135300>] ? mem_cgroup_shrink_node+0x150/0x150
[77554.135692]  [<ffffffff81075be4>] ? kthread+0xc4/0xe0
[77554.135695]  [<ffffffff81b2b34f>] ? ret_from_fork+0x1f/0x40
[77554.135696]  [<ffffffff81075b20>] ? kthread_worker_fn+0x160/0x160
[77734.252362] INFO: rcu_sched detected stalls on CPUs/tasks:
[77734.252367]  1-...: (897 ticks this GP) idle=7dd/140000000000000/0 softirq=30962751/30963197 fqs=50466
[77734.252368]  (detected by 0, t=240122 jiffies, g=7958132, c=7958131, q=456322)
[77734.252372] Task dump for CPU 1:
[77734.252373] kswapd1         R  running task        0    86      2 0x00000008
[77734.252376]  ffff88080ad87c58 ffff88080ad87c58 ffff88080ad87cf8 ffff88100c1e5200
[77734.252378]  0000000000000003 0000000000000000 ffff88080ad87e60 ffff88080ad87d90
[77734.252380]  ffffffff811345f5 ffff88080ad87da0 ffff88080ad87db0 ffff88100c1e5200
[77734.252382] Call Trace:
[77734.252388]  [<ffffffff811345f5>] ? shrink_node_memcg+0x605/0x870
[77734.252390]  [<ffffffff8113491f>] ? shrink_node+0xbf/0x1c0
[77734.252391]  [<ffffffff81135642>] ? kswapd+0x342/0x6b0
[77734.252393]  [<ffffffff81135300>] ? mem_cgroup_shrink_node+0x150/0x150
[77734.252396]  [<ffffffff81075be4>] ? kthread+0xc4/0xe0
[77734.252399]  [<ffffffff81b2b34f>] ? ret_from_fork+0x1f/0x40
[77734.252401]  [<ffffffff81075b20>] ? kthread_worker_fn+0x160/0x160
[…]
```

> >> * When the backups are actually happening there might be relevant memory
> >> pressure from inode cache and the rsync processes. We saw the oom-killer
> >> kick in on another machine with same hardware and similar (a bit higher)
> >> workload. This other machine also shows a lot of rcu stall warnings since
> >> 4.8.4.
> >>
> >> * We see "rcu_sched detected stalls" also on some other machines since we
> >> switched to 4.8 but not as frequently as on the two backup servers. Usually
> >> there's "shrink_node" and "kswapd" on the top of the stack. Often
> >> "xfs_reclaim_inodes" variants on top of that.
> >
> > I would be interested to see some reclaim tracepoints enabled. Could you
> > try that out? At least mm_shrink_slab_{start,end} and
> > mm_vmscan_lru_shrink_inactive. This should tell us more about how the
> > reclaim behaved.
> 
> We'll try that tomorrow!

Unfortunately, looking today at `trace`, the corresponding messages have
already been thrown out the buffer. We continue trying.


Kind regards,

Paul Menzel

