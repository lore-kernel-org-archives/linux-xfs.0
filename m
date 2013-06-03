Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9955929DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:04:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4389F8F8040
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 20:04:19 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id oFwx1EGFLqzH5mjA for
	<xfs@oss.sgi.com>; Sun, 02 Jun 2013 20:04:16 -0700 (PDT)
Date: Sun, 2 Jun 2013 23:04:11 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1517224799.10311874.1370228651422.JavaMail.root@redhat.com>
In-Reply-To: <20130531060415.GU29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
	<20130530052049.GK29466@dastard>
	<1824023060.8558101.1369892432333.JavaMail.root@redhat.com>
	<1462663454.9294499.1369969415681.JavaMail.root@redhat.com>
	<20130531060415.GU29466@dastard>
Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
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
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com


> There's memory corruption all over the place.  It is most likely
> that trinity is causing this - it's purpose is to trigger corruption
> issues, but they aren't always immediately seen.  If you can trigger
> this xfs trace without trinity having been run and without all the
> RCU/idle/scheduler/cgroup issues occuring at the same time, then
> it's likely to be caused by XFS. But right now, I'd say XFS is just
> an innocent bystander caught in the crossfire. There's nothing I can
> do from an XFS persepctive to track this down...
OK, this can be reproduced by just running LTP and then xfstests without
trinity at all...
[  302.311213] XFS (dm-0): Mounting Filesystem 
[  302.608320] XFS (dm-0): Ending clean mount 
[  303.625760] XFS (dm-2): Mounting Filesystem 
[  303.674648] XFS (dm-2): Ending clean mount 
[  304.247740] XFS (dm-0): Mounting Filesystem 
[  304.563899] XFS (dm-0): Ending clean mount 
[  305.118268] BUG: unable to handle kernel paging request at ffff8801f7067000 
[  305.156637] IP: [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  305.185560] PGD 1ddf067 PUD 20bdf9067 PMD 1f9b56063 PTE 80000001f7067161 
[  305.222852] Oops: 0003 [#1] SMP  
[  305.238742] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  305.615528] CPU 3  
[  305.624597] Pid: 19138, comm: attr Tainted: GF            3.9.4 #1 HP ProLiant DL120 G7 
[  305.667290] RIP: 0010:[<ffffffff813022fa>]  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  305.707799] RSP: 0018:ffff8801da2a7ad8  EFLAGS: 00010282 
[  305.736413] RAX: ffff8801f7034540 RBX: ffff8801d3bba000 RCX: 000000000000d00b 
[  305.774576] RDX: fffffffffffcd4f8 RSI: ffff8801f70673f8 RDI: ffff8801f7067000 
[  305.811143] RBP: ffff8801da2a7b30 R08: 3ee6e8057eed854d R09: 9066aaebe17ba23c 
[  305.847038] R10: 0d8b3a7401f8834f R11: 74c08510ffdf89f6 R12: ffff8801f7034520 
[  305.883189] R13: 00000000000003d8 R14: 0000000000001800 R15: 000000000000007b 
[  305.921160] FS:  00007fbdabf4e740(0000) GS:ffff88020b460000(0000) knlGS:0000000000000000 
[  305.961370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  305.990403] CR2: ffff8801f7067000 CR3: 00000001d3d90000 CR4: 00000000000407e0 
[  306.025585] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  306.061610] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  306.097768] Process attr (pid: 19138, threadinfo ffff8801da2a6000, task ffff8801dfdb3580) 
[  306.138073] Stack: 
[  306.148523]  ffffffffa01691a1 0000000000000000 0000000000000000 ffff8801f7034540 
[  306.187280]  ffff8801f7034520 0000000000000018 ffff8801f7034520 0000000000000000 
[  306.227244]  ffff8801e2425cd0 ffff8801d207e880 ffff8801d3e6ad20 ffff8801da2a7b68 
[  306.267164] Call Trace: 
[  306.280421]  [<ffffffffa01691a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[  306.321077]  [<ffffffffa0169467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[  306.355110]  [<ffffffffa016aa2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[  306.386559]  [<ffffffffa0166850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[  306.420459]  [<ffffffffa0174d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[  306.453034]  [<ffffffffa016778c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[  306.484498]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[  306.511064]  [<ffffffffa0167d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[  306.539972]  [<ffffffffa015da12>] xfs_xattr_set+0x42/0x70 [xfs] 
[  306.570403]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[  306.598333]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[  306.629324]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[  306.655470]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[  306.681365]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[  306.710684]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[  306.740728]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[  306.767873]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[  306.799781]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[  306.831920]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[  306.861316]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  306.894531] Code: 00 00 48 81 fa a8 02 00 00 72 05 40 38 fe 74 41 48 83 ea 20 48 83 ea 20 4c 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 <4c> 89 1f 4c 89 57 08 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4  
[  306.989301] RIP  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  307.016021]  RSP <ffff8801da2a7ad8> 
[  307.033212] CR2: ffff8801f7067000 
[  307.049503] ---[ end trace 94a32a2cfce117d8 ]--- 
[  307.073111] BUG: unable to handle kernel paging request at 0000428200000008 
[  307.107376] IP: [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  307.135985] PGD 0  
[  307.145833] Oops: 0000 [#2] SMP  
[  307.161695] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  307.547533] CPU 3  
[  307.556537] Pid: 18958, comm: sleep Tainted: GF     D      3.9.4 #1 HP ProLiant DL120 G7 
[  307.598058] RIP: 0010:[<ffffffff810c8b00>]  [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  307.638608] RSP: 0018:ffff8801fd1e3e90  EFLAGS: 00010206 
[  307.664796] RAX: 0000428200000000 RBX: ffff8801ff0a5d80 RCX: ffff8801fd1e3fd8 
[  307.700780] RDX: 0000000006936000 RSI: 0000000000000001 RDI: ffff8801d3aef328 
[  307.735921] RBP: ffff8801fd1e3eb0 R08: ffff8801dff5d040 R09: 0000000000000000 
[  307.771698] R10: ffffffffffffff80 R11: 0000000000000246 R12: ffff8801dff5d040 
[  307.808645] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8801dff5d040 
[  307.847144] FS:  00007f3a74a7b740(0000) GS:ffff88020b460000(0000) knlGS:0000000000000000 
[  307.891651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  307.922666] CR2: 0000428200000008 CR3: 00000001d21f7000 CR4: 00000000000407e0 
[  307.961110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  307.999904] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  308.035206] Process sleep (pid: 18958, threadinfo ffff8801fd1e2000, task ffff8801dff5d040) 
[  308.076654] Stack: 
[  308.086497]  0000000000000000 0000000000004a0e ffff8801dff5d040 00007fffa372b608 
[  308.123532]  ffff8801fd1e3f38 ffffffff81066e01 0000000100000000 0000000000000000 
[  308.160362]  00000046b1319ffe 00000046b130dcae ffffffff81087820 ffff88020b46e700 
[  308.197286] Call Trace: 
[  308.209307]  [<ffffffff81066e01>] do_exit+0x7e1/0xa20 
[  308.234897]  [<ffffffff81087820>] ? hrtimer_get_res+0x50/0x50 
[  308.263462]  [<ffffffff8160e341>] ? do_nanosleep+0x61/0xe0 
[  308.291687]  [<ffffffff810670bf>] do_group_exit+0x3f/0xa0 
[  308.318371]  [<ffffffff81067134>] sys_exit_group+0x14/0x20 
[  308.346294]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  308.376928] Code: 00 00 00 74 56 49 8b 84 24 80 04 00 00 48 8d 78 68 e8 25 5b 54 00 49 8b 84 24 80 04 00 00 48 8b 00 48 85 c0 74 1c 31 d2 0f 1f 00 <48> 03 50 08 48 2b 10 48 8b 40 10 48 85 c0 75 f0 48 c1 ea 0a 49  
[  308.480424] RIP  [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  308.509509]  RSP <ffff8801fd1e3e90> 
[  308.527362] CR2: 0000428200000008 
[  308.543697] general protection fault: 0000 [#3] [  308.543760] ---[ end trace 94a32a2cfce117d9 ]--- 
[  308.543761] Fixing recursive fault but reboot is needed! 
SMP  
[  308.618050] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  309.002756] CPU 0  
[  309.012338] Pid: 19138, comm: attr Tainted: GF     D      3.9.4 #1 HP ProLiant DL120 G7 
[  309.056022] RIP: 0010:[<ffffffff8115798b>]  [<ffffffff8115798b>] vma_interval_tree_remove+0x14b/0x240 
[  309.101815] RSP: 0018:ffff8801da2a7670  EFLAGS: 00010202 
[  309.128508] RAX: ffff8801f703d058 RBX: ffff8801fb9f0e00 RCX: 6b6b6b6b6b6b6b6b 
[  309.163784] RDX: 6b6b6b6b6b6b6b6a RSI: ffff8801febdb220 RDI: ffff8801fb9f0e00 
[  309.199476] RBP: ffff8801da2a7688 R08: 0000000000000000 R09: 0000000000017700 
[  309.235490] R10: ffff8801fb9f0e58 R11: 000000000000000e R12: ffff8801fb9f0e00 
[  309.270754] R13: ffff8801febdb238 R14: ffff8801febdb200 R15: ffff8801fb9f2a00 
[  309.307101] FS:  00007fbdabf4e740(0000) GS:ffff88020b400000(0000) knlGS:0000000000000000 
[  309.348288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  309.376730] CR2: 0000000002077840 CR3: 00000001d3d90000 CR4: 00000000000407f0 
[  309.413051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  309.449081] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  309.487646] Process attr (pid: 19138, threadinfo ffff8801da2a6000, task ffff8801dfdb3580) 
[  309.532131] Stack: 
[  309.543173]  ffffffff811613e6 ffff8801d21718c0 ffff8801fb9f0e00 ffff8801da2a76b8 
[  309.582822]  ffffffff811619a0 ffff8801fb9f0e00 00007fbdab776000 0000000000000000 
[  309.621914]  ffff8801da2a7710 ffff8801da2a76f8 ffffffff8115a1d8 0000000000000000 
[  309.659092] Call Trace: 
[  309.671075]  [<ffffffff811613e6>] ? __remove_shared_vm_struct+0x46/0x70 
[  309.704907]  [<ffffffff811619a0>] unlink_file_vma+0x40/0x60 
[  309.732536]  [<ffffffff8115a1d8>] free_pgtables+0x48/0x120 
[  309.760022]  [<ffffffff81164722>] exit_mmap+0xb2/0x170 
[  309.785585]  [<ffffffff8160eda5>] ? __schedule+0x3b5/0x7d0 
[  309.813041]  [<ffffffff8105e377>] mmput+0x67/0xf0 
[  309.837444]  [<ffffffff81066898>] do_exit+0x278/0xa20 
[  309.862503]  [<ffffffff81604989>] ? printk+0x67/0x69 
[  309.888016]  [<ffffffff81063088>] ? console_unlock+0x1e8/0x3f0 
[  309.916848]  [<ffffffff81612034>] oops_end+0xa4/0xe0 
[  309.942105]  [<ffffffff81604212>] no_context+0x263/0x270 
[  309.968280]  [<ffffffff81604292>] __bad_area_nosemaphore+0x73/0x1cc 
[  310.000888]  [<ffffffff816043fe>] bad_area_nosemaphore+0x13/0x15 
[  310.033080]  [<ffffffff81614c0e>] __do_page_fault+0x31e/0x510 
[  310.064304]  [<ffffffffa0161497>] ? kmem_alloc+0x67/0xf0 [xfs] 
[  310.095564]  [<ffffffff81020c2b>] ? save_stack_trace+0x2b/0x50 
[  310.125723]  [<ffffffff81180911>] ? set_track+0x61/0x1b0 
[  310.153458]  [<ffffffff8118176d>] ? init_object+0x3d/0x70 
[  310.182482]  [<ffffffff81614e0e>] do_page_fault+0xe/0x10 
[  310.209285]  [<ffffffff81611498>] page_fault+0x28/0x30 
[  310.234674]  [<ffffffff813022fa>] ? memmove+0x4a/0x1a0 
[  310.260888]  [<ffffffffa01691a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[  310.298854]  [<ffffffffa0169467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[  310.332735]  [<ffffffffa016aa2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[  310.364814]  [<ffffffffa0166850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[  310.398089]  [<ffffffffa0174d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[  310.431514]  [<ffffffffa016778c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[  310.462923]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[  310.489423]  [<ffffffffa0167d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[  310.518114]  [<ffffffffa015da12>] xfs_xattr_set+0x42/0x70 [xfs] 
[  310.548571]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[  310.579571]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[  310.613506]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[  310.640943]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[  310.668401]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[  310.700284]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[  310.727708]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[  310.753288]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[  310.782891]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[  310.812647]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[  310.839684]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  310.870818] Code: 48 89 50 18 48 8b 00 48 83 e0 fc 74 43 48 8b 50 b0 48 2b 50 a8 48 8b 48 40 48 c1 ea 0c 48 8d 54 11 ff 48 8b 48 10 48 85 c9 74 0b <48> 8b 49 18 48 39 ca 48 0f 42 d1 48 8b 48 08 48 85 c9 74 0b 48  
[  310.966164] RIP  [<ffffffff8115798b>] vma_interval_tree_remove+0x14b/0x240 
[  311.000221]  RSP <ffff8801da2a7670> 
[  311.017819] BUG: unable to handle kernel [  311.017973] ---[ end trace 94a32a2cfce117da ]--- 
[  311.017974] Fixing recursive fault but reboot is needed! 
paging request at 00007f7f3985cfe8 
[  311.105330] IP: [<ffffffff81160ff3>] find_vma+0x43/0xa0 
[  311.133081] PGD 0  
[  311.144699] Oops: 0000 [#4] SMP  
[  311.161948] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  311.542611] CPU 1  
[  311.552199] Pid: 17036, comm: systemd-udevd Tainted: GF     D      3.9.4 #1 HP ProLiant DL120 G7 
[  311.596657] RIP: 0010:[<ffffffff81160ff3>]  [<ffffffff81160ff3>] find_vma+0x43/0xa0 
[  311.636364] RSP: 0000:ffff8801d16ede48  EFLAGS: 00010206 
[  311.665124] RAX: 0000000000000000 RBX: 0000000000000014 RCX: ffff8801d16edfd8 
[  311.703530] RDX: 00007f7f3985d000 RSI: 00007fb5f3715a90 RDI: ffff8801d3aee540 
[  311.741784] RBP: ffff8801d16edf38 R08: 0000000000000001 R09: 00007fb5f28317d8 
[  311.777051] R10: 00007fb5f28317d8 R11: 0000000000000246 R12: 0000000000000028 
[  311.813094] R13: 00007fb5f3715a90 R14: ffff8801d16edf58 R15: ffff8801d3aee540 
[  311.848908] FS:  00007fb5f36e0880(0000) GS:ffff88020b420000(0000) knlGS:0000000000000000 
[  311.890296] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  311.919321] CR2: 00007f7f3985cfe8 CR3: 00000001fbef8000 CR4: 00000000000407e0 
[  311.954562] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  311.990646] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  312.026415] Process systemd-udevd (pid: 17036, threadinfo ffff8801d16ec000, task ffff8801f70d8000) 
[  312.071166] Stack: 
[  312.081624]  ffffffff816149f3 ffff8801d12620dc ffff8801f70d8000 ffff8801d3aee5a8 
[  312.119621]  ffff8801d16ede90 ffffffff811b9a9e ffff8801d16418c0 0000000000000008 
[  312.159495]  ffff8801feb0d340 ffff8801d16edea0 ffffffff811b9ba6 ffff8801d16edee8 
[  312.199195] Call Trace: 
[  312.212470]  [<ffffffff816149f3>] ? __do_page_fault+0x103/0x510 
[  312.244953]  [<ffffffff811b9a9e>] ? mntput_no_expire+0x3e/0x120 
[  312.277378]  [<ffffffff811b9ba6>] ? mntput+0x26/0x40 
[  312.302467]  [<ffffffff8119d9e3>] ? __fput+0x183/0x270 
[  312.327922]  [<ffffffff8119db8e>] ? ____fput+0xe/0x10 
[  312.353480]  [<ffffffff81080f2c>] ? task_work_run+0xac/0xe0 
[  312.381167]  [<ffffffff81614e0e>] do_page_fault+0xe/0x10 
[  312.408212]  [<ffffffff81611498>] page_fault+0x28/0x30 
[  312.433289] Code: 47 48 8b 57 08 31 c0 48 85 d2 75 1f eb 44 66 2e 0f 1f 84 00 00 00 00 00 48 3b 72 e0 48 8d 42 e0 73 1d 48 8b 52 10 48 85 d2 74 0f <48> 3b 72 e8 72 e7 48 8b 52 08 48 85 d2 75 f1 48 85 c0 74 10 48  
[  312.528198] RIP  [<ffffffff81160ff3>] find_vma+0x43/0xa0 
[  312.555203]  RSP <ffff8801d16ede48> 
[  312.572391] CR2: 00007f7f3985cfe8 
[  312.588724] ---[ end trace 94a32a2cfce117db ]--- 
[  312.612043] BUG: unable to handle kernel paging request at 0000428200000008 
[  312.646416] IP: [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  312.675123] PGD 0  
[  312.685662] Oops: 0000 [#5] SMP  
[  312.702907] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  313.090194] CPU 2  
[  313.099192] Pid: 17036, comm: systemd-udevd Tainted: GF     D      3.9.4 #1 HP ProLiant DL120 G7 
[  313.143933] RIP: 0010:[<ffffffff810c8b00>]  [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  313.183945] RSP: 0018:ffff8801d16edaf8  EFLAGS: 00010206 
[  313.210509] RAX: 0000428200000000 RBX: ffff8801dfefac00 RCX: ffff8801d16edfd8 
[  313.246545] RDX: 00000000029b7000 RSI: 0000000000000001 RDI: ffff8801d3aee5a8 
[  313.285230] RBP: ffff8801d16edb18 R08: ffff8801f70d8000 R09: 0000000000000000 
[  313.323961] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801f70d8000 
[  313.362768] R13: 0000000000000009 R14: 0000000000000000 R15: ffff8801f70d8000 
[  313.402688] FS:  00007fb5f36e0880(0000) GS:ffff88020b440000(0000) knlGS:0000000000000000 
[  313.445042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  313.474147] CR2: 0000428200000008 CR3: 00000001fbef8000 CR4: 00000000000407e0 
[  313.510209] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  313.545396] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  313.581255] Process systemd-udevd (pid: 17036, threadinfo ffff8801d16ec000, task ffff8801f70d8000) 
[  313.626232] Stack: 
[  313.636139]  0000000000000009 000000000000428c 0000000000000246 0000000000000000 
[  313.672927]  ffff8801d16edba0 ffffffff81066e01 00000001d16edb80 ffffffff81604989 
[  313.709663]  0000000000000010 ffff8801d16edb90 ffff8801d16edb50 ffffffff819f6f88 
[  313.746821] Call Trace: 
[  313.759043]  [<ffffffff81066e01>] do_exit+0x7e1/0xa20 
[  313.784649]  [<ffffffff81604989>] ? printk+0x67/0x69 
[  313.809568]  [<ffffffff81612034>] oops_end+0xa4/0xe0 
[  313.834180]  [<ffffffff81604212>] no_context+0x263/0x270 
[  313.863369]  [<ffffffff81604292>] __bad_area_nosemaphore+0x73/0x1cc 
[  313.896335]  [<ffffffff8160460f>] bad_area+0x43/0x4a 
[  313.924110]  [<ffffffff81614d4c>] __do_page_fault+0x45c/0x510 
[  313.955197]  [<ffffffff81020c2b>] ? save_stack_trace+0x2b/0x50 
[  313.986579]  [<ffffffff81180911>] ? set_track+0x61/0x1b0 
[  314.012728]  [<ffffffff8118176d>] ? init_object+0x3d/0x70 
[  314.039782]  [<ffffffff81606e25>] ? free_debug_processing+0x1de/0x222 
[  314.071858]  [<ffffffff81614e0e>] do_page_fault+0xe/0x10 
[  314.098809]  [<ffffffff81611498>] page_fault+0x28/0x30 
[  314.125269]  [<ffffffff81160ff3>] ? find_vma+0x43/0xa0 
[  314.152148]  [<ffffffff816149f3>] ? __do_page_fault+0x103/0x510 
[  314.181402]  [<ffffffff811b9a9e>] ? mntput_no_expire+0x3e/0x120 
[  314.211469]  [<ffffffff811b9ba6>] ? mntput+0x26/0x40 
[  314.236258]  [<ffffffff8119d9e3>] ? __fput+0x183/0x270 
[  314.262654]  [<ffffffff8119db8e>] ? ____fput+0xe/0x10 
[  314.287521]  [<ffffffff81080f2c>] ? task_work_run+0xac/0xe0 
[  314.315854]  [<ffffffff81614e0e>] do_page_fault+0xe/0x10 
[  314.342280]  [<ffffffff81611498>] page_fault+0x28/0x30 
[  314.368412] Code: 00 00 00 74 56 49 8b 84 24 80 04 00 00 48 8d 78 68 e8 25 5b 54 00 49 8b 84 24 80 04 00 00 48 8b 00 48 85 c0 74 1c 31 d2 0f 1f 00 <48> 03 50 08 48 2b 10 48 8b 40 10 48 85 c0 75 f0 48 c1 ea 0a 49  
[  314.472334] RIP  [<ffffffff810c8b00>] acct_collect+0x60/0x1b0 
[  314.502845]  RSP <ffff8801d16edaf8> 
[  314.520964] CR2: 0000428200000008 
[  314.537469] ---[ end trace 94a32a2cfce117dc ]--- 
[  314.560276] Fixing recursive fault but reboot is needed! 
[  314.598307] ============================================================================= 
[  314.639471] BUG kmalloc-4096 (Tainted: GF     D     ): Padding overwritten. 0xffff8801f7037c28-0xffff8801f7037fff 
[  314.691639] ----------------------------------------------------------------------------- 
[  314.691639]  
[  314.739818] INFO: Slab 0xffffea0007dc0c00 objects=7 used=4 fp=0xffff8801f7031148 flags=0x20000000004081 
[  314.786319] Pid: 302, comm: kworker/0:1H Tainted: GF   B D      3.9.4 #1 
[  314.820301] Call Trace: 
[  314.832314]  [<ffffffff81181ed2>] slab_err+0xc2/0xf0 
[  314.857597]  [<ffffffff810c0007>] ? on_each_cpu_mask+0x47/0x60 
[  314.886444]  [<ffffffff810154cf>] ? dump_trace+0x16f/0x2b0 
[  314.915497]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170 
[  314.949702]  [<ffffffff811820e3>] check_slab+0x73/0x100 
[  314.978505]  [<ffffffff81180007>] ? page_referenced_ksm+0x77/0x1a0 
[  315.012162]  [<ffffffff81606c9e>] free_debug_processing+0x57/0x222 
[  315.045042]  [<ffffffffa0161595>] ? kmem_free+0x35/0x40 [xfs] 
[  315.076862]  [<ffffffffa0161595>] ? kmem_free+0x35/0x40 [xfs] 
[  315.105209]  [<ffffffff81606ea3>] __slab_free+0x3a/0x318 
[  315.132235]  [<ffffffffa0161595>] ? kmem_free+0x35/0x40 [xfs] 
[  315.160550]  [<ffffffffa014e532>] ? xfs_extent_busy_clear_one+0x42/0xd0 [xfs] 
[  315.196283]  [<ffffffffa0161595>] ? kmem_free+0x35/0x40 [xfs] 
[  315.224568]  [<ffffffff8118373f>] kfree+0xff/0x130 
[  315.248848]  [<ffffffffa0161595>] kmem_free+0x35/0x40 [xfs] 
[  315.276362]  [<ffffffffa01a0adf>] xlog_cil_committed+0x9f/0xe0 [xfs] 
[  315.308507]  [<ffffffffa019def0>] xlog_state_do_callback+0x170/0x2c0 [xfs] 
[  315.342483]  [<ffffffffa019e0ae>] xlog_state_done_syncing+0x6e/0x90 [xfs] 
[  315.376540]  [<ffffffffa019e11b>] xlog_iodone+0x4b/0xa0 [xfs] 
[  315.405695]  [<ffffffffa014b866>] xfs_buf_iodone_work+0x46/0xd0 [xfs] 
[  315.437442]  [<ffffffff8107d80f>] process_one_work+0x16f/0x3f0 
[  315.467401]  [<ffffffff8107f360>] worker_thread+0x110/0x3d0 
[  315.497398]  [<ffffffff8107f250>] ? __alloc_workqueue_key+0x500/0x500 
[  315.532523]  [<ffffffff81084240>] kthread+0xc0/0xd0 
[  315.559039]  [<ffffffff81084180>] ? insert_kthread_work+0x40/0x40 
[  315.592030]  [<ffffffff816192ac>] ret_from_fork+0x7c/0xb0 
[  315.621438]  [<ffffffff81084180>] ? insert_kthread_work+0x40/0x40 
[  315.652053] Padding ffff8801f70378f8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.699076] Padding ffff8801f7037908: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.745979] Padding ffff8801f7037918: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.792851] Padding ffff8801f7037928: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.840050] Padding ffff8801f7037938: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.887178] Padding ffff8801f7037948: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.934795] Padding ffff8801f7037958: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  315.982248] Padding ffff8801f7037968: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.030041] Padding ffff8801f7037978: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.080829] Padding ffff8801f7037988: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.131932] Padding ffff8801f7037998: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.183194] Padding ffff8801f70379a8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.233916] Padding ffff8801f70379b8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.281215] Padding ffff8801f70379c8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.328966] Padding ffff8801f70379d8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.376138] Padding ffff8801f70379e8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.422472] Padding ffff8801f70379f8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.469480] Padding ffff8801f7037a08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.516904] Padding ffff8801f7037a18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.564165] Padding ffff8801f7037a28: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.612961] Padding ffff8801f7037a38: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.664073] Padding ffff8801f7037a48: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.715212] Padding ffff8801f7037a58: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.764149] Padding ffff8801f7037a68: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.811182] Padding ffff8801f7037a78: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.858494] Padding ffff8801f7037a88: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.906132] Padding ffff8801f7037a98: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  316.954730] Padding ffff8801f7037aa8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.001916] Padding ffff8801f7037ab8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.049322] Padding ffff8801f7037ac8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.097121] Padding ffff8801f7037ad8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.145051] Padding ffff8801f7037ae8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.196764] Padding ffff8801f7037af8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.247078] Padding ffff8801f7037b08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.297532] Padding ffff8801f7037b18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.345002] Padding ffff8801f7037b28: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.392045] Padding ffff8801f7037b38: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.439071] Padding ffff8801f7037b48: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.485932] Padding ffff8801f7037b58: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.532876] Padding ffff8801f7037b68: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.580171] Padding ffff8801f7037b78: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.627661] Padding ffff8801f7037b88: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.674527] Padding ffff8801f7037b98: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.725010] Padding ffff8801f7037ba8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.775448] Padding ffff8801f7037bb8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.826466] Padding ffff8801f7037bc8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.873530] Padding ffff8801f7037bd8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.920442] Padding ffff8801f7037be8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  317.968769] Padding ffff8801f7037bf8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  318.015333] Padding ffff8801f7037c08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  318.062740] Padding ffff8801f7037c18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  318.109415] Padding ffff8801f7037c28: e0 bd 03 f7 01 88 ff ff ff ff ff ff ff ff ff ff  ................ 
[  318.156333] Padding ffff8801f7037c38: ff ff ff ff ff ff ff ff 80 01 00 00 00 00 00 00  ................ 
[  318.203365] Padding ffff8801f7037c48: cc cc cc cc cc cc cc cc 68 81 03 f7 01 88 ff ff  ........h....... 
[  318.252859] Padding ffff8801f7037c58: 27 1e 2a 81 ff ff ff ff 2f 77 60 81 ff ff ff ff  '.*...../w`..... 
[  318.303185] Padding ffff8801f7037c68: d1 4d 18 81 ff ff ff ff 27 1e 2a 81 ff ff ff ff  .M......'.*..... 
[  318.354505] Padding ffff8801f7037c78: 55 2c 2a 81 ff ff ff ff 0d 30 2a 81 ff ff ff ff  U,*......0*..... 
[  318.404617] Padding ffff8801f7037c88: 77 bf 2a 81 ff ff ff ff a3 07 2a 81 ff ff ff ff  w.*.......*..... 
[  318.451210] Padding ffff8801f7037c98: 08 ec 29 81 ff ff ff ff df c6 19 81 ff ff ff ff  ..)............. 
[  318.497880] Padding ffff8801f7037ca8: d9 c9 19 81 ff ff ff ff 59 93 61 81 ff ff ff ff  ........Y.a..... 
[  318.544873] Padding ffff8801f7037cb8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.592075] Padding ffff8801f7037cc8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.639232] Padding ffff8801f7037cd8: 00 00 00 00 00 00 00 00 00 00 00 00 d7 21 00 00  .............!.. 
[  318.686150] Padding ffff8801f7037ce8: 14 b3 fc ff 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.733295] Padding ffff8801f7037cf8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.780243] Padding ffff8801f7037d08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.829838] Padding ffff8801f7037d18: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.881128] Padding ffff8801f7037d28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.931308] Padding ffff8801f7037d38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  318.979077] Padding ffff8801f7037d48: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.026194] Padding ffff8801f7037d58: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.073630] Padding ffff8801f7037d68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.120712] Padding ffff8801f7037d78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.167629] Padding ffff8801f7037d88: 5a 5a 5a 5a 5a 5a 5a 5a 78 bc 03 f7 01 88 ff ff  ZZZZZZZZx....... 
[  319.214535] Padding ffff8801f7037d98: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................ 
[  319.261416] Padding ffff8801f7037da8: 80 02 00 00 00 00 00 00 cc cc cc cc cc cc cc cc  ................ 
[  319.307982] Padding ffff8801f7037db8: d0 82 03 f7 01 88 ff ff 27 1e 2a 81 ff ff ff ff  ........'.*..... 
[  319.358389] Padding ffff8801f7037dc8: 2f 77 60 81 ff ff ff ff d1 4d 18 81 ff ff ff ff  /w`......M...... 
[  319.409888] Padding ffff8801f7037dd8: 27 1e 2a 81 ff ff ff ff 55 2c 2a 81 ff ff ff ff  '.*.....U,*..... 
[  319.460846] Padding ffff8801f7037de8: 0d 30 2a 81 ff ff ff ff 77 bf 2a 81 ff ff ff ff  .0*.....w.*..... 
[  319.508176] Padding ffff8801f7037df8: a3 07 2a 81 ff ff ff ff 08 ec 29 81 ff ff ff ff  ..*.......)..... 
[  319.555362] Padding ffff8801f7037e08: df c6 19 81 ff ff ff ff d9 c9 19 81 ff ff ff ff  ................ 
[  319.602255] Padding ffff8801f7037e18: 59 93 61 81 ff ff ff ff 00 00 00 00 00 00 00 00  Y.a............. 
[  319.649541] Padding ffff8801f7037e28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.697595] Padding ffff8801f7037e38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.744772] Padding ffff8801f7037e48: 00 00 00 00 d7 21 00 00 14 b3 fc ff 00 00 00 00  .....!.......... 
[  319.791652] Padding ffff8801f7037e58: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.838095] Padding ffff8801f7037e68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.888739] Padding ffff8801f7037e78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.939962] Padding ffff8801f7037e88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  319.991256] Padding ffff8801f7037e98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.039515] Padding ffff8801f7037ea8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.086594] Padding ffff8801f7037eb8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.133629] Padding ffff8801f7037ec8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.180672] Padding ffff8801f7037ed8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.227713] Padding ffff8801f7037ee8: 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ 
[  320.274136] Padding ffff8801f7037ef8: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................ 
[  320.321932] Padding ffff8801f7037f08: ff ff ff ff ff ff ff ff 80 03 00 00 00 00 00 00  ................ 
[  320.370826] Padding ffff8801f7037f18: cc cc cc cc cc cc cc cc 38 84 03 f7 01 88 ff ff  ........8....... 
[  320.420767] Padding ffff8801f7037f28: 27 1e 2a 81 ff ff ff ff 2f 77 60 81 ff ff ff ff  '.*...../w`..... 
[  320.471678] Padding ffff8801f7037f38: d1 4d 18 81 ff ff ff ff 27 1e 2a 81 ff ff ff ff  .M......'.*..... 
[  320.522943] Padding ffff8801f7037f48: 55 2c 2a 81 ff ff ff ff 0d 30 2a 81 ff ff ff ff  U,*......0*..... 
[  320.571368] Padding ffff8801f7037f58: 77 bf 2a 81 ff ff ff ff a3 07 2a 81 ff ff ff ff  w.*.......*..... 
[  320.618584] Padding ffff8801f7037f68: 08 ec 29 81 ff ff ff ff df c6 19 81 ff ff ff ff  ..)............. 
[  320.665595] Padding ffff8801f7037f78: d9 c9 19 81 ff ff ff ff 59 93 61 81 ff ff ff ff  ........Y.a..... 
[  320.713267] Padding ffff8801f7037f88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.759666] Padding ffff8801f7037f98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.806540] Padding ffff8801f7037fa8: 00 00 00 00 00 00 00 00 00 00 00 00 d7 21 00 00  .............!.. 
[  320.854175] Padding ffff8801f7037fb8: 14 b3 fc ff 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.901359] Padding ffff8801f7037fc8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  320.950409] Padding ffff8801f7037fd8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  321.001549] Padding ffff8801f7037fe8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
[  321.052274] Padding ffff8801f7037ff8: 00 00 00 00 00 00 00 00                          ........ 
[  321.099932] FIX kmalloc-4096: Restoring 0xffff8801f70378f8-0xffff8801f7037fff=0x5a 
[  321.099932]  
[  343.457847] general protection fault: 0000 [#6] SMP  
[  343.485571] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  343.867974] CPU 3  
[  343.876992] Pid: 1119, comm: master Tainted: GF   B D      3.9.4 #1 HP ProLiant DL120 G7 
[  343.918848] RIP: 0010:[<ffffffff811e1cb5>]  [<ffffffff811e1cb5>] sys_epoll_ctl+0x135/0x7c0 
[  343.960461] RSP: 0018:ffff8801e2f65ee8  EFLAGS: 00010206 
[  343.986626] RAX: ffff8801e262b580 RBX: ffff8801dff6b840 RCX: ffff8801e2f65fd8 
[  344.025028] RDX: 0000000000000000 RSI: ffffffff8196ff30 RDI: ffff8801e21ed350 
[  344.063326] RBP: ffff8801e2f65f78 R08: 5a5a5a5a5a5a5a5a R09: 0101010101010101 
[  344.103131] R10: 00007fffc305ba30 R11: 0000000000000297 R12: 0000000000000001 
[  344.140479] R13: 0000000000000015 R14: ffff8801d2177bc0 R15: ffff8801e21ed348 
[  344.175959] FS:  00007facb165d840(0000) GS:ffff88020b460000(0000) knlGS:0000000000000000 
[  344.217871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  344.246145] CR2: 00007fbb90d88e70 CR3: 00000001e62c3000 CR4: 00000000000407e0 
[  344.282166] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  344.317848] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  344.353523] Process master (pid: 1119, threadinfo ffff8801e2f64000, task ffff8801e262b580) 
[  344.395286] Stack: 
[  344.405276]  0000000000000001 0000000000000002 ffff8801e18a0f30 00007facb1696821 
[  344.442554]  ffff8801e21ed350 00000001e3390790 ffff8801e21ed348 00000001e3390790 
[  344.479873]  0000000100000015 ffff8801e3390790 ffff8801e3390790 ffff8801e2f65f78 
[  344.516638] Call Trace: 
[  344.529475]  [<ffffffff810e0ef6>] ? __audit_syscall_exit+0x1f6/0x2a0 
[  344.564393]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  344.597127] Code: f8 01 0f 86 45 01 00 00 4c 8b 7c 24 30 4c 89 f8 48 83 c0 08 48 89 c7 48 89 44 24 20 e8 75 c0 42 00 4d 8b 47 68 90 4d 85 c0 74 1d <4d> 3b 70 30 77 0e 72 63 44 89 e8 41 2b 40 38 83 f8 00 7e 4d 4d  
[  344.700053] RIP  [<ffffffff811e1cb5>] sys_epoll_ctl+0x135/0x7c0 
[  344.729172]  RSP <ffff8801e2f65ee8> 
[  344.747188] ---[ end trace 94a32a2cfce117dd ]--- 
[  373.803073] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1 
[  373.844067] drm_kms_helper: panic occurred, switching back to text console 
[  373.882178] ------------[ cut here ]------------ 
[  373.908207] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5a/0x60() 
[  373.948563] Hardware name: ProLiant DL120 G7 
[  373.969969] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) e1000e(F) ixgbe(F) iTCO_vendor_support(F) ptp(F) mdio(F) dca(F) serio_raw(F) hpwdt(F) pcspkr(F) pps_core(F) hpilo(F) lpc_ich(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) sd_mod(F) mgag200(F) ata_generic(F) crc_t10dif(F) i2c_algo_bit(F) pata_acpi(F) drm_kms_helper(F) ttm(F) ata_piix(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[  374.346510] Pid: 8673, comm: ntpd Tainted: GF   B D      3.9.4 #1 
[  374.379076] Call Trace: 
[  374.392291]  <IRQ>  [<ffffffff81060f50>] warn_slowpath_common+0x70/0xa0 
[  374.428962]  [<ffffffff8106103a>] warn_slowpath_null+0x1a/0x20 
[  374.460338]  [<ffffffff8103697a>] native_smp_send_reschedule+0x5a/0x60 
[  374.496389]  [<ffffffff810a0545>] trigger_load_balance+0x175/0x210 
[  374.527311]  [<ffffffff810943af>] scheduler_tick+0xff/0x140 
[  374.555719]  [<ffffffff81071f46>] update_process_times+0x66/0x80 
[  374.585366]  [<ffffffff810ba1c5>] tick_sched_handle.isra.13+0x25/0x60 
[  374.617683]  [<ffffffff810ba241>] tick_sched_timer+0x41/0x60 
[  374.645722]  [<ffffffff81087af4>] __run_hrtimer+0x74/0x1d0 
[  374.673706]  [<ffffffff810ba200>] ? tick_sched_handle.isra.13+0x60/0x60 
[  374.707178]  [<ffffffff810882d7>] hrtimer_interrupt+0xe7/0x220 
[  374.736837]  [<ffffffff8161b0e9>] smp_apic_timer_interrupt+0x69/0x9c 
[  374.768883]  [<ffffffff81619fdd>] apic_timer_interrupt+0x6d/0x80 
[  374.799400]  <EOI>  <NMI>  [<ffffffff816048a8>] ? panic+0x193/0x1d7 
[  374.831195]  [<ffffffff81604812>] ? panic+0xfd/0x1d7 
[  374.855966]  [<ffffffff810f0120>] ? watchdog_enable+0x1e0/0x1e0 
[  374.886109]  [<ffffffff810f01e2>] watchdog_overflow_callback+0xc2/0xd0 
[  374.921097]  [<ffffffff8112a89e>] __perf_event_overflow+0x8e/0x220 
[  374.955486]  [<ffffffff81129729>] ? perf_event_update_userpage+0x19/0x100 
[  374.991471]  [<ffffffff8112b484>] perf_event_overflow+0x14/0x20 
[  375.024211]  [<ffffffff81028c92>] intel_pmu_handle_irq+0x1b2/0x370 
[  375.057297]  [<ffffffff816129ed>] perf_event_nmi_handler+0x1d/0x20 
[  375.089114]  [<ffffffff816121b9>] nmi_handle.isra.0+0x59/0x90 
[  375.117439]  [<ffffffff816122c0>] do_nmi+0xd0/0x310 
[  375.142167]  [<ffffffff81611801>] end_repeat_nmi+0x1e/0x2e 
[  375.169249]  [<ffffffff81610de0>] ? _raw_spin_lock_irqsave+0x30/0x40 
[  375.201372]  [<ffffffff81610de0>] ? _raw_spin_lock_irqsave+0x30/0x40 
[  375.232709]  [<ffffffff81610de0>] ? _raw_spin_lock_irqsave+0x30/0x40 
[  375.264788]  <<EOE>>  [<ffffffff81084f39>] remove_wait_queue+0x19/0x40 
[  375.298191]  [<ffffffff811ae9c1>] poll_freewait+0x71/0xa0 
[  375.324866]  [<ffffffff811af15a>] do_select+0x5ca/0x650 
[  375.351625]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.382475]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.414047]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.445344]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.479068]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.512964]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.547448]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.580977]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.613662]  [<ffffffff811ae760>] ? poll_schedule_timeout+0x70/0x70 
[  375.644540]  [<ffffffff811af3d7>] core_sys_select+0x1f7/0x310 
[  375.673468]  [<ffffffff814ec7f6>] ? sys_sendto+0x126/0x1c0 
[  375.700596]  [<ffffffff8101a309>] ? read_tsc+0x9/0x20 
[  375.726347]  [<ffffffff810b2a28>] ? ktime_get_ts+0x48/0xe0 
[  375.753522]  [<ffffffff8101a309>] ? read_tsc+0x9/0x20 
[  375.779227]  [<ffffffff810b2a28>] ? ktime_get_ts+0x48/0xe0 
[  375.806136]  [<ffffffff811af59e>] sys_select+0xae/0x100 
[  375.833004]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  375.863012] ---[ end trace 94a32a2cfce117de ]-

