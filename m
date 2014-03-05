Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C33687F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 17:08:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE3CD304032
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 15:08:18 -0800 (PST)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	ZwuhmKH8eFZ7jx9Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 15:08:16 -0800 (PST)
Received: by mail-ie0-f181.google.com with SMTP id tp5so1888113ieb.12
	for <xfs@oss.sgi.com>; Wed, 05 Mar 2014 15:08:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 5 Mar 2014 15:08:16 -0800
Message-ID: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
Subject: XFS crash?
From: Austin Schuh <austin@peloton-tech.com>
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
To: xfs@oss.sgi.com

Howdy,

I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
and I'm seeing a couple lockups and crashes which I think are related
to XFS.

After the first lockup, I booted into single user mode, mounted the
filesystem readonly, and then ran xfs_repair -d.  When I rebooted
again, I initiated a large copy to a USB drive (formated EXT3) and
continued editing source files and compiling.  After a couple minutes,
my laptop started locking up and after 2 minutes, the following showed
up in the kernel.

Austin

$ uname -a
Linux vpc5 3.10-3-rt-amd64 #5 SMP PREEMPT RT Debian 3.10.11-2
(2013-09-10) x86_64 GNU/Linux

[ 1186.363397] usb 2-1: USB disconnect, device number 2
[ 1200.895262] INFO: task kworker/u16:5:250 blocked for more than 120 seconds.
[ 1200.895267] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895270] kworker/u16:5   D ffff88040dc62cc0     0   250      2 0x00000000
[ 1200.895281] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
[ 1200.895287]  ffff880406fc5c20 0000000000000046 0000000000008000
ffff880407f06ce0
[ 1200.895288]  0000000000062cc0 ffff880407dfdfd8 0000000000062cc0
ffff880407dfdfd8
[ 1200.895290]  ffff880407dfd5e8 ffff880406fc5c20 ffff880407dfd710
ffff880407dfd708
[ 1200.895294] Call Trace:
[ 1200.895301]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
[ 1200.895304]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895307]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
[ 1200.895310]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1200.895313]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
[ 1200.895317]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
[ 1200.895319]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1200.895322]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
[ 1200.895356]  [<ffffffffa01a5032>] ? xfs_bmapi_allocate+0x92/0x9e [xfs]
[ 1200.895371]  [<ffffffffa01a535d>] ? xfs_bmapi_write+0x31f/0x558 [xfs]
[ 1200.895375]  [<ffffffff81109680>] ? kmem_cache_alloc+0x7c/0x17d
[ 1200.895390]  [<ffffffffa01a2e6e>] ? __xfs_bmapi_allocate+0x22b/0x22b [xfs]
[ 1200.895402]  [<ffffffffa018b899>] ?
xfs_iomap_write_allocate+0x1bc/0x2c8 [xfs]
[ 1200.895414]  [<ffffffffa017edc5>] ? xfs_map_blocks+0x125/0x1f5 [xfs]
[ 1200.895424]  [<ffffffffa017fc87>] ? xfs_vm_writepage+0x266/0x48f [xfs]
[ 1200.895428]  [<ffffffff810d3d14>] ? __writepage+0xd/0x2a
[ 1200.895430]  [<ffffffff810d4790>] ? write_cache_pages+0x207/0x302
[ 1200.895432]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
[ 1200.895435]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
[ 1200.895438]  [<ffffffff81134698>] ? __writeback_single_inode+0x72/0x225
[ 1200.895441]  [<ffffffff8113550b>] ? writeback_sb_inodes+0x215/0x36d
[ 1200.895444]  [<ffffffff811356cc>] ? __writeback_inodes_wb+0x69/0xab
[ 1200.895446]  [<ffffffff81135844>] ? wb_writeback+0x136/0x2a7
[ 1200.895448]  [<ffffffff810d3fc8>] ? global_dirtyable_memory+0xd/0x46
[ 1200.895450]  [<ffffffff810d4945>] ? global_dirty_limits+0x27/0x120
[ 1200.895453]  [<ffffffff81135cc8>] ? wb_do_writeback+0x1a1/0x1dc
[ 1200.895456]  [<ffffffff81135d66>] ? bdi_writeback_workfn+0x63/0xf4
[ 1200.895460]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
[ 1200.895462]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
[ 1200.895465]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
[ 1200.895467]  [<ffffffff8105a909>] ? kthread+0x81/0x89
[ 1200.895469]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[ 1200.895472]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
[ 1200.895474]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[ 1200.895477] INFO: task kworker/0:2:272 blocked for more than 120 seconds.
[ 1200.895501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895503] kworker/0:2     D ffff880407f06ce0     0   272      2 0x00000000
[ 1200.895517] Workqueue: xfs-data/sda7 xfs_end_io [xfs]
[ 1200.895520]  ffff880407f06ce0 0000000000000046 ffffffffffffffff
ffff88032dc7baa0
[ 1200.895522]  0000000000062cc0 ffff8804053f3fd8 0000000000062cc0
ffff8804053f3fd8
[ 1200.895524]  0000000000000001 ffff880407f06ce0 ffff88030fb5df80
0000000000000002
[ 1200.895526] Call Trace:
[ 1200.895531]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895534]  [<ffffffff813a2438>] ? __rt_mutex_slowlock+0x7b/0xb4
[ 1200.895537]  [<ffffffff813a2577>] ? rt_mutex_slowlock+0xe5/0x150
[ 1200.895542]  [<ffffffff8100c02f>] ? load_TLS+0x7/0xa
[ 1200.895552]  [<ffffffffa017eadb>] ? xfs_setfilesize+0x48/0x120 [xfs]
[ 1200.895555]  [<ffffffff81063d25>] ? finish_task_switch+0x80/0xc6
[ 1200.895565]  [<ffffffffa017f62f>] ? xfs_end_io+0x7a/0x8e [xfs]
[ 1200.895568]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
[ 1200.895570]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
[ 1200.895572]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
[ 1200.895574]  [<ffffffff8105a909>] ? kthread+0x81/0x89
[ 1200.895576]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[ 1200.895579]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
[ 1200.895581]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[ 1200.895617] INFO: task BrowserBlocking:5547 blocked for more than
120 seconds.
[ 1200.895628] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895630] BrowserBlocking D ffff88040dc62cc0     0  5547      1 0x00000000
[ 1200.895635]  ffff88040497baa0 0000000000000086 0000000000000000
ffffffff81616400
[ 1200.895636]  0000000000062cc0 ffff8803f07bbfd8 0000000000062cc0
ffff8803f07bbfd8
[ 1200.895638]  ffff8803f07bb868 ffff88040497baa0 ffff8803f07bb990
ffff8803f07bb988
[ 1200.895641] Call Trace:
[ 1200.895645]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
[ 1200.895648]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895650]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
[ 1200.895653]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1200.895654]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
[ 1200.895657]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
[ 1200.895659]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1200.895662]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
[ 1200.895676]  [<ffffffffa01a5032>] ? xfs_bmapi_allocate+0x92/0x9e [xfs]
[ 1200.895689]  [<ffffffffa01a535d>] ? xfs_bmapi_write+0x31f/0x558 [xfs]
[ 1200.895691]  [<ffffffff81109680>] ? kmem_cache_alloc+0x7c/0x17d
[ 1200.895705]  [<ffffffffa01a2e6e>] ? __xfs_bmapi_allocate+0x22b/0x22b [xfs]
[ 1200.895717]  [<ffffffffa018b899>] ?
xfs_iomap_write_allocate+0x1bc/0x2c8 [xfs]
[ 1200.895728]  [<ffffffffa017edc5>] ? xfs_map_blocks+0x125/0x1f5 [xfs]
[ 1200.895739]  [<ffffffffa017fc87>] ? xfs_vm_writepage+0x266/0x48f [xfs]
[ 1200.895742]  [<ffffffff810d3d14>] ? __writepage+0xd/0x2a
[ 1200.895744]  [<ffffffff810d4790>] ? write_cache_pages+0x207/0x302
[ 1200.895745]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
[ 1200.895749]  [<ffffffff8104031a>] ? pin_current_cpu+0x3e/0x191
[ 1200.895752]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
[ 1200.895755]  [<ffffffff810cd303>] ? __filemap_fdatawrite_range+0x50/0x55
[ 1200.895758]  [<ffffffff810cd32d>] ? filemap_write_and_wait_range+0x25/0x59
[ 1200.895769]  [<ffffffffa01844d4>] ? xfs_file_fsync+0x78/0x1ad [xfs]
[ 1200.895773]  [<ffffffff8113876b>] ? do_fsync+0x2b/0x50
[ 1200.895776]  [<ffffffff8113897d>] ? SyS_fdatasync+0xb/0xf
[ 1200.895778]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.895780] INFO: task BrowserBlocking:5558 blocked for more than
120 seconds.
[ 1200.895800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895801] BrowserBlocking D ffff88040dde2cc0     0  5558      1 0x00000000
[ 1200.895806]  ffff8804093ac300 0000000000000086 ffff8803efd94000
ffff88040ad28000
[ 1200.895808]  0000000000062cc0 ffff8803efd95fd8 0000000000062cc0
ffff8803efd95fd8
[ 1200.895809]  ffff88041e52efc0 ffff8804093ac300 ffff8804093ac300
ffff8803efd95da0
[ 1200.895812] Call Trace:
[ 1200.895816]  [<ffffffff810cc034>] ? __lock_page+0x66/0x66
[ 1200.895819]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895821]  [<ffffffff813a1ff9>] ? io_schedule+0x55/0x6b
[ 1200.895823]  [<ffffffff810cc03a>] ? sleep_on_page+0x6/0xa
[ 1200.895826]  [<ffffffff813a128f>] ? __wait_on_bit+0x3e/0x75
[ 1200.895828]  [<ffffffff810cc4a4>] ? find_get_pages_tag+0xfa/0x125
[ 1200.895830]  [<ffffffff810cc0f3>] ? wait_on_page_bit+0x6e/0x73
[ 1200.895833]  [<ffffffff8105b333>] ? autoremove_wake_function+0x2a/0x2a
[ 1200.895835]  [<ffffffff810cc7bf>] ? filemap_fdatawait_range+0x66/0xfe
[ 1200.895838]  [<ffffffff810cd303>] ? __filemap_fdatawrite_range+0x50/0x55
[ 1200.895841]  [<ffffffff810cd342>] ? filemap_write_and_wait_range+0x3a/0x59
[ 1200.895852]  [<ffffffffa01844d4>] ? xfs_file_fsync+0x78/0x1ad [xfs]
[ 1200.895855]  [<ffffffff8113876b>] ? do_fsync+0x2b/0x50
[ 1200.895858]  [<ffffffff8113897d>] ? SyS_fdatasync+0xb/0xf
[ 1200.895860]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.895863] INFO: task BrowserBlocking:5575 blocked for more than
120 seconds.
[ 1200.895874] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895876] BrowserBlocking D ffff88040dd62cc0     0  5575      1 0x00000000
[ 1200.895881]  ffff880408c46480 0000000000000086 ffff8803f064e000
ffff88040accf540
[ 1200.895882]  0000000000062cc0 ffff8803f064ffd8 0000000000062cc0
ffff8803f064ffd8
[ 1200.895884]  ffff88041e54dfc0 ffff880408c46480 ffff880408c46480
ffff8803f064fda0
[ 1200.895887] Call Trace:
[ 1200.895891]  [<ffffffff810cc034>] ? __lock_page+0x66/0x66
[ 1200.895893]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895896]  [<ffffffff813a1ff9>] ? io_schedule+0x55/0x6b
[ 1200.895898]  [<ffffffff810cc03a>] ? sleep_on_page+0x6/0xa
[ 1200.895900]  [<ffffffff813a128f>] ? __wait_on_bit+0x3e/0x75
[ 1200.895902]  [<ffffffff810cc4a4>] ? find_get_pages_tag+0xfa/0x125
[ 1200.895905]  [<ffffffff810cc0f3>] ? wait_on_page_bit+0x6e/0x73
[ 1200.895907]  [<ffffffff8105b333>] ? autoremove_wake_function+0x2a/0x2a
[ 1200.895909]  [<ffffffff810cc7bf>] ? filemap_fdatawait_range+0x66/0xfe
[ 1200.895912]  [<ffffffff810cd303>] ? __filemap_fdatawrite_range+0x50/0x55
[ 1200.895915]  [<ffffffff810cd342>] ? filemap_write_and_wait_range+0x3a/0x59
[ 1200.895926]  [<ffffffffa01844d4>] ? xfs_file_fsync+0x78/0x1ad [xfs]
[ 1200.895929]  [<ffffffff8113876b>] ? do_fsync+0x2b/0x50
[ 1200.895932]  [<ffffffff8113896d>] ? SyS_fsync+0x9/0xe
[ 1200.895934]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.895965] INFO: task xterm:6032 blocked for more than 120 seconds.
[ 1200.895977] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.895979] xterm           D ffff88040dc62cc0     0  6032      1 0x00000000
[ 1200.895983]  ffff880407ce9920 0000000000000086 ffff8803b8473700
ffffffff81616400
[ 1200.895985]  0000000000062cc0 ffff8803b86affd8 0000000000062cc0
ffff8803b86affd8
[ 1200.895986]  ffff8803b86afc48 ffff880407ce9920 ffff8803b86afd50
ffff8803b86afd48
[ 1200.895989] Call Trace:
[ 1200.895994]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
[ 1200.895996]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.895999]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
[ 1200.896002]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
[ 1200.896004]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1200.896006]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
[ 1200.896009]  [<ffffffff810549bb>] ? flush_work+0xf6/0x119
[ 1200.896011]  [<ffffffff8105344b>] ? create_and_start_worker+0x5e/0x5e
[ 1200.896016]  [<ffffffff812606fa>] ? input_available_p+0x15/0x53
[ 1200.896019]  [<ffffffff812629fd>] ? n_tty_read+0x374/0x78f
[ 1200.896022]  [<ffffffff810671e8>] ? try_to_wake_up+0x1ca/0x1ca
[ 1200.896024]  [<ffffffff8125e28c>] ? tty_read+0x79/0xbd
[ 1200.896029]  [<ffffffff8111587c>] ? vfs_read+0x93/0xf5
[ 1200.896032]  [<ffffffff811159f5>] ? SyS_read+0x51/0x80
[ 1200.896035]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.896046] INFO: task tup:12846 blocked for more than 120 seconds.
[ 1200.896058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.896060] tup             D ffff88040dc62cc0     0 12846   7061 0x00000000
[ 1200.896064]  ffff88032dc7baa0 0000000000000086 ffff8802cc83dde8
ffffffff81616400
[ 1200.896066]  0000000000062cc0 ffff8802cc83dfd8 0000000000062cc0
ffff8802cc83dfd8
[ 1200.896068]  ffff8802dd120818 ffff88032dc7baa0 ffff88030fb5df80
0000000000000002
[ 1200.896071] Call Trace:
[ 1200.896075]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.896078]  [<ffffffff813a2438>] ? __rt_mutex_slowlock+0x7b/0xb4
[ 1200.896081]  [<ffffffff813a2577>] ? rt_mutex_slowlock+0xe5/0x150
[ 1200.896094]  [<ffffffffa018c3ec>] ? xfs_vn_update_time+0xa0/0x16f [xfs]
[ 1200.896097]  [<ffffffff81128b78>] ? file_update_time+0x95/0xb5
[ 1200.896098]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
[ 1200.896109]  [<ffffffffa018524b>] ? xfs_file_aio_write_checks+0xa3/0xc0 [xfs]
[ 1200.896120]  [<ffffffffa01852cf>] ?
xfs_file_buffered_aio_write+0x67/0x175 [xfs]
[ 1200.896122]  [<ffffffff810671e8>] ? try_to_wake_up+0x1ca/0x1ca
[ 1200.896133]  [<ffffffffa018549a>] ? xfs_file_aio_write+0xbd/0x10f [xfs]
[ 1200.896136]  [<ffffffff81114d6f>] ? do_sync_write+0x55/0x7c
[ 1200.896140]  [<ffffffff81115783>] ? vfs_write+0x9e/0x104
[ 1200.896143]  [<ffffffff81115b8c>] ? SyS_pwrite64+0x61/0x87
[ 1200.896146]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.896149] INFO: task ld:12961 blocked for more than 120 seconds.
[ 1200.896160] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.896162] ld              D ffff8802d3c4a180     0 12961      1 0x00000004
[ 1200.896166]  ffff8802d3c4a180 0000000000000086 ffff8802dd1b7ec0
ffff8802d41fbaa0
[ 1200.896168]  0000000000062cc0 ffff8802d3c9ffd8 0000000000062cc0
ffff8802d3c9ffd8
[ 1200.896169]  ffff8802dd1b7ec0 ffff8802d3c4a180 ffff880406cd1000
ffff8802d3c9fb90
[ 1200.896172] Call Trace:
[ 1200.896176]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.896180]  [<ffffffffa07bbd11>] ? __fuse_request_send+0x1fa/0x2d0 [fuse]
[ 1200.896183]  [<ffffffff8105b309>] ? abort_exclusive_wait+0x7f/0x7f
[ 1200.896187]  [<ffffffffa07c045e>] ? fuse_send_write+0x118/0x12b [fuse]
[ 1200.896190]  [<ffffffffa07c04e1>] ? fuse_send_write_pages+0x70/0x10f [fuse]
[ 1200.896193]  [<ffffffff8104047a>] ? unpin_current_cpu+0xd/0x51
[ 1200.896198]  [<ffffffffa07c1ae9>] ? fuse_perform_write+0x27a/0x2fd [fuse]
[ 1200.896202]  [<ffffffffa07c1dba>] ? fuse_file_aio_write+0x24e/0x297 [fuse]
[ 1200.896205]  [<ffffffff81114d6f>] ? do_sync_write+0x55/0x7c
[ 1200.896209]  [<ffffffff81115783>] ? vfs_write+0x9e/0x104
[ 1200.896212]  [<ffffffff81115a75>] ? SyS_write+0x51/0x80
[ 1200.896215]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
[ 1200.896217] INFO: task ld:12970 blocked for more than 120 seconds.
[ 1200.896226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.896228] ld              D ffff88040dce2cc0     0 12970      1 0x00000006
[ 1200.896232]  ffff8802d3d090c0 0000000000000046 ffff8802dd1b64f8
ffff88040accece0
[ 1200.896234]  0000000000062cc0 ffff880373e47fd8 0000000000062cc0
ffff880373e47fd8
[ 1200.896236]  ffff8802dd1b64f8 ffff8802d3d090c0 ffff880406cd1000
ffff880373e47be0
[ 1200.896239] Call Trace:
[ 1200.896243]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1200.896246]  [<ffffffffa07bbd11>] ? __fuse_request_send+0x1fa/0x2d0 [fuse]
[ 1200.896248]  [<ffffffff8105b309>] ? abort_exclusive_wait+0x7f/0x7f
[ 1200.896252]  [<ffffffffa07c030a>] ? fuse_flush+0xba/0xf6 [fuse]
[ 1200.896254]  [<ffffffff81113a4a>] ? filp_close+0x37/0x68
[ 1200.896257]  [<ffffffff8112aabf>] ? put_files_struct+0x6c/0xc5
[ 1200.896260]  [<ffffffff8104204d>] ? do_exit+0x3d5/0x946
[ 1200.896263]  [<ffffffff8104031a>] ? pin_current_cpu+0x3e/0x191
[ 1200.896265]  [<ffffffff8104265a>] ? do_group_exit+0x77/0xac
[ 1200.896268]  [<ffffffff8104e14a>] ? get_signal_to_deliver+0x4ff/0x543
[ 1200.896272]  [<ffffffff8100d1f7>] ? do_signal+0x3c/0x434
[ 1200.896275]  [<ffffffff8111587c>] ? vfs_read+0x93/0xf5
[ 1200.896278]  [<ffffffff8100d641>] ? do_notify_resume+0x52/0x97
[ 1200.896281]  [<ffffffff813a7966>] ? int_signal+0x12/0x17
[ 1320.927310] INFO: task khubd:210 blocked for more than 120 seconds.
[ 1320.927335] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.927338] khubd           D ffff88040dd62cc0     0   210      2 0x00000000
[ 1320.927346]  ffff880407a0dc20 0000000000000046 0000000000000000
ffff88040accf540
[ 1320.927348]  0000000000062cc0 ffff880404843fd8 0000000000062cc0
ffff880404843fd8
[ 1320.927350]  0000000000000000 ffff880407a0dc20 ffff880404843a70
ffff880404843a68
[ 1320.927354] Call Trace:
[ 1320.927364]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
[ 1320.927367]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[ 1320.927370]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
[ 1320.927374]  [<ffffffff8102c27b>] ? _flat_send_IPI_mask+0x68/0x78
[ 1320.927378]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
[ 1320.927381]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[ 1320.927382]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
[ 1320.927394]  [<ffffffff810549bb>] ? flush_work+0xf6/0x119
[ 1320.927396]  [<ffffffff8105344b>] ? create_and_start_worker+0x5e/0x5e
[ 1320.927400]  [<ffffffff810d7309>] ? __pagevec_release+0x20/0x20
[ 1320.927402]  [<ffffffff810564cc>] ? schedule_on_each_cpu+0x9e/0xd5
[ 1320.927422]  [<ffffffff8113f5a0>] ? invalidate_bdev+0x1d/0x2e
[ 1320.927425]  [<ffffffff8113f5f4>] ? __invalidate_device+0x43/0x4b
[ 1320.927427]  [<ffffffff811bf94d>] ? invalidate_partition+0x27/0x41
[ 1320.927429]  [<ffffffff811c09f9>] ? del_gendisk+0x86/0x1bb
[ 1320.927435]  [<ffffffffa00de643>] ? sd_remove+0x5f/0x98 [sd_mod]
[ 1320.927443]  [<ffffffff8128d2a0>] ? __device_release_driver+0x7f/0xd5
[ 1320.927444]  [<ffffffff8128d53a>] ? device_release_driver+0x1a/0x25
[ 1320.927446]  [<ffffffff8128cee7>] ? bus_remove_device+0xe7/0xfc
[ 1320.927448]  [<ffffffff8128ada0>] ? device_del+0x120/0x176
[ 1320.927455]  [<ffffffffa0029a0f>] ? __scsi_remove_device+0x4d/0xaf [scsi_mod]
[ 1320.927461]  [<ffffffffa002898c>] ? scsi_forget_host+0x48/0x68 [scsi_mod]
[ 1320.927467]  [<ffffffffa002025c>] ? scsi_remove_host+0x85/0x101 [scsi_mod]
[ 1320.927472]  [<ffffffffa00d1f7c>] ? usb_stor_disconnect+0x63/0xae
[usb_storage]
[ 1320.927479]  [<ffffffffa0071d31>] ? usb_unbind_interface+0x5e/0x135 [usbcore]
[ 1320.927488]  [<ffffffff8128d2a0>] ? __device_release_driver+0x7f/0xd5
[ 1320.927490]  [<ffffffff8128d53a>] ? device_release_driver+0x1a/0x25
[ 1320.927491]  [<ffffffff8128cee7>] ? bus_remove_device+0xe7/0xfc
[ 1320.927493]  [<ffffffff8128ada0>] ? device_del+0x120/0x176
[ 1320.927501]  [<ffffffffa0070025>] ? usb_disable_device+0x6a/0x180 [usbcore]
[ 1320.927509]  [<ffffffffa0069507>] ? usb_disconnect+0x79/0x151 [usbcore]
[ 1320.927515]  [<ffffffffa006abee>] ? hub_thread+0x60d/0xea2 [usbcore]
[ 1320.927518]  [<ffffffff8105b309>] ? abort_exclusive_wait+0x7f/0x7f
[ 1320.927524]  [<ffffffffa006a5e1>] ? hub_port_debounce+0xcf/0xcf [usbcore]
[ 1320.927526]  [<ffffffff8105a909>] ? kthread+0x81/0x89
[ 1320.927528]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[ 1320.927530]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
[ 1320.927532]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
