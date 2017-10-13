Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdJMSQI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 14:16:08 -0400
Date: Fri, 13 Oct 2017 14:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug Report]: generic/085 trigger a XFS panic on kernel 4.14-rc2
Message-ID: <20171013181605.GA46787@bfoster.bfoster>
References: <20170930032857.GQ21475@dhcp12-143.nay.redhat.com>
 <20171002135618.GA32279@bfoster.bfoster>
 <20171013132935.GE21475@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013132935.GE21475@dhcp12-143.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com

On Fri, Oct 13, 2017 at 09:29:35PM +0800, Zorro Lang wrote:
> On Mon, Oct 02, 2017 at 09:56:18AM -0400, Brian Foster wrote:
> > On Sat, Sep 30, 2017 at 11:28:57AM +0800, Zorro Lang wrote:
> > > Hi,
> > > 
> > > I hit a panic[1] when I ran xfstests on debug kernel v4.14-rc2
> > > (with xfsprogs 4.13.1), and I can reproduce it on the same machine
> > > twice. But I can't reproduce it on another machine.
> > > 
> > > Maybe there're some hardware specific requirement to trigger this panic. I
> > > tested on normal disk partition, but the disk is multi stripes RAID device.
> > > I didn't get the mkfs output of g/085, bug I found the default mkfs output
> > > (mkfs.xfs -f /dev/sda3) is:
> > > 
> > > meta-data=/dev/sda3              isize=512    agcount=16, agsize=982528 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
> > > data     =                       bsize=1024   blocks=15720448, imaxpct=25
> > >          =                       sunit=512    swidth=1024 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > log      =internal log           bsize=1024   blocks=10240, version=2
> > >          =                       sectsz=512   sunit=32 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > (The test machine is not on my hand now, I need time reserve it.)
> > > 
> > 
> > If you are able to reproduce, could you provide a metadump of this fs
> > immediately after the crash?
> 
> Finally I got the machine which can reproduce this bug for 1 day. Then I
> got the XFS metadump which can trigger this bug.
> 
> Please download the metadump file by opening below link:
> https://drive.google.com/file/d/0B5dFDeCXGOPXalNuMUJNdDM3STQ/view?usp=sharing
> 
> Just mount this xfs image, then kernel will crash. I didn't do any operations
> on this XFS, just did "mkfs.xfs -b size=1024".
> 

Thanks Zorro. I can reproduce with this image. It looks like the root
problem is that a block address calculation goes wrong in
xlog_find_head():

	start_blk = log_bbnum - (num_scan_bblks - head_blk);

With log_bbnum = 3264, num_scan_bblks = 4096 and head_blk = 512,
start_blk underflows and we go off the rails from there. Aside from
addressing the crash, I think either this value and/or num_scan_bblks
need to be clamped to within the range of the log.

Brian

