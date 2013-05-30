Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0AB7A7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 22:45:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B00F5304043
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 20:45:37 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id TaoXTHFspLutJnPQ for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 20:45:31 -0700 (PDT)
Date: Wed, 29 May 2013 23:45:28 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
In-Reply-To: <20130527053608.GS29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
Subject: Re: 3.9.3: Oops running xfstests
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
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

Also reproduced this on 3.9.4 on several different machines.

[  312.686504] BUG: unable to handle kernel paging request at ffff880077434000 
[  312.693518] IP: [<ffffffff81302305>] memmove+0x55/0x1a0 
[  312.698771] PGD 1ddf067 PUD 1de2067 PMD 7748a063 PTE 8000000077434161 
[  312.705284] Oops: 0003 [#1] SMP  
[  312.708550] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e hp_wmi sparse_keymap snd_pcm rfkill ptp iTCO_wdt iTCO_vendor_support pps_core pcspkr mei snd_page_alloc i2c_i801 snd_timer snd lpc_ich soundcore mfd_core microcode xfs libcrc32c sr_mod sd_mod cdrom crc_t10dif nouveau ata_generic video mxm_wmi i2c_algo_bit drm_kms_helper ahci pata_acpi ttm libahci drm libata i2c_core wmi dm_mirror dm_region_hash dm_log dm_mod 
[  312.784678] CPU 3  
[  312.786522] Pid: 19267, comm: attr Not tainted 3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[  312.795590] RIP: 0010:[<ffffffff81302305>]  [<ffffffff81302305>] memmove+0x55/0x1a0 
[  312.803273] RSP: 0018:ffff880051d63ad8  EFLAGS: 00010282 
[  312.808596] RAX: ffff880077325688 RBX: ffff880063c00000 RCX: 000000000000d00b 
[  312.815739] RDX: ffffffffffef1658 RSI: ffff8800774343e0 RDI: ffff880077433fe8 
[  312.822883] RBP: ffff880051d63b30 R08: 8941c085e1178b44 R09: e8a049a0e0c7c748 
[  312.830020] R10: e0be6090e8c03100 R11: 000001bfa049909d R12: ffff880077325668 
[  312.837160] R13: 00000000000003d8 R14: 0000000000001800 R15: 000000000000007b 
[  312.844297] FS:  00007ff3eddd1740(0000) GS:ffff88007d180000(0000) knlGS:0000000000000000 
[  312.852397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  312.858150] CR2: ffff880077434000 CR3: 0000000063c96000 CR4: 00000000000407e0 
[  312.865285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  312.872423] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  312.879565] Process attr (pid: 19267, threadinfo ffff880051d62000, task ffff880051a19ac0) 
[  312.887750] Stack: 
[  312.889764]  ffffffffa02651a1 0000000000000000 0000000000000000 ffff880077325688 
[  312.897233]  ffff880077325668 0000000000000018 ffff880077325668 0000000000000000 
[  312.904700]  ffff8800626e1bd8 ffff880051bccdc0 ffff88004ec26f80 ffff880051d63b68 
[  312.912167] Call Trace: 
[  312.914641]  [<ffffffffa02651a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs] 
[  312.922240]  [<ffffffffa0265467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs] 
[  312.928969]  [<ffffffffa0266a2e>] xfs_attr_leaf_add+0xce/0x170 [xfs] 
[  312.935348]  [<ffffffffa0262850>] xfs_attr_leaf_addname+0xc0/0x3d0 [xfs] 
[  312.942068]  [<ffffffffa0270d4e>] ? xfs_bmap_one_block+0x3e/0xa0 [xfs] 
[  312.948613]  [<ffffffffa026378c>] xfs_attr_set_int+0x30c/0x420 [xfs] 
[  312.954976]  [<ffffffff811be9f4>] ? setxattr+0xa4/0x1c0 
[  312.960224]  [<ffffffffa0263d1f>] xfs_attr_set+0x7f/0x90 [xfs] 
[  312.966077]  [<ffffffffa0259a12>] xfs_xattr_set+0x42/0x70 [xfs] 
[  312.972001]  [<ffffffff811bdef2>] generic_setxattr+0x62/0x80 
[  312.977670]  [<ffffffff811be743>] __vfs_setxattr_noperm+0x63/0x1b0 
[  312.983859]  [<ffffffff811be945>] vfs_setxattr+0xb5/0xc0 
[  312.989179]  [<ffffffff811bea76>] setxattr+0x126/0x1c0 
[  312.994327]  [<ffffffff8118358d>] ? kmem_cache_free+0x1cd/0x1e0 
[  313.000256]  [<ffffffff811a72b2>] ? final_putname+0x22/0x50 
[  313.005834]  [<ffffffff811a74cb>] ? putname+0x2b/0x40 
[  313.010893]  [<ffffffff811ab96f>] ? user_path_at_empty+0x5f/0x90 
[  313.016908]  [<ffffffff8119e5c9>] ? __sb_start_write+0x49/0x100 
[  313.022835]  [<ffffffff811bedef>] sys_lsetxattr+0x8f/0xd0 
[  313.028241]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 
[  313.034252] Code: 40 38 fe 74 41 48 83 ea 20 48 83 ea 20 4c 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 4c 89 1f 4c 89 57 08 4c 89 4f 10 <4c> 89 47 18 48 8d 7f 20 73 d4 48 83 c2 20 e9 a8 00 00 00 0f 1f  
[  313.054228] RIP  [<ffffffff81302305>] memmove+0x55/0x1a0 
[  313.059557]  RSP <ffff880051d63ad8> 
[  313.063045] CR2: ffff880077434000 
[  313.066362] ---[ end trace 76a02834e4697b82 ]--- 
[  313.066368] general protection fault: 0000 [#2] SMP  
[  313.066397] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e hp_wmi sparse_keymap snd_pcm rfkill ptp iTCO_wdt iTCO_vendor_support pps_core pcspkr mei snd_page_alloc i2c_i801 snd_timer snd lpc_ich soundcore mfd_core microcode xfs libcrc32c sr_mod sd_mod cdrom crc_t10dif nouveau ata_generic video mxm_wmi i2c_algo_bit drm_kms_helper ahci pata_acpi ttm libahci drm libata i2c_core wmi dm_mirror dm_region_hash dm_log dm_mod 
[  313.066403] CPU 0  
[  313.066404] Pid: 0, comm: swapper/0 Tainted: G      D      3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[  313.066409] RIP: 0010:[<ffffffff812fd820>]  [<ffffffff812fd820>] timerqueue_add+0x20/0xb0 
[  313.066411] RSP: 0018:ffff88007d003eb0  EFLAGS: 00010002 
[  313.066412] RAX: 53544155415641e5 RBX: ffff88007d00e900 RCX: ffffffffa059ec30 
[  313.066413] RDX: ffffffffa059ec38 RSI: 878b427400407f83 RDI: ffff88007d00e710 
[  313.066414] RBP: ffff88007d003ec0 R08: 00000048a96ae400 R09: 0000000000000000 
[  313.066415] R10: 0000000000000000 R11: 0000000000000005 R12: ffff88007d00e710 
[  313.066416] R13: ffff88007d00e700 R14: ffff88007d00e700 R15: 0000000000000001 
[  313.066417] FS:  0000000000000000(0000) GS:ffff88007d000000(0000) knlGS:0000000000000000 
[  313.066419] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  313.066420] CR2: 0000000000c057a0 CR3: 00000000018fa000 CR4: 00000000000407f0 
[  313.066421] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  313.066422] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  313.066424] Process swapper/0 (pid: 0, threadinfo ffffffff818ee000, task ffffffff81901440) 
[  313.066424] Stack: 
[  313.066427]  ffff88007d00e900 ffff88007d00e900 ffff88007d003ee8 ffffffff81087605 
[  313.066429]  ffff88007d00e900 ffff88007d003f58 ffff88007d00e6c0 ffff88007d003f28 
[  313.066431]  ffffffff81087b1f ffffffff810ba200 ffff88007d00e6c0 ffff88007d00e6c0 
[  313.066431] Call Trace: 
[  313.066433]  <IRQ>  
[  313.066437]  [<ffffffff81087605>] enqueue_hrtimer+0x25/0x80 
[  313.066440]  [<ffffffff81087b1f>] __run_hrtimer+0x9f/0x1d0 
[  313.066443]  [<ffffffff810ba200>] ? tick_sched_handle.isra.13+0x60/0x60 
[  313.066446]  [<ffffffff810882d7>] hrtimer_interrupt+0xe7/0x220 
[  313.066449]  [<ffffffff814b8800>] ? cpufreq_p4_cpu_init+0x290/0x290 
[  313.066452]  [<ffffffff8161b0e9>] smp_apic_timer_interrupt+0x69/0x9c 
[  313.066455]  [<ffffffff81619fdd>] apic_timer_interrupt+0x6d/0x80 
[  313.066457]  <EOI>  
[  313.066459]  [<ffffffff814b9181>] ? cpuidle_wrap_enter+0x41/0x80 
[  313.066461]  [<ffffffff814b91d0>] cpuidle_enter_tk+0x10/0x20 
[  313.066463]  [<ffffffff814b8f32>] cpuidle_idle_call+0xb2/0x1e0 
[  313.066467]  [<ffffffff8101c015>] cpu_idle+0xe5/0x140 
[  313.066470]  [<ffffffff815edb92>] rest_init+0x72/0x80 
[  313.066475]  [<ffffffff81a1bed1>] start_kernel+0x3fd/0x409 
[  313.066477]  [<ffffffff81a1b8dd>] ? repair_env_string+0x5c/0x5c 
[  313.066481]  [<ffffffff81a1b120>] ? early_idt_handlers+0x120/0x120 
[  313.066484]  [<ffffffff81a1b5dc>] x86_64_start_reservations+0x2a/0x2c 
[  313.066486]  [<ffffffff81a1b6d1>] x86_64_start_kernel+0xf3/0x100 
[  313.066505] Code: 31 db eb c6 0f 0b 90 90 90 90 90 55 48 89 e5 41 54 49 89 fc 53 48 3b 36 48 89 f3 75 6c 4c 89 e2 31 c9 eb 1e 0f 1f 80 00 00 00 00 <48> 8b 70 18 48 39 73 18 48 8d 48 08 48 8d 50 10 48 0f 4d d1 48  
[  313.066508] RIP  [<ffffffff812fd820>] timerqueue_add+0x20/0xb0 
[  313.066509]  RSP <ffff88007d003eb0> 
[  313.066511] ---[ end trace 76a02834e4697b83 ]--- 
[  313.066515] Kernel panic - not syncing: Fatal exception in interrupt 
[  313.066516] general protection fault: 0000 [#3] SMP  
[  313.066544] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e hp_wmi sparse_keymap snd_pcm rfkill ptp iTCO_wdt iTCO_vendor_support pps_core pcspkr mei snd_page_alloc i2c_i801 snd_timer snd lpc_ich soundcore mfd_core microcode xfs libcrc32c sr_mod sd_mod cdrom crc_t10dif nouveau ata_generic video mxm_wmi i2c_algo_bit drm_kms_helper ahci pata_acpi ttm libahci drm libata i2c_core wmi dm_mirror dm_region_hash dm_log dm_mod 
[  313.066550] CPU 1  
[  313.066550] Pid: 0, comm: swapper/1 Tainted: G      D      3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[  313.066556] RIP: 0010:[<ffffffff8104bf66>]  [<ffffffff8104bf66>] leave_mm+0x26/0x70 
[  313.066558] RSP: 0018:ffff880079991e38  EFLAGS: 00010002 
[  313.066559] RAX: 5a5a5a5a5a5a5a5a RBX: ffff88007d09b170 RCX: 0000000000000004 
[  313.066560] RDX: ffff8800773aa1c0 RSI: ffffffff8199a7a0 RDI: 0000000000000001 
[  313.066561] RBP: ffff880079991e38 R08: 0000000000000068 R09: 00000000000003d6 
[  313.066562] R10: 0000000000000000 R11: 00000000000003d8 R12: 0000000000000004 
[  313.066563] R13: 0000000000000020 R14: 0000000000000003 R15: ffffffff814b8800 
[  313.066564] FS:  0000000000000000(0000) GS:ffff88007d080000(0000) knlGS:0000000000000000 
[  313.066565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  313.066566] CR2: 00007fc2b88c6e00 CR3: 00000000018fa000 CR4: 00000000000407e0 
[  313.066568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  313.066569] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  313.066570] Process swapper/1 (pid: 0, threadinfo ffff880079990000, task ffff88007996b580) 
[  313.066571] Stack: 
[  313.066573]  ffff880079991e70 ffffffff81358c35 0000000179991e58 ffff88007d09b170 
[  313.066575]  ffffffff8199a7a0 00000048a96b3734 0000000000000004 ffff880079991e80 
[  313.066577]  ffffffff814b8819 ffff880079991eb8 ffffffff814b9172 0000000000000004 
[  313.066578] Call Trace: 
[  313.066582]  [<ffffffff81358c35>] intel_idle+0xf5/0x100 
[  313.066584]  [<ffffffff814b8819>] cpuidle_enter+0x19/0x20 
[  313.066586]  [<ffffffff814b9172>] cpuidle_wrap_enter+0x32/0x80 
[  313.066588]  [<ffffffff814b91d0>] cpuidle_enter_tk+0x10/0x20 
[  313.066590]  [<ffffffff814b8f32>] cpuidle_idle_call+0xb2/0x1e0 
[  313.066593]  [<ffffffff8101c015>] cpu_idle+0xe5/0x140 
[  313.066597]  [<ffffffff815f9a9e>] start_secondary+0x24f/0x251 
[  313.066616] Code: 5d c3 0f 1f 00 66 66 66 66 90 55 65 48 8b 14 25 c0 3c 01 00 65 8b 04 25 c8 3c 01 00 83 f8 01 48 89 e5 74 4c 48 8b 82 c0 02 00 00 <0f> a3 38 19 d2 85 d2 75 09 5d c3 0f 1f 80 00 00 00 00 f0 0f b3  
[  313.066619] RIP  [<ffffffff8104bf66>] leave_mm+0x26/0x70 
[  313.066620]  RSP <ffff880079991e38> 
[  313.066622] ---[ end trace 76a02834e4697b84 ]--- 
[  313.066625] BUG: unable to handle kernel paging request at ffffebe000000020 
[  313.066631] IP: [<ffffffff8130a9e1>] __list_del_entry+0x1/0xd0 
[  313.066632] PGD 0  
[  313.066634] Oops: 0000 [#4] SMP  
[  313.066663] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e hp_wmi sparse_keymap snd_pcm rfkill ptp iTCO_wdt iTCO_vendor_support pps_core pcspkr mei snd_page_alloc i2c_i801 snd_timer snd lpc_ich soundcore mfd_core microcode xfs libcrc32c sr_mod sd_mod cdrom crc_t10dif nouveau ata_generic video mxm_wmi i2c_algo_bit drm_kms_helper ahci pata_acpi ttm libahci drm libata i2c_core wmi dm_mirror dm_region_hash dm_log dm_mod 
[  313.066668] CPU 2  
[  313.066669] Pid: 17, comm: watchdog/2 Tainted: G      D      3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h 
[  313.066673] RIP: 0010:[<ffffffff8130a9e1>]  [<ffffffff8130a9e1>] __list_del_entry+0x1/0xd0 
[  313.066674] RSP: 0018:ffff880079b21d78  EFLAGS: 00010206 
[  313.066675] RAX: 000001e000000000 RBX: ffffebe000000020 RCX: 000000000000f142 
[  313.066676] RDX: ffffea0000000000 RSI: 0000000000000000 RDI: ffffebe000000020 
[  313.066677] RBP: ffff880079b21d90 R08: ffff880079b20000 R09: 0000000000000001 
[  313.066678] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800773af2c0 
[  313.066679] R13: ffff8800773af2c0 R14: 0000000000000000 R15: ffff8800799b3580 
[  313.066681] FS:  0000000000000000(0000) GS:ffff88007d100000(0000) knlGS:0000000000000000 
[  313.066682] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  313.066683] CR2: ffffebe000000020 CR3: 00000000018fa000 CR4: 00000000000407e0 
[  313.066684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  313.066685] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  313.066687] Process watchdog/2 (pid: 17, threadinfo ffff880079b20000, task ffff8800799b3580) 
[  313.066687] Stack: 
[  313.066690]  ffff880079b21d90 ffffffff8130aabd 0000000000000000 ffff880079b21db0 
[  313.066692]  ffffffff8104acd7 0000000000000000 ffff8800773af2c0 ffff880079b21dd8 
[  313.066694]  ffffffff8105de13 0000000000000000 ffff8800773af2c0 ffff880079998000 
[  313.066694] Call Trace: 
[  313.066698]  [<ffffffff8130aabd>] ? list_del+0xd/0x30 
[  313.066701]  [<ffffffff8104acd7>] pgd_free+0x57/0x80 
[  313.066705]  [<ffffffff8105de13>] __mmdrop+0x23/0xa0 
[  313.066709]  [<ffffffff810915aa>] finish_task_switch+0xba/0xe0 
[  313.066712]  [<ffffffff8160eda0>] __schedule+0x3b0/0x7d0 
[  313.066715]  [<ffffffff8160f1e9>] schedule+0x29/0x70 
[  313.066719]  [<ffffffff8108be63>] smpboot_thread_fn+0xd3/0x1a0 
[  313.066722]  [<ffffffff8108bd90>] ? lg_local_lock_cpu+0x40/0x40 
[  313.066724]  [<ffffffff81084240>] kthread+0xc0/0xd0 
[  313.066726]  [<ffffffff81084180>] ? insert_kthread_work+0x40/0x40 
[  313.066729]  [<ffffffff816192ac>] ret_from_fork+0x7c/0xb0 
[  313.066731]  [<ffffffff81084180>] ? insert_kthread_work+0x40/0x40 
[  313.066750] Code: f5 84 81 be 21 00 00 00 48 c7 c7 41 ea 84 81 31 c0 e8 b4 65 d5 ff e9 73 ff ff ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 8b 17 48 b9 00 01 10 00 00 00 ad de 48 8b 47 08 48 89 e5 48  
[  313.066753] RIP  [<ffffffff8130a9e1>] __list_del_entry+0x1/0xd0 
[  313.066754]  RSP <ffff880079b21d78> 
[  313.066754] CR2: ffffebe000000020 
[  313.066756] ---[ end trace 76a02834e4697b85 ]--- 
[  314.133075] Shutting down cpus with NMI 
[  314.136923] drm_kms_helper: panic occurred, switching back to text console 
[  314.143850] ============================================================================= 
[  314.152039] BUG kmalloc-4096 (Tainted: G      D     ): Padding overwritten. 0xffff880077327c28-0xffff880077327fff 
[  314.162310] ----------------------------------------------------------------------------- 
[  314.162310]  
[  314.171975] INFO: Slab 0xffffea0001dcc800 objects=7 used=7 fp=0x          (null) flags=0x10000000004080 
[  314.181380] Pid: 0, comm: swapper/0 Tainted: G    B D      3.9.4 #1 
[  314.187656] Call Trace: 
[  314.190104]  <IRQ>  [<ffffffff81181ed2>] slab_err+0xc2/0xf0 
[  314.195717]  [<ffffffff810c6f4e>] ? is_module_text_address+0xe/0x20 
[  314.201991]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170 
[  314.208269]  [<ffffffffa0107bac>] ? drm_crtc_helper_set_config+0x12c/0xb30 [drm_kms_helper] 
[  314.216625]  [<ffffffff811820e3>] check_slab+0x73/0x100 
[  314.221859]  [<ffffffff81188007>] ? offline_memory_block_cb+0x7/0x30 
[  314.228222]  [<ffffffff81606b50>] alloc_debug_processing+0x21/0x118 
[  314.234498]  [<ffffffff8160772f>] __slab_alloc+0x3b8/0x4a2 
[  314.239995]  [<ffffffffa0107bac>] ? drm_crtc_helper_set_config+0x12c/0xb30 [drm_kms_helper] 
[  314.248353]  [<ffffffff813ca50b>] ? wait_for_xmitr+0x3b/0xa0 
[  314.254021]  [<ffffffff813012ea>] ? delay_tsc+0x4a/0x80 
[  314.259254]  [<ffffffff81301238>] ? __const_udelay+0x28/0x30 
[  314.264926]  [<ffffffff8118474a>] __kmalloc+0x1da/0x220 
[  314.270161]  [<ffffffffa0107bac>] drm_crtc_helper_set_config+0x12c/0xb30 [drm_kms_helper] 
[  314.278342]  [<ffffffff81062e84>] ? wake_up_klogd+0x34/0x50 
[  314.283925]  [<ffffffff810630a7>] ? console_unlock+0x207/0x3f0 
[  314.289775]  [<ffffffffa00a50f3>] drm_mode_set_config_internal+0x23/0x50 [drm] 
[  314.297005]  [<ffffffffa01047b7>] drm_fb_helper_restore_fbdev_mode+0x57/0x80 [drm_kms_helper] 
[  314.305538]  [<ffffffffa0104825>] drm_fb_helper_force_kernel_mode+0x45/0x80 [drm_kms_helper] 
[  314.313981]  [<ffffffffa010515b>] drm_fb_helper_panic+0x2b/0x30 [drm_kms_helper] 
[  314.321382]  [<ffffffff81614e5c>] notifier_call_chain+0x4c/0x70 
[  314.327309]  [<ffffffff81614eba>] atomic_notifier_call_chain+0x1a/0x20 
[  314.333846]  [<ffffffff8160480b>] panic+0xf6/0x1d7 
[  314.338648]  [<ffffffff8161206b>] oops_end+0xdb/0xe0 
[  314.343624]  [<ffffffff810168db>] die+0x4b/0x70 
[  314.348160]  [<ffffffff81611ada>] do_general_protection+0xda/0x160 
[  314.354349]  [<ffffffff81611468>] general_protection+0x28/0x30 
[  314.360201]  [<ffffffffa059ec30>] ? cache_release_pipefs+0x30/0x30 [sunrpc] 
[  314.367177]  [<ffffffffa059ec38>] ? sunrpc_cache_pipe_upcall+0x8/0x1e0 [sunrpc] 
[  314.374489]  [<ffffffff812fd820>] ? timerqueue_add+0x20/0xb0 
[  314.380158]  [<ffffffff81087605>] enqueue_hrtimer+0x25/0x80 
[  314.385738]  [<ffffffff81087b1f>] __run_hrtimer+0x9f/0x1d0 
[  314.391231]  [<ffffffff810ba200>] ? tick_sched_handle.isra.13+0x60/0x60 
[  314.397855]  [<ffffffff810882d7>] hrtimer_interrupt+0xe7/0x220 
[  314.403698]  [<ffffffff814b8800>] ? cpufreq_p4_cpu_init+0x290/0x290 
[  314.409975]  [<ffffffff8161b0e9>] smp_apic_timer_interrupt+0x69/0x9c 
[  314.416340]  [<ffffffff81619fdd>] apic_timer_interrupt+0x6d/0x80 
[  314.422355]  <EOI>  [<ffffffff814b9181>] ? cpuidle_wrap_enter+0x41/0x80 
[  314.428997]  [<ffffffff814b91d0>] cpuidle_enter_tk+0x10/0x20 
[  314.434667]  [<ffffffff814b8f32>] cpuidle_idle_call+0xb2/0x1e0 
[  314.440504]  [<ffffffff8101c015>] cpu_idle+0xe5/0x140 
[  314.445567]  [<ffffffff815edb92>] rest_init+0x72/0x80 
[  314.450629]  [<ffffffff81a1bed1>] start_kernel+0x3fd/0x409 
[  314.456122]  [<ffffffff81a1b8dd>] ? repair_env_string+0x5c/0x5c 
[  314.462055]  [<ffffffff81a1b120>] ? early_idt_handlers+0x120/0x120 
[  314.468246]  [<ffffffff81a1b5dc>] x86_64_start_reservations+0x2a/0x2c 
[  314.474697]  [<ffffffff81a1b6d1>] x86_64_start_kernel+0xf3/0x100 
[  314.480716] Padding ffff8800773278f8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.490117] Padding ffff880077327908: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.499518] Padding ffff880077327918: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.508918] Padding ffff880077327928: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.518312] Padding ffff880077327938: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.527715] Padding ffff880077327948: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.537116] Padding ffff880077327958: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.546511] Padding ffff880077327968: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.555911] Padding ffff880077327978: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.565303] Padding ffff880077327988: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.574700] Padding ffff880077327998: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.584099] Padding ffff8800773279a8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.593491] Padding ffff8800773279b8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.602885] Padding ffff8800773279c8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.612278] Padding ffff8800773279d8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.621680] Padding ffff8800773279e8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.631080] Padding ffff8800773279f8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.640473] Padding ffff880077327a08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.649868] Padding ffff880077327a18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.659263] Padding ffff880077327a28: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.668663] Padding ffff880077327a38: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.678055] Padding ffff880077327a48: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.687453] Padding ffff880077327a58: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.696858] Padding ffff880077327a68: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.706252] Padding ffff880077327a78: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.715649] Padding ffff880077327a88: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.725044] Padding ffff880077327a98: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.734442] Padding ffff880077327aa8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.743846] Padding ffff880077327ab8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.753251] Padding ffff880077327ac8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.762646] Padding ffff880077327ad8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.772043] Padding ffff880077327ae8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.781440] Padding ffff880077327af8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.790844] Padding ffff880077327b08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.800250] Padding ffff880077327b18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.809656] Padding ffff880077327b28: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.819058] Padding ffff880077327b38: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.828454] Padding ffff880077327b48: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.837858] Padding ffff880077327b58: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.847260] Padding ffff880077327b68: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.856666] Padding ffff880077327b78: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.866059] Padding ffff880077327b88: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.875452] Padding ffff880077327b98: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.884847] Padding ffff880077327ba8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.894248] Padding ffff880077327bb8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.903641] Padding ffff880077327bc8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.913036] Padding ffff880077327bd8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.922435] Padding ffff880077327be8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.931835] Padding ffff880077327bf8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.941229] Padding ffff880077327c08: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.950625] Padding ffff880077327c18: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ 
[  314.960029] Padding ffff880077327c28: 58 44 32 44 00 b8 00 08 00 e8 00 08 01 a0 00 08  XD2D............ 
[  314.969430] Padding ffff880077327c38: 00 00 00 00 0c 00 00 8a 01 2e 00 01 00 00 00 10  ................ 
[  314.978827] Padding ffff880077327c48: 00 00 00 00 00 00 00 9d 02 2e 2e 00 00 00 00 20  ...............  
[  314.988230] Padding ffff880077327c58: 00 00 00 00 0c 02 46 f8 09 67 65 74 73 65 62 6f  ......F..getsebo 
[  314.997632] Padding ffff880077327c68: 6f 6c 00 00 00 00 00 30 00 00 00 00 0c 04 3e 14  ol.....0......>. 
[  315.007034] Padding ffff880077327c78: 05 70 61 72 74 78 00 48 00 00 00 00 0c 00 05 bf  .partx.H........ 
[  315.016429] Padding ffff880077327c88: 14 62 75 69 6c 64 2d 6c 6f 63 61 6c 65 2d 61 72  .build-locale-ar 
[  315.025833] Padding ffff880077327c98: 63 68 69 76 65 00 00 58 00 00 00 00 0c 04 0f 98  chive..X........ 
[  315.035237] Padding ffff880077327ca8: 03 6c 69 64 6f 75 00 78 00 00 00 00 0c 04 46 6f  .lidou.x......Fo 
[  315.044633] Padding ffff880077327cb8: 04 68 61 6c 74 00 00 88 00 00 00 00 0c 00 05 c0  .halt........... 
[  315.054031] Padding ffff880077327cc8: 05 7a 64 75 6d 70 00 98 00 00 00 00 0c 04 3e 07  .zdump........>. 
[  315.063435] Padding ffff880077327cd8: 04 66 73 63 6b 00 00 a8 ff ff 00 08 00 00 00 b8  .fsck........... 
[  315.072838] Padding ffff880077327ce8: 00 00 00 00 0c 00 05 c1 03 7a 69 63 00 00 00 c0  .........zic.... 
[  315.082240] Padding ffff880077327cf8: 00 00 00 00 0c 04 0f 97 09 6c 67 72 6f 75 70 6d  .........lgroupm 
[  315.091642] Padding ffff880077327d08: 6f 64 00 00 00 00 00 d0 ff ff 00 08 00 00 00 e8  od.............. 
[  315.101043] Padding ffff880077327d18: 00 00 00 00 0c 00 05 c6 08 6c 64 63 6f 6e 66 69  .........ldconfi 
[  315.110435] Padding ffff880077327d28: 67 00 00 00 00 00 00 f0 00 00 00 00 0c 04 3e 08  g.............>. 
[  315.119827] Padding ffff880077327d38: 0b 66 73 63 6b 2e 63 72 61 6d 66 73 00 00 01 08  .fsck.cramfs.... 
[  315.129218] Padding ffff880077327d48: 00 00 00 00 0c 00 05 c7 03 73 6c 6e 00 00 01 20  .........sln...  
[  315.138611] Padding ffff880077327d58: 00 00 00 00 0c 02 46 f7 0a 67 65 74 65 6e 66 6f  ......F..getenfo 
[  315.148004] Padding ffff880077327d68: 72 63 65 00 00 00 01 30 00 00 00 00 0c 04 3e 09  rce....0......>. 
[  315.157397] Padding ffff880077327d78: 0a 66 73 63 6b 2e 6d 69 6e 69 78 00 00 00 01 48  .fsck.minix....H 
[  315.166793] Padding ffff880077327d88: 00 00 00 00 0c 00 05 c8 19 67 6c 69 62 63 5f 70  .........glibc_p 
[  315.176195] Padding ffff880077327d98: 6f 73 74 5f 75 70 67 72 61 64 65 2e 78 38 36 5f  ost_upgrade.x86_ 
[  315.185589] Padding ffff880077327da8: 36 34 00 00 00 00 01 60 00 00 00 00 0c 04 0f 99  64.....`........ 
[  315.194981] Padding ffff880077327db8: 09 6c 6e 65 77 75 73 65 72 73 64 63 61 3b 01 88  .lnewusersdca;.. 
[  315.204374] Padding ffff880077327dc8: ff ff 00 08 63 61 01 a0 00 00 00 00 0c 02 46 f9  ....ca........F. 
[  315.213777] Padding ffff880077327dd8: 0c 6d 61 74 63 68 70 61 74 68 63 6f 6e 76 01 a8  .matchpathconv.. 
[  315.223179] Padding ffff880077327de8: 00 00 00 00 0c 04 46 70 04 69 6e 69 74 00 01 c0  ......Fp.init... 
[  315.232581] Padding ffff880077327df8: 00 00 00 00 0c 00 05 d5 0b 69 63 6f 6e 76 63 6f  .........iconvco 
[  315.241976] Padding ffff880077327e08: 6e 66 69 67 00 00 01 d0 00 00 00 00 0c 00 05 d5  nfig............ 
[  315.251375] Padding ffff880077327e18: 12 69 63 6f 6e 76 63 6f 6e 66 69 67 2e 78 38 36  .iconvconfig.x86 
[  315.260771] Padding ffff880077327e28: 5f 36 34 be 00 00 01 e8 00 00 00 00 0c 04 0f 9a  _64............. 
[  315.270170] Padding ffff880077327e38: 07 6c 70 61 73 73 77 64 72 73 3b 35 31 61 02 08  .lpasswdrs;51a.. 
[  315.279568] Padding ffff880077327e48: ff ff 00 08 00 00 02 20 00 00 00 00 0c 00 05 da  ....... ........ 
[  315.288971] Padding ffff880077327e58: 05 63 61 70 73 68 02 28 00 00 00 00 0c 04 0f 9b  .capsh.(........ 
[  315.298369] Padding ffff880077327e68: 08 6c 75 73 65 72 61 64 64 35 31 61 32 38 02 38  .luseradd51a28.8 
[  315.307774] Padding ffff880077327e78: ff ff 00 08 00 00 02 50 00 00 00 00 0c 00 05 db  .......P........ 
[  315.317179] Padding ffff880077327e88: 06 67 65 74 63 61 70 00 00 00 00 00 00 00 02 58  .getcap........X 
[  315.326576] Padding ffff880077327e98: 00 00 00 00 0c 04 0f 9c 08 6c 75 73 65 72 64 65  .........luserde 
[  315.335979] Padding ffff880077327ea8: 6c 3b 35 31 61 32 02 70 ff ff 00 08 00 00 02 88  l;51a2.p........ 
[  315.345383] Padding ffff880077327eb8: 00 00 00 00 0c 00 05 dc 08 67 65 74 70 63 61 70  .........getpcap 
[  315.354787] Padding ffff880077327ec8: 73 00 00 00 00 00 02 90 00 00 00 00 0c 04 0f 9d  s............... 
[  315.364190] Padding ffff880077327ed8: 08 6c 75 73 65 72 6d 6f 64 3b 35 31 61 32 02 a8  .lusermod;51a2.. 
[  315.373588] Padding ffff880077327ee8: ff ff 00 08 00 00 02 c0 00 00 00 00 0c 00 05 dd  ................ 
[  315.382993] Padding ffff880077327ef8: 06 73 65 74 63 61 70 00 00 00 00 00 00 00 02 c8  .setcap......... 
[  315.392390] Padding ffff880077327f08: 00 00 00 00 0c 03 0e fe 09 76 70 64 64 65 63 6f  .........vpddeco 
[  315.401794] Padding ffff880077327f18: 64 65 6e 6c 69 73 02 e0 00 00 00 00 0c 04 48 ac  denlis........H. 
[  315.411199] Padding ffff880077327f28: 05 63 72 6f 6e 64 02 f8 00 00 00 00 0c 00 a8 c1  .crond.......... 
[  315.420603] Padding ffff880077327f38: 12 73 65 66 63 6f 6e 74 65 78 74 5f 63 6f 6d 70  .sefcontext_comp 
[  315.430006] Padding ffff880077327f48: 69 6c 65 00 00 00 03 08 00 00 00 00 0c 04 2d a7  ile...........-. 
[  315.439405] Padding ffff880077327f58: 06 63 68 72 6f 6f 74 6f 64 3b 35 31 61 32 03 28  .chrootod;51a2.( 
[  315.448807] Padding ffff880077327f68: ff ff 00 08 63 61 03 40 00 00 00 00 0c 00 a8 c2  ....ca.@........ 
[  315.458205] Padding ffff880077327f78: 0c 69 6e 73 74 61 6c 6c 2d 69 6e 66 6f 00 03 48  .install-info..H 
[  315.467609] Padding ffff880077327f88: 00 00 00 00 0c 04 2d c9 08 66 61 69 6c 6c 6f 63  ......-..failloc 
[  315.477012] Padding ffff880077327f98: 6b 31 61 32 38 64 03 60 ff ff 00 08 00 00 03 78  k1a28d.`.......x 
[  315.486408] Padding ffff880077327fa8: 00 00 00 00 0c 00 a8 cb 09 63 68 6b 63 6f 6e 66  .........chkconf 
[  315.495804] Padding ffff880077327fb8: 69 67 00 00 00 00 03 80 00 00 00 00 0c 04 2d cb  ig............-. 
[  315.505209] Padding ffff880077327fc8: 11 70 61 6d 5f 63 6f 6e 73 6f 6c 65 5f 61 70 70  .pam_console_app 
[  315.514605] Padding ffff880077327fd8: 6c 79 38 64 63 61 03 98 00 00 00 00 0c 00 a8 cc  ly8dca.......... 
[  315.524008] Padding ffff880077327fe8: 0c 61 6c 74 65 72 6e 61 74 69 76 65 73 00 03 b8  .alternatives... 
[  315.533408] Padding ffff880077327ff8: 00 00 00 00 0c 02 46 fa                          ......F. 
[  315.542107] FIX kmalloc-4096: Restoring 0xffff8800773278f8-0xffff880077327fff=0x5a

