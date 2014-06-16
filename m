Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FE3329DF8
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 17:29:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B627DAC008
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 15:29:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zkbizno4oIIIDBnV for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 15:29:07 -0700 (PDT)
Date: Tue, 17 Jun 2014 08:27:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140616222729.GE9508@dastard>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
	<20140612234441.GT9508@dastard>
	<20140613162352.GB23394@infradead.org>
	<20140615223323.GB9508@dastard> <20140616020030.GC9508@dastard>
	<539E5D66.8040605@kernel.dk> <20140616071951.GD9508@dastard>
	<539F45E2.5030909@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <539F45E2.5030909@kernel.dk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-man@vger.kernel.org

On Mon, Jun 16, 2014 at 01:30:42PM -0600, Jens Axboe wrote:
> On 06/16/2014 01:19 AM, Dave Chinner wrote:
> > On Sun, Jun 15, 2014 at 08:58:46PM -0600, Jens Axboe wrote:
> >> On 2014-06-15 20:00, Dave Chinner wrote:
> >>> On Mon, Jun 16, 2014 at 08:33:23AM +1000, Dave Chinner wrote:
> >>> FWIW, the non-linear system CPU overhead of a fs_mark test I've been
> >>> running isn't anything related to XFS.  The async fsync workqueue
> >>> results in several thousand worker threads dispatching IO
> >>> concurrently across 16 CPUs:
> >>>
> >>> $ ps -ef |grep kworker |wc -l
> >>> 4693
> >>> $
> >>>
> >>> Profiles from 3.15 + xfs for-next + xfs aio_fsync show:
> >>>
> >>> -  51.33%  [kernel]            [k] percpu_ida_alloc
> >>>    - percpu_ida_alloc
> >>>       + 85.73% blk_mq_wait_for_tags
> >>>       + 14.23% blk_mq_get_tag
> >>> -  14.25%  [kernel]            [k] _raw_spin_unlock_irqrestore
> >>>    - _raw_spin_unlock_irqrestore
> >>>       - 66.26% virtio_queue_rq
> >>>          - __blk_mq_run_hw_queue
> >>>             - 99.65% blk_mq_run_hw_queue
> >>>                + 99.47% blk_mq_insert_requests
> >>>                + 0.53% blk_mq_insert_request
> >>> .....
> >>> -   7.91%  [kernel]            [k] _raw_spin_unlock_irq
> >>>    - _raw_spin_unlock_irq
> >>>       - 69.59% __schedule
> >>>          - 86.49% schedule
> >>>             + 47.72% percpu_ida_alloc
> >>>             + 21.75% worker_thread
> >>>             + 19.12% schedule_timeout
> >>> ....
> >>>       + 18.06% blk_mq_make_request
> >>>
> >>> Runtime:
> >>>
> >>> real    4m1.243s
> >>> user    0m47.724s
> >>> sys     11m56.724s
> >>>
> >>> Most of the excessive CPU usage is coming from the blk-mq layer, and
> >>> XFS is barely showing up in the profiles at all - the IDA tag
> >>> allocator is burning 8 CPUs at about 60,000 write IOPS....
> >>>
> >>> I know that the tag allocator has been rewritten, so I tested
> >>> against a current a current Linus kernel with the XFS aio-fsync
> >>> patch. The results are all over the place - from several sequential
> >>> runs of the same test (removing the files in between so each tests
> >>> starts from an empty fs):
> >>>
> >>> Wall time	sys time	IOPS	 files/s
> >>> 4m58.151s	11m12.648s	30,000	 13,500
> >>> 4m35.075s	12m45.900s	45,000	 15,000
> >>> 3m10.665s	11m15.804s	65,000	 21,000
> >>> 3m27.384s	11m54.723s	85,000	 20,000
> >>> 3m59.574s	11m12.012s	50,000	 16,500
> >>> 4m12.704s	12m15.720s	50,000	 17,000
> >>>
> >>> The 3.15 based kernel was pretty consistent around the 4m10 mark,
> >>> generally only +/-10s in runtime and not much change in system time.
> >>> The files/s rate reported by fs_mark doesn't vary that much, either.
> >>> So the new tag allocator seems to be no better in terms of IO
> >>> dispatch scalability, yet adds significant variability to IO
> >>> performance.
> >>>
> >>> What I noticed is a massive jump in context switch overhead: from
> >>> around 250,000/s to over 800,000/s and the CPU profiles show that
> >>> this comes from the new tag allocator:
> >>>
> >>> -  34.62%  [kernel]  [k] _raw_spin_unlock_irqrestore
> >>>    - _raw_spin_unlock_irqrestore
> >>>       - 58.22% prepare_to_wait
> >>>            100.00% bt_get
> >>>               blk_mq_get_tag
> >>>               __blk_mq_alloc_request
> >>>               blk_mq_map_request
> >>>               blk_sq_make_request
> >>>               generic_make_request
> >>>       - 22.51% virtio_queue_rq
> >>>            __blk_mq_run_hw_queue
> >>> ....
> >>> -  21.56%  [kernel]  [k] _raw_spin_unlock_irq
> >>>    - _raw_spin_unlock_irq
> >>>       - 58.73% __schedule
> >>>          - 53.42% io_schedule
> >>>               99.88% bt_get
> >>>                  blk_mq_get_tag
> >>>                  __blk_mq_alloc_request
> >>>                  blk_mq_map_request
> >>>                  blk_sq_make_request
> >>>                  generic_make_request
> >>>          - 35.58% schedule
> >>>             + 49.31% worker_thread
> >>>             + 32.45% schedule_timeout
> >>>             + 10.35% _xfs_log_force_lsn
> >>>             + 3.10% xlog_cil_force_lsn
> >>> ....
.....
> Can you try with this patch?

Ok, context switches are back down in the realm of 400,000/s. It's
better, but it's still a bit higher than that the 3.15 code. XFS is
actually showing up in the context switch path profiles now...

However, performance is still excitingly variable and not much
different to not having this patch applied. System time is unchanged
(still around the 11m20s +/- 1m) and IOPS, wall time and files/s all
show significant variance (at least +/-25%) from run to run. The
worst case is not as slow as the unpatched kernel, but it's no
better than the 3.15 worst case.

Profiles on a slow run look like:

-  43.43%  [kernel]  [k] _raw_spin_unlock_irq
   - _raw_spin_unlock_irq
      - 64.23% blk_sq_make_request
           generic_make_request
          submit_bio                                                       =
                                                                           =
                =BF
      + 26.79% __schedule
...
-  15.00%  [kernel]  [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 39.81% virtio_queue_rq
           __blk_mq_run_hw_queue
      + 24.13% complete
      + 17.74% prepare_to_wait_exclusive
      + 9.66% remove_wait_queue

Looks like the main contention problem is in blk_sq_make_request().
Also, there looks to be quite a bit of lock contention on the tag
wait queues given that this patch made prepare_to_wait_exclusive()
suddenly show up in the profiles.

FWIW, on a fast run there is very little time in
blk_sq_make_request() lock contention, and overall spin lock/unlock
overhead of these two functions is around 10% each....

So, yes, the patch reduces context switches but doesn't really
reduce system time, improve performance noticably or address the
run-to-run variability issue...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
