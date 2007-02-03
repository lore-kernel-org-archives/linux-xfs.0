Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 03 Feb 2007 10:25:16 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l13IPAqw009923
	for <xfs@oss.sgi.com>; Sat, 3 Feb 2007 10:25:11 -0800
Received: by ug-out-1314.google.com with SMTP id a2so1034036ugf
        for <xfs@oss.sgi.com>; Sat, 03 Feb 2007 10:24:12 -0800 (PST)
Message-ID: <f0e429340702030959r7b8b815sb58c01238c19495e@mail.gmail.com>
Date: Sat, 3 Feb 2007 18:59:29 +0100
From: "KE Liew" <ke.liew@gmail.com>
Subject: bad magic and dubious inode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

It's been a great day, and this is the situation. Files were being
transfered from one hdd to another, SATA to IDE, and BANG and error
occured, can't remember exactly what, but I had to umount it.
Successful, and ran xfs_check

====================
eXiStEnCe:~# xfs_check -s /dev/hdb
bad magic # 0 in inobt block 15/916145
====================

Doesn't look good at all. I attempted the famous xfs_repair :)

====================
eXiStEnCe:~# xfs_repair -n /dev/hdb
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
bad magic # 0 in inobt block 15/916145
dubious inode btree block header 15/916145
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
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
No modify flag set, skipping phase 5
Inode allocation btrees are too corrupted, skipping phases 6 and 7
No modify flag set, skipping filesystem flush and exiting.
====================

As you can see, it's almost dead? I haven't mount it yet, so I hope
it's all safe and cool. What should be the next step for me to take?



Kwang