> Thanks,
> Zorro
> 
> > 
> > Brian
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > [1]:
> > > 
> > > [  373.165020] run fstests generic/085 at 2017-09-29 10:29:32 
> > > [  373.522944] XFS (sda4): Unmounting Filesystem 
> > > [  373.700510] device-mapper: uevent: version 1.0.3 
> > > [  373.725266] device-mapper: ioctl: 4.36.0-ioctl (2017-06-09) initialised: dm-devel@redhat.com 
> > > [  374.199737] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.228642] XFS (dm-0): Ending clean mount 
> > > [  374.285479] XFS (dm-0): Unmounting Filesystem 
> > > [  374.319080] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.353123] XFS (dm-0): Ending clean mount 
> > > [  374.409625] XFS (dm-0): Unmounting Filesystem 
> > > [  374.437494] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.477124] XFS (dm-0): Ending clean mount 
> > > [  374.549775] XFS (dm-0): Unmounting Filesystem 
> > > [  374.578300] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.618208] XFS (dm-0): Ending clean mount 
> > > [  374.672593] XFS (dm-0): Unmounting Filesystem 
> > > [  374.701455] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.741861] XFS (dm-0): Ending clean mount 
> > > [  374.798972] XFS (dm-0): Unmounting Filesystem 
> > > [  374.827584] XFS (dm-0): Mounting V5 Filesystem 
> > > [  374.872622] XFS (dm-0): Ending clean mount 
> > > [  374.938045] XFS (dm-0): Unmounting Filesystem 
> > > [  374.966630] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.009748] XFS (dm-0): Ending clean mount 
> > > [  375.067006] XFS (dm-0): Unmounting Filesystem 
> > > [  375.095371] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.134992] XFS (dm-0): Ending clean mount 
> > > [  375.198436] XFS (dm-0): Unmounting Filesystem 
> > > [  375.226926] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.271643] XFS (dm-0): Ending clean mount 
> > > [  375.326618] XFS (dm-0): Unmounting Filesystem 
> > > [  375.357583] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.402952] XFS (dm-0): Ending clean mount 
> > > [  375.454747] XFS (dm-0): Unmounting Filesystem 
> > > [  375.483053] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.527584] XFS (dm-0): Ending clean mount 
> > > [  375.592113] XFS (dm-0): Unmounting Filesystem 
> > > [  375.620637] XFS (dm-0): Mounting V5 Filesystem 
> > > [  375.683969] XFS (dm-0): Invalid block length (0xfffffed8) for buffer 
> > > [  375.713282] BUG: unable to handle kernel NULL pointer dereference at           (null) 
> > > [  375.749352] IP: xlog_header_check_mount+0x11/0xd0 [xfs] 
> > > [  375.773424] PGD 0 P4D 0  
> > > [  375.784990] Oops: 0000 [#1] SMP 
> > > [  375.799382] Modules linked in: dm_mod rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_core intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ext4 mbcache jbd2 irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc vfat fat aesni_intel crypto_simd glue_helper ipmi_ssif cryptd iTCO_wdt joydev hpilo iTCO_vendor_support sg ipmi_si hpwdt ipmi_devintf i2c_i801 pcspkr lpc_ich ioatdma ipmi_msghandler shpchp dca nfsd wmi acpi_power_meter auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mgag200 i2c_algo_bit drm_kms_helper sd_mod syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel i2c_core hpsa be2net 
> > > [  376.134079]  scsi_transport_sas 
> > > [  376.148586] CPU: 52 PID: 46126 Comm: mount Not tainted 4.14.0-rc2 #1 
> > > [  376.177733] Hardware name: HP ProLiant BL460c Gen9, BIOS I36 09/12/2016 
> > > [  376.209076] task: ffff9e448206b4c0 task.stack: ffffab2bc9828000 
> > > [  376.236861] RIP: 0010:xlog_header_check_mount+0x11/0xd0 [xfs] 
> > > [  376.263261] RSP: 0018:ffffab2bc982baf8 EFLAGS: 00010246 
> > > [  376.287307] RAX: 0000000000000001 RBX: fffffffffffffed7 RCX: 0000000000000000 
> > > [  376.320119] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9e44827ee000 
> > > [  376.353016] RBP: ffffab2bc982bb10 R08: 0000000000000000 R09: 0000000000000000 
> > > [  376.388077] R10: 0000000000000001 R11: 000000008dbdaba7 R12: ffff9e3e84567b80 
> > > [  376.423650] R13: ffff9e44827ee000 R14: 0000000000000001 R15: 0000000000000000 
> > > [  376.456573] FS:  00007f7ea6c46880(0000) GS:ffff9e3ea7a00000(0000) knlGS:0000000000000000 
> > > [  376.493753] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > > [  376.520232] CR2: 0000000000000000 CR3: 0000000c3b76a004 CR4: 00000000001606e0 
> > > [  376.553291] Call Trace: 
> > > [  376.564479]  xlog_find_verify_log_record+0x13b/0x270 [xfs] 
> > > [  376.589761]  xlog_find_head+0x1ed/0x4d0 [xfs] 
> > > [  376.609787]  ? mark_held_locks+0x66/0x90 
> > > [  376.627819]  xlog_find_tail+0x43/0x3a0 [xfs] 
> > > [  376.647431]  ? try_to_wake_up+0x59/0x750 
> > > [  376.665459]  xlog_recover+0x2d/0x170 [xfs] 
> > > [  376.684250]  ? xfs_trans_ail_init+0xc7/0xf0 [xfs] 
> > > [  376.706261]  xfs_log_mount+0x2b0/0x320 [xfs] 
> > > [  376.726658]  xfs_mountfs+0x55c/0xaf0 [xfs] 
> > > [  376.745614]  ? xfs_mru_cache_create+0x178/0x1d0 [xfs] 
> > > [  376.768813]  xfs_fs_fill_super+0x4bd/0x620 [xfs] 
> > > [  376.790017]  mount_bdev+0x18c/0x1c0 
> > > [  376.806030]  ? xfs_test_remount_options.isra.15+0x60/0x60 [xfs] 
> > > [  376.833247]  xfs_fs_mount+0x15/0x20 [xfs] 
> > > [  376.851728]  mount_fs+0x39/0x150 
> > > [  376.866558]  vfs_kern_mount+0x6b/0x170 
> > > [  376.884623]  do_mount+0x1f0/0xd60 
> > > [  376.901879]  ? memdup_user+0x42/0x60 
> > > [  376.919545]  SyS_mount+0x83/0xd0 
> > > [  376.936736]  do_syscall_64+0x6c/0x220 
> > > [  376.954020]  entry_SYSCALL64_slow_path+0x25/0x25 
> > > [  376.975265] RIP: 0033:0x7f7ea5ec0aaa 
> > > [  376.991661] RSP: 002b:00007ffe777381e8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5 
> > > [  377.026394] RAX: ffffffffffffffda RBX: 00005596b8d93080 RCX: 00007f7ea5ec0aaa 
> > > [  377.059178] RDX: 00005596b8d95640 RSI: 00005596b8d93270 RDI: 00005596b8d93250 
> > > [  377.092234] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000010 
> > > [  377.125095] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00005596b8d93250 
> > > [  377.158157] R13: 00005596b8d95640 R14: 0000000000000000 R15: 00005596b8d93080 
> > > [  377.192994] Code: c0 48 c7 c7 58 13 70 c0 e8 2d 2a fe ff e9 aa fd ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 55 49 89 fd 41 54 53 <81> 3e fe ed ba be 48 89 f3 75 5b 4c 8d a3 30 01 00 00 ba 10 00  
> > > [  377.291657] RIP: xlog_header_check_mount+0x11/0xd0 [xfs] RSP: ffffab2bc982baf8 
> > > [  377.326553] CR2: 0000000000000000 
> > > [  377.342022] ---[ end trace 85d9cc5b8e738db6 ]--- 
> > > 
> > > 
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
