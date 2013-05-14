Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4BF857CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 21:28:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 099AA30405F
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 19:28:26 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id iiIQTnaVTdCDTSUc for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 19:28:25 -0700 (PDT)
Date: Mon, 13 May 2013 22:28:23 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1140911111.191794.1368498503318.JavaMail.root@redhat.com>
In-Reply-To: <51895115.90108@sandeen.net>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
Subject: Re: 3.9.0: XFS rootfs corruption
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

3.10-rc1 has the same problem reproduced on 2 Power 7 systems. I am going to
get the metadata dump this time.

CAI Qian


  OK     
] Started Setup Virtual Console. 
[      
  OK     
] Reached target System Initialization. 
[    1.430947] device-mapper: uevent: version 1.0.3 
[    1.431120] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com 
[      
  OK     
] Started dracut pre-udev hook. 
         Starting udev Kernel Device Manager... 
[    1.453958] systemd-udevd[244]: starting version 197 
[      
  OK     
] Started udev Kernel Device Manager. 
         Starting dracut pre-trigger hook... 
[      
  OK     
] Started dracut pre-trigger hook. 
         Starting udev Coldplug all Devices... 
[      
  OK     
] Started udev Coldplug all Devices. 
         Starting Show Plymouth Boot Screen... 
         Starting dracut initqueue hook... 
