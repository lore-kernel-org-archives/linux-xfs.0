Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:52918 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdIJQHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 12:07:14 -0400
Date: Sun, 10 Sep 2017 12:07:10 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170910160710.7myz4iel2mnvya3b@codemonkey.org.uk>
References: <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910025712.GC5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 03:57:21AM +0100, Al Viro wrote:
 > On Sat, Sep 09, 2017 at 09:07:56PM -0400, Dave Jones wrote:
 > 
 > > With this in place, I'm still seeing -EBUSY from invalidate_inode_pages2_range
 > > which doesn't end well...
 > 
 > Different issue, and I'm not sure why that WARN_ON() is there in the
 > first place.  Note that in a similar situation generic_file_direct_write()
 > simply buggers off and lets the caller do buffered write...
 > 
 > iov_iter_pipe() warning is a sign of ->read_iter() on pipe-backed iov_iter
 > putting into the pipe more than it claims to have done.

(from a rerun after hitting that EBUSY warn; hence the taint)

WARNING: CPU: 0 PID: 14154 at fs/iomap.c:1055 iomap_dio_rw+0x78e/0x840
CPU: 0 PID: 14154 Comm: trinity-c33 Tainted: G        W       4.13.0-think+ #9 
task: ffff8801027e3e40 task.stack: ffff8801632d8000
RIP: 0010:iomap_dio_rw+0x78e/0x840
RSP: 0018:ffff8801632df370 EFLAGS: 00010286
RAX: 00000000fffffff0 RBX: ffff880428666428 RCX: ffffffffffffffea
RDX: ffffed002c65bdef RSI: 0000000000000000 RDI: ffffed002c65be5f
RBP: ffff8801632df550 R08: ffff88046ae176c0 R09: 0000000000000000
R10: ffff8801632de960 R11: 0000000000000001 R12: ffff8801632df7f0
R13: ffffffffffffffea R14: 1ffff1002c65be7c R15: ffff8801632df988
FS:  00007f3da2100700(0000) GS:ffff88046ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000002f6223001 CR4: 00000000001606f0
DR0: 00007f3da1f3d000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 ? iomap_seek_data+0xb0/0xb0
 ? find_inode_fast+0xd0/0xd0
 ? xfs_file_aio_write_checks+0x295/0x320 [xfs]
 ? __lock_is_held+0x51/0xc0
 ? xfs_file_dio_aio_write+0x286/0x7e0 [xfs]
 ? rcu_read_lock_sched_held+0x90/0xa0
 xfs_file_dio_aio_write+0x286/0x7e0 [xfs]
 ? xfs_file_aio_write_checks+0x320/0x320 [xfs]
 ? unwind_get_return_address+0x2f/0x50
 ? __save_stack_trace+0x92/0x100
 ? memcmp+0x45/0x70
 ? depot_save_stack+0x12e/0x480
 ? save_stack+0x89/0xb0
 ? save_stack+0x32/0xb0
 ? kasan_kmalloc+0xa0/0xd0
 ? __kmalloc+0x157/0x360
 ? iter_file_splice_write+0x154/0x760
 ? direct_splice_actor+0x86/0xa0
 ? splice_direct_to_actor+0x1c4/0x420
 ? do_splice_direct+0x173/0x1e0
 ? do_sendfile+0x3a2/0x6d0
 ? SyS_sendfile64+0xa4/0x130
 ? do_syscall_64+0x182/0x3e0
 ? entry_SYSCALL64_slow_path+0x25/0x25
 ? match_held_lock+0xa6/0x410
 ? iter_file_splice_write+0x154/0x760
 xfs_file_write_iter+0x227/0x280 [xfs]
 do_iter_readv_writev+0x267/0x330
 ? vfs_dedupe_file_range+0x400/0x400
 do_iter_write+0xd7/0x280
 ? splice_from_pipe_next.part.9+0x28/0x160
 iter_file_splice_write+0x4d5/0x760
 ? page_cache_pipe_buf_steal+0x2b0/0x2b0
 ? generic_file_splice_read+0x2e1/0x340
 ? pipe_to_user+0x80/0x80
 direct_splice_actor+0x86/0xa0
 splice_direct_to_actor+0x1c4/0x420
 ? generic_pipe_buf_nosteal+0x10/0x10
 ? do_splice_to+0xc0/0xc0
 do_splice_direct+0x173/0x1e0
 ? splice_direct_to_actor+0x420/0x420
 ? rcu_read_lock_sched_held+0x90/0xa0
 ? rcu_sync_lockdep_assert+0x43/0x70
 ? __sb_start_write+0x179/0x1e0
 do_sendfile+0x3a2/0x6d0
 ? do_compat_pwritev64+0xa0/0xa0
 ? __lock_is_held+0x2e/0xc0
 SyS_sendfile64+0xa4/0x130
 ? SyS_sendfile+0x140/0x140
 ? mark_held_locks+0x1c/0x90
 ? do_syscall_64+0xae/0x3e0
 ? SyS_sendfile+0x140/0x140
 do_syscall_64+0x182/0x3e0
 ? syscall_return_slowpath+0x250/0x250
 ? rcu_read_lock_sched_held+0x90/0xa0
 ? __context_tracking_exit.part.4+0x223/0x290
 ? mark_held_locks+0x1c/0x90
 ? return_from_SYSCALL_64+0x2d/0x7a
 ? trace_hardirqs_on_caller+0x17a/0x250
 ? trace_hardirqs_on_thunk+0x1a/0x1c
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f3da1a2b219
RSP: 002b:00007ffdd1642f38 EFLAGS: 00000246
 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000028 RCX: 00007f3da1a2b219
RDX: 00007f3da1f3d000 RSI: 000000000000005f RDI: 0000000000000060
RBP: 00007ffdd1642fe0 R08: 30503123188dbe3f R09: ffffffffe7e7e7e7
R10: 000000000000f000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f3da2012058 R14: 00007f3da2100698 R15: 00007f3da2012000
