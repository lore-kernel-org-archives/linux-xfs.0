Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Nov 2006 07:35:03 -0800 (PST)
Received: from herkules.vie.weberhofer.at (85-124-132-100.work.xdsl-line.inode.at [85.124.132.100])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kARFYtaG019306
	for <xfs@oss.sgi.com>; Mon, 27 Nov 2006 07:34:57 -0800
Message-ID: <456AFF30.2060904@weberhofer.at>
Date: Mon, 27 Nov 2006 16:07:28 +0100
From: "Johannes Weberhofer, Weberhofer GmbH" <office@weberhofer.at>
MIME-Version: 1.0
Subject: Problem after removing SATA II disc without unmounting
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello!

I have a problem with an hard-disk which has been removed from a SATA II slot without being unmounted. After inserting the disk, a mount attempt results in:

server:~ # mount /backup/
mount: /dev/sdb1: can't read superblock

****************************************
xfs_check /dev/sdb1 does not show any error

****************************************
xfs_repair shows:
server:~ # xfs_repair /dev/sdb1
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
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - deleting existing "lost+found" entry
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
****************************************
in /var/log/message I can see:
Nov 27 10:00:01 server kernel: attempt to access beyond end of device
Nov 27 10:00:01 server kernel: sdb1: rw=0, want=781417600, limit=781401537
Nov 27 10:00:01 server kernel: I/O error in filesystem ("sdb1") meta-data dev sdb1 block 0x2e937c7f       ("xfs_read_buf") error 5 buf count 512
Nov 27 10:00:01 server kernel: XFS: size check 2 failed


****************************************
server:~ # cat /proc/partitions
major minor  #blocks  name

   8    16  390711384 sdb
   8    17  390700768 sdb1

****************************************


I have Opensuse with kernel kernel-default-2.6.16.21-0.25 running. Do you have any ideas/suggestions?

Best regards,
Johannes Weberhofer

-- 


|---------------------------------
|  weberhofer GmbH               | Johannes Weberhofer
|  information technologies, Austria
|
|  phone : +43 (0)1 5454421 0    | email: office@weberhofer.at
|  fax   : +43 (0)1 5454421 19   | web  : http://weberhofer.at
|  mobile: +43 (0)699 11998315
|----------------------------------------------------------->>
