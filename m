Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 10:45:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FHjCeV020713
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:45:15 -0700
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAA47173643
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:45:56 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.227]) by cuda.sgi.com with ESMTP id Pam4tGQ9CZSB2Mkf for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:45:56 -0700 (PDT)
Received: by wx-out-0506.google.com with SMTP id h30so422074wxd.32
        for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:45:56 -0700 (PDT)
Message-ID: <a4423d670805151045k4d2f9459geaeeff7418957487@mail.gmail.com>
Date: Thu, 15 May 2008 21:45:55 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: 2.6.26-rc1: possible circular locking dependency with xfs filesystem
In-Reply-To: <20080511231002.GN103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com>
	 <4825DF71.1030209@linux.vnet.ibm.com>
	 <48266C77.3040102@linux.vnet.ibm.com>
	 <20080511231002.GN103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, pvp-lsts@fs.ru.acad.bg, kernel-testers@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, xfs@oss.sgi.com

2008/5/12 David Chinner <dgc@sgi.com>:
> On Sun, May 11, 2008 at 09:18:07AM +0530, Kamalesh Babulal wrote:
>> Kamalesh Babulal wrote:
>> > Adding the cc to kernel-list, Ingo Molnar and Peter Zijlstra
>> >
>> > Alexander Beregalov wrote:
>> >> [ INFO: possible circular locking dependency detected ]
>> >> 2.6.26-rc1-00279-g28a4acb #13
>> >> -------------------------------------------------------
>> >> nfsd/3087 is trying to acquire lock:
>> >>  (iprune_mutex){--..}, at: [<c016f947>] shrink_icache_memory+0x38/0x19b
>> >>
>> >> but task is already holding lock:
>> >>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6
>> >>
>> >> which lock already depends on the new lock.
>> >>
>> >>
>> >> the existing dependency chain (in reverse order) is:
>> >>
>> >> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>> >>        [<c01352e6>] __lock_acquire+0xa0c/0xbc6
>> >>        [<c013550a>] lock_acquire+0x6a/0x86
>> >>        [<c012c39a>] down_write_nested+0x33/0x6a
>> >>        [<c0210b5c>] xfs_ilock+0x7b/0xd6
>> >>        [<c0210cd5>] xfs_ireclaim+0x1d/0x59
>> >>        [<c022edfe>] xfs_finish_reclaim+0x173/0x195
>> >>        [<c0230fa3>] xfs_reclaim+0xb3/0x138
>> >>        [<c023b4cb>] xfs_fs_clear_inode+0x55/0x8e
>> >>        [<c016f60b>] clear_inode+0x83/0xd2
>> >>        [<c016f88a>] dispose_list+0x3c/0xc1
>> >>        [<c016fa82>] shrink_icache_memory+0x173/0x19b
>> >>        [<c014a68d>] shrink_slab+0xda/0x14e
>> >>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>> >>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>> >>        [<c0146b11>] __alloc_pages+0xa/0xc
>> >>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>> >>        [<c01484bc>] force_page_cache_readahead+0x4a/0x74
>> >>        [<c014c9b0>] sys_madvise+0x308/0x400
>> >>        [<c0102b25>] sysenter_past_esp+0x6a/0xb1
>> >>        [<ffffffff>] 0xffffffff
>> >>
>> >> -> #0 (iprune_mutex){--..}:
>> >>        [<c0135203>] __lock_acquire+0x929/0xbc6
>> >>        [<c013550a>] lock_acquire+0x6a/0x86
>> >>        [<c0356a6f>] mutex_lock_nested+0xb4/0x226
>> >>        [<c016f947>] shrink_icache_memory+0x38/0x19b
>> >>        [<c014a68d>] shrink_slab+0xda/0x14e
>> >>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>> >>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>> >>        [<c0146b11>] __alloc_pages+0xa/0xc
>> >>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>> >>        [<c014866c>] ondemand_readahead+0x119/0x127
>> >>        [<c01486cc>] page_cache_async_readahead+0x52/0x5d
>> >>        [<c0178e46>] generic_file_splice_read+0x290/0x4a8
>> >>        [<c0239f06>] xfs_splice_read+0x4b/0x78
>> >>        [<c0237713>] xfs_file_splice_read+0x24/0x29
>> >>        [<c0178182>] do_splice_to+0x45/0x63
>> >>        [<c01783f6>] splice_direct_to_actor+0xab/0x150
>> >>        [<c01ce8e1>] nfsd_vfs_read+0x1ed/0x2d0
>> >>        [<c01ced50>] nfsd_read+0x82/0x99
>> >>        [<c01d42bc>] nfsd3_proc_read+0xdf/0x12a
>> >>        [<c01cb40b>] nfsd_dispatch+0xcf/0x19e
>> >>        [<c033f484>] svc_process+0x3b3/0x68b
>> >>        [<c01cb939>] nfsd+0x168/0x26b
>> >>        [<c0103747>] kernel_thread_helper+0x7/0x10
>> >>        [<ffffffff>] 0xffffffff
>
> Oh, yeah, that. Direct inode reclaim through memory pressure.
>
> Effectively memory reclaim inverts locking order w.r.t. iprune_mutex
> when it recurses into the filesystem. False positive - can never
> cause a deadlock on XFS. Can't be solved from the XFS side of things
> without effectively turning off lockdep checking for xfs inode
> locking.
Yes, it is not a deadlock, but machine hangs for few seconds.
It still happens about once a day for me. Every kernel report looks
similar to the above.
I cannot reproduce it quickly, so bisect is not possible.

