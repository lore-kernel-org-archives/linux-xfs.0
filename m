Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p140F79K236154
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 18:15:07 -0600
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 155492AF32A
	for <linux-xfs@oss.sgi.com>; Thu,  3 Feb 2011 16:17:36 -0800 (PST)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id W1YByfJLqGSSZAtT for
	<linux-xfs@oss.sgi.com>; Thu, 03 Feb 2011 16:17:36 -0800 (PST)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1402vIL017189
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 17:02:57 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p140HTjc123740
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 17:17:30 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p140HTAx010152
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 17:17:29 -0700
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p140HSj8010132
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 17:17:29 -0700
Subject: Oops while running xfstests on Power architecture
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 03 Feb 2011 16:17:48 -0800
Message-ID: <1296778668.32230.18.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: linux-xfs@oss.sgi.com

Hello All,

I see the following Oops when I run the test 070 on power Architecture.
Looking at the code, I do not see anything that is popping out as a
problem.

I do not see the same failures in x86_64, so, I thought it may be due to
the pagesize, so changed the pagesize to be 4k, but that didn't help.

Is this assertion a false-positive ?

If not, Any suggestions on where to start looking at the code.

I see the same Oops with 2.6.37, 2.6.38-rc2 and 2.6.38-rc3.

Thanks,

chandra
------------------------------
Feb  3 14:01:30 mytestmachine kernel: Assertion failed: args->op_flags & XFS_DA_OP_OKNOENT, file: fs/xfs/xfs_da_btree.c, line: 1428
Feb  3 14:01:30 mytestmachine kernel: ------------[ cut here ]------------
Feb  3 14:01:30 mytestmachine kernel: kernel BUG at fs/xfs/support/debug.c:100!
Feb  3 14:01:30 mytestmachine kernel: Oops: Exception in kernel mode, sig: 5 [#1]
Feb  3 14:01:30 mytestmachine kernel: SMP NR_CPUS=1024 NUMA pSeries
Feb  3 14:01:30 mytestmachine kernel: last sysfs file: /sys/devices/pci0001:00/0001:00:02.4/0001:d0:01.0/host3/target3:0:4/3:0:4:0/block/sdb/dev
Feb  3 14:01:30 mytestmachine kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log
e1000 shpchp ses enclosure sg ext4 jbd2 mbcache sd_mod crc_t10dif sr_mod cdrom ipr pata_pdc2027x qla2xxx scsi_transport_fc scsi_tgt dm_mod [last
unloaded: scsi_wait_scan]
Feb  3 14:01:30 mytestmachine kernel: NIP: d000000001512e84 LR: d000000001512e80 CTR: c00000000005f760
Feb  3 14:01:30 mytestmachine kernel: REGS: c0000000aefdb310 TRAP: 0700   Not tainted  (2.6.38-rc3)
Feb  3 14:01:30 mytestmachine kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28004484  XER: 0000000f
Feb  3 14:01:30 mytestmachine kernel: TASK = c0000000aeba71a0[2129] 'fsstress' THREAD: c0000000aefd8000 CPU: 0
Feb  3 14:01:30 mytestmachine kernel: GPR00: d000000001512e80 c0000000aefdb590 d000000001564da0 0000000000000064
Feb  3 14:01:30 mytestmachine kernel: GPR04: 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000
Feb  3 14:01:30 mytestmachine kernel: GPR08: ffffffffffffffff c000000000856f38 0000000000015347 00000000008ae000
Feb  3 14:01:30 mytestmachine kernel: GPR12: 0000000028004482 c000000007601000 ffffffffffffffff 0000000000000000
Feb  3 14:01:30 mytestmachine kernel: GPR16: 0000000000000000 00000ffff309abd8 0000000000000001 000000001001c4bc
Feb  3 14:01:30 mytestmachine kernel: GPR20: 00000ffff309c29a c0000000aefdb750 c0000000aed26de0 c0000000aefdb850
Feb  3 14:01:30 mytestmachine kernel: GPR24: 000000000000d2ff 0000000000000001 c0000000aed26dc0 c0000000aefdb750
Feb  3 14:01:30 mytestmachine kernel: GPR28: c0000000aefdb928 ffffffffffffffff d00000000155edc8 0000000000000001
Feb  3 14:01:30 mytestmachine kernel: NIP [d000000001512e84] .assfail+0x34/0x40 [xfs]
Feb  3 14:01:30 mytestmachine kernel: LR [d000000001512e80] .assfail+0x30/0x40 [xfs]
Feb  3 14:01:30 mytestmachine kernel: Call Trace:
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb590] [d000000001512e80] .assfail+0x30/0x40 [xfs] (unreliable)
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb610] [d0000000014b4cf0] .xfs_da_path_shift+0x390/0x470 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb6e0] [d0000000014b59e0] .xfs_da_node_lookup_int+0x380/0x510 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb7e0] [d00000000148ce64] .xfs_attr_node_removename+0x64/0x490 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb8a0] [d00000000148ec28] .xfs_attr_remove_int+0x238/0x360 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdb9e0] [d00000000148f69c] .xfs_attr_remove+0xec/0x110 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdba80] [d000000001512928] .xfs_xattr_set+0x88/0xa0 [xfs]
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdbaf0] [c0000000001d2e84] .generic_removexattr+0xb4/0xf0
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdbb60] [c0000000001d3180] .vfs_removexattr+0xd0/0x170
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdbc00] [c0000000001d32e0] .removexattr+0xc0/0xe0
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdbd90] [c0000000001d349c] .SyS_lremovexattr+0xac/0xc0
Feb  3 14:01:30 mytestmachine kernel: [c0000000aefdbe30] [c000000000008564] syscall_exit+0x0/0x40

--------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
