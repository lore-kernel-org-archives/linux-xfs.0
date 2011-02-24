Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OLqQFl162204 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 15:52:26 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CC1E2FAB4C
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 13:55:10 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id mhtrQ0wglDyu0xwP for
	<xfs@oss.sgi.com>; Thu, 24 Feb 2011 13:55:10 -0800 (PST)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1OLYrQ8021599
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 16:34:53 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1OLtAq0322950 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 16:55:10 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1OLtA8G011913 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 18:55:10 -0300
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p1OLt9Ku011868 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 18:55:09 -0300
Subject: xfstests 011 trips an ASSERT
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 24 Feb 2011 13:54:40 -0800
Message-ID: <1298584480.32230.416.camel@chandra-lucid.beaverton.ibm.com>
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
To: XFS Mailing List <xfs@oss.sgi.com>

Hello,

I ran the xfs tests on my POWER box and was tripped by an ASSERT while
running test 011. I have not seen it before in 2.6.37, so started with a
git-bisect from 2.6.37 to 2.6.38-rc6 and ended at this commit:
--------------------
Author  Linus Torvalds <torvalds@linux-foundation.org>
        Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
committer       Linus Torvalds <torvalds@linux-foundation.org>
        Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
commit  7bc4a4ce68f8c6d064ea949446852e996526f692        
Merge branch 'for-linus-merged' of git://oss.sgi.com/xfs/xfs

* 'for-linus-merged' of git://oss.sgi.com/xfs/xfs: (47 commits)
  xfs: convert grant head manipulations to lockless algorithm
  xfs: introduce new locks for the log grant ticket wait queues
  xfs: convert log grant heads to atomic variables
  xfs: convert l_tail_lsn to an atomic variable.
  xfs: convert l_last_sync_lsn to an atomic variable
  xfs: make AIL tail pushing independent of the grant lock
  xfs: use wait queues directly for the log wait queues
  xfs: combine grant heads into a single 64 bit integer
  xfs: rework log grant space calculations
  xfs: fact out common grant head/log tail verification code
  xfs: convert log grant ticket queues to list heads
  xfs: use AIL bulk delete function to implement single delete
  xfs: use AIL bulk update function to implement single updates
  xfs: remove all the inodes on a buffer from the AIL in bulk
  xfs: consume iodone callback items on buffers as they are processed
  xfs: reduce the number of AIL push wakeups
  xfs: bulk AIL insertion during transaction commit
  xfs: clean up xfs_ail_delete()
  xfs: Pull EFI/EFD handling out from under the AIL lock
  xfs: fix EFI transaction cancellation.
  ...
-----------------------------

Since it included so many patches, I thought i will start a git-bisect
on xfs git tree at git://oss.sgi.com/xfs/xfs, and ended up at
92f1c008ae79e32b83c0607d184b194f302bb3ee, which is the same commit as
above.

Two questions:
1. Has anybody seen this problem ? I see this ASSERT has been added in
that patch set, is it a false-positive ?
2. Can anybody tell me how to use git bisect on xfs's git tree in this
context to pin point the commit that causes this problem ?

