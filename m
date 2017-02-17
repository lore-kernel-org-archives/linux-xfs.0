Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdBQGxR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 01:53:17 -0500
Date: Fri, 17 Feb 2017 14:53:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/5] xfs: quota deadlock fixes
Message-ID: <20170217065315.GD24562@eguan.usersys.redhat.com>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, Feb 15, 2017 at 10:40:42AM -0500, Brian Foster wrote:
> Hi all,
> 
> This is a collection of several quota related deadlock fixes for
> problems that have been reported to the list recently.
> 
> Patch 1 fixes the low memory quotacheck problem reported by Martin[1].
> Dave is CC'd as he had comments on this particular thread that started a
> discussion, but I hadn't heard anything back since my last response.
> 
> Patch 2 fixes a separate problem I ran into while attempting to
> reproduce Eryu's xfs/305 hang report[2]. 
> 
> Patches 3-5 fix the actual problem reported by Eryu, which is a quotaoff
> deadlock reproduced by xfs/305.
> 
> Further details are included in the individual commit log descriptions.
> Thoughts, reviews, flames appreciated.
> 
> Eryu,
> 
> I've run several hundred iterations of this on your reproducer system
> without reproducing the hang. I have reproduced a reset overnight but
> still haven't been able to grab a stack trace from that occurrence (I'll
> try again today/tonight with better console logging). I suspect this is

I hit a NULL pointer dereference while testing your fix, I was running
xfs/305 for 1000 iterations and host crashed at the 639th run. Not sure
if it's the same issue you've met here. I posted dmesg log at the end of
mail. I haven't tried to see if I can reproduce it on stock linus tree
yet.

On another host, xfs/305 ran for 500 iterations so far without problems,
I'll keep it running for more time.

Thanks,
Eryu

