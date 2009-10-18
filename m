Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9IKGBV8000446 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 15:16:12 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC400176A6B6
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 13:17:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id XGzYyBKNErw07CWw for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 13:17:43 -0700 (PDT)
Date: Sun, 18 Oct 2009 16:17:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
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
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>



On Sat, 17 Oct 2009, Justin Piszcz wrote:

> Hello,

It has happened again, all sysrq-X output was saved this time.

wget http://home.comcast.net/~jpiszcz/20091018/crash.txt
wget http://home.comcast.net/~jpiszcz/20091018/dmesg.txt
wget http://home.comcast.net/~jpiszcz/20091018/interrupts.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-l.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-m.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-p.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-q.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-t.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-w.txt

Kernel configuration:

wget http://home.comcast.net/~jpiszcz/20091018/config-2.6.30.9.txt
wget http://home.comcast.net/~jpiszcz/20091018/config-2.6.31.4.txt

Diff of the two configs:

$ diff config-2.6.30.9.txt config-2.6.31.4.txt |grep -v "#"|grep "_"
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_CONSTRUCTORS=y
> CONFIG_HAVE_PERF_COUNTERS=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_X86_NEW_MCE=y
> CONFIG_X86_THERMAL_VECTOR=y
< CONFIG_UNEVICTABLE_LRU=y
< CONFIG_PHYSICAL_START=0x200000
> CONFIG_PHYSICAL_START=0x1000000
< CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_PHYSICAL_ALIGN=0x1000000
< CONFIG_COMPAT_NET_DEV_OPS=y
< CONFIG_SND_JACK=y
> CONFIG_HID_DRAGONRISE=y
> CONFIG_HID_GREENASIA=y
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_HID_THRUSTMASTER=y
> CONFIG_HID_ZEROPLUS=y
> CONFIG_FSNOTIFY=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y

I have reverted back to 2.6.30.9 to see if the problem recurs with this
kernel version.

I do not recall seeing this on the older 2.6.30.x kernels:

[    9.276427] md3: detected capacity change from 0 to 5251073572864
[    9.277411] md2: detected capacity change from 0 to 132706598912
[    9.278305] md1: detected capacity change from 0 to 139722752
[    9.278921] md0: detected capacity change from 0 to 17190682624

Again, some more D-state processes:

[76325.608073] pdflush       D 0000000000000001     0   362      2 0x00000000
[76325.608087] Call Trace:
[76325.608095]  [<ffffffff811ea1c0>] ? xfs_trans_brelse+0x30/0x130
[76325.608099]  [<ffffffff811dc44c>] ? xlog_state_sync+0x26c/0x2a0
[76325.608103]  [<ffffffff810513e0>] ? default_wake_function+0x0/0x10
[76325.608106]  [<ffffffff811dc4d1>] ? _xfs_log_force+0x51/0x80
[76325.608108]  [<ffffffff811dc50b>] ? xfs_log_force+0xb/0x40

[76325.608202] xfssyncd      D 0000000000000000     0   831      2 0x00000000
[76325.608214] Call Trace:
[76325.608216]  [<ffffffff811dc229>] ? xlog_state_sync+0x49/0x2a0
[76325.608220]  [<ffffffff811d3485>] ? __xfs_iunpin_wait+0x95/0xe0
[76325.608222]  [<ffffffff81069c20>] ? autoremove_wake_function+0x0/0x30
[76325.608225]  [<ffffffff811d566d>] ? xfs_iflush+0xdd/0x2f0
[76325.608228]  [<ffffffff811fbe28>] ? xfs_reclaim_inode+0x148/0x190
[76325.608231]  [<ffffffff811fbe70>] ? xfs_reclaim_inode_now+0x0/0xa0
[76325.608233]  [<ffffffff811fc8dc>] ? xfs_inode_ag_walk+0x6c/0xc0
[76325.608236]  [<ffffffff811fbe70>] ? xfs_reclaim_inode_now+0x0/0xa0

All of the D-state processes:

