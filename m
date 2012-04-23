Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NC9tN9178526 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 07:09:55 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id SFxPlw1GLR8UYs9R
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Apr 2012 05:09:53 -0700 (PDT)
Received: by dadz9 with SMTP id z9so17579246dad.5
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 05:09:53 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 14:09:53 +0200
Message-ID: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
Subject: Still seeing hangs in xlog_grant_log_space
From: Juerg Haefliger <juergh@gmail.com>
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
To: xfs@oss.sgi.com

Hi,

I have a test system that I'm using to try to force an XFS filesystem
hang since we're encountering that problem sporadically in production
running a 2.6.38-8 Natty kernel. The original idea was to use this
system to find the patches that fix the issue but I've tried a whole
bunch of kernels and they all hang eventually (anywhere from 5 to 45
mins) with the stack trace shown below. Only an emergency flush will
bring the filesystem back. I tried kernels 3.0.29, 3.1.10, 3.2.15,
3.3.2. From reading through the mail archives, I get the impression
that this should be fixed in 3.1.

What makes the test system special is:
1) The test partition uses 1024 block size and 576b log size.
2) The RAID controller cache is disabled.

I can't seem to hit the problem without the above modifications.

For the IO workload I pre-create 8000 files with random content and
sizes between 1k and 128k on the test partition. Then I run a tool
that spawns a bunch of threads which just copy these files to a
different directory on the same partition. At the same time there are
other threads that rename, remove and overwrite random files in the
destination directory keeping the file count at around 500.

Let me know what other information I can provide to pin this down.

Thanks
...Juerg


haefligerj@use0453rtk:/xfs-hang$ xfs_info /xfs-hang/
meta-data=/dev/mapper/vg00-tmp   isize=256    agcount=4, agsize=2441216 blks
         =                       sectsz=512   attr=2
data     =                       bsize=1024   blocks=9764864, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=1024   blocks=576, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

haefligerj@use0453rtk:/xfs-hang$ mount | grep xfs-hang
/dev/mapper/vg00-tmp on /xfs-hang type xfs (rw)

