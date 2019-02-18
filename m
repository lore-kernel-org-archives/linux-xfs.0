Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389984AbfBRR5Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 12:57:25 -0500
Date: Mon, 18 Feb 2019 12:57:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Corruption of in-memory data detected. Shutting down filesystem
Message-ID: <20190218175722.GF33924@bfoster>
References: <b4141aed-70f1-83de-92e3-b8c9494900c7@molgen.mpg.de>
 <20190218142203.p53qvipc4yul6mv6@hades.usersys.redhat.com>
 <20190218143403.GB33924@bfoster>
 <0d3627ab-34e6-a800-c562-c25c578e3c6a@molgen.mpg.de>
 <20190218161746.GE33924@bfoster>
 <20190218173251.GF6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190218173251.GF6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org, it+linux-xfs@molgen.mpg.de

On Mon, Feb 18, 2019 at 09:32:51AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 18, 2019 at 11:17:46AM -0500, Brian Foster wrote:
> > On Mon, Feb 18, 2019 at 04:08:00PM +0100, Paul Menzel wrote:
> > > Dear Brian, dear Carlos,
> > > 
> > > 
> > > Thank you very much for your replies.
> > > 
> > > 
> > > On 02/18/19 15:34, Brian Foster wrote:
> > > > On Mon, Feb 18, 2019 at 03:22:03PM +0100, Carlos Maiolino wrote:
> > > 
> > > >>> [   25.506600] XFS (sdd): Mounting V5 Filesystem
> > > >>> [   25.629621] XFS (sdd): Starting recovery (logdev: internal)
> > > >>> [   25.685100] NFSD: starting 90-second grace period (net f0000098)
> > > >>> [   26.433828] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> > > >>> [   26.433834] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> > > >>> [   26.433835] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> > > >>> [   26.433857] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> > > >>>
> > > >> Ok, filesystem shut itself down likely because blocks allocated in the
> > > >> transaction exceeded the reservation.
> > > 
> > > >>> We mounted it with an overlay files,
> > > >>
> > > >> I'm not sure what you meant here, could you please specify what you meant by
> > > >> 'overlay files'? Are you using this XFS filesystem as an upper/lower FS for
> > > >> overlayfs?
> > > 
> > > To not touch the original data on `/dev/sdd` after the error we created on overlay
> > > FS to test xfs_repair, and analyze the effect.
> > > 
> > > ```
> > > # more /scratch/local3/mkoverlay.sh 
> > > dev=/dev/sdd
> > > ovl=/scratch/local3/X4042-overlay.file
> > > newdevname=sddovl
> > > size=$(blockdev --getsz "$dev")
> > > 
> > > loop=$(losetup -f --show -- "$ovl")
> > > printf '%s\n' "0 $size snapshot $dev $loop P 8" 
> > > printf '%s\n' "0 $size snapshot $dev $loop P 8" | dmsetup create "$newdevname"
> > > # lsblk
> > > NAME     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> > > loop0      7:0    0    10G  0 loop 
> > > loop1      7:1    0    10G  0 loop 
> > > └─sddovl 252:0    0    51T  0 dm   
> > > sda        8:0    0 931.5G  0 disk 
> > > ├─sda1     8:1    0   256G  0 part /
> > > └─sda2     8:2    0 675.5G  0 part /amd/tinytina/0
> > > sdb        8:16   0 931.5G  0 disk /amd/tinytina/1
> > > sdc        8:32   0  27.3T  0 disk /amd/tinytina/2
> > > sdd        8:48   0    51T  0 disk 
> > > └─sddovl 252:0    0    51T  0 dm   
> > > sde        8:64   0    51T  0 disk /amd/tinytina/X/X4075
> > > sdf        8:80   0    51T  0 disk /amd/tinytina/X/X4076
> > > ```
> > > 
> > > >>> and the xfs_repair shows the summary below.
> > > >>>
> > > >>> ```
> > > >>> # xfs_repair -vv /dev/mapper/sddovl
> > > >>>         - block cache size set to 4201400 entries
> > > >>> Phase 2 - using internal log
> > > >>>         - zero log...
> > > >>> zero_log: head block 3930112 tail block 3929088
> > > >>> ERROR: The filesystem has valuable metadata changes in a log which needs to
> > > >>> be replayed.  Mount the filesystem to replay the log, and unmount it before
> > > >>> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> > > >>> the -L option to destroy the log and attempt a repair.
> > > >>> Note that destroying the log may cause corruption -- please attempt a mount
> > > >>
> > > >> Have you tried to mount/umount the filesystem before zeroing the log? This is
> > > >> supposed to be used as a last resort. Zero out the logs I mean.
> > > 
> > > Yes, we tried that, and were told to run `xfs_repair`.
> > > 
> > > >>> The directory `lost+found` contains almost five million files
> > > >>>
> > > >>>     # find lost+found | wc
> > > >>>     4859687 4859687 110985720
> > > >>
> > > >> We don't have neither the whole xfs_repair output nor more information about the
> > > >> filesystem itself, but looks like you had huge directory(ies) update in your log
> > > >> which were not replayed, and all orphan inodes ended up in the lost+found =/
> > > 
> > > I’ll see if I can share the 500 MB xfs_repair output.
> > > 
> > > ```
> > > $ lsblk /dev/sdd
> > > NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> > > sdd    8:48   0  51T  0 disk
> > > $ sudo xfs_info /dev/sdd
> > > Password (for pmenzel) : 
> > > meta-data=/dev/sdd               isize=512    agcount=51, agsize=268435392 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=0, rmapbt=0
> > >          =                       reflink=0
> > > data     =                       bsize=4096   blocks=13671838208, imaxpct=1
> > >          =                       sunit=64     swidth=896 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=521728, version=2
> > >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > ```
> > > 
> > > >>> We saved the output of `xfs_repair`, but it’s over 500 MB in size, so we
> > > >>> cannot attach it.
> > > >>>
> > > >>> `sudo xfs_metadump -go /dev/sdd sdd-metadump.dump` takes over 15 minutes
> > > >>> and the dump files is 8.8 GB in size.
> > > >>
> > > >> At this point, xfs_metadump won't help much once you already repaired the
> > > >> filesystem.
> > > 
> > > As written, we only run the repair on the overlay.
> > > 
> > > >> Although, why are you getting a metadump from /dev/sdd, when the fs you tried to
> > > >> repair is a device-mapper device? Are you facing this issue in more than one
> > > >> filesystem?
> > > 
> > > As written above, it was to not touch `/dev/sdd`. So the meta data dump should be
> > > useable.
> > > 
> > > >>> It’d be great, if you could give hints on debugging this issue further,
> > > >>> and comment, if you think it is possible to recover the files, that means,
> > > >>> to fix the log, so that it can be cleanly applied.
> > > >>
> > > >> Unfortunately, you already got rid of the log, so, you can't recover it anymore,
> > > >> but all the recovered files will be in lost+found, with their inode numbers as
> > > >> file name.
> > > >>
> > > >> Ok, so below is the dmesg, thanks for having attached it.
> > > >>
> > > >> One thing is there are 2 devices failing. sdd and dm-0. So my question again, is
> > > >> this the same filesystem or are they 2 separated filesystems showing exactly the
> > > >> same issue? The filesystem has found corrupted inodes in the AG's unlinked
> > > >> bucket, but this shouldn't affect log recovery.
> > > >>
> > > >> If they are two separated devices, did you xfs_repair'ed both of them? After you
> > > >> repaired the filesystem(s), do you still see the memory corruption issue?
> > > 
> > > No, we do not see the corruption issue anymore, and mounting works as expected.
> > > 
> > > >> At this point, there is not much we can do regarding the filesystem metadata,
> > > >> once you already forced a xfs_repair zeroing the logs.
> > > >>
> > > >> So, could you please tell the current state of the filesystem (or filesystems if
> > > >> there is more than one)? Are you still seeing the same memory corruption error
> > > >> even after xfs_repair it?
> > > 
> > > The user wants to continue using the device, and does not need the recovered files,
> > > so we had to go ahead, and repair `/dev/sde` now too. We are only interested in
> > > having this bug fixed in XFS, and not about data recovery.
> > > 
> > 
> > Well, if the metadump is still available and is based on the original
> > (broken) fs then it may be able to reproduce the original problem. How
> > large is it compressed? Would you be able to upload it somewhere?
> > 
> > Brian
> > 
> > > > FWIW, if you do still have an original copy of the fs, we could see
> > > > about whether bypassing the shutdown allows us to trade log recovery
> > > > failure for a space accounting error. This would still require a
> > > > subsequent repair, but that may be less invasive than zapping the log
> > > > and dealing with the aftermath of that.
> > > 
> > > Unfortunately, it’s 50 TB, so we do not have a copy anymore.
> > > 
> > > >> And for completeness, please provide us as much information as possible from
> > > >> this(these) filesystem(s):
> > > >>
> > > >> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > > 
> > >     /dev/sdd /amd/tinytina/X/X4074 xfs rw,relatime,attr2,inode64,logbsize=256k,sunit=512,swidth=7168,noquota 0 0
> > > 
> > > >>> [ 1380.869451] XFS (sdd): Mounting V5 Filesystem
> > > >>> [ 1380.912559] XFS (sdd): Starting recovery (logdev: internal)
> > > >>> [ 1381.030780] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> 
> <groan> Funny, I saw this exact same thing a week ago.  We really ought
> to record a stack trace when we cancel dirty transactions.
> 
> Hmm, so leaking millions of nfs file handles ... were they temporary or
> deleted files?
> 
> I bet I know exactly what caused this -- freeing unlinked inodes that
> required a free inode btree expansion, but m_inotbt_nores was
> incorrectly set during log recovery so we didn't reserve any blocks and
> blew up.
> 

Interesting. I suppose rather than upload it, the user could try to
restore the metadump somewhere, bump /proc/sys/fs/xfs/error_level to >=5
and reproduce the mount failure to try and generate a stack trace.

Brian

> Relevant patches that might fix this:
> 
> "xfs: rename m_inotbt_nores to m_finobt_nores"
> "xfs: reserve blocks for ifree transaction during log recovery"
> 
> (As mentioned earlier, there's not much we can do once the log has been
> zereod.)
> 
> --D
> 
> > > >>> [ 1381.030785] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> > > >>> [ 1381.030786] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> > > >>> [ 1381.031086] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> > > >>> [ 1381.031088] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> > > >>> [ 1381.031090] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> > > >>> [ 1381.031093] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> > > >>> [ 1381.031095] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> > > >> <...>
> > > >>> [ 1381.031113] XFS (sdd): Ending recovery (logdev: internal)
> > > >>> [ 1381.031490] XFS (sdd): Error -5 reserving per-AG metadata reserve pool.
> > > >>> [ 1381.031492] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5
> > > >>
> > > >>> [ 2795.123228] XFS (dm-0): Ending recovery (logdev: internal)
> > > >>> [ 2795.231020] XFS (dm-0): Error -5 reserving per-AG metadata reserve pool.
> > > >>> [ 2795.231023] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5
> > > >>
> > > >>> [10944.023429] XFS (dm-0): Mounting V5 Filesystem
> > > >>> [10944.035260] XFS (dm-0): Ending clean mount
> > > >>> [11664.862376] XFS (dm-0): Unmounting Filesystem
> > > >>> [11689.260213] XFS (dm-0): Mounting V5 Filesystem
> > > >>> [11689.338187] XFS (dm-0): Ending clean mount
> > > 
> > > As written, data recovery is not needed anymore, but, if it’d help the driver,
> > > we could share the logs we have (after making sure it’s obfuscated).
> > > 
> > > Please tell us, if you are interested, and what dumps, xfs_repair output and
> > > so on would be needed.
> > > 
> > > 
> > > Kind regards,
> > > 
> > > Paul
> > > 
> > 
> > 
