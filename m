Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39094 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727409AbfAXL7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 06:59:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A187C2EBA3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Jan 2019 11:59:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Thu, 24 Jan 2019 11:59:44 +0000
Message-ID: <bug-202349-201763-yYLhiFGsy4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

--- Comment #6 from nfxjfg@googlemail.com ---
In all the information below, the test disk was /dev/sdd, and was mounted on
/mnt/tmp1/.

Script which triggers the problem somewhat reliably:

-----

#!/bin/bash

TESTDIR=/mnt/tmp1/tests/
mkdir $TESTDIR

COUNTER=0
while true ; do
    dd if=/dev/zero of=$TESTDIR/f$COUNTER bs=1024 count=$((1*1024))
    COUNTER=$((COUNTER+1))
done

-----

Whether it "freezes" the system after a few seconds (under 1 minute) of running
seems to depend on the size of the files written. The system freeze is of
course not permanent; it's just a performance problem.

When the system freezes, even the mouse pointer can stop moving. As you can see
in the dmesg excerpt below, Xorg got blocked. The script was run from a
terminal emulator running on the X session. I'm fairly sure nothing other than
the test script accessed the test disk/filesystem. Sometimes the script blocks
for a while without freezing the system.

dmesg excerpt from when I triggered the blocked task sysrq via ssh, this
includes the messages from when the disk was hotplugged and mounted:

-----

