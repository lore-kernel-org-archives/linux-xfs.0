Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54716 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726470AbfFZSGQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 14:06:16 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EA060289C4
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 18:06:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203999] New: [xfstests xfs/442] kernel BUG at
 mm/swap_state.c:170! RIP: 0010:__delete_from_swap_cache+0x45a/0x6c0
Date: Wed, 26 Jun 2019 18:06:12 +0000
Message-ID: <bug-203999-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203999

            Bug ID: 203999
           Summary: [xfstests xfs/442] kernel BUG at mm/swap_state.c:170!
                    RIP: 0010:__delete_from_swap_cache+0x45a/0x6c0
           Product: File System
           Version: 2.5
    Kernel Version: 5.2.0-rc4 xfs-5.3-merge-2
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

xfstests xfs/442 hit a kernel panic[1]. I test with -b size=4k -m
reflink=1,rmapbt=1, on kernel xfs-linux xfs-5.3-merge-2. The XFS info is:
meta-data=/dev/sda2              isize=512    agcount=4, agsize=983040 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3693, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0



[1]
[17709.175853] run fstests xfs/442 at 2019-06-26 11:17:05 
[17709.860178] XFS (sda3): Mounting V5 Filesystem 
[17709.884929] XFS (sda3): Ending clean mount 
[17709.917986] XFS (sda3): Unmounting Filesystem 
[17710.250832] XFS (sda3): Mounting V5 Filesystem 
[17710.277188] XFS (sda3): Ending clean mount 
[17710.283564] XFS (sda3): Quotacheck needed: Please wait. 
[17710.295348] XFS (sda3): Quotacheck: Done. 
[17723.018312] restraintd[1307]: *** Current Time: Wed Jun 26 11:17:19 2019
Localwatchdog at: Fri Jun 28 06:24:18 2019 
[17783.077111] restraintd[1307]: *** Current Time: Wed Jun 26 11:18:19 2019
Localwatchdog at: Fri Jun 28 06:24:18 2019 
[17838.551564] page:ffffea00020a8000 refcount:3 mapcount:0
mapping:ffff88810f1eb7b9 index:0x5644f2e00 
[17838.561860] anon  
[17838.561865] flags:
0xfffffc008044c(uptodate|dirty|workingset|owner_priv_1|swapbacked) 
[17838.574378] raw: 000fffffc008044c ffff888030b27600 ffff888030b27600
ffff88810f1eb7b9 
[17838.583586] raw: 00000005644f2e00 00000000000dea00 00000002ffffffff
ffff888107314200 
[17838.592820] page dumped because: VM_BUG_ON_PAGE(entry != page) 
[17838.600145] page->mem_cgroup:ffff888107314200 
[17838.606001] ------------[ cut here ]------------ 
[17838.612124] kernel BUG at mm/swap_state.c:170! 
[17838.618090] invalid opcode: 0000 [#1] SMP KASAN PTI 
[17838.624493] CPU: 4 PID: 183 Comm: kswapd0 Tainted: G    B   W        
5.2.0-rc4 #1 
[17838.633631] Hardware name: Intel Corporation 2012 Client Platform/Emerald
Lake 2, BIOS ACRVMBY1.86C.0078.P00.1201161002 01/16/2012 
[17838.648697] RIP: 0010:__delete_from_swap_cache+0x45a/0x6c0 
[17838.655912] Code: e8 a9 c2 b6 ff e9 d9 fe ff ff 48 c7 c6 40 65 73 8a 48 89
ef e8 d7 73 f7 ff 0f 0b 48 c7 c6 00 66 73 8a 48 89 c7 e8 c6 73 f7 ff <0f> 0b 48
b8 00 00 00 00 00 fc ff df 49 8d 
7d 08 48 89 fa 48 c1 ea 
[17838.678389] RSP: 0018:ffff888030b27228 EFLAGS: 00010082 
[17838.685517] RAX: 0000000000000021 RBX: 0000000000000000 RCX:
ffffffff88983f80 
[17838.694592] RDX: 0000000000000000 RSI: 0000000000000008 RDI:
ffff88810cfdffb0 
[17838.703650] RBP: ffffea00020a8040 R08: ffffed10219fbff7 R09:
ffffed10219fbff6 
[17838.712741] R10: ffffed10219fbff6 R11: ffff88810cfdffb7 R12:
dffffc0000000000 
[17838.721859] R13: ffffea00020a8000 R14: ffff888030b272b0 R15:
0000000000000001 
[17838.730982] FS:  0000000000000000(0000) GS:ffff88810ce00000(0000)
knlGS:0000000000000000 
[17838.741066] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[17838.748790] CR2: 00007f5826bb0000 CR3: 000000002fa7a006 CR4:
00000000001606e0 
[17838.757943] Call Trace: 
[17838.762405]  ? add_to_swap_cache+0x9f0/0x9f0 
[17838.768727]  ? do_raw_spin_trylock+0xb2/0x180 
[17838.775144]  delete_from_swap_cache+0x8c/0x170 
[17838.781647]  try_to_free_swap+0x239/0x370 
[17838.787721]  swap_writepage+0x12/0x70 
[17838.793453]  pageout.isra.47+0x36b/0xa30 
[17838.799446]  ? wake_up_page_bit+0x15e/0x1c0 
[17838.805708]  ? __remove_mapping+0x750/0x750 
[17838.811966]  ? memset+0x1f/0x40 
[17838.817175]  ? page_mapped+0xed/0x270 
[17838.822910]  shrink_page_list+0x169e/0x24d0 
[17838.829195]  ? page_evictable+0x1b0/0x1b0 
[17838.835295]  ? __isolate_lru_page+0x440/0x440 
[17838.841761]  ? lock_downgrade+0x620/0x620 
[17838.847868]  shrink_inactive_list+0x36c/0xbd0 
[17838.854339]  ? move_pages_to_lru+0xee0/0xee0 
[17838.860699]  ? lock_downgrade+0x620/0x620 
[17838.866875]  ? xfs_perag_get_tag+0x5/0x500 [xfs] 
[17838.873601]  ? lruvec_lru_size+0x163/0x270 
[17838.879804]  ? lruvec_lru_size+0x163/0x270 
[17838.885981]  shrink_node_memcg+0x4b2/0x1140 
[17838.892252]  ? shrink_active_list+0xe10/0xe10 
[17838.898658]  ? lock_downgrade+0x620/0x620 
[17838.904669]  ? mem_cgroup_iter+0x418/0xa20 
[17838.910739]  shrink_node+0x248/0x11d0 
[17838.916357]  ? shrink_node_memcg+0x1140/0x1140 
[17838.922722]  ? __count_memcg_events+0x10/0x10 
[17838.928975]  ? inactive_list_is_low+0x241/0x5c0 
[17838.935378]  balance_pgdat+0x4ef/0xa20 
[17838.941003]  ? mem_cgroup_shrink_node+0x5f0/0x5f0 
[17838.947589]  ? finish_task_switch+0x199/0x690 
[17838.953821]  ? __switch_to_asm+0x34/0x70 
[17838.959606]  ? __switch_to_asm+0x40/0x70 
[17838.965285]  ? set_pgdat_percpu_threshold+0x1bb/0x280 
[17838.972056]  ? vm_events_fold_cpu+0xa0/0xa0 
[17838.977935]  kswapd+0x585/0xc50 
[17838.982705]  ? balance_pgdat+0xa20/0xa20 
[17838.988186]  ? lock_downgrade+0x620/0x620 
[17838.993723]  ? firmware_map_remove+0x16d/0x16d 
[17838.999662]  ? _raw_spin_unlock_irqrestore+0x43/0x50 
[17839.006124]  ? finish_wait+0x280/0x280 
[17839.011351]  ? __kthread_parkme+0xb6/0x180 
[17839.016933]  ? balance_pgdat+0xa20/0xa20 
[17839.022312]  kthread+0x326/0x3f0 
[17839.026964]  ? kthread_create_on_node+0xc0/0xc0 
[17839.032911]  ret_from_fork+0x3a/0x50 
[17839.037883] Modules linked in: dm_delay dm_zero dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey dm_mod
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt
iTCO_vendor_support kvm mei_wdt sunrpc irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate dax_pmem_compat intel_uncore device_dax mei_me
sg dax_pmem_core pcspkr intel_rapl_perf nd_pmem mei i2c_i801 lpc_ich ext4
mbcache jbd2 xfs libcrc32c sr_mod cdrom sd_mod i915 intel_gtt i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci
crc32c_intel serio_raw libata e1000e video [last unloaded: scsi_debug] 
[17839.107642] ---[ end trace 01faf255ccde756c ]---
[17839.114049] RIP: 0010:__delete_from_swap_cache+0x45a/0x6c0 
[17839.121351] Code: e8 a9 c2 b6 ff e9 d9 fe ff ff 48 c7 c6 40 65 73 8a 48 89
ef e8 d7 73 f7 ff 0f 0b 48 c7 c6 00 66 73 8a 48 89 c7 e8 c6 73 f7 ff <0f> 0b 48
b8 00 00 00 00 00 fc ff df 49 8d 7d 08 48 89 fa 48 c1 ea 
[17839.143978] RSP: 0018:ffff888030b27228 EFLAGS: 00010082 
[17839.151181] RAX: 0000000000000021 RBX: 0000000000000000 RCX:
ffffffff88983f80 
[17839.160338] RDX: 0000000000000000 RSI: 0000000000000008 RDI:
ffff88810cfdffb0 
[17839.169495] RBP: ffffea00020a8040 R08: ffffed10219fbff7 R09:
ffffed10219fbff6 
[17839.178675] R10: ffffed10219fbff6 R11: ffff88810cfdffb7 R12:
dffffc0000000000 
[17839.187857] R13: ffffea00020a8000 R14: ffff888030b272b0 R15:
0000000000000001 
[17839.197039] FS:  0000000000000000(0000) GS:ffff88810ce00000(0000)
knlGS:0000000000000000 
[17839.207208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[17839.215052] CR2: 00007f5826bb0000 CR3: 000000002fa7a006 CR4:
00000000001606e0 
[17839.224317] BUG: sleeping function called from invalid context at
include/linux/percpu-rwsem.h:34 
[17839.235371] in_atomic(): 1, irqs_disabled(): 1, pid: 183, name: kswapd0 
[17839.244204] INFO: lockdep is turned off. 
[17839.250351] irq event stamp: 40 
[17839.255720] hardirqs last  enabled at (39): [<ffffffff8a0c9a73>]
_raw_spin_unlock_irqrestore+0x43/0x50 
[17839.267328] hardirqs last disabled at (40): [<ffffffff8a0b67c3>]
__schedule+0x183/0x14f0 
[17839.277749] softirqs last  enabled at (0): [<ffffffff885b04f7>]
copy_process.part.33+0x1917/0x5e40 
[17839.289055] softirqs last disabled at (0): [<0000000000000000>] 0x0 
[17839.297689] CPU: 4 PID: 183 Comm: kswapd0 Tainted: G    B D W        
5.2.0-rc4 #1 
[17839.307656] Hardware name: Intel Corporation 2012 Client Platform/Emerald
Lake 2, BIOS ACRVMBY1.86C.0078.P00.1201161002 01/16/2012 
[17839.324336] Call Trace: 
[17839.329247]  dump_stack+0x7c/0xc0 
[17839.335020]  ___might_sleep.cold.75+0x10e/0x128 
[17839.342020]  exit_signals+0x75/0x630 
[17839.348080]  ? get_signal+0x2070/0x2070 
[17839.354394]  ? vm_events_fold_cpu+0xa0/0xa0 
[17839.361047]  ? __validate_process_creds+0x22e/0x350 
[17839.368403]  do_exit+0x204/0x29f0 
[17839.374203]  ? balance_pgdat+0xa20/0xa20 
[17839.380624]  ? mm_update_next_owner+0x5e0/0x5e0 
[17839.387664]  ? firmware_map_remove+0x16d/0x16d 
[17839.394612]  ? _raw_spin_unlock_irqrestore+0x43/0x50 
[17839.402053]  ? finish_wait+0x280/0x280 
[17839.408291]  ? __kthread_parkme+0xb6/0x180 
[17839.414901]  ? balance_pgdat+0xa20/0xa20 
[17839.421311]  ? kthread+0x326/0x3f0 
[17839.427186]  rewind_stack_do_exit+0x17/0x20 
[17839.433930] note: kswapd0[183] exited with preempt_count 1 
[17857.810741] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1 
[17857.810742] Modules linked in: dm_delay dm_zero dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey dm_mod
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt
iTCO_vendor_support kvm mei_wdt sunrpc irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate dax_pmem_compat intel_uncore device_dax mei_me
sg dax_pmem_core pcspkr intel_rapl_perf nd_pmem mei i2c_i801 lpc_ich ext4
mbcache jbd2 xfs libcrc32c sr_mod cdrom sd_mod i915 intel_gtt i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci
crc32c_intel serio_raw libata e1000e video [last unloaded: scsi_debug] 
[17857.810763] irq event stamp: 0 
[17857.810763] hardirqs last  enabled at (0): [<0000000000000000>] 0x0 
[17857.810764] hardirqs last disabled at (0): [<ffffffff885b045b>]
copy_process.part.33+0x187b/0x5e40 
[17857.810765] softirqs last  enabled at (0): [<ffffffff885b04f7>]
copy_process.part.33+0x1917/0x5e40 
[17857.810765] softirqs last disabled at (0): [<0000000000000000>] 0x0 
[17857.810766] CPU: 1 PID: 2071 Comm: fsstress Tainted: G    B D W        
5.2.0-rc4 #1 
[17857.810767] Hardware name: Intel Corporation 2012 Client Platform/Emerald
Lake 2, BIOS ACRVMBY1.86C.0078.P00.1201161002 01/16/2012 
[17857.810767] RIP: 0010:native_queued_spin_lock_slowpath+0x1db/0x950
...
...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