[    1.546875] ibmvscsi 30000003: SRP_VERSION: 16.a 
[    1.547169] scsi0 : IBM POWER Virtual SCSI Adapter 1.5.9 
[    1.547430] ibmvscsi 30000003: partner initialization complete 
[    1.547533] ibmvscsi 30000003: host srp version: 16.a, host partition vios (1), OS 3, max io 262144 
[    1.547684] ibmvscsi 30000003: Client reserve enabled 
[    1.547713] ibmvscsi 30000003: sent SRP login 
[    1.547798] ibmvscsi 30000003: SRP_LOGIN succeeded 
[    1.564079] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3 
[    1.608450] sd 0:0:1:0: [sda] 209715200 512-byte logical blocks: (107 GB/100 GiB) 
[    1.608555] sd 0:0:1:0: [sda] Write Protect is off 
[    1.608653] sd 0:0:1:0: [sda] Cache data unavailable 
[    1.608663] sd 0:0:1:0: [sda] Assuming drive cache: write through 
[    1.609140] sd 0:0:1:0: [sda] Cache data unavailable 
[    1.609152] sd 0:0:1:0: [sda] Assuming drive cache: write through 
[    1.621164]  sda: sda1 sda2 sda3 
[    1.621841] sd 0:0:1:0: [sda] Cache data unavailable 
[    1.621849] sd 0:0:1:0: [sda] Assuming drive cache: write through 
[    1.621858] sd 0:0:1:0: [sda] Attached SCSI disk 
[      
  OK     
] Started Show Plymouth Boot Screen.  
[      
  OK     
] Reached target Basic System.  
[    1.871350] bio: create slab <bio-1> at 1 
[    2.030633] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled 
[    2.033824] XFS (dm-1): Mounting Filesystem 
[    2.180799] XFS (dm-1): Starting recovery (logdev: internal) 
[    2.658307] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000239703c 
[    2.658307]  
[    2.658352] CPU: 14 PID: 372 Comm: mount Not tainted 3.10.0-rc1 #1 
[    2.658360] Call Trace: 
[    2.658370] [c0000003e7c02b40] [c000000000014e28] .show_stack+0x78/0x1e0 (unreliable) 
[    2.658387] [c0000003e7c02c10] [c000000000747834] .dump_stack+0x28/0x3c 
[    2.658441] [c0000003e7c02c80] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
[    2.658497] [c0000003e7c02cf0] [d000000002396ee4] .__xfs_dir3_data_check+0x784/0x820 [xfs] 
[    2.658553] [c0000003e7c02df0] [d00000000239703c] .xfs_dir3_data_verify+0xbc/0xe0 [xfs] 
[    2.658617] [c0000003e7c02e70] [d00000000239709c] .xfs_dir3_data_write_verify+0x3c/0x1c0 [xfs] 
[    2.658670] [c0000003e7c02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
[    2.658732] [c0000003e7c03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    2.658784] [c0000003e7c030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    2.658837] [c0000003e7c03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
[    2.658898] [c0000003e7c03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    2.658964] [c0000003e7c03310] [d0000000023b1964] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
[    2.659031] [c0000003e7c033d0] [d0000000023b1cac] .xlog_recover_process_data+0x26c/0x340 [xfs] 
[    2.659089] [c0000003e7c034a0] [d0000000023b2168] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
[    2.659155] [c0000003e7c03610] [d0000000023b23c0] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
[    2.659221] [c0000003e7c036b0] [d0000000023b2460] .xlog_do_recover+0x20/0x150 [xfs] 
[    2.659287] [c0000003e7c03740] [d0000000023b2624] .xlog_recover+0x94/0x100 [xfs] 
[    2.659344] [c0000003e7c037d0] [d0000000023bcfe4] .xfs_log_mount+0x144/0x1e0 [xfs] 
[    2.659410] [c0000003e7c03870] [d0000000023b60f8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    2.659473] [c0000003e7c03930] [d0000000023643ac] .xfs_fs_fill_super+0x32c/0x3c0 [xfs] 
[    2.659498] [c0000003e7c039d0] [c000000000215e08] .mount_bdev+0x258/0x2b0 
[    2.659561] [c0000003e7c03aa0] [d000000002361cb8] .xfs_fs_mount+0x18/0x30 [xfs] 
[    2.659583] [c0000003e7c03b10] [c000000000216e10] .mount_fs+0x70/0x220 
[    2.659595] [c0000003e7c03bd0] [c000000000239708] .vfs_kern_mount+0x58/0x140 
[    2.659615] [c0000003e7c03c80] [c00000000023c330] .do_mount+0x2b0/0xb00 
[    2.659626] [c0000003e7c03d70] [c00000000023cc30] .SyS_mount+0xb0/0x110 
[    2.659639] [c0000003e7c03e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    2.659651] c0000003eb671000: 58 44 32 44 09 50 00 40 0a 50 00 40 0b 50 00 40  XD2D.P.@.P.@.P.@ 
[    2.659663] c0000003eb671010: 00 00 00 00 00 a0 78 53 32 62 65 61 68 5f 74 61  ......xS2beah_ta 
[    2.659674] c0000003eb671020: 73 6b 5f 32 31 39 39 63 63 39 37 2d 64 66 32 31  sk_2199cc97-df21 
[    2.659694] c0000003eb671030: 2d 34 66 63 31 2d 39 39 61 63 2d 32 64 64 34 39  -4fc1-99ac-2dd49 
[    2.659707] XFS (dm-1): Internal error xfs_dir3_data_write_verify at line 271 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000234db94 
[    2.659707]  
[    2.659723] CPU: 14 PID: 372 Comm: mount Not tainted 3.10.0-rc1 #1 
[    2.659731] Call Trace: 
[    2.659737] [c0000003e7c02c10] [c000000000014e28] .show_stack+0x78/0x1e0 (unreliable) 
[    2.659751] [c0000003e7c02ce0] [c000000000747834] .dump_stack+0x28/0x3c 
[    2.659812] [c0000003e7c02d50] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
[    2.659874] [c0000003e7c02dc0] [d00000000234ffac] .xfs_corruption_error+0x7c/0xb0 [xfs] 
[    2.659929] [c0000003e7c02e70] [d0000000023971a8] .xfs_dir3_data_write_verify+0x148/0x1c0 [xfs] 
[    2.659992] [c0000003e7c02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
[    2.660053] [c0000003e7c03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    2.660115] [c0000003e7c030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    2.660169] [c0000003e7c03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
[    2.660230] [c0000003e7c03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    2.660296] [c0000003e7c03310] [d0000000023b1964] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
[    2.660363] [c0000003e7c033d0] [d0000000023b1cac] .xlog_recover_process_data+0x26c/0x340 [xfs] 
[    2.660420] [c0000003e7c034a0] [d0000000023b2168] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
[    2.660485] [c0000003e7c03610] [d0000000023b23c0] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
[    2.660552] [c0000003e7c036b0] [d0000000023b2460] .xlog_do_recover+0x20/0x150 [xfs] 
[    2.660608] [c0000003e7c03740] [d0000000023b2624] .xlog_recover+0x94/0x100 [xfs] 
[    2.660675] [c0000003e7c037d0] [d0000000023bcfe4] .xfs_log_mount+0x144/0x1e0 [xfs] 
[    2.660741] [c0000003e7c03870] [d0000000023b60f8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    2.660795] [c0000003e7c03930] [d0000000023643ac] .xfs_fs_fill_super+0x32c/0x3c0 [xfs] 
[    2.660817] [c0000003e7c039d0] [c000000000215e08] .mount_bdev+0x258/0x2b0 
[    2.660869] [c0000003e7c03aa0] [d000000002361cb8] .xfs_fs_mount+0x18/0x30 [xfs] 
[    2.660881] [c0000003e7c03b10] [c000000000216e10] .mount_fs+0x70/0x220 
[    2.660902] [c0000003e7c03bd0] [c000000000239708] .vfs_kern_mount+0x58/0x140 
[    2.660913] [c0000003e7c03c80] [c00000000023c330] .do_mount+0x2b0/0xb00 
[    2.660923] [c0000003e7c03d70] [c00000000023cc30] .SyS_mount+0xb0/0x110 
[    2.660944] [c0000003e7c03e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    2.660954] XFS (dm-1): Corruption detected. Unmount and run xfs_repair 
[    2.660965] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1364 of file fs/xfs/xfs_buf.c.  Return address = 0xd00000000234de84 
[    2.660979] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem 
[    2.660989] XFS (dm-1): Please umount the filesystem and rectify the problem(s) 
[    2.661013] XFS (dm-1): metadata I/O error: block 0xd6060 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661026] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661041] XFS (dm-1): metadata I/O error: block 0xd7940 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661053] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661069] XFS (dm-1): metadata I/O error: block 0xe0190 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661091] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661106] XFS (dm-1): metadata I/O error: block 0x379590 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661118] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661134] XFS (dm-1): metadata I/O error: block 0x45f5e0 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661154] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661169] XFS (dm-1): metadata I/O error: block 0x5483c0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661181] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661197] XFS (dm-1): metadata I/O error: block 0x576190 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661218] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661233] XFS (dm-1): metadata I/O error: block 0x57acc8 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661245] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661261] XFS (dm-1): metadata I/O error: block 0x1900002 ("xlog_recover_iodone") error 5 numblks 1 
[    2.661282] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661297] XFS (dm-1): metadata I/O error: block 0x1900018 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661309] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661324] XFS (dm-1): metadata I/O error: block 0x1900030 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661346] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661361] XFS (dm-1): metadata I/O error: block 0x19004f0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661373] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661389] XFS (dm-1): metadata I/O error: block 0x1900540 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661411] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661427] XFS (dm-1): metadata I/O error: block 0x1900558 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661439] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661454] XFS (dm-1): metadata I/O error: block 0x197fe10 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661476] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661491] XFS (dm-1): metadata I/O error: block 0x19b9f70 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661503] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661518] XFS (dm-1): metadata I/O error: block 0x1f02c50 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661541] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661557] XFS (dm-1): metadata I/O error: block 0x1f0cea0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661569] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661584] XFS (dm-1): metadata I/O error: block 0x4b00001 ("xlog_recover_iodone") error 5 numblks 1 
[    2.661605] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661621] XFS (dm-1): metadata I/O error: block 0x4b00002 ("xlog_recover_iodone") error 5 numblks 1 
[    2.661633] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661648] XFS (dm-1): metadata I/O error: block 0x4bad410 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661670] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661685] XFS (dm-1): metadata I/O error: block 0x4c0aca0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661697] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661713] XFS (dm-1): metadata I/O error: block 0x4c1b3d0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661725] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661740] XFS (dm-1): metadata I/O error: block 0x4d0aa68 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661771] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661786] XFS (dm-1): metadata I/O error: block 0x4d0aab8 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661808] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661823] XFS (dm-1): metadata I/O error: block 0x4f42630 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661836] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661851] XFS (dm-1): metadata I/O error: block 0x4f42640 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661872] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661888] XFS (dm-1): metadata I/O error: block 0x4f42cb8 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661900] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661915] XFS (dm-1): metadata I/O error: block 0x4f5e8f0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.661936] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.661952] XFS (dm-1): metadata I/O error: block 0x4f67a10 ("xlog_recover_iodone") error 5 numblks 8 
[    2.661974] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.662043] XFS (dm-1): metadata I/O error: block 0xd6018 ("xlog_recover_iodone") error 117 numblks 8 
[    2.662055] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023adad0 
[    2.677551] XFS (dm-1): log mount/recovery failed: error 117 
[    2.677627] XFS (dm-1): log mount failed 
dracut-initqueue[273]: mount: mount /dev/mapper/rhel_ibm--p730--06--lp1-root on /sysroot failed: Structure needs cleaning  
dracut-initqueue[273]: Warning: Failed to mount -t xfs -o ro,ro /dev/mapper/rhel_ibm--p730--06--lp1-root /sysroot  
dracut-initqueue[273]: Warning: *** An error occurred during the file system check.  
dracut-initqueue[273]: Warning: *** Dropping you to a shell; the system will try  
dracut-initqueue[273]: Warning: *** to mount the filesystem(s), when you leave the shell.  
[      
  OK     
] Started Show Plymouth Boot Screen.  
[      
  OK     
] Reached target Basic System.  
dracut-initqueue[273]: mount: mount /dev/mapper/rhel_ibm--p730--06--lp1-root on /sysroot failed: Structure needs cleaning  
dracut-initqueue[273]: Warning: Failed to mount -t xfs -o ro,ro /dev/mapper/rhel_ibm--p730--06--lp1-root /sysroot  
dracut-initqueue[273]: Warning: *** An error occurred during the file system check.  
dracut-initqueue[273]: Warning: *** Dropping you to a shell; the system will try  
dracut-initqueue[273]: Warning: *** to mount the filesystem(s), when you leave the shell.  
dracut-initqueue[273]: Warning: 
 
 
Entering emergency mode. Exit the shell to continue. 
Type "journalctl" to view system logs. 
 
