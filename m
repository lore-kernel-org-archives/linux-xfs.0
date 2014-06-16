Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE93C7F3F
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 21:01:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 488E0AC083
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 19:01:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iB8nZYriwfOWZ4KI for <xfs@oss.sgi.com>;
	Sun, 15 Jun 2014 19:00:55 -0700 (PDT)
Date: Mon, 16 Jun 2014 12:00:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140616020030.GC9508@dastard>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
	<20140612234441.GT9508@dastard>
	<20140613162352.GB23394@infradead.org>
	<20140615223323.GB9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140615223323.GB9508@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org, axboe@kernel.dk, xfs@oss.sgi.com

On Mon, Jun 16, 2014 at 08:33:23AM +1000, Dave Chinner wrote:
> On Fri, Jun 13, 2014 at 09:23:52AM -0700, Christoph Hellwig wrote:
> > On Fri, Jun 13, 2014 at 09:44:41AM +1000, Dave Chinner wrote:
> > > On Thu, Jun 12, 2014 at 07:13:29AM -0700, Christoph Hellwig wrote:
> > > > There doesn't really seem anything XFS specific here, so instead
> > > > of wiring up ->aio_fsync I'd implement IOCB_CMD_FSYNC in fs/aio.c
> > > > based on the workqueue and ->fsync.
> > > 
> > > I really don't know whether the other ->fsync methods in other
> > > filesystems can stand alone like that. I also don't have the
> > > time to test that it works properly on all filesystems right now.
> > 
> > Of course they can, as shown by various calls to vfs_fsync_range that
> > is nothing but a small wrapper around ->fsync.
> 
> Sure, but that's not getting 10,000 concurrent callers, is it? And
> some fsync methods require journal credits, and others serialise
> completely, and so on.
> 
> Besides, putting an *unbound, highly concurrent* aio queue into the
> kernel for an operation that can serialise the entire filesystem
> seems like a pretty nasty user-level DOS vector to me.

FWIW, the non-linear system CPU overhead of a fs_mark test I've been
running isn't anything related to XFS.  The async fsync workqueue
results in several thousand worker threads dispatching IO
concurrently across 16 CPUs:

$ ps -ef |grep kworker |wc -l
4693
$

Profiles from 3.15 + xfs for-next + xfs aio_fsync show:

-  51.33%  [kernel]            [k] percpu_ida_alloc
   - percpu_ida_alloc
      + 85.73% blk_mq_wait_for_tags
      + 14.23% blk_mq_get_tag
-  14.25%  [kernel]            [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 66.26% virtio_queue_rq
         - __blk_mq_run_hw_queue
            - 99.65% blk_mq_run_hw_queue
               + 99.47% blk_mq_insert_requests
               + 0.53% blk_mq_insert_request
.....
-   7.91%  [kernel]            [k] _raw_spin_unlock_irq
   - _raw_spin_unlock_irq
      - 69.59% __schedule
         - 86.49% schedule
            + 47.72% percpu_ida_alloc
            + 21.75% worker_thread
            + 19.12% schedule_timeout
....
      + 18.06% blk_mq_make_request

Runtime:

real    4m1.243s
user    0m47.724s
sys     11m56.724s

Most of the excessive CPU usage is coming from the blk-mq layer, and
XFS is barely showing up in the profiles at all - the IDA tag
allocator is burning 8 CPUs at about 60,000 write IOPS....

I know that the tag allocator has been rewritten, so I tested
against a current a current Linus kernel with the XFS aio-fsync
patch. The results are all over the place - from several sequential
runs of the same test (removing the files in between so each tests
starts from an empty fs):

Wall time	sys time	IOPS	 files/s
4m58.151s	11m12.648s	30,000	 13,500
4m35.075s	12m45.900s	45,000	 15,000
3m10.665s	11m15.804s	65,000	 21,000
3m27.384s	11m54.723s	85,000	 20,000
3m59.574s	11m12.012s	50,000	 16,500
4m12.704s	12m15.720s	50,000	 17,000

The 3.15 based kernel was pretty consistent around the 4m10 mark,
generally only +/-10s in runtime and not much change in system time.
The files/s rate reported by fs_mark doesn't vary that much, either.
So the new tag allocator seems to be no better in terms of IO
dispatch scalability, yet adds significant variability to IO
performance.

What I noticed is a massive jump in context switch overhead: from
around 250,000/s to over 800,000/s and the CPU profiles show that
this comes from the new tag allocator:

-  34.62%  [kernel]  [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 58.22% prepare_to_wait
           100.00% bt_get
              blk_mq_get_tag
              __blk_mq_alloc_request
              blk_mq_map_request
              blk_sq_make_request
              generic_make_request
      - 22.51% virtio_queue_rq
           __blk_mq_run_hw_queue
....
-  21.56%  [kernel]  [k] _raw_spin_unlock_irq
   - _raw_spin_unlock_irq
      - 58.73% __schedule
         - 53.42% io_schedule
              99.88% bt_get
                 blk_mq_get_tag
                 __blk_mq_alloc_request
                 blk_mq_map_request
                 blk_sq_make_request
                 generic_make_request
         - 35.58% schedule
            + 49.31% worker_thread
            + 32.45% schedule_timeout
            + 10.35% _xfs_log_force_lsn
            + 3.10% xlog_cil_force_lsn
....

The new block-mq tag allocator is hammering the waitqueues and
that's generating a large amount of lock contention. It looks like
the new allocator replaces CPU burn doing work in the IDA allocator
with the same amount of CPU burn from extra context switch
overhead....

Oh, OH. Now I understand!

# echo 4 > /sys/block/vdc/queue/nr_requests

<run workload>

80.56%  [kernel]  [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 98.49% prepare_to_wait
           bt_get
           blk_mq_get_tag
           __blk_mq_alloc_request
           blk_mq_map_request
           blk_sq_make_request
           generic_make_request
         + submit_bio
      + 1.07% finish_wait
+  13.63%  [kernel]  [k] _raw_spin_unlock_irq
...

It's context switch bound at 800,000 context switches/s, burning all
16 CPUs waking up and going to sleep and doing very little real
work. How little real work? About 3000 IOPS for 2MB/s of IO. That
amount of IO should only take a single digit CPU percentage of one
CPU.

This seems like bad behaviour to have on a congested block device,
even a high performance one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
