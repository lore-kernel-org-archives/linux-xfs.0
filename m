Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p064GNph011302 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 22:16:24 -0600
Received: from zns001-0m9004.yokogawa.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0E3BF826B1
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 20:18:31 -0800 (PST)
Received: from zns001-0m9004.yokogawa.co.jp (zns001-0m9004.yokogawa.co.jp
	[203.174.79.162]) by cuda.sgi.com with ESMTP id
	1vW4umRA2J17ihd0 for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 20:18:31 -0800 (PST)
Received: from zns001-0m9004.yokogawa.co.jp (localhost [127.0.0.1])
	by zns001-0m9004.yokogawa.co.jp (8.12.10+Sun/8.12.10) with ESMTP id
	p064ITUQ022644
	for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 13:18:29 +0900 (JST)
Received: from zex001-0m9027.jp.ykgw.net (zex001-0m9027.jp.ykgw.net
	[10.0.11.46])
	by zns001-0m9004.yokogawa.co.jp (8.12.10+Sun/8.12.10) with ESMTP id
	p064IT8o022638
	for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 13:18:29 +0900 (JST)
From: <yuji_touya@yokogawa-digital.com>
Date: Thu, 6 Jan 2011 13:18:27 +0900
Subject: 2.6.27.30 fc10, some processes stuck in D state
Message-ID: <8529A87D856C184491994079B5F87B68C1A8289FCC@EXMAIL03.jp.ykgw.net>
Content-Language: ja-JP
MIME-Version: 1.0
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

Hello folks,

We need to save a bunch of transport-stream(TS) data(4MB/sec, 300GB/day), and
are using xfs formatted hardware RAID system to save TS data.
Some processes (pdflush, kswapd, our own services etc) stuck in D-state and
our system stops saving and down-converting TS data.
It rarely happens (3 times in recent 3 months), but it's quite serious for us.
How can we avoid this?

One more thing, in that situation when I run "ls /mnt/raid/foo" command, 
all stuck processes suddenly wake up and continue running. Very strange...
(/mnt/raid is where we mount xfs)

kenel: fedora 10
Linux version 2.6.27.30-170.2.82.fc10.i686 (mockbuild@xenbuilder4.fedora.phx.redhat.com)
(gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #1 SMP Mon Aug 17 08:38:59 EDT2009
cpu:
Intel(R) Xeon(R) E5420 CPU @ 2.50GHz  (4 cores)
mount:
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
/dev/mapper/IcmsT2-Volume00 on /mnt/raid type xfs (rw)

result of SysRq + w:
SysRq : Show Blocked State
 task                PC stack   pid father
pdflush       D c07fc900     0   289      2
      f5e82b2c 00000046 c04749e5 c07fc900 00000001 c087c67c c087fc00 c087fc00 
      c087fc00 f78d4010 f78d4284 c2032c00 00000003 c2032c00 c8113a78 ded18d80 
      000000ca 00000000 ded18dc0 f78d4284 0651f34e 00000004 00000005 00a000ca 
Call Trace:
[<c04749e5>] ? __alloc_pages_internal+0xb0/0x399
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<f9070cbd>] ? xfs_bmap_search_extents+0x4c/0xab [xfs]
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f9091f63>] xlog_grant_log_space+0x84/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f908d224>] xfs_iomap_write_allocate+0x101/0x355 [xfs]
[<f908de36>] ? xfs_iomap+0x18b/0x2c9 [xfs]
[<f908df15>] xfs_iomap+0x26a/0x2c9 [xfs]
[<f90a3439>] xfs_map_blocks+0x2b/0x63 [xfs]
[<f90a3d19>] xfs_page_state_convert+0x326/0x5d2 [xfs]
[<c0482ca9>] ? page_mkclean+0x15/0x1d7
[<f90a4239>] xfs_vm_writepage+0xa0/0xd7 [xfs]
[<c0474e6b>] __writepage+0xb/0x26
[<c0475759>] write_cache_pages+0x1bc/0x2ad
[<c0474e60>] ? __writepage+0x0/0x26
[<c0475867>] generic_writepages+0x1d/0x27
[<f90a4182>] xfs_vm_writepages+0x3e/0x44 [xfs]
[<f90a4144>] ? xfs_vm_writepages+0x0/0x44 [xfs]
[<c0475894>] do_writepages+0x23/0x34
[<c04ab96d>] __writeback_single_inode+0x16c/0x2b7
[<c060be47>] ? dm_any_congested+0x39/0x42
[<c04abe33>] generic_sync_sb_inodes+0x202/0x31b
[<c04ac0e5>] writeback_inodes+0x7d/0xc5
[<c0475e1d>] background_writeout+0x73/0x9f
[<c04762c1>] pdflush+0x12c/0x1d5
[<c0475daa>] ? background_writeout+0x0/0x9f
[<c0476195>] ? pdflush+0x0/0x1d5
[<c043ece3>] kthread+0x3b/0x61
[<c043eca8>] ? kthread+0x0/0x61
[<c040590b>] kernel_thread_helper+0x7/0x10
=======================
kswapd0       D f796c258     0   291      2
      f5e80b08 00000046 00000021 f796c258 f5e80ae0 c087c67c c087fc00 c087fc00 
      c087fc00 f78d59b0 f78d5c24 c201cc00 00000001 c201cc00 c8113a78 ded18d80 
      000000ca 00000000 ded18dc0 f78d5c24 06b83185 00000004 00000005 00a000ca 
