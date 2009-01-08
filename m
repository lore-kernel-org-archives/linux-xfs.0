Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n083ksaK030835 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 21:46:57 -0600
Received: from cavemail.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 146186E568
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 19:46:51 -0800 (PST)
Received: from cavemail.org (static-ip-62-75-189-85.inaddr.intergenia.de
	[62.75.189.85]) by cuda.sgi.com with ESMTP id rLTSfDbEW7nDdbfu
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 19:46:51 -0800 (PST)
Received: from localhost (cavemail.org.local [127.0.0.1])
	by cavemail.org (Postfix) with ESMTP id E1FA05C9109E
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 03:46:49 +0000 (UTC)
Received: from cavemail.org ([127.0.0.1])
	by localhost (mail.cavemail.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IXsOU5TY-j+q for <xfs@oss.sgi.com>;
	Thu,  8 Jan 2009 03:46:42 +0000 (UTC)
Received: from cavemail.org (cavemail.org.local [127.0.0.1])
	by cavemail.org (Postfix) with ESMTP id 477205C9109C
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 03:46:42 +0000 (UTC)
Message-ID: <50407.88.130.217.97.1231386402.squirrel@cavemail.org>
Date: Thu, 8 Jan 2009 03:46:42 -0000 (UTC)
Subject: XFS suddenly corrupted inode
From: "dusty@gmx.li" <dusty@gmx.li>
MIME-Version: 1.0
Reply-To: dusty@gmx.li
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

I don't know if I address the right people, but I would appreciate any help.
I run a xfs file system ontop of a dm-crypted 3ware 8xxx controller
powered raid-5. This worked for more than one year without any problem on
two different computers.
Last year I encountered an inode corruption on pc2 and after running
xfs_repair everything seemed fine. After a short while the same error
reappeared. I ran xfs_repair again and so on. The times the file system
stayed stable became more and more short. So I decided to back everything
up and run mkfs.xfs again. The System is now stable again for about 3
month.

Today I found again an inode corruption. But this time on the other pc
(pc1=jasmin) that has the same setup and hardware. Currently I don't want
to mess around with the system before anybody may have a look at what the
problems trigger is.

This is what I remember from the first time:
The inode corruption was logged in the syslog the first time during a
xfs_fsr.

The filesystem is now no longer mounted and the first xfs syslog messages
are:

Jan  7 05:08:32 jasmin Filesystem "dm-3": corrupt inode 2971 ((a)extents =
4).  Unmount and run xfs_repair.
Jan  7 05:08:32 jasmin 00000000: 49 4e 81 f8 02 02 00 00 00 00 00 00 00 00
27 10  IN............'.
Jan  7 05:08:32 jasmin Filesystem "dm-3": XFS internal error
xfs_iformat_extents(1) at line 619 of file fs/xfs/xfs_inode.c.  Caller
0xffffffff80339322
Jan  7 05:08:32 jasmin Pid: 26656, comm: smbd Tainted: P        
2.6.25-gentoo-r7 #1
Jan  7 05:08:32 jasmin
Jan  7 05:08:32 jasmin Call Trace:
Jan  7 05:08:32 jasmin [<ffffffff80339322>] xfs_iformat+0x252/0x490
Jan  7 05:08:32 jasmin [<ffffffff80337db7>] xfs_iformat_extents+0x187/0x250
Jan  7 05:08:32 jasmin [<ffffffff80339322>] xfs_iformat+0x252/0x490
Jan  7 05:08:32 jasmin [<ffffffff80339322>] xfs_iformat+0x252/0x490
Jan  7 05:08:32 jasmin [<ffffffff80339725>] xfs_iread+0x1c5/0x220
Jan  7 05:08:32 jasmin [<ffffffff80333d3d>] xfs_iget_core+0x1bd/0x710
Jan  7 05:08:32 jasmin [<ffffffff803343b1>] xfs_iget+0x121/0x1a0
Jan  7 05:08:32 jasmin [<ffffffff8034dbad>] xfs_dir_lookup_int+0x8d/0xf0
Jan  7 05:08:32 jasmin [<ffffffff80350345>] xfs_lookup+0x75/0xa0
Jan  7 05:08:32 jasmin [<ffffffff8035d471>] xfs_vn_lookup+0x31/0x70
Jan  7 05:08:32 jasmin [<ffffffff80292067>] do_lookup+0x1b7/0x210
Jan  7 05:08:32 jasmin [<ffffffff80293ea7>] __link_path_walk+0x867/0xe40
Jan  7 05:08:32 jasmin [<ffffffff802944da>] path_walk+0x5a/0xc0
Jan  7 05:08:32 jasmin [<ffffffff80294763>] do_path_lookup+0x83/0x1c0
Jan  7 05:08:32 jasmin [<ffffffff802932e5>] getname+0xe5/0x210
Jan  7 05:08:32 jasmin [<ffffffff8029535b>] __user_walk_fd+0x4b/0x80
Jan  7 05:08:32 jasmin [<ffffffff8028d40f>] vfs_stat_fd+0x2f/0x80
Jan  7 05:08:32 jasmin [<ffffffff802932e5>] getname+0xe5/0x210
Jan  7 05:08:32 jasmin [<ffffffff8039262e>] _atomic_dec_and_lock+0x4e/0x70
Jan  7 05:08:32 jasmin [<ffffffff802a11d7>] mntput_no_expire+0x27/0x90
Jan  7 05:08:32 jasmin [<ffffffff802a7062>] sys_getxattr+0x72/0xb0
Jan  7 05:08:32 jasmin [<ffffffff8028d657>] sys_newstat+0x27/0x50
Jan  7 05:08:32 jasmin [<ffffffff8028a65a>] vfs_read+0x12a/0x160
Jan  7 05:08:32 jasmin [<ffffffff8028aad3>] sys_read+0x53/0x90
Jan  7 05:08:32 jasmin [<ffffffff8020b30b>]
system_call_after_swapgs+0x7b/0x80

This block of messages was logged 20 times till Jan  7 05:09:18

System:
Linux jasmin 2.6.25-gentoo-r7 #1 SMP Sat Aug 30 19:05:13 CEST 2008 x86_64
AMD Phenom(tm) 9850 Quad-Core Processor AuthenticAMD GNU/Linux

jasmin ~ # tw_cli /c0 show
Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
------------------------------------------------------------------------------
u0    RAID-5    OK             -       -       64K     1397.28   ON     -
...
(4x500GB Samsung HD501LJ)

------------------------------------------------------------------------------

jasmin ~ # xfs_check /dev/mapper/crypt2
(no output)

jasmin ~ # xfs_repair -n /dev/mapper/crypt
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
local inode 2147909181 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2147909181, would clear attr fork
would have cleared inode 2147909181
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 3
        - agno = 2
        - agno = 0
        - agno = 1
local inode 2147909181 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2147909181, would clear attr fork
would have cleared inode 2147909181
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

jasmin ~ # xfs_db -r -c "inode 2147909181" -c "p" /dev/mapper/crypt
core.magic = 0x494e
core.mode = 0100770
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 1
core.onlink = 0
core.projid = 0
core.uid = 10033
core.gid = 10000
core.flushiter = 108
core.atime.sec = Thu Dec  4 08:42:51 2008
core.atime.nsec = 469951000
core.mtime.sec = Thu Dec  4 09:05:45 2008
core.mtime.nsec = 436920683
core.ctime.sec = Thu Dec  4 09:05:45 2008
core.ctime.nsec = 436920683
core.size = 6210560
core.nblocks = 1517
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 7
core.aformat = 1 (local)
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
core.gen = 84
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,180758896,1517,0]
a.sfattr.hdr.totsize = 3
a.sfattr.hdr.count = 0


Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
