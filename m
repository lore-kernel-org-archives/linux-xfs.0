Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.linode.com ([96.126.108.55]:51736 "EHLO mail1.linode.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbcK0FmL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Nov 2016 00:42:11 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and `mem_cgroup_shrink_node`
From: "Christopher S. Aker" <caker@theshore.net>
In-Reply-To: <20161124101525.GB20668@dhcp22.suse.cz>
Date: Sun, 27 Nov 2016 00:32:52 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <E9180081-785C-4C1A-85F5-1B63960D2187@theshore.net>
References: <20161108170340.GB4127@linux.vnet.ibm.com> <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de> <20161108183938.GD4127@linux.vnet.ibm.com> <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de> <20161116173036.GK3612@linux.vnet.ibm.com> <20161121134130.GB18112@dhcp22.suse.cz> <20161121140122.GU3612@linux.vnet.ibm.com> <20161121141818.GD18112@dhcp22.suse.cz> <20161121142901.GV3612@linux.vnet.ibm.com> <68025f6c-6801-ab46-b0fc-a9407353d8ce@molgen.mpg.de> <20161124101525.GB20668@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Donald Buczek <buczek@molgen.mpg.de>, dvteam@molgen.mpg.de, Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>


> On Nov 24, 2016, at 5:15 AM, Michal Hocko <mhocko@kernel.org> wrote:
> 
>> * No rcu_* warnings on that machine with 4.7.2, but with 4.8.4 , 4.8.6 ,
>> 4.8.8 and now 4.9.0-rc5+Pauls patch
> 
> I assume you haven't tried the Linus 4.8 kernel without any further
> stable patches? Just to be sure we are not talking about some later
> regression which found its way to the stable tree.

We are also seeing this frequently on our fleet since moving from 4.7.x to 4.8. This is from a machine running vanilla 4.8.6 just a few moments ago:

INFO: rcu_sched detected stalls on CPUs/tasks:
	13-...: (420 ticks this GP) idle=ce1/140000000000000/0 softirq=225550784/225550904 fqs=87105 
	(detected by 26, t=600030 jiffies, g=68185325, c=68185324, q=344996)
Task dump for CPU 13:
kswapd1         R  running task    12200  1840      2 0x00000808
 0000000000000001 0000000000000034 000000000000012b 0000000000003139
 ffff8b643fffb000 ffff8b028cee7cf8 ffff8b028cee7cf8 ffff8b028cee7d08
 ffff8b028cee7d08 ffff8b028cee7d18 ffff8b028cee7d18 ffff8b0200000000
Call Trace:
 [] ? shrink_node+0xcd/0x2f0
 [] ? kswapd+0x304/0x710
 [] ? mem_cgroup_shrink_node+0x160/0x160
 [] ? kthread+0xc4/0xe0
 [] ? ret_from_fork+0x1f/0x40
 [] ? kthread_worker_fn+0x140/0x140

The machine will lag terribly during these occurrences .. some will eventually recover, some will spiral down and require a reboot.

-Chris

