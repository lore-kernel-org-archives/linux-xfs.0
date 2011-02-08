Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p18KMQlW147077
	for <linux-xfs@oss.sgi.com>; Tue, 8 Feb 2011 14:22:27 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47B35123518D
	for <linux-xfs@oss.sgi.com>; Tue,  8 Feb 2011 12:25:00 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id GIJXJHII2FW60pMA for
	<linux-xfs@oss.sgi.com>; Tue, 08 Feb 2011 12:25:00 -0800 (PST)
Message-ID: <4D51A695.6060700@lueckdatasystems.com>
Date: Tue, 08 Feb 2011 15:24:53 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D517FD2.5040509@lueckdatasystems.com>
	<20110208195256.GA25601@dastard>
	<4D51A0BC.6070201@lueckdatasystems.com>
In-Reply-To: <4D51A0BC.6070201@lueckdatasystems.com>
Content-Type: multipart/mixed; boundary="------------080905090907010703040206"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

This is a multi-part message in MIME format.
--------------080905090907010703040206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Lueck wrote:
> I will IPL the server to the latest kernel and run the tests immediately.

Here they are attached...

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

--------------080905090907010703040206
Content-Type: text/x-log;
 name="xfs_db-inode_80508397.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_db-inode_80508397.log"

# sudo xfs_db -c "inode 80508397" -c p /dev/sda9 2>&1 | tee xfs_db-inode_80508397.log
core.magic = 0x494e
core.mode = 040777
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 2
core.onlink = 0
core.projid = 0
core.uid = 1000
core.gid = 1000
core.flushiter = 10
core.atime.sec = Sun Feb  6 16:59:44 2011
core.atime.nsec = 088915516
core.mtime.sec = Tue Jan 11 13:50:51 2011
core.mtime.nsec = 950662167
core.ctime.sec = Tue Jan 11 13:50:51 2011
core.ctime.nsec = 950662167
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
core.filestream = 0
core.gen = 3978985788
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,5052169,1,0]

--------------080905090907010703040206
Content-Type: text/x-log;
 name="xfs_repair-srv.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_repair-srv.log"

# sudo xfs_repair -n /dev/sda9 2>&1 | tee xfs_repair-srv.log
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
No modify flag set, skipping filesystem flush and exiting.

--------------080905090907010703040206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------080905090907010703040206--