[585767.299464] ata3: softreset failed (device not ready)
[585772.375433] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[585772.378964] ata3.00: ATA-9: HGST HUH728060ALE600, A4GNT7J0, max UDMA/133
[585772.378968] ata3.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[585772.386994] ata3.00: configured for UDMA/133
[585772.387134] scsi 2:0:0:0: Direct-Access     ATA      HGST HUH728060AL T7J0
PQ: 0 ANSI: 5
[585772.387453] sd 2:0:0:0: Attached scsi generic sg3 type 0
[585772.387599] sd 2:0:0:0: [sdd] 11721045168 512-byte logical blocks: (6.00
TB/5.46 TiB)
[585772.387604] sd 2:0:0:0: [sdd] 4096-byte physical blocks
[585772.387636] sd 2:0:0:0: [sdd] Write Protect is off
[585772.387640] sd 2:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[585772.387680] sd 2:0:0:0: [sdd] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[585772.432755]  sdd: sdd1
[585772.433234] sd 2:0:0:0: [sdd] Attached SCSI disk
[585790.697722] XFS (sdd1): Mounting V5 Filesystem
[585790.842858] XFS (sdd1): Ending clean mount
[587294.464409] sysrq: SysRq : Show Blocked State
[587294.464419]   task                        PC stack   pid father
[588653.596479] sysrq: SysRq : Show Blocked State
[588653.596488]   task                        PC stack   pid father
[588653.596534] kswapd0         D    0    93      2 0x80000000
[588653.596538] Call Trace:
[588653.596549]  ? __schedule+0x240/0x860
[588653.596553]  ? schedule_timeout+0x274/0x390
[588653.596557]  schedule+0x78/0x110
[588653.596560]  schedule_timeout+0x274/0x390
[588653.596565]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[588653.596568]  wait_for_completion+0xe2/0x140
[588653.596572]  ? wake_up_q+0x70/0x70
[588653.596576]  __flush_work+0xfb/0x1a0
[588653.596580]  ? flush_workqueue_prep_pwqs+0x130/0x130
[588653.596585]  xlog_cil_force_lsn+0x67/0x1d0
[588653.596591]  ? __xfs_iunpin_wait+0x96/0x150
[588653.596594]  xfs_log_force_lsn+0x73/0x130
[588653.596597]  ? xfs_reclaim_inode+0xb5/0x300
[588653.596600]  __xfs_iunpin_wait+0x96/0x150
[588653.596605]  ? init_wait_var_entry+0x40/0x40
[588653.596607]  xfs_reclaim_inode+0xb5/0x300
[588653.596611]  xfs_reclaim_inodes_ag+0x1a6/0x2f0
[588653.596616]  ? preempt_count_sub+0x43/0x50
[588653.596619]  ? _raw_spin_unlock+0x12/0x30
[588653.596621]  ? xfs_inode_set_reclaim_tag+0x9f/0x170
[588653.596624]  ? preempt_count_sub+0x43/0x50
[588653.596627]  xfs_reclaim_inodes_nr+0x31/0x40
[588653.596631]  super_cache_scan+0x14c/0x1a0
[588653.596635]  do_shrink_slab+0x125/0x2a0
[588653.596639]  shrink_slab+0x144/0x260
[588653.596643]  shrink_node+0xd6/0x420
[588653.596647]  kswapd+0x3ce/0x6e0
[588653.596651]  ? mem_cgroup_shrink_node+0x170/0x170
[588653.596654]  kthread+0x110/0x130
[588653.596658]  ? kthread_create_worker_on_cpu+0x40/0x40
[588653.596660]  ret_from_fork+0x24/0x30
[588653.596730] Xorg            D    0   894    880 0x00400004
[588653.596733] Call Trace:
[588653.596737]  ? __schedule+0x240/0x860
[588653.596741]  ? schedule_preempt_disabled+0x23/0xa0
[588653.596744]  schedule+0x78/0x110
[588653.596747]  ? __mutex_lock.isra.5+0x292/0x4b0
[588653.596750]  schedule_preempt_disabled+0x23/0xa0
[588653.596752]  __mutex_lock.isra.5+0x292/0x4b0
[588653.596757]  ? xfs_perag_get_tag+0x52/0xf0
[588653.596760]  xfs_reclaim_inodes_ag+0x287/0x2f0
[588653.596766]  ? radix_tree_gang_lookup_tag+0xc2/0x140
[588653.596770]  ? iput+0x210/0x210
[588653.596772]  ? preempt_count_sub+0x43/0x50
[588653.596775]  xfs_reclaim_inodes_nr+0x31/0x40
[588653.596778]  super_cache_scan+0x14c/0x1a0
[588653.596781]  do_shrink_slab+0x125/0x2a0
[588653.596784]  shrink_slab+0x204/0x260
[588653.596787]  ? __schedule+0x248/0x860
[588653.596791]  shrink_node+0xd6/0x420
[588653.596794]  do_try_to_free_pages+0xb6/0x350
[588653.596798]  try_to_free_pages+0xce/0x1b0
[588653.596802]  __alloc_pages_slowpath+0x33d/0xc80
[588653.596808]  __alloc_pages_nodemask+0x23f/0x260
[588653.596820]  ttm_pool_populate+0x25e/0x480 [ttm]
[588653.596825]  ? kmalloc_large_node+0x37/0x60
[588653.596828]  ? __kmalloc_node+0x20e/0x2b0
[588653.596836]  ttm_populate_and_map_pages+0x24/0x250 [ttm]
[588653.596845]  ttm_tt_populate.part.9+0x1b/0x60 [ttm]
[588653.596853]  ttm_tt_bind+0x42/0x60 [ttm]
[588653.596861]  ttm_bo_handle_move_mem+0x258/0x4e0 [ttm]
[588653.596939]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
[588653.596947]  ttm_bo_validate+0xe7/0x110 [ttm]
[588653.596951]  ? preempt_count_sub+0x43/0x50
[588653.596954]  ? _raw_write_unlock+0x12/0x30
[588653.596974]  ? drm_pci_agp_destroy+0x4d/0x50 [drm]
[588653.596983]  ttm_bo_init_reserved+0x347/0x390 [ttm]
[588653.597059]  amdgpu_bo_do_create+0x19c/0x420 [amdgpu]
[588653.597136]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
[588653.597213]  amdgpu_bo_create+0x30/0x200 [amdgpu]
[588653.597291]  amdgpu_gem_object_create+0x8b/0x110 [amdgpu]
[588653.597404]  amdgpu_gem_create_ioctl+0x1d0/0x290 [amdgpu]
[588653.597417]  ? preempt_count_sub+0x43/0x50
[588653.597421]  ? _raw_spin_unlock+0x12/0x30
[588653.597499]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
[588653.597521]  drm_ioctl_kernel+0x7f/0xd0 [drm]
[588653.597545]  drm_ioctl+0x1e4/0x380 [drm]
[588653.597625]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
[588653.597631]  ? tlb_finish_mmu+0x1f/0x30
[588653.597637]  ? preempt_count_sub+0x43/0x50
[588653.597712]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
[588653.597720]  do_vfs_ioctl+0x8d/0x5d0
[588653.597726]  ? do_munmap+0x33c/0x430
[588653.597731]  ? __fget+0x6e/0xa0
[588653.597736]  ksys_ioctl+0x60/0x90
[588653.597742]  __x64_sys_ioctl+0x16/0x20
[588653.597748]  do_syscall_64+0x4a/0xd0
[588653.597754]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[588653.597759] RIP: 0033:0x7f929cf6d747
[588653.597768] Code: Bad RIP value.
[588653.597771] RSP: 002b:00007ffca6b5df18 EFLAGS: 00003246 ORIG_RAX:
0000000000000010
[588653.597780] RAX: ffffffffffffffda RBX: 00007ffca6b5e000 RCX:
00007f929cf6d747
[588653.597783] RDX: 00007ffca6b5df70 RSI: 00000000c0206440 RDI:
000000000000000e
[588653.597787] RBP: 00007ffca6b5df70 R08: 000055f3e86a3290 R09:
000000000000000b
[588653.597791] R10: 000055f3e653c010 R11: 0000000000003246 R12:
00000000c0206440
[588653.597795] R13: 000000000000000e R14: 0000000000000000 R15:
000055f3e86a3290
[588653.598255] kworker/u32:0   D    0  6490      2 0x80000000
[588653.598263] Workqueue: writeback wb_workfn (flush-8:48)
[588653.598265] Call Trace:
[588653.598270]  ? __schedule+0x240/0x860
[588653.598274]  ? blk_flush_plug_list+0x1d9/0x220
[588653.598277]  ? io_schedule+0x12/0x40
[588653.598280]  schedule+0x78/0x110
[588653.598283]  io_schedule+0x12/0x40
[588653.598286]  get_request+0x26b/0x770
[588653.598291]  ? finish_wait+0x80/0x80
[588653.598294]  blk_queue_bio+0x15f/0x4e0
[588653.598297]  generic_make_request+0x1c0/0x460
[588653.598301]  submit_bio+0x45/0x140
[588653.598304]  xfs_submit_ioend+0x9c/0x1e0
[588653.598308]  xfs_vm_writepages+0x68/0x80
[588653.598312]  do_writepages+0x2e/0xb0
[588653.598315]  ? _raw_spin_unlock+0x12/0x30
[588653.598317]  ? list_lru_add+0xf5/0x1a0
[588653.598320]  __writeback_single_inode+0x3d/0x3d0
[588653.598323]  writeback_sb_inodes+0x1c4/0x430
[588653.598328]  __writeback_inodes_wb+0x5d/0xb0
[588653.598331]  wb_writeback+0x265/0x310
[588653.598335]  wb_workfn+0x314/0x410
[588653.598340]  process_one_work+0x199/0x3b0
[588653.598343]  worker_thread+0x30/0x380
[588653.598345]  ? rescuer_thread+0x310/0x310
[588653.598348]  kthread+0x110/0x130
[588653.598351]  ? kthread_create_worker_on_cpu+0x40/0x40
[588653.598354]  ret_from_fork+0x24/0x30
[588653.598380] xfsaild/sdd1    D    0 19755      2 0x80000000
[588653.598383] Call Trace:
[588653.598387]  ? __schedule+0x240/0x860
[588653.598389]  ? enqueue_entity+0xf6/0x6c0
[588653.598392]  ? schedule_timeout+0x274/0x390
[588653.598395]  schedule+0x78/0x110
[588653.598398]  schedule_timeout+0x274/0x390
[588653.598403]  ? tracing_record_taskinfo_skip+0x40/0x50
[588653.598405]  wait_for_completion+0xe2/0x140
[588653.598408]  ? wake_up_q+0x70/0x70
[588653.598411]  __flush_work+0xfb/0x1a0
[588653.598415]  ? flush_workqueue_prep_pwqs+0x130/0x130
[588653.598419]  xlog_cil_force_lsn+0x67/0x1d0
[588653.598422]  ? _raw_spin_unlock_irqrestore+0x22/0x40
[588653.598426]  ? try_to_del_timer_sync+0x3d/0x50
[588653.598429]  xfs_log_force+0x83/0x2d0
[588653.598432]  ? preempt_count_sub+0x43/0x50
[588653.598436]  xfsaild+0x19b/0x7f0
[588653.598440]  ? _raw_spin_unlock_irqrestore+0x22/0x40
[588653.598443]  ? xfs_trans_ail_cursor_first+0x80/0x80
[588653.598446]  kthread+0x110/0x130
[588653.598449]  ? kthread_create_worker_on_cpu+0x40/0x40
[588653.598452]  ret_from_fork+0x24/0x30
[588653.598462] kworker/6:2     D    0 19911      2 0x80000000
[588653.598468] Workqueue: xfs-cil/sdd1 xlog_cil_push_work
[588653.598469] Call Trace:
[588653.598473]  ? __schedule+0x240/0x860
[588653.598476]  ? _raw_spin_lock_irqsave+0x1c/0x40
[588653.598479]  ? xlog_state_get_iclog_space+0xfc/0x2c0
[588653.598481]  ? wake_up_q+0x70/0x70
[588653.598484]  schedule+0x78/0x110
[588653.598487]  xlog_state_get_iclog_space+0xfc/0x2c0
[588653.598490]  ? wake_up_q+0x70/0x70
[588653.598494]  xlog_write+0x153/0x680
[588653.598498]  xlog_cil_push+0x259/0x3e0
[588653.598503]  process_one_work+0x199/0x3b0
[588653.598506]  worker_thread+0x1c6/0x380
[588653.598509]  ? rescuer_thread+0x310/0x310
[588653.598512]  kthread+0x110/0x130
[588653.598515]  ? kthread_create_worker_on_cpu+0x40/0x40
[588653.598518]  ret_from_fork+0x24/0x30
[588653.598542] kworker/8:0     D    0 21308      2 0x80000000
[588653.598547] Workqueue: xfs-sync/sdd1 xfs_log_worker
[588653.598549] Call Trace:
[588653.598553]  ? __schedule+0x240/0x860
[588653.598556]  ? schedule_timeout+0x274/0x390
[588653.598559]  schedule+0x78/0x110
[588653.598561]  schedule_timeout+0x274/0x390
[588653.598565]  wait_for_completion+0xe2/0x140
[588653.598567]  ? wake_up_q+0x70/0x70
[588653.598570]  __flush_work+0xfb/0x1a0
[588653.598574]  ? flush_workqueue_prep_pwqs+0x130/0x130
[588653.598577]  xlog_cil_force_lsn+0x67/0x1d0
[588653.598581]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[588653.598584]  xfs_log_force+0x83/0x2d0
[588653.598587]  ? preempt_count_sub+0x43/0x50
[588653.598590]  xfs_log_worker+0x2f/0xf0
[588653.598593]  process_one_work+0x199/0x3b0
[588653.598595]  worker_thread+0x30/0x380
[588653.598598]  ? rescuer_thread+0x310/0x310
[588653.598601]  kthread+0x110/0x130
[588653.598604]  ? kthread_create_worker_on_cpu+0x40/0x40
[588653.598607]  ret_from_fork+0x24/0x30

