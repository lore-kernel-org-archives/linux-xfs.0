Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q648aJhl187080 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 03:36:19 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Egnf3ztMpfzTRDC0 for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 01:36:17 -0700 (PDT)
Date: Wed, 4 Jul 2012 18:36:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: improve test 286 for repeated unwritten/hole
	extents.
Message-ID: <20120704083616.GI19223@dastard>
References: <4FF29F94.6030702@oracle.com>
 <4FF30A89.9010800@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FF30A89.9010800@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: jeff.liu@oracle.com, xfs@oss.sgi.com

On Tue, Jul 03, 2012 at 10:06:49AM -0500, Mark Tinguely wrote:
> On 07/03/12 02:30, Jeff Liu wrote:
> >Hello,
> >
> >I'd like to enlarge the test coverage of 286 to includes file mapping with repeated hole/unwritten/unwritten_without_data/data intersections.
> >
> >Those two new sub-tests could help verifying the current seek_data/seek_hole improvements.
> >
> >Besides, I observed a weird thing at the diff of 286.full, look at the the sparse file creation output,  there seems to be a significant
> >I/O degradation compare to the old test01/test02 IOPS results:
> >
> >-1 MiB, 256 ops; 0.0000 sec (1.242 GiB/sec and 325699.7455 ops/sec)
> >+1 MiB, 256 ops; 0.0000 sec (70.161 MiB/sec and 17961.1310 ops/sec)
> >
> >I run the test on same machine and same partition, I recalled the old result is generated against around 3.4-rc2(not very sure), now is updated
> >to 3.5-rc4, does anyone hit that?
> >
> >
> 
> Quick feedback. I don't see any degradation.
> 
> OLD:  1 MiB, 256 ops; 0.0000 sec (484.027 MiB/sec and 123910.9390 ops/sec)
> THIS: 1 MiB, 256 ops; 0.0000 sec (494.560 MiB/sec and 126607.3195 ops/sec)
> 
> All the tests are very close to the unpatched results.

Sounds like the change in size pushed the workload from running in
memory under the dirty limit to being over the dirty limit and
running at disk speed rather than page cache speed. i.e. the
behaviour is RAM size dependent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
