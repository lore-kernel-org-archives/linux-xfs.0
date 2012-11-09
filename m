Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA98EfEt088062 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 02:14:41 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SnfFF1tFFcxyTqKM for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 00:16:39 -0800 (PST)
Date: Fri, 9 Nov 2012 19:16:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: better perf and memory uage for xfs_fsr? Trivial patch against
	xfstools-3.16 included...
Message-ID: <20121109081636.GD6434@dastard>
References: <509BAABF.3030608@tlinx.org> <509C1653.7050906@tlinx.org>
	<20121108213911.GS6434@dastard> <509CAC62.3040508@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509CAC62.3040508@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 08, 2012 at 11:10:26PM -0800, Linda Walsh wrote:
> 
> 
> Dave Chinner wrote:
> >On Thu, Nov 08, 2012 at 12:30:11PM -0800, Linda Walsh wrote:
> >>FWIW, the benefit, probably comes from the read-file, as the written file
> >>is written with DIRECT I/O and I can't see that it should make a difference
> >>there.
> >
> >Hmmm, so it does. I think that's probably the bug that needs to be
> >fixed, not so much using posix_fadvise....
> ---
> 	Well... using direct I/O might be another way of fixing it...
> but I notice that neither the reads nor the writes seem to use the optimal
> I/O size that takes into consideration RAID alignment.  It aligns for memory
> alignment and aligns for a 2-4k device alignment, but doesn't seem to take
> into consideration minor things like a 64k strip-unit x 12-wide-data-width
> (768k).. if you do direct I/O. might want to be sure to RAID align it...

Sure, you can get that information from the fs geometry ioctl.

> 	Doing <64k at a time would cause heinous perf... while using

#define BUFFER_MAX      (1<<24)
....
                blksz_dio = min(dio.d_maxiosz, BUFFER_MAX - pagesize);
                if (argv_blksz_dio != 0)
                        blksz_dio = min(argv_blksz_dio, blksz_dio);
                blksz_dio = (min(statp->bs_size, blksz_dio) / dio_min) * dio_min

so, the buffer size starts at 16MB, and  ends up the minimum of the
buffer size and the file size. As can be seen here:

/mnt/test/foo extents=6 can_save=1 tmp=/mnt/test/.fsr4188
DEBUG: fsize=17825792 blsz_dio=16773120 d_min=512 d_max=2147483136 pgsz=4096

So, really, if you want to change that to be stripe width aligned,
you could quite easily do that...

However, if you really wanted to increase fsr throughput, using AIO
and keeping multiple IOs in flight at once woul dbe a much better
option as it would avoid the serialised read-write-read-write-...
pattern tha limits the throughput now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
