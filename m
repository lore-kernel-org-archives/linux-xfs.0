Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1J1JTMM249804 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 19:19:30 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97B942EA8E8
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 17:22:10 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id 6D3AT29h42gG7NjF for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 17:22:10 -0800 (PST)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1J11wQs025831
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 20:01:58 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1J1LreF2539658
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 20:21:53 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1J1LrC7002253 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 20:21:53 -0500
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p1J1LqvD002209 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 20:21:52 -0500
Subject: xfstests 071 trips an ASSERT due to commit
	055388a3188f56676c21e92962fc366ac8b5cb72
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 18 Feb 2011 17:24:53 -0800
Message-ID: <1298078693.32230.398.camel@chandra-lucid.beaverton.ibm.com>
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
To: xfs@oss.sgi.com

Hello,

In My POWER system, I saw 2 new ASSERTs when I ran the xfstests (071 and
087) on 2.6.38-rc4 that I did not see in 2.6.37.

I did a git bisect and the following commit is the one causes the ASSERT
when 071 was run (still working on git-bisect of 087).

Note that the 512 byte sectors warning is printed when the pagesize is
64K. That message is not printed when I change the pagesize to 4K, but
the ASSERT still trips.

-----------------------------------------
commit 055388a3188f56676c21e92962fc366ac8b5cb72
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jan 4 11:35:03 2011 +1100

    xfs: dynamic speculative EOF preallocation
    
    Currently the size of the speculative preallocation during delayed
    allocation is fixed by either the allocsize mount option of a
    default size. We are seeing a lot of cases where we need to
    recommend using the allocsize mount option to prevent fragmentation
    when buffered writes land in the same AG.
------------------------------------------

and here is the log
-------------------------------------------

