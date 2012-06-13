Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D1Jvhk059849 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 20:19:58 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sEOh0YgZEBGhbPtM for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 18:19:54 -0700 (PDT)
Date: Wed, 13 Jun 2012 11:19:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120613011950.GN22848@dastard>
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD766A7.9030908@xsnews.nl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com

On Tue, Jun 12, 2012 at 05:56:23PM +0200, Matthew Whittaker-Williams wrote:
> On 6/12/12 3:18 AM, Dave Chinner wrote:
> >On Mon, Jun 11, 2012 at 11:37:23PM +0200, Matthew Whittaker-Williams wrote:
> >>[ 6110.300098]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10
> >That's pretty much a meaningless stack trace. Can you recompile your
> >kernel with frame pointers enabled so we can get a reliable stack
> >trace?
> 
> See attached for new trace.

Thatnks, that's much more informative.

> >>Could you have a look into this issue?
> >We know there is a lurking problem that we've been trying to flush
> >out over the past couple of months. Do a search for hangs in
> >xlog_grant_log_space - we've found several problems in
> >the process, but there's still a remaining hang that is likely to be
> >the source of your problems.
> 
> I see, it indeed seems about the same issues we encounter.

With the valid stack traces, I see that it isn't related to the log,
though.

> >>If you need any more information I am happy to provide it.
> >What workload are you running that triggers this?
> 
> About our workload, we are providing usenet with diablo.
> We are currently triggering the issue with running several
> diloadfromspool commands.
> This will scan the entire spool and extracts article location size
> and message-id and placement information.
.....
> But we have also been able to produce the same trigger with running
> multiple bonnie++ commands.
.....
> It gets triggered when filesystem gets generally alot of reads.

And that is what makes it different to the other hangs we've been
seeing.

> Filesystem info:

Looks like a standard 41TB filesystem layout.

> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
> Size                : 40.014 TB
> State               : Optimal
> Strip Size          : 64 KB
> Number Of Drives    : 24
.....
> Virtual Drive: 1 (Target Id: 1)
> Name                :
> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
> Size                : 40.014 TB
> State               : Optimal
> Strip Size          : 1.0 MB
> Number Of Drives    : 24

OOC, any reason for the different stripe sizes on the two
RAID volumes?

It does, however, point to your problem - you have 24 disk RAID6
volumes and you are reading and writing lots of small files on them.
Every small random file write is going to cause a RMW cycle in the
RAID6 volume (i.e. across all 24 disks), so it is going to be *very*
slow when the BBWC can't hide that latency.

That, in turn, is going to make reads very slow as the are going to
get queued up behind those RMW cycles as the BBWC flushes all those
small writes it has buffered.

what does the output of a coupl eof minutes of 'iostat -d -x -m 5'
look like when this problem is occurring?

