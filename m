Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44438 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfHBE7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 00:59:04 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5F6C9287B5
        for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2019 04:59:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204409] New: BUG: KASAN: use-after-free in do_raw_spin_lock
Date: Fri, 02 Aug 2019 04:59:01 +0000
Message-ID: <bug-204409-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204409

            Bug ID: 204409
           Summary: BUG: KASAN: use-after-free in do_raw_spin_lock
           Product: File System
           Version: 2.5
    Kernel Version: v5.3-rc2 + xfs-5.3-fixes-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Description of problem:
when I use "XFS_IOC_GOINGDOWN" ioctl to simulate powerfailure to do some stress
test, I hit below errors on aarch64 machine:

[20635.666543] XFS (sda3): Mounting V5 Filesystem 
[20635.690232] XFS (sda3): Ending clean mount 
[20672.010761] restraintd[3690]: *** Current Time: Thu Aug 01 06:54:49 2019
Localwatchdog at: Sat Aug 03 01:13:49 2019 
[-- MARK -- Thu Aug  1 10:55:00 2019] 
[20732.070427] restraintd[3690]: *** Current Time: Thu Aug 01 06:55:49 2019
Localwatchdog at: Sat Aug 03 01:13:49 2019 
[20792.041464] restraintd[3690]: *** Current Time: Thu Aug 01 06:56:49 2019
Localwatchdog at: Sat Aug 03 01:13:49 2019 
[20852.044923] restraintd[3690]: *** Current Time: Thu Aug 01 06:57:49 2019
Localwatchdog at: Sat Aug 03 01:13:49 2019 
[20875.878643] XFS (sda3): User initiated shutdown received. Shutting down
filesystem 
[20875.878873] XFS (sda3): writeback error on sector 99772712 
[20875.879629]
================================================================== 
[20875.879800] BUG: KASAN: use-after-free in do_raw_spin_lock+0x22c/0x260 
[20875.879808] Read of size 4 at addr ffff800e188963c4 by task
kworker/53:0/222370 
[20875.879811]  
[20875.879819] CPU: 53 PID: 222370 Comm: kworker/53:0 Not tainted 5.3.0-rc2+ #1 
[20875.879823] Hardware name: HPE Apollo 70             /C01_APACHE_MB        
, BIOS L50_5.13_1.11 06/18/2019 
[20875.879972] Workqueue: xfs-cil/sda3 xlog_cil_push_work [xfs] 
[20875.879981] Call trace: 
[20875.879989]  dump_backtrace+0x0/0x2b8 
[20875.879994]  show_stack+0x24/0x30 
[20875.880000]  dump_stack+0x108/0x164 
[20875.880007]  print_address_description+0x54/0x388 
[20875.880012]  __kasan_report+0x174/0x1b0 
[20875.880016]  kasan_report+0xc/0x18 
[20875.880021]  __asan_report_load4_noabort+0x18/0x20 
[20875.880025]  do_raw_spin_lock+0x22c/0x260 
[20875.880030]  _raw_spin_lock_irqsave+0xc8/0xf0 
[20875.880036]  __wake_up_common_lock+0xb0/0x128 
[20875.880040]  __wake_up+0x40/0x50 
[20875.880151]  xfs_buf_item_unpin+0x824/0x11b8 [xfs] 
[20875.880262]  xfs_trans_committed_bulk+0x2a8/0x6f0 [xfs] 
[20875.880372]  xlog_cil_committed+0x150/0xf08 [xfs] 
[20875.880378] XFS (sda3): writeback error on sector 32632896 
[20875.880485]  xlog_cil_push+0x9a8/0xe00 [xfs] 
[20875.880596]  xlog_cil_push_work+0x38/0x50 [xfs] 
[20875.880606]  process_one_work+0x794/0x19e0 
[20875.880610]  worker_thread+0x49c/0xa98 
[20875.880616]  kthread+0x2d0/0x358 
[20875.880622]  ret_from_fork+0x10/0x18 
[20875.880625]  
[20875.880630] Allocated by task 224332: 
[20875.880638]  __kasan_kmalloc.isra.0.part.1+0x40/0xd8 
[20875.880642]  __kasan_kmalloc.isra.0+0xb8/0xd8 
[20875.880647]  kasan_slab_alloc+0x14/0x20 
[20875.880651]  kmem_cache_alloc+0x148/0x4d8 
[20875.880759]  kmem_zone_alloc+0x84/0x148 [xfs] 
[20875.880870]  _xfs_buf_alloc+0x4c/0x10d8 [xfs] 
[20875.880981]  xfs_buf_get_map+0x400/0xa78 [xfs] 
[20875.881091]  xfs_trans_get_buf_map+0x48c/0xe10 [xfs] 
[20875.881203]  xfs_btree_get_buf_block+0x184/0x2b0 [xfs] 
[20875.881209] XFS (sda3): writeback error on sector 8548592 
[20875.881315]  xfs_btree_new_root+0x5c4/0xd78 [xfs] 
[20875.881426]  xfs_btree_insrec+0xa50/0xf70 [xfs] 
[20875.881535]  xfs_btree_insert+0x1c4/0x4d8 [xfs] 
[20875.881645]  xfs_free_ag_extent+0x9a4/0x1b78 [xfs] 
[20875.881756]  xfs_free_agfl_block+0x50/0xd8 [xfs] 
[20875.881866]  xfs_agfl_free_finish_item+0x694/0xaf0 [xfs] 
[20875.881976]  xfs_defer_finish_noroll+0x5b0/0x21f8 [xfs] 
[20875.882086]  xfs_defer_finish+0x20/0x130 [xfs] 
[20875.882195]  xfs_itruncate_extents_flags+0x45c/0x1418 [xfs] 
[20875.882305]  xfs_free_eofblocks+0x3b4/0x5f0 [xfs] 
[20875.882415]  xfs_release+0x278/0x2f8 [xfs] 
[20875.882525]  xfs_file_release+0x20/0x30 [xfs] 
[20875.882533]  __fput+0x1f0/0x608 
[20875.882538]  ____fput+0x20/0x30 
[20875.882542]  task_work_run+0x100/0x170 
[20875.882546]  do_notify_resume+0x548/0x668 
[20875.882550]  work_pending+0x8/0x14 
[20875.882553]  
[20875.882557] Freed by task 224311: 
[20875.882563]  __kasan_slab_free+0x114/0x218 
[20875.882567]  kasan_slab_free+0x10/0x18 
[20875.882571]  kmem_cache_free+0xb8/0x590 
[20875.882680]  xfs_buf_free+0x2b8/0x828 [xfs] 
[20875.882795]  xfs_buf_rele+0x780/0x1a18 [xfs] 
[20875.882905]  xfs_buf_ioend+0x4a8/0x988 [xfs] 
[20875.883016]  xfs_buf_iodone_callbacks+0x1d0/0x258 [xfs] 
[20875.883125]  xfs_buf_ioend+0x458/0x988 [xfs] 
[20875.883234]  __xfs_buf_submit+0x798/0x920 [xfs] 
[20875.883343]  xfs_buf_delwri_submit_buffers+0x32c/0xad8 [xfs] 
[20875.883454]  xfs_buf_delwri_submit_nowait+0x24/0x30 [xfs] 
[20875.883563]  xfsaild_push+0x390/0x28d0 [xfs] 
[20875.883671]  xfsaild+0x1e0/0x6a0 [xfs] 
[20875.883678]  kthread+0x2d0/0x358 
[20875.883684]  ret_from_fork+0x10/0x18 
[20875.883686]  
[20875.883692] The buggy address belongs to the object at ffff800e18896300 
[20875.883692]  which belongs to the cache xfs_buf of size 600 
[20875.883697] The buggy address is located 196 bytes inside of 
[20875.883697]  600-byte region [ffff800e18896300, ffff800e18896558) 
[20875.883700] The buggy address belongs to the page: 
[20875.883705] page:ffff7fe003862240 refcount:1 mapcount:0
mapping:ffff800e41a94b00 index:0xffff800e18897e00 
[20875.883712] flags: 0x2fffff8000000200(slab) 
[20875.883720] raw: 2fffff8000000200 dead000000000100 dead000000000122
ffff800e41a94b00 
[20875.883726] raw: ffff800e18897e00 0000000080550018 00000001ffffffff
0000000000000000 
[20875.883729] page dumped because: kasan: bad access detected 
[20875.883731]  
[20875.883734] Memory state around the buggy address: 
[20875.883739]  ffff800e18896280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc 
[20875.883743]  ffff800e18896300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20875.883746] >ffff800e18896380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20875.883750]                                            ^ 
[20875.883753]  ffff800e18896400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20875.883757]  ffff800e18896480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20875.883760]
================================================================== 
[20875.883763] Disabling lock debugging due to kernel taint 
[20875.883836]
================================================================== 
[20875.883843] BUG: KASAN: double-free or invalid-free in kvfree+0x4c/0x58 
[20875.883845]  
[20875.883851] CPU: 53 PID: 222370 Comm: kworker/53:0 Tainted: G    B          
  5.3.0-rc2+ #1 
