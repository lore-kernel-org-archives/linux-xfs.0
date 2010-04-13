Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DC8A6i227967 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 07:08:12 -0500
Received: from mx.inode.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8017E12594D5
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 05:10:03 -0700 (PDT)
Received: from mx.inode.at (mx04.lb01.inode.at [62.99.145.4]) by cuda.sgi.com
	with ESMTP id rzLZK16l7d4kl56H for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 05:10:03 -0700 (PDT)
Received: from [83.64.155.34] (port=5272 helo=workstation006.office.ice-sf.at)
	by smartmx-04.inode.at with esmtp (Exim 4.69)
	(envelope-from <Bernhard.Gschaider@ice-sf.at>) id 1O1ewN-00045d-1I
	for xfs@oss.sgi.com; Tue, 13 Apr 2010 14:10:03 +0200
Subject: XFS-filesystem corrupted by defragmentation
From: Bernhard Gschaider <bgschaid_lists@ice-sf.at>
Date: Tue, 13 Apr 2010 14:10:02 +0200
Message-ID: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
MIME-Version: 1.0
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


Hi!

I'm asking here because I've been referred here fro the CentOS-mailing
list (for the full story see
http://www.pubbs.net/201004/centos/17112-centos-performance-problems-with-xfs-on-centos-54.html
and 
http://www.pubbs.net/201004/centos/24542-centos-xfs-filesystem-corrupted-by-defragmentation-was-performance-problems-with-xfs-on-centos-54.html
the following stuff is a summary of this)

It was suggested to me that the source of my performance problems might
be the fragmentation of the XFS-system. I tested for fragmentation and
got 

xfs_db> frag
actual 6349355, ideal 4865683, fragmentation factor 23.37%

Before I'd try to defragment my whole filesystem I figured "Let's try
it on some file". 

So I did

> xfs_bmap /raid/Temp/someDiskimage.iso
[output shows 101 extents and 1 hole]

Then I defragmented the file
> xfs_fsr /raid/Temp/someDiskimage.iso
extents before:101 after:3 DONE

> xfs_bmap /raid/Temp/someDiskimage.iso
[output shows 3 extents and 1 hole]

and now comes the bummer: i wanted to check the fragmentation of the
whole filesystem (just for checking):

> xfs_db -r /dev/mapper/VolGroup00-LogVol04
xfs_db: unexpected XFS SB magic number 0x00000000
xfs_db: read failed: Invalid argument
xfs_db: data size check failed
cache_node_purge: refcount was 1, not zero (node=0x2a25c20)
xfs_db: cannot read root inode (22)

THAT output was definitly not there when I did this the last time and
therefor the new fragmentation does not make me happy either

xfs_db> frag
actual 0, ideal 0, fragmentation factor 0.00%

The file-system is still mounted and working and I don't dare to do
anything about it (am in a mild state of panic) because I think it
might not come back if I do.

Any suggestions most welcome (am googling myself before I do anything
about it).

I swear to god: I did not do anything else with the xfs_*-commands
than the stuff mentioned above

As far as I understood from other places the first thing to do is "try
to get the incore copy of the XFS superblock flushed out" before
proceeding (must find out how to do that). How would you suggest to
proceed from that? If defragmenting one file messes things up this
badly how safe is defragmentation in general?

Thanks for your time
Bernhard

Info about my system. Tell me if you need more info:

My system is a CentOS 5.4 (which is equivalent to a RHEL 5.4) which
means kernel 2.6.18 (64bit. Unmodified Xen-Kernel). xfs_db -V reports
"xfs_db version 2.9.4"

Memory on the system is 4Gig (2 DualCore Xenons). The filesystem is
3.5 TB of which 740 Gig are used. Which is the maximum amount used
during the one year that the filesystem is being used (that is why the
high fragmentation amazes me) The filesystem is on a LVM-Volume which
sits on a RAID 5 (Hardware RAID) drive.

% xfs_info  /raid
meta-data=/dev/VolGroup00/LogVol05 isize=256    agcount=32, agsize=29434880 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=941916160, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
