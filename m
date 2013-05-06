Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7988F29DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 09:31:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 595E6304039
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 07:31:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JoOUF1GwMm3SHNqE for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 07:31:03 -0700 (PDT)
Message-ID: <5187BEA5.4040107@sandeen.net>
Date: Mon, 06 May 2013 09:31:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3.9.0: XFS rootfs corruption
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
In-Reply-To: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On 5/6/13 2:50 AM, CAI Qian wrote:
> Saw this on several different Power7 systems after kdump reboot. It has xfsprogs-3.1.10
> and rootfs in on LVM. Never saw one of those in any of the RC releases.
> 
> ] Reached target Basic System.  
> [    4.919316] bio: create slab <bio-1> at 1 
> [    5.078616] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled 
> [    5.081925] XFS (dm-1): Mounting Filesystem 
> [    5.168530] XFS (dm-1): Starting recovery (logdev: internal) 
> [    5.333575] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000002396fdc 

here:

        /*
         * Need to have seen all the entries and all the bestfree slots.
         */
        XFS_WANT_CORRUPTED_RETURN(freeseen == 7);

I hope Dave knows offhand what this might mean.  :)

Could you get a metadump of the filesystem in question?

> [    5.333575]  
> [    5.333600] CPU: 2 PID: 372 Comm: mount Tainted: G        W    3.9.0+ #1 
> [    5.333609] Call Trace: 
> [    5.333619] [c0000003e7e02b40] [c000000000014e48] .show_stack+0x78/0x1e0 (unreliable) 
> [    5.333635] [c0000003e7e02c10] [c00000000074be70] .dump_stack+0x28/0x3c 
> [    5.333690] [c0000003e7e02c80] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
> [    5.333747] [c0000003e7e02cf0] [d000000002396e84] .__xfs_dir3_data_check+0x784/0x820 [xfs] 
> [    5.333805] [c0000003e7e02df0] [d000000002396fdc] .xfs_dir3_data_verify+0xbc/0xe0 [xfs] 
> [    5.333871] [c0000003e7e02e70] [d00000000239703c] .xfs_dir3_data_write_verify+0x3c/0x1c0 [xfs] 
> [    5.333936] [c0000003e7e02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
> [    5.334003] [c0000003e7e03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
> [    5.334055] [c0000003e7e030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
> [    5.334117] [c0000003e7e03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
> [    5.334180] [c0000003e7e03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
> [    5.334237] [c0000003e7e03310] [d0000000023b1904] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
> [    5.334305] [c0000003e7e033d0] [d0000000023b1c4c] .xlog_recover_process_data+0x26c/0x340 [xfs] 
> [    5.334372] [c0000003e7e034a0] [d0000000023b2108] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
> [    5.334438] [c0000003e7e03610] [d0000000023b2360] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
> [    5.334503] [c0000003e7e036b0] [d0000000023b2400] .xlog_do_recover+0x20/0x150 [xfs] 
> [    5.334570] [c0000003e7e03740] [d0000000023b25c4] .xlog_recover+0x94/0x100 [xfs] 
> [    5.334647] [c0000003e7e037d0] [d0000000023bcf84] .xfs_log_mount+0x144/0x1e0 [xfs] 
> [    5.334705] [c0000003e7e03870] [d0000000023b6098] .xfs_mountfs+0x3c8/0x780 [xfs] 
> [    5.334768] [c0000003e7e03930] [d00000000236435c] .xfs_fs_fill_super+0x31c/0x3b0 [xfs] 
> [    5.334801] [c0000003e7e039d0] [c000000000217028] .mount_bdev+0x258/0x2b0 
> [    5.334855] [c0000003e7e03aa0] [d000000002361c78] .xfs_fs_mount+0x18/0x30 [xfs] 
> [    5.334878] [c0000003e7e03b10] [c000000000218040] .mount_fs+0x70/0x230 
> [    5.334890] [c0000003e7e03bd0] [c00000000023a9f8] .vfs_kern_mount+0x58/0x140 
> [    5.334901] [c0000003e7e03c80] [c00000000023d5f0] .do_mount+0x280/0xb10 
> [    5.334912] [c0000003e7e03d70] [c00000000023df30] .SyS_mount+0xb0/0x110 
> [    5.334924] [c0000003e7e03e30] [c000000000009e54] syscall_exit+0x0/0x98 
> [    5.334945] c00000001bee2000: 58 44 32 44 09 50 00 40 0a 50 00 40 0b 50 00 40  XD2D.P.@.P.@.P.@ 
> [    5.334957] c00000001bee2010: 00 00 00 00 00 11 a3 8e 32 62 65 61 68 5f 74 61  ........2beah_ta 
> [    5.334968] c00000001bee2020: 73 6b 5f 65 64 33 33 63 61 62 36 2d 32 65 30 31  sk_ed33cab6-2e01 
> [    5.334979] c00000001bee2030: 2d 34 63 34 34 2d 38 63 31 65 2d 66 65 37 36 35  -4c44-8c1e-fe765 
> [    5.334992] XFS (dm-1): Internal error xfs_dir3_data_write_verify at line 271 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000234db94 
> [    5.334992]  
> [    5.335017] CPU: 2 PID: 372 Comm: mount Tainted: G        W    3.9.0+ #1 
> [    5.335025] Call Trace: 
> [    5.335032] [c0000003e7e02c10] [c000000000014e48] .show_stack+0x78/0x1e0 (unreliable) 
> [    5.335046] [c0000003e7e02ce0] [c00000000074be70] .dump_stack+0x28/0x3c 
> [    5.335099] [c0000003e7e02d50] [d00000000234ff14] .xfs_error_report+0x54/0x70 [xfs] 
> [    5.335153] [c0000003e7e02dc0] [d00000000234ffac] .xfs_corruption_error+0x7c/0xb0 [xfs] 
> [    5.335220] [c0000003e7e02e70] [d000000002397148] .xfs_dir3_data_write_verify+0x148/0x1c0 [xfs] 
> [    5.335284] [c0000003e7e02f20] [d00000000234db94] ._xfs_buf_ioapply+0xd4/0x400 [xfs] 
> [    5.335337] [c0000003e7e03060] [d00000000234dfcc] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
> [    5.335403] [c0000003e7e030f0] [d00000000234e0c4] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
> [    5.335464] [c0000003e7e03180] [d00000000234e284] .__xfs_buf_delwri_submit+0x104/0x2a0 [xfs] 
> [    5.335527] [c0000003e7e03270] [d00000000234f318] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
> [    5.335584] [c0000003e7e03310] [d0000000023b1904] .xlog_recover_commit_trans+0xd4/0x1b0 [xfs] 
> [    5.335650] [c0000003e7e033d0] [d0000000023b1c4c] .xlog_recover_process_data+0x26c/0x340 [xfs] 
> [    5.335718] [c0000003e7e034a0] [d0000000023b2108] .xlog_do_recovery_pass+0x3e8/0x5a0 [xfs] 
> [    5.335785] [c0000003e7e03610] [d0000000023b2360] .xlog_do_log_recovery+0xa0/0x120 [xfs] 
> [    5.335842] [c0000003e7e036b0] [d0000000023b2400] .xlog_do_recover+0x20/0x150 [xfs] 
> [    5.335909] [c0000003e7e03740] [d0000000023b25c4] .xlog_recover+0x94/0x100 [xfs] 
> [    5.335976] [c0000003e7e037d0] [d0000000023bcf84] .xfs_log_mount+0x144/0x1e0 [xfs] 
> [    5.336033] [c0000003e7e03870] [d0000000023b6098] .xfs_mountfs+0x3c8/0x780 [xfs] 
> [    5.336097] [c0000003e7e03930] [d00000000236435c] .xfs_fs_fill_super+0x31c/0x3b0 [xfs] 
> [    5.336121] [c0000003e7e039d0] [c000000000217028] .mount_bdev+0x258/0x2b0 
> [    5.336174] [c0000003e7e03aa0] [d000000002361c78] .xfs_fs_mount+0x18/0x30 [xfs] 
> [    5.336206] [c0000003e7e03b10] [c000000000218040] .mount_fs+0x70/0x230 
> [    5.336218] [c0000003e7e03bd0] [c00000000023a9f8] .vfs_kern_mount+0x58/0x140 
> [    5.336229] [c0000003e7e03c80] [c00000000023d5f0] .do_mount+0x280/0xb10 
> [    5.336240] [c0000003e7e03d70] [c00000000023df30] .SyS_mount+0xb0/0x110 
> [    5.336251] [c0000003e7e03e30] [c000000000009e54] syscall_exit+0x0/0x98 


> [    5.348410] XFS (dm-1): log mount/recovery failed: error 117 
> [    5.348491] XFS (dm-1): log mount failed 
> dracut-initqueue[275]: mount: mount /dev/mapper/rhel_ibm--p730--06--lp1-root on /sysroot failed: Structure needs cleaning  
> dracut-initqueue[275]: Warning: Failed to mount -t xfs -o ro,ro /dev/mapper/rhel_ibm--p730--06--lp1-root /sysroot  
> dracut-initqueue[275]: Warning: *** An error occurred during the file system check.  
> dracut-initqueue[275]: Warning: *** Dropping you to a shell; the system will try
> 
> Also, never saw any of those in other architectures like x64, but started get those there in 3.9.0.
> Unsure if those are related.
> 
> [ 3224.369782] ============================================================================= 
> [ 3224.370017] BUG xfs_efi_item (Tainted: GF   B       ): Poison overwritten 
> [ 3224.370017] ----------------------------------------------------------------------------- 

  2: 'F' if any module was force loaded by "insmod -f", ' ' if all
     modules were loaded normally.

Force loaded modules, what's that from?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
