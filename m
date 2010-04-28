Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SEWNRE241534 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 09:32:24 -0500
Received: from hermes.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35B8D154E78B
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:34:26 -0700 (PDT)
Received: from hermes.mejor.pl (hermes.mejor.pl [193.238.12.139]) by
	cuda.sgi.com with ESMTP id kFRALtKVaX3Znhdz for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:34:26 -0700 (PDT)
Received: from 127-goc-33.acn.waw.pl ([94.75.108.127] helo=[192.168.138.2])
	by hermes.mejor.pl with esmtpa (Exim 4.71)
	(envelope-from <marcin@mejor.pl>) id 1O78LJ-0001iA-JS
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 16:34:25 +0200
Message-ID: <4BD84771.4030804@mejor.pl>
Date: Wed, 28 Apr 2010 16:34:25 +0200
From: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>
MIME-Version: 1.0
Subject: Enabling lazy counters damages filesystem
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,
Please look at this:
# mkfs.xfs -f /dev/malowazne/test
meta-data=/dev/malowazne/test    isize=256    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

# xfs_check /dev/malowazne/test
# xfs_check /dev/malowazne/test

It's still clean.

# xfs_admin -c 1 /dev/malowazne/test
Enabling lazy-counters
# xfs_check /dev/malowazne/test
sb_features2 (0xa) not same as sb_bad_features2 (0x8)

Not good, let's repair fs:

# xfs_repair /dev/malowazne/test
Phase 1 - find and verify superblock...
superblock has a features2 mismatch, correcting
writing modified primary superblock
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
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

Now i'm trying to turn off lazy counters:

# xfs_admin -c 0 /dev/malowazne/test
Disabling lazy-counters
# xfs_check /dev/malowazne/test
sb_features2 (0x8) not same as sb_bad_features2 (0xa)
# xfs_repair /dev/malowazne/test
Phase 1 - find and verify superblock...
superblock has a features2 mismatch, correcting
writing modified primary superblock
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
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

# mount /dev/malowazne/test /mnt/test
# xfs_info /dev/malowazne/test
meta-data=/dev/mapper/malowazne-test isize=256    agcount=4,
agsize=524288 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So as you can see lazy conters are still turn on.
I'm using:
# mkfs.xfs -V
mkfs.xfs version 3.0.3
# uname -r
2.6.33-zen2

The same problem noticed with kernel-2.6.28-r9 with grsecurity, and with
xfsprogs-3.0.0 .
Is this behaviour bug or i don't know about something that i should?:)

Regards!
Marcin









_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
