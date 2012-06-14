Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5E04G3T198713 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 19:04:16 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eGYDXZY4EQ7XrpZd for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 17:04:14 -0700 (PDT)
Date: Thu, 14 Jun 2012 10:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120614000411.GY22848@dastard>
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD8552C.4090208@xsnews.nl>
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
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com

On Wed, Jun 13, 2012 at 10:54:04AM +0200, Matthew Whittaker-Williams wrote:
> On 6/13/12 3:19 AM, Dave Chinner wrote:
> >
> >With the valid stack traces, I see that it isn't related to the log,
> >though.
> 
> Ah ok, we are triggering a new issue?

No, your system appears to be stalling waiting for IO completion.

> >>RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
> >>Size                : 40.014 TB
> >>State               : Optimal
> >>Strip Size          : 64 KB
> >>Number Of Drives    : 24
> >.....
> >>Virtual Drive: 1 (Target Id: 1)
> >>Name                :
> >>RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
> >>Size                : 40.014 TB
> >>State               : Optimal
> >>Strip Size          : 1.0 MB
> >>Number Of Drives    : 24
> >OOC, any reason for the different stripe sizes on the two
> >RAID volumes?
> 
> This is a fluke, we are running several new systems and this is just
> one of the new servers.
> Which indeed has a wrong stripe set, this should be 1MB.
> We actually found stripe size set of 1MB to give better performance
> overall than 64/256/512

So if you fix that, does the problem go away?

> >And that is sync waiting for the flusher thread to complete
> >writeback of all the dirty inodes. The lack of other stall messages
> >at this time makes it pretty clear that the problem is not
> >filesystem related - the system is simply writeback IO bound.
> >
> >The reason, I'd suggest, is that you've chosen the wrong RAID volume
> >type for your workload. Small random file read and write workloads
> >like news and mail spoolers are IOPS intensive workloads and do
> >not play well with RAID5/6. RAID5/6 really only work well for large
> >files with sequential access patterns - you need to use RAID1/10 for
> >IOPS intensive workloads because they don't suffer from the RMW
> >cycle problem that RAID5/6 has for small writes. The iostat output
> >will help clarify whether this is really the problem or not...
> 

> I understand that RAID 10 is better for performance for reads on
> small files sets.  But with raid 10 we of course loose a lot of
> disk space compared to RAID 6.  Side note to this we have been
> running RAID 6 for years now without any issues.

but have you been running 24 disk RAID6 volumes? With RAID5/6, the
number of disks of the volume really matters - for small write IOs,
the more disks in the RAID6 volume, the slower it will be...

> In the past we did tune our xfs filesystem with switches like
> sunit and swidth.  But back then we couldn't see much peformance
> difference between using:
> 
> mkfs.xfs -f -L P.01 -l lazy-count=1 -d su=1m,sw=22 /dev/sda
> 
> and
> 
> mkfs.xfs -f -L P.01 -l lazy-count=1 /dev/sda

You won't see much difference with the BBWC enabled. It does affect
how files and inodes are allocated, though, so the aging
characteristics of the filesystem will be better for an aligned
filesystem. i.e. you might not notice the performance now, but after
a coupl eof years in production you probably will...

> xfs_info from a system that shows no problems with an H800
> Controller from dell ( same chipset as the LSI controllers )
> 
> Product Name    : PERC H800 Adapter
> Serial No       : 071002C
> FW Package Build: 12.10.1-0001
> 
> sd60:~# xfs_info /dev/sda
> meta-data=/dev/sda               isize=256    agcount=58,
> agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=15381037056, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Where we even have bigger spools:

You have larger drives, not a wider RAID volume. That's a 23-disk
wide, 3TB drive RAID6 volume. And it's on a different controller
with different firmware, so there's lots different here...

> Aside from the wrong stripe set and write alignments, this still
> should not cause the kernel to crash like this.

The kernel is not crashing. It's emitting warnings that indicate the
IO subsystem is overloaded.

> We found that running with a newer driver of LSI it takes a bit
> longer for the kernel to crash but it still does.

Which indicates the problem is almost certainly related to the
storage configuration or drivers, not the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
