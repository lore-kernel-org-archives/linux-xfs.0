Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752966AbcJGHIm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 03:08:42 -0400
Date: Fri, 7 Oct 2016 09:08:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161007070838.GA16260@quack2.suse.cz>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20161004214219.GN4205@htj.duckdns.org>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org>
 <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>


So I believe this may be just a problem in overlayfs lockdep annotation
(see below). Added Miklos to CC.

On Thu 06-10-16 08:25:59, CAI Qian wrote:
> > > > Not sure if this related, and there is always a lockdep regards procfs
> > > > happened
> > > > below unless masking by other lockdep issues before the cgroup hang.
> > > > Also,
> > > > this
> > > > hang is always reproducible.
> > > 
> > > Sigh...  Let's get the /proc/*/auxv out of the way - this should deal with
> > > it:
> > So I applied both this and the sanity patch, and both original sanity and the
> > proc warnings went away. However, the cgroup hang can still be reproduced as
> > well as this new xfs internal error below,
> 
> Wait. There is also a lockep happened before the xfs internal error as well.
> 
> [ 5839.452325] ======================================================
> [ 5839.459221] [ INFO: possible circular locking dependency detected ]
> [ 5839.466215] 4.8.0-rc8-splice-fixw-proc+ #4 Not tainted
> [ 5839.471945] -------------------------------------------------------
> [ 5839.478937] trinity-c220/69531 is trying to acquire lock:
> [ 5839.484961]  (&p->lock){+.+.+.}, at: [<ffffffff812ac69c>] seq_read+0x4c/0x3e0
> [ 5839.492967] 
> but task is already holding lock:
> [ 5839.499476]  (sb_writers#8){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 5839.508560] 
> which lock already depends on the new lock.
> 
> [ 5839.517686] 
> the existing dependency chain (in reverse order) is:
> [ 5839.526036] 
> -> #3 (sb_writers#8){.+.+.+}:
> [ 5839.530751]        [<ffffffff810ff174>] lock_acquire+0xd4/0x240
> [ 5839.537368]        [<ffffffff810f8f4a>] percpu_down_read+0x4a/0x90
> [ 5839.544275]        [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 5839.551181]        [<ffffffff812a8544>] mnt_want_write+0x24/0x50
> [ 5839.557892]        [<ffffffffa04a398f>] ovl_want_write+0x1f/0x30 [overlay]
> [ 5839.565577]        [<ffffffffa04a6036>] ovl_do_remove+0x46/0x480 [overlay]
> [ 5839.573259]        [<ffffffffa04a64a3>] ovl_unlink+0x13/0x20 [overlay]
> [ 5839.580555]        [<ffffffff812918ea>] vfs_unlink+0xda/0x190
> [ 5839.586979]        [<ffffffff81293698>] do_unlinkat+0x268/0x2b0
> [ 5839.593599]        [<ffffffff8129419b>] SyS_unlinkat+0x1b/0x30
> [ 5839.600120]        [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 5839.606836]        [<ffffffff817d4a3f>] return_from_SYSCALL_64+0x0/0x7a
> [ 5839.614231] 

So here is IMO the real culprit: do_unlinkat() grabs fs freeze protection
through mnt_want_write(), we grab also i_rwsem in do_unlinkat() in
I_MUTEX_PARENT class a bit after that and further down in vfs_unlink() we
grab i_rwsem for the unlinked inode itself in default I_MUTEX class. Then
in ovl_want_write() we grab freeze protection again, but this time for the
upper filesystem. That establishes sb_writers (overlay) -> I_MUTEX_PARENT
(overlay) -> I_MUTEX (overlay) -> sb_writers (FS-A) lock ordering
(we maintain locking classes per fs type so that's why I'm showing fs type
in parenthesis).

Now this nesting is nasty because once you add locks that are not tracked
per fs type into the mix, you get cycles. In this case we've got
seq_file->lock and cred_guard_mutex into the mix - the splice path is
doing sb_writers (FS-A) -> seq_file->lock -> cred_guard_mutex (splicing
from seq_file into the real filesystem). Exec path further establishes
cred_guard_mutex -> I_MUTEX (overlay) which closes the full cycle:

sb_writers (FS-A) -> seq_file->lock -> cred_guard_mutex -> i_mutex
(overlay) -> sb_writers (FS-A)

If I analyzed the lockdep trace, this looks like a real (although remote)
deadlock possibility. Miklos?

								Honza

> -> #2 (&sb->s_type->i_mutex_key#17){++++++}:
> [ 5839.620399]        [<ffffffff810ff174>] lock_acquire+0xd4/0x240
> [ 5839.627015]        [<ffffffff817d1b77>] down_read+0x47/0x70
> [ 5839.633242]        [<ffffffff8128cfd2>] lookup_slow+0xc2/0x1f0
> [ 5839.639762]        [<ffffffff8128f6f2>] walk_component+0x172/0x220
> [ 5839.646668]        [<ffffffff81290fd6>] link_path_walk+0x1a6/0x620
> [ 5839.653574]        [<ffffffff81291a81>] path_openat+0xe1/0xdb0
> [ 5839.660092]        [<ffffffff812939e1>] do_filp_open+0x91/0x100
> [ 5839.666707]        [<ffffffff81288e06>] do_open_execat+0x76/0x180
> [ 5839.673517]        [<ffffffff81288f3b>] open_exec+0x2b/0x50
> [ 5839.679743]        [<ffffffff812eccf3>] load_elf_binary+0x2a3/0x10a0
> [ 5839.686844]        [<ffffffff81288917>] search_binary_handler+0x97/0x1d0
> [ 5839.694331]        [<ffffffff81289ed8>] do_execveat_common.isra.35+0x678/0x9a0
> [ 5839.702400]        [<ffffffff8128a4da>] SyS_execve+0x3a/0x50
> [ 5839.708726]        [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 5839.715441]        [<ffffffff817d4a3f>] return_from_SYSCALL_64+0x0/0x7a
> [ 5839.722833] 
> -> #1 (&sig->cred_guard_mutex){+.+.+.}:
> [ 5839.728510]        [<ffffffff810ff174>] lock_acquire+0xd4/0x240
> [ 5839.735126]        [<ffffffff817cfc66>] mutex_lock_killable_nested+0x86/0x540
> [ 5839.743097]        [<ffffffff81301e84>] lock_trace+0x24/0x60
> [ 5839.749421]        [<ffffffff8130224d>] proc_pid_syscall+0x2d/0x110
> [ 5839.756423]        [<ffffffff81302af0>] proc_single_show+0x50/0x90
> [ 5839.763330]        [<ffffffff812ab867>] traverse+0xf7/0x210
> [ 5839.769557]        [<ffffffff812ac9eb>] seq_read+0x39b/0x3e0
> [ 5839.775884]        [<ffffffff81280573>] do_loop_readv_writev+0x83/0xc0
> [ 5839.783179]        [<ffffffff81281a03>] do_readv_writev+0x213/0x230
> [ 5839.790181]        [<ffffffff81281a59>] vfs_readv+0x39/0x50
> [ 5839.796406]        [<ffffffff81281c12>] do_preadv+0xa2/0xc0
> [ 5839.802634]        [<ffffffff81282ec1>] SyS_preadv+0x11/0x20
> [ 5839.808963]        [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 5839.815681]        [<ffffffff817d4a3f>] return_from_SYSCALL_64+0x0/0x7a
> [ 5839.823075] 
> -> #0 (&p->lock){+.+.+.}:
> [ 5839.827395]        [<ffffffff810fe69c>] __lock_acquire+0x151c/0x1990
> [ 5839.834500]        [<ffffffff810ff174>] lock_acquire+0xd4/0x240
> [ 5839.841115]        [<ffffffff817cf3b6>] mutex_lock_nested+0x76/0x450
> [ 5839.848219]        [<ffffffff812ac69c>] seq_read+0x4c/0x3e0
> [ 5839.854448]        [<ffffffff8131566b>] kernfs_fop_read+0x12b/0x1b0
> [ 5839.861451]        [<ffffffff81280573>] do_loop_readv_writev+0x83/0xc0
> [ 5839.868742]        [<ffffffff81281a03>] do_readv_writev+0x213/0x230
> [ 5839.875744]        [<ffffffff81281a59>] vfs_readv+0x39/0x50
> [ 5839.881971]        [<ffffffff812bc55a>] default_file_splice_read+0x1aa/0x2c0
> [ 5839.889847]        [<ffffffff812bb913>] do_splice_to+0x73/0x90
> [ 5839.896365]        [<ffffffff812bba1b>] splice_direct_to_actor+0xeb/0x220
> [ 5839.903950]        [<ffffffff812bbbd9>] do_splice_direct+0x89/0xd0
> [ 5839.910857]        [<ffffffff8128261e>] do_sendfile+0x1ce/0x3b0
> [ 5839.917470]        [<ffffffff812831df>] SyS_sendfile64+0x6f/0xd0
> [ 5839.924184]        [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 5839.930898]        [<ffffffff817d4a3f>] return_from_SYSCALL_64+0x0/0x7a
> [ 5839.938286] 
> other info that might help us debug this:
> 
> [ 5839.947217] Chain exists of:
>   &p->lock --> &sb->s_type->i_mutex_key#17 --> sb_writers#8
> 
> [ 5839.956615]  Possible unsafe locking scenario:
> 
> [ 5839.963218]        CPU0                    CPU1
> [ 5839.968269]        ----                    ----
> [ 5839.973321]   lock(sb_writers#8);
> [ 5839.977046]                                lock(&sb->s_type->i_mutex_key#17);
> [ 5839.985037]                                lock(sb_writers#8);
> [ 5839.991573]   lock(&p->lock);
> [ 5839.994900] 
>  *** DEADLOCK ***
> 
> [ 5840.001503] 1 lock held by trinity-c220/69531:
> [ 5840.006457]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 5840.016031] 
> stack backtrace:
> [ 5840.020891] CPU: 12 PID: 69531 Comm: trinity-c220 Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 5840.030306] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
> [ 5840.041660]  0000000000000086 00000000a1ef62f8 ffff8803ca52f7c0 ffffffff813d2ecc
> [ 5840.049952]  ffffffff82a41160 ffffffff82a913e0 ffff8803ca52f800 ffffffff811dd630
> [ 5840.058245]  ffff8803ca52f840 ffff880392c4ecc8 ffff880392c4e000 0000000000000001
> [ 5840.066537] Call Trace:
> [ 5840.069266]  [<ffffffff813d2ecc>] dump_stack+0x85/0xc9
> [ 5840.075000]  [<ffffffff811dd630>] print_circular_bug+0x1f9/0x207
> [ 5840.081701]  [<ffffffff810fe69c>] __lock_acquire+0x151c/0x1990
> [ 5840.088208]  [<ffffffff810ff174>] lock_acquire+0xd4/0x240
> [ 5840.094232]  [<ffffffff812ac69c>] ? seq_read+0x4c/0x3e0
> [ 5840.100061]  [<ffffffff812ac69c>] ? seq_read+0x4c/0x3e0
> [ 5840.105891]  [<ffffffff817cf3b6>] mutex_lock_nested+0x76/0x450
> [ 5840.112397]  [<ffffffff812ac69c>] ? seq_read+0x4c/0x3e0
> [ 5840.118228]  [<ffffffff810fb3e9>] ? __lock_is_held+0x49/0x70
> [ 5840.124540]  [<ffffffff812ac69c>] seq_read+0x4c/0x3e0
> [ 5840.130175]  [<ffffffff81315540>] ? kernfs_vma_page_mkwrite+0x90/0x90
> [ 5840.137360]  [<ffffffff8131566b>] kernfs_fop_read+0x12b/0x1b0
> [ 5840.143770]  [<ffffffff81315540>] ? kernfs_vma_page_mkwrite+0x90/0x90
> [ 5840.150956]  [<ffffffff81280573>] do_loop_readv_writev+0x83/0xc0
> [ 5840.157657]  [<ffffffff81315540>] ? kernfs_vma_page_mkwrite+0x90/0x90
> [ 5840.164843]  [<ffffffff81281a03>] do_readv_writev+0x213/0x230
> [ 5840.171255]  [<ffffffff81418cf9>] ? __pipe_get_pages+0x24/0x9b
> [ 5840.177762]  [<ffffffff813e6f0f>] ? iov_iter_get_pages_alloc+0x19f/0x360
> [ 5840.185240]  [<ffffffff810fd5f2>] ? __lock_acquire+0x472/0x1990
> [ 5840.191843]  [<ffffffff81281a59>] vfs_readv+0x39/0x50
> [ 5840.197478]  [<ffffffff812bc55a>] default_file_splice_read+0x1aa/0x2c0
> [ 5840.204763]  [<ffffffff810cba89>] ? __might_sleep+0x49/0x80
> [ 5840.210980]  [<ffffffff81349c93>] ? security_file_permission+0xa3/0xc0
> [ 5840.218264]  [<ffffffff812bb913>] do_splice_to+0x73/0x90
> [ 5840.224190]  [<ffffffff812bba1b>] splice_direct_to_actor+0xeb/0x220
> [ 5840.231182]  [<ffffffff812baee0>] ? generic_pipe_buf_nosteal+0x10/0x10
> [ 5840.238465]  [<ffffffff812bbbd9>] do_splice_direct+0x89/0xd0
> [ 5840.244778]  [<ffffffff8128261e>] do_sendfile+0x1ce/0x3b0
> [ 5840.250802]  [<ffffffff812831df>] SyS_sendfile64+0x6f/0xd0
> [ 5840.256922]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 5840.263042]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> 
>    CAI Qian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
