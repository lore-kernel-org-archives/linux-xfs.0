Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7BAwFvv130892 for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 05:58:25 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38A9B147FD02
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 03:58:48 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Uhccjtm42TbuFel9 for
	<xfs@oss.sgi.com>; Tue, 11 Aug 2009 03:58:48 -0700 (PDT)
Date: Tue, 11 Aug 2009 06:58:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (happened again)
In-Reply-To: <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
	<00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
	<alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 9 Aug 2009, Justin Piszcz wrote:

>
>
> On Sat, 8 Aug 2009, Felix Blyakher wrote:
>
>> 
>> On Aug 8, 2009, at 3:39 AM, Justin Piszcz wrote:
>> 
>> The threads below don't ring a bell as something already seen or
>> reported.
>> 
>> Discounting bunch of spurious frames, here we're waiting for the
>> xfs ilock.
>> 
>> At this point xfs ilock is released in xfs_write(), and it shouldn't
>> be holding the other thread. Though, some other thread is.
>> We'd need more info to figure it out. Maybe the whole output of both
>> sysrq-w and sysrq-t.
>> 
>> Felix
>>

It has happened again, I am back to using 2.6.29.1 now, but here are some new
sysrq -w and -t outputs from the last lockup:

Would enabling debugging for the XFS filesystem provide more details if 
this is caused by XFS or is it another part of the kernel subsystem?

sysrq-w:

