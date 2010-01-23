Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0NE8JYP188961 for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 08:08:20 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F402135CF6F
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 06:09:19 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id UZ03HBJ7BjcsAQNw for
	<xfs@oss.sgi.com>; Sat, 23 Jan 2010 06:09:19 -0800 (PST)
Date: Sat, 23 Jan 2010 09:09:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.32.3: INFO: task flush-9:3:29267 blocked for more than 120
	seconds.
Message-ID: <alpine.DEB.2.00.1001230904310.20641@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

Hello,

I recently saw this under 2.6.32.3:

Running raid-1 w/2 raptors & a raid-5 with some 750GB drives.
All mdadm / 0.90 superblocks / XFS.
Debian Testing x86_64

Is this normal?

[1128155.188452] md: data-check of RAID array md0
[1128155.188465] md: minimum _guaranteed_  speed: 30000 KB/sec/disk.
[1128155.188468] md: using maximum available idle IO bandwidth (but not more than 50000 KB/sec) for data-check.
[1128155.188473] md: using 128k window, over a total of 16787776 blocks.
[1128156.201359] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[1128157.204843] md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
[1128157.204907] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[1128158.208350] md: data-check of RAID array md3
[1128158.208363] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1128158.208366] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[1128158.208373] md: using 128k window, over a total of 732571648 blocks.
[1128493.349066] md: md0: data-check done.
[1128493.368842] md: data-check of RAID array md1
[1128493.368846] md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
[1128493.368864] md: minimum _guaranteed_  speed: 30000 KB/sec/disk.
[1128493.368867] md: using maximum available idle IO bandwidth (but not more than 50000 KB/sec) for data-check.
[1128493.368871] md: using 128k window, over a total of 136448 blocks.
[1128496.003606] md: md1: data-check done.
[1128496.026560] md: data-check of RAID array md2
[1128496.026578] md: minimum _guaranteed_  speed: 30000 KB/sec/disk.
[1128496.026581] md: using maximum available idle IO bandwidth (but not more than 50000 KB/sec) for data-check.
[1128496.026588] md: using 128k window, over a total of 129596288 blocks.
[1131179.410906] md: md2: data-check done.
[1148640.440503] INFO: task xfssyncd:1655 blocked for more than 120 seconds.
[1148640.440516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148640.440520] xfssyncd      D ffff88023fb6a028     0  1655      2 0x00000000
[1148640.440533]  ffff8800af9693e0 0000000000000046 ffff8801f866e6d8 000000002baa9928
[1148640.440545]  000000000000c928 ffff88023a329fd8 ffff88023f956210 ffff88023f956488
[1148640.440552]  0000000100000000 ffffffff8134cb47 ffff88002828c928 ffff88023f956488
[1148640.440558] Call Trace:
[1148640.440572]  [<ffffffff8134cb47>] ? get_active_stripe+0x417/0x630
[1148640.440577]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148640.440583]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148640.440587]  [<ffffffff8134977d>] ? release_stripe+0x3d/0x60
[1148640.440592]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148640.440595]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148640.440603]  [<ffffffff81220313>] ? cpumask_next_and+0x23/0x40
[1148640.440606]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148640.440612]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148640.440616]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148640.440620]  [<ffffffff811fdc70>] ? _xfs_buf_ioapply+0x120/0x280
[1148640.440626]  [<ffffffff811fee79>] ? xfs_buf_iorequest+0x29/0x90
[1148640.440631]  [<ffffffff811e84dd>] ? xlog_bdstrat_cb+0x3d/0x50
[1148640.440638]  [<ffffffff811e5ecb>] ? xlog_sync+0x20b/0x4e0
[1148640.440641]  [<ffffffff811e6dc8>] ? xlog_state_sync_all+0x1b8/0x230
[1148640.440647]  [<ffffffff8106313a>] ? del_timer_sync+0x1a/0x30
[1148640.440650]  [<ffffffff811e735b>] ? _xfs_log_force+0x6b/0x80
[1148640.440654]  [<ffffffff811e737b>] ? xfs_log_force+0xb/0x40
[1148640.440658]  [<ffffffff81207549>] ? xfs_sync_worker+0x19/0x60
[1148640.440662]  [<ffffffff81206bcc>] ? xfssyncd+0x13c/0x1c0
[1148640.440665]  [<ffffffff81206a90>] ? xfssyncd+0x0/0x1c0
[1148640.440668]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148640.440674]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148640.440680]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148640.440683]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1148640.440730] INFO: task flush-9:3:29267 blocked for more than 120 seconds.
[1148640.440733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148640.440736] flush-9:3     D ffff88023fb6a028     0 29267      2 0x00000000
[1148640.440743]  ffff88023f9578d0 0000000000000046 ffff8801f868e108 ffff880109a41900
[1148640.440749]  000000000000c928 ffff880109a41fd8 ffff88023fa82bf0 ffff88023fa82e68
[1148640.440758]  0000000209a41944 ffffffff811babef 0000000000000000 ffff88023fa82e68
[1148640.440764] Call Trace:
[1148640.440770]  [<ffffffff811babef>] ? xfs_bmap_search_multi_extents+0xaf/0x120
[1148640.440774]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148640.440780]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148640.440784]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148640.440790]  [<ffffffff81092624>] ? test_set_page_writeback+0xd4/0x170
[1148640.440794]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148640.440798]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148640.440805]  [<ffffffff811fc38c>] ? xfs_cluster_write+0x11c/0x160
[1148640.440809]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148640.440815]  [<ffffffff810d9808>] ? __mark_inode_dirty+0x68/0x170
[1148640.440819]  [<ffffffff811fc49f>] ? xfs_submit_ioend_bio+0x4f/0x70
[1148640.440822]  [<ffffffff811fc55a>] ? xfs_submit_ioend+0x9a/0xd0
[1148640.440826]  [<ffffffff811fc972>] ? xfs_page_state_convert+0x3e2/0x6c0
[1148640.440830]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130
[1148640.440834]  [<ffffffff8109249a>] ? __writepage+0xa/0x40
[1148640.440840]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0
[1148640.440844]  [<ffffffff81092490>] ? __writepage+0x0/0x40
[1148640.440848]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390
[1148640.440851]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0
[1148640.440856]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0
[1148640.440859]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90
[1148640.440863]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180
[1148640.440866]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0
[1148640.440871]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148640.440874]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0
[1148640.440877]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148640.440880]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148640.440884]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148640.440888]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148640.440893]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1148760.440444] INFO: task xfssyncd:1655 blocked for more than 120 seconds.
[1148760.440458] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148760.440462] xfssyncd      D ffff88023fb6a028     0  1655      2 0x00000000
[1148760.440469]  ffff8800af9693e0 0000000000000046 ffff8801f866e6d8 000000002baa9928
[1148760.440483]  000000000000c928 ffff88023a329fd8 ffff88023f956210 ffff88023f956488
[1148760.440489]  0000000100000000 ffffffff8134cb47 ffff88002828c928 ffff88023f956488
[1148760.440497] Call Trace:
[1148760.440510]  [<ffffffff8134cb47>] ? get_active_stripe+0x417/0x630
[1148760.440516]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148760.440523]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148760.440528]  [<ffffffff8134977d>] ? release_stripe+0x3d/0x60
[1148760.440532]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148760.440536]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148760.440542]  [<ffffffff81220313>] ? cpumask_next_and+0x23/0x40
[1148760.440546]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148760.440551]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148760.440556]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148760.440561]  [<ffffffff811fdc70>] ? _xfs_buf_ioapply+0x120/0x280
[1148760.440565]  [<ffffffff811fee79>] ? xfs_buf_iorequest+0x29/0x90
[1148760.440572]  [<ffffffff811e84dd>] ? xlog_bdstrat_cb+0x3d/0x50
[1148760.440576]  [<ffffffff811e5ecb>] ? xlog_sync+0x20b/0x4e0
[1148760.440580]  [<ffffffff811e6dc8>] ? xlog_state_sync_all+0x1b8/0x230
[1148760.440586]  [<ffffffff8106313a>] ? del_timer_sync+0x1a/0x30
[1148760.440590]  [<ffffffff811e735b>] ? _xfs_log_force+0x6b/0x80
[1148760.440593]  [<ffffffff811e737b>] ? xfs_log_force+0xb/0x40
[1148760.440598]  [<ffffffff81207549>] ? xfs_sync_worker+0x19/0x60
[1148760.440601]  [<ffffffff81206bcc>] ? xfssyncd+0x13c/0x1c0
[1148760.440605]  [<ffffffff81206a90>] ? xfssyncd+0x0/0x1c0
[1148760.440609]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148760.440615]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148760.440619]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148760.440623]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1148760.440667] INFO: task flush-9:3:29267 blocked for more than 120 seconds.
[1148760.440671] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148760.440673] flush-9:3     D ffff88023fb6a028     0 29267      2 0x00000000
[1148760.440679]  ffff88023f9578d0 0000000000000046 ffff8801f868e108 ffff880109a41900
[1148760.440686]  000000000000c928 ffff880109a41fd8 ffff88023fa82bf0 ffff88023fa82e68
[1148760.440693]  0000000209a41944 ffffffff811babef 0000000000000000 ffff88023fa82e68
[1148760.440701] Call Trace:
[1148760.440707]  [<ffffffff811babef>] ? xfs_bmap_search_multi_extents+0xaf/0x120
[1148760.440711]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148760.440716]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148760.440720]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148760.440725]  [<ffffffff81092624>] ? test_set_page_writeback+0xd4/0x170
[1148760.440730]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148760.440733]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148760.440738]  [<ffffffff811fc38c>] ? xfs_cluster_write+0x11c/0x160
[1148760.440742]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148760.440748]  [<ffffffff810d9808>] ? __mark_inode_dirty+0x68/0x170
[1148760.440751]  [<ffffffff811fc49f>] ? xfs_submit_ioend_bio+0x4f/0x70
[1148760.440755]  [<ffffffff811fc55a>] ? xfs_submit_ioend+0x9a/0xd0
[1148760.440759]  [<ffffffff811fc972>] ? xfs_page_state_convert+0x3e2/0x6c0
[1148760.440764]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130
[1148760.440767]  [<ffffffff8109249a>] ? __writepage+0xa/0x40
[1148760.440770]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0
[1148760.440774]  [<ffffffff81092490>] ? __writepage+0x0/0x40
[1148760.440778]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390
[1148760.440782]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0
[1148760.440786]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0
[1148760.440791]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90
[1148760.440794]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180
[1148760.440798]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0
[1148760.440802]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148760.440805]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0
[1148760.440808]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148760.440812]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148760.440816]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148760.440819]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148760.440822]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1148880.440706] INFO: task xfssyncd:1655 blocked for more than 120 seconds.
[1148880.440718] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148880.440723] xfssyncd      D ffff88023fb6a028     0  1655      2 0x00000000
[1148880.440730]  ffff8800af9693e0 0000000000000046 ffff8801f866e6d8 000000002baa9928
[1148880.440744]  000000000000c928 ffff88023a329fd8 ffff88023f956210 ffff88023f956488
[1148880.440751]  0000000100000000 ffffffff8134cb47 ffff88002828c928 ffff88023f956488
[1148880.440757] Call Trace:
[1148880.440767]  [<ffffffff8134cb47>] ? get_active_stripe+0x417/0x630
[1148880.440771]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148880.440777]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148880.440781]  [<ffffffff8134977d>] ? release_stripe+0x3d/0x60
[1148880.440785]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148880.440790]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148880.440796]  [<ffffffff81220313>] ? cpumask_next_and+0x23/0x40
[1148880.440801]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148880.440806]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148880.440810]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148880.440817]  [<ffffffff811fdc70>] ? _xfs_buf_ioapply+0x120/0x280
[1148880.440820]  [<ffffffff811fee79>] ? xfs_buf_iorequest+0x29/0x90
[1148880.440825]  [<ffffffff811e84dd>] ? xlog_bdstrat_cb+0x3d/0x50
[1148880.440829]  [<ffffffff811e5ecb>] ? xlog_sync+0x20b/0x4e0
[1148880.440832]  [<ffffffff811e6dc8>] ? xlog_state_sync_all+0x1b8/0x230
[1148880.440838]  [<ffffffff8106313a>] ? del_timer_sync+0x1a/0x30
[1148880.440842]  [<ffffffff811e735b>] ? _xfs_log_force+0x6b/0x80
[1148880.440845]  [<ffffffff811e737b>] ? xfs_log_force+0xb/0x40
[1148880.440849]  [<ffffffff81207549>] ? xfs_sync_worker+0x19/0x60
[1148880.440853]  [<ffffffff81206bcc>] ? xfssyncd+0x13c/0x1c0
[1148880.440856]  [<ffffffff81206a90>] ? xfssyncd+0x0/0x1c0
[1148880.440859]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148880.440864]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148880.440868]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148880.440871]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1148880.440914] INFO: task flush-9:3:29267 blocked for more than 120 seconds.
[1148880.440917] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1148880.440919] flush-9:3     D ffff88023fb6a028     0 29267      2 0x00000000
[1148880.440925]  ffff88023f9578d0 0000000000000046 ffff8801f868e108 ffff880109a41900
[1148880.440934]  000000000000c928 ffff880109a41fd8 ffff88023fa82bf0 ffff88023fa82e68
[1148880.440944]  0000000209a41944 ffffffff811babef 0000000000000000 ffff88023fa82e68
[1148880.440953] Call Trace:
[1148880.440959]  [<ffffffff811babef>] ? xfs_bmap_search_multi_extents+0xaf/0x120
[1148880.440963]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1148880.440968]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1148880.440972]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1148880.440976]  [<ffffffff81092624>] ? test_set_page_writeback+0xd4/0x170
[1148880.440982]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1148880.440987]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1148880.440992]  [<ffffffff811fc38c>] ? xfs_cluster_write+0x11c/0x160
[1148880.440997]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1148880.441002]  [<ffffffff810d9808>] ? __mark_inode_dirty+0x68/0x170
[1148880.441006]  [<ffffffff811fc49f>] ? xfs_submit_ioend_bio+0x4f/0x70
[1148880.441009]  [<ffffffff811fc55a>] ? xfs_submit_ioend+0x9a/0xd0
[1148880.441013]  [<ffffffff811fc972>] ? xfs_page_state_convert+0x3e2/0x6c0
[1148880.441017]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130
[1148880.441020]  [<ffffffff8109249a>] ? __writepage+0xa/0x40
[1148880.441023]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0
[1148880.441026]  [<ffffffff81092490>] ? __writepage+0x0/0x40
[1148880.441030]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390
[1148880.441034]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0
[1148880.441037]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0
[1148880.441044]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90
[1148880.441048]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180
[1148880.441051]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0
[1148880.441055]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148880.441059]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0
[1148880.441062]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1148880.441066]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1148880.441069]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1148880.441072]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1148880.441075]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1149000.440407] INFO: task xfssyncd:1655 blocked for more than 120 seconds.
[1149000.440421] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1149000.440427] xfssyncd      D ffff88023fb6a028     0  1655      2 0x00000000
[1149000.440438]  ffff8800af9693e0 0000000000000046 ffff8801f866e6d8 000000002baa9928
[1149000.440446]  000000000000c928 ffff88023a329fd8 ffff88023f956210 ffff88023f956488
[1149000.440452]  0000000100000000 ffffffff8134cb47 ffff88002828c928 ffff88023f956488
[1149000.440461] Call Trace:
[1149000.440475]  [<ffffffff8134cb47>] ? get_active_stripe+0x417/0x630
[1149000.440481]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1149000.440488]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149000.440493]  [<ffffffff8134977d>] ? release_stripe+0x3d/0x60
[1149000.440497]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1149000.440501]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149000.440506]  [<ffffffff81220313>] ? cpumask_next_and+0x23/0x40
[1149000.440510]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1149000.440515]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1149000.440520]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1149000.440524]  [<ffffffff811fdc70>] ? _xfs_buf_ioapply+0x120/0x280
[1149000.440528]  [<ffffffff811fee79>] ? xfs_buf_iorequest+0x29/0x90
[1149000.440532]  [<ffffffff811e84dd>] ? xlog_bdstrat_cb+0x3d/0x50
[1149000.440536]  [<ffffffff811e5ecb>] ? xlog_sync+0x20b/0x4e0
[1149000.440544]  [<ffffffff811e6dc8>] ? xlog_state_sync_all+0x1b8/0x230
[1149000.440549]  [<ffffffff8106313a>] ? del_timer_sync+0x1a/0x30
[1149000.440553]  [<ffffffff811e735b>] ? _xfs_log_force+0x6b/0x80
[1149000.440556]  [<ffffffff811e737b>] ? xfs_log_force+0xb/0x40
[1149000.440560]  [<ffffffff81207549>] ? xfs_sync_worker+0x19/0x60
[1149000.440563]  [<ffffffff81206bcc>] ? xfssyncd+0x13c/0x1c0
[1149000.440567]  [<ffffffff81206a90>] ? xfssyncd+0x0/0x1c0
[1149000.440570]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1149000.440578]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1149000.440582]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1149000.440585]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1149000.440633] INFO: task flush-9:3:29267 blocked for more than 120 seconds.
[1149000.440635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1149000.440637] flush-9:3     D ffff88023fb6a028     0 29267      2 0x00000000
[1149000.440643]  ffff88023f9578d0 0000000000000046 ffff8801f868e108 ffff880109a41900
[1149000.440654]  000000000000c928 ffff880109a41fd8 ffff88023fa82bf0 ffff88023fa82e68
[1149000.440660]  0000000209a41944 ffffffff811babef 0000000000000000 ffff88023fa82e68
[1149000.440669] Call Trace:
[1149000.440676]  [<ffffffff811babef>] ? xfs_bmap_search_multi_extents+0xaf/0x120
[1149000.440680]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1149000.440684]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149000.440687]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1149000.440691]  [<ffffffff81092624>] ? test_set_page_writeback+0xd4/0x170
[1149000.440697]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1149000.440701]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1149000.440710]  [<ffffffff811fc38c>] ? xfs_cluster_write+0x11c/0x160
[1149000.440713]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1149000.440719]  [<ffffffff810d9808>] ? __mark_inode_dirty+0x68/0x170
[1149000.440723]  [<ffffffff811fc49f>] ? xfs_submit_ioend_bio+0x4f/0x70
[1149000.440727]  [<ffffffff811fc55a>] ? xfs_submit_ioend+0x9a/0xd0
[1149000.440731]  [<ffffffff811fc972>] ? xfs_page_state_convert+0x3e2/0x6c0
[1149000.440736]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130
[1149000.440739]  [<ffffffff8109249a>] ? __writepage+0xa/0x40
[1149000.440743]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0
[1149000.440745]  [<ffffffff81092490>] ? __writepage+0x0/0x40
[1149000.440749]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390
[1149000.440753]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0
[1149000.440756]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0
[1149000.440760]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90
[1149000.440764]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180
[1149000.440767]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0
[1149000.440774]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1149000.440776]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0
[1149000.440780]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1149000.440783]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1149000.440786]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1149000.440790]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1149000.440793]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1149120.440754] INFO: task xfssyncd:1655 blocked for more than 120 seconds.
[1149120.440768] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1149120.440772] xfssyncd      D ffff88023fb6a028     0  1655      2 0x00000000
[1149120.440778]  ffff8800af9693e0 0000000000000046 ffff8801f866e6d8 000000002baa9928
[1149120.440786]  000000000000c928 ffff88023a329fd8 ffff88023f956210 ffff88023f956488
[1149120.440792]  0000000100000000 ffffffff8134cb47 ffff88002828c928 ffff88023f956488
[1149120.440802] Call Trace:
[1149120.440812]  [<ffffffff8134cb47>] ? get_active_stripe+0x417/0x630
[1149120.440817]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1149120.440824]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149120.440828]  [<ffffffff8134977d>] ? release_stripe+0x3d/0x60
[1149120.440831]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1149120.440835]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149120.440840]  [<ffffffff81220313>] ? cpumask_next_and+0x23/0x40
[1149120.440845]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1149120.440851]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1149120.440855]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1149120.440860]  [<ffffffff811fdc70>] ? _xfs_buf_ioapply+0x120/0x280
[1149120.440863]  [<ffffffff811fee79>] ? xfs_buf_iorequest+0x29/0x90
[1149120.440869]  [<ffffffff811e84dd>] ? xlog_bdstrat_cb+0x3d/0x50
[1149120.440874]  [<ffffffff811e5ecb>] ? xlog_sync+0x20b/0x4e0
[1149120.440878]  [<ffffffff811e6dc8>] ? xlog_state_sync_all+0x1b8/0x230
[1149120.440883]  [<ffffffff8106313a>] ? del_timer_sync+0x1a/0x30
[1149120.440886]  [<ffffffff811e735b>] ? _xfs_log_force+0x6b/0x80
[1149120.440889]  [<ffffffff811e737b>] ? xfs_log_force+0xb/0x40
[1149120.440894]  [<ffffffff81207549>] ? xfs_sync_worker+0x19/0x60
[1149120.440898]  [<ffffffff81206bcc>] ? xfssyncd+0x13c/0x1c0
[1149120.440902]  [<ffffffff81206a90>] ? xfssyncd+0x0/0x1c0
[1149120.440906]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1149120.440914]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1149120.440917]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1149120.440920]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
[1149120.440962] INFO: task flush-9:3:29267 blocked for more than 120 seconds.
[1149120.440965] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1149120.440968] flush-9:3     D ffff88023fb6a028     0 29267      2 0x00000000
[1149120.440973]  ffff88023f9578d0 0000000000000046 ffff8801f868e108 ffff880109a41900
[1149120.440979]  000000000000c928 ffff880109a41fd8 ffff88023fa82bf0 ffff88023fa82e68
[1149120.440985]  0000000209a41944 ffffffff811babef 0000000000000000 ffff88023fa82e68
[1149120.440992] Call Trace:
[1149120.440997]  [<ffffffff811babef>] ? xfs_bmap_search_multi_extents+0xaf/0x120
[1149120.441001]  [<ffffffff81357805>] ? md_write_start+0xb5/0x1b0
[1149120.441005]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30
[1149120.441011]  [<ffffffff813518ac>] ? make_request+0x3c/0x700
[1149120.441015]  [<ffffffff81092624>] ? test_set_page_writeback+0xd4/0x170
[1149120.441019]  [<ffffffff8135810c>] ? md_make_request+0xbc/0x130
[1149120.441023]  [<ffffffff81211fcc>] ? generic_make_request+0x1ec/0x2f0
[1149120.441027]  [<ffffffff811fc38c>] ? xfs_cluster_write+0x11c/0x160
[1149120.441030]  [<ffffffff8121212a>] ? submit_bio+0x5a/0xe0
[1149120.441034]  [<ffffffff810d9808>] ? __mark_inode_dirty+0x68/0x170
[1149120.441040]  [<ffffffff811fc49f>] ? xfs_submit_ioend_bio+0x4f/0x70
[1149120.441043]  [<ffffffff811fc55a>] ? xfs_submit_ioend+0x9a/0xd0
[1149120.441047]  [<ffffffff811fc972>] ? xfs_page_state_convert+0x3e2/0x6c0
[1149120.441052]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130
[1149120.441055]  [<ffffffff8109249a>] ? __writepage+0xa/0x40
[1149120.441059]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0
[1149120.441062]  [<ffffffff81092490>] ? __writepage+0x0/0x40
[1149120.441069]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390
[1149120.441073]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0
[1149120.441076]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0
[1149120.441080]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90
[1149120.441083]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180
[1149120.441086]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0
[1149120.441090]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1149120.441093]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0
[1149120.441096]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0
[1149120.441101]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0
[1149120.441104]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20
[1149120.441108]  [<ffffffff8106da20>] ? kthread+0x0/0xa0
[1149120.441112]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