-----

"iostat -x -d -m 5 " while running the test:

-----

Linux 4.19.16 (debian)  24.01.2019      _x86_64_        (12 CPU)

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb             49.94    0.13      8.22      0.09     0.01     0.01   0.02  
6.16    1.09  195.85   0.08   168.59   689.71   0.73   3.63
sda              2.09    0.35      0.03      0.02     0.01     0.02   0.24  
6.36    0.25    6.46   0.00    15.34    51.02   0.23   0.06
sdc              4.14    1.01      0.37      0.09     0.02     3.05   0.58 
75.03    0.33   13.48   0.01    90.82    90.05   0.25   0.13
dm-0             0.97    3.56      0.02      0.02     0.00     0.00   0.00  
0.00    0.29    7.14   0.03    19.75     4.56   0.08   0.03
loop0            0.01    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    9.87    1.08   0.00    11.52     8.80   1.50   0.00
loop1            0.06    0.00      0.01      0.00     0.00     0.00   0.00  
0.00    2.66    3.65   0.00    85.79    88.40   0.88   0.01
sdd              0.04    0.48      0.00      0.34     0.00     0.00   2.38  
0.48   13.82  625.41   0.30    10.27   712.62   4.63   0.24

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sda              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdc              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
dm-0             0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd              2.80  114.60      0.01     57.53     0.00     0.00   0.00  
0.00   31.57  315.09  44.88     4.00   514.07   2.82  33.12

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sda              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdc              0.00    0.20      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    2.00   0.00     0.00     4.00   0.00   0.00
dm-0             0.00    0.20      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     4.00   0.00   0.00
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd              0.00  309.20      0.00    158.60     0.00     0.00   0.00  
0.00    0.00  379.40 143.99     0.00   525.25   3.24 100.08

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sda              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdc              0.00    0.60      0.00      0.00     0.00     0.20   0.00 
25.00    0.00    3.00   0.00     0.00     4.00   2.67   0.16
dm-0             0.00    0.80      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    2.00   0.00     0.00     4.00   2.00   0.16
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd              0.80  162.20      0.00    159.67     0.00     0.00   0.00  
0.00 1161.50  933.72 130.70     4.00  1008.02   6.13 100.00

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sda              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdc              0.00    0.40      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    2.00   0.00     0.00     4.00   0.00   0.00
dm-0             0.00    0.40      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     4.00   0.00   0.00
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd              0.00  154.00      0.00    153.80     0.00     0.00   0.00  
0.00    0.00  885.47 143.06     0.00  1022.67   6.49 100.00

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sda              0.40    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    1.50    0.00   0.00     4.00     0.00   0.00   0.00
sdc              0.00    1.00      0.00      0.00     0.00     0.20   0.00 
16.67    0.00    1.60   0.00     0.00     4.00   0.80   0.08
dm-0             0.00    1.20      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.67   0.00     0.00     4.00   0.67   0.08
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd             10.60  174.40      0.17    138.13     0.00     7.40   0.00  
4.07    6.43  861.84 130.00    16.00   811.06   5.39  99.76

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
%wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    0.40      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    6.00   0.00     0.00     4.00   6.00   0.24
sda              5.80    0.60      0.05      0.00     0.00     0.00   0.00  
0.00    0.55    2.33   0.00     8.55     7.00   0.62   0.40
sdc              0.00    0.40      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    1.50   0.00     0.00     2.00   0.00   0.00
dm-0             0.00    0.40      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     4.00   0.00   0.00
loop0            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
loop1            0.00    0.00      0.00      0.00     0.00     0.00   0.00  
0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
sdd             15.60   29.20      0.23      7.46     0.00    36.20   0.00 
55.35    8.55   47.97   1.53    15.08   261.59   3.91  17.52

