Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC57729DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 02:50:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0F038F8052
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 00:50:16 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id NArzvk0HR49FGJLS for
	<xfs@oss.sgi.com>; Mon, 06 May 2013 00:50:14 -0700 (PDT)
Received: from zmail14.collab.prod.int.phx2.redhat.com
	(zmail14.collab.prod.int.phx2.redhat.com [10.5.83.16])
	by mx4-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r467oELg005551
	for <xfs@oss.sgi.com>; Mon, 6 May 2013 03:50:14 -0400
Date: Mon, 6 May 2013 03:50:13 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
In-Reply-To: <2105365384.7582278.1367825507929.JavaMail.root@redhat.com>
Subject: 3.9.0: XFS rootfs corruption
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

Saw this on several different Power7 systems after kdump reboot. It has xfsprogs-3.1.10
and rootfs in on LVM. Never saw one of those in any of the RC releases.

] Reached target Basic System.  
[    4.919316] bio: create slab <bio-1> at 1 
[    5.078616] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled 
[    5.081925] XFS (dm-1): Mounting Filesystem 
[    5.168530] XFS (dm-1): Starting recovery (logdev: internal) 
[    5.333575] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000002396fdc 
[    5.333575]  
[    5.333600] CPU: 2 PID: 372 Comm: mount Tainted: G        W    3.9.0+ #1 
[    5.333609] Call Trace: 
[    5.333619] [c0000003e7e02b40] [c000000000014e48] .show_stack+0x78/0x1e0 (unreliable) 
[    5.333635] [c0000003e7e02c10] [c00000000074be70] .dump_stack+0x28/0x3c 
[    5.333690] [c0000003e7e02c80] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
[    5.333747] [c0000003e7e02cf0] [d000000002396e84] .__xfs_dir3_data_check+0x784/0x820 [xfs] 
[    5.333805] [c0000003e7e02df0] [d000000002396fdc] .xfs_dir3_data_verify+0xbc/0xe0 [xfs] 
[    5.333871] [c0000003e7e02e70] [d00000000239703c] .xfs_dir3_data_write_verify+0x3c/0x1c0 [xfs] 
[    5.333936] [c0000003e7e02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
[    5.334003] [c0000003e7e03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    5.334055] [c0000003e7e030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    5.334117] [c0000003e7e03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
[    5.334180] [c0000003e7e03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    5.334237] [c0000003e7e03310] [d0000000023b1904] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
[    5.334305] [c0000003e7e033d0] [d0000000023b1c4c] .xlog_recover_process_data+0x26c/0x340 [xfs] 
[    5.334372] [c0000003e7e034a0] [d0000000023b2108] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
[    5.334438] [c0000003e7e03610] [d0000000023b2360] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
[    5.334503] [c0000003e7e036b0] [d0000000023b2400] .xlog_do_recover+0x20/0x150 [xfs] 
[    5.334570] [c0000003e7e03740] [d0000000023b25c4] .xlog_recover+0x94/0x100 [xfs] 
[    5.334647] [c0000003e7e037d0] [d0000000023bcf84] .xfs_log_mount+0x144/0x1e0 [xfs] 
[    5.334705] [c0000003e7e03870] [d0000000023b6098] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    5.334768] [c0000003e7e03930] [d00000000236435c] .xfs_fs_fill_super+0x31c/0x3b0 [xfs] 
[    5.334801] [c0000003e7e039d0] [c000000000217028] .mount_bdev+0x258/0x2b0 
[    5.334855] [c0000003e7e03aa0] [d000000002361c78] .xfs_fs_mount+0x18/0x30 [xfs] 
[    5.334878] [c0000003e7e03b10] [c000000000218040] .mount_fs+0x70/0x230 
[    5.334890] [c0000003e7e03bd0] [c00000000023a9f8] .vfs_kern_mount+0x58/0x140 
[    5.334901] [c0000003e7e03c80] [c00000000023d5f0] .do_mount+0x280/0xb10 
[    5.334912] [c0000003e7e03d70] [c00000000023df30] .SyS_mount+0xb0/0x110 
[    5.334924] [c0000003e7e03e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    5.334945] c00000001bee2000: 58 44 32 44 09 50 00 40 0a 50 00 40 0b 50 00 40  XD2D.P.@.P.@.P.@ 
[    5.334957] c00000001bee2010: 00 00 00 00 00 11 a3 8e 32 62 65 61 68 5f 74 61  ........2beah_ta 
[    5.334968] c00000001bee2020: 73 6b 5f 65 64 33 33 63 61 62 36 2d 32 65 30 31  sk_ed33cab6-2e01 
[    5.334979] c00000001bee2030: 2d 34 63 34 34 2d 38 63 31 65 2d 66 65 37 36 35  -4c44-8c1e-fe765 
[    5.334992] XFS (dm-1): Internal error xfs_dir3_data_write_verify at line 271 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000234db94 
[    5.334992]  
[    5.335017] CPU: 2 PID: 372 Comm: mount Tainted: G        W    3.9.0+ #1 
[    5.335025] Call Trace: 
[    5.335032] [c0000003e7e02c10] [c000000000014e48] .show_stack+0x78/0x1e0 (unreliable) 
[    5.335046] [c0000003e7e02ce0] [c00000000074be70] .dump_stack+0x28/0x3c 
[    5.335099] [c0000003e7e02d50] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
[    5.335153] [c0000003e7e02dc0] [d00000000234ffac] .xfs_corruption_error+0x7c/0xb0 [xfs] 
[    5.335220] [c0000003e7e02e70] [d000000002397148] .xfs_dir3_data_write_verify+0x148/0x1c0 [xfs] 
[    5.335284] [c0000003e7e02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
[    5.335337] [c0000003e7e03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    5.335403] [c0000003e7e030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    5.335464] [c0000003e7e03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
[    5.335527] [c0000003e7e03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    5.335584] [c0000003e7e03310] [d0000000023b1904] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
[    5.335650] [c0000003e7e033d0] [d0000000023b1c4c] .xlog_recover_process_data+0x26c/0x340 [xfs] 
[    5.335718] [c0000003e7e034a0] [d0000000023b2108] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
[    5.335785] [c0000003e7e03610] [d0000000023b2360] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
[    5.335842] [c0000003e7e036b0] [d0000000023b2400] .xlog_do_recover+0x20/0x150 [xfs] 
[    5.335909] [c0000003e7e03740] [d0000000023b25c4] .xlog_recover+0x94/0x100 [xfs] 
[    5.335976] [c0000003e7e037d0] [d0000000023bcf84] .xfs_log_mount+0x144/0x1e0 [xfs] 
[    5.336033] [c0000003e7e03870] [d0000000023b6098] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    5.336097] [c0000003e7e03930] [d00000000236435c] .xfs_fs_fill_super+0x31c/0x3b0 [xfs] 
[    5.336121] [c0000003e7e039d0] [c000000000217028] .mount_bdev+0x258/0x2b0 
[    5.336174] [c0000003e7e03aa0] [d000000002361c78] .xfs_fs_mount+0x18/0x30 [xfs] 
[    5.336206] [c0000003e7e03b10] [c000000000218040] .mount_fs+0x70/0x230 
[    5.336218] [c0000003e7e03bd0] [c00000000023a9f8] .vfs_kern_mount+0x58/0x140 
[    5.336229] [c0000003e7e03c80] [c00000000023d5f0] .do_mount+0x280/0xb10 
[    5.336240] [c0000003e7e03d70] [c00000000023df30] .SyS_mount+0xb0/0x110 
[    5.336251] [c0000003e7e03e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    5.336262] XFS (dm-1): Corruption detected. Unmount and run xfs_repair 
[    5.336281] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1364 of file fs/xfs/xfs_buf.c.  Return address = 0xd00000000234de84 
[    5.336295] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem 
[    5.336305] XFS (dm-1): Please umount the filesystem and rectify the problem(s) 
[    5.336320] XFS (dm-1): metadata I/O error: block 0x8cfa0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336333] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336357] XFS (dm-1): metadata I/O error: block 0xb2250 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336369] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336385] XFS (dm-1): metadata I/O error: block 0xddd00 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336397] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336422] XFS (dm-1): metadata I/O error: block 0xde228 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336434] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336450] XFS (dm-1): metadata I/O error: block 0x25e6e0 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336462] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336486] XFS (dm-1): metadata I/O error: block 0x55bd70 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336499] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336514] XFS (dm-1): metadata I/O error: block 0x562370 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336526] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336552] XFS (dm-1): metadata I/O error: block 0x1900002 ("xlog_recover_iodone") error 5 numblks 1 
[    5.336564] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336579] XFS (dm-1): metadata I/O error: block 0x1900018 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336591] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336617] XFS (dm-1): metadata I/O error: block 0x1900590 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336629] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336644] XFS (dm-1): metadata I/O error: block 0x19005f0 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336656] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336680] XFS (dm-1): metadata I/O error: block 0x1900600 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336719] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336751] XFS (dm-1): metadata I/O error: block 0x1900c10 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336767] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336798] XFS (dm-1): metadata I/O error: block 0x197c7d0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336816] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336838] XFS (dm-1): metadata I/O error: block 0x32685a0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.336855] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336886] XFS (dm-1): metadata I/O error: block 0x32c7fd8 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336904] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336926] XFS (dm-1): metadata I/O error: block 0x4b00002 ("xlog_recover_iodone") error 5 numblks 1 
[    5.336950] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.336968] XFS (dm-1): metadata I/O error: block 0x4be1120 ("xlog_recover_iodone") error 5 numblks 8 
[    5.336982] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337000] XFS (dm-1): metadata I/O error: block 0x4be3820 ("xlog_recover_iodone") error 5 numblks 16 
[    5.337013] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337039] XFS (dm-1): metadata I/O error: block 0x4c3dbf0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.337053] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337071] XFS (dm-1): metadata I/O error: block 0x4c48d80 ("xlog_recover_iodone") error 5 numblks 16 
[    5.337085] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337111] XFS (dm-1): metadata I/O error: block 0x4d88328 ("xlog_recover_iodone") error 5 numblks 8 
[    5.337125] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337143] XFS (dm-1): metadata I/O error: block 0x4e05ad8 ("xlog_recover_iodone") error 5 numblks 8 
[    5.337156] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337184] XFS (dm-1): metadata I/O error: block 0x5066bf0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.337198] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337216] XFS (dm-1): metadata I/O error: block 0x506a808 ("xlog_recover_iodone") error 5 numblks 8 
[    5.337229] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.337300] XFS (dm-1): metadata I/O error: block 0x8a618 ("xlog_recover_iodone") error 117 numblks 8 
[    5.337315] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd0000000023ada70 
[    5.348410] XFS (dm-1): log mount/recovery failed: error 117 
[    5.348491] XFS (dm-1): log mount failed 
dracut-initqueue[275]: mount: mount /dev/mapper/rhel_ibm--p730--06--lp1-root on /sysroot failed: Structure needs cleaning  
dracut-initqueue[275]: Warning: Failed to mount -t xfs -o ro,ro /dev/mapper/rhel_ibm--p730--06--lp1-root /sysroot  
dracut-initqueue[275]: Warning: *** An error occurred during the file system check.  
dracut-initqueue[275]: Warning: *** Dropping you to a shell; the system will try

