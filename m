Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03CE67F5F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 07:07:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8312304051
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 05:06:57 -0700 (PDT)
Received: from emea01-db3-obe.outbound.protection.outlook.com
	(mail-db3on0128.outbound.protection.outlook.com
	[157.55.234.128]) by cuda.sgi.com with ESMTP id
	vE0QRQBN64OPCERM (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 05:06:51 -0700 (PDT)
Date: Tue, 2 Jun 2015 14:06:48 +0200
From: Anders Ossowicki <aowi@novozymes.com>
Subject: Re: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150602120648.GA22111@otto>
References: <20150601145741.GA16608@otto> <20150601210113.GL24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150601210113.GL24666@dastard>
Reply-To: aowi@novozymes.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 01, 2015 at 11:01:13PM +0200, Dave Chinner wrote:
> Nothing should go wrong - XFS will essentially block until it gets
> the memory it requires.

Good to know, thanks!

> > We're running on 3.18.13, built from kernel.org git.
> 
> Right around the time that I was seeing all sorts of regressions
> relating to low memory behaviour and the OOM killer....

We fought with some high cpu load issues back in march, related to
memory management, and we ended up on a recent longterm kernel.
http://thread.gmane.org/gmane.linux.kernel.mm/129858

> Ouch. 3TB of memory, and no higher order pages left? Do you have
> memory compaction turned on? That should be reforming large pages in
> this situation. What type of machine is it?

Memory compaction is turned on. It's an off-the-shelf dell server with 4
12c Xeon processors.

> Yes, memory fragmentation tends to be a MM problem; nothing XFS can
> do about it.

Ya, knowing we're not in immediate danger of a filesystem meltdown, I
think we'll tackle the fragmentation issue next.

> Especially as it appears that 2.8TB of your memory is in the page
> cache and should be reclaimable.

Indeed. I haven't been able to catch the issue while it was ongoing,
since upgrading to 3.13.18, but my guess is that we're not reclaiming
the cache fast enough for some reason, possibly because it takes too
long to find the best reclaimable regions with so many fragment to sift
through.

As for the pertinent system info:

Linux 3.18.13 (we also saw the issue with 3.18.9)
xfs_repair version 3.1.7

4x Intel Xeon E7-8857 v2

$ cat /proc/meminfo
MemTotal:       3170749444 kB
MemFree:        18947564 kB
MemAvailable:   2968870324 kB
Buffers:          270704 kB
Cached:         3008702200 kB
SwapCached:            0 kB
Active:         1617534420 kB
Inactive:       1415684856 kB
Active(anon):   156973416 kB
Inactive(anon):  4856264 kB
Active(file):   1460561004 kB
Inactive(file): 1410828592 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      25353212 kB
SwapFree:       25353212 kB
Dirty:           1228056 kB
Writeback:        348024 kB
AnonPages:      24244728 kB
Mapped:         137738148 kB
Shmem:          137578880 kB
Slab:           79729144 kB
SReclaimable:   79040008 kB
SUnreclaim:       689136 kB
KernelStack:       22976 kB
PageTables:     19203180 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    1610727932 kB
Committed_AS:   178507488 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     6628972 kB
VmallocChunk:   31937036032 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      172736 kB
DirectMap2M:    13412352 kB
DirectMap1G:    3207593984 kB

We have three hardware raid'ed disks with XFS on them, one of which receives
the bulk of the load. This is a raid 50 volume on SSDs with the raid controller
running in writethrough mode.

$ xfs_info /dev/sdb
meta-data=/dev/sdb               isize=256    agcount=32, agsize=97640448 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3124494336, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
Anders Ossowicki

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
