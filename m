Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34876 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbcIVG26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2016 02:28:58 -0400
Received: by mail-wm0-f44.google.com with SMTP id l132so307714916wmf.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2016 23:28:57 -0700 (PDT)
MIME-Version: 1.0
From: Simon Becks <beckssimon5@gmail.com>
Date: Thu, 22 Sep 2016 08:28:55 +0200
Message-ID: <CAKA=zHrnLZj2FitHtZEsrWHYjQZ_XpMeuea+OF2ADCF9ea13tg@mail.gmail.com>
Subject: restore files from xfs on top of rebuild raid5
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Good morning,

i was stupid enough to format my raid5 disks with xfs and broke the
raid instantly :/

Now i tried to rebuild the raid5 with 3 disks but have issues to
restore the filesystem on top or even restore files with photorec.

Any help is greatly appreciated. Some details:

The old raid was in the form (sda6, sdb6, sdc6):

/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 342ec726:3804270d:5917dd5f:c24883a9
           Name : TS-XLB6C:2
  Creation Time : Fri Dec 23 17:58:59 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 1923497952 (917.20 GiB 984.83 GB)
     Array Size : 1923496960 (1834.39 GiB 1969.66 GB)
  Used Dev Size : 1923496960 (917.19 GiB 984.83 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=992 sectors
          State : active
    Device UUID : d27a69d0:456f3704:8e17ac75:78939886

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 27 19:08:08 2016
       Checksum : de9dbd10 - correct
         Events : 11543

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

As all md superblocks were gone, i recreated it and got:

/dev/mapper/sdb6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da61174d:9567c4df:fcea79f1:38024893
           Name : grml:42  (local to host grml)
  Creation Time : Thu Sep 22 05:14:11 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 1923497952 (917.20 GiB 984.83 GB)
     Array Size : 1923496960 (1834.39 GiB 1969.66 GB)
  Used Dev Size : 1923496960 (917.19 GiB 984.83 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=992 sectors
          State : clean
    Device UUID : d0c61415:186b446b:ca34a8c6:69ed5b18

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Sep 22 05:14:11 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bba25a31 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0

Now i tried xfs_repair on the raid but got:


>> root@grml ~ # xfs_repair /dev/md42
>> Phase 1 - find and verify superblock...
>> bad primary superblock - bad magic number !!!
>>
>> attempting to find secondary superblock...
>> ...........................................
>> found candidate secondary superblock...
>> unable to verify superblock, continuing...
>> found candidate secondary superblock...
>> error reading superblock 22 -- seek to offset 2031216754688 failed
>> unable to verify superblock, continuing...
>> found candidate secondary superblock...
>> unable to verify superblock, continuing...
>> ..found candidate secondary superblock...
>> verified secondary superblock...
>> writing modified primary superblock
>>         - reporting progress in intervals of 15 minutes
>> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
>> calculated value 2048
>> resetting superblock root inode pointer to 2048
>> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
>
> Those big ones strike me as imaginary numbers.
>
>> with calculated value 2049
>> resetting superblock realtime bitmap ino pointer to 2049
>> sb realtime summary inode 18446744073709551615 (NULLFSINO)
>> inconsistent with calculated value 2050
>> resetting superblock realtime summary ino pointer to 2050
>> Phase 2 - using internal log
>>         - zero log...
>> totally zeroed log
>>         - scan filesystem freespace and inode maps...
>> bad magic number
>> bad magic number
>> bad magic number
>> Metadata corruption detected at block 0x8/0x1000
>> bad magic number
>> Metadata corruption detected at block 0x23d3f408/0x1000
>> bad magic numberbad magic number
>>
>> Metadata corruption detected at block 0x2afe5808/0x1000
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> bad magic number
>> Metadata corruption detected at block 0x10/0x1000
>> Metadata corruption detected at block 0xe54c808/0x1000
>> bad magic # 0x494e81f6 for agf 0
>> bad version # 16908289 for agf 0
>> bad sequence # 99 for agf 0
>> bad length 99 for agf 0, should be 15027328
>> flfirst 1301384768 in agf 0 too large (max = 1024)
>> bad magic # 0x494e81f6 for agi 0
>> bad version # 16908289 for agi 0
>> bad sequence # 99 for agi 0
>> bad length # 99 for agi 0, should be 15027328
>> reset bad agf for ag 0
>> reset bad agi for ag 0
>> Metadata corruption detected at block 0xd6f7b808/0x1000
>> Metadata corruption detected at block 0x2afe5810/0x1000
>> bad on-disk superblock 6 - bad magic number
>> primary/secondary superblock 6 conflict - AG superblock geometry info
>> conflicts with filesystem geometry
>> zeroing unused portion of secondary superblock (AG #6)
>> [1]    23110 segmentation fault  xfs_repair /dev/md42


But it ends with a segfault. How screwed am I? Am i even on the right
track with the underlying raid?

thank you.

simon
