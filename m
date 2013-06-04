Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7FE87F3F
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 00:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BDD9AC002
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 22:02:51 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id ADSAaDuLTeIProHz for
	<xfs@oss.sgi.com>; Mon, 03 Jun 2013 22:02:50 -0700 (PDT)
Date: Tue, 4 Jun 2013 01:02:48 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1545236918.11080543.1370322168495.JavaMail.root@redhat.com>
In-Reply-To: <20130604043610.GH29466@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<131268379.10596360.1370246946902.JavaMail.root@redhat.com>
	<20130604043610.GH29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Eric Sandeen" <sandeen@sandeen.net>, xfs@oss.sgi.com
> Sent: Tuesday, June 4, 2013 12:36:10 PM
> Subject: Re: 3.9.0: XFS rootfs corruption
> 
> On Mon, Jun 03, 2013 at 04:09:06AM -0400, CAI Qian wrote:
> [snip]
> 
> > :/# xfs_repair -L  /dev/mapper/rhel_ibm--p720--01--lp4-root
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> ....
> 
> Now that you've repaired the filesystem, can you reproduce the
> problem?
> 
> It looks somewhat like the same bug we fixed in 3.8-rc4 that Dave
> Jones hit (37f1356 xfs: recalculate leaf entry pointer after
> compacting a dir2 block), but if you've never repaired the damage on
> disk that this problem caused then you'll just keep tripping over
> it.
BTW, this can still be reproduced in 3.10-rc4 running the original reproducer.
[    1.718742] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled 
[    1.720985] XFS (dm-1): Mounting Filesystem 
[    1.812149] XFS (dm-1): Starting recovery (logdev: internal) 
[    2.123553] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000001647c0c 
[    2.123553]  
[    2.123564] CPU: 2 PID: 400 Comm: mount Not tainted 3.10.0-rc4 #1 
[    2.123568] Call Trace: 
[    2.123575] [c00000001bd8ab90] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable) 
[    2.123583] [c00000001bd8ac60] [c0000000007444fc] .dump_stack+0x28/0x3c 
[    2.123614] [c00000001bd8acd0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs] 
[    2.123644] [c00000001bd8ad40] [d000000001647ab4] .__xfs_dir3_data_check+0x784/0x820 [xfs] 
[    2.123673] [c00000001bd8ae40] [d000000001647c0c] .xfs_dir3_data_verify+0xbc/0xe0 [xfs] 
[    2.123702] [c00000001bd8aec0] [d000000001647c6c] .xfs_dir3_data_write_verify+0x3c/0x1c0 [xfs] 
[    2.123730] [c00000001bd8af70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs] 
[    2.123757] [c00000001bd8b0b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    2.123785] [c00000001bd8b140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    2.123812] [c00000001bd8b1d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs] 
[    2.123840] [c00000001bd8b2b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    2.123870] [c00000001bd8b350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs] 
[    2.123900] [c00000001bd8b410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 [xfs] 
[    2.123930] [c00000001bd8b4e0] [d0000000016629f8] .xlog_do_recovery_pass+0x148/0x590 [xfs] 
[    2.123959] [c00000001bd8b650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs] 
[    2.123988] [c00000001bd8b6e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs] 
[    2.124018] [c00000001bd8b770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs] 
[    2.124047] [c00000001bd8b800] [d00000000166d9a4] .xfs_log_mount+0x134/0x1d0 [xfs] 
[    2.124077] [c00000001bd8b890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    2.124105] [c00000001bd8b940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs] 
[    2.124111] [c00000001bd8b9e0] [c000000000214d58] .mount_bdev+0x258/0x2a0 
[    2.124139] [c00000001bd8bab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs] 
[    2.124145] [c00000001bd8bb20] [c000000000215be0] .mount_fs+0x70/0x230 
[    2.124150] [c00000001bd8bbe0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130 
[    2.124156] [c00000001bd8bc90] [c00000000023b390] .do_mount+0x2d0/0xb30 
[    2.124161] [c00000001bd8bd70] [c00000000023bca0] .SyS_mount+0xb0/0x110 
[    2.124167] [c00000001bd8be30] [c000000000009e54] syscall_exit+0x0/0x98 
[    2.124173] c00000001b5ab000: 58 44 32 44 09 90 00 40 0a 90 00 40 0b 90 00 40  XD2D...@...@...@ 
[    2.124178] c00000001b5ab010: 00 00 00 00 08 14 9c 07 2e 72 68 74 73 5f 74 61  .........rhts_ta 
[    2.124183] c00000001b5ab020: 73 6b 5f 4a 34 32 37 38 31 39 2d 53 37 33 31 31  sk_J427819-S7311 
[    2.124187] c00000001b5ab030: 35 36 2d 52 38 39 39 38 37 39 2d 54 31 32 38 37  56-R899879-T1287 
[    2.124193] XFS (dm-1): Internal error xfs_dir3_data_write_verify at line 271 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd0000000015fdb74 
[    2.124193]  
[    2.124200] CPU: 2 PID: 400 Comm: mount Not tainted 3.10.0-rc4 #1 
[    2.124203] Call Trace: 
[    2.124206] [c00000001bd8ac60] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable) 
[    2.124212] [c00000001bd8ad30] [c0000000007444fc] .dump_stack+0x28/0x3c 
[    2.124239] [c00000001bd8ada0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs] 
[    2.124267] [c00000001bd8ae10] [d00000000160070c] .xfs_corruption_error+0x7c/0xb0 [xfs] 
[    2.124296] [c00000001bd8aec0] [d000000001647d78] .xfs_dir3_data_write_verify+0x148/0x1c0 [xfs] 
[    2.124323] [c00000001bd8af70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs] 
[    2.124351] [c00000001bd8b0b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    2.124379] [c00000001bd8b140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    2.124406] [c00000001bd8b1d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs] 
[    2.124434] [c00000001bd8b2b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    2.124463] [c00000001bd8b350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs] 
[    2.124493] [c00000001bd8b410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 [xfs] 
[    2.124522] [c00000001bd8b4e0] [d0000000016629f8] .xlog_do_recovery_pass+0x148/0x590 [xfs] 
[    2.124552] [c00000001bd8b650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs] 
[    2.124581] [c00000001bd8b6e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs] 
[    2.124611] [c00000001bd8b770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs] 
[    2.124640] [c00000001bd8b800] [d00000000166d9a4] .xfs_log_mount+0x134/0x1d0 [xfs] 
[    2.124670] [c00000001bd8b890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    2.124698] [c00000001bd8b940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs] 
[    2.124703] [c00000001bd8b9e0] [c000000000214d58] .mount_bdev+0x258/0x2a0 
[    2.124731] [c00000001bd8bab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs] 
[    2.124736] [c00000001bd8bb20] [c000000000215be0] .mount_fs+0x70/0x230 
[    2.124741] [c00000001bd8bbe0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130 
[    2.124746] [c00000001bd8bc90] [c00000000023b390] .do_mount+0x2d0/0xb30 
[    2.124752] [c00000001bd8bd70] [c00000000023bca0] .SyS_mount+0xb0/0x110 
[    2.124757] [c00000001bd8be30] [c000000000009e54] syscall_exit+0x0/0x98 
[    2.124761] XFS (dm-1): Corruption detected. Unmount and run xfs_repair 
[    2.124766] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1365 of file fs/xfs/xfs_buf.c.  Return address = 0xd0000000015fdba0 
[    2.124772] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem 
[    2.124776] XFS (dm-1): Please umount the filesystem and rectify the problem(s) 
[    2.124783] XFS (dm-1): metadata I/O error: block 0x32a55f0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.124789] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124795] XFS (dm-1): metadata I/O error: block 0x32ad118 ("xlog_recover_iodone") error 5 numblks 8 
[    2.124800] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124807] XFS (dm-1): metadata I/O error: block 0x35a5b60 ("xlog_recover_iodone") error 5 numblks 8 
[    2.124812] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124819] XFS (dm-1): metadata I/O error: block 0x3748af0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.124824] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124830] XFS (dm-1): metadata I/O error: block 0x37490f0 ("xlog_recover_iodone") error 5 numblks 16 
[    2.124835] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124842] XFS (dm-1): metadata I/O error: block 0x4b00002 ("xlog_recover_iodone") error 5 numblks 1 
[    2.124847] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124853] XFS (dm-1): metadata I/O error: block 0x4c1cc20 ("xlog_recover_iodone") error 5 numblks 16 
[    2.124858] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124865] XFS (dm-1): metadata I/O error: block 0x4d018b8 ("xlog_recover_iodone") error 5 numblks 8 
[    2.124870] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124876] XFS (dm-1): metadata I/O error: block 0x4dbde68 ("xlog_recover_iodone") error 5 numblks 8 
[    2.124881] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124888] XFS (dm-1): metadata I/O error: block 0x4f9c990 ("xlog_recover_iodone") error 5 numblks 16 
[    2.124893] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.124904] XFS (dm-1): metadata I/O error: block 0x32a55d0 ("xlog_recover_iodone") error 117 numblks 8 
[    2.124910] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600 
[    2.198068] XFS (dm-1): log mount/recovery failed: error 117 
[    2.198106] XFS (dm-1): log mount failed 
[    2.200723] systemd[1]: Starting Emergency Shell... 
[      
FAILED   
] Failed to mount /sysroot.  
See 'systemctl status sysroot.mount' for details.  
[      
DEPEND   
] Dependency failed for Initrd Root File System.  
[      
DEPEND   
] Dependency failed for Reload Configuration from the Real Root.  
[    2.201901] systemd[1]: Starting Journal Service... 
[    2.206066] systemd-journald[178]: Received SIGTERM 
[    2.207016] systemd[1]: Starting Journal Service... 
[    2.207434] systemd[1]: Started Journal Service. 
[    2.207815] systemd[1]: Stopped udev Kernel Device Manager. 
[    2.207845] systemd[1]: Stopping dracut pre-udev hook... 
[    2.207855] systemd[1]: Stopped dracut pre-udev hook. 
[    2.207894] systemd[1]: Stopping dracut cmdline hook... 
[    2.207904] systemd[1]: Stopped dracut cmdline hook. 
[    2.207940] systemd[1]: Stopping udev Kernel Socket. 
[    2.207978] systemd[1]: Closed udev Kernel Socket. 
[    2.207989] systemd[1]: Stopping udev Control Socket. 
[    2.208024] systemd[1]: Closed udev Control Socket. 
 
Generating "/run/initramfs/sosreport.txt" 
 
 
Entering emergency mode. Exit the shell to continue. 
Type "journalctl" to view system logs. 
You might want to save "/run/initramfs/sosreport.txt" to a USB stick or /boot 
after mounting them and attach it to a bug report. 
 
 
:/#[-- MARK -- Mon Jun  3 10:30:00 2013] 
CAI Qian
> 
> So, can you reproduce the problem now on this machine/filesystem?
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
