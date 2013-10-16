Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E9897F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 16:42:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97929AC001
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 14:42:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	eY59RGPZL1C8Gc5j for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 14:42:33 -0700 (PDT)
Date: Thu, 17 Oct 2013 08:42:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A review of dm-writeboost
Message-ID: <20131016214200.GI4446@dastard>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
	<20131016110146.GH4446@dastard> <525E83E4.9090803@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525E83E4.9090803@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com

On Wed, Oct 16, 2013 at 09:17:40PM +0900, Akira Hayakawa wrote:
> Dave
> 
> > XFS shuts down because you've returned EIO to a log IO. That's a
> > fatal error. If you do the same to an ext4 journal write, it will do
> > the equivalent of shut down (e.g. complain and turn read-only).
> You mean block device should not return -EIO anyway if
> it doesn't want XFS to suddenly shut down?

Yes. EIO means an IO error has occurred. That causes failure paths
to be triggered in the upper layers.

I really don't understand what you are trying to achieve with this
"blockup" thing. If something goes wrong with the device, then you
*cannot recover* by sending EIO to any new IOs and then continuing
on at a later time as though nothing has happened. The moment a
filesystem gets EIO from a metadata write, it is likely to be
corrupted and if you continue onwards after that you simply
propagate the corruption.

> As Mikulas said, connection failure often be the cause of
> I/O error from the underlying devices.

Connection failure is *rarely* the cause of IO errors, except in
environments where SANs are in use. Even then multipathing makes
fatal connection failure a rare occurrence. Broken hardware is a
much more common cause of problems at the storage layers.

> That ext4 and XFS are both determine shutting down in
> erroneous journal writes is also due to the limitation of journal write?
> or just a compromise in implementation? This is just for my curiosity.

A failed, unrecoverable journal write violates the filesystem
consistency model of any journalling filesystem. Operations must be
stopped and the hardware and filesystem must be repaired, otherwise
loss of data will occur.

i.e. You're tellingthe filesystem that it's had a fatal IO error by
returning EIO, and the filesystems are treating it as though they've
seen a fatal IO error.


Simple rule: Don't complete IOs with EIO if you haven't had a fatal
IO error.

