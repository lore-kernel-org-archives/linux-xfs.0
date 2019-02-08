Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfBHNR7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Feb 2019 08:17:59 -0500
Date: Fri, 8 Feb 2019 08:17:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Metadata CRC error detected at xfs_dquot_buf_read_verify
Message-ID: <20190208131756.GD21317@bfoster>
References: <201902071309.38999.ricardo.barberis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201902071309.38999.ricardo.barberis@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Ricardo J. Barberis" <ricardo.barberis@gmail.com>
Cc: Linux-XFS list <linux-xfs@vger.kernel.org>

On Thu, Feb 07, 2019 at 01:09:38PM -0300, Ricardo J. Barberis wrote:
> Hello list!
> 
> I'm having a metadata corruption on an XFS filesystem, I googled the error but
> didn't find anything about it.
> 
> Background:
> 
> One CentOS 7.6 box with 2 SSD disks and 3 SATA disks.
> Those disks are synchorized via DRBD with 5 identical disks on another
> identical box (for HA).
> The SSDs form an LVM group with one VG and one LV.
> This LV is then formatted with XFS and mounted with quotas enabled.
> The SATA disks form another LVM group with one VG and one LV, also formatted
> with XFS and mounted quotas enabled.
> 
> Each pair of servers has keepalived to make sure only one of them puts the
> DRBD resources as primary and can mount the LVs.
> 
> Relevant extract from lsblk:
> sdb              8:16   0 931,5G  0 disk
> └─sdb1           8:17   0 931,5G  0 part
>   └─drbd2      147:2    0 931,5G  0 disk
>     └─VG2-home 253:4    0   1,8T  0 lvm  /home
> sdc              8:32   0 894,3G  0 disk
> └─sdc1           8:33   0 894,3G  0 part
>   └─drbd3      147:3    0 894,2G  0 disk
>     └─VG2-home 253:4    0   1,8T  0 lvm  /home
> sdd              8:48   0 931,5G  0 disk
> └─sdd1           8:49   0 931,5G  0 part
>   └─drbd4      147:4    0 931,5G  0 disk
>     └─VG3-mail 253:0    0   2,7T  0 lvm
>       └─mail   253:5    0   2,7T  0 dm   /Mails
> sde              8:64   0 931,5G  0 disk
> └─sde1           8:65   0 931,5G  0 part
>   └─drbd5      147:5    0 931,5G  0 disk
>     └─VG3-mail 253:0    0   2,7T  0 lvm
>       └─mail   253:5    0   2,7T  0 dm   /Mails
> sdf              8:80   0 931,5G  0 disk
> └─sdf1           8:81   0 931,5G  0 part
>   └─drbd6      147:6    0 931,5G  0 disk
>     └─VG3-mail 253:0    0   2,7T  0 lvm
>       └─mail   253:5    0   2,7T  0 dm   /Mails
> 
> 
> We have several pairs of servers with this same configuration, but on this
> particular pair of boxes we're getting metadata corruption only on the SSD LV
> and quotas don't get accounted for, dmesg shows these errors on the primary box:
> 

I assume there are different workloads between the two volumes as well,
based on the naming above at least, and that dm-4 is the VG2-home volume
above..?

Either way, can you provide the xfs_info for the associated filesystem?

> [root@c142a ~] # dmesg -T | grep XFS
> [mié feb  6 18:43:03 2019] SGI XFS with ACLs, security attributes, no debug enabled
> [mié feb  6 18:43:03 2019] XFS (dm-4): Mounting V5 Filesystem
> [mié feb  6 18:43:03 2019] XFS (dm-4): Starting recovery (logdev: internal)

What happened to require log recovery in the first place?