Apr 23 11:25:45 use0453rtk kernel: [  719.663591] INFO: task
kworker/6:2:367 blocked for more than 120 seconds.
Apr 23 11:25:45 use0453rtk kernel: [  719.663601] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 23 11:25:45 use0453rtk kernel: [  719.663609] kworker/6:2     D
ffffffff818080c0     0   367      2 0x00000000
Apr 23 11:25:45 use0453rtk kernel: [  719.663616]  ffff8817ffddfc30
0000000000000046 0000000000000000 0000000000000000
Apr 23 11:25:45 use0453rtk kernel: [  719.663622]  ffff8817ffdde000
ffff8817ffdde000 ffff880c03304100 ffff8818003fc040
Apr 23 11:25:45 use0453rtk kernel: [  719.663627]  ffff8817ffddfc20
ffff880bffc94c00 ffff8818002f7aa8 0000000000000ab4
Apr 23 11:25:45 use0453rtk kernel: [  719.663633] Call Trace:
Apr 23 11:25:45 use0453rtk kernel: [  719.663644]
[<ffffffff8164a4bf>] schedule+0x3f/0x60
Apr 23 11:25:45 use0453rtk kernel: [  719.663671]
[<ffffffffa00edf63>] xlog_reserveq_wait+0x103/0x270 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663679]
[<ffffffff81085300>] ? try_to_wake_up+0x2b0/0x2b0
Apr 23 11:25:45 use0453rtk kernel: [  719.663693]
[<ffffffffa00ee367>] xlog_grant_log_space+0x157/0x200 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663708]
[<ffffffffa00f0cbb>] xfs_log_reserve+0x14b/0x1c0 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663722]
[<ffffffffa00eba4c>] xfs_trans_reserve+0x9c/0x200 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663735]
[<ffffffffa00a7e90>] ? xfs_reclaim_inode_grab+0x90/0x90 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663748]
[<ffffffffa00a7e90>] ? xfs_reclaim_inode_grab+0x90/0x90 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663760]
[<ffffffffa009d363>] xfs_fs_log_dummy+0x43/0x90 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663773]
[<ffffffffa00a7f0c>] xfs_sync_worker+0x7c/0x80 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663778]
[<ffffffff810704ab>] process_one_work+0x11b/0x4a0
Apr 23 11:25:45 use0453rtk kernel: [  719.663783]
[<ffffffff81070be9>] worker_thread+0x169/0x350
Apr 23 11:25:45 use0453rtk kernel: [  719.663787]
[<ffffffff81070a80>] ? rescuer_thread+0x210/0x210
Apr 23 11:25:45 use0453rtk kernel: [  719.663792]
[<ffffffff810755ae>] kthread+0x9e/0xb0
Apr 23 11:25:45 use0453rtk kernel: [  719.663799]
[<ffffffff816540e4>] kernel_thread_helper+0x4/0x10
Apr 23 11:25:45 use0453rtk kernel: [  719.663804]
[<ffffffff81075510>] ? flush_kthread_worker+0xc0/0xc0
Apr 23 11:25:45 use0453rtk kernel: [  719.663808]
[<ffffffff816540e0>] ? gs_change+0x13/0x13
Apr 23 11:25:45 use0453rtk kernel: [  719.663822] INFO: task
flush-252:2:5916 blocked for more than 120 seconds.
Apr 23 11:25:45 use0453rtk kernel: [  719.663828] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 23 11:25:45 use0453rtk kernel: [  719.663836] flush-252:2     D
ffffffff818080c0     0  5916      2 0x00000000
Apr 23 11:25:45 use0453rtk kernel: [  719.663841]  ffff880c0135f650
0000000000000046 ffff880c0135f600 ffffffff8164b571
Apr 23 11:25:45 use0453rtk kernel: [  719.663846]  ffff880c0135e000
ffff880c0135e000 ffff880c03308870 ffff880c0087e870
Apr 23 11:25:45 use0453rtk kernel: [  719.663851]  ffff880c0135f640
ffff880bffc94c00 ffff881800a5c4a8 00000000000163f0
Apr 23 11:25:45 use0453rtk kernel: [  719.663857] Call Trace:
Apr 23 11:25:45 use0453rtk kernel: [  719.663861]
[<ffffffff8164b571>] ? _raw_spin_unlock_irq+0x21/0x50
Apr 23 11:25:45 use0453rtk kernel: [  719.663866]
[<ffffffff8164a4bf>] schedule+0x3f/0x60
Apr 23 11:25:45 use0453rtk kernel: [  719.663880]
[<ffffffffa00edf63>] xlog_reserveq_wait+0x103/0x270 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663884]
[<ffffffff81085300>] ? try_to_wake_up+0x2b0/0x2b0
Apr 23 11:25:45 use0453rtk kernel: [  719.663898]
[<ffffffffa00ee367>] xlog_grant_log_space+0x157/0x200 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663912]
[<ffffffffa00f0cbb>] xfs_log_reserve+0x14b/0x1c0 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663926]
[<ffffffffa00eba4c>] xfs_trans_reserve+0x9c/0x200 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663940]
[<ffffffffa00eb8c1>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663953]
[<ffffffffa00a1bd6>] xfs_iomap_write_allocate+0x1d6/0x370 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663960]
[<ffffffff812e7307>] ? generic_make_request+0xc7/0x100
Apr 23 11:25:45 use0453rtk kernel: [  719.663964]
[<ffffffff812e73c7>] ? submit_bio+0x87/0x110
Apr 23 11:25:45 use0453rtk kernel: [  719.663974]
[<ffffffffa0094559>] xfs_map_blocks+0x269/0x2b0 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663985]
[<ffffffffa009473f>] xfs_vm_writepage+0x19f/0x540 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.663994]
[<ffffffff81117d07>] __writepage+0x17/0x40
Apr 23 11:25:45 use0453rtk kernel: [  719.663998]
[<ffffffff81118468>] write_cache_pages+0x228/0x4f0
Apr 23 11:25:45 use0453rtk kernel: [  719.664003]
[<ffffffff81117cf0>] ? set_page_dirty+0x70/0x70
Apr 23 11:25:45 use0453rtk kernel: [  719.664008]
[<ffffffff8111877a>] generic_writepages+0x4a/0x70
Apr 23 11:25:45 use0453rtk kernel: [  719.664018]
[<ffffffffa00932bc>] xfs_vm_writepages+0x5c/0x80 [xfs]
Apr 23 11:25:45 use0453rtk kernel: [  719.664023]
[<ffffffff8111a201>] do_writepages+0x21/0x40
Apr 23 11:25:45 use0453rtk kernel: [  719.664029]
[<ffffffff811981a5>] writeback_single_inode+0x185/0x470
Apr 23 11:25:45 use0453rtk kernel: [  719.664034]
[<ffffffff8119888d>] writeback_sb_inodes+0x19d/0x270
Apr 23 11:25:45 use0453rtk kernel: [  719.664039]
[<ffffffff811989f6>] __writeback_inodes_wb+0x96/0xc0
Apr 23 11:25:45 use0453rtk kernel: [  719.664043]
[<ffffffff81198d33>] wb_writeback+0x313/0x340
Apr 23 11:25:45 use0453rtk kernel: [  719.664048]
[<ffffffff81188ae2>] ? get_nr_inodes+0x52/0x70
Apr 23 11:25:45 use0453rtk kernel: [  719.664053]
[<ffffffff811992f7>] wb_do_writeback+0x257/0x260
Apr 23 11:25:45 use0453rtk kernel: [  719.664058]
[<ffffffff81062e0a>] ? del_timer_sync+0x3a/0x60
Apr 23 11:25:45 use0453rtk kernel: [  719.664063]
[<ffffffff8119938c>] bdi_writeback_thread+0x8c/0x2c0
Apr 23 11:25:45 use0453rtk kernel: [  719.664067]
[<ffffffff81199300>] ? wb_do_writeback+0x260/0x260
Apr 23 11:25:45 use0453rtk kernel: [  719.664071]
[<ffffffff810755ae>] kthread+0x9e/0xb0
Apr 23 11:25:45 use0453rtk kernel: [  719.664076]
[<ffffffff816540e4>] kernel_thread_helper+0x4/0x10
Apr 23 11:25:45 use0453rtk kernel: [  719.664080]
[<ffffffff81075510>] ? flush_kthread_worker+0xc0/0xc0
Apr 23 11:25:45 use0453rtk kernel: [  719.664084]
[<ffffffff816540e0>] ? gs_change+0x13/0x13

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
