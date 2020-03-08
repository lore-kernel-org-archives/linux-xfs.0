Return-Path: <SRS0=BAu2=4Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5086EC10DCE
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 19:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1440120675
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 19:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgCHTpW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Mar 2020 15:45:22 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37320 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgCHTpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Mar 2020 15:45:22 -0400
Received: by mail-oi1-f195.google.com with SMTP id q65so8082725oif.4
        for <linux-xfs@vger.kernel.org>; Sun, 08 Mar 2020 12:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=bPXK1OGq5BWb0BhDCwZeadJ9MA6JVfMC3dvqznne874=;
        b=XMiTm/noExZyn68MBdapCXsGkeSNa5Fg/m+xdj5NHfAgYn95iKaKiTvmchwt6RjhoF
         EbzlZeVvA/5pIL3a3wczPkLinEKmx5xcG76un8UEvisOiDTVzxHrylNdNfabHH3eZz7n
         obIha+OrRuZ/KOSSIwIZhTDZPwHDNvMT0KG7hCp3KQ9/+tZ8JtEwDUmAU6NZ9eogydAn
         Xo3p0lWLAeWkZi7L2ULn0drpt/nbsYaL03OH85vugsTaCacTiRXiAjrhHCsIbQyf5o2N
         0SspL09KvI2YTVIMTDaWGS40hFMLcq9R6OZ/n6vqYT9gVaSh2rYKEo34r5JZjiisQHrm
         Z6hA==
X-Gm-Message-State: ANhLgQ25onOeEIanmR7lXOyBgo0auQtcj2ItJMDaWBK/fUtyzGQ1Tez6
        kTJWVmKYpjOeOAcTDZvr+SJYh3lKynFDM7/bxiMoUMXfsbo=
X-Google-Smtp-Source: ADFU+vtzwV81r28fMgf+V+2JyuqRiuoq7ZjbXHGL+iqVe7Gxh+hzQkho8L46sCLFQ8Gv8SvxmBCSawSitHV/8Gn+An4=
X-Received: by 2002:aca:ebca:: with SMTP id j193mr1405232oih.124.1583696720761;
 Sun, 08 Mar 2020 12:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
In-Reply-To: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
Reply-To: bart.brashers@nyckelharpa.org
From:   Bart Brashers <bart.brashers@nyckelharpa.org>
Date:   Sun, 8 Mar 2020 12:43:29 -0700
Message-ID: <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
Subject: Re: mount before xfs_repair hangs
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An update:

Mounting the degraded xfs filesystem still hangs, so I can't replay
the journal, so I don't yet want to run xfs_repair.

I can mount the degraded xfs filesystem like this:

$ mount -t xfs -o ro,norecovery,inode64,logdev=/dev/md/nvme2
/dev/volgrp4TB/lvol4TB /export/lvol4TB/

If I do a "du" on the contents, I see 3822 files with either
"Structure needs cleaning" or "No such file or directory".

Is what I mounted what I would get if I used the xfs_repair -L option,
and discarded the journal? Or would there be more corruption, e.g. to
the directory structure?

Some of the instances of "No such file or directory" are for files
that are not in their correct directory - I can tell by the filetype
and the directory name. Does that by itself imply directory
corruption?

At this point, can I do a backup, either using rsync or xfsdump or
xfs_copy? I have a separate RAID array on the same server where I
could put the 7.8 TB of data, though the destination already has data
on it - so I don't think xfs_copy is right. Is xfsdump to a directory
faster/better than rsync? Or would it be best to use something like

$ tar cf - /export/lvol4TB/directory | (cd /export/lvol6TB/ ; tar xfp -)

Thanks,

Bart