[215701.139416] SysRq : Show Blocked State
[215701.139441]   task                PC stack   pid father
[215701.139458] pdflush       D cf937f24     0   208      2
[215701.139476]  cf8d9684 00000046 cf8d9500 cf937f24 00000002 cf331100 cf937f70 00000000
[215701.139504]  cf92a380 cf92a394 00000000 cfaa1400 c03e72e5 c0273555 00000000 cf8d9500
[215701.139533]  c0118a10 cf92a394 cf92a394 cf92a380 cf25383c 00000000 c027450f cf92a380
[215701.139560] Call Trace:
[215701.139584]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139600]  [<c0273555>] ? xfs_buf_wait_unpin+0x95/0xd0
[215701.139617]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139631]  [<c027450f>] ? xfs_buf_iorequest+0x5f/0x80
[215701.139646]  [<c02784d7>] ? xfs_bdstrat_cb+0x37/0x40
[215701.139659]  [<c0270407>] ? xfs_bwrite+0x57/0xd0
[215701.139672]  [<c027c0fa>] ? xfs_sync_fsdata+0xba/0x100
[215701.139686]  [<c0279e26>] ? xfs_fs_write_super+0x16/0x20
[215701.139703]  [<c0165967>] ? sync_supers+0x67/0x90
[215701.139718]  [<c01481c0>] ? pdflush+0x0/0x180
[215701.139730]  [<c01475a5>] ? wb_kupdate+0x25/0x110
[215701.139743]  [<c01481c0>] ? pdflush+0x0/0x180
[215701.139755]  [<c0148275>] ? pdflush+0xb5/0x180
[215701.139767]  [<c0147580>] ? wb_kupdate+0x0/0x110
[215701.139785]  [<c012d7e0>] ? kthread+0x40/0x70
[215701.139797]  [<c012d7a0>] ? kthread+0x0/0x70
[215701.139811]  [<c01033d3>] ? kernel_thread_helper+0x7/0x14
[215701.139823] pdflush       D c6cd41a4     0   209      2
[215701.139838]  cf8d99d4 00000046 cf8d9850 c6cd41a4 ce0c18c0 cf331440 00000000 00006000
[215701.139852]  cf9399d0 ce0c18c0 0000008b 00025ef5 c03e72e5 c025c03e cf216be0 00000001
[215701.139852]  cf8d9850 c0118a10 ce0c18c0 ce0c18c0 cf216be0 0000008b 00000000 00000001
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c025c03e>] ? xlog_state_sync+0x18e/0x1c0
[215701.139852]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139852]  [<c025c0bb>] ? _xfs_log_force+0x4b/0x70
[215701.139852]  [<c025c0fc>] ? xfs_log_force+0x1c/0x50
[215701.139852]  [<c0225e4d>] ? xfs_alloc_ag_vextent+0xed/0x100
[215701.139852]  [<c02266f7>] ? xfs_alloc_vextent+0x347/0x480
[215701.139852]  [<c02340bc>] ? xfs_bmap_btalloc+0x54c/0x940
[215701.139852]  [<c022ef51>] ? xfs_bmap_search_multi_extents+0x91/0x100
[215701.139852]  [<c0237019>] ? xfs_bmapi+0xd29/0x14d0
[215701.139852]  [<c027092d>] ? kmem_zone_alloc+0x7d/0xc0
[215701.139852]  [<c0257ac9>] ? xfs_iomap_write_allocate+0x2a9/0x470
[215701.139852]  [<c0258b3e>] ? xfs_iomap+0x38e/0x3e0
[215701.139852]  [<c02714d5>] ? xfs_map_blocks+0x35/0x40
[215701.139852]  [<c0272587>] ? xfs_page_state_convert+0x407/0x7d0
[215701.139852]  [<c0272be4>] ? xfs_vm_writepage+0x64/0x110
[215701.139852]  [<c0146c68>] ? __writepage+0x8/0x30
[215701.139852]  [<c01472bf>] ? write_cache_pages+0x18f/0x350
[215701.139852]  [<c0146c60>] ? __writepage+0x0/0x30
[215701.139852]  [<c02742c0>] ? xfs_buf_rele+0x20/0x80
[215701.139852]  [<c02744e5>] ? xfs_buf_iorequest+0x35/0x80
[215701.139852]  [<c0272b60>] ? xfs_vm_writepages+0x0/0x10
[215701.139852]  [<c01474a0>] ? generic_writepages+0x20/0x30
[215701.139852]  [<c01474db>] ? do_writepages+0x2b/0x50
[215701.139852]  [<c017ca77>] ? __writeback_single_inode+0x77/0x380
[215701.139852]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215701.139852]  [<c017d15e>] ? generic_sync_sb_inodes+0x23e/0x3b0
[215701.139852]  [<c017d419>] ? writeback_inodes+0x29/0x90
[215701.139852]  [<c0147ab6>] ? background_writeout+0x96/0xc0
[215701.139852]  [<c01481c0>] ? pdflush+0x0/0x180
[215701.139852]  [<c0148275>] ? pdflush+0xb5/0x180
[215701.139852]  [<c0147a20>] ? background_writeout+0x0/0xc0
[215701.139852]  [<c012d7e0>] ? kthread+0x40/0x70
[215701.139852]  [<c012d7a0>] ? kthread+0x0/0x70
[215701.139852]  [<c01033d3>] ? kernel_thread_helper+0x7/0x14
[215701.139852] xfsdatad/0    D 000007d8     0   216      2
[215701.139852]  00000000 00000046 cf8c5190 000007d8 00000000 cf331440 cf8c51bc 00000000
[215701.139852]  cf5702e4 cf5702e4 cf975f64 cf95a8a8 c03e72e5 c03e85fd cf5702e8 cf8c5190
[215701.139852]  cf8c5314 cf5702e4 00000000 cf570280 cf95a8a8 c03e870a cf5702e8 cf5702e8
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[215701.139852]  [<c03e870a>] ? rwsem_down_write_failed+0x1a/0x30
[215701.139852]  [<c03e8756>] ? call_rwsem_down_write_failed+0x6/0x8
[215701.139852]  [<c03e7d41>] ? down_write+0x11/0x20
[215701.139852]  [<c027101d>] ? xfs_setfilesize+0x3d/0x120
[215701.139852]  [<c0271300>] ? xfs_end_bio_written+0x0/0x20
[215701.139852]  [<c027130d>] ? xfs_end_bio_written+0xd/0x20
[215701.139852]  [<c012ab8a>] ? worker_thread+0xaa/0x140
[215701.139852]  [<c03e717b>] ? __schedule+0x1cb/0x330
[215701.139852]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215701.139852]  [<c012aae0>] ? worker_thread+0x0/0x140
[215701.139852]  [<c012d7e0>] ? kthread+0x40/0x70
[215701.139852]  [<c012d7a0>] ? kthread+0x0/0x70
[215701.139852]  [<c01033d3>] ? kernel_thread_helper+0x7/0x14
[215701.139852] loop0         D cf5d86c8     0  1971      2
[215701.139852]  cf8b05b4 00000046 cf8b0430 cf5d86c8 00000008 cf331440 ce14be80 ce14be88
[215701.139852]  c049f170 ce14be80 ce14be88 c1200438 c03e72e5 c03e7311 00000000 c014111d
[215701.139852]  c03e75a7 c01410f0 ce14be80 c1105ca0 ce14be9c cf8b0430 c0141335 00000002
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e75a7>] ? __wait_on_bit+0x47/0x70
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c0141335>] ? wait_on_page_bit+0x95/0xb0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c0141cc7>] ? wait_on_page_writeback_range+0x97/0x100
[215701.139852]  [<c01474a0>] ? generic_writepages+0x20/0x30
[215701.139852]  [<c01474db>] ? do_writepages+0x2b/0x50
[215701.139852]  [<c0141dcb>] ? __filemap_fdatawrite_range+0x6b/0x90
[215701.139852]  [<c0275430>] ? xfs_wait_on_pages+0x20/0x30
[215701.139852]  [<c026ec7a>] ? xfs_fsync+0x5a/0x190
[215701.139852]  [<c02752a5>] ? xfs_file_fsync+0x15/0x20
[215701.139852]  [<c018006f>] ? vfs_fsync+0x6f/0xc0
[215701.139852]  [<c02fdc18>] ? loop_thread+0x4a8/0x4c0
[215701.139852]  [<c02fd5b0>] ? do_lo_send_aops+0x0/0x1c0
[215701.139852]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215701.139852]  [<c02fd770>] ? loop_thread+0x0/0x4c0
[215701.139852]  [<c012d7e0>] ? kthread+0x40/0x70
[215701.139852]  [<c012d7a0>] ? kthread+0x0/0x70
[215701.139852]  [<c01033d3>] ? kernel_thread_helper+0x7/0x14
[215701.139852] xfssyncd      D cce1fedc     0  1981      2
[215701.139852]  cf9d4654 00000046 cf9d44d0 cce1fedc c0117636 cf288220 00000001 c025c0fc
[215701.139852]  c684c040 c684c0cc cce1ff08 cfaa1400 c03e72e5 c0252ffd 00000002 00000000
[215701.139852]  cf9d44d0 c012dbe0 c684c0cc c684c0cc c29e4598 c684c040 00000002 c025512c
[215701.139852] Call Trace:
[215701.139852]  [<c0117636>] ? update_curr+0x156/0x180
[215701.139852]  [<c025c0fc>] ? xfs_log_force+0x1c/0x50
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c0252ffd>] ? __xfs_iunpin_wait+0x8d/0xc0
[215701.139852]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215701.139852]  [<c025512c>] ? xfs_iflush+0x9c/0x2b0
[215701.139852]  [<c027bac9>] ? xfs_reclaim_inode+0xa9/0xe0
[215701.139852]  [<c027bbd7>] ? xfs_reclaim_inodes_ag+0xd7/0x120
[215701.139852]  [<c027bc71>] ? xfs_reclaim_inodes+0x51/0x70
[215701.139852]  [<c027c196>] ? xfs_sync_worker+0x56/0xa0
[215701.139852]  [<c027be19>] ? xfssyncd+0xf9/0x160
[215701.139852]  [<c027bd20>] ? xfssyncd+0x0/0x160
[215701.139852]  [<c012d7e0>] ? kthread+0x40/0x70
[215701.139852]  [<c012d7a0>] ? kthread+0x0/0x70
[215701.139852]  [<c01033d3>] ? kernel_thread_helper+0x7/0x14
[215701.139852] misc-daemon  D 00001397     0  2306      1
[215701.139852]  cf8b1ce4 00200082 cf8b1b60 00001397 00005000 cfb65380 cf402380 00000010
[215701.139852]  c049f170 cf8b1b60 cc41fe94 c1200670 c03e72e5 c03e7311 cc41fe8c c014111d
[215701.139852]  c03e76f2 0000000e c01410f0 c04c371c cf8b1b60 cc41fea8 c10ecda0 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215701.139852]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c01649ff>] ? vfs_read+0xff/0x140
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852] vsftpd        D c0499320     0  7269   1821
[215701.139852]  c15e2bb4 00000082 c15e2a30 c0499320 00000005 cf0c5c40 000081b6 c684c040
[215701.139852]  00000286 0cd72fe2 c9f03cf4 0cd72fe1 c03e72e5 c03e74a0 00000000 ce22bd48
[215701.139852]  c053ced8 c053ced8 0cd72fe2 c0124de0 c15e2a30 c053c7c0 c684c040 ce22bd48
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e74a0>] ? schedule_timeout+0xb0/0x110
[215701.139852]  [<c0124de0>] ? process_timeout+0x0/0x10
[215701.139852]  [<c0251380>] ? xfs_iget+0x1a0/0x390
[215701.139852]  [<c026a705>] ? xfs_trans_iget+0xf5/0x120
[215701.139852]  [<c025486a>] ? xfs_ialloc+0xba/0x680
[215701.139852]  [<c026b199>] ? xfs_dir_ialloc+0x89/0x2e0
[215701.139852]  [<c0268e12>] ? xfs_trans_reserve+0x82/0x220
[215701.139852]  [<c026da7a>] ? xfs_create+0x3ea/0x5d0
[215701.139852]  [<c0277c21>] ? xfs_vn_mknod+0x81/0x120
[215701.139852]  [<c016bc90>] ? vfs_create+0x90/0xe0
[215701.139852]  [<c0277ce0>] ? xfs_vn_create+0x0/0x10
[215701.139852]  [<c016eaeb>] ? do_filp_open+0x72b/0x830
[215701.139852]  [<c016208b>] ? do_sys_open+0x5b/0x110
[215701.139852]  [<c01621bc>] ? sys_open+0x2c/0x40
[215701.139852]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215701.139852] vsftpd        D cf402150     0 19048   1821
[215701.139852]  00000000 00000086 c15e3770 cf402150 c1085ba0 cf331100 00000000 00000001
[215701.139852]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215701.139852]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff c997f878
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215701.139852]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215701.139852]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215701.139852]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215701.139852]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139852]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215701.139852]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215701.139852]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215701.139852]  [<c023a791>] ? xfs_btree_read_bufl+0x71/0xa0
[215701.139852]  [<c0234566>] ? xfs_bmap_read_extents+0xa6/0x380
[215701.139852]  [<c0254e97>] ? xfs_iread_extents+0x67/0xe0
[215701.139852]  [<c023640d>] ? xfs_bmapi+0x11d/0x14d0
[215701.139852]  [<c03bc59e>] ? nf_nat_setup_info+0x57e/0x660
[215701.139852]  [<c03be21b>] ? ipt_do_table+0x1bb/0x330
[215701.139852]  [<c031b96c>] ? tulip_start_xmit+0xec/0x120
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c0258964>] ? xfs_iomap+0x1b4/0x3e0
[215701.139852]  [<c0271582>] ? __xfs_get_blocks+0xa2/0x2a0
[215701.139852]  [<c0180c8d>] ? alloc_buffer_head+0xd/0x60
[215701.139852]  [<c02717d0>] ? xfs_get_blocks+0x20/0x30
[215701.139852]  [<c0182bc4>] ? __block_prepare_write+0x1d4/0x3f0
[215701.139852]  [<c014139b>] ? add_to_page_cache_locked+0x4b/0xb0
[215701.139852]  [<c0182f65>] ? block_write_begin+0x45/0xe0
[215701.139852]  [<c02717b0>] ? xfs_get_blocks+0x0/0x30
[215701.139852]  [<c0272b36>] ? xfs_vm_write_begin+0x46/0x50
[215701.139852]  [<c02717b0>] ? xfs_get_blocks+0x0/0x30
[215701.139852]  [<c0141f86>] ? generic_file_buffered_write+0x106/0x300
[215701.139852]  [<c02791ea>] ? xfs_write+0x77a/0x860
[215701.139852]  [<c0275361>] ? xfs_file_aio_write+0x61/0x70
[215701.139852]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215701.139852]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215701.139852]  [<c015a256>] ? page_add_new_anon_rmap+0x56/0x80
[215701.139852]  [<c0153a7e>] ? handle_mm_fault+0x42e/0x530
[215701.139852]  [<c016758e>] ? sys_fstat64+0x1e/0x30
[215701.139852]  [<c0163b40>] ? do_sync_write+0x0/0x120
[215701.139852]  [<c0164750>] ? vfs_write+0xa0/0x140
[215701.139852]  [<c01648c1>] ? sys_write+0x41/0x80
[215701.139852]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215701.139852] vsftpd        D 00000000     0 29887   1821
[215701.139852]  00000000 00000082 cf9e9580 00000000 4a7df9b3 cf288220 4a8077bb 03bca3c6
[215701.139852]  cd1621bc ffffffff cf9e9580 cd1621c0 c03e78bb cd1621c0 cd1621c0 cf9e9580
[215701.139852]  00c372e8 00000000 c89589a0 c3b8a000 c03e7819 c0164c03 00000000 c0164be0
[215701.139852] Call Trace:
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c0164c03>] ? generic_file_llseek+0x23/0x60
[215701.139852]  [<c0164be0>] ? generic_file_llseek+0x0/0x60
[215701.139852]  [<c01637ac>] ? vfs_llseek+0x3c/0x50
[215701.139852]  [<c0164ba6>] ? sys_llseek+0x56/0x90
[215701.139852]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215701.139852] md5sum   D 02bb4af3     0 30660  19048
[215701.139852]  00000000 00000086 cf879b20 02bb4af3 00003000 cf35e600 cf402380 00000010
[215701.139852]  c049f170 cf879b20 c15a7c74 c12003b0 c03e72e5 c03e7311 c15a7c6c c014111d
[215701.139852]  c03e76f2 00000003 c01410f0 c04c371c cf879b20 c15a7c88 c10b65a0 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215701.139852] md5sum   D c01202d3     0 30661  29887
[215701.139852]  00000000 00000082 cf8783f0 c01202d3 cf6e0390 cfb65520 c21abaa0 c1052d40
[215701.139852]  c049f170 cf8783f0 c8123c74 c12003b0 c03e72e5 c03e7311 c8123c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf8783f0 c8123c88 c10b65a0 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c01202d3>] ? current_fs_time+0x13/0x20
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215701.139852] vsftpd        D cf935088     0 30663   1821
[215701.139852]  c15d9914 00000082 c15d9790 cf935088 c15d9790 cf288a40 c1200118 c02906a3
[215701.139852]  c049f170 c15d9790 c14ebc74 c1200118 c03e72e5 c03e7311 c14ebc6c c014111d
[215701.139852]  c03e76f2 0000001b c01410f0 c04c371c c15d9790 c14ebc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c02906a3>] ? __generic_unplug_device+0x23/0x30
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30664   1821
[215701.139852]  00000000 00000082 cf920800 00000000 0100a150 cfaca6e0 c7a057e0 80000000
[215701.139852]  c049f170 cf920800 cc643c74 c1200118 c03e72e5 c03e7311 cc643c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf920800 cc643c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30671   1821
[215701.139852]  00000000 00000086 c15d90f0 00000000 010090f0 cfb65ba0 c4099c20 80000000
[215701.139852]  c049f170 c15d90f0 c4099c74 c1200118 c03e72e5 c03e7311 c4099c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d90f0 c4099c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30672   1821
[215701.139852]  00000000 00000082 cf9204b0 00000000 0100a150 cf331780 ce03f2a0 80000000
[215701.139852]  c049f170 cf9204b0 c3ac7c74 c1200118 c03e72e5 c03e7311 c3ac7c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf9204b0 c3ac7c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30673   1821
[215701.139852]  00000000 00000086 cf878de0 00000000 0100a150 cf0880c0 ce05b540 80000000
[215701.139852]  c049f170 cf878de0 c9123c74 c1200118 c03e72e5 c03e7311 c9123c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf878de0 c9123c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30674   1821
[215701.139852]  00000000 00000082 c15d8a50 00000000 0100a150 cf35eae0 ce09ec60 80000000
[215701.139852]  c049f170 c15d8a50 cd03dc74 c1200118 c03e72e5 c03e7311 cd03dc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d8a50 cd03dc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D cf402150     0 30683  30682
[215701.139852]  00000000 00000086 cf8b0780 cf402150 c1137380 cf288560 00000000 00000001
[215701.139852]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215701.139852]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff ccd84898
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215701.139852]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215701.139852]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215701.139852]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215701.139852]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139852]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215701.139852]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215701.139852]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215701.139852]  [<c023f6da>] ? xfs_da_do_buf+0x4aa/0x870
[215701.139852]  [<c023fb30>] ? xfs_da_read_buf+0x30/0x40
[215701.139852]  [<c0244061>] ? xfs_dir2_block_lookup_int+0x51/0x200
[215701.139852]  [<c0244061>] ? xfs_dir2_block_lookup_int+0x51/0x200
[215701.139852]  [<c022e91f>] ? xfs_bmap_last_offset+0x12f/0x140
[215701.139852]  [<c0244750>] ? xfs_dir2_block_lookup+0x20/0xc0
[215701.139852]  [<c0243185>] ? xfs_dir_lookup+0x145/0x170
[215701.139852]  [<c026dccb>] ? xfs_lookup+0x6b/0xf0
[215701.139852]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215701.139852]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215701.139852]  [<c016c90f>] ? __link_path_walk+0x17f/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D cf402150     0 30686  30685
[215701.139852]  00000000 00000082 c15e2390 cf402150 c1037f80 cf288080 00000000 00000001
[215701.139852]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215701.139852]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff ccd84a18
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215701.139852]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215701.139852]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215701.139852]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215701.139852]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139852]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215701.139852]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215701.139852]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215701.139852]  [<c023f6da>] ? xfs_da_do_buf+0x4aa/0x870
[215701.139852]  [<c023fb30>] ? xfs_da_read_buf+0x30/0x40
[215701.139852]  [<c0245d03>] ? xfs_dir2_leaf_lookup_int+0x63/0x2f0
[215701.139852]  [<c0245d03>] ? xfs_dir2_leaf_lookup_int+0x63/0x2f0
[215701.139852]  [<c022ef3b>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[215701.139852]  [<c0246a37>] ? xfs_dir2_leaf_lookup+0x27/0xc0
[215701.139852]  [<c02427ef>] ? xfs_dir2_isleaf+0x1f/0x60
[215701.139852]  [<c0243108>] ? xfs_dir_lookup+0xc8/0x170
[215701.139852]  [<c026dccb>] ? xfs_lookup+0x6b/0xf0
[215701.139852]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215701.139852]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D c0104a67     0 30689  30688
[215701.139852]  00000000 00000086 cf864a70 c0104a67 c1585e10 cf2c70a0 cf864a70 00000000
[215701.139852]  cf6aa63c ffffffff cf864a70 cf6aa640 c03e78bb c1443e04 cf6aa640 cf864a70
[215701.139852]  c1585e70 00000000 c1585ef4 c1585e70 c03e7819 c016b423 c1585e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c0104a67>] ? handle_irq+0x17/0x20
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30695   1821
[215701.139852]  00000000 00000086 cf8643d0 00000000 0100a150 cfacad60 c8a126e0 80000000
[215701.139852]  c049f170 cf8643d0 c70d7c74 c1200118 c03e72e5 c03e7311 c70d7c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf8643d0 c70d7c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30696   1821
[215701.139852]  00000000 00000086 c15e2d80 00000000 0100a150 cf088dc0 cfb99e60 80000000
[215701.139852]  c049f170 c15e2d80 c38cbc74 c1200118 c03e72e5 c03e7311 c38cbc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15e2d80 c38cbc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30697   1821
[215701.139852]  00000000 00000086 cf864dc0 00000000 0100a150 cf3312a0 ce03f520 80000000
[215701.139852]  c049f170 cf864dc0 c926dc74 c1200118 c03e72e5 c03e7311 c926dc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf864dc0 c926dc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30698   1821
[215701.139852]  00000000 00000086 cf8d8b10 00000000 0100a150 cfacabc0 ce05b8c0 80000000
[215701.139852]  c049f170 cf8d8b10 c260bc74 c1200118 c03e72e5 c03e7311 c260bc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf8d8b10 c260bc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30699   1821
[215701.139852]  00000000 00000086 cf9e8b90 00000000 0100a150 cf0c55c0 c7a05660 80000000
[215701.139852]  c049f170 cf9e8b90 ce9cbc74 c1200118 c03e72e5 c03e7311 ce9cbc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf9e8b90 ce9cbc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30700   1821
[215701.139852]  00000000 00000082 cf9e9230 00000000 0100a150 cf2c7580 cf20e860 80000000
[215701.139852]  c049f170 cf9e9230 ca90dc74 c1200118 c03e72e5 c03e7311 ca90dc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf9e9230 ca90dc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30707   1821
[215701.139852]  00000000 00000082 cf8c5b80 00000000 0100a150 cf35ee20 ce09f6a0 80000000
[215701.139852]  c049f170 cf8c5b80 cc31fc74 c1200118 c03e72e5 c03e7311 cc31fc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf8c5b80 cc31fc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30708   1821
[215701.139852]  00000000 00000086 c15d8060 00000000 0100a150 cfaca3a0 ce09ed60 80000000
[215701.139852]  c049f170 c15d8060 c5e13c74 c1200118 c03e72e5 c03e7311 c5e13c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d8060 c5e13c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30709   1821
[215701.139852]  00000000 00000082 c15d9440 00000000 0100a150 cf0c5420 c7a05e60 80000000
[215701.139852]  c049f170 c15d9440 c802bc74 c1200118 c03e72e5 c03e7311 c802bc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d9440 c802bc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30710   1821
[215701.139852]  00000000 00000086 c15d8700 00000000 0100a150 cf0885a0 c21aba20 80000000
[215701.139852]  c049f170 c15d8700 cc8d7c74 c1200118 c03e72e5 c03e7311 cc8d7c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d8700 cc8d7c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30711   1821
[215701.139852]  00000000 00000086 c15d9ae0 00000000 0100a150 cf2c7a60 c8958920 80000000
[215701.139852]  c049f170 c15d9ae0 c1463c74 c1200118 c03e72e5 c03e7311 c1463c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d9ae0 c1463c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30712   1821
[215701.139852]  00000000 00000086 c15d83b0 00000000 0100a150 cf2c7c00 cf882740 80000000
[215701.139852]  c049f170 c15d83b0 c1409c74 c1200118 c03e72e5 c03e7311 c1409c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c15d83b0 c1409c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30713   1821
[215701.139852]  00000000 00000086 cf8b0ad0 00000000 0100a150 cf331e00 c8a12ce0 80000000
[215701.139852]  c049f170 cf8b0ad0 c140bc74 c1200118 c03e72e5 c03e7311 c140bc6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c cf8b0ad0 c140bc88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30720   1821
[215701.139852]  00000000 00000086 c14c5c20 00000000 0100a150 cf2c7da0 c47420e0 80000000
[215701.139852]  c049f170 c14c5c20 c14c7c74 c1200118 c03e72e5 c03e7311 c14c7c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c14c5c20 c14c7c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D c04c371c     0 30721   1821
[215701.139852]  00000000 00000082 c14c41a0 c04c371c c0103269 cf35ec80 c4703000 00000500
[215701.139852]  c049f170 c14c41a0 c1451c74 c1200118 c03e72e5 c03e7311 c1451c6c c014111d
[215701.139852]  c03e76f2 c02a07cb c01410f0 c04c371c c14c41a0 c1451c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c0103269>] ? common_interrupt+0x29/0x30
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c02a07cb>] ? mmx_clear_page+0x2b/0xd0
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30722   1821
[215701.139852]  00000000 00000082 c14c58d0 00000000 0100a150 cf35e120 c8958d20 80000000
[215701.139852]  c049f170 c14c58d0 c1453c74 c1200118 c03e72e5 c03e7311 c1453c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c14c58d0 c1453c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30723   1821
[215701.139852]  00000000 00000086 c14c44f0 00000000 0100a150 cf35e2c0 c8a12ee0 80000000
[215701.139852]  c049f170 c14c44f0 c1651c74 c1200118 c03e72e5 c03e7311 c1651c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c14c44f0 c1651c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30724   1821
[215701.139852]  00000000 00000082 c14c5580 00000000 0100a150 cf35e940 ce05b940 80000000
[215701.139852]  c049f170 c14c5580 c1505c74 c1200118 c03e72e5 c03e7311 c1505c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c14c5580 c1505c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c013fd8e>] ? rcu_process_callbacks+0x1e/0x20
[215701.139852]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D 00000000     0 30752  30751
[215701.139852]  00000000 00000082 c4a00510 00000000 00000000 cfaca880 00000000 00000000
[215701.139852]  cf5a11bc ffffffff c4a00510 cf5a11c0 c03e78bb cf5a11c0 cf5a11c0 c4a00510
[215701.139852]  c5ad9e70 00000000 c5ad9ef4 c5ad9e70 c03e7819 c016b423 c5ad9e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016c90f>] ? __link_path_walk+0x17f/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D 00000044     0 30755  30754
[215701.139852]  00000000 00000086 c4a015a0 00000044 00000000 cf0c5900 00000000 00000000
[215701.139852]  cf6aa63c ffffffff c4a015a0 cf6aa640 c03e78bb c1555e04 c1585e04 c4a015a0
[215701.139852]  c1443e70 00000000 c1443ef4 c1443e70 c03e7819 c016b423 c1443e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D cf402150     0 30757  30756
[215701.139852]  00000000 00000082 c4a00f00 cf402150 c111e120 cf0c5280 00000000 00000002
[215701.139852]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215701.139852]  00000000 00001000 00000008 00000000 c027371c 00000000 7fffffff c997f4b8
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215701.139852]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215701.139852]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215701.139852]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215701.139852]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215701.139852]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215701.139852]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215701.139852]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215701.139852]  [<c0254f58>] ? xfs_imap_to_bp+0x48/0x110
[215701.139852]  [<c0256634>] ? xfs_iread+0x94/0x1b0
[215701.139852]  [<c02511b1>] ? xfs_inode_alloc+0xd1/0x100
[215701.139852]  [<c02513d6>] ? xfs_iget+0x1f6/0x390
[215701.139852]  [<c026dd28>] ? xfs_lookup+0xc8/0xf0
[215701.139852]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215701.139852]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c0146422>] ? get_page_from_freelist+0x292/0x450
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[215701.139852]  [<c016208b>] ? do_sys_open+0x5b/0x110
[215701.139852]  [<c01621bc>] ? sys_open+0x2c/0x40
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D c90a9650     0 30760  30759
[215701.139852]  00000000 00000086 c146d910 c90a9650 c0185ee0 c44afb00 00000400 00000c00
[215701.139852]  cf6aa63c ffffffff c146d910 cf6aa640 c03e78bb c1617e04 c1443e04 c146d910
[215701.139852]  c1555e70 00000000 c1555ef4 c1555e70 c03e7819 c016b423 c1555e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c0185ee0>] ? bio_fs_destructor+0x0/0x10
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016cde6>] ? __link_path_walk+0x656/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D 1ccf74c0     0 30763  30762
[215701.139852]  00000000 00000082 c146cf20 1ccf74c0 c4a01924 c44af620 c146d2a4 c029d591
[215701.139852]  cf6aa63c ffffffff c146cf20 cf6aa640 c03e78bb c16b5e04 c1555e04 c146cf20
[215701.139852]  c1617e70 00000000 c1617ef4 c1617e70 c03e7819 c016b423 c1617e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c029d591>] ? rb_insert_color+0xc1/0xf0
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D 00000000     0 30766  30765
[215701.139852]  c146c6b4 00000082 c146c530 00000000 00000000 c44af140 00008068 00000008
[215701.139852]  cf6aa63c ffffffff c146c530 cf6aa640 c03e78bb cf6aa640 c16b5e04 c146c530
[215701.139852]  cce39e70 00000000 cce39ef4 cce39e70 c03e7819 c016b423 cce39e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c0162f79>] ? do_truncate+0x79/0x90
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] sh            D 30000000     0 30769  30768
[215701.139852]  00000000 00000086 c1489930 30000000 00000000 c8baaa00 00000040 00000286
[215701.139852]  cf6aa63c ffffffff c1489930 cf6aa640 c03e78bb cce39e04 c1617e04 c1489930
[215701.139852]  c16b5e70 00000000 c16b5ef4 c16b5e70 c03e7819 c016b423 c16b5e84 cf80c8a0
[215701.139852] Call Trace:
[215701.139852]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215701.139852]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215701.139852]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215701.139852]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215701.139852]  [<c016d573>] ? path_walk+0x53/0xb0
[215701.139852]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215701.139852]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215701.139852]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215701.139852]  [<c0169188>] ? do_execve+0x98/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215701.139852] vsftpd        D 00000000     0 30788   1821
[215701.139852]  00000000 00000086 c1488200 00000000 0100a150 c8baa860 c4105660 80000000
[215701.139852]  c049f170 c1488200 c7765c74 c1200118 c03e72e5 c03e7311 c7765c6c c014111d
[215701.139852]  c03e76f2 00000254 c01410f0 c04c371c c1488200 c7765c88 c11e7340 c01410cc
[215701.139852] Call Trace:
[215701.139852]  [<c03e72e5>] ? schedule+0x5/0x20
[215701.139852]  [<c03e7311>] ? io_schedule+0x11/0x20
[215701.139852]  [<c014111d>] ? sync_page+0x2d/0x60
[215701.139852]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215701.139852]  [<c01410f0>] ? sync_page+0x0/0x60
[215701.139852]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215701.139852]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215701.139852]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215701.139852]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215701.139852]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215701.139852]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215701.139852]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c03e87dd>] ? error_code+0x65/0x6c
[215701.139852]  [<c0113910>] ? do_page_fault+0x0/0x290
[215701.139852]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215701.139852]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215701.139852]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215701.139852]  [<c029e16b>] ? strrchr+0xb/0x20
[215701.139852]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0152937>] ? follow_page+0x117/0x150
[215701.139852]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215701.139852]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215701.139852]  [<c016827e>] ? copy_strings+0x16e/0x190
[215701.139852]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215701.139852]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215701.139852]  [<c01016e6>] ? sys_execve+0x46/0x70
[215701.139852]  [<c0102c48>] ? sysenter_do_call+0x12/0x26

