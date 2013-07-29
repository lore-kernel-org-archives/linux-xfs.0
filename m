Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE4D07F4E
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 02:39:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80551304032
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 00:39:46 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id SHMIHMqLoXHUOIKk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 00:39:40 -0700 (PDT)
Message-ID: <51F61C39.6050200@profihost.ag>
Date: Mon, 29 Jul 2013 09:39:37 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Vanilla 3.0.78
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>

Hi,

while running 3.0.78 and doing heavy rsync tasks on a raid 50 i'm gettig
these call traces:

[396113.710927] INFO: task rsync:25944 blocked for more than 120 seconds.
[396113.760608] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[396113.811356] rsync           D ffff88042eb70560     0 25944  25943
0x00000000
[396113.861996]  ffff88000ef4b218 0000000000000082 ffff88000ef4b1f8
0000000000000000
[396113.912069]  0000000000010800 ffff88000ef4bfd8 ffff88000ef4a010
0000000000010800
[396113.962197]  ffff88000ef4bfd8 0000000000010800 ffffffff81a0b020
ffff88042eb70000
[396114.013067] Call Trace:
[396114.063597]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[396114.114651]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[396114.165719]  [<ffffffff811f9ec0>] ? xfs_btree_log_keys+0x50/0x90
[396114.216982]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[396114.268645]  [<ffffffff8147bc59>] __down+0x69/0xb0
[396114.320322]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[396114.371695]  [<ffffffff81078c9c>] down+0x3c/0x50
[396114.422894]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[396114.474072]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[396114.524772]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[396114.575620]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[396114.625803]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[396114.676022]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[396114.725920]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[396114.776482]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[396114.826416]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[396114.876304]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[396114.924793]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[396114.972421]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[396115.019255]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[396115.065919]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[396115.112754]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[396115.158908]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[396115.204162]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[396115.247605]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[396115.291805]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[396115.335010]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[396115.378068]  [<ffffffff810cd832>] __writepage+0x12/0x40
[396115.420772]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[396115.466613]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[396115.512538]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[396115.555134]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[396115.597647]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[396115.640635]  [<ffffffff810c4cab>] __filemap_fdatawrite_range+0x5b/0x60
[396115.682990]  [<ffffffff810c4f4e>] filemap_fdatawrite_range+0xe/0x10
[396115.724450]  [<ffffffff812399c7>] xfs_flush_pages+0x67/0xb0
[396115.765531]  [<ffffffff8122fc7a>] xfs_setattr+0x9da/0xa80
[396115.806444]  [<ffffffff8123c8a6>] xfs_vn_setattr+0x16/0x20
[396115.846806]  [<ffffffff8112d9bd>] notify_change+0x11d/0x300
[396115.887020]  [<ffffffff8111328c>] do_truncate+0x5c/0x90
[396115.926632]  [<ffffffff81113387>] sys_ftruncate+0xc7/0xd0
[396115.965535]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[396116.003705] INFO: task rsync:16891 blocked for more than 120 seconds.
[396116.041978] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[396116.080957] rsync           D ffff880044d9b5a0     0 16891  16890
0x00000000
[396116.120493]  ffff88062b129b68 0000000000000086 0000000000000000
ffff880400000001
[396116.160730]  0000000000010800 ffff88062b129fd8 ffff88062b128010
0000000000010800
[396116.200394]  ffff88062b129fd8 0000000000010800 ffffffff81a0b020
ffff880044d9b040
[396116.240183] Call Trace:
[396116.279644]  [<ffffffff81108e3b>] ? kmem_cache_free+0x1b/0xf0
[396116.320904]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[396116.360893]  [<ffffffff8147c6bd>] rwsem_down_failed_common+0xbd/0x150
[396116.401765]  [<ffffffff8147c763>] rwsem_down_write_failed+0x13/0x20
[396116.442829]  [<ffffffff812861c3>] call_rwsem_down_write_failed+0x13/0x20
[396116.483521]  [<ffffffff8147bac0>] ? down_write+0x20/0x30
[396116.524244]  [<ffffffff8121244e>] xfs_ilock+0x7e/0xd0
[396116.564991]  [<ffffffff81239107>] xfs_file_aio_write_checks+0x47/0x150
[396116.606056]  [<ffffffff8123951d>] xfs_file_buffered_aio_write+0x6d/0x180
[396116.647785]  [<ffffffff812397d3>] xfs_file_aio_write+0x1a3/0x2b0
[396116.689301]  [<ffffffff811142a2>] do_sync_write+0xd2/0x110
[396116.730611]  [<ffffffff8104d6ce>] ? perf_event_task_sched_out+0x2e/0x90
[396116.772345]  [<ffffffff8147cc8e>] ? common_interrupt+0xe/0x13
[396116.814509]  [<ffffffff8107dbc8>] ? ktime_get_ts+0xa8/0xe0
[396116.855862]  [<ffffffff811147b8>] vfs_write+0xc8/0x190
[396116.896935]  [<ffffffff8111496c>] sys_write+0x4c/0x90
[396116.937889]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[412651.656492] INFO: task flush-8:16:5619 blocked for more than 120
seconds.
[412651.698333] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[412651.741269] flush-8:16      D ffff88042e6635a0     0  5619      2
0x00000000
[412651.785328]  ffff88042da27120 0000000000000046 ffff88042e3c86a8
0000000000000024
[412651.829433]  0000000000010800 ffff88042da27fd8 ffff88042da26010
0000000000010800
[412651.873521]  ffff88042da27fd8 0000000000010800 ffff88042f89c860
ffff88042e663040
[412651.917893] Call Trace:
[412651.961539]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[412652.005977]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[412652.050757]  [<ffffffff8122cd90>] ? xfs_trans_log_buf+0x90/0xd0
[412652.095552]  [<ffffffff811f9ec0>] ? xfs_btree_log_keys+0x50/0x90
[412652.139883]  [<ffffffff8147bc59>] __down+0x69/0xb0
[412652.184525]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[412652.228969]  [<ffffffff81078c9c>] down+0x3c/0x50
[412652.273330]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[412652.317308]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[412652.361185]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[412652.404909]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[412652.448291]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[412652.492152]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[412652.535849]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[412652.579896]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[412652.624049]  [<ffffffff8127a109>] ? cpumask_next_and+0x29/0x50
[412652.667864]  [<ffffffff810fe9de>] ? alloc_pages_current+0x7e/0xe0
[412652.711426]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[412652.754460]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[412652.796510]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[412652.838066]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[412652.879153]  [<ffffffff81212c73>] ? xfs_iext_get_ext+0x33/0x80
[412652.920043]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[412652.960023]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[412652.999673]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[412653.039712]  [<ffffffff81212c73>] ? xfs_iext_get_ext+0x33/0x80
[412653.079928]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[412653.120173]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[412653.160213]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[412653.202678]  [<ffffffff810cd832>] __writepage+0x12/0x40
[412653.245561]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[412653.285796]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[412653.325281]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[412653.364922]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[412653.404711]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[412653.443941]  [<ffffffff81138454>] writeback_single_inode+0xf4/0x260
[412653.483453]  [<ffffffff81138955>] writeback_sb_inodes+0xe5/0x1b0
[412653.523014]  [<ffffffff81138db9>] writeback_inodes_wb+0x99/0x160
[412653.561999]  [<ffffffff811396f3>] wb_writeback+0x2f3/0x450
[412653.601805]  [<ffffffff8147cc8e>] ? common_interrupt+0xe/0x13
[412653.641066]  [<ffffffff81139a6f>] wb_do_writeback+0x21f/0x270
[412653.679713]  [<ffffffff81139b5a>] bdi_writeback_thread+0x9a/0x230
[412653.717842]  [<ffffffff81139ac0>] ? wb_do_writeback+0x270/0x270
[412653.755257]  [<ffffffff81139ac0>] ? wb_do_writeback+0x270/0x270
[412653.791866]  [<ffffffff81073286>] kthread+0x96/0xa0
[412653.827748]  [<ffffffff8147e314>] kernel_thread_helper+0x4/0x10
[412653.863566]  [<ffffffff810731f0>] ? kthread_worker_fn+0x130/0x130
[412653.898946]  [<ffffffff8147e310>] ? gs_change+0xb/0xb
[412653.934129] INFO: task rsync:16475 blocked for more than 120 seconds.
[412653.969849] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[412654.006947] rsync           D ffff88042e660560     0 16475  16474
0x00000000
[412654.044772]  ffff880487331218 0000000000000082 ffff88042e3c86a8
0000000000000003
[412654.083421]  0000000000010800 ffff880487331fd8 ffff880487330010
0000000000010800
[412654.122261]  ffff880487331fd8 0000000000010800 ffff8801fefcc860
ffff88042e660000
[412654.161041] Call Trace:
[412654.199520]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[412654.238551]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[412654.277727]  [<ffffffff811f9ec0>] ? xfs_btree_log_keys+0x50/0x90
[412654.319874]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[412654.361564]  [<ffffffff8147bc59>] __down+0x69/0xb0
[412654.400663]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[412654.440047]  [<ffffffff81078c9c>] down+0x3c/0x50
[412654.479105]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[412654.518100]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[412654.557207]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[412654.596206]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[412654.634624]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[412654.673479]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[412654.712002]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[412654.750449]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[412654.789052]  [<ffffffff811f59ef>] ?
xfs_bmap_add_extent_delay_real+0x64f/0x1700
[412654.828682]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[412654.867729]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[412654.906586]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[412654.945568]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[412654.984313]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[412655.023299]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[412655.061549]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[412655.101113]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[412655.140458]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[412655.179687]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[412655.219207]  [<ffffffff810cd832>] __writepage+0x12/0x40
[412655.258002]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[412655.296797]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[412655.336008]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[412655.375370]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[412655.414534]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[412655.454009]  [<ffffffff810c4cab>] __filemap_fdatawrite_range+0x5b/0x60
[412655.493627]  [<ffffffff810c4f4e>] filemap_fdatawrite_range+0xe/0x10
[412655.533156]  [<ffffffff812399c7>] xfs_flush_pages+0x67/0xb0
[412655.572856]  [<ffffffff8122fc7a>] xfs_setattr+0x9da/0xa80
[412655.613257]  [<ffffffff8123c8a6>] xfs_vn_setattr+0x16/0x20
[412655.653033]  [<ffffffff8112d9bd>] notify_change+0x11d/0x300
[412655.692725]  [<ffffffff8111328c>] do_truncate+0x5c/0x90
[412655.731966]  [<ffffffff81113387>] sys_ftruncate+0xc7/0xd0
[412655.771199]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[412655.810243] INFO: task rsync:30660 blocked for more than 120 seconds.
[412655.848982] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[412655.888250] rsync           D ffff88042d871d80     0 30660  30659
0x00000000
[412655.927393]  ffff880415137218 0000000000000086 ffff8804151371a8
ffffffff81078be2
[412655.967391]  0000000000010800 ffff880415137fd8 ffff880415136010
0000000000010800
[412656.007316]  ffff880415137fd8 0000000000010800 ffffffff81a0b020
ffff88042d871820
[412656.046983] Call Trace:
[412656.085817]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[412656.126302]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[412656.166035]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[412656.206776]  [<ffffffff812321d5>] ? kmem_zone_zalloc+0x35/0x50
[412656.250152]  [<ffffffff8122cd90>] ? xfs_trans_log_buf+0x90/0xd0
[412656.291970]  [<ffffffff8147bc59>] __down+0x69/0xb0
[412656.331764]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[412656.371898]  [<ffffffff81078c9c>] down+0x3c/0x50
[412656.411888]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[412656.452059]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[412656.492297]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[412656.532531]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[412656.572399]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[412656.612389]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[412656.652851]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[412656.692462]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[412656.731749]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[412656.771739]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[412656.811371]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[412656.850939]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[412656.890922]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[412656.930893]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[412656.970295]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[412657.009689]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[412657.049157]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[412657.088642]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[412657.128997]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[412657.169076]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[412657.209303]  [<ffffffff810cd832>] __writepage+0x12/0x40
[412657.249098]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[412657.288823]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[412657.328563]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[412657.368193]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[412657.407870]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[412657.447095]  [<ffffffff810c4cab>] __filemap_fdatawrite_range+0x5b/0x60
[412657.487191]  [<ffffffff810c4f4e>] filemap_fdatawrite_range+0xe/0x10
[412657.527229]  [<ffffffff812399c7>] xfs_flush_pages+0x67/0xb0
[412657.567153]  [<ffffffff8122fc7a>] xfs_setattr+0x9da/0xa80
[412657.607216]  [<ffffffff8123c8a6>] xfs_vn_setattr+0x16/0x20
[412657.647641]  [<ffffffff8112d9bd>] notify_change+0x11d/0x300
[412657.687480]  [<ffffffff8111328c>] do_truncate+0x5c/0x90
[412657.726860]  [<ffffffff81113387>] sys_ftruncate+0xc7/0xd0
[412657.765326]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[412657.803043] INFO: task rsync:16891 blocked for more than 120 seconds.
[412657.840819] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[412657.879354] rsync           D ffff880044d9b5a0     0 16891  16890
0x00000000
[412657.917922]  ffff88062b129b68 0000000000000086 0000000000000000
ffff880200000001
[412657.956861]  0000000000010800 ffff88062b129fd8 ffff88062b128010
0000000000010800
[412657.996037]  ffff88062b129fd8 0000000000010800 ffffffff81a0b020
ffff880044d9b040
[412658.035286] Call Trace:
[412658.074171]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[412658.113709]  [<ffffffff8147c6bd>] rwsem_down_failed_common+0xbd/0x150
[412658.154355]  [<ffffffff8147c763>] rwsem_down_write_failed+0x13/0x20
[412658.194313]  [<ffffffff812861c3>] call_rwsem_down_write_failed+0x13/0x20
[412658.234820]  [<ffffffff8147bac0>] ? down_write+0x20/0x30
[412658.275104]  [<ffffffff8121244e>] xfs_ilock+0x7e/0xd0
[412658.315310]  [<ffffffff81239107>] xfs_file_aio_write_checks+0x47/0x150
[412658.355943]  [<ffffffff8123951d>] xfs_file_buffered_aio_write+0x6d/0x180
[412658.396638]  [<ffffffff812397d3>] xfs_file_aio_write+0x1a3/0x2b0
[412658.437447]  [<ffffffff811142a2>] do_sync_write+0xd2/0x110
[412658.478284]  [<ffffffff8107dbc8>] ? ktime_get_ts+0xa8/0xe0
[412658.519038]  [<ffffffff811147b8>] vfs_write+0xc8/0x190
[412658.559661]  [<ffffffff8111496c>] sys_write+0x4c/0x90
[412658.599950]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[412658.640329] INFO: task rsync:27527 blocked for more than 120 seconds.
[412658.681340] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[412658.723153] rsync           D ffff88042dde4dc0     0 27527   5627
0x00000000
[412658.765631]  ffff88000c999808 0000000000000086 ffff88042dd4f2e8
ffffc90000000000
[412658.808827]  0000000000010800 ffff88000c999fd8 ffff88000c998010
0000000000010800
[412658.852414]  ffff88000c999fd8 0000000000010800 ffff88042f991820
ffff88042dde4860
[412658.896628] Call Trace:
[412658.939953]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[412658.984168]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[412659.027943]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[412659.071098]  [<ffffffff81235b7a>] ? xfs_buf_cond_lock+0x2a/0xc0
[412659.114604]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[412659.157907]  [<ffffffff8147bc59>] __down+0x69/0xb0
[412659.201369]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[412659.246860]  [<ffffffff81078c9c>] down+0x3c/0x50
[412659.293899]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[412659.337497]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[412659.380474]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[412659.423531]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[412659.466079]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[412659.508637]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[412659.551046]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[412659.593820]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[412659.636680]  [<ffffffff81108e3b>] ? kmem_cache_free+0x1b/0xf0
[412659.679799]  [<ffffffff8122a0ae>] ? xfs_trans_free_item_desc+0x2e/0x30
[412659.723313]  [<ffffffff8122a1e7>] ? xfs_trans_free_items+0x87/0xb0
[412659.766472]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[412659.808765]  [<ffffffff811e6d17>] ? xfs_free_extent+0x97/0x120
[412659.850247]  [<ffffffff811e6d28>] xfs_free_extent+0xa8/0x120
[412659.891039]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[412659.931242]  [<ffffffff811f01cd>] xfs_bmap_finish+0x15d/0x1a0
[412659.970975]  [<ffffffff8121717f>] xfs_itruncate_finish+0x15f/0x330
[412660.010652]  [<ffffffff8122ebe3>] xfs_inactive+0x313/0x470
[412660.049573]  [<ffffffff8123f2ba>] xfs_fs_evict_inode+0xba/0x100
[412660.087971]  [<ffffffff8112c99b>] evict+0x7b/0x140
[412660.126324]  [<ffffffff8112cdd8>] iput_final+0xc8/0x180
[412660.164635]  [<ffffffff8112cec3>] iput+0x33/0x40
[412660.202813]  [<ffffffff811230c4>] do_unlinkat+0x164/0x1c0
[412660.240689]  [<ffffffff81130ed8>] ? mntput+0x18/0x30
[412660.278332]  [<ffffffff811162bd>] ? fput+0x1d/0x30
[412660.315609]  [<ffffffff811126d0>] ? filp_close+0x60/0x90
[412660.352846]  [<ffffffff81123131>] sys_unlink+0x11/0x20
[412660.389835]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[417932.351148] INFO: task flush-8:16:5619 blocked for more than 120
seconds.
[417932.389328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[417932.428412] flush-8:16      D ffff88042e6635a0     0  5619      2
0x00000000
[417932.468679]  ffff88042da27120 0000000000000046 ffff88042e3c86a8
000000000000001e
[417932.509997]  0000000000010800 ffff88042da27fd8 ffff88042da26010
0000000000010800
[417932.550591]  ffff88042da27fd8 0000000000010800 ffff8801fefcc860
ffff88042e663040
[417932.590999] Call Trace:
[417932.629814]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[417932.668838]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[417932.707796]  [<ffffffff811fa733>] ? xfs_btree_del_cursor+0x63/0x70
[417932.746792]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[417932.784584]  [<ffffffff8147bc59>] __down+0x69/0xb0
[417932.822045]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[417932.860343]  [<ffffffff81078c9c>] down+0x3c/0x50
[417932.897945]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[417932.935951]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[417932.973550]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[417933.011390]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[417933.048936]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[417933.086642]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[417933.124124]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[417933.161818]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[417933.199627]  [<ffffffff810fe9de>] ? alloc_pages_current+0x7e/0xe0
[417933.237788]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[417933.276072]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[417933.314175]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[417933.352335]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[417933.390764]  [<ffffffff81212c73>] ? xfs_iext_get_ext+0x33/0x80
[417933.428967]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[417933.466814]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[417933.504962]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[417933.543502]  [<ffffffff81212c73>] ? xfs_iext_get_ext+0x33/0x80
[417933.582007]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[417933.620741]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[417933.659551]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[417933.698203]  [<ffffffff810cd832>] __writepage+0x12/0x40
[417933.736676]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[417933.775417]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[417933.814118]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[417933.852705]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[417933.891799]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[417933.930897]  [<ffffffff81138454>] writeback_single_inode+0xf4/0x260
[417933.970365]  [<ffffffff81138955>] writeback_sb_inodes+0xe5/0x1b0
[417934.009561]  [<ffffffff81138db9>] writeback_inodes_wb+0x99/0x160
[417934.048630]  [<ffffffff811396f3>] wb_writeback+0x2f3/0x450
[417934.087944]  [<ffffffff8147cc8e>] ? common_interrupt+0xe/0x13
[417934.127261]  [<ffffffff81139a6f>] wb_do_writeback+0x21f/0x270
[417934.166603]  [<ffffffff81139b5a>] bdi_writeback_thread+0x9a/0x230
[417934.205473]  [<ffffffff81139ac0>] ? wb_do_writeback+0x270/0x270
[417934.243674]  [<ffffffff81139ac0>] ? wb_do_writeback+0x270/0x270
[417934.280260]  [<ffffffff81073286>] kthread+0x96/0xa0
[417934.316477]  [<ffffffff8147e314>] kernel_thread_helper+0x4/0x10
[417934.352432]  [<ffffffff810731f0>] ? kthread_worker_fn+0x130/0x130
[417934.388926]  [<ffffffff8147e310>] ? gs_change+0xb/0xb
[417934.424356] INFO: task rsync:16475 blocked for more than 120 seconds.
[417934.459973] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[417934.497620] rsync           D ffff88042e660560     0 16475  16474
0x00000000
[417934.538513]  ffff880487331218 0000000000000082 ffff8804873311a8
ffffffff00000000
[417934.579249]  0000000000010800 ffff880487331fd8 ffff880487330010
0000000000010800
[417934.617923]  ffff880487331fd8 0000000000010800 ffff88042fa1e080
ffff88042e660000
[417934.656752] Call Trace:
[417934.695112]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[417934.734191]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[417934.773444]  [<ffffffff812321d5>] ? kmem_zone_zalloc+0x35/0x50
[417934.812649]  [<ffffffff81078be2>] ? down_trylock+0x32/0x50
[417934.852084]  [<ffffffff8147bc59>] __down+0x69/0xb0
[417934.891346]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[417934.931227]  [<ffffffff81078c9c>] down+0x3c/0x50
[417934.970405]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[417935.009641]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[417935.048842]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[417935.087990]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[417935.126664]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[417935.165700]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[417935.204566]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[417935.243406]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[417935.282639]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[417935.322257]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[417935.361292]  [<ffffffff811e6f73>] ? xfs_alloc_vextent+0x1d3/0x580
[417935.400613]  [<ffffffff811e6f0b>] xfs_alloc_vextent+0x16b/0x580
[417935.439495]  [<ffffffff811f0e77>] xfs_bmap_btalloc+0x257/0x6e0
[417935.478274]  [<ffffffff811f1309>] xfs_bmap_alloc+0x9/0x10
[417935.517264]  [<ffffffff811f77fe>] xfs_bmapi+0x99e/0x1090
[417935.555550]  [<ffffffff811ef165>] ?
xfs_bmap_search_multi_extents+0xa5/0x110
[417935.594479]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[417935.633438]  [<ffffffff81218bb6>] xfs_iomap_write_allocate+0x176/0x330
[417935.672722]  [<ffffffff81234051>] xfs_map_blocks+0x1d1/0x260
[417935.712129]  [<ffffffff812342a2>] xfs_vm_writepage+0x1c2/0x500
[417935.751264]  [<ffffffff810cd832>] __writepage+0x12/0x40
[417935.789867]  [<ffffffff810cea59>] write_cache_pages+0x239/0x4d0
[417935.828959]  [<ffffffff810cd820>] ? set_page_dirty+0x70/0x70
[417935.868322]  [<ffffffff81134688>] ? generic_getxattr+0x88/0x90
[417935.907789]  [<ffffffff810ced3c>] generic_writepages+0x4c/0x70
[417935.947262]  [<ffffffff81232dff>] xfs_vm_writepages+0x4f/0x60
[417935.986511]  [<ffffffff810ced7c>] do_writepages+0x1c/0x40
[417936.025537]  [<ffffffff810c4cab>] __filemap_fdatawrite_range+0x5b/0x60
[417936.065140]  [<ffffffff810c4f4e>] filemap_fdatawrite_range+0xe/0x10
[417936.105320]  [<ffffffff812399c7>] xfs_flush_pages+0x67/0xb0
[417936.145237]  [<ffffffff8122fc7a>] xfs_setattr+0x9da/0xa80
[417936.185206]  [<ffffffff8123c8a6>] xfs_vn_setattr+0x16/0x20
[417936.224767]  [<ffffffff8112d9bd>] notify_change+0x11d/0x300
[417936.264369]  [<ffffffff8111328c>] do_truncate+0x5c/0x90
[417936.303371]  [<ffffffff81113387>] sys_ftruncate+0xc7/0xd0
[417936.341555]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b
[417936.379030] INFO: task rsync:25549 blocked for more than 120 seconds.
[417936.417012] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[417936.455324] rsync           D ffff88042daa35a0     0 25549   5627
0x00000000
[417936.493927]  ffff8801fd84b808 0000000000000082 ffff8801fd84b7b8
0000000000000000
[417936.532884]  0000000000010800 ffff8801fd84bfd8 ffff8801fd84a010
0000000000010800
[417936.571574]  ffff8801fd84bfd8 0000000000010800 ffffffff81a0b020
ffff88042daa3040
[417936.611035] Call Trace:
[417936.649563]  [<ffffffff8147aa2a>] schedule+0x3a/0x60
[417936.688577]  [<ffffffff8147ae65>] schedule_timeout+0x1d5/0x2b0
[417936.728017]  [<ffffffff81201098>] ? xfs_da_do_buf+0x5f8/0x760
[417936.767408]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[417936.806501]  [<ffffffff8147bc59>] __down+0x69/0xb0
[417936.845640]  [<ffffffff812366d6>] ? _xfs_buf_find+0xf6/0x270
[417936.885062]  [<ffffffff81078c9c>] down+0x3c/0x50
[417936.925012]  [<ffffffff81235ab0>] xfs_buf_lock+0x40/0xe0
[417936.964598]  [<ffffffff812366d6>] _xfs_buf_find+0xf6/0x270
[417937.004007]  [<ffffffff812368a9>] xfs_buf_get+0x59/0x190
[417937.043544]  [<ffffffff81236f07>] xfs_buf_read+0x27/0x100
[417937.082900]  [<ffffffff8122d118>] xfs_trans_read_buf+0x1e8/0x410
[417937.122465]  [<ffffffff811e3741>] xfs_read_agf+0x61/0x1a0
[417937.161379]  [<ffffffff811e38b4>] xfs_alloc_read_agf+0x34/0xd0
[417937.200439]  [<ffffffff811e6c11>] xfs_alloc_fix_freelist+0x401/0x470
[417937.239532]  [<ffffffff81108e3b>] ? kmem_cache_free+0x1b/0xf0
[417937.278505]  [<ffffffff8122a0ae>] ? xfs_trans_free_item_desc+0x2e/0x30
[417937.317752]  [<ffffffff8122a1e7>] ? xfs_trans_free_items+0x87/0xb0
[417937.356843]  [<ffffffff81226c73>] ? xfs_perag_get+0x33/0xb0
[417937.396008]  [<ffffffff811e6d17>] ? xfs_free_extent+0x97/0x120
[417937.435181]  [<ffffffff811e6d28>] xfs_free_extent+0xa8/0x120
[417937.473635]  [<ffffffff81232127>] ? kmem_zone_alloc+0x77/0xf0
[417937.511878]  [<ffffffff811f01cd>] xfs_bmap_finish+0x15d/0x1a0
[417937.553173]  [<ffffffff8121717f>] xfs_itruncate_finish+0x15f/0x330
[417937.595039]  [<ffffffff8122ebe3>] xfs_inactive+0x313/0x470
[417937.633483]  [<ffffffff8123f2ba>] xfs_fs_evict_inode+0xba/0x100
[417937.671809]  [<ffffffff8112c99b>] evict+0x7b/0x140
[417937.710082]  [<ffffffff8112cdd8>] iput_final+0xc8/0x180
[417937.748325]  [<ffffffff8112cec3>] iput+0x33/0x40
[417937.786032]  [<ffffffff811230c4>] do_unlinkat+0x164/0x1c0
[417937.823972]  [<ffffffff81114815>] ? vfs_write+0x125/0x190
[417937.861674]  [<ffffffff81002dcb>] ? math_state_restore+0x3b/0x70
[417937.899449]  [<ffffffff81123131>] sys_unlink+0x11/0x20
[417937.936815]  [<ffffffff8147d2bb>] system_call_fastpath+0x16/0x1b

Any ideas what this is?

mount options are:rw,noatime,nodiratime,inode64,logbufs=8,logbsize=256k

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
