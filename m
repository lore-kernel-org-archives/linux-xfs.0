Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 06:45:23 -0700 (PDT)
Received: from mail.gatrixx.com (mail.gatrixx.com [217.111.11.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2UDjE6p018560
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 06:45:15 -0700
Message-ID: <460D145C.6080807@j-o-a.de>
Date: Fri, 30 Mar 2007 15:45:00 +0200
From: Oliver Joa <oliver@j-o-a.de>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de> <20070328234647.GT32597093@melbourne.sgi.com>
In-Reply-To: <20070328234647.GT32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

Hi,

David Chinner wrote:

[...]

> Next time you get a shutdown, can you unmount the filesystems and
> run xfs_check and then "xfs_repair -n" on the filesystem. These will
> tell you the inode numbers that are bad. Can you post the errors
> reported by these tools?


xfs_check gives this:

bad format 0 for inode 8458341 type 0100000
bad format 0 for inode 8458344 type 0100000
bad format 0 for inode 8458348 type 0100000
block 1/4962 type unknown not expected
block 1/4963 type unknown not expected
block 1/4970 type unknown not expected
block 1/4975 type unknown not expected
block 1/4976 type unknown not expected
link count mismatch for inode 8458341 (name ?), nlink 0, counted 1
link count mismatch for inode 8458344 (name ?), nlink 0, counted 1
link count mismatch for inode 8458348 (name ?), nlink 0, counted 1



xfs_repair -n gives this:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
bad inode format in inode 8458341
bad inode format in inode 8458344
bad inode format in inode 8458348
bad inode format in inode 8458341
would have cleared inode 8458341
bad inode format in inode 8458344
would have cleared inode 8458344
bad inode format in inode 8458348
would have cleared inode 8458348
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
entry "cpufreq.c" at block 0 offset 152 in directory inode 8458336 
references free inode 8458341
         would clear inode number in entry at offset 152...
entry "head.S" at block 0 offset 232 in directory inode 8458336 
references free inode 8458344
         would clear inode number in entry at offset 232...
entry "irq.c" at block 0 offset 320 in directory inode 8458336 
references free inode 8458348
         would clear inode number in entry at offset 320...
bad inode format in inode 8458341
would have cleared inode 8458341
bad inode format in inode 8458344
would have cleared inode 8458344
bad inode format in inode 8458348
would have cleared inode 8458348
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
Phase 6 - check inode connectivity...
         - traversing filesystem starting at / ...
entry "cpufreq.c" in directory inode 8458336 points to free inode 
8458341, would junk entry
entry "head.S" in directory inode 8458336 points to free inode 8458344, 
would junk entry
entry "irq.c" in directory inode 8458336 points to free inode 8458348, 
would junk entry
         - traversal finished ...
         - traversing all unattached subtrees ...
         - traversals finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


> Once you have the bad inode numbers, can you run the following
> on the bad inodes:
> 
> # xfs_db -r -c "inode <inum>" -c "p" <device>


xfs_db on inode 8458341 gives:

core.magic = 0x494e
core.mode = 0100644
core.version = 1
core.format = 0 (dev)
core.nlinkv1 = 1
core.uid = 0
core.gid = 0
core.flushiter = 6
core.atime.sec = Tue Jan 30 22:42:51 2007
core.atime.nsec = 000000000
core.mtime.sec = Wed Jan 10 19:10:37 2007
core.mtime.nsec = 000000000
core.ctime.sec = Wed Mar 28 18:15:36 2007
core.ctime.nsec = 612718490
core.size = 6209
core.nblocks = 2
core.extsize = 0
core.nextents = 1
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
core.gen = 0
next_unlinked = null
u.dev = 0



xfs_db on inode 8458344 gives:

core.magic = 0x494e
core.mode = 0100644
core.version = 1
core.format = 0 (dev)
core.nlinkv1 = 1
core.uid = 0
core.gid = 0
core.flushiter = 6
core.atime.sec = Tue Jan 30 22:42:51 2007
core.atime.nsec = 000000000
core.mtime.sec = Wed Jan 10 19:10:37 2007
core.mtime.nsec = 000000000
core.ctime.sec = Wed Mar 28 18:15:36 2007
core.ctime.nsec = 612849562
core.size = 2326
core.nblocks = 1
core.extsize = 0
core.nextents = 1
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
core.gen = 0
next_unlinked = null
u.dev = 0


xfs_db on inode 8458336 gives:

core.magic = 0x494e
core.mode = 040755
core.version = 1
core.format = 2 (extents)
core.nlinkv1 = 5
core.uid = 0
core.gid = 0
core.flushiter = 1
core.atime.sec = Tue Jan 30 22:42:51 2007
core.atime.nsec = 906063000
core.mtime.sec = Wed Jan 10 19:10:37 2007
core.mtime.nsec = 000000000
core.ctime.sec = Tue Jan 30 22:44:48 2007
core.ctime.nsec = 428077021
core.size = 4096
core.nblocks = 1
core.extsize = 0
core.nextents = 1
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
core.gen = 0
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,528704,1,0]

[...]

> and post the output for us? That will enable us to see exactly what
> the corruption is on the inode.

Here is it...

Thanks a lot...

Olli
