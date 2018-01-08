Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbeAHT0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 14:26:12 -0500
Date: Mon, 8 Jan 2018 11:26:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180108192607.GS5602@magnolia>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs.pkoch@dfgh.net
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 08, 2018 at 08:08:09PM +0100, xfs.pkoch@dfgh.net wrote:
> Dear Linux-Raid and Linux-XFS experts:
> 
> I'm posting this on both the linux-raid and linux-xfs
> mailing list as it's not clear at this point wether
> this is a MD- od XFS-problem.
> 
> I have described my problem in a recent posting on
> linux-raid and Wol's conclusion was:
> 
> >In other words, one or more of the following three are true :-
> >1) The OP has been caught by some random act of God
> >2) There's a serious flaw in "mdadm --grow"
> >3) There's a serious flaw in xfs
> >
> >Cheers,
> >Wol
> 
> There's very important data on our RAID10 device but I doubt
> it's important enough for God to take a hand into our storage.
> 
> But let me first summarize what happened and why I believe that
> this is an XFS-problem:
> 
> Machine running Linux 3.14.69 with no kernel-patches.
> 
> XFS filesystem was created with XFS userutils 3.1.11.
> I did a fresh compile of xfsprogs-4.9.0 yesterday when
> I realized that the 3.1.11 xfs_repair did not help.
> 
> mdadm is V3.3
> 
> /dev/md5 is a RAID10-device that was created in Feb 2013
> with 10 2TB disks and an ext3 filesystem on it. Once in a
> while I added two more 2TB disks. Reshaping was done
> while the ext3 filesystem was mounted. Then the ext3
> filesystem was unmounted resized and mounted again. That
> worked until I resized the RAID10 from 16 to 20 disks and
> realized that ext3 does not support filesystems >16TB.
> 
> I switched to XFS and created a 20TB filesystem. Here are
> the details:
> 
> # xfs_info /dev/md5
> meta-data=/dev/md5               isize=256    agcount=32,
> agsize=152608128 blks
>           =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=4883457280, imaxpct=5
>           =                       sunit=128    swidth=1280 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>           =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Please notice: Ths XFS-filesystem has a size of
> 4883457280*4K = 19,533,829,120K
> 
> On saturday I tried to add two more 2TB disks to the RAID10
> and the XFS filesystem was mounted (and in medium use) at that
> time. Commands were:
> 
> # mdadm /dev/md5 --add /dev/sdo
> # mdadm --grow /dev/md5 --raid-devices=21
> 
> # mdadm -D /dev/md5
> /dev/md5:
>          Version : 1.2
>    Creation Time : Sun Feb 10 16:58:10 2013
>       Raid Level : raid10
>       Array Size : 19533829120 (18628.91 GiB 20002.64 GB)
>    Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
>     Raid Devices : 21
>    Total Devices : 21
>      Persistence : Superblock is persistent
> 
>      Update Time : Sat Jan  6 15:08:37 2018
>            State : clean, reshaping
>   Active Devices : 21
> Working Devices : 21
>   Failed Devices : 0
>    Spare Devices : 0
> 
>           Layout : near=2
>       Chunk Size : 512K
> 
>   Reshape Status : 1% complete
>    Delta Devices : 1, (20->21)
> 
>             Name : backup:5  (local to host backup)
>             UUID : 9030ff07:6a292a3c:26589a26:8c92a488
>           Events : 86002
> 
>      Number   Major   Minor   RaidDevice State
>         0       8       16        0      active sync   /dev/sdb
>         1      65       48        1      active sync   /dev/sdt
>         2       8       64        2      active sync   /dev/sde
>         3      65       96        3      active sync   /dev/sdw
>         4       8      112        4      active sync   /dev/sdh
>         5      65      144        5      active sync   /dev/sdz
>         6       8      160        6      active sync   /dev/sdk
>         7      65      192        7      active sync   /dev/sdac
>         8       8      208        8      active sync   /dev/sdn
>         9      65      240        9      active sync   /dev/sdaf
>        10      65        0       10      active sync   /dev/sdq
>        11      66       32       11      active sync   /dev/sdai
>        12       8       32       12      active sync   /dev/sdc
>        13      65       64       13      active sync   /dev/sdu
>        14       8       80       14      active sync   /dev/sdf
>        15      65      112       15      active sync   /dev/sdx
>        16       8      128       16      active sync   /dev/sdi
>        17      65      160       17      active sync   /dev/sdaa
>        18       8      176       18      active sync   /dev/sdl
>        19      65      208       19      active sync   /dev/sdad
>        20       8      224       20      active sync   /dev/sdo
> 
> Please notice: Ths RAID10-device has a size of 19,533,829,120K
> that's exactly the same size as the contained XFS-filesystem.
> 
> Immediately after the RAID10 reshape operation started the
> XFS-filesystem reported I/O-errors and was severly damaged.
> I waited for the reshape operation to finish and tried to repair
> the filesystem with xfs_repair (version 3.1.11) but xfs_repair
> crashed, so I tried 4.9.0-version aif xfs_reapair with no luck
> either.
> 
> /dev/md5 ist now mounted ro,norecovery with an overlay filesystem
> on top of it (thanks very much to Andreas for that idea) and I have
> setup a new server today. Rsyncing the data to the new server will
> take a while and I'm sure I will stumble on lots of corrupted files.
> I proceeded from XFS to ZFS (skipped YFS) so lengthy reshape
> operations won't happen in the future anymore.
> 
> Here are the relevant log messages:
> 
> >Jan  6 14:45:00 backup kernel: md: reshape of RAID array md5
> >Jan  6 14:45:00 backup kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> >Jan  6 14:45:00 backup kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> >Jan  6 14:45:00 backup kernel: md: using 128k window, over a total of 19533829120k.
> >Jan  6 14:45:00 backup kernel: XFS (md5): metadata I/O error: block 0x12c08f360 ("xfs_trans_read_buf_map") error 5 numblks 16
> >Jan  6 14:45:00 backup kernel: XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> >Jan  6 14:45:00 backup kernel: XFS (md5): metadata I/O error: block 0x12c08f360 ("xfs_trans_read_buf_map") error 5 numblks 16
> >Jan  6 14:45:00 backup kernel: XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> >... hundreds of the above XFS-messages deleted
> >Jan  6 14:45:00 backup kernel: XFS (md5): Log I/O Error Detected.  Shutting down filesystem
> >Jan  6 14:45:00 backup kernel: XFS (md5): Please umount the filesystem and rectify the problem(s)
> 
> Please notice: no error message about hardware-problems.
> All 21 disks are fine and the next messages from the
> md-driver was:
> 
> >Jan  7 02:28:02 backup kernel: md: md5: reshape done.
> >Jan  7 02:28:03 backup kernel: md5: detected capacity change from 20002641018880 to 21002772807680
> 
> I'm wondering about one thing: the first xfs message is about a
> meatadata I/O error on block 0x12c08f360. Since the xfs filesystem

