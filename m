Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from dmzsha2062.multrix.com ([87.233.41.63]:15503 "EHLO
        dmzsha2062.multrix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753403AbdHQRP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 13:15:57 -0400
Subject: Re: Issue with "no space left on device"
References: <1502981688167.22881@true.nl>
 <20170817164751.GA62570@bfoster.bfoster>
From: Sander van Schie <sander.vanschie@true.nl>
Message-ID: <a3012e54-dc24-b069-a7a9-c235168d0499@true.nl>
Date: Thu, 17 Aug 2017 19:15:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170817164751.GA62570@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


On 17-08-17 18:47, Brian Foster wrote:
> On Thu, Aug 17, 2017 at 02:54:48PM +0000, Sander van Schie / True wrote:
>> Hello,
>>
>> I have a 35 GB XFS partition with both plenty of free space and inodes, but I'm still getting the error "No space left on device" when trying to create new files.
>>
>> Mount options:
>>
>> # mount | grep vdc1
>> /dev/vdc1 on /mnt type xfs (rw,relatime,attr2,inode64,noquota)
>>
>> Used disk space:
>>
>> # df /dev/vdc1
>> Filesystem     1K-blocks     Used Available Use% Mounted on
>> /dev/vdc1       36681200 16066576  20614624  44% /mnt
>>
>> Used inodes:
>>
>> # df -i /dev/vdc1
>> Filesystem     Inodes  IUsed  IFree IUse% Mounted on
>> /dev/vdc1      917440 199616 717824   22% /mnt
>>
>> xfs info:
>>
>> # xfs_info /dev/vdc1
>> meta-data=/dev/vdc1              isize=2048   agcount=4, agsize=2293695 blks
> 
> With 2k sized inodes, the most likely cause is free space fragmentation.
> What does 'xfs_db -c "freesp -s" <dev>' print for this fs?
> 
> Brian
> 

The output of the command is as follows:

# xfs_db -c "freesp -s" /dev/vdc1
    from      to extents  blocks    pct
       1       1      28      28   0,00
       2       3      50     149   0,00
       4       7     907    3799   0,07
       8      15    1369   12990   0,25
      16      31  183206 5126962  99,34
      32      63     492   17197   0,33
total free extents 186052
total free blocks 5161125
average free extent size 27,7402

(not sure what I'm looking at myself)


>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=1        finobt=1 spinodes=0
>> data     =                       bsize=4096   blocks=9174779, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal               bsize=4096   blocks=4479, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>>
>> I've already tried repairing and rebooting, which unfortunately didn't help.
>>
>> Any idea what's wrong?
>>
>> Thanks!
>>
>> - Sander--
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
