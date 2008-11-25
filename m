Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPM9CJh011853 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:09:12 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61C6A15F653B
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:09:10 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 9QAK57yrnpExoT8e for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:09:10 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.175.140.ip-pool.NEFkom.net [83.171.175.140])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 981B35ADD6
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 23:03:37 +0100 (CET)
Subject: Badness in key lookup (length)
Content-Disposition: inline
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Tue, 25 Nov 2008 23:03:36 +0100
MIME-Version: 1.0
Message-Id: <200811252303.36912.Martin@lichtvoll.de>
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


Hi!

I also checked my / XFS filesystem after that failed attempt to hibernate 
via TuxOnIce (see my mail "truncated files"). Well BTW this happened on a 
ThinkPad T42.

While /home was fine, / had some rather minor - it seems - issues. Whether 
they have been from today or from whenever - I do not know.

xfs_check had stuff like

agi unlinked bucket 0 is 8620800 in ag 0 (inode=8620800)
agi unlinked bucket 1 is 1181377 in ag 0 (inode=1181377)
agi unlinked bucket 2 is 8628866 in ag 0 (inode=8628866)
agi unlinked bucket 3 is 8620611 in ag 0 (inode=8620611)
agi unlinked bucket 4 is 1181380 in ag 0 (inode=1181380)
agi unlinked bucket 5 is 7711173 in ag 0 (inode=7711173)
agi unlinked bucket 6 is 7711174 in ag 0 (inode=7711174)
[...]
allocated inode 207025 has 0 link count
allocated inode 207029 has 0 link count
allocated inode 207118 has 0 link count
allocated inode 7711173 has 0 link count
allocated inode 7711174 has 0 link count
allocated inode 7711197 has 0 link count

Which are due to references to deleted files AFAIK.

But there also was:

allocated inode 17686884 has 0 link count
link count mismatch for inode 23955806 (name ?), nlink 28, counted 29
allocated inode 23971992 has 0 link count
[...]
allocated inode 36427654 has 0 link count
link count mismatch for inode 35553563 (name ?), nlink 0, counted 1
allocated inode 34329742 has 0 link count



And xfs_repair -n showed:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
error following ag 0 unlinked list
error following ag 2 unlinked list
error following ag 3 unlinked list
        - process known inodes and perform inode discovery...
        - agno = 0
b796fb90: Badness in key lookup (length)
bp=(bno 21440, len 16384 bytes) key=(bno 21440, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 29872, len 16384 bytes) key=(bno 29872, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 84512, len 16384 bytes) key=(bno 84512, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 91728, len 16384 bytes) key=(bno 91728, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 97728, len 16384 bytes) key=(bno 97728, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 100208, len 16384 bytes) key=(bno 100208, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 100256, len 16384 bytes) key=(bno 100256, len 8192 bytes)
b796fb90: Badness in key lookup (length)
[...]
        - agno = 1
b47ffb90: Badness in key lookup (length)
bp=(bno 15007344, len 16384 bytes) key=(bno 15007344, len 8192 bytes)
b47ffb90: Badness in key lookup (length)
bp=(bno 15009728, len 16384 bytes) key=(bno 15009728, len 8192 bytes)
b47ffb90: Badness in key lookup (length)
bp=(bno 15020000, len 16384 bytes) key=(bno 15020000, len 8192 bytes)
b47ffb90: Badness in key lookup (length)
bp=(bno 15044480, len 16384 bytes) key=(bno 15044480, len 8192 bytes)
b47ffb90: Badness in key lookup (length)
[...]
        - agno = 2
b796fb90: Badness in key lookup (length)
bp=(bno 21986088, len 16384 bytes) key=(bno 21986088, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 22240200, len 16384 bytes) key=(bno 22240200, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 22374744, len 16384 bytes) key=(bno 22374744, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 23118072, len 16384 bytes) key=(bno 23118072, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 23133528, len 16384 bytes) key=(bno 23133528, len 8192 bytes)
b796fb90: Badness in key lookup (length)
bp=(bno 26478456, len 16384 bytes) key=(bno 26478456, len 8192 bytes)
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
disconnected inode 29078, moving to lost+found
disconnected inode 42896, moving to lost+found
disconnected inode 42930, moving to lost+found
disconnected inode 53518, moving to lost+found
[...]
disconnected inode 35447288, moving to lost+found
disconnected inode 35447289, moving to lost+found
disconnected dir inode 35553563, moving to lost+found
disconnected inode 35756686, moving to lost+found
disconnected inode 36427654, moving to lost+found
[...]
Phase 7 - verify and correct link counts...
resetting inode 35553563 nlinks from 0 to 2
done


Running xfs_repair -n after that yielded yet another issue - although 
everything should be fixed:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
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
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
would have reset inode 94530 nlinks from 2 to 3
No modify flag set, skipping filesystem flush and exiting.

Another xfs_repair fixed this one for good.


Lost+found is impressive -  but my bet is that its all those previously 
deleted files that xfs_repair "fixed" - disk usage appears to be where I 
expect it to be and I do not "miss" anything yet:

shambhala:~> du -sch /lost+found
151M    /lost+found
151M    insgesamt


My questions:

1) Whats those Badness in key lookup messages? Anything to worry about?

2) Why did xfs_repair -n after I ran xfs_repair yield yet another 
error "would have reset inode 94530 nlinks from 2 to 3"? Why didn't it 
appear in the first pass?

martin@shambhala:~/Zeit/xfs-probleme-2008-11-25> grep 94530 
xfsrepair-sda1-repair.txt
martin@shambhala:~/Zeit/xfs-probleme-2008-11-25#1>

3) Any idea how these problems occured in the first time? 


Well I did not grab a metadump as I was just concerned to get anything up 
and running ASAP. So if you can't say much, thats fair enough. I have 
complete outputs of xfs_check and the different xfs_repair runs at hand 
tough and could upload them to my webserver somewhere.




shambhala:~> xfs_info /dev/sda1
meta-data=/dev/disk/by-uuid/7fcd9766-bf1a-426a-8a07-2c3e0c510898 isize=256    
agcount=4, agsize=915703 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3662812, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

shambhala:~#1> cat /proc/version
Linux version 2.6.27.7-tp42-toi-3.0-rc7a (martin@shambhala) (gcc version 
4.3.2 (Debian 4.3.2-1) ) #1 PREEMPT Mon Nov 24 11:30:39 CET 2008

xfsprogs 2.9.8-1 (debian package)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
