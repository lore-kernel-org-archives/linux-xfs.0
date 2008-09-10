Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Sep 2008 23:12:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8A6CGNi018301
	for <xfs@oss.sgi.com>; Tue, 9 Sep 2008 23:12:17 -0700
Received: from smtp5.pp.htv.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 057FE105BFD6
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2008 23:13:41 -0700 (PDT)
Received: from smtp5.pp.htv.fi (smtp5.pp.htv.fi [213.243.153.39]) by cuda.sgi.com with ESMTP id 9OjiAXObFaDAbFui for <xfs@oss.sgi.com>; Tue, 09 Sep 2008 23:13:41 -0700 (PDT)
Message-ID: <20080910091340.rjubi6txm8s8088o@webmail.welho.com>
Date: Wed, 10 Sep 2008 09:13:40 +0300
From: eerov@welho.com
Subject: xfs bug/crash on
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_1yieh1lc7ue8"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: eerov@welho.com

This message is in MIME format.

--=_1yieh1lc7ue8
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Backup3 2.6.26.3 #6 SMP Tue Sep 2 11:20:20 EEST 2008 x86_64 x86_64  
x86_64 GNU/Linux

xfs? crash with dollowing error messages.

any helps. thanks?

--
Eero



--=_1yieh1lc7ue8
Content-Type: text/plain;
	charset=UTF-8;
	name="errors"
Content-Disposition: attachment;
	filename="errors"
Content-Transfer-Encoding: quoted-printable

02aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928  19926
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982  19980
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19928 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011f03e400     0 19928      1
 ffff810102ac9ca8 0000000000000082 ffff81011e54f0b8 ffff81011e54f080
 ffff81011dcce3c0 ffff81011f03e400 ffff81011f04c440 ffff81011f03e760
 0000000394bf55f0 0000000000000001 0000000000000000 ffff81005b9e3080
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task scp:19982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scp           D ffff81011e5a15e0     0 19982      1
 ffff8100082ebca8 0000000000000082 ffff81003cc00ab8 ffff81003cc00a80
 ffff810008231740 ffff81011e5a15e0 ffff81011d040920 ffff81011e5a1940
 00000003d8c0a370 0000000000000001 0000000000000000 ffff8101187b8d00
Call Trace:
 [<ffffffff804729f5>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff8047288b>] mutex_lock+0x1a/0x1e
 [<ffffffffa0360fa5>] :xfs:xfs_write+0x1b8/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda

INFO: task xfsdatad/2:2636 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsdatad/2    D ffff810111cf4eb0     0  2636      2
 ffff81011b909e40 0000000000000046 ffff810001079760 ffff81011dd46858
 ffff81011b909de0 ffff81011dd46820 ffff81011b098080 ffff81011dd46b80
 0000000201079760 ffff81011f0c41f8 ffff81011b909e00 ffff810001079700
Call Trace:
 [<ffffffff80473591>] __down_write_nested+0x71/0x8b
 [<ffffffffa035a189>] :xfs:xfs_setfilesize+0x2d/0x8d
 [<ffffffffa035a2ca>] :xfs:xfs_end_bio_delalloc+0x0/0x19
 [<ffffffffa035a2da>] :xfs:xfs_end_bio_delalloc+0x10/0x19
 [<ffffffff8023f17d>] run_workqueue+0x7b/0x103
 [<ffffffff8023f9f8>] worker_thread+0xd5/0xe0
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023f923>] worker_thread+0x0/0xe0
 [<ffffffff80242093>] kthread+0x47/0x74
 [<ffffffff8022c898>] schedule_tail+0x28/0x5d
 [<ffffffff8020cb98>] child_rip+0xa/0x12
 [<ffffffff8024204c>] kthread+0x0/0x74
 [<ffffffff8020cb8e>] child_rip+0x0/0x12

