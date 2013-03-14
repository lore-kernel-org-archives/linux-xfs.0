Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42E807F37
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 02:39:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27D4C304039
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 00:39:45 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id FUJepDEYO1pnerQy for
	<xfs@oss.sgi.com>; Thu, 14 Mar 2013 00:39:43 -0700 (PDT)
Date: Thu, 14 Mar 2013 03:39:33 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <740792090.842745.1363246773807.JavaMail.root@redhat.com>
In-Reply-To: <20130313044307.GV21651@dastard>
Subject: Re: 3.9-rc2 xfs panic
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

OK, this time I reproduced this panic on both x64 and ppc64
systems with LVM partitions using the default block size as
well as enabling debugging and memory poisoning options.

- ppc64 trace:
(nothing looks like really interesting prior to this)
[ 2221.546337] XFS (dm-0): Corruption detected. Unmount and run xfs_repair
[ 2221.546345] XFS (dm-0): bad inode magic/vsn daddr 64 #8 (magic=5858)
[ 2221.546350] XFS: Assertion failed: 0, file: fs/xfs/xfs_inode.c, line: 416
[ 2221.546383] ------------[ cut here ]------------
[ 2221.546386] kernel BUG at fs/xfs/xfs_message.c:100!
[ 2221.546391] Oops: Exception in kernel mode, sig: 5 [#1]
[ 2221.546394] SMP NR_CPUS=1024 NUMA pSeries
[ 2221.546398] Modules linked in: btrfs raid6_pq xor lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg ibmveth xfs libcrc32c sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[ 2221.546445] NIP: d000000002758bbc LR: d000000002758bbc CTR: 0000000001766760
[ 2221.546449] REGS: c00000000a393780 TRAP: 0700   Not tainted  (3.9.0-rc2+)
[ 2221.546452] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 286b4b24  XER: 0000000e
[ 2221.546463] SOFTE: 1
[ 2221.546465] CFAR: d00000000275881c
[ 2221.546468] TASK = c00000000a423dc0[415] 'kworker/16:1H' THREAD: c00000000a390000 CPU: 16
GPR00: d000000002758bbc c00000000a393a00 d00000000282f770 000000000000003d 
GPR04: 0000000000000000 0000000000000000 0000000000010000 0000000000000000 
GPR08: 0000000000000007 0000000000000000 0000000000000000 0000000000003fef 
GPR12: 00000000286b4b22 c00000000f244000 c0000000000b57e0 c0000000fb6dba90 
GPR16: 0000000000000000 0000000000000000 c0000000e76614b0 d00000000282f770 
GPR20: d00000000282f770 d00000000282f770 d00000000282f770 d00000000282f770 
GPR24: d00000000282f770 d000000002743554 0000000000000020 d000000002802988 
GPR28: c00000005758e700 c0000000e7661290 0000000000000008 c0000000e7423dc8 
[ 2221.546545] NIP [d000000002758bbc] .assfail+0x2c/0x30 [xfs]
[ 2221.546564] LR [d000000002758bbc] .assfail+0x2c/0x30 [xfs]
[ 2221.546568] Call Trace:
[ 2221.546586] [c00000000a393a00] [d000000002758bbc] .assfail+0x2c/0x30 [xfs] (unreliable)
[ 2221.546612] [c00000000a393a70] [d0000000027a8704] .xfs_inode_buf_verify+0x134/0x220 [xfs]
[ 2221.546632] [c00000000a393b50] [d000000002743554] .xfs_buf_iodone_work+0x64/0x150 [xfs]
[ 2221.546639] [c00000000a393bd0] [c0000000000ad830] .process_one_work+0x1b0/0x4c0
[ 2221.546644] [c00000000a393c70] [c0000000000ae078] .worker_thread+0x178/0x470
[ 2221.546649] [c00000000a393d30] [c0000000000b58c8] .kthread+0xe8/0xf0
[ 2221.546654] [c00000000a393e30] [c000000000009f64] .ret_from_kernel_thread+0x64/0x80
[ 2221.546658] Instruction dump:
[ 2221.546662] 60000000 7c0802a6 3d420000 7c691b78 7c862378 e88a90f0 7ca72b78 38600000 
[ 2221.546672] 7d254b78 f8010010 f821ff91 4bfffc09 <0fe00000> 7c0802a6 3ce20000 3d420000 
[ 2221.546685] ---[ end trace fd5756e02a75ba6a ]---
[ 2221.548469] 
[ 2221.548542] Unable to handle kernel paging request for data at address 0xffffffffffffffd8
[ 2221.548552] Faulting instruction address: 0xc0000000000b5cc4
[ 2221.548561] Oops: Kernel access of bad area, sig: 11 [#2]
[ 2221.548577] SMP NR_CPUS=1024 NUMA pSeries
[ 2221.548592] Modules linked in: btrfs raid6_pq xor lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg ibmveth xfs libcrc32c sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[ 2221.548677] NIP: c0000000000b5cc4 LR: c0000000000aede8 CTR: c0000000000d3d80
[ 2221.548685] REGS: c00000000a392e40 TRAP: 0300   Tainted: G      D       (3.9.0-rc2+)
[ 2221.548692] MSR: 8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 426b4b48  XER: 00000001
[ 2221.548714] SOFTE: 0
[ 2221.548718] CFAR: c000000000005f1c
[ 2221.548724] DAR: ffffffffffffffd8, DSISR: 40000000
[ 2221.548732] TASK = c00000000a423dc0[415] 'kworker/16:1H' THREAD: c00000000a390000 CPU: 16
GPR00: c000000000738fac c00000000a3930c0 c000000001114018 c00000000a423dc0 
GPR04: 0000000000000010 c00000000a423e30 0000000000000000 0000000000000001 
GPR08: 0000000000000001 0000000000000000 c000000001352f08 00000000161aad9e 
GPR12: 00000000846b4b44 c00000000f244000 c000000001044018 c00000000008d470 
GPR16: c000000000b04880 c0000000011b4018 c000000001074018 c000000000b04880 
GPR20: c000000000b04880 0000000000c10000 0000000000000010 c000000000b04880 
GPR24: c000000000b04880 0000000000000010 c00000000a424200 c00000000a390000 
GPR28: c00000000117c9d8 c000000000b04880 c000000001714880 0000000000000010 
[ 2221.548853] NIP [c0000000000b5cc4] .kthread_data+0x4/0x10
[ 2221.548862] LR [c0000000000aede8] .wq_worker_sleeping+0x18/0xd0
[ 2221.548868] Call Trace:
[ 2221.548874] [c00000000a3930c0] [c0000000007495a4] .__slab_free+0x84/0x310 (unreliable)
[ 2221.548883] [c00000000a393140] [c000000000738fac] .__schedule+0x6fc/0x940
[ 2221.548891] [c00000000a3933c0] [c00000000008d470] .do_exit+0x730/0xb40
[ 2221.548899] [c00000000a3934c0] [c00000000001e0d4] .die+0x2e4/0x440
[ 2221.548906] [c00000000a393570] [c00000000001e444] ._exception+0x1a4/0x1d0
[ 2221.548913] [c00000000a393710] [c0000000000063c8] program_check_common+0x148/0x180
[ 2221.548994] --- Exception: 700 at .assfail+0x2c/0x30 [xfs]
[ 2221.548994]     LR = .assfail+0x2c/0x30 [xfs]
[ 2221.549043] [c00000000a393a70] [d0000000027a8704] .xfs_inode_buf_verify+0x134/0x220 [xfs]
[ 2221.549086] [c00000000a393b50] [d000000002743554] .xfs_buf_iodone_work+0x64/0x150 [xfs]
[ 2221.549094] [c00000000a393bd0] [c0000000000ad830] .process_one_work+0x1b0/0x4c0
[ 2221.549102] [c00000000a393c70] [c0000000000ae078] .worker_thread+0x178/0x470
[ 2221.549108] [c00000000a393d30] [c0000000000b58c8] .kthread+0xe8/0xf0
[ 2221.549115] [c00000000a393e30] [c000000000009f64] .ret_from_kernel_thread+0x64/0x80
[ 2221.549121] Instruction dump:
[ 2221.549125] ebe1fff8 7c0803a6 4bfffdf4 e92d0258 e92903f8 e869ffc8 7863f7e2 4e800020 
[ 2221.549138] 60000000 60000000 60000000 e92303f8 <e869ffd8> 4e800020 60000000 e92d0258 
[ 2221.549151] ---[ end trace fd5756e02a75ba6b ]---
[ 2221.552003] 
[ 2221.552008] Fixing recursive fault but reboot is needed!
[ 2281.608342] INFO: rcu_sched detected stalls on CPUs/tasks: { 16} (detected by 17, t=6002 jiffies, g=23049, c=23048, q=135)
[ 2281.608362] Task dump for CPU 16:
[ 2281.608367] kworker/16:1H   D 0000000000000000     0   415      2 0x00000800
[ 2281.608374] Call Trace:
[ 2281.608412] [c00000000a393770] [d000000002758bbc] .assfail+0x2c/0x30 [xfs] (unreliable)
[ 2353.528157] sd 0:0:1:0: aborting command. lun 0x8100000000000000, tag 0xc0000000fc142650
[ 2406.758570] sd 0:0:1:0: aborted task tag 0xc0000000fc142650 completed
[ 2461.657815] INFO: rcu_sched detected stalls on CPUs/tasks: { 16} (detected by 18, t=24007 jiffies, g=23049, c=23048, q=511)
[ 2461.657838] Task dump for CPU 16:
[ 2461.657843] kworker/16:1H   D 0000000000000000     0   415      2 0x00000800
[ 2461.657851] Call Trace:
[ 2461.657900] [c00000000a393770] [d000000002758bbc] .assfail+0x2c/0x30 [xfs] (unreliable)

- x64 trace:
[18922.742140] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 964
[18922.744338] ------------[ cut here ]------------
[18922.745267] kernel BUG at fs/xfs/xfs_message.c:100!
[18922.746294] invalid opcode: 0000 [#1] SMP
[18922.747261] Modules linked in: btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) kvm_amd(F) kvm(F) bnx2(F) pcspkr(F) microcode(F) shpchp(F) amd64_edac_mod(F) serio_raw(F) ipmi_si(F) edac_mce_amd(F) hpwdt(F) ipmi_msghandler(F) edac_core(F) k10temp(F) hpilo(F) xfs(F) libcrc32c(F) sr_mod(F) cdrom(F) hpsa(F) radeon(F) ata_generic(F) qla2xxx(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) scsi_transport_fc(F) ttm(F) scsi_tgt(F) drm(F) pata_amd(F) cciss(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F)
[18922.764413] CPU 4
[18922.764815] Pid: 23999, comm: umount Tainted: GF            3.9.0-rc2+ #1 HP ProLiant DL585 G5
[18922.766619] RIP: 0010:[<ffffffffa03807b2>]  [<ffffffffa03807b2>] assfail+0x22/0x30 [xfs]
[18922.768316] RSP: 0018:ffff8801c9575d38  EFLAGS: 00010292
[18922.769482] RAX: 0000000000000077 RBX: ffff88010da1bf08 RCX: ffff88007da8ffe8
[18922.770812] RDX: 0000000000000000 RSI: ffff88007da8e3b8 RDI: 0000000000000246
[18922.772117] RBP: ffff8801c9575d38 R08: ffffffff81a0f320 R09: 00000000000014ce
[18922.773429] R10: 0000000000000000 R11: 00000000000014cd R12: ffff88010da1bf08
[18922.774715] R13: ffff88010da1bdc0 R14: ffff880073e53ab8 R15: ffff880072bfef60
[18922.775998] FS:  00007fde048ed880(0000) GS:ffff88007da80000(0000) knlGS:0000000000000000
[18922.777433] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18922.778446] CR2: 00007fde044c264f CR3: 00000000737c5000 CR4: 00000000000007e0
[18922.779730] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18922.781019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18922.782305] Process umount (pid: 23999, threadinfo ffff8801c9574000, task ffff88019a24d040)
[18922.783836] Stack:
[18922.784236]  ffff8801c9575d68 ffffffffa0381664 ffff8801c9575d68 ffff88010da1bf08
[18922.785773]  ffff88010da1c008 ffffffffa03f3ca0 ffff8801c9575d88 ffffffff811bb37c
[18922.787466]  ffff88010da1bf08 ffff88010da1bf08 ffff8801c9575db8 ffffffff811bb4bf
[18922.788982] Call Trace:
[18922.789541]  [<ffffffffa0381664>] xfs_fs_destroy_inode+0x84/0x140 [xfs]
[18922.790878]  [<ffffffff811bb37c>] destroy_inode+0x3c/0x70
[18922.792087]  [<ffffffff811bb4bf>] evict+0x10f/0x1a0
[18922.792991]  [<ffffffff811bb58e>] dispose_list+0x3e/0x60
[18922.793967]  [<ffffffff811bc058>] evict_inodes+0xb8/0x100
[18922.794937]  [<ffffffff811a3f53>] generic_shutdown_super+0x53/0xf0
[18922.796064]  [<ffffffff811a4020>] kill_block_super+0x30/0x80
[18922.797091]  [<ffffffff811a4407>] deactivate_locked_super+0x57/0x80
[18922.798198]  [<ffffffff811a4f8e>] deactivate_super+0x4e/0x70
[18922.799235]  [<ffffffff811bfb17>] mntput_no_expire+0xd7/0x130
[18922.800310]  [<ffffffff811c09fc>] sys_umount+0x9c/0x3c0
[18922.801273]  [<ffffffff81630399>] system_call_fastpath+0x16/0x1b
[18922.802393] Code: e8 f4 fb ff ff 0f 0b 66 90 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 b0 e0 3f a0 48 89 fa 31 c0 48 89 e5 31 ff e8 1e fc ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
[18922.806375] RIP  [<ffffffffa03807b2>] assfail+0x22/0x30 [xfs]
[18922.807459]  RSP <ffff8801c9575d38>
[18922.824045] ---[ end trace 133202f8e58b0c3c ]---

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
