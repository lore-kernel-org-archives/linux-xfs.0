Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 May 2008 20:48:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4B3lVrP016898
	for <xfs@oss.sgi.com>; Sat, 10 May 2008 20:47:37 -0700
Received: from e23smtp04.au.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D350150FB3
	for <xfs@oss.sgi.com>; Sat, 10 May 2008 20:48:15 -0700 (PDT)
Received: from e23smtp04.au.ibm.com (E23SMTP04.au.ibm.com [202.81.18.173]) by cuda.sgi.com with ESMTP id FNpKd7yYCeMkOPjA for <xfs@oss.sgi.com>; Sat, 10 May 2008 20:48:15 -0700 (PDT)
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4B3lYvm021408
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 13:47:34 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4B3qGt5179872
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 13:52:17 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4B3mCYq013544
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 13:48:12 +1000
Message-ID: <48266C77.3040102@linux.vnet.ibm.com>
Date: Sun, 11 May 2008 09:18:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: 2.6.26-rc1: possible circular locking dependency with xfs filesystem
References: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com> <4825DF71.1030209@linux.vnet.ibm.com>
In-Reply-To: <4825DF71.1030209@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: pvp-lsts@fs.ru.acad.bg
Cc: Alexander Beregalov <a.beregalov@gmail.com>, kernel-testers@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, xfs@oss.sgi.com, David Chinner <dgc@sgi.com>

