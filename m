Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CF017F4E
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 04:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 876C1AC002
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 02:25:19 -0700 (PDT)
Received: from smtp2.ispfabriek.nl (smtp2.ispfabriek.nl [37.251.0.169]) by
	cuda.sgi.com with ESMTP id 7ORQlNXYMF6eYPjW for
	<xfs@oss.sgi.com>; Mon, 24 Mar 2014 02:25:09 -0700 (PDT)
Received: from localhost (unknown [10.3.1.68])
	by smtp2.ispfabriek.nl (Postfix) with ESMTP id 1510E13EDA5
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 09:25:09 +0000 (UTC)
Received: from smtp2.ispfabriek.nl ([10.3.1.141])
	by localhost (mailscan2.ispfabriek.nl [10.3.1.68]) (amavisd-new,
	port 10026) with ESMTP id Cc-iuX5tPjpl for <xfs@oss.sgi.com>;
	Mon, 24 Mar 2014 10:24:50 +0100 (CET)
Received: from mailserver.verbraak.thuis (188-142-103-130.FTTH.ispfabriek.nl
	[188.142.103.130])
	by smtp2.ispfabriek.nl (Postfix) with ESMTP id 853BA13EE48
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 10:24:50 +0100 (CET)
Received: from [10.242.43.6] ([10.242.43.6])
	by mailserver.verbraak.thuis (8.14.7/8.14.5) with ESMTP id
	s2OAOwmx004929 for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 11:24:58 +0100
Message-ID: <532FF9DD.5080700@1st-setup.nl>
Date: Mon, 24 Mar 2014 10:24:45 +0100
From: "Michel Verbraak(1st-Setup)" <info@1st-setup.nl>
MIME-Version: 1.0
Subject: xfs blocks (blocked for more than 120 seconds)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6464325953409917436=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============6464325953409917436==
Content-Type: multipart/alternative;
 boundary="------------020709070101020901020602"

This is a multi-part message in MIME format.
--------------020709070101020901020602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

We have a problem with one of our systems which is using XFS but we are
unable to find the problem. Recently we had two moments, Tuesday 4th of
March and Friday the 21st of March, where we had to reboot the system to
get it up and running again.

What happens:
- The programs handling files on the XFS disc stop working when
creating, deleting or writing files. They do not error they are just
waiting on the command to complete.
- One of our programs, a java application, goes into very high cpu usage
(50%) which normally is at 1%. This could be something in our java
application but it happens at the moment handling files gets stuck.
- A nice restart of the programs does not succeed as wel a kill -9 does
not work.
- Trying to reboot the servers in a normal fashion does not work. As it
is a virtual machine we have to do a shutdown (unplug power) and start
it up again to get it up and running.

Following details I have for you:

System OS: Ubuntu 12.04 LTS
Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux
Server: Virtual machine in a VMWare setup.
Disc: 300GB direct attached LUN

We have an exact clone of this system for our acceptance environment. In
this environment we are unable to reproduce this problem/situation.

Differences between the two days is that our services on 2014-03-21 were
quit busy with a lot of file changes on the xfs disc and on 2014-03-04
the system was very quiet on the moment the kernel traces appear and the
services get stuck.

Any help is appreciated.

Regards Michel Verbraak.

Following we see in the syslog on both moments (2014-03-04 and 2014-03-21):

