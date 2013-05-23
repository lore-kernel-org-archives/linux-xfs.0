Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5CC829DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 22:21:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C343304059
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 20:21:19 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id YNKvkKMfF7OTNAl4 for
	<xfs@oss.sgi.com>; Wed, 22 May 2013 20:21:17 -0700 (PDT)
Date: Wed, 22 May 2013 23:21:17 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
In-Reply-To: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
Subject: 3.9.3: Oops running xfstests
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
To: xfs@oss.sgi.com
Cc: stable@vger.kernel.org

Fedora-19 based distro and LVM partitions.

[  301.385639] XFS (dm-2): Mounting Filesystem 
[  301.434479] XFS (dm-2): Ending clean mount 
[  301.972477] XFS (dm-0): Mounting Filesystem 
[  302.264395] XFS (dm-0): Ending clean mount 
[  302.819270] BUG: unable to handle kernel paging request at ffff8801fbf19000 
[  302.858096] IP: [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  302.886832] PGD 1ddf067 PUD 20bdf9067 PMD 1fb92e063 PTE 80000001fbf19161 
[  302.923831] Oops: 0003 [#1] SMP  
[  302.939820] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg iTCO_wdt e1000e iTCO_vendor_support ixgbe mdio dca ptp pps_core pcspkr hpwdt hpilo lpc_ich microcode mfd_core xfs libcrc32c sd_mod crc_t10dif ata_generic pata_acpi mgag200 i2c_algo_bit drm_kms_helper ata_piix ttm drm libata i2c_core hpsa dm_mirror dm_region_hash dm_log dm_mod 
[  303.231016] CPU 3  
[  303.240132] Pid: 19129, comm: attr Not tainted 3.9.3 #1 HP ProLiant DL120 G7 
[  303.278111] RIP: 0010:[<ffffffff813022fa>]  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  303.316747] RSP: 0018:ffff8801d1bd5ad8  EFLAGS: 00010286 
[  303.343135] RAX: ffff8801fbeb0020 RBX: ffff8801fd7e0000 RCX: 000000000000d00b 
[  303.381919] RDX: fffffffffff96fd8 RSI: ffff8801fbf193f8 RDI: ffff8801fbf19000 
[  303.420250] RBP: ffff8801d1bd5b30 R08: 7720657079742065 R09: 6c75646f6d202b50 
[  303.459969] R10: 465320646574726f R11: 707075736e75206e R12: ffff8801fbeb0000 
[  303.498346] R13: 00000000000003d8 R14: 0000000000001800 R15: 000000000000007b 
[  303.535369] FS:  00007f0026971740(0000) GS:ffff88020b460000(0000) knlGS:0000000000000000 
[  303.576159] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  303.604432] CR2: ffff8801fbf19000 CR3: 00000001e6403000 CR4: 00000000000407e0 
[  303.640327] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  303.675585] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  303.711631] Process attr (pid: 19129, threadinfo ffff8801d1bd4000, task ffff8801e676b580) 
[  303.753011] Stack: 
[  303.762850]  ffffffffa01971a1 0000000000000000 0000000000000000 ffff8801fbeb0020 
[  303.799908]  ffff8801fbeb0000 0000000000000018 ffff8801fbeb0000 0000000000000000 
[  303.836554]  ffff8801e2066618 ffff8801d3ac2680 ffff8801d16d9a20 ffff8801d1bd5b68 
[  303.874096] Call Trace: 
[  303.886242]  [<ffffffffa01971a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[  303.925533]  [<ffffffffa0197467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[  303.962494]  [<ffffffffa0198a2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[  303.996629]  [<ffffffffa0194850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[  304.033242]  [<ffffffffa01a2d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[  304.069208]  [<ffffffffa019578c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[  304.100911]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[  304.126845]  [<ffffffffa0195d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[  304.156492]  [<ffffffffa018ba12>] xfs_xattr_set+0x42/0x70 [xfs] 
[  304.185868]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[  304.214985]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[  304.245755]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[  304.273386]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[  304.299844]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[  304.329476]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[  304.357290]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[  304.382481]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[  304.412902]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[  304.442884]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[  304.469523]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  304.502054] Code: 00 00 48 81 fa a8 02 00 00 72 05 40 38 fe 74 41 48 83 ea 20 48 83 ea 20 4c 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 <4c> 89 1f 4c 89 57 08 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4  
[  304.605187] RIP  [<ffffffff813022fa>] memmove+0x4a/0x1a0 
[  304.631499]  RSP <ffff8801d1bd5ad8> 
[  304.649339] CR2: ffff8801fbf19000 
[  304.665667] ---[ end trace b3069cd0e14b6ad0 ]--- 
[  304.665670] general protection fault: 0000 [#2] SMP  
[  304.665682] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg iTCO_wdt e1000e iTCO_vendor_support ixgbe mdio dca ptp pps_core pcspkr hpwdt hpilo lpc_ich microcode mfd_core xfs libcrc32c sd_mod crc_t10dif ata_generic pata_acpi mgag200 i2c_algo_bit drm_kms_helper ata_piix ttm drm libata i2c_core hpsa dm_mirror dm_region_hash dm_log dm_mod 
[  304.665684] CPU 2  
[  304.665684] Pid: 1202, comm: rhts-test-runne Tainted: G      D      3.9.3 #1 HP ProLiant DL120 G7 
[  304.665687] RIP: 0010:[<ffffffff812960e2>]  [<ffffffff812960e2>] avc_has_perm_noaudit+0x72/0x110 
[  304.665688] RSP: 0018:ffff8801dee91cd8  EFLAGS: 00010202 
[  304.665688] RAX: 00010a102504ff45 RBX: 0000000000000143 RCX: ffff8801f9a82df0 
[  304.665689] RDX: ffff8801f9a82e10 RSI: 0000000000000004 RDI: 0000000000000143 
[  304.665689] RBP: ffff8801dee91d10 R08: 0000000000000000 R09: ffff8801dee91d34 
[  304.665690] R10: 0000000000000001 R11: ffff880200937800 R12: 0000000000000143 
[  304.665690] R13: 0000000000200000 R14: 0000000000000000 R15: 0000000000000004 
[  304.665691] FS:  00007f7f2c2b7740(0000) GS:ffff88020b440000(0000) knlGS:0000000000000000 
[  304.665692] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  304.665692] CR2: 0000000001d5e0a8 CR3: 00000001def1c000 CR4: 00000000000407e0 
[  304.665693] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  304.665694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  304.665694] Process rhts-test-runne (pid: 1202, threadinfo ffff8801dee90000, task ffff8801e00a5040) 
[  304.665694] Stack: 
[  304.665696]  ffff8801dee91da8 0000000000000296 0000000000200000 0000000000000143 
[  304.665697]  0000000000000000 0000000000000004 ffff8801fb965a00 ffff8801dee91d90 
[  304.665698]  ffffffff8129966c ffff880200000000 ffffffff8105e848 000000d000000002 
[  304.665698] Call Trace: 
[  304.665701]  [<ffffffff8129966c>] cred_has_capability+0x5c/0x100 
[  304.665702]  [<ffffffff8105e848>] ? dup_mm+0x208/0x660 
[  304.665705]  [<ffffffff81178819>] ? alloc_pages_current+0xa9/0x170 
[  304.665706]  [<ffffffff8129973e>] selinux_capable+0x2e/0x40 
[  304.665707]  [<ffffffff81299885>] selinux_vm_enough_memory+0x35/0x50 
[  304.665710]  [<ffffffff81293a83>] security_vm_enough_memory_mm+0x13/0x20 
[  304.665710]  [<ffffffff8105e82f>] dup_mm+0x1ef/0x660 
[  304.665712]  [<ffffffff8105f6a9>] copy_process.part.26+0x9d9/0x13d0 
[  304.665713]  [<ffffffff8106019d>] do_fork+0xad/0x340 
[  304.665714]  [<ffffffff811b7f40>] ? get_unused_fd_flags+0x30/0x40 
[  304.665715]  [<ffffffff810604b6>] sys_clone+0x16/0x20 
[  304.665717]  [<ffffffff816196b9>] stub_clone+0x69/0x90 
[  304.665718]  [<ffffffff81619359>] ? system_call_fastpath+0x16/0x1b 
[  304.665727] Code: db 81 31 c0 65 ff 04 25 00 0a 01 00 48 8d 4a e0 48 85 d2 48 0f 45 c1 eb 0d 48 8b 40 20 48 85 c0 74 3f 48 83 e8 20 48 85 c0 74 36 <3b> 18 75 ea 66 3b 70 08 75 e4 44 3b 60 04 75 de 48 8d 50 0c 48  
[  304.665728] RIP  [<ffffffff812960e2>] avc_has_perm_noaudit+0x72/0x110 
[  304.665729]  RSP <ffff8801dee91cd8> 
[  304.665763] ---[ end trace b3069cd0e14b6ad1 ]--- 
[  304.898489] ============================================================================= 
[  304.898489] BUG kmalloc-4096 (Tainted: G      D     ): Padding overwritten. 0xffff8801fbeb7c28-0xffff8801fbeb7fff 
[  304.898490] ----------------------------------------------------------------------------- 
[  304.898490]  
[  304.898491] INFO: Slab 0xffffea0007efac00 objects=7 used=7 fp=0x          (null) flags=0x20000000004080 
[  304.898492] Pid: 357, comm: systemd-udevd Tainted: G    B D      3.9.3 #1 
[  304.898492] Call Trace: 
[  304.898495]  [<ffffffff81181ed2>] slab_err+0xc2/0xf0 
[  304.898497]  [<ffffffff8118176d>] ? init_object+0x3d/0x70 
[  304.898498]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170 
[  304.898500]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0 
[  304.898501]  [<ffffffff811820e3>] check_slab+0x73/0x100 
[  304.898503]  [<ffffffff81606b50>] alloc_debug_processing+0x21/0x118 
[  304.898504]  [<ffffffff8160772f>] __slab_alloc+0x3b8/0x4a2 
[  304.898506]  [<ffffffff81161b57>] ? vma_link+0xb7/0xc0 
[  304.898508]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0 
[  304.898509]  [<ffffffff81184dd1>] kmem_cache_alloc_trace+0x1b1/0x200 
[  304.898510]  [<ffffffff811bda63>] seq_read+0x2e3/0x3b0 
[  304.898512]  [<ffffffff8119c56c>] vfs_read+0x9c/0x170 
[  304.898513]  [<ffffffff8119c939>] sys_read+0x49/0xa0 
[  304.898514]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
