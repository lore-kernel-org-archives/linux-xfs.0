Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32403 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755416AbdDMUAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 16:00:16 -0400
Date: Thu, 13 Apr 2017 13:00:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: inconsistent lock state in kernel 4.11 rc6
Message-ID: <20170413200009.GZ8502@birch.djwong.org>
References: <CABXGCsOUaRMg8ztgeqgN_BbQvPtaSxmyKJZ6hqMnKhO1VA4vmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsOUaRMg8ztgeqgN_BbQvPtaSxmyKJZ6hqMnKhO1VA4vmg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2017 at 12:37:00AM +0500, Михаил Гаврилов wrote:
> Hi guys. I see message about inconsistent lock state in latest kernels.

Does the patch[1] "xfs: drop iolock from reclaim context to appease lockdep"
fix this for you?

[1] https://www.spinics.net/lists/linux-xfs/msg05780.html

--D

> 
> [  823.490923] =================================
> [  823.490925] [ INFO: inconsistent lock state ]
> [  823.490929] 4.11.0-0.rc6.git0.1.fc26.x86_64+debug #1 Not tainted
> [  823.490931] ---------------------------------
> [  823.490933] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> [  823.490935] kswapd0/97 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [  823.490937]  (&sb->s_type->i_mutex_key#22){++++?+}, at:
> [<ffffffffc0c1c09b>] xfs_ilock+0x13b/0x220 [xfs]
> [  823.491078] {RECLAIM_FS-ON-W} state was registered at:
> [  823.491089]   mark_held_locks+0x5f/0x90
> [  823.491093]   lockdep_trace_alloc+0x7d/0xe0
> [  823.491097]   kmem_cache_alloc+0x33/0x2e0
> [  823.491235]   kmem_zone_alloc+0x66/0x100 [xfs]
> [  823.491347]   xfs_trans_alloc+0x6b/0x130 [xfs]
> [  823.491471]   xfs_link+0x1a4/0x3a0 [xfs]
> [  823.491558]   xfs_vn_link+0x6a/0xb0 [xfs]
> [  823.491567]   vfs_link+0x238/0x320
> [  823.491569]   SyS_link+0x1bf/0x200
> [  823.491576]   entry_SYSCALL_64_fastpath+0x1f/0xc2
> [  823.491577] irq event stamp: 889625
> [  823.491584] hardirqs last  enabled at (889625):
> [<ffffffffa213baa1>] __call_rcu+0x1f1/0x3d0
> [  823.491586] hardirqs last disabled at (889624):
> [<ffffffffa213b952>] __call_rcu+0xa2/0x3d0
> [  823.491589] softirqs last  enabled at (887736):
> [<ffffffffa2986b12>] __do_softirq+0x382/0x511
> [  823.491595] softirqs last disabled at (887729):
> [<ffffffffa20ba6af>] irq_exit+0x10f/0x120
> [  823.491597]
>                other info that might help us debug this:
> [  823.491598]  Possible unsafe locking scenario:
> 
> [  823.491599]        CPU0
> [  823.491600]        ----
> [  823.491601]   lock(&sb->s_type->i_mutex_key#22);
> [  823.491604]   <Interrupt>
> [  823.491605]     lock(&sb->s_type->i_mutex_key#22);
> [  823.491607]
>                 *** DEADLOCK ***
> 
> [  823.491610] 2 locks held by kswapd0/97:
> [  823.491611]  #0:  (shrinker_rwsem){++++..}, at:
> [<ffffffffa2231d5b>] shrink_slab.part.43+0x5b/0x580
> [  823.491618]  #1:  (&type->s_umount_key#62){++++.+}, at:
> [<ffffffffa22ced9b>] trylock_super+0x1b/0x50
> [  823.491624]
>                stack backtrace:
> [  823.491628] CPU: 3 PID: 97 Comm: kswapd0 Not tainted
> 4.11.0-0.rc6.git0.1.fc26.x86_64+debug #1
> [  823.491629] Hardware name: Gigabyte Technology Co., Ltd.
> Z87M-D3H/Z87M-D3H, BIOS F11 08/12/2014
> [  823.491632] Call Trace:
> [  823.491645]  dump_stack+0x8e/0xd1
> [  823.491653]  print_usage_bug+0x1d0/0x1e0
> [  823.491656]  mark_lock+0x504/0x5a0
> [  823.491661]  ? sched_clock+0x9/0x10
> [  823.491664]  ? print_shortest_lock_dependencies+0x190/0x190
> [  823.491667]  __lock_acquire+0x2f7/0x13d0
> [  823.491670]  ? trace_hardirqs_on_caller+0xf4/0x1b0
> [  823.491672]  ? trace_hardirqs_on+0xd/0x10
> [  823.491675]  lock_acquire+0xa3/0x1f0
> [  823.491677]  ? lock_acquire+0xa3/0x1f0
> [  823.491770]  ? xfs_ilock+0x13b/0x220 [xfs]
> [  823.491830]  ? xfs_inactive+0xf5/0x130 [xfs]
> [  823.491836]  down_write_nested+0x55/0xc0
> [  823.491881]  ? xfs_ilock+0x13b/0x220 [xfs]
> [  823.491931]  xfs_ilock+0x13b/0x220 [xfs]
> [  823.491969]  xfs_inactive+0xf5/0x130 [xfs]
> [  823.492005]  xfs_fs_destroy_inode+0xbb/0x2d0 [xfs]
> [  823.492010]  destroy_inode+0x3b/0x60
> [  823.492012]  evict+0x13e/0x1a0
> [  823.492015]  dispose_list+0x56/0x80
> [  823.492017]  prune_icache_sb+0x5a/0x80
> [  823.492019]  super_cache_scan+0x137/0x1b0
> [  823.492023]  shrink_slab.part.43+0x1f4/0x580
> [  823.492027]  shrink_slab+0x1b/0x30
> [  823.492029]  shrink_node+0x102/0x300
> [  823.492032]  kswapd+0x334/0x950
> [  823.492036]  ? mem_cgroup_shrink_node+0x330/0x330
> [  823.492039]  kthread+0x12c/0x150
> [  823.492041]  ? kthread_create_on_node+0x70/0x70
> [  823.492045]  ret_from_fork+0x31/0x40
> 
> Anybody can comment on what is culprit here?
> See a lot of functions with xfs prefix therefore I wrote in this mail list.
> 
> 
> 
> --
> Best Regards,
> Mike Gavrilov.

> [    0.000000] microcode: microcode updated early to revision 0x20, date = 2016-03-16
> [    0.000000] Linux version 4.11.0-0.rc6.git0.1.fc26.x86_64+debug (mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 7.0.1 20170309 (Red Hat 7.0.1-0.12) (GCC) ) #1 SMP Mon Apr 10 19:31:42 UTC 2017
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.11.0-0.rc6.git0.1.fc26.x86_64+debug root=UUID=c5983c72-8bda-479f-a0df-b633da8bb9d7 ro rhgb quiet scsi_mod.use_blk_mq=1 LANG=en_US.UTF-8
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009efff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008973cfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000008973d000-0x0000000089743fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x0000000089744000-0x000000008a219fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000008a21a000-0x000000008a772fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000008a773000-0x000000009ce30fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000009ce31000-0x000000009cec8fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000009cec9000-0x000000009cf0ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000009cf10000-0x000000009cfcbfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000009cfcc000-0x000000009effefff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000009efff000-0x000000009effffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000009f800000-0x00000000df9fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000081f5fffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] e820: update [mem 0x8941e018-0x8942e057] usable ==> usable
> [    0.000000] e820: update [mem 0x8940d018-0x8941d857] usable ==> usable
> [    0.000000] extended physical RAM map:
> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
> [    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009efff] usable
> [    0.000000] reserve setup_data: [mem 0x000000000009f000-0x000000000009ffff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000008940d017] usable
> [    0.000000] reserve setup_data: [mem 0x000000008940d018-0x000000008941d857] usable
> [    0.000000] reserve setup_data: [mem 0x000000008941d858-0x000000008941e017] usable
> [    0.000000] reserve setup_data: [mem 0x000000008941e018-0x000000008942e057] usable
> [    0.000000] reserve setup_data: [mem 0x000000008942e058-0x000000008973cfff] usable
> [    0.000000] reserve setup_data: [mem 0x000000008973d000-0x0000000089743fff] ACPI NVS
> [    0.000000] reserve setup_data: [mem 0x0000000089744000-0x000000008a219fff] usable
> [    0.000000] reserve setup_data: [mem 0x000000008a21a000-0x000000008a772fff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000008a773000-0x000000009ce30fff] usable
> [    0.000000] reserve setup_data: [mem 0x000000009ce31000-0x000000009cec8fff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000009cec9000-0x000000009cf0ffff] usable
> [    0.000000] reserve setup_data: [mem 0x000000009cf10000-0x000000009cfcbfff] ACPI NVS
> [    0.000000] reserve setup_data: [mem 0x000000009cfcc000-0x000000009effefff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000009efff000-0x000000009effffff] usable
> [    0.000000] reserve setup_data: [mem 0x000000009f800000-0x00000000df9fffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000081f5fffff] usable
> [    0.000000] efi: EFI v2.31 by American Megatrends
> [    0.000000] efi:  ACPI=0x9cf98000  ACPI 2.0=0x9cf98000  SMBIOS=0xf04c0  MPS=0xfd440 
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: Gigabyte Technology Co., Ltd. Z87M-D3H/Z87M-D3H, BIOS F11 08/12/2014
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x81f600 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DFFFF uncachable
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask 7800000000 write-back
> [    0.000000]   1 base 0800000000 mask 7FE0000000 write-back
> [    0.000000]   2 base 00C0000000 mask 7FC0000000 uncachable
> [    0.000000]   3 base 00A0000000 mask 7FE0000000 uncachable
> [    0.000000]   4 base 009F800000 mask 7FFF800000 uncachable
> [    0.000000]   5 base 081F800000 mask 7FFF800000 uncachable
> [    0.000000]   6 base 081F600000 mask 7FFFE00000 uncachable
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
> [    0.000000] e820: update [mem 0x9f800000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0x9f000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fd700-0x000fd70f] mapped at [ffff98dcc00fd700]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff98dcc0097000] 97000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] BRK [0x49a551000, 0x49a551fff] PGTABLE
> [    0.000000] BRK [0x49a552000, 0x49a552fff] PGTABLE
> [    0.000000] BRK [0x49a553000, 0x49a553fff] PGTABLE
> [    0.000000] BRK [0x49a554000, 0x49a554fff] PGTABLE
> [    0.000000] BRK [0x49a555000, 0x49a555fff] PGTABLE
> [    0.000000] BRK [0x49a556000, 0x49a556fff] PGTABLE
> [    0.000000] BRK [0x49a557000, 0x49a557fff] PGTABLE
> [    0.000000] BRK [0x49a558000, 0x49a558fff] PGTABLE
> [    0.000000] BRK [0x49a559000, 0x49a559fff] PGTABLE
> [    0.000000] BRK [0x49a55a000, 0x49a55afff] PGTABLE
> [    0.000000] BRK [0x49a55b000, 0x49a55bfff] PGTABLE
> [    0.000000] Secure boot could not be determined
> [    0.000000] RAMDISK: [mem 0x3ed18000-0x3fffafff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000000009CF98000 000024 (v02 ALASKA)
> [    0.000000] ACPI: XSDT 0x000000009CF98080 00007C (v01 ALASKA A M I    01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 0x000000009CFA4E20 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 0x000000009CF98190 00CC8D (v02 ALASKA A M I    00000088 INTL 20091112)
> [    0.000000] ACPI: FACS 0x000000009CFCA080 000040
> [    0.000000] ACPI: APIC 0x000000009CFA4F30 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
> [    0.000000] ACPI: FPDT 0x000000009CFA4FC8 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
> [    0.000000] ACPI: SSDT 0x000000009CFA5010 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x000000009CFA5550 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
> [    0.000000] ACPI: MCFG 0x000000009CFA6028 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
> [    0.000000] ACPI: HPET 0x000000009CFA6068 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
> [    0.000000] ACPI: SSDT 0x000000009CFA60A0 00036D (v01 SataRe SataTabl 00001000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x000000009CFA6410 0034E1 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
> [    0.000000] ACPI: BGRT 0x000000009CFA98F8 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
> [    0.000000] ACPI: DMAR 0x000000009CFA9930 0000A8 (v01 INTEL  HSW      00000001 INTL 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000081f5fffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x81f5d5000-0x81f5fffff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000081f5fffff]
> [    0.000000]   Device   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
> [    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009efff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x000000008973cfff]
> [    0.000000]   node   0: [mem 0x0000000089744000-0x000000008a219fff]
> [    0.000000]   node   0: [mem 0x000000008a773000-0x000000009ce30fff]
> [    0.000000]   node   0: [mem 0x000000009cec9000-0x000000009cf0ffff]
> [    0.000000]   node   0: [mem 0x000000009efff000-0x000000009effffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000081f5fffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000081f5fffff]
> [    0.000000] On node 0 totalpages: 8109750
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 24 pages reserved
> [    0.000000]   DMA zone: 3997 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 9957 pages used for memmap
> [    0.000000]   DMA32 zone: 637209 pages, LIFO batch:31
> [    0.000000]   Normal zone: 116696 pages used for memmap
> [    0.000000]   Normal zone: 7468544 pages, LIFO batch:31
> [    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
> [    0.000000] Reserving Intel graphics memory at 0x000000009fa00000-0x00000000c19fffff
> [    0.000000] ACPI: PM-Timer IO Port: 0x1808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8940d000-0x8940dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8941d000-0x8941dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8941e000-0x8941efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8942e000-0x8942efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8973d000-0x89743fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8a21a000-0x8a772fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x9ce31000-0x9cec8fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x9cf10000-0x9cfcbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x9cfcc000-0x9effefff]
> [    0.000000] PM: Registered nosave memory: [mem 0x9f000000-0x9f7fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x9f800000-0xdf9fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] percpu: Embedded 485 pages/cpu @ffff98e4bec00000 s1948504 r8192 d29864 u2097152
> [    0.000000] pcpu-alloc: s1948504 r8192 d29864 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 7983009
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.11.0-0.rc6.git0.1.fc26.x86_64+debug root=UUID=c5983c72-8bda-479f-a0df-b633da8bb9d7 ro rhgb quiet scsi_mod.use_blk_mq=1 LANG=en_US.UTF-8
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Memory: 31556968K/32439000K available (9764K kernel code, 2014K rwdata, 3820K rodata, 4656K init, 17160K bss, 882032K reserved, 0K cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Running RCU self tests
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU lockdep checking is enabled.
> [    0.000000] 	Build-time adjustment of leaf fanout to 64.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
> [    0.000000] NR_IRQS:524544 nr_irqs:488 16
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 8671 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] kmemleak: Kernel memory leak detector disabled
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] spurious 8259A interrupt: IRQ7.
> [    0.001000] tsc: Detected 3392.373 MHz processor
> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6784.74 BogoMIPS (lpj=3392373)
> [    0.001000] pid_max: default: 32768 minimum: 301
> [    0.001000] ACPI: Core revision 20170119
> [    0.019457] ACPI: 5 ACPI AML tables successfully acquired and loaded
> [    0.019691] ---[ User Space ]---
> [    0.019693] 0x0000000000000000-0x0000000000008000          32K     RW                 GLB x  pte
> [    0.019706] 0x0000000000008000-0x000000000005f000         348K                               pte
> [    0.019711] 0x000000000005f000-0x000000000009f000         256K     RW                 GLB x  pte
> [    0.019725] 0x000000000009f000-0x0000000000200000        1412K                               pte
> [    0.019732] 0x0000000000200000-0x0000000040000000        1022M                               pmd
> [    0.019737] 0x0000000040000000-0x0000000080000000           1G                               pud
> [    0.019741] 0x0000000080000000-0x0000000089600000         150M                               pmd
> [    0.019747] 0x0000000089600000-0x0000000089744000        1296K                               pte
> [    0.019755] 0x0000000089744000-0x0000000089a00000        2800K     RW                 GLB x  pte
> [    0.019766] 0x0000000089a00000-0x000000008a000000           6M     RW         PSE         x  pmd
> [    0.019782] 0x000000008a000000-0x000000008a400000           4M     RW                 GLB x  pte
> [    0.019794] 0x000000008a400000-0x000000008a600000           2M     RW         PSE         x  pmd
> [    0.019923] 0x000000008a600000-0x000000008a7ae000        1720K     RW                 GLB x  pte
> [    0.019935] 0x000000008a7ae000-0x000000008a800000         328K                               pte
> [    0.019939] 0x000000008a800000-0x000000008de00000          54M                               pmd
> [    0.019945] 0x000000008de00000-0x000000008df7f000        1532K                               pte
> [    0.019950] 0x000000008df7f000-0x000000008dfc1000         264K     RW                 GLB x  pte
> [    0.019962] 0x000000008dfc1000-0x000000008dfd1000          64K                               pte
> [    0.019967] 0x000000008dfd1000-0x000000008e006000         212K     RW                 GLB x  pte
> [    0.019979] 0x000000008e006000-0x000000008e013000          52K                               pte
> [    0.019984] 0x000000008e013000-0x000000008e06f000         368K     RW                 GLB x  pte
> [    0.020013] 0x000000008e06f000-0x000000008e088000         100K                               pte
> [    0.020018] 0x000000008e088000-0x000000008e0e2000         360K     RW                 GLB x  pte
> [    0.020030] 0x000000008e0e2000-0x000000008e0f8000          88K                               pte
> [    0.020035] 0x000000008e0f8000-0x000000008e167000         444K     RW                 GLB x  pte
> [    0.020046] 0x000000008e167000-0x000000008e198000         196K                               pte
> [    0.020051] 0x000000008e198000-0x000000008e20e000         472K     RW                 GLB x  pte
> [    0.020063] 0x000000008e20e000-0x000000008e23c000         184K                               pte
> [    0.020068] 0x000000008e23c000-0x000000008e259000         116K     RW                 GLB x  pte
> [    0.020081] 0x000000008e259000-0x000000008e346000         948K                               pte
> [    0.020085] 0x000000008e346000-0x000000008e349000          12K     RW                 GLB x  pte
> [    0.020097] 0x000000008e349000-0x000000008e350000          28K                               pte
> [    0.020101] 0x000000008e350000-0x000000008e351000           4K     RW                 GLB x  pte
> [    0.020114] 0x000000008e351000-0x000000008e3e4000         588K                               pte
> [    0.020118] 0x000000008e3e4000-0x000000008e3e5000           4K     RW                 GLB x  pte
> [    0.020131] 0x000000008e3e5000-0x000000008e47f000         616K                               pte
> [    0.020135] 0x000000008e47f000-0x000000008e480000           4K     RW                 GLB x  pte
> [    0.020147] 0x000000008e480000-0x000000008e481000           4K                               pte
> [    0.020151] 0x000000008e481000-0x000000008e4aa000         164K     RW                 GLB x  pte
> [    0.020163] 0x000000008e4aa000-0x000000008e4d7000         180K                               pte
> [    0.020168] 0x000000008e4d7000-0x000000008e4d8000           4K     RW                 GLB x  pte
> [    0.020180] 0x000000008e4d8000-0x000000008e50f000         220K                               pte
> [    0.020184] 0x000000008e50f000-0x000000008e510000           4K     RW                 GLB x  pte
> [    0.020196] 0x000000008e510000-0x000000008e511000           4K                               pte
> [    0.020200] 0x000000008e511000-0x000000008e512000           4K     RW                 GLB x  pte
> [    0.020213] 0x000000008e512000-0x000000008e569000         348K                               pte
> [    0.020217] 0x000000008e569000-0x000000008e56a000           4K     RW                 GLB x  pte
> [    0.020229] 0x000000008e56a000-0x000000008e623000         740K                               pte
> [    0.020235] 0x000000008e623000-0x000000008e6ca000         668K     RW                 GLB x  pte
> [    0.020247] 0x000000008e6ca000-0x000000008e711000         284K                               pte
> [    0.020251] 0x000000008e711000-0x000000008e713000           8K     RW                 GLB x  pte
> [    0.020263] 0x000000008e713000-0x000000008e71a000          28K                               pte
> [    0.020267] 0x000000008e71a000-0x000000008e71b000           4K     RW                 GLB x  pte
> [    0.020280] 0x000000008e71b000-0x000000008e804000         932K                               pte
> [    0.020285] 0x000000008e804000-0x000000008e875000         452K     RW                 GLB x  pte
> [    0.020297] 0x000000008e875000-0x000000008e8b2000         244K                               pte
> [    0.020302] 0x000000008e8b2000-0x000000008e9bd000        1068K     RW                 GLB x  pte
> [    0.020315] 0x000000008e9bd000-0x000000008ea62000         660K                               pte
> [    0.020320] 0x000000008ea62000-0x000000008eb1c000         744K     RW                 GLB x  pte
> [    0.020332] 0x000000008eb1c000-0x000000008eb2c000          64K                               pte
> [    0.020336] 0x000000008eb2c000-0x000000008eb60000         208K     RW                 GLB x  pte
> [    0.020348] 0x000000008eb60000-0x000000008eb6d000          52K                               pte
> [    0.020353] 0x000000008eb6d000-0x000000008ebcb000         376K     RW                 GLB x  pte
> [    0.020365] 0x000000008ebcb000-0x000000008ebe4000         100K                               pte
> [    0.020370] 0x000000008ebe4000-0x000000008ec3e000         360K     RW                 GLB x  pte
> [    0.020381] 0x000000008ec3e000-0x000000008ec54000          88K                               pte
> [    0.020387] 0x000000008ec54000-0x000000008ed6b000        1116K     RW                 GLB x  pte
> [    0.020399] 0x000000008ed6b000-0x000000008ed99000         184K                               pte
> [    0.020404] 0x000000008ed99000-0x000000008edb8000         124K     RW                 GLB x  pte
> [    0.020415] 0x000000008edb8000-0x000000008edf9000         260K                               pte
> [    0.020420] 0x000000008edf9000-0x000000008ee2b000         200K     RW                 GLB x  pte
> [    0.020432] 0x000000008ee2b000-0x000000008ee5a000         188K                               pte
> [    0.020437] 0x000000008ee5a000-0x000000008eef0000         600K     RW                 GLB x  pte
> [    0.020449] 0x000000008eef0000-0x000000008ef00000          64K                               pte
> [    0.020454] 0x000000008ef00000-0x000000008ef33000         204K     RW                 GLB x  pte
> [    0.020466] 0x000000008ef33000-0x000000008ef40000          52K                               pte
> [    0.020470] 0x000000008ef40000-0x000000008ef9c000         368K     RW                 GLB x  pte
> [    0.020482] 0x000000008ef9c000-0x000000008efb5000         100K                               pte
> [    0.020487] 0x000000008efb5000-0x000000008f00f000         360K     RW                 GLB x  pte
> [    0.020499] 0x000000008f00f000-0x000000008f025000          88K                               pte
> [    0.020504] 0x000000008f025000-0x000000008f097000         456K     RW                 GLB x  pte
> [    0.020516] 0x000000008f097000-0x000000008f09a000          12K                               pte
> [    0.020521] 0x000000008f09a000-0x000000008f13d000         652K     RW                 GLB x  pte
> [    0.020533] 0x000000008f13d000-0x000000008f151000          80K                               pte
> [    0.020538] 0x000000008f151000-0x000000008f2bb000        1448K     RW                 GLB x  pte
> [    0.020550] 0x000000008f2bb000-0x000000008f2be000          12K                               pte
> [    0.020555] 0x000000008f2be000-0x000000008f369000         684K     RW                 GLB x  pte
> [    0.020567] 0x000000008f369000-0x000000008f375000          48K                               pte
> [    0.020572] 0x000000008f375000-0x000000008f3dc000         412K     RW                 GLB x  pte
> [    0.020584] 0x000000008f3dc000-0x000000008f3e5000          36K                               pte
> [    0.020589] 0x000000008f3e5000-0x000000008f50b000        1176K     RW                 GLB x  pte
> [    0.020601] 0x000000008f50b000-0x000000008f513000          32K                               pte
> [    0.020606] 0x000000008f513000-0x000000008f5ee000         876K     RW                 GLB x  pte
> [    0.020618] 0x000000008f5ee000-0x000000008f5fa000          48K                               pte
> [    0.020623] 0x000000008f5fa000-0x000000008f600000          24K     RW                 GLB x  pte
> [    0.020635] 0x000000008f600000-0x000000008f800000           2M     RW         PSE         x  pmd
> [    0.020648] 0x000000008f800000-0x000000008f9f9000        2020K     RW                 GLB x  pte
> [    0.020660] 0x000000008f9f9000-0x000000008fa00000          28K                               pte
> [    0.020666] 0x000000008fa00000-0x000000008fb3a000        1256K     RW                 GLB x  pte
> [    0.020677] 0x000000008fb3a000-0x000000008fb46000          48K                               pte
> [    0.020683] 0x000000008fb46000-0x000000008fc32000         944K     RW                 GLB x  pte
> [    0.020695] 0x000000008fc32000-0x000000008fc3a000          32K                               pte
> [    0.020700] 0x000000008fc3a000-0x000000008fd8a000        1344K     RW                 GLB x  pte
> [    0.020712] 0x000000008fd8a000-0x000000008fd94000          40K                               pte
> [    0.020717] 0x000000008fd94000-0x000000008fe37000         652K     RW                 GLB x  pte
> [    0.020729] 0x000000008fe37000-0x000000008fe41000          40K                               pte
> [    0.020734] 0x000000008fe41000-0x000000008feca000         548K     RW                 GLB x  pte
> [    0.020746] 0x000000008feca000-0x000000008fecf000          20K                               pte
> [    0.020751] 0x000000008fecf000-0x000000008ff9f000         832K     RW                 GLB x  pte
> [    0.020763] 0x000000008ff9f000-0x000000008ffa2000          12K                               pte
> [    0.020767] 0x000000008ffa2000-0x000000008ffb6000          80K     RW                 GLB x  pte
> [    0.020779] 0x000000008ffb6000-0x000000008ffc1000          44K                               pte
> [    0.020784] 0x000000008ffc1000-0x0000000090000000         252K     RW                 GLB x  pte
> [    0.020796] 0x0000000090000000-0x0000000090600000           6M     RW         PSE         x  pmd
> [    0.020811] 0x0000000090600000-0x00000000909de000        3960K     RW                 GLB x  pte
> [    0.020823] 0x00000000909de000-0x00000000909df000           4K                               pte
> [    0.020828] 0x00000000909df000-0x0000000090a00000         132K     RW                 GLB x  pte
> [    0.020840] 0x0000000090a00000-0x000000009a200000         152M     RW         PSE         x  pmd
> [    0.020852] 0x000000009a200000-0x000000009a21d000         116K     RW                 GLB x  pte
> [    0.020863] 0x000000009a21d000-0x000000009a220000          12K                               pte
> [    0.020868] 0x000000009a220000-0x000000009a228000          32K     RW                 GLB x  pte
> [    0.020880] 0x000000009a228000-0x000000009a22b000          12K                               pte
> [    0.020884] 0x000000009a22b000-0x000000009a234000          36K     RW                 GLB x  pte
> [    0.020896] 0x000000009a234000-0x000000009a237000          12K                               pte
> [    0.020900] 0x000000009a237000-0x000000009a240000          36K     RW                 GLB x  pte
> [    0.020912] 0x000000009a240000-0x000000009a243000          12K                               pte
> [    0.020917] 0x000000009a243000-0x000000009a25f000         112K     RW                 GLB x  pte
> [    0.020929] 0x000000009a25f000-0x000000009a261000           8K                               pte
> [    0.020935] 0x000000009a261000-0x000000009a400000        1660K     RW                 GLB x  pte
> [    0.020946] 0x000000009a400000-0x000000009be00000          26M     RW         PSE         x  pmd
> [    0.020959] 0x000000009be00000-0x000000009beaf000         700K     RW                 GLB x  pte
> [    0.020972] 0x000000009beaf000-0x000000009c000000        1348K                               pte
> [    0.020976] 0x000000009c000000-0x000000009ca00000          10M                               pmd
> [    0.020982] 0x000000009ca00000-0x000000009cb3d000        1268K                               pte
> [    0.020987] 0x000000009cb3d000-0x000000009cc00000         780K     RW                 GLB x  pte
> [    0.021017] 0x000000009cc00000-0x000000009ce00000           2M     RW         PSE         x  pmd
> [    0.021029] 0x000000009ce00000-0x000000009ce31000         196K     RW                 GLB x  pte
> [    0.021042] 0x000000009ce31000-0x000000009cfcc000        1644K                               pte
> [    0.021047] 0x000000009cfcc000-0x000000009d000000         208K     RW                 GLB x  pte
> [    0.021058] 0x000000009d000000-0x000000009ee00000          30M     RW         PSE         x  pmd
> [    0.021072] 0x000000009ee00000-0x000000009f000000           2M     RW                 GLB x  pte
> [    0.021084] 0x000000009f000000-0x000000009f800000           8M                               pmd
> [    0.021091] 0x000000009f800000-0x00000000dfa00000        1026M     RW     PCD PSE         x  pmd
> [    0.021104] 0x00000000dfa00000-0x00000000f8000000         390M                               pmd
> [    0.021109] 0x00000000f8000000-0x00000000fc000000          64M     RW     PCD PSE         x  pmd
> [    0.021121] 0x00000000fc000000-0x00000000fec00000          44M                               pmd
> [    0.021125] 0x00000000fec00000-0x00000000fec01000           4K     RW     PCD         GLB x  pte
> [    0.021138] 0x00000000fec01000-0x00000000fed00000        1020K                               pte
> [    0.021142] 0x00000000fed00000-0x00000000fed04000          16K     RW     PCD         GLB x  pte
> [    0.021154] 0x00000000fed04000-0x00000000fed1c000          96K                               pte
> [    0.021159] 0x00000000fed1c000-0x00000000fed20000          16K     RW     PCD         GLB x  pte
> [    0.021171] 0x00000000fed20000-0x00000000fee00000         896K                               pte
> [    0.021176] 0x00000000fee00000-0x00000000fee01000           4K     RW     PCD         GLB x  pte
> [    0.021190] 0x00000000fee01000-0x00000000ff000000        2044K                               pte
> [    0.021194] 0x00000000ff000000-0x0000000100000000          16M     RW     PCD PSE         x  pmd
> [    0.021206] 0x0000000100000000-0x00000007c0000000          27G                               pud
> [    0.021213] 0x00000007c0000000-0x00000007fe800000        1000M                               pmd
> [    0.021219] 0x00000007fe800000-0x00000007fe906000        1048K                               pte
> [    0.021223] 0x00000007fe906000-0x00000007fe908000           8K     RW                 GLB NX pte
> [    0.021236] 0x00000007fe908000-0x00000007fea00000         992K                               pte
> [    0.021241] 0x00000007fea00000-0x0000000800000000          22M                               pmd
> [    0.021248] 0x0000000800000000-0x0000008000000000         480G                               pud
> [    0.021257] 0x0000008000000000-0xffff800000000000   17179737600G                               pgd
> [    0.021261] ---[ Kernel Space ]---
> [    0.021263] 0xffff800000000000-0xffff808000000000         512G                               pgd
> [    0.021267] ---[ Low Kernel Mapping ]---
> [    0.021268] 0xffff808000000000-0xffff810000000000         512G                               pgd
> [    0.021273] ---[ vmalloc() Area ]---
> [    0.021274] 0xffff810000000000-0xffff818000000000         512G                               pgd
> [    0.021278] ---[ Vmemmap ]---
> [    0.021280] 0xffff818000000000-0xffff988000000000          23T                               pgd
> [    0.021287] 0xffff988000000000-0xffff98dcc0000000         371G                               pud
> [    0.021294] 0xffff98dcc0000000-0xffff98dcc0200000           2M     RW                 GLB NX pte
> [    0.021308] 0xffff98dcc0200000-0xffff98dd00000000        1022M     RW         PSE     GLB NX pmd
> [    0.021320] 0xffff98dd00000000-0xffff98dd40000000           1G     RW         PSE     GLB NX pud
> [    0.021332] 0xffff98dd40000000-0xffff98dd49600000         150M     RW         PSE     GLB NX pmd
> [    0.021345] 0xffff98dd49600000-0xffff98dd4973d000        1268K     RW                 GLB NX pte
> [    0.021357] 0xffff98dd4973d000-0xffff98dd49744000          28K                               pte
> [    0.021362] 0xffff98dd49744000-0xffff98dd49800000         752K     RW                 GLB NX pte
> [    0.021374] 0xffff98dd49800000-0xffff98dd4a200000          10M     RW         PSE     GLB NX pmd
> [    0.021386] 0xffff98dd4a200000-0xffff98dd4a21a000         104K     RW                 GLB NX pte
> [    0.021399] 0xffff98dd4a21a000-0xffff98dd4a400000        1944K                               pte
> [    0.021404] 0xffff98dd4a400000-0xffff98dd4a600000           2M                               pmd
> [    0.021410] 0xffff98dd4a600000-0xffff98dd4a773000        1484K                               pte
> [    0.021415] 0xffff98dd4a773000-0xffff98dd4a800000         564K     RW                 GLB NX pte
> [    0.021428] 0xffff98dd4a800000-0xffff98dd5ce00000         294M     RW         PSE     GLB NX pmd
> [    0.021440] 0xffff98dd5ce00000-0xffff98dd5ce31000         196K     RW                 GLB NX pte
> [    0.021452] 0xffff98dd5ce31000-0xffff98dd5cec9000         608K                               pte
> [    0.021457] 0xffff98dd5cec9000-0xffff98dd5cf10000         284K     RW                 GLB NX pte
> [    0.021469] 0xffff98dd5cf10000-0xffff98dd5d000000         960K                               pte
> [    0.021474] 0xffff98dd5d000000-0xffff98dd5ee00000          30M                               pmd
> [    0.021480] 0xffff98dd5ee00000-0xffff98dd5efff000        2044K                               pte
> [    0.021485] 0xffff98dd5efff000-0xffff98dd5f000000           4K     RW                 GLB NX pte
> [    0.021498] 0xffff98dd5f000000-0xffff98dd80000000         528M                               pmd
> [    0.021503] 0xffff98dd80000000-0xffff98ddc0000000           1G                               pud
> [    0.021507] 0xffff98ddc0000000-0xffff98e4c0000000          28G     RW         PSE     GLB NX pud
> [    0.021521] 0xffff98e4c0000000-0xffff98e4df600000         502M     RW         PSE     GLB NX pmd
> [    0.021534] 0xffff98e4df600000-0xffff98e500000000         522M                               pmd
> [    0.021539] 0xffff98e500000000-0xffff990000000000         108G                               pud
> [    0.021544] 0xffff990000000000-0xffffaa8000000000       17920G                               pgd
> [    0.021550] 0xffffaa8000000000-0xffffaaafc0000000         191G                               pud
> [    0.021554] 0xffffaaafc0000000-0xffffaaafc0001000           4K     RW     PCD         GLB NX pte
> [    0.021566] 0xffffaaafc0001000-0xffffaaafc0002000           4K                               pte
> [    0.021570] 0xffffaaafc0002000-0xffffaaafc0003000           4K     RW                 GLB NX pte
> [    0.021582] 0xffffaaafc0003000-0xffffaaafc0004000           4K                               pte
> [    0.021587] 0xffffaaafc0004000-0xffffaaafc0006000           8K     RW                 GLB NX pte
> [    0.021598] 0xffffaaafc0006000-0xffffaaafc0008000           8K                               pte
> [    0.021603] 0xffffaaafc0008000-0xffffaaafc000c000          16K     RW                 GLB NX pte
> [    0.021615] 0xffffaaafc000c000-0xffffaaafc0010000          16K                               pte
> [    0.021619] 0xffffaaafc0010000-0xffffaaafc001d000          52K     RW                 GLB NX pte
> [    0.021633] 0xffffaaafc001d000-0xffffaaafc0200000        1932K                               pte
> [    0.021640] 0xffffaaafc0200000-0xffffaab000000000        1022M                               pmd
> [    0.021646] 0xffffaab000000000-0xffffab0000000000         320G                               pud
> [    0.021653] 0xffffab0000000000-0xfffff78000000000       78336G                               pgd
> [    0.021660] 0xfffff78000000000-0xfffff7d000000000         320G                               pud
> [    0.021664] 0xfffff7d000000000-0xfffff7d002800000          40M     RW         PSE     GLB NX pmd
> [    0.021676] 0xfffff7d002800000-0xfffff7d004000000          24M                               pmd
> [    0.021682] 0xfffff7d004000000-0xfffff7d020800000         456M     RW         PSE     GLB NX pmd
> [    0.021695] 0xfffff7d020800000-0xfffff7d040000000         504M                               pmd
> [    0.021700] 0xfffff7d040000000-0xfffff80000000000         191G                               pud
> [    0.021705] 0xfffff80000000000-0xffffff0000000000           7T                               pgd
> [    0.021710] ---[ ESPfix Area ]---
> [    0.021711] 0xffffff0000000000-0xffffff8000000000         512G                               pgd
> [    0.021718] 0xffffff8000000000-0xffffffef00000000         444G                               pud
> [    0.021722] ---[ EFI Runtime Services ]---
> [    0.021724] 0xffffffef00000000-0xfffffffe80000000          62G                               pud
> [    0.021730] 0xfffffffe80000000-0xfffffffea9200000         658M                               pmd
> [    0.021735] 0xfffffffea9200000-0xfffffffea9208000          32K     RW                 GLB x  pte
> [    0.021747] 0xfffffffea9208000-0xfffffffea925f000         348K                               pte
> [    0.021752] 0xfffffffea925f000-0xfffffffea929f000         256K     RW                 GLB x  pte
> [    0.021764] 0xfffffffea929f000-0xfffffffea9344000         660K                               pte
> [    0.021771] 0xfffffffea9344000-0xfffffffea9600000        2800K     RW                 GLB x  pte
> [    0.021783] 0xfffffffea9600000-0xfffffffea9c00000           6M     RW         PSE         x  pmd
> [    0.021799] 0xfffffffea9c00000-0xfffffffeaa000000           4M     RW                 GLB x  pte
> [    0.021810] 0xfffffffeaa000000-0xfffffffeaa200000           2M     RW         PSE         x  pmd
> [    0.021824] 0xfffffffeaa200000-0xfffffffeaa3ae000        1720K     RW                 GLB x  pte
> [    0.021837] 0xfffffffeaa3ae000-0xfffffffeaa57f000        1860K                               pte
> [    0.021842] 0xfffffffeaa57f000-0xfffffffeaa5c1000         264K     RW                 GLB x  pte
> [    0.021854] 0xfffffffeaa5c1000-0xfffffffeaa5d1000          64K                               pte
> [    0.021859] 0xfffffffeaa5d1000-0xfffffffeaa606000         212K     RW                 GLB x  pte
> [    0.021871] 0xfffffffeaa606000-0xfffffffeaa613000          52K                               pte
> [    0.021876] 0xfffffffeaa613000-0xfffffffeaa66f000         368K     RW                 GLB x  pte
> [    0.021887] 0xfffffffeaa66f000-0xfffffffeaa688000         100K                               pte
> [    0.021892] 0xfffffffeaa688000-0xfffffffeaa6e2000         360K     RW                 GLB x  pte
> [    0.021904] 0xfffffffeaa6e2000-0xfffffffeaa6f8000          88K                               pte
> [    0.021909] 0xfffffffeaa6f8000-0xfffffffeaa767000         444K     RW                 GLB x  pte
> [    0.021921] 0xfffffffeaa767000-0xfffffffeaa798000         196K                               pte
> [    0.021926] 0xfffffffeaa798000-0xfffffffeaa80e000         472K     RW                 GLB x  pte
> [    0.021938] 0xfffffffeaa80e000-0xfffffffeaa83c000         184K                               pte
> [    0.021942] 0xfffffffeaa83c000-0xfffffffeaa859000         116K     RW                 GLB x  pte
> [    0.021955] 0xfffffffeaa859000-0xfffffffeaa946000         948K                               pte
> [    0.021959] 0xfffffffeaa946000-0xfffffffeaa949000          12K     RW                 GLB x  pte
> [    0.021971] 0xfffffffeaa949000-0xfffffffeaa950000          28K                               pte
> [    0.021976] 0xfffffffeaa950000-0xfffffffeaa951000           4K     RW                 GLB x  pte
> [    0.021988] 0xfffffffeaa951000-0xfffffffeaa9e4000         588K                               pte
> [    0.021993] 0xfffffffeaa9e4000-0xfffffffeaa9e5000           4K     RW                 GLB x  pte
> [    0.022021] 0xfffffffeaa9e5000-0xfffffffeaaa7f000         616K                               pte
> [    0.022026] 0xfffffffeaaa7f000-0xfffffffeaaa80000           4K     RW                 GLB x  pte
> [    0.022038] 0xfffffffeaaa80000-0xfffffffeaaa81000           4K                               pte
> [    0.022042] 0xfffffffeaaa81000-0xfffffffeaaaaa000         164K     RW                 GLB x  pte
> [    0.022054] 0xfffffffeaaaaa000-0xfffffffeaaad7000         180K                               pte
> [    0.022059] 0xfffffffeaaad7000-0xfffffffeaaad8000           4K     RW                 GLB x  pte
> [    0.022071] 0xfffffffeaaad8000-0xfffffffeaab0f000         220K                               pte
> [    0.022075] 0xfffffffeaab0f000-0xfffffffeaab10000           4K     RW                 GLB x  pte
> [    0.022087] 0xfffffffeaab10000-0xfffffffeaab11000           4K                               pte
> [    0.022092] 0xfffffffeaab11000-0xfffffffeaab12000           4K     RW                 GLB x  pte
> [    0.022104] 0xfffffffeaab12000-0xfffffffeaab69000         348K                               pte
> [    0.022108] 0xfffffffeaab69000-0xfffffffeaab6a000           4K     RW                 GLB x  pte
> [    0.022121] 0xfffffffeaab6a000-0xfffffffeaac23000         740K                               pte
> [    0.022126] 0xfffffffeaac23000-0xfffffffeaacca000         668K     RW                 GLB x  pte
> [    0.022138] 0xfffffffeaacca000-0xfffffffeaad11000         284K                               pte
> [    0.022142] 0xfffffffeaad11000-0xfffffffeaad13000           8K     RW                 GLB x  pte
> [    0.022154] 0xfffffffeaad13000-0xfffffffeaad1a000          28K                               pte
> [    0.022159] 0xfffffffeaad1a000-0xfffffffeaad1b000           4K     RW                 GLB x  pte
> [    0.022171] 0xfffffffeaad1b000-0xfffffffeaae04000         932K                               pte
> [    0.022176] 0xfffffffeaae04000-0xfffffffeaae75000         452K     RW                 GLB x  pte
> [    0.022188] 0xfffffffeaae75000-0xfffffffeaaeb2000         244K                               pte
> [    0.022194] 0xfffffffeaaeb2000-0xfffffffeaafbd000        1068K     RW                 GLB x  pte
> [    0.022206] 0xfffffffeaafbd000-0xfffffffeab062000         660K                               pte
> [    0.022211] 0xfffffffeab062000-0xfffffffeab11c000         744K     RW                 GLB x  pte
> [    0.022223] 0xfffffffeab11c000-0xfffffffeab12c000          64K                               pte
> [    0.022228] 0xfffffffeab12c000-0xfffffffeab160000         208K     RW                 GLB x  pte
> [    0.022240] 0xfffffffeab160000-0xfffffffeab16d000          52K                               pte
> [    0.022245] 0xfffffffeab16d000-0xfffffffeab1cb000         376K     RW                 GLB x  pte
> [    0.022256] 0xfffffffeab1cb000-0xfffffffeab1e4000         100K                               pte
> [    0.022261] 0xfffffffeab1e4000-0xfffffffeab23e000         360K     RW                 GLB x  pte
> [    0.022273] 0xfffffffeab23e000-0xfffffffeab254000          88K                               pte
> [    0.022279] 0xfffffffeab254000-0xfffffffeab36b000        1116K     RW                 GLB x  pte
> [    0.022291] 0xfffffffeab36b000-0xfffffffeab399000         184K                               pte
> [    0.022295] 0xfffffffeab399000-0xfffffffeab3b8000         124K     RW                 GLB x  pte
> [    0.022307] 0xfffffffeab3b8000-0xfffffffeab3f9000         260K                               pte
> [    0.022312] 0xfffffffeab3f9000-0xfffffffeab42b000         200K     RW                 GLB x  pte
> [    0.022324] 0xfffffffeab42b000-0xfffffffeab45a000         188K                               pte
> [    0.022329] 0xfffffffeab45a000-0xfffffffeab4f0000         600K     RW                 GLB x  pte
> [    0.022341] 0xfffffffeab4f0000-0xfffffffeab500000          64K                               pte
> [    0.022345] 0xfffffffeab500000-0xfffffffeab533000         204K     RW                 GLB x  pte
> [    0.022357] 0xfffffffeab533000-0xfffffffeab540000          52K                               pte
> [    0.022362] 0xfffffffeab540000-0xfffffffeab59c000         368K     RW                 GLB x  pte
> [    0.022374] 0xfffffffeab59c000-0xfffffffeab5b5000         100K                               pte
> [    0.022379] 0xfffffffeab5b5000-0xfffffffeab60f000         360K     RW                 GLB x  pte
> [    0.022391] 0xfffffffeab60f000-0xfffffffeab625000          88K                               pte
> [    0.022396] 0xfffffffeab625000-0xfffffffeab697000         456K     RW                 GLB x  pte
> [    0.022407] 0xfffffffeab697000-0xfffffffeab69a000          12K                               pte
> [    0.022413] 0xfffffffeab69a000-0xfffffffeab73d000         652K     RW                 GLB x  pte
> [    0.022424] 0xfffffffeab73d000-0xfffffffeab751000          80K                               pte
> [    0.022430] 0xfffffffeab751000-0xfffffffeab8bb000        1448K     RW                 GLB x  pte
> [    0.022442] 0xfffffffeab8bb000-0xfffffffeab8be000          12K                               pte
> [    0.022447] 0xfffffffeab8be000-0xfffffffeab969000         684K     RW                 GLB x  pte
> [    0.022459] 0xfffffffeab969000-0xfffffffeab975000          48K                               pte
> [    0.022464] 0xfffffffeab975000-0xfffffffeab9dc000         412K     RW                 GLB x  pte
> [    0.022476] 0xfffffffeab9dc000-0xfffffffeab9e5000          36K                               pte
> [    0.022481] 0xfffffffeab9e5000-0xfffffffeabb0b000        1176K     RW                 GLB x  pte
> [    0.022493] 0xfffffffeabb0b000-0xfffffffeabb13000          32K                               pte
> [    0.022498] 0xfffffffeabb13000-0xfffffffeabbee000         876K     RW                 GLB x  pte
> [    0.022510] 0xfffffffeabbee000-0xfffffffeabbfa000          48K                               pte
> [    0.022515] 0xfffffffeabbfa000-0xfffffffeabc00000          24K     RW                 GLB x  pte
> [    0.022526] 0xfffffffeabc00000-0xfffffffeabe00000           2M     RW         PSE         x  pmd
> [    0.022540] 0xfffffffeabe00000-0xfffffffeabff9000        2020K     RW                 GLB x  pte
> [    0.022552] 0xfffffffeabff9000-0xfffffffeac000000          28K                               pte
> [    0.022558] 0xfffffffeac000000-0xfffffffeac13a000        1256K     RW                 GLB x  pte
> [    0.022569] 0xfffffffeac13a000-0xfffffffeac146000          48K                               pte
> [    0.022575] 0xfffffffeac146000-0xfffffffeac232000         944K     RW                 GLB x  pte
> [    0.022587] 0xfffffffeac232000-0xfffffffeac23a000          32K                               pte
> [    0.022593] 0xfffffffeac23a000-0xfffffffeac38a000        1344K     RW                 GLB x  pte
> [    0.022604] 0xfffffffeac38a000-0xfffffffeac394000          40K                               pte
> [    0.022609] 0xfffffffeac394000-0xfffffffeac437000         652K     RW                 GLB x  pte
> [    0.022621] 0xfffffffeac437000-0xfffffffeac441000          40K                               pte
> [    0.022626] 0xfffffffeac441000-0xfffffffeac4ca000         548K     RW                 GLB x  pte
> [    0.022638] 0xfffffffeac4ca000-0xfffffffeac4cf000          20K                               pte
> [    0.022643] 0xfffffffeac4cf000-0xfffffffeac59f000         832K     RW                 GLB x  pte
> [    0.022655] 0xfffffffeac59f000-0xfffffffeac5a2000          12K                               pte
> [    0.022660] 0xfffffffeac5a2000-0xfffffffeac5b6000          80K     RW                 GLB x  pte
> [    0.022672] 0xfffffffeac5b6000-0xfffffffeac5c1000          44K                               pte
> [    0.022676] 0xfffffffeac5c1000-0xfffffffeac600000         252K     RW                 GLB x  pte
> [    0.022688] 0xfffffffeac600000-0xfffffffeacc00000           6M     RW         PSE         x  pmd
> [    0.022704] 0xfffffffeacc00000-0xfffffffeacfde000        3960K     RW                 GLB x  pte
> [    0.022715] 0xfffffffeacfde000-0xfffffffeacfdf000           4K                               pte
> [    0.022720] 0xfffffffeacfdf000-0xfffffffead000000         132K     RW                 GLB x  pte
> [    0.022732] 0xfffffffead000000-0xfffffffeb6800000         152M     RW         PSE         x  pmd
> [    0.022744] 0xfffffffeb6800000-0xfffffffeb681d000         116K     RW                 GLB x  pte
> [    0.022756] 0xfffffffeb681d000-0xfffffffeb6820000          12K                               pte
> [    0.022760] 0xfffffffeb6820000-0xfffffffeb6828000          32K     RW                 GLB x  pte
> [    0.022772] 0xfffffffeb6828000-0xfffffffeb682b000          12K                               pte
> [    0.022777] 0xfffffffeb682b000-0xfffffffeb6834000          36K     RW                 GLB x  pte
> [    0.022788] 0xfffffffeb6834000-0xfffffffeb6837000          12K                               pte
> [    0.022793] 0xfffffffeb6837000-0xfffffffeb6840000          36K     RW                 GLB x  pte
> [    0.022805] 0xfffffffeb6840000-0xfffffffeb6843000          12K                               pte
> [    0.022809] 0xfffffffeb6843000-0xfffffffeb685f000         112K     RW                 GLB x  pte
> [    0.022821] 0xfffffffeb685f000-0xfffffffeb6861000           8K                               pte
> [    0.022827] 0xfffffffeb6861000-0xfffffffeb6a00000        1660K     RW                 GLB x  pte
> [    0.022839] 0xfffffffeb6a00000-0xfffffffeb8400000          26M     RW         PSE         x  pmd
> [    0.022851] 0xfffffffeb8400000-0xfffffffeb84af000         700K     RW                 GLB x  pte
> [    0.022864] 0xfffffffeb84af000-0xfffffffeb853d000         568K                               pte
> [    0.022869] 0xfffffffeb853d000-0xfffffffeb8600000         780K     RW                 GLB x  pte
> [    0.022881] 0xfffffffeb8600000-0xfffffffeb8800000           2M     RW         PSE         x  pmd
> [    0.022893] 0xfffffffeb8800000-0xfffffffeb8831000         196K     RW                 GLB x  pte
> [    0.022906] 0xfffffffeb8831000-0xfffffffeb89cc000        1644K                               pte
> [    0.022911] 0xfffffffeb89cc000-0xfffffffeb8a00000         208K     RW                 GLB x  pte
> [    0.022922] 0xfffffffeb8a00000-0xfffffffeba800000          30M     RW         PSE         x  pmd
> [    0.022936] 0xfffffffeba800000-0xfffffffebaa00000           2M     RW                 GLB x  pte
> [    0.022951] 0xfffffffebaa00000-0xfffffffefec00000        1090M     RW     PCD PSE         x  pmd
> [    0.022963] 0xfffffffefec00000-0xfffffffefec01000           4K     RW     PCD         GLB x  pte
> [    0.022975] 0xfffffffefec01000-0xfffffffefed00000        1020K                               pte
> [    0.022980] 0xfffffffefed00000-0xfffffffefed04000          16K     RW     PCD         GLB x  pte
> [    0.022992] 0xfffffffefed04000-0xfffffffefed1c000          96K                               pte
> [    0.023013] 0xfffffffefed1c000-0xfffffffefed20000          16K     RW     PCD         GLB x  pte
> [    0.023026] 0xfffffffefed20000-0xfffffffefee00000         896K                               pte
> [    0.023030] 0xfffffffefee00000-0xfffffffefee01000           4K     RW     PCD         GLB x  pte
> [    0.023044] 0xfffffffefee01000-0xfffffffeff000000        2044K                               pte
> [    0.023049] 0xfffffffeff000000-0xffffffff00000000          16M     RW     PCD PSE         x  pmd
> [    0.023060] 0xffffffff00000000-0xffffffff80000000           2G                               pud
> [    0.023065] ---[ High Kernel Mapping ]---
> [    0.023067] 0xffffffff80000000-0xffffffffa2000000         544M                               pmd
> [    0.023072] 0xffffffffa2000000-0xffffffffa4600000          38M     RW         PSE     GLB x  pmd
> [    0.023085] 0xffffffffa4600000-0xffffffffc0000000         442M                               pmd
> [    0.023090] ---[ Modules ]---
> [    0.023093] 0xffffffffc0000000-0xffffffffff000000        1008M                               pmd
> [    0.023098] ---[ End Modules ]---
> [    0.023099] 0xffffffffff000000-0xffffffffff200000           2M                               pmd
> [    0.023107] 0xffffffffff200000-0xffffffffff57b000        3564K                               pte
> [    0.023111] 0xffffffffff57b000-0xffffffffff57c000           4K     ro                 GLB NX pte
> [    0.023124] 0xffffffffff57c000-0xffffffffff5fb000         508K                               pte
> [    0.023128] 0xffffffffff5fb000-0xffffffffff5fd000           8K     RW PWT PCD         GLB NX pte
> [    0.023140] 0xffffffffff5fd000-0xffffffffff600000          12K                               pte
> [    0.023145] 0xffffffffff600000-0xffffffffff601000           4K USR ro                 GLB NX pte
> [    0.023158] 0xffffffffff601000-0xffffffffff800000        2044K                               pte
> [    0.023163] 0xffffffffff800000-0x0000000000000000           8M                               pmd
> [    0.023267] Security Framework initialized
> [    0.023269] Yama: becoming mindful.
> [    0.023277] SELinux:  Initializing.
> [    0.023314] SELinux:  Starting in permissive mode
> [    0.026887] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> [    0.032023] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.033734] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.033792] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.034294] CPU: Physical Processor ID: 0
> [    0.034295] CPU: Processor Core ID: 0
> [    0.034301] mce: CPU supports 9 MCE banks
> [    0.034311] CPU0: Thermal monitoring enabled (TM1)
> [    0.034324] process: using mwait in idle threads
> [    0.034326] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> [    0.034327] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.034655] Freeing SMP alternatives memory: 32K
> [    0.061992] ftrace: allocating 32236 entries in 126 pages
> [    0.066159] smpboot: Max logical packages: 2
> [    0.066168] DMAR: Host address width 39
> [    0.066170] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.066183] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
> [    0.066184] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.066190] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
> [    0.066191] DMAR: RMRR base: 0x0000009ee83000 end: 0x0000009ee91fff
> [    0.066193] DMAR: RMRR base: 0x000000df800000 end: 0x000000df9fffff
> [    0.066195] DMAR-IR: IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
> [    0.066196] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [    0.066198] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
> [    0.067227] DMAR-IR: Enabled IRQ remapping in x2apic mode
> [    0.067229] x2apic enabled
> [    0.067237] Switched APIC routing to cluster x2apic.
> [    0.067734] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.077751] TSC deadline timer enabled
> [    0.077756] smpboot: CPU0: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (family: 0x6, model: 0x3c, stepping: 0x3)
> [    0.077937] Performance Events: PEBS fmt2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
> [    0.077974] ... version:                3
> [    0.077975] ... bit width:              48
> [    0.077976] ... generic registers:      4
> [    0.077977] ... value mask:             0000ffffffffffff
> [    0.077978] ... max period:             00007fffffffffff
> [    0.077979] ... fixed-purpose events:   3
> [    0.077981] ... event mask:             000000070000000f
> [    0.078041] smp: Bringing up secondary CPUs ...
> [    0.078348] x86: Booting SMP configuration:
> [    0.078351] .... node  #0, CPUs:      #1
> [    0.139165] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.139406]  #2 #3 #4 #5 #6 #7
> [    0.505068] smp: Brought up 1 node, 8 CPUs
> [    0.505068] smpboot: Total of 8 processors activated (54414.16 BogoMIPS)
> [    0.506236] sched_clock: Marking stable (506000000, 0)->(516328657, -10328657)
> [    0.506989] devtmpfs: initialized
> [    0.507111] x86/mm: Memory block size: 128MB
> [    0.514383] PM: Registering ACPI NVS region [mem 0x8973d000-0x89743fff] (28672 bytes)
> [    0.514386] PM: Registering ACPI NVS region [mem 0x9cf10000-0x9cfcbfff] (770048 bytes)
> [    0.515008] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.515052] futex hash table entries: 2048 (order: 6, 262144 bytes)
> [    0.515310] pinctrl core: initialized pinctrl subsystem
> [    0.515398] RTC time: 15:08:33, date: 04/13/17
> [    0.516250] NET: Registered protocol family 16
> [    0.516693] cpuidle: using governor menu
> [    0.516697] PCCT header not found.
> [    0.516824] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.516830] ACPI: bus type PCI registered
> [    0.516832] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.516952] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.516955] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.516960] pmd_set_huge: Cannot satisfy [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR override.
> [    0.517018] PCI: Using configuration type 1 for base access
> [    0.517113] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
> [    0.521515] HugeTLB registered 1 GB page size, pre-allocated 0 pages
> [    0.521517] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.522086] ACPI: Added _OSI(Module Device)
> [    0.522088] ACPI: Added _OSI(Processor Device)
> [    0.522090] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.522091] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.522334] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.538262] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    0.539997] ACPI: Dynamic OEM Table Load:
> [    0.540008] ACPI: SSDT 0xFFFF98E4BABB1C00 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
> [    0.540717] ACPI: Dynamic OEM Table Load:
> [    0.540728] ACPI: SSDT 0xFFFF98E4BAD89800 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
> [    0.541610] ACPI: Dynamic OEM Table Load:
> [    0.541621] ACPI: SSDT 0xFFFF98E4BAD9BA00 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
> [    0.546403] ACPI: Interpreter enabled
> [    0.546445] ACPI: (supports S0 S3 S4 S5)
> [    0.546446] ACPI: Using IOAPIC for interrupt routing
> [    0.546491] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.571086] ACPI: Power Resource [FN00] (off)
> [    0.571317] ACPI: Power Resource [FN01] (off)
> [    0.571516] ACPI: Power Resource [FN02] (off)
> [    0.571716] ACPI: Power Resource [FN03] (off)
> [    0.571917] ACPI: Power Resource [FN04] (off)
> [    0.574480] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.574486] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.574958] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
> [    0.575371] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
> [    0.575372] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
> [    0.576511] PCI host bridge to bus 0000:00
> [    0.576513] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.576515] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.576517] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    0.576518] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
> [    0.576520] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
> [    0.576521] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
> [    0.576523] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
> [    0.576524] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff window]
> [    0.576526] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.576541] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
> [    0.576756] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
> [    0.576769] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
> [    0.576778] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.576784] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
> [    0.577003] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
> [    0.577013] pci 0000:00:03.0: reg 0x10: [mem 0xf7d14000-0xf7d17fff 64bit]
> [    0.577250] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
> [    0.577269] pci 0000:00:14.0: reg 0x10: [mem 0xf7d00000-0xf7d0ffff 64bit]
> [    0.577342] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.577482] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.577540] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
> [    0.577560] pci 0000:00:16.0: reg 0x10: [mem 0xf7d1c000-0xf7d1c00f 64bit]
> [    0.577635] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.577815] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
> [    0.577831] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d10000-0xf7d13fff 64bit]
> [    0.577903] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.578034] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.578092] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
> [    0.578168] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.578415] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.578477] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
> [    0.578555] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.578788] pci 0000:00:1c.2: System wakeup disabled by ACPI
> [    0.578847] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
> [    0.578925] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.579157] pci 0000:00:1c.3: System wakeup disabled by ACPI
> [    0.579224] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
> [    0.579513] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
> [    0.579527] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
> [    0.579535] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
> [    0.579543] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
> [    0.579551] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
> [    0.579559] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
> [    0.579567] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d1a000-0xf7d1a7ff]
> [    0.579611] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.579783] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
> [    0.579799] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d19000-0xf7d190ff 64bit]
> [    0.579821] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
> [    0.580140] acpiphp: Slot [1] registered
> [    0.580146] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.580273] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.580294] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
> [    0.580325] pci 0000:02:00.0: reg 0x18: [mem 0xf7c00000-0xf7c00fff 64bit]
> [    0.580345] pci 0000:02:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff 64bit pref]
> [    0.580455] pci 0000:02:00.0: supports D1 D2
> [    0.580456] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.580530] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.584272] pci 0000:00:1c.2: PCI bridge to [bus 02]
> [    0.584275] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
> [    0.584279] pci 0000:00:1c.2:   bridge window [mem 0xf7c00000-0xf7cfffff]
> [    0.584284] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
> [    0.584407] pci 0000:03:00.0: [8086:244e] type 01 class 0x060401
> [    0.584543] pci 0000:03:00.0: supports D1 D2
> [    0.584545] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.584595] pci 0000:03:00.0: System wakeup disabled by ACPI
> [    0.584649] pci 0000:00:1c.3: PCI bridge to [bus 03-04]
> [    0.584803] pci 0000:03:00.0: PCI bridge to [bus 04] (subtractive decode)
> [    0.586871] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    0.587005] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.587138] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    0.587274] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    0.587412] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.587544] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.587678] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
> [    0.587807] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.588483] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.588751] pci 0000:00:02.0: vgaarb: setting as boot VGA device
> [    0.588754] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    0.588761] pci 0000:00:02.0: vgaarb: bridge control possible
> [    0.588762] vgaarb: loaded
> [    0.588897] SCSI subsystem initialized
> [    0.588972] libata version 3.00 loaded.
> [    0.589011] ACPI: bus type USB registered
> [    0.589042] usbcore: registered new interface driver usbfs
> [    0.589056] usbcore: registered new interface driver hub
> [    0.589106] usbcore: registered new device driver usb
> [    0.589230] Registered efivars operations
> [    0.592225] PCI: Using ACPI for IRQ routing
> [    0.593670] PCI: pci_cache_line_size set to 64 bytes
> [    0.593711] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
> [    0.593715] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
> [    0.593717] e820: reserve RAM buffer [mem 0x8940d018-0x8bffffff]
> [    0.593719] e820: reserve RAM buffer [mem 0x8941e018-0x8bffffff]
> [    0.593721] e820: reserve RAM buffer [mem 0x8973d000-0x8bffffff]
> [    0.593723] e820: reserve RAM buffer [mem 0x8a21a000-0x8bffffff]
> [    0.593725] e820: reserve RAM buffer [mem 0x9ce31000-0x9fffffff]
> [    0.593727] e820: reserve RAM buffer [mem 0x9cf10000-0x9fffffff]
> [    0.593729] e820: reserve RAM buffer [mem 0x9f000000-0x9fffffff]
> [    0.593731] e820: reserve RAM buffer [mem 0x81f600000-0x81fffffff]
> [    0.593959] NetLabel: Initializing
> [    0.593961] NetLabel:  domain hash size = 128
> [    0.593962] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    0.593989] NetLabel:  unlabeled traffic allowed by default
> [    0.594102] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.594112] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.596177] clocksource: Switched to clocksource hpet
> [    0.630939] VFS: Disk quotas dquot_6.6.0
> [    0.630975] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.631195] pnp: PnP ACPI init
> [    0.631376] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.631394] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.631750] system 00:01: [io  0x0680-0x069f] has been reserved
> [    0.631753] system 00:01: [io  0xffff] has been reserved
> [    0.631755] system 00:01: [io  0xffff] has been reserved
> [    0.631757] system 00:01: [io  0xffff] has been reserved
> [    0.631759] system 00:01: [io  0x1c00-0x1cfe] has been reserved
> [    0.631761] system 00:01: [io  0x1d00-0x1dfe] has been reserved
> [    0.631763] system 00:01: [io  0x1e00-0x1efe] has been reserved
> [    0.631765] system 00:01: [io  0x1f00-0x1ffe] has been reserved
> [    0.631767] system 00:01: [io  0x1800-0x18fe] has been reserved
> [    0.631769] system 00:01: [io  0x164e-0x164f] has been reserved
> [    0.631774] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.631819] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.631919] system 00:03: [io  0x1854-0x1857] has been reserved
> [    0.631924] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.632197] system 00:04: [io  0x0a00-0x0a0f] has been reserved
> [    0.632199] system 00:04: [io  0x0a30-0x0a3f] has been reserved
> [    0.632201] system 00:04: [io  0x0a20-0x0a2f] has been reserved
> [    0.632205] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.632715] pnp 00:05: [dma 0 disabled]
> [    0.632768] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.633380] pnp 00:06: [dma 0 disabled]
> [    0.633593] pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.633687] system 00:07: [io  0x04d0-0x04d1] has been reserved
> [    0.633692] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.634624] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.634626] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.634628] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.634630] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.634633] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.634635] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.634638] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
> [    0.634640] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.634642] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
> [    0.634645] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.634647] system 00:08: [mem 0xf7fdf000-0xf7fdffff] has been reserved
> [    0.634649] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
> [    0.634654] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.635208] pnp: PnP ACPI: found 9 devices
> [    0.643081] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    0.643120] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.643132] pci 0000:00:1c.2: PCI bridge to [bus 02]
> [    0.643134] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
> [    0.643139] pci 0000:00:1c.2:   bridge window [mem 0xf7c00000-0xf7cfffff]
> [    0.643142] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
> [    0.643148] pci 0000:03:00.0: PCI bridge to [bus 04]
> [    0.643176] pci 0000:00:1c.3: PCI bridge to [bus 03-04]
> [    0.643187] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.643189] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.643190] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> [    0.643192] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff window]
> [    0.643193] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff window]
> [    0.643195] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff window]
> [    0.643196] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff window]
> [    0.643197] pci_bus 0000:00: resource 11 [mem 0xdfa00000-0xfeafffff window]
> [    0.643199] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
> [    0.643201] pci_bus 0000:02: resource 1 [mem 0xf7c00000-0xf7cfffff]
> [    0.643202] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
> [    0.643463] NET: Registered protocol family 2
> [    0.644048] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.644770] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
> [    0.646693] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.647070] UDP hash table entries: 16384 (order: 9, 3145728 bytes)
> [    0.648400] UDP-Lite hash table entries: 16384 (order: 9, 3145728 bytes)
> [    0.649527] NET: Registered protocol family 1
> [    0.649543] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    0.650123] PCI: CLS 64 bytes, default 64
> [    0.650286] Unpacking initramfs...
> [    0.895593] Freeing initrd memory: 19340K
> [    0.907308] DMA-API: preallocated 65536 debug entries
> [    0.907310] DMA-API: debugging enabled by kernel config
> [    0.907396] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.907399] software IO TLB [mem 0x8540d000-0x8940d000] (64MB) mapped at [ffff98dd4540d000-ffff98dd4940cfff]
> [    0.909082] Scanning for low memory corruption every 60 seconds
> [    0.909318] cryptomgr_test (95) used greatest stack depth: 14600 bytes left
> [    0.909743] audit: initializing netlink subsys (disabled)
> [    0.910217] Initialise system trusted keyrings
> [    0.910327] workingset: timestamp_bits=36 max_order=23 bucket_order=0
> [    0.913271] zbud: loaded
> [    0.914517] SELinux:  Registering netfilter hooks
> [    0.940280] cryptomgr_test (99) used greatest stack depth: 14360 bytes left
> [    0.940588] cryptomgr_test (104) used greatest stack depth: 14248 bytes left
> [    0.941040] cryptomgr_test (109) used greatest stack depth: 14184 bytes left
> [    0.943173] modprobe (115) used greatest stack depth: 13816 bytes left
> [    0.944753] cryptomgr_test (118) used greatest stack depth: 13656 bytes left
> [    0.944844] cryptomgr_test (113) used greatest stack depth: 12904 bytes left
> [    0.948943] NET: Registered protocol family 38
> [    0.948959] Key type asymmetric registered
> [    0.948966] Asymmetric key parser 'x509' registered
> [    0.948989] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
> [    0.949070] io scheduler noop registered
> [    0.949072] io scheduler deadline registered
> [    0.949140] io scheduler cfq registered (default)
> [    0.949141] io scheduler mq-deadline registered
> [    0.949142] start plist test
> [    0.950208] end plist test
> [    0.950356] atomic64_test: passed for x86-64 platform with CX8 and with SSE
> [    0.951467] efifb: probing for efifb
> [    0.951483] efifb: framebuffer at 0xe0000000, using 3072k, total 3072k
> [    0.951485] efifb: mode is 1024x768x32, linelength=4096, pages=1
> [    0.951486] efifb: scrolling: redraw
> [    0.951487] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.951747] Console: switching to colour frame buffer device 128x48
> [    0.952728] fb0: EFI VGA frame buffer device
> [    0.952741] intel_idle: MWAIT substates: 0x42120
> [    0.952742] intel_idle: v0.4.1 model 0x3C
> [    0.953343] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.953523] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    0.953535] ACPI: Power Button [PWRB]
> [    0.953601] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    0.953604] ACPI: Power Button [PWRF]
> [    0.955184] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
> [    0.955573] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.955576] ACPI: Thermal Zone [TZ00] (28 C)
> [    0.956231] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.956233] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.956352] GHES: HEST is not enabled!
> [    0.956492] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.977133] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    0.981844] Non-volatile memory driver v1.3
> [    0.981890] Linux agpgart interface v0.103
> [    0.983321] ahci 0000:00:1f.2: version 3.0
> [    0.983630] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xd impl SATA mode
> [    0.983632] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
> [    0.990816] scsi host0: ahci
> [    0.991066] scsi host1: ahci
> [    0.991389] scsi host2: ahci
> [    0.991625] scsi host3: ahci
> [    0.992062] scsi host4: ahci
> [    0.992408] scsi host5: ahci
> [    0.992510] ata1: SATA max UDMA/133 abar m2048@0xf7d1a000 port 0xf7d1a100 irq 26
> [    0.992511] ata2: DUMMY
> [    0.992513] ata3: SATA max UDMA/133 abar m2048@0xf7d1a000 port 0xf7d1a200 irq 26
> [    0.992514] ata4: SATA max UDMA/133 abar m2048@0xf7d1a000 port 0xf7d1a280 irq 26
> [    0.992515] ata5: DUMMY
> [    0.992517] ata6: DUMMY
> [    0.992759] libphy: Fixed MDIO Bus: probed
> [    0.992986] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.992995] ehci-pci: EHCI PCI platform driver
> [    0.993014] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.993019] ohci-pci: OHCI PCI platform driver
> [    0.993033] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.993347] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.993592] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
> [    0.994768] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
> [    0.994773] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    0.994976] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.994979] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.994980] usb usb1: Product: xHCI Host Controller
> [    0.994982] usb usb1: Manufacturer: Linux 4.11.0-0.rc6.git0.1.fc26.x86_64+debug xhci-hcd
> [    0.994983] usb usb1: SerialNumber: 0000:00:14.0
> [    0.995386] hub 1-0:1.0: USB hub found
> [    0.995438] hub 1-0:1.0: 14 ports detected
> [    1.007424] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    1.007600] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
> [    1.007695] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
> [    1.007697] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.007698] usb usb2: Product: xHCI Host Controller
> [    1.007700] usb usb2: Manufacturer: Linux 4.11.0-0.rc6.git0.1.fc26.x86_64+debug xhci-hcd
> [    1.007701] usb usb2: SerialNumber: 0000:00:14.0
> [    1.008038] hub 2-0:1.0: USB hub found
> [    1.008075] hub 2-0:1.0: 6 ports detected
> [    1.011523] usbcore: registered new interface driver usbserial
> [    1.011532] usbcore: registered new interface driver usbserial_generic
> [    1.011556] usbserial: USB Serial support registered for generic
> [    1.011593] i8042: PNP: No PS/2 controller found.
> [    1.011696] mousedev: PS/2 mouse device common for all mice
> [    1.012052] rtc_cmos 00:02: RTC can wake from S4
> [    1.012255] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    1.012298] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    1.012386] device-mapper: uevent: version 1.0.3
> [    1.012565] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
> [    1.012767] intel_pstate: Intel P-state driver initializing
> [    1.016325] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.016574] usbcore: registered new interface driver usbhid
> [    1.016579] usbhid: USB HID core driver
> [    1.017120] drop_monitor: Initializing network drop monitor service
> [    1.017551] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.017765] Initializing XFRM netlink socket
> [    1.018814] NET: Registered protocol family 10
> [    1.033219] Segment Routing with IPv6
> [    1.033285] mip6: Mobile IPv6
> [    1.033323] NET: Registered protocol family 17
> [    1.036365] microcode: sig=0x306c3, pf=0x2, revision=0x20
> [    1.036968] microcode: Microcode Update Driver: v2.2.
> [    1.037028] AVX2 version of gcm_enc/dec engaged.
> [    1.037033] AES CTR mode by8 optimization enabled
> [    1.075320] registered taskstats version 1
> [    1.075356] Loading compiled-in X.509 certificates
> [    1.079412] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
> [    1.080060] Loaded X.509 cert 'Fedora kernel signing key: 5f5468550bc407a148e3491d0ec09f4e01641f25'
> [    1.080178] zswap: loaded using pool lzo/zbud
> [    1.089709] Key type big_key registered
> [    1.092220] Key type encrypted registered
> [    1.093189]   Magic number: 13:618:133
> [    1.093234] acpi device:08: hash matches
> [    1.093333] rtc_cmos 00:02: setting system clock to 2017-04-13 15:08:34 UTC (1492096114)
> [    1.093460] PM: Hibernation image not present or could not be loaded.
> [    1.301763] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.301903] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.301936] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.302166] ata1.00: ATA-8: OCZ-VECTOR150, 1.2, max UDMA/133
> [    1.302168] ata1.00: 468862128 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> [    1.303048] ata1.00: configured for UDMA/133
> [    1.303317] ata3.00: NCQ Send/Recv Log not supported
> [    1.303320] ata3.00: ATA-9: ST4000NM0033-9ZM170, SN06, max UDMA/133
> [    1.303323] ata3.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    1.304008] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VECTOR150    1.2  PQ: 0 ANSI: 5
> [    1.304988] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
> [    1.305013] ata3.00: NCQ Send/Recv Log not supported
> [    1.305019] ata3.00: configured for UDMA/133
> [    1.305045] sd 0:0:0:0: [sda] Write Protect is off
> [    1.305050] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.305088] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.305358] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.306602] scsi 2:0:0:0: Direct-Access     ATA      ST4000NM0033-9ZM SN06 PQ: 0 ANSI: 5
> [    1.307349] sd 2:0:0:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
> [    1.307365] sd 2:0:0:0: [sdb] Write Protect is off
> [    1.307368] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.307390] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.307465] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [    1.308052]  sda: sda1 sda2 sda3 sda4
> [    1.309730] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.315791] sd 2:0:0:0: [sdb] Attached SCSI disk
> [    1.358942] ata4.00: NCQ Send/Recv Log not supported
> [    1.358944] ata4.00: ATA-9: ST4000NM0033-9ZM170, SN06, max UDMA/133
> [    1.358946] ata4.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    1.360413] ata4.00: NCQ Send/Recv Log not supported
> [    1.360416] ata4.00: configured for UDMA/133
> [    1.360909] scsi 3:0:0:0: Direct-Access     ATA      ST4000NM0033-9ZM SN06 PQ: 0 ANSI: 5
> [    1.361212] sd 3:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
> [    1.361221] sd 3:0:0:0: [sdc] Write Protect is off
> [    1.361223] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.361244] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.361264] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [    1.372198] usb 1-9: new high-speed USB device number 2 using xhci_hcd
> [    1.407230]  sdc: sdc1
> [    1.407882] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    1.409604] Freeing unused kernel memory: 4656K
> [    1.409606] Write protecting the kernel read-only data: 14336k
> [    1.410141] Freeing unused kernel memory: 460K
> [    1.410671] Freeing unused kernel memory: 276K
> [    1.412027] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    1.412032] rodata_test: all tests were successful
> [    1.425449] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.425978] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.425992] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.428559] systemd[1]: systemd 233 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN default-hierarchy=hybrid)
> [    1.428953] systemd[1]: Detected architecture x86-64.
> [    1.428957] systemd[1]: Running in initial RAM disk.
> [    1.428989] systemd[1]: Set hostname to <localhost.localdomain>.
> [    1.475010] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.475027] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.475053] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.475087] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.476297] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.476354] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.476543] random: systemd: uninitialized urandom read (16 bytes read)
> [    1.482740] systemd[1]: Created slice System Slice.
> [    1.482902] systemd[1]: Listening on udev Control Socket.
> [    1.482997] systemd[1]: Listening on Journal Socket.
> [    1.484397] systemd[1]: Starting Create list of required static device nodes for the current kernel...
> [    1.484505] systemd[1]: Listening on Journal Audit Socket.
> [    1.484683] systemd[1]: Reached target Slices.
> [    1.541580] usb 1-9: New USB device found, idVendor=2109, idProduct=2812
> [    1.541588] usb 1-9: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    1.541591] usb 1-9: Product: USB 2.0 HUB
>                      
> [    1.542501] hub 1-9:1.0: USB hub found
> [    1.542728] hub 1-9:1.0: 4 ports detected
> [    1.644258] usb 2-5: new SuperSpeed USB device number 2 using xhci_hcd
> [    1.657848] usb 2-5: New USB device found, idVendor=2109, idProduct=0812
> [    1.657851] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.657854] usb 2-5: Product: USB 3.0 HUB
>                      
> [    1.657857] usb 2-5: Manufacturer: VLI Labs, Inc. 
> [    1.659514] hub 2-5:1.0: USB hub found
> [    1.660217] hub 2-5:1.0: 4 ports detected
> [    1.812152] usb 1-10: new high-speed USB device number 3 using xhci_hcd
> [    1.837186] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    1.837198] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
> [    1.838486] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffaaafc3249000, 94:de:80:6b:dd:24, XID 0c900800 IRQ 28
> [    1.838490] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    1.920128] r8169 0000:02:00.0 enp2s0: renamed from eth0
> [    1.936835] [drm] Memory usable by graphics device = 2048M
> [    1.936839] checking generic (e0000000 300000) vs hw (e0000000 10000000)
> [    1.936841] fb: switching to inteldrmfb from EFI VGA
> [    1.936969] Console: switching to colour dummy device 80x25
> [    1.938146] [drm] Replacing VGA console driver
> [    1.944806] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    1.944807] [drm] Driver supports precise vblank timestamp query.
> [    1.947783] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    1.952225] tsc: Refined TSC clocksource calibration: 3392.144 MHz
> [    1.952239] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x30e5517d4e4, max_idle_ns: 440795261668 ns
> [    1.956320] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on minor 0
> [    1.959741] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    1.961614] random: fast init done
> [    1.962005] acpi device:60: registered as cooling_device13
> [    1.962288] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
> [    1.962780] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on minor 0
> [    1.980481] usb 1-10: config 1 has an invalid interface number: 9 but max is 2
> [    1.980484] usb 1-10: config 1 has no interface number 2
> [    1.980687] usb 1-10: New USB device found, idVendor=1019, idProduct=0010
> [    1.980688] usb 1-10: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    1.980690] usb 1-10: Product: FOSTEX USB AUDIO HP-A8
> [    1.980691] usb 1-10: Manufacturer: FOSTEX
> [    1.980693] usb 1-10: SerialNumber: 00000
> [    1.982263] input: FOSTEX FOSTEX USB AUDIO HP-A8 as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.9/0003:1019:0010.0001/input/input3
> [    2.034720] hid-generic 0003:1019:0010.0001: input,hidraw0: USB HID v1.00 Device [FOSTEX FOSTEX USB AUDIO HP-A8] on usb-0000:00:14.0-10/input9
> [    2.057110] usb 1-9.1: new high-speed USB device number 4 using xhci_hcd
> [    2.145296] usb 1-9.1: New USB device found, idVendor=1a40, idProduct=0201
> [    2.145300] usb 1-9.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    2.145302] usb 1-9.1: Product: USB 2.0 Hub [MTT]
> [    2.145853] hub 1-9.1:1.0: USB hub found
> [    2.145930] hub 1-9.1:1.0: 7 ports detected
> [    2.152245] fbcon: inteldrmfb (fb0) is primary device
> [    2.180656] Console: switching to colour frame buffer device 240x67
> [    2.199717] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    2.216861] setfont (406) used greatest stack depth: 12712 bytes left
> [    2.286525] systemd-udevd (366) used greatest stack depth: 12440 bytes left
> [    2.287040] systemd-udevd (357) used greatest stack depth: 11880 bytes left
> [    2.287783] systemd-udevd (369) used greatest stack depth: 11784 bytes left
> [    2.325134] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    2.416102] usb 1-9.1.2: new high-speed USB device number 5 using xhci_hcd
> [    2.493000] usb 1-9.1.2: New USB device found, idVendor=12d1, idProduct=1506
> [    2.493003] usb 1-9.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.493005] usb 1-9.1.2: Product: HUAWEI_MOBILE
> [    2.493006] usb 1-9.1.2: Manufacturer: HUAWEI_MOBILE
> [    2.585447] usb-storage 1-9.1.2:1.3: USB Mass Storage device detected
> [    2.585845] scsi host6: usb-storage 1-9.1.2:1.3
> [    2.585989] usb-storage 1-9.1.2:1.4: USB Mass Storage device detected
> [    2.586267] scsi host7: usb-storage 1-9.1.2:1.4
> [    2.586448] usbcore: registered new interface driver usb-storage
> [    2.588360] usbcore: registered new interface driver uas
> [    2.641073] usb 1-9.1.3: new low-speed USB device number 6 using xhci_hcd
> [    2.687538] systemd-journald[255]: Received SIGTERM from PID 1 (systemd).
> [    2.725829] usb 1-9.1.3: New USB device found, idVendor=046d, idProduct=c326
> [    2.725832] usb 1-9.1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.725833] usb 1-9.1.3: Product: USB Keyboard
> [    2.725835] usb 1-9.1.3: Manufacturer: Logitech
> [    2.731910] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.1/1-9.1.3/1-9.1.3:1.0/0003:046D:C326.0002/input/input4
> [    2.737293] systemd: 15 output lines suppressed due to ratelimiting
> [    2.783475] hid-generic 0003:046D:C326.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Keyboard] on usb-0000:00:14.0-9.1.3/input0
> [    2.789236] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.1/1-9.1.3/1-9.1.3:1.1/0003:046D:C326.0003/input/input5
> [    2.825742] SELinux: 32768 avtab hash slots, 106842 rules.
> [    2.841598] hid-generic 0003:046D:C326.0003: input,hiddev0,hidraw2: USB HID v1.10 Device [Logitech USB Keyboard] on usb-0000:00:14.0-9.1.3/input1
> [    2.848248] SELinux: 32768 avtab hash slots, 106842 rules.
> [    2.896130] SELinux:  8 users, 14 roles, 5077 types, 309 bools, 1 sens, 1024 cats
> [    2.896134] SELinux:  94 classes, 106842 rules
> [    2.902094] SELinux:  Class sctp_socket not defined in policy.
> [    2.902095] SELinux:  Class icmp_socket not defined in policy.
> [    2.902096] SELinux:  Class ax25_socket not defined in policy.
> [    2.902097] SELinux:  Class ipx_socket not defined in policy.
> [    2.902099] SELinux:  Class netrom_socket not defined in policy.
> [    2.902100] SELinux:  Class atmpvc_socket not defined in policy.
> [    2.902101] SELinux:  Class x25_socket not defined in policy.
> [    2.902102] SELinux:  Class rose_socket not defined in policy.
> [    2.902103] SELinux:  Class decnet_socket not defined in policy.
> [    2.902104] SELinux:  Class atmsvc_socket not defined in policy.
> [    2.902105] SELinux:  Class rds_socket not defined in policy.
> [    2.902106] SELinux:  Class irda_socket not defined in policy.
> [    2.902107] SELinux:  Class pppox_socket not defined in policy.
> [    2.902108] SELinux:  Class llc_socket not defined in policy.
> [    2.902110] SELinux:  Class can_socket not defined in policy.
> [    2.902111] SELinux:  Class tipc_socket not defined in policy.
> [    2.902112] SELinux:  Class bluetooth_socket not defined in policy.
> [    2.902113] SELinux:  Class iucv_socket not defined in policy.
> [    2.902114] SELinux:  Class rxrpc_socket not defined in policy.
> [    2.902115] SELinux:  Class isdn_socket not defined in policy.
> [    2.902116] SELinux:  Class phonet_socket not defined in policy.
> [    2.902117] SELinux:  Class ieee802154_socket not defined in policy.
> [    2.902119] SELinux:  Class caif_socket not defined in policy.
> [    2.902120] SELinux:  Class alg_socket not defined in policy.
> [    2.902121] SELinux:  Class nfc_socket not defined in policy.
> [    2.902122] SELinux:  Class vsock_socket not defined in policy.
> [    2.902123] SELinux:  Class kcm_socket not defined in policy.
> [    2.902124] SELinux:  Class qipcrtr_socket not defined in policy.
> [    2.902125] SELinux:  Class smc_socket not defined in policy.
> [    2.902126] SELinux: the above unknown classes and permissions will be allowed
> [    2.902134] SELinux:  Completing initialization.
> [    2.902135] SELinux:  Setting up existing superblocks.
> [    2.905050] usb 1-9.1.4: new full-speed USB device number 7 using xhci_hcd
> [    2.941814] systemd[1]: Successfully loaded SELinux policy in 141.283ms.
> [    2.960476] clocksource: Switched to clocksource tsc
> [    2.971216] systemd[1]: Relabelled /dev and /run in 17.445ms.
> [    3.004261] systemd-fstab-g (503) used greatest stack depth: 11656 bytes left
> [    3.020232] selinux-autorel (500) used greatest stack depth: 11352 bytes left
> [    3.157213] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    3.165052] RPC: Registered named UNIX socket transport module.
> [    3.165056] RPC: Registered udp transport module.
> [    3.165057] RPC: Registered tcp transport module.
> [    3.165058] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    3.195657] systemd-journald[515]: Received request to flush runtime journal from PID 1
> [    3.196518] usb 1-9.1.4: New USB device found, idVendor=0a12, idProduct=0001
> [    3.196522] usb 1-9.1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [    3.196525] usb 1-9.1.4: Product: BT2.0
> [    3.210584] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    3.263028] usb 1-9.1.5: new high-speed USB device number 8 using xhci_hcd
> [    3.343023] usb 1-9.1.5: New USB device found, idVendor=13fe, idProduct=3623
> [    3.343028] usb 1-9.1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.343031] usb 1-9.1.5: Product: silicon-power
> [    3.343034] usb 1-9.1.5: Manufacturer:         
> [    3.343036] usb 1-9.1.5: SerialNumber: 10090526E6A90E000F3B01F8
> [    3.343847] usb-storage 1-9.1.5:1.0: USB Mass Storage device detected
> [    3.347017] scsi host8: usb-storage 1-9.1.5:1.0
> [    3.411024] usb 1-9.1.6: new full-speed USB device number 9 using xhci_hcd
> [    3.454458] parport_pc 00:06: reported by Plug and Play ACPI
> [    3.454630] parport0: PC-style at 0x378, irq 5 [PCSPP,TRISTATE]
> [    3.489969] usb 1-9.1.6: New USB device found, idVendor=046d, idProduct=c52b
> [    3.489974] usb 1-9.1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.489991] usb 1-9.1.6: Product: USB Receiver
> [    3.489994] usb 1-9.1.6: Manufacturer: Logitech
> [    3.509578] ACPI Warning: SystemIO range 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x0000000000001800-0x000000000000187F (\PMIO) (20170119/utaddress-247)
> [    3.509586] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    3.509590] ACPI Warning: SystemIO range 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170119/utaddress-247)
> [    3.509594] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    3.509596] ACPI Warning: SystemIO range 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170119/utaddress-247)
> [    3.509600] ACPI Warning: SystemIO range 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170119/utaddress-247)
> [    3.509605] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    3.509606] ACPI Warning: SystemIO range 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170119/utaddress-247)
> [    3.509611] ACPI Warning: SystemIO range 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170119/utaddress-247)
> [    3.509615] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    3.509616] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    3.511003] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    3.611300] Bluetooth: Core ver 2.22
> [    3.611391] NET: Registered protocol family 31
> [    3.611393] Bluetooth: HCI device and connection manager initialized
> [    3.611439] Bluetooth: HCI socket layer initialized
> [    3.611442] Bluetooth: L2CAP socket layer initialized
> [    3.611478] Bluetooth: SCO socket layer initialized
> [    3.626882] scsi 7:0:0:0: Direct-Access     HUAWEI   TF CARD Storage  2.31 PQ: 0 ANSI: 2
> [    3.628590] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
> [    3.628981] raid6: sse2x1   gen()  7453 MB/s
> [    3.629908] usbcore: registered new interface driver btusb
> [    3.631900] sd 7:0:0:0: Attached scsi generic sg3 type 0
> [    3.634037] sd 7:0:0:0: [sdd] Attached SCSI removable disk
> [    3.634724] sr 6:0:0:0: [sr0] scsi-1 drive
> [    3.634733] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    3.644134] sr 6:0:0:0: Attached scsi CD-ROM sr0
> [    3.644398] sr 6:0:0:0: Attached scsi generic sg4 type 5
> [    3.645978] raid6: sse2x1   xor()  5798 MB/s
> [    3.662976] raid6: sse2x2   gen() 10503 MB/s
> [    3.679975] raid6: sse2x2   xor()  6302 MB/s
> [    3.696972] raid6: sse2x4   gen() 10996 MB/s
> [    3.713973] raid6: sse2x4   xor()  6501 MB/s
> [    3.724838] ppdev: user-space parallel port driver
> [    3.727787] iTCO_vendor_support: vendor-support=0
> [    3.729817] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    3.729900] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
> [    3.730976] raid6: avx2x1   gen() 17441 MB/s
> [    3.747965] raid6: avx2x1   xor() 13542 MB/s
> [    3.753845] Adding 62494716k swap on /dev/sda2.  Priority:-1 extents:1 across:62494716k SSFS
> [    3.764962] raid6: avx2x2   gen() 23023 MB/s
> [    3.781972] raid6: avx2x2   xor() 17998 MB/s
> [    3.798960] raid6: avx2x4   gen() 34390 MB/s
> [    3.815970] raid6: avx2x4   xor() 21582 MB/s
> [    3.815972] raid6: using algorithm avx2x4 gen() 34390 MB/s
> [    3.815973] raid6: .... xor() 21582 MB/s, rmw enabled
> [    3.815974] raid6: using avx2x2 recovery algorithm
> [    3.816884] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360 ms ovfl timer
> [    3.816887] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> [    3.816889] RAPL PMU: hw unit of domain package 2^-14 Joules
> [    3.816890] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [    3.816892] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> [    3.817165] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
> [    3.818420] i801_smbus 0000:00:1f.3: SPD Write Disable is set
> [    3.818460] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    3.818776] xor: automatically using best checksumming function   avx       
> [    3.828298] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
> [    3.828586] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
> [    3.829020] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
> [    3.868380] snd_hda_codec_realtek hdaudioC1D2: autoconfig for ALC892: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
> [    3.868385] snd_hda_codec_realtek hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.868388] snd_hda_codec_realtek hdaudioC1D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> [    3.868391] snd_hda_codec_realtek hdaudioC1D2:    mono: mono_out=0x0
> [    3.868393] snd_hda_codec_realtek hdaudioC1D2:    dig-out=0x11/0x0
> [    3.868396] snd_hda_codec_realtek hdaudioC1D2:    inputs:
> [    3.868400] snd_hda_codec_realtek hdaudioC1D2:      Front Mic=0x19
> [    3.868404] snd_hda_codec_realtek hdaudioC1D2:      Rear Mic=0x18
> [    3.868407] snd_hda_codec_realtek hdaudioC1D2:      Line=0x1a
> [    3.869606] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input6
> [    3.870224] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input7
> [    3.870471] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
> [    3.870749] input: HDA Intel HDMI HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
> [    3.871025] input: HDA Intel HDMI HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
> [    3.886307] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
> [    3.886531] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
> [    3.886730] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
> [    3.886916] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
> [    3.887429] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
> [    3.887658] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
> [    3.888083] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
> [    3.888530] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input18
> [    3.890827] Btrfs loaded, crc32c=crc32c-intel
> [    3.894165] BTRFS: device fsid a22dd8bc-24ef-4f97-bb62-01fcd7c3f11c devid 1 transid 73 /dev/sda4
> [    3.911658] logitech-djreceiver 0003:046D:C52B.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-9.1.6/input2
> [    3.916942] usbcore: registered new interface driver snd-usb-audio
> [    3.933308] BTRFS: device label home devid 1 transid 2347836 /dev/sdc1
> [    3.975441] usbcore: registered new interface driver option
> [    3.975549] usbserial: USB Serial support registered for GSM modem (1-port)
> [    3.975656] option 1-9.1.2:1.0: GSM modem (1-port) converter detected
> [    3.976596] usb 1-9.1.2: GSM modem (1-port) converter now attached to ttyUSB0
> [    3.976890] option 1-9.1.2:1.1: GSM modem (1-port) converter detected
> [    3.979903] usb 1-9.1.2: GSM modem (1-port) converter now attached to ttyUSB1
> [    4.003980] usbcore: registered new interface driver cdc_ncm
> [    4.006827] usbcore: registered new interface driver cdc_wdm
> [    4.047898] intel_rapl: Found RAPL domain package
> [    4.047902] intel_rapl: Found RAPL domain core
> [    4.047904] intel_rapl: Found RAPL domain uncore
> [    4.047906] intel_rapl: Found RAPL domain dram
> [    4.052722] input: Logitech T400 as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.1/1-9.1.6/1-9.1.6:1.2/0003:046D:C52B.0006/0003:046D:4026.0007/input/input19
> [    4.054293] logitech-hidpp-device 0003:046D:4026.0007: input,hidraw4: USB HID v1.11 Keyboard [Logitech T400] on usb-0000:00:14.0-9.1.6:1
> [    4.101746] huawei_cdc_ncm 1-9.1.2:1.2: MAC-Address: 00:1e:10:1f:00:00
> [    4.101749] huawei_cdc_ncm 1-9.1.2:1.2: setting rx_max = 16384
> [    4.108921] huawei_cdc_ncm 1-9.1.2:1.2: NDP will be placed at end of frame for this device.
> [    4.109147] huawei_cdc_ncm 1-9.1.2:1.2: cdc-wdm0: USB WDM device
> [    4.109495] huawei_cdc_ncm 1-9.1.2:1.2 wwan0: register 'huawei_cdc_ncm' at usb-0000:00:14.0-9.1.2, Huawei CDC NCM device, 00:1e:10:1f:00:00
> [    4.109555] usbcore: registered new interface driver huawei_cdc_ncm
> [    4.119143] huawei_cdc_ncm 1-9.1.2:1.2 wwp0s20u9u1u2i2: renamed from wwan0
> [    4.128478] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.128497] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.128499] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.128501] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d fc 00 00 02 00
> [    4.128518] blk_update_request: critical medium error, dev sr0, sector 145392
> [    4.135279] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.135281] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.135283] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.135285] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d fc 00 00 02 00
> [    4.135286] blk_update_request: critical medium error, dev sr0, sector 145392
> [    4.135333] Buffer I/O error on dev sr0, logical block 18174, async page read
> [    4.160471] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.160474] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.160476] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.160477] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8c 80 00 00 3c 00
> [    4.160479] blk_update_request: critical medium error, dev sr0, sector 143872
> [    4.166736] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.166738] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.166740] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.166742] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8c 80 00 00 02 00
> [    4.166743] blk_update_request: critical medium error, dev sr0, sector 143872
> [    4.166774] Buffer I/O error on dev sr0, logical block 17984, async page read
> [    4.173322] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.173324] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.173326] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.173327] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d fa 00 00 02 00
> [    4.173329] blk_update_request: critical medium error, dev sr0, sector 145384
> [    4.179556] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.179558] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.179560] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.179561] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d fa 00 00 02 00
> [    4.179563] blk_update_request: critical medium error, dev sr0, sector 145384
> [    4.179592] Buffer I/O error on dev sr0, logical block 18173, async page read
> [    4.198626] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.198628] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.198630] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.198631] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d f6 00 00 02 00
> [    4.198633] blk_update_request: critical medium error, dev sr0, sector 145368
> [    4.204872] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.204874] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.204875] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.204877] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8d f6 00 00 02 00
> [    4.204879] blk_update_request: critical medium error, dev sr0, sector 145368
> [    4.204908] Buffer I/O error on dev sr0, logical block 18171, async page read
> [    4.229028] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.229030] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.229031] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.229033] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8c 80 00 00 3c 00
> [    4.229035] blk_update_request: critical medium error, dev sr0, sector 143872
> [    4.235251] sr 6:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    4.235253] sr 6:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current] 
> [    4.235254] sr 6:0:0:0: [sr0] tag#0 Add. Sense: Unrecovered read error
> [    4.235256] sr 6:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 8c 80 00 00 02 00
> [    4.235258] blk_update_request: critical medium error, dev sr0, sector 143872
> [    4.235287] Buffer I/O error on dev sr0, logical block 17984, async page read
> [    4.247922] Buffer I/O error on dev sr0, logical block 18170, async page read
> [    4.385807] scsi 8:0:0:0: Direct-Access              silicon-power    PMAP PQ: 0 ANSI: 0 CCS
> [    4.387141] sd 8:0:0:0: Attached scsi generic sg5 type 0
> [    4.387699] sd 8:0:0:0: [sde] 3907584 512-byte logical blocks: (2.00 GB/1.86 GiB)
> [    4.389444] sd 8:0:0:0: [sde] Write Protect is off
> [    4.389447] sd 8:0:0:0: [sde] Mode Sense: 03 41 00 00
> [    4.391172] sd 8:0:0:0: [sde] No Caching mode page found
> [    4.391359] sd 8:0:0:0: [sde] Assuming drive cache: write through
> [    4.397857]  sde: sde1
> [    4.404410] sd 8:0:0:0: [sde] Attached SCSI removable disk
> [    4.423142] SGI XFS with ACLs, security attributes, no debug enabled
> [    4.448785] XFS (sdb): Mounting V5 Filesystem
> [    4.558625] XFS (sdb): Ending clean mount
> [    4.624206] mount (684) used greatest stack depth: 11256 bytes left
> [    4.730011] audit: type=2000 audit(1492096113.907:1): state=initialized audit_enabled=0 res=1
> [    4.730020] audit: type=1130 audit(1492096114.903:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730023] audit: type=1130 audit(1492096114.912:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730026] audit: type=1130 audit(1492096114.973:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730029] audit: type=1130 audit(1492096114.977:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730032] audit: type=1131 audit(1492096114.977:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730035] audit: type=1130 audit(1492096114.979:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730038] audit: type=1130 audit(1492096115.011:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730040] audit: type=1130 audit(1492096115.019:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.730043] audit: type=1130 audit(1492096115.213:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.911295] random: crng init done
> [    5.031660] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    5.031664] Bluetooth: BNEP filters: protocol multicast
> [    5.031671] Bluetooth: BNEP socket layer initialized
> [    5.544272] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    5.575993] Ebtables v2.0 registered
> [    5.633538] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> [    5.692500] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
> [    5.818003] r8169 0000:02:00.0 enp2s0: link down
> [    5.818029] r8169 0000:02:00.0 enp2s0: link down
> [    5.818277] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
> [    5.852701] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
> [    5.881061] Netfilter messages via NETLINK v0.30.
> [    5.886871] ip_set: protocol 6
> [    8.251588] r8169 0000:02:00.0 enp2s0: link up
> [    8.251608] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready
> [   20.405785] fuse init (API version 7.26)
> [   21.842098] Bluetooth: RFCOMM TTY layer initialized
> [   21.842106] Bluetooth: RFCOMM socket layer initialized
> [   21.842147] Bluetooth: RFCOMM ver 1.11
> [   33.242046] ISO 9660 Extensions: Microsoft Joliet Level 1
> [   33.253023] ISO 9660 Extensions: IEEE_P1282
> [   33.267411] FAT-fs (sde1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
> [   57.086214] tun: Universal TUN/TAP device driver, 1.6
> [   57.089303] virbr0: port 1(virbr0-nic) entered blocking state
> [   57.089308] virbr0: port 1(virbr0-nic) entered disabled state
> [   57.089511] device virbr0-nic entered promiscuous mode
> [   57.219977] virbr0: port 1(virbr0-nic) entered blocking state
> [   57.219988] virbr0: port 1(virbr0-nic) entered listening state
> [   57.287939] virbr0: port 1(virbr0-nic) entered disabled state
> [  233.433558] virbr0: port 2(vnet0) entered blocking state
> [  233.433564] virbr0: port 2(vnet0) entered disabled state
> [  233.433757] device vnet0 entered promiscuous mode
> [  233.434157] virbr0: port 2(vnet0) entered blocking state
> [  233.434163] virbr0: port 2(vnet0) entered listening state
> [  235.474288] virbr0: port 2(vnet0) entered learning state
> [  237.521561] virbr0: port 2(vnet0) entered forwarding state
> [  237.521565] virbr0: topology change detected, propagating
> [  332.749153] kworker/dying (163) used greatest stack depth: 10952 bytes left
> [  782.615867] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615915] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615919] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615923] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615927] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615931] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615935] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615939] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615943] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615948] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615952] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615956] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615960] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615964] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615967] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615971] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615975] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615979] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615983] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615987] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615991] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.615995] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616000] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616004] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616008] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616012] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616016] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616020] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616024] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616029] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616033] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616037] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616041] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616045] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616049] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616054] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616058] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616062] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616066] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616070] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616075] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616079] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616083] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616086] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616090] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616094] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616099] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616103] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616107] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616111] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616115] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616119] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616124] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616128] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616132] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616136] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616140] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616144] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616149] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616153] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616157] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616162] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616166] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616170] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616174] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616178] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616183] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616187] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616191] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616195] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616199] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616204] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616208] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616212] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616217] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616221] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616225] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616229] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616233] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616237] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616241] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616245] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616249] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616253] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616258] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616262] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616266] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616270] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616275] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616279] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616283] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616287] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616291] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616296] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616300] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616304] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616308] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616312] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616316] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616321] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616325] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616329] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616333] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616337] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616341] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616346] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616350] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616354] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616359] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616363] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616367] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616371] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616375] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616379] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616384] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616388] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616392] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616396] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616400] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616404] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616408] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616412] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616416] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616420] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616436] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616441] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616445] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616449] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616454] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616458] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616462] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616466] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616470] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616475] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616479] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616483] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616487] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616491] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616495] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616500] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616504] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616508] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616512] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616517] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616521] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616525] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616529] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616534] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616537] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616542] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616546] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616550] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616554] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616558] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616563] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616567] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616573] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616580] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616587] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616594] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616601] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616608] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616724] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616729] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616734] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616738] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616742] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616746] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616750] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616754] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616759] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616763] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616767] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616771] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616775] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616779] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616783] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616788] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616792] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616796] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616812] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616816] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616820] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616824] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616828] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616832] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616863] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616868] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616872] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616877] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616881] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616885] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616889] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616893] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616899] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616903] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616907] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616911] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616915] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616919] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616924] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616928] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616932] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616936] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616940] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616945] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616949] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616956] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616962] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616968] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616973] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616977] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616981] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616986] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616990] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616994] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.616998] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617003] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617007] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617011] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617018] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617025] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617032] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617038] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617045] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617051] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617059] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617066] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617073] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617080] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617087] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617094] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617101] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617105] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617109] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617113] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617117] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617122] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617126] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617130] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617134] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617138] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617142] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617146] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617150] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617154] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617158] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617162] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617166] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617170] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617174] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617178] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617182] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617187] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617192] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617196] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617200] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617204] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617208] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617212] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617216] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617220] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617225] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617229] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617233] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617237] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617241] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617246] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617250] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617254] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617258] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617262] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617267] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617271] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617275] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617279] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617283] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617287] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617292] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617296] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617300] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617304] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617308] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617313] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617317] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617322] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617326] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617330] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617334] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617338] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617342] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617346] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617350] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617354] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617358] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617362] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617366] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617370] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617375] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617379] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617383] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617387] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617391] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617396] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617400] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617404] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617408] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617412] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617416] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617420] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617424] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617428] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617432] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617437] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617441] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617445] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617449] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617453] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617457] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617462] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617466] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617470] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617474] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617478] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617482] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617486] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617490] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617494] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617498] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617503] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617507] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617511] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617515] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617519] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617523] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617527] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617532] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617536] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617540] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617544] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617548] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617552] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617556] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617560] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617564] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617568] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617572] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617576] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617581] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617585] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> [  782.617589] DMA-API: cacheline tracking ENOMEM, dma-debug disabled
> 
> [  823.490923] =================================
> [  823.490925] [ INFO: inconsistent lock state ]
> [  823.490929] 4.11.0-0.rc6.git0.1.fc26.x86_64+debug #1 Not tainted
> [  823.490931] ---------------------------------
> [  823.490933] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> [  823.490935] kswapd0/97 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [  823.490937]  (&sb->s_type->i_mutex_key#22){++++?+}, at: [<ffffffffc0c1c09b>] xfs_ilock+0x13b/0x220 [xfs]
> [  823.491078] {RECLAIM_FS-ON-W} state was registered at:
> [  823.491089]   mark_held_locks+0x5f/0x90
> [  823.491093]   lockdep_trace_alloc+0x7d/0xe0
> [  823.491097]   kmem_cache_alloc+0x33/0x2e0
> [  823.491235]   kmem_zone_alloc+0x66/0x100 [xfs]
> [  823.491347]   xfs_trans_alloc+0x6b/0x130 [xfs]
> [  823.491471]   xfs_link+0x1a4/0x3a0 [xfs]
> [  823.491558]   xfs_vn_link+0x6a/0xb0 [xfs]
> [  823.491567]   vfs_link+0x238/0x320
> [  823.491569]   SyS_link+0x1bf/0x200
> [  823.491576]   entry_SYSCALL_64_fastpath+0x1f/0xc2
> [  823.491577] irq event stamp: 889625
> [  823.491584] hardirqs last  enabled at (889625): [<ffffffffa213baa1>] __call_rcu+0x1f1/0x3d0
> [  823.491586] hardirqs last disabled at (889624): [<ffffffffa213b952>] __call_rcu+0xa2/0x3d0
> [  823.491589] softirqs last  enabled at (887736): [<ffffffffa2986b12>] __do_softirq+0x382/0x511
> [  823.491595] softirqs last disabled at (887729): [<ffffffffa20ba6af>] irq_exit+0x10f/0x120
> [  823.491597] 
>                other info that might help us debug this:
> [  823.491598]  Possible unsafe locking scenario:
> 
> [  823.491599]        CPU0
> [  823.491600]        ----
> [  823.491601]   lock(&sb->s_type->i_mutex_key#22);
> [  823.491604]   <Interrupt>
> [  823.491605]     lock(&sb->s_type->i_mutex_key#22);
> [  823.491607] 
>                 *** DEADLOCK ***
> 
> [  823.491610] 2 locks held by kswapd0/97:
> [  823.491611]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffffa2231d5b>] shrink_slab.part.43+0x5b/0x580
> [  823.491618]  #1:  (&type->s_umount_key#62){++++.+}, at: [<ffffffffa22ced9b>] trylock_super+0x1b/0x50
> [  823.491624] 
>                stack backtrace:
> [  823.491628] CPU: 3 PID: 97 Comm: kswapd0 Not tainted 4.11.0-0.rc6.git0.1.fc26.x86_64+debug #1
> [  823.491629] Hardware name: Gigabyte Technology Co., Ltd. Z87M-D3H/Z87M-D3H, BIOS F11 08/12/2014
> [  823.491632] Call Trace:
> [  823.491645]  dump_stack+0x8e/0xd1
> [  823.491653]  print_usage_bug+0x1d0/0x1e0
> [  823.491656]  mark_lock+0x504/0x5a0
> [  823.491661]  ? sched_clock+0x9/0x10
> [  823.491664]  ? print_shortest_lock_dependencies+0x190/0x190
> [  823.491667]  __lock_acquire+0x2f7/0x13d0
> [  823.491670]  ? trace_hardirqs_on_caller+0xf4/0x1b0
> [  823.491672]  ? trace_hardirqs_on+0xd/0x10
> [  823.491675]  lock_acquire+0xa3/0x1f0
> [  823.491677]  ? lock_acquire+0xa3/0x1f0
> [  823.491770]  ? xfs_ilock+0x13b/0x220 [xfs]
> [  823.491830]  ? xfs_inactive+0xf5/0x130 [xfs]
> [  823.491836]  down_write_nested+0x55/0xc0
> [  823.491881]  ? xfs_ilock+0x13b/0x220 [xfs]
> [  823.491931]  xfs_ilock+0x13b/0x220 [xfs]
> [  823.491969]  xfs_inactive+0xf5/0x130 [xfs]
> [  823.492005]  xfs_fs_destroy_inode+0xbb/0x2d0 [xfs]
> [  823.492010]  destroy_inode+0x3b/0x60
> [  823.492012]  evict+0x13e/0x1a0
> [  823.492015]  dispose_list+0x56/0x80
> [  823.492017]  prune_icache_sb+0x5a/0x80
> [  823.492019]  super_cache_scan+0x137/0x1b0
> [  823.492023]  shrink_slab.part.43+0x1f4/0x580
> [  823.492027]  shrink_slab+0x1b/0x30
> [  823.492029]  shrink_node+0x102/0x300
> [  823.492032]  kswapd+0x334/0x950
> [  823.492036]  ? mem_cgroup_shrink_node+0x330/0x330
> [  823.492039]  kthread+0x12c/0x150
> [  823.492041]  ? kthread_create_on_node+0x70/0x70
> [  823.492045]  ret_from_fork+0x31/0x40
> [ 1026.411166] perf: interrupt took too long (2551 > 2500), lowering kernel.perf_event_max_sample_rate to 78000
> [ 2420.023556] CGenericAsyncFi (17214) used greatest stack depth: 10920 bytes left
> [ 2538.827693] rundll32.exe (12771) used greatest stack depth: 10616 bytes left
> [ 2624.969163] perf: interrupt took too long (3190 > 3188), lowering kernel.perf_event_max_sample_rate to 62000
> [ 3248.919731] kworker/dying (114) used greatest stack depth: 10248 bytes left

