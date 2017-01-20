Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbdATLzS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 06:55:18 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50EE24E4CF
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 11:55:19 +0000 (UTC)
Received: from localhost (dhcp-12-128.nay.redhat.com [10.66.12.128])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0KBtI65023128
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 06:55:18 -0500
Date: Fri, 20 Jan 2017 19:55:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: XFS warning at fs/iomap.c:768 iomap_dio_actor
Message-ID: <20170120115517.GW1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I've seen the warning in subject a few times while testing XFS with
xfstests, with different test configs, different arches, and multiple
tests could trigger the warning, e.g. generic/269 generic/388 xfs/297.

Today I reproduced it manually by running xfs/297 in a loop on one of my
test hosts, the warning usueally fires within 30 iterations for me.

Below is detailed host info and dmesg log. If you need more info please
let me know.

Thanks,
Eryu

MKFS_OPTIONS="-m crc=1 -b size=4k"
MOUNT_OPTIONS not set

xfs_info $SCRATCH_MNT after test
[root@hp-dl360g9-15 xfstests]# xfs_info /mnt/scratch
meta-data=/dev/mapper/systemvg-testlv2 isize=512    agcount=16, agsize=245760 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=64     swidth=768 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=5120, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[root@hp-dl360g9-15 xfstests]# uname -a
Linux hp-dl360g9-15 4.10.0-rc4 #18 SMP Wed Jan 18 11:39:05 CST 2017 x86_64 x86_64 x86_64 GNU/Linux
[root@hp-dl360g9-15 xfstests]# free -m
              total        used        free      shared  buff/cache   available
Mem:          64305         305       61774           9        2225       63369
Swap:         16379           0       16379
[root@hp-dl360g9-15 xfstests]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    1
Core(s) per socket:    8
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 63
Model name:            Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
Stepping:              2
CPU MHz:               2400.000
BogoMIPS:              4801.69
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              20480K
NUMA node0 CPU(s):     0-3,8-11
NUMA node1 CPU(s):     4-7,12-15

dmesg
[ 3484.480115] run fstests xfs/297 at 2017-01-20 15:08:20
[ 3484.886396] XFS (dm-5): Unmounting Filesystem
[ 3488.139739] XFS (dm-5): Mounting V5 Filesystem
[ 3488.308905] XFS (dm-5): Ending clean mount
[ 3620.466136] ------------[ cut here ]------------
[ 3620.490181] WARNING: CPU: 0 PID: 1302 at fs/iomap.c:768 iomap_dio_actor+0x39e/0x3b0
[ 3620.529312] Modules linked in: brd xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif aesni_intel crypto_simd ipmi_si glue_helper iTCO_wdt cryptd sg iTCO_vendor_support ipmi_devintf hpilo hpwdt pcspkr ipmi_msghandler
[ 3620.851354]  shpchp ioatdma pcc_cpufreq i2c_i801 lpc_ich wmi acpi_power_meter acpi_cpufreq dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops sd_mod ttm tg3 uas drm ptp usb_storage crc32c_intel serio_raw hpsa pps_core i2c_core fjes scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[ 3621.009180] CPU: 0 PID: 1302 Comm: fsstress Not tainted 4.10.0-rc4 #18
[ 3621.041709] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[ 3621.071020] Call Trace:
[ 3621.081930]  dump_stack+0x63/0x87
[ 3621.096754]  __warn+0xd1/0xf0
[ 3621.109991]  warn_slowpath_null+0x1d/0x20
[ 3621.128045]  iomap_dio_actor+0x39e/0x3b0
[ 3621.145575]  ? iomap_dio_zero+0x110/0x110
[ 3621.163733]  iomap_apply+0xb3/0x130
[ 3621.179539]  iomap_dio_rw+0x216/0x3c0
[ 3621.195961]  ? iomap_dio_zero+0x110/0x110
[ 3621.214328]  xfs_file_dio_aio_read+0x6e/0xf0 [xfs]
[ 3621.235734]  xfs_file_read_iter+0xab/0xc0 [xfs]
[ 3621.255995]  __vfs_read+0xe0/0x150
[ 3621.271168]  vfs_read+0x8c/0x130
[ 3621.286163]  SyS_read+0x55/0xc0
[ 3621.300614]  do_syscall_64+0x67/0x180
[ 3621.317058]  entry_SYSCALL64_slow_path+0x25/0x25
[ 3621.337701] RIP: 0033:0x7fde7df47480
[ 3621.353725] RSP: 002b:00007ffdc025a108 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 3621.387617] RAX: ffffffffffffffda RBX: 0000000000000059 RCX: 00007fde7df47480
[ 3621.419714] RDX: 0000000000019600 RSI: 00007fde78000e00 RDI: 0000000000000003
[ 3621.451452] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000019830
[ 3621.483487] R10: 000000000000007a R11: 0000000000000246 R12: 0000000000019600
[ 3621.518697] R13: 0000000000363200 R14: 00007fde78000e00 R15: 0000000000000000
[ 3621.553276] ---[ end trace 2e994b2d00c5ff37 ]---
[ 3639.346520] XFS (dm-5): Unmounting Filesystem
[ 3650.234532] XFS (dm-5): Mounting V5 Filesystem
[ 3650.370766] XFS (dm-5): Ending clean mount
[ 3650.465012] XFS (dm-4): Unmounting Filesystem
[ 3650.577045] XFS (dm-5): Unmounting Filesystem