>         struct wb_cache *cache = data;
>         struct wb_device *wb = cache->wb;
>         unsigned long intvl;
> 
>         while (!kthread_should_stop()) {
> 
>                 wait_on_blockup();

Ugh. You should be using workqueue with timed work for this.

BTW, you're missing the handling needed by these kernel threads
for suspend-to-disk/ram....

> [   68.825016] XFS (dm-3): Mounting Filesystem
> [   68.847027] XFS (dm-3): Ending clean mount
> [   72.100112] device-mapper: writeboost: err@dm_safe_io_internal() system is blocked up on I/O error. set blockup to 0 after checkup.
> [   72.109702] device-mapper: writeboost: err@migrate_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> [   72.812097] device-mapper: writeboost: err@modulator_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> [   73.894429] Buffer I/O error on device dm-3, logical block 98354
> [   73.895824] lost page write due to I/O error on dm-3

Data IO has been lost due to EIOs. You've corrupted user files when
this error is emitted.

...

> [   73.930022] XFS (dm-3): metadata I/O error: block 0x40 ("xfs_buf_iodone_callbacks") error 5 numblks 16
> [   74.036759] XFS (dm-3): metadata I/O error: block 0x300c7f ("xlog_iodone") error 5 numblks 64
> [   74.043456] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
> [   74.047556] XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
> [   74.049893] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
> [   74.051467] XFS (dm-3): metadata I/O error: block 0x300cbf ("xlog_iodone") error 5 numblks 64
> [   74.053190] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417

And these are all the log buffers containing uncommitted changes
being aborted due to EIO. The filesystem state in memory now doesn't
match the state on disk, and so it's effectively corrupt and shuts
down.

....

> [  100.052005] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:1H:215]
...
> [  100.052005] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
> [  100.052005] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
> [  100.052005] Call Trace:
> [  100.052005]  [<ffffffffa03aa836>] ? xfs_buf_iodone+0x1b/0x49 [xfs]
> [  100.052005]  [<ffffffffa03a99c2>] ? xfs_buf_do_callbacks+0x22/0x30 [xfs]
> [  100.052005]  [<ffffffffa03a9bd2>] ? xfs_buf_iodone_callbacks+0x16b/0x1c4 [xfs]
> [  100.052005]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
> [  100.052005]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
> [  100.052005]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
> [  100.052005]  [<ffffffff81050641>] ? kthread+0x81/0x89
> [  100.052005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
> [  100.052005]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
> [  100.052005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d

You need to compile your kernel with framepointers enabled so we get
reliable stack traces. I think it's stuck on a spinlock in
xfs_buf_iodone, which would imply the AIL lock.

.....

> [  100.244006] CPU: 2 PID: 3167 Comm: xfsaild/dm-3 Tainted: G           O 3.12.0-rc1 #8

FWIW, you should probably be testing the lastest Linus kernel
(3.12-rc5, IIRC) rather than -rc1....

....

> [  100.244006] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
> [  100.244006] Call Trace:
> [  100.244006]  [<ffffffffa0372e3d>] ? xfs_trans_committed_bulk+0x2f/0x19d [xfs]
> [  100.244006]  [<ffffffffa036050e>] ? _xfs_buf_ioapply+0x271/0x29c [xfs]
> [  100.244006]  [<ffffffff81050e94>] ? remove_wait_queue+0xe/0x48
> [  100.244006]  [<ffffffffa03a5b85>] ? xlog_wait+0x62/0x6b [xfs]
> [  100.244006]  [<ffffffff8105bbfb>] ? try_to_wake_up+0x190/0x190
> [  100.244006]  [<ffffffffa03a78e6>] ? xlog_state_get_iclog_space+0x5a/0x1fb [xfs]
> [  100.244006]  [<ffffffff810fa1c3>] ? __cache_free.isra.46+0x178/0x187
> [  100.244006]  [<ffffffffa03a8e0b>] ? xlog_cil_committed+0x2f/0xe6 [xfs]
> [  100.244006]  [<ffffffffa03a926c>] ? xlog_cil_push+0x2f6/0x311 [xfs]
> [  100.244006]  [<ffffffff81058701>] ? mmdrop+0xd/0x1c
> [  100.244006]  [<ffffffffa03a9780>] ? xlog_cil_force_lsn+0x71/0xdd [xfs]
> [  100.244006]  [<ffffffffa03a8162>] ? _xfs_log_force+0x55/0x1a0 [xfs]
> [  100.244006]  [<ffffffffa03a82cc>] ? xfs_log_force+0x1f/0x4e [xfs]
> [  100.244006]  [<ffffffffa03aba15>] ? xfsaild+0x144/0x4cd [xfs]
> [  100.244006]  [<ffffffff810592dc>] ? finish_task_switch+0x7f/0xaa
> [  100.244006]  [<ffffffffa03ab8d1>] ? xfs_trans_ail_cursor_first+0x76/0x76 [xfs]
> [  100.244006]  [<ffffffffa03ab8d1>] ? xfs_trans_ail_cursor_first+0x76/0x76 [xfs]
> [  100.244006]  [<ffffffff81050641>] ? kthread+0x81/0x89
> [  100.244006]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
> [  100.244006]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
> [  100.244006]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d

It's stuck on a spin lock, but I don't know what function it's
in because the stack trace is indeterminate (i.e. need frame
pointers enabled). It might be the AIL lock (as it's the xfsaild),
but I can't tell.

> [  100.436010] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:2:537]
...
> [  100.436010] Workqueue: xfs-reclaim/dm-3 xfs_reclaim_worker [xfs]
> [  100.436010] RIP: 0010:[<ffffffff81081460>]  [<ffffffff81081460>] do_raw_spin_lock+0x13/0x23
> [  100.436010] Call Trace:
> [  100.436010]  [<ffffffffa03ab5f3>] ? xfs_iflush_abort+0x35/0x9a [xfs]
> [  100.436010]  [<ffffffffa03667a3>] ? xfs_reclaim_inode+0x85/0x246 [xfs]
> [  100.436010]  [<ffffffffa0366aab>] ? xfs_reclaim_inodes_ag+0x147/0x1fc [xfs]
> [  100.436010]  [<ffffffff8105bbfb>] ? try_to_wake_up+0x190/0x190
> [  100.436010]  [<ffffffff81056927>] ? __wake_up_common+0x42/0x78
> [  100.436010]  [<ffffffff810d5a18>] ? fold_diff+0x22/0x2e
> [  100.436010]  [<ffffffff810408d8>] ? lock_timer_base.isra.35+0x23/0x48
> [  100.436010]  [<ffffffff81040750>] ? internal_add_timer+0xd/0x28
> [  100.436010]  [<ffffffff8104125b>] ? __mod_timer+0xfa/0x10c
> [  100.436010]  [<ffffffffa0367382>] ? xfs_reclaim_inodes+0x16/0x1b [xfs]
> [  100.436010]  [<ffffffffa036739c>] ? xfs_reclaim_worker+0x15/0x1e [xfs]
> [  100.436010]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
> [  100.436010]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
> [  100.436010]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
> [  100.436010]  [<ffffffff81050641>] ? kthread+0x81/0x89
> [  100.436010]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
> [  100.436010]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
> [  100.436010]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d

Also stuck on a spin lock, but again it is not obvious what function
it is in and hence what spinlock is affected. xfs_iflush_abort()
does take the AIL lock, so that might be it.

> [  100.628005] BUG: soft lockup - CPU#6 stuck for 22s! [script:3151]
> [  100.628005] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
> [  100.628005] Call Trace:
> [  100.628005]  [<ffffffffa03abe25>] ? xfs_ail_push_all+0x13/0x4f [xfs]
> [  100.628005]  [<ffffffffa03673bf>] ? xfs_reclaim_inodes_nr+0x1a/0x34 [xfs]
> [  100.628005]  [<ffffffff8110875e>] ? super_cache_scan+0x121/0x13e
> [  100.628005]  [<ffffffff810cdb7a>] ? shrink_slab+0x1e3/0x2f9
> [  100.628005]  [<ffffffff81119526>] ? iput+0x34/0x13d
> [  100.628005]  [<ffffffff81148d14>] ? do_coredump+0xbc3/0xbc3
> [  100.628005]  [<ffffffff81148e3f>] ? drop_caches_sysctl_handler+0x65/0x76
> [  100.628005]  [<ffffffff81157b7c>] ? proc_sys_call_handler+0x98/0xbf
> [  100.628005]  [<ffffffff81105eca>] ? vfs_write+0x9e/0x104
> [  100.628005]  [<ffffffff811061c1>] ? SyS_write+0x51/0x85
> [  100.628005]  [<ffffffff8137f592>] ? system_call_fastpath+0x16/0x1b

That can only be stuck on the AIL spin lock.

So, I've just audited all the uses of the AIL lock, and I cannot
find an unbalanced user of the AIL lock. If we've leaked the spin
lock, it's not an obvious or easy to trigger bug. Can you turn on
lockdep as well as CONFIG_XFS_DEBUG and see what warnings that
throws?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
