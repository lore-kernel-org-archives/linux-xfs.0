Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D6227F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 01:13:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D46628F8068
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 23:13:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r0aMdF0TALntdNPV for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 23:13:23 -0700 (PDT)
Date: Wed, 18 Jun 2014 16:13:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140618061320.GP9508@dastard>
References: <539E5D66.8040605@kernel.dk> <20140616071951.GD9508@dastard>
	<539F45E2.5030909@kernel.dk> <20140616222729.GE9508@dastard>
	<53A0416E.20105@kernel.dk> <20140618002845.GM9508@dastard>
	<53A0F84A.6040708@kernel.dk> <20140618031329.GN9508@dastard>
	<53A10597.6020707@kernel.dk> <20140618050230.GO9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140618050230.GO9508@dastard>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

On Wed, Jun 18, 2014 at 03:02:30PM +1000, Dave Chinner wrote:
> On Tue, Jun 17, 2014 at 08:20:55PM -0700, Jens Axboe wrote:
> > On 2014-06-17 20:13, Dave Chinner wrote:
> > >On Tue, Jun 17, 2014 at 07:24:10PM -0700, Jens Axboe wrote:
> > >>On 2014-06-17 17:28, Dave Chinner wrote:
> > >>>[cc linux-mm]
> > >>>
> > >>>On Tue, Jun 17, 2014 at 07:23:58AM -0600, Jens Axboe wrote:
> > >>>>On 2014-06-16 16:27, Dave Chinner wrote:
> > >>>>>On Mon, Jun 16, 2014 at 01:30:42PM -0600, Jens Axboe wrote:
> > >>>>>>On 06/16/2014 01:19 AM, Dave Chinner wrote:
> > >>>>>>>On Sun, Jun 15, 2014 at 08:58:46PM -0600, Jens Axboe wrote:
> > >>>>>>>>On 2014-06-15 20:00, Dave Chinner wrote:
> > >>>>>>>>>On Mon, Jun 16, 2014 at 08:33:23AM +1000, Dave Chinner wrote:
> > >>>>>>>>>FWIW, the non-linear system CPU overhead of a fs_mark test I've been
> > >>>>>>>>>running isn't anything related to XFS.  The async fsync workqueue
> > >>>>>>>>>results in several thousand worker threads dispatching IO
> > >>>>>>>>>concurrently across 16 CPUs:
> > >....
> > >>>>>>>>>I know that the tag allocator has been rewritten, so I tested
> > >>>>>>>>>against a current a current Linus kernel with the XFS aio-fsync
> > >>>>>>>>>patch. The results are all over the place - from several sequential
> > >>>>>>>>>runs of the same test (removing the files in between so each tests
> > >>>>>>>>>starts from an empty fs):
> > >>>>>>>>>
> > >>>>>>>>>Wall time	sys time	IOPS	 files/s
> > >>>>>>>>>4m58.151s	11m12.648s	30,000	 13,500
> > >>>>>>>>>4m35.075s	12m45.900s	45,000	 15,000
> > >>>>>>>>>3m10.665s	11m15.804s	65,000	 21,000
> > >>>>>>>>>3m27.384s	11m54.723s	85,000	 20,000
> > >>>>>>>>>3m59.574s	11m12.012s	50,000	 16,500
> > >>>>>>>>>4m12.704s	12m15.720s	50,000	 17,000
> 
> ....
> > >But the IOPS rate has definitely increased with this config
> > >- I just saw 90k, 100k and 110k IOPS in the last 3 iterations of the
> > >workload (the above profile is from the 100k IOPS period). However,
> > >the wall time was still only 3m58s, which again tends to implicate
> > >the write() portion of the benchmark for causing the slowdowns
> > >rather than the fsync() portion that is dispatching all the IO...
> > 
> > Some contention for this case is hard to avoid, and the above looks
> > better than 3.15 does. So the big question is whether it's worth
> > fixing the gaps with multiple waitqueues (and if that actually still
> > buys us anything), or whether we should just disable them.
> > 
> > If I can get you to try one more thing, can you apply this patch and
> > give that a whirl? Get rid of the other patches I sent first, this
> > has everything.
> 
> Not much difference in the CPU usage profiles or base line
> performance. It runs at 3m10s from empty memory, and ~3m45s when
> memory starts full of clean pages. system time varies from 10m40s to
> 12m55s with no real correlation to overall runtime.
> 
> From observation of all the performance metrics I graph in real
> time, however, the pattern of the peaks and troughs from run to run
> and even iteration to iteration is much more regular than the
> previous patches. So from that perspective it is an improvement.
> Again, all the variability in the graphs show up when free memory
> runs out...

And I've identified the commit that caused the memory reclaim
behaviour to go south:

commit 1f6d64829db78a7e1d63e15c9f48f0a5d2b5a679
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:59:59 2014 +1000

    xfs: block allocation work needs to be kswapd aware
    
    Upon memory pressure, kswapd calls xfs_vm_writepage() from
    shrink_page_list(). This can result in delayed allocation occurring
    and that gets deferred to the the allocation workqueue.
    
    The allocation then runs outside kswapd context, which means if it
    needs memory (and it does to demand page metadata from disk) it can
    block in shrink_inactive_list() waiting for IO congestion. These
    blocking waits are normally avoiding in kswapd context, so under
    memory pressure writeback from kswapd can be arbitrarily delayed by
    memory reclaim.
    
    To avoid this, pass the kswapd context to the allocation being done
    by the workqueue, so that memory reclaim understands correctly that
    the work is being done for kswapd and therefore it is not blocked
    and does not delay memory reclaim.
    
    To avoid issues with int->char conversion of flag fields (as noticed
    in v1 of this patch) convert the flag fields in the struct
    xfs_bmalloca to bool types. pahole indicates these variables are
    still single byte variables, so no extra space is consumed by this
    change.
    
    cc: <stable@vger.kernel.org>
    Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

Reverting this patch results in runtimes of between 3m and 3m10s
regardless of the amount of free memory when the test starts.

I'm probably going to have to revert this and make sure it stays out
of the stable kernels now - I think that unbalancing memory reclaim
and introducing performance degradations of 25-30% to work around a
problem that is only hit by an extreme memory pressure stress test
is a bad trade-off.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
