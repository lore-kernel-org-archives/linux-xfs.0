Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbcLEJ27 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:28:59 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08440680E0
        for <linux-xfs@vger.kernel.org>; Mon,  5 Dec 2016 09:21:14 +0000 (UTC)
Received: from localhost (dhcp-13-108.nay.redhat.com [10.66.13.108])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uB59LClA029765
        for <linux-xfs@vger.kernel.org>; Mon, 5 Dec 2016 04:21:13 -0500
Date: Mon, 5 Dec 2016 17:21:12 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161205092112.GS29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I hit an xfs/109 crash today while testing reflink XFS with 2k block
size on x86_64 hosts (both baremetal and kvm guest).

It can be reproduced by running xfs/109 many times, I tried 50-times
loop twice and it crashed at the 21st and 46th runs. And I can reproduce
it with both linus tree (4.9-rc4) and linux-xfs tree for-next branch
(updated on 2016-11-30). I haven't been able to reproduce it with 4k
block size XFS.

Detailed host info and crash log are appended at the end of this mail.

Thanks,
Eryu

fstests config:
TEST_DEV=/dev/mapper/testvg-testlv1
TEST_DIR=/mnt/testarea/test
SCRATCH_DEV=/dev/mapper/testvg-testlv2
SCRATCH_MNT=/mnt/testarea/scratch
MKFS_OPTIONS="-f -b size=2k -m reflink=1,rmapbt=1"

[root@ibm-x3550m3-05 ~]# xfs_info /mnt/testarea/scratch/
meta-data=/dev/mapper/testvg-testlv2 isize=512    agcount=4, agsize=20480 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=1
         =                       reflink=1
data     =                       bsize=2048   blocks=81920, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=2048   blocks=4608, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@ibm-x3550m3-05 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           7937         127        7482           8         326        7478
Swap:          8191           0        8191
[root@ibm-x3550m3-05 xfstests]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0,1,4-6,9-11
Thread(s) per core:    1
Core(s) per socket:    4
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Model name:            Intel(R) Xeon(R) CPU           E5606  @ 2.13GHz
Stepping:              2
CPU MHz:               2128.000
BogoMIPS:              4266.55
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0,1,4,5
NUMA node1 CPU(s):     6,9-11
[root@ibm-x3550m3-05 ~]# lvs
  LV      VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root    systemvg -wi-ao---- 771.25g                                                    
  swap    systemvg -wi-ao----   8.00g                                                    
  lv50g   testvg   -wi-a-----  50.00g                                                    
  testlv1 testvg   -wi-a-----  15.00g                                                    
  testlv2 testvg   -wi-ao----  15.00g                                                    
  testlv3 testvg   -wi-a-----  15.00g                                                    
  testlv4 testvg   -wi-a-----  15.00g                                                    
  testlv5 testvg   -wi-a-----  15.00g                                                    
[root@ibm-x3550m3-05 ~]# vgs
  VG       #PV #LV #SN Attr   VSize   VFree  
  systemvg   1   2   0 wz--n- 779.25g      0 
  testvg     1   6   0 wz--n- 878.90g 753.90g
[root@ibm-x3550m3-05 ~]# pvs
  PV         VG       Fmt  Attr PSize   PFree  
  /dev/sda2  systemvg lvm2 a--  779.25g      0 
  /dev/sdb1  testvg   lvm2 a--  878.90g 753.90g

