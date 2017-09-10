Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:51702 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdIJBH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 21:07:59 -0400
Date: Sat, 9 Sep 2017 21:07:56 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
References: <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908010441.GZ5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 02:04:41AM +0100, Al Viro wrote:
 
 > There's at least one suspicious place in iomap_dio_actor() -
 >                 if (!(dio->flags & IOMAP_DIO_WRITE)) {
 >                         iov_iter_zero(length, dio->submit.iter);
 >                         dio->size += length;
 >                         return length;
 >                 }
 > which assumes that iov_iter_zero() always succeeds.  That's very
 > much _not_ true - neither for iovec-backed, not for pipe-backed.
 > Orangefs read_one_page() is fine (it calls that sucker for bvec-backed
 > iov_iter it's just created), but iomap_dio_actor() is not.
 > 
 > I'm not saying that it will suffice, but we definitely need this:
 > 
 > diff --git a/fs/iomap.c b/fs/iomap.c
 > index 269b24a01f32..4a671263475f 100644
 > --- a/fs/iomap.c
 > +++ b/fs/iomap.c
 > @@ -843,7 +843,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 >  		/*FALLTHRU*/
 >  	case IOMAP_UNWRITTEN:
 >  		if (!(dio->flags & IOMAP_DIO_WRITE)) {
 > -			iov_iter_zero(length, dio->submit.iter);
 > +			length = iov_iter_zero(length, dio->submit.iter);
 >  			dio->size += length;
 >  			return length;

With this in place, I'm still seeing -EBUSY from invalidate_inode_pages2_range
which doesn't end well...


WARNING: CPU: 3 PID: 11443 at fs/iomap.c:993 iomap_dio_rw+0x825/0x840
CPU: 3 PID: 11443 Comm: trinity-c39 Not tainted 4.13.0-think+ #9 
task: ffff880461080040 task.stack: ffff88043d720000
RIP: 0010:iomap_dio_rw+0x825/0x840
RSP: 0018:ffff88043d727730 EFLAGS: 00010286
RAX: 00000000fffffff0 RBX: ffff88044f036428 RCX: 0000000000000000
RDX: ffffed0087ae4e67 RSI: 0000000000000000 RDI: ffffed0087ae4ed7
RBP: ffff88043d727910 R08: ffff88046b4176c0 R09: 0000000000000000
R10: ffff88043d726d20 R11: 0000000000000001 R12: ffff88043d727a90
R13: 00000000027253f7 R14: 1ffff10087ae4ef4 R15: ffff88043d727c10
FS:  00007f5d8613e700(0000) GS:ffff88046b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5d84503000 CR3: 00000004594e1000 CR4: 00000000001606e0
Call Trace:
 ? iomap_seek_data+0xb0/0xb0
 ? down_read_nested+0xd3/0x160
 ? down_read_non_owner+0x40/0x40
 ? xfs_ilock+0x3cb/0x460 [xfs]
 ? sched_clock_cpu+0x14/0xf0
 ? __lock_is_held+0x51/0xc0
 ? xfs_file_dio_aio_read+0x123/0x350 [xfs]
 xfs_file_dio_aio_read+0x123/0x350 [xfs]
 ? xfs_file_fallocate+0x550/0x550 [xfs]
 ? lock_release+0xa00/0xa00
 ? ___might_sleep.part.70+0x118/0x320
 xfs_file_read_iter+0x1b1/0x1d0 [xfs]
 do_iter_readv_writev+0x2ea/0x330
 ? vfs_dedupe_file_range+0x400/0x400
 do_iter_read+0x149/0x280
 vfs_readv+0x107/0x180
 ? vfs_iter_read+0x60/0x60
 ? fget_raw+0x10/0x10
 ? native_sched_clock+0xf9/0x1a0
 ? __fdget_pos+0xd6/0x110
 ? __fdget_pos+0xd6/0x110
 ? __fdget_raw+0x10/0x10
 ? do_readv+0xc0/0x1b0
 do_readv+0xc0/0x1b0
 ? vfs_readv+0x180/0x180
 ? mark_held_locks+0x1c/0x90
 ? do_syscall_64+0xae/0x3e0
 ? compat_rw_copy_check_uvector+0x1b0/0x1b0
 do_syscall_64+0x182/0x3e0
 ? syscall_return_slowpath+0x250/0x250
 ? rcu_read_lock_sched_held+0x90/0xa0
 ? mark_held_locks+0x1c/0x90
 ? return_from_SYSCALL_64+0x2d/0x7a
 ? trace_hardirqs_on_caller+0x17a/0x250
 ? trace_hardirqs_on_thunk+0x1a/0x1c
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f5d85a69219
RSP: 002b:00007ffdf090afd8 EFLAGS: 00000246
 ORIG_RAX: 0000000000000013
RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 00007f5d85a69219
RDX: 00000000000000ae RSI: 0000565183cd5490 RDI: 0000000000000056
RBP: 00007ffdf090b080 R08: 0141082b00011c63 R09: 0000000000000000
R10: 00000000ffffe000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f5d86026058 R14: 00007f5d8613e698 R15: 00007f5d86026000