Mar 21 06:32:20 ealxs00169 kernel: [1412280.930340] INFO: task
flush-8:16:13864 blocked for more than 120 seconds.
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930462] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543] flush-8:16      D
0000000000000000     0 13864      2 0x00000000
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930549]  ffff88000676f880
0000000000000046 0000000001000000 2500000000000000
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930557]  ffff88000676ffd8
ffff88000676ffd8 ffff88000676ffd8 00000000000137c0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930560]  ffff880002218000
ffff88001b5d4500 ffff88000676f850 ffff88001fc14080
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930564] Call Trace:
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930584] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930602] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930605] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930608] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930617] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930620] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930626] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930634] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930638] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930641] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930644] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930701] 
[<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930708] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930719] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930722] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930725] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930728] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930739] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930744] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930747] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930751] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930757] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930762] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930765] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930768] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930775] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930778] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar 21 06:32:20 ealxs00169 kernel: [1412280.930781] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891012] INFO: task
archiver.pl:4005 blocked for more than 120 seconds.
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891118] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181] archiver.pl     D
0000000000000000     0  4005   4004 0x00000000
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891186]  ffff88001bb41718
0000000000000086 ffffffff8142bff0 0000000000000002
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891189]  ffff88001bb41fd8
ffff88001bb41fd8 ffff88001bb41fd8 00000000000137c0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891192]  ffff88001bad8000
ffff88000602dc00 ffff88001bb41798 7fffffffffffffff
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891195] Call Trace:
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891223] 
[<ffffffff8142bff0>] ? scsi_mode_select+0x200/0x200
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891227] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891229] 
[<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891234] 
[<ffffffff8165c5f0>] __down_common+0xa5/0xf5
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891291] 
[<ffffffffa007c295>] ? _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891294] 
[<ffffffff8165c6b3>] __down+0x1d/0x1f
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891301] 
[<ffffffff810912e1>] down+0x41/0x50
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891314] 
[<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891324] 
[<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891335] 
[<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891345] 
[<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891373] 
[<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891386] 
[<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891399] 
[<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891411] 
[<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891418] 
[<ffffffff8116371b>] ? kfree+0x3b/0x140
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891421] 
[<ffffffff8116355f>] ? kmem_cache_free+0x2f/0x110
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891432] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891447] 
[<ffffffffa00cb2f8>] ? xfs_perag_get+0x38/0xd0 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891460] 
[<ffffffffa00967f1>] ? xfs_free_extent+0x91/0x120 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891473] 
[<ffffffffa0096802>] xfs_free_extent+0xa2/0x120 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891486] 
[<ffffffffa00a6e14>] xfs_bmap_finish+0x164/0x1b0 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891501] 
[<ffffffffa00c143b>] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891516] 
[<ffffffffa00c15a6>] xfs_itruncate_data+0x66/0x150 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891529] 
[<ffffffffa009056e>] xfs_inactive+0x2fe/0x460 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891532] 
[<ffffffff8165d545>] ? _raw_spin_lock_irq+0x15/0x20
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891543] 
[<ffffffffa008afad>] xfs_fs_evict_inode+0xad/0x110 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891547] 
[<ffffffff81193e98>] evict+0xb8/0x1c0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891550] 
[<ffffffff81194088>] iput_final+0xe8/0x210
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891552] 
[<ffffffff811941ee>] iput+0x3e/0x50
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891555] 
[<ffffffff81188be3>] do_unlinkat+0x153/0x1d0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891561] 
[<ffffffff8117974d>] ? vfs_read+0x10d/0x180
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891564] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891568] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891571] INFO: task
flush-8:16:13864 blocked for more than 120 seconds.
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891626] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891686] flush-8:16      D
0000000000000000     0 13864      2 0x00000000
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891689]  ffff88000676f880
0000000000000046 0000000001000000 2500000000000000
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891692]  ffff88000676ffd8
ffff88000676ffd8 ffff88000676ffd8 00000000000137c0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891694]  ffff880002218000
ffff88001b5d4500 ffff88000676f850 ffff88001fc14080
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891697] Call Trace:
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891702] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891704] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891710] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891712] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891714] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891717] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891720] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891725] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891727] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891730] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891732] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891742] 
[<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891745] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891749] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891751] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891754] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891756] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891760] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891763] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891765] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891768] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891772] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891774] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891777] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891779] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891782] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891784] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar 21 06:34:20 ealxs00169 kernel: [1412400.891787] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861122] INFO: task
java:14629 blocked for more than 120 seconds.
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861204] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861471] java            D
0000000000000000     0 14629   1788 0x00000000
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861476]  ffff8800028e9328
0000000000000086 0000000000000100 0000000000000100
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861481]  ffff8800028e9fd8
ffff8800028e9fd8 ffff8800028e9fd8 00000000000137c0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861483]  ffff88001a9a4500
ffff88001b5e8000 ffff8800028e9308 7fffffffffffffff
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861487] Call Trace:
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861500] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861502] 
[<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861514] 
[<ffffffff8101aef2>] ? nommu_map_sg+0x72/0xe0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861522] 
[<ffffffff8142bff0>] ? scsi_mode_select+0x200/0x200
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861526] 
[<ffffffff8165c5f0>] __down_common+0xa5/0xf5
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861581] 
[<ffffffffa007c295>] ? _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861583] 
[<ffffffff8165c6b3>] __down+0x1d/0x1f
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861588] 
[<ffffffff810912e1>] down+0x41/0x50
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861598] 
[<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861608] 
[<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861618] 
[<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861626] 
[<ffffffff8105702d>] ? set_next_entity+0xad/0xd0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861637] 
[<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861656] 
[<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861670] 
[<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861684] 
[<ffffffffa00a0c93>] ? xfs_bmap_add_extent_hole_delay+0xd3/0x6b0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861697] 
[<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861711] 
[<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861725] 
[<ffffffffa00aa368>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861730] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861732] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861748] 
[<ffffffffa00cb2f8>] ? xfs_perag_get+0x38/0xd0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861762] 
[<ffffffffa009fe23>] ? xfs_bmap_btalloc_nullfb+0x193/0x380 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861776] 
[<ffffffffa0096b6c>] ? xfs_alloc_vextent+0x2ec/0x690 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861792] 
[<ffffffffa0096a4b>] xfs_alloc_vextent+0x1cb/0x690 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861806] 
[<ffffffffa00a02c1>] xfs_bmap_btalloc+0x2b1/0x770 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861821] 
[<ffffffffa00c21dc>] ? xfs_iext_bno_to_ext+0x8c/0x160 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861836] 
[<ffffffffa00a07a4>] xfs_bmap_alloc+0x24/0x40 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861849] 
[<ffffffffa00a594e>] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861864] 
[<ffffffffa00a85c3>] xfs_bmapi_write+0x4c3/0x720 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861876] 
[<ffffffffa0086988>] xfs_iomap_write_allocate+0x178/0x330 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861886] 
[<ffffffffa00799c3>] xfs_map_blocks+0x183/0x250 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861895] 
[<ffffffffa007aa56>] xfs_vm_writepage+0x196/0x510 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861901] 
[<ffffffff81122217>] __writepage+0x17/0x40
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861903] 
[<ffffffff81122a0d>] write_cache_pages+0x20d/0x460
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861922] 
[<ffffffff8152ba7d>] ? sock_recvmsg+0x11d/0x140
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861925] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861935] 
[<ffffffffa00804bc>] ? xfs_file_aio_write+0x25c/0x2a0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861938] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861948] 
[<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861951] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861955] 
[<ffffffff81119f2b>] __filemap_fdatawrite_range+0x5b/0x60
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861958] 
[<ffffffff81119f82>] filemap_write_and_wait_range+0x52/0x80
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861968] 
[<ffffffffa007f05d>] xfs_file_fsync+0x5d/0x300 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861972] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861977] 
[<ffffffff811a7eb6>] do_fsync+0x56/0x80
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861979] 
[<ffffffff811a81e0>] sys_fsync+0x10/0x20
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861983] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:36:20 ealxs00169 kernel: [1412520.861989] INFO: task
archiver.pl:4005 blocked for more than 120 seconds.
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862047] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862112] archiver.pl     D
0000000000000000     0  4005   4004 0x00000000
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862115]  ffff88001bb41718
0000000000000086 ffffffff8142bff0 0000000000000002
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862118]  ffff88001bb41fd8
ffff88001bb41fd8 ffff88001bb41fd8 00000000000137c0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862121]  ffff88001bad8000
ffff88000602dc00 ffff88001bb41798 7fffffffffffffff
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862123] Call Trace:
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862126] 
[<ffffffff8142bff0>] ? scsi_mode_select+0x200/0x200
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862133] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862135] 
[<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862138] 
[<ffffffff8165c5f0>] __down_common+0xa5/0xf5
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862149] 
[<ffffffffa007c295>] ? _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862151] 
[<ffffffff8165c6b3>] __down+0x1d/0x1f
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862154] 
[<ffffffff810912e1>] down+0x41/0x50
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862164] 
[<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862173] 
[<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862183] 
[<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862193] 
[<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862210] 
[<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862223] 
[<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862236] 
[<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862250] 
[<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862255] 
[<ffffffff8116371b>] ? kfree+0x3b/0x140
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862258] 
[<ffffffff8116355f>] ? kmem_cache_free+0x2f/0x110
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862260] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862277] 
[<ffffffffa00cb2f8>] ? xfs_perag_get+0x38/0xd0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862290] 
[<ffffffffa00967f1>] ? xfs_free_extent+0x91/0x120 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862303] 
[<ffffffffa0096802>] xfs_free_extent+0xa2/0x120 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862317] 
[<ffffffffa00a6e14>] xfs_bmap_finish+0x164/0x1b0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862333] 
[<ffffffffa00c143b>] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862349] 
[<ffffffffa00c15a6>] xfs_itruncate_data+0x66/0x150 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862365] 
[<ffffffffa009056e>] xfs_inactive+0x2fe/0x460 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862368] 
[<ffffffff8165d545>] ? _raw_spin_lock_irq+0x15/0x20
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862380] 
[<ffffffffa008afad>] xfs_fs_evict_inode+0xad/0x110 [xfs]
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862385] 
[<ffffffff81193e98>] evict+0xb8/0x1c0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862387] 
[<ffffffff81194088>] iput_final+0xe8/0x210
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862389] 
[<ffffffff811941ee>] iput+0x3e/0x50
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862392] 
[<ffffffff81188be3>] do_unlinkat+0x153/0x1d0
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862396] 
[<ffffffff8117974d>] ? vfs_read+0x10d/0x180
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862399] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:36:20 ealxs00169 kernel: [1412520.862401] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:38:20 ealxs00169 kernel: [1412640.820901] INFO: task java:1804
blocked for more than 120 seconds.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.820972] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821037] java            D
0000000000000000     0  1804   1788 0x00000000
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821042]  ffff88001b4b3de8
0000000000000086 ffff88001b4b3da8 ffffffffa008d944
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821045]  ffff88001b4b3fd8
ffff88001b4b3fd8 ffff88001b4b3fd8 00000000000137c0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821048]  ffff88001a749700
ffff88001c61ae00 0000000000000000 ffff8800002f38a0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821051] Call Trace:
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821116] 
[<ffffffffa008d944>] ? xfs_inode_set_reclaim_tag+0x84/0xa0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821122] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821126] 
[<ffffffff8165c157>] __mutex_lock_slowpath+0xd7/0x150
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821131] 
[<ffffffff81188731>] ? do_path_lookup+0x31/0xc0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821134] 
[<ffffffff8165bd6a>] mutex_lock+0x2a/0x50
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821136] 
[<ffffffff81188b1e>] do_unlinkat+0x8e/0x1d0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821140] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821145] 
[<ffffffff81015721>] ? math_state_restore+0x51/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821148] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821152] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821154] INFO: task java:1805
blocked for more than 120 seconds.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821207] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821301] java            D
0000000000000000     0  1805   1788 0x00000000
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821309]  ffff88001f4a17e8
0000000000000086 0000000000000000 ffff88001f5f1410
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821312]  ffff88001f4a1fd8
ffff88001f4a1fd8 ffff88001f4a1fd8 00000000000137c0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821314]  ffff88001bad8000
ffff88001c61dc00 000000000000003a 7fffffffffffffff
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821317] Call Trace:
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821320] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821322] 
[<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821327] 
[<ffffffff81165a1d>] ? kmem_cache_alloc+0x11d/0x140
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821342] 
[<ffffffffa00927b7>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821345] 
[<ffffffff8165c5f0>] __down_common+0xa5/0xf5
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821355] 
[<ffffffffa007c295>] ? _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821358] 
[<ffffffff8165c6b3>] __down+0x1d/0x1f
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821362] 
[<ffffffff810912e1>] down+0x41/0x50
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821372] 
[<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821382] 
[<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821392] 
[<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821402] 
[<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821420] 
[<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821434] 
[<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821446] 
[<ffffffffa00925e7>] ? kmem_alloc+0x67/0xe0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821459] 
[<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821473] 
[<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821483] 
[<ffffffffa007c42d>] ? xfs_buf_unlock+0x2d/0xa0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821487] 
[<ffffffff8116355f>] ? kmem_cache_free+0x2f/0x110
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821491] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821508] 
[<ffffffffa00cb2f8>] ? xfs_perag_get+0x38/0xd0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821521] 
[<ffffffffa00967f1>] ? xfs_free_extent+0x91/0x120 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821539] 
[<ffffffffa0096802>] xfs_free_extent+0xa2/0x120 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821553] 
[<ffffffffa00a6e14>] xfs_bmap_finish+0x164/0x1b0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821566] 
[<ffffffffa00914c1>] xfs_remove+0x351/0x400 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821569] 
[<ffffffff8165d25e>] ? _raw_spin_lock+0xe/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821580] 
[<ffffffffa0087378>] xfs_vn_unlink+0x48/0x90 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821583] 
[<ffffffff81186520>] vfs_unlink.part.26+0x80/0xf0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821585] 
[<ffffffff811865cc>] vfs_unlink+0x3c/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821587] 
[<ffffffff81188c3a>] do_unlinkat+0x1aa/0x1d0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821590] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821593] 
[<ffffffff81015721>] ? math_state_restore+0x51/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821595] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821598] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821600] INFO: task java:1806
blocked for more than 120 seconds.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821668] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821760] java            D
0000000000000000     0  1806   1788 0x00000000
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821767]  ffff88001f741de8
0000000000000086 ffff88001f741da8 ffffffffa008d944
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821770]  ffff88001f741fd8
ffff88001f741fd8 ffff88001f741fd8 00000000000137c0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821772]  ffff88001c61ae00
ffff88001b9adc00 0000000000000000 ffff8800002f38a0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821775] Call Trace:
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821788] 
[<ffffffffa008d944>] ? xfs_inode_set_reclaim_tag+0x84/0xa0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821790] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821793] 
[<ffffffff8165c157>] __mutex_lock_slowpath+0xd7/0x150
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821795] 
[<ffffffff81188731>] ? do_path_lookup+0x31/0xc0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821797] 
[<ffffffff8165bd6a>] mutex_lock+0x2a/0x50
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821799] 
[<ffffffff81188b1e>] do_unlinkat+0x8e/0x1d0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821802] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821805] 
[<ffffffff81015721>] ? math_state_restore+0x51/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821807] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821809] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821812] INFO: task java:1807
blocked for more than 120 seconds.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821878] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821971] java            D
0000000000000000     0  1807   1788 0x00000000
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821977]  ffff88001f7fdde8
0000000000000086 ffff88001f7fdda8 ffffffffa008d944
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821980]  ffff88001f7fdfd8
ffff88001f7fdfd8 ffff88001f7fdfd8 00000000000137c0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821983]  ffff88001b9adc00
ffff88001b9a8000 0000000000000000 ffff8800002f38a0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821985] Call Trace:
Mar 21 06:38:20 ealxs00169 kernel: [1412640.821998] 
[<ffffffffa008d944>] ? xfs_inode_set_reclaim_tag+0x84/0xa0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822001] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822003] 
[<ffffffff8165c157>] __mutex_lock_slowpath+0xd7/0x150
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822005] 
[<ffffffff81188731>] ? do_path_lookup+0x31/0xc0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822007] 
[<ffffffff8165bd6a>] mutex_lock+0x2a/0x50
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822010] 
[<ffffffff81188b1e>] do_unlinkat+0x8e/0x1d0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822012] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822015] 
[<ffffffff81015721>] ? math_state_restore+0x51/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822017] 
[<ffffffff811897b6>] sys_unlink+0x16/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822020] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822022] INFO: task
java:14629 blocked for more than 120 seconds.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822090] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822183] java            D
0000000000000000     0 14629   1788 0x00000000
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822186]  ffff8800028e9328
0000000000000086 0000000000000100 0000000000000100
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822189]  ffff8800028e9fd8
ffff8800028e9fd8 ffff8800028e9fd8 00000000000137c0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822191]  ffff88001a9a4500
ffff88001b5e8000 ffff8800028e9308 7fffffffffffffff
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822194] Call Trace:
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822196] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822199] 
[<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822203] 
[<ffffffff8101aef2>] ? nommu_map_sg+0x72/0xe0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822216] 
[<ffffffff8142bff0>] ? scsi_mode_select+0x200/0x200
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822220] 
[<ffffffff8165c5f0>] __down_common+0xa5/0xf5
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822234] 
[<ffffffffa007c295>] ? _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822237] 
[<ffffffff8165c6b3>] __down+0x1d/0x1f
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822241] 
[<ffffffff810912e1>] down+0x41/0x50
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822252] 
[<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822262] 
[<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822272] 
[<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822276] 
[<ffffffff8105702d>] ? set_next_entity+0xad/0xd0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822285] 
[<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822302] 
[<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822315] 
[<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822329] 
[<ffffffffa00a0c93>] ? xfs_bmap_add_extent_hole_delay+0xd3/0x6b0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822342] 
[<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822355] 
[<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822369] 
[<ffffffffa00aa368>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822372] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822374] 
[<ffffffff8131214b>] ? radix_tree_lookup+0xb/0x10
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822390] 
[<ffffffffa00cb2f8>] ? xfs_perag_get+0x38/0xd0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822403] 
[<ffffffffa009fe23>] ? xfs_bmap_btalloc_nullfb+0x193/0x380 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822417] 
[<ffffffffa0096b6c>] ? xfs_alloc_vextent+0x2ec/0x690 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822430] 
[<ffffffffa0096a4b>] xfs_alloc_vextent+0x1cb/0x690 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822443] 
[<ffffffffa00a02c1>] xfs_bmap_btalloc+0x2b1/0x770 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822459] 
[<ffffffffa00c21dc>] ? xfs_iext_bno_to_ext+0x8c/0x160 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822473] 
[<ffffffffa00a07a4>] xfs_bmap_alloc+0x24/0x40 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822486] 
[<ffffffffa00a594e>] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822500] 
[<ffffffffa00a85c3>] xfs_bmapi_write+0x4c3/0x720 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822512] 
[<ffffffffa0086988>] xfs_iomap_write_allocate+0x178/0x330 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822522] 
[<ffffffffa00799c3>] xfs_map_blocks+0x183/0x250 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822531] 
[<ffffffffa007aa56>] xfs_vm_writepage+0x196/0x510 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822536] 
[<ffffffff81122217>] __writepage+0x17/0x40
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822538] 
[<ffffffff81122a0d>] write_cache_pages+0x20d/0x460
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822542] 
[<ffffffff8152ba7d>] ? sock_recvmsg+0x11d/0x140
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822544] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822554] 
[<ffffffffa00804bc>] ? xfs_file_aio_write+0x25c/0x2a0 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822557] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822566] 
[<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822569] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822573] 
[<ffffffff81119f2b>] __filemap_fdatawrite_range+0x5b/0x60
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822575] 
[<ffffffff81119f82>] filemap_write_and_wait_range+0x52/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822585] 
[<ffffffffa007f05d>] xfs_file_fsync+0x5d/0x300 [xfs]
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822588] 
[<ffffffff8118c985>] ? poll_select_set_timeout+0x85/0xa0
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822593] 
[<ffffffff811a7eb6>] do_fsync+0x56/0x80
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822595] 
[<ffffffff811a81e0>] sys_fsync+0x10/0x20
Mar 21 06:38:20 ealxs00169 kernel: [1412640.822597] 
[<ffffffff81665842>] system_call_fastpath+0x16/0x1b

