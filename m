Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A6717F54
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 21:58:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C42EAC008
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:58:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9RT08Mrev8KnO5Xo for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 19:58:26 -0700 (PDT)
Date: Fri, 30 Aug 2013 12:58:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: higher agcount on LVM2 thinp volumes
Message-ID: <20130830025819.GB23571@dastard>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
	<DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Thu, Aug 29, 2013 at 08:08:25PM -0600, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 7:44 PM, Stan Hoeppner
> <stan@hardwarefreak.com> wrote:
> > 
> > More information would be helpful, specifically WRT the device
> > stack underlying mkfs.xfs.  I.e. we need to know more about the
> > LVM configuration.
> > 
> > See:
> > 
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> Summary: laptop, one HDD, one 402GB partition is made into a PV,
> one VG is created with that PV and is the only VG on the system,
> one 400GB logical volume pool is created, one 100GB virtual sized
> logical volume is created from the thin pool.
....
> meta-data=/dev/vg1/data          isize=256    agcount=16, agsize=1638400 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Whereas if I mkfs.xfs on /dev/sda7, or if I create a regular LV
> rather than a thinp volume, agcount is 4. It doesn't matter
> whether I create the thinp with the chunk option set to default
> (as above) or 1MB or 4MB.

Which means that the thinp device has some difference in what it is
telling mkfs.xfs about it's configuration that makes mkfs.xfs think
it is a RAID volume, not a single disk.

Basically, I think you'll find that the thinp device is emitting a
an optimal IO size that is not aligned to the filesystem block size,
so the AG count is being calculated as though it is a ~1TB
"multidisk" device (which gives 16 AGs) and then setting
sunit/swidth to zero because they aren't filesystem block aligned...

Check the contents of
/sys/block/<dev>/queue/{minimum,optimal}_io_size for the single
device, the standard LV and the thinp device. I think that you'll
find only the thinp device has a non-zero value. If the value from
the thinp code is 512 (i.e. single sector) then that's a bug in
the thinp device code as it should be zero...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