[419012.731523] run fstests xfs/109 at 2016-12-05 14:01:26
[419013.066939] XFS (dm-4): Unmounting Filesystem
[419013.089131] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[419013.098098] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[419013.106264] XFS (dm-4): Mounting V5 Filesystem
[419013.136734] XFS (dm-4): Ending clean mount
[419013.163906] XFS (dm-4): Unmounting Filesystem
[419013.295657] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[419013.304635] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[419013.312666] XFS (dm-4): Mounting V5 Filesystem
[419013.357736] XFS (dm-4): Ending clean mount
[419019.581319] XFS (dm-4): Unmounting Filesystem
[419019.635144] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[419019.644118] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[419019.652521] XFS (dm-4): Mounting V5 Filesystem
[419019.859615] XFS (dm-4): Ending clean mount
[419021.380595] XFS (dm-4): _xfs_buf_find: Block out of range: block 0x140000000bffc, EOFS 0x50000
[419021.389457] ------------[ cut here ]------------
[419021.394243] WARNING: CPU: 9 PID: 4984 at fs/xfs/xfs_buf.c:520 _xfs_buf_find+0x2d5/0x340 [xfs]
[419021.402917] Modules linked in:[419021.405962]  xfs overlay arc4 md4 nls_utf8 cifs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_delay dm_zero btrfs xor raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey libcrc32c ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel cdc_ether usbnet aesni_intel lrw gf128mul glue_helper iTCO_wdt iTCO_vendor_support ipmi_devintf mii ablk_helper i2c_i801 cryptd i2c_smbus lpc_ich pcspkr ipmi_si nfsd sg i7core_edac ipmi_msghandler ioatdma edac_core shpchp dca acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea ata_generic sysfillrect pata_acpi sysimgblt fb_sys_fops ttm ata_piix crc32c_intel drm libata serio_raw megaraid_sas i2c_core bnx2 fjes dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[419021.527826] CPU: 9 PID: 4984 Comm: kworker/u50:2 Tainted: G        W  OE   4.9.0-rc1.xfs+ #7
[419021.536341] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[419021.546164] Workqueue: writeback wb_workfn (flush-253:4)
[419021.551594]  ffffc90007b2b300 ffffffff81363bec 0000000000000000 0000000000000000
[419021.559148]  ffffc90007b2b340 ffffffff8108f201 0000020807b2b320 ffffc90007b2b430
[419021.566701]  0000000000000004 ffff880275e7ad80 0000000000000000 0000000000000001
[419021.574255] Call Trace:
[419021.576797]  [<ffffffff81363bec>] dump_stack+0x63/0x87
[419021.582022]  [<ffffffff8108f201>] __warn+0xd1/0xf0
[419021.586896]  [<ffffffff8108f33d>] warn_slowpath_null+0x1d/0x20
[419021.592840]  [<ffffffffa0be7bd5>] _xfs_buf_find+0x2d5/0x340 [xfs]
[419021.599015]  [<ffffffff81369f64>] ? __radix_tree_lookup+0x84/0xf0
[419021.605219]  [<ffffffffa0be7c6a>] xfs_buf_get_map+0x2a/0x280 [xfs]
[419021.611481]  [<ffffffff8136a02d>] ? radix_tree_lookup+0xd/0x10
[419021.617429]  [<ffffffffa0c1bf96>] xfs_trans_get_buf_map+0x116/0x190 [xfs]
[419021.624323]  [<ffffffffa0bb46d4>] xfs_btree_get_bufl+0x74/0x90 [xfs]
[419021.630783]  [<ffffffffa0ba4924>] xfs_bmap_extents_to_btree+0x254/0x630 [xfs]
[419021.638018]  [<ffffffffa0b999fc>] ? xfs_alloc_update_counters.isra.17+0x3c/0x50 [xfs]
[419021.645951]  [<ffffffffa0baaac2>] xfs_bmap_add_extent_delay_real+0x1b42/0x2090 [xfs]
[419021.653797]  [<ffffffffa0baed3b>] xfs_bmapi_write+0x78b/0xba0 [xfs]
[419021.660176]  [<ffffffffa0bf71a6>] xfs_iomap_write_allocate+0x196/0x3a0 [xfs]
[419021.667334]  [<ffffffffa0be09fb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[419021.673624]  [<ffffffffa0be1abc>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[419021.680061]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[419021.686067]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[419021.691925]  [<ffffffffa0be18f0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[419021.698476]  [<ffffffffa0be18c6>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[419021.704826]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[419021.710310]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[419021.716834]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[419021.723011]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[419021.728578]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[419021.733890]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[419021.739803]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[419021.745460]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419021.751202]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[419021.757116]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419021.762859]  [<ffffffff810af039>] kthread+0xd9/0xf0
[419021.767822]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[419021.773394]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[419021.778947] ---[ end trace 5fae8d49ab722482 ]---
[419021.783787] XFS (dm-4): _xfs_buf_find: Block out of range: block 0x140000000bffc, EOFS 0x50000
[419021.792583] ------------[ cut here ]------------
[419021.797372] WARNING: CPU: 11 PID: 4984 at fs/xfs/xfs_buf.c:520 _xfs_buf_find+0x2d5/0x340 [xfs]
[419021.806064] Modules linked in:[419021.809097]  xfs overlay arc4 md4 nls_utf8 cifs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_delay dm_zero btrfs xor raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey libcrc32c ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel cdc_ether usbnet aesni_intel lrw gf128mul glue_helper iTCO_wdt iTCO_vendor_support ipmi_devintf mii ablk_helper i2c_i801 cryptd i2c_smbus lpc_ich pcspkr ipmi_si nfsd sg i7core_edac ipmi_msghandler ioatdma edac_core shpchp dca acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea ata_generic sysfillrect pata_acpi sysimgblt fb_sys_fops ttm ata_piix crc32c_intel drm libata serio_raw megaraid_sas i2c_core bnx2 fjes dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[419021.930296] CPU: 11 PID: 4984 Comm: kworker/u50:2 Tainted: G        W  OE   4.9.0-rc1.xfs+ #7
[419021.938899] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[419021.948718] Workqueue: writeback wb_workfn (flush-253:4)
[419021.954147]  ffffc90007b2b300 ffffffff81363bec 0000000000000000 0000000000000000
[419021.961701]  ffffc90007b2b340 ffffffff8108f201 0000020807b2b320 ffffc90007b2b430
[419021.969254]  0000000000000004 ffff880275e7ad80 0000000000000000 0000000000000001
[419021.976807] Call Trace:
[419021.979346]  [<ffffffff81363bec>] dump_stack+0x63/0x87
[419021.984567]  [<ffffffff8108f201>] __warn+0xd1/0xf0
[419021.989444]  [<ffffffff8108f33d>] warn_slowpath_null+0x1d/0x20
[419021.995387]  [<ffffffffa0be7bd5>] _xfs_buf_find+0x2d5/0x340 [xfs]
[419022.001593]  [<ffffffffa0be7e42>] xfs_buf_get_map+0x202/0x280 [xfs]
[419022.007973]  [<ffffffffa0c1bf96>] xfs_trans_get_buf_map+0x116/0x190 [xfs]
[419022.014864]  [<ffffffffa0bb46d4>] xfs_btree_get_bufl+0x74/0x90 [xfs]
[419022.021320]  [<ffffffffa0ba4924>] xfs_bmap_extents_to_btree+0x254/0x630 [xfs]
[419022.028555]  [<ffffffffa0b999fc>] ? xfs_alloc_update_counters.isra.17+0x3c/0x50 [xfs]
[419022.036488]  [<ffffffffa0baaac2>] xfs_bmap_add_extent_delay_real+0x1b42/0x2090 [xfs]
[419022.044335]  [<ffffffffa0baed3b>] xfs_bmapi_write+0x78b/0xba0 [xfs]
[419022.050714]  [<ffffffffa0bf71a6>] xfs_iomap_write_allocate+0x196/0x3a0 [xfs]
[419022.057870]  [<ffffffffa0be09fb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[419022.064158]  [<ffffffffa0be1abc>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[419022.070593]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[419022.076596]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[419022.082454]  [<ffffffffa0be18f0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[419022.089005]  [<ffffffffa0be18c6>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[419022.095356]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[419022.100839]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[419022.107362]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[419022.113538]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[419022.119107]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[419022.124414]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[419022.130328]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[419022.135984]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419022.141725]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[419022.147639]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419022.153380]  [<ffffffff810af039>] kthread+0xd9/0xf0
[419022.158344]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[419022.163911]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[419022.169463] ---[ end trace 5fae8d49ab722483 ]---
[419022.174174] BUG: unable to handle kernel NULL pointer dereference at 0000000000000168
[419022.182119] IP: [<ffffffffa0ba492b>] xfs_bmap_extents_to_btree+0x25b/0x630 [xfs]
[419022.189640] PGD 0 [419022.191565]
[419022.193159] Oops: 0002 [#1] SMP
[419022.196388] Modules linked in: xfs overlay arc4 md4 nls_utf8 cifs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_delay dm_zero btrfs xor raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey libcrc32c ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel cdc_ether usbnet aesni_intel lrw gf128mul glue_helper iTCO_wdt iTCO_vendor_support ipmi_devintf mii ablk_helper i2c_i801 cryptd i2c_smbus lpc_ich pcspkr ipmi_si nfsd sg i7core_edac ipmi_msghandler ioatdma edac_core shpchp dca acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea ata_generic sysfillrect pata_acpi sysimgblt fb_sys_fops ttm ata_piix crc32c_intel drm libata serio_raw megaraid_sas i2c_core bnx2 fjes dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[419022.316408] CPU: 11 PID: 4984 Comm: kworker/u50:2 Tainted: G        W  OE   4.9.0-rc1.xfs+ #7
[419022.325010] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[419022.334827] Workqueue: writeback wb_workfn (flush-253:4)
[419022.340255] task: ffff88019d90ab00 task.stack: ffffc90007b28000
[419022.346257] RIP: 0010:[<ffffffffa0ba492b>]  [<ffffffffa0ba492b>] xfs_bmap_extents_to_btree+0x25b/0x630 [xfs]
[419022.356205] RSP: 0018:ffffc90007b2b458  EFLAGS: 00010246
[419022.361599] RAX: 0000000000000000 RBX: ffff880262a31138 RCX: 0000000000cd045a
[419022.368814] RDX: 0000000000cd0459 RSI: 0000000000000000 RDI: ffff8801ff820140
[419022.376026] RBP: ffffc90007b2b578 R08: 000000000001d200 R09: ffffffffa0be6f46
[419022.383242] R10: ffff88027fb5d200 R11: ffffea0009dc5c00 R12: ffff8802502596c8
[419022.390457] R13: ffff880178487000 R14: 0000000000000001 R15: ffff880250259680
[419022.397674] FS:  0000000000000000(0000) GS:ffff88027fb40000(0000) knlGS:0000000000000000
[419022.405841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[419022.411670] CR2: 0000000000000168 CR3: 0000000001c06000 CR4: 00000000000006e0
[419022.418886] Stack:
[419022.420986]  0000000000000050 0000000000000009 ffffffffa0b999fc 0000000000000000
[419022.428538]  ffffc90007b2b798 ffffc90007b2b5e8 ffff8801ff34ce80 ffffc90007b2b878
[419022.436091]  ffff880276233ea0 ffff880262a31138 ffff880262a31138 ffff880178487000
[419022.443644] Call Trace:
[419022.446202]  [<ffffffffa0b999fc>] ? xfs_alloc_update_counters.isra.17+0x3c/0x50 [xfs]
[419022.454136]  [<ffffffffa0baaac2>] xfs_bmap_add_extent_delay_real+0x1b42/0x2090 [xfs]
[419022.461980]  [<ffffffffa0baed3b>] xfs_bmapi_write+0x78b/0xba0 [xfs]
[419022.468360]  [<ffffffffa0bf71a6>] xfs_iomap_write_allocate+0x196/0x3a0 [xfs]
[419022.475517]  [<ffffffffa0be09fb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[419022.481806]  [<ffffffffa0be1abc>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[419022.488240]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[419022.494245]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[419022.500103]  [<ffffffffa0be18f0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[419022.506654]  [<ffffffffa0be18c6>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[419022.513004]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[419022.518488]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[419022.525012]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[419022.531189]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[419022.536756]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[419022.542066]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[419022.547980]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[419022.553636]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419022.559376]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[419022.565289]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419022.571032]  [<ffffffff810af039>] kthread+0xd9/0xf0
[419022.575996]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[419022.581563]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[419022.587046] Code: 49 83 87 18 01 00 00 01 48 89 df e8 e0 b3 07 00 48 8b 95 58 ff ff ff 31 c9 48 89 de 4c 89 ef e8 3c fd 00 00 48 89 85 f8 fe ff ff <48> c7 80 68 01 00 00 d0 b5 c2 a0 48 8b 80 a0 00 00 00 48 89 85
[419022.607262] RIP  [<ffffffffa0ba492b>] xfs_bmap_extents_to_btree+0x25b/0x630 [xfs]
[419022.614866]  RSP <ffffc90007b2b458>
[419022.618441] CR2: 0000000000000168
[419022.718795] ---[ end trace 5fae8d49ab722484 ]---
[419022.723497] Kernel panic - not syncing: Fatal exception
[419022.729283] Kernel Offset: disabled
[419022.732860] ---[ end Kernel panic - not syncing: Fatal exception
[419022.738951] ------------[ cut here ]------------
[419022.743656] WARNING: CPU: 11 PID: 4984 at arch/x86/kernel/smp.c:127 native_smp_send_reschedule+0x3f/0x50
[419022.753210] Modules linked in: xfs overlay arc4 md4 nls_utf8 cifs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_delay dm_zero btrfs xor raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey libcrc32c ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel cdc_ether usbnet aesni_intel lrw gf128mul glue_helper iTCO_wdt iTCO_vendor_support ipmi_devintf mii ablk_helper i2c_i801 cryptd i2c_smbus lpc_ich pcspkr ipmi_si nfsd sg i7core_edac ipmi_msghandler ioatdma edac_core shpchp dca acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea ata_generic sysfillrect pata_acpi sysimgblt fb_sys_fops ttm ata_piix crc32c_intel drm libata serio_raw megaraid_sas i2c_core bnx2 fjes dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[419022.873226] CPU: 11 PID: 4984 Comm: kworker/u50:2 Tainted: G      D W  OE   4.9.0-rc1.xfs+ #7
[419022.881828] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[419022.891645] Workqueue: writeback wb_workfn (flush-253:4)
[419022.897073]  ffff88027fb43c78 ffffffff81363bec 0000000000000000 0000000000000000
[419022.904627]  ffff88027fb43cb8 ffffffff8108f201 0000007f77040f00 ffff880275c2ab00
[419022.912181]  ffff880275c2b61c 0000000000000000 0000000000000046 0000000000019300
[419022.919735] Call Trace:
[419022.922270]  <IRQ> [419022.924288]  [<ffffffff81363bec>] dump_stack+0x63/0x87
[419022.929523]  [<ffffffff8108f201>] __warn+0xd1/0xf0
[419022.934397]  [<ffffffff8108f33d>] warn_slowpath_null+0x1d/0x20
[419022.940312]  [<ffffffff81051c7f>] native_smp_send_reschedule+0x3f/0x50
[419022.946921]  [<ffffffff810bb988>] try_to_wake_up+0x328/0x3b0
[419022.952661]  [<ffffffff810bbac2>] default_wake_function+0x12/0x20
[419022.958840]  [<ffffffff810d56d5>] __wake_up_common+0x55/0x90
[419022.964580]  [<ffffffff810d5723>] __wake_up_locked+0x13/0x20
[419022.970323]  [<ffffffff8127b199>] ep_poll_callback+0xb9/0x200
[419022.976152]  [<ffffffff810d56d5>] __wake_up_common+0x55/0x90
[419022.981893]  [<ffffffff810d5859>] __wake_up+0x39/0x50
[419022.987031]  [<ffffffff810eca90>] wake_up_klogd_work_func+0x40/0x60
[419022.993382]  [<ffffffff8118652d>] irq_work_run_list+0x4d/0x70
[419022.999214]  [<ffffffff81111d90>] ? tick_sched_do_timer+0x50/0x50
[419023.005390]  [<ffffffff811866e0>] irq_work_tick+0x40/0x50
[419023.010873]  [<ffffffff81101bb2>] update_process_times+0x42/0x60
[419023.016961]  [<ffffffff811116d5>] tick_sched_handle.isra.16+0x25/0x60
[419023.023483]  [<ffffffff81111dcd>] tick_sched_timer+0x3d/0x70
[419023.029223]  [<ffffffff811028d3>] __hrtimer_run_queues+0xf3/0x280
[419023.035399]  [<ffffffff81102db8>] hrtimer_interrupt+0xa8/0x1a0
[419023.041313]  [<ffffffff81054635>] local_apic_timer_interrupt+0x35/0x60
[419023.047922]  [<ffffffff817128ed>] smp_apic_timer_interrupt+0x3d/0x50
[419023.054354]  [<ffffffff81711aac>] apic_timer_interrupt+0x8c/0xa0
[419023.060441]  <EOI> [419023.062460]  [<ffffffff8119dde3>] ? panic+0x1f5/0x239
[419023.067613]  [<ffffffff81031a28>] oops_end+0xb8/0xd0
[419023.072665]  [<ffffffff8106b73e>] no_context+0x19e/0x400
[419023.078060]  [<ffffffff8106ba8e>] __bad_area_nosemaphore+0xee/0x1d0
[419023.084409]  [<ffffffff8106bb84>] bad_area_nosemaphore+0x14/0x20
[419023.090496]  [<ffffffff8106c239>] __do_page_fault+0x89/0x4a0
[419023.096236]  [<ffffffff8108f1da>] ? __warn+0xaa/0xf0
[419023.101283]  [<ffffffff8106c680>] do_page_fault+0x30/0x80
[419023.106765]  [<ffffffff81711208>] page_fault+0x28/0x30
[419023.112022]  [<ffffffffa0be6f46>] ? xfs_buf_free+0xb6/0x120 [xfs]
[419023.118221]  [<ffffffffa0ba492b>] ? xfs_bmap_extents_to_btree+0x25b/0x630 [xfs]
[419023.125634]  [<ffffffffa0ba4924>] ? xfs_bmap_extents_to_btree+0x254/0x630 [xfs]
[419023.133043]  [<ffffffffa0b999fc>] ? xfs_alloc_update_counters.isra.17+0x3c/0x50 [xfs]
[419023.140976]  [<ffffffffa0baaac2>] xfs_bmap_add_extent_delay_real+0x1b42/0x2090 [xfs]
[419023.148821]  [<ffffffffa0baed3b>] xfs_bmapi_write+0x78b/0xba0 [xfs]
[419023.155202]  [<ffffffffa0bf71a6>] xfs_iomap_write_allocate+0x196/0x3a0 [xfs]
[419023.162358]  [<ffffffffa0be09fb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[419023.168647]  [<ffffffffa0be1abc>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[419023.175082]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[419023.181086]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[419023.186944]  [<ffffffffa0be18f0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[419023.193495]  [<ffffffffa0be18c6>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[419023.199846]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[419023.205329]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[419023.211852]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[419023.218029]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[419023.223597]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[419023.228906]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[419023.234820]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[419023.240476]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419023.246217]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[419023.252132]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[419023.257872]  [<ffffffff810af039>] kthread+0xd9/0xf0
[419023.262835]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[419023.268402]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[419023.273884] ---[ end trace 5fae8d49ab722485 ]---
