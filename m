Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbfBZSSc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 13:18:32 -0500
Date: Tue, 26 Feb 2019 13:18:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Corruption of in-memory data detected. Shutting down filesystem
Message-ID: <20190226181828.GA3976@bfoster>
References: <b4141aed-70f1-83de-92e3-b8c9494900c7@molgen.mpg.de>
 <20190218142203.p53qvipc4yul6mv6@hades.usersys.redhat.com>
 <20190218143403.GB33924@bfoster>
 <0d3627ab-34e6-a800-c562-c25c578e3c6a@molgen.mpg.de>
 <20190218161746.GE33924@bfoster>
 <20190218173251.GF6503@magnolia>
 <20190218175722.GF33924@bfoster>
 <e9f4af9a-7188-7913-8aef-41869179cbab@molgen.mpg.de>
 <dd17d543-1e6d-8f26-2764-c2f93815f310@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd17d543-1e6d-8f26-2764-c2f93815f310@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, it+linux-xfs@molgen.mpg.de

On Tue, Feb 26, 2019 at 06:15:34PM +0100, Paul Menzel wrote:
> Dear Brian, dear Darrick,
> 
> 
> On 02/26/19 16:03, Paul Menzel wrote:
> 
> > On 02/18/19 18:57, Brian Foster wrote:
> >> On Mon, Feb 18, 2019 at 09:32:51AM -0800, Darrick J. Wong wrote:
> >>> On Mon, Feb 18, 2019 at 11:17:46AM -0500, Brian Foster wrote:
> >>>> On Mon, Feb 18, 2019 at 04:08:00PM +0100, Paul Menzel wrote:
> > 
> >>>>> On 02/18/19 15:34, Brian Foster wrote:
> >>>>>> On Mon, Feb 18, 2019 at 03:22:03PM +0100, Carlos Maiolino wrote:
> >>>>>
> >>>>>>>> [   25.506600] XFS (sdd): Mounting V5 Filesystem
> >>>>>>>> [   25.629621] XFS (sdd): Starting recovery (logdev: internal)
> >>>>>>>> [   25.685100] NFSD: starting 90-second grace period (net f0000098)
> >>>>>>>> [   26.433828] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> >>>>>>>> [   26.433834] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> >>>>>>>> [   26.433835] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> >>>>>>>> [   26.433857] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> >>>>>>>>
> >>>>>>> Ok, filesystem shut itself down likely because blocks allocated in the
> >>>>>>> transaction exceeded the reservation.
> >>>>>
> >>>>>>>> We mounted it with an overlay files,
> >>>>>>>
> >>>>>>> I'm not sure what you meant here, could you please specify what you meant by
> >>>>>>> 'overlay files'? Are you using this XFS filesystem as an upper/lower FS for
> >>>>>>> overlayfs?
> >>>>>
> >>>>> To not touch the original data on `/dev/sdd` after the error we created on overlay
> >>>>> FS to test xfs_repair, and analyze the effect.
> >>>>>
> >>>>> ```
> >>>>> # more /scratch/local3/mkoverlay.sh 
> >>>>> dev=/dev/sdd
> >>>>> ovl=/scratch/local3/X4042-overlay.file
> >>>>> newdevname=sddovl
> >>>>> size=$(blockdev --getsz "$dev")
> >>>>>
> >>>>> loop=$(losetup -f --show -- "$ovl")
> >>>>> printf '%s\n' "0 $size snapshot $dev $loop P 8" 
> >>>>> printf '%s\n' "0 $size snapshot $dev $loop P 8" | dmsetup create "$newdevname"
> >>>>> # lsblk
> >>>>> NAME     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> >>>>> loop0      7:0    0    10G  0 loop 
> >>>>> loop1      7:1    0    10G  0 loop 
> >>>>> └─sddovl 252:0    0    51T  0 dm   
> >>>>> sda        8:0    0 931.5G  0 disk 
> >>>>> ├─sda1     8:1    0   256G  0 part /
> >>>>> └─sda2     8:2    0 675.5G  0 part /amd/tinytina/0
> >>>>> sdb        8:16   0 931.5G  0 disk /amd/tinytina/1
> >>>>> sdc        8:32   0  27.3T  0 disk /amd/tinytina/2
> >>>>> sdd        8:48   0    51T  0 disk 
> >>>>> └─sddovl 252:0    0    51T  0 dm   
> >>>>> sde        8:64   0    51T  0 disk /amd/tinytina/X/X4075
> >>>>> sdf        8:80   0    51T  0 disk /amd/tinytina/X/X4076
> >>>>> ```
> >>>>>
> >>>>>>>> and the xfs_repair shows the summary below.
> >>>>>>>>
> >>>>>>>> ```
> >>>>>>>> # xfs_repair -vv /dev/mapper/sddovl
> >>>>>>>>         - block cache size set to 4201400 entries
> >>>>>>>> Phase 2 - using internal log
> >>>>>>>>         - zero log...
> >>>>>>>> zero_log: head block 3930112 tail block 3929088
> >>>>>>>> ERROR: The filesystem has valuable metadata changes in a log which needs to
> >>>>>>>> be replayed.  Mount the filesystem to replay the log, and unmount it before
> >>>>>>>> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> >>>>>>>> the -L option to destroy the log and attempt a repair.
> >>>>>>>> Note that destroying the log may cause corruption -- please attempt a mount
> >>>>>>>
> >>>>>>> Have you tried to mount/umount the filesystem before zeroing the log? This is
> >>>>>>> supposed to be used as a last resort. Zero out the logs I mean.
> >>>>>
> >>>>> Yes, we tried that, and were told to run `xfs_repair`.
> >>>>>
> >>>>>>>> The directory `lost+found` contains almost five million files
> >>>>>>>>
> >>>>>>>>     # find lost+found | wc
> >>>>>>>>     4859687 4859687 110985720
> >>>>>>>
> >>>>>>> We don't have neither the whole xfs_repair output nor more information about the
> >>>>>>> filesystem itself, but looks like you had huge directory(ies) update in your log
> >>>>>>> which were not replayed, and all orphan inodes ended up in the lost+found =/
> >>>>>
> >>>>> I’ll see if I can share the 500 MB xfs_repair output.
> >>>>>
> >>>>> ```
> >>>>> $ lsblk /dev/sdd
> >>>>> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> >>>>> sdd    8:48   0  51T  0 disk
> >>>>> $ sudo xfs_info /dev/sdd
> >>>>> Password (for pmenzel) : 
> >>>>> meta-data=/dev/sdd               isize=512    agcount=51, agsize=268435392 blks
> >>>>>          =                       sectsz=512   attr=2, projid32bit=1
> >>>>>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
> >>>>>          =                       reflink=0
> >>>>> data     =                       bsize=4096   blocks=13671838208, imaxpct=1
> >>>>>          =                       sunit=64     swidth=896 blks
> >>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> >>>>> log      =internal log           bsize=4096   blocks=521728, version=2
> >>>>>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> >>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>>>> ```
> >>>>>
> >>>>>>>> We saved the output of `xfs_repair`, but it’s over 500 MB in size, so we
> >>>>>>>> cannot attach it.
> >>>>>>>>
> >>>>>>>> `sudo xfs_metadump -go /dev/sdd sdd-metadump.dump` takes over 15 minutes
> >>>>>>>> and the dump files is 8.8 GB in size.
> >>>>>>>
> >>>>>>> At this point, xfs_metadump won't help much once you already repaired the
> >>>>>>> filesystem.
> >>>>>
> >>>>> As written, we only run the repair on the overlay.
> >>>>>
> >>>>>>> Although, why are you getting a metadump from /dev/sdd, when the fs you tried to
> >>>>>>> repair is a device-mapper device? Are you facing this issue in more than one
> >>>>>>> filesystem?
> >>>>>
> >>>>> As written above, it was to not touch `/dev/sdd`. So the meta data dump should be
> >>>>> useable.
> >>>>>
> >>>>>>>> It’d be great, if you could give hints on debugging this issue further,
> >>>>>>>> and comment, if you think it is possible to recover the files, that means,
> >>>>>>>> to fix the log, so that it can be cleanly applied.
> >>>>>>>
> >>>>>>> Unfortunately, you already got rid of the log, so, you can't recover it anymore,
> >>>>>>> but all the recovered files will be in lost+found, with their inode numbers as
> >>>>>>> file name.
> >>>>>>>
> >>>>>>> Ok, so below is the dmesg, thanks for having attached it.
> >>>>>>>
> >>>>>>> One thing is there are 2 devices failing. sdd and dm-0. So my question again, is
> >>>>>>> this the same filesystem or are they 2 separated filesystems showing exactly the
> >>>>>>> same issue? The filesystem has found corrupted inodes in the AG's unlinked
> >>>>>>> bucket, but this shouldn't affect log recovery.
> >>>>>>>
> >>>>>>> If they are two separated devices, did you xfs_repair'ed both of them? After you
> >>>>>>> repaired the filesystem(s), do you still see the memory corruption issue?
> >>>>>
> >>>>> No, we do not see the corruption issue anymore, and mounting works as expected.
> >>>>>
> >>>>>>> At this point, there is not much we can do regarding the filesystem metadata,
> >>>>>>> once you already forced a xfs_repair zeroing the logs.
> >>>>>>>
> >>>>>>> So, could you please tell the current state of the filesystem (or filesystems if
> >>>>>>> there is more than one)? Are you still seeing the same memory corruption error
> >>>>>>> even after xfs_repair it?
> >>>>>
> >>>>> The user wants to continue using the device, and does not need the recovered files,
> >>>>> so we had to go ahead, and repair `/dev/sde` now too. We are only interested in
> >>>>> having this bug fixed in XFS, and not about data recovery.
> >>>>>
> >>>>
> >>>> Well, if the metadump is still available and is based on the original
> >>>> (broken) fs then it may be able to reproduce the original problem. How
> >>>> large is it compressed? Would you be able to upload it somewhere?
> >>>>
> >>>> Brian
> >>>>
> >>>>>> FWIW, if you do still have an original copy of the fs, we could see
> >>>>>> about whether bypassing the shutdown allows us to trade log recovery
> >>>>>> failure for a space accounting error. This would still require a
> >>>>>> subsequent repair, but that may be less invasive than zapping the log
> >>>>>> and dealing with the aftermath of that.
> >>>>>
> >>>>> Unfortunately, it’s 50 TB, so we do not have a copy anymore.
> >>>>>
> >>>>>>> And for completeness, please provide us as much information as possible from
> >>>>>>> this(these) filesystem(s):
> >>>>>>>
> >>>>>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>>>>
> >>>>>     /dev/sdd /amd/tinytina/X/X4074 xfs rw,relatime,attr2,inode64,logbsize=256k,sunit=512,swidth=7168,noquota 0 0
> >>>>>
> >>>>>>>> [ 1380.869451] XFS (sdd): Mounting V5 Filesystem
> >>>>>>>> [ 1380.912559] XFS (sdd): Starting recovery (logdev: internal)
> >>>>>>>> [ 1381.030780] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> >>>
> >>> <groan> Funny, I saw this exact same thing a week ago.  We really ought
> >>> to record a stack trace when we cancel dirty transactions.
> >>>
> >>> Hmm, so leaking millions of nfs file handles ... were they temporary or
> >>> deleted files?
> >>>
> >>> I bet I know exactly what caused this -- freeing unlinked inodes that
> >>> required a free inode btree expansion, but m_inotbt_nores was
> >>> incorrectly set during log recovery so we didn't reserve any blocks and
> >>> blew up.
> >>
> >> Interesting. I suppose rather than upload it, the user could try to
> >> restore the metadump somewhere, bump /proc/sys/fs/xfs/error_level to >=5
> >> and reproduce the mount failure to try and generate a stack trace.
> > 
> > Please find the 2.1 GB LZ4-compressed metadata dump at [1]. Please delete
> > it after you are done using it for analysis.
> 
> And here is the stack trace. Please find the full output of `dmesg` attached.
> 

FWIW, this looks to me exactly the scenario Darrick calls out above.
You probably want to try the patches referenced in his mail.

Brian

> ```
> [1145080.180898] XFS (loop0): Mounting V5 Filesystem
> [1145080.221747] XFS (loop0): Starting recovery (logdev: internal)
> [1145080.231642] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 000000009195283b
> [1145080.231647] XFS (loop0): Corruption of in-memory data detected.  Shutting down filesystem
> [1145080.231651] CPU: 12 PID: 129522 Comm: mount Kdump: loaded Not tainted 4.19.19.mx64.244 #1
> [1145080.231652] Hardware name: Supermicro AS -2023US-TR4/H11DSU-iN, BIOS 1.1 02/07/2018
> [1145080.231653] Call Trace:
> [1145080.231664]  dump_stack+0x46/0x5b
> [1145080.231669]  xfs_do_force_shutdown+0x10e/0x110
> [1145080.231672]  xfs_trans_mod_sb+0x1b0/0x1c0
> [1145080.231677]  xfs_alloc_ag_vextent+0x99/0x150
> [1145080.231679]  xfs_alloc_vextent+0x42b/0x560
> [1145080.231682]  __xfs_inobt_alloc_block.isra.2+0x9f/0x100
> [1145080.231685]  __xfs_btree_split+0xcb/0x600
> [1145080.231690]  ? loop_queue_rq+0xa6/0xc0
> [1145080.231692]  ? xfs_buf_trylock+0x19/0xe0
> [1145080.231696]  ? down_trylock+0x25/0x30
> [1145080.231697]  xfs_btree_split+0x4b/0x100
> [1145080.231699]  xfs_btree_make_block_unfull+0x186/0x1c0
> [1145080.231701]  xfs_btree_insrec+0x474/0x4c0
> [1145080.231704]  ? xfs_btree_read_buf_block.constprop.28+0x97/0xd0
> [1145080.231705]  xfs_btree_insert+0xcb/0x240
> [1145080.231707]  ? xfs_difree_finobt+0xb9/0x1e0
> [1145080.231708]  xfs_difree_finobt+0xb9/0x1e0
> [1145080.231710]  xfs_difree+0x11e/0x190
> [1145080.231712]  xfs_ifree+0x71/0x160
> [1145080.231715]  ? xfs_inode_item_init+0x1e/0x50
> [1145080.231717]  xfs_inactive_ifree+0x9e/0x1c0
> [1145080.231719]  xfs_inactive+0xa1/0x140
> [1145080.231721]  xfs_fs_destroy_inode+0xb1/0x1c0
> [1145080.231723]  xlog_recover_process_one_iunlink+0xcb/0x110
> [1145080.231725]  xlog_recover_process_iunlinks.isra.28+0x7c/0xc0
> [1145080.231727]  xlog_recover_finish+0x37/0xa0
> [1145080.231729]  xfs_log_mount_finish+0x5a/0xe0
> [1145080.231731]  xfs_mountfs+0x617/0x860
> [1145080.231733]  ? xfs_mru_cache_create+0x12b/0x180
> [1145080.231734]  xfs_fs_fill_super+0x462/0x5d0
> [1145080.231735]  ? xfs_test_remount_options+0x60/0x60
> [1145080.231739]  mount_bdev+0x173/0x1b0
> [1145080.231742]  mount_fs+0x15/0x80
> [1145080.231745]  vfs_kern_mount.part.9+0x54/0x100
> [1145080.231747]  do_mount+0x20d/0xc30
> [1145080.231750]  ? _copy_from_user+0x37/0x60
> [1145080.231753]  ? memdup_user+0x3e/0x70
> [1145080.231755]  ksys_mount+0x80/0xd0
> [1145080.231757]  __x64_sys_mount+0x21/0x30
> [1145080.231759]  do_syscall_64+0x48/0x100
> [1145080.231763]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [1145080.231766] RIP: 0033:0x7f454074e7da
> [1145080.231769] Code: 48 8b 0d b1 c6 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 7e c6 2b 00 f7 d8 64 89 01 48
> [1145080.231770] RSP: 002b:00007ffc0b9bba58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> [1145080.231772] RAX: ffffffffffffffda RBX: 000000000060b340 RCX: 00007f454074e7da
> [1145080.231772] RDX: 00000000006200c0 RSI: 000000000060d240 RDI: 0000000000621840
> [1145080.231773] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f454078ca90
> [1145080.231774] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000000000621840
> [1145080.231774] R13: 00000000006200c0 R14: 0000000000000000 R15: 0000000000000003
> [1145080.231776] XFS (loop0): Please umount the filesystem and rectify the problem(s)
> ```
> 
> >>> Relevant patches that might fix this:
> >>>
> >>> "xfs: rename m_inotbt_nores to m_finobt_nores"
> >>> "xfs: reserve blocks for ifree transaction during log recovery"
> >>>
> >>> (As mentioned earlier, there's not much we can do once the log has been
> >>> zereod.)
> >>>
> >>> --D
> >>>
> >>>>>>>> [ 1381.030785] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> >>>>>>>> [ 1381.030786] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> >>>>>>>> [ 1381.031086] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> >>>>>>>> [ 1381.031088] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> >>>>>>>> [ 1381.031090] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> >>>>>>>> [ 1381.031093] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> >>>>>>>> [ 1381.031095] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> >>>>>>> <...>
> >>>>>>>> [ 1381.031113] XFS (sdd): Ending recovery (logdev: internal)
> >>>>>>>> [ 1381.031490] XFS (sdd): Error -5 reserving per-AG metadata reserve pool.
> >>>>>>>> [ 1381.031492] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5
> >>>>>>>
> >>>>>>>> [ 2795.123228] XFS (dm-0): Ending recovery (logdev: internal)
> >>>>>>>> [ 2795.231020] XFS (dm-0): Error -5 reserving per-AG metadata reserve pool.
> >>>>>>>> [ 2795.231023] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5
> >>>>>>>
> >>>>>>>> [10944.023429] XFS (dm-0): Mounting V5 Filesystem
> >>>>>>>> [10944.035260] XFS (dm-0): Ending clean mount
> >>>>>>>> [11664.862376] XFS (dm-0): Unmounting Filesystem
> >>>>>>>> [11689.260213] XFS (dm-0): Mounting V5 Filesystem
> >>>>>>>> [11689.338187] XFS (dm-0): Ending clean mount
> >>>>>
> >>>>> As written, data recovery is not needed anymore, but, if it’d help the driver,
> >>>>> we could share the logs we have (after making sure it’s obfuscated).
> >>>>>
> >>>>> Please tell us, if you are interested, and what dumps, xfs_repair output and
> >>>>> so on would be needed.
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> > [1]: https://www.molgen.mpg.de/~pmenzel/sdd-metadump.dump.lz4

> [    0.000000] Linux version 4.19.19.mx64.244 (root@theinternet.molgen.mpg.de) (gcc version 7.3.0 (GCC)) #1 SMP Tue Feb 5 13:01:13 CET 2019
> [    0.000000] Command line: BOOT_IMAGE=/boot/bzImage-4.19.19.mx64.244 crashkernel=256M root=LABEL=root ro console=ttyS1,115200n8 console=tty0 init=/bin/systemd audit=0
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000076daffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000076db0000-0x0000000076ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000077000000-0x00000000c9d5efff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000c9d5f000-0x00000000c9dd1fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000c9dd2000-0x00000000c9e84fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000c9e85000-0x00000000ca210fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000ca211000-0x00000000cacc8fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cacc9000-0x00000000cbffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cc000000-0x00000000cfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ddc00000-0x00000000ddc7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ddd00000-0x00000000ddd7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dddf0000-0x00000000dddf0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000e007ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0100000-0x00000000e017ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e01f0000-0x00000000e01f0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e2700000-0x00000000e277ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e2800000-0x00000000e287ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e28f0000-0x00000000e28f0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e4b00000-0x00000000e4b7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e4c00000-0x00000000e4c7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e4cf0000-0x00000000e4cf0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e6f00000-0x00000000e6f7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e7000000-0x00000000e707ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e70f0000-0x00000000e70f0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e9300000-0x00000000e937ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e9400000-0x00000000e947ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e94f0000-0x00000000e94f0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000eb700000-0x00000000eb77ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000eb800000-0x00000000eb87ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000eb8f0000-0x00000000eb8f0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000eff00000-0x00000000eff7ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000efff0000-0x00000000efff0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000feafffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedc0000-0x00000000fedc0fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedc5fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedc7000-0x00000000fedc7fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedc9000-0x00000000fedcafff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000202f37ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000202f380000-0x000000202fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000002030000000-0x000000402ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000402ff80000-0x000000402fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000004030000000-0x000000602ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000602ff80000-0x000000602fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000006030000000-0x000000802ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000802ff80000-0x000000802fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000008030000000-0x000000a02ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000a02ff80000-0x000000a02fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000a030000000-0x000000c02ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000c02ff80000-0x000000c02fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000c030000000-0x000000e02ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000e02ff80000-0x000000e02fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000e030000000-0x000001002ff7ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000001002ff80000-0x000001002fffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 3.1.1 present.
> [    0.000000] DMI: Supermicro AS -2023US-TR4/H11DSU-iN, BIOS 1.1 02/07/2018
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] last_pfn = 0x1002ff80 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF write-through
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
> [    0.000000]   3 base 0000CC000000 mask FFFFFC000000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] TOM2: 0000010030000000 aka 1049344M
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
> [    0.000000] e820: update [mem 0xcc000000-0xffffffff] usable ==> reserved
> [    0.000000] last_pfn = 0xcc000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fd660-0x000fd66f] mapped at [(____ptrval____)]
> [    0.000000] Base memory trampoline at [(____ptrval____)] 93000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] BRK [0x02c02000, 0x02c02fff] PGTABLE
> [    0.000000] BRK [0x02c03000, 0x02c03fff] PGTABLE
> [    0.000000] BRK [0x02c04000, 0x02c04fff] PGTABLE
> [    0.000000] BRK [0x02c05000, 0x02c05fff] PGTABLE
> [    0.000000] BRK [0x02c06000, 0x02c06fff] PGTABLE
> [    0.000000] BRK [0x02c07000, 0x02c07fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x375e7000-0x37aeafff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F05B0 000024 (v02 SUPERM)
> [    0.000000] ACPI: XSDT 0x00000000C9E850A8 0000D4 (v01 SUPERM SUPERM   03242016 AMI  00010013)
> [    0.000000] ACPI: FACP 0x00000000C9E916E8 000114 (v06                 03242016 AMI  00010013)
> [    0.000000] ACPI: DSDT 0x00000000C9E85218 00C4CB (v02 SUPERM SMCI     03242016 INTL 20120913)
> [    0.000000] ACPI: FACS 0x00000000CA210E80 000040
> [    0.000000] ACPI: APIC 0x00000000C9E91800 0004B2 (v04                 03242016 AMI  00010013)
> [    0.000000] ACPI: FPDT 0x00000000C9E91CB8 000044 (v01                 03242016 AMI  00010013)
> [    0.000000] ACPI: FIDT 0x00000000C9E91D00 00009C (v01 SUPERM SMCI     03242016 AMI  00010013)
> [    0.000000] ACPI: SSDT 0x00000000C9E91DA0 0000D2 (v02 SUPERM AMD ALIB 00000002 MSFT 04000000)
> [    0.000000] ACPI: SPMI 0x00000000C9E91E78 000041 (v05 SUPERM SMCI     00000000 AMI. 00000000)
> [    0.000000] ACPI: SSDT 0x00000000C9E91EC0 0006AC (v02 SUPERM CPUSSDT  03242016 AMI  03242016)
> [    0.000000] ACPI: MCFG 0x00000000C9E92570 00003C (v01 SUPERM SMCI     03242016 MSFT 00010013)
> [    0.000000] ACPI: SSDT 0x00000000C9E925B0 0117A4 (v01 SUPERM AMD CPU  00000001 AMD  00000001)
> [    0.000000] ACPI: SRAT 0x00000000C9EA3D58 0009C0 (v03 SUPERM AMD SRAT 00000001 AMD  00000001)
> [    0.000000] ACPI: MSCT 0x00000000C9EA4718 00004E (v01 SUPERM AMD MSCT 00000000 AMD  00000001)
> [    0.000000] ACPI: SLIT 0x00000000C9EA4768 00006C (v01 SUPERM AMD SLIT 00000001 AMD  00000001)
> [    0.000000] ACPI: CRAT 0x00000000C9EA47D8 007700 (v01 SUPERM AMD CRAT 00000001 AMD  00000001)
> [    0.000000] ACPI: CDIT 0x00000000C9EABED8 000068 (v01 SUPERM AMD CDIT 00000001 AMD  00000001)
> [    0.000000] ACPI: BERT 0x00000000C9EABF40 000030 (v01 AMD    AMD BERT 00000001 AMD  00000001)
> [    0.000000] ACPI: EINJ 0x00000000C9EABF70 000150 (v01 AMD    AMD EINJ 00000001 AMD  00000001)
> [    0.000000] ACPI: HEST 0x00000000C9EAC0C0 000608 (v01 AMD    AMD HEST 00000001 AMD  00000001)
> [    0.000000] ACPI: HPET 0x00000000C9EAC6C8 000038 (v01 SUPERM SMCI     03242016 AMI  00000005)
> [    0.000000] ACPI: SSDT 0x00000000C9EAC700 000024 (v01 AMDFCH FCHZP    00001000 INTL 20120913)
> [    0.000000] ACPI: UEFI 0x00000000C9EAC728 000042 (v01                 00000000      00000000)
> [    0.000000] ACPI: SSDT 0x00000000C9EAC770 001630 (v01 AMD    CPMCMN   00000001 INTL 20120913)
> [    0.000000] ACPI: WSMT 0x00000000C9EADDA0 000028 (v01 \xfe\xca              03242016 AMI  00010013)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x18 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x19 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1a -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1b -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1c -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1d -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1e -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x1f -> Node 1
> [    0.000000] SRAT: PXM 2 -> APIC 0x20 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x21 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x22 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x23 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x24 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x25 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x26 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x27 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x28 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x29 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2a -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2b -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2c -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2d -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2e -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 0x2f -> Node 2
> [    0.000000] SRAT: PXM 3 -> APIC 0x30 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x31 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x32 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x33 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x34 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x35 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x36 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x37 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x38 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x39 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3a -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3b -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3c -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3d -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3e -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 0x3f -> Node 3
> [    0.000000] SRAT: PXM 4 -> APIC 0x40 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x41 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x42 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x43 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x44 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x45 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x46 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x47 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x48 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x49 -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4a -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4b -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4c -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4d -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4e -> Node 4
> [    0.000000] SRAT: PXM 4 -> APIC 0x4f -> Node 4
> [    0.000000] SRAT: PXM 5 -> APIC 0x50 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x51 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x52 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x53 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x54 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x55 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x56 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x57 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x58 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x59 -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5a -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5b -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5c -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5d -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5e -> Node 5
> [    0.000000] SRAT: PXM 5 -> APIC 0x5f -> Node 5
> [    0.000000] SRAT: PXM 6 -> APIC 0x60 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x61 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x62 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x63 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x64 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x65 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x66 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x67 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x68 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x69 -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6a -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6b -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6c -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6d -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6e -> Node 6
> [    0.000000] SRAT: PXM 6 -> APIC 0x6f -> Node 6
> [    0.000000] SRAT: PXM 7 -> APIC 0x70 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x71 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x72 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x73 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x74 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x75 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x76 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x77 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x78 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x79 -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7a -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7b -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7c -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7d -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7e -> Node 7
> [    0.000000] SRAT: PXM 7 -> APIC 0x7f -> Node 7
> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xcfffffff]
> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x202fffffff]
> [    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x2030000000-0x402fffffff]
> [    0.000000] ACPI: SRAT: Node 2 PXM 2 [mem 0x4030000000-0x602fffffff]
> [    0.000000] ACPI: SRAT: Node 3 PXM 3 [mem 0x6030000000-0x802fffffff]
> [    0.000000] ACPI: SRAT: Node 4 PXM 4 [mem 0x8030000000-0xa02fffffff]
> [    0.000000] ACPI: SRAT: Node 5 PXM 5 [mem 0xa030000000-0xc02fffffff]
> [    0.000000] ACPI: SRAT: Node 6 PXM 6 [mem 0xc030000000-0xe02fffffff]
> [    0.000000] ACPI: SRAT: Node 7 PXM 7 [mem 0xe030000000-0x1002fffffff]
> [    0.000000] NUMA: Initialized distance table, cnt=8
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xcfffffff] -> [mem 0x00000000-0xcfffffff]
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0xcfffffff] + [mem 0x100000000-0x202fffffff] -> [mem 0x00000000-0x202fffffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x202f37c000-0x202f37ffff]
> [    0.000000] NODE_DATA(1) allocated [mem 0x402ff7c000-0x402ff7ffff]
> [    0.000000] NODE_DATA(2) allocated [mem 0x602ff7c000-0x602ff7ffff]
> [    0.000000] NODE_DATA(3) allocated [mem 0x802ff7c000-0x802ff7ffff]
> [    0.000000] NODE_DATA(4) allocated [mem 0xa02ff7c000-0xa02ff7ffff]
> [    0.000000] NODE_DATA(5) allocated [mem 0xc02ff7c000-0xc02ff7ffff]
> [    0.000000] NODE_DATA(6) allocated [mem 0xe02ff7c000-0xe02ff7ffff]
> [    0.000000] NODE_DATA(7) allocated [mem 0x1002ff7b000-0x1002ff7efff]
> [    0.000000] Reserving 256MB of memory at 624MB for crashkernel (System RAM: 1048478MB)
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000001002ff7ffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000098fff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x0000000076daffff]
> [    0.000000]   node   0: [mem 0x0000000077000000-0x00000000c9d5efff]
> [    0.000000]   node   0: [mem 0x00000000c9dd2000-0x00000000c9e84fff]
> [    0.000000]   node   0: [mem 0x00000000cacc9000-0x00000000cbffffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000202f37ffff]
> [    0.000000]   node   1: [mem 0x0000002030000000-0x000000402ff7ffff]
> [    0.000000]   node   2: [mem 0x0000004030000000-0x000000602ff7ffff]
> [    0.000000]   node   3: [mem 0x0000006030000000-0x000000802ff7ffff]
> [    0.000000]   node   4: [mem 0x0000008030000000-0x000000a02ff7ffff]
> [    0.000000]   node   5: [mem 0x000000a030000000-0x000000c02ff7ffff]
> [    0.000000]   node   6: [mem 0x000000c030000000-0x000000e02ff7ffff]
> [    0.000000]   node   7: [mem 0x000000e030000000-0x000001002ff7ffff]
> [    0.000000] Reserved but unavailable: 104 pages
> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000202f37ffff]
> [    0.000000] On node 0 totalpages: 33530385
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3992 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 12924 pages used for memmap
> [    0.000000]   DMA32 zone: 827129 pages, LIFO batch:63
> [    0.000000]   Normal zone: 510926 pages used for memmap
> [    0.000000]   Normal zone: 32699264 pages, LIFO batch:63
> [    0.000000] Initmem setup node 1 [mem 0x0000002030000000-0x000000402ff7ffff]
> [    0.000000] On node 1 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 2 [mem 0x0000004030000000-0x000000602ff7ffff]
> [    0.000000] On node 2 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 3 [mem 0x0000006030000000-0x000000802ff7ffff]
> [    0.000000] On node 3 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 4 [mem 0x0000008030000000-0x000000a02ff7ffff]
> [    0.000000] On node 4 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 5 [mem 0x000000a030000000-0x000000c02ff7ffff]
> [    0.000000] On node 5 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 6 [mem 0x000000c030000000-0x000000e02ff7ffff]
> [    0.000000] On node 6 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] Initmem setup node 7 [mem 0x000000e030000000-0x000001002ff7ffff]
> [    0.000000] On node 7 totalpages: 33554304
> [    0.000000]   Normal zone: 524286 pages used for memmap
> [    0.000000]   Normal zone: 33554304 pages, LIFO batch:63
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 128, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] IOAPIC[1]: apic_id 129, version 33, address 0xefff0000, GSI 24-55
> [    0.000000] IOAPIC[2]: apic_id 130, version 33, address 0xeb8f0000, GSI 56-87
> [    0.000000] IOAPIC[3]: apic_id 131, version 33, address 0xe94f0000, GSI 88-119
> [    0.000000] IOAPIC[4]: apic_id 132, version 33, address 0xe70f0000, GSI 120-151
> [    0.000000] IOAPIC[5]: apic_id 133, version 33, address 0xe4cf0000, GSI 152-183
> [    0.000000] IOAPIC[6]: apic_id 134, version 33, address 0xe28f0000, GSI 184-215
> [    0.000000] IOAPIC[7]: apic_id 135, version 33, address 0xe01f0000, GSI 216-247
> [    0.000000] IOAPIC[8]: apic_id 136, version 33, address 0xdddf0000, GSI 248-279
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 128 CPUs, 0 hotplug CPUs
> [    0.000000] [mem 0xefff1000-0xfe9fffff] available for PCI devices
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.000000] random: get_random_bytes called from start_kernel+0x90/0x4a7 with crng_init=0
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:128 nr_node_ids:8
> [    0.000000] percpu: Embedded 42 pages/cpu @(____ptrval____) s134104 r8192 d29736 u262144
> [    0.000000] pcpu-alloc: s134104 r8192 d29736 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 
> [    0.000000] pcpu-alloc: [0] 064 065 066 067 068 069 070 071 
> [    0.000000] pcpu-alloc: [1] 008 009 010 011 012 013 014 015 
> [    0.000000] pcpu-alloc: [1] 072 073 074 075 076 077 078 079 
> [    0.000000] pcpu-alloc: [2] 016 017 018 019 020 021 022 023 
> [    0.000000] pcpu-alloc: [2] 080 081 082 083 084 085 086 087 
> [    0.000000] pcpu-alloc: [3] 024 025 026 027 028 029 030 031 
> [    0.000000] pcpu-alloc: [3] 088 089 090 091 092 093 094 095 
> [    0.000000] pcpu-alloc: [4] 032 033 034 035 036 037 038 039 
> [    0.000000] pcpu-alloc: [4] 096 097 098 099 100 101 102 103 
> [    0.000000] pcpu-alloc: [5] 040 041 042 043 044 045 046 047 
> [    0.000000] pcpu-alloc: [5] 104 105 106 107 108 109 110 111 
> [    0.000000] pcpu-alloc: [6] 048 049 050 051 052 053 054 055 
> [    0.000000] pcpu-alloc: [6] 112 113 114 115 116 117 118 119 
> [    0.000000] pcpu-alloc: [7] 056 057 058 059 060 061 062 063 
> [    0.000000] pcpu-alloc: [7] 120 121 122 123 124 125 126 127 
> [    0.000000] Built 8 zonelists, mobility grouping on.  Total pages: 264216576
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/bzImage-4.19.19.mx64.244 crashkernel=256M root=LABEL=root ro console=ttyS1,115200n8 console=tty0 init=/bin/systemd audit=0
> [    0.000000] audit: disabled (until reboot)
> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 520192 bytes
> [    0.000000] log_buf_len min size: 131072 bytes
> [    0.000000] log_buf_len: 1048576 bytes
> [    0.000000] early log buf free: 105316(80%)
> [    0.000000] Memory: 1056475592K/1073642052K available (14348K kernel code, 1379K rwdata, 3520K rodata, 1564K init, 1200K bss, 17166460K reserved, 0K cma-reserved)
> [    0.000000] ftrace: allocating 41809 entries in 164 pages
> [    0.000000] rcu: Hierarchical RCU implementation.
> [    0.000000] rcu: 	RCU event tracing is enabled.
> [    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=128.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=128
> [    0.000000] NR_IRQS: 16640, nr_irqs: 5800, preallocated irqs: 16
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [ttyS1] enabled
> [    0.000000] ACPI: Core revision 20180810
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] APIC: Switch to symmetric I/O mode setup
> [    0.001000] Switched APIC routing to physical flat.
> [    0.005000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.011000] tsc: PIT calibration matches HPET. 1 loops
> [    0.012000] tsc: Detected 2199.779 MHz processor
> [    0.000010] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x1fb56216d0f, max_idle_ns: 440795205636 ns
> [    0.010740] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.55 BogoMIPS (lpj=2199779)
> [    0.011741] pid_max: default: 131072 minimum: 1024
> [    0.073641] Dentry cache hash table entries: 33554432 (order: 16, 268435456 bytes)
> [    0.104227] Inode-cache hash table entries: 16777216 (order: 15, 134217728 bytes)
> [    0.105915] Mount-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.108107] Mountpoint-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.109583] mce: CPU supports 23 MCE banks
> [    0.110752] LVT offset 2 assigned for vector 0xf4
> [    0.111749] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
> [    0.112740] Last level dTLB entries: 4KB 1536, 2MB 1536, 4MB 768, 1GB 0
> [    0.113741] Spectre V2 : Mitigation: Full AMD retpoline
> [    0.114740] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
> [    0.115741] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
> [    0.116740] Spectre V2 : User space: Vulnerable
> [    0.117741] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
> [    0.118986] Freeing SMP alternatives memory: 44K
> [    0.121739] smpboot: CPU0: AMD EPYC 7601 32-Core Processor (family: 0x17, model: 0x1, stepping: 0x2)
> [    0.121911] Performance Events: Fam17h core perfctr, AMD PMU driver.
> [    0.122742] ... version:                0
> [    0.123740] ... bit width:              48
> [    0.124740] ... generic registers:      6
> [    0.125740] ... value mask:             0000ffffffffffff
> [    0.126740] ... max period:             00007fffffffffff
> [    0.127740] ... fixed-purpose events:   0
> [    0.128740] ... event mask:             000000000000003f
> [    0.129868] rcu: Hierarchical SRCU implementation.
> [    0.130892] MCE: In-kernel MCE decoding enabled.
> [    0.133825] smp: Bringing up secondary CPUs ...
> [    0.134860] x86: Booting SMP configuration:
> [    0.135741] .... node  #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
> [    0.146742] .... node  #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
> [    0.158742] .... node  #2, CPUs:    #16  #17  #18  #19  #20  #21  #22  #23
> [    0.171742] .... node  #3, CPUs:    #24  #25  #26  #27  #28  #29  #30  #31
> [    0.184742] .... node  #4, CPUs:    #32  #33  #34  #35  #36  #37  #38  #39
> [    0.207743] .... node  #5, CPUs:    #40  #41  #42  #43  #44  #45  #46  #47
> [    0.221742] .... node  #6, CPUs:    #48  #49  #50  #51  #52  #53  #54  #55
> [    0.235743] .... node  #7, CPUs:    #56  #57  #58  #59  #60  #61  #62  #63
> [    0.249742] .... node  #0, CPUs:    #64  #65  #66  #67  #68  #69  #70  #71
> [    0.263742] .... node  #1, CPUs:    #72  #73  #74  #75  #76  #77  #78  #79
> [    0.276743] .... node  #2, CPUs:    #80  #81  #82  #83  #84  #85  #86  #87
> [    0.290742] .... node  #3, CPUs:    #88  #89  #90  #91  #92  #93  #94  #95
> [    0.304742] .... node  #4, CPUs:    #96  #97  #98  #99 #100 #101 #102 #103
> [    0.318742] .... node  #5, CPUs:   #104 #105 #106 #107 #108 #109 #110 #111
> [    0.332742] .... node  #6, CPUs:   #112 #113 #114 #115 #116 #117 #118 #119
> [    0.347743] .... node  #7, CPUs:   #120 #121 #122 #123 #124 #125 #126 #127
> [    0.362030] smp: Brought up 8 nodes, 128 CPUs
> [    0.363741] smpboot: Max logical packages: 2
> [    0.364750] smpboot: Total of 128 processors activated (561541.50 BogoMIPS)
> [    0.420450] devtmpfs: initialized
> [    0.421124] PM: Registering ACPI NVS region [mem 0xc9e85000-0xca210fff] (3719168 bytes)
> [    0.423152] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.423862] futex hash table entries: 32768 (order: 9, 2097152 bytes)
> [    0.426094] xor: automatically using best checksumming function   avx       
> [    0.428980] NET: Registered protocol family 16
> [    0.431184] cpuidle: using governor ladder
> [    0.437493] ACPI: bus type PCI registered
> [    0.437785] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
> [    0.438744] PCI: not using MMCONFIG
> [    0.439741] PCI: Using configuration type 1 for base access
> [    0.440740] PCI: Using configuration type 1 for extended access
> [    0.451489] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.470748] raid6: sse2x1   gen()  6140 MB/s
> [    0.488742] raid6: sse2x1   xor()  5919 MB/s
> [    0.506741] raid6: sse2x2   gen() 12910 MB/s
> [    0.524741] raid6: sse2x2   xor()  8154 MB/s
> [    0.542742] raid6: sse2x4   gen() 13062 MB/s
> [    0.560746] raid6: sse2x4   xor()  7222 MB/s
> [    0.578743] raid6: avx2x1   gen() 15121 MB/s
> [    0.596742] raid6: avx2x1   xor() 10925 MB/s
> [    0.614741] raid6: avx2x2   gen() 20230 MB/s
> [    0.632741] raid6: avx2x2   xor() 11845 MB/s
> [    0.650742] raid6: avx2x4   gen() 20675 MB/s
> [    0.668743] raid6: avx2x4   xor()  9910 MB/s
> [    0.669741] raid6: using algorithm avx2x4 gen() 20675 MB/s
> [    0.670740] raid6: .... xor() 9910 MB/s, rmw enabled
> [    0.671740] raid6: using avx2x2 recovery algorithm
> [    0.673395] ACPI: Added _OSI(Module Device)
> [    0.673742] ACPI: Added _OSI(Processor Device)
> [    0.674740] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.675740] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.676741] ACPI: Added _OSI(Linux-Dell-Video)
> [    0.677741] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
> [    0.698616] ACPI: 6 ACPI AML tables successfully acquired and loaded
> [    0.706134] ACPI: Interpreter enabled
> [    0.706755] ACPI: (supports S0 S5)
> [    0.707742] ACPI: Using IOAPIC for interrupt routing
> [    0.709877] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
> [    0.710791] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in ACPI motherboard resources
> [    0.711755] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.714143] ACPI: Enabled 2 GPEs in block 00 to 1F
> [    0.718197] ACPI: Power Resource [P0SA] (off)
> [    0.718771] ACPI: Power Resource [P3SA] (off)
> [    0.724265] ACPI: Power Resource [P0SA] (off)
> [    0.724769] ACPI: Power Resource [P3SA] (off)
> [    0.727469] ACPI: Power Resource [P0SA] (off)
> [    0.727765] ACPI: Power Resource [P3SA] (off)
> [    0.731051] ACPI: Power Resource [P0SA] (off)
> [    0.731766] ACPI: Power Resource [P3SA] (off)
> [    0.734169] ACPI: Power Resource [P0SA] (off)
> [    0.734768] ACPI: Power Resource [P3SA] (off)
> [    0.737399] ACPI: Power Resource [P0SA] (off)
> [    0.737768] ACPI: Power Resource [P3SA] (off)
> [    0.740626] ACPI: Power Resource [P0SA] (off)
> [    0.740766] ACPI: Power Resource [P3SA] (off)
> [    0.743784] ACPI: Power Resource [P0SA] (off)
> [    0.744768] ACPI: Power Resource [P3SA] (off)
> [    0.749302] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-0f])
> [    0.749744] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.750917] acpi PNP0A08:00: _OSC: platform does not support [AER LTR]
> [    0.751905] acpi PNP0A08:00: _OSC: OS now controls [PME PCIeCapability]
> [    0.752939] PCI host bridge to bus 0000:00
> [    0.753742] pci_bus 0000:00: root bus resource [io  0x0000-0x02ff window]
> [    0.754742] pci_bus 0000:00: root bus resource [io  0x0300-0x03af window]
> [    0.755741] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
> [    0.756741] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
> [    0.757741] pci_bus 0000:00: root bus resource [io  0x0d00-0x1fff window]
> [    0.758741] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    0.759741] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
> [    0.760741] pci_bus 0000:00: root bus resource [mem 0xec000000-0xefffffff window]
> [    0.761741] pci_bus 0000:00: root bus resource [mem 0x1e006000000-0x1ffffffffff window]
> [    0.762741] pci_bus 0000:00: root bus resource [bus 00-0f]
> [    0.763748] pci 0000:00:00.0: [1022:1450] type 00 class 0x060000
> [    0.763839] pci 0000:00:01.0: [1022:1452] type 00 class 0x060000
> [    0.763912] pci 0000:00:01.3: [1022:1453] type 01 class 0x060400
> [    0.764468] pci 0000:00:01.3: PME# supported from D0 D3hot D3cold
> [    0.764557] pci 0000:00:01.4: [1022:1453] type 01 class 0x060400
> [    0.764809] pci 0000:00:01.4: PME# supported from D0 D3hot D3cold
> [    0.764900] pci 0000:00:01.6: [1022:1453] type 01 class 0x060400
> [    0.765799] pci 0000:00:01.6: PME# supported from D0 D3hot D3cold
> [    0.765883] pci 0000:00:02.0: [1022:1452] type 00 class 0x060000
> [    0.765963] pci 0000:00:03.0: [1022:1452] type 00 class 0x060000
> [    0.766044] pci 0000:00:04.0: [1022:1452] type 00 class 0x060000
> [    0.766786] pci 0000:00:07.0: [1022:1452] type 00 class 0x060000
> [    0.766851] pci 0000:00:07.1: [1022:1454] type 01 class 0x060400
> [    0.767401] pci 0000:00:07.1: enabling Extended Tags
> [    0.767822] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
> [    0.767917] pci 0000:00:08.0: [1022:1452] type 00 class 0x060000
> [    0.768745] pci 0000:00:08.1: [1022:1454] type 01 class 0x060400
> [    0.769415] pci 0000:00:08.1: enabling Extended Tags
> [    0.769824] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
> [    0.770837] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
> [    0.771058] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
> [    0.771964] pci 0000:00:18.0: [1022:1460] type 00 class 0x060000
> [    0.772014] pci 0000:00:18.1: [1022:1461] type 00 class 0x060000
> [    0.772066] pci 0000:00:18.2: [1022:1462] type 00 class 0x060000
> [    0.772119] pci 0000:00:18.3: [1022:1463] type 00 class 0x060000
> [    0.772172] pci 0000:00:18.4: [1022:1464] type 00 class 0x060000
> [    0.772219] pci 0000:00:18.5: [1022:1465] type 00 class 0x060000
> [    0.772269] pci 0000:00:18.6: [1022:1466] type 00 class 0x060000
> [    0.772318] pci 0000:00:18.7: [1022:1467] type 00 class 0x060000
> [    0.772368] pci 0000:00:19.0: [1022:1460] type 00 class 0x060000
> [    0.772425] pci 0000:00:19.1: [1022:1461] type 00 class 0x060000
> [    0.772481] pci 0000:00:19.2: [1022:1462] type 00 class 0x060000
> [    0.772533] pci 0000:00:19.3: [1022:1463] type 00 class 0x060000
> [    0.772588] pci 0000:00:19.4: [1022:1464] type 00 class 0x060000
> [    0.772641] pci 0000:00:19.5: [1022:1465] type 00 class 0x060000
> [    0.772696] pci 0000:00:19.6: [1022:1466] type 00 class 0x060000
> [    0.772755] pci 0000:00:19.7: [1022:1467] type 00 class 0x060000
> [    0.772807] pci 0000:00:1a.0: [1022:1460] type 00 class 0x060000
> [    0.772862] pci 0000:00:1a.1: [1022:1461] type 00 class 0x060000
> [    0.772915] pci 0000:00:1a.2: [1022:1462] type 00 class 0x060000
> [    0.772971] pci 0000:00:1a.3: [1022:1463] type 00 class 0x060000
> [    0.773024] pci 0000:00:1a.4: [1022:1464] type 00 class 0x060000
> [    0.773082] pci 0000:00:1a.5: [1022:1465] type 00 class 0x060000
> [    0.773134] pci 0000:00:1a.6: [1022:1466] type 00 class 0x060000
> [    0.773191] pci 0000:00:1a.7: [1022:1467] type 00 class 0x060000
> [    0.773244] pci 0000:00:1b.0: [1022:1460] type 00 class 0x060000
> [    0.773303] pci 0000:00:1b.1: [1022:1461] type 00 class 0x060000
> [    0.773358] pci 0000:00:1b.2: [1022:1462] type 00 class 0x060000
> [    0.773413] pci 0000:00:1b.3: [1022:1463] type 00 class 0x060000
> [    0.773466] pci 0000:00:1b.4: [1022:1464] type 00 class 0x060000
> [    0.773522] pci 0000:00:1b.5: [1022:1465] type 00 class 0x060000
> [    0.773579] pci 0000:00:1b.6: [1022:1466] type 00 class 0x060000
> [    0.773631] pci 0000:00:1b.7: [1022:1467] type 00 class 0x060000
> [    0.773686] pci 0000:00:1c.0: [1022:1460] type 00 class 0x060000
> [    0.773756] pci 0000:00:1c.1: [1022:1461] type 00 class 0x060000
> [    0.773819] pci 0000:00:1c.2: [1022:1462] type 00 class 0x060000
> [    0.773884] pci 0000:00:1c.3: [1022:1463] type 00 class 0x060000
> [    0.773947] pci 0000:00:1c.4: [1022:1464] type 00 class 0x060000
> [    0.774009] pci 0000:00:1c.5: [1022:1465] type 00 class 0x060000
> [    0.774073] pci 0000:00:1c.6: [1022:1466] type 00 class 0x060000
> [    0.774136] pci 0000:00:1c.7: [1022:1467] type 00 class 0x060000
> [    0.774200] pci 0000:00:1d.0: [1022:1460] type 00 class 0x060000
> [    0.774264] pci 0000:00:1d.1: [1022:1461] type 00 class 0x060000
> [    0.774328] pci 0000:00:1d.2: [1022:1462] type 00 class 0x060000
> [    0.774389] pci 0000:00:1d.3: [1022:1463] type 00 class 0x060000
> [    0.774451] pci 0000:00:1d.4: [1022:1464] type 00 class 0x060000
> [    0.774513] pci 0000:00:1d.5: [1022:1465] type 00 class 0x060000
> [    0.774576] pci 0000:00:1d.6: [1022:1466] type 00 class 0x060000
> [    0.774640] pci 0000:00:1d.7: [1022:1467] type 00 class 0x060000
> [    0.774702] pci 0000:00:1e.0: [1022:1460] type 00 class 0x060000
> [    0.774768] pci 0000:00:1e.1: [1022:1461] type 00 class 0x060000
> [    0.774828] pci 0000:00:1e.2: [1022:1462] type 00 class 0x060000
> [    0.774889] pci 0000:00:1e.3: [1022:1463] type 00 class 0x060000
> [    0.774949] pci 0000:00:1e.4: [1022:1464] type 00 class 0x060000
> [    0.775007] pci 0000:00:1e.5: [1022:1465] type 00 class 0x060000
> [    0.775069] pci 0000:00:1e.6: [1022:1466] type 00 class 0x060000
> [    0.775127] pci 0000:00:1e.7: [1022:1467] type 00 class 0x060000
> [    0.775185] pci 0000:00:1f.0: [1022:1460] type 00 class 0x060000
> [    0.775248] pci 0000:00:1f.1: [1022:1461] type 00 class 0x060000
> [    0.775313] pci 0000:00:1f.2: [1022:1462] type 00 class 0x060000
> [    0.775380] pci 0000:00:1f.3: [1022:1463] type 00 class 0x060000
> [    0.775441] pci 0000:00:1f.4: [1022:1464] type 00 class 0x060000
> [    0.775504] pci 0000:00:1f.5: [1022:1465] type 00 class 0x060000
> [    0.775567] pci 0000:00:1f.6: [1022:1466] type 00 class 0x060000
> [    0.775633] pci 0000:00:1f.7: [1022:1467] type 00 class 0x060000
> [    0.775795] pci 0000:01:00.0: [1b21:1142] type 00 class 0x0c0330
> [    0.775826] pci 0000:01:00.0: reg 0x10: [mem 0xef800000-0xef807fff 64bit]
> [    0.775940] pci 0000:01:00.0: PME# supported from D3cold
> [    0.776028] pci 0000:00:01.3: PCI bridge to [bus 01]
> [    0.776745] pci 0000:00:01.3:   bridge window [mem 0xef800000-0xef8fffff]
> [    0.777391] pci 0000:02:00.0: [1b21:1142] type 00 class 0x0c0330
> [    0.777420] pci 0000:02:00.0: reg 0x10: [mem 0xef700000-0xef707fff 64bit]
> [    0.777535] pci 0000:02:00.0: PME# supported from D3cold
> [    0.777760] pci 0000:00:01.4: PCI bridge to [bus 02]
> [    0.778744] pci 0000:00:01.4:   bridge window [mem 0xef700000-0xef7fffff]
> [    0.779337] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
> [    0.779439] pci 0000:03:00.0: supports D1 D2
> [    0.779440] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.781761] pci 0000:00:01.6: PCI bridge to [bus 03-04]
> [    0.782744] pci 0000:00:01.6:   bridge window [io  0x1000-0x1fff]
> [    0.782747] pci 0000:00:01.6:   bridge window [mem 0xee000000-0xef0fffff]
> [    0.782787] pci_bus 0000:04: extended config space not accessible
> [    0.783769] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
> [    0.783791] pci 0000:04:00.0: reg 0x10: [mem 0xee000000-0xeeffffff]
> [    0.783802] pci 0000:04:00.0: reg 0x14: [mem 0xef000000-0xef01ffff]
> [    0.783813] pci 0000:04:00.0: reg 0x18: [io  0x1000-0x107f]
> [    0.783900] pci 0000:04:00.0: supports D1 D2
> [    0.783902] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.783987] pci 0000:03:00.0: PCI bridge to [bus 04]
> [    0.784746] pci 0000:03:00.0:   bridge window [io  0x1000-0x1fff]
> [    0.784749] pci 0000:03:00.0:   bridge window [mem 0xee000000-0xef0fffff]
> [    0.785422] pci 0000:05:00.0: [1022:145a] type 00 class 0x130000
> [    0.785460] pci 0000:05:00.0: enabling Extended Tags
> [    0.785822] pci 0000:05:00.2: [1022:1456] type 00 class 0x108000
> [    0.785842] pci 0000:05:00.2: reg 0x18: [mem 0xef300000-0xef3fffff]
> [    0.785855] pci 0000:05:00.2: reg 0x24: [mem 0xef400000-0xef401fff]
> [    0.785863] pci 0000:05:00.2: enabling Extended Tags
> [    0.786824] pci 0000:05:00.3: [1022:145f] type 00 class 0x0c0330
> [    0.786839] pci 0000:05:00.3: reg 0x10: [mem 0xef200000-0xef2fffff 64bit]
> [    0.786861] pci 0000:05:00.3: enabling Extended Tags
> [    0.787773] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
> [    0.787842] pci 0000:00:07.1: PCI bridge to [bus 05]
> [    0.788744] pci 0000:00:07.1:   bridge window [mem 0xef200000-0xef4fffff]
> [    0.788974] pci 0000:06:00.0: [1022:1455] type 00 class 0x130000
> [    0.789014] pci 0000:06:00.0: enabling Extended Tags
> [    0.789823] pci 0000:06:00.1: [1022:1468] type 00 class 0x108000
> [    0.789844] pci 0000:06:00.1: reg 0x18: [mem 0xef500000-0xef5fffff]
> [    0.789858] pci 0000:06:00.1: reg 0x24: [mem 0xef600000-0xef601fff]
> [    0.789866] pci 0000:06:00.1: enabling Extended Tags
> [    0.790846] pci 0000:00:08.1: PCI bridge to [bus 06]
> [    0.791744] pci 0000:00:08.1:   bridge window [mem 0xef500000-0xef6fffff]
> [    0.791770] pci_bus 0000:00: on NUMA node 0
> [    0.793172] ACPI: PCI Root Bridge [S0D1] (domain 0000 [bus 10-1f])
> [    0.793744] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.794916] acpi PNP0A08:01: _OSC: platform does not support [AER LTR]
> [    0.796886] acpi PNP0A08:01: _OSC: OS now controls [PME PCIeCapability]
> [    0.798783] PCI host bridge to bus 0000:10
> [    0.799742] pci_bus 0000:10: root bus resource [io  0x2000-0x3fff window]
> [    0.800742] pci_bus 0000:10: root bus resource [mem 0xe9900000-0xebffffff window]
> [    0.801742] pci_bus 0000:10: root bus resource [mem 0x1c00c000000-0x1e005ffffff window]
> [    0.802741] pci_bus 0000:10: root bus resource [bus 10-1f]
> [    0.803746] pci 0000:10:00.0: [1022:1450] type 00 class 0x060000
> [    0.803831] pci 0000:10:01.0: [1022:1452] type 00 class 0x060000
> [    0.803898] pci 0000:10:01.1: [1022:1453] type 01 class 0x060400
> [    0.804832] pci 0000:10:01.1: PME# supported from D0 D3hot D3cold
> [    0.804934] pci 0000:10:02.0: [1022:1452] type 00 class 0x060000
> [    0.805016] pci 0000:10:03.0: [1022:1452] type 00 class 0x060000
> [    0.805094] pci 0000:10:04.0: [1022:1452] type 00 class 0x060000
> [    0.805176] pci 0000:10:07.0: [1022:1452] type 00 class 0x060000
> [    0.805240] pci 0000:10:07.1: [1022:1454] type 01 class 0x060400
> [    0.805744] pci 0000:10:07.1: enabling Extended Tags
> [    0.806826] pci 0000:10:07.1: PME# supported from D0 D3hot D3cold
> [    0.806919] pci 0000:10:08.0: [1022:1452] type 00 class 0x060000
> [    0.806982] pci 0000:10:08.1: [1022:1454] type 01 class 0x060400
> [    0.807017] pci 0000:10:08.1: enabling Extended Tags
> [    0.808806] pci 0000:10:08.1: PME# supported from D0 D3hot D3cold
> [    0.809433] pci 0000:11:00.0: [8086:1521] type 00 class 0x020000
> [    0.810479] pci 0000:11:00.0: reg 0x10: [mem 0xeba80000-0xebafffff]
> [    0.811052] pci 0000:11:00.0: reg 0x18: [io  0x3060-0x307f]
> [    0.811324] pci 0000:11:00.0: reg 0x1c: [mem 0xebb0c000-0xebb0ffff]
> [    0.814635] pci 0000:11:00.0: PME# supported from D0 D3hot D3cold
> [    0.815816] pci 0000:11:00.0: reg 0x184: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.815818] pci 0000:11:00.0: VF(n) BAR0 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    0.817817] pci 0000:11:00.0: reg 0x190: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.817819] pci 0000:11:00.0: VF(n) BAR3 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    0.822132] pci 0000:11:00.1: [8086:1521] type 00 class 0x020000
> [    0.823011] pci 0000:11:00.1: reg 0x10: [mem 0xeba00000-0xeba7ffff]
> [    0.823558] pci 0000:11:00.1: reg 0x18: [io  0x3040-0x305f]
> [    0.823816] pci 0000:11:00.1: reg 0x1c: [mem 0xebb08000-0xebb0bfff]
> [    0.827014] pci 0000:11:00.1: PME# supported from D0 D3hot D3cold
> [    0.828096] pci 0000:11:00.1: reg 0x184: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.828098] pci 0000:11:00.1: VF(n) BAR0 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    0.830125] pci 0000:11:00.1: reg 0x190: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.830126] pci 0000:11:00.1: VF(n) BAR3 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    0.833934] pci 0000:11:00.2: [8086:1521] type 00 class 0x020000
> [    0.834777] pci 0000:11:00.2: reg 0x10: [mem 0xeb980000-0xeb9fffff]
> [    0.835318] pci 0000:11:00.2: reg 0x18: [io  0x3020-0x303f]
> [    0.835591] pci 0000:11:00.2: reg 0x1c: [mem 0xebb04000-0xebb07fff]
> [    0.838817] pci 0000:11:00.2: PME# supported from D0 D3hot D3cold
> [    0.839879] pci 0000:11:00.2: reg 0x184: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.839881] pci 0000:11:00.2: VF(n) BAR0 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    0.841879] pci 0000:11:00.2: reg 0x190: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.841881] pci 0000:11:00.2: VF(n) BAR3 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    0.845669] pci 0000:11:00.3: [8086:1521] type 00 class 0x020000
> [    0.846516] pci 0000:11:00.3: reg 0x10: [mem 0xeb900000-0xeb97ffff]
> [    0.847052] pci 0000:11:00.3: reg 0x18: [io  0x3000-0x301f]
> [    0.847324] pci 0000:11:00.3: reg 0x1c: [mem 0xebb00000-0xebb03fff]
> [    0.850555] pci 0000:11:00.3: PME# supported from D0 D3hot D3cold
> [    0.851633] pci 0000:11:00.3: reg 0x184: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.851634] pci 0000:11:00.3: VF(n) BAR0 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    0.852381] pci 0000:11:00.3: reg 0x190: [mem 0x00000000-0x00003fff 64bit pref]
> [    0.852383] pci 0000:11:00.3: VF(n) BAR3 space: [mem 0x00000000-0x0001ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    0.856293] pci 0000:10:01.1: PCI bridge to [bus 11]
> [    0.856744] pci 0000:10:01.1:   bridge window [io  0x3000-0x3fff]
> [    0.856747] pci 0000:10:01.1:   bridge window [mem 0xeb900000-0xebbfffff]
> [    0.857784] pci 0000:12:00.0: [1022:145a] type 00 class 0x130000
> [    0.857826] pci 0000:12:00.0: enabling Extended Tags
> [    0.858824] pci 0000:12:00.2: [1022:1456] type 00 class 0x108000
> [    0.858846] pci 0000:12:00.2: reg 0x18: [mem 0xebe00000-0xebefffff]
> [    0.858860] pci 0000:12:00.2: reg 0x24: [mem 0xebf00000-0xebf01fff]
> [    0.858869] pci 0000:12:00.2: enabling Extended Tags
> [    0.859845] pci 0000:10:07.1: PCI bridge to [bus 12]
> [    0.860744] pci 0000:10:07.1:   bridge window [mem 0xebe00000-0xebffffff]
> [    0.861785] pci 0000:13:00.0: [1022:1455] type 00 class 0x130000
> [    0.861831] pci 0000:13:00.0: enabling Extended Tags
> [    0.862828] pci 0000:13:00.1: [1022:1468] type 00 class 0x108000
> [    0.862852] pci 0000:13:00.1: reg 0x18: [mem 0xebc00000-0xebcfffff]
> [    0.862866] pci 0000:13:00.1: reg 0x24: [mem 0xebd00000-0xebd01fff]
> [    0.862876] pci 0000:13:00.1: enabling Extended Tags
> [    0.863836] pci 0000:13:00.2: [1022:7901] type 00 class 0x010601
> [    0.863873] pci 0000:13:00.2: reg 0x24: [mem 0xebd02000-0xebd02fff]
> [    0.863883] pci 0000:13:00.2: enabling Extended Tags
> [    0.864777] pci 0000:13:00.2: PME# supported from D3hot D3cold
> [    0.865741] pci 0000:10:08.1: PCI bridge to [bus 13]
> [    0.866745] pci 0000:10:08.1:   bridge window [mem 0xebc00000-0xebdfffff]
> [    0.866763] pci_bus 0000:10: on NUMA node 1
> [    0.867093] ACPI: PCI Root Bridge [S0D2] (domain 0000 [bus 20-2f])
> [    0.867743] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.868910] acpi PNP0A08:02: _OSC: platform does not support [AER LTR]
> [    0.869900] acpi PNP0A08:02: _OSC: OS now controls [PME PCIeCapability]
> [    0.871805] PCI host bridge to bus 0000:20
> [    0.872742] pci_bus 0000:20: root bus resource [io  0x4000-0x5fff window]
> [    0.873741] pci_bus 0000:20: root bus resource [mem 0xe7500000-0xe98fffff window]
> [    0.874741] pci_bus 0000:20: root bus resource [mem 0x1a012000000-0x1c00bffffff window]
> [    0.875741] pci_bus 0000:20: root bus resource [bus 20-2f]
> [    0.876746] pci 0000:20:00.0: [1022:1450] type 00 class 0x060000
> [    0.876831] pci 0000:20:01.0: [1022:1452] type 00 class 0x060000
> [    0.876911] pci 0000:20:02.0: [1022:1452] type 00 class 0x060000
> [    0.876989] pci 0000:20:03.0: [1022:1452] type 00 class 0x060000
> [    0.877809] pci 0000:20:04.0: [1022:1452] type 00 class 0x060000
> [    0.877890] pci 0000:20:07.0: [1022:1452] type 00 class 0x060000
> [    0.877950] pci 0000:20:07.1: [1022:1454] type 01 class 0x060400
> [    0.877993] pci 0000:20:07.1: enabling Extended Tags
> [    0.878826] pci 0000:20:07.1: PME# supported from D0 D3hot D3cold
> [    0.878921] pci 0000:20:08.0: [1022:1452] type 00 class 0x060000
> [    0.878986] pci 0000:20:08.1: [1022:1454] type 01 class 0x060400
> [    0.879021] pci 0000:20:08.1: enabling Extended Tags
> [    0.880808] pci 0000:20:08.1: PME# supported from D0 D3hot D3cold
> [    0.881015] pci 0000:21:00.0: [1022:145a] type 00 class 0x130000
> [    0.881057] pci 0000:21:00.0: enabling Extended Tags
> [    0.881821] pci 0000:21:00.2: [1022:1456] type 00 class 0x108000
> [    0.881843] pci 0000:21:00.2: reg 0x18: [mem 0xe9700000-0xe97fffff]
> [    0.881857] pci 0000:21:00.2: reg 0x24: [mem 0xe9800000-0xe9801fff]
> [    0.881865] pci 0000:21:00.2: enabling Extended Tags
> [    0.882846] pci 0000:20:07.1: PCI bridge to [bus 21]
> [    0.883745] pci 0000:20:07.1:   bridge window [mem 0xe9700000-0xe98fffff]
> [    0.883933] pci 0000:22:00.0: [1022:1455] type 00 class 0x130000
> [    0.883978] pci 0000:22:00.0: enabling Extended Tags
> [    0.884829] pci 0000:22:00.1: [1022:1468] type 00 class 0x108000
> [    0.884853] pci 0000:22:00.1: reg 0x18: [mem 0xe9500000-0xe95fffff]
> [    0.884868] pci 0000:22:00.1: reg 0x24: [mem 0xe9600000-0xe9601fff]
> [    0.884877] pci 0000:22:00.1: enabling Extended Tags
> [    0.885854] pci 0000:20:08.1: PCI bridge to [bus 22]
> [    0.886745] pci 0000:20:08.1:   bridge window [mem 0xe9500000-0xe96fffff]
> [    0.886757] pci_bus 0000:20: on NUMA node 2
> [    0.887931] ACPI: PCI Root Bridge [S0D3] (domain 0000 [bus 30-3f])
> [    0.888744] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.890806] acpi PNP0A08:03: _OSC: platform does not support [AER LTR]
> [    0.891899] acpi PNP0A08:03: _OSC: OS now controls [PME PCIeCapability]
> [    0.892885] PCI host bridge to bus 0000:30
> [    0.893742] pci_bus 0000:30: root bus resource [io  0x6000-0x7fff window]
> [    0.894741] pci_bus 0000:30: root bus resource [mem 0xe5100000-0xe74fffff window]
> [    0.895742] pci_bus 0000:30: root bus resource [mem 0x18018000000-0x1a011ffffff window]
> [    0.896741] pci_bus 0000:30: root bus resource [bus 30-3f]
> [    0.897747] pci 0000:30:00.0: [1022:1450] type 00 class 0x060000
> [    0.897829] pci 0000:30:01.0: [1022:1452] type 00 class 0x060000
> [    0.897908] pci 0000:30:02.0: [1022:1452] type 00 class 0x060000
> [    0.897985] pci 0000:30:03.0: [1022:1452] type 00 class 0x060000
> [    0.898061] pci 0000:30:04.0: [1022:1452] type 00 class 0x060000
> [    0.898143] pci 0000:30:07.0: [1022:1452] type 00 class 0x060000
> [    0.898206] pci 0000:30:07.1: [1022:1454] type 01 class 0x060400
> [    0.898744] pci 0000:30:07.1: enabling Extended Tags
> [    0.899825] pci 0000:30:07.1: PME# supported from D0 D3hot D3cold
> [    0.899917] pci 0000:30:08.0: [1022:1452] type 00 class 0x060000
> [    0.899980] pci 0000:30:08.1: [1022:1454] type 01 class 0x060400
> [    0.900015] pci 0000:30:08.1: enabling Extended Tags
> [    0.901795] pci 0000:30:08.1: PME# supported from D0 D3hot D3cold
> [    0.902002] pci 0000:31:00.0: [1022:145a] type 00 class 0x130000
> [    0.902043] pci 0000:31:00.0: enabling Extended Tags
> [    0.902822] pci 0000:31:00.2: [1022:1456] type 00 class 0x108000
> [    0.902843] pci 0000:31:00.2: reg 0x18: [mem 0xe7300000-0xe73fffff]
> [    0.902857] pci 0000:31:00.2: reg 0x24: [mem 0xe7400000-0xe7401fff]
> [    0.902866] pci 0000:31:00.2: enabling Extended Tags
> [    0.904819] pci 0000:30:07.1: PCI bridge to [bus 31]
> [    0.905745] pci 0000:30:07.1:   bridge window [mem 0xe7300000-0xe74fffff]
> [    0.905914] pci 0000:32:00.0: [1022:1455] type 00 class 0x130000
> [    0.905959] pci 0000:32:00.0: enabling Extended Tags
> [    0.906829] pci 0000:32:00.1: [1022:1468] type 00 class 0x108000
> [    0.906852] pci 0000:32:00.1: reg 0x18: [mem 0xe7100000-0xe71fffff]
> [    0.906867] pci 0000:32:00.1: reg 0x24: [mem 0xe7200000-0xe7201fff]
> [    0.906876] pci 0000:32:00.1: enabling Extended Tags
> [    0.907855] pci 0000:30:08.1: PCI bridge to [bus 32]
> [    0.908744] pci 0000:30:08.1:   bridge window [mem 0xe7100000-0xe72fffff]
> [    0.908757] pci_bus 0000:30: on NUMA node 3
> [    0.910031] ACPI: PCI Root Bridge [S1D0] (domain 0000 [bus 40-4f])
> [    0.910743] acpi PNP0A08:04: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.911907] acpi PNP0A08:04: _OSC: platform does not support [AER LTR]
> [    0.913742] acpi PNP0A08:04: _OSC: OS now controls [PME PCIeCapability]
> [    0.914883] PCI host bridge to bus 0000:40
> [    0.915742] pci_bus 0000:40: root bus resource [io  0x8000-0x9fff window]
> [    0.916742] pci_bus 0000:40: root bus resource [mem 0xe2d00000-0xe50fffff window]
> [    0.917741] pci_bus 0000:40: root bus resource [mem 0x1601e000000-0x18017ffffff window]
> [    0.918741] pci_bus 0000:40: root bus resource [bus 40-4f]
> [    0.919746] pci 0000:40:00.0: [1022:1450] type 00 class 0x060000
> [    0.919836] pci 0000:40:01.0: [1022:1452] type 00 class 0x060000
> [    0.919921] pci 0000:40:02.0: [1022:1452] type 00 class 0x060000
> [    0.920007] pci 0000:40:03.0: [1022:1452] type 00 class 0x060000
> [    0.920093] pci 0000:40:04.0: [1022:1452] type 00 class 0x060000
> [    0.920768] pci 0000:40:07.0: [1022:1452] type 00 class 0x060000
> [    0.920840] pci 0000:40:07.1: [1022:1454] type 01 class 0x060400
> [    0.921443] pci 0000:40:07.1: enabling Extended Tags
> [    0.921836] pci 0000:40:07.1: PME# supported from D0 D3hot D3cold
> [    0.922741] pci 0000:40:08.0: [1022:1452] type 00 class 0x060000
> [    0.922815] pci 0000:40:08.1: [1022:1454] type 01 class 0x060400
> [    0.923448] pci 0000:40:08.1: enabling Extended Tags
> [    0.923836] pci 0000:40:08.1: PME# supported from D0 D3hot D3cold
> [    0.925490] pci 0000:41:00.0: [1022:145a] type 00 class 0x130000
> [    0.925542] pci 0000:41:00.0: enabling Extended Tags
> [    0.926741] pci 0000:41:00.2: [1022:1456] type 00 class 0x108000
> [    0.926768] pci 0000:41:00.2: reg 0x18: [mem 0xe4f00000-0xe4ffffff]
> [    0.926785] pci 0000:41:00.2: reg 0x24: [mem 0xe5000000-0xe5001fff]
> [    0.926795] pci 0000:41:00.2: enabling Extended Tags
> [    0.927862] pci 0000:40:07.1: PCI bridge to [bus 41]
> [    0.928746] pci 0000:40:07.1:   bridge window [mem 0xe4f00000-0xe50fffff]
> [    0.929113] pci 0000:42:00.0: [1022:1455] type 00 class 0x130000
> [    0.929167] pci 0000:42:00.0: enabling Extended Tags
> [    0.930757] pci 0000:42:00.1: [1022:1468] type 00 class 0x108000
> [    0.930785] pci 0000:42:00.1: reg 0x18: [mem 0xe4d00000-0xe4dfffff]
> [    0.930803] pci 0000:42:00.1: reg 0x24: [mem 0xe4e00000-0xe4e01fff]
> [    0.930814] pci 0000:42:00.1: enabling Extended Tags
> [    0.931847] pci 0000:42:00.2: [1022:7901] type 00 class 0x010601
> [    0.931892] pci 0000:42:00.2: reg 0x24: [mem 0xe4e02000-0xe4e02fff]
> [    0.931904] pci 0000:42:00.2: enabling Extended Tags
> [    0.932784] pci 0000:42:00.2: PME# supported from D3hot D3cold
> [    0.932878] pci 0000:40:08.1: PCI bridge to [bus 42]
> [    0.933745] pci 0000:40:08.1:   bridge window [mem 0xe4d00000-0xe4efffff]
> [    0.933761] pci_bus 0000:40: on NUMA node 4
> [    0.934742] ACPI: PCI Root Bridge [S1D1] (domain 0000 [bus 50-5f])
> [    0.935743] acpi PNP0A08:05: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.936908] acpi PNP0A08:05: _OSC: platform does not support [AER LTR]
> [    0.937899] acpi PNP0A08:05: _OSC: OS now controls [PME PCIeCapability]
> [    0.938885] PCI host bridge to bus 0000:50
> [    0.939742] pci_bus 0000:50: root bus resource [io  0xa000-0xbfff window]
> [    0.940741] pci_bus 0000:50: root bus resource [mem 0xe0900000-0xe2cfffff window]
> [    0.941741] pci_bus 0000:50: root bus resource [mem 0x14024000000-0x1601dffffff window]
> [    0.942741] pci_bus 0000:50: root bus resource [bus 50-5f]
> [    0.943747] pci 0000:50:00.0: [1022:1450] type 00 class 0x060000
> [    0.943836] pci 0000:50:01.0: [1022:1452] type 00 class 0x060000
> [    0.943923] pci 0000:50:02.0: [1022:1452] type 00 class 0x060000
> [    0.944006] pci 0000:50:03.0: [1022:1452] type 00 class 0x060000
> [    0.944090] pci 0000:50:04.0: [1022:1452] type 00 class 0x060000
> [    0.944182] pci 0000:50:07.0: [1022:1452] type 00 class 0x060000
> [    0.944253] pci 0000:50:07.1: [1022:1454] type 01 class 0x060400
> [    0.944300] pci 0000:50:07.1: enabling Extended Tags
> [    0.945815] pci 0000:50:07.1: PME# supported from D0 D3hot D3cold
> [    0.945913] pci 0000:50:08.0: [1022:1452] type 00 class 0x060000
> [    0.945986] pci 0000:50:08.1: [1022:1454] type 01 class 0x060400
> [    0.946027] pci 0000:50:08.1: enabling Extended Tags
> [    0.946837] pci 0000:50:08.1: PME# supported from D0 D3hot D3cold
> [    0.947944] pci 0000:51:00.0: [1022:145a] type 00 class 0x130000
> [    0.947996] pci 0000:51:00.0: enabling Extended Tags
> [    0.948837] pci 0000:51:00.2: [1022:1456] type 00 class 0x108000
> [    0.948865] pci 0000:51:00.2: reg 0x18: [mem 0xe2b00000-0xe2bfffff]
> [    0.948881] pci 0000:51:00.2: reg 0x24: [mem 0xe2c00000-0xe2c01fff]
> [    0.948892] pci 0000:51:00.2: enabling Extended Tags
> [    0.949863] pci 0000:50:07.1: PCI bridge to [bus 51]
> [    0.950746] pci 0000:50:07.1:   bridge window [mem 0xe2b00000-0xe2cfffff]
> [    0.950956] pci 0000:52:00.0: [1022:1455] type 00 class 0x130000
> [    0.951011] pci 0000:52:00.0: enabling Extended Tags
> [    0.951843] pci 0000:52:00.1: [1022:1468] type 00 class 0x108000
> [    0.951871] pci 0000:52:00.1: reg 0x18: [mem 0xe2900000-0xe29fffff]
> [    0.951889] pci 0000:52:00.1: reg 0x24: [mem 0xe2a00000-0xe2a01fff]
> [    0.951900] pci 0000:52:00.1: enabling Extended Tags
> [    0.953813] pci 0000:50:08.1: PCI bridge to [bus 52]
> [    0.954745] pci 0000:50:08.1:   bridge window [mem 0xe2900000-0xe2afffff]
> [    0.954761] pci_bus 0000:50: on NUMA node 5
> [    0.955055] ACPI: PCI Root Bridge [S1D2] (domain 0000 [bus 60-6f])
> [    0.955743] acpi PNP0A08:06: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.956908] acpi PNP0A08:06: _OSC: platform does not support [AER LTR]
> [    0.957900] acpi PNP0A08:06: _OSC: OS now controls [PME PCIeCapability]
> [    0.959823] PCI host bridge to bus 0000:60
> [    0.960742] pci_bus 0000:60: root bus resource [io  0xc000-0xdfff window]
> [    0.961741] pci_bus 0000:60: root bus resource [mem 0xde200000-0xe08fffff window]
> [    0.962741] pci_bus 0000:60: root bus resource [mem 0x1202a000000-0x14023ffffff window]
> [    0.963742] pci_bus 0000:60: root bus resource [bus 60-6f]
> [    0.964747] pci 0000:60:00.0: [1022:1450] type 00 class 0x060000
> [    0.964835] pci 0000:60:01.0: [1022:1452] type 00 class 0x060000
> [    0.964915] pci 0000:60:02.0: [1022:1452] type 00 class 0x060000
> [    0.965757] pci 0000:60:03.0: [1022:1452] type 00 class 0x060000
> [    0.965826] pci 0000:60:03.1: [1022:1453] type 01 class 0x060400
> [    0.966167] pci 0000:60:03.1: PME# supported from D0 D3hot D3cold
> [    0.966267] pci 0000:60:04.0: [1022:1452] type 00 class 0x060000
> [    0.966357] pci 0000:60:07.0: [1022:1452] type 00 class 0x060000
> [    0.966425] pci 0000:60:07.1: [1022:1454] type 01 class 0x060400
> [    0.966462] pci 0000:60:07.1: enabling Extended Tags
> [    0.967811] pci 0000:60:07.1: PME# supported from D0 D3hot D3cold
> [    0.967909] pci 0000:60:08.0: [1022:1452] type 00 class 0x060000
> [    0.967980] pci 0000:60:08.1: [1022:1454] type 01 class 0x060400
> [    0.968018] pci 0000:60:08.1: enabling Extended Tags
> [    0.968833] pci 0000:60:08.1: PME# supported from D0 D3hot D3cold
> [    0.969926] pci 0000:61:00.0: [8086:10fb] type 00 class 0x020000
> [    0.969952] pci 0000:61:00.0: reg 0x10: [mem 0xe0380000-0xe03fffff 64bit]
> [    0.969961] pci 0000:61:00.0: reg 0x18: [io  0xd020-0xd03f]
> [    0.969980] pci 0000:61:00.0: reg 0x20: [mem 0xe0404000-0xe0407fff 64bit]
> [    0.969988] pci 0000:61:00.0: reg 0x30: [mem 0xe0300000-0xe037ffff pref]
> [    0.970048] pci 0000:61:00.0: PME# supported from D0 D3hot
> [    0.970081] pci 0000:61:00.0: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
> [    0.970083] pci 0000:61:00.0: VF(n) BAR0 space: [mem 0x00000000-0x000fffff 64bit] (contains BAR0 for 64 VFs)
> [    0.970758] pci 0000:61:00.0: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
> [    0.970760] pci 0000:61:00.0: VF(n) BAR3 space: [mem 0x00000000-0x000fffff 64bit] (contains BAR3 for 64 VFs)
> [    0.972754] pci 0000:61:00.1: [8086:10fb] type 00 class 0x020000
> [    0.972780] pci 0000:61:00.1: reg 0x10: [mem 0xe0280000-0xe02fffff 64bit]
> [    0.972789] pci 0000:61:00.1: reg 0x18: [io  0xd000-0xd01f]
> [    0.972808] pci 0000:61:00.1: reg 0x20: [mem 0xe0400000-0xe0403fff 64bit]
> [    0.972816] pci 0000:61:00.1: reg 0x30: [mem 0xe0200000-0xe027ffff pref]
> [    0.972876] pci 0000:61:00.1: PME# supported from D0 D3hot
> [    0.972905] pci 0000:61:00.1: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
> [    0.972907] pci 0000:61:00.1: VF(n) BAR0 space: [mem 0x00000000-0x000fffff 64bit] (contains BAR0 for 64 VFs)
> [    0.973758] pci 0000:61:00.1: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
> [    0.973760] pci 0000:61:00.1: VF(n) BAR3 space: [mem 0x00000000-0x000fffff 64bit] (contains BAR3 for 64 VFs)
> [    0.974984] pci 0000:60:03.1: PCI bridge to [bus 61]
> [    0.975744] pci 0000:60:03.1:   bridge window [io  0xd000-0xdfff]
> [    0.975746] pci 0000:60:03.1:   bridge window [mem 0xe0200000-0xe04fffff]
> [    0.975819] pci 0000:62:00.0: [1022:145a] type 00 class 0x130000
> [    0.975866] pci 0000:62:00.0: enabling Extended Tags
> [    0.976831] pci 0000:62:00.2: [1022:1456] type 00 class 0x108000
> [    0.976855] pci 0000:62:00.2: reg 0x18: [mem 0xe0700000-0xe07fffff]
> [    0.976871] pci 0000:62:00.2: reg 0x24: [mem 0xe0800000-0xe0801fff]
> [    0.976881] pci 0000:62:00.2: enabling Extended Tags
> [    0.977854] pci 0000:60:07.1: PCI bridge to [bus 62]
> [    0.978745] pci 0000:60:07.1:   bridge window [mem 0xe0700000-0xe08fffff]
> [    0.978844] pci 0000:63:00.0: [1022:1455] type 00 class 0x130000
> [    0.978894] pci 0000:63:00.0: enabling Extended Tags
> [    0.979836] pci 0000:63:00.1: [1022:1468] type 00 class 0x108000
> [    0.979862] pci 0000:63:00.1: reg 0x18: [mem 0xe0500000-0xe05fffff]
> [    0.979878] pci 0000:63:00.1: reg 0x24: [mem 0xe0600000-0xe0601fff]
> [    0.979888] pci 0000:63:00.1: enabling Extended Tags
> [    0.980876] pci 0000:60:08.1: PCI bridge to [bus 63]
> [    0.981745] pci 0000:60:08.1:   bridge window [mem 0xe0500000-0xe06fffff]
> [    0.981764] pci_bus 0000:60: on NUMA node 6
> [    0.982056] ACPI: PCI Root Bridge [S1D3] (domain 0000 [bus 70-ff])
> [    0.982743] acpi PNP0A08:07: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.983907] acpi PNP0A08:07: _OSC: platform does not support [AER LTR]
> [    0.985779] acpi PNP0A08:07: _OSC: OS now controls [PME PCIeCapability]
> [    0.986753] acpi PNP0A08:07: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
> [    0.987875] PCI host bridge to bus 0000:70
> [    0.988742] pci_bus 0000:70: root bus resource [io  0xe000-0xffff window]
> [    0.989741] pci_bus 0000:70: root bus resource [mem 0xdbe00000-0xde1fffff window]
> [    0.990742] pci_bus 0000:70: root bus resource [mem 0x10030000000-0x12029ffffff window]
> [    0.991741] pci_bus 0000:70: root bus resource [bus 70-ff]
> [    0.992746] pci 0000:70:00.0: [1022:1450] type 00 class 0x060000
> [    0.992838] pci 0000:70:01.0: [1022:1452] type 00 class 0x060000
> [    0.992922] pci 0000:70:02.0: [1022:1452] type 00 class 0x060000
> [    0.993006] pci 0000:70:03.0: [1022:1452] type 00 class 0x060000
> [    0.993089] pci 0000:70:04.0: [1022:1452] type 00 class 0x060000
> [    0.993180] pci 0000:70:07.0: [1022:1452] type 00 class 0x060000
> [    0.993251] pci 0000:70:07.1: [1022:1454] type 01 class 0x060400
> [    0.993744] pci 0000:70:07.1: enabling Extended Tags
> [    0.994835] pci 0000:70:07.1: PME# supported from D0 D3hot D3cold
> [    0.994933] pci 0000:70:08.0: [1022:1452] type 00 class 0x060000
> [    0.995005] pci 0000:70:08.1: [1022:1454] type 01 class 0x060400
> [    0.995045] pci 0000:70:08.1: enabling Extended Tags
> [    0.996816] pci 0000:70:08.1: PME# supported from D0 D3hot D3cold
> [    0.997037] pci 0000:71:00.0: [1022:145a] type 00 class 0x130000
> [    0.997087] pci 0000:71:00.0: enabling Extended Tags
> [    0.997835] pci 0000:71:00.2: [1022:1456] type 00 class 0x108000
> [    0.997862] pci 0000:71:00.2: reg 0x18: [mem 0xde000000-0xde0fffff]
> [    0.997878] pci 0000:71:00.2: reg 0x24: [mem 0xde100000-0xde101fff]
> [    0.997889] pci 0000:71:00.2: enabling Extended Tags
> [    0.999850] pci 0000:70:07.1: PCI bridge to [bus 71]
> [    1.000745] pci 0000:70:07.1:   bridge window [mem 0xde000000-0xde1fffff]
> [    1.000856] pci 0000:72:00.0: [1022:1455] type 00 class 0x130000
> [    1.000910] pci 0000:72:00.0: enabling Extended Tags
> [    1.001839] pci 0000:72:00.1: [1022:1468] type 00 class 0x108000
> [    1.001867] pci 0000:72:00.1: reg 0x18: [mem 0xdde00000-0xddefffff]
> [    1.001884] pci 0000:72:00.1: reg 0x24: [mem 0xddf00000-0xddf01fff]
> [    1.001895] pci 0000:72:00.1: enabling Extended Tags
> [    1.002869] pci 0000:70:08.1: PCI bridge to [bus 72]
> [    1.003745] pci 0000:70:08.1:   bridge window [mem 0xdde00000-0xddffffff]
> [    1.003761] pci_bus 0000:70: on NUMA node 7
> [    1.005003] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 *11 14 15)
> [    1.005802] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *5 7 10 11 14 15)
> [    1.006794] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 *10 11 14 15)
> [    1.007808] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 *5 7 10 11 14 15)
> [    1.008801] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 *11 14 15)
> [    1.009789] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 *10 11 14 15)
> [    1.010790] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 *11 14 15)
> [    1.011789] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 *10 11 14 15)
> [    1.013292] pci 0000:04:00.0: vgaarb: setting as boot VGA device
> [    1.013739] pci 0000:04:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    1.013758] pci 0000:04:00.0: vgaarb: bridge control possible
> [    1.014741] vgaarb: loaded
> [    1.015822] SCSI subsystem initialized
> [    1.017152] libata version 3.00 loaded.
> [    1.017173] ACPI: bus type USB registered
> [    1.017769] usbcore: registered new interface driver usbfs
> [    1.018748] usbcore: registered new interface driver hub
> [    1.020255] usbcore: registered new device driver usb
> [    1.020758] pps_core: LinuxPPS API ver. 1 registered
> [    1.021741] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.022743] PTP clock support registered
> [    1.024395] EDAC MC: Ver: 3.0.0
> [    1.025387] Advanced Linux Sound Architecture Driver Initialized.
> [    1.025752] PCI: Using ACPI for IRQ routing
> [    1.035435] PCI: pci_cache_line_size set to 64 bytes
> [    1.036007] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
> [    1.036009] e820: reserve RAM buffer [mem 0x76db0000-0x77ffffff]
> [    1.036010] e820: reserve RAM buffer [mem 0xc9d5f000-0xcbffffff]
> [    1.036011] e820: reserve RAM buffer [mem 0xc9e85000-0xcbffffff]
> [    1.036012] e820: reserve RAM buffer [mem 0x202f380000-0x202fffffff]
> [    1.036013] e820: reserve RAM buffer [mem 0x402ff80000-0x402fffffff]
> [    1.036013] e820: reserve RAM buffer [mem 0x602ff80000-0x602fffffff]
> [    1.036014] e820: reserve RAM buffer [mem 0x802ff80000-0x802fffffff]
> [    1.036015] e820: reserve RAM buffer [mem 0xa02ff80000-0xa02fffffff]
> [    1.036016] e820: reserve RAM buffer [mem 0xc02ff80000-0xc02fffffff]
> [    1.036017] e820: reserve RAM buffer [mem 0xe02ff80000-0xe02fffffff]
> [    1.036017] e820: reserve RAM buffer [mem 0x1002ff80000-0x1002fffffff]
> [    1.036330] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    1.036741] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
> [    1.040816] clocksource: Switched to clocksource tsc-early
> [    1.064016] VFS: Disk quotas dquot_6.6.0
> [    1.068151] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.075361] FS-Cache: Loaded
> [    1.078503] CacheFiles: Loaded
> [    1.081705] pnp: PnP ACPI init
> [    1.085221] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
> [    1.091986] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    1.092234] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.092556] system 00:02: [io  0x0a00-0x0a0f] has been reserved
> [    1.098621] system 00:02: [io  0x0a10-0x0a1f] has been reserved
> [    1.104676] system 00:02: [io  0x0a20-0x0a2f] has been reserved
> [    1.110736] system 00:02: [io  0x0a30-0x0a3f] has been reserved
> [    1.116795] system 00:02: [io  0x0a40-0x0a4f] has been reserved
> [    1.122857] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.123090] pnp 00:03: [dma 0 disabled]
> [    1.123134] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.123351] pnp 00:04: [dma 0 disabled]
> [    1.123394] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.123774] system 00:05: [io  0x04d0-0x04d1] has been reserved
> [    1.129829] system 00:05: [io  0x040b] has been reserved
> [    1.135282] system 00:05: [io  0x04d6] has been reserved
> [    1.140736] system 00:05: [io  0x0c00-0x0c01] has been reserved
> [    1.146803] system 00:05: [io  0x0c14] has been reserved
> [    1.152252] system 00:05: [io  0x0c50-0x0c51] has been reserved
> [    1.158312] system 00:05: [io  0x0c52] has been reserved
> [    1.163785] system 00:05: [io  0x0c6c] has been reserved
> [    1.169235] system 00:05: [io  0x0c6f] has been reserved
> [    1.174685] system 00:05: [io  0x0cd0-0x0cd1] has been reserved
> [    1.180744] system 00:05: [io  0x0cd2-0x0cd3] has been reserved
> [    1.186803] system 00:05: [io  0x0cd4-0x0cd5] has been reserved
> [    1.192859] system 00:05: [io  0x0cd6-0x0cd7] has been reserved
> [    1.198920] system 00:05: [io  0x0cd8-0x0cdf] has been reserved
> [    1.204977] system 00:05: [io  0x0800-0x089f] has been reserved
> [    1.211035] system 00:05: [io  0x0b00-0x0b0f] has been reserved
> [    1.217096] system 00:05: [io  0x0b20-0x0b3f] has been reserved
> [    1.223153] system 00:05: [io  0x0900-0x090f] has been reserved
> [    1.229213] system 00:05: [io  0x0910-0x091f] has been reserved
> [    1.235272] system 00:05: [io  0xfe00-0xfefe] has been reserved
> [    1.241331] system 00:05: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    1.248428] system 00:05: [mem 0xfec01000-0xfec01fff] has been reserved
> [    1.255182] system 00:05: [mem 0xfedc0000-0xfedc0fff] has been reserved
> [    1.261934] system 00:05: [mem 0xfee00000-0xfee00fff] has been reserved
> [    1.268687] system 00:05: [mem 0xfed80000-0xfed8ffff] could not be reserved
> [    1.275793] system 00:05: [mem 0xfed61000-0xfed70fff] has been reserved
> [    1.282542] system 00:05: [mem 0xfec10000-0xfec10fff] has been reserved
> [    1.289295] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
> [    1.296052] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.297798] pnp: PnP ACPI: found 6 devices
> [    1.307892] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    1.317013] pci 0000:00:01.3: PCI bridge to [bus 01]
> [    1.322115] pci 0000:00:01.3:   bridge window [mem 0xef800000-0xef8fffff]
> [    1.329048] pci 0000:00:01.4: PCI bridge to [bus 02]
> [    1.334151] pci 0000:00:01.4:   bridge window [mem 0xef700000-0xef7fffff]
> [    1.341080] pci 0000:03:00.0: PCI bridge to [bus 04]
> [    1.346182] pci 0000:03:00.0:   bridge window [io  0x1000-0x1fff]
> [    1.352417] pci 0000:03:00.0:   bridge window [mem 0xee000000-0xef0fffff]
> [    1.359356] pci 0000:00:01.6: PCI bridge to [bus 03-04]
> [    1.364722] pci 0000:00:01.6:   bridge window [io  0x1000-0x1fff]
> [    1.370953] pci 0000:00:01.6:   bridge window [mem 0xee000000-0xef0fffff]
> [    1.377882] pci 0000:00:07.1: PCI bridge to [bus 05]
> [    1.382984] pci 0000:00:07.1:   bridge window [mem 0xef200000-0xef4fffff]
> [    1.389912] pci 0000:00:08.1: PCI bridge to [bus 06]
> [    1.395014] pci 0000:00:08.1:   bridge window [mem 0xef500000-0xef6fffff]
> [    1.401949] pci_bus 0000:00: resource 4 [io  0x0000-0x02ff window]
> [    1.401950] pci_bus 0000:00: resource 5 [io  0x0300-0x03af window]
> [    1.401952] pci_bus 0000:00: resource 6 [io  0x03e0-0x0cf7 window]
> [    1.401953] pci_bus 0000:00: resource 7 [io  0x03b0-0x03df window]
> [    1.401954] pci_bus 0000:00: resource 8 [io  0x0d00-0x1fff window]
> [    1.401956] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff window]
> [    1.401957] pci_bus 0000:00: resource 10 [mem 0x000c0000-0x000dffff window]
> [    1.401959] pci_bus 0000:00: resource 11 [mem 0xec000000-0xefffffff window]
> [    1.401960] pci_bus 0000:00: resource 12 [mem 0x1e006000000-0x1ffffffffff window]
> [    1.401961] pci_bus 0000:01: resource 1 [mem 0xef800000-0xef8fffff]
> [    1.401963] pci_bus 0000:02: resource 1 [mem 0xef700000-0xef7fffff]
> [    1.401965] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
> [    1.401966] pci_bus 0000:03: resource 1 [mem 0xee000000-0xef0fffff]
> [    1.401968] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
> [    1.401969] pci_bus 0000:04: resource 1 [mem 0xee000000-0xef0fffff]
> [    1.401970] pci_bus 0000:05: resource 1 [mem 0xef200000-0xef4fffff]
> [    1.401972] pci_bus 0000:06: resource 1 [mem 0xef500000-0xef6fffff]
> [    1.402007] pci 0000:10:01.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 11] add_size 100000 add_align 100000
> [    1.402022] pci 0000:10:01.1: BAR 15: assigned [mem 0x1c00c000000-0x1c00c0fffff 64bit pref]
> [    1.410584] pci 0000:11:00.0: BAR 7: assigned [mem 0x1c00c000000-0x1c00c01ffff 64bit pref]
> [    1.419171] pci 0000:11:00.0: BAR 10: assigned [mem 0x1c00c020000-0x1c00c03ffff 64bit pref]
> [    1.427851] pci 0000:11:00.1: BAR 7: assigned [mem 0x1c00c040000-0x1c00c05ffff 64bit pref]
> [    1.436440] pci 0000:11:00.1: BAR 10: assigned [mem 0x1c00c060000-0x1c00c07ffff 64bit pref]
> [    1.445115] pci 0000:11:00.2: BAR 7: assigned [mem 0x1c00c080000-0x1c00c09ffff 64bit pref]
> [    1.453704] pci 0000:11:00.2: BAR 10: assigned [mem 0x1c00c0a0000-0x1c00c0bffff 64bit pref]
> [    1.462380] pci 0000:11:00.3: BAR 7: assigned [mem 0x1c00c0c0000-0x1c00c0dffff 64bit pref]
> [    1.470959] pci 0000:11:00.3: BAR 10: assigned [mem 0x1c00c0e0000-0x1c00c0fffff 64bit pref]
> [    1.479627] pci 0000:10:01.1: PCI bridge to [bus 11]
> [    1.484731] pci 0000:10:01.1:   bridge window [io  0x3000-0x3fff]
> [    1.490965] pci 0000:10:01.1:   bridge window [mem 0xeb900000-0xebbfffff]
> [    1.497890] pci 0000:10:01.1:   bridge window [mem 0x1c00c000000-0x1c00c0fffff 64bit pref]
> [    1.506362] pci 0000:10:07.1: PCI bridge to [bus 12]
> [    1.511463] pci 0000:10:07.1:   bridge window [mem 0xebe00000-0xebffffff]
> [    1.518392] pci 0000:10:08.1: PCI bridge to [bus 13]
> [    1.523494] pci 0000:10:08.1:   bridge window [mem 0xebc00000-0xebdfffff]
> [    1.530421] pci_bus 0000:10: resource 4 [io  0x2000-0x3fff window]
> [    1.530422] pci_bus 0000:10: resource 5 [mem 0xe9900000-0xebffffff window]
> [    1.530423] pci_bus 0000:10: resource 6 [mem 0x1c00c000000-0x1e005ffffff window]
> [    1.530425] pci_bus 0000:11: resource 0 [io  0x3000-0x3fff]
> [    1.530426] pci_bus 0000:11: resource 1 [mem 0xeb900000-0xebbfffff]
> [    1.530427] pci_bus 0000:11: resource 2 [mem 0x1c00c000000-0x1c00c0fffff 64bit pref]
> [    1.530428] pci_bus 0000:12: resource 1 [mem 0xebe00000-0xebffffff]
> [    1.530430] pci_bus 0000:13: resource 1 [mem 0xebc00000-0xebdfffff]
> [    1.530462] pci 0000:20:07.1: PCI bridge to [bus 21]
> [    1.535569] pci 0000:20:07.1:   bridge window [mem 0xe9700000-0xe98fffff]
> [    1.542504] pci 0000:20:08.1: PCI bridge to [bus 22]
> [    1.547608] pci 0000:20:08.1:   bridge window [mem 0xe9500000-0xe96fffff]
> [    1.554542] pci_bus 0000:20: resource 4 [io  0x4000-0x5fff window]
> [    1.554544] pci_bus 0000:20: resource 5 [mem 0xe7500000-0xe98fffff window]
> [    1.554545] pci_bus 0000:20: resource 6 [mem 0x1a012000000-0x1c00bffffff window]
> [    1.554547] pci_bus 0000:21: resource 1 [mem 0xe9700000-0xe98fffff]
> [    1.554549] pci_bus 0000:22: resource 1 [mem 0xe9500000-0xe96fffff]
> [    1.554574] pci 0000:30:07.1: PCI bridge to [bus 31]
> [    1.559675] pci 0000:30:07.1:   bridge window [mem 0xe7300000-0xe74fffff]
> [    1.566609] pci 0000:30:08.1: PCI bridge to [bus 32]
> [    1.571713] pci 0000:30:08.1:   bridge window [mem 0xe7100000-0xe72fffff]
> [    1.578649] pci_bus 0000:30: resource 4 [io  0x6000-0x7fff window]
> [    1.578651] pci_bus 0000:30: resource 5 [mem 0xe5100000-0xe74fffff window]
> [    1.578652] pci_bus 0000:30: resource 6 [mem 0x18018000000-0x1a011ffffff window]
> [    1.578653] pci_bus 0000:31: resource 1 [mem 0xe7300000-0xe74fffff]
> [    1.578655] pci_bus 0000:32: resource 1 [mem 0xe7100000-0xe72fffff]
> [    1.578681] pci 0000:40:07.1: PCI bridge to [bus 41]
> [    1.583787] pci 0000:40:07.1:   bridge window [mem 0xe4f00000-0xe50fffff]
> [    1.590722] pci 0000:40:08.1: PCI bridge to [bus 42]
> [    1.595827] pci 0000:40:08.1:   bridge window [mem 0xe4d00000-0xe4efffff]
> [    1.602785] pci_bus 0000:40: resource 4 [io  0x8000-0x9fff window]
> [    1.602786] pci_bus 0000:40: resource 5 [mem 0xe2d00000-0xe50fffff window]
> [    1.602787] pci_bus 0000:40: resource 6 [mem 0x1601e000000-0x18017ffffff window]
> [    1.602789] pci_bus 0000:41: resource 1 [mem 0xe4f00000-0xe50fffff]
> [    1.602790] pci_bus 0000:42: resource 1 [mem 0xe4d00000-0xe4efffff]
> [    1.602814] pci 0000:50:07.1: PCI bridge to [bus 51]
> [    1.607919] pci 0000:50:07.1:   bridge window [mem 0xe2b00000-0xe2cfffff]
> [    1.614853] pci 0000:50:08.1: PCI bridge to [bus 52]
> [    1.619955] pci 0000:50:08.1:   bridge window [mem 0xe2900000-0xe2afffff]
> [    1.626882] pci_bus 0000:50: resource 4 [io  0xa000-0xbfff window]
> [    1.626884] pci_bus 0000:50: resource 5 [mem 0xe0900000-0xe2cfffff window]
> [    1.626885] pci_bus 0000:50: resource 6 [mem 0x14024000000-0x1601dffffff window]
> [    1.626887] pci_bus 0000:51: resource 1 [mem 0xe2b00000-0xe2cfffff]
> [    1.626889] pci_bus 0000:52: resource 1 [mem 0xe2900000-0xe2afffff]
> [    1.626922] pci 0000:61:00.0: BAR 7: no space for [mem size 0x00100000 64bit]
> [    1.634194] pci 0000:61:00.0: BAR 7: failed to assign [mem size 0x00100000 64bit]
> [    1.641882] pci 0000:61:00.0: BAR 10: no space for [mem size 0x00100000 64bit]
> [    1.649311] pci 0000:61:00.0: BAR 10: failed to assign [mem size 0x00100000 64bit]
> [    1.657086] pci 0000:61:00.1: BAR 7: no space for [mem size 0x00100000 64bit]
> [    1.664357] pci 0000:61:00.1: BAR 7: failed to assign [mem size 0x00100000 64bit]
> [    1.672045] pci 0000:61:00.1: BAR 10: no space for [mem size 0x00100000 64bit]
> [    1.679473] pci 0000:61:00.1: BAR 10: failed to assign [mem size 0x00100000 64bit]
> [    1.687251] pci 0000:60:03.1: PCI bridge to [bus 61]
> [    1.692355] pci 0000:60:03.1:   bridge window [io  0xd000-0xdfff]
> [    1.698587] pci 0000:60:03.1:   bridge window [mem 0xe0200000-0xe04fffff]
> [    1.705515] pci 0000:60:07.1: PCI bridge to [bus 62]
> [    1.710618] pci 0000:60:07.1:   bridge window [mem 0xe0700000-0xe08fffff]
> [    1.717553] pci 0000:60:08.1: PCI bridge to [bus 63]
> [    1.722658] pci 0000:60:08.1:   bridge window [mem 0xe0500000-0xe06fffff]
> [    1.729595] pci_bus 0000:60: Some PCI device resources are unassigned, try booting with pci=realloc
> [    1.738846] pci_bus 0000:60: resource 4 [io  0xc000-0xdfff window]
> [    1.738848] pci_bus 0000:60: resource 5 [mem 0xde200000-0xe08fffff window]
> [    1.738849] pci_bus 0000:60: resource 6 [mem 0x1202a000000-0x14023ffffff window]
> [    1.738851] pci_bus 0000:61: resource 0 [io  0xd000-0xdfff]
> [    1.738852] pci_bus 0000:61: resource 1 [mem 0xe0200000-0xe04fffff]
> [    1.738854] pci_bus 0000:62: resource 1 [mem 0xe0700000-0xe08fffff]
> [    1.738855] pci_bus 0000:63: resource 1 [mem 0xe0500000-0xe06fffff]
> [    1.738882] pci 0000:70:07.1: PCI bridge to [bus 71]
> [    1.743988] pci 0000:70:07.1:   bridge window [mem 0xde000000-0xde1fffff]
> [    1.750917] pci 0000:70:08.1: PCI bridge to [bus 72]
> [    1.756022] pci 0000:70:08.1:   bridge window [mem 0xdde00000-0xddffffff]
> [    1.762955] pci_bus 0000:70: resource 4 [io  0xe000-0xffff window]
> [    1.762956] pci_bus 0000:70: resource 5 [mem 0xdbe00000-0xde1fffff window]
> [    1.762957] pci_bus 0000:70: resource 6 [mem 0x10030000000-0x12029ffffff window]
> [    1.762959] pci_bus 0000:71: resource 1 [mem 0xde000000-0xde1fffff]
> [    1.762961] pci_bus 0000:72: resource 1 [mem 0xdde00000-0xddffffff]
> [    1.763504] NET: Registered protocol family 2
> [    1.768567] tcp_listen_portaddr_hash hash table entries: 65536 (order: 8, 1048576 bytes)
> [    1.777269] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
> [    1.785765] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    1.792791] TCP: Hash tables configured (established 524288 bind 65536)
> [    1.799794] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
> [    1.806643] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
> [    1.814694] pci 0000:04:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    1.823738] PCI: CLS 64 bytes, default 64
> [    1.823792] Trying to unpack rootfs image as initramfs...
> [    1.912876] Freeing initrd memory: 5136K
> [    1.916945] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    1.923530] software IO TLB: mapped [mem 0xc5d5f000-0xc9d5f000] (64MB)
> [    1.930364] amd_uncore: AMD NB counters detected
> [    1.935250] amd_uncore: AMD LLC counters detected
> [    1.947260] workingset: timestamp_bits=40 max_order=28 bucket_order=0
> [    1.956169] SGI XFS with ACLs, security attributes, realtime, no debug enabled
> [    1.965923] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
> [    1.973878] io scheduler noop registered
> [    1.977932] io scheduler deadline registered
> [    1.982394] io scheduler cfq registered (default)
> [    1.987231] io scheduler mq-deadline registered
> [    1.991896] io scheduler kyber registered
> [    2.017699] pcieport 0000:00:01.3: Signaling PME with IRQ 25
> [    2.023728] pcieport 0000:00:01.4: Signaling PME with IRQ 26
> [    2.029713] pcieport 0000:00:01.6: Signaling PME with IRQ 27
> [    2.035588] pcieport 0000:00:07.1: Signaling PME with IRQ 28
> [    2.041714] pcieport 0000:00:08.1: Signaling PME with IRQ 30
> [    2.047566] pcieport 0000:10:01.1: Signaling PME with IRQ 31
> [    2.053403] pcieport 0000:10:07.1: Signaling PME with IRQ 33
> [    2.059262] pcieport 0000:10:08.1: Signaling PME with IRQ 35
> [    2.065124] pcieport 0000:20:07.1: Signaling PME with IRQ 37
> [    2.071121] pcieport 0000:20:08.1: Signaling PME with IRQ 39
> [    2.077219] pcieport 0000:30:07.1: Signaling PME with IRQ 41
> [    2.083221] pcieport 0000:30:08.1: Signaling PME with IRQ 43
> [    2.089657] pcieport 0000:40:07.1: Signaling PME with IRQ 45
> [    2.095651] pcieport 0000:40:08.1: Signaling PME with IRQ 47
> [    2.101524] pcieport 0000:50:07.1: Signaling PME with IRQ 49
> [    2.107395] pcieport 0000:50:08.1: Signaling PME with IRQ 51
> [    2.113257] pcieport 0000:60:03.1: Signaling PME with IRQ 52
> [    2.119227] pcieport 0000:60:07.1: Signaling PME with IRQ 54
> [    2.125234] pcieport 0000:60:08.1: Signaling PME with IRQ 56
> [    2.131161] pcieport 0000:70:07.1: Signaling PME with IRQ 58
> [    2.137151] pcieport 0000:70:08.1: Signaling PME with IRQ 60
> [    2.142993] version 39.2
> [    2.145673] ipmi device interface
> [    2.149208] IPMI System Interface driver.
> [    2.153369] ipmi_si dmi-ipmi-si.0: ipmi_platform: probing via SMBIOS
> [    2.159864] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
> [    2.165924] ipmi_si: Adding SMBIOS-specified kcs state machine
> [    2.173281] ipmi_si IPI0001:00: ipmi_platform: probing via ACPI
> [    2.179366] ipmi_si IPI0001:00: [io  0x0ca4] regsize 1 spacing 1 irq 0
> [    2.186038] ipmi_si: Adding ACPI-specified kcs state machine
> [    2.191914] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
> [    2.278823] ipmi_si dmi-ipmi-si.0: The BMC does not support clearing the recv irq bit, compensating, but the BMC needs to be fixed.
> [    2.308738] ipmi_si dmi-ipmi-si.0: Found new BMC (man_id: 0x002a7c, prod_id: 0x0963, dev_id: 0x20)
> [    2.331718] ipmi_si dmi-ipmi-si.0: IPMI kcs interface initialized
> [    2.338925] IPMI Watchdog: driver initialized
> [    2.343425] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> [    2.351805] IPMI poweroff: ATCA Detect mfg 0x2A7C prod 0x963
> [    2.357605] IPMI poweroff: Found a chassis style poweroff function
> [    2.364148] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    2.372720] ACPI: Power Button [PWRB]
> [    2.376580] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    2.384311] ACPI: Power Button [PWRF]
> [    2.388203] Monitor-Mwait will be used to enter C-1 state
> [    2.410432] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    2.438387] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    2.467747] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> [    2.476934] lp: driver loaded but no devices found
> [    2.482500] Linux agpgart interface v0.103
> [    2.520760] brd: module loaded
> [    2.533409] loop: module loaded
> [    2.557314] drbd: initialized. Version: 8.4.10 (api:1/proto:86-101)
> [    2.564348] drbd: built-in
> [    2.567420] drbd: registered as block device major 147
> [    2.573322] Uniform Multi-Platform E-IDE driver
> [    2.579191] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    2.589930] Probing IDE interface ide0...
> [    2.972077] tsc: Refined TSC clocksource calibration: 2199.767 MHz
> [    2.979245] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb556cc37f, max_idle_ns: 440795278180 ns
> [    2.990479] clocksource: Switched to clocksource tsc
> [    3.117107] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    3.122082] Probing IDE interface ide1...
> [    3.648044] ide1 at 0x170-0x177,0x376 on irq 15
> [    3.653038] ide-gd driver 1.18
> [    3.656431] ide-cd driver 5.00
> [    3.660400] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [    3.668437] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [    3.676095] megasas: 07.706.03.00-rc1
> [    3.680268] mpt3sas version 26.100.00.00 loaded
> [    3.685774] ahci 0000:13:00.2: version 3.0
> [    3.686033] ahci 0000:13:00.2: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0xff impl SATA mode
> [    3.695050] ahci 0000:13:00.2: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part ems sxs 
> [    3.706155] scsi host0: ahci
> [    3.709601] scsi host1: ahci
> [    3.713216] scsi host2: ahci
> [    3.716513] scsi host3: ahci
> [    3.720125] scsi host4: ahci
> [    3.723458] scsi host5: ahci
> [    3.727125] scsi host6: ahci
> [    3.730449] scsi host7: ahci
> [    3.733726] ata1: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02100 irq 62
> [    3.742072] ata2: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02180 irq 62
> [    3.750139] ata3: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02200 irq 62
> [    3.758268] ata4: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02280 irq 62
> [    3.766406] ata5: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02300 irq 62
> [    3.774494] ata6: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02380 irq 62
> [    3.782495] ata7: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02400 irq 62
> [    3.790701] ata8: SATA max UDMA/133 abar m4096@0xebd02000 port 0xebd02480 irq 62
> [    3.799395] ahci 0000:42:00.2: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0xff impl SATA mode
> [    3.808416] ahci 0000:42:00.2: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part ems sxs 
> [    3.820050] scsi host8: ahci
> [    3.823518] scsi host9: ahci
> [    3.827139] scsi host10: ahci
> [    3.830597] scsi host11: ahci
> [    3.834476] scsi host12: ahci
> [    3.838138] scsi host13: ahci
> [    3.841580] scsi host14: ahci
> [    3.845204] scsi host15: ahci
> [    3.848564] ata9: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02100 irq 64
> [    3.857039] ata10: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02180 irq 64
> [    3.865174] ata11: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02200 irq 64
> [    3.873351] ata12: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02280 irq 64
> [    3.881669] ata13: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02300 irq 64
> [    3.890250] ata14: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02380 irq 64
> [    3.898536] ata15: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02400 irq 64
> [    3.907056] ata16: SATA max UDMA/133 abar m4096@0xe4e02000 port 0xe4e02480 irq 64
> [    3.915922] tun: Universal TUN/TAP device driver, 1.6
> [    3.921671] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
> [    3.931917] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    3.938643] e100: Copyright(c) 1999-2006 Intel Corporation
> [    3.945081] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> [    3.952724] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    3.959360] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    3.965667] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    3.972453] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
> [    3.980019] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    4.079720] igb 0000:11:00.0: added PHC on eth0
> [    4.085044] igb 0000:11:00.0: Intel(R) Gigabit Ethernet Network Connection
> [    4.092501] igb 0000:11:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:fb:1e:f0
> [    4.100317] igb 0000:11:00.0: eth0: PBA No: 010A00-000
> [    4.105279] ata8: SATA link down (SStatus 0 SControl 300)
> [    4.106052] igb 0000:11:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    4.112028] ata4: SATA link down (SStatus 0 SControl 300)
> [    4.126108] ata7: SATA link down (SStatus 0 SControl 300)
> [    4.216113] igb 0000:11:00.1: added PHC on eth1
> [    4.221145] igb 0000:11:00.1: Intel(R) Gigabit Ethernet Network Connection
> [    4.225305] ata10: SATA link down (SStatus 0 SControl 300)
> [    4.228555] igb 0000:11:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:fb:1e:f1
> [    4.228722] igb 0000:11:00.1: eth1: PBA No: 010A00-000
> [    4.234438] ata15: SATA link down (SStatus 0 SControl 300)
> [    4.242057] igb 0000:11:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    4.261632] ata9: SATA link down (SStatus 0 SControl 300)
> [    4.267731] ata14: SATA link down (SStatus 0 SControl 300)
> [    4.274073] ata12: SATA link down (SStatus 0 SControl 300)
> [    4.280028] ata11: SATA link down (SStatus 0 SControl 300)
> [    4.286076] ata13: SATA link down (SStatus 0 SControl 300)
> [    4.291866] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.292068] ata16: SATA link down (SStatus 0 SControl 300)
> [    4.298630] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.311624] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.318593] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.325407] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.332610] ata2.00: ATA-10: ST2000NM0055-1V4104, TN02, max UDMA/133
> [    4.338116] igb 0000:11:00.2: added PHC on eth2
> [    4.339651] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32), AA
> [    4.345034] igb 0000:11:00.2: Intel(R) Gigabit Ethernet Network Connection
> [    4.352443] ata3.00: ATA-10: ST2000NM0055-1V4104, TN02, max UDMA/133
> [    4.360056] igb 0000:11:00.2: eth2: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:fb:1e:f2
> [    4.360223] igb 0000:11:00.2: eth2: PBA No: 010A00-000
> [    4.367000] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32), AA
> [    4.367007] ata5.00: ATA-10: ST8000NM0045-1RL112, NN02, max UDMA/133
> [    4.374682] igb 0000:11:00.2: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    4.403174] ata5.00: 1953506646 sectors, multi 2: LBA48 NCQ (depth 32), AA
> [    4.410552] ata1.00: ATA-9: SAMSUNG MZ7KM960HMJP-00005, GXM5104Q, max UDMA/133
> [    4.418618] ata1.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth 32), AA
> [    4.427065] ata6.00: ATA-10: ST8000NM0045-1RL112, NN02, max UDMA/133
> [    4.434002] ata6.00: 1953506646 sectors, multi 2: LBA48 NCQ (depth 32), AA
> [    4.441634] ata1.00: configured for UDMA/133
> [    4.448594] ata5.00: configured for UDMA/133
> [    4.453426] ata2.00: configured for UDMA/133
> [    4.458046] ata3.00: configured for UDMA/133
> [    4.465714] ata6.00: configured for UDMA/133
> [    4.471126] igb 0000:11:00.3: added PHC on eth3
> [    4.476156] igb 0000:11:00.3: Intel(R) Gigabit Ethernet Network Connection
> [    4.483676] igb 0000:11:00.3: eth3: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:fb:1e:f3
> [    4.491920] igb 0000:11:00.3: eth3: PBA No: 010A00-000
> [    4.497900] igb 0000:11:00.3: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    4.506702] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.4.0-k
> [    4.515418] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    4.522099] sky2: driver version 1.30
> [    4.526410] Fusion MPT base driver 3.04.20
> [    4.531064] Copyright (c) 1999-2008 LSI Corporation
> [    4.536500] Fusion MPT SPI Host driver 3.04.20
> [    4.541427] Fusion MPT FC Host driver 3.04.20
> [    4.548130] Fusion MPT SAS Host driver 3.04.20
> [    4.553076] Fusion MPT misc device (ioctl) driver 3.04.20
> [    4.559081] mptctl: Registered with Fusion MPT base driver
> [    4.565109] mptctl: /dev/mptctl @ (major,minor=10,220)
> [    4.571063] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    4.578171] ehci-pci: EHCI PCI platform driver
> [    4.583169] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    4.590054] ohci-pci: OHCI PCI platform driver
> [    4.595080] uhci_hcd: USB Universal Host Controller Interface driver
> [    4.602339] xhci_hcd 0000:01:00.0: xHCI Host Controller
> [    4.608098] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
> [    4.677074] xhci_hcd 0000:01:00.0: hcc params 0x0200e081 hci version 0x100 quirks 0x0000000010000410
> [    4.687495] hub 1-0:1.0: USB hub found
> [    4.691543] hub 1-0:1.0: 2 ports detected
> [    4.696238] xhci_hcd 0000:01:00.0: xHCI Host Controller
> [    4.701994] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 2
> [    4.710105] xhci_hcd 0000:01:00.0: Host supports USB 3.0  SuperSpeed
> [    4.717101] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
> [    4.726140] hub 2-0:1.0: USB hub found
> [    4.730261] hub 2-0:1.0: 2 ports detected
> [    4.735056] xhci_hcd 0000:02:00.0: xHCI Host Controller
> [    4.740974] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
> [    4.810151] xhci_hcd 0000:02:00.0: hcc params 0x0200e081 hci version 0x100 quirks 0x0000000010000410
> [    4.820666] hub 3-0:1.0: USB hub found
> [    4.825074] hub 3-0:1.0: 2 ports detected
> [    4.829698] xhci_hcd 0000:02:00.0: xHCI Host Controller
> [    4.835709] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
> [    4.844208] xhci_hcd 0000:02:00.0: Host supports USB 3.0  SuperSpeed
> [    4.851281] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
> [    4.860227] hub 4-0:1.0: USB hub found
> [    4.864315] hub 4-0:1.0: 2 ports detected
> [    4.869111] xhci_hcd 0000:05:00.3: xHCI Host Controller
> [    4.875067] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 5
> [    4.883156] xhci_hcd 0000:05:00.3: hcc params 0x0270f665 hci version 0x100 quirks 0x0000000000000410
> [    4.893370] hub 5-0:1.0: USB hub found
> [    4.897528] hub 5-0:1.0: 2 ports detected
> [    4.902257] xhci_hcd 0000:05:00.3: xHCI Host Controller
> [    4.908091] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 6
> [    4.916269] xhci_hcd 0000:05:00.3: Host supports USB 3.0  SuperSpeed
> [    4.923276] usb usb6: We don't know the algorithms for LPM for this host, disabling LPM.
> [    4.932349] hub 6-0:1.0: USB hub found
> [    4.936454] hub 6-0:1.0: 2 ports detected
> [    4.941187] usbcore: registered new interface driver usb-storage
> [    4.947728] usbcore: registered new interface driver ftdi_sio
> [    4.954419] usbserial: USB Serial support registered for FTDI USB Serial Device
> [    4.962535] usbcore: registered new interface driver omninet
> [    4.969017] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
> [    4.977942] i8042: PNP: No PS/2 controller found.
> [    4.983365] rtc_cmos 00:01: RTC can wake from S4
> [    4.989023] rtc_cmos 00:01: registered as rtc0
> [    4.994111] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    5.003088] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
> [    5.011267] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus port selection
> [    5.019861] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    5.026161] iTCO_vendor_support: vendor-support=0
> [    5.031371] nv_tco: NV TCO WatchDog Timer Driver v0.01
> [    5.037607] EDAC amd64: Node 0: DRAM ECC enabled.
> [    5.043085] EDAC amd64: F17h detected (node 0).
> [    5.048106] EDAC MC: UMC0 chip selects:
> [    5.048107] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.053329] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.058555] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.063667] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.069149] EDAC MC: UMC1 chip selects:
> [    5.069150] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.074330] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.079540] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.084669] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.090219] EDAC amd64: using x8 syndromes.
> [    5.094745] EDAC amd64: MCT channel count: 2
> [    5.100077] EDAC MC0: Giving out device to module amd64_edac controller F17h: DEV 0000:00:18.3 (INTERRUPT)
> [    5.110695] EDAC amd64: Node 1: DRAM ECC enabled.
> [    5.116142] EDAC amd64: F17h detected (node 1).
> [    5.121232] EDAC MC: UMC0 chip selects:
> [    5.121233] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.126485] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.131701] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.137101] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.139752] usb 1-1: new full-speed USB device number 2 using xhci_hcd
> [    5.142245] EDAC MC: UMC1 chip selects:
> [    5.149435] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.154672] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.160091] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.165409] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.170503] EDAC amd64: using x8 syndromes.
> [    5.175153] EDAC amd64: MCT channel count: 2
> [    5.180218] EDAC MC1: Giving out device to module amd64_edac controller F17h: DEV 0000:00:19.3 (INTERRUPT)
> [    5.191026] EDAC amd64: Node 2: DRAM ECC enabled.
> [    5.196191] EDAC amd64: F17h detected (node 2).
> [    5.201285] EDAC MC: UMC0 chip selects:
> [    5.201286] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.206407] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.211588] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.217081] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.222236] EDAC MC: UMC1 chip selects:
> [    5.222237] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.227416] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.232575] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.237919] usb 5-2: new high-speed USB device number 2 using xhci_hcd
> [    5.238060] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.250396] EDAC amd64: using x8 syndromes.
> [    5.255094] EDAC amd64: MCT channel count: 2
> [    5.260076] EDAC MC2: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1a.3 (INTERRUPT)
> [    5.271248] EDAC amd64: Node 3: DRAM ECC enabled.
> [    5.276366] EDAC amd64: F17h detected (node 3).
> [    5.281469] EDAC MC: UMC0 chip selects:
> [    5.281470] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.287051] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.292338] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.297614] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.303235] EDAC MC: UMC1 chip selects:
> [    5.303236] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.308514] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.313969] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.319343] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.324580] EDAC amd64: using x8 syndromes.
> [    5.329156] EDAC amd64: MCT channel count: 2
> [    5.334201] EDAC MC3: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1b.3 (INTERRUPT)
> [    5.345065] EDAC amd64: Node 4: DRAM ECC enabled.
> [    5.350245] EDAC amd64: F17h detected (node 4).
> [    5.355328] EDAC MC: UMC0 chip selects:
> [    5.355329] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.360508] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.365865] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.371411] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.376529] EDAC MC: UMC1 chip selects:
> [    5.376530] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.381682] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.387281] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.392515] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.397604] EDAC amd64: using x8 syndromes.
> [    5.402494] EDAC amd64: MCT channel count: 2
> [    5.407524] EDAC MC4: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1c.3 (INTERRUPT)
> [    5.418499] EDAC amd64: Node 5: DRAM ECC enabled.
> [    5.424048] EDAC amd64: F17h detected (node 5).
> [    5.429186] EDAC MC: UMC0 chip selects:
> [    5.429187] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.434408] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.435499] hub 5-2:1.0: USB hub found
> [    5.439668] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.439669] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.439673] EDAC MC: UMC1 chip selects:
> [    5.444352] hub 5-2:1.0: 4 ports detected
> [    5.449343] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.464690] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.470066] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.475405] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.480613] EDAC amd64: using x8 syndromes.
> [    5.485590] EDAC amd64: MCT channel count: 2
> [    5.490464] EDAC MC5: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1d.3 (INTERRUPT)
> [    5.501096] EDAC amd64: Node 6: DRAM ECC enabled.
> [    5.506237] EDAC amd64: F17h detected (node 6).
> [    5.511302] EDAC MC: UMC0 chip selects:
> [    5.511303] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.516441] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.521690] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.527141] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.532074] floppy0: no floppy controllers found
> [    5.532346] EDAC MC: UMC1 chip selects:
> [    5.537423] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.538079] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MZ7KM960 104Q PQ: 0 ANSI: 5
> [    5.542496] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.551545] ata1.00: Enabling discard_zeroes_data
> [    5.551596] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    5.556484] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.561685] scsi 1:0:0:0: Direct-Access     ATA      ST2000NM0055-1V4 TN02 PQ: 0 ANSI: 5
> [    5.561691] sd 0:0:0:0: [sda] 1875385008 512-byte logical blocks: (960 GB/894 GiB)
> [    5.561697] sd 0:0:0:0: [sda] Write Protect is off
> [    5.561698] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.561705] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.561865] ata1.00: Enabling discard_zeroes_data
> [    5.562244]  sda: sda1 sda2
> [    5.563305] ata1.00: Enabling discard_zeroes_data
> [    5.563334] sd 0:0:0:0: [sda] Attached SCSI removable disk
> [    5.565080] random: fast init done
> [    5.567675] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.573423] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> [    5.573461] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    5.573776] scsi 2:0:0:0: Direct-Access     ATA      ST2000NM0055-1V4 TN02 PQ: 0 ANSI: 5
> [    5.573883] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> [    5.573888] sd 2:0:0:0: [sdc] Write Protect is off
> [    5.573889] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    5.573896] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.574057] sd 2:0:0:0: Attached scsi generic sg2 type 0
> [    5.574445] scsi 4:0:0:0: Direct-Access     ATA      ST8000NM0045-1RL NN02 PQ: 0 ANSI: 5
> [    5.574541] sd 4:0:0:0: [sdd] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> [    5.574545] sd 4:0:0:0: [sdd] Write Protect is off
> [    5.574546] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [    5.574551] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.574564] sd 4:0:0:0: Attached scsi generic sg3 type 0
> [    5.574824] scsi 5:0:0:0: Direct-Access     ATA      ST8000NM0045-1RL NN02 PQ: 0 ANSI: 5
> [    5.575056] sd 5:0:0:0: [sde] 1953506646 4096-byte logical blocks: (8.00 TB/7.28 TiB)
> [    5.575060] sd 5:0:0:0: [sde] Write Protect is off
> [    5.575062] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [    5.575069] sd 5:0:0:0: Attached scsi generic sg4 type 0
> [    5.575072] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.582184] EDAC amd64: using x8 syndromes.
> [    5.582185] EDAC amd64: MCT channel count: 2
> [    5.585893] sd 5:0:0:0: [sde] Attached SCSI removable disk
> [    5.590584] sd 1:0:0:0: [sdb] Write Protect is off
> [    5.593904] sd 2:0:0:0: [sdc] Attached SCSI removable disk
> [    5.594418] sd 4:0:0:0: [sdd] Attached SCSI removable disk
> [    5.598280] EDAC MC6: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1e.3 (INTERRUPT)
> [    5.608065] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    5.613088] EDAC amd64: Node 7: DRAM ECC enabled.
> [    5.616190] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.621411] EDAC amd64: F17h detected (node 7).
> [    5.649994] sd 1:0:0:0: [sdb] Attached SCSI removable disk
> [    5.651310] EDAC MC: UMC0 chip selects:
> [    5.751827] usb 5-2.1: new low-speed USB device number 3 using xhci_hcd
> [    5.752230] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.851700] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.857257] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.862604] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.868199] EDAC MC: UMC1 chip selects:
> [    5.868200] EDAC amd64: MC: 0: 65535MB 1: 65535MB
> [    5.873343] EDAC amd64: MC: 2: 65535MB 3: 65535MB
> [    5.878397] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    5.883597] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    5.889065] EDAC amd64: using x8 syndromes.
> [    5.893751] EDAC amd64: MCT channel count: 2
> [    5.898924] EDAC MC7: Giving out device to module amd64_edac controller F17h: DEV 0000:00:1f.3 (INTERRUPT)
> [    5.909495] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.0 (POLLED)
> [    5.921395] AMD64 EDAC driver v3.5.0
> [    5.925429] hidraw: raw HID events driver (C) Jiri Kosina
> [    5.932940] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:01.3/0000:01:00.0/usb1/1-1/1-1:1.0/0003:14DD:0002.0001/input/input2
> [    5.952219] input: HID 0557:2419 as /devices/pci0000:00/0000:00:07.1/0000:05:00.3/usb5/5-2/5-2.1/5-2.1:1.0/0003:0557:2419.0002/input/input3
> [    5.999113] hid-generic 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:01:00.0-1/input0
> [    6.013897] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:01.3/0000:01:00.0/usb1/1-1/1-1:1.1/0003:14DD:0002.0003/input/input4
> [    6.051085] hid-generic 0003:0557:2419.0002: input,hidraw1: USB HID v1.00 Keyboard [HID 0557:2419] on usb-0000:05:00.3-2.1/input0
> [    6.051140] hid-generic 0003:14DD:0002.0003: input,hidraw2: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:01:00.0-1/input1
> [    6.068229] input: HID 0557:2419 as /devices/pci0000:00/0000:00:07.1/0000:05:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0557:2419.0004/input/input5
> [    6.090701] hid-generic 0003:0557:2419.0004: input,hidraw3: USB HID v1.00 Mouse [HID 0557:2419] on usb-0000:05:00.3-2.1/input1
> [    6.103465] usbcore: registered new interface driver usbhid
> [    6.109589] usbhid: USB HID core driver
> [    6.115015] Key type dns_resolver registered
> [    6.128196] microcode: CPU0: patch_level=0x08001213
> [    6.133345] microcode: CPU1: patch_level=0x08001213
> [    6.138607] microcode: CPU2: patch_level=0x08001213
> [    6.144229] microcode: CPU3: patch_level=0x08001213
> [    6.149589] microcode: CPU4: patch_level=0x08001213
> [    6.155062] microcode: CPU5: patch_level=0x08001213
> [    6.160291] microcode: CPU6: patch_level=0x08001213
> [    6.166035] microcode: CPU7: patch_level=0x08001213
> [    6.171334] microcode: CPU8: patch_level=0x08001213
> [    6.176556] microcode: CPU9: patch_level=0x08001213
> [    6.182059] microcode: CPU10: patch_level=0x08001213
> [    6.187438] microcode: CPU11: patch_level=0x08001213
> [    6.193073] microcode: CPU12: patch_level=0x08001213
> [    6.198505] microcode: CPU13: patch_level=0x08001213
> [    6.204063] microcode: CPU14: patch_level=0x08001213
> [    6.209416] microcode: CPU15: patch_level=0x08001213
> [    6.215062] microcode: CPU16: patch_level=0x08001213
> [    6.220435] microcode: CPU17: patch_level=0x08001213
> [    6.226038] microcode: CPU18: patch_level=0x08001213
> [    6.231494] microcode: CPU19: patch_level=0x08001213
> [    6.237056] microcode: CPU20: patch_level=0x08001213
> [    6.242416] microcode: CPU21: patch_level=0x08001213
> [    6.248063] microcode: CPU22: patch_level=0x08001213
> [    6.253414] microcode: CPU23: patch_level=0x08001213
> [    6.259055] microcode: CPU24: patch_level=0x08001213
> [    6.264516] microcode: CPU25: patch_level=0x08001213
> [    6.270040] microcode: CPU26: patch_level=0x08001213
> [    6.275412] microcode: CPU27: patch_level=0x08001213
> [    6.281064] microcode: CPU28: patch_level=0x08001213
> [    6.286421] microcode: CPU29: patch_level=0x08001213
> [    6.292056] microcode: CPU30: patch_level=0x08001213
> [    6.297566] microcode: CPU31: patch_level=0x08001213
> [    6.303075] microcode: CPU32: patch_level=0x08001213
> [    6.308500] microcode: CPU33: patch_level=0x08001213
> [    6.314059] microcode: CPU34: patch_level=0x08001213
> [    6.319520] microcode: CPU35: patch_level=0x08001213
> [    6.325093] microcode: CPU36: patch_level=0x08001213
> [    6.330481] microcode: CPU37: patch_level=0x08001213
> [    6.336045] microcode: CPU38: patch_level=0x08001213
> [    6.341499] microcode: CPU39: patch_level=0x08001213
> [    6.347064] microcode: CPU40: patch_level=0x08001213
> [    6.352488] microcode: CPU41: patch_level=0x08001213
> [    6.358055] microcode: CPU42: patch_level=0x08001213
> [    6.363504] microcode: CPU43: patch_level=0x08001213
> [    6.369058] microcode: CPU44: patch_level=0x08001213
> [    6.374598] microcode: CPU45: patch_level=0x08001213
> [    6.380344] microcode: CPU46: patch_level=0x08001213
> [    6.385929] microcode: CPU47: patch_level=0x08001213
> [    6.391400] microcode: CPU48: patch_level=0x08001213
> [    6.397037] microcode: CPU49: patch_level=0x08001213
> [    6.402421] microcode: CPU50: patch_level=0x08001213
> [    6.408057] microcode: CPU51: patch_level=0x08001213
> [    6.413417] microcode: CPU52: patch_level=0x08001213
> [    6.419049] microcode: CPU53: patch_level=0x08001213
> [    6.424505] microcode: CPU54: patch_level=0x08001213
> [    6.430061] microcode: CPU55: patch_level=0x08001213
> [    6.435501] microcode: CPU56: patch_level=0x08001213
> [    6.441070] microcode: CPU57: patch_level=0x08001213
> [    6.446426] microcode: CPU58: patch_level=0x08001213
> [    6.452064] microcode: CPU59: patch_level=0x08001213
> [    6.457414] microcode: CPU60: patch_level=0x08001213
> [    6.463029] microcode: CPU61: patch_level=0x08001213
> [    6.468500] microcode: CPU62: patch_level=0x08001213
> [    6.474062] microcode: CPU63: patch_level=0x08001213
> [    6.479508] microcode: CPU64: patch_level=0x08001213
> [    6.485050] microcode: CPU65: patch_level=0x08001213
> [    6.490499] microcode: CPU66: patch_level=0x08001213
> [    6.496070] microcode: CPU67: patch_level=0x08001213
> [    6.501396] microcode: CPU68: patch_level=0x08001213
> [    6.506620] microcode: CPU69: patch_level=0x08001213
> [    6.512435] microcode: CPU70: patch_level=0x08001213
> [    6.518075] microcode: CPU71: patch_level=0x08001213
> [    6.523477] microcode: CPU72: patch_level=0x08001213
> [    6.529041] microcode: CPU73: patch_level=0x08001213
> [    6.534414] microcode: CPU74: patch_level=0x08001213
> [    6.540051] microcode: CPU75: patch_level=0x08001213
> [    6.545487] microcode: CPU76: patch_level=0x08001213
> [    6.551061] microcode: CPU77: patch_level=0x08001213
> [    6.556423] microcode: CPU78: patch_level=0x08001213
> [    6.562004] microcode: CPU79: patch_level=0x08001213
> [    6.567416] microcode: CPU80: patch_level=0x08001213
> [    6.573063] microcode: CPU81: patch_level=0x08001213
> [    6.578519] microcode: CPU82: patch_level=0x08001213
> [    6.584083] microcode: CPU83: patch_level=0x08001213
> [    6.589493] microcode: CPU84: patch_level=0x08001213
> [    6.595054] microcode: CPU85: patch_level=0x08001213
> [    6.600441] microcode: CPU86: patch_level=0x08001213
> [    6.606077] microcode: CPU87: patch_level=0x08001213
> [    6.611595] microcode: CPU88: patch_level=0x08001213
> [    6.617419] microcode: CPU89: patch_level=0x08001213
> [    6.623077] microcode: CPU90: patch_level=0x08001213
> [    6.628547] microcode: CPU91: patch_level=0x08001213
> [    6.634261] microcode: CPU92: patch_level=0x08001213
> [    6.640064] microcode: CPU93: patch_level=0x08001213
> [    6.645518] microcode: CPU94: patch_level=0x08001213
> [    6.651171] microcode: CPU95: patch_level=0x08001213
> [    6.658617] microcode: CPU96: patch_level=0x08001213
> [    6.664556] microcode: CPU97: patch_level=0x08001213
> [    6.670078] microcode: CPU98: patch_level=0x08001213
> [    6.675697] microcode: CPU99: patch_level=0x08001213
> [    6.681601] microcode: CPU100: patch_level=0x08001213
> [    6.687612] microcode: CPU101: patch_level=0x08001213
> [    6.693534] microcode: CPU102: patch_level=0x08001213
> [    6.699217] microcode: CPU103: patch_level=0x08001213
> [    6.704936] microcode: CPU104: patch_level=0x08001213
> [    6.710698] microcode: CPU105: patch_level=0x08001213
> [    6.716693] microcode: CPU106: patch_level=0x08001213
> [    6.722526] microcode: CPU107: patch_level=0x08001213
> [    6.728350] microcode: CPU108: patch_level=0x08001213
> [    6.734082] microcode: CPU109: patch_level=0x08001213
> [    6.740085] microcode: CPU110: patch_level=0x08001213
> [    6.746005] microcode: CPU111: patch_level=0x08001213
> [    6.751576] microcode: CPU112: patch_level=0x08001213
> [    6.757070] microcode: CPU113: patch_level=0x08001213
> [    6.762612] microcode: CPU114: patch_level=0x08001213
> [    6.768700] microcode: CPU115: patch_level=0x08001213
> [    6.774611] microcode: CPU116: patch_level=0x08001213
> [    6.780598] microcode: CPU117: patch_level=0x08001213
> [    6.786604] microcode: CPU118: patch_level=0x08001213
> [    6.792368] microcode: CPU119: patch_level=0x08001213
> [    6.798075] microcode: CPU120: patch_level=0x08001213
> [    6.803958] microcode: CPU121: patch_level=0x08001213
> [    6.809690] microcode: CPU122: patch_level=0x08001213
> [    6.815561] microcode: CPU123: patch_level=0x08001213
> [    6.821101] microcode: CPU124: patch_level=0x08001213
> [    6.826588] microcode: CPU125: patch_level=0x08001213
> [    6.832507] microcode: CPU126: patch_level=0x08001213
> [    6.838165] microcode: CPU127: patch_level=0x08001213
> [    6.843767] microcode: Microcode Update Driver: v2.2.
> [    6.843792] sched_clock: Marking stable (6847015480, -3260091)->(8681444179, -1837688790)
> [    6.859214] registered taskstats version 1
> [    6.865776] rtc_cmos 00:01: setting system clock to 2019-02-13 11:04:09 UTC (1550055849)
> [    6.874426] ALSA device list:
> [    6.877676]   No soundcards found.
> [    6.883946] Freeing unused kernel image memory: 1564K
> [    6.894004] Write protecting the kernel read-only data: 20480k
> [    6.901812] Freeing unused kernel image memory: 2008K
> [    6.907755] Freeing unused kernel image memory: 576K
> [    6.913073] Run /init as init process
> [    7.090611] XFS (sda1): Mounting V5 Filesystem
> [    7.108533] XFS (sda1): Starting recovery (logdev: internal)
> [    7.126071] XFS (sda1): Ending recovery (logdev: internal)
> [    7.266991] NET: Registered protocol family 10
> [    7.272562] Segment Routing with IPv6
> [    7.289789] NET: Registered protocol family 1
> [    7.332788] systemd[1]: systemd 239 running in system mode. (+PAM -AUDIT -SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP -LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
> [    7.374350] systemd[1]: Detected architecture x86-64.
> [    7.385142] systemd[1]: Set hostname to <bohemianrhapsody.molgen.mpg.de>.
> [    7.417772] systemd[1]: File /lib/systemd/system/systemd-journald.service:36 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
> [    7.435721] systemd[1]: Proceeding WITHOUT firewalling in effect! (This warning is only shown for the first loaded unit using IP firewalling.)
> [    7.495609] random: systemd: uninitialized urandom read (16 bytes read)
> [    7.503592] systemd[1]: Created slice User and Session Slice.
> [    7.510532] random: systemd: uninitialized urandom read (16 bytes read)
> [    7.517587] systemd[1]: Reached target Slices.
> [    7.523118] random: systemd: uninitialized urandom read (16 bytes read)
> [    7.530130] systemd[1]: Reached target network after root writable.
> [    7.537500] systemd[1]: Reached target Remote File Systems.
> [    7.544619] systemd[1]: Created slice system-getty.slice.
> [    7.605731] RPC: Registered named UNIX socket transport module.
> [    7.612030] RPC: Registered udp transport module.
> [    7.617024] RPC: Registered tcp transport module.
> [    7.617025] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    7.662924] random: crng init done
> [    7.662927] random: 7 urandom warning(s) missed due to ratelimiting
> [    7.736238] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    7.751483] systemd-journald[951]: Received request to flush runtime journal from PID 1
> [    7.815081] acpi_cpufreq: overriding BIOS provided _PSD data
> [    7.979542] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 5.1.0-k
> [    7.987641] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
> [    8.141271] kvm: Nested Virtualization enabled
> [    8.141322] kvm: Nested Paging enabled
> [    8.141323] SVM: Virtual VMLOAD VMSAVE supported
> [    8.141324] SVM: Virtual GIF supported
> [    8.178017] ixgbe 0000:61:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
> [    8.189337] ixgbe 0000:61:00.0: 32.000 Gb/s available PCIe bandwidth (5 GT/s x8 link)
> [    8.197846] ixgbe 0000:61:00.0: MAC: 2, PHY: 20, SFP+: 5, PBA No: Unknown
> [    8.205213] ixgbe 0000:61:00.0: 00:1b:21:bc:f3:a4
> [    8.211777] ixgbe 0000:61:00.0: Intel(R) 10 Gigabit Network Connection
> [    8.380871] ixgbe 0000:61:00.1: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
> [    8.392326] ixgbe 0000:61:00.1: 32.000 Gb/s available PCIe bandwidth (5 GT/s x8 link)
> [    8.400862] ixgbe 0000:61:00.1: MAC: 2, PHY: 20, SFP+: 6, PBA No: Unknown
> [    8.408305] ixgbe 0000:61:00.1: 00:1b:21:bc:f3:a6
> [    8.414805] ixgbe 0000:61:00.1: Intel(R) 10 Gigabit Network Connection
> [    8.588193] igb 0000:11:00.0 net00: renamed from eth0
> [    8.620092] igb 0000:11:00.1 net01: renamed from eth1
> [    8.646398] igb 0000:11:00.2 net02: renamed from eth2
> [    8.694829] md: md0 stopped.
> [    8.701032] md0: detected capacity change from 0 to 16002857304064
> [    8.707094] igb 0000:11:00.3 net03: renamed from eth3
> [    8.722021] ixgbe 0000:61:00.0 net04: renamed from eth4
> [    8.743862] ixgbe 0000:61:00.1 net05: renamed from eth5
> [    8.825235] XFS (sda2): Mounting V5 Filesystem
> [    8.842154] XFS (sda2): Starting recovery (logdev: internal)
> [    8.845490] XFS (sda2): Ending recovery (logdev: internal)
> [    8.929334] XFS (md0): Mounting V5 Filesystem
> [    9.028561] ixgbe 0000:61:00.0: registered PHC device on net04
> [    9.042671] XFS (md0): Starting recovery (logdev: internal)
> [    9.196205] 8021q: 802.1Q VLAN Support v1.8
> [    9.196225] 8021q: adding VLAN 0 to HW filter on device net04
> [    9.203003] ixgbe 0000:61:00.0 net04: detected SFP+: 5
> [    9.221193] NFSD: starting 90-second grace period (net f0000098)
> [    9.365396] XFS (md0): Ending recovery (logdev: internal)
> [    9.868112] ixgbe 0000:61:00.0 net04: NIC Link is Up 10 Gbps, Flow Control: RX/TX
> [   13.358712] FS-Cache: Netfs 'nfs' registered for caching
> [   13.405090] NFS: Registering the id_resolver key type
> [   13.405104] Key type id_resolver registered
> [   13.405104] Key type id_legacy registered
> [1145080.180898] XFS (loop0): Mounting V5 Filesystem
> [1145080.221747] XFS (loop0): Starting recovery (logdev: internal)
> [1145080.231642] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 000000009195283b
> [1145080.231647] XFS (loop0): Corruption of in-memory data detected.  Shutting down filesystem
> [1145080.231651] CPU: 12 PID: 129522 Comm: mount Kdump: loaded Not tainted 4.19.19.mx64.244 #1
> [1145080.231652] Hardware name: Supermicro AS -2023US-TR4/H11DSU-iN, BIOS 1.1 02/07/2018
> [1145080.231653] Call Trace:
> [1145080.231664]  dump_stack+0x46/0x5b
> [1145080.231669]  xfs_do_force_shutdown+0x10e/0x110
> [1145080.231672]  xfs_trans_mod_sb+0x1b0/0x1c0
> [1145080.231677]  xfs_alloc_ag_vextent+0x99/0x150
> [1145080.231679]  xfs_alloc_vextent+0x42b/0x560
> [1145080.231682]  __xfs_inobt_alloc_block.isra.2+0x9f/0x100
> [1145080.231685]  __xfs_btree_split+0xcb/0x600
> [1145080.231690]  ? loop_queue_rq+0xa6/0xc0
> [1145080.231692]  ? xfs_buf_trylock+0x19/0xe0
> [1145080.231696]  ? down_trylock+0x25/0x30
> [1145080.231697]  xfs_btree_split+0x4b/0x100
> [1145080.231699]  xfs_btree_make_block_unfull+0x186/0x1c0
> [1145080.231701]  xfs_btree_insrec+0x474/0x4c0
> [1145080.231704]  ? xfs_btree_read_buf_block.constprop.28+0x97/0xd0
> [1145080.231705]  xfs_btree_insert+0xcb/0x240
> [1145080.231707]  ? xfs_difree_finobt+0xb9/0x1e0
> [1145080.231708]  xfs_difree_finobt+0xb9/0x1e0
> [1145080.231710]  xfs_difree+0x11e/0x190
> [1145080.231712]  xfs_ifree+0x71/0x160
> [1145080.231715]  ? xfs_inode_item_init+0x1e/0x50
> [1145080.231717]  xfs_inactive_ifree+0x9e/0x1c0
> [1145080.231719]  xfs_inactive+0xa1/0x140
> [1145080.231721]  xfs_fs_destroy_inode+0xb1/0x1c0
> [1145080.231723]  xlog_recover_process_one_iunlink+0xcb/0x110
> [1145080.231725]  xlog_recover_process_iunlinks.isra.28+0x7c/0xc0
> [1145080.231727]  xlog_recover_finish+0x37/0xa0
> [1145080.231729]  xfs_log_mount_finish+0x5a/0xe0
> [1145080.231731]  xfs_mountfs+0x617/0x860
> [1145080.231733]  ? xfs_mru_cache_create+0x12b/0x180
> [1145080.231734]  xfs_fs_fill_super+0x462/0x5d0
> [1145080.231735]  ? xfs_test_remount_options+0x60/0x60
> [1145080.231739]  mount_bdev+0x173/0x1b0
> [1145080.231742]  mount_fs+0x15/0x80
> [1145080.231745]  vfs_kern_mount.part.9+0x54/0x100
> [1145080.231747]  do_mount+0x20d/0xc30
> [1145080.231750]  ? _copy_from_user+0x37/0x60
> [1145080.231753]  ? memdup_user+0x3e/0x70
> [1145080.231755]  ksys_mount+0x80/0xd0
> [1145080.231757]  __x64_sys_mount+0x21/0x30
> [1145080.231759]  do_syscall_64+0x48/0x100
> [1145080.231763]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [1145080.231766] RIP: 0033:0x7f454074e7da
> [1145080.231769] Code: 48 8b 0d b1 c6 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 7e c6 2b 00 f7 d8 64 89 01 48
> [1145080.231770] RSP: 002b:00007ffc0b9bba58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> [1145080.231772] RAX: ffffffffffffffda RBX: 000000000060b340 RCX: 00007f454074e7da
> [1145080.231772] RDX: 00000000006200c0 RSI: 000000000060d240 RDI: 0000000000621840
> [1145080.231773] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f454078ca90
> [1145080.231774] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000000000621840
> [1145080.231774] R13: 00000000006200c0 R14: 0000000000000000 R15: 0000000000000003
> [1145080.231776] XFS (loop0): Please umount the filesystem and rectify the problem(s)
> [1145080.231793] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231795] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231797] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231798] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231799] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231800] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231801] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231802] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231804] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231805] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231806] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231807] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231808] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231809] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231810] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231811] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231813] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231814] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231815] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231816] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231817] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231818] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231819] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231820] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231822] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231823] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231823] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231824] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231825] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231826] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231827] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231828] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231830] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231831] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231832] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231833] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231834] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231835] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231836] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231837] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231840] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231840] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231841] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231842] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231843] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231844] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231845] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231846] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231848] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231849] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231850] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231851] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231852] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231853] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231854] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231855] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231857] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231858] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231859] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231860] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231861] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231862] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231863] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231864] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231867] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231868] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231870] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231871] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231872] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231873] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231875] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231876] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231878] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231879] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231881] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231882] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231884] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231885] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231886] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231887] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231890] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231891] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231893] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231894] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231895] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231896] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231898] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231899] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231901] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231902] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231904] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231905] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231907] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231908] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231909] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231910] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231914] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231915] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231917] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231918] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231919] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231920] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231922] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231923] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231926] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231927] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231929] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231930] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231931] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231932] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231934] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231935] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231938] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231939] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231940] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231941] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231943] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231944] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231946] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231947] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231950] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231951] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231952] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231953] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231955] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231956] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231958] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [1145080.231959] XFS (loop0): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [1145080.231971] XFS (loop0): Ending recovery (logdev: internal)
> [1145080.232301] XFS (loop0): Error -5 reserving per-AG metadata reserve pool.
> [1145080.232303] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000d48a575f
