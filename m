Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754901AbdDJPfn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 11:35:43 -0400
Date: Mon, 10 Apr 2017 11:35:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170410153529.GE3991@bfoster.bfoster>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 12:42:33PM +0300, Avi Kivity wrote:
> On 04/10/2017 12:23 PM, Avi Kivity wrote:
> > Today my kernel complained that in memory metadata is corrupt and
> > asked that I run xfs_repair.  But xfs_repair doesn't like the
> > superblock and isn't able to find a secondary superblock.
> > 
> > Latest Fedora 25 kernel, new Intel NVMe drive (worked for a few weeks
> > without issue).
> > 
> > Anything I can do to recover the data?
> 

Well I can't explain why you have a checksum error, but what do you mean
that xfs_repair doesn't like the superblock? Can you provide the
xfs_repair output?

It seems strange for xfs_repair to not find the superblock of a
filesystem that can otherwise run log recovery up until it encounters
the buffer with a bad crc.

It also might be useful to find out exactly what that error reported by
smartctl means. Are you aware of whether it pre-existed the filesystem
issue or not?

Brian

> 
> Initial error:
> 
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Metadata CRC
> error detected at xfs_agfl_read_verify+0xcd/0x100 [xfs], xfs_agfl block
> 0x2cb68e13
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Unmount and
> run xfs_repair
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): First 64
> bytes of corrupted metadata buffer:
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75400: 23 40 8f
> 28 5b 50 3a b4 f8 54 1e 31 97 f4 fe ed  #@.([P:..T.1....
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75410: 62 87 57
> 51 ee 9d 31 02 ec 2c 10 46 6c 93 db 09  b.WQ..1..,.Fl...
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75420: ae 7a ea
> b3 91 49 7e d3 99 a4 25 49 11 c5 8b be  .z...I~...%I....
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75430: e4 2e 14
> d4 8a f8 5f 98 66 d8 67 72 ec c9 1a d5  ......_.f.gr....
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): metadata I/O
> error: block 0x2cb68e13 ("xfs_trans_read_buf_map") error 74 numblks 1
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1):
> xfs_do_force_shutdown(0x8) called from line 236 of file
> fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffc05bdbc6
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Corruption
> of in-memory data detected.  Shutting down filesystem
> Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Please
> umount the filesystem and rectify the problem(s)
> 
> 
> After restart:
> 
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Mounting V5
> Filesystem
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Starting
> recovery (logdev: internal)
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Metadata CRC
> error detected at xfs_agfl_read_verify+0xcd/0x100 [xfs], xfs_agfl block
> 0x2cb68e13
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Unmount and
> run xfs_repair
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): First 64
> bytes of corrupted metadata buffer:
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: ffff9450761d4a00: 23 40 8f
> 28 5b 50 3a b4 f8 54 1e 31 97 f4 fe ed  #@.([P:..T.1....
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: ffff9450761d4a10: 62 87 57
> 51 ee 9d 31 02 ec 2c 10 46 6c 93 db 09  b.WQ..1..,.Fl...
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: ffff9450761d4a20: ae 7a ea
> b3 91 49 7e d3 99 a4 25 49 11 c5 8b be  .z...I~...%I....
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: ffff9450761d4a30: e4 2e 14
> d4 8a f8 5f 98 66 d8 67 72 ec c9 1a d5  ......_.f.gr....
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): metadata I/O
> error: block 0x2cb68e13 ("xfs_trans_read_buf_map") error 74 numblks 1
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Internal
> error xfs_trans_cancel at line 983 of file fs/xfs/xfs_trans.c.  Caller
> xfs_efi_recover+0x18e/0x1c0 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: CPU: 3 PID: 1063 Comm:
> mount Not tainted 4.10.8-200.fc25.x86_64 #1
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: Hardware name:
> /DH77EB, BIOS EBH7710H.86A.0099.2013.0125.1400 01/25/2013
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: Call Trace:
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: dump_stack+0x63/0x86
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: xfs_error_report+0x3c/0x40
> [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ?
> xfs_efi_recover+0x18e/0x1c0 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: xfs_trans_cancel+0xb6/0xe0
> [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: xfs_efi_recover+0x18e/0x1c0
> [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> xlog_recover_process_efi+0x2c/0x50 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> xlog_recover_process_intents.isra.42+0x122/0x160 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ?
> xfs_reinit_percpu_counters+0x46/0x50 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> xlog_recover_finish+0x23/0xb0 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> xfs_log_mount_finish+0x29/0x50 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: xfs_mountfs+0x6ce/0x930
> [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> xfs_fs_fill_super+0x3ee/0x570 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: mount_bdev+0x178/0x1b0
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ?
> xfs_test_remount_options.isra.14+0x60/0x60 [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: xfs_fs_mount+0x15/0x20
> [xfs]
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: mount_fs+0x38/0x150
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ? __alloc_percpu+0x15/0x20
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: vfs_kern_mount+0x67/0x130
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: do_mount+0x1dd/0xc50
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ?
> _copy_from_user+0x4e/0x80
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:  ? memdup_user+0x4f/0x70
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: SyS_mount+0x83/0xd0
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: do_syscall_64+0x67/0x180
> Apr 10 11:47:58 avi.cloudius-systems.com kernel:
> entry_SYSCALL64_slow_path+0x25/0x25
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: RIP: 0033:0x7f5cb9a626fa
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: RSP: 002b:00007ffeffa2c928
> EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: RAX: ffffffffffffffda RBX:
> 000055b59fd6f030 RCX: 00007f5cb9a626fa
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: RDX: 000055b59fd6f210 RSI:
> 000055b59fd6f250 RDI: 000055b59fd6f230
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: RBP: 0000000000000000 R08:
> 0000000000000000 R09: 0000000000000012
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: R10: 00000000c0ed0000 R11:
> 0000000000000246 R12: 000055b59fd6f230
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: R13: 000055b59fd6f210 R14:
> 0000000000000000 R15: 00000000ffffffff
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1):
> xfs_do_force_shutdown(0x8) called from line 984 of file fs/xfs/xfs_trans.c.
> Return address = 0xffffffffc056324f
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Corruption
> of in-memory data detected.  Shutting down filesystem
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Please
> umount the filesystem and rectify the problem(s)
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): Failed to
> recover intents
> Apr 10 11:47:58 avi.cloudius-systems.com kernel: XFS (nvme0n1): log mount
> finish failed
> 
> 
> 
> smart (note error at end; there were no kernel I/O errors from the block
> layer):
> 
> $ sudo smartctl -a /dev/nvme0n1
> smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.10.8-200.fc25.x86_64] (local
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Number:                       INTEL SSDPEKKW512G7
> Serial Number:                      BTPY6313086D512F
> Firmware Version:                   PSF100C
> PCI Vendor/Subsystem ID:            0x8086
> IEEE OUI Identifier:                0x5cd2e4
> Controller ID:                      1
> Number of Namespaces:               1
> Namespace 1 Size/Capacity:          512,110,190,592 [512 GB]
> Namespace 1 Formatted LBA Size:     512
> Local Time is:                      Mon Apr 10 12:36:41 2017 IDT
> Firmware Updates (0x12):            1 Slot, no Reset required
> Optional Admin Commands (0x0006):   Format Frmw_DL
> Optional NVM Commands (0x001e):     Wr_Unc DS_Mngmt Wr_Zero Sav/Sel_Feat
> Maximum Data Transfer Size:         32 Pages
> Warning  Comp. Temp. Threshold:     70 Celsius
> Critical Comp. Temp. Threshold:     80 Celsius
> 
> Supported Power States
> St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>  0 +     9.00W       -        -    0  0  0  0        5       5
>  1 +     4.60W       -        -    1  1  1  1       30      30
>  2 +     3.80W       -        -    2  2  2  2       30      30
>  3 -   0.0700W       -        -    3  3  3  3    10000     300
>  4 -   0.0050W       -        -    4  4  4  4     2000   10000
> 
> Supported LBA Sizes (NSID 0x1)
> Id Fmt  Data  Metadt  Rel_Perf
>  0 +     512       0         0
> 
> === START OF SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SMART/Health Information (NVMe Log 0x02, NSID 0x1)
> Critical Warning:                   0x00
> Temperature:                        27 Celsius
> Available Spare:                    100%
> Available Spare Threshold:          10%
> Percentage Used:                    0%
> Data Units Read:                    8,854,487 [4.53 TB]
> Data Units Written:                 5,652,445 [2.89 TB]
> Host Read Commands:                 446,901,662
> Host Write Commands:                35,627,742
> Controller Busy Time:               633
> Power Cycles:                       24
> Power On Hours:                     987
> Unsafe Shutdowns:                   16
> Media and Data Integrity Errors:    1
> Error Information Log Entries:      1
> Warning  Comp. Temperature Time:    11
> Critical Comp. Temperature Time:    0
> 
> Error Information (NVMe Log 0x01, max 64 entries)
> Num   ErrCount  SQId   CmdId  Status  PELoc          LBA  NSID    VS
>   0          1     1  0x0000  0x0286      -            0     1     -
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