>From this moment on the services are not working anymore. Complete stuck.

Mar  4 19:39:25 ealxs00169 kernel: [34229278.392177] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392400] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392474] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392478]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392487]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392489]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392492] Call Trace:
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392510] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392523] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392526] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392528] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392536] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392539] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392544] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392551] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392554] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392556] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392559] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392621] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392627] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392636] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392639] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392641] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392644] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392654] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392658] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392661] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392664] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392669] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392671] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392674] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392676] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392682] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392685] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:39:25 ealxs00169 kernel: [34229278.392687] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350796] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350923] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350987] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350991]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350995]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.350998]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351001] Call Trace:
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351017] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351022] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351024] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351027] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351030] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351033] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351039] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351044] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351047] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351049] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351052] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351093] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351096] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351101] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351104] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351106] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351109] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351113] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351117] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351120] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351123] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351128] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351130] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351133] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351135] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351140] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351142] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:41:25 ealxs00169 kernel: [34229398.351145] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317264] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317367] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317436] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317443]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317447]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317450]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317453] Call Trace:
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317467] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317472] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317474] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317477] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317480] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317483] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317488] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317493] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317496] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317498] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317501] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317596] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317600] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317606] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317609] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317611] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317614] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317620] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317624] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317627] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317630] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317648] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317651] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317654] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317657] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317661] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317664] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:43:25 ealxs00169 kernel: [34229518.317666] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275799] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275894] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275957] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275962]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275969]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275971]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275975] Call Trace:
Mar  4 19:45:25 ealxs00169 kernel: [34229638.275993] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276006] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276008] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276011] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276018] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276021] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276029] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276036] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276039] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276042] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276044] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276084] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276090] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276099] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276102] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276105] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276107] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276117] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276121] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276124] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276127] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276132] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276135] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276137] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276140] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276146] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276148] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:45:25 ealxs00169 kernel: [34229638.276151] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246364] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246439] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246501] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246505]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246509]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246512]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246515] Call Trace:
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246527] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246532] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246534] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246537] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246540] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246543] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246548] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246554] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246556] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246559] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246561] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246622] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246626] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246631] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246633] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246636] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246638] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246644] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246648] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246650] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246653] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246658] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246661] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246663] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246665] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246670] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246672] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:47:25 ealxs00169 kernel: [34229758.246675] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204689] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204764] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204827] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204834]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204838]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204841]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204844] Call Trace:
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204865] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204870] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204872] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204875] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204878] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204880] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204886] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204891] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204893] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204896] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204898] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204956] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204960] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204965] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204967] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204970] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204972] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204976] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204980] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204982] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204985] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204990] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204993] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204995] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.204997] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.205002] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:49:25 ealxs00169 kernel: [34229878.205004] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:49:25 ealxs00169 kernel: [34229878.205007] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176219] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176491] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176614] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176618]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176622]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176625]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176628] Call Trace:
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176640] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176645] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176647] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176649] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176652] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176655] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176661] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176666] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176668] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176671] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176673] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176746] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176750] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176756] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176759] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176762] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176764] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176769] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176773] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176776] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176779] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176784] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176786] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176789] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176791] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176796] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176798] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:51:25 ealxs00169 kernel: [34229998.176801] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139419] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139541] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139635] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139639]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139643]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139646]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139649] Call Trace:
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139665] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139671] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139673] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139676] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139679] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139681] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139687] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139693] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139695] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139698] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139700] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139759] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139762] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139767] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139770] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139773] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139775] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139781] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139785] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139787] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139791] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139796] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139798] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139801] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139803] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139808] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139810] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:53:25 ealxs00169 kernel: [34230118.139813] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105607] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105721] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105812] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105817]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105823]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105826]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105829] Call Trace:
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105848] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105860] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105862] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105865] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105872] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105875] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105881] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105887] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105890] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105892] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105895] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105965] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105971] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105980] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105983] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105986] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105988] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:55:25 ealxs00169 kernel: [34230238.105998] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106003] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106005] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106009] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106014] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106016] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106019] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106021] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106027] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106030] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:55:25 ealxs00169 kernel: [34230238.106032] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082371] INFO: task
flush-8:16:20760 blocked for more than 120 seconds.
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082468] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082560] flush-8:16      D
0000000000000000     0 20760      2 0x00000000
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082564]  ffff8800148af880
0000000000000046 ffff8800148afbf0 0000000000000000
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082568]  ffff8800148affd8
ffff8800148affd8 ffff8800148affd8 00000000000137c0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082571]  ffff8800022a4500
ffff8800022a1700 ffff8800148af850 ffff88001fc14080
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082573] Call Trace:
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082594] 
[<ffffffff81118360>] ? __lock_page+0x70/0x70
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082599] 
[<ffffffff8165b34f>] schedule+0x3f/0x60
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082601] 
[<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082604] 
[<ffffffff8111836e>] sleep_on_page+0xe/0x20
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082607] 
[<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082609] 
[<ffffffff81118357>] __lock_page+0x67/0x70
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082615] 
[<ffffffff8108bd60>] ? autoremove_wake_function+0x40/0x40
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082620] 
[<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082623] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082625] 
[<ffffffff81122200>] ? set_page_dirty_lock+0x60/0x60
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082627] 
[<ffffffff81122caa>] generic_writepages+0x4a/0x70
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082677] 
[<ffffffffa008d80d>] xfs_vm_writepages+0x4d/0x60 [xfs]
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082681] 
[<ffffffff81123b71>] do_writepages+0x21/0x40
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082687] 
[<ffffffff811a2990>] writeback_single_inode+0x180/0x430
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082689] 
[<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082692] 
[<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082694] 
[<ffffffff811a345b>] wb_writeback+0x27b/0x330
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082700] 
[<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082705] 
[<ffffffff81194ad2>] ? get_nr_dirty_inodes+0x52/0x80
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082707] 
[<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082713] 
[<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082719] 
[<ffffffff810778b0>] ? usleep_range+0x50/0x50
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082721] 
[<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082723] 
[<ffffffff811a4500>] ? wb_do_writeback+0x1d0/0x1d0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082726] 
[<ffffffff8108b27c>] kthread+0x8c/0xa0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082731] 
[<ffffffff816679b4>] kernel_thread_helper+0x4/0x10
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082733] 
[<ffffffff8108b1f0>] ? flush_kthread_worker+0xa0/0xa0
Mar  4 19:57:25 ealxs00169 kernel: [34230358.082736] 
[<ffffffff816679b0>] ? gs_change+0x13/0x13


