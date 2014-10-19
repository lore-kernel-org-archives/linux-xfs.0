Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D6FB07F4E
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2014 17:24:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C51D1304032
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2014 15:24:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	73py1sS4fnVJPmeM for <xfs@oss.sgi.com>;
	Sun, 19 Oct 2014 15:24:37 -0700 (PDT)
Date: Mon, 20 Oct 2014 09:24:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: gather write metrics on multiple files
Message-ID: <20141019222434.GL17506@dastard>
References: <543611CF.6030904@hardwarefreak.com> <543613E7.70508@gmail.com>
	<54361C04.5090404@hardwarefreak.com>
	<20141009211339.GD4376@dastard>
	<544202AE.3000003@hardwarefreak.com>
	<5442AE9A.7030703@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5442AE9A.7030703@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

[ please word wrap your emails at 68-72 columns ]

On Sat, Oct 18, 2014 at 01:16:58PM -0500, Stan Hoeppner wrote:
> On 10/18/2014 01:03 AM, Stan Hoeppner wrote:
> > On 10/09/2014 04:13 PM, Dave Chinner wrote:
> > ...
> >>> I'm told we have 800 threads writing to nearly as many files
> >>> concurrently on a single XFS on a 12+2 spindle RAID6 LUN.
> >>> Achieved data rate is currently ~300 MiB/s.  Some of these are
> >>> files are supposedly being written at a rate of only 32KiB every
> >>> 2-3 seconds, while some (two) are ~50 MiB/s.  I need to determine
> >>> how many bytes we're writing to each of the low rate files, and
> >>> how many files, to figure out RMW mitigation strategies.  Out of
> >>> the apparent 800 streams 700 are these low data rate suckers, one
> >>> stream writing per file.  
> >>>
> >>> Nary a stock RAID controller is going to be able to assemble full
> >>> stripes out of these small slow writes.  With a 768 KiB stripe
> >>> that's what, 24 seconds to fill it at 2 seconds per 32 KiB IO?
> >>
> >> Raid controllers don't typically have the resources to track
> >> hundreds of separate write streams at a time. Most don't have the
> >> memory available to track that many active write streams, and those
> >> that do probably can't proritise writeback sanely given how slowly
> >> most cachelines would be touched. The fast writers would simply tune
> >> over the slower writer caches way too quickly.
> >>
> >> Perhaps you need to change the application to make the slow writers
> >> buffer stripe sized writes in memory and flush them 768k at a
> >> time...
> > 
> > All buffers are now 768K multiples--6144, 768, 768, and I'm told
> > the app should be writing out full buffers.  However I'm not
> > seeing the throughput increase I should given the amount that
> > the RMWs should have decreased, which, if my math is correct,

Maybe that's not your problem. What's the storage array tell you
about RMW cycles? What's it tell you about lun utilisation - is it
even or do you have hot luns?

> > should be about half (80) the raw actuator seek rate of these
> > drives (7.2k SAS).

Not all drives seek at the same rate. Typically for a RAID 6 array,
every disk you add to the width of the lun slows the seek rate for
full stripe writes by 2-3%. So a 12+2 lun is going to have an
average seek rate of 25-30% lower than a 2+1 lun on full stripe
writes....

> > Something isn't right.  I'm guessing it's
> > the controller firmware, maybe the test app, or both.  The test
> > app backs off then ramps up when response times at the
> > controller go up and back down.  And it's not super accurate or
> > timely about it.  The lowest interval setting possible is 10
> > seconds.  Which is way too high when a controller goes into
> > congestion.

The controller should not have any problems with this. If the
controller IO response times are varying significantly, then you're
doing something wrong - most probably caching in BBWC rather than
writing through to disk immediately...

> > Does XFS give alignment hints with O_DIRECT writes into
> > preallocated files?

What do you mean? if the file is preallocated and aligned, then
the IO alignment is wholly up to the application. i.e. if the
application is not doing aligned IO, then there's nothing the
filesystem can do to align it...

> > The filesystems were aligned at make time
> > w/768K stripe width, so each prealloc file should be aligned on
> > a stripe boundary.

"should be aligned"? You haven't verified they are aligned by using
with 'xfs_bmap -vp'?

> > I've played with the various queue settings,
> > even tried deadline instead of noop hoping more LBAs could be
> > sorted before hitting the controller.  Can't seem to get a
> > repeatable increase.  I've nr_requests at 524288, rq_affinity 2,
> > read_ahead_kb 0 since reads are <20% of the IO, add_random 0,
> > etc.  Nothing seems to help really.

nr_requests = 524288? Why do you want to queue half a million IOs
once the CTQ depth has overflowed? That's a major latency problem
right there.

You've got latency problems, so your should be removing any source
of potential or variable latency in the IO stack. e.g. turning off
all IO scheduler queuing, reducing CTQ depth and using write through
caching so you can observe the behaviour of the raw luns. Strip it
right back, then observe...

> Some additional background:
> 
>     Num. Streams     = 350
>     WRITING:
>         Num. Write Threads  = 100
>         Avg. Write Rate     =       72 KiB/s
>         Avg. Write Intvl    = 10666.666 ms
>         Num. Write Buffers  = 426
>         Write Buffer Size   = 768 KiB
>         Write Buffer Mem.   = 327168 KiB
>         Group Write Rate    =    25200 KiB/s
>         Avg. Buffer Rate    = 32.812 bufs/s
>         Avg. Buffer Intvl.  = 30.476 ms
>         Avg. Thread Intvl.  = 3047.600 ms
> 
> The 350 streams are written to 350 preallocated files in parallel.

And they layout of those files are? If you don't know the physical
layout of the files and what disks in the storage array they map to,
then you can't determine what the seek times should be. If you can't
work out what the seek times should be, then you don't know what the
stream capacity of the storage should be.

Keep in mind that single extent files are optimised for read
performance, not write performance. i.e. by default XFS trades off
some write performance to improve file read performance.  Optimising
for highest write speeds means linearising all writes (i.e. reducing
seeks), while XFS's default behaviour is to separate them into
different regions of the disk (increasing seeks).

IOWs, write rates are likely to go up if you allow files to be
fragmented and interleaved to make writes more sequential.
The down side is that reads will then seek, but if reads aren't the
primary workload, nor a performance sensitive operation, then
perhaps you're optimising for the wrong operation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