>
> The fix is needed to lockdep via iprune_mutex annotations here....
>
>> May  9 02:16:46 nomad64 kernel: [42951853.992965] the existing dependency chain (in reverse order) is:
>> May  9 02:16:46 nomad64 kernel: [42951853.992967]
>> May  9 02:16:46 nomad64 kernel: [42951853.992968] -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>> May  9 02:16:46 nomad64 kernel: [42951853.992974]        [<ffffffff80261d72>] __lock_acquire+0xf92/0x1080
>> May  9 02:16:46 nomad64 kernel: [42951853.992989]        [<ffffffff80261f02>] lock_acquire+0xa2/0xd0
>> May  9 02:16:46 nomad64 kernel: [42951853.993002]        [<ffffffff80255556>] down_write_nested+0x46/0x80
>> May  9 02:16:46 nomad64 kernel: [42951853.993018]        [<ffffffff80387fb9>] xfs_ilock+0x99/0xa0
>> May  9 02:16:46 nomad64 kernel: [42951853.993034]        [<ffffffff803a5117>] xfs_free_eofblocks+0x1c7/0x250
>> May  9 02:16:46 nomad64 kernel: [42951853.993049]        [<ffffffff803a8a26>] xfs_release+0x186/0x1d0
>> May  9 02:16:46 nomad64 kernel: [42951853.993062]        [<ffffffff803aeeb0>] xfs_file_release+0x10/0x20
>> May  9 02:16:46 nomad64 kernel: [42951853.993076]        [<ffffffff802a01cc>] __fput+0xcc/0x1c0
>> May  9 02:16:46 nomad64 kernel: [42951853.993091]        [<ffffffff802a05e6>] fput+0x16/0x20
>> May  9 02:16:46 nomad64 kernel: [42951853.993105]        [<ffffffff8028865a>] remove_vma+0x4a/0x80
>> May  9 02:16:46 nomad64 kernel: [42951853.993120]        [<ffffffff802894e1>] do_munmap+0x281/0x2e0
>> May  9 02:16:46 nomad64 kernel: [42951853.993134]        [<ffffffff8028958b>] sys_munmap+0x4b/0x70
>> May  9 02:16:46 nomad64 kernel: [42951853.993148]        [<ffffffff8020b62b>] system_call_after_swapgs+0x7b/0x80
>> May  9 02:16:46 nomad64 kernel: [42951853.993161]        [<ffffffffffffffff>] 0xffffffffffffffff
>
> hmmmm. Sounds like:
>
>        fd = open()
>        addr = mmap(fd)
>        close(fd)
>        .....
>        munmap(addr);
>
> But yes, XFS takes locks in ->release which means.....
>
>> May  9 02:16:46 nomad64 kernel: [42951853.993293] Call Trace:
>> May  9 02:16:46 nomad64 kernel: [42951853.993297]  [<ffffffff8025f2b3>] print_circular_bug_tail+0x83/0x90
>> May  9 02:16:46 nomad64 kernel: [42951853.993302]  [<ffffffff80261b90>] __lock_acquire+0xdb0/0x1080
>> May  9 02:16:46 nomad64 kernel: [42951853.993306]  [<ffffffff80222bbd>] ? do_page_fault+0xdd/0x890
>> May  9 02:16:46 nomad64 kernel: [42951853.993310]  [<ffffffff80261f02>] lock_acquire+0xa2/0xd0
>> May  9 02:16:46 nomad64 kernel: [42951853.993313]  [<ffffffff80222bbd>] ? do_page_fault+0xdd/0x890
>> May  9 02:16:46 nomad64 kernel: [42951853.993317]  [<ffffffff806b887b>] down_read+0x3b/0x70
>> May  9 02:16:46 nomad64 kernel: [42951853.993320]  [<ffffffff80222bbd>] do_page_fault+0xdd/0x890
>> May  9 02:16:46 nomad64 kernel: [42951853.993324]  [<ffffffff806ba5dd>] error_exit+0x0/0xa9
>> May  9 02:16:46 nomad64 kernel: [42951853.993328]  [<ffffffff802739b6>] ? file_read_actor+0x46/0x1b0
>> May  9 02:16:46 nomad64 kernel: [42951853.993331]  [<ffffffff806ba3d6>] ? _read_unlock_irq+0x36/0x60
>> May  9 02:16:46 nomad64 kernel: [42951853.993335]  [<ffffffff80275dbc>] ? generic_file_aio_read+0x2cc/0x5d0
>> May  9 02:16:46 nomad64 kernel: [42951853.993339]  [<ffffffff8025ddb9>] ? get_lock_stats+0x19/0x70
>> May  9 02:16:46 nomad64 kernel: [42951853.993343]  [<ffffffff803b2769>] ? xfs_read+0x139/0x220
>> May  9 02:16:46 nomad64 kernel: [42951853.993347]  [<ffffffff803af06d>] ? xfs_file_aio_read+0x4d/0x60
>> May  9 02:16:46 nomad64 kernel: [42951853.993350]  [<ffffffff8029eeb1>] ? do_sync_read+0xf1/0x130
>> May  9 02:16:46 nomad64 kernel: [42951853.993354]  [<ffffffff802516e0>] ? autoremove_wake_function+0x0/0x40
>> May  9 02:16:46 nomad64 kernel: [42951853.993358]  [<ffffffff8026089a>] ? trace_hardirqs_on+0xda/0x170
>> May  9 02:16:46 nomad64 kernel: [42951853.993361]  [<ffffffff80272e45>] ? __rcu_read_unlock+0xb5/0xc0
>> May  9 02:16:46 nomad64 kernel: [42951853.993365]  [<ffffffff8026089a>] ? trace_hardirqs_on+0xda/0x170
>> May  9 02:16:46 nomad64 kernel: [42951853.993369]  [<ffffffff803c4381>] ? security_file_permission+0x11/0x20
>> May  9 02:16:46 nomad64 kernel: [42951853.993374]  [<ffffffff8029f794>] ? vfs_read+0xc4/0x160
>> May  9 02:16:46 nomad64 kernel: [42951853.993377]  [<ffffffff8029fc30>] ? sys_read+0x50/0x90
>> May  9 02:16:46 nomad64 kernel: [42951853.993380]  [<ffffffff8020b62b>] ? system_call_after_swapgs+0x7b/0x80
>
> Oh, joy - a page fault during a read() call triggers lock order
> inversions on the mmap->sem. I don't think this can deadlock
> (can't be page faulting in a vma that is being torn down), but
> it's clear from the last trace that the VM has a mmap->sem
> inversion problem with ->release vs ->read and page faults...
>
> Basically what we are seeing here in both cases is that the VM is
> calling inode ->release or ->clear_inode methods with different high
> level locks held. If the filesystem has to take the same locks in
> these methods as it does in, say, ->read (like XFS does), then we
> are guaranteed to get reports like this. AFAICT there's nothing we
> can do from the filesystem perspective to prevent false positives like
> this from being reported....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