Call Trace:
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<f9070cbd>] ? xfs_bmap_search_extents+0x4c/0xab [xfs]
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f9091f63>] xlog_grant_log_space+0x84/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f908d224>] xfs_iomap_write_allocate+0x101/0x355 [xfs]
[<c04264ec>] ? check_preempt_wakeup+0x145/0x1c3
[<f908de36>] ? xfs_iomap+0x18b/0x2c9 [xfs]
[<f908df15>] xfs_iomap+0x26a/0x2c9 [xfs]
[<f90a3439>] xfs_map_blocks+0x2b/0x63 [xfs]
[<f90a3d19>] xfs_page_state_convert+0x326/0x5d2 [xfs]
[<c0482ca9>] ? page_mkclean+0x15/0x1d7
[<f90a4239>] xfs_vm_writepage+0xa0/0xd7 [xfs]
[<c047846a>] shrink_page_list+0x330/0x55d
[<c0477ade>] ? isolate_lru_pages+0x7c/0x16d
[<c04787fd>] shrink_inactive_list+0x144/0x373
[<c06abc79>] ? _spin_lock+0x8/0xb
[<f90c93c3>] ? nfs_access_cache_shrinker+0x174/0x1ad [nfs]
[<c0478ae7>] shrink_zone+0xbb/0xda
[<c0478fe3>] kswapd+0x329/0x43c
[<c0477bcf>] ? isolate_pages_global+0x0/0x3e
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c0478cba>] ? kswapd+0x0/0x43c
[<c043ece3>] kthread+0x3b/0x61
[<c043eca8>] ? kthread+0x0/0x61
[<c040590b>] kernel_thread_helper+0x7/0x10
=======================
icms          D e0bc99d4     0  2860      1
      e0debe00 00000086 c436cdc8 e0bc99d4 e0debe60 c087c67c c087fc00 c087fc00 
      c087fc00 f4c1cce0 f4c1cf54 c2032c00 00000003 c2032c00 e0debdc8 e0debe60 
      00040000 0000e9f8 00000000 f4c1cf54 065204d3 c046fa29 0000000e 00000000 
Call Trace:
[<c046fa29>] ? find_get_pages+0x28/0xb0
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<c0476915>] ? pagevec_lookup+0x19/0x22
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f9091f63>] xlog_grant_log_space+0x84/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f90a0558>] xfs_free_eofblocks+0x193/0x230 [xfs]
[<f90a0f7e>] xfs_release+0x167/0x173 [xfs]
[<c06aa82f>] ? schedule+0x6ee/0x70d
[<f90a6515>] xfs_file_release+0xe/0x12 [xfs]
[<c04938a5>] __fput+0xad/0x13d
[<c049394c>] fput+0x17/0x19
[<c04911df>] filp_close+0x50/0x5a
[<c049125b>] sys_close+0x72/0xb1
[<c0404c8a>] syscall_call+0x7/0xb
=======================
gnome-setting D c0471cc1     0  3130      1
      f5148900 00000086 c048f5e4 c0471cc1 00011220 c087c67c c087fc00 c087fc00 
      c087fc00 e08059b0 e0805c24 c201cc00 00000001 c201cc00 c8113a78 ded18d80 
      000000ca 00000000 ded18dc0 e0805c24 0747d4ba 00000004 00000005 00a000ca 