-----

"vmstat 5" while running the test:

-----

procs -----------memory---------- ---swap-- -----io---- -system--
------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
st
 1  0      0 4379320  64296 6133624    0    0   738   760    4    0  1  0 97  1
 0
 0  1      0 3123424  64296 7369344    0    0    11 58163 4661 8568  1  5 92  2
 0
 1  1      0 2301400  64296 8193912    0    0     1 176743 5350 10644  2  4 86 
8  0
 1  1      0 934552  64304 9550800    0    0     2 170806 5922 12653  2  5 85 
8  0
 0  3      0 132944  64304 10366496    0    0     0 163897 5791 9442  1  4 82
13  0
 2  1      0 135192  64312 10366564    0    0     2 114094 2093 2144  0  0 91 
8  0
 0  0      0 185980  64316 10327628    0    0   454  7708 2964 8098  1  1 97  1
 0

-----

Information requested by the FAQ:

- kernel version (uname -a) 

Linux debian 4.19.16 #1.0.my.2 SMP PREEMPT Thu Jan 17 15:18:14 CET 2019 x86_64
GNU/Linux

(That's just a vanilla kernel. It does _not_ use Debian's default kernel
config.)

- xfsprogs version (xfs_repair -V) 

xfs_repair version 4.15.1

- number of CPUs 

