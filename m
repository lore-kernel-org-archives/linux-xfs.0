Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:34311 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753222AbcK0JTL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Nov 2016 04:19:11 -0500
Subject: Re: INFO: rcu_sched detected stalls on CPUs/tasks with `kswapd` and
 `mem_cgroup_shrink_node`
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
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <583AA50A.9010608@molgen.mpg.de>
Date: Sun, 27 Nov 2016 10:19:06 +0100
MIME-Version: 1.0
In-Reply-To: <20161124101525.GB20668@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: dvteam@molgen.mpg.de, Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>

On 24.11.2016 11:15, Michal Hocko wrote:
> On Mon 21-11-16 16:35:53, Donald Buczek wrote:
> [...]
>> Hello,
>>
>> thanks a lot for looking into this!
>>
>> Let me add some information from the reporting site:
>>
>> * We've tried the patch from Paul E. McKenney (the one posted Wed, 16 Nov
>> 2016)  and it doesn't shut up the rcu stall warnings.
>>
>> * Log file from a boot with the patch applied ( grep kernel
>> /var/log/messages ) is here :
>> http://owww.molgen.mpg.de/~buczek/321322/2016-11-21_syslog.txt
>>
>> * This system is a backup server and walks over thousands of files sometimes
>> with multiple parallel rsync processes.
>>
>> * No rcu_* warnings on that machine with 4.7.2, but with 4.8.4 , 4.8.6 ,
>> 4.8.8 and now 4.9.0-rc5+Pauls patch
> I assume you haven't tried the Linus 4.8 kernel without any further
> stable patches? Just to be sure we are not talking about some later
> regression which found its way to the stable tree.

We've tried v4.8 and got the first rcu stall warnings with this, too. 
First one after about 20 hours uptime.


>> * When the backups are actually happening there might be relevant memory
>> pressure from inode cache and the rsync processes. We saw the oom-killer
>> kick in on another machine with same hardware and similar (a bit higher)
>> workload. This other machine also shows a lot of rcu stall warnings since
>> 4.8.4.
>>
>> * We see "rcu_sched detected stalls" also on some other machines since we
>> switched to 4.8 but not as frequently as on the two backup servers. Usually
>> there's "shrink_node" and "kswapd" on the top of the stack. Often
>> "xfs_reclaim_inodes" variants on top of that.
> I would be interested to see some reclaim tracepoints enabled. Could you
> try that out? At least mm_shrink_slab_{start,end} and
> mm_vmscan_lru_shrink_inactive. This should tell us more about how the
> reclaim behaved.

http://owww.molgen.mpg.de/~buczek/321322/2016-11-26.dmesg.txt  (80K)
http://owww.molgen.mpg.de/~buczek/321322/2016-11-26.trace.txt (50M)

Traces wrapped, but the last event is covered. all vmscan events were 
enabled


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

