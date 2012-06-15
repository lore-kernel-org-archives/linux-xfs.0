Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5FCTe56089264 for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 07:29:40 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	t7p7tSBpNc1Jv8yS for <xfs@oss.sgi.com>;
	Fri, 15 Jun 2012 05:29:37 -0700 (PDT)
Date: Fri, 15 Jun 2012 22:29:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120615122934.GB19223@dastard>
References: <4FD66513.2000108@xsnews.nl> <4FD9F5B3.3040901@xsnews.nl>
	<20120615001602.GF7339@dastard> <47854255.KfXFdqTbOZ@saturn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47854255.KfXFdqTbOZ@saturn>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Jun 15, 2012 at 11:52:17AM +0200, Michael Monnerie wrote:
> Am Freitag, 15. Juni 2012, 10:16:02 schrieb Dave Chinner:
> > So, the average service time for an IO is 10-16ms, which is a seek
> > per IO. You're doing primarily 128k read IOs, and maybe one or 2
> > writes a second. You have a very deep request queue: > 512 requests.
> > Have you tuned /sys/block/sda/queue/nr_requests up from the default
> > of 128? This is going to be one of the causes of your problems - you
> > have 511 oustanding write requests, and only one read at a time.
> > Reduce the ioscehduer queue depth, and potentially also the device
> > CTQ depth.
> 
> Dave, I'm puzzled by this. I'd believe that a higher #req. would help 
> the block layer to resort I/O in the elevator, and therefore help to 
> gain throughput. Why would 128 be better than 512 here?

512 * 16ms per IO = 7-8s IO latency.

Fundamentally, deep queues are as harmful to latency as shallow
queues are to throughput. Everyone says "make the queues deeper" to
get the highest benchmark numbers, but in reality most benchmarks
measure throughput and aren't IO latency sensistive.

I did a bunch of measurement 7 or8 years ago on high end FC HW RAID,
and found that a CTQ depth per lun of 4 was all that was needed to
reach maximum write bandwidth under almost all circumstances. When
doing concurrent read and write with a CTQ depth of 4, the balance
was roughly 50/50 read/write. Al things the same except for a CTQ
depth of 6, and it was 30/70 read/write. And any CTQ depth deeper
than 8 is was roughly 10/90 read/write. That hardware supported a
CTQ depth of 240 IOs per lun....

So even high end hardware that can support a maximum CTQ depth of
256 IOs will see this problem - you'll get 255 writes and a single
read at a time, resulting in terrible read IO latency. There is
always another async write ready to be queued, but the application
doesn't queue another read until the first one completes. Hence
reads always are issued in small numbers and when any IO is
completed, there isn't another read queued ready for dispatch. Hence
all that happens is that async writes are sent to the drive.

And then when the BBWC fills up and has to flush all those writes,
everything slows right done because the cache effective becomes
a write-through cache - it can't take another read or write until
the flush completes another IO and space is freed in the BBWC for
the next IO.

> And maybe Matthew could profit from limiting the vm.dirty_bytes, I've 
> seen when this value is too high the server stucks on lots of writes, 
> for streaming it's better to have this smaller so the disk writes can 
> keep up and delays are not too long.

I pretty much never tune dirty limits anymore - most writeback
problems are storage stack related these days...

> > Oh, I just noticed you are might be using CFQ (it's the default in
> > dmesg). Don't - CFQ is highly unsuited for hardware RAID - it's
> > hueristically tuned to work well on sngle SATA drives. Use deadline,
> > or preferably for hardware RAID, noop.
> 
> Wouldn't deadline be better with a higher rq_qu size? As I understand 
> it, noop only groups adjacent I/Os together, while deadline does a bit 
> more and should be able to get bigger adjacent I/O areas because it 
> waits a bit longer before a flush.

The BBWC does a much better job of sorting and batching IOs than the
io scheduler can ever possibly hope to. Think about it - 512MB can
hold a 100,000 4k IOs and reorder and batch them far more
effectively than a io scheduler with even a 512 request deept
queue.

That's why making the IO scheduler queue deeper with HW RAID is
harmful - it's not needed to reach maximum performance for almost
all workloads, and all it does is add latency to the IO path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
