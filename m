Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:57794 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdIFUDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 16:03:40 -0400
Date: Wed, 6 Sep 2017 16:03:37 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
References: <20170412170723.GQ29622@ZenIV.linux.org.uk>
 <20170412190318.srkkdytf2ebrjzrg@codemonkey.org.uk>
 <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829042542.GO4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 09:25:42PM -0700, Darrick J. Wong wrote:
 > On Mon, Aug 28, 2017 at 04:31:30PM -0400, Dave Jones wrote:
 > > On Mon, Aug 07, 2017 at 04:18:18PM -0400, Dave Jones wrote:
 > >  > On Fri, Apr 28, 2017 at 06:20:25PM +0100, Al Viro wrote:
 > >  >  > On Fri, Apr 28, 2017 at 12:50:24PM -0400, Dave Jones wrote:
 > >  >  > > currently running v4.11-rc8-75-gf83246089ca0
 > >  >  > > 
 > >  >  > > sunrpc bit is for the other unrelated problem I'm chasing.
 > >  >  > > 
 > >  >  > > note also, I saw the backtrace without the fs/splice.c changes.
 > >  >  > 
 > >  >  > 	Interesting...  Could you add this and see if that triggers?
 > >  >  > 
 > >  >  > diff --git a/fs/splice.c b/fs/splice.c
 > >  >  > index 540c4a44756c..12a12d9c313f 100644
 > >  >  > --- a/fs/splice.c
 > >  >  > +++ b/fs/splice.c
 > >  >  > @@ -306,6 +306,9 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 > >  >  >  	kiocb.ki_pos = *ppos;
 > >  >  >  	ret = call_read_iter(in, &kiocb, &to);
 > >  >  >  	if (ret > 0) {
 > >  >  > +		if (WARN_ON(iov_iter_count(&to) != len - ret))
 > >  >  > +			printk(KERN_ERR "ops %p: was %zd, left %zd, returned %d\n",
 > >  >  > +				in->f_op, len, iov_iter_count(&to), ret);
 > >  >  >  		*ppos = kiocb.ki_pos;
 > >  >  >  		file_accessed(in);
 > >  >  >  	} else if (ret < 0) {
 > >  > 
 > >  > Hey Al,
 > >  >  Due to a git stash screw up on my part, I've had this leftover WARN_ON
 > >  > in my tree for the last couple months. (That screw-up might turn out to be
 > >  > serendipitous if this is a real bug..)
 > >  > 
 > >  > Today I decided to change things up and beat up on xfs for a change, and
 > >  > was able to trigger this again.
 > >  > 
 > >  > Is this check no longer valid, or am I triggering the same bug we were chased
 > >  > down in nfs, but now in xfs ?  (None of the other detritus from that debugging
 > >  > back in April made it, just those three lines above).
 > > 
 > > Revisiting this. I went back and dug out some of the other debug diffs [1]
 > > from that old thread.
 > > 
 > > I can easily trigger this spew on xfs.
 > > 
 > > 
 > > WARNING: CPU: 1 PID: 2251 at fs/splice.c:292 test_it+0xd4/0x1d0
 > > CPU: 1 PID: 2251 Comm: trinity-c42 Not tainted 4.13.0-rc7-think+ #1 
 > > task: ffff880459173a40 task.stack: ffff88044f7d0000
 > > RIP: 0010:test_it+0xd4/0x1d0
 > > RSP: 0018:ffff88044f7d7878 EFLAGS: 00010283
 > > RAX: 0000000000000000 RBX: ffff88044f44b968 RCX: ffffffff81511ea0
 > > RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffff88044f44ba68
 > > RBP: ffff88044f7d78c8 R08: ffff88046b218ec0 R09: 0000000000000000
 > > R10: ffff88044f7d7518 R11: 0000000000000000 R12: 0000000000001000
 > > R13: 0000000000000001 R14: 00000000ffffffff R15: 0000000000000001
 > > FS:  00007fdbc09b2700(0000) GS:ffff88046b200000(0000) knlGS:0000000000000000
 > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > > CR2: 0000000000000000 CR3: 0000000459e1d000 CR4: 00000000001406e0
 > > Call Trace:
 > >  generic_file_splice_read+0x414/0x4e0
 > >  ? opipe_prep.part.14+0x180/0x180
 > >  ? lockdep_init_map+0xb2/0x2b0
 > >  ? rw_verify_area+0x65/0x150
 > >  do_splice_to+0xab/0xc0
 > >  splice_direct_to_actor+0x1f5/0x540
 > >  ? generic_pipe_buf_nosteal+0x10/0x10
 > >  ? do_splice_to+0xc0/0xc0
 > >  ? rw_verify_area+0x9d/0x150
 > >  do_splice_direct+0x1b9/0x230
 > >  ? splice_direct_to_actor+0x540/0x540
 > >  ? __sb_start_write+0x164/0x1c0
 > >  ? do_sendfile+0x7b3/0x840
 > >  do_sendfile+0x428/0x840
 > >  ? do_compat_pwritev64+0xb0/0xb0
 > >  ? __might_sleep+0x72/0xe0
 > >  ? kasan_check_write+0x14/0x20
 > >  SyS_sendfile64+0xa4/0x120
 > >  ? SyS_sendfile+0x150/0x150
 > >  ? mark_held_locks+0x23/0xb0
 > >  ? do_syscall_64+0xc0/0x3e0
 > >  ? SyS_sendfile+0x150/0x150
 > >  do_syscall_64+0x1bc/0x3e0
 > >  ? syscall_return_slowpath+0x240/0x240
 > >  ? mark_held_locks+0x23/0xb0
 > >  ? return_from_SYSCALL_64+0x2d/0x7a
 > >  ? trace_hardirqs_on_caller+0x182/0x260
 > >  ? trace_hardirqs_on_thunk+0x1a/0x1c
 > >  entry_SYSCALL64_slow_path+0x25/0x25
 > > RIP: 0033:0x7fdbc02dd219
 > > RSP: 002b:00007ffc5024fa48 EFLAGS: 00000246
 > >  ORIG_RAX: 0000000000000028
 > > RAX: ffffffffffffffda RBX: 0000000000000028 RCX: 00007fdbc02dd219
 > > RDX: 00007fdbbe348000 RSI: 0000000000000011 RDI: 0000000000000015
 > > RBP: 00007ffc5024faf0 R08: 000000000000006d R09: 0094e82f2c730a50
 > > R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000002
 > > R13: 00007fdbc0885058 R14: 00007fdbc09b2698 R15: 00007fdbc0885000
 > > ---[ end trace a5847ef0f7be7e20 ]---
 > > asked to read 4096, claims to have read 1
 > > actual size of data in pipe 4096 
 > > [0:4096]
 > > f_op: ffffffffa058c920, f_flags: 49154, pos: 0/1, size: 0
 > > 
 > > 
 > > I'm still trying to narrow down an exact reproducer, but it seems having
 > > trinity do a combination of sendfile & writev, with pipes and regular
 > > files as fd's is the best repro.
 > > 
 > > Is this a real problem, or am I chasing ghosts ?  That it doesn't happen
 > > on ext4 or btrfs is making me wonder...
 > 
 > <shrug> I haven't heard of any problems w/ directio xfs lately, but OTOH
 > I think it's the only filesystem that uses iomap_dio_rw, which would
 > explain why ext4/btrfs don't have this problem.

Another warning, from likely the same root cause.

WARNING: CPU: 3 PID: 572 at lib/iov_iter.c:962 iov_iter_pipe+0xe2/0xf0
CPU: 3 PID: 572 Comm: trinity-c45 Not tainted 4.13.0-think+ #5 
task: ffff88042e5f8040 task.stack: ffff880454cb0000
RIP: 0010:iov_iter_pipe+0xe2/0xf0
RSP: 0018:ffff880454cb7950 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880454cb79c0 RCX: ffffffff818fc581
RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffff88043f07fa80
RBP: ffff88043f07f968 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880454cb7468 R11: 0000000000000000 R12: 000000000003fff8
R13: 0000000000000010 R14: ffff88043f07fa80 R15: ffff88043f07fa78
FS:  00007fac217a1700(0000) GS:ffff88046b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000043f37e001 CR4: 00000000001606e0
Call Trace:
 generic_file_splice_read+0x8d/0x340
 ? pipe_unlock+0x15/0x30
 ? splice_from_pipe+0x10e/0x160
 ? pipe_to_user+0x80/0x80
 ? splice_shrink_spd+0x40/0x40
 ? init_wait_entry+0x100/0x100
 ? rw_verify_area+0x87/0x130
 splice_direct_to_actor+0x186/0x420
 ? generic_pipe_buf_nosteal+0x10/0x10
 ? do_splice_to+0xc0/0xc0
 ? __fget_light+0x181/0x200
 do_splice_direct+0x173/0x1e0
 ? splice_direct_to_actor+0x420/0x420
 ? mark_held_locks+0x1c/0x90
 ? retint_kernel+0x10/0x10
 do_sendfile+0x3a2/0x6d0
 ? do_compat_pwritev64+0xa0/0xa0
 ? copy_user_generic_unrolled+0x83/0xb0
 SyS_sendfile64+0xa4/0x130
 ? SyS_sendfile+0x140/0x140
 ? mark_held_locks+0x1c/0x90
 ? do_syscall_64+0xae/0x3e0
 ? SyS_sendfile+0x140/0x140
 do_syscall_64+0x182/0x3e0
 ? syscall_return_slowpath+0x250/0x250
 ? rcu_read_lock_sched_held+0x90/0xa0
 ? __context_tracking_exit.part.5+0x226/0x290
 ? mark_held_locks+0x1c/0x90
 ? return_from_SYSCALL_64+0x2d/0x7a
 ? trace_hardirqs_on_caller+0x17a/0x250
 ? trace_hardirqs_on_thunk+0x1a/0x1c
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fac210cc219
RSP: 002b:00007ffd7fe8ab38 EFLAGS: 00000246
 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000028 RCX: 00007fac210cc219
RDX: 00007fac215de000 RSI: 000000000000001b RDI: 000000000000000b
RBP: 00007ffd7fe8abe0 R08: 00000000c8c8c8c8 R09: 00000000000000c9
R10: 0000000000040000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fac2165f058 R14: 00007fac217a1698 R15: 00007fac2165f000
Code: 10 48 c7 43 08 00 00 00 00 e8 bb 79 b1 ff 4c 89 63 10 48 8d 7b 24 e8 ae 78 b1 ff 89 6b 24 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> ff e9 65 ff ff ff 0f 1f 80 00 00 00 00 41 57 41 56 41 55 49 
---[ end trace 4507dec15e49aca7 ]---


 962         WARN_ON(pipe->nrbufs == pipe->buffers);


 
