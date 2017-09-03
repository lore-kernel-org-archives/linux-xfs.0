Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25459 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752817AbdICCsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 22:48:40 -0400
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: error: "Your hard drive is failing" ???
Message-ID: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
Date: Sat, 2 Sep 2017 19:48:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear Xfs,

Scientific Linux 7.3

$ rpm -qa \*xfsdump\*
xfsdump-3.1.4-1.el7.x86_64


When I do a backup to /dev/sda1 (/lin-bak), I get told

     WARNING: Your hard drive is failing
     Device: /dev/sda [SAT], unable to open device

xfs_repair finda nothing wrong with /dev/sda1.
gsmartcontrol -- both the long and short test -- find
nothing either.

Any words of wisdom?  Is this a false positive?


Many thanks,
-T

/home
      /dev/dm-2
      xfs
      RAID 1 and resides on an LSI 3ware LSI00216 SAS 9750-4i

/lin-bak
     /dev/sda1


/usr/sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f 
/lin-bak/2017-09-02_13-59-28_homeXfsDump  /home
/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.1.4 (dump format 3.0) - type ^C for status 
and control
/usr/sbin/xfsdump: level 0 dump of rn4.rent-a-nerd.local:/home
/usr/sbin/xfsdump: dump date: Sat Sep  2 13:59:36 2017
/usr/sbin/xfsdump: session id: bcaf0ce7-e742-41bc-ad9d-2db722c69e74
/usr/sbin/xfsdump: session label: "1"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 659337362880 bytes
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
WARNING: Your hard drive is failing
Device: /dev/sda [SAT], unable to open device

umount: /lin-bak (/dev/mapper/lin-bak) unmounted
/sbin/xfs_repair /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 1
         - agno = 3
         - agno = 2
         - agno = 0
Phase 5 - rebuild AG headers and trees...
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

/lin-bak dismounted
           starting capacaity (used space): 65%
           stopping capacaity (used space): 68% Remaining space: 620224 MB

