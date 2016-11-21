Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:39895 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754809AbcKUPf4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Nov 2016 10:35:56 -0500
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
References: <24c226a5-1a4a-173e-8b4e-5107a2baac04@molgen.mpg.de>
 <28a9fabb-c9fe-c865-016a-467a4d5e2a34@molgen.mpg.de>
 <20161108170340.GB4127@linux.vnet.ibm.com>
 <6c717122-e671-b086-77ed-4b3c26398564@molgen.mpg.de>
 <20161108183938.GD4127@linux.vnet.ibm.com>
 <9f87f8f0-9d0f-f78f-8dca-993b09b19a69@molgen.mpg.de>
 <20161116173036.GK3612@linux.vnet.ibm.com>
 <20161121134130.GB18112@dhcp22.suse.cz>
 <20161121140122.GU3612@linux.vnet.ibm.com>
 <20161121141818.GD18112@dhcp22.suse.cz>
 <20161121142901.GV3612@linux.vnet.ibm.com>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <68025f6c-6801-ab46-b0fc-a9407353d8ce@molgen.mpg.de>
Date: Mon, 21 Nov 2016 16:35:53 +0100
MIME-Version: 1.0
In-Reply-To: <20161121142901.GV3612@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dvteam@molgen.mpg.de, Michal Hocko <mhocko@kernel.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>

On 11/21/16 15:29, Paul E. McKenney wrote:
> On Mon, Nov 21, 2016 at 03:18:19PM +0100, Michal Hocko wrote:
>> On Mon 21-11-16 06:01:22, Paul E. McKenney wrote:
>>> On Mon, Nov 21, 2016 at 02:41:31PM +0100, Michal Hocko wrote:
>> [...]
>>>> To the patch. I cannot say I would like it. cond_resched_rcu_qs sounds
>>>> way too lowlevel for this usage. If anything cond_resched somewhere inside
>>>> mem_cgroup_iter would be more appropriate to me.
>>> Like this?
>>>
>>> 							Thanx, Paul
>>>
>>> ------------------------------------------------------------------------
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index ae052b5e3315..81cb30d5b2fc 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -867,6 +867,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>>   out:
>>>   	if (prev && prev != root)
>>>   		css_put(&prev->css);
>>> +	cond_resched_rcu_qs();
>> I still do not understand why should we play with _rcu_qs at all and a
>> regular cond_resched is not sufficient. Anyway I would have to double
>> check whether we can do cond_resched in the iterator. I do not remember
>> having users which are atomic but I might be easily wrong here. Before
>> we touch this code, though, I would really like to understand what is
>> actually going on here because as I've already pointed out we should
>> have some resched points in the reclaim path.
> If there is a tight loop in the kernel, cond_resched() will ensure that
> other tasks get a chance to run, but if there are no such tasks, it does
> nothing to give RCU the quiescent state that it needs from time to time.
> So if there is a possibility of a long-running in-kernel loop without
> preemption by some other task, cond_resched_rcu_qs() is required.
>
> I welcome your deeper investigation -- I am very much treating symptoms
> here, which might or might not have any relationship to fixing underlying
> problems.
>
> 							Thanx, Paul
>

Hello,

thanks a lot for looking into this!

Let me add some information from the reporting site:

* We've tried the patch from Paul E. McKenney (the one posted Wed, 16 
Nov 2016)  and it doesn't shut up the rcu stall warnings.

* Log file from a boot with the patch applied ( grep kernel 
/var/log/messages ) is here : 
http://owww.molgen.mpg.de/~buczek/321322/2016-11-21_syslog.txt

* This system is a backup server and walks over thousands of files 
sometimes with multiple parallel rsync processes.

* No rcu_* warnings on that machine with 4.7.2, but with 4.8.4 , 4.8.6 , 
4.8.8 and now 4.9.0-rc5+Pauls patch

* When the backups are actually happening there might be relevant memory 
pressure from inode cache and the rsync processes. We saw the oom-killer 
kick in on another machine with same hardware and similar (a bit higher) 
workload. This other machine also shows a lot of rcu stall warnings 
since 4.8.4.

* We see "rcu_sched detected stalls" also on some other machines since 
we switched to 4.8 but not as frequently as on the two backup servers. 
Usually there's "shrink_node" and "kswapd" on the top of the stack. 
Often "xfs_reclaim_inodes" variants on top of that.

Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