System information is below:

+ cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=1984960k,nr_inodes=496240,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
/dev/mapper/rhel_hp--xw9400--02-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=32,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
tmpfs /tmp tmpfs rw,seclabel 0 0
/dev/mapper/rhel_hp--xw9400--02-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
+ echo
+ lscpu

Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                12
On-line CPU(s) list:   0-11
Thread(s) per core:    1
Core(s) per socket:    6
Socket(s):             2
NUMA node(s):          2
Vendor ID:             AuthenticAMD
CPU family:            16
Model:                 8
Model name:            Six-Core AMD Opteron(tm) Processor 2427
Stepping:              0
CPU MHz:               800.000
BogoMIPS:              4400.02
Virtualization:        AMD-V
L1d cache:             64K
L1i cache:             64K
L2 cache:              512K
L3 cache:              6144K
NUMA node0 CPU(s):     0,2,4,6,8,10
NUMA node1 CPU(s):     1,3,5,7,9,11
+ echo
+ cat /proc/partitions

major minor  #blocks  name

  11        0       1536 sr0
   8        0   39082680 sda
   8        1     512000 sda1
   8        2   38568960 sda2
 253        0    4063232 dm-0
   8       16   35566480 sdb
   8       17   35564544 sdb1
 253        1   47079424 dm-1
 253        2   22986752 dm-2
