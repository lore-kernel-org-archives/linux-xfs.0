Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35786 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757318AbdAET7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 14:59:23 -0500
Received: by mail-io0-f195.google.com with SMTP id f73so63889571ioe.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2017 11:59:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170105191316.GD17846@birch.djwong.org>
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net> <20170105191316.GD17846@birch.djwong.org>
From: Xingbo Wu <wuxb45@gmail.com>
Date: Thu, 5 Jan 2017 13:58:26 -0600
Message-ID: <CABPa+v2t_wF-n55GWRcHL7D3_ANcLqaDx1qa5SQ07pU7CgomXg@mail.gmail.com>
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Thu, Jan 5, 2017 at 1:13 PM, Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
> On Thu, Jan 05, 2017 at 12:58:23PM -0600, Eric Sandeen wrote:
>> On 1/5/17 12:02 PM, Xingbo Wu wrote:
>> > /dev/sdf is a 3TB hard drive.
>> > It has 2930266584 blocks, as reported in `badblocks -wsv /dev/sdf`:
>> > Checking for bad blocks in read-write mode
>> > From block 0 to 2930266583
>>
>> 2930266583 x 1024 =3D=3D 3000592980992
>>
>> I'd rather see what /proc/partitions and/or blockdev says about it...
>
> From the badblocks manpage,
>
> "-b block_size: Specify the size of blocks in bytes.  The default is 1024=
."
>
> (So far so good.)
>
>> > However mkfs.xfs reports a larger block count:
>> > `sudo mkfs.xfs /dev/sdf`:
>> > meta-data=3D/dev/sdf               isize=3D512    agcount=3D4, agsize=
=3D183141662 blks
>> >          =3D                       sectsz=3D4096  attr=3D2, projid32bi=
t=3D1
>> >          =3D                       crc=3D1        finobt=3D1, sparse=
=3D0, rmapbt=3D0
>> > data     =3D                       bsize=3D4096   blocks=3D732566646, =
imaxpct=3D5
>> >          =3D                       sunit=3D0      swidth=3D0 blks
>> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=
=3D1
>> > log      =3Dinternal log           bsize=3D4096   blocks=3D357698, ver=
sion=3D2
>> >          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy=
-count=3D1
>> > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextent=
s=3D0
>>
>> 732566646 x 4k blocks =3D=3D 3000592982016 bytes
>>
>> Ok, that is 1024 bytes bigger.  But the weird thing is that
>> mkfs.xfs actually writes the last block, and fails if that fails.
>>
>> So let's start with what /proc/partitions says, as well as
>>
>> # blkdev --getsize --getsize64 /dev/sdf
>>
>> -Eric
>>
>> > It later leads to IO error:
>> > `dmesg`:
>> > [1807875.741674] blk_update_request: I/O error, dev sdf, sector 293026=
6664
>> > [1807875.741732] blk_update_request: I/O error, dev sdf, sector 293026=
6664
>
> The kernel complains about "sector 2930266664", which is in 512-byte bloc=
ks.
>
> 2930266664 * 512 =3D 1500296531968, or halfway across your 3TB disk.
>
> Makes sense since the log generally ends up halfway across the disk.
> Not sure if there's any output before 1807875.741674 but this sort of
> looks like a disk error or something?
>

I grepped "sdf" from dmesg:
[    7.158847] sd 0:0:6:0: [sdf] 5860533168 512-byte logical blocks:
(3.00 TB/2.73 TiB)
[    7.158851] sd 0:0:6:0: [sdf] 4096-byte physical blocks
[    7.259937] sd 0:0:6:0: [sdf] Write Protect is off
[    7.259943] sd 0:0:6:0: [sdf] Mode Sense: 9b 00 10 08
[    7.282316] sd 0:0:6:0: [sdf] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.418959] sd 0:0:6:0: [sdf] Attached SCSI disk
[1807850.471959] XFS (sdf): Mounting V5 Filesystem
[1807850.605057] XFS (sdf): Ending clean mount
[1807875.741657] sd 0:0:6:0: [sdf] tag#0 UNKNOWN(0x2003) Result:
hostbyte=3D0x07 driverbyte=3D0x00
[1807875.741670] sd 0:0:6:0: [sdf] tag#0 CDB: opcode=3D0x8a 8a 08 00 00
00 00 ae a8 52 28 00 00 00 08 00 00
[1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
[1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664
[1807875.742306] XFS (sdf): metadata I/O error: block 0xaea85228
("xlog_iodone") error 5 numblks 64
[1807875.742369] XFS (sdf): xfs_do_force_shutdown(0x2) called from
line 1200 of file fs/xfs/xfs_log.c.  Return address =3D
0xffffffffa024090c

Earlier I tried to format the disk with ext4. It also had similar
errors. I thought it was the disk's problem. Would that be something
wrong with mkfs' math? I will try ext4 again and let you know if I
found something relevant.

--=20

Regards,
        Wu, Xingbo (=E5=90=B4=E5=85=B4=E5=8D=9A)  <wuxb45@gmail.com>
