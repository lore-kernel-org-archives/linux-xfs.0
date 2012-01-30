Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0U9JMb9001834 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 03:19:22 -0600
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id i2cFA5Uo0GdAQDh6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 01:19:19 -0800 (PST)
Received: by werb10 with SMTP id b10so3597800wer.26
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 01:19:18 -0800 (PST)
MIME-Version: 1.0
From: Supratik Goswami <supratiksekhar@gmail.com>
Date: Mon, 30 Jan 2012 14:48:58 +0530
Message-ID: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
Subject: File system remain unresponsive until the system is rebooted.
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

Hi

We are using RAID-0 volumes as PV's in our LVM stack and XFS as the filesystem.

The kernel logged the below call trace when the filesystem was being
expanded using "xfs_growfs" command.
We have used xfs_grofs at least 3 times earlier but did not cam across
this situation.

The files system remained unresponsive until we rebooted the system
and again increased the size of the filesystem.
This time it worked fine. Can you please tell us why xfs_grofs hanged suddenly ?

Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550724] flush-254:0   D
00000001016ff564     0 31679      2 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550728]
ffff8801de5df388 0000000000000246 ffff88002a3f57d0 ffff8801de5df308
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550732]
ffff8801deb59a10 ffff8801de5df350 ffff8801def9ec70 ffff8801de5dffd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550734]
ffff8801def9e8c0 ffff8801def9e8c0 ffff8801def9e8c0 ffff8801de5dffd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550737] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550748]
[<ffffffff812604c7>] ? xfs_btree_insert+0x67/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550754]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550757]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550761]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550764]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550770]
[<ffffffff81257f20>] xfs_bmap_btalloc+0x300/0xa90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550774]
[<ffffffff812513c5>] ? xfs_bmap_search_multi_extents+0xa5/0x110
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550784]
[<ffffffff81251609>] ? xfs_bmap_search_extents+0x69/0xf0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550787]
[<ffffffff812586cc>] xfs_bmap_alloc+0x1c/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550790]
[<ffffffff8125928f>] xfs_bmapi+0xb9f/0x1290
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550796]
[<ffffffff8127a205>] xfs_iomap_write_allocate+0x1c5/0x3c0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550799]
[<ffffffff8127af46>] xfs_iomap+0x2a6/0x2e0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550804]
[<ffffffff81293998>] xfs_map_blocks+0x28/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550807]
[<ffffffff81294d7a>] xfs_page_state_convert+0x3da/0x720
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550809]
[<ffffffff81295211>] xfs_vm_writepage+0x71/0x120
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550815]
[<ffffffff810b5b62>] __writepage+0x12/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550817]
[<ffffffff810b6917>] write_cache_pages+0x1d7/0x3d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550820]
[<ffffffff810b5b50>] ? __writepage+0x0/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550823]
[<ffffffff810b6b2f>] generic_writepages+0x1f/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550826]
[<ffffffff81294020>] xfs_vm_writepages+0x70/0x90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550829]
[<ffffffff810b6b5c>] do_writepages+0x1c/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550834]
[<ffffffff81111693>] writeback_single_inode+0x103/0x3f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550837]
[<ffffffff81111c64>] writeback_sb_inodes+0x184/0x2a0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550840]
[<ffffffff81111deb>] writeback_inodes_wb+0x6b/0x1f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550843]
[<ffffffff811121db>] wb_writeback+0x26b/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550847]
[<ffffffff8104c73a>] ? del_timer_sync+0x1a/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550850]
[<ffffffff811123bf>] wb_do_writeback+0x17f/0x190
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550853]
[<ffffffff8111241b>] bdi_writeback_task+0x4b/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550858]
[<ffffffff810c72f0>] ? bdi_start_fn+0x0/0x110
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550861]
[<ffffffff810c7371>] bdi_start_fn+0x81/0x110
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550863]
[<ffffffff810c72f0>] ? bdi_start_fn+0x0/0x110
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550868]
[<ffffffff81059e2e>] kthread+0x8e/0xa0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550873]
[<ffffffff8100a71a>] child_rip+0xa/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550876]
[<ffffffff81059da0>] ? kthread+0x0/0xa0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550878]
[<ffffffff8100a710>] ? child_rip+0x0/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550897] cm-httpserver D
00000001016fed9a     0 16726      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550900]
ffff8801dd869d28 0000000000000286 ffff8801dca1a8c0 ffff8801dd869ca8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550903]
ffff8801b1583032 ffff8801dd869cf0 ffff8801dd7f6870 ffff8801dd869fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550905]
ffff8801dd7f64c0 ffff8801dd7f64c0 ffff8801dd7f64c0 ffff8801dd869fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550908] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550916]
[<ffffffff812de22a>] ? security_inode_permission+0x1a/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550920]
[<ffffffff810fa91d>] ? __link_path_walk+0xed/0xf90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550922]
[<ffffffff814b026c>] __mutex_lock_slowpath+0x11c/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550928]
[<ffffffff8130e314>] ? apparmor_file_alloc_security+0x24/0x90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550930]
[<ffffffff814b005e>] mutex_lock+0x1e/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550933]
[<ffffffff810fce3d>] do_filp_open+0x3cd/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550936]
[<ffffffff810f8fdc>] ? path_put+0x2c/0x40
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550939]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550944]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550947]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550950]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550953]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550977] cm-gdoc       D
0000000000000002     0 16809      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550980]
ffff8801dcd65810 0000000000000286 000000008102a929 ffff8801dcd65790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550983]
ffff880002c67bd0 ffff8801dcd657d8 ffff88012679e8f0 ffff8801dcd65fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550985]
ffff88012679e540 ffff88012679e540 ffff88012679e540 ffff8801dcd65fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550990] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550995]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550997]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551003]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551006]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551008]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551011]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551013]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551017]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551020]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551026]
[<ffffffff8102cddd>] ? update_sd_lb_stats+0x1fd/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551029]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551032]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551035]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551038]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551041]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551044]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551047]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551050]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551052]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551054]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551057]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551059]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551062]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551065]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551067]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551070]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551078] cm-gdoc       D
0000000000000001     0 16816      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551081]
ffff8801dea61a58 0000000000000286 ffff8800087f1078 ffff8801dea619d8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551083]
ffff880004a73000 ffff8801dea61a20 ffff8801dcc3ca70 ffff8801dea61fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551086]
ffff8801dcc3c6c0 ffff8801dcc3c6c0 ffff8801dcc3c6c0 ffff8801dea61fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551088] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551094]
[<ffffffff8127efc0>] ? xlog_state_get_iclog_space+0x60/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551097]
[<ffffffff814afcb5>] schedule_timeout+0x1e5/0x2c0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551099]
[<ffffffff8127efc0>] ? xlog_state_get_iclog_space+0x60/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551102]
[<ffffffff8127f8a8>] ? xlog_write+0x5d8/0x690
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551104]
[<ffffffff814b0cc8>] __down+0x78/0xf0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551109]
[<ffffffff8105eb6c>] down+0x3c/0x50
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551112]
[<ffffffff81296e0e>] xfs_buf_lock+0x1e/0x60
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551114]
[<ffffffff81297699>] _xfs_buf_find+0x149/0x270
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551117]
[<ffffffff8129781b>] xfs_buf_get_flags+0x5b/0x170
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551119]
[<ffffffff81297943>] xfs_buf_read_flags+0x13/0xa0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551122]
[<ffffffff8128cad9>] xfs_trans_read_buf+0x1c9/0x300
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551126]
[<ffffffff8126d3c1>] ? xfs_dir2_sf_removename+0x121/0x190
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551128]
[<ffffffff812708ef>] xfs_read_agi+0x6f/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551131]
[<ffffffff81276736>] xfs_iunlink+0x46/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551134]
[<ffffffff81042582>] ? current_fs_time+0x22/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551137]
[<ffffffff811113cd>] ? __mark_inode_dirty+0x3d/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551139]
[<ffffffff8129b90d>] ? xfs_ichgtime+0x1d/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551142]
[<ffffffff8128dd19>] xfs_droplink+0x59/0x70
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551144]
[<ffffffff8128f364>] xfs_remove+0x294/0x350
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551148]
[<ffffffff810f821e>] ? generic_permission+0x1e/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551150]
[<ffffffff8129b213>] xfs_vn_unlink+0x43/0x90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551152]
[<ffffffff810f98c0>] vfs_unlink+0xa0/0xf0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551154]
[<ffffffff810fa755>] ? lookup_hash+0x35/0x50
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551156]
[<ffffffff810fc16e>] do_unlinkat+0x19e/0x1d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551159]
[<ffffffff810efe6d>] ? fput+0x1d/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551162]
[<ffffffff810ec218>] ? filp_close+0x58/0x90
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551164]
[<ffffffff810fc1b1>] sys_unlink+0x11/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551167]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551169]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551177] cm-gdoc       D
00000001016fea9d     0 16817      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551180]
ffff8801ddbad810 0000000000000286 0000000000000000 ffff8801ddbad790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551183]
ffff880002c67bd0 ffff8801ddbad7d8 ffff8801de886ab0 ffff8801ddbadfd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551185]
ffff8801de886700 ffff8801de886700 ffff8801de886700 ffff8801ddbadfd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551190] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551192]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551195]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551198]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551200]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551203]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551205]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551208]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551210]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551212]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551217]
[<ffffffff8143ccc4>] ? ip_finish_output+0x134/0x310
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551220]
[<ffffffff8143cf58>] ? ip_output+0xb8/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551222]
[<ffffffff814b08ad>] ? schedule_hrtimeout_range+0xcd/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551225]
[<ffffffff8143bf10>] ? ip_local_out+0x20/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551227]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551230]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551233]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551236]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551239]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551241]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551244]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551246]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551249]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551251]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551253]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551256]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551259]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551261]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551264]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551267]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551274] cm-gdoc       D
00000001016fea61     0 16818      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551277]
ffff8801dd593810 0000000000000286 0000000000000000 ffff8801dd593790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551280]
ffff880002c67bd0 ffff8801dd5937d8 ffff8801ded64af0 ffff8801dd593fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551284]
ffff8801ded64740 ffff8801ded64740 ffff8801ded64740 ffff8801dd593fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551287] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551290]
[<ffffffff8100a505>] ? hypervisor_callback+0x25/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551293]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551295]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551298]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551300]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551302]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551305]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551307]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551310]
[<ffffffff8102cddd>] ? update_sd_lb_stats+0x1fd/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551312]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551315]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551318]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551321]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551324]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551326]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551329]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551331]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551333]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551336]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551338]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551340]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551343]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551346]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551348]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551351]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551359] cm-gdoc       D
00000001016fea55     0 16831      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551362]
ffff8801dde39810 0000000000000286 0000000000000000 ffff8801dde39790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551364]
ffff880002c67bd0 ffff8801dde397d8 ffff8801de888cb0 ffff8801dde39fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551367]
ffff8801de888900 ffff8801de888900 ffff8801de888900 ffff8801dde39fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551369] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551374]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551377]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551379]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551382]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551384]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551387]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551389]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551391]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551394]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551396]
[<ffffffff8143ccc4>] ? ip_finish_output+0x134/0x310
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551399]
[<ffffffff8143cf58>] ? ip_output+0xb8/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551401]
[<ffffffff814b08ad>] ? schedule_hrtimeout_range+0xcd/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551404]
[<ffffffff8143bf10>] ? ip_local_out+0x20/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551406]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551409]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551412]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551415]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551417]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551420]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551423]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551426]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551428]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551430]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551433]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551435]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551438]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551441]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551443]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551446]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551453] cm-gdoc       D
0000000000000001     0 16837      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551456]
ffff8801dd5a7810 0000000000000286 0000000000000000 ffff8801dd5a7790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551459]
ffff880004a73000 ffff8801dd5a77d8 ffff8801dd59e4f0 ffff8801dd5a7fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551461]
ffff8801dd59e140 ffff8801dd59e140 ffff8801dd59e140 ffff8801dd5a7fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551464] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551469]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551472]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551474]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551477]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551479]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551482]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551484]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551486]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551489]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551491]
[<ffffffff8143ccc4>] ? ip_finish_output+0x134/0x310
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551494]
[<ffffffff8143cf58>] ? ip_output+0xb8/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551496]
[<ffffffff814b08ad>] ? schedule_hrtimeout_range+0xcd/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551499]
[<ffffffff8143bf10>] ? ip_local_out+0x20/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551501]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551504]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551507]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551509]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551512]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551515]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551518]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551520]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551522]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551525]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551527]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551530]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551533]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551535]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551538]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551541]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551548] cm-gdoc       D
0000000000000001     0 16838      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551551]
ffff8801b15e9810 0000000000000286 0000000000000000 ffff8801b15e9790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551554]
ffff880004a73000 ffff8801b15e97d8 ffff8801deb9e530 ffff8801b15e9fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551556]
ffff8801deb9e180 ffff8801deb9e180 ffff8801deb9e180 ffff8801b15e9fd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551558] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551563]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551566]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551569]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551571]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551574]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551576]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551578]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551581]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551583]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551586]
[<ffffffff8143ccc4>] ? ip_finish_output+0x134/0x310
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551588]
[<ffffffff8143cf58>] ? ip_output+0xb8/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551591]
[<ffffffff814b08ad>] ? schedule_hrtimeout_range+0xcd/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551593]
[<ffffffff8143bf10>] ? ip_local_out+0x20/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551596]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551598]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551601]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551604]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551606]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551609]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551612]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551614]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551616]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551618]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551621]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551623]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551626]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551629]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551631]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551634]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551641] cm-gdoc       D
0000000000000002     0 16859      1 0x00000000
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551644]
ffff88012646b810 0000000000000286 0000000000000000 ffff88012646b790
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551647]
ffff880002c67bd0 ffff88012646b7d8 ffff8801b1690a70 ffff88012646bfd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551649]
ffff8801b16906c0 ffff8801b16906c0 ffff8801b16906c0 ffff88012646bfd8
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551652] Call Trace:
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551656]
[<ffffffff81038c0f>] ? find_busiest_group+0x5f/0x440
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551659]
[<ffffffff814b172d>] rwsem_down_failed_common+0xbd/0x240
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551662]
[<ffffffff813a37ee>] ? notify_remote_via_irq+0x5e/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551664]
[<ffffffff814b1906>] rwsem_down_read_failed+0x26/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551667]
[<ffffffff813424b4>] call_rwsem_down_read_failed+0x14/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551669]
[<ffffffff814b0ab2>] ? down_read+0x12/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551671]
[<ffffffff81271882>] xfs_ialloc_ag_select+0x92/0x370
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551674]
[<ffffffff81421a95>] ? sch_direct_xmit+0x95/0x200
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551676]
[<ffffffff81272465>] xfs_dialloc+0x415/0x940
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551679]
[<ffffffff8143ccc4>] ? ip_finish_output+0x134/0x310
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551682]
[<ffffffff8143cf58>] ? ip_output+0xb8/0xc0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551684]
[<ffffffff814b08ad>] ? schedule_hrtimeout_range+0xcd/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551687]
[<ffffffff8143bf10>] ? ip_local_out+0x20/0x30
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551689]
[<ffffffff81275ead>] xfs_ialloc+0x5d/0x700
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551692]
[<ffffffff812806ec>] ? xlog_grant_log_space+0x3fc/0x450
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551695]
[<ffffffff8128dded>] xfs_dir_ialloc+0x7d/0x2d0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551697]
[<ffffffff81280814>] ? xfs_log_reserve+0xd4/0xe0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551700]
[<ffffffff8128f9d3>] xfs_create+0x3e3/0x5f0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551703]
[<ffffffff81103361>] ? __d_lookup+0xb1/0x180
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551705]
[<ffffffff8129afd2>] xfs_vn_mknod+0xa2/0x1b0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551708]
[<ffffffff8129b0fb>] xfs_vn_create+0xb/0x10
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551710]
[<ffffffff810f966f>] vfs_create+0xaf/0xd0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551712]
[<ffffffff810fa20c>] __open_namei_create+0xbc/0x100
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551715]
[<ffffffff810fd4d6>] do_filp_open+0xa66/0xba0
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551717]
[<ffffffff811089bb>] ? alloc_fd+0x4b/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551720]
[<ffffffff810ec404>] do_sys_open+0x64/0x160
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551723]
[<ffffffff810ec52b>] sys_open+0x1b/0x20
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551726]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.551728]
[<ffffffff81009b50>] ? system_call+0x0/0x52

-- 
Warm Regards

Supratik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