I'm sure Dave will have more to say about this, but...

"block 0x12c08f360" == units of sectors, not fs blocks.

IOWs, this IO error happened at offset 2,577,280,712,704 (~2.5TB)

XFS doesn't change the fs size until you tell it to (via growfs);
even if the underlying storage geometry changes, XFS won't act on it
until the admin tells it to.

What did xfs_repair do?

--D

> has a blocksize of 4K this block is located at position 20135005568K
> which is beyond the end of the RAID10 device. No wonder that the
> xfs driver receives an I/O error. And also no wonder that the
> filesystem is severely corrupted right now.
> 
> Question 1: How did the xfs driver knew on Jan 6 that the RAID10
> device was about to be increased from 20TB to 21TB on Jan 7?
> 
> Question 2: Why did the xfs driver started to use the additional
> space that was not yet there without me executing xfs_growfs.
> 
> This looks like a severe XFS-problem to me.
> 
> But my hope is that all the data taht was within the filesystem
> before Jan 6 14:45 is not involved in the corruption. If xfs
> started to use space beyond the end of the underlying raid
> device this should have affected only data that was created,
> modified or deleted after Jan 6 14:45.
> 
> If that was true we could clearly distinct between data
> that we must dump and data that we can keep. The machine is
> our backup system (as you may have guessed from its name)
> and I would like to keep old backup-files.
> 
> I remember that mkfs.xfs is clever enough to adopt the
> filesystem paramters to the underlying hardware of the
> block device that the xfs filesystem is created on. Hence
> from the xfs drivers point of view the underlying block
> device is not just a sequence of data blocks, but the xfs
> driver knows something about the layout of the underlying
> hardware.
> 
> If that was true - how does the xfs driver reacts if that
> information about the layout of the underlying hardware
> changes while the xfs-filesystem is mounted?
> 
> Seems to be an interesting problem
> 
> Kind regards
> 
> Peter Koch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