Also, never saw any of those in other architectures like x64, but started get those there in 3.9.0.
Unsure if those are related.

[ 3224.369782] ============================================================================= 
[ 3224.370017] BUG xfs_efi_item (Tainted: GF   B       ): Poison overwritten 
[ 3224.370017] ----------------------------------------------------------------------------- 
[ 3224.370017]  
[ 3224.370017] INFO: 0xffff880031199fb8-0xffff880031199fb8. First byte 0x6a instead of 0x6b 
[ 3224.370017] INFO: Allocated in kmem_zone_alloc+0x67/0xf0 [xfs] age=355660 cpu=0 pid=1846 
[ 3224.370017] 	__slab_alloc+0x474/0x4f2 
[ 3224.370017] 	kmem_cache_alloc+0x192/0x1e0 
[ 3224.370017] 	kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017] 	kmem_zone_zalloc+0x1d/0x50 [xfs] 
[ 3224.370017] 	xfs_efi_init+0x35/0xa0 [xfs] 
[ 3224.370017] 	xfs_trans_get_efi+0x21/0x40 [xfs] 
[ 3224.370017] 	xfs_bmap_finish+0x66/0x1a0 [xfs] 
[ 3224.370017] 	xfs_inactive+0x3b8/0x470 [xfs] 
[ 3224.370017] 	xfs_fs_evict_inode+0x84/0xc0 [xfs] 
[ 3224.370017] 	evict+0xa7/0x1a0 
[ 3224.370017] 	iput+0x105/0x190 
[ 3224.370017] 	do_unlinkat+0x1d9/0x230 
[ 3224.370017] 	SyS_unlink+0x16/0x20 
[ 3224.370017] 	system_call_fastpath+0x16/0x1b 
[ 3224.370017] INFO: Freed in xfs_efi_item_free+0x21/0x40 [xfs] age=352306 cpu=2 pid=260 
[ 3224.370017] 	__slab_free+0x35/0x328 
[ 3224.370017] 	kmem_cache_free+0x1d4/0x1f0 
[ 3224.370017] 	xfs_efi_item_free+0x21/0x40 [xfs] 
[ 3224.370017] 	__xfs_efi_release+0x53/0x60 [xfs] 
[ 3224.370017] 	xfs_efi_release+0x2d/0x50 [xfs] 
[ 3224.370017] 	xfs_efd_item_committed+0x26/0x40 [xfs] 
[ 3224.370017] 	xfs_trans_committed_bulk+0x9a/0x2a0 [xfs] 
[ 3224.370017] 	xlog_cil_committed+0x3b/0xf0 [xfs] 
[ 3224.370017] 	xlog_state_do_callback+0x16d/0x2b0 [xfs] 
[ 3224.370017] 	xlog_state_done_syncing+0x76/0xa0 [xfs] 
[ 3224.370017] 	xlog_iodone+0x4b/0xa0 [xfs] 
[ 3224.370017] 	xfs_buf_iodone_work+0x5e/0xc0 [xfs] 
[ 3224.370017] 	process_one_work+0x175/0x400 
[ 3224.370017] 	worker_thread+0x11b/0x370 
[ 3224.370017] 	kthread+0xc0/0xd0 
[ 3224.370017] 	ret_from_fork+0x7c/0xb0 
[ 3224.370017] INFO: Slab 0xffffea0000c46600 objects=22 used=22 fp=0x          (null) flags=0x10000000004080 
[ 3224.370017] INFO: Object 0xffff880031199f48 @offset=8008 fp=0xffff88003119bbb8 
[ 3224.370017]  
[ 3224.370017] Bytes b4 ffff880031199f38: 7e 3f 27 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ~?'.....ZZZZZZZZ 
[ 3224.370017] Object ffff880031199f48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199f58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199f68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199f78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199f88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199f98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199fa8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199fb8: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199fc8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199fd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199fe8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff880031199ff8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a008: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a018: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a028: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a038: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a048: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a058: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a068: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a078: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a088: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a098: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a0a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a0b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk 
[ 3224.370017] Object ffff88003119a0c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk. 
[ 3224.370017] Redzone ffff88003119a0d8: bb bb bb bb bb bb bb bb                          ........ 
[ 3224.370017] Padding ffff88003119a218: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ 
[ 3224.370017] CPU: 3 PID: 5993 Comm: rm Tainted: GF   B        3.9.0+ #1 
[ 3224.370017] Hardware name: Dell Computer Corporation PowerEdge 2800/0NJ022, BIOS A07 04/25/2008 
[ 3224.370017]  ffff880031199f48 ffff88003723f9b8 ffffffff815f105e ffff88003723f9e8 
[ 3224.370017]  ffffffff8117266e ffff880031199fb9 ffff88003768e880 000000000000006b 
[ 3224.370017]  ffff880031199f48 ffff88003723fa38 ffffffff81172802 ffff880031199fb8 
[ 3224.370017] Call Trace: 
[ 3224.370017]  [<ffffffff815f105e>] dump_stack+0x19/0x1b 
[ 3224.370017]  [<ffffffff8117266e>] print_trailer+0xfe/0x160 
[ 3224.370017]  [<ffffffff81172802>] check_bytes_and_report+0xe2/0x120 
[ 3224.370017]  [<ffffffff81172faf>] check_object+0x1cf/0x250 
[ 3224.370017]  [<ffffffffa02e1ba7>] ? kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017]  [<ffffffff815ed2af>] alloc_debug_processing+0x67/0x109 
[ 3224.370017]  [<ffffffff815edce5>] __slab_alloc+0x474/0x4f2 
[ 3224.370017]  [<ffffffffa02f6336>] ? xfs_bmap_del_extent+0x576/0xca0 [xfs] 
[ 3224.370017]  [<ffffffffa02e1ba7>] ? kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017]  [<ffffffff81175012>] kmem_cache_alloc+0x192/0x1e0 
[ 3224.370017]  [<ffffffffa02e1ba7>] ? kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017]  [<ffffffffa02e1ba7>] kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017]  [<ffffffffa02e1c4d>] kmem_zone_zalloc+0x1d/0x50 [xfs] 
[ 3224.370017]  [<ffffffffa032c365>] xfs_efi_init+0x35/0xa0 [xfs] 
[ 3224.370017]  [<ffffffffa032f051>] xfs_trans_get_efi+0x21/0x40 [xfs] 
[ 3224.370017]  [<ffffffffa02f6c66>] xfs_bmap_finish+0x66/0x1a0 [xfs] 
[ 3224.370017]  [<ffffffffa02e1ba7>] ? kmem_zone_alloc+0x67/0xf0 [xfs] 
[ 3224.370017]  [<ffffffffa0315a49>] xfs_itruncate_extents+0xf9/0x2c0 [xfs] 
[ 3224.370017]  [<ffffffffa02dff6d>] xfs_inactive+0x34d/0x470 [xfs] 
[ 3224.370017]  [<ffffffffa02dd674>] xfs_fs_evict_inode+0x84/0xc0 [xfs] 
[ 3224.370017]  [<ffffffff811a7447>] evict+0xa7/0x1a0 
[ 3224.370017]  [<ffffffff811a7c25>] iput+0x105/0x190 
[ 3224.370017]  [<ffffffff8119b399>] do_unlinkat+0x1d9/0x230 
[ 3224.370017]  [<ffffffff8119e1eb>] SyS_unlinkat+0x1b/0x40 
[ 3224.370017]  [<ffffffff815ff942>] system_call_fastpath+0x16/0x1b 
[ 3224.370017] FIX xfs_efi_item: Restoring 0xffff880031199fb8-0xffff880031199fb8=0x6b 
[ 3224.370017]  
[ 3224.370017] FIX xfs_efi_item: Marking all objects used 

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