Call Trace:
[<c048f5e4>] ? kmem_cache_alloc+0x80/0xc4
[<c0471cc1>] ? mempool_alloc_slab+0xe/0x10
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<f9070cbd>] ? xfs_bmap_search_extents+0x4c/0xab [xfs]
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f9091f63>] xlog_grant_log_space+0x84/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f908d224>] xfs_iomap_write_allocate+0x101/0x355 [xfs]
[<c041f874>] ? resched_task+0x3a/0x6e
[<f908de36>] ? xfs_iomap+0x18b/0x2c9 [xfs]
[<f908df15>] xfs_iomap+0x26a/0x2c9 [xfs]
[<f90a3439>] xfs_map_blocks+0x2b/0x63 [xfs]
[<f90a3d19>] xfs_page_state_convert+0x326/0x5d2 [xfs]
[<c0482ca9>] ? page_mkclean+0x15/0x1d7
[<f90a4239>] xfs_vm_writepage+0xa0/0xd7 [xfs]
[<c047846a>] shrink_page_list+0x330/0x55d
[<c0477ade>] ? isolate_lru_pages+0x7c/0x16d
[<c04787fd>] shrink_inactive_list+0x144/0x373
[<c0475e6a>] ? throttle_vm_writeout+0x21/0x74
[<c0478ae7>] shrink_zone+0xbb/0xda
[<c047959d>] try_to_free_pages+0x201/0x321
[<c0477bcf>] ? isolate_pages_global+0x0/0x3e
[<c0474b57>] __alloc_pages_internal+0x222/0x399
[<c047d68f>] handle_mm_fault+0x14c/0x6d1
[<c0629a80>] ? __sock_recvmsg+0x51/0x5b
[<c06adadf>] do_page_fault+0x33d/0x710
[<c0480e92>] ? vma_merge+0x1bc/0x237
[<c0481a81>] ? __vm_enough_memory+0x17/0xde
[<c048151e>] ? mmap_region+0x179/0x3fa
[<c04816ce>] ? mmap_region+0x329/0x3fa
[<c0481a0a>] ? do_mmap_pgoff+0x26b/0x2cb
[<c0498e1a>] ? path_put+0x15/0x18
[<c0461ccd>] ? audit_syscall_exit+0xb2/0xc7
[<c06ad7a2>] ? do_page_fault+0x0/0x710
[<c06ac07a>] error_code+0x72/0x78
=======================
DownConvert   D c0447428     0  3161   2860
      e0817e00 00000086 f786a670 c0447428 00000000 c087c67c c087fc00 c087fc00 
      c087fc00 e0bc99a0 e0bc9c14 c2027c00 00000002 c2027c00 c0406f63 00000046 
      c2023104 00000000 e000be70 e0bc9c14 06520571 e0817000 c052068c c087fc00 
Call Trace:
[<c0447428>] ? tick_program_event+0x22/0x29
[<c0406f63>] ? do_softirq+0xbe/0xdb
[<c052068c>] ? trace_hardirqs_on_thunk+0xc/0x10
[<c0404cd7>] ? restore_nocheck_notrace+0x0/0xe
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f909201c>] xlog_grant_log_space+0x13d/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f90a0558>] xfs_free_eofblocks+0x193/0x230 [xfs]
[<f90a0f7e>] xfs_release+0x167/0x173 [xfs]
[<f90a6515>] xfs_file_release+0xe/0x12 [xfs]
[<c04938a5>] __fput+0xad/0x13d
[<c049394c>] fput+0x17/0x19
[<c04911df>] filp_close+0x50/0x5a
[<c049125b>] sys_close+0x72/0xb1
[<c0404c8a>] syscall_call+0x7/0xb
=======================
extif         D 00c066d4     0  4914   2870
      d8259e2c 00000082 c04e0bf8 00c066d4 d8259dd4 c087c67c c087fc00 c087fc00 
      c087fc00 e0bcd9b0 e0bcdc24 c2032c00 00000003 c2032c00 dc4a9908 00000015 
      7c012ebf db74d019 f77c1908 e0bcdc24 06520ade d8259e58 db74d000 d8259e20 