Feb 18 16:25:40 test135 root: ======== starting XFS test 071 2.6.37-bad+ ========
Feb 18 16:25:41 test135 kernel: SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
Feb 18 16:25:41 test135 kernel: SGI XFS Quota Management subsystem
Feb 18 16:25:41 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
Feb 18 16:25:41 test135 kernel: XFS mounting filesystem sda6
Feb 18 16:25:42 test135 kernel: XFS: 512 byte sectors in use on device sda5.  This is suboptimal; 1024 or greater is ideal.
Feb 18 16:25:42 test135 kernel: XFS mounting filesystem sda5
Feb 18 16:25:42 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
Feb 18 16:25:42 test135 kernel: XFS mounting filesystem sda6
Feb 18 16:25:43 test135 kernel: XFS: 512 byte sectors in use on device sda5.  This is suboptimal; 1024 or greater is ideal.
Feb 18 16:25:43 test135 kernel: XFS mounting filesystem sda5
Feb 18 16:25:44 test135 kernel: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/linux-2.6/xfs_super.c, line: 915
Feb 18 16:25:44 test135 kernel: ------------[ cut here ]------------
Feb 18 16:25:44 test135 kernel: kernel BUG at fs/xfs/support/debug.c:108!
Feb 18 16:25:44 test135 kernel: Oops: Exception in kernel mode, sig: 5 [#1]
Feb 18 16:25:44 test135 kernel: SMP NR_CPUS=1024 NUMA pSeries
Feb 18 16:25:44 test135 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/host0/target0:255:0/0:255:0:0/block/sda/dev
Feb 18 16:25:44 test135 kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log ses enclosure sg ehea ext4 jbd2 mbcache sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt ipr dm_mod [last unloaded: scsi_wait_scan]
Feb 18 16:25:44 test135 kernel: NIP: d00000000bc8fa24 LR: d00000000bc8fa20 CTR: 0000000000000001
Feb 18 16:25:44 test135 kernel: REGS: c0000007aaea7550 TRAP: 0700   Not tainted  (2.6.37-bad+)
Feb 18 16:25:44 test135 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28004484  XER: 20000000
Feb 18 16:25:44 test135 kernel: TASK = c0000007a9199b70[2795] 'umount' THREAD: c0000007aaea4000 CPU: 9
Feb 18 16:25:44 test135 kernel: GPR00: d00000000bc8fa20 c0000007aaea77d0 d00000000bce18b8 0000000000000080 
Feb 18 16:25:44 test135 kernel: GPR04: 0000000000000000 ffffffffffffffff 0000000000000004 0000000000080000 
Feb 18 16:25:44 test135 kernel: GPR08: 00000000000050bc c0000000008753b8 0000000000005041 0000000000c20000 
Feb 18 16:25:44 test135 kernel: GPR12: 0000000028004482 c00000000f2a1680 000000004196e380 000000004196e388 
Feb 18 16:25:44 test135 kernel: GPR16: 000000004196e320 000000004196e390 000000004196e398 000000004196e3a8 
Feb 18 16:25:44 test135 kernel: GPR20: 000000004196e190 c0000007b10904b0 c000000001268848 c0000007b0b1db40 
Feb 18 16:25:44 test135 kernel: GPR24: 0000000000000000 0000000000000000 c0000000012685fc c0000000012685f8 
Feb 18 16:25:44 test135 kernel: GPR28: 0000000000000000 c0000007b0b1db20 d00000000bcdb830 c0000007b0b1d980 
Feb 18 16:25:44 test135 kernel: NIP [d00000000bc8fa24] .assfail+0x34/0x40 [xfs]
Feb 18 16:25:44 test135 kernel: LR [d00000000bc8fa20] .assfail+0x30/0x40 [xfs]
Feb 18 16:25:44 test135 kernel: Call Trace:
Feb 18 16:25:44 test135 kernel: [c0000007aaea77d0] [d00000000bc8fa20] .assfail+0x30/0x40 [xfs] (unreliable)
Feb 18 16:25:44 test135 kernel: [c0000007aaea7850] [d00000000bc8b208] .xfs_fs_destroy_inode+0xd8/0x200 [xfs]
Feb 18 16:25:44 test135 kernel: [c0000007aaea78e0] [c0000000001c9108] .destroy_inode+0x68/0xc0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7960] [c0000000001c9264] .dispose_list+0x104/0x150
Feb 18 16:25:44 test135 kernel: [c0000007aaea7a20] [c0000000001c95d0] .evict_inodes+0x160/0x1b0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7ae0] [c0000000001af048] .generic_shutdown_super+0x88/0x170
Feb 18 16:25:44 test135 kernel: [c0000007aaea7b70] [c0000000001af158] .kill_block_super+0x28/0x60
Feb 18 16:25:44 test135 kernel: [c0000007aaea7c00] [c0000000001adbfc] .deactivate_locked_super+0x8c/0xc0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7c90] [c0000000001cf7b0] .mntput_no_expire+0x140/0x1f0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7d30] [c0000000001d0f48] .SyS_umount+0xe8/0x440
Feb 18 16:25:44 test135 kernel: [c0000007aaea7e30] [c000000000008564] syscall_exit+0x0/0x40
Feb 18 16:25:44 test135 kernel: Instruction dump:
Feb 18 16:25:44 test135 kernel: fbc1fff0 ebc28220 7c691b78 7ca62b78 f8010010 f821ff81 7c802378 e87e8010 
Feb 18 16:25:44 test135 kernel: 7d244b78 7c050378 48001295 e8410028 <0fe00000> 48000000 60000000 7c0802a6 
Feb 18 16:25:44 test135 kernel: ---[ end trace 11fadf36d83e70cb ]---
Feb 18 16:25:44 test135 kernel: ------------[ cut here ]------------
Feb 18 16:25:44 test135 kernel: WARNING: at kernel/exit.c:910
Feb 18 16:25:44 test135 kernel: Modules linked in: xfs exportfs autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log ses enclosure sg ehea ext4 jbd2 mbcache sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt ipr dm_mod [last unloaded: scsi_wait_scan]
Feb 18 16:25:44 test135 kernel: NIP: c00000000008eb78 LR: c00000000008eb60 CTR: c0000000000609c0
Feb 18 16:25:44 test135 kernel: REGS: c0000007aaea6f00 TRAP: 0700   Tainted: G      D      (2.6.37-bad+)
Feb 18 16:25:44 test135 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28004482  XER: 00000006
Feb 18 16:25:44 test135 kernel: TASK = c0000007a9199b70[2795] 'umount' THREAD: c0000007aaea4000 CPU: 9
Feb 18 16:25:44 test135 kernel: GPR00: 0000000000000001 c0000007aaea7180 c000000000d709a0 0000000000000000 
Feb 18 16:25:44 test135 kernel: GPR04: 0000000000000000 c0000007a9199b70 ffffffffffffffff 0000000000000000 
Feb 18 16:25:44 test135 kernel: GPR08: 0000000000005b2d 0000000000000001 000000000000f908 0000000000000000 
Feb 18 16:25:44 test135 kernel: GPR12: 0000000028004484 c00000000f2a1680 000000004196e380 000000004196e388 
Feb 18 16:25:44 test135 kernel: GPR16: 000000004196e320 000000004196e390 000000004196e398 000000004196e3a8 
Feb 18 16:25:44 test135 kernel: GPR20: 000000004196e190 c0000007b10904b0 c000000001268848 c0000007b0b1db40 
Feb 18 16:25:44 test135 kernel: GPR24: 0000000000000000 c0000007aaea73d4 c00000000072ef38 0000000000000001 
Feb 18 16:25:44 test135 kernel: GPR28: c000000000c92ca0 0000000000000005 c000000000d05508 c0000007a9199b70 
Feb 18 16:25:44 test135 kernel: NIP [c00000000008eb78] .do_exit+0x78/0x870
Feb 18 16:25:44 test135 kernel: LR [c00000000008eb60] .do_exit+0x60/0x870
Feb 18 16:25:44 test135 kernel: Call Trace:
Feb 18 16:25:44 test135 kernel: [c0000007aaea7180] [c00000000008eb60] .do_exit+0x60/0x870 (unreliable)
Feb 18 16:25:44 test135 kernel: [c0000007aaea7280] [c00000000002eb64] .die+0x164/0x2c0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7320] [c00000000002f060] ._exception+0x100/0x1c0
Feb 18 16:25:44 test135 kernel: [c0000007aaea74e0] [c000000000004b9c] program_check_common+0x11c/0x180
Feb 18 16:25:44 test135 kernel: --- Exception: 700 at .assfail+0x34/0x40 [xfs]
Feb 18 16:25:44 test135 kernel:    LR = .assfail+0x30/0x40 [xfs]
Feb 18 16:25:44 test135 kernel: [c0000007aaea7850] [d00000000bc8b208] .xfs_fs_destroy_inode+0xd8/0x200 [xfs]
Feb 18 16:25:44 test135 kernel: [c0000007aaea78e0] [c0000000001c9108] .destroy_inode+0x68/0xc0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7960] [c0000000001c9264] .dispose_list+0x104/0x150
Feb 18 16:25:44 test135 kernel: [c0000007aaea7a20] [c0000000001c95d0] .evict_inodes+0x160/0x1b0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7ae0] [c0000000001af048] .generic_shutdown_super+0x88/0x170
Feb 18 16:25:44 test135 kernel: [c0000007aaea7b70] [c0000000001af158] .kill_block_super+0x28/0x60
Feb 18 16:25:44 test135 kernel: [c0000007aaea7c00] [c0000000001adbfc] .deactivate_locked_super+0x8c/0xc0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7c90] [c0000000001cf7b0] .mntput_no_expire+0x140/0x1f0
Feb 18 16:25:44 test135 kernel: [c0000007aaea7d30] [c0000000001d0f48] .SyS_umount+0xe8/0x440
Feb 18 16:25:44 test135 kernel: [c0000007aaea7e30] [c000000000008564] syscall_exit+0x0/0x40
Feb 18 16:25:44 test135 kernel: Instruction dump:
Feb 18 16:25:44 test135 kernel: ebc2b218 f821ff01 7c7d1b78 ebed01e8 7fe3fb78 48032675 60000000 813f0b5c 
Feb 18 16:25:44 test135 kernel: 7d2bfe70 7d604a78 7c005850 54000ffe <0b000000> 783c0464 801c0014 5409016f 
Feb 18 16:25:44 test135 kernel: ---[ end trace 11fadf36d83e70cc ]---

---------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
