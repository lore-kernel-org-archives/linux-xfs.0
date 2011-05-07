Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p47G67sQ249337 for <xfs@oss.sgi.com>; Sat, 7 May 2011 11:06:07 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0807A164BEF2
	for <xfs@oss.sgi.com>; Sat,  7 May 2011 09:09:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id O3DyKQZFKjZvX0tM for
	<xfs@oss.sgi.com>; Sat, 07 May 2011 09:09:46 -0700 (PDT)
Date: Sat, 7 May 2011 12:09:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.38.4: xfs speed problem?
Message-ID: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Hello,

Using 2.6.38.4 on two hosts:

Host 1:
$ /usr/bin/time find geocities.data 1> /dev/null
80.92user 417.93system 2:19:07elapsed 5%CPU (0avgtext+0avgdata 105520maxresident)k
0inputs+0outputs (0major+73373minor)pagefaults 0swaps

# xfs_db -c frag -f /dev/sda1
actual 40203982, ideal 40088075, fragmentation factor 0.29%

meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=11718704640, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

--

Host 2:
$ /usr/bin/time find geocities.data 1>/dev/null
54.60user 337.20system 48:42.71elapsed 13%CPU (0avgtext+0avgdata 105632maxresident)k
0inputs+0outputs (1major+72981minor)pagefaults 0swaps

# xfs_db -c frag -f /dev/sdb1
actual 37998306, ideal 37939331, fragmentation factor 0.16%

meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2441379328, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


--

Host 1: RAID-6 (7200 RPM Drives, 18+1 hot spare)
Host 2: RAID-6 (7200 RPM Drives, 12)

Each system uses a 3ware 9750-24i4e controller, same settings.

Any thoughts why one is > 2x faster than the other?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
