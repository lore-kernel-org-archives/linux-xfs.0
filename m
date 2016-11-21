Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34487 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753191AbcKUOS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 09:18:27 -0500
Date: Mon, 21 Nov 2016 15:18:19 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
Message-ID: <20161121141818.GD18112@dhcp22.suse.cz>
References: <24c226a5-1a4a-173e-8b4e-5107a2baac04@molgen.mpg.de>
 <28a9fabb-c9fe-c865-016a-467a4d5e2a34@molgen.mpg.de>
 <20161108170340.GB4127@linux.vnet.ibm.com>
 <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de>
 <20161108183938.GD4127@linux.vnet.ibm.com>
 <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
 <20161116173036.GK3612@linux.vnet.ibm.com>
 <20161121134130.GB18112@dhcp22.suse.cz>
 <20161121140122.GU3612@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161121140122.GU3612@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, dvteam@molgen.mpg.de

On Mon 21-11-16 06:01:22, Paul E. McKenney wrote:
> On Mon, Nov 21, 2016 at 02:41:31PM +0100, Michal Hocko wrote:
[...]
> > To the patch. I cannot say I would like it. cond_resched_rcu_qs sounds
> > way too lowlevel for this usage. If anything cond_resched somewhere inside
> > mem_cgroup_iter would be more appropriate to me.
> 
> Like this?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae052b5e3315..81cb30d5b2fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -867,6 +867,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  out:
>  	if (prev && prev != root)
>  		css_put(&prev->css);
> +	cond_resched_rcu_qs();

I still do not understand why should we play with _rcu_qs at all and a
regular cond_resched is not sufficient. Anyway I would have to double
check whether we can do cond_resched in the iterator. I do not remember
having users which are atomic but I might be easily wrong here. Before
we touch this code, though, I would really like to understand what is
actually going on here because as I've already pointed out we should
have some resched points in the reclaim path.

-- 
Michal Hocko
SUSE Labs