--------------020709070101020901020602
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#666666" bgcolor="#FFFFFF">
    <font size="-1"><font face="DejaVu Sans">Hi,<br>
        <br>
        We have a problem with one of our systems which is using XFS but
        we are unable to find the problem. Recently we had two moments,
        Tuesday 4th of March and Friday the 21st of March, where we had
        to reboot the system to get it up and running again.<br>
        <br>
        What happens:<br>
        - The programs handling files on the XFS disc stop working when
        creating, deleting or writing files. They do not error they are
        just waiting on the command to complete.<br>
        - One of our programs, a java application, goes into very high
        cpu usage (50%) which normally is at 1%. This could be something
        in our java application but it happens at the moment handling
        files gets stuck.<br>
        - A nice restart of the programs does not succeed as wel a kill
        -9 does not work.<br>
        - Trying to reboot the servers in a normal fashion does not
        work. As it is a virtual machine we have to do a shutdown
        (unplug power) and start it up again to get it up and running.<br>
        <br>
        Following details I have for you:<br>
        <br>
        System OS: Ubuntu 12.04 LTS<br>
        Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC
        2013 x86_64 x86_64 x86_64 GNU/Linux<br>
        Server: Virtual machine in a VMWare setup.<br>
        Disc: 300GB direct attached LUN<br>
        <br>
        We have an exact clone of this system for our acceptance
        environment. In this environment we are unable to reproduce this
        problem/situation.<br>
        <br>
        Differences between the two days is that our services on
        2014-03-21 were quit busy with a lot of file changes on the xfs
        disc and on 2014-03-04 the system was very quiet on the moment
        the kernel traces appear and the services get stuck.<br>
        <br>
        Any help is appreciated.<br>
        <br>
        Regards Michel Verbraak.<br>
      </font></font><br>
    <font size="-1"><font face="DejaVu Sans"><font size="-1"><font
            face="DejaVu Sans">Following we see in the syslog on both
            moments (2014-03-04 and 2014-03-21):<br>
            <br>
          </font></font>Mar 21 06:32:20 ealxs00169 kernel:
        [1412280.930340] INFO: task flush-8:16:13864 blocked for more
        than 120 seconds.<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930462] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 13864&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930549]&nbsp;
        ffff88000676f880 0000000000000046 0000000001000000
        2500000000000000<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930557]&nbsp;
        ffff88000676ffd8 ffff88000676ffd8 ffff88000676ffd8
        00000000000137c0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930560]&nbsp;
        ffff880002218000 ffff88001b5d4500 ffff88000676f850
        ffff88001fc14080<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930564] Call Trace:<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930584]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930602]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930605]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930608]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930617]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930620]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930626]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930634]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930638]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930641]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930644]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930701]&nbsp;
        [&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930708]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930719]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930722]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930725]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930728]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930739]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930744]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930747]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930751]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930757]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930762]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930765]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930768]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930775]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930778]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar 21 06:32:20 ealxs00169 kernel: [1412280.930781]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891012] INFO: task
        archiver.pl:4005 blocked for more than 120 seconds.<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891118] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181]
        archiver.pl&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 4005&nbsp;&nbsp; 4004 0x00000000<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891186]&nbsp;
        ffff88001bb41718 0000000000000086 ffffffff8142bff0
        0000000000000002<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891189]&nbsp;
        ffff88001bb41fd8 ffff88001bb41fd8 ffff88001bb41fd8
        00000000000137c0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891192]&nbsp;
        ffff88001bad8000 ffff88000602dc00 ffff88001bb41798
        7fffffffffffffff<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891195] Call Trace:<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891223]&nbsp;
        [&lt;ffffffff8142bff0&gt;] ? scsi_mode_select+0x200/0x200<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891227]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891229]&nbsp;
        [&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891234]&nbsp;
        [&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891291]&nbsp;
        [&lt;ffffffffa007c295&gt;] ? _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891294]&nbsp;
        [&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891301]&nbsp;
        [&lt;ffffffff810912e1&gt;] down+0x41/0x50<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891314]&nbsp;
        [&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891324]&nbsp;
        [&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891335]&nbsp;
        [&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891345]&nbsp;
        [&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891373]&nbsp;
        [&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891386]&nbsp;
        [&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891399]&nbsp;
        [&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891411]&nbsp;
        [&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490
        [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891418]&nbsp;
        [&lt;ffffffff8116371b&gt;] ? kfree+0x3b/0x140<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891421]&nbsp;
        [&lt;ffffffff8116355f&gt;] ? kmem_cache_free+0x2f/0x110<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891432]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891447]&nbsp;
        [&lt;ffffffffa00cb2f8&gt;] ? xfs_perag_get+0x38/0xd0 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891460]&nbsp;
        [&lt;ffffffffa00967f1&gt;] ? xfs_free_extent+0x91/0x120 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891473]&nbsp;
        [&lt;ffffffffa0096802&gt;] xfs_free_extent+0xa2/0x120 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891486]&nbsp;
        [&lt;ffffffffa00a6e14&gt;] xfs_bmap_finish+0x164/0x1b0 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891501]&nbsp;
        [&lt;ffffffffa00c143b&gt;] xfs_itruncate_extents+0xdb/0x1e0
        [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891516]&nbsp;
        [&lt;ffffffffa00c15a6&gt;] xfs_itruncate_data+0x66/0x150 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891529]&nbsp;
        [&lt;ffffffffa009056e&gt;] xfs_inactive+0x2fe/0x460 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891532]&nbsp;
        [&lt;ffffffff8165d545&gt;] ? _raw_spin_lock_irq+0x15/0x20<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891543]&nbsp;
        [&lt;ffffffffa008afad&gt;] xfs_fs_evict_inode+0xad/0x110 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891547]&nbsp;
        [&lt;ffffffff81193e98&gt;] evict+0xb8/0x1c0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891550]&nbsp;
        [&lt;ffffffff81194088&gt;] iput_final+0xe8/0x210<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891552]&nbsp;
        [&lt;ffffffff811941ee&gt;] iput+0x3e/0x50<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891555]&nbsp;
        [&lt;ffffffff81188be3&gt;] do_unlinkat+0x153/0x1d0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891561]&nbsp;
        [&lt;ffffffff8117974d&gt;] ? vfs_read+0x10d/0x180<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891564]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891568]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891571] INFO: task
        flush-8:16:13864 blocked for more than 120 seconds.<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891626] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891686]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 13864&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891689]&nbsp;
        ffff88000676f880 0000000000000046 0000000001000000
        2500000000000000<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891692]&nbsp;
        ffff88000676ffd8 ffff88000676ffd8 ffff88000676ffd8
        00000000000137c0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891694]&nbsp;
        ffff880002218000 ffff88001b5d4500 ffff88000676f850
        ffff88001fc14080<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891697] Call Trace:<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891702]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891704]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891710]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891712]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891714]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891717]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891720]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891725]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891727]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891730]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891732]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891742]&nbsp;
        [&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891745]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891749]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891751]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891754]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891756]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891760]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891763]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891765]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891768]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891772]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891774]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891777]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891779]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891782]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891784]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar 21 06:34:20 ealxs00169 kernel: [1412400.891787]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861122] INFO: task
        java:14629 blocked for more than 120 seconds.<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861204] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861471]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 14629&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861476]&nbsp;
        ffff8800028e9328 0000000000000086 0000000000000100
        0000000000000100<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861481]&nbsp;
        ffff8800028e9fd8 ffff8800028e9fd8 ffff8800028e9fd8
        00000000000137c0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861483]&nbsp;
        ffff88001a9a4500 ffff88001b5e8000 ffff8800028e9308
        7fffffffffffffff<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861487] Call Trace:<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861500]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861502]&nbsp;
        [&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861514]&nbsp;
        [&lt;ffffffff8101aef2&gt;] ? nommu_map_sg+0x72/0xe0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861522]&nbsp;
        [&lt;ffffffff8142bff0&gt;] ? scsi_mode_select+0x200/0x200<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861526]&nbsp;
        [&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861581]&nbsp;
        [&lt;ffffffffa007c295&gt;] ? _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861583]&nbsp;
        [&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861588]&nbsp;
        [&lt;ffffffff810912e1&gt;] down+0x41/0x50<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861598]&nbsp;
        [&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861608]&nbsp;
        [&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861618]&nbsp;
        [&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861626]&nbsp;
        [&lt;ffffffff8105702d&gt;] ? set_next_entity+0xad/0xd0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861637]&nbsp;
        [&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861656]&nbsp;
        [&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861670]&nbsp;
        [&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861684]&nbsp;
        [&lt;ffffffffa00a0c93&gt;] ?
        xfs_bmap_add_extent_hole_delay+0xd3/0x6b0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861697]&nbsp;
        [&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861711]&nbsp;
        [&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861725]&nbsp;
        [&lt;ffffffffa00aa368&gt;] ? xfs_bmbt_get_all+0x18/0x20 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861730]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861732]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861748]&nbsp;
        [&lt;ffffffffa00cb2f8&gt;] ? xfs_perag_get+0x38/0xd0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861762]&nbsp;
        [&lt;ffffffffa009fe23&gt;] ? xfs_bmap_btalloc_nullfb+0x193/0x380
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861776]&nbsp;
        [&lt;ffffffffa0096b6c&gt;] ? xfs_alloc_vextent+0x2ec/0x690 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861792]&nbsp;
        [&lt;ffffffffa0096a4b&gt;] xfs_alloc_vextent+0x1cb/0x690 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861806]&nbsp;
        [&lt;ffffffffa00a02c1&gt;] xfs_bmap_btalloc+0x2b1/0x770 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861821]&nbsp;
        [&lt;ffffffffa00c21dc&gt;] ? xfs_iext_bno_to_ext+0x8c/0x160
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861836]&nbsp;
        [&lt;ffffffffa00a07a4&gt;] xfs_bmap_alloc+0x24/0x40 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861849]&nbsp;
        [&lt;ffffffffa00a594e&gt;] xfs_bmapi_allocate+0xce/0x2d0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861864]&nbsp;
        [&lt;ffffffffa00a85c3&gt;] xfs_bmapi_write+0x4c3/0x720 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861876]&nbsp;
        [&lt;ffffffffa0086988&gt;] xfs_iomap_write_allocate+0x178/0x330
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861886]&nbsp;
        [&lt;ffffffffa00799c3&gt;] xfs_map_blocks+0x183/0x250 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861895]&nbsp;
        [&lt;ffffffffa007aa56&gt;] xfs_vm_writepage+0x196/0x510 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861901]&nbsp;
        [&lt;ffffffff81122217&gt;] __writepage+0x17/0x40<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861903]&nbsp;
        [&lt;ffffffff81122a0d&gt;] write_cache_pages+0x20d/0x460<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861922]&nbsp;
        [&lt;ffffffff8152ba7d&gt;] ? sock_recvmsg+0x11d/0x140<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861925]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861935]&nbsp;
        [&lt;ffffffffa00804bc&gt;] ? xfs_file_aio_write+0x25c/0x2a0
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861938]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861948]&nbsp;
        [&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861951]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861955]&nbsp;
        [&lt;ffffffff81119f2b&gt;] __filemap_fdatawrite_range+0x5b/0x60<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861958]&nbsp;
        [&lt;ffffffff81119f82&gt;]
        filemap_write_and_wait_range+0x52/0x80<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861968]&nbsp;
        [&lt;ffffffffa007f05d&gt;] xfs_file_fsync+0x5d/0x300 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861972]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861977]&nbsp;
        [&lt;ffffffff811a7eb6&gt;] do_fsync+0x56/0x80<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861979]&nbsp;
        [&lt;ffffffff811a81e0&gt;] sys_fsync+0x10/0x20<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861983]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.861989] INFO: task
        archiver.pl:4005 blocked for more than 120 seconds.<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862047] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862112]
        archiver.pl&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 4005&nbsp;&nbsp; 4004 0x00000000<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862115]&nbsp;
        ffff88001bb41718 0000000000000086 ffffffff8142bff0
        0000000000000002<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862118]&nbsp;
        ffff88001bb41fd8 ffff88001bb41fd8 ffff88001bb41fd8
        00000000000137c0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862121]&nbsp;
        ffff88001bad8000 ffff88000602dc00 ffff88001bb41798
        7fffffffffffffff<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862123] Call Trace:<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862126]&nbsp;
        [&lt;ffffffff8142bff0&gt;] ? scsi_mode_select+0x200/0x200<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862133]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862135]&nbsp;
        [&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862138]&nbsp;
        [&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862149]&nbsp;
        [&lt;ffffffffa007c295&gt;] ? _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862151]&nbsp;
        [&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862154]&nbsp;
        [&lt;ffffffff810912e1&gt;] down+0x41/0x50<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862164]&nbsp;
        [&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862173]&nbsp;
        [&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862183]&nbsp;
        [&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862193]&nbsp;
        [&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862210]&nbsp;
        [&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862223]&nbsp;
        [&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862236]&nbsp;
        [&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862250]&nbsp;
        [&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862255]&nbsp;
        [&lt;ffffffff8116371b&gt;] ? kfree+0x3b/0x140<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862258]&nbsp;
        [&lt;ffffffff8116355f&gt;] ? kmem_cache_free+0x2f/0x110<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862260]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862277]&nbsp;
        [&lt;ffffffffa00cb2f8&gt;] ? xfs_perag_get+0x38/0xd0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862290]&nbsp;
        [&lt;ffffffffa00967f1&gt;] ? xfs_free_extent+0x91/0x120 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862303]&nbsp;
        [&lt;ffffffffa0096802&gt;] xfs_free_extent+0xa2/0x120 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862317]&nbsp;
        [&lt;ffffffffa00a6e14&gt;] xfs_bmap_finish+0x164/0x1b0 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862333]&nbsp;
        [&lt;ffffffffa00c143b&gt;] xfs_itruncate_extents+0xdb/0x1e0
        [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862349]&nbsp;
        [&lt;ffffffffa00c15a6&gt;] xfs_itruncate_data+0x66/0x150 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862365]&nbsp;
        [&lt;ffffffffa009056e&gt;] xfs_inactive+0x2fe/0x460 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862368]&nbsp;
        [&lt;ffffffff8165d545&gt;] ? _raw_spin_lock_irq+0x15/0x20<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862380]&nbsp;
        [&lt;ffffffffa008afad&gt;] xfs_fs_evict_inode+0xad/0x110 [xfs]<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862385]&nbsp;
        [&lt;ffffffff81193e98&gt;] evict+0xb8/0x1c0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862387]&nbsp;
        [&lt;ffffffff81194088&gt;] iput_final+0xe8/0x210<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862389]&nbsp;
        [&lt;ffffffff811941ee&gt;] iput+0x3e/0x50<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862392]&nbsp;
        [&lt;ffffffff81188be3&gt;] do_unlinkat+0x153/0x1d0<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862396]&nbsp;
        [&lt;ffffffff8117974d&gt;] ? vfs_read+0x10d/0x180<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862399]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:36:20 ealxs00169 kernel: [1412520.862401]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.820901] INFO: task
        java:1804 blocked for more than 120 seconds.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.820972] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821037]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 1804&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821042]&nbsp;
        ffff88001b4b3de8 0000000000000086 ffff88001b4b3da8
        ffffffffa008d944<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821045]&nbsp;
        ffff88001b4b3fd8 ffff88001b4b3fd8 ffff88001b4b3fd8
        00000000000137c0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821048]&nbsp;
        ffff88001a749700 ffff88001c61ae00 0000000000000000
        ffff8800002f38a0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821051] Call Trace:<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821116]&nbsp;
        [&lt;ffffffffa008d944&gt;] ? xfs_inode_set_reclaim_tag+0x84/0xa0
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821122]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821126]&nbsp;
        [&lt;ffffffff8165c157&gt;] __mutex_lock_slowpath+0xd7/0x150<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821131]&nbsp;
        [&lt;ffffffff81188731&gt;] ? do_path_lookup+0x31/0xc0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821134]&nbsp;
        [&lt;ffffffff8165bd6a&gt;] mutex_lock+0x2a/0x50<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821136]&nbsp;
        [&lt;ffffffff81188b1e&gt;] do_unlinkat+0x8e/0x1d0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821140]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821145]&nbsp;
        [&lt;ffffffff81015721&gt;] ? math_state_restore+0x51/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821148]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821152]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821154] INFO: task
        java:1805 blocked for more than 120 seconds.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821207] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821301]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 1805&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821309]&nbsp;
        ffff88001f4a17e8 0000000000000086 0000000000000000
        ffff88001f5f1410<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821312]&nbsp;
        ffff88001f4a1fd8 ffff88001f4a1fd8 ffff88001f4a1fd8
        00000000000137c0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821314]&nbsp;
        ffff88001bad8000 ffff88001c61dc00 000000000000003a
        7fffffffffffffff<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821317] Call Trace:<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821320]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821322]&nbsp;
        [&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821327]&nbsp;
        [&lt;ffffffff81165a1d&gt;] ? kmem_cache_alloc+0x11d/0x140<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821342]&nbsp;
        [&lt;ffffffffa00927b7&gt;] ? kmem_zone_alloc+0x67/0xe0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821345]&nbsp;
        [&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821355]&nbsp;
        [&lt;ffffffffa007c295&gt;] ? _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821358]&nbsp;
        [&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821362]&nbsp;
        [&lt;ffffffff810912e1&gt;] down+0x41/0x50<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821372]&nbsp;
        [&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821382]&nbsp;
        [&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821392]&nbsp;
        [&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821402]&nbsp;
        [&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821420]&nbsp;
        [&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821434]&nbsp;
        [&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821446]&nbsp;
        [&lt;ffffffffa00925e7&gt;] ? kmem_alloc+0x67/0xe0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821459]&nbsp;
        [&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821473]&nbsp;
        [&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821483]&nbsp;
        [&lt;ffffffffa007c42d&gt;] ? xfs_buf_unlock+0x2d/0xa0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821487]&nbsp;
        [&lt;ffffffff8116355f&gt;] ? kmem_cache_free+0x2f/0x110<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821491]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821508]&nbsp;
        [&lt;ffffffffa00cb2f8&gt;] ? xfs_perag_get+0x38/0xd0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821521]&nbsp;
        [&lt;ffffffffa00967f1&gt;] ? xfs_free_extent+0x91/0x120 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821539]&nbsp;
        [&lt;ffffffffa0096802&gt;] xfs_free_extent+0xa2/0x120 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821553]&nbsp;
        [&lt;ffffffffa00a6e14&gt;] xfs_bmap_finish+0x164/0x1b0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821566]&nbsp;
        [&lt;ffffffffa00914c1&gt;] xfs_remove+0x351/0x400 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821569]&nbsp;
        [&lt;ffffffff8165d25e&gt;] ? _raw_spin_lock+0xe/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821580]&nbsp;
        [&lt;ffffffffa0087378&gt;] xfs_vn_unlink+0x48/0x90 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821583]&nbsp;
        [&lt;ffffffff81186520&gt;] vfs_unlink.part.26+0x80/0xf0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821585]&nbsp;
        [&lt;ffffffff811865cc&gt;] vfs_unlink+0x3c/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821587]&nbsp;
        [&lt;ffffffff81188c3a&gt;] do_unlinkat+0x1aa/0x1d0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821590]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821593]&nbsp;
        [&lt;ffffffff81015721&gt;] ? math_state_restore+0x51/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821595]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821598]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821600] INFO: task
        java:1806 blocked for more than 120 seconds.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821668] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821760]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 1806&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821767]&nbsp;
        ffff88001f741de8 0000000000000086 ffff88001f741da8
        ffffffffa008d944<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821770]&nbsp;
        ffff88001f741fd8 ffff88001f741fd8 ffff88001f741fd8
        00000000000137c0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821772]&nbsp;
        ffff88001c61ae00 ffff88001b9adc00 0000000000000000
        ffff8800002f38a0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821775] Call Trace:<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821788]&nbsp;
        [&lt;ffffffffa008d944&gt;] ? xfs_inode_set_reclaim_tag+0x84/0xa0
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821790]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821793]&nbsp;
        [&lt;ffffffff8165c157&gt;] __mutex_lock_slowpath+0xd7/0x150<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821795]&nbsp;
        [&lt;ffffffff81188731&gt;] ? do_path_lookup+0x31/0xc0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821797]&nbsp;
        [&lt;ffffffff8165bd6a&gt;] mutex_lock+0x2a/0x50<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821799]&nbsp;
        [&lt;ffffffff81188b1e&gt;] do_unlinkat+0x8e/0x1d0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821802]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821805]&nbsp;
        [&lt;ffffffff81015721&gt;] ? math_state_restore+0x51/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821807]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821809]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821812] INFO: task
        java:1807 blocked for more than 120 seconds.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821878] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821971]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 1807&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821977]&nbsp;
        ffff88001f7fdde8 0000000000000086 ffff88001f7fdda8
        ffffffffa008d944<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821980]&nbsp;
        ffff88001f7fdfd8 ffff88001f7fdfd8 ffff88001f7fdfd8
        00000000000137c0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821983]&nbsp;
        ffff88001b9adc00 ffff88001b9a8000 0000000000000000
        ffff8800002f38a0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821985] Call Trace:<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.821998]&nbsp;
        [&lt;ffffffffa008d944&gt;] ? xfs_inode_set_reclaim_tag+0x84/0xa0
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822001]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822003]&nbsp;
        [&lt;ffffffff8165c157&gt;] __mutex_lock_slowpath+0xd7/0x150<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822005]&nbsp;
        [&lt;ffffffff81188731&gt;] ? do_path_lookup+0x31/0xc0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822007]&nbsp;
        [&lt;ffffffff8165bd6a&gt;] mutex_lock+0x2a/0x50<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822010]&nbsp;
        [&lt;ffffffff81188b1e&gt;] do_unlinkat+0x8e/0x1d0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822012]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822015]&nbsp;
        [&lt;ffffffff81015721&gt;] ? math_state_restore+0x51/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822017]&nbsp;
        [&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822020]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822022] INFO: task
        java:14629 blocked for more than 120 seconds.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822090] "echo 0 &gt;
        /proc/sys/kernel/hung_task_timeout_secs" disables this message.<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822183]
        java&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 14629&nbsp;&nbsp; 1788 0x00000000<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822186]&nbsp;
        ffff8800028e9328 0000000000000086 0000000000000100
        0000000000000100<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822189]&nbsp;
        ffff8800028e9fd8 ffff8800028e9fd8 ffff8800028e9fd8
        00000000000137c0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822191]&nbsp;
        ffff88001a9a4500 ffff88001b5e8000 ffff8800028e9308
        7fffffffffffffff<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822194] Call Trace:<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822196]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822199]&nbsp;
        [&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822203]&nbsp;
        [&lt;ffffffff8101aef2&gt;] ? nommu_map_sg+0x72/0xe0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822216]&nbsp;
        [&lt;ffffffff8142bff0&gt;] ? scsi_mode_select+0x200/0x200<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822220]&nbsp;
        [&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822234]&nbsp;
        [&lt;ffffffffa007c295&gt;] ? _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822237]&nbsp;
        [&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822241]&nbsp;
        [&lt;ffffffff810912e1&gt;] down+0x41/0x50<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822252]&nbsp;
        [&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822262]&nbsp;
        [&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822272]&nbsp;
        [&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822276]&nbsp;
        [&lt;ffffffff8105702d&gt;] ? set_next_entity+0xad/0xd0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822285]&nbsp;
        [&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822302]&nbsp;
        [&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822315]&nbsp;
        [&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822329]&nbsp;
        [&lt;ffffffffa00a0c93&gt;] ?
        xfs_bmap_add_extent_hole_delay+0xd3/0x6b0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822342]&nbsp;
        [&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822355]&nbsp;
        [&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822369]&nbsp;
        [&lt;ffffffffa00aa368&gt;] ? xfs_bmbt_get_all+0x18/0x20 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822372]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822374]&nbsp;
        [&lt;ffffffff8131214b&gt;] ? radix_tree_lookup+0xb/0x10<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822390]&nbsp;
        [&lt;ffffffffa00cb2f8&gt;] ? xfs_perag_get+0x38/0xd0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822403]&nbsp;
        [&lt;ffffffffa009fe23&gt;] ? xfs_bmap_btalloc_nullfb+0x193/0x380
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822417]&nbsp;
        [&lt;ffffffffa0096b6c&gt;] ? xfs_alloc_vextent+0x2ec/0x690 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822430]&nbsp;
        [&lt;ffffffffa0096a4b&gt;] xfs_alloc_vextent+0x1cb/0x690 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822443]&nbsp;
        [&lt;ffffffffa00a02c1&gt;] xfs_bmap_btalloc+0x2b1/0x770 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822459]&nbsp;
        [&lt;ffffffffa00c21dc&gt;] ? xfs_iext_bno_to_ext+0x8c/0x160
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822473]&nbsp;
        [&lt;ffffffffa00a07a4&gt;] xfs_bmap_alloc+0x24/0x40 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822486]&nbsp;
        [&lt;ffffffffa00a594e&gt;] xfs_bmapi_allocate+0xce/0x2d0 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822500]&nbsp;
        [&lt;ffffffffa00a85c3&gt;] xfs_bmapi_write+0x4c3/0x720 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822512]&nbsp;
        [&lt;ffffffffa0086988&gt;] xfs_iomap_write_allocate+0x178/0x330
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822522]&nbsp;
        [&lt;ffffffffa00799c3&gt;] xfs_map_blocks+0x183/0x250 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822531]&nbsp;
        [&lt;ffffffffa007aa56&gt;] xfs_vm_writepage+0x196/0x510 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822536]&nbsp;
        [&lt;ffffffff81122217&gt;] __writepage+0x17/0x40<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822538]&nbsp;
        [&lt;ffffffff81122a0d&gt;] write_cache_pages+0x20d/0x460<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822542]&nbsp;
        [&lt;ffffffff8152ba7d&gt;] ? sock_recvmsg+0x11d/0x140<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822544]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822554]&nbsp;
        [&lt;ffffffffa00804bc&gt;] ? xfs_file_aio_write+0x25c/0x2a0
        [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822557]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822566]&nbsp;
        [&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822569]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822573]&nbsp;
        [&lt;ffffffff81119f2b&gt;] __filemap_fdatawrite_range+0x5b/0x60<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822575]&nbsp;
        [&lt;ffffffff81119f82&gt;]
        filemap_write_and_wait_range+0x52/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822585]&nbsp;
        [&lt;ffffffffa007f05d&gt;] xfs_file_fsync+0x5d/0x300 [xfs]<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822588]&nbsp;
        [&lt;ffffffff8118c985&gt;] ? poll_select_set_timeout+0x85/0xa0<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822593]&nbsp;
        [&lt;ffffffff811a7eb6&gt;] do_fsync+0x56/0x80<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822595]&nbsp;
        [&lt;ffffffff811a81e0&gt;] sys_fsync+0x10/0x20<br>
        Mar 21 06:38:20 ealxs00169 kernel: [1412640.822597]&nbsp;
        [&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b<br>
        <br>
        From this moment on the services are not working anymore.
        Complete stuck.<br>
        <br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392177] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392400] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392474]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392478]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392487]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392489]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392492] Call Trace:<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392510]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392523]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392526]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392528]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392536]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392539]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392544]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392551]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392554]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392556]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392559]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392621]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392627]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392636]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392639]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392641]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392644]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392654]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392658]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392661]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392664]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392669]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392671]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392674]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392676]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392682]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392685]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:39:25 ealxs00169 kernel: [34229278.392687]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350796] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350923] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350987]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350991]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350995]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.350998]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351001] Call Trace:<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351017]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351022]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351024]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351027]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351030]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351033]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351039]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351044]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351047]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351049]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351052]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351093]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351096]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351101]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351104]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351106]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351109]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351113]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351117]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351120]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351123]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351128]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351130]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351133]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351135]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351140]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351142]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:41:25 ealxs00169 kernel: [34229398.351145]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317264] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317367] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317436]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317443]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317447]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317450]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317453] Call Trace:<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317467]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317472]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317474]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317477]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317480]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317483]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317488]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317493]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317496]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317498]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317501]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317596]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317600]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317606]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317609]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317611]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317614]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317620]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317624]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317627]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317630]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317648]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317651]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317654]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317657]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317661]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317664]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:43:25 ealxs00169 kernel: [34229518.317666]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275799] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275894] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275957]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275962]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275969]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275971]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275975] Call Trace:<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.275993]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276006]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276008]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276011]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276018]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276021]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276029]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276036]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276039]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276042]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276044]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276084]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276090]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276099]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276102]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276105]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276107]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276117]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276121]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276124]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276127]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276132]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276135]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276137]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276140]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276146]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276148]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:45:25 ealxs00169 kernel: [34229638.276151]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246364] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246439] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246501]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246505]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246509]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246512]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246515] Call Trace:<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246527]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246532]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246534]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246537]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246540]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246543]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246548]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246554]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246556]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246559]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246561]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246622]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246626]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246631]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246633]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246636]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246638]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246644]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246648]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246650]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246653]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246658]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246661]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246663]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246665]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246670]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246672]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:47:25 ealxs00169 kernel: [34229758.246675]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204689] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204764] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204827]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204834]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204838]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204841]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204844] Call Trace:<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204865]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204870]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204872]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204875]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204878]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204880]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204886]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204891]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204893]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204896]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204898]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204956]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204960]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204965]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204967]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204970]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204972]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204976]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204980]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204982]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204985]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204990]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204993]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204995]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.204997]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.205002]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.205004]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:49:25 ealxs00169 kernel: [34229878.205007]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176219] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176491] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176614]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176618]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176622]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176625]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176628] Call Trace:<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176640]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176645]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176647]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176649]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176652]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176655]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176661]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176666]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176668]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176671]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176673]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176746]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176750]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176756]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176759]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176762]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176764]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176769]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176773]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176776]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176779]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176784]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176786]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176789]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176791]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176796]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176798]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:51:25 ealxs00169 kernel: [34229998.176801]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139419] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139541] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139635]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139639]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139643]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139646]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139649] Call Trace:<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139665]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139671]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139673]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139676]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139679]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139681]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139687]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139693]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139695]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139698]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139700]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139759]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139762]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139767]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139770]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139773]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139775]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139781]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139785]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139787]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139791]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139796]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139798]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139801]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139803]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139808]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139810]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:53:25 ealxs00169 kernel: [34230118.139813]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105607] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105721] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105812]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105817]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105823]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105826]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105829] Call Trace:<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105848]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105860]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105862]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105865]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105872]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105875]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105881]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105887]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105890]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105892]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105895]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105965]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105971]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105980]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105983]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105986]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105988]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.105998]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106003]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106005]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106009]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106014]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106016]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106019]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106021]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106027]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106030]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:55:25 ealxs00169 kernel: [34230238.106032]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082371] INFO: task
        flush-8:16:20760 blocked for more than 120 seconds.<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082468] "echo 0
        &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this
        message.<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082560]
        flush-8:16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D 0000000000000000&nbsp;&nbsp;&nbsp;&nbsp; 0 20760&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082564]&nbsp;
        ffff8800148af880 0000000000000046 ffff8800148afbf0
        0000000000000000<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082568]&nbsp;
        ffff8800148affd8 ffff8800148affd8 ffff8800148affd8
        00000000000137c0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082571]&nbsp;
        ffff8800022a4500 ffff8800022a1700 ffff8800148af850
        ffff88001fc14080<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082573] Call Trace:<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082594]&nbsp;
        [&lt;ffffffff81118360&gt;] ? __lock_page+0x70/0x70<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082599]&nbsp;
        [&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082601]&nbsp;
        [&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082604]&nbsp;
        [&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082607]&nbsp;
        [&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082609]&nbsp;
        [&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082615]&nbsp;
        [&lt;ffffffff8108bd60&gt;] ? autoremove_wake_function+0x40/0x40<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082620]&nbsp;
        [&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082623]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082625]&nbsp;
        [&lt;ffffffff81122200&gt;] ? set_page_dirty_lock+0x60/0x60<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082627]&nbsp;
        [&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082677]&nbsp;
        [&lt;ffffffffa008d80d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082681]&nbsp;
        [&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082687]&nbsp;
        [&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082689]&nbsp;
        [&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082692]&nbsp;
        [&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082694]&nbsp;
        [&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082700]&nbsp;
        [&lt;ffffffff810136e5&gt;] ? __switch_to+0xf5/0x360<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082705]&nbsp;
        [&lt;ffffffff81194ad2&gt;] ? get_nr_dirty_inodes+0x52/0x80<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082707]&nbsp;
        [&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082713]&nbsp;
        [&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082719]&nbsp;
        [&lt;ffffffff810778b0&gt;] ? usleep_range+0x50/0x50<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082721]&nbsp;
        [&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082723]&nbsp;
        [&lt;ffffffff811a4500&gt;] ? wb_do_writeback+0x1d0/0x1d0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082726]&nbsp;
        [&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082731]&nbsp;
        [&lt;ffffffff816679b4&gt;] kernel_thread_helper+0x4/0x10<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082733]&nbsp;
        [&lt;ffffffff8108b1f0&gt;] ? flush_kthread_worker+0xa0/0xa0<br>
        Mar&nbsp; 4 19:57:25 ealxs00169 kernel: [34230358.082736]&nbsp;
        [&lt;ffffffff816679b0&gt;] ? gs_change+0x13/0x13<br>
        <br>
      </font></font>
  </body>
</html>

--------------020709070101020901020602--


--===============6464325953409917436==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6464325953409917436==--