6 cores, total of 12 CPUs (AMD Ryzen 5 2600).

- contents of /proc/meminfo 

MemTotal:       16419320 kB
MemFree:          442860 kB
MemAvailable:    8501360 kB
Buffers:           66816 kB
Cached:          9966896 kB
SwapCached:            0 kB
Active:         10300036 kB
Inactive:        4981936 kB
Active(anon):    6199144 kB
Inactive(anon):   930620 kB
Active(file):    4100892 kB
Inactive(file):  4051316 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               112 kB
Writeback:             0 kB
AnonPages:       5248396 kB
Mapped:          1110368 kB
Shmem:           1881512 kB
Slab:             426008 kB
SReclaimable:     242452 kB
SUnreclaim:       183556 kB
KernelStack:       16064 kB
PageTables:        44408 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     8209660 kB
Committed_AS:   15149512 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
Percpu:             9664 kB
HardwareCorrupted:     0 kB
AnonHugePages:   2619392 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:     6745216 kB
DirectMap2M:     9963520 kB
DirectMap1G:     1048576 kB

- contents of /proc/mounts 

Target disk only:

/dev/sdd1 /mnt/tmp1 xfs rw,relatime,attr2,inode64,noquota 0 0

- contents of /proc/partitions 

Target disk only:

   8       48 5860522584 sdd
   8       49 5860521543 sdd1

- RAID layout (hardware and/or software) 

None.

- LVM configuration

None.

- type of disks you are using

Spinning rust, potentially interesting parts from smartctl:

Model Family:     HGST Ultrastar He8
Device Model:     HGST HUH728060ALE600
Firmware Version: A4GNT7J0

- write cache status of drives

hdparm -I /dev/sdd|grep Write.cache

           *    Write cache

- size of BBWC and mode it is running in

No idea how to get this.

- xfs_info output on the filesystem in question 

xfs_info /mnt/tmp1

meta-data=/dev/sdd1              isize=512    agcount=6, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=1465130385, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
