Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4B1R6SI109382 for <xfs@oss.sgi.com>; Thu, 10 May 2012 20:27:06 -0500
Received: from boosthardware.localdomain (boosthardware.com [88.198.122.139])
	by cuda.sgi.com with ESMTP id ABLHHWnNqREsDdh4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 May 2012 18:27:04 -0700 (PDT)
Message-ID: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
Date: Fri, 11 May 2012 03:27:02 +0200 (CEST)
Subject: file corruption issue
From: "Patrick Shirkey" <pshirkey@boosthardware.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I have some HP machines running centos:

kernel 2.6.32-042stab049.6
AMD Opteron(tm) Processor 6180 SE
RAM:   528 GB
RAID bus controller: Hewlett-Packard Company Smart Array G6 controllers

We have experienced some kernel crashes due to a kernel bug with
interleaving ram on this hardware which require hard reset of the
machines.

After reboot we are finding that there is severe file corruption on the
xfs file system where TBs of readonly databases are getting partially or
fully truncated.

Has anyone come across this or similar?

We don't think it is related to write cache due to the amount of data that
is being corrupted.


rgds,

--
Patrick Shirkey
Boost Hardware Ltd


Kernel trace below:

======
May 10 20:49:42 h4 kernel: [586068.444002] BUG: soft lockup - CPU#0 stuck
for 67s! [python:173511]
May 10 20:49:42 h4 kernel: [586068.444002] Modules linked in: vzethdev
simfs vzrst vzcpt nfs lockd fscache nfs_acl auth_rpcgss vzdquota
ip6table_mangle xt_length xt_hl xt_tcpmss xt_TCPMSS xt_multiport xt_limit
xt_dscp vzevent mptctl mptbase autofs4 sunrpc vznetdev vzmon vzdev bonding
ipt_REJECT iptable_filter iptable_mangle ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 xfs
exportfs power_meter hpilo hpwdt netxen_nic microcode sg serio_raw k10temp
amd64_edac_mod edac_core edac_mce_amd i2c_piix4 shpchp ext4 mbcache jbd2
sd_mod crc_t10dif sr_mod cdrom hpsa ata_generic pata_acpi pata_atiixp ahci
radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: mperf]
May 10 20:49:42 h4 kernel: [586068.444002] CPU 0
May 10 20:49:42 h4 kernel: [586068.444002] Modules linked in: vzethdev
simfs vzrst vzcpt nfs lockd fscache nfs_acl auth_rpcgss vzdquota
ip6table_mangle xt_length xt_hl xt_tcpmss xt_TCPMSS xt_multiport xt_limit
xt_dscp vzevent mptctl mptbase autofs4 sunrpc vznetdev vzmon vzdev bonding
ipt_REJECT iptable_filter iptable_mangle ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 xfs
exportfs power_meter hpilo hpwdt netxen_nic microcode sg serio_raw k10temp
amd64_edac_mod edac_core edac_mce_amd i2c_piix4 shpchp ext4 mbcache jbd2
sd_mod crc_t10dif sr_mod cdrom hpsa ata_generic pata_acpi pata_atiixp ahci
radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: mperf]
May 10 20:49:42 h4 kernel: [586068.444002]
May 10 20:49:42 h4 kernel: [586068.444002] Pid: 173511, comm: python veid:
430 Not tainted 2.6.32-042stab049.6 #1 042stab049_6 HP ProLiant DL585 G7
May 10 20:49:42 h4 kernel: [586068.444002] RIP: 0010:[<ffffffff8114033e>] 
[<ffffffff8114033e>] shrink_zone+0x21e/0x9a0
May 10 20:49:42 h4 kernel: [586068.444002] RSP: 0000:ffff8818fecab9a8 
EFLAGS: 00000286
May 10 20:49:42 h4 kernel: [586068.444002] RAX: ffff8850400192a8 RBX:
ffff8818fecaba68 RCX: ffff8818fecaba10
May 10 20:49:42 h4 kernel: [586068.444002] RDX: 0000000000000000 RSI:
28f5c28f5c28f5c3 RDI: ffff8850400192a8
May 10 20:49:42 h4 kernel: [586068.444002] RBP: ffffffff8100bcce R08:
0000000000000000 R09: 0000000000000000
May 10 20:49:42 h4 kernel: [586068.444002] R10: 0000000000000001 R11:
0000000000000020 R12: ffff8818fecab998
May 10 20:49:42 h4 kernel: [586068.444002] R13: ffffffff8100bcce R14:
ffffffff81137d77 R15: ffff8818fecab958
May 10 20:49:42 h4 kernel: [586068.444002] FS:  00007f6c25324700(0000)
GS:ffff880028200000(0000) knlGS:00000000b77e76c0
May 10 20:49:42 h4 kernel: [586068.444002] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May 10 20:49:42 h4 kernel: [586068.444002] CR2: 0000000000434020 CR3:
0000007a892ab000 CR4: 00000000000006f0
May 10 20:49:42 h4 kernel: [586068.444002] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 10 20:49:42 h4 kernel: [586068.444002] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 10 20:49:42 h4 kernel: [586068.444002] Process python (pid: 173511,
veid: 430, threadinfo ffff8818fecaa000, task ffff88190ee5a600)
May 10 20:49:42 h4 kernel: [586068.444002] Stack:
May 10 20:49:42 h4 kernel: [586068.444002]  0000000000000000
ffff8818fecaba38 ffff885037bab180 00000064fecaba68
May 10 20:49:42 h4 kernel: [586068.444002] <0> 00ff881800000000
0000000000000020 ffff8850400192a8 000000008109fd79
May 10 20:49:42 h4 kernel: [586068.444002] <0> 0000000000000000
ffff885040010e40 0000000000000000 0000000000000000
May 10 20:49:42 h4 kernel: [586068.444002] Call Trace:
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8109fd79>] ?
ktime_get_ts+0xa9/0xe0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81140d54>] ?
do_try_to_free_pages+0x294/0x7f0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811413f7>] ?
try_to_free_gang_pages+0x77/0xf0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8113e040>] ?
isolate_pages_global+0x0/0x520
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff810a9845>] ?
ub_try_to_free_pages+0x45/0x130
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff810a999b>] ?
__ub_check_ram_limits+0x6b/0x90
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81153c25>] ?
__do_fault+0x565/0x600
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8119c35e>] ?
__link_path_walk+0x88e/0x1060
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81153db9>] ?
handle_pte_fault+0xf9/0xd00
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811ad180>] ?
mntput_no_expire+0x30/0x110
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811ad180>] ?
mntput_no_expire+0x30/0x110
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81154ba4>] ?
handle_mm_fault+0x1e4/0x2b0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8119a2e5>] ?
putname+0x35/0x50
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81042aa9>] ?
__do_page_fault+0x139/0x480
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811922b4>] ?
cp_new_stat+0xe4/0x100
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff814e4a7e>] ?
do_page_fault+0x3e/0xa0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff814e1e25>] ?
page_fault+0x25/0x30
May 10 20:49:42 h4 kernel: [586068.444002] Code: 00 89 b5 60 ff ff ff 89
85 5c ff ff ff eb 56 66 0f 1f 44 00 00 31 d2 48 89 11 48 8b 85 70 ff ff ff
66 ff 00 66 66 90 fb 66 66 90 <66> 66 90 48 83 39 00 75 21 80 bd 67 ff ff
ff 00 74 18 4d 63 f6
May 10 20:49:42 h4 kernel: [586068.444002] Call Trace:
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811403fe>] ?
shrink_zone+0x2de/0x9a0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8109fd79>] ?
ktime_get_ts+0xa9/0xe0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81140d54>] ?
do_try_to_free_pages+0x294/0x7f0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811413f7>] ?
try_to_free_gang_pages+0x77/0xf0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8113e040>] ?
isolate_pages_global+0x0/0x520
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff810a9845>] ?
ub_try_to_free_pages+0x45/0x130
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff810a999b>] ?
__ub_check_ram_limits+0x6b/0x90
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81153c25>] ?
__do_fault+0x565/0x600
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8119c35e>] ?
__link_path_walk+0x88e/0x1060
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81153db9>] ?
handle_pte_fault+0xf9/0xd00
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811ad180>] ?
mntput_no_expire+0x30/0x110
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811ad180>] ?
mntput_no_expire+0x30/0x110
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81154ba4>] ?
handle_mm_fault+0x1e4/0x2b0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff8119a2e5>] ?
putname+0x35/0x50
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff81042aa9>] ?
__do_page_fault+0x139/0x480
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff811922b4>] ?
cp_new_stat+0xe4/0x100
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff814e4a7e>] ?
do_page_fault+0x3e/0xa0
May 10 20:49:42 h4 kernel: [586068.444002]  [<ffffffff814e1e25>] ?
page_fault+0x25/0x30

======

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