Kamalesh Babulal wrote:
> Adding the cc to kernel-list, Ingo Molnar and Peter Zijlstra
> 
> Alexander Beregalov wrote:
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.26-rc1-00279-g28a4acb #13
>> -------------------------------------------------------
>> nfsd/3087 is trying to acquire lock:
>>  (iprune_mutex){--..}, at: [<c016f947>] shrink_icache_memory+0x38/0x19b
>>
>> but task is already holding lock:
>>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>>        [<c01352e6>] __lock_acquire+0xa0c/0xbc6
>>        [<c013550a>] lock_acquire+0x6a/0x86
>>        [<c012c39a>] down_write_nested+0x33/0x6a
>>        [<c0210b5c>] xfs_ilock+0x7b/0xd6
>>        [<c0210cd5>] xfs_ireclaim+0x1d/0x59
>>        [<c022edfe>] xfs_finish_reclaim+0x173/0x195
>>        [<c0230fa3>] xfs_reclaim+0xb3/0x138
>>        [<c023b4cb>] xfs_fs_clear_inode+0x55/0x8e
>>        [<c016f60b>] clear_inode+0x83/0xd2
>>        [<c016f88a>] dispose_list+0x3c/0xc1
>>        [<c016fa82>] shrink_icache_memory+0x173/0x19b
>>        [<c014a68d>] shrink_slab+0xda/0x14e
>>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>>        [<c0146b11>] __alloc_pages+0xa/0xc
>>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>>        [<c01484bc>] force_page_cache_readahead+0x4a/0x74
>>        [<c014c9b0>] sys_madvise+0x308/0x400
>>        [<c0102b25>] sysenter_past_esp+0x6a/0xb1
>>        [<ffffffff>] 0xffffffff
>>
>> -> #0 (iprune_mutex){--..}:
>>        [<c0135203>] __lock_acquire+0x929/0xbc6
>>        [<c013550a>] lock_acquire+0x6a/0x86
>>        [<c0356a6f>] mutex_lock_nested+0xb4/0x226
>>        [<c016f947>] shrink_icache_memory+0x38/0x19b
>>        [<c014a68d>] shrink_slab+0xda/0x14e
>>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>>        [<c0146b11>] __alloc_pages+0xa/0xc
>>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>>        [<c014866c>] ondemand_readahead+0x119/0x127
>>        [<c01486cc>] page_cache_async_readahead+0x52/0x5d
>>        [<c0178e46>] generic_file_splice_read+0x290/0x4a8
>>        [<c0239f06>] xfs_splice_read+0x4b/0x78
>>        [<c0237713>] xfs_file_splice_read+0x24/0x29
>>        [<c0178182>] do_splice_to+0x45/0x63
>>        [<c01783f6>] splice_direct_to_actor+0xab/0x150
>>        [<c01ce8e1>] nfsd_vfs_read+0x1ed/0x2d0
>>        [<c01ced50>] nfsd_read+0x82/0x99
>>        [<c01d42bc>] nfsd3_proc_read+0xdf/0x12a
>>        [<c01cb40b>] nfsd_dispatch+0xcf/0x19e
>>        [<c033f484>] svc_process+0x3b3/0x68b
>>        [<c01cb939>] nfsd+0x168/0x26b
>>        [<c0103747>] kernel_thread_helper+0x7/0x10
>>        [<ffffffff>] 0xffffffff
>>
>> other info that might help us debug this:
>>
>> 3 locks held by nfsd/3087:
>>  #0:  (hash_sem){..--}, at: [<c01d1538>] exp_readlock+0xd/0xf
>>  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6
>>  #2:  (shrinker_rwsem){----}, at: [<c014a5d7>] shrink_slab+0x24/0x14e
>>
>> stack backtrace:
>> Pid: 3087, comm: nfsd Not tainted 2.6.26-rc1-00279-g28a4acb #13
>>  [<c0133498>] print_circular_bug_tail+0x5a/0x65
>>  [<c0133d99>] ? print_circular_bug_header+0xa8/0xb3
>>  [<c0135203>] __lock_acquire+0x929/0xbc6
>>  [<c0106c1a>] ? native_sched_clock+0x8b/0x9f
>>  [<c013550a>] lock_acquire+0x6a/0x86
>>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>>  [<c0356a6f>] mutex_lock_nested+0xb4/0x226
>>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>>  [<c016f947>] shrink_icache_memory+0x38/0x19b
>>  [<c014a68d>] shrink_slab+0xda/0x14e
>>  [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>>  [<c03583c8>] ? _spin_unlock_irqrestore+0x36/0x58
>>  [<c014982f>] ? isolate_pages_global+0x0/0x3e
>>  [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>>  [<c0146b11>] __alloc_pages+0xa/0xc
>>  [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>>  [<c014866c>] ondemand_readahead+0x119/0x127
>>  [<c01486cc>] page_cache_async_readahead+0x52/0x5d
>>  [<c0178e46>] generic_file_splice_read+0x290/0x4a8
>>  [<c0358305>] ? _spin_unlock+0x27/0x3c
>>  [<c0250e55>] ? _atomic_dec_and_lock+0x25/0x30
>>  [<c016ed3f>] ? iput+0x24/0x4e
>>  [<c0135484>] ? __lock_acquire+0xbaa/0xbc6
>>  [<c01cb12a>] ? exportfs_decode_fh+0x9b/0x1a1
>>  [<c0178245>] ? spd_release_page+0x0/0xf
>>  [<c0239f06>] xfs_splice_read+0x4b/0x78
>>  [<c0237713>] xfs_file_splice_read+0x24/0x29
>>  [<c0178182>] do_splice_to+0x45/0x63
>>  [<c01783f6>] splice_direct_to_actor+0xab/0x150
>>  [<c01ce9c4>] ? nfsd_direct_splice_actor+0x0/0xf
>>  [<c01ce8e1>] nfsd_vfs_read+0x1ed/0x2d0
>>  [<c01ced50>] nfsd_read+0x82/0x99
>>  [<c01d42bc>] nfsd3_proc_read+0xdf/0x12a
>>  [<c01cb40b>] nfsd_dispatch+0xcf/0x19e
>>  [<c033f484>] svc_process+0x3b3/0x68b
>>  [<c01cb939>] nfsd+0x168/0x26b
>>  [<c01cb7d1>] ? nfsd+0x0/0x26b
>>  [<c0103747>] kernel_thread_helper+0x7/0x10
>> --
Adding the trimmed forward message of syslog from Plamen Petrov <pvp-lsts@fs.ru.acad.bg>

May  9 02:16:46 nomad64 kernel: [42951853.992912] 
May  9 02:16:46 nomad64 kernel: [42951853.992913] =======================================================
May  9 02:16:46 nomad64 kernel: [42951853.992920] [ INFO: possible circular locking dependency detected ]
May  9 02:16:46 nomad64 kernel: [42951853.992922] 2.6.26-rc1-00243-g46e4965 #1
May  9 02:16:46 nomad64 kernel: [42951853.992924] -------------------------------------------------------
May  9 02:16:46 nomad64 kernel: [42951853.992927] kio_http/3813 is trying to acquire lock:
May  9 02:16:46 nomad64 kernel: [42951853.992930]  (&mm->mmap_sem){----}, at: [<ffffffff80222bbd>] do_page_fault+0xdd/0x890
May  9 02:16:46 nomad64 kernel: [42951853.992944] 
May  9 02:16:46 nomad64 kernel: [42951853.992944] but task is already holding lock:
May  9 02:16:46 nomad64 kernel: [42951853.992947]  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff80387f85>] xfs_ilock+0x65/0xa0
May  9 02:16:46 nomad64 kernel: [42951853.992960] 
May  9 02:16:46 nomad64 kernel: [42951853.992960] which lock already depends on the new lock.
May  9 02:16:46 nomad64 kernel: [42951853.992961] 
May  9 02:16:46 nomad64 kernel: [42951853.992964] 
May  9 02:16:46 nomad64 kernel: [42951853.992965] the existing dependency chain (in reverse order) is:
May  9 02:16:46 nomad64 kernel: [42951853.992967] 
May  9 02:16:46 nomad64 kernel: [42951853.992968] -> #1 (&(&ip->i_iolock)->mr_lock){----}:
May  9 02:16:46 nomad64 kernel: [42951853.992974]        [<ffffffff80261d72>] __lock_acquire+0xf92/0x1080
May  9 02:16:46 nomad64 kernel: [42951853.992989]        [<ffffffff80261f02>] lock_acquire+0xa2/0xd0
May  9 02:16:46 nomad64 kernel: [42951853.993002]        [<ffffffff80255556>] down_write_nested+0x46/0x80
May  9 02:16:46 nomad64 kernel: [42951853.993018]        [<ffffffff80387fb9>] xfs_ilock+0x99/0xa0
May  9 02:16:46 nomad64 kernel: [42951853.993034]        [<ffffffff803a5117>] xfs_free_eofblocks+0x1c7/0x250
May  9 02:16:46 nomad64 kernel: [42951853.993049]        [<ffffffff803a8a26>] xfs_release+0x186/0x1d0
May  9 02:16:46 nomad64 kernel: [42951853.993062]        [<ffffffff803aeeb0>] xfs_file_release+0x10/0x20
May  9 02:16:46 nomad64 kernel: [42951853.993076]        [<ffffffff802a01cc>] __fput+0xcc/0x1c0
May  9 02:16:46 nomad64 kernel: [42951853.993091]        [<ffffffff802a05e6>] fput+0x16/0x20
May  9 02:16:46 nomad64 kernel: [42951853.993105]        [<ffffffff8028865a>] remove_vma+0x4a/0x80
May  9 02:16:46 nomad64 kernel: [42951853.993120]        [<ffffffff802894e1>] do_munmap+0x281/0x2e0
May  9 02:16:46 nomad64 kernel: [42951853.993134]        [<ffffffff8028958b>] sys_munmap+0x4b/0x70
May  9 02:16:46 nomad64 kernel: [42951853.993148]        [<ffffffff8020b62b>] system_call_after_swapgs+0x7b/0x80
May  9 02:16:46 nomad64 kernel: [42951853.993161]        [<ffffffffffffffff>] 0xffffffffffffffff
May  9 02:16:46 nomad64 kernel: [42951853.993178] 
May  9 02:16:46 nomad64 kernel: [42951853.993178] -> #0 (&mm->mmap_sem){----}:
May  9 02:16:46 nomad64 kernel: [42951853.993185]        [<ffffffff80261b90>] __lock_acquire+0xdb0/0x1080
May  9 02:16:46 nomad64 kernel: [42951853.993197]        [<ffffffff80261f02>] lock_acquire+0xa2/0xd0
May  9 02:16:46 nomad64 kernel: [42951853.993213]        [<ffffffff806b887b>] down_read+0x3b/0x70
May  9 02:16:46 nomad64 kernel: [42951853.993228]        [<ffffffff80222bbd>] do_page_fault+0xdd/0x890
May  9 02:16:46 nomad64 kernel: [42951853.993241]        [<ffffffff806ba5dd>] error_exit+0x0/0xa9
May  9 02:16:46 nomad64 kernel: [42951853.993256]        [<ffffffffffffffff>] 0xffffffffffffffff
May  9 02:16:46 nomad64 kernel: [42951853.993269] 
May  9 02:16:46 nomad64 kernel: [42951853.993270] other info that might help us debug this:
May  9 02:16:46 nomad64 kernel: [42951853.993270] 
May  9 02:16:46 nomad64 kernel: [42951853.993273] 1 lock held by kio_http/3813:
May  9 02:16:46 nomad64 kernel: [42951853.993275]  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff80387f85>] xfs_ilock+0x65/0xa0
May  9 02:16:46 nomad64 kernel: [42951853.993286] 
May  9 02:16:46 nomad64 kernel: [42951853.993287] stack backtrace:
May  9 02:16:46 nomad64 kernel: [42951853.993290] Pid: 3813, comm: kio_http Not tainted 2.6.26-rc1-00243-g46e4965 #1
May  9 02:16:46 nomad64 kernel: [42951853.993292] 
May  9 02:16:46 nomad64 kernel: [42951853.993293] Call Trace:
May  9 02:16:46 nomad64 kernel: [42951853.993297]  [<ffffffff8025f2b3>] print_circular_bug_tail+0x83/0x90
May  9 02:16:46 nomad64 kernel: [42951853.993302]  [<ffffffff80261b90>] __lock_acquire+0xdb0/0x1080
May  9 02:16:46 nomad64 kernel: [42951853.993306]  [<ffffffff80222bbd>] ? do_page_fault+0xdd/0x890
May  9 02:16:46 nomad64 kernel: [42951853.993310]  [<ffffffff80261f02>] lock_acquire+0xa2/0xd0
May  9 02:16:46 nomad64 kernel: [42951853.993313]  [<ffffffff80222bbd>] ? do_page_fault+0xdd/0x890
May  9 02:16:46 nomad64 kernel: [42951853.993317]  [<ffffffff806b887b>] down_read+0x3b/0x70
May  9 02:16:46 nomad64 kernel: [42951853.993320]  [<ffffffff80222bbd>] do_page_fault+0xdd/0x890
May  9 02:16:46 nomad64 kernel: [42951853.993324]  [<ffffffff806ba5dd>] error_exit+0x0/0xa9
May  9 02:16:46 nomad64 kernel: [42951853.993328]  [<ffffffff802739b6>] ? file_read_actor+0x46/0x1b0
May  9 02:16:46 nomad64 kernel: [42951853.993331]  [<ffffffff806ba3d6>] ? _read_unlock_irq+0x36/0x60
May  9 02:16:46 nomad64 kernel: [42951853.993335]  [<ffffffff80275dbc>] ? generic_file_aio_read+0x2cc/0x5d0
May  9 02:16:46 nomad64 kernel: [42951853.993339]  [<ffffffff8025ddb9>] ? get_lock_stats+0x19/0x70
May  9 02:16:46 nomad64 kernel: [42951853.993343]  [<ffffffff803b2769>] ? xfs_read+0x139/0x220
May  9 02:16:46 nomad64 kernel: [42951853.993347]  [<ffffffff803af06d>] ? xfs_file_aio_read+0x4d/0x60
May  9 02:16:46 nomad64 kernel: [42951853.993350]  [<ffffffff8029eeb1>] ? do_sync_read+0xf1/0x130
May  9 02:16:46 nomad64 kernel: [42951853.993354]  [<ffffffff802516e0>] ? autoremove_wake_function+0x0/0x40
May  9 02:16:46 nomad64 kernel: [42951853.993358]  [<ffffffff8026089a>] ? trace_hardirqs_on+0xda/0x170
May  9 02:16:46 nomad64 kernel: [42951853.993361]  [<ffffffff80272e45>] ? __rcu_read_unlock+0xb5/0xc0
May  9 02:16:46 nomad64 kernel: [42951853.993365]  [<ffffffff8026089a>] ? trace_hardirqs_on+0xda/0x170
May  9 02:16:46 nomad64 kernel: [42951853.993369]  [<ffffffff803c4381>] ? security_file_permission+0x11/0x20
May  9 02:16:46 nomad64 kernel: [42951853.993374]  [<ffffffff8029f794>] ? vfs_read+0xc4/0x160
May  9 02:16:46 nomad64 kernel: [42951853.993377]  [<ffffffff8029fc30>] ? sys_read+0x50/0x90
May  9 02:16:46 nomad64 kernel: [42951853.993380]  [<ffffffff8020b62b>] ? system_call_after_swapgs+0x7b/0x80

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
