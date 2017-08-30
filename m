Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49955 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdH3RN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 13:13:56 -0400
Date: Wed, 30 Aug 2017 10:13:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170830171343.GT4757@magnolia>
References: <20170412190318.srkkdytf2ebrjzrg@codemonkey.org.uk>
 <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170830170523.a4bysufgifdhtm43@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830170523.a4bysufgifdhtm43@codemonkey.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jones <davej@codemonkey.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 01:05:23PM -0400, Dave Jones wrote:
> On Mon, Aug 28, 2017 at 09:25:42PM -0700, Darrick J. Wong wrote:
>  > On Mon, Aug 28, 2017 at 04:31:30PM -0400, Dave Jones wrote:
>  > > On Mon, Aug 07, 2017 at 04:18:18PM -0400, Dave Jones wrote:
>  > >  > On Fri, Apr 28, 2017 at 06:20:25PM +0100, Al Viro wrote:
>  > >  >  > On Fri, Apr 28, 2017 at 12:50:24PM -0400, Dave Jones wrote:
>  > >  >  > 
>  > >  >  > diff --git a/fs/splice.c b/fs/splice.c
>  > >  >  > index 540c4a44756c..12a12d9c313f 100644
>  > >  >  > --- a/fs/splice.c
>  > >  >  > +++ b/fs/splice.c
>  > >  >  > @@ -306,6 +306,9 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
>  > >  >  >  	kiocb.ki_pos = *ppos;
>  > >  >  >  	ret = call_read_iter(in, &kiocb, &to);
>  > >  >  >  	if (ret > 0) {
>  > >  >  > +		if (WARN_ON(iov_iter_count(&to) != len - ret))
>  > >  >  > +			printk(KERN_ERR "ops %p: was %zd, left %zd, returned %d\n",
>  > >  >  > +				in->f_op, len, iov_iter_count(&to), ret);
>  > >  >  >  		*ppos = kiocb.ki_pos;
>  > >  >  >  		file_accessed(in);
>  > >  >  >  	} else if (ret < 0) {
>  > >  > 
>  > >  > Hey Al,
>  > >  >  Due to a git stash screw up on my part, I've had this leftover WARN_ON
>  > >  > in my tree for the last couple months. (That screw-up might turn out to be
>  > >  > serendipitous if this is a real bug..)
>  > >  > 
>  > >  > Today I decided to change things up and beat up on xfs for a change, and
>  > >  > was able to trigger this again.
>  > >  > 
>  > >  > Is this check no longer valid, or am I triggering the same bug we were chased
>  > >  > down in nfs, but now in xfs ?  (None of the other detritus from that debugging
>  > >  > back in April made it, just those three lines above).
>  > > 
>  > > Revisiting this. I went back and dug out some of the other debug diffs [1]
>  > > from that old thread.
>  > > 
>  > > I can easily trigger this spew on xfs.
>  > > 
>  > > ...
>  > >
>  > > asked to read 4096, claims to have read 1
>  > > actual size of data in pipe 4096 
>  > > [0:4096]
>  > > f_op: ffffffffa058c920, f_flags: 49154, pos: 0/1, size: 0
>  > > 
>  > > 
>  > > I'm still trying to narrow down an exact reproducer, but it seems having
>  > > trinity do a combination of sendfile & writev, with pipes and regular
>  > > files as fd's is the best repro.
>  > > 
>  > > Is this a real problem, or am I chasing ghosts ?  That it doesn't happen
>  > > on ext4 or btrfs is making me wonder...
>  > 
>  > <shrug> I haven't heard of any problems w/ directio xfs lately, but OTOH
>  > I think it's the only filesystem that uses iomap_dio_rw, which would
>  > explain why ext4/btrfs don't have this problem.
>  > 
>  > Granted that's idle speculation; is there a reproducer/xfstest for this?
> 
> I reverted the debug patches mentioned above, and ran trinity for a while again,
> and got this which smells really suspiciously related
> 
> WARNING: CPU: 1 PID: 10380 at fs/iomap.c:993 iomap_dio_rw+0x825/0x840
> CPU: 1 PID: 10380 Comm: trinity-c30 Not tainted 4.13.0-rc7-think+ #3 
> task: ffff8804613a5740 task.stack: ffff880432120000
> RIP: 0010:iomap_dio_rw+0x825/0x840
> RSP: 0018:ffff880432127890 EFLAGS: 00010286
> RAX: 00000000fffffff0 RBX: ffff88046a64d0e8 RCX: 0000000000000000
> RDX: ffffed0086424e9b RSI: 0000000000000000 RDI: ffffed0086424f03
> RBP: ffff880432127a70 R08: ffff88046b239840 R09: 0000000000000001
> R10: ffff880432126f50 R11: 0000000000000000 R12: ffff880432127c40
> R13: 0000000000000e0a R14: 1ffff10086424f20 R15: ffff880432127ca0
> FS:  00007f4cda32f700(0000) GS:ffff88046b200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f181e02f000 CR3: 000000043d32a000 CR4: 00000000001406e0
> Call Trace:
>  ? iomap_seek_data+0xc0/0xc0
>  ? down_read_non_owner+0x40/0x40
>  ? xfs_ilock+0x3f2/0x490 [xfs]
>  ? touch_atime+0x9c/0x180
>  ? __atime_needs_update+0x440/0x440
>  xfs_file_dio_aio_read+0x12d/0x390 [xfs]
>  ? xfs_file_dio_aio_read+0x12d/0x390 [xfs]
>  ? xfs_file_fallocate+0x660/0x660 [xfs]
>  ? cyc2ns_read_end+0x10/0x10
>  xfs_file_read_iter+0x1bb/0x1d0 [xfs]
>  __vfs_read+0x332/0x440
>  ? default_llseek+0x140/0x140
>  ? cyc2ns_read_end+0x10/0x10
>  ? __fget_light+0x1ae/0x230
>  ? rcu_is_watching+0x8d/0xd0
>  ? exit_to_usermode_loop+0x1b0/0x1b0
>  ? rw_verify_area+0x9d/0x150
>  vfs_read+0xc8/0x1c0
>  SyS_pread64+0x11a/0x140
>  ? SyS_write+0x160/0x160
>  ? do_syscall_64+0xc0/0x3e0
>  ? SyS_write+0x160/0x160
>  do_syscall_64+0x1bc/0x3e0
>  ? syscall_return_slowpath+0x240/0x240
>  ? cpumask_check.part.2+0x10/0x10
>  ? cpumask_check.part.2+0x10/0x10
>  ? mark_held_locks+0x23/0xb0
>  ? return_from_SYSCALL_64+0x2d/0x7a
>  ? trace_hardirqs_on_caller+0x182/0x260
>  ? trace_hardirqs_on_thunk+0x1a/0x1c
>  entry_SYSCALL64_slow_path+0x25/0x25
> RIP: 0033:0x7f4cd9c5a219
> RSP: 002b:00007ffce0d90888 EFLAGS: 00000246
>  ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 0000000000000011 RCX: 00007f4cd9c5a219
> RDX: 0000000000000e0a RSI: 00007f4cd7ec5000 RDI: 000000000000000f
> RBP: 00007ffce0d90930 R08: fffffffffffffffd R09: 000000000000001b
> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f4cda256058 R14: 00007f4cda32f698 R15: 00007f4cda256000
> Code: 83 bd 78 08 00 00 00 f 85 8e fd ff ff 4c 89 ef e8 d1 46 fa ff 85 c0 89 c2 0f 89 7c fd ff ff 31 c0 f0 0f b1 53 28 e9 70 fd ff ff <0f> ff e9 82 fc ff ff 48 c7 c1 f4 ff ff ff e9 0d f9 ff ff e8 93 
> ---[ end trace 2f6189daedf1df6e ]---
> 
> 
> 
> That's this..
> 
>  987         ret = filemap_write_and_wait_range(mapping, start, end);
>  988         if (ret)
>  989                 goto out_free_dio;
>  990 
>  991         ret = invalidate_inode_pages2_range(mapping,
>  992                         start >> PAGE_SHIFT, end >> PAGE_SHIFT);
>  993         WARN_ON_ONCE(ret);
> 
> 
> Plot thickens..

Hm, that's the WARN_ON that comes from a failed pagecache invalidation
prior to a dio operation, which implies that something's mixing buffered
and dio?

Given that it's syzkaller it wouldn't surprise me to hear that it's
doing that... :)

--D

> 
> 	Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
