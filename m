Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145807.y6h75atmunft32qf@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail.webx.cz ([109.123.222.201]:48156 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdBWJT3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Feb 2017 04:19:29 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Thu, 23 Feb 2017 10:05:08 +0100
Message-ID: <3114301.pdi8LQHD6i@libor-nb>
In-Reply-To: <30c5d3eb-5f62-5488-aff7-6b1544f1c29a@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <3412655.IXdA3WXzce@libor-nb> <30c5d3eb-5f62-5488-aff7-6b1544f1c29a@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hello,
so repair did something, in log it says "block 0", is that ok?

Inode=335629253 is now in lost+found - empty dir belonging to user cust1.
When looking at 
u.sfdir2.hdr.parent.i4 = 319041478
from xfs_db before repair, it seemed to be in dir, which is owned by cust2, 
totally unrelated to cust1, is that possible? 
>From our view, it's not possible because of FS rights (homedir of each user has rights 0750)

Second inode=1992635 , repaired by xfs_repair, is directory lost+found

Libor

Commands output follows:

Kernel 4.9.2, xfsprogs 4.10.0-rc1
-----------------------------------------------------------------------------
---- check
# xfs_repair -n /dev/mapper/vgDisk2-lvData
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 5 is 84933 in ag 20 (inode=335629253)
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
bad attribute count 0 in attr block 0, inode 335629253
problem with attribute contents in inode 335629253
would clear attr fork
bad nblocks 1 for inode 335629253, would reset to 0
bad anextents 1 for inode 335629253, would reset to 0
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
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
        - agno = 16
        - agno = 17
       - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 335629253, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 335629253 nlinks from 0 to 2
No modify flag set, skipping filesystem flush and exiting.
-----------------------------------------------------------------------------
---- repair
# xfs_repair  /dev/mapper/vgDisk2-lvData
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 5 is 84933 in ag 20 (inode=335629253)
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
bad attribute count 0 in attr block 0, inode 335629253
problem with attribute contents in inode 335629253
clearing inode 335629253 attributes
correcting nblocks for inode 335629253, was 1 - counted 0
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
bad attribute format 1 in inode 335629253, resetting value
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 335629253, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 1992635 nlinks from 2 to 3
resetting inode 335629253 nlinks from 0 to 2
Note - quota info will be regenerated on next quota mount.
Done
-----------------------------------------------------------------------------
---- xfs_db before repair
# xfs_db -r /dev/vgDisk2/lvData
xfs_db> inode 335629253
xfs_db> print
core.magic = 0x494e
core.mode = 040775
core.version = 2
core.format = 1 (local)
core.nlinkv2 = 0
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 10106
core.gid = 10106
core.flushiter = 2
core.atime.sec = Wed Feb 22 11:04:21 2017
core.atime.nsec = 464104444
core.mtime.sec = Wed Feb 22 11:46:41 2017
core.mtime.nsec = 548670485
core.ctime.sec = Wed Feb 22 11:46:41 2017
core.ctime.nsec = 548670485
core.size = 6
core.nblocks = 1
core.extsize = 0
core.nextents = 0
core.naextents = 1
core.forkoff = 15
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 1322976790
next_unlinked = null
u.sfdir2.hdr.count = 0
u.sfdir2.hdr.i8count = 0
u.sfdir2.hdr.parent.i4 = 319041478
a.bmx[0] = [startoff,startblock,blockcount,extentflag]
0:[0,20976867,1,0]

-----------------------------------------------------------------------------
---- xfs_db after repair
# xfs_db -r /dev/vgDisk2/lvData
xfs_db> inode 335629253
xfs_db> print
core.magic = 0x494e
core.mode = 040775
core.version = 2
core.format = 1 (local)
core.nlinkv2 = 2
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 10106
core.gid = 10106
core.flushiter = 2
core.atime.sec = Wed Feb 22 11:04:21 2017
core.atime.nsec = 464104444
core.mtime.sec = Wed Feb 22 11:46:41 2017
core.mtime.nsec = 548670485
core.ctime.sec = Wed Feb 22 11:46:41 2017
core.ctime.nsec = 548670485
core.size = 6
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 1322976790
next_unlinked = null
u.sfdir2.hdr.count = 0
u.sfdir2.hdr.i8count = 0
u.sfdir2.hdr.parent.i4 = 1992635
xfs_db> quit

