Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hacer.buildnet.ru ([91.214.224.3]:57637 "EHLO hacer.buildnet.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdL0ImJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Dec 2017 03:42:09 -0500
Received: from [185.29.130.2] (helo=[172.23.197.12])
        by hacer.buildnet.ru with esmtpa (Exim 4.72)
        (envelope-from <nnovikov@binmail.ru>)
        id 1eU7Hq-0005Vz-BA
        for linux-xfs@vger.kernel.org; Wed, 27 Dec 2017 12:42:06 +0400
Subject: Re: Metadata corruption
References: <99f455cd-4773-a051-98ff-2cd25fbb5fca@binmail.ru>
 <da1613f0-9dc3-1605-317d-f162ff92d97a@sandeen.net>
From: Nickolay Novikov <nnovikov@binmail.ru>
Message-ID: <dbe73b16-d17d-47bb-5122-74aab1636963@binmail.ru>
Date: Wed, 27 Dec 2017 11:42:00 +0300
MIME-Version: 1.0
In-Reply-To: <da1613f0-9dc3-1605-317d-f162ff92d97a@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

|I have xfs_repair output from another host with similar problem: # 
xfs_repair /dev/md20 Phase 1 - find and verify superblock... Phase 2 - 
using internal log - zero log... ERROR: The filesystem has valuable 
metadata changes in a log which needs to be replayed. Mount the 
filesystem to replay the log, and unmount it before re-running 
xfs_repair. If you are unable to mount the filesystem, then use the -L 
option to destroy the log and attempt a repair. Note that destroying the 
log may cause corruption -- please attempt a mount of the filesystem 
before doing this. # mount /dev/md20 # umount /dev/md20 # xfs_repair 
/dev/md20 Phase 1 - find and verify superblock... Phase 2 - using 
internal log - zero log... - scan filesystem freespace and inode maps... 
- found root inode chunk Phase 3 - for each AG... - scan and clear agi 
unlinked lists... - process known inodes and perform inode discovery... 
- agno = 0 - agno = 1 - agno = 2 - agno = 3 - agno = 4 - agno = 5 - agno 
= 6 - agno = 7 - process newly discovered inodes... Phase 4 - check for 
duplicate blocks... - setting up duplicate extent list... - check for 
inodes claiming duplicate blocks... - agno = 0 - agno = 1 - agno = 2 - 
agno = 3 - agno = 4 - agno = 5 - agno = 6 - agno = 7 Phase 5 - rebuild 
AG headers and trees... - reset superblock... Phase 6 - check inode 
connectivity... - resetting contents of realtime bitmap and summary 
inodes - traversing filesystem ... - traversal finished ... - moving 
disconnected inodes to lost+found ... Phase 7 - verify and correct link 
counts... done |


On 26.12.2017 22:34, Eric Sandeen wrote:
>
> On 12/25/17 3:33 AM, Nickolay Novikov wrote:
>> Hello!
>>
>> I have some servers with XFS metadata corruption. XFS works on softRAID devices (/dev/mdXX, RAID1, HDD). I try to find same errors in google, but search yielded no results :(
>>
>> What I can do for investigate this error?
> You have an inode block with corruption.  It's tough to say how
> it may have occurred, especially without knowing the nature
> of the corruption.
>
> You could use xfs_db to examine it, based on the xfs_inode
> block mentioned in the dmesg.
>
> To preserve the metadata for later analysis, you could first
> create an xfs_metadump image of the filesystem.
>
> Or,
>
>> Dec 25 11:39:15 srv701 kernel: [287080.544365] XFS (md25): Unmount and run xfs_repair
> and save the output, to see what is found.  You could run it
> with "-n" in a dry-run mode so that you don't commit to any
> changes.  You may need to mount/unmount it to replay the journal
> first.
>
> -Eric
>
>> Big thanks for any help.
>>
>>
>> Server info:
>>
>> Debian GNU/Linux 8.9 (jessie)
>> ii  linux-image-4.9.0-0.bpo.4-amd64 4.9.51-1~bpo8+1                  amd64        Linux 4.9 for 64-bit PCs
>>
>> Kernel log:
>>
>> Dec 25 11:39:15 srv701 kernel: [287080.542782] XFS (md25): Metadata corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode block 0x2ebd50
>> Dec 25 11:39:15 srv701 kernel: [287080.544365] XFS (md25): Unmount and run xfs_repair
>> Dec 25 11:39:15 srv701 kernel: [287080.545909] XFS (md25): First 64 bytes of corrupted metadata buffer:
>> Dec 25 11:39:15 srv701 kernel: [287080.547406] ffff8bae1cf22000: 2a 2e 19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
>> Dec 25 11:39:15 srv701 kernel: [287080.548962] ffff8bae1cf22010: 80 c9 d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
>> Dec 25 11:39:15 srv701 kernel: [287080.550554] ffff8bae1cf22020: 49 da 06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
>> Dec 25 11:39:15 srv701 kernel: [287080.552069] ffff8bae1cf22030: a6 91 43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