Call Trace:
[<c04e0bf8>] ? ext3_get_acl+0x77/0x26f
[<c04a21aa>] ? dput+0x34/0x107
[<c06abb52>] rwsem_down_failed_common+0x81/0x95
[<c06abba6>] rwsem_down_read_failed+0x1d/0x27
[<c06abbeb>] call_rwsem_down_read_failed+0x7/0xc
[<c06ab1e8>] ? down_read+0x26/0x29
[<f9087632>] xfs_ilock+0x2b/0x4b [xfs]
[<f90a9c7d>] xfs_read+0xf8/0x1cb [xfs]
[<f90a64bb>] xfs_file_aio_read+0x51/0x59 [xfs]
[<c0492a5a>] do_sync_read+0xab/0xe9
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c041f802>] ? need_resched+0x18/0x22
[<c048d041>] ? virt_to_head_page+0x22/0x2e
[<c04f66ea>] ? security_file_permission+0xf/0x11
[<c04929af>] ? do_sync_read+0x0/0xe9
[<c0493310>] vfs_read+0x81/0xdc
[<c0493404>] sys_read+0x3b/0x60
[<c0404c8a>] syscall_call+0x7/0xb
=======================
extif         D 00c066d4     0  7721   2870
      de6e5e2c 00000086 c04e0bf8 00c066d4 de6e5dd4 c087c67c c087fc00 c087fc00 
      c087fc00 e0800000 e0800274 c2027c00 00000002 c2027c00 dc4a9908 00000015 
      7c012ebf f4c04019 f77c1908 e0800274 0669c893 de6e5e58 f4c04000 de6e5e20 
Call Trace:
[<c04e0bf8>] ? ext3_get_acl+0x77/0x26f
[<c04a21aa>] ? dput+0x34/0x107
[<c06abb52>] rwsem_down_failed_common+0x81/0x95
[<c06abba6>] rwsem_down_read_failed+0x1d/0x27
[<c06abbeb>] call_rwsem_down_read_failed+0x7/0xc
[<c06ab1e8>] ? down_read+0x26/0x29
[<f9087632>] xfs_ilock+0x2b/0x4b [xfs]
[<f90a9c7d>] xfs_read+0xf8/0x1cb [xfs]
[<f90a64bb>] xfs_file_aio_read+0x51/0x59 [xfs]
[<c0492a5a>] do_sync_read+0xab/0xe9
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c041f802>] ? need_resched+0x18/0x22
[<c048d041>] ? virt_to_head_page+0x22/0x2e
[<c04f66ea>] ? security_file_permission+0xf/0x11
[<c04929af>] ? do_sync_read+0x0/0xe9
[<c0493310>] vfs_read+0x81/0xdc
[<c0493404>] sys_read+0x3b/0x60
[<c0404c8a>] syscall_call+0x7/0xb
=======================
extif         D 00c066d4     0  8628   2870
      de873e2c 00000086 c04e0bf8 00c066d4 de873dd4 c087c67c c087fc00 c087fc00 
      c087fc00 e0e359b0 e0e35c24 c2032c00 00000003 c2032c00 dc4a9908 00000015 
      7c012ebf db74d019 f77c1908 e0e35c24 06b091d2 de873e58 db74d000 de873e20 
Call Trace:
[<c04e0bf8>] ? ext3_get_acl+0x77/0x26f
[<c04a21aa>] ? dput+0x34/0x107
[<c06abb52>] rwsem_down_failed_common+0x81/0x95
[<c06abba6>] rwsem_down_read_failed+0x1d/0x27
[<c06abbeb>] call_rwsem_down_read_failed+0x7/0xc
[<c06ab1e8>] ? down_read+0x26/0x29
[<f9087632>] xfs_ilock+0x2b/0x4b [xfs]
[<f90a9c7d>] xfs_read+0xf8/0x1cb [xfs]
[<f90a64bb>] xfs_file_aio_read+0x51/0x59 [xfs]
[<c0492a5a>] do_sync_read+0xab/0xe9
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c041f802>] ? need_resched+0x18/0x22
[<c048d041>] ? virt_to_head_page+0x22/0x2e
[<c04f66ea>] ? security_file_permission+0xf/0x11
[<c04929af>] ? do_sync_read+0x0/0xe9
[<c0493310>] vfs_read+0x81/0xdc
[<c0493404>] sys_read+0x3b/0x60
[<c0404c8a>] syscall_call+0x7/0xb
=======================
tar           D 00000000     0  8728   8727
      d81c08e8 00000082 00000000 00000000 00000000 c087c67c c087fc00 c087fc00 
      c087fc00 e0bccce0 e0bccf54 c2011c00 00000000 c2011c00 c8113a78 ded18d80 
      000000ca 00000000 ded18dc0 e0bccf54 06b834d7 00000004 00000005 00a000ca 
