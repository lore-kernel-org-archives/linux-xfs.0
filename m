Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C1FCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 10:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A468C20578
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 10:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438822AbfJYKYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 06:24:07 -0400
Received: from verein.lst.de ([213.95.11.211]:50475 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438821AbfJYKYH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Oct 2019 06:24:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A1D468B05; Fri, 25 Oct 2019 12:24:04 +0200 (CEST)
Date:   Fri, 25 Oct 2019 12:24:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: softlockup with CONFIG_XFS_ONLINE_SCRUB enabled
Message-ID: <20191025102404.GA12255@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

the current xfs tree seems to easily cause sotlockups in generic/175
(and a few other tests, but not as reproducible) for me.  This is on
20GB 4k block size images on a VM with 4 CPUs and 4G of RAM.

Trace below

generic/175 files ... [ 1815.804060] run fstests generic/175 at 2019-10-25 08:32
[ 1816.168474] XFS (vdb): Mounting V5 Filesystem
[ 1816.674372] XFS (vdb): Ending clean mount
[ 1816.679621] Mounted xfs file system at /mnt/test supports timestamps until 2)
[ 1817.023736] XFS (vdc): Mounting V5 Filesystem
[ 1817.031661] XFS (vdc): Ending clean mount
[ 1817.035755] Mounted xfs file system at /mnt/scratch supports timestamps unti)
[ 1817.061998] XFS (vdc): Unmounting Filesystem
[ 1817.278028] XFS (vdc): Mounting V5 Filesystem
[ 1817.285522] XFS (vdc): Ending clean mount
[ 1817.289734] Mounted xfs file system at /mnt/scratch supports timestamps unti)
[ 1965.113511] XFS (vdc): Unmounting Filesystem
[ 1965.505196] XFS (vdc): Mounting V5 Filesystem
[ 1965.898141] XFS (vdc): Ending clean mount
[ 1965.903121] Mounted xfs file system at /mnt/scratch supports timestamps unti)
[ 2122.950581] XFS (vdb): Unmounting Filesystem
[ 2148.474472] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [xfs_scrub:161]
[ 2148.475763] Modules linked in:
[ 2148.476389] irq event stamp: 41692326
[ 2148.477095] hardirqs last  enabled at (41692325): [<ffffffff8232c3b7>] _raw_0
[ 2148.478878] hardirqs last disabled at (41692326): [<ffffffff81001c5a>] trace0
[ 2148.480493] softirqs last  enabled at (41684994): [<ffffffff8260031f>] __do_e
[ 2148.481977] softirqs last disabled at (41684987): [<ffffffff81127d8c>] irq_e0
[ 2148.483306] CPU: 3 PID: 16189 Comm: xfs_scrub Not tainted 5.4.0-rc3+ #30
[ 2148.484391] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.124
[ 2148.485755] RIP: 0010:_raw_spin_unlock_irqrestore+0x39/0x40
[ 2148.486699] Code: 89 f3 be 01 00 00 00 e8 d5 3a e5 fe 48 89 ef e8 ed 87 e5 f2
[ 2148.489710] RSP: 0018:ffffc9000233f970 EFLAGS: 00000286 ORIG_RAX: ffffffffff3
[ 2148.491004] RAX: ffff88813b398040 RBX: 0000000000000286 RCX: 0000000000000006
[ 2148.492160] RDX: 0000000000000006 RSI: ffff88813b3988c0 RDI: ffff88813b398040
[ 2148.493313] RBP: ffff888137958640 R08: 0000000000000001 R09: 0000000000000000
[ 2148.494466] R10: 0000000000000000 R11: 0000000000000000 R12: ffffea00042b0c00
[ 2148.495600] R13: 0000000000000001 R14: ffff88810ac32308 R15: ffff8881376fc040
[ 2148.497119] FS:  00007f6113dea700(0000) GS:ffff88813bb80000(0000) knlGS:00000
[ 2148.498606] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2148.499553] CR2: 00007f6113de8ff8 CR3: 000000012f290000 CR4: 00000000000006e0
[ 2148.500718] Call Trace:
[ 2148.501145]  free_debug_processing+0x1dd/0x240
[ 2148.501897]  ? xchk_ag_btcur_free+0x76/0xb0
[ 2148.502616]  __slab_free+0x231/0x410
[ 2148.503206]  ? mark_held_locks+0x48/0x70
[ 2148.503863]  ? _raw_spin_unlock_irqrestore+0x37/0x40
[ 2148.504698]  ? debug_check_no_obj_freed+0x110/0x1d7
[ 2148.505511]  ? xchk_ag_btcur_free+0x76/0xb0
[ 2148.506197]  kmem_cache_free+0x30e/0x360
[ 2148.506920]  xchk_ag_btcur_free+0x76/0xb0
[ 2148.507642]  xchk_ag_free+0x10/0x80
[ 2148.508254]  xchk_bmap_iextent_xref.isra.14+0xd9/0x120
[ 2148.509228]  xchk_bmap_iextent+0x187/0x210
[ 2148.510000]  xchk_bmap+0x2e0/0x3b0
[ 2148.510643]  xfs_scrub_metadata+0x2e7/0x500
[ 2148.511421]  xfs_ioc_scrub_metadata+0x4a/0xa0
[ 2148.512166]  xfs_file_ioctl+0x58a/0xcd0
[ 2148.512793]  ? __lock_acquire+0x252/0x1470
[ 2148.513485]  ? find_held_lock+0x2d/0x90
[ 2148.514125]  do_vfs_ioctl+0xa0/0x6f0
[ 2148.514730]  ? __fget+0x101/0x1e0
[ 2148.515279]  ksys_ioctl+0x5b/0x90
[ 2148.515834]  __x64_sys_ioctl+0x11/0x20
[ 2148.516464]  do_syscall_64+0x4b/0x1a0
[ 2148.517077]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 2148.517921] RIP: 0033:0x7f6114a08f07
[ 2148.518525] Code: b3 66 90 48 8b 05 81 5f 2c 00 64 c7 00 26 00 00 00 48 c7 c8
[ 2148.521539] RSP: 002b:00007f6113de97e8 EFLAGS: 00000246 ORIG_RAX: 00000000000
[ 2148.522781] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f6114a08f07
[ 2148.523965] RDX: 00007f6113de9940 RSI: 00000000c040583c RDI: 0000000000000003
[ 2148.525128] RBP: 00007f6113de9940 R08: 000000000000000e R09: 000055761ead0256
[ 2148.526284] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff7c3f41f0
[ 2148.527605] R13: 00007fff7c3f4050 R14: 00007f6113de9800 R15: 0000000000000006