On Sat, Mar 7, 2020 at 12:36 PM Bart Brashers <bart.brashers@gmail.com> wrote:
>
> (Re-sending without the attachment, in case that's why my previous
> message appears to have been silently rejected.)
>
> I can't find a list for non-devel related post like this, so sorry if
> this is going to the wrong place.
>
> I have an older JBOD attached to a Microsemi 3164-8e RAID card (with
> battery backup) using CentOS 7. It has been up and running for a few
> weeks now, but backups have failed due to operator errors.
>
> While I was working yesterday evening doing some moderate I/O, the
> first backups (bacula) started, and 3 of the disks in a RAID6 set (7
> data + 2 parity) suddenly went offline at the same time. I rebooted,
> and the RAID card’s command line utility (arcconf) showed the drives
> were back online – no longer marked “failed”. So I gave the command:
>
> $ arcconf setstate 1 logicaldrive 3 optimal
>
> To bring the array back online. The next step is to mount and umount
> ito replay the journal, then run xfs_repair.
>
> I gave the mount command and waited ~10 hours, but it’s still hung. I
> can’t figure out why – any help would be greatly appreciated.
>
> I realize now I should have cycled the power on the JBOD only (not
> rebooted the server) to bring the drives back online.
>
> Details:
>
> I created the RAID arrays (7 data + 2 parity + 1 hot spare) like this
> - taken from my notes:
>
> <notes>
> # create the RAID array 2 with physical labels 3.x (4TB disks):
> arcconf create 1 logicaldrive stripesize 256 MAX 6 0  5 0 13 0 14 0 34
> 0 35 0 43 0 44 0 52 0 53 noprompt
> # create the RAID array 3 with physical labels 2.x (4TB disks):
> arcconf create 1 logicaldrive stripesize 256 MAX 6 0  7 0  8 0 16 0 17
> 0 25 0 26 0 46 0 47 0 56 noprompt
> # create the RAID array 4 with physical labels 1.x (4TB disks):
> arcconf create 1 logicaldrive stripesize 256 MAX 6 0 10 0 11 0 19 0 20
> 0 28 0 29 0 37 0 38 0 59 noprompt
>
> # Combine the three 4TB disks arrays (called "logicaldrive" in arcconf).
> # The three 4TB RAID arrays from arcconf appear as sde, sdf, and sdg.
> pvcreate /dev/sde /dev/sdf /dev/sdg
> vgcreate volgrp4TB /dev/sde /dev/sdf /dev/sdg
> lvcreate -l 100%VG -n lvol4TB volgrp4TB # creates /dev/volgrp4TB/lvol4TB
>
> # Store the journal on a RAID0 M2. NVMe device:
>
> parted /dev/nvme0n1 mkpart primary  0% 25%
> parted /dev/nvme0n1 mkpart primary 25% 50%
> parted /dev/nvme0n1 mkpart primary 50% 75%
> parted /dev/nvme0n1 mkpart primary 75% 100%
>
> parted /dev/nvme1n1 mkpart primary  0% 25%
> parted /dev/nvme1n1 mkpart primary 25% 50%
> parted /dev/nvme1n1 mkpart primary 50% 75%
> parted /dev/nvme1n1 mkpart primary 75% 100%
>
> parted /dev/nvme0n1 set 1 raid on
> parted /dev/nvme0n1 set 2 raid on
> parted /dev/nvme0n1 set 3 raid on
> parted /dev/nvme0n1 set 4 raid on
>
> parted /dev/nvme1n1 set 1 raid on
> parted /dev/nvme1n1 set 2 raid on
> parted /dev/nvme1n1 set 3 raid on
> parted /dev/nvme1n1 set 4 raid on
>
> mdadm --create /dev/md/nvme1 --level=mirror --raid-devices=2
> /dev/nvme0n1p1 /dev/nvme1n1p1
> mdadm --create /dev/md/nvme2 --level=mirror --raid-devices=2
> /dev/nvme0n1p2 /dev/nvme1n1p2
> mdadm --create /dev/md/nvme3 --level=mirror --raid-devices=2
> /dev/nvme0n1p3 /dev/nvme1n1p3
> mdadm --create /dev/md/nvme4 --level=mirror --raid-devices=2
> /dev/nvme0n1p4 /dev/nvme1n1p4
> mdadm --examine --scan --config=/etc/mdadm.conf | tail -4 >> /etc/mdadm.conf
>
> mkfs.xfs -l logdev=/dev/md/nvme2,size=500000b -d su=256k,sw=7
> /dev/volgrp4TB/lvol4TB
>
> mkdir -p /export/lvol4TB
> echo "/dev/volgrp4TB/lvol4TB    /export/lvol4TB         auto
> inode64,logdev=/dev/md/nvme2    1 2" >> /etc/fstab
> mount -a
> </notes>
>
> After a boot, I can still see the PVs and LVs:
>
> $ pvs; lvs
>   PV         VG        Fmt  Attr PSize   PFree
>   /dev/sdc   volgrp6TB lvm2 a--  <38.21t    0
>   /dev/sdd   volgrp6TB lvm2 a--  <38.21t    0
>   /dev/sde   volgrp4TB lvm2 a--   25.47t    0
>   /dev/sdf   volgrp4TB lvm2 a--   25.47t    0
>   /dev/sdg   volgrp4TB lvm2 a--   25.47t    0
>   LV      VG        Attr       LSize  Pool Origin Data%  Meta%  Move
> Log Cpy%Sync Convert
>   lvol4TB volgrp4TB -wi-ao---- 76.41t
>  lvol6TB volgrp6TB -wi-ao---- 76.41t
>
>  When I try to mount the problematic filesystem using
>
> % mount -o inode64,logdev=/dev/md/nvme2 -t xfs /dev/volgrp4TB/lvol4TB
> /export/lvol4TB
>
> or by using mount -a with the following in /etc/fstab:
>
> /dev/volgrp4TB/lvol4TB  /export/lvol4TB         xfs
> inode64,logdev=/dev/md/nvme2        1 2
>
> I see this in dmesg:
>
> [  417.033013] XFS (dm-0): Mounting V5 Filesystem
> [  417.086868] XFS (dm-0): Starting recovery (logdev: /dev/md/nvme2)
> [  417.094291] XFS (dm-0): Metadata corruption detected at
> xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block
> 0x108605a000
> [  417.094342] XFS (dm-0): Unmount and run xfs_repair
> [  417.094360] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> [  417.094383] ffffbd6f5ba68000: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.094412] ffffbd6f5ba68010: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.094439] ffffbd6f5ba68020: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.094467] ffffbd6f5ba68030: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.094512] XFS (dm-0): Metadata corruption detected at
> xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x108605a000
>         (repeat like that many times)
> [  417.209070] XFS (dm-0): Unmount and run xfs_repair
> [  417.209662] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> [  417.210263] ffffbd6f5ba68000: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.210893] ffffbd6f5ba68010: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.211518] ffffbd6f5ba68020: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.212121] ffffbd6f5ba68030: aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa  ................
> [  417.212709] XFS (dm-0): metadata I/O error: block 0x108605a000
> ("xlog_recover_do..(read#2)") error 117 numblks 32
> [  417.213415] XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at
> line 143 of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller
> xfs_dir3_data_verify+0x9a/0xb0 [xfs]
> [  417.214652] CPU: 19 PID: 11323 Comm: mount Kdump: loaded Tainted: G
>           OE  ------------   3.10.0-1062.el7.x86_64 #1
> [  417.214653] Hardware name: Supermicro SYS-6028R-TR/X10DRi, BIOS
> 3.1b 05/16/2019
> [  417.214654] Call Trace:
> [  417.214663]  [<ffffffffa6779262>] dump_stack+0x19/0x1b
> [  417.214680]  [<ffffffffc06af26b>] xfs_error_report+0x3b/0x40 [xfs]
> [  417.214690]  [<ffffffffc069192a>] ? xfs_dir3_data_verify+0x9a/0xb0 [xfs]
> [  417.214700]  [<ffffffffc0691779>] __xfs_dir3_data_check+0x4b9/0x5d0 [xfs]
> [  417.214710]  [<ffffffffc069192a>] xfs_dir3_data_verify+0x9a/0xb0 [xfs]
> [  417.214719]  [<ffffffffc0691971>] xfs_dir3_data_write_verify+0x31/0xc0 [xfs]
> [  417.214730]  [<ffffffffc06acc9e>] ?
> xfs_buf_delwri_submit_buffers+0x12e/0x240 [xfs]
> [  417.214740]  [<ffffffffc06aada7>] _xfs_buf_ioapply+0x97/0x460 [xfs]
> [  417.214744]  [<ffffffffa60da0b0>] ? wake_up_state+0x20/0x20
> [  417.214754]  [<ffffffffc06acc9e>] ?
> xfs_buf_delwri_submit_buffers+0x12e/0x240 [xfs]
> [  417.214764]  [<ffffffffc06ac8c1>] __xfs_buf_submit+0x61/0x210 [xfs]
> [  417.214773]  [<ffffffffc06acc9e>]
> xfs_buf_delwri_submit_buffers+0x12e/0x240 [xfs]
> [  417.214783]  [<ffffffffc06ad97c>] ? xfs_buf_delwri_submit+0x3c/0xf0 [xfs]
> [  417.214793]  [<ffffffffc06ad97c>] xfs_buf_delwri_submit+0x3c/0xf0 [xfs]
> [  417.214806]  [<ffffffffc06daa9e>] xlog_do_recovery_pass+0x3ae/0x6e0 [xfs]
> [  417.214819]  [<ffffffffc06dae59>] xlog_do_log_recovery+0x89/0xd0 [xfs]
> [  417.214830]  [<ffffffffc06daed1>] xlog_do_recover+0x31/0x180 [xfs]
> [  417.214842]  [<ffffffffc06dbfef>] xlog_recover+0xbf/0x190 [xfs]
> [  417.214854]  [<ffffffffc06ce58f>] xfs_log_mount+0xff/0x310 [xfs]
> [  417.214866]  [<ffffffffc06c51b0>] xfs_mountfs+0x520/0x8e0 [xfs]
> [  417.214877]  [<ffffffffc06c82a0>] xfs_fs_fill_super+0x410/0x550 [xfs]
> [  417.214881]  [<ffffffffa624c893>] mount_bdev+0x1b3/0x1f0
> [  417.214892]  [<ffffffffc06c7e90>] ?
> xfs_test_remount_options.isra.12+0x70/0x70 [xfs]
> [  417.214903]  [<ffffffffc06c6aa5>] xfs_fs_mount+0x15/0x20 [xfs]
> [  417.214905]  [<ffffffffa624d1fe>] mount_fs+0x3e/0x1b0
> [  417.214908]  [<ffffffffa626b377>] vfs_kern_mount+0x67/0x110
> [  417.214910]  [<ffffffffa626dacf>] do_mount+0x1ef/0xce0
> [  417.214913]  [<ffffffffa624521a>] ? __check_object_size+0x1ca/0x250
> [  417.214916]  [<ffffffffa622368c>] ? kmem_cache_alloc_trace+0x3c/0x200
> [  417.214918]  [<ffffffffa626e903>] SyS_mount+0x83/0xd0
> [  417.214921]  [<ffffffffa678bede>] system_call_fastpath+0x25/0x2a
> [  417.214932] XFS (dm-0): Metadata corruption detected at
> xfs_dir3_data_write_verify+0xad/0xc0 [xfs], xfs_dir3_data block
> 0x19060071f8
> [  417.216244] XFS (dm-0): Unmount and run xfs_repair
> [  417.216901] XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> [  417.217550] ffff98b8b5edc000: 58 44 44 33 1f 58 d3 06 00 00 00 19
> 06 00 71 f8  XDD3.X........q.
> [  417.218208] ffff98b8b5edc010: 00 00 00 01 00 11 d1 0e 77 df d5 2b
> c0 8a 44 38  ........w..+..D8
> [  417.218864] ffff98b8b5edc020: b6 6b 44 d5 a5 17 96 e6 00 00 00 19
> 06 00 d6 85  .kD.............
> [  417.219527] ffff98b8b5edc030: 07 30 08 d0 00 40 00 20 00 00 00 00
> 00 00 20 00  .0...@. ...... .
> [  417.220203] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line
> 1393 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffc06aadd7
> [  417.220205] XFS (dm-0): Corruption of in-memory data detected.
> Shutting down filesystem
> [  417.220897] XFS (dm-0): Please umount the filesystem and rectify
> the problem(s)
>
> I would try to umount, but the mount command has hung. Ctrl-C does not
> kill it. I can see it in `ps aux`, but it’s not using any CPU. `kill
> -9 [pid]` does not kill the process. At this point I can only reboot
> to kill off the hung mount process.
>
> If I try to run xfs_repair before trying to mount it, it says:
>
> $ xfs_repair -l /dev/md/nvme2 /dev/volgrp4TB/lvol4TB
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using external log on /dev/md/nvme2
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
>
> If I try to run xfs_repair after trying to mount it, it says:
>
> $ xfs_repair -l /dev/md/nvme2 /dev/volgrp4TB/lvol4TB
> xfs_repair: cannot open /dev/volgrp4TB/lvol4TB: Device or resource busy
>
> I can see in arcconf that the array is rebuilding.
>
> I did the “echo w > /proc/sysrq-trigger” and captured the output of
> dmesg, attached to this email.
>
> Here’s most of the details that are requested at
> https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> $ uname -a
> Linux hostname1.localdomain 3.10.0-1062.el7.x86_64 #1 SMP Wed Aug 7
> 18:08:02 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
>
> $ xfs_repair -V
> xfs_repair version 4.5.0
>
> $ cat /proc/cpuinfo | grep processor | wc -l
> 56
>
> $ cat /proc/meminfo
> MemTotal:       263856296 kB
> MemFree:        261564216 kB
> MemAvailable:   261016076 kB
> Buffers:            4444 kB
> Cached:           183392 kB
> SwapCached:            0 kB
> Active:           109128 kB
> Inactive:         147332 kB
> Active(anon):      69304 kB
> Inactive(anon):     9992 kB
> Active(file):      39824 kB
> Inactive(file):   137340 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       4194300 kB
> SwapFree:        4194300 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:         68780 kB
> Mapped:            29312 kB
> Shmem:             10568 kB
> Slab:             146228 kB
> SReclaimable:      44360 kB
> SUnreclaim:       101868 kB
> KernelStack:       10176 kB
> PageTables:         5712 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    136122448 kB
> Committed_AS:     370852 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      712828 kB
> VmallocChunk:   34224732156 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:     14336 kB
> CmaTotal:              0 kB
> CmaFree:               0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:      288568 kB
> DirectMap2M:     6940672 kB
> DirectMap1G:    263192576 kB
>
> $ cat /proc/partitions
> major minor  #blocks  name
>    8       16 1953514584 sdb
>    8       17 1895636992 sdb1
>    8       18   52428800 sdb2
>    8        0 1953514584 sda
>    8        1     204800 sda1
>    8        2    1047552 sda2
>    8        3 1895636992 sda3
>    8        4   52428800 sda4
>    8        5    4194304 sda5
>    9      127   52395008 md127
>    8       32 41023425112 sdc
>    8       48 41023425112 sdd
>    8       64 27348895576 sde
>    8       80 27348895576 sdf
>    8       96 27348895576 sdg
> 259        1  244198584 nvme0n1
> 259        4   61048832 nvme0n1p1
> 259        6   61049856 nvme0n1p2
> 259        8   61048832 nvme0n1p3
> 259        9   61049856 nvme0n1p4
> 259        0  244198584 nvme1n1
> 259        2   61048832 nvme1n1p1
> 259        3   61049856 nvme1n1p2
> 259        5   61048832 nvme1n1p3
> 259        7   61049856 nvme1n1p4
>    9      126 1895504896 md126
>    9      125   61016064 md125
>    9      124   61015040 md124
>    9      123   61016064 md123
>    9      122   61015040 md122
> 253        0 82046681088 dm-0
> 253        1 82046844928 dm-1
>
> $ xfs_info /dev/volgrp4TB/
> xfs_info: /dev/volgrp4TB/ is not a mounted XFS filesystem
>
> Bart
> 206-550-2606 cell, textable
