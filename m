Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4CD57F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 03:56:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F5B6AC003
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 01:56:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cxQcgRw803mbXhyu for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 01:56:03 -0700 (PDT)
Date: Mon, 24 Aug 2015 18:55:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824085549.GB714@dastard>
References: <20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824083437.GP17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824083437.GP17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 24, 2015 at 04:34:37PM +0800, Eryu Guan wrote:
> On Mon, Aug 24, 2015 at 04:24:25PM +1000, Dave Chinner wrote:
> > On Mon, Aug 24, 2015 at 11:18:16AM +0800, Eryu Guan wrote:
> > > On Mon, Aug 24, 2015 at 11:11:23AM +1000, Dave Chinner wrote:
> > > > 
> > > > Eryu, can you change the way you run the event trace to be:
> > > > 
> > > > $ sudo trace-cmd <options> -o <outfile location> ./check <test options>
> > > > 
> > > > rather than running the trace as a background operation elsewhere?
> > > > Maybe that will give better results.
> [snip]
> > Anyway, Eryum long and short of it is that you don't need to worry
> > about testing all the different combinations - we now know that the
> > completion events are occurring, so let's focus on whether the sync
> > code is not waiting for them correctly. Can you trace the following
> > events:
> > 
> > 	xfs_log_force
> > 	xfs_setfilesize
> > 	writeback_queue
> > 	writeback_exec
> > 	writeback_start
> > 	writeback_queue_io
> > 	writeback_written
> > 	writeback_pages_written
> > 
> > basically I'm trying to see if we've got all the BDI events as we'd
> > expect then to be queued and run for sync, and when the ->sync_fs
> > call occurs during the sync process before shutdown and unmount...
> 
> I collected two versions of trace info with crc enabled.
> 
> http://128.199.137.77/writeback-crc/
> 
> This version traced the same events as previous runs.
> 
> http://128.199.137.77/writeback-crc-v2/
> 
> And this version only traced the events you listed above.

OK, I'll look into these later.

> And the results of other tests to check(all done with v4 xfs, with no
> tracepoints enabled):
> 
> > Other things to check (separately):
> >	- change godown to godown -f
> 
> Passed 100 loops.

Yup, I expected that from the last set of traces - the "-f" flag
triggers a log force before shutdown, and that flushes out
transactions that sync missed.

> >	- add a "sleep 5" before running godown after sync
> 
> Failed, if you need the trace info please let me know.

Expected, still nothing to flush transactions before shutdown.

> >	- add a "sleep 5; sync" before running godown
> 
> Passed 100 loops.

expected - sync flushed the transactions it missed on the first
pass.

Thanks for running these tests!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