INFO: task gzip:12426 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gzip          D ffffffff8048d4c0     0 12426  12425
 ffff81011a8a2f38 0000000000000082 0000000000000000 ffff81011a8a3008
 000000021a8a2f28 ffff81011b098080 ffff81011fb3d5a0 ffff81011b0983e0
 000000020106dd80 000000011b8ec6ae ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff8026246d>] sync_page+0x0/0x41
 [<ffffffff8047252f>] io_schedule+0x5d/0x9f
 [<ffffffff802624a9>] sync_page+0x3c/0x41
 [<ffffffff8047278a>] __wait_on_bit+0x40/0x6f
 [<ffffffff802626e7>] wait_on_page_bit+0x6c/0x72
 [<ffffffff802421f0>] wake_bit_function+0x0/0x23
 [<ffffffff8026b592>] shrink_page_list+0x107/0x545
 [<ffffffff8024486a>] ktime_get_ts+0x22/0x4b
 [<ffffffff80260c07>] delayacct_end+0x7d/0x88
 [<ffffffff804724a9>] io_schedule_timeout+0x8b/0xb4
 [<ffffffff8026dd3f>] congestion_wait+0x75/0x81
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026bb4a>] shrink_inactive_list+0x17a/0x34b
 [<ffffffff8026bdfd>] shrink_zone+0xe2/0x106
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffff8026c15b>] try_to_free_pages+0x1e6/0x305
 [<ffffffff8026b2b1>] isolate_pages_global+0x0/0x2f
 [<ffffffff80267a17>] __alloc_pages_internal+0x26d/0x3c2
 [<ffffffff80284319>] kmem_getpages+0x96/0x15f
 [<ffffffff802848f4>] fallback_alloc+0x120/0x1b4
 [<ffffffff80284db9>] __kmalloc+0xf9/0x122
 [<ffffffffa035a021>] :xfs:kmem_alloc+0x60/0xc4
 [<ffffffffa035a0a2>] :xfs:kmem_realloc+0x1d/0x53
 [<ffffffffa033eeef>] :xfs:xfs_iext_realloc_indirect+0x35/0x3b
 [<ffffffffa033f24d>] :xfs:xfs_iext_irec_new+0x3e/0xc2
 [<ffffffffa033fd78>] :xfs:xfs_iext_add+0x1b1/0x1e5
 [<ffffffffa033fdc8>] :xfs:xfs_iext_insert+0x1c/0x4b
 [<ffffffffa032361a>] :xfs:xfs_bmap_add_extent_hole_delay+0x31c/0x39f
 [<ffffffffa0325037>] :xfs:xfs_bmap_add_extent+0x169/0x3a6
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0327ba6>] :xfs:xfs_bmapi+0x8b9/0xe9e
 [<ffffffffa033e980>] :xfs:xfs_iext_get_ext+0x34/0x5a
 [<ffffffffa0321824>] :xfs:xfs_bmap_search_multi_extents+0x83/0xda
 [<ffffffffa0344340>] :xfs:xfs_iomap_write_delay+0x1d3/0x250
 [<ffffffffa034497b>] :xfs:xfs_iomap+0x1cf/0x298
 [<ffffffff8026d62a>] zone_statistics+0x3a/0x8e
 [<ffffffffa035a9cf>] :xfs:__xfs_get_blocks+0x5f/0x198
 [<ffffffff802a8fc7>] alloc_buffer_head+0x3d/0x42
 [<ffffffff802a96c1>] alloc_page_buffers+0x81/0xd4
 [<ffffffff802aa6cb>] __block_prepare_write+0x19d/0x36c
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff8026279d>] add_to_page_cache_lru+0x1c/0x22
 [<ffffffff802aa937>] block_write_begin+0x78/0xca
 [<ffffffffa035a560>] :xfs:xfs_vm_write_begin+0x22/0x27
 [<ffffffffa035ab19>] :xfs:xfs_get_blocks+0x0/0xe
 [<ffffffff802631b1>] generic_file_buffered_write+0x14a/0x62c
 [<ffffffff8023515c>] current_fs_time+0x1e/0x24
 [<ffffffff80319e94>] __up_write+0x27/0xf3
 [<ffffffffa03612e3>] :xfs:xfs_write+0x4f6/0x70b
 [<ffffffff8028a4cf>] do_sync_write+0xc9/0x10c
 [<ffffffff802421c2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8047218d>] thread_return+0x3d/0x9c
 [<ffffffff8028ac31>] vfs_write+0xad/0x136
 [<ffffffff8028b16e>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda


--=_1yieh1lc7ue8--
