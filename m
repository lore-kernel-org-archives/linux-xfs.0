Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMJOfY5096078 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 13:24:41 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAD1719AC2E
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 11:26:16 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id fABJdYhUGyIXFN6P for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 11:26:16 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUKIXWXE9CLGY2QD@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Mon, 22 Nov 2010 20:25:08 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUKIXWT4QOLGY2QC@mx.isti.cnr.it> for xfs@oss.sgi.com; Mon,
	22 Nov 2010 20:25:08 +0100 (MET)
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
	by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUKIXWNYRWLI95RA@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Mon, 22 Nov 2010 20:25:08 +0100 (MET)
Date: Mon, 22 Nov 2010 20:27:14 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Xfs delaylog hanged up
Message-id: <4CEAC412.9000406@shiftmail.org>
MIME-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi there
EXCELLENT speed improvement with delaylog! My congratulations.
Now there's a problem: it hanged on me (not sure it was because of 
delaylog, but anyway...)
I am on 2.6.37rc2

16 disk MD raid-5
mkfs line
        mkfs.xfs -l size=128m -d agcount=16 <device>
(then lvm2, all aligned to stripes)
mount line:
        /dev/mapper/perftestvg-xfslv /perftest/xfs xfs 
rw,relatime,attr2,delaylog,nobarrier,inode64,logbufs=8,logbsize=256k,noquota 
0 0

deadline scheduler, nr_requests 1024

I was doing a parallel-kernel-unpack benchmark:

     /perftest/xfs# mkdir dir{1,2,3,4,5,6,7,8,9,10}
     /perftest/xfs# for i in {1..10} ; do time tar -jxf 
linux-2.6.37-rc2.tar.bz2 -C dir$i & done ; echo waiting now ; time wait; 
echo syncing now ; time sync

     [1] 3400
     [2] 3401
     [3] 3402
     [4] 3404
     [5] 3407
     [6] 3409
     [7] 3410
     [8] 3413
     [9] 3415
     [10] 3417
     waiting now

     [unfortunately I hit ctrl-C here by mistake after a while and it 
might have unlocked the situation]
     [These are the final times for tars: 6 minutes, while it usually 
takes about 1min20sec]

     real    6m34.883s
     user    0m19.770s
     sys     0m5.610s

     real    6m45.220s
     user    0m20.600s
     sys     0m5.750s

     real    6m46.638s
     user    0m20.920s
     sys     0m5.800s

     real    6m46.731s
     user    0m20.640s
     sys     0m5.840s

     real    6m46.743s
     user    0m20.860s
     sys     0m5.950s

     real    6m46.857s
     user    0m20.330s
     sys     0m6.000s

     real    6m47.885s
     user    0m21.000s
     sys     0m6.010s

     real    6m48.718s
     user    0m20.780s
     sys     0m5.700s

     real    6m51.915s
     user    0m19.530s
     sys     0m4.680s

     real    7m0.249s
     user    0m20.330s
     sys     0m6.290s



     Iostat showed everything totally still.
     Computer was responsive for the rest (OS is on other filesystems)
     Look at the stack traces in the 5 minutes they were hanged:

# ps aux | grep tar
     root       875  0.0  0.0  12688   556 ?        S    16:47   0:00 
upstart-udev-bridge --daemon
     root      3403  1.9  0.0  18224  1168 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir1
     root      3405  1.8  0.0  18224  1168 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir2
     root      3406  0.9  0.0  18224  1164 pts/1    D    18:58   0:02 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir3
     root      3408  1.7  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir4
     root      3411  1.8  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir5
     root      3412  1.6  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir6
     root      3414  1.7  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir7
     root      3416  1.8  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir8
     root      3418  1.8  0.0  18224  1168 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir9
     root      3419  1.7  0.0  18224  1164 pts/1    D    18:58   0:04 