$ cat sysrq-w.txt  |grep ' D'
[76307.285125] alpine        D 0000000000000000     0  7659  29120 0x00000000
[76325.608073] pdflush       D 0000000000000001     0   362      2 0x00000000
[76325.608202] xfssyncd      D 0000000000000000     0   831      2 0x00000000
[76325.608257] syslogd       D 0000000000000002     0  2438      1 0x00000000
[76325.608318] freshclam     D 0000000000000000     0  2877      1 0x00000000
[76325.608428] asterisk      D 0000000000000001     0  3278      1 0x00000000
[76325.608492] console-kit-d D 0000000000000000     0  3299      1 0x00000000
[76325.608562] dhcpd3        D 0000000000000000     0  3554      1 0x00000000
[76325.608621] plasma-deskto D 0000000000000002     0 32482      1 0x00000000
[76325.608713] kaccess       D 0000000000000001     0 32488      1 0x00000000
[76325.608752] mail          D 0000000000000000     0  7397   7386 0x00000000
[76325.608830] hal-acl-tool  D 0000000000000000     0  7430   3399 0x00000004
[76325.608888] mrtg          D 0000000000000000     0  7444   7433 0x00000000
[76325.608981] cron          D 0000000000000000     0  7500   3630 0x00000000
[76325.609000] alpine        D 0000000000000000     0  7659  29120 0x00000000

