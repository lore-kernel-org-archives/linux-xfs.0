Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42972 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754714AbdAEUBm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jan 2017 15:01:42 -0500
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
 <20170105191316.GD17846@birch.djwong.org>
 <CABPa+v2t_wF-n55GWRcHL7D3_ANcLqaDx1qa5SQ07pU7CgomXg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0e31b8db-9721-f735-7e29-0eaae5fd21eb@sandeen.net>
Date: Thu, 5 Jan 2017 14:01:40 -0600
MIME-Version: 1.0
In-Reply-To: <CABPa+v2t_wF-n55GWRcHL7D3_ANcLqaDx1qa5SQ07pU7CgomXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xingbo Wu <wuxb45@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/5/17 1:58 PM, Xingbo Wu wrote:
> On Thu, Jan 5, 2017 at 1:13 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> On Thu, Jan 05, 2017 at 12:58:23PM -0600, Eric Sandeen wrote:
>>> On 1/5/17 12:02 PM, Xingbo Wu wrote:
>>>> /dev/sdf is a 3TB hard drive.
>>>> It has 2930266584 blocks, as reported in `badblocks -wsv /dev/sdf`:
>>>> Checking for bad blocks in read-write mode
>>>> From block 0 to 2930266583
>>>
>>> 2930266583 x 1024 == 3000592980992
>>>
>>> I'd rather see what /proc/partitions and/or blockdev says about it...
>>
>> From the badblocks manpage,
>>
>> "-b block_size: Specify the size of blocks in bytes.  The default is 1024."
>>
>> (So far so good.)
>>
>>>> However mkfs.xfs reports a larger block count:
>>>> `sudo mkfs.xfs /dev/sdf`:
>>>> meta-data=/dev/sdf               isize=512    agcount=4, agsize=183141662 blks
>>>>          =                       sectsz=4096  attr=2, projid32bit=1
>>>>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
>>>> data     =                       bsize=4096   blocks=732566646, imaxpct=5
>>>>          =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>>> log      =internal log           bsize=4096   blocks=357698, version=2
>>>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>
>>> 732566646 x 4k blocks == 3000592982016 bytes
>>>
>>> Ok, that is 1024 bytes bigger.  But the weird thing is that
>>> mkfs.xfs actually writes the last block, and fails if that fails.
>>>
>>> So let's start with what /proc/partitions says, as well as
>>>
>>> # blkdev --getsize --getsize64 /dev/sdf
>>>
>>> -Eric
>>>
>>>> It later leads to IO error:
>>>> `dmesg`:
>>>> [1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
>>>> [1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664
>>
>> The kernel complains about "sector 2930266664", which is in 512-byte blocks.
>>
>> 2930266664 * 512 = 1500296531968, or halfway across your 3TB disk.
>>
>> Makes sense since the log generally ends up halfway across the disk.
>> Not sure if there's any output before 1807875.741674 but this sort of
>> looks like a disk error or something?
>>
> 
> I grepped "sdf" from dmesg:
> [    7.158847] sd 0:0:6:0: [sdf] 5860533168 512-byte logical blocks:
> (3.00 TB/2.73 TiB)
> [    7.158851] sd 0:0:6:0: [sdf] 4096-byte physical blocks
> [    7.259937] sd 0:0:6:0: [sdf] Write Protect is off
> [    7.259943] sd 0:0:6:0: [sdf] Mode Sense: 9b 00 10 08
> [    7.282316] sd 0:0:6:0: [sdf] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [    7.418959] sd 0:0:6:0: [sdf] Attached SCSI disk
> [1807850.471959] XFS (sdf): Mounting V5 Filesystem
> [1807850.605057] XFS (sdf): Ending clean mount
> [1807875.741657] sd 0:0:6:0: [sdf] tag#0 UNKNOWN(0x2003) Result:
> hostbyte=0x07 driverbyte=0x00
> [1807875.741670] sd 0:0:6:0: [sdf] tag#0 CDB: opcode=0x8a 8a 08 00 00
> 00 00 ae a8 52 28 00 00 00 08 00 00
> [1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
> [1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664

Your disk is failing.  To solve this, get a new disk.

-Eric

> [1807875.742306] XFS (sdf): metadata I/O error: block 0xaea85228
> ("xlog_iodone") error 5 numblks 64
> [1807875.742369] XFS (sdf): xfs_do_force_shutdown(0x2) called from
> line 1200 of file fs/xfs/xfs_log.c.  Return address =
> 0xffffffffa024090c
> 
> Earlier I tried to format the disk with ext4. It also had similar
> errors. I thought it was the disk's problem. Would that be something
> wrong with mkfs' math? I will try ext4 again and let you know if I
> found something relevant.
> 