tar -jxf linux-2.6.37-rc2.tar.bz2 -C dir10
# cat /proc/3403/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
     [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
     [<ffffffff8114de68>] notify_change+0x168/0x2d0
     [<ffffffff811346e7>] sys_fchmodat+0xd7/0x110
     [<ffffffff81134733>] sys_chmod+0x13/0x20
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3405/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
     [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
     [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
     [<ffffffff81137405>] fput+0xd5/0x280
     [<ffffffff81133bf8>] filp_close+0x58/0x90
     [<ffffffff81133ce9>] sys_close+0xb9/0x110
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3406/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02c05ed>] xfs_iomap_write_allocate+0x21d/0x360 [xfs]
     [<ffffffffa02c09bf>] xfs_iomap+0x28f/0x340 [xfs]
     [<ffffffffa02da287>] xfs_map_blocks+0x37/0x40 [xfs]
     [<ffffffffa02dbae0>] xfs_vm_writepage+0x3f0/0x5d0 [xfs]
     [<ffffffff810f00d2>] __writepage+0x12/0x40
     [<ffffffff810f1198>] write_cache_pages+0x1f8/0x490
     [<ffffffff810f144f>] generic_writepages+0x1f/0x30
     [<ffffffffa02da8a8>] xfs_vm_writepages+0x58/0x70 [xfs]
     [<ffffffff810f147c>] do_writepages+0x1c/0x40
     [<ffffffff81158ddd>] writeback_single_inode+0x9d/0x260
     [<ffffffff811591e4>] writeback_sb_inodes+0xd4/0x170
     [<ffffffff81159324>] writeback_inodes_wb+0xa4/0x170
     [<ffffffff810f0a60>] balance_dirty_pages_ratelimited_nr+0x390/0x4a0
     [<ffffffff810e71b3>] generic_file_buffered_write+0x1b3/0x250
     [<ffffffffa02e09b8>] xfs_file_aio_write+0x7b8/0xa60 [xfs]
     [<ffffffff81135582>] do_sync_write+0xd2/0x110
     [<ffffffff81135878>] vfs_write+0xc8/0x190
     [<ffffffff811361ac>] sys_write+0x4c/0x80
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3408/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d666b>] xfs_create+0x17b/0x650 [xfs]
     [<ffffffffa02e3868>] xfs_vn_mknod+0xa8/0x1c0 [xfs]
     [<ffffffffa02e399b>] xfs_vn_create+0xb/0x10 [xfs]
     [<ffffffff81140f97>] vfs_create+0xa7/0xd0
     [<ffffffff811420e8>] do_last+0x658/0x720
     [<ffffffff8114414b>] do_filp_open+0x1fb/0x650
     [<ffffffff81133da3>] do_sys_open+0x63/0x120
     [<ffffffff81133e8b>] sys_open+0x1b/0x20
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3411/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
     [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
     [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
     [<ffffffff81137405>] fput+0xd5/0x280
     [<ffffffff81133bf8>] filp_close+0x58/0x90
     [<ffffffff81133ce9>] sys_close+0xb9/0x110
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3412/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d666b>] xfs_create+0x17b/0x650 [xfs]
     [<ffffffffa02e3868>] xfs_vn_mknod+0xa8/0x1c0 [xfs]
     [<ffffffffa02e399b>] xfs_vn_create+0xb/0x10 [xfs]
     [<ffffffff81140f97>] vfs_create+0xa7/0xd0
     [<ffffffff811420e8>] do_last+0x658/0x720
     [<ffffffff8114414b>] do_filp_open+0x1fb/0x650
     [<ffffffff81133da3>] do_sys_open+0x63/0x120
     [<ffffffff81133e8b>] sys_open+0x1b/0x20
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3414/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
     [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
     [<ffffffff8114de68>] notify_change+0x168/0x2d0
     [<ffffffff8115dc57>] utimes_common+0xd7/0x1b0
     [<ffffffff8115ddc0>] do_utimes+0x90/0xf0
     [<ffffffff8115dece>] sys_utimensat+0x2e/0x80
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3416/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
     [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
     [<ffffffff8114de68>] notify_change+0x168/0x2d0
     [<ffffffff811346e7>] sys_fchmodat+0xd7/0x110
     [<ffffffff81134733>] sys_chmod+0x13/0x20
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3418/stack
     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
     [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
     [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
     [<ffffffff81137405>] fput+0xd5/0x280
     [<ffffffff81133bf8>] filp_close+0x58/0x90
     [<ffffffff81133ce9>] sys_close+0xb9/0x110
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/3419/stack
     [<ffffffffa02c6195>] xlog_grant_log_space+0x2b5/0x5e0 [xfs]
     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
     [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
     [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
     [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
     [<ffffffff81137405>] fput+0xd5/0x280
     [<ffffffff81133bf8>] filp_close+0x58/0x90
     [<ffffffff81133ce9>] sys_close+0xb9/0x110
     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff



dmesg:
[ 8042.770130] xfsaild/dm-6  D 00000001000b92b8     0  2979      2 
0x00000000
[ 8042.770135]  ffff88082c11ba90 0000000000000046 ffff88083140de08 
0000000000000000
[ 8042.770140]  00000000000138c0 ffff88083dfa5a80 ffff88083dfa5e18 
ffff88082c11bfd8
[ 8042.770144]  ffff88083dfa5e20 00000000000138c0 ffff88082c11a010 
00000000000138c0
[ 8042.770148] Call Trace:
[ 8042.770187]  [<ffffffffa02c4a8f>] 
xlog_state_get_iclog_space+0xdf/0x2c0 [xfs]
[ 8042.770205]  [<ffffffffa02c422a>] ? xlog_sync+0x1fa/0x3d0 [xfs]
[ 8042.770213]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.770231]  [<ffffffffa02c5708>] xlog_write+0x198/0x6c0 [xfs]
[ 8042.770249]  [<ffffffffa02c6fd2>] xlog_cil_push+0x252/0x3b0 [xfs]
[ 8042.770267]  [<ffffffffa02c7636>] xlog_cil_force_lsn+0x116/0x120 [xfs]
[ 8042.770286]  [<ffffffffa02dd3dc>] ? xfs_buf_delwri_queue+0xcc/0x150 [xfs]
[ 8042.770291]  [<ffffffff81033209>] ? default_spin_lock_flags+0x9/0x10
[ 8042.770296]  [<ffffffff810808d2>] ? down_trylock+0x32/0x50
[ 8042.770314]  [<ffffffffa02c4543>] _xfs_log_force+0x63/0x230 [xfs]
[ 8042.770332]  [<ffffffffa02c4933>] xfs_log_force+0x13/0x40 [xfs]
[ 8042.770351]  [<ffffffffa02d38e4>] xfsaild_push+0x3b4/0x400 [xfs]
[ 8042.770357]  [<ffffffff81571c26>] ? schedule_timeout+0x196/0x2f0
[ 8042.770377]  [<ffffffffa02e67a4>] xfsaild+0x74/0xb0 [xfs]
[ 8042.770395]  [<ffffffffa02e6730>] ? xfsaild+0x0/0xb0 [xfs]
[ 8042.770400]  [<ffffffff8107b076>] kthread+0x96/0xa0
[ 8042.770404]  [<ffffffff8100bd64>] kernel_thread_helper+0x4/0x10
[ 8042.770408]  [<ffffffff8107afe0>] ? kthread+0x0/0xa0
[ 8042.770411]  [<ffffffff8100bd60>] ? kernel_thread_helper+0x0/0x10
[ 8042.770414] INFO: task xfssyncd/dm-6:2980 blocked for more than 120 
seconds.
[ 8042.770449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.770501] xfssyncd/dm-6 D ffff88083dfa0000     0  2980      2 
0x00000000
[ 8042.770505]  ffff88015d98fcf0 0000000000000046 ffff88015d98fc80 
ffffffffa02cdb39
[ 8042.770510]  00000000000138c0 ffff88083dfa0000 ffff88083dfa0398 
ffff88015d98ffd8
[ 8042.770514]  ffff88083dfa03a0 00000000000138c0 ffff88015d98e010 
00000000000138c0
[ 8042.770518] Call Trace:
[ 8042.770537]  [<ffffffffa02cdb39>] ? xfs_perag_get_tag+0x39/0xc0 [xfs]
[ 8042.770555]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.770574]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.770578]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.770595]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.770614]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.770631]  [<ffffffffa02b5ac9>] xfs_fs_log_dummy+0x49/0xb0 [xfs]
[ 8042.770649]  [<ffffffffa02c3c46>] ? xfs_log_need_covered+0x66/0xd0 [xfs]
[ 8042.770668]  [<ffffffffa02e82e3>] xfs_sync_worker+0x83/0x90 [xfs]
[ 8042.770686]  [<ffffffffa02e70b3>] xfssyncd+0x183/0x230 [xfs]
[ 8042.770705]  [<ffffffffa02e6f30>] ? xfssyncd+0x0/0x230 [xfs]
[ 8042.770709]  [<ffffffff8107b076>] kthread+0x96/0xa0
[ 8042.770712]  [<ffffffff8100bd64>] kernel_thread_helper+0x4/0x10
[ 8042.770715]  [<ffffffff8107afe0>] ? kthread+0x0/0xa0
[ 8042.770718]  [<ffffffff8100bd60>] ? kernel_thread_helper+0x0/0x10
[ 8042.770721] INFO: task flush-252:6:3320 blocked for more than 120 
seconds.
[ 8042.770756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.770808] flush-252:6   D 00000001000b92b0     0  3320      2 
0x00000000
[ 8042.770812]  ffff8808329776b0 0000000000000046 0000000000000286 
ffff880800000000
[ 8042.770817]  00000000000138c0 ffff88083dbe96a0 ffff88083dbe9a38 
ffff880832977fd8
[ 8042.770821]  ffff88083dbe9a40 00000000000138c0 ffff880832976010 
00000000000138c0
[ 8042.770825] Call Trace:
[ 8042.770843]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.770861]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.770865]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.770883]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.770901]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.770920]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.770937]  [<ffffffffa02c05ed>] 
xfs_iomap_write_allocate+0x21d/0x360 [xfs]
[ 8042.770957]  [<ffffffffa02d31f1>] ? xfs_trans_unlocked_item+0x31/0x50 
[xfs]
[ 8042.770974]  [<ffffffffa02c09bf>] xfs_iomap+0x28f/0x340 [xfs]
[ 8042.770992]  [<ffffffffa02da287>] xfs_map_blocks+0x37/0x40 [xfs]
[ 8042.771011]  [<ffffffffa02dbae0>] xfs_vm_writepage+0x3f0/0x5d0 [xfs]
[ 8042.771017]  [<ffffffff810f00d2>] __writepage+0x12/0x40
[ 8042.771020]  [<ffffffff810f1198>] write_cache_pages+0x1f8/0x490
[ 8042.771024]  [<ffffffff810f00c0>] ? __writepage+0x0/0x40
[ 8042.771027]  [<ffffffff8157130c>] ? schedule+0x44c/0xa80
[ 8042.771045]  [<ffffffffa02d31f1>] ? xfs_trans_unlocked_item+0x31/0x50 
[xfs]
[ 8042.771050]  [<ffffffff810f144f>] generic_writepages+0x1f/0x30
[ 8042.771068]  [<ffffffffa02da8a8>] xfs_vm_writepages+0x58/0x70 [xfs]
[ 8042.771071]  [<ffffffff810f147c>] do_writepages+0x1c/0x40
[ 8042.771077]  [<ffffffff81158ddd>] writeback_single_inode+0x9d/0x260
[ 8042.771080]  [<ffffffff811591e4>] writeback_sb_inodes+0xd4/0x170
[ 8042.771083]  [<ffffffff81158258>] ? queue_io+0x98/0x1b0
[ 8042.771087]  [<ffffffff81159324>] writeback_inodes_wb+0xa4/0x170
[ 8042.771090]  [<ffffffff8115967b>] wb_writeback+0x28b/0x400
[ 8042.771094]  [<ffffffff8105477b>] ? dequeue_task_fair+0x8b/0x90
[ 8042.771099]  [<ffffffff810095fb>] ? __switch_to+0xcb/0x350
[ 8042.771103]  [<ffffffff812a7ab9>] ? __percpu_counter_sum+0x69/0x80
[ 8042.771106]  [<ffffffff8115998b>] wb_do_writeback+0x19b/0x1e0
[ 8042.771110]  [<ffffffff81159a7a>] bdi_writeback_thread+0xaa/0x270
[ 8042.771113]  [<ffffffff811599d0>] ? bdi_writeback_thread+0x0/0x270
[ 8042.771117]  [<ffffffff8107b076>] kthread+0x96/0xa0
[ 8042.771120]  [<ffffffff8100bd64>] kernel_thread_helper+0x4/0x10
[ 8042.771123]  [<ffffffff8107afe0>] ? kthread+0x0/0xa0
[ 8042.771126]  [<ffffffff8100bd60>] ? kernel_thread_helper+0x0/0x10
[ 8042.771130] INFO: task tar:3403 blocked for more than 120 seconds.
[ 8042.771163] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.771216] tar           D ffff88083d04ad40     0  3403   3400 
0x00000000
[ 8042.771220]  ffff88015e7a9c68 0000000000000082 0000000000000001 
ffff880832815f00
[ 8042.771224]  00000000000138c0 ffff88083d04ad40 ffff88083d04b0d8 
ffff88015e7a9fd8
[ 8042.771228]  ffff88083d04b0e0 00000000000138c0 ffff88015e7a8010 
00000000000138c0
[ 8042.771232] Call Trace:
[ 8042.771250]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.771268]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.771272]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.771290]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.771308]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.771326]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.771345]  [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
[ 8042.771363]  [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
[ 8042.771368]  [<ffffffff8114de68>] notify_change+0x168/0x2d0
[ 8042.771373]  [<ffffffff811346e7>] sys_fchmodat+0xd7/0x110
[ 8042.771377]  [<ffffffff815737e9>] ? _raw_spin_lock+0x9/0x10
[ 8042.771381]  [<ffffffff811345e8>] ? sys_chown+0x68/0x90
[ 8042.771384]  [<ffffffff81134733>] sys_chmod+0x13/0x20
[ 8042.771387]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.771390] INFO: task tar:3405 blocked for more than 120 seconds.
[ 8042.771424] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.771476] tar           D 00000001000b92b6     0  3405   3401 
0x00000000
[ 8042.771480]  ffff88018e975cc8 0000000000000086 ffff88018e975cd8 
0000000000000000
[ 8042.771484]  00000000000138c0 ffff880832b98000 ffff880832b98398 
ffff88018e975fd8
[ 8042.771489]  ffff880832b983a0 00000000000138c0 ffff88018e974010 
00000000000138c0
[ 8042.771493] Call Trace:
[ 8042.771510]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.771528]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.771532]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.771550]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.771568]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.771587]  [<ffffffffa02e0dab>] ? xfs_tosspages+0x1b/0x20 [xfs]
[ 8042.771605]  [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
[ 8042.771624]  [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
[ 8042.771642]  [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
[ 8042.771646]  [<ffffffff81137405>] fput+0xd5/0x280
[ 8042.771650]  [<ffffffff81133bf8>] filp_close+0x58/0x90
[ 8042.771653]  [<ffffffff81133ce9>] sys_close+0xb9/0x110
[ 8042.771656]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.771659] INFO: task tar:3406 blocked for more than 120 seconds.
[ 8042.771692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.771745] tar           D 00000001000b92b0     0  3406   3402 
0x00000008
[ 8042.771749]  ffff8801202c94c8 0000000000000086 0000000000000282 
ffff880800000001
[ 8042.771754]  00000000000138c0 ffff880832af2d40 ffff880832af30d8 
ffff8801202c9fd8
[ 8042.771758]  ffff880832af30e0 00000000000138c0 ffff8801202c8010 
00000000000138c0
[ 8042.771762] Call Trace:
[ 8042.771779]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.771798]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.771801]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.771819]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.771838]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.771856]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.771874]  [<ffffffffa02c05ed>] 
xfs_iomap_write_allocate+0x21d/0x360 [xfs]
[ 8042.771892]  [<ffffffffa02d31f1>] ? xfs_trans_unlocked_item+0x31/0x50 
[xfs]
[ 8042.771910]  [<ffffffffa02c09bf>] xfs_iomap+0x28f/0x340 [xfs]
[ 8042.771928]  [<ffffffffa02da287>] xfs_map_blocks+0x37/0x40 [xfs]
[ 8042.771946]  [<ffffffffa02ddc18>] ? _xfs_buf_lookup_pages+0x288/0x360 
[xfs]
[ 8042.771965]  [<ffffffffa02dbae0>] xfs_vm_writepage+0x3f0/0x5d0 [xfs]
[ 8042.771969]  [<ffffffff810f00d2>] __writepage+0x12/0x40
[ 8042.771972]  [<ffffffff810f1198>] write_cache_pages+0x1f8/0x490
[ 8042.771975]  [<ffffffff810f00c0>] ? __writepage+0x0/0x40
[ 8042.771993]  [<ffffffffa02bea94>] ? xfs_iflush+0x214/0x220 [xfs]
[ 8042.772011]  [<ffffffffa02dd86e>] ? xfs_bdwrite+0x3e/0x80 [xfs]
[ 8042.772030]  [<ffffffffa02d31f1>] ? xfs_trans_unlocked_item+0x31/0x50 
[xfs]
[ 8042.772034]  [<ffffffff810f144f>] generic_writepages+0x1f/0x30
[ 8042.772052]  [<ffffffffa02da8a8>] xfs_vm_writepages+0x58/0x70 [xfs]
[ 8042.772056]  [<ffffffff810f147c>] do_writepages+0x1c/0x40
[ 8042.772059]  [<ffffffff81158ddd>] writeback_single_inode+0x9d/0x260
[ 8042.772063]  [<ffffffff811591e4>] writeback_sb_inodes+0xd4/0x170
[ 8042.772066]  [<ffffffff81159324>] writeback_inodes_wb+0xa4/0x170
[ 8042.772070]  [<ffffffff810f0a60>] 
balance_dirty_pages_ratelimited_nr+0x390/0x4a0
[ 8042.772074]  [<ffffffff810e6db1>] ? 
iov_iter_copy_from_user_atomic+0x91/0x160
[ 8042.772077]  [<ffffffff810e71b3>] generic_file_buffered_write+0x1b3/0x250
[ 8042.772097]  [<ffffffffa02e09b8>] xfs_file_aio_write+0x7b8/0xa60 [xfs]
[ 8042.772101]  [<ffffffff81135582>] do_sync_write+0xd2/0x110
[ 8042.772106]  [<ffffffff81243a4e>] ? security_file_permission+0x1e/0x90
[ 8042.772109]  [<ffffffff81135878>] vfs_write+0xc8/0x190
[ 8042.772112]  [<ffffffff811361ac>] sys_write+0x4c/0x80
[ 8042.772116]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.772119] INFO: task tar:3408 blocked for more than 120 seconds.
[ 8042.772152] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.772205] tar           D 00000001000b92b0     0  3408   3404 
0x00000000
[ 8042.772209]  ffff88082c331a98 0000000000000082 0000000000000000 
0000000000000000
[ 8042.772213]  00000000000138c0 ffff88083cca43e0 ffff88083cca4778 
ffff88082c331fd8
[ 8042.772217]  ffff88083cca4780 00000000000138c0 ffff88082c330010 
00000000000138c0
[ 8042.772221] Call Trace:
[ 8042.772239]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.772257]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.772261]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.772279]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.772297]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.772315]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.772334]  [<ffffffffa02d666b>] xfs_create+0x17b/0x650 [xfs]
[ 8042.772338]  [<ffffffff815737e9>] ? _raw_spin_lock+0x9/0x10
[ 8042.772356]  [<ffffffffa02e3868>] xfs_vn_mknod+0xa8/0x1c0 [xfs]
[ 8042.772375]  [<ffffffffa02e399b>] xfs_vn_create+0xb/0x10 [xfs]
[ 8042.772379]  [<ffffffff81140f97>] vfs_create+0xa7/0xd0
[ 8042.772382]  [<ffffffff811420e8>] do_last+0x658/0x720
[ 8042.772386]  [<ffffffff8114414b>] do_filp_open+0x1fb/0x650
[ 8042.772389]  [<ffffffff81243286>] ? security_d_instantiate+0x16/0x30
[ 8042.772393]  [<ffffffff8114a371>] ? d_instantiate+0x51/0x60
[ 8042.772397]  [<ffffffff8114ef92>] ? alloc_fd+0x102/0x150
[ 8042.772400]  [<ffffffff81133da3>] do_sys_open+0x63/0x120
[ 8042.772403]  [<ffffffff8100c15d>] ? math_state_restore+0x3d/0x60
[ 8042.772407]  [<ffffffff81133e8b>] sys_open+0x1b/0x20
[ 8042.772410]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.772413] INFO: task tar:3411 blocked for more than 120 seconds.
[ 8042.772446] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.772499] tar           D ffff88083d40ad40     0  3411   3407 
0x00000000
[ 8042.772503]  ffff880832545cc8 0000000000000086 ffff880832545cd8 
0000000000000004
[ 8042.772507]  00000000000138c0 ffff88083d40ad40 ffff88083d40b0d8 
ffff880832545fd8
[ 8042.772512]  ffff88083d40b0e0 00000000000138c0 ffff880832544010 
00000000000138c0
[ 8042.772516] Call Trace:
[ 8042.772533]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.772551]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.772555]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.772573]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.772591]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.772610]  [<ffffffffa02e0dab>] ? xfs_tosspages+0x1b/0x20 [xfs]
[ 8042.772628]  [<ffffffffa02d6db5>] xfs_free_eofblocks+0x175/0x270 [xfs]
[ 8042.772646]  [<ffffffffa02d782d>] xfs_release+0x10d/0x1c0 [xfs]
[ 8042.772665]  [<ffffffffa02dfa90>] xfs_file_release+0x10/0x20 [xfs]
[ 8042.772669]  [<ffffffff81137405>] fput+0xd5/0x280
[ 8042.772672]  [<ffffffff81133bf8>] filp_close+0x58/0x90
[ 8042.772675]  [<ffffffff81133ce9>] sys_close+0xb9/0x110
[ 8042.772678]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.772681] INFO: task tar:3412 blocked for more than 120 seconds.
[ 8042.772714] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.772767] tar           D 00000001000b92ae     0  3412   3409 
0x00000000
[ 8042.772771]  ffff8802b0811a98 0000000000000082 0000000000000000 
0000000000000000
[ 8042.772775]  00000000000138c0 ffff8808400aad40 ffff8808400ab0d8 
ffff8802b0811fd8
[ 8042.772780]  ffff8808400ab0e0 00000000000138c0 ffff8802b0810010 
00000000000138c0
[ 8042.772784] Call Trace:
[ 8042.772802]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.772820]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.772824]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.772841]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.772860]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.772878]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.772896]  [<ffffffffa02d666b>] xfs_create+0x17b/0x650 [xfs]
[ 8042.772913]  [<ffffffffa02b8ef6>] ? xfs_iunlock+0x96/0x130 [xfs]
[ 8042.772932]  [<ffffffffa02d6bcd>] ? xfs_lookup+0x8d/0x100 [xfs]
[ 8042.772950]  [<ffffffffa02e3868>] xfs_vn_mknod+0xa8/0x1c0 [xfs]
[ 8042.772969]  [<ffffffffa02e399b>] xfs_vn_create+0xb/0x10 [xfs]
[ 8042.772972]  [<ffffffff81140f97>] vfs_create+0xa7/0xd0
[ 8042.772976]  [<ffffffff811420e8>] do_last+0x658/0x720
[ 8042.772979]  [<ffffffff8114414b>] do_filp_open+0x1fb/0x650
[ 8042.772983]  [<ffffffff815737e9>] ? _raw_spin_lock+0x9/0x10
[ 8042.772986]  [<ffffffff815737e9>] ? _raw_spin_lock+0x9/0x10
[ 8042.772990]  [<ffffffff8114ef92>] ? alloc_fd+0x102/0x150
[ 8042.772993]  [<ffffffff81133da3>] do_sys_open+0x63/0x120
[ 8042.772996]  [<ffffffff8100c15d>] ? math_state_restore+0x3d/0x60
[ 8042.773000]  [<ffffffff81133e8b>] sys_open+0x1b/0x20
[ 8042.773003]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
[ 8042.773006] INFO: task tar:3414 blocked for more than 120 seconds.
[ 8042.773039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 8042.773092] tar           D 00000001000b92aa     0  3414   3410 
0x00000000
[ 8042.773096]  ffff8802b0a19c08 0000000000000086 ffff88015d090800 
0000000500000000
[ 8042.773100]  00000000000138c0 ffff880832af0000 ffff880832af0398 
ffff8802b0a19fd8
[ 8042.773104]  ffff880832af03a0 00000000000138c0 ffff8802b0a18010 
00000000000138c0
[ 8042.773108] Call Trace:
[ 8042.773126]  [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
[ 8042.773144]  [<ffffffffa02d97e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[ 8042.773148]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
[ 8042.773166]  [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
[ 8042.773184]  [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[ 8042.773202]  [<ffffffffa02d28b7>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 8042.773221]  [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
[ 8042.773239]  [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
[ 8042.773243]  [<ffffffff8114de68>] notify_change+0x168/0x2d0
[ 8042.773247]  [<ffffffff8115dc57>] utimes_common+0xd7/0x1b0
[ 8042.773252]  [<ffffffff81292a3d>] ? _atomic_dec_and_lock+0x4d/0x80
[ 8042.773255]  [<ffffffff8115ddc0>] do_utimes+0x90/0xf0
[ 8042.773259]  [<ffffffff8115dece>] sys_utimensat+0x2e/0x80
[ 8042.773262]  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b


What do you think?
Is it the delaylog? is it not stable?

Thank you


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