> [mié feb  6 18:43:04 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [mié feb  6 18:43:04 2019] XFS (dm-4): Unmount and run xfs_repair
> [mié feb  6 18:43:04 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [mié feb  6 18:43:04 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [mié feb  6 18:43:04 2019] XFS (dm-4): log mount/recovery failed: error -117
> [mié feb  6 18:43:04 2019] XFS (dm-4): log mount failed

So log recovery and the mount failed. Is this where you ran
xfs_repair?

> [mié feb  6 18:48:52 2019] XFS (dm-5): Mounting V5 Filesystem
> [mié feb  6 18:48:52 2019] XFS (dm-5): Ending clean mount
> [mié feb  6 18:48:59 2019] XFS (dm-5): Unmounting Filesystem
> [mié feb  6 18:57:25 2019] XFS (dm-4): Mounting V5 Filesystem
> [mié feb  6 18:57:25 2019] XFS (dm-4): Ending clean mount
> [mié feb  6 18:57:25 2019] XFS (dm-4): Quotacheck needed: Please wait.

Then the mount succeeds (repair presumably zapped the log), a quotacheck
was required and before that even completes we run into the same issue.

> [mié feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [mié feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
> [mié feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [mié feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [mié feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
> [mié feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [mié feb  6 18:57:26 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [mié feb  6 18:57:52 2019] XFS (dm-4): Quotacheck: Done.
> [mié feb  6 18:58:13 2019] XFS (dm-4): Unmounting Filesystem
> [mié feb  6 18:58:15 2019] XFS (dm-4): Mounting V5 Filesystem
> [mié feb  6 18:58:15 2019] XFS (dm-4): Ending clean mount
> [mié feb  6 18:58:27 2019] XFS (dm-4): Unmounting Filesystem
> [mié feb  6 19:01:12 2019] XFS (dm-5): Mounting V5 Filesystem
> [mié feb  6 19:01:12 2019] XFS (dm-5): Ending clean mount
> [mié feb  6 19:01:12 2019] XFS (dm-4): Mounting V5 Filesystem
> [mié feb  6 19:01:12 2019] XFS (dm-4): Ending clean mount
> [mié feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [mié feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
> [mié feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [mié feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [mié feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [mié feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
> [mié feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [mié feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> 
> 
> We tried xfs_repair but it doesn't seem to fix it.
> 

Does xfs_repair find and fix anything? Please show the associated repair
output.

> We then promoted the secondary and tried xfs_repair there, fearing some memory
> issues on the primary, but the result is the same:
> 

I'm not terribly familiar with drbd. I assume this means the primary was
offlined and the secondary onlined. IOW, these two filesystems are not
ever simultaneously active, correct?

Brian

> [root@c142b ~] # dmesg -T | grep XFS
> [jue ene 31 19:14:12 2019] SGI XFS with ACLs, security attributes, no debug enabled
> [jue ene 31 19:14:12 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:14:12 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:22:20 2019] XFS (dm-4): Unmounting Filesystem
> [jue ene 31 19:23:24 2019] XFS (dm-5): Mounting V5 Filesystem
> [jue ene 31 19:23:24 2019] XFS (dm-5): Ending clean mount
> [jue ene 31 19:23:24 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:23:24 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:25:21 2019] XFS (dm-4): Unmounting Filesystem
> [jue ene 31 19:26:14 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:26:14 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:26:14 2019] XFS (dm-4): Quotacheck needed: Please wait.
> [jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
> [jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
> [jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [jue ene 31 19:26:14 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [jue ene 31 19:26:40 2019] XFS (dm-4): Quotacheck: Done.
> [jue ene 31 19:34:31 2019] XFS (dm-5): Unmounting Filesystem
> [jue ene 31 19:35:13 2019] XFS (dm-4): Unmounting Filesystem
> [jue ene 31 19:46:33 2019] XFS (dm-5): Mounting V5 Filesystem
> [jue ene 31 19:46:34 2019] XFS (dm-5): Ending clean mount
> [jue ene 31 19:46:34 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:46:34 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:47:18 2019] XFS (dm-4): Unmounting Filesystem
> [jue ene 31 19:47:21 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:47:21 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:47:29 2019] XFS (dm-4): Unmounting Filesystem
> [jue ene 31 19:50:28 2019] XFS (dm-4): Mounting V5 Filesystem
> [jue ene 31 19:50:28 2019] XFS (dm-4): Ending clean mount
> [jue ene 31 19:50:28 2019] XFS (dm-4): Quotacheck needed: Please wait.
> [jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
> [jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
> [jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [jue ene 31 19:50:28 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [jue ene 31 19:50:54 2019] XFS (dm-4): Quotacheck: Done.
> 
> 
> This is a more complete extract of dmesg, where I noticed some context lines
> that might be useful:
> 
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [Thu Feb  7 12:06:45 2019] ffffa0002708a000: 44 51 01 01 00 00 d7 82 00 00 00 00 00 00 00 00  DQ..............
> [Thu Feb  7 12:06:45 2019] ffffa0002708a010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] ffffa0002708a020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] ffffa0002708a030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [Thu Feb  7 12:06:45 2019] ffffa003bdb3b000: 44 51 01 01 00 00 d7 82 00 00 00 00 00 00 00 00  DQ..............
> [Thu Feb  7 12:06:45 2019] ffffa003bdb3b010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] ffffa003bdb3b020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] ffffa003bdb3b030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [Thu Feb  7 13:03:43 2019] ffffa001427e8000: 44 51 01 01 00 00 d7 82 00 00 00 00 00 00 00 00  DQ..............
> [Thu Feb  7 13:03:43 2019] ffffa001427e8010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] ffffa001427e8020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] ffffa001427e8030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [Thu Feb  7 13:03:43 2019] ffffa004a3ef1000: 44 51 01 01 00 00 d7 82 00 00 00 00 00 00 00 00  DQ..............
> [Thu Feb  7 13:03:43 2019] ffffa004a3ef1010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] ffffa004a3ef1020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] ffffa004a3ef1030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> 
> 
> Is there anything else I can try?
> Any more info needed?
> Should I open a bug report instead?
> 
> I can compile a newr version of xfsprogs but I don't know if it'll help.
> 
> 
> Thanks,
> -- 
> Ricardo J. Barberis
> Usuario Linux Nº 250625: http://counter.li.org/
> Usuario LFS Nº 5121: http://www.linuxfromscratch.org/
> Senior SysAdmin / IT Architect - www.DonWeb.com
