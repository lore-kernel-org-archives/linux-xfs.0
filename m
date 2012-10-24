Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OMo9Tp059818 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 17:50:09 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	34YZ9jXfYFxZSd0i for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 15:51:52 -0700 (PDT)
Date: Thu, 25 Oct 2012 09:51:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption
Message-ID: <20121024225148.GA29378@dastard>
References: <5077077A.3040608@crossroads.com> <20121011210741.GC2739@dastard>
	<50789076.7040402@crossroads.com> <20121013001425.GN2739@dastard>
	<50885B60.9050904@crossroads.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50885B60.9050904@crossroads.com>
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
To: Wayne Walker <wwalker@crossroads.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 24, 2012 at 04:19:28PM -0500, Wayne Walker wrote:
> On 10/12/2012 07:14 PM, Dave Chinner wrote:
> <snip>
> >And SB/AGF 3 and 4 are ok, too. So, the filesystem headers just
> >beyond the 2TB offset are zero. That tends to point to a block
> >device problem, as an offset of 2TB is where a 32 bit sector count
> >will overflow (i.e. 2^32). Next step is to run blktrace/blkparse
> >on the cp workload that generates the error to see if anything
> >actually writes to the 2TB offset region, and if so, where it
> >comes from. Probably best to compress the resultant blkparse
> >output file - it might be quite large but the text will compress
> >well. Cheers, Dave.
> 
> Dave,
> 
> Thank you for your help.
> 
> 10 MB .gz file at http://rx-7.bybent.com/blktrace.sde1.out.gz
> 
> What I can see seems to have most of the writes are around 2^31.

Which is 2^31 sectors of just above 1TB. i.e. writing the data into
AG #1. The writes stop a short way into #AG1. The filesystem does
not issue any writes to the AG#2 headers, only a single read. IOWs,
the filesystem is not overwriting it's own metadata during the
workload, so that implies a problem at a lower storage layer....

IOWs, I can't see the filesystem doing anything wrong here.

FWIW, can you pattern the block device around the 2TB offset and
re-run the test, and see if the sb/agf 2 are zeroed via xfs_db after
the failure occurs? i.e. do something like:

# xfs_io -F -f -c "pwrite 2047g 2g" -c fsync /dev/sde1

the mkfs, run xfs_db to dump sb 2 and agf 2, then run the test and
dump sb 2/agf 2 again after the test? use the same xfs-db scripts as
the previous time (i.e. including the drop caches commands) if you
can.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
