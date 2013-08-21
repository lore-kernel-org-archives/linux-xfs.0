Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC12A7FE6
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 10:25:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 742CFAC004
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 08:25:02 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id WZ60MTdSPYB5xo2C for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 08:25:00 -0700 (PDT)
Received: from poseidon.cudanet.local (unknown [64.235.151.250])
	by josefsipek.net (Postfix) with ESMTPSA id 4D906554D8
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:25:00 -0400 (EDT)
Date: Wed, 21 Aug 2013 11:24:58 -0400
From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
Message-ID: <20130821152458.GD986@poseidon.cudanet.local>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We've started experimenting with larger directory block sizes to avoid
directory fragmentation.  Everything seems to work fine, except that the log
is spammed with these lovely debug messages:

	XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

>From looking at the code, it looks like that each of those messages (there
are thousands) equates to 100 trips through the loop.  My guess is that the
larger blocks require multi-page allocations which are harder to satisfy.
This is with 3.10 kernel.

The hardware is something like (I can find out the exact config is you want):

	32 cores
	128 GB RAM
	LSI 9271-8i RAID (one big RAID-60 with 36 disks, partitioned)

As I hinted at earlier, we end up with pretty big directories.  We can
semi-reliably trigger this when we run rsync on the data between two
(identical) hosts over 10GbitE.

# xfs_info /dev/sda9 
meta-data=/dev/sda9              isize=256    agcount=6, agsize=268435455 blks 
         =                       sectsz=512   attr=2 
data     =                       bsize=4096   blocks=1454213211, imaxpct=5 
         =                       sunit=0      swidth=0 blks 
naming   =version 2              bsize=65536  ascii-ci=0 
log      =internal               bsize=4096   blocks=521728, version=2 
         =                       sectsz=512   sunit=0 blks, lazy-count=1 
realtime =none                   extsz=4096   blocks=0, rtextents=0

/proc/slabinfo: https://www.copy.com/s/1x1yZFjYO2EI/slab.txt
sysrq m output: https://www.copy.com/s/mYfMYfJJl2EB/sysrq-m.txt


While I realize that the message isn't bad, it does mean that the system is
having hard time allocating memory.  This could potentially lead to bad
performance, or even an actual deadlock.  Do you have any suggestions?

Thanks,

Jeff.

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