>  imklog 4.6.4, log source = /proc/kmsg started.
>  [  323.966564] XFS (sdb): Mounting Filesystem
>  [  324.183373] XFS (sdb): Ending clean mount
>  Kernel logging (proc) stopped.
>  imklog 4.6.4, log source = /proc/kmsg started.
>  [ 1200.374551] INFO: task kworker/0:2:1115 blocked for more than 120 seconds.
>  [ 1200.374628] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  [ 1200.374722] kworker/0:2     D ffff8805ebdd3fa8     0  1115      2 0x00000000
>  [ 1200.374860]  ffff880602ae7bf0 0000000000000046 ffffffff814cecd0 ffff880603c56840
>  [ 1200.375098]  0000000000000400 ffff880602ae6010 0000000000013340 0000000000013340
>  [ 1200.375336]  ffff880602ae7fd8 0000000000013340 ffff880602ae7fd8 0000000000013340
>  [ 1200.375573] Call Trace:
>  [ 1200.375641]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>  [ 1200.375709]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
>  [ 1200.375775]  [<ffffffff8137d912>] __down_common+0x96/0xe4
>  [ 1200.375858]  [<ffffffffa034338c>] ? xfs_getsb+0x32/0x60 [xfs]
>  [ 1200.375928]  [<ffffffff8137d9bf>] __down+0x18/0x1a
>  [ 1200.375996]  [<ffffffff81060428>] down+0x28/0x38
>  [ 1200.376071]  [<ffffffffa02f4786>] xfs_buf_lock+0x6f/0xc0 [xfs]
>  [ 1200.376155]  [<ffffffffa034338c>] xfs_getsb+0x32/0x60 [xfs]
>  [ 1200.376235]  [<ffffffffa035065c>] xfs_trans_getsb+0xb3/0x107 [xfs]
>  [ 1200.376319]  [<ffffffffa0343da5>] xfs_mod_sb+0x41/0x112 [xfs]
>  [ 1200.376401]  [<ffffffffa0303bac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
>  [ 1200.376482]  [<ffffffffa02f9434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
>  [ 1200.382394]  [<ffffffffa034a656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
>  [ 1200.382534]  [<ffffffffa0303bea>] xfs_sync_worker+0x3e/0x64 [xfs]
>  [ 1200.382607]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
>  [ 1200.382741]  [<ffffffff8105531e>] worker_thread+0x13e/0x264

That is blocked trying to read the superblock, which means it is
probably locked for writeback. i.e. it's sitting in an IO queue
somewhere. The xfs_sync_worker is not blocked on log space which
means this is not the same as the problem I mentioned previously.


> [ 1201.674223] bonnie++        D ffff8805bc4f02e8     0  6337      1 0x00000000
> [ 1201.674370]  ffff88059b5f59b8 0000000000000086 ffff880601a53bb8 0000000000000286
> [ 1201.674607]  ffff88059b5f5968 ffff88059b5f4010 0000000000013340 0000000000013340
> [ 1201.674844]  ffff88059b5f5fd8 0000000000013340 ffff88059b5f5fd8 0000000000013340
> [ 1201.675081] Call Trace:
> [ 1201.675142]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
> [ 1201.675212]  [<ffffffff8137e2af>] schedule+0x5f/0x61
> [ 1201.675280]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
> [ 1201.675350]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
> [ 1201.675420]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
> [ 1201.675491]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
> [ 1201.675561]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
> [ 1201.675633]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
> [ 1201.675723]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
> [ 1201.675858]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
> [ 1201.675939]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
> [ 1201.676039]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
> [ 1201.676117]  [<ffffffffa02f8002>] ? xfs_file_aio_write+0xb/0x1b0 [xfs]
> [ 1201.676188]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
> [ 1201.676257]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
> [ 1201.676327]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
> [ 1201.676394]  [<ffffffff81111292>] sys_write+0x45/0x6c
> [ 1201.676461]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b

All the bonnie++ processes are waiting for write IO to complete so
they can dirty more pages (i.e. write more in to the page cache).

>  [ 1201.700104] flush-8:0       D ffff8805bcaf5aa8     0  6346      2 0x00000000
>  [ 1201.700250]  ffff88059d78f710 0000000000000046 ffff88059d78f700 ffff88059d78f6e0
>  [ 1201.700487]  ffff8805eaef8000 ffff88059d78e010 0000000000013340 0000000000013340
>  [ 1201.700724]  ffff88059d78ffd8 0000000000013340 ffff88059d78ffd8 0000000000013340
>  [ 1201.700961] Call Trace:
>  [ 1201.701022]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>  [ 1201.701090]  [<ffffffff8137e338>] io_schedule+0x87/0xca
>  [ 1201.701159]  [<ffffffff811aca59>] get_request_wait+0x116/0x1b9
>  [ 1201.701229]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
>  [ 1201.701298]  [<ffffffff811a70d2>] ? elv_merge+0xae/0xbe
>  [ 1201.701367]  [<ffffffff811acf8f>] blk_queue_bio+0x1a8/0x30d
>  [ 1201.701436]  [<ffffffff811ac2e5>] generic_make_request+0x99/0xdc
>  [ 1201.701507]  [<ffffffff811ac407>] submit_bio+0xdf/0xfe
>  [ 1201.701580]  [<ffffffffa02f1c3d>] xfs_submit_ioend_bio+0x2e/0x30 [xfs]
>  [ 1201.701658]  [<ffffffffa02f236e>] xfs_submit_ioend+0xa1/0xea [xfs]
>  [ 1201.701736]  [<ffffffffa02f353f>] xfs_vm_writepage+0x40f/0x484 [xfs]
>  [ 1201.701808]  [<ffffffff811c761c>] ? rb_insert_color+0xbc/0xe5
>  [ 1201.701878]  [<ffffffff810d558a>] __writepage+0x12/0x2b
>  [ 1201.701946]  [<ffffffff810d6a0d>] write_cache_pages+0x25f/0x36a
>  [ 1201.702017]  [<ffffffff810d5578>] ? set_page_dirty+0x62/0x62
>  [ 1201.702087]  [<ffffffff810d6b58>] generic_writepages+0x40/0x57
>  [ 1201.702162]  [<ffffffffa02f1a30>] xfs_vm_writepages+0x48/0x4f [xfs]
>  [ 1201.702234]  [<ffffffff810d6b8b>] do_writepages+0x1c/0x25
>  [ 1201.702304]  [<ffffffff81130a04>] writeback_single_inode+0x183/0x370
>  [ 1201.702376]  [<ffffffff81130eaa>] writeback_sb_inodes+0x172/0x20b
>  [ 1201.702447]  [<ffffffff81130fb6>] __writeback_inodes_wb+0x73/0xb4
>  [ 1201.702518]  [<ffffffff8113162b>] wb_writeback+0x136/0x22c
>  [ 1201.702587]  [<ffffffff810d61c1>] ? global_dirty_limits+0x2a/0x10a
>  [ 1201.702659]  [<ffffffff811317b1>] wb_do_writeback+0x90/0x1de
>  [ 1201.702729]  [<ffffffff811319bf>] bdi_writeback_thread+0xc0/0x1e5
>  [ 1201.702800]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
>  [ 1201.702871]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
>  [ 1201.702941]  [<ffffffff8105bb50>] kthread+0x84/0x8c
>  [ 1201.703009]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
>  [ 1201.703079]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
>  [ 1201.703152]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13

And writeback is stalled waiting for IO to complete as well (hence
the bonnie++ processes being blocked). IN this case, the IO request
queue is full, which indicates it is waiting on the disk subsystem
to complete IO requests....

>  [ 1559.653179] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  [ 1559.653269] sync            D ffff8805ec48b8e8     0  7493   7169 0x00000000
>  [ 1559.653417]  ffff880208869cf8 0000000000000086 ffff8805bc02ae78 00000000000000c9
>  [ 1559.653655]  ffff880208869ce8 ffff880208868010 0000000000013340 0000000000013340
>  [ 1559.653892]  ffff880208869fd8 0000000000013340 ffff880208869fd8 0000000000013340
>  [ 1559.654129] Call Trace:
>  [ 1559.654197]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>  [ 1559.654265]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
>  [ 1559.654337]  [<ffffffff8106b47b>] ? wake_affine+0x190/0x248
>  [ 1559.660092]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
>  [ 1559.660163]  [<ffffffff8137e136>] wait_for_common+0xcc/0x14a
>  [ 1559.660235]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
>  [ 1559.660307]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
>  [ 1559.660382]  [<ffffffff811348f7>] ? __sync_filesystem+0x7a/0x7a
>  [ 1559.660452]  [<ffffffff8137e24e>] wait_for_completion+0x18/0x1a
>  [ 1559.660524]  [<ffffffff81131203>] writeback_inodes_sb_nr+0x78/0x7f
>  [ 1559.660596]  [<ffffffff811312b0>] writeback_inodes_sb+0x4e/0x59
>  [ 1559.660667]  [<ffffffff811348ce>] __sync_filesystem+0x51/0x7a
>  [ 1559.660738]  [<ffffffff81134908>] sync_one_sb+0x11/0x13
>  [ 1559.660827]  [<ffffffff81112aae>] iterate_supers+0x69/0xbb
>  [ 1559.660898]  [<ffffffff81134939>] sys_sync+0x2f/0x5c
>  [ 1559.661052]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b

And that is sync waiting for the flusher thread to complete
writeback of all the dirty inodes. The lack of other stall messages
at this time makes it pretty clear that the problem is not
filesystem related - the system is simply writeback IO bound.

The reason, I'd suggest, is that you've chosen the wrong RAID volume
type for your workload. Small random file read and write workloads
like news and mail spoolers are IOPS intensive workloads and do
not play well with RAID5/6. RAID5/6 really only work well for large
files with sequential access patterns - you need to use RAID1/10 for
IOPS intensive workloads because they don't suffer from the RMW
cycle problem that RAID5/6 has for small writes. The iostat output
will help clarify whether this is really the problem or not...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