Message from syslogd@localhost at Oct 25 08:43:15 ...
 kernel:[ 2148.474472] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [xfs_s]
[ 2149.498479] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2149.499799] rcu: 	3-....: (6486 ticks this GP) idle=662/1/0x4000000000000 
[ 2149.502054] 	(t=6500 jiffies g=455813 q=201)
[ 2149.503003] NMI backtrace for cpu 3
[ 2149.503787] CPU: 3 PID: 16189 Comm: xfs_scrub Tainted: G             L    5.0
[ 2149.505599] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.124
[ 2149.507451] Call Trace:
[ 2149.508009]  <IRQ>
[ 2149.508473]  dump_stack+0x67/0x90
[ 2149.509170]  nmi_cpu_backtrace.cold.6+0x13/0x50
[ 2149.510184]  ? lapic_can_unplug_cpu.cold.31+0x3e/0x3e
[ 2149.511301]  nmi_trigger_cpumask_backtrace+0x8b/0x98
[ 2149.512400]  rcu_dump_cpu_stacks+0x8c/0xb8
[ 2149.513322]  rcu_sched_clock_irq.cold.91+0x1c0/0x3c0
[ 2149.514418]  ? tick_sched_do_timer+0x50/0x50
[ 2149.515367]  ? rcu_read_lock_sched_held+0x4d/0x60
[ 2149.516416]  ? tick_sched_do_timer+0x50/0x50
[ 2149.517368]  update_process_times+0x1f/0x50
[ 2149.518334]  tick_sched_handle+0x1d/0x50
[ 2149.519205]  tick_sched_timer+0x32/0x70
[ 2149.520063]  __hrtimer_run_queues+0x119/0x3e0
[ 2149.521035]  hrtimer_interrupt+0xef/0x200
[ 2149.521950]  smp_apic_timer_interrupt+0x7c/0x1f0
[ 2149.522980]  apic_timer_interrupt+0xf/0x20
[ 2149.523862]  </IRQ>
[ 2149.524297] RIP: 0010:__slab_alloc.constprop.93+0x4f/0x60
[ 2149.525475] Code: 44 89 e6 e8 13 fa ff ff f6 c7 02 48 89 c5 75 13 53 9d e8 f0
[ 2149.529618] RSP: 0018:ffffc9000233f8f0 EFLAGS: 00000246 ORIG_RAX: ffffffffff3
[ 2149.531338] RAX: ffff88813b398040 RBX: 0000000000000246 RCX: 0000000000000006
[ 2149.532929] RDX: 0000000000000006 RSI: ffff88813b3988c0 RDI: ffff88813b398040
[ 2149.534510] RBP: ffff888109016d28 R08: ffff8881376fc5c0 R09: 0000000000000000
[ 2149.536078] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000002dc0
[ 2149.537707] R13: ffffffff816990d6 R14: ffff88813bbb1780 R15: ffffffff816a271b
[ 2149.539282]  ? xfs_buf_item_init+0x6b/0x220
[ 2149.540218]  ? kmem_zone_alloc+0x96/0x1a0
[ 2149.541115]  ? kmem_zone_alloc+0x96/0x1a0
[ 2149.542018]  kmem_cache_alloc+0x1e2/0x220
[ 2149.542907]  ? xfs_buf_item_init+0x6b/0x220
[ 2149.543844]  kmem_zone_alloc+0x96/0x1a0
[ 2149.544705]  xfs_buf_item_init+0x6b/0x220
[ 2149.545610]  _xfs_trans_bjoin+0x26/0xf0
[ 2149.546468]  xfs_trans_read_buf_map+0x17f/0x5f0
[ 2149.547481]  xfs_read_agi+0xb1/0x1c0
[ 2149.548290]  xfs_ialloc_read_agi+0x45/0x170
[ 2149.549250]  xchk_ag_read_headers+0x29/0xa0
[ 2149.550204]  xchk_ag_init+0x1c/0x30
[ 2149.550988]  xchk_bmap_iextent_xref.isra.14+0x48/0x120
[ 2149.552135]  xchk_bmap_iextent+0x187/0x210
[ 2149.553061]  xchk_bmap+0x2e0/0x3b0
[ 2149.553847]  xfs_scrub_metadata+0x2e7/0x500
[ 2149.554727]  xfs_ioc_scrub_metadata+0x4a/0xa0
[ 2149.555618]  xfs_file_ioctl+0x58a/0xcd0
[ 2149.556496]  ? __lock_acquire+0x252/0x1470
[ 2149.557460]  ? find_held_lock+0x2d/0x90
[ 2149.558342]  do_vfs_ioctl+0xa0/0x6f0
[ 2149.559124]  ? __fget+0x101/0x1e0
[ 2149.559880]  ksys_ioctl+0x5b/0x90
[ 2149.560635]  __x64_sys_ioctl+0x11/0x20
[ 2149.561481]  do_syscall_64+0x4b/0x1a0
[ 2149.562300]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 2149.563426] RIP: 0033:0x7f6114a08f07
[ 2149.564226] Code: b3 66 90 48 8b 05 81 5f 2c 00 64 c7 00 26 00 00 00 48 c7 c8
[ 2149.568334] RSP: 002b:00007f6113de97e8 EFLAGS: 00000246 ORIG_RAX: 00000000000
[ 2149.570071] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f6114a08f07
[ 2149.571718] RDX: 00007f6113de9940 RSI: 00000000c040583c RDI: 0000000000000003
[ 2149.573367] RBP: 00007f6113de9940 R08: 000000000000000e R09: 000055761ead0256
[ 2149.574984] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff7c3f41f0
[ 2149.576633] R13: 00007fff7c3f4050 R14: 00007f6113de9800 R15: 0000000000000006