[57779.280327] run fstests xfs/305 at 2017-02-17 14:41:53
[57779.715697] XFS (dm-5): Unmounting Filesystem
[57783.699225] XFS (dm-5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[57783.746222] XFS (dm-5): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[57783.781671] XFS (dm-5): Mounting V5 Filesystem
[57784.004821] XFS (dm-5): Ending clean mount
[57784.040650] XFS (dm-5): Unmounting Filesystem
[57787.791041] XFS (dm-5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[57787.837644] XFS (dm-5): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[57787.872553] XFS (dm-5): Mounting V5 Filesystem
[57787.989184] XFS (dm-5): Ending clean mount
[57788.007960] XFS (dm-5): Quotacheck needed: Please wait.
[57788.142359] XFS (dm-5): Quotacheck: Done.
[57788.294295] XFS (dm-5): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[57808.117713] XFS (dm-5): Unmounting Filesystem
[57808.708484] XFS (dm-5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[57808.754928] XFS (dm-5): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[57808.808546] XFS (dm-5): Mounting V5 Filesystem
[57809.092982] XFS (dm-5): Ending clean mount
[57809.113320] XFS (dm-5): Quotacheck needed: Please wait.
[57810.033450] XFS (dm-5): Quotacheck: Done.
[57811.979626] XFS (dm-5): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[57821.196437] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[57821.235127] IP: xlog_write+0x243/0x7b0 [xfs]
[57821.256325] PGD 0
[57821.256325]
[57821.273804] Oops: 0000 [#1] SMP
[57821.289563] Modules linked in: binfmt_misc xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel iTCO_wdt crypto_simd iTCO_vendor_support glue_helper ipmi_ssif cryptd hpilo hpwdt pcspkr ipmi_si i2c_i801 lpc_ich
[57821.622303]  ioatdma nfsd sg ipmi_devintf shpchp dca pcc_cpufreq ipmi_msghandler wmi acpi_power_meter acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm tg3 uas drm ptp usb_storage serio_raw hpsa crc32c_intel i2c_core pps_core fjes scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[57821.794306] CPU: 3 PID: 29556 Comm: kworker/3:5 Tainted: G        W       4.10.0-rc4.xfs305+ #22
[57821.836074] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[57821.865964] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[57821.891286] task: ffff880804462d00 task.stack: ffffc900072e8000
[57821.917941] RIP: 0010:xlog_write+0x243/0x7b0 [xfs]
[57821.939935] RSP: 0018:ffffc900072ebcc8 EFLAGS: 00010246
[57821.964071] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[57821.996048] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
[57822.028123] RBP: ffffc900072ebd68 R08: 0000000000000600 R09: 0000000000040000
[57822.060083] R10: 0000000000000000 R11: 0000000000000006 R12: 0000000000000000
[57822.092224] R13: ffff880804f302e0 R14: ffff880853288000 R15: ffffc90024a01600
[57822.124209] FS:  0000000000000000(0000) GS:ffff88085fcc0000(0000) knlGS:0000000000000000
[57822.160446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[57822.186144] CR2: 0000000000000008 CR3: 0000000001c09000 CR4: 00000000001406e0
[57822.218143] Call Trace:
[57822.229306]  xlog_cil_push+0x2a6/0x470 [xfs]
[57822.250663]  xlog_cil_push_work+0x15/0x20 [xfs]
[57822.274715]  process_one_work+0x165/0x410
[57822.293371]  worker_thread+0x27f/0x4c0
[57822.310145]  kthread+0x101/0x140
[57822.324549]  ? rescuer_thread+0x3b0/0x3b0
[57822.342527]  ? kthread_park+0x90/0x90
[57822.358856]  ? do_syscall_64+0x165/0x180
[57822.376436]  ret_from_fork+0x2c/0x40
[57822.392427] Code: c8 04 88 5d 83 88 45 82 41 8b 46 08 85 c0 0f 85 f2 02 00 00 41 83 7e 2c ff 0f 84 4c 05 00 00 4c 63 65 bc 49 c1 e4 04 4c 03 65 a0 <41> f6 44 24 08 03 74 18 ba 3e 09 00 00 48 c7 c6 f6 8a 34 a0 48
[57822.477016] RIP: xlog_write+0x243/0x7b0 [xfs] RSP: ffffc900072ebcc8
[57822.505055] CR2: 0000000000000008
[57822.522334] ---[ end trace 041d7b1a49184126 ]---
[57822.548331] Kernel panic - not syncing: Fatal exception
[57822.571795] Kernel Offset: disabled
[57822.593828] ---[ end Kernel panic - not syncing: Fatal exception
[57822.621048] ------------[ cut here ]------------
[57822.641914] WARNING: CPU: 3 PID: 29556 at arch/x86/kernel/smp.c:127 native_smp_send_reschedule+0x3f/0x50
[57822.684393] Modules linked in: binfmt_misc xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel iTCO_wdt crypto_simd iTCO_vendor_support glue_helper ipmi_ssif cryptd hpilo hpwdt pcspkr ipmi_si i2c_i801 lpc_ich
[57823.009497]  ioatdma nfsd sg ipmi_devintf shpchp dca pcc_cpufreq ipmi_msghandler wmi acpi_power_meter acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm tg3 uas drm ptp usb_storage serio_raw hpsa crc32c_intel i2c_core pps_core fjes scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[57823.170780] CPU: 3 PID: 29556 Comm: kworker/3:5 Tainted: G      D W       4.10.0-rc4.xfs305+ #22
[57823.210153] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[57823.239623] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[57823.264951] Call Trace:
[57823.277094]  <IRQ>
[57823.287711]  dump_stack+0x63/0x87
[57823.305098]  __warn+0xd1/0xf0
[57823.318359]  warn_slowpath_null+0x1d/0x20
[57823.336295]  native_smp_send_reschedule+0x3f/0x50
[57823.357374]  trigger_load_balance+0x10f/0x1f0
[57823.376913]  scheduler_tick+0xa3/0xe0
[57823.393249]  ? tick_sched_do_timer+0x70/0x70
[57823.412373]  update_process_times+0x47/0x60
[57823.431660]  tick_sched_handle.isra.18+0x25/0x60
[57823.453341]  tick_sched_timer+0x40/0x70
[57823.470881]  __hrtimer_run_queues+0xf3/0x280
[57823.490170]  hrtimer_interrupt+0xa8/0x1a0
[57823.509122]  local_apic_timer_interrupt+0x35/0x60
[57823.531331]  smp_apic_timer_interrupt+0x38/0x50
[57823.552752]  apic_timer_interrupt+0x93/0xa0
[57823.571887] RIP: 0010:panic+0x1f8/0x239
[57823.589092] RSP: 0018:ffffc900072eba10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[57823.623298] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000006
[57823.655358] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88085fccdfe0
[57823.687307] RBP: ffffc900072eba80 R08: 00000000fffffffe R09: 000000000000915a
[57823.719315] R10: 0000000000000005 R11: 0000000000009159 R12: ffffffff81a2f668
[57823.751391] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000046
[57823.783944]  </IRQ>
[57823.795292]  oops_end+0xb8/0xd0
[57823.812182]  no_context+0x19e/0x3f0
[57823.827792]  ? select_idle_sibling+0x2c/0x3d0
[57823.847287]  __bad_area_nosemaphore+0xee/0x1d0
[57823.867166]  ? __enqueue_entity+0x6c/0x70
[57823.885089]  bad_area_nosemaphore+0x14/0x20
[57823.903814]  __do_page_fault+0x89/0x4a0
[57823.921531]  ? check_preempt_wakeup+0x106/0x230
[57823.941952]  do_page_fault+0x30/0x80
[57823.958382]  page_fault+0x28/0x30
[57823.973847] RIP: 0010:xlog_write+0x243/0x7b0 [xfs]
[57823.996259] RSP: 0018:ffffc900072ebcc8 EFLAGS: 00010246
[57824.019806] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[57824.051819] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
[57824.083915] RBP: ffffc900072ebd68 R08: 0000000000000600 R09: 0000000000040000
[57824.116122] R10: 0000000000000000 R11: 0000000000000006 R12: 0000000000000000
[57824.148050] R13: ffff880804f302e0 R14: ffff880853288000 R15: ffffc90024a01600
[57824.179966]  ? xlog_write+0x762/0x7b0 [xfs]
[57824.198643]  xlog_cil_push+0x2a6/0x470 [xfs]
[57824.217802]  xlog_cil_push_work+0x15/0x20 [xfs]
[57824.238297]  process_one_work+0x165/0x410
[57824.256209]  worker_thread+0x27f/0x4c0
[57824.272976]  kthread+0x101/0x140
[57824.288084]  ? rescuer_thread+0x3b0/0x3b0
[57824.308736]  ? kthread_park+0x90/0x90
[57824.327867]  ? do_syscall_64+0x165/0x180
[57824.345398]  ret_from_fork+0x2c/0x40
[57824.361034] ---[ end trace 041d7b1a49184127 ]---
[57824.381686] ------------[ cut here ]------------
[57824.402342] WARNING: CPU: 3 PID: 29556 at arch/x86/kernel/smp.c:127 native_smp_send_reschedule+0x3f/0x50
[57824.445004] Modules linked in: binfmt_misc xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel iTCO_wdt crypto_simd iTCO_vendor_support glue_helper ipmi_ssif cryptd hpilo hpwdt pcspkr ipmi_si i2c_i801 lpc_ich
[57824.763533]  ioatdma nfsd sg ipmi_devintf shpchp dca pcc_cpufreq ipmi_msghandler wmi acpi_power_meter acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm tg3 uas drm ptp usb_storage serio_raw hpsa crc32c_intel i2c_core pps_core fjes scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[57824.931113] CPU: 3 PID: 29556 Comm: kworker/3:5 Tainted: G      D W       4.10.0-rc4.xfs305+ #22
[57824.970667] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[57824.999927] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[57825.026452] Call Trace:
[57825.037533]  <IRQ>
[57825.046518]  dump_stack+0x63/0x87
[57825.061285]  __warn+0xd1/0xf0
[57825.074564]  warn_slowpath_null+0x1d/0x20
[57825.092513]  native_smp_send_reschedule+0x3f/0x50
[57825.113571]  resched_curr+0xa1/0xc0
[57825.129181]  check_preempt_curr+0x70/0x90
[57825.146768]  ttwu_do_wakeup+0x19/0xe0
[57825.163141]  ttwu_do_activate+0x6f/0x80
[57825.180275]  try_to_wake_up+0x1aa/0x3b0
[57825.197440]  default_wake_function+0x12/0x20
[57825.216596]  pollwake+0x73/0x90
[57825.230654]  ? wake_up_q+0x80/0x80
[57825.246033]  __wake_up_common+0x55/0x90
[57825.263171]  __wake_up+0x39/0x50
[57825.277624]  credit_entropy_bits+0x1fe/0x2a0
[57825.296829]  ? add_interrupt_randomness+0x1b9/0x210
[57825.320068]  add_interrupt_randomness+0x1b9/0x210
[57825.345255]  handle_irq_event_percpu+0x40/0x80
[57825.365728]  handle_irq_event+0x3b/0x60
[57825.382876]  handle_edge_irq+0x8d/0x130
[57825.400120]  handle_irq+0xab/0x130
[57825.415340]  do_IRQ+0x48/0xd0
[57825.428621]  common_interrupt+0x93/0x93
[57825.446017] RIP: 0010:__do_softirq+0x6d/0x28c
[57825.465570] RSP: 0018:ffff88085fcc3f68 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff1b
[57825.499744] RAX: ffff880804462d00 RBX: 0000000000000000 RCX: 0000000000000282
[57825.533033] RDX: 00000000000193fa RSI: 00000000f2fa3225 RDI: 00000000000006e0
[57825.565178] RBP: ffff88085fcc3fb8 R08: 00003496f5963280 R09: 0000000000000000
[57825.597220] R10: 0000000000000003 R11: 0000000000000020 R12: ffffffff81a2f668
[57825.629321] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000046
[57825.661321]  irq_exit+0xd9/0xf0
[57825.675454]  smp_apic_timer_interrupt+0x3d/0x50
[57825.695743]  apic_timer_interrupt+0x93/0xa0
[57825.714467] RIP: 0010:panic+0x1f8/0x239
[57825.731620] RSP: 0018:ffffc900072eba10 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[57825.765508] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000006
[57825.797718] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88085fccdfe0
[57825.831010] RBP: ffffc900072eba80 R08: 00000000fffffffe R09: 000000000000915a
[57825.866503] R10: 0000000000000005 R11: 0000000000009159 R12: ffffffff81a2f668
[57825.898470] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000046
[57825.930824]  </IRQ>
[57825.940296]  oops_end+0xb8/0xd0
[57825.954347]  no_context+0x19e/0x3f0
[57825.969927]  ? select_idle_sibling+0x2c/0x3d0
[57825.989418]  __bad_area_nosemaphore+0xee/0x1d0
[57826.009319]  ? __enqueue_entity+0x6c/0x70
[57826.027283]  bad_area_nosemaphore+0x14/0x20
[57826.046834]  __do_page_fault+0x89/0x4a0
[57826.064164]  ? check_preempt_wakeup+0x106/0x230
[57826.084437]  do_page_fault+0x30/0x80
[57826.100450]  page_fault+0x28/0x30
[57826.115307] RIP: 0010:xlog_write+0x243/0x7b0 [xfs]
[57826.136805] RSP: 0018:ffffc900072ebcc8 EFLAGS: 00010246
[57826.160181] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[57826.192114] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
[57826.224161] RBP: ffffc900072ebd68 R08: 0000000000000600 R09: 0000000000040000
[57826.256406] R10: 0000000000000000 R11: 0000000000000006 R12: 0000000000000000
[57826.288363] R13: ffff880804f302e0 R14: ffff880853288000 R15: ffffc90024a01600
[57826.320430]  ? xlog_write+0x762/0x7b0 [xfs]
[57826.341434]  xlog_cil_push+0x2a6/0x470 [xfs]
[57826.364361]  xlog_cil_push_work+0x15/0x20 [xfs]
[57826.384629]  process_one_work+0x165/0x410
[57826.402564]  worker_thread+0x27f/0x4c0
[57826.419452]  kthread+0x101/0x140
[57826.434012]  ? rescuer_thread+0x3b0/0x3b0
[57826.452045]  ? kthread_park+0x90/0x90
[57826.468470]  ? do_syscall_64+0x165/0x180
[57826.486147]  ret_from_fork+0x2c/0x40
[57826.502218] ---[ end trace 041d7b1a49184128 ]---
