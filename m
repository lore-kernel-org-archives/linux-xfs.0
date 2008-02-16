Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 14:41:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1GMfHSM032230
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 14:41:19 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCED8E423E2
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 14:41:42 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id yL86umnSDt22cqaC for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 14:41:42 -0800 (PST)
Date: Sat, 16 Feb 2008 23:41:42 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080216074019.GV155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, 16 Feb 2008, David Chinner wrote:

> had time. The patch below should fix the problem - mkfs.xfs is writing
> the features2 field to the wrong location in the superblock, and
> this patch detects and corrects it. You'll probably see the output:

I would like to ask if correcting the feature2 field can lead to this
message?:
# xfs_check /dev/system/mnt
sb_fdblocks 190009, counted 191033
sb_fdblocks 190009, aggregate AGF count 191033

"local" is copy (dd) of other corrected FS
# xfs_check local
sb_fdblocks 163441, counted 165489
sb_fdblocks 163441, aggregate AGF count 165489
# xfs_repair -v local
Phase 1 - find and verify superblock...
        - block cache size set to 96240 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 120967 tail block 120967
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
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Sat Feb 16 23:31:16 2008

Phase           Start           End             Duration
Phase 1:        02/16 23:31:10  02/16 23:31:10
Phase 2:        02/16 23:31:10  02/16 23:31:13  3 seconds
Phase 3:        02/16 23:31:13  02/16 23:31:15  2 seconds
Phase 4:        02/16 23:31:15  02/16 23:31:16  1 second
Phase 5:        02/16 23:31:16  02/16 23:31:16
Phase 6:        02/16 23:31:16  02/16 23:31:16
Phase 7:        02/16 23:31:16  02/16 23:31:16

Total run time: 6 seconds
done
# xfs_check local
# xfs_info /usr/local/
meta-data=/dev/mapper/system-local isize=256    agcount=4, agsize=131072
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=524288, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


I cannot confirm that wrong fdblocks count was not there before correction. I
checked FS's only after correction.


Cheers,

jan

-- 
