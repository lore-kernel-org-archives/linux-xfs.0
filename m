Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 10:13:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84HDfED000431
	for <linux-xfs@oss.sgi.com>; Thu, 4 Sep 2008 10:13:44 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E95E3401EC8
	for <linux-xfs@oss.sgi.com>; Thu,  4 Sep 2008 10:15:07 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id vYPCudZEACc5YGjR for <linux-xfs@oss.sgi.com>; Thu, 04 Sep 2008 10:15:07 -0700 (PDT)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KbIQA-0001z2-N7
	for linux-xfs@oss.sgi.com; Thu, 04 Sep 2008 17:15:02 +0000
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 04 Sep 2008 17:15:02 +0000
Received: from bs by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 04 Sep 2008 17:15:02 +0000
From: Bernd Schubert <bs@q-leap.de>
Subject: xfs corruptions
Date: Thu, 04 Sep 2008 19:11:48 +0200
Message-ID: <g9p4sl$smg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello,

I'm presently debugging the error handler of the MPT fusion driver and
therefore causing errors on the disk (Infortrend scsi hardware raids).
When I later on try to delete files and directories having been created
before and during the failures, "rm -fr" simply says directory not empty.
No message in dmesg about it, but xfs_repair reports errors, see below.
Once xfs_repair has done its jobs, removing these directories works fine.
But this shouldn't happen, should it? This is with 2.6.26

root@beo-11:~# xfs_repair /dev/inf/box-3a/disc
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
imap claims a free inode 1073741964 is in use, correcting imap and clearing
inode
cleared inode 1073741964
        - agno = 2
imap claims a free inode 2147483788 is in use, correcting imap and clearing
inode
cleared inode 2147483788
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "9B769A18" in shortform directory 1073741962 references free inode
1073741964
junking entry "9B769A18" in directory inode 1073741962
        - agno = 2
entry "E95A1D2D" in shortform directory 2147483786 references free inode
2147483788
junking entry "E95A1D2D" in directory inode 2147483786
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...


Thanks,
Bernd