Here is the ASSERT log
---------------------------------
Feb 22 13:36:08 test135 root: ======== starting XFS test 011 2.6.38-rc6.1+ ========
Feb 22 13:36:09 test135 kernel: SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
Feb 22 13:36:09 test135 kernel: SGI XFS Quota Management subsystem
Feb 22 13:36:09 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
Feb 22 13:36:09 test135 kernel: XFS mounting filesystem sda6
Feb 22 13:36:09 test135 kernel: XFS: 512 byte sectors in use on device sda5.  This is suboptimal; 1024 or greater is ideal.
Feb 22 13:36:09 test135 kernel: XFS mounting filesystem sda5
Feb 22 13:36:10 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
Feb 22 13:36:10 test135 kernel: XFS mounting filesystem sda6
Feb 22 13:36:11 test135 kernel: Assertion failed: space <= BBTOB(tail_blocks), file: fs/xfs/xfs_log.c, line: 3435
Feb 22 13:36:11 test135 kernel: ------------[ cut here ]------------
Feb 22 13:36:11 test135 kernel: kernel BUG at fs/xfs/support/debug.c:100!
Feb 22 13:36:11 test135 kernel: Oops: Exception in kernel mode, sig: 5 [#1]
Feb 22 13:36:11 test135 kernel: SMP NR_CPUS=1024 NUMA pSeries
Feb 22 13:36:11 test135 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/host0/target0:255:0/0:255:0:0/block/sda/dev
Feb 22 13:36:11 test135 kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log ses enclosure sg ehea ext4 jbd2 mbcache sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt ipr dm_mod [last unloaded: scsi_wait_scan]
Feb 22 13:36:11 test135 kernel: NIP: d00000000bc20864 LR: d00000000bc20860 CTR: c000000000060ec0
Feb 22 13:36:11 test135 kernel: REGS: c0000007abd27410 TRAP: 0700   Not tainted  (2.6.38-rc6.1+)
Feb 22 13:36:11 test135 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28044484  XER: 20000003
Feb 22 13:36:11 test135 kernel: TASK = c0000007ac5c0f70[2129] 'dirstress' THREAD: c0000007abd24000 CPU: 5
Feb 22 13:36:11 test135 kernel: GPR00: d00000000bc20860 c0000007abd27690 d00000000bc72ab8 0000000000000058 
Feb 22 13:36:11 test135 kernel: GPR04: 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR08: 0000000000001e3d c000000000855538 00000000000053a0 0000000000900000 
Feb 22 13:36:11 test135 kernel: GPR12: 0000000028044482 c00000000f2a0c80 0000000000000000 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR16: 0000000000000000 0000000000000000 0000000000000003 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR20: c0000007ac5b3988 0000000000000002 0000000000000000 c0000007ac5b3980 
Feb 22 13:36:11 test135 kernel: GPR24: c0000007abdcbdb0 c0000007ac5b3998 c0000007abd27810 00000000000772d4 
Feb 22 13:36:11 test135 kernel: GPR28: 0000000000000000 c0000007abdcbd98 d00000000bc6c960 00000004008940d4 
Feb 22 13:36:11 test135 kernel: NIP [d00000000bc20864] .assfail+0x34/0x40 [xfs]
Feb 22 13:36:11 test135 kernel: LR [d00000000bc20860] .assfail+0x30/0x40 [xfs]
Feb 22 13:36:11 test135 kernel: Call Trace:
Feb 22 13:36:11 test135 kernel: [c0000007abd27690] [d00000000bc20860] .assfail+0x30/0x40 [xfs] (unreliable)
Feb 22 13:36:11 test135 kernel: [c0000007abd27710] [d00000000bbe9698] .xlog_verify_grant_tail+0x78/0xa0 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd277a0] [d00000000bbec96c] .xlog_grant_log_space+0x49c/0x750 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd278b0] [d00000000bc008bc] .xfs_trans_reserve+0x10c/0x310 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd27970] [d00000000bc06d1c] .xfs_symlink+0x28c/0x960 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd27af0] [d00000000bc1ae7c] .xfs_vn_symlink+0x6c/0x110 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd27bc0] [c0000000001b7f3c] .vfs_symlink+0xdc/0x140
Feb 22 13:36:11 test135 kernel: [c0000007abd27c60] [c0000000001bb954] .SyS_symlinkat+0x124/0x140
Feb 22 13:36:11 test135 kernel: [c0000007abd27dc0] [c0000000001b7878] .SyS_symlink+0x18/0x30
Feb 22 13:36:11 test135 kernel: [c0000007abd27e30] [c000000000008564] syscall_exit+0x0/0x40
Feb 22 13:36:11 test135 kernel: Instruction dump:
Feb 22 13:36:11 test135 kernel: fbc1fff0 ebc28228 7c691b78 7ca62b78 f8010010 f821ff81 7c802378 e87e8010 
Feb 22 13:36:11 test135 kernel: 7d244b78 7c050378 48001255 e8410028 <0fe00000> 48000000 60000000 7c0802a6 
Feb 22 13:36:11 test135 kernel: ---[ end trace 64d4d171f799e660 ]---
Feb 22 13:36:11 test135 kernel: Assertion failed: space <= BBTOB(tail_blocks), file: fs/xfs/xfs_log.c, line: 3435
Feb 22 13:36:11 test135 kernel: ------------[ cut here ]------------
Feb 22 13:36:11 test135 kernel: kernel BUG at fs/xfs/support/debug.c:100!
Feb 22 13:36:11 test135 kernel: Oops: Exception in kernel mode, sig: 5 [#2]
Feb 22 13:36:11 test135 kernel: SMP NR_CPUS=1024 NUMA pSeries
Feb 22 13:36:11 test135 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/host0/target0:255:0/0:255:0:0/block/sda/dev
Feb 22 13:36:11 test135 kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log ses enclosure sg ehea ext4 jbd2 mbcache sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt ipr dm_mod [last unloaded: scsi_wait_scan]
Feb 22 13:36:11 test135 kernel: NIP: d00000000bc20864 LR: d00000000bc20860 CTR: c000000000060ec0
Feb 22 13:36:11 test135 kernel: REGS: c0000007abd2b470 TRAP: 0700   Tainted: G      D      (2.6.38-rc6.1+)
Feb 22 13:36:11 test135 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28044484  XER: 20000003
Feb 22 13:36:11 test135 kernel: TASK = c000000798876310[2132] 'dirstress' THREAD: c0000007abd28000 CPU: 9
Feb 22 13:36:11 test135 kernel: GPR00: d00000000bc20860 c0000007abd2b6f0 d00000000bc72ab8 0000000000000058 
Feb 22 13:36:11 test135 kernel: GPR04: 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR08: 00000000000013f0 c000000000855538 0000000000002690 0000000000940000 
Feb 22 13:36:11 test135 kernel: GPR12: 0000000028044482 c00000000f2a1680 0000000000000000 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR16: 0000000000000000 0000000000000000 0000000000000003 0000000000000000 
Feb 22 13:36:11 test135 kernel: GPR20: c0000007ac5b3988 0000000000000002 0000000000000000 c0000007ac5b3980 
Feb 22 13:36:11 test135 kernel: GPR24: c0000007acbe1a68 c0000007ac5b3998 c0000007abd2b870 0000000000076b54 
Feb 22 13:36:11 test135 kernel: GPR28: 0000000000000000 c0000007acbe1a50 d00000000bc6c960 000000050014d25c 
Feb 22 13:36:11 test135 kernel: NIP [d00000000bc20864] .assfail+0x34/0x40 [xfs]
Feb 22 13:36:11 test135 kernel: LR [d00000000bc20860] .assfail+0x30/0x40 [xfs]
Feb 22 13:36:11 test135 kernel: Call Trace:
Feb 22 13:36:11 test135 kernel: [c0000007abd2b6f0] [d00000000bc20860] .assfail+0x30/0x40 [xfs] (unreliable)
Feb 22 13:36:11 test135 kernel: [c0000007abd2b770] [d00000000bbe9698] .xlog_verify_grant_tail+0x78/0xa0 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd2b800] [d00000000bbec96c] .xlog_grant_log_space+0x49c/0x750 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd2b910] [d00000000bc008bc] .xfs_trans_reserve+0x10c/0x310 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd2b9d0] [d00000000bc08454] .xfs_create+0x184/0x880 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd2baf0] [d00000000bc1afbc] .xfs_vn_mknod+0x9c/0x240 [xfs]
Feb 22 13:36:11 test135 kernel: [c0000007abd2bbc0] [c0000000001b8088] .vfs_mkdir+0xe8/0x150
Feb 22 13:36:11 test135 kernel: [c0000007abd2bc70] [c0000000001bb588] .SyS_mkdirat+0x148/0x160
Feb 22 13:36:11 test135 kernel: [c0000007abd2bdc0] [c0000000001b798c] .SyS_mkdir+0x1c/0x30
Feb 22 13:36:11 test135 kernel: [c0000007abd2be30] [c000000000008564] syscall_exit+0x0/0x40
Feb 22 13:36:11 test135 kernel: Instruction dump:
Feb 22 13:36:11 test135 kernel: fbc1fff0 ebc28228 7c691b78 7ca62b78 f8010010 f821ff81 7c802378 e87e8010 
Feb 22 13:36:11 test135 kernel: 7d244b78 7c050378 48001255 e8410028 <0fe00000> 48000000 60000000 7c0802a6 
Feb 22 13:36:11 test135 kernel: ---[ end trace 64d4d171f799e661 ]---
Feb 22 13:36:12 test135 kernel: Assertion failed: space <= BBTOB(tail_blocks), file: fs/xfs/xfs_log.c, line: 3435
Feb 22 13:36:12 test135 kernel: ------------[ cut here ]------------
Feb 22 13:36:12 test135 kernel: kernel BUG at fs/xfs/support/debug.c:100!
Feb 22 13:36:12 test135 kernel: Oops: Exception in kernel mode, sig: 5 [#3]
Feb 22 13:36:12 test135 kernel: SMP NR_CPUS=1024 NUMA pSeries
Feb 22 13:36:12 test135 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/host0/target0:255:0/0:255:0:0/block/sda/dev
Feb 22 13:36:12 test135 kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log ses enclosure sg ehea ext4 jbd2 mbcache sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt ipr dm_mod [last unloaded: scsi_wait_scan]
Feb 22 13:36:12 test135 kernel: NIP: d00000000bc20864 LR: d00000000bc20860 CTR: c000000000060ec0
Feb 22 13:36:12 test135 kernel: REGS: c0000007a7fff2c0 TRAP: 0700   Tainted: G      D      (2.6.38-rc6.1+)
Feb 22 13:36:12 test135 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28044484  XER: 20000003
Feb 22 13:36:12 test135 kernel: TASK = c0000007ac5c0390[2130] 'dirstress' THREAD: c0000007a7ffc000 CPU: 8
Feb 22 13:36:12 test135 kernel: GPR00: d00000000bc20860 c0000007a7fff540 d00000000bc72ab8 0000000000000058 
Feb 22 13:36:12 test135 kernel: GPR04: 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000 
Feb 22 13:36:12 test135 kernel: GPR08: 00000000000009a2 c000000000855538 0000000000008ca0 0000000000930000 
Feb 22 13:36:12 test135 kernel: GPR12: 0000000028044482 c00000000f2a1400 0000000000000000 0000000000000000 
Feb 22 13:36:12 test135 kernel: GPR16: 0000000000000000 0000000000000000 0000000000000003 0000000000000000 
Feb 22 13:36:12 test135 kernel: GPR20: c0000007ac5b3988 0000000000000002 0000000000000000 c0000007ac5b3980 
Feb 22 13:36:12 test135 kernel: GPR24: c0000007acbe9128 c0000007ac5b3998 c0000007a7fff6c0 00000000000a689c 
Feb 22 13:36:12 test135 kernel: GPR28: 0000000000000000 c0000007acbe9110 d00000000bc6c960 000000050057ca64 
Feb 22 13:36:12 test135 kernel: NIP [d00000000bc20864] .assfail+0x34/0x40 [xfs]
Feb 22 13:36:12 test135 kernel: LR [d00000000bc20860] .assfail+0x30/0x40 [xfs]
Feb 22 13:36:12 test135 kernel: Call Trace:
Feb 22 13:36:12 test135 kernel: [c0000007a7fff540] [d00000000bc20860] .assfail+0x30/0x40 [xfs] (unreliable)
Feb 22 13:36:12 test135 kernel: [c0000007a7fff5c0] [d00000000bbe9698] .xlog_verify_grant_tail+0x78/0xa0 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fff650] [d00000000bbec96c] .xlog_grant_log_space+0x49c/0x750 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fff760] [d00000000bc008bc] .xfs_trans_reserve+0x10c/0x310 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fff820] [d00000000bb9bad8] .xfs_attr_set_int+0x178/0x570 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fff990] [d00000000bb9c288] .xfs_attr_set+0xb8/0xe0 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fffa50] [d00000000bc1add8] .xfs_init_security+0x88/0xc0 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fffaf0] [d00000000bc1afdc] .xfs_vn_mknod+0xbc/0x240 [xfs]
Feb 22 13:36:12 test135 kernel: [c0000007a7fffbc0] [c0000000001b820c] .vfs_mknod+0x11c/0x1a0
Feb 22 13:36:12 test135 kernel: [c0000007a7fffc60] [c0000000001bb7e0] .SyS_mknodat+0x240/0x290
Feb 22 13:36:12 test135 kernel: [c0000007a7fffdc0] [c0000000001b79c4] .SyS_mknod+0x24/0x40
Feb 22 13:36:12 test135 kernel: [c0000007a7fffe30] [c000000000008564] syscall_exit+0x0/0x40
Feb 22 13:36:12 test135 kernel: Instruction dump:
Feb 22 13:36:12 test135 kernel: fbc1fff0 ebc28228 7c691b78 7ca62b78 f8010010 f821ff81 7c802378 e87e8010 
Feb 22 13:36:12 test135 kernel: 7d244b78 7c050378 48001255 e8410028 <0fe00000> 48000000 60000000 7c0802a6 
Feb 22 13:36:12 test135 kernel: ---[ end trace 64d4d171f799e662 ]---
---------------------------------

Thanks.

chandra
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
