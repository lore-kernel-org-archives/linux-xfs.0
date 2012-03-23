Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2N8nUXT138446 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 03:49:30 -0500
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id ZY0G71TsaobbCVCJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Mar 2012 01:49:27 -0700 (PDT)
Received: by werm13 with SMTP id m13so2855877wer.26
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 01:49:26 -0700 (PDT)
MIME-Version: 1.0
From: Supratik Goswami <supratiksekhar@gmail.com>
Date: Fri, 23 Mar 2012 14:19:05 +0530
Message-ID: <CANs4eSAs3B3qjMN=Z56-Y9HfXBsGNbJ_QD0hNmpYu8VcP-Ce8w@mail.gmail.com>
Subject: LVM volume with XFS file system hanged
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

Our current system is running Ubuntu 10.04 with a the below kernel version.

root@ip-10-0-1-117:~# cat /etc/issue
Ubuntu 10.04.4 LTS \n \l

root@ip-10-0-1-117:~# uname -a
Linux ip-10-0-1-117 2.6.32-343-ec2 #45-Ubuntu SMP Tue Feb 14 18:18:17
UTC 2012 x86_64 GNU/Linux

We have an LVM volume which is using XFS filesystem. We found the
below call trace in /var/log/messages when it was unresponsive.

Can anyone please tell me what went wrong ?

Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028931] kdmflush      D
00000001050f2438     0   561      2 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028936]
ffff8801ddfbbce0 0000000000000246 ffff8801b9cd5200 ffff8801ddfbbc60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028942]
ffff8801ddbbceb8 ffff8801ddfbbca8 ffff8801ddbbcc30 ffff8801ddfbbfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028945]
ffff8801ddbbc880 ffff8801ddbbc880 ffff8801ddbbc880 ffff8801ddfbbfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028948] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028960]
[<ffffffff813ee314>] ? dm_table_unplug_all+0x54/0xc0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028966]
[<ffffffff810339a6>] ? update_curr+0xe6/0x200
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028970]
[<ffffffff814b01f2>] io_schedule+0x42/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028974]
[<ffffffff813ec23f>] dm_wait_for_completion+0x9f/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028977]
[<ffffffff81034de0>] ? default_wake_function+0x0/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028979]
[<ffffffff813ec8c5>] dm_flush+0x25/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028982]
[<ffffffff813edb39>] process_barrier+0x29/0x130
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028985]
[<ffffffff813edc7b>] dm_wq_work+0x3b/0x150
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028987]
[<ffffffff813edc40>] ? dm_wq_work+0x0/0x150
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028994]
[<ffffffff81055eff>] run_workqueue+0x8f/0x220
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.028997]
[<ffffffff8105612b>] worker_thread+0x9b/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029000]
[<ffffffff8105a3d0>] ? autoremove_wake_function+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029003]
[<ffffffff81056090>] ? worker_thread+0x0/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029005]
[<ffffffff81059eee>] kthread+0x8e/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029010]
[<ffffffff8100a71a>] child_rip+0xa/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029013]
[<ffffffff81059e60>] ? kthread+0x0/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029015]
[<ffffffff8100a710>] ? child_rip+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029038] xfssyncd      D
00000001050f2a8c     0   697      2 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029041]
ffff8801ddd7dc60 0000000000000246 0000000000000000 ffff8801ddd7dbe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029044]
0000000000000000 ffff8801ddd7dc28 ffff8801dd0eac30 ffff8801ddd7dfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029047]
ffff8801dd0ea880 ffff8801dd0ea880 ffff8801dd0ea880 ffff8801ddd7dfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029049] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029055]
[<ffffffff81275245>] __xfs_iunpin_wait+0x95/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029058]
[<ffffffff8105a3d0>] ? autoremove_wake_function+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029061]
[<ffffffff812791d1>] xfs_iflush+0x91/0x300
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029067]
[<ffffffff8133da7b>] ? radix_tree_gang_lookup_tag+0x8b/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029074]
[<ffffffff812a0d7b>] xfs_reclaim_inode+0x13b/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029077]
[<ffffffff812a025c>] xfs_inode_ag_walk+0x8c/0x140
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029079]
[<ffffffff812a0c40>] ? xfs_reclaim_inode+0x0/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029082]
[<ffffffff812a039f>] xfs_inode_ag_iterator+0x8f/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029085]
[<ffffffff812a0c40>] ? xfs_reclaim_inode+0x0/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029088]
[<ffffffff812a054d>] xfs_reclaim_inodes+0x1d/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029090]
[<ffffffff812a057e>] xfs_sync_worker+0x2e/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029093]
[<ffffffff812a099d>] xfssyncd+0x17d/0x220
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029096]
[<ffffffff812a0820>] ? xfssyncd+0x0/0x220
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029098]
[<ffffffff81059eee>] kthread+0x8e/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029101]
[<ffffffff8100a71a>] child_rip+0xa/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029103]
[<ffffffff81059e60>] ? kthread+0x0/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029106]
[<ffffffff8100a710>] ? child_rip+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029128] flush-254:0   D
00000001050f272a     0  1180      2 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029133]
ffff8801dee033e0 0000000000000246 ffffffffdee03330 ffff8801dee03360
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029136]
ffff8800a7a63640 ffff8801dee033a8 ffff8801dee00cf0 ffff8801dee03fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029139]
ffff8801dee00940 ffff8801dee00940 ffff8801dee00940 ffff8801dee03fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029141] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029148]
[<ffffffff8127f6a1>] xlog_state_get_iclog_space+0xf1/0x370
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029174]
[<ffffffff8128802c>] ? xfs_icsb_modify_counters+0x9c/0x1e0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029181]
[<ffffffff81034de0>] ? default_wake_function+0x0/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029191]
[<ffffffff8127fa8c>] xlog_write+0x16c/0x690
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029197]
[<ffffffff81256957>] ? xfs_bmap_add_extent+0x377/0x420
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029200]
[<ffffffff81275328>] ? xfs_iextents_copy+0x68/0xc0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029203]
[<ffffffff8127ffea>] xfs_log_write+0x3a/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029207]
[<ffffffff8128bcf7>] _xfs_trans_commit+0x197/0x3b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029211]
[<ffffffff8127a885>] xfs_iomap_write_allocate+0x1f5/0x3c0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029214]
[<ffffffff8127b596>] xfs_iomap+0x2a6/0x2e0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029217]
[<ffffffff81294028>] xfs_map_blocks+0x28/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029220]
[<ffffffff8129540a>] xfs_page_state_convert+0x3da/0x720
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029233]
[<ffffffff8133d9a5>] ? radix_tree_gang_lookup_tag_slot+0x95/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029237]
[<ffffffff812958a1>] xfs_vm_writepage+0x71/0x120
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029243]
[<ffffffff810b5d82>] __writepage+0x12/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029246]
[<ffffffff810b6b37>] write_cache_pages+0x1d7/0x3d0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029249]
[<ffffffff810b5d70>] ? __writepage+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029253]
[<ffffffff810b6d4f>] generic_writepages+0x1f/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029255]
[<ffffffff812946b0>] xfs_vm_writepages+0x70/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029258]
[<ffffffff810b6d7c>] do_writepages+0x1c/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029263]
[<ffffffff81111963>] writeback_single_inode+0x103/0x3f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029265]
[<ffffffff81111f34>] writeback_sb_inodes+0x184/0x2a0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029268]
[<ffffffff811120bb>] writeback_inodes_wb+0x6b/0x1f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029271]
[<ffffffff811124ab>] wb_writeback+0x26b/0x2d0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029275]
[<ffffffff8104c7fa>] ? del_timer_sync+0x1a/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029278]
[<ffffffff8111268f>] wb_do_writeback+0x17f/0x190
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029281]
[<ffffffff811126eb>] bdi_writeback_task+0x4b/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029284]
[<ffffffff810c7520>] ? bdi_start_fn+0x0/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029286]
[<ffffffff810c75a1>] bdi_start_fn+0x81/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029288]
[<ffffffff810c7520>] ? bdi_start_fn+0x0/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029292]
[<ffffffff81059eee>] kthread+0x8e/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029296]
[<ffffffff8100a71a>] child_rip+0xa/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029299]
[<ffffffff81059e60>] ? kthread+0x0/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029301]
[<ffffffff8100a710>] ? child_rip+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029360] cm-gmail      D
00000001050f24b6     0 19722      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029363]
ffff88019ba8f408 0000000000000286 ffff88019ba8f3a8 ffff88019ba8f388
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029366]
ffff88019ba8f378 ffff88019ba8f3d0 ffff88017e79ea70 ffff88019ba8ffd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029369]
ffff88017e79e6c0 ffff88017e79e6c0 ffff88017e79e6c0 ffff88019ba8ffd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029378] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029382]
[<ffffffff8127e34b>] _sv_wait+0x7b/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029385]
[<ffffffff81034de0>] ? default_wake_function+0x0/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029388]
[<ffffffff812803f2>] xlog_state_sync+0x262/0x280
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029392]
[<ffffffff81248c45>] ? xfs_alloc_ag_vextent_near+0x5b5/0x9a0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029394]
[<ffffffff81277f06>] ? xfs_iext_insert+0x46/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029397]
[<ffffffff81280466>] _xfs_log_force+0x56/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029400]
[<ffffffff8128cead>] ? xfs_trans_log_buf+0x8d/0xb0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029403]
[<ffffffff81280493>] xfs_log_force+0x13/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029406]
[<ffffffff812473b3>] xfs_alloc_search_busy+0x103/0x120
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029408]
[<ffffffff81249154>] xfs_alloc_ag_vextent+0x124/0x130
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029411]
[<ffffffff81249898>] xfs_alloc_vextent+0x1e8/0x480
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029414]
[<ffffffff812583e9>] xfs_bmap_btalloc+0x179/0xa90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029417]
[<ffffffff81258d1c>] xfs_bmap_alloc+0x1c/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029420]
[<ffffffff812598df>] xfs_bmapi+0xb9f/0x1290
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029423]
[<ffffffff81297ef6>] ? xfs_buf_get_flags+0xa6/0x170
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029427]
[<ffffffff812652a3>] xfs_dir2_grow_inode+0x103/0x3a0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029429]
[<ffffffff8128d462>] ? xfs_trans_brelse+0x32/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029432]
[<ffffffff8126678f>] xfs_dir2_sf_to_block+0x9f/0x5a0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029435]
[<ffffffff8105a2b6>] ? bit_waitqueue+0x26/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029437]
[<ffffffff8105a3ba>] ? wake_up_bit+0x2a/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029440]
[<ffffffff8129be72>] ? xfs_setup_inode+0x192/0x270
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029444]
[<ffffffff8126e168>] xfs_dir2_sf_addname+0x238/0x300
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029447]
[<ffffffff81265e5c>] xfs_dir_createname+0x14c/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029450]
[<ffffffff8129009b>] xfs_create+0x45b/0x5f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029455]
[<ffffffff81103631>] ? __d_lookup+0xb1/0x180
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029457]
[<ffffffff8129b662>] xfs_vn_mknod+0xa2/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029460]
[<ffffffff8129b78b>] xfs_vn_create+0xb/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029463]
[<ffffffff810f993f>] vfs_create+0xaf/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029465]
[<ffffffff810fa4dc>] __open_namei_create+0xbc/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029467]
[<ffffffff810fd7a6>] do_filp_open+0xa66/0xba0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029471]
[<ffffffff81108c8b>] ? alloc_fd+0x4b/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029476]
[<ffffffff810ec6d4>] do_sys_open+0x64/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029479]
[<ffffffff810ec7fb>] sys_open+0x1b/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029482]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029485]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029493] cm-gmail      D
ffff8801dd919c78     0 19728      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029496]
ffff8801dd919bd8 0000000000000286 0000000000000004 ffff8801dd919b58
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029498]
00000000000004e6 ffff8801dd919ba0 ffff8801b9c94bb0 ffff8801dd919fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029504]
ffff8801b9c94800 ffff8801b9c94800 ffff8801b9c94800 ffff8801dd919fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029506] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029509]
[<ffffffff810b0a80>] ? mempool_alloc_slab+0x10/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029515]
[<ffffffff813ec17b>] ? dm_unplug_all+0x4b/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029519]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029522]
[<ffffffff814b01f2>] io_schedule+0x42/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029524]
[<ffffffff811180eb>] sync_buffer+0x3b/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029527]
[<ffffffff814b07a7>] __wait_on_bit+0x57/0x80
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029529]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029532]
[<ffffffff81294250>] ? xfs_get_blocks+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029534]
[<ffffffff814b0843>] out_of_line_wait_on_bit+0x73/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029537]
[<ffffffff8105a410>] ? wake_bit_function+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029539]
[<ffffffff811180a6>] __wait_on_buffer+0x26/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029542]
[<ffffffff8111b9bd>] block_truncate_page+0x21d/0x260
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029545]
[<ffffffff8129bcbb>] xfs_vn_truncate+0x1b/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029547]
[<ffffffff810b994e>] vmtruncate+0x5e/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029550]
[<ffffffff8129146d>] xfs_setattr+0x2ad/0xb30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029555]
[<ffffffff8112f7fa>] ? do_lock_file_wait+0x5a/0xf0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029558]
[<ffffffff8129bb96>] xfs_vn_setattr+0x16/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029562]
[<ffffffff81107d33>] notify_change+0x163/0x340
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029564]
[<ffffffff810ed8cf>] do_truncate+0x5f/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029566]
[<ffffffff810edff3>] T.709+0xe3/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029569]
[<ffffffff810ee029>] sys_ftruncate+0x9/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029571]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029574]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029581] cm-gmail      D
00000001050f2562     0 19729      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029584]
ffff8801dc80bbd8 0000000000000286 0000000000000006 ffff8801dc80bb58
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029587]
000000000001be6a ffff8801dc80bba0 ffff8801a7d98bf0 ffff8801dc80bfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029591]
ffff8801a7d98840 ffff8801a7d98840 ffff8801a7d98840 ffff8801dc80bfd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029594] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029596]
[<ffffffff810b0a80>] ? mempool_alloc_slab+0x10/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029599]
[<ffffffff813ec17b>] ? dm_unplug_all+0x4b/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029601]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029603]
[<ffffffff814b01f2>] io_schedule+0x42/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029606]
[<ffffffff811180eb>] sync_buffer+0x3b/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029608]
[<ffffffff814b07a7>] __wait_on_bit+0x57/0x80
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029610]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029613]
[<ffffffff81294250>] ? xfs_get_blocks+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029615]
[<ffffffff814b0843>] out_of_line_wait_on_bit+0x73/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029618]
[<ffffffff8105a410>] ? wake_bit_function+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029620]
[<ffffffff811180a6>] __wait_on_buffer+0x26/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029623]
[<ffffffff8111b9bd>] block_truncate_page+0x21d/0x260
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029625]
[<ffffffff8129bcbb>] xfs_vn_truncate+0x1b/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029627]
[<ffffffff810b994e>] vmtruncate+0x5e/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029630]
[<ffffffff8129146d>] xfs_setattr+0x2ad/0xb30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029633]
[<ffffffff8112f7fa>] ? do_lock_file_wait+0x5a/0xf0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029636]
[<ffffffff8129bb96>] xfs_vn_setattr+0x16/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029638]
[<ffffffff81107d33>] notify_change+0x163/0x340
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029641]
[<ffffffff810ed8cf>] do_truncate+0x5f/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029643]
[<ffffffff810edff3>] T.709+0xe3/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029645]
[<ffffffff810ee029>] sys_ftruncate+0x9/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029648]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029650]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029659] cm-gmail      D
00000001050f24fb     0 19746      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029662]
ffff880195d09bd8 0000000000000286 0000000000000005 ffff880195d09b58
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029665]
0000000000008f14 ffff880195d09ba0 ffff8801b70946f0 ffff880195d09fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029669]
ffff8801b7094340 ffff8801b7094340 ffff8801b7094340 ffff880195d09fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029672] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029674]
[<ffffffff810b0a80>] ? mempool_alloc_slab+0x10/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029677]
[<ffffffff813ec17b>] ? dm_unplug_all+0x4b/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029679]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029681]
[<ffffffff814b01f2>] io_schedule+0x42/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029683]
[<ffffffff811180eb>] sync_buffer+0x3b/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029686]
[<ffffffff814b07a7>] __wait_on_bit+0x57/0x80
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029688]
[<ffffffff811180b0>] ? sync_buffer+0x0/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029690]
[<ffffffff81294250>] ? xfs_get_blocks+0x0/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029693]
[<ffffffff814b0843>] out_of_line_wait_on_bit+0x73/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029695]
[<ffffffff8105a410>] ? wake_bit_function+0x0/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029698]
[<ffffffff811180a6>] __wait_on_buffer+0x26/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029700]
[<ffffffff8111b9bd>] block_truncate_page+0x21d/0x260
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029703]
[<ffffffff8129bcbb>] xfs_vn_truncate+0x1b/0x40
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029705]
[<ffffffff810b994e>] vmtruncate+0x5e/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029707]
[<ffffffff8129146d>] xfs_setattr+0x2ad/0xb30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029710]
[<ffffffff8112f7fa>] ? do_lock_file_wait+0x5a/0xf0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029713]
[<ffffffff8129bb96>] xfs_vn_setattr+0x16/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029715]
[<ffffffff81107d33>] notify_change+0x163/0x340
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029718]
[<ffffffff810ed8cf>] do_truncate+0x5f/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029720]
[<ffffffff810edff3>] T.709+0xe3/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029722]
[<ffffffff810ee029>] sys_ftruncate+0x9/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029724]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029727]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029735] cm-gmail      D
0000000000000001     0 19748      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029738]
ffff880143325638 0000000000000286 ffff880143325870 ffff8801433255b8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029740]
ffff880004c66000 ffff880143325600 ffff8801dddb2770 ffff880143325fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029745]
ffff8801dddb23c0 ffff8801dddb23c0 ffff8801dddb23c0 ffff880143325fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029747] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029750]
[<ffffffff8128802c>] ? xfs_icsb_modify_counters+0x9c/0x1e0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029752]
[<ffffffff814b04d5>] schedule_timeout+0x1e5/0x2c0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029754]
[<ffffffff8100892c>] ? __switch_to+0x2ec/0x780
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029757]
[<ffffffff812883a5>] ? xfs_mod_incore_sb+0xa5/0xb0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029760]
[<ffffffff814b14e8>] __down+0x78/0xf0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029764]
[<ffffffff8105ec2c>] down+0x3c/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029766]
[<ffffffff8129749e>] xfs_buf_lock+0x1e/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029768]
[<ffffffff81297d29>] _xfs_buf_find+0x149/0x270
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029771]
[<ffffffff81297eab>] xfs_buf_get_flags+0x5b/0x170
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029773]
[<ffffffff81297fd3>] xfs_buf_read_flags+0x13/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029776]
[<ffffffff8128d129>] xfs_trans_read_buf+0x1c9/0x300
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029778]
[<ffffffff81270f3f>] xfs_read_agi+0x6f/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029781]
[<ffffffff81270ff2>] xfs_ialloc_read_agi+0x22/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029783]
[<ffffffff812720e8>] xfs_ialloc_ag_select+0x2a8/0x370
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029786]
[<ffffffff81272ab5>] xfs_dialloc+0x415/0x940
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029788]
[<ffffffff810b4936>] ? __alloc_pages_nodemask+0xd6/0x180
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029793]
[<ffffffff810c655d>] ? mod_zone_page_state+0x2d/0x80
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029796]
[<ffffffff810e4198>] ? T.618+0x338/0x480
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029799]
[<ffffffff812764fd>] xfs_ialloc+0x5d/0x700
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029802]
[<ffffffff81280d3c>] ? xlog_grant_log_space+0x3fc/0x450
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029804]
[<ffffffff8128e43d>] xfs_dir_ialloc+0x7d/0x2d0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029807]
[<ffffffff81280e64>] ? xfs_log_reserve+0xd4/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029810]
[<ffffffff81290023>] xfs_create+0x3e3/0x5f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029812]
[<ffffffff81103631>] ? __d_lookup+0xb1/0x180
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029815]
[<ffffffff8129b662>] xfs_vn_mknod+0xa2/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029818]
[<ffffffff8129b78b>] xfs_vn_create+0xb/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029820]
[<ffffffff810f993f>] vfs_create+0xaf/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029822]
[<ffffffff810fa4dc>] __open_namei_create+0xbc/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029825]
[<ffffffff810fd7a6>] do_filp_open+0xa66/0xba0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029827]
[<ffffffff81108c8b>] ? alloc_fd+0x4b/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029830]
[<ffffffff810ec6d4>] do_sys_open+0x64/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029833]
[<ffffffff810ec7fb>] sys_open+0x1b/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029835]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029838]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029845] cm-gmail      D
0000000000000001     0 19753      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029848]
ffff88015dd81638 0000000000000286 ffff88015dd81870 ffff88015dd815b8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029851]
ffff880004c66000 ffff88015dd81600 ffff88015dd168b0 ffff88015dd81fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029855]
ffff88015dd16500 ffff88015dd16500 ffff88015dd16500 ffff88015dd81fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029857] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029860]
[<ffffffff8128802c>] ? xfs_icsb_modify_counters+0x9c/0x1e0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029862]
[<ffffffff814b04d5>] schedule_timeout+0x1e5/0x2c0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029865]
[<ffffffff8100892c>] ? __switch_to+0x2ec/0x780
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029868]
[<ffffffff810ae639>] ? find_get_page+0x19/0x90
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029870]
[<ffffffff810af2d1>] ? find_lock_page+0x21/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029873]
[<ffffffff814b14e8>] __down+0x78/0xf0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029875]
[<ffffffff8105ec2c>] down+0x3c/0x50
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029877]
[<ffffffff8129749e>] xfs_buf_lock+0x1e/0x60
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029880]
[<ffffffff81297d29>] _xfs_buf_find+0x149/0x270
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029882]
[<ffffffff81297eab>] xfs_buf_get_flags+0x5b/0x170
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029885]
[<ffffffff81297fd3>] xfs_buf_read_flags+0x13/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029887]
[<ffffffff8128d129>] xfs_trans_read_buf+0x1c9/0x300
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029889]
[<ffffffff81270f3f>] xfs_read_agi+0x6f/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029892]
[<ffffffff81293412>] ? kmem_zone_alloc+0x92/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029895]
[<ffffffff81270ff2>] xfs_ialloc_read_agi+0x22/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029897]
[<ffffffff812720e8>] xfs_ialloc_ag_select+0x2a8/0x370
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029900]
[<ffffffff81272ab5>] xfs_dialloc+0x415/0x940
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029902]
[<ffffffff8126b6fb>] ? xfs_dir2_leafn_lookup_for_entry+0x10b/0x360
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029905]
[<ffffffff81296637>] ? xfs_buf_free+0x67/0xa0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029908]
[<ffffffff812975a7>] ? xfs_buf_rele+0xc7/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029910]
[<ffffffff8128d500>] ? xfs_trans_brelse+0xd0/0x110
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029913]
[<ffffffff812764fd>] xfs_ialloc+0x5d/0x700
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029915]
[<ffffffff81280d3c>] ? xlog_grant_log_space+0x3fc/0x450
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029918]
[<ffffffff8128e43d>] xfs_dir_ialloc+0x7d/0x2d0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029921]
[<ffffffff81280e64>] ? xfs_log_reserve+0xd4/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029924]
[<ffffffff81290023>] xfs_create+0x3e3/0x5f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029926]
[<ffffffff81103631>] ? __d_lookup+0xb1/0x180
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029929]
[<ffffffff8129b662>] xfs_vn_mknod+0xa2/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029931]
[<ffffffff8129b78b>] xfs_vn_create+0xb/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029934]
[<ffffffff810f993f>] vfs_create+0xaf/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029936]
[<ffffffff810fa4dc>] __open_namei_create+0xbc/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029938]
[<ffffffff810fd7a6>] do_filp_open+0xa66/0xba0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029941]
[<ffffffff81108c8b>] ? alloc_fd+0x4b/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029944]
[<ffffffff810ec6d4>] do_sys_open+0x64/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029946]
[<ffffffff810ec7fb>] sys_open+0x1b/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029949]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029952]
[<ffffffff81009b50>] ? system_call+0x0/0x52
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029960] cm-gmail      D
00000001050f256d     0 19754      1 0x00000000
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029962]
ffff88015dd23878 0000000000000286 0000000000104fad ffff88015dd237f8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029965]
ffff8801a22f3400 ffff88015dd23840 ffff8801dd2648f0 ffff88015dd23fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029969]
ffff8801dd264540 ffff8801dd264540 ffff8801dd264540 ffff88015dd23fd8
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029972] Call Trace:
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029974]
[<ffffffff81293412>] ? kmem_zone_alloc+0x92/0xe0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029977]
[<ffffffff8127f6a1>] xlog_state_get_iclog_space+0xf1/0x370
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029980]
[<ffffffff81262a08>] ? xfs_da_do_buf+0x5d8/0x6e0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029982]
[<ffffffff81034de0>] ? default_wake_function+0x0/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029985]
[<ffffffff81261a6f>] ? xfs_da_log_buf+0xbf/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029987]
[<ffffffff8127fa8c>] xlog_write+0x16c/0x690
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029990]
[<ffffffff81267bf8>] ? xfs_dir2_data_log_unused+0x58/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029993]
[<ffffffff8128cead>] ? xfs_trans_log_buf+0x8d/0xb0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029995]
[<ffffffff81275328>] ? xfs_iextents_copy+0x68/0xc0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.029998]
[<ffffffff8127ffea>] xfs_log_write+0x3a/0x70
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030000]
[<ffffffff8128be8d>] _xfs_trans_commit+0x32d/0x3b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030003]
[<ffffffff81265e5c>] ? xfs_dir_createname+0x14c/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030006]
[<ffffffff811116e7>] ? __mark_inode_dirty+0x87/0x200
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030009]
[<ffffffff8129bf71>] ? xfs_mark_inode_dirty_sync+0x21/0x30
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030011]
[<ffffffff8129012d>] xfs_create+0x4ed/0x5f0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030014]
[<ffffffff81103631>] ? __d_lookup+0xb1/0x180
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030016]
[<ffffffff8129b662>] xfs_vn_mknod+0xa2/0x1b0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030019]
[<ffffffff8129b78b>] xfs_vn_create+0xb/0x10
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030021]
[<ffffffff810f993f>] vfs_create+0xaf/0xd0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030023]
[<ffffffff810fa4dc>] __open_namei_create+0xbc/0x100
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030026]
[<ffffffff810fd7a6>] do_filp_open+0xa66/0xba0
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030028]
[<ffffffff81108c8b>] ? alloc_fd+0x4b/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030031]
[<ffffffff810ec6d4>] do_sys_open+0x64/0x160
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030033]
[<ffffffff810ec7fb>] sys_open+0x1b/0x20
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030036]
[<ffffffff81009bb8>] system_call_fastpath+0x16/0x1b
Mar 23 04:50:51 ip-10-0-1-117 kernel: [849247.030038]
[<ffffffff81009b50>] ? system_call+0x0/0x52


-- 
Warm Regards

Supratik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