+ echo
+ pvdisplay

  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel_hp-xw9400-02
  PV Size               36.78 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              9416
  Free PE               0
  Allocated PE          9416
  PV UUID               8MvTYN-OaUs-a7K4-yF0W-k1G6-eItC-ndZDel
   
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               rhel_hp-xw9400-02
  PV Size               33.92 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              8682
  Free PE               0
  Allocated PE          8682
  PV UUID               43zey8-rZMQ-VCO3-PnTM-fb8v-3IJF-LA9FvI
   
+ echo

+ vgdisplay
  --- Volume group ---
  VG Name               rhel_hp-xw9400-02
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               70.70 GiB
  PE Size               4.00 MiB
  Total PE              18098
  Alloc PE / Size       18098 / 70.70 GiB
  Free  PE / Size       0 / 0   
  VG UUID               923eYU-qAJR-kRbj-MYwR-zBeh-2lP8-ZyhOfF
   
+ echo

+ lvdisplay
  --- Logical volume ---
  LV Path                /dev/rhel_hp-xw9400-02/swap
  LV Name                swap
  VG Name                rhel_hp-xw9400-02
  LV UUID                FvWm56-fypL-T2du-CxVW-riyL-tO06-8dLBUH
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                3.88 GiB
  Current LE             992
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/rhel_hp-xw9400-02/home
  LV Name                home
  VG Name                rhel_hp-xw9400-02
  LV UUID                8VXYot-OHHf-WaXA-RlFj-I9b5-7qhc-zGZ5Qx
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                21.92 GiB
  Current LE             5612
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/rhel_hp-xw9400-02/root
  LV Name                root
  VG Name                rhel_hp-xw9400-02
  LV UUID                R5qalV-W0Dw-3C0S-JfUE-ubnB-plP9-j6Gf8D
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                44.90 GiB
  Current LE             11494
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