[20875.883854] Hardware name: HPE Apollo 70             /C01_APACHE_MB        
, BIOS L50_5.13_1.11 06/18/2019 
[20875.883962] Workqueue: xfs-cil/sda3 xlog_cil_push_work [xfs] 
[20875.883967] Call trace: 
[20875.883972]  dump_backtrace+0x0/0x2b8 
[20875.883976]  show_stack+0x24/0x30 
[20875.883980]  dump_stack+0x108/0x164 
[20875.883985]  print_address_description+0x168/0x388 
[20875.883989]  kasan_report_invalid_free+0x7c/0xb8 
[20875.883992]  __kasan_slab_free+0x1ec/0x218 
[20875.883996]  kasan_slab_free+0x10/0x18 
[20875.884000]  kfree+0x134/0x4c8 
[20875.884004]  kvfree+0x4c/0x58 
[20875.884111]  xfs_buf_free+0x65c/0x828 [xfs] 
[20875.884218]  xfs_buf_rele+0x780/0x1a18 [xfs] 
[20875.884324]  xfs_buf_ioend+0x4a8/0x988 [xfs] 
[20875.884431]  xfs_buf_item_unpin+0x7f4/0x11b8 [xfs] 
[20875.884540]  xfs_trans_committed_bulk+0x2a8/0x6f0 [xfs] 
[20875.884647]  xlog_cil_committed+0x150/0xf08 [xfs] 
[20875.884754]  xlog_cil_push+0x9a8/0xe00 [xfs] 
[20875.884863]  xlog_cil_push_work+0x38/0x50 [xfs] 
[20875.884869]  process_one_work+0x794/0x19e0 
[20875.884872]  worker_thread+0x49c/0xa98 
[20875.884876]  kthread+0x2d0/0x358 
[20875.884880]  ret_from_fork+0x10/0x18 
[20875.884883]  
[20875.884887] Allocated by task 224332: 
[20875.884893]  __kasan_kmalloc.isra.0.part.1+0x40/0xd8 
[20875.884896]  __kasan_kmalloc.isra.0+0xb8/0xd8 
[20875.884900]  kasan_kmalloc+0xc/0x18 
[20875.884904]  __kmalloc+0x1fc/0x538 
[20875.885009]  kmem_alloc+0x74/0x158 [xfs] 
[20875.885115]  xfs_buf_allocate_memory+0x90/0xbf0 [xfs] 
[20875.885224]  xfs_buf_get_map+0x410/0xa78 [xfs] 
[20875.885331]  xfs_trans_get_buf_map+0x48c/0xe10 [xfs] 
[20875.885438]  xfs_btree_get_buf_block+0x184/0x2b0 [xfs] 
[20875.885545]  xfs_btree_new_root+0x5c4/0xd78 [xfs] 
[20875.885652]  xfs_btree_insrec+0xa50/0xf70 [xfs] 
[20875.885758]  xfs_btree_insert+0x1c4/0x4d8 [xfs] 
[20875.885866]  xfs_free_ag_extent+0x9a4/0x1b78 [xfs] 
[20875.885973]  xfs_free_agfl_block+0x50/0xd8 [xfs] 
[20875.886080]  xfs_agfl_free_finish_item+0x694/0xaf0 [xfs] 
[20875.886188]  xfs_defer_finish_noroll+0x5b0/0x21f8 [xfs] 
[20875.886294]  xfs_defer_finish+0x20/0x130 [xfs] 
[20875.886405]  xfs_itruncate_extents_flags+0x45c/0x1418 [xfs] 
[20876.559099]  xfs_free_eofblocks+0x3b4/0x5f0 [xfs] 
[20876.564017]  xfs_release+0x278/0x2f8 [xfs] 
[20876.568325]  xfs_file_release+0x20/0x30 [xfs] 
[20876.572687]  __fput+0x1f0/0x608 
[20876.575827]  ____fput+0x20/0x30 
[20876.578966]  task_work_run+0x100/0x170 
[20876.582719]  do_notify_resume+0x548/0x668 
[20876.586726]  work_pending+0x8/0x14 
[20876.590121]  
[20876.591609] Freed by task 224311: 
[20876.594924]  __kasan_slab_free+0x114/0x218 
[20876.599018]  kasan_slab_free+0x10/0x18 
[20876.602766]  kfree+0x134/0x4c8 
[20876.605819]  kvfree+0x4c/0x58 
[20876.608987]  xfs_buf_free+0x65c/0x828 [xfs] 
[20876.613364]  xfs_buf_rele+0x780/0x1a18 [xfs] 
[20876.617839]  xfs_buf_ioend+0x4a8/0x988 [xfs] 
[20876.622319]  xfs_buf_iodone_callbacks+0x1d0/0x258 [xfs] 
[20876.627753]  xfs_buf_ioend+0x458/0x988 [xfs] 
[20876.632234]  __xfs_buf_submit+0x798/0x920 [xfs] 
[20876.636969]  xfs_buf_delwri_submit_buffers+0x32c/0xad8 [xfs] 
[20876.642836]  xfs_buf_delwri_submit_nowait+0x24/0x30 [xfs] 
[20876.648440]  xfsaild_push+0x390/0x28d0 [xfs] 
[20876.652908]  xfsaild+0x1e0/0x6a0 [xfs] 
[20876.656659]  kthread+0x2d0/0x358 
[20876.659888]  ret_from_fork+0x10/0x18 
[20876.663457]  
[20876.664949] The buggy address belongs to the object at ffff8009f2a9ba00 
[20876.664949]  which belongs to the cache kmalloc-4k of size 4096 
[20876.677470] The buggy address is located 0 bytes inside of 
[20876.677470]  4096-byte region [ffff8009f2a9ba00, ffff8009f2a9ca00) 
[20876.689115] The buggy address belongs to the page: 
[20876.693910] page:ffff7fe0027caa00 refcount:1 mapcount:0
mapping:ffff800ac001ed80 index:0xffff8009f2abb800 compound_mapcount: 0 
[20876.705304] flags: 0xfffff8000010200(slab|head) 
[20876.709838] raw: 0fffff8000010200 ffff7fe003b6fe00 0000000200000002
ffff800ac001ed80 
[20876.717583] raw: ffff8009f2abb800 00000000803c0002 00000001ffffffff
0000000000000000 
[20876.725324] page dumped because: kasan: bad access detected 
[20876.730892]  
[20876.732378] Memory state around the b uggy address: 
f f8009f2a9b980:   fb fb fb fb fb f b fb fb fb fb ff b 
[20876.77646====================================================== 
[20876.791061] BUG: KASAN: double-free or invalid-free in
xfs_buf_free+0x2b8/0x828 [xfs] 
....
....
[20877.167521] Memory state around the buggy address: 
[20877.172304]  ffff800e18896200: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
fc 
[20877.179516]  ffff800e18896280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc 
[20877.186729] >ffff800e18896300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20877.193940]                    ^ 
[20877.197160]  ffff800e18896380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20877.204372]  ffff800e18896400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb 
[20877.211584]
================================================================== 
[20888.443350] XFS (sda3): Unmounting Filesystem 
[20888.800328] XFS: Assertion failed: atomic_read(&pag->pag_ref) > 0, file:
fs/xfs/libxfs/xfs_sb.c, line: 88 
[20888.809945] ------------[ cut here ]------------ 
[20888.815071] WARNING: CPU: 201 PID: 226186 at fs/xfs/xfs_message.c:93
asswarn+0x4c/0x60 [xfs] 
[20888.823505] Modules linked in: loop sha2_ce sg ghash_ce sha256_arm64
crct10dif_ce ipmi_ssif i2c_smbus sha1_ce ipmi_devintf ipmi_msghandler
thunderx2_pmu sunrpc ext4 mbcache jbd2 vfat fat xfs libcrc32c sr_mod cdrom
mlx5_core ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops drm uas usb_storage mlxfw gpio_xlp i2c_xlp9xx 
[20888.855893] CPU: 201 PID: 226186 Comm: umount Tainted: G    B            
5.3.0-rc2+ #1 
[20888.863892] Hardware name: HPE Apollo 70             /C01_APACHE_MB        
, BIOS L50_5.13_1.11 06/18/2019 
[20888.873629] pstate: 10400009 (nzcV daif +PAN -UAO) 
[20888.878651] pc : asswarn+0x4c/0x60 [xfs] 
[20888.882781] lr : asswarn+0x4c/0x60 [xfs] 
[20888.886701] sp : ffff8009565c7770 
[20888.890010] x29: ffff8009565c7770 x28: ffff800a38133f00  
[20888.895321] x27: ffff2000135a9848 x26: 000000000000001d  
[20888.900632] x25: ffff20000c02d2c8 x24: ffff800e31a0d200  
[20888.905944] x23: ffff800ae3a6b400 x22: 0000000000000058  
[20888.911255] x21: ffff20000c17d9a0 x20: ffff20000c17db20  
[20888.916567] x19: ffff20000c187180 x18: 0000000000000000  
[20888.921877] x17: 0000000000000000 x16: 0000000000000000  
[20888.927188] x15: 0000000000000000 x14: 0000000000000010  
[20888.932498] x13: 2f7366782f736620 x12: ffff1001df7812b2  
[20888.937811] x11: 1ffff001df7812b1 x10: ffff1001df7812b1  
[20888.943123] x9 : 1ffff001df7812b1 x8 : dfff200000000000  
[20888.948433] x7 : ffff1001df7812b2 x6 : ffff800efbc0958f  
[20888.953744] x5 : 0000000000000001 x4 : ffff1001df7812b2  
[20888.959053] x3 : 1ffff001c6341a42 x2 : ec4de2664e41f300  
[20888.964364] x1 : 0000000000000000 x0 : 0000000000000024  
[20888.969675] Call trace: 
[20888.972345]  asswarn+0x4c/0x60 [ xfs] 
[20888.971 44]  xfs_wait_bs _log_unmount+0xe r+0x60/0xf8 [xf
 [20889.016218] anup_mnt+0x190/0x2f0 
[20889.028066]  __cleanup_mnt+0x20/0x30 
[20889.031640]  task_work_run+0x100/0x170 
[20889.035387]  do_notify_resume+0x548/0x668 
[20889.039394]  work_pending+0x8/0x14 
[20889.042791] irq event stamp: 0 
[20889.045846] hardirqs last  enabled at (0): [<0000000000000000>] 0x0 
[20889.052119] hardirqs last disabled at (0): [<ffff200010174c0c>]
copy_process+0x122c/0x5668 
[20889.060380] softirqs last  enabled at (0): [<ffff200010174c84>]
copy_process+0x12a4/0x5668 
[20889.068644] softirqs last disabled at (0): [<0000000000000000>] 0x0 
[20889.074909] ---[ end trace fff082c27130a17f ]--- 
[20889.142850] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file:
fs/xfs/xfs_mount.c, line: 148
....
....


Steps to Reproduce:
1. prepare a 50G local device
2. mkfs.xfs -f $dev
3. mount $dev $mnt
4. fs_mark  -d  $mnt  -n  10000  -N  10  -D  1000  -s  409600  -r  8  -t  10 
-k &
5. fsstress -d $mnt -n 1000 -p 100 -c -l 0 &
6. wait 1~15min randomly
7. xfs_io -xc "shutdown" $mnt
8. kill fs_mark and fssstress processes
9. umount $dev
10. mount $dev $mnt
11. umount $dev
12. xfs_repair -n $dev
13. loop run above 12 steps until reproduce this bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