Call Trace:
[<c06aab3b>] schedule_timeout+0x17/0xbc
[<f9070cbd>] ? xfs_bmap_search_extents+0x4c/0xab [xfs]
[<c043f136>] ? add_wait_queue_exclusive+0x2b/0x30
[<f909012c>] _sv_wait+0x53/0x65 [xfs]
[<c04281f0>] ? default_wake_function+0x0/0xd
[<f9091f63>] xlog_grant_log_space+0x84/0x269 [xfs]
[<f90921e8>] xfs_log_reserve+0xa0/0xa8 [xfs]
[<f909b940>] xfs_trans_reserve+0xbe/0x19d [xfs]
[<f908d224>] xfs_iomap_write_allocate+0x101/0x355 [xfs]
[<f908de36>] ? xfs_iomap+0x18b/0x2c9 [xfs]
[<f908df15>] xfs_iomap+0x26a/0x2c9 [xfs]
[<f90a3439>] xfs_map_blocks+0x2b/0x63 [xfs]
[<f90a3d19>] xfs_page_state_convert+0x326/0x5d2 [xfs]
[<c0482ca9>] ? page_mkclean+0x15/0x1d7
[<f90a4239>] xfs_vm_writepage+0xa0/0xd7 [xfs]
[<c047846a>] shrink_page_list+0x330/0x55d
[<c0477ade>] ? isolate_lru_pages+0x7c/0x16d
[<c04787fd>] shrink_inactive_list+0x144/0x373
[<c0475e6a>] ? throttle_vm_writeout+0x21/0x74
[<c0478ae7>] shrink_zone+0xbb/0xda
[<c047959d>] try_to_free_pages+0x201/0x321
[<c0477bcf>] ? isolate_pages_global+0x0/0x3e
[<c0474b57>] __alloc_pages_internal+0x222/0x399
[<c04764dd>] __do_page_cache_readahead+0xa0/0x159
[<c04767d2>] ondemand_readahead+0x101/0x10f
[<c0476837>] page_cache_async_readahead+0x57/0x62
[<c0471540>] generic_file_aio_read+0x248/0x539
[<c0492a5a>] do_sync_read+0xab/0xe9
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c041f802>] ? need_resched+0x18/0x22
[<c04f66ea>] ? security_file_permission+0xf/0x11
[<c04929af>] ? do_sync_read+0x0/0xe9
[<c0493310>] vfs_read+0x81/0xdc
[<c0493404>] sys_read+0x3b/0x60
[<c0404c8a>] syscall_call+0x7/0xb
=======================
extif         D 00c066d4     0 22868   2870
      f5b77e2c 00000086 c04e0bf8 00c066d4 f5b77dd4 c087c67c c087fc00 c087fc00 
      c087fc00 dcd52670 dcd528e4 c2027c00 00000002 c2027c00 dc4a9908 00000015 
      7c012ebf f4c05019 f77c1908 dcd528e4 0ae7ef5e f5b77e58 f4c05000 f5b77e20 
Call Trace:
[<c04e0bf8>] ? ext3_get_acl+0x77/0x26f
[<c04a21aa>] ? dput+0x34/0x107
[<c06abb52>] rwsem_down_failed_common+0x81/0x95
[<c06abba6>] rwsem_down_read_failed+0x1d/0x27
[<c06abbeb>] call_rwsem_down_read_failed+0x7/0xc
[<c06ab1e8>] ? down_read+0x26/0x29
[<f9087632>] xfs_ilock+0x2b/0x4b [xfs]
[<f90a9c7d>] xfs_read+0xf8/0x1cb [xfs]
[<f90a64bb>] xfs_file_aio_read+0x51/0x59 [xfs]
[<c0492a5a>] do_sync_read+0xab/0xe9
[<c043ef86>] ? autoremove_wake_function+0x0/0x33
[<c041f802>] ? need_resched+0x18/0x22
[<c048d041>] ? virt_to_head_page+0x22/0x2e
[<c04f66ea>] ? security_file_permission+0xf/0x11
[<c04929af>] ? do_sync_read+0x0/0xe9
[<c0493310>] vfs_read+0x81/0xdc
[<c0493404>] sys_read+0x3b/0x60
[<c0404c8a>] syscall_call+0x7/0xb

-----------
Yuji Touya
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
