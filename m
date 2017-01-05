Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34166 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965560AbdAETEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 14:04:42 -0500
Received: by mail-io0-f196.google.com with SMTP id n85so37401000ioi.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2017 11:04:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
From: Xingbo Wu <wuxb45@gmail.com>
Date: Thu, 5 Jan 2017 13:04:01 -0600
Message-ID: <CABPa+v1ScWZdrTNRvDtS=ni7xFan7=bCqg6m9qJa7cwAoYw-AQ@mail.gmail.com>
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 5, 2017 at 12:58 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/5/17 12:02 PM, Xingbo Wu wrote:
>> /dev/sdf is a 3TB hard drive.
>> It has 2930266584 blocks, as reported in `badblocks -wsv /dev/sdf`:
>> Checking for bad blocks in read-write mode
>> From block 0 to 2930266583
>
> 2930266583 x 1024 =3D=3D 3000592980992
>
> I'd rather see what /proc/partitions and/or blockdev says about it...
>

$ cat /proc/partitions
major minor  #blocks  name

   8        0  244198584 sda
   8        1   31457280 sda1
   8        2  212740096 sda2
   8       48 3907018584 sdd
   8       64 3907018584 sde
   8       32 1953514584 sdc
   8       16 1953514584 sdb
   8       80 2930266584 sdf


>> However mkfs.xfs reports a larger block count:
>> `sudo mkfs.xfs /dev/sdf`:
>> meta-data=3D/dev/sdf               isize=3D512    agcount=3D4, agsize=3D=
183141662 blks
>>          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
>>          =3D                       crc=3D1        finobt=3D1, sparse=3D0=
, rmapbt=3D0
>> data     =3D                       bsize=3D4096   blocks=3D732566646, im=
axpct=3D5
>>          =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
>> log      =3Dinternal log           bsize=3D4096   blocks=3D357698, versi=
on=3D2
>>          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-c=
ount=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>
> 732566646 x 4k blocks =3D=3D 3000592982016 bytes
>
> Ok, that is 1024 bytes bigger.  But the weird thing is that
> mkfs.xfs actually writes the last block, and fails if that fails.
>
> So let's start with what /proc/partitions says, as well as
>
> # blkdev --getsize --getsize64 /dev/sdf
>

The machines runs a up-to-dated Archlinux with Kernel 4.8.13 (64bit)
I didn't found blkdev but instead found blockdev in package
util-linux. It looks the samething.
$ sudo blockdev --getsize --getsize64 /dev/sdf
5860533168
3000592982016

> -Eric
>
>> It later leads to IO error:
>> `dmesg`:
>> [1807875.741674] blk_update_request: I/O error, dev sdf, sector 29302666=
64
>> [1807875.741732] blk_update_request: I/O error, dev sdf, sector 29302666=
64
>> [1807875.742306] XFS (sdf): metadata I/O error: block 0xaea85228
>> ("xlog_iodone") error 5 numblks 64
>> [1807875.742369] XFS (sdf): xfs_do_force_shutdown(0x2) called from
>> line 1200 of file fs/xfs/xfs_log.c.  Return address =3D
>> 0xffffffffa024090c
>> [1807875.742381] XFS (sdf): Log I/O Error Detected.  Shutting down files=
ystem
>> [1807875.742416] XFS (sdf): xfs_log_force: error -5 returned.
>> [1807875.742426] XFS (sdf): Please umount the filesystem and rectify
>> the problem(s)
>> [1807881.868117] XFS (sdf): xfs_log_force: error -5 returned.
>> [1807910.701836] XFS (sdf): xfs_log_force: error -5 returned.
>> [1807910.701841] XFS (sdf): Unmounting Filesystem
>> [1807910.701854] XFS (sdf): xfs_log_force: error -5 returned.
>> [1807910.701866] XFS (sdf): xfs_log_force: error -5 returned.
>>
>>
>>
>> The hard drive information:
>> Model Family:     Seagate Barracuda 7200.14 (AF)
>> Device Model:     ST3000DM001-9YN166
>> Serial Number:    W1F03GXY
>>



--=20

Regards,
        Wu, Xingbo (=E5=90=B4=E5=85=B4=E5=8D=9A)  <wuxb45@gmail.com>