or this,
[ 7263.377379] XFS (dm-2): Mounting Filesystem 
[ 7263.491740] XFS (dm-2): Ending clean mount 
[ 7265.014356] XFS (dm-0): Mounting Filesystem 
[ 7265.671630] XFS (dm-0): Ending clean mount 
[ 7266.738912] BUG: unable to handle kernel paging request at ffff8800764e0000 
[ 7266.745904] IP: [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[ 7266.751141] PGD 1ddf067 PUD 1de2067 PMD 76520063 PTE 80000000764e0161 
[ 7266.757637] Oops: 0003 [#1] SMP  
[ 7266.760892] Modules linked in: binfmt_misc(F) snd_seq_dummy(F) tun(F) lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) snd_hda_codec_hdmi(F) snd_hda_codec_realtek(F) snd_hda_intel(F) snd_hda_codec(F) snd_hwdep(F) snd_seq(F) e1000e(F) snd_seq_device(F) snd_pcm(F) hp_wmi(F) iTCO_wdt(F) sparse_keymap(F) iTCO_vendor_support(F) snd_page_alloc(F) rfkill(F) ptp(F) snd_timer(F) mei(F) lpc_ich(F) pps_core(F) snd(F) pcspkr(F) i2c_i801(F) mfd_core(F) microcode(F) soundcore(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) cdrom(F) crc_t10dif(F) nouveau(F) video(F) mxm_wmi(F) i2c_algo_bit(F) drm_kms_helper(F) a
 ta_generic(F) ttm(F) ahci(F) pata_acpi(F) drm(F) libahci(F) i2c_core(F) wmi(F) libata(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[ 7266.860252] CPU 3  
[ 7266.862092] Pid: 24364, comm: attr Tainted: GF            3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[ 7266.872091] RIP: 0010:[<ffffffff813022fa>]  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[ 7266.879756] RSP: 0018:ffff880063573ad8  EFLAGS: 00010282 
[ 7266.885057] RAX: ffff88007649c540 RBX: ffff880057665000 RCX: 000000000000d00b 
[ 7266.892182] RDX: fffffffffffbc4f8 RSI: ffff8800764e03f8 RDI: ffff8800764e0000 
[ 7266.899302] RBP: ffff880063573b30 R08: b7fffffbfeffff47 R09: 530000008efffffc 
[ 7266.906422] R10: 0affff42d0000000 R11: 8ffffffc16ffff42 R12: ffff88007649c520 
[ 7266.913549] R13: 00000000000003d8 R14: 0000000000001800 R15: 000000000000007b 
[ 7266.920668] FS:  00007f1b4a778740(0000) GS:ffff88007d180000(0000) knlGS:0000000000000000 
[ 7266.928750] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 7266.934484] CR2: ffff8800764e0000 CR3: 000000006478c000 CR4: 00000000000407e0 
[ 7266.941607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 7266.948734] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[ 7266.955853] Process attr (pid: 24364, threadinfo ffff880063572000, task ffff880062621ac0) 
[ 7266.964020] Stack: 
[ 7266.966029]  ffffffffa028b1a1 0000000000000000 0000000000000000 ffff88007649c540 
[ 7266.973478]  ffff88007649c520 0000000000000018 ffff88007649c520 0000000000000000 
[ 7266.980928]  ffff88005f1fb7b0 ffff88003e8a8840 ffff88005f9476a0 ffff880063573b68 
[ 7266.988376] Call Trace: 
[ 7266.990846]  [<ffffffffa028b1a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[ 7266.998425]  [<ffffffffa028b467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[ 7267.005138]  [<ffffffffa028ca2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[ 7267.011502]  [<ffffffffa0288850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[ 7267.018207]  [<ffffffffa0296d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[ 7267.024745]  [<ffffffffa028978c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[ 7267.031091]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[ 7267.036326]  [<ffffffffa0289d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[ 7267.042163]  [<ffffffffa027fa12>] xfs_xattr_set+0x42/0x70 [xfs] 
[ 7267.048073]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[ 7267.053728]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[ 7267.059903]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[ 7267.065210]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[ 7267.070348]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[ 7267.076263]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[ 7267.081833]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[ 7267.086885]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[ 7267.092890]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[ 7267.098807]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[ 7267.104206]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[ 7267.110205] Code: 00 00 48 81 fa a8 02 00 00 72 05 40 38 fe 74 41 48 83 ea 20 48 83 ea 20 4c 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 <4c> 89 1f 4c 89 57 08 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4  
[ 7267.130148] RIP  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[ 7267.135476]  RSP <ffff880063573ad8> 
[ 7267.138959] CR2: ffff8800764e0000 
[ 7267.142290] general protection fault: 0000 [#2] SMP  
[ 7267.147285] Modules linked in: binfmt_misc(F) snd_seq_dummy(F) tun(F) lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) snd_hda_codec_hdmi(F) snd_hda_codec_realtek(F) snd_hda_intel(F) snd_hda_codec(F) snd_hwdep(F) snd_seq(F) e1000e(F) snd_seq_device(F) snd_pcm(F) hp_wmi(F) iTCO_wdt(F) sparse_keymap(F) iTCO_vendor_support(F) snd_page_alloc(F) rfkill(F) ptp(F) snd_timer(F) mei(F) lpc_ich(F) pps_core(F) snd(F) pcspkr(F) i2c_i801(F) mfd_core(F) microcode(F) soundcore(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) cdrom(F) crc_t10dif(F) nouveau(F) video(F) mxm_wmi(F) i2c_algo_bit(F) drm_kms_helper(F) a
 ta_generic(F) ttm(F) ahci(F) pata_acpi(F) drm(F) libahci(F) i2c_core(F) wmi(F) libata(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[ 7267.246679] CPU 3  
[ 7267.248519] Pid: 24364, comm: attr Tainted: GF            3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[ 7267.258522] RIP: 0010:[<ffffffffa01c4da8>]  [<ffffffffa01c4da8>] nv50_crtc_lut_load+0x98/0x110 [nouveau] 
[ 7267.268031] RSP: 0018:ffff8800635734a0  EFLAGS: 00010046 
[ 7267.273330] RAX: ffff880036e14908 RBX: ffffffff810a3297 RCX: 0000000000000000 
[ 7267.280450] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90010414000 
[ 7267.287570] RBP: ffff8800635734b8 R08: ffffc90010414000 R09: 0000000000000000 
[ 7267.294697] R10: 8b4cc28948c08548 R11: 000000000000ffff R12: ffffc90010414000 
[ 7267.301817] R13: ffff880036e14520 R14: ffff880076abfb10 R15: ffff880076abfbb0 
[ 7267.308938] FS:  00007f1b4a778740(0000) GS:ffff88007d180000(0000) knlGS:0000000000000000 
[ 7267.317017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 7267.322750] CR2: ffff8800764e0000 CR3: 000000006478c000 CR4: 00000000000407e0 
[ 7267.329869] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 7267.336987] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[ 7267.344115] Process attr (pid: 24364, threadinfo ffff880063572000, task ffff880062621ac0) 
[ 7267.352280] Stack: 
[ 7267.354289]  ffff880075c68000 000000000000000f 0000000000000010 ffff880063573570 
[ 7267.361737]  ffffffffa00e62fb ffff8800635735f8 ffffffff8133fa06 0000000000000010 
[ 7267.369186]  ffff880075c70320 ffff880075c68000 ffffffffa01de540 ffff880076abfb10 
[ 7267.376641] Call Trace: 
[ 7267.379089]  [<ffffffffa00e62fb>] drm_fb_helper_setcmap+0x2fb/0x3c0 [drm_kms_helper] 
[ 7267.386822]  [<ffffffff8133fa06>] ? fb_set_var+0x276/0x430 
[ 7267.392305]  [<ffffffff8160dd32>] ? mutex_lock+0x12/0x30 
[ 7267.397613]  [<ffffffff8134268a>] fb_set_cmap+0x6a/0x140 
[ 7267.402923]  [<ffffffff8134ad9c>] fbcon_set_palette+0x13c/0x170 
[ 7267.408838]  [<ffffffff8134dd85>] fbcon_switch+0x3b5/0x550 
[ 7267.414325]  [<ffffffff813becc9>] redraw_screen+0x189/0x260 
[ 7267.419891]  [<ffffffff8133f70e>] ? fb_blank+0x9e/0xc0 
[ 7267.425027]  [<ffffffff8134c4ca>] fbcon_blank+0x20a/0x2d0 
[ 7267.430425]  [<ffffffff810898c2>] ? up+0x32/0x50 
[ 7267.435039]  [<ffffffff81062e84>] ? wake_up_klogd+0x34/0x50 
[ 7267.440609]  [<ffffffff810701f3>] ? __internal_add_timer+0x113/0x130 
[ 7267.446953]  [<ffffffff81070847>] ? internal_add_timer+0x17/0x40 
[ 7267.452956]  [<ffffffff81071b4f>] ? mod_timer+0x10f/0x220 
[ 7267.458354]  [<ffffffff813bf374>] do_unblank_screen+0xb4/0x1e0 
[ 7267.464181]  [<ffffffff813bf4b0>] unblank_screen+0x10/0x20 
[ 7267.469660]  [<ffffffff813034f9>] bust_spinlocks+0x19/0x40 
[ 7267.475144]  [<ffffffff81611fc4>] oops_end+0x34/0xe0 
[ 7267.480103]  [<ffffffff81604212>] no_context+0x263/0x270 
[ 7267.485410]  [<ffffffff81604292>] __bad_area_nosemaphore+0x73/0x1cc 
[ 7267.491671]  [<ffffffff816043fe>] bad_area_nosemaphore+0x13/0x15 
[ 7267.497674]  [<ffffffff81614c0e>] __do_page_fault+0x31e/0x510 
[ 7267.503434]  [<ffffffffa0283497>] ? kmem_alloc+0x67/0xf0 [xfs] 
[ 7267.509266]  [<ffffffff81020c2b>] ? save_stack_trace+0x2b/0x50 
[ 7267.515092]  [<ffffffff81180911>] ? set_track+0x61/0x1b0 
[ 7267.520402]  [<ffffffff8118176d>] ? init_object+0x3d/0x70 
[ 7267.525799]  [<ffffffff81614e0e>] do_page_fault+0xe/0x10 
[ 7267.531109]  [<ffffffff81611498>] page_fault+0x28/0x30 
[ 7267.536246]  [<ffffffff813022fa>] ? memmove+0x4a/0x1a0 
[ 7267.541398]  [<ffffffffa028b1a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[ 7267.548972]  [<ffffffffa028b467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[ 7267.555676]  [<ffffffffa028ca2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[ 7267.562030]  [<ffffffffa0288850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[ 7267.568734]  [<ffffffffa0296d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[ 7267.575264]  [<ffffffffa028978c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[ 7267.581610]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[ 7267.586845]  [<ffffffffa0289d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[ 7267.592685]  [<ffffffffa027fa12>] xfs_xattr_set+0x42/0x70 [xfs] 
[ 7267.598595]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[ 7267.604252]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[ 7267.610429]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[ 7267.615738]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[ 7267.620875]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[ 7267.626791]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[ 7267.632361]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[ 7267.637412]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[ 7267.643415]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[ 7267.649331]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[ 7267.654727]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[ 7267.660726] Code: c1 01 48 83 c0 02 48 83 c7 08 49 83 c0 20 41 81 f9 00 01 00 00 74 4c 4c 8b 13 0f b7 30 0f b7 88 00 02 00 00 0f b7 90 00 04 00 00 <4d> 8b 12 66 c1 ee 02 66 c1 e9 02 66 c1 ea 02 66 41 81 3a 6f 90  
[ 7267.680665] RIP  [<ffffffffa01c4da8>] nv50_crtc_lut_load+0x98/0x110 [nouveau] 
[ 7267.687835]  RSP <ffff8800635734a0> 
[ 7267.691324] ---[ end trace 0ac6265371f9a5bf ]--- 
[ 7287.146356] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3 
[ 7288.185689] Shutting down cpus with NMI 
[ 7288.189526] drm_kms_helper: panic occurred, switching back to text console 
CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