(Repair:/

----- Original Message -----
> From: "Eric Sandeen" <sandeen@sandeen.net>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com
> Sent: Wednesday, May 8, 2013 3:08:05 AM
> Subject: Re: 3.9.0: XFS rootfs corruption
> 
> On 5/7/13 2:53 AM, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> >> From: "Eric Sandeen" <sandeen@sandeen.net>
> >> To: "CAI Qian" <caiqian@redhat.com>
> >> Cc: xfs@oss.sgi.com
> >> Sent: Monday, May 6, 2013 10:31:01 PM
> >> Subject: Re: 3.9.0: XFS rootfs corruption
> >>
> >> On 5/6/13 2:50 AM, CAI Qian wrote:
> >>> Saw this on several different Power7 systems after kdump reboot. It has
> >>> xfsprogs-3.1.10
> >>> and rootfs in on LVM. Never saw one of those in any of the RC releases.
> >>>
> >>> ] Reached target Basic System.
> >>> [    4.919316] bio: create slab <bio-1> at 1
> >>> [    5.078616] SGI XFS with ACLs, security attributes, large block/inode
> >>> numbers, no debug enabled
> >>> [    5.081925] XFS (dm-1): Mounting Filesystem
> >>> [    5.168530] XFS (dm-1): Starting recovery (logdev: internal)
> >>> [    5.333575] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176
> >>> of
> >>> file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000002396fdc
> >>
> >> here:
> >>
> >>         /*
> >>          * Need to have seen all the entries and all the bestfree slots.
> >>          */
> >>         XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
> >>
> >> I hope Dave knows offhand what this might mean.  :)
> >>
> >> Could you get a metadump of the filesystem in question?
> > Err, less familiar here. May I ask how can I do that?
> 
> since it's the root fs, you might need to do it from some sort of rescue
> shell, then just do xfs_metadump /dev/<device> <metadump filename>
> 
> the resulting file should compress further with something like bzip2.
> 
> ...
> 
> >>> Also, never saw any of those in other architectures like x64, but started
> >>> get those there in 3.9.0.
> >>> Unsure if those are related.
> >>>
> >>> [ 3224.369782]
> >>> =============================================================================
> >>> [ 3224.370017] BUG xfs_efi_item (Tainted: GF   B       ): Poison
> >>> overwritten
> >>> [ 3224.370017]
> >>> -----------------------------------------------------------------------------
> >>
> >>   2: 'F' if any module was force loaded by "insmod -f", ' ' if all
> >>      modules were loaded normally.
> >>
> >> Force loaded modules, what's that from?
> > This could be just happened after the booting done or we were running a
> > stress test later
> > that does load (modprobe *) and unload (modprobe -r *) every module. Again,
> > those warnings
> > could be totally unrelated to the above rootfs corruption.
> > CAI Qian
> 
> hmmm :)  So any one of those modules could have caused memory corruption I
> guess.
> 
> If you can hit it reliably you might try to narrow it down to whether it
> is a particular module causing it.
> 
> -Eric
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