List of functions underneath the D-state processes (sorted/uniqued)--

     121 [<ffffffff81069c20>] ? autoremove_wake_function+0x0/0x30
      77 [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b
      62 [<ffffffff814543a5>] ? schedule_timeout+0x165/0x1a0
      60 [<ffffffff813bc1f6>] ? __alloc_skb+0x66/0x170
      60 [<ffffffff813b3e59>] ? sys_sendto+0x119/0x180
      59 [<ffffffff81428397>] ? unix_dgram_sendmsg+0x467/0x5c0
      59 [<ffffffff81427ce6>] ? unix_wait_for_peer+0x86/0xd0
      59 [<ffffffff813bd497>] ? memcpy_fromiovec+0x57/0x80
      59 [<ffffffff813b6c29>] ? sock_alloc_send_pskb+0x1d9/0x2f0
      59 [<ffffffff813b3a4b>] ? sock_sendmsg+0xcb/0x100
      59 [<ffffffff813b3062>] ? sockfd_lookup_light+0x22/0x80
      58 [<ffffffff814287ed>] ? unix_dgram_connect+0xad/0x270
      58 [<ffffffff813b3336>] ? sys_connect+0x86/0xe0
      57 [<ffffffff81427ed5>] ? unix_find_other+0x1a5/0x200
      57 [<ffffffff810c9d13>] ? mntput_no_expire+0x23/0xf0
      57 [<ffffffff810a3e74>] ? page_add_new_anon_rmap+0x54/0x90
      57 [<ffffffff8105947e>] ? current_fs_time+0x1e/0x30
      55 [<ffffffff81085445>] ? filemap_fault+0x95/0x3e0
       8 [<ffffffff810513e0>] ? default_wake_function+0x0/0x10
       7 [<ffffffff811e8fd8>] ? xfs_trans_reserve+0xa8/0x220
       7 [<ffffffff810af727>] ? do_sys_open+0x97/0x150
       6 [<ffffffff811dc4d1>] ? _xfs_log_force+0x51/0x80
       5 [<ffffffff811dd7f0>] ? xlog_grant_push_ail+0x30/0xf0
       4 [<ffffffff811f5284>] ? xfs_file_fsync+0x54/0x70
       4 [<ffffffff811f42e2>] ? xfs_buf_iorequest+0x42/0x90
       4 [<ffffffff811f0242>] ? kmem_zone_zalloc+0x32/0x50
       4 [<ffffffff811f01d3>] ? kmem_zone_alloc+0x83/0xc0
       4 [<ffffffff811dc44c>] ? xlog_state_sync+0x26c/0x2a0
       4 [<ffffffff810d3a4b>] ? sys_fsync+0xb/0x20
       4 [<ffffffff810d39f6>] ? do_fsync+0x36/0x60
       4 [<ffffffff810d394e>] ? vfs_fsync+0x9e/0x110
       4 [<ffffffff810bbcde>] ? __link_path_walk+0x7e/0x1000
       3 [<ffffffff81454866>] ? __mutex_lock_slowpath+0xd6/0x160
       3 [<ffffffff814546ba>] ? mutex_lock+0x1a/0x40
       3 [<ffffffff811f7b82>] ? xfs_vn_mknod+0x82/0x130
       3 [<ffffffff811eeab1>] ? xfs_fsync+0x141/0x190
       3 [<ffffffff811e8f1b>] ? _xfs_trans_commit+0x38b/0x3a0
       3 [<ffffffff811ddfac>] ? xlog_grant_log_space+0x28c/0x3c0
       3 [<ffffffff811dd66d>] ? xlog_bdstrat_cb+0x3d/0x50
       3 [<ffffffff811dc50b>] ? xfs_log_force+0xb/0x40
       3 [<ffffffff811dc1b0>] ? xfs_log_release_iclog+0x10/0x40
       3 [<ffffffff811db05b>] ? xlog_sync+0x20b/0x4e0
       3 [<ffffffff811b6a42>] ? xfs_bmapi+0x9e2/0x11a0
       3 [<ffffffff811b41e8>] ? xfs_bmap_btalloc+0x598/0xa40
       3 [<ffffffff811a7aa8>] ? xfs_alloc_vextent+0x368/0x4b0
       3 [<ffffffff811a7223>] ? xfs_alloc_ag_vextent+0x123/0x130
       3 [<ffffffff810c80ca>] ? alloc_fd+0x4a/0x140
       3 [<ffffffff810c2110>] ? pollwake+0x0/0x60
       3 [<ffffffff810c0b88>] ? poll_freewait+0x48/0xb0
       3 [<ffffffff810be8ee>] ? do_filp_open+0x9ee/0xac0
       3 [<ffffffff810be134>] ? do_filp_open+0x234/0xac0
       3 [<ffffffff810baeb6>] ? vfs_create+0xa6/0xf0
       3 [<ffffffff810b51d7>] ? vfs_fstatat+0x37/0x80
       3 [<ffffffff810ad46d>] ? kmem_cache_alloc+0x6d/0xa0
       3 [<ffffffff8104aca3>] ? __wake_up+0x43/0x70
       2 [<ffffffff81455797>] ? __down_write_nested+0x17/0xb0
       2 [<ffffffff81455151>] ? __down+0x61/0xa0
       2 [<ffffffff81454e85>] ? do_nanosleep+0x95/0xd0
       2 [<ffffffff81454dbd>] ? schedule_hrtimeout_range+0x11d/0x140
       2 [<ffffffff81454359>] ? schedule_timeout+0x119/0x1a0
       2 [<ffffffff811fbe70>] ? xfs_reclaim_inode_now+0x0/0xa0
       2 [<ffffffff811f4b82>] ? xfs_buf_read_flags+0x12/0xa0
       2 [<ffffffff811f4a4e>] ? xfs_buf_get_flags+0x6e/0x190
       2 [<ffffffff811f48f4>] ? _xfs_buf_find+0x134/0x220
       2 [<ffffffff811f23b7>] ? xfs_vm_writepage+0x77/0x130
       2 [<ffffffff811f1e04>] ? xfs_page_state_convert+0x414/0x6c0
       2 [<ffffffff811f0d15>] ? xfs_map_blocks+0x25/0x30
       2 [<ffffffff811ed872>] ? xfs_create+0x312/0x530
       2 [<ffffffff811eb6e8>] ? xfs_dir_ialloc+0xa8/0x340
       2 [<ffffffff811ea4a6>] ? xfs_trans_read_buf+0x1e6/0x360
       2 [<ffffffff811dc337>] ? xlog_state_sync+0x157/0x2a0
       2 [<ffffffff811d8c00>] ? xfs_iomap+0x2c0/0x300
       2 [<ffffffff811d805e>] ? xfs_iomap_write_allocate+0x23e/0x3b0
       2 [<ffffffff810c31dc>] ? dput+0xac/0x160
       2 [<ffffffff810c29d3>] ? d_kill+0x53/0x70
       2 [<ffffffff810b9b38>] ? generic_permission+0x78/0x130
       2 [<ffffffff8109a9a5>] ? handle_mm_fault+0x1b5/0x780
       2 [<ffffffff810987fa>] ? __do_fault+0x3ca/0x4b0
       2 [<ffffffff8108cc30>] ? pdflush+0x0/0x220
       2 [<ffffffff8108bd30>] ? do_writepages+0x20/0x40
       2 [<ffffffff8108baff>] ? write_cache_pages+0x1df/0x3c0
       2 [<ffffffff8108b21a>] ? __writepage+0xa/0x40
       2 [<ffffffff8108b210>] ? __writepage+0x0/0x40
       2 [<ffffffff8108ab88>] ? __alloc_pages_nodemask+0x108/0x5f0
       2 [<ffffffff81084b6b>] ? find_get_page+0x1b/0xb0
       2 [<ffffffff8106e016>] ? down+0x46/0x50
       2 [<ffffffff8106d4e0>] ? sys_nanosleep+0x70/0x80
       2 [<ffffffff8106d3e2>] ? hrtimer_nanosleep+0xa2/0x130
       2 [<ffffffff8106d1ab>] ? __hrtimer_start_range_ns+0x12b/0x2a0
       2 [<ffffffff8106c960>] ? hrtimer_wakeup+0x0/0x30
       2 [<ffffffff81069bd8>] ? __wake_up_bit+0x28/0x30
       2 [<ffffffff81069886>] ? kthread+0xa6/0xb0
       2 [<ffffffff810697e0>] ? kthread+0x0/0xb0
       2 [<ffffffff8105efb0>] ? process_timeout+0x0/0x10
       2 [<ffffffff8105ee14>] ? try_to_del_timer_sync+0x54/0x60
       2 [<ffffffff8105eaa4>] ? lock_timer_base+0x34/0x70
       2 [<ffffffff8102d4ba>] ? child_rip+0xa/0x20
       2 [<ffffffff8102d4b0>] ? child_rip+0x0/0x20
       1 [<ffffffff81455b09>] ? _spin_lock_bh+0x9/0x20
       1 [<ffffffff81455857>] ? __down_read+0x17/0xae
       1 [<ffffffff814545d0>] ? __wait_on_bit+0x50/0x80
       1 [<ffffffff81454144>] ? io_schedule+0x34/0x50
       1 [<ffffffff81453741>] ? wait_for_common+0x151/0x180
       1 [<ffffffff81403c26>] ? tcp_write_xmit+0x206/0xa30
       1 [<ffffffff813f73b9>] ? tcp_sendmsg+0x859/0xb10
       1 [<ffffffff813b675f>] ? sk_reset_timer+0xf/0x20
       1 [<ffffffff813b6273>] ? release_sock+0x13/0xa0
       1 [<ffffffff813b270a>] ? sock_aio_write+0x13a/0x150
       1 [<ffffffff81272408>] ? tty_ldisc_try+0x48/0x60
       1 [<ffffffff8126c391>] ? tty_write+0x221/0x270
       1 [<ffffffff81221960>] ? swiotlb_map_page+0x0/0x100
       1 [<ffffffff81219361>] ? __up_read+0x21/0xc0
       1 [<ffffffff811fca29>] ? xfs_sync_worker+0x49/0x80
       1 [<ffffffff811fc993>] ? xfs_inode_ag_iterator+0x63/0xa0
       1 [<ffffffff811fc8dc>] ? xfs_inode_ag_walk+0x6c/0xc0
       1 [<ffffffff811fc0ec>] ? xfssyncd+0x13c/0x1c0
       1 [<ffffffff811fbfb0>] ? xfssyncd+0x0/0x1c0
       1 [<ffffffff811fbe28>] ? xfs_reclaim_inode+0x148/0x190
       1 [<ffffffff811f8645>] ? xfs_bdstrat_cb+0x45/0x50
       1 [<ffffffff811f8076>] ? xfs_vn_setattr+0x16/0x20
       1 [<ffffffff811f54dd>] ? xfs_flush_pages+0xad/0xc0
       1 [<ffffffff811f5423>] ? xfs_wait_on_pages+0x23/0x30
       1 [<ffffffff811f52b0>] ? xfs_file_release+0x10/0x20
       1 [<ffffffff811f3f8b>] ? xfs_buf_rele+0x3b/0x100
       1 [<ffffffff811f3d65>] ? _xfs_buf_lookup_pages+0x265/0x340
       1 [<ffffffff811f0daf>] ? __xfs_get_blocks+0x8f/0x220
       1 [<ffffffff811ef5e6>] ? xfs_setattr+0x826/0x880
       1 [<ffffffff811ee9c6>] ? xfs_fsync+0x56/0x190
       1 [<ffffffff811ee907>] ? xfs_release+0x167/0x1d0
       1 [<ffffffff811edb20>] ? xfs_lookup+0x90/0xe0
       1 [<ffffffff811ed96b>] ? xfs_create+0x40b/0x530
       1 [<ffffffff811eab8a>] ? xfs_trans_iget+0xda/0x100
       1 [<ffffffff811eaa48>] ? xfs_trans_ijoin+0x38/0xa0
       1 [<ffffffff811ea9d7>] ? xfs_trans_log_inode+0x27/0x60
       1 [<ffffffff811ea948>] ? xfs_trans_get_efd+0x28/0x40
       1 [<ffffffff811ea1c0>] ? xfs_trans_brelse+0x30/0x130
       1 [<ffffffff811dc229>] ? xlog_state_sync+0x49/0x2a0
       1 [<ffffffff811d566d>] ? xfs_iflush+0xdd/0x2f0
       1 [<ffffffff811d50ff>] ? xfs_ialloc+0x52f/0x6f0
       1 [<ffffffff811d4c8e>] ? xfs_ialloc+0xbe/0x6f0
       1 [<ffffffff811d4c4e>] ? xfs_ialloc+0x7e/0x6f0
       1 [<ffffffff811d483a>] ? xfs_itruncate_finish+0x15a/0x320
       1 [<ffffffff811d3485>] ? __xfs_iunpin_wait+0x95/0xe0
       1 [<ffffffff811d17dd>] ? xfs_iget+0xfd/0x480
       1 [<ffffffff811d17cb>] ? xfs_iget+0xeb/0x480
       1 [<ffffffff811d0341>] ? xfs_dialloc+0x2e1/0xa70
       1 [<ffffffff811cee12>] ? xfs_ialloc_ag_select+0x222/0x320
       1 [<ffffffff811ceaaf>] ? xfs_ialloc_read_agi+0x1f/0x80
       1 [<ffffffff811ce9f1>] ? xfs_read_agi+0x71/0x110
       1 [<ffffffff811cbf90>] ? xfs_dir2_sf_addname+0x430/0x5c0
       1 [<ffffffff811c3a4f>] ? xfs_dir2_sf_to_block+0x9f/0x5c0
       1 [<ffffffff811c388a>] ? xfs_dir_createname+0x17a/0x1d0
       1 [<ffffffff811c2bda>] ? xfs_dir2_grow_inode+0x15a/0x3f0
       1 [<ffffffff811b4bf4>] ? xfs_bmap_finish+0x164/0x1b0
       1 [<ffffffff811a76fe>] ? xfs_free_extent+0x7e/0xc0
       1 [<ffffffff811a75a9>] ? xfs_alloc_fix_freelist+0x379/0x450
       1 [<ffffffff811a5450>] ? xfs_alloc_read_agf+0x30/0xd0
       1 [<ffffffff811a52f8>] ? xfs_read_agf+0x68/0x190
       1 [<ffffffff810e38cf>] ? sys_epoll_wait+0x22f/0x2e0
       1 [<ffffffff810d5b76>] ? __set_page_dirty+0x66/0xd0
       1 [<ffffffff810d00f6>] ? writeback_inodes+0x46/0xe0
       1 [<ffffffff810cfe46>] ? generic_sync_sb_inodes+0x2e6/0x4b0
       1 [<ffffffff810cf6a9>] ? writeback_single_inode+0x1e9/0x460
       1 [<ffffffff810c7341>] ? notify_change+0x101/0x2f0
       1 [<ffffffff810c47da>] ? __d_lookup+0xaa/0x140
       1 [<ffffffff810c1ff0>] ? __pollwait+0x0/0x120
       1 [<ffffffff810c1f31>] ? sys_select+0x51/0x110
       1 [<ffffffff810c1b9f>] ? core_sys_select+0x1ff/0x310
       1 [<ffffffff810c182f>] ? do_select+0x4ff/0x670
       1 [<ffffffff810c0b1c>] ? poll_schedule_timeout+0x2c/0x50
       1 [<ffffffff810be5a0>] ? do_filp_open+0x6a0/0xac0
       1 [<ffffffff810bb851>] ? may_open+0x1c1/0x1f0
       1 [<ffffffff810b9e50>] ? get_write_access+0x20/0x60
       1 [<ffffffff810b2c0d>] ? __fput+0xcd/0x1e0
       1 [<ffffffff810b2233>] ? sys_write+0x53/0xa0
       1 [<ffffffff810b1533>] ? do_sync_write+0xe3/0x130
       1 [<ffffffff810b060e>] ? do_truncate+0x5e/0x80
       1 [<ffffffff810af636>] ? sys_close+0xa6/0x100
       1 [<ffffffff810af556>] ? filp_close+0x56/0x90
       1 [<ffffffff810ace06>] ? cache_alloc_refill+0x96/0x590
       1 [<ffffffff8108d71a>] ? pagevec_lookup_tag+0x1a/0x30
       1 [<ffffffff8108cd40>] ? pdflush+0x110/0x220
       1 [<ffffffff8108beb6>] ? wb_kupdate+0xb6/0x140
       1 [<ffffffff8108be00>] ? wb_kupdate+0x0/0x140
       1 [<ffffffff81085abd>] ? __filemap_fdatawrite_range+0x4d/0x60
       1 [<ffffffff810859d3>] ? wait_on_page_writeback_range+0xc3/0x140
       1 [<ffffffff81084fac>] ? wait_on_page_bit+0x6c/0x80
       1 [<ffffffff81084e83>] ? find_lock_page+0x23/0x80
       1 [<ffffffff81084d95>] ? sync_page+0x35/0x60
       1 [<ffffffff81084d60>] ? sync_page+0x0/0x60
       1 [<ffffffff8106ee8e>] ? sched_clock_cpu+0x6e/0x250
       1 [<ffffffff81069c50>] ? wake_bit_function+0x0/0x30
       1 [<ffffffff81069c29>] ? autoremove_wake_function+0x9/0x30
       1 [<ffffffff81064e09>] ? sys_setpriority+0x89/0x240
       1 [<ffffffff8105444e>] ? do_fork+0x16e/0x360
       1 [<ffffffff810512bf>] ? try_to_wake_up+0xaf/0x1d0
       1 [<ffffffff8104ad17>] ? task_rq_lock+0x47/0x90
       1 [<ffffffff8104a99b>] ? __wake_up_common+0x5b/0x90
       1 [<ffffffff81049bcf>] ? sched_slice+0x5f/0x90
       1 [<ffffffff81034200>] ? sys_vfork+0x20/0x30
       1 [<ffffffff8102c853>] ? stub_vfork+0x13/0x20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
