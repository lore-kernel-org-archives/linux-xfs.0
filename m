Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BE8SDj151398 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 08:08:28 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E028B1C5899
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:09:40 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id FeALlbCRQp6GrcZl for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:09:40 -0800 (PST)
Date: Thu, 11 Feb 2010 09:09:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Message-ID: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan>
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
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernl.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Hello,

While tarring and compressing (bzip2) a lot of files, the following error
occurred, note the output is not clean because this was taken from netconsole.

When this occurs, the host cannot be rebooted with reboot/proceses cannot
be killed and the box locks up.  There are no apparent hardware issues.

Before, asterisk would trigger this bug, since asterisk no longer runs on 
this host, it ran for ~2-3 months without any problems, until now.

Please cc me as I am not on the lists, thanks.

Is this a md raid issue or XFS? From the trace it appears to be an XFS bug?

Feb 11 07:38:14 l1 [   20.270270] e100: eth1 NIC Link is Up 100 Mbps Full Duplex 
Feb 11 07:47:54 l1 [  600.432165] INFO: task scp:4871 blocked for more than 120 seconds. 
Feb 11 07:47:54 l1 [  600.432177] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
Feb 11 07:47:54 l1 [  600.432182] scp           D
Feb 11 07:47:54 l1  ffff8801eee6f14c 
Feb 11 07:47:54 l1     0  4871   4870 0x00000000 
Feb 11 07:47:54 l1 [  600.432188]  ffff880220c87950
Feb 11 07:47:54 l1  0000000000000082
Feb 11 07:47:54 l1  0000000000200200
Feb 11 07:47:54 l1  ffff88023eb71400
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432196]  000000000000c928
Feb 11 07:47:54 l1  ffff8801f7a55fd8
Feb 11 07:47:54 l1  ffff880205fc6150
Feb 11 07:47:54 l1  ffff880205fc63c8
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432203]  0000000000001000
Feb 11 07:47:54 l1  ffffffff8108d02a
Feb 11 07:47:54 l1  ffff8801eee6f0c0
Feb 11 07:47:54 l1  ffff880205fc63c8
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432209] Call Trace: 
Feb 11 07:47:54 l1 [  600.432230]  [<ffffffff8108d02a>] ? generic_file_buffered_write+0x1aa/0x290 
Feb 11 07:47:54 l1 [  600.432236]  [<ffffffff8145f02d>] ? __down_write_nested+0x7d/0xb0 
Feb 11 07:47:54 l1 [  600.432242]  [<ffffffff8120387d>] ? xfs_write+0x23d/0x950 
Feb 11 07:47:54 l1 [  600.432250]  [<ffffffff810ba913>] ? do_sync_write+0xe3/0x130 
Feb 11 07:47:54 l1 [  600.432260]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30 
Feb 11 07:47:54 l1 [  600.432266]  [<ffffffff810e9654>] ? fsnotify+0x4/0x1a0 
Feb 11 07:47:54 l1 [  600.432271]  [<ffffffff8102f78e>] ? common_interrupt+0xe/0x13 
Feb 11 07:47:54 l1 [  600.432276]  [<ffffffff810bb45b>] ? vfs_write+0xcb/0x180 
Feb 11 07:47:54 l1 [  600.432280]  [<ffffffff810bb613>] ? sys_write+0x53/0xa0 
Feb 11 07:47:54 l1 [  600.432285]  [<ffffffff8102eeeb>] ? system_call_fastpath+0x16/0x1b 
Feb 11 07:47:54 l1 [  600.432291] INFO: task flush-9:3:4874 blocked for more than 120 seconds. 
Feb 11 07:47:54 l1 [  600.432294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
Feb 11 07:47:54 l1 [  600.432297] flush-9:3     D
Feb 11 07:47:54 l1  ffff88021948d750 
Feb 11 07:47:54 l1     0  4874      2 0x00000000 
Feb 11 07:47:54 l1 [  600.432309]  ffff88023fa3c8c0
Feb 11 07:47:54 l1  0000000000000046
Feb 11 07:47:54 l1  000000001948d750
Feb 11 07:47:54 l1  ffffffff8163d788
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432323]  000000000000c928
Feb 11 07:47:54 l1  ffff8801f79fbfd8
Feb 11 07:47:54 l1  ffff88021948d750
Feb 11 07:47:54 l1  ffff88021948d9c8
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432329]  000000013f467bb0
Feb 11 07:47:54 l1  ffffffff8108c183
Feb 11 07:47:54 l1  0000000000000000
Feb 11 07:47:54 l1  ffff88021948d9c8
Feb 11 07:47:54 l1 
Feb 11 07:47:54 l1 [  600.432337] Call Trace: 
Feb 11 07:47:54 l1 [  600.432341]  [<ffffffff8108c183>] ? find_lock_page+0x23/0x80 
Feb 11 07:47:54 l1 [  600.432344]  [<ffffffff8108cbb1>] ? find_or_create_page+0x41/0xc0 
Feb 11 07:47:54 l1 [  600.432349]  [<ffffffff8145dbc5>] ? schedule_timeout+0x195/0x1f0 
Feb 11 07:47:54 l1 [  600.432352]  [<ffffffff8145ea81>] ? __down+0x61/0xa0 
Feb 11 07:47:54 l1 [  600.432356]  [<ffffffff81072046>] ? down+0x46/0x50 
Feb 11 07:47:54 l1 [  600.432360]  [<ffffffff811ff4a4>] ? _xfs_buf_find+0x134/0x220 
Feb 11 07:47:54 l1 [  600.432363]  [<ffffffff811ff5fe>] ? xfs_buf_get_flags+0x6e/0x190 
Feb 11 07:47:54 l1 [  600.432366]  [<ffffffff811ff732>] ? xfs_buf_read_flags+0x12/0xa0 
Feb 11 07:47:54 l1 [  600.432371]  [<ffffffff811f5226>] ? xfs_trans_read_buf+0x1f6/0x350 
Feb 11 07:47:54 l1 [  600.432377]  [<ffffffff811b0268>] ? xfs_read_agf+0x68/0x190 
Feb 11 07:47:54 l1 [  600.432380]  [<ffffffff811b03c0>] ? xfs_alloc_read_agf+0x30/0xd0 
Feb 11 07:47:54 l1 [  600.432383]  [<ffffffff811b2519>] ? xfs_alloc_fix_freelist+0x379/0x450 
Feb 11 07:47:54 l1 [  600.432388]  [<ffffffff811ddfe5>] ? xfs_iext_remove+0x35/0x80 
Feb 11 07:47:54 l1 [  600.432393]  [<ffffffff811bd83f>] ? xfs_bmap_add_extent_delay_real+0x5ef/0x11a0 
Feb 11 07:47:54 l1 [  600.432396]  [<ffffffff811f4e73>] ? xfs_trans_log_buf+0x63/0xa0 
Feb 11 07:47:54 l1 [  600.432401]  [<ffffffff811e7410>] ? xlog_state_get_iclog_space+0x60/0x2c0 
Feb 11 07:47:54 l1 [  600.432404]  [<ffffffff8145f087>] ? __down_read+0x17/0xae 
Feb 11 07:47:54 l1 [  600.432408]  [<ffffffff811b29c0>] ? xfs_alloc_vextent+0x310/0x4b0 
Feb 11 07:47:54 l1 [  600.432412]  [<ffffffff811bf148>] ? xfs_bmap_btalloc+0x598/0xa40 
Feb 11 07:47:54 l1 [  600.432417]  [<ffffffff811c19a2>] ? xfs_bmapi+0x9e2/0x11a0 
Feb 11 07:47:54 l1 [  600.432422]  [<ffffffff811f3d4f>] ? xfs_trans_reserve+0x9f/0x210 
Feb 11 07:47:54 l1 [  600.432425]  [<ffffffff811e2efe>] ? xfs_iomap_write_allocate+0x23e/0x3b0 
Feb 11 07:47:54 l1 [  600.432429]  [<ffffffff811e3aa0>] ? xfs_iomap+0x2c0/0x300 
Feb 11 07:47:54 l1 [  600.432433]  [<ffffffff811fb875>] ? xfs_map_blocks+0x25/0x30 
Feb 11 07:47:54 l1 [  600.432437]  [<ffffffff811fc9a4>] ? xfs_page_state_convert+0x414/0x6c0 
Feb 11 07:47:54 l1 [  600.432443]  [<ffffffff81224463>] ? radix_tree_gang_lookup_tag_slot+0xc3/0xf0 
Feb 11 07:47:54 l1 [  600.432447]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130 
Feb 11 07:47:54 l1 [  600.432453]  [<ffffffff8109249a>] ? __writepage+0xa/0x40 
Feb 11 07:47:54 l1 [  600.432456]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0 
Feb 11 07:47:54 l1 [  600.432459]  [<ffffffff81092490>] ? __writepage+0x0/0x40 
Feb 11 07:47:54 l1 [  600.432464]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390 
Feb 11 07:47:54 l1 [  600.432468]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0 
Feb 11 07:47:54 l1 [  600.432473]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0 
Feb 11 07:47:54 l1 [  600.432479]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90 
Feb 11 07:47:54 l1 [  600.432484]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180 
Feb 11 07:47:54 l1 [  600.432487]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0 
Feb 11 07:47:54 l1 [  600.432492]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 
Feb 11 07:47:54 l1 [  600.432496]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0 
Feb 11 07:47:54 l1 [  600.432499]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 
Feb 11 07:47:54 l1 [  600.432503]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0 
Feb 11 07:47:54 l1 [  600.432508]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20 
Feb 11 07:47:54 l1 [  600.432513]  [<ffffffff8106da20>] ? kthread+0x0/0xa0 
Feb 11 07:47:54 l1 [  600.432517]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20 
Feb 11 07:49:54 l1 [  720.432171] INFO: task scp:4871 blocked for more than 120 seconds. 
Feb 11 07:49:54 l1 [  720.432187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
Feb 11 07:49:54 l1 [  720.432192] scp           D
Feb 11 07:49:54 l1  ffff8801eee6f14c 
Feb 11 07:49:54 l1     0  4871   4870 0x00000000 
Feb 11 07:49:54 l1 [  720.432198]  ffff880220c87950
Feb 11 07:49:54 l1  0000000000000082
Feb 11 07:49:54 l1  0000000000200200
Feb 11 07:49:54 l1  ffff88023eb71400
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432206]  000000000000c928
Feb 11 07:49:54 l1  ffff8801f7a55fd8
Feb 11 07:49:54 l1  ffff880205fc6150
Feb 11 07:49:54 l1  ffff880205fc63c8
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432217]  0000000000001000
Feb 11 07:49:54 l1  ffffffff8108d02a
Feb 11 07:49:54 l1  ffff8801eee6f0c0
Feb 11 07:49:54 l1  ffff880205fc63c8
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432224] Call Trace: 
Feb 11 07:49:54 l1 [  720.432238]  [<ffffffff8108d02a>] ? generic_file_buffered_write+0x1aa/0x290 
Feb 11 07:49:54 l1 [  720.432243]  [<ffffffff8145f02d>] ? __down_write_nested+0x7d/0xb0 
Feb 11 07:49:54 l1 [  720.432249]  [<ffffffff8120387d>] ? xfs_write+0x23d/0x950 
Feb 11 07:49:54 l1 [  720.432254]  [<ffffffff810ba913>] ? do_sync_write+0xe3/0x130 
Feb 11 07:49:54 l1 [  720.432259]  [<ffffffff8106dd90>] ? autoremove_wake_function+0x0/0x30 
Feb 11 07:49:54 l1 [  720.432265]  [<ffffffff810e9654>] ? fsnotify+0x4/0x1a0 
Feb 11 07:49:54 l1 [  720.432270]  [<ffffffff8102f78e>] ? common_interrupt+0xe/0x13 
Feb 11 07:49:54 l1 [  720.432275]  [<ffffffff810bb45b>] ? vfs_write+0xcb/0x180 
Feb 11 07:49:54 l1 [  720.432280]  [<ffffffff810bb613>] ? sys_write+0x53/0xa0 
Feb 11 07:49:54 l1 [  720.432285]  [<ffffffff8102eeeb>] ? system_call_fastpath+0x16/0x1b 
Feb 11 07:49:54 l1 [  720.432291] INFO: task flush-9:3:4874 blocked for more than 120 seconds. 
Feb 11 07:49:54 l1 [  720.432295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
Feb 11 07:49:54 l1 [  720.432298] flush-9:3     D
Feb 11 07:49:54 l1  ffff88021948d750 
Feb 11 07:49:54 l1     0  4874      2 0x00000000 
Feb 11 07:49:54 l1 [  720.432306]  ffff88023fa3c8c0
Feb 11 07:49:54 l1  0000000000000046
Feb 11 07:49:54 l1  000000001948d750
Feb 11 07:49:54 l1  ffffffff8163d788
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432322]  000000000000c928
Feb 11 07:49:54 l1  ffff8801f79fbfd8
Feb 11 07:49:54 l1  ffff88021948d750
Feb 11 07:49:54 l1  ffff88021948d9c8
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432329]  000000013f467bb0
Feb 11 07:49:54 l1  ffffffff8108c183
Feb 11 07:49:54 l1  0000000000000000
Feb 11 07:49:54 l1  ffff88021948d9c8
Feb 11 07:49:54 l1 
Feb 11 07:49:54 l1 [  720.432336] Call Trace: 
Feb 11 07:49:54 l1 [  720.432340]  [<ffffffff8108c183>] ? find_lock_page+0x23/0x80 
Feb 11 07:49:54 l1 [  720.432343]  [<ffffffff8108cbb1>] ? find_or_create_page+0x41/0xc0 
Feb 11 07:49:54 l1 [  720.432348]  [<ffffffff8145dbc5>] ? schedule_timeout+0x195/0x1f0 
Feb 11 07:49:54 l1 [  720.432351]  [<ffffffff8145ea81>] ? __down+0x61/0xa0 
Feb 11 07:49:54 l1 [  720.432356]  [<ffffffff81072046>] ? down+0x46/0x50 
Feb 11 07:49:54 l1 [  720.432361]  [<ffffffff811ff4a4>] ? _xfs_buf_find+0x134/0x220 
Feb 11 07:49:54 l1 [  720.432365]  [<ffffffff811ff5fe>] ? xfs_buf_get_flags+0x6e/0x190 
Feb 11 07:49:54 l1 [  720.432368]  [<ffffffff811ff732>] ? xfs_buf_read_flags+0x12/0xa0 
Feb 11 07:49:54 l1 [  720.432373]  [<ffffffff811f5226>] ? xfs_trans_read_buf+0x1f6/0x350 
Feb 11 07:49:54 l1 [  720.432378]  [<ffffffff811b0268>] ? xfs_read_agf+0x68/0x190 
Feb 11 07:49:54 l1 [  720.432382]  [<ffffffff811b03c0>] ? xfs_alloc_read_agf+0x30/0xd0 
Feb 11 07:49:54 l1 [  720.432386]  [<ffffffff811b2519>] ? xfs_alloc_fix_freelist+0x379/0x450 
Feb 11 07:49:54 l1 [  720.432391]  [<ffffffff811ddfe5>] ? xfs_iext_remove+0x35/0x80 
Feb 11 07:49:54 l1 [  720.432396]  [<ffffffff811bd83f>] ? xfs_bmap_add_extent_delay_real+0x5ef/0x11a0 
Feb 11 07:49:54 l1 [  720.432399]  [<ffffffff811f4e73>] ? xfs_trans_log_buf+0x63/0xa0 
Feb 11 07:49:54 l1 [  720.432404]  [<ffffffff811e7410>] ? xlog_state_get_iclog_space+0x60/0x2c0 
Feb 11 07:49:54 l1 [  720.432410]  [<ffffffff8145f087>] ? __down_read+0x17/0xae 
Feb 11 07:49:54 l1 [  720.432415]  [<ffffffff811b29c0>] ? xfs_alloc_vextent+0x310/0x4b0 
Feb 11 07:49:54 l1 [  720.432420]  [<ffffffff811bf148>] ? xfs_bmap_btalloc+0x598/0xa40 
Feb 11 07:49:54 l1 [  720.432426]  [<ffffffff811c19a2>] ? xfs_bmapi+0x9e2/0x11a0 
Feb 11 07:49:54 l1 [  720.432430]  [<ffffffff811f3d4f>] ? xfs_trans_reserve+0x9f/0x210 
Feb 11 07:49:54 l1 [  720.432434]  [<ffffffff811e2efe>] ? xfs_iomap_write_allocate+0x23e/0x3b0 
Feb 11 07:49:54 l1 [  720.432437]  [<ffffffff811e3aa0>] ? xfs_iomap+0x2c0/0x300 
Feb 11 07:49:54 l1 [  720.432441]  [<ffffffff811fb875>] ? xfs_map_blocks+0x25/0x30 
Feb 11 07:49:54 l1 [  720.432445]  [<ffffffff811fc9a4>] ? xfs_page_state_convert+0x414/0x6c0 
Feb 11 07:49:54 l1 [  720.432451]  [<ffffffff81224463>] ? radix_tree_gang_lookup_tag_slot+0xc3/0xf0 
Feb 11 07:49:54 l1 [  720.432455]  [<ffffffff811fcf57>] ? xfs_vm_writepage+0x77/0x130 
Feb 11 07:49:54 l1 [  720.432459]  [<ffffffff8109249a>] ? __writepage+0xa/0x40 
Feb 11 07:49:54 l1 [  720.432462]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0 
Feb 11 07:49:54 l1 [  720.432466]  [<ffffffff81092490>] ? __writepage+0x0/0x40 
Feb 11 07:49:54 l1 [  720.432472]  [<ffffffff810d9092>] ? writeback_single_inode+0xd2/0x390 
Feb 11 07:49:54 l1 [  720.432476]  [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0 
Feb 11 07:49:54 l1 [  720.432480]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0 
Feb 11 07:49:54 l1 [  720.432485]  [<ffffffff810630ee>] ? try_to_del_timer_sync+0x5e/0x90 
Feb 11 07:49:54 l1 [  720.432489]  [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180 
Feb 11 07:49:54 l1 [  720.432493]  [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0 
Feb 11 07:49:54 l1 [  720.432497]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 
Feb 11 07:49:54 l1 [  720.432500]  [<ffffffff8109e97e>] ? bdi_start_fn+0x7e/0xf0 
Feb 11 07:49:54 l1 [  720.432503]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 
Feb 11 07:49:54 l1 [  720.432506]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0 
Feb 11 07:49:54 l1 [  720.432511]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20 
Feb 11 07:49:54 l1 [  720.432515]  [<ffffffff8106da20>] ? kthread+0x0/0xa0 
Feb 11 07:49:54 l1 [  720.432519]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