sysrq-t:

ge+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c01649ff>] ? vfs_read+0xff/0x140
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452] misc-daemon S c0499320     0  2307      1
[215680.693452]  00000000 00200082 cf8d8120 c0499320 000f423f cf331440 cf29bb5c cf29bb2c
[215680.693452]  19886cce 0000c429 cf29bb5c cf29bb2c c03e72e5 c03e7b43 000f423f 00000000
[215680.693452]  00000000 ce0c3b2c 00000000 00000000 1997af0d 0000c429 19886cce 0000c429
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7b43>] ? schedule_hrtimeout_range+0xc3/0x140
[215680.693452]  [<c0130820>] ? hrtimer_wakeup+0x0/0x20
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c023fb30>] ? xfs_da_read_buf+0x30/0x40
[215680.693452]  [<c0245e79>] ? xfs_dir2_leaf_lookup_int+0x1d9/0x2f0
[215680.693452]  [<c023ef70>] ? xfs_da_brelse+0x40/0xd0
[215680.693452]  [<c0246ab0>] ? xfs_dir2_leaf_lookup+0xa0/0xc0
[215680.693452]  [<c0243108>] ? xfs_dir_lookup+0xc8/0x170
[215680.693452]  [<c017432d>] ? igrab+0x1d/0x30
[215680.693452]  [<c025149d>] ? xfs_iget+0x2bd/0x390
[215680.693452]  [<c037b1b7>] ? __nf_conntrack_find+0xe7/0x100
[215680.693452]  [<c037bbf7>] ? __nf_ct_refresh_acct+0x27/0xe0
[215680.693452]  [<c038005f>] ? udp_packet+0x4f/0x70
[215680.693452]  [<c031671d>] ? rtl8169_start_xmit+0x20d/0x3d0
[215680.693452]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c0172a12>] ? dput+0x82/0x100
[215680.693452]  [<c0177e73>] ? mntput_no_expire+0x13/0xa0
[215680.693452]  [<c016d5c0>] ? path_walk+0xa0/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c016c756>] ? getname+0x96/0xd0
[215680.693452]  [<c016e238>] ? user_path_at+0x68/0x90
[215680.693452]  [<c0166f17>] ? cp_new_stat64+0xf7/0x110
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] ssh           S 00000000     0  3289      1
[215680.693452]  00000000 00000086 cf89d150 00000000 c049cc60 cf0c5aa0 c049c2c0 c0138836
[215680.693452]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 00000000 00000010
[215680.693452]  00000000 c0131c60 00000000 00000010 c011094f c04a1760 00000010 0000c41c
[215680.693452] Call Trace:
[215680.693452]  [<c0138836>] ? tick_handle_periodic_broadcast+0x26/0x80
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[215680.693452]  [<c0131c60>] ? notify_die+0x30/0x40
[215680.693452]  [<c011094f>] ? ack_apic_level+0x3f/0x140
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0367bbe>] ? dev_queue_xmit+0xbe/0x3b0
[215680.693452]  [<c038d8f2>] ? ip_finish_output+0x192/0x270
[215680.693452]  [<c038ca85>] ? ip_local_out+0x15/0x20
[215680.693452]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[215680.693452]  [<c039eb34>] ? tcp_transmit_skb+0x444/0x680
[215680.693452]  [<c035c16c>] ? sk_reset_timer+0xc/0x20
[215680.693452]  [<c03a0b2b>] ? tcp_write_xmit+0x1fb/0x9a0
[215680.693452]  [<c0362422>] ? memcpy_toiovec+0x42/0x60
[215680.693452]  [<c0360fd2>] ? __alloc_skb+0x52/0x130
[215680.693452]  [<c035bdbc>] ? release_sock+0xc/0x80
[215680.693452]  [<c0394d64>] ? tcp_sendmsg+0x694/0xa40
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S ff66affe     0  3293      1
[215680.693452]  00000000 00000082 cf864080 ff66affe 00000001 cf288d80 000002f6 cf288d80
[215680.693452]  00000000 00000000 00000000 bfb85a24 c03e72e5 c01394bd 00000000 c049eda0
[215680.693452]  c8595e58 00000000 00000000 00000064 c053eb40 c053eb40 c053eb48 c053eb48
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c01394bd>] ? futex_wait+0x38d/0x3d0
[215680.693452]  [<c0139577>] ? wake_futex+0x27/0x40
[215680.693452]  [<c0139659>] ? futex_wake+0xc9/0xe0
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c013a583>] ? do_futex+0xe3/0x920
[215680.693452]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[215680.693452]  [<c013ae2e>] ? sys_futex+0x6e/0x120
[215680.693452]  [<c03e717b>] ? __schedule+0x1cb/0x330
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3294      1
[215680.693452]  cf8648a4 00000082 cf864720 00000000 00000060 cf288d80 c020ad8c 00000000
[215680.693452]  cfa9f800 ce1ffedc cfa9f82c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  ce1fff60 cfa9f83c cfa9f834 cfaa4ca0 cfa9f860 cfa9f824 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c0181010>] ? end_bio_bh_io_sync+0x0/0x50
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c0298610>] ? cfq_completed_request+0x2b0/0x310
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c013d9dd>] ? handle_IRQ_event+0x2d/0xc0
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3295      1
[215680.693452]  00000000 00000082 cf8d87c0 00000000 00000060 cf288d80 c020ad8c 00000000
[215680.693452]  cfa9f800 c407bedc cfa9f82c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  c407bf60 cfa9f83c cfa9f834 cfaa4ca0 cfa9f860 cfa9f824 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c03a3de8>] ? tcp_v4_rcv+0x578/0x630
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S c0118423     0  3296      1
[215680.693452]  cf89cc34 00000082 cf89cab0 c0118423 00000000 cf288d80 00000001 00000286
[215680.693452]  c1e0be2c 7fffffff 7fffffff 00000000 c03e72e5 c03e74cd c88f7ba0 00000000
[215680.693452]  c01184ff 00000000 c03c2de8 c88f7ba0 00000286 c89e9c00 c1e0be2c 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c0118423>] ? __wake_up_common+0x43/0x70
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c01184ff>] ? __wake_up_sync+0xf/0x20
[215680.693452]  [<c03c2de8>] ? unix_write_space+0x28/0x60
[215680.693452]  [<c03c27e4>] ? unix_stream_recvmsg+0x374/0x4d0
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0358ab5>] ? sock_aio_read+0x125/0x140
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c013a54c>] ? do_futex+0xac/0x920
[215680.693452]  [<c013815f>] ? tick_handle_periodic+0xf/0x80
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0164a2f>] ? vfs_read+0x12f/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  6958      1
[215680.693452]  00000000 00000082 c15d8da0 00000000 00000060 cf288d80 c020ad8c 00000000
[215680.693452]  cfa9f800 c1d51edc cfa9f82c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  c1d51f60 cfa9f83c cfa9f834 cfaa4ca0 cfa9f860 cfa9f824 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] ssh           S c0499318     0  3302      1
[215680.693452]  cf921374 00000082 cf9211f0 c0499318 00000000 cf331920 cf525064 0852507c
[215680.693452]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 18000086 eb032807
[215680.693452]  00000000 c9f1bc6c 00001000 c9f1bbd0 c05498a0 c9f1bbd0 00000246 c037b1b7
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[215680.693452]  [<c037b1b7>] ? __nf_conntrack_find+0xe7/0x100
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c038d86e>] ? ip_finish_output+0x10e/0x270
[215680.693452]  [<c038da50>] ? ip_output+0x80/0x90
[215680.693452]  [<c038ca85>] ? ip_local_out+0x15/0x20
[215680.693452]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[215680.693452]  [<c039eb34>] ? tcp_transmit_skb+0x444/0x680
[215680.693452]  [<c035c16c>] ? sk_reset_timer+0xc/0x20
[215680.693452]  [<c03a0b2b>] ? tcp_write_xmit+0x1fb/0x9a0
[215680.693452]  [<c03bd574>] ? udp_manip_pkt+0xe4/0x100
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c0360fd2>] ? __alloc_skb+0x52/0x130
[215680.693452]  [<c035bdbc>] ? release_sock+0xc/0x80
[215680.693452]  [<c0394d64>] ? tcp_sendmsg+0x694/0xa40
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c0103269>] ? common_interrupt+0x29/0x30
[215680.693452]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215680.693452]  [<c0131b67>] ? atomic_notifier_call_chain+0x17/0x20
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S ff9ab1c5     0  3305      1
[215680.693452]  00000000 00000082 cf865110 ff9ab1c5 00000001 cf088a80 000002f6 cf088a80
[215680.693452]  00000000 00000000 00000000 bfeac0d4 c03e72e5 c01394bd 00000000 c049eda0
[215680.693452]  c7a1fe58 00000000 00000000 00000064 c053dd70 c053dd70 c053dd78 c053dd78
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c01394bd>] ? futex_wait+0x38d/0x3d0
[215680.693452]  [<c0139577>] ? wake_futex+0x27/0x40
[215680.693452]  [<c0139659>] ? futex_wake+0xc9/0xe0
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c013a583>] ? do_futex+0xe3/0x920
[215680.693452]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[215680.693452]  [<c013ae2e>] ? sys_futex+0x6e/0x120
[215680.693452]  [<c03e717b>] ? __schedule+0x1cb/0x330
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3306      1
[215680.693452]  cf8b1994 00000082 cf8b1810 00000000 00000060 cf088a80 c020ad8c 00000000
[215680.693452]  cf253000 c3a9bedc cf25302c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  c3a9bf60 cf25303c cf253034 cfa981a0 cf253060 cf253024 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c0181010>] ? end_bio_bh_io_sync+0x0/0x50
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c0298610>] ? cfq_completed_request+0x2b0/0x310
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c013d9dd>] ? handle_IRQ_event+0x2d/0xc0
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3307      1
[215680.693452]  00000000 00000082 cf89c760 00000000 00000060 cf088a80 c020ad8c 00000000
[215680.693452]  cf253000 ce08bedc cf25302c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  ce08bf60 cf25303c cf253034 cfa981a0 cf253060 cf253024 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c03a3e14>] ? tcp_v4_rcv+0x5a4/0x630
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c013a583>] ? do_futex+0xe3/0x920
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S c0118423     0  3308      1
[215680.693452]  cf89d974 00000082 cf89d7f0 c0118423 00000000 cf088a80 00000001 00000282
[215680.693452]  c653be2c 7fffffff 7fffffff 00000000 c03e72e5 c03e74cd c88f7e60 00000000
[215680.693452]  c01184ff 00000000 c03c2de8 c88f7e60 00000286 cf208a40 c653be2c 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c0118423>] ? __wake_up_common+0x43/0x70
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c01184ff>] ? __wake_up_sync+0xf/0x20
[215680.693452]  [<c03c2de8>] ? unix_write_space+0x28/0x60
[215680.693452]  [<c03c27e4>] ? unix_stream_recvmsg+0x374/0x4d0
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0358ab5>] ? sock_aio_read+0x125/0x140
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c013a54c>] ? do_futex+0xac/0x920
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0164a2f>] ? vfs_read+0x12f/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3190      1
[215680.693452]  cf8655e4 00000082 cf865460 00000000 00000060 cf088a80 c020ad8c 00000000
[215680.693452]  cf253000 c1511edc cf25302c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  c1511f60 cf25303c cf253034 cfa981a0 cf253060 cf253024 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c03a3763>] ? tcp_v4_do_rcv+0xa3/0x1b0
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c03a3de8>] ? tcp_v4_rcv+0x578/0x630
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3191      1
[215680.693452]  00000000 00000082 cf8fab30 00000000 00000060 cf088a80 c020ad8c 00000000
[215680.693452]  cf253000 cc7cdedc cf25302c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  cc7cdf60 cf25303c cf253034 cfa981a0 cf253060 cf253024 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c013a583>] ? do_futex+0xe3/0x920
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshfs         S 00000000     0  3193      1
[215680.693452]  00000000 00000082 c15e30d0 00000000 00000060 cf088a80 c020ad8c 00000000
[215680.693452]  cf253000 c1685edc cf25302c 00000001 c03e72e5 c020b4ba 00000000 00000002
[215680.693452]  c1685f60 cf25303c cf253034 cfa981a0 cf253060 cf253024 00000000 c44d88fc
[215680.693452] Call Trace:
[215680.693452]  [<c020ad8c>] ? request_end+0xdc/0x160
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c020b4ba>] ? fuse_dev_read+0x29a/0x480
[215680.693452]  [<c020ae80>] ? fuse_dev_write+0x0/0x3a0
[215680.693452]  [<c0163afe>] ? do_sync_readv_writev+0xce/0x110
[215680.693452]  [<c03a3e52>] ? tcp_v4_rcv+0x5e2/0x630
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        R running      0  7269   1821
[215680.693452]  c15e2bb4 00000082 c15e2a30 c0499320 00000003 cf0c5c40 000081b6 c0103269
[215680.693452]  00000286 0cd6e035 c9f03cf4 0cd6e034 c03e72e5 c03e74a0 c9f12050 0000007b
[215680.693452]  00000000 00200200 0cd6e035 c0124de0 c15e2a30 c053c7c0 c684c040 ce22bd48
[215680.693452] Call Trace:
[215680.693452]  [<c0103269>] ? common_interrupt+0x29/0x30
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74a0>] ? schedule_timeout+0xb0/0x110
[215680.693452]  [<c0124de0>] ? process_timeout+0x0/0x10
[215680.693452]  [<c0251380>] ? xfs_iget+0x1a0/0x390
[215680.693452]  [<c026a705>] ? xfs_trans_iget+0xf5/0x120
[215680.693452]  [<c025486a>] ? xfs_ialloc+0xba/0x680
[215680.693452]  [<c026b199>] ? xfs_dir_ialloc+0x89/0x2e0
[215680.693452]  [<c0268e12>] ? xfs_trans_reserve+0x82/0x220
[215680.693452]  [<c026da7a>] ? xfs_create+0x3ea/0x5d0
[215680.693452]  [<c0277c21>] ? xfs_vn_mknod+0x81/0x120
[215680.693452]  [<c016bc90>] ? vfs_create+0x90/0xe0
[215680.693452]  [<c0277ce0>] ? xfs_vn_create+0x0/0x10
[215680.693452]  [<c016eaeb>] ? do_filp_open+0x72b/0x830
[215680.693452]  [<c016208b>] ? do_sys_open+0x5b/0x110
[215680.693452]  [<c01621bc>] ? sys_open+0x2c/0x40
[215680.693452]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215680.693452] sshd          S 00000000     0 13131   1529
[215680.693452]  00000000 00000086 cf920ea0 00000000 00000000 cf088260 00000000 00000000
[215680.693452]  c16bfe2c 7fffffff 7fffffff 00000000 c03e72e5 c03e74cd c16bfdb8 c16bfdb8
[215680.693452]  c9fa5e2c cc70c084 c16bfdfc cc70c090 c012dbfb 000000c1 c16bfe2c 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c012dbfb>] ? autoremove_wake_function+0x1b/0x50
[215680.693452]  [<c03c27e4>] ? unix_stream_recvmsg+0x374/0x4d0
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0358ab5>] ? sock_aio_read+0x125/0x140
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0164a2f>] ? vfs_read+0x12f/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshd          S cf9e9818     0 13134  13131
[215680.693452]  cf9202e4 00000082 cf920160 cf9e9818 c04a1760 cf0888e0 00000010 0813ee21
[215680.693452]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 188493cc 00000001
[215680.693452]  00000000 00000000 00000082 cf007400 c02d9ae0 00000082 00000000 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[215680.693452]  [<c02d9ae0>] ? n_tty_poll+0x0/0x1a0
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c038ca85>] ? ip_local_out+0x15/0x20
[215680.693452]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[215680.693452]  [<c0367bbe>] ? dev_queue_xmit+0xbe/0x3b0
[215680.693452]  [<c038d8f2>] ? ip_finish_output+0x192/0x270
[215680.693452]  [<c038ca85>] ? ip_local_out+0x15/0x20
[215680.693452]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[215680.693452]  [<c038d8f2>] ? ip_finish_output+0x192/0x270
[215680.693452]  [<c03a26e4>] ? tcp_v4_send_check+0x44/0xf0
[215680.693452]  [<c039eb34>] ? tcp_transmit_skb+0x444/0x680
[215680.693452]  [<c03a0b2b>] ? tcp_write_xmit+0x1fb/0x9a0
[215680.693452]  [<c0360fd2>] ? __alloc_skb+0x52/0x130
[215680.693452]  [<c035bdbc>] ? release_sock+0xc/0x80
[215680.693452]  [<c0394d64>] ? tcp_sendmsg+0x694/0xa40
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215680.693452]  [<c02d6e4f>] ? tty_wakeup+0x2f/0x70
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] bash          S 00000000     0 13135  13134
[215680.693452]  00000000 00000082 cf9e98d0 00000000 00000000 cf088c20 c0118423 00000004
[215680.693452]  00000001 7fffffff 00000001 00000001 c03e72e5 c03e74cd 00000286 00000000
[215680.693452]  00000004 cf007400 cf007000 c02d6e4f c04b5660 cf007400 00000001 cf007000
[215680.693452] Call Trace:
[215680.693452]  [<c0118423>] ? __wake_up_common+0x43/0x70
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c02d6e4f>] ? tty_wakeup+0x2f/0x70
[215680.693452]  [<c02da631>] ? n_tty_read+0x441/0x6c0
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c02d656d>] ? tty_read+0x8d/0xd0
[215680.693452]  [<c02da1f0>] ? n_tty_read+0x0/0x6c0
[215680.693452]  [<c02d64e0>] ? tty_read+0x0/0xd0
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] screen        S cf920160     0 13154      1
[215680.693452]  00000000 00000082 cf89ce00 cf920160 cf252c00 cfb65040 c02de400 c1bde340
[215680.693452]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 c1bde340 00000001
[215680.693452]  00000000 00000000 00000082 cf252c00 c02d9ae0 00000082 00000000 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c02de400>] ? pty_write+0x0/0x60
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[215680.693452]  [<c02d9ae0>] ? n_tty_poll+0x0/0x1a0
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c025c5c8>] ? xlog_write+0x138/0x540
[215680.693452]  [<c026a8ae>] ? xfs_trans_unlock_chunk+0xae/0x100
[215680.693452]  [<c026a989>] ? xfs_trans_unlock_items+0x49/0xd0
[215680.693452]  [<c025bb43>] ? xlog_state_release_iclog+0x33/0x90
[215680.693452]  [<c025be81>] ? xfs_log_release_iclog+0x11/0x40
[215680.693452]  [<c0268cb5>] ? _xfs_trans_commit+0x285/0x360
[215680.693452]  [<c027092d>] ? kmem_zone_alloc+0x7d/0xc0
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c011791d>] ? check_preempt_wakeup+0xad/0xd0
[215680.693452]  [<c0126738>] ? __send_signal+0x118/0x220
[215680.693452]  [<c0126b47>] ? __group_send_sig_info+0x17/0x20
[215680.693452]  [<c01276ac>] ? kill_pid_info+0x2c/0x50
[215680.693452]  [<c012776a>] ? sys_kill+0x9a/0x140
[215680.693452]  [<c0172a12>] ? dput+0x82/0x100
[215680.693452]  [<c0177e73>] ? mntput_no_expire+0x13/0xa0
[215680.693452]  [<c018048c>] ? do_utimes+0xbc/0x100
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] bash          S c02d7c50     0 13155  13154
[215680.693452]  cf89dcc4 00000082 cf89db40 c02d7c50 c6e288e0 cfb65d40 ccf8c000 c016f78f
[215680.693452]  cf89db38 cf89db40 cf89dc60 00000003 c03e72e5 c011edd0 ccf8df68 00000003
[215680.693452]  00000000 0000000e 00000000 bfee5c98 00000000 0000000e 00000000 0000000e
[215680.693452] Call Trace:
[215680.693452]  [<c02d7c50>] ? tty_ioctl+0x0/0x740
[215680.693452]  [<c016f78f>] ? vfs_ioctl+0x1f/0x80
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] lftp          S c02a0447     0 13169  13155
[215680.693452]  00000000 00000082 cf878a90 c02a0447 0000c350 cfb651e0 c14ddbe4 c14ddbb4
[215680.693452]  a9e1351a 0000c5a8 c14ddbe4 c14ddbb4 c03e72e5 c03e7b43 0000c350 00000000
[215680.693452]  00000000 cfb71781 cf1a9b2c ce039f58 a9e1f86a 0000c5a8 a9e1351a 0000c5a8
[215680.693452] Call Trace:
[215680.693452]  [<c02a0447>] ? __const_udelay+0x27/0x30
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7b43>] ? schedule_hrtimeout_range+0xc3/0x140
[215680.693452]  [<c0130820>] ? hrtimer_wakeup+0x0/0x20
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c0170e16>] ? do_sys_poll+0x296/0x390
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c02906a3>] ? __generic_unplug_device+0x23/0x30
[215680.693452]  [<c0298f3b>] ? cfq_insert_request+0x24b/0x350
[215680.693452]  [<c037bc9b>] ? __nf_ct_refresh_acct+0xcb/0xe0
[215680.693452]  [<c037f89e>] ? tcp_packet+0x8ce/0xd40
[215680.693452]  [<c028fa24>] ? generic_make_request+0x224/0x2f0
[215680.693452]  [<c037b1b7>] ? __nf_conntrack_find+0xe7/0x100
[215680.693452]  [<c037b296>] ? nf_conntrack_find_get+0x16/0x120
[215680.693452]  [<c03be21b>] ? ipt_do_table+0x1bb/0x330
[215680.693452]  [<c035c16c>] ? sk_reset_timer+0xc/0x20
[215680.693452]  [<c039cefc>] ? tcp_rcv_established+0x66c/0x7f0
[215680.693452]  [<c03a3763>] ? tcp_v4_do_rcv+0xa3/0x1b0
[215680.693452]  [<c03799c6>] ? nf_iterate+0x76/0x90
[215680.693452]  [<c03a3de8>] ? tcp_v4_rcv+0x578/0x630
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c038898e>] ? ip_rcv_finish+0x13e/0x270
[215680.693452]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c01710b7>] ? sys_poll+0x67/0xd0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D cf402150     0 19048   1821
[215680.693452]  00000000 00000086 c15e3770 cf402150 c1085ba0 cf331100 00000000 00000001
[215680.693452]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215680.693452]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff c997f878
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215680.693452]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215680.693452]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215680.693452]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215680.693452]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215680.693452]  [<c023a791>] ? xfs_btree_read_bufl+0x71/0xa0
[215680.693452]  [<c0234566>] ? xfs_bmap_read_extents+0xa6/0x380
[215680.693452]  [<c0254e97>] ? xfs_iread_extents+0x67/0xe0
[215680.693452]  [<c023640d>] ? xfs_bmapi+0x11d/0x14d0
[215680.693452]  [<c03bc59e>] ? nf_nat_setup_info+0x57e/0x660
[215680.693452]  [<c03be21b>] ? ipt_do_table+0x1bb/0x330
[215680.693452]  [<c031b96c>] ? tulip_start_xmit+0xec/0x120
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c0258964>] ? xfs_iomap+0x1b4/0x3e0
[215680.693452]  [<c0271582>] ? __xfs_get_blocks+0xa2/0x2a0
[215680.693452]  [<c0180c8d>] ? alloc_buffer_head+0xd/0x60
[215680.693452]  [<c02717d0>] ? xfs_get_blocks+0x20/0x30
[215680.693452]  [<c0182bc4>] ? __block_prepare_write+0x1d4/0x3f0
[215680.693452]  [<c014139b>] ? add_to_page_cache_locked+0x4b/0xb0
[215680.693452]  [<c0182f65>] ? block_write_begin+0x45/0xe0
[215680.693452]  [<c02717b0>] ? xfs_get_blocks+0x0/0x30
[215680.693452]  [<c0272b36>] ? xfs_vm_write_begin+0x46/0x50
[215680.693452]  [<c02717b0>] ? xfs_get_blocks+0x0/0x30
[215680.693452]  [<c0141f86>] ? generic_file_buffered_write+0x106/0x300
[215680.693452]  [<c02791ea>] ? xfs_write+0x77a/0x860
[215680.693452]  [<c0275361>] ? xfs_file_aio_write+0x61/0x70
[215680.693452]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015a256>] ? page_add_new_anon_rmap+0x56/0x80
[215680.693452]  [<c0153a7e>] ? handle_mm_fault+0x42e/0x530
[215680.693452]  [<c016758e>] ? sys_fstat64+0x1e/0x30
[215680.693452]  [<c0163b40>] ? do_sync_write+0x0/0x120
[215680.693452]  [<c0164750>] ? vfs_write+0xa0/0x140
[215680.693452]  [<c01648c1>] ? sys_write+0x41/0x80
[215680.693452]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215680.693452] vsftpd        D 00000000     0 29887   1821
[215680.693452]  00000000 00000082 cf9e9580 00000000 4a7df9b3 cf288220 4a8077bb 03bca3c6
[215680.693452]  cd1621bc ffffffff cf9e9580 cd1621c0 c03e78bb cd1621c0 cd1621c0 cf9e9580
[215680.693452]  00c372e8 00000000 c89589a0 c3b8a000 c03e7819 c0164c03 00000000 c0164be0
[215680.693452] Call Trace:
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c0164c03>] ? generic_file_llseek+0x23/0x60
[215680.693452]  [<c0164be0>] ? generic_file_llseek+0x0/0x60
[215680.693452]  [<c01637ac>] ? vfs_llseek+0x3c/0x50
[215680.693452]  [<c0164ba6>] ? sys_llseek+0x56/0x90
[215680.693452]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215680.693452] md5sum   D 02bb4af3     0 30660  19048
[215680.693452]  00000000 00000086 cf879b20 02bb4af3 00003000 cf35e600 cf402380 00000010
[215680.693452]  c049f170 cf879b20 c15a7c74 c12003b0 c03e72e5 c03e7311 c15a7c6c c014111d
[215680.693452]  c03e76f2 00000003 c01410f0 c04c371c cf879b20 c15a7c88 c10b65a0 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215680.693452] md5sum   D c01202d3     0 30661  29887
[215680.693452]  00000000 00000082 cf8783f0 c01202d3 cf6e0390 cfb65520 c21abaa0 c1052d40
[215680.693452]  c049f170 cf8783f0 c8123c74 c12003b0 c03e72e5 c03e7311 c8123c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf8783f0 c8123c88 c10b65a0 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c01202d3>] ? current_fs_time+0x13/0x20
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102cb5>] ? syscall_call+0x7/0xb
[215680.693452] vsftpd        D cf935088     0 30663   1821
[215680.693452]  c15d9914 00000082 c15d9790 cf935088 c15d9790 cf288a40 c1200118 c02906a3
[215680.693452]  c049f170 c15d9790 c14ebc74 c1200118 c03e72e5 c03e7311 c14ebc6c c014111d
[215680.693452]  c03e76f2 0000001b c01410f0 c04c371c c15d9790 c14ebc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c02906a3>] ? __generic_unplug_device+0x23/0x30
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141994>] ? filemap_fault+0x2a4/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30664   1821
[215680.693452]  00000000 00000082 cf920800 00000000 0100a150 cfaca6e0 c7a057e0 80000000
[215680.693452]  c049f170 cf920800 cc643c74 c1200118 c03e72e5 c03e7311 cc643c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf920800 cc643c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30671   1821
[215680.693452]  00000000 00000086 c15d90f0 00000000 010090f0 cfb65ba0 c4099c20 80000000
[215680.693452]  c049f170 c15d90f0 c4099c74 c1200118 c03e72e5 c03e7311 c4099c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d90f0 c4099c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30672   1821
[215680.693452]  00000000 00000082 cf9204b0 00000000 0100a150 cf331780 ce03f2a0 80000000
[215680.693452]  c049f170 cf9204b0 c3ac7c74 c1200118 c03e72e5 c03e7311 c3ac7c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf9204b0 c3ac7c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30673   1821
[215680.693452]  00000000 00000086 cf878de0 00000000 0100a150 cf0880c0 ce05b540 80000000
[215680.693452]  c049f170 cf878de0 c9123c74 c1200118 c03e72e5 c03e7311 c9123c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf878de0 c9123c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30674   1821
[215680.693452]  00000000 00000082 c15d8a50 00000000 0100a150 cf35eae0 ce09ec60 80000000
[215680.693452]  c049f170 c15d8a50 cd03dc74 c1200118 c03e72e5 c03e7311 cd03dc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d8a50 cd03dc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c999be88     0 30681   1894
[215680.693452]  00000000 00000082 c15e26e0 c999be88 c696b534 cf088740 c016b3d3 c999be9c
[215680.693452]  cfaf6a00 c999bedc c999bf60 00001000 c03e72e5 c016a175 00000000 c15e26e0
[215680.693452]  c012dbe0 cfaf6a00 cfaf6a00 c8c95860 c999bedc c016aa6e 000007f4 c999bf60
[215680.693452] Call Trace:
[215680.693452]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30682  30681
[215680.693452]  00000000 00000086 c15e3420 00000000 c106c8c0 cf288700 c0152354 03646067
[215680.693452]  c15e3418 c15e3420 c15e3540 00000003 c03e72e5 c011edd0 c1ba3f68 00000003
[215680.693452]  00000000 00000004 00000000 bfb26438 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D cf402150     0 30683  30682
[215680.693452]  00000000 00000086 cf8b0780 cf402150 c1137380 cf288560 00000000 00000001
[215680.693452]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215680.693452]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff ccd84898
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215680.693452]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215680.693452]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215680.693452]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215680.693452]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215680.693452]  [<c023f6da>] ? xfs_da_do_buf+0x4aa/0x870
[215680.693452]  [<c023fb30>] ? xfs_da_read_buf+0x30/0x40
[215680.693452]  [<c0244061>] ? xfs_dir2_block_lookup_int+0x51/0x200
[215680.693452]  [<c0244061>] ? xfs_dir2_block_lookup_int+0x51/0x200
[215680.693452]  [<c022e91f>] ? xfs_bmap_last_offset+0x12f/0x140
[215680.693452]  [<c0244750>] ? xfs_dir2_block_lookup+0x20/0xc0
[215680.693452]  [<c0243185>] ? xfs_dir_lookup+0x145/0x170
[215680.693452]  [<c026dccb>] ? xfs_lookup+0x6b/0xf0
[215680.693452]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215680.693452]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215680.693452]  [<c016c90f>] ? __link_path_walk+0x17f/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c6ed1e88     0 30684   1894
[215680.693452]  00000000 00000082 cf920b50 c6ed1e88 c696b534 cf288be0 c016b3d3 c6ed1e9c
[215680.693452]  cd054400 c6ed1edc c6ed1f60 00001000 c03e72e5 c016a175 00000000 cf920b50
[215680.693452]  c012dbe0 cd054400 cd054400 c8c958e0 c6ed1edc c016aa6e 00000781 c6ed1f60
[215680.693452] Call Trace:
[215680.693452]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30685  30684
[215680.693452]  00000000 00000086 cf921540 00000000 c103e780 cf2888a0 c0152354 01f3c067
[215680.693452]  cf921538 cf921540 cf921660 00000003 c03e72e5 c011edd0 c8e33f68 00000003
[215680.693452]  00000000 00000004 00000000 bfedecd8 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D cf402150     0 30686  30685
[215680.693452]  00000000 00000082 c15e2390 cf402150 c1037f80 cf288080 00000000 00000001
[215680.693452]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215680.693452]  00000000 00001000 00000004 00000000 c027371c 00000000 7fffffff ccd84a18
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215680.693452]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215680.693452]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215680.693452]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215680.693452]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215680.693452]  [<c023f6da>] ? xfs_da_do_buf+0x4aa/0x870
[215680.693452]  [<c023fb30>] ? xfs_da_read_buf+0x30/0x40
[215680.693452]  [<c0245d03>] ? xfs_dir2_leaf_lookup_int+0x63/0x2f0
[215680.693452]  [<c0245d03>] ? xfs_dir2_leaf_lookup_int+0x63/0x2f0
[215680.693452]  [<c022ef3b>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[215680.693452]  [<c0246a37>] ? xfs_dir2_leaf_lookup+0x27/0xc0
[215680.693452]  [<c02427ef>] ? xfs_dir2_isleaf+0x1f/0x60
[215680.693452]  [<c0243108>] ? xfs_dir_lookup+0xc8/0x170
[215680.693452]  [<c026dccb>] ? xfs_lookup+0x6b/0xf0
[215680.693452]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215680.693452]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c1415e88     0 30687   1894
[215680.693452]  00000000 00000086 c15e3ac0 c1415e88 c04c3774 cf2c78c0 c03efda0 0000002c
[215680.693452]  cd0d7c00 c1415edc c1415f60 00001000 c03e72e5 c016a175 00000000 c15e3ac0
[215680.693452]  c012dbe0 cd0d7c00 cd0d7c00 c8b6d940 c1415edc c016aa6e 0000086b c1415f60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30688  30687
[215680.693452]  00000000 00000082 c15e2040 00000000 c10d3c20 cf2c7720 c0152354 069e1067
[215680.693452]  c15e2038 c15e2040 c15e2160 00000003 c03e72e5 c011edd0 c1417f68 00000003
[215680.693452]  00000000 00000004 00000000 bfa14098 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D c0104a67     0 30689  30688
[215680.693452]  00000000 00000086 cf864a70 c0104a67 c1585e10 cf2c70a0 cf864a70 00000000
[215680.693452]  cf6aa63c ffffffff cf864a70 cf6aa640 c03e78bb c1443e04 cf6aa640 cf864a70
[215680.693452]  c1585e70 00000000 c1585ef4 c1585e70 c03e7819 c016b423 c1585e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c0104a67>] ? handle_irq+0x17/0x20
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30695   1821
[215680.693452]  00000000 00000086 cf8643d0 00000000 0100a150 cfacad60 c8a126e0 80000000
[215680.693452]  c049f170 cf8643d0 c70d7c74 c1200118 c03e72e5 c03e7311 c70d7c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf8643d0 c70d7c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30696   1821
[215680.693452]  00000000 00000086 c15e2d80 00000000 0100a150 cf088dc0 cfb99e60 80000000
[215680.693452]  c049f170 c15e2d80 c38cbc74 c1200118 c03e72e5 c03e7311 c38cbc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15e2d80 c38cbc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30697   1821
[215680.693452]  00000000 00000086 cf864dc0 00000000 0100a150 cf3312a0 ce03f520 80000000
[215680.693452]  c049f170 cf864dc0 c926dc74 c1200118 c03e72e5 c03e7311 c926dc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf864dc0 c926dc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30698   1821
[215680.693452]  00000000 00000086 cf8d8b10 00000000 0100a150 cfacabc0 ce05b8c0 80000000
[215680.693452]  c049f170 cf8d8b10 c260bc74 c1200118 c03e72e5 c03e7311 c260bc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf8d8b10 c260bc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30699   1821
[215680.693452]  00000000 00000086 cf9e8b90 00000000 0100a150 cf0c55c0 c7a05660 80000000
[215680.693452]  c049f170 cf9e8b90 ce9cbc74 c1200118 c03e72e5 c03e7311 ce9cbc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf9e8b90 ce9cbc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30700   1821
[215680.693452]  00000000 00000082 cf9e9230 00000000 0100a150 cf2c7580 cf20e860 80000000
[215680.693452]  c049f170 cf9e9230 ca90dc74 c1200118 c03e72e5 c03e7311 ca90dc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf9e9230 ca90dc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30707   1821
[215680.693452]  00000000 00000082 cf8c5b80 00000000 0100a150 cf35ee20 ce09f6a0 80000000
[215680.693452]  c049f170 cf8c5b80 cc31fc74 c1200118 c03e72e5 c03e7311 cc31fc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf8c5b80 cc31fc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30708   1821
[215680.693452]  00000000 00000086 c15d8060 00000000 0100a150 cfaca3a0 ce09ed60 80000000
[215680.693452]  c049f170 c15d8060 c5e13c74 c1200118 c03e72e5 c03e7311 c5e13c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d8060 c5e13c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30709   1821
[215680.693452]  00000000 00000082 c15d9440 00000000 0100a150 cf0c5420 c7a05e60 80000000
[215680.693452]  c049f170 c15d9440 c802bc74 c1200118 c03e72e5 c03e7311 c802bc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d9440 c802bc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30710   1821
[215680.693452]  00000000 00000086 c15d8700 00000000 0100a150 cf0885a0 c21aba20 80000000
[215680.693452]  c049f170 c15d8700 cc8d7c74 c1200118 c03e72e5 c03e7311 cc8d7c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d8700 cc8d7c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30711   1821
[215680.693452]  00000000 00000086 c15d9ae0 00000000 0100a150 cf2c7a60 c8958920 80000000
[215680.693452]  c049f170 c15d9ae0 c1463c74 c1200118 c03e72e5 c03e7311 c1463c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d9ae0 c1463c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30712   1821
[215680.693452]  00000000 00000086 c15d83b0 00000000 0100a150 cf2c7c00 cf882740 80000000
[215680.693452]  c049f170 c15d83b0 c1409c74 c1200118 c03e72e5 c03e7311 c1409c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c15d83b0 c1409c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30713   1821
[215680.693452]  00000000 00000086 cf8b0ad0 00000000 0100a150 cf331e00 c8a12ce0 80000000
[215680.693452]  c049f170 cf8b0ad0 c140bc74 c1200118 c03e72e5 c03e7311 c140bc6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c cf8b0ad0 c140bc88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30720   1821
[215680.693452]  00000000 00000086 c14c5c20 00000000 0100a150 cf2c7da0 c47420e0 80000000
[215680.693452]  c049f170 c14c5c20 c14c7c74 c1200118 c03e72e5 c03e7311 c14c7c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c14c5c20 c14c7c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D c04c371c     0 30721   1821
[215680.693452]  00000000 00000082 c14c41a0 c04c371c c0103269 cf35ec80 c4703000 00000500
[215680.693452]  c049f170 c14c41a0 c1451c74 c1200118 c03e72e5 c03e7311 c1451c6c c014111d
[215680.693452]  c03e76f2 c02a07cb c01410f0 c04c371c c14c41a0 c1451c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c0103269>] ? common_interrupt+0x29/0x30
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c02a07cb>] ? mmx_clear_page+0x2b/0xd0
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30722   1821
[215680.693452]  00000000 00000082 c14c58d0 00000000 0100a150 cf35e120 c8958d20 80000000
[215680.693452]  c049f170 c14c58d0 c1453c74 c1200118 c03e72e5 c03e7311 c1453c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c14c58d0 c1453c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30723   1821
[215680.693452]  00000000 00000086 c14c44f0 00000000 0100a150 cf35e2c0 c8a12ee0 80000000
[215680.693452]  c049f170 c14c44f0 c1651c74 c1200118 c03e72e5 c03e7311 c1651c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c14c44f0 c1651c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] vsftpd        D 00000000     0 30724   1821
[215680.693452]  00000000 00000082 c14c5580 00000000 0100a150 cf35e940 ce05b940 80000000
[215680.693452]  c049f170 c14c5580 c1505c74 c1200118 c03e72e5 c03e7311 c1505c6c c014111d
[215680.693452]  c03e76f2 00000254 c01410f0 c04c371c c14c5580 c1505c88 c11e7340 c01410cc
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7311>] ? io_schedule+0x11/0x20
[215680.693452]  [<c014111d>] ? sync_page+0x2d/0x60
[215680.693452]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[215680.693452]  [<c01410f0>] ? sync_page+0x0/0x60
[215680.693452]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[215680.693452]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[215680.693452]  [<c014127f>] ? find_lock_page+0x4f/0x70
[215680.693452]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[215680.693452]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[215680.693452]  [<c013fd8e>] ? rcu_process_callbacks+0x1e/0x20
[215680.693452]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0113a42>] ? do_page_fault+0x132/0x290
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c03e87dd>] ? error_code+0x65/0x6c
[215680.693452]  [<c0113910>] ? do_page_fault+0x0/0x290
[215680.693452]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[215680.693452]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[215680.693452]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[215680.693452]  [<c029e16b>] ? strrchr+0xb/0x20
[215680.693452]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0152937>] ? follow_page+0x117/0x150
[215680.693452]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[215680.693452]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[215680.693452]  [<c016827e>] ? copy_strings+0x16e/0x190
[215680.693452]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[215680.693452]  [<c01693ab>] ? do_execve+0x2bb/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshd          S 00000000     0 30725   1529
[215680.693452]  00000000 00000086 c14c4840 00000000 00000000 cf35e460 00000000 00000000
[215680.693452]  c1507e2c 7fffffff 7fffffff 00000000 c03e72e5 c03e74cd c1507db8 c1507db8
[215680.693452]  c1641e2c c6a28384 c1507dfc c6a28390 c012dbfb 000000c1 c1507e2c 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c012dbfb>] ? autoremove_wake_function+0x1b/0x50
[215680.693452]  [<c03c27e4>] ? unix_stream_recvmsg+0x374/0x4d0
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0358ab5>] ? sock_aio_read+0x125/0x140
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0164a2f>] ? vfs_read+0x12f/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sshd          S c1489518     0 30728  30725
[215680.693452]  00000000 00000082 c14c4b90 c1489518 00000000 cf2c7240 00000046 08000030
[215680.693452]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 18641bec 00000001
[215680.693452]  00000000 00000000 00000082 c8159400 c02d9ae0 00000082 00000000 00000000
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[215680.693452]  [<c02d9ae0>] ? n_tty_poll+0x0/0x1a0
[215680.693452]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[215680.693452]  [<c017154b>] ? do_select+0x3cb/0x4f0
[215680.693452]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c0171ce0>] ? pollwake+0x0/0x50
[215680.693452]  [<c038ca85>] ? ip_local_out+0x15/0x20
[215680.693452]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[215680.693452]  [<c035ed9d>] ? skb_checksum+0x4d/0x280
[215680.693452]  [<c03a26e4>] ? tcp_v4_send_check+0x44/0xf0
[215680.693452]  [<c039eb34>] ? tcp_transmit_skb+0x444/0x680
[215680.693452]  [<c035c16c>] ? sk_reset_timer+0xc/0x20
[215680.693452]  [<c03a0b2b>] ? tcp_write_xmit+0x1fb/0x9a0
[215680.693452]  [<c0360fd2>] ? __alloc_skb+0x52/0x130
[215680.693452]  [<c035bdbc>] ? release_sock+0xc/0x80
[215680.693452]  [<c0394d64>] ? tcp_sendmsg+0x694/0xa40
[215680.693452]  [<c017184e>] ? core_sys_select+0x1de/0x310
[215680.693452]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[215680.693452]  [<c02d6e4f>] ? tty_wakeup+0x2f/0x70
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] bash          S c02d7c50     0 30729  30728
[215680.693452]  c14c53b4 00000086 c14c5230 c02d7c50 cf0afba0 cfaca060 c1440000 c016f78f
[215680.693452]  c14c5228 c14c5230 c14c5350 00000003 c03e72e5 c011edd0 c1441f68 00000003
[215680.693452]  00000000 0000000e 00000000 bf8316c8 00000000 0000000e 00000000 0000000e
[215680.693452] Call Trace:
[215680.693452]  [<c02d7c50>] ? tty_ioctl+0x0/0x740
[215680.693452]  [<c016f78f>] ? vfs_ioctl+0x1f/0x80
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c14e5e88     0 30750   1894
[215680.693452]  00000000 00000086 c4a00bb0 c14e5e88 c696b534 cf041860 c016b3d3 c14e5e9c
[215680.693452]  c99f7600 c14e5edc c14e5f60 00001000 c03e72e5 c016a175 00000000 c4a00bb0
[215680.693452]  c012dbe0 c99f7600 c99f7600 cfaa45a0 c14e5edc c016aa6e 000005ed c14e5f60
[215680.693452] Call Trace:
[215680.693452]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30751  30750
[215680.693452]  00000000 00000082 c4a00860 00000000 c106f760 cfaca540 c0152354 037bb067
[215680.693452]  c4a00858 c4a00860 c4a00980 00000003 c03e72e5 c011edd0 c48c9f68 00000003
[215680.693452]  00000000 00000004 00000000 bfdf3088 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D 00000000     0 30752  30751
[215680.693452]  00000000 00000082 c4a00510 00000000 00000000 cfaca880 00000000 00000000
[215680.693452]  cf5a11bc ffffffff c4a00510 cf5a11c0 c03e78bb cf5a11c0 cf5a11c0 c4a00510
[215680.693452]  c5ad9e70 00000000 c5ad9ef4 c5ad9e70 c03e7819 c016b423 c5ad9e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016c90f>] ? __link_path_walk+0x17f/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c14e7e88     0 30753   1894
[215680.693452]  00000000 00000086 c4a001c0 c14e7e88 c696b534 cfaca200 c016b3d3 c14e7e9c
[215680.693452]  c4c42000 c14e7edc c14e7f60 00001000 c03e72e5 c016a175 00000000 c4a001c0
[215680.693452]  c012dbe0 c4c42000 c4c42000 cf83dda0 c14e7edc c016aa6e 00000863 c14e7f60
[215680.693452] Call Trace:
[215680.693452]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30754  30753
[215680.693452]  00000000 00000082 c4a01c40 00000000 c11e7720 cf0411e0 c0152354 0f3b9067
[215680.693452]  c4a01c38 c4a01c40 c4a01d60 00000003 c03e72e5 c011edd0 c8733f68 00000003
[215680.693452]  00000000 00000004 00000000 bfa8dd98 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D 00000044     0 30755  30754
[215680.693452]  00000000 00000086 c4a015a0 00000044 00000000 cf0c5900 00000000 00000000
[215680.693452]  cf6aa63c ffffffff c4a015a0 cf6aa640 c03e78bb c1555e04 c1585e04 c4a015a0
[215680.693452]  c1443e70 00000000 c1443ef4 c1443e70 c03e7819 c016b423 c1443e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S c04c371c     0 30756   1894
[215680.693452]  00000000 00000082 c4a01250 c04c371c 000000d0 cf0c5de0 c04c371c 000000d0
[215680.693452]  c99f7800 c1429edc c1429f60 00001000 c03e72e5 c016a175 00000000 c4a01250
[215680.693452]  c012dbe0 c99f7800 c99f7800 c1bdec40 c1429edc c016aa6e 000006b7 c1429f60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D cf402150     0 30757  30756
[215680.693452]  00000000 00000082 c4a00f00 cf402150 c111e120 cf0c5280 00000000 00000002
[215680.693452]  7fffffff 7fffffff 00000002 00000000 c03e72e5 c03e74cd c018552a 00001000
[215680.693452]  00000000 00001000 00000008 00000000 c027371c 00000000 7fffffff c997f4b8
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[215680.693452]  [<c018552a>] ? bio_add_page+0x3a/0x50
[215680.693452]  [<c027371c>] ? _xfs_buf_ioapply+0x18c/0x290
[215680.693452]  [<c03e6f1f>] ? wait_for_common+0xef/0x110
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c02734ae>] ? xfs_buf_iowait+0x2e/0x40
[215680.693452]  [<c0274c2f>] ? xfs_buf_read_flags+0x4f/0x80
[215680.693452]  [<c026a061>] ? xfs_trans_read_buf+0x181/0x340
[215680.693452]  [<c0254f58>] ? xfs_imap_to_bp+0x48/0x110
[215680.693452]  [<c0256634>] ? xfs_iread+0x94/0x1b0
[215680.693452]  [<c02511b1>] ? xfs_inode_alloc+0xd1/0x100
[215680.693452]  [<c02513d6>] ? xfs_iget+0x1f6/0x390
[215680.693452]  [<c026dd28>] ? xfs_lookup+0xc8/0xf0
[215680.693452]  [<c0277a85>] ? xfs_vn_lookup+0x55/0xa0
[215680.693452]  [<c016b4fa>] ? do_lookup+0x1ba/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c0146422>] ? get_page_from_freelist+0x292/0x450
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[215680.693452]  [<c016208b>] ? do_sys_open+0x5b/0x110
[215680.693452]  [<c01621bc>] ? sys_open+0x2c/0x40
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S 00000000     0 30758   1894
[215680.693452]  00000000 00000082 c4a018f0 00000000 00000000 c44afe40 c04c3740 00000246
[215680.693452]  c99f7200 c142bedc c142bf60 00001000 c03e72e5 c016a175 00000000 c4a018f0
[215680.693452]  c012dbe0 c99f7200 c99f7200 c1bde740 c142bedc c016aa6e 000006a3 c142bf60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000008     0 30759  30758
[215680.693452]  00000000 00000086 c146dc60 00000008 c10a3920 c44afca0 c0152584 00000000
[215680.693452]  c146dc58 c146dc60 c146dd80 00000003 c03e72e5 c011edd0 c146ff68 00000003
[215680.693452]  00000000 00000004 00000000 bfe0bf98 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152584>] ? do_wp_page+0x334/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D c90a9650     0 30760  30759
[215680.693452]  00000000 00000086 c146d910 c90a9650 c0185ee0 c44afb00 00000400 00000c00
[215680.693452]  cf6aa63c ffffffff c146d910 cf6aa640 c03e78bb c1617e04 c1443e04 c146d910
[215680.693452]  c1555e70 00000000 c1555ef4 c1555e70 c03e7819 c016b423 c1555e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c0185ee0>] ? bio_fs_destructor+0x0/0x10
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016cde6>] ? __link_path_walk+0x656/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S 00000000     0 30761   1894
[215680.693452]  00000000 00000086 c146d5c0 00000000 00000000 c44af960 c04c3740 00000246
[215680.693452]  c1855e00 c1557edc c1557f60 00001000 c03e72e5 c016a175 00000000 c146d5c0
[215680.693452]  c012dbe0 c1855e00 c1855e00 c1b028c0 c1557edc c016aa6e 000007f3 c1557f60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30762  30761
[215680.693452]  00000000 00000086 c146d270 00000000 c10eb900 c44af7c0 c0152354 075c8067
[215680.693452]  c146d268 c146d270 c146d390 00000003 c03e72e5 c011edd0 c1615f68 00000003
[215680.693452]  00000000 00000004 00000000 bf8208e8 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D 1ccf74c0     0 30763  30762
[215680.693452]  00000000 00000082 c146cf20 1ccf74c0 c4a01924 c44af620 c146d2a4 c029d591
[215680.693452]  cf6aa63c ffffffff c146cf20 cf6aa640 c03e78bb c16b5e04 c1555e04 c146cf20
[215680.693452]  c1617e70 00000000 c1617ef4 c1617e70 c03e7819 c016b423 c1617e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c029d591>] ? rb_insert_color+0xc1/0xf0
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S 00000000     0 30764   1894
[215680.693452]  00000000 00000082 c146cbd0 00000000 00000000 c44af480 c04c3740 00000246
[215680.693452]  c1855a00 c8bfdedc c8bfdf60 00001000 c03e72e5 c016a175 00000000 c146cbd0
[215680.693452]  c012dbe0 c1855a00 c1855a00 ce09f320 c8bfdedc c016aa6e 00000668 c8bfdf60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000008     0 30765  30764
[215680.693452]  00000000 00000082 c146c880 00000008 c11002c0 c44af2e0 c0152584 00000000
[215680.693452]  c146c878 c146c880 c146c9a0 00000003 c03e72e5 c011edd0 c9ea5f68 00000003
[215680.693452]  00000000 00000004 00000000 bff003a8 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152584>] ? do_wp_page+0x334/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D 00000000     0 30766  30765
[215680.693452]  c146c6b4 00000082 c146c530 00000000 00000000 c44af140 00008068 00000008
[215680.693452]  cf6aa63c ffffffff c146c530 cf6aa640 c03e78bb cf6aa640 c16b5e04 c146c530
[215680.693452]  cce39e70 00000000 cce39ef4 cce39e70 c03e7819 c016b423 cce39e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c0162f79>] ? do_truncate+0x79/0x90
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] cron          S 00000000     0 30767   1894
[215680.693452]  00000000 00000082 c146c1e0 00000000 00000000 c8baad40 c04c3740 00000246
[215680.693452]  c1855600 cceededc cceedf60 00001000 c03e72e5 c016a175 00000000 c146c1e0
[215680.693452]  c012dbe0 c1855600 c1855600 c8a12ae0 cceededc c016aa6e 000006d9 cceedf60
[215680.693452] Call Trace:
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c016a175>] ? pipe_wait+0x45/0x60
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[215680.693452]  [<c0140eac>] ? find_get_page+0x1c/0x70
[215680.693452]  [<c014124b>] ? find_lock_page+0x1b/0x70
[215680.693452]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[215680.693452]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0163c60>] ? do_sync_read+0x0/0x120
[215680.693452]  [<c016499d>] ? vfs_read+0x9d/0x140
[215680.693452]  [<c0164b11>] ? sys_read+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            S 00000000     0 30768  30767
[215680.693452]  00000000 00000086 c1489c80 00000000 c115c240 c8baaba0 c0152354 0ae12067
[215680.693452]  c1489c78 c1489c80 c1489da0 00000003 c03e72e5 c011edd0 c148bf68 00000003
[215680.693452]  00000000 00000004 00000000 bfe63c48 00000000 00000004 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] sh            D 30000000     0 30769  30768
[215680.693452]  00000000 00000086 c1489930 30000000 00000000 c8baaa00 00000040 00000286
[215680.693452]  cf6aa63c ffffffff c1489930 cf6aa640 c03e78bb cce39e04 c1617e04 c1489930
[215680.693452]  c16b5e70 00000000 c16b5ef4 c16b5e70 c03e7819 c016b423 c16b5e84 cf80c8a0
[215680.693452] Call Trace:
[215680.693452]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[215680.693452]  [<c03e7819>] ? mutex_lock+0x9/0x10
[215680.693452]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[215680.693452]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[215680.693452]  [<c016d573>] ? path_walk+0x53/0xb0
[215680.693452]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[215680.693452]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[215680.693452]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[215680.693452]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[215680.693452]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[215680.693452]  [<c0169188>] ? do_execve+0x98/0x360
[215680.693452]  [<c01016e6>] ? sys_execve+0x46/0x70
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] su            S 00000000     0 30780  30729
[215680.693452]  c1489414 00000086 c1489290 00000000 c105ff20 c8baa6c0 c0152354 02ff9067
[215680.693452]  c1489288 c1489290 c14893b0 00000003 c03e72e5 c011edd0 c9d01f68 00000003
[215680.693452]  00000000 00000006 00000000 bf87dcb8 00000000 00000006 00000000 00000006
[215680.693452] Call Trace:
[215680.693452]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[215680.693452]  [<c03e72e5>] ? schedule+0x5/0x20
[215680.693452]  [<c011edd0>] ? do_wait+0x260/0x300
[215680.693452]  [<c0118a10>] ? default_wake_function+0x0/0x10
[215680.693452]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[215680.693452]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[215680.693452] bash          R running      0 30781  30780
[215680.693452]  c125fdbe c125feb0 00000000 00000001 00000008 00000001 00000010 ffffffff
[215680.693452]  6666ffff 35326666 36393335 0000000a ffffffff 3830ffff 00000016 c00b8dc0
[215680.693452]  00000019 c1201d00 c04053a0 00000001 c02e54c1 c125fe08 00000003 c1201d00
[215680.693452] Call Trace:
[215680.693452]  [<c02e54c1>] ? scrup+0xe1/0xf0
[215680.693452]  [<c011c86a>] ? __call_console_drivers+0x3a/0x50
[215680.693452]  [<c011c86a>] ? __call_console_drivers+0x3a/0x50
[215680.693452]  [<c03e6ce5>] ? printk+0x17/0x1b
[215680.693452]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[215680.693452]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[215680.693452]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[215680.693452]  [<c0105c3e>] ? print_context_stack+0x4e/0xb0
[215680.693452]  [<c0104e1d>] ? dump_trace+0x6d/0xb0
[215680.693452]  [<c0105b5b>] ? show_trace_log_lvl+0x4b/0x60
[215680.693452]  [<c0104b1e>] ? show_stack_log_lvl+0x5e/0x100
[215680.693452]  [<c0105b0b>] ? show_stack+0x1b/0x20
[215680.693452]  [<c0119b4e>] ? show_state_filter+0x4e/0x70
[215680.693452]  [<c02ea4a0>] ? __handle_sysrq+0xe0/0x130
[215680.693452]  [<c02ea4f0>] ? write_sysrq_trigger+0x0/0x30
[215680.693452]  [<c02ea51e>] ? write_sysrq_trigger+0x2e/0x30
[215680.693452]  [<c0198d37>] ? proc_reg_write+0x47/0x70
[215680.693452]  [<c0198cf0>] ? proc_reg_write+0x0/0x70
[215680.693452]  [<c0164750>] ? vfs_write+0xa0/0x140
[215680.693452]  [<c01648c1>] ? sys_write+0x41/0x80
[215680.693452]  [<c0102c48>] ? sysenter_do_call+0x12/0x26



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
