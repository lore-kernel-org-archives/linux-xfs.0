Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0326F7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 03:34:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76663AC001
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 01:34:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vMGMxmV1cpxOkUNO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 01:34:41 -0700 (PDT)
Date: Mon, 24 Aug 2015 16:34:37 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824083437.GP17933@dhcp-13-216.nay.redhat.com>
References: <20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824062425.GU3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 24, 2015 at 04:24:25PM +1000, Dave Chinner wrote:
> On Mon, Aug 24, 2015 at 11:18:16AM +0800, Eryu Guan wrote:
> > On Mon, Aug 24, 2015 at 11:11:23AM +1000, Dave Chinner wrote:
> > > 
> > > Eryu, can you change the way you run the event trace to be:
> > > 
> > > $ sudo trace-cmd <options> -o <outfile location> ./check <test options>
> > > 
> > > rather than running the trace as a background operation elsewhere?
> > > Maybe that will give better results.
[snip]
> Anyway, Eryum long and short of it is that you don't need to worry
> about testing all the different combinations - we now know that the
> completion events are occurring, so let's focus on whether the sync
> code is not waiting for them correctly. Can you trace the following
> events:
> 
> 	xfs_log_force
> 	xfs_setfilesize
> 	writeback_queue
> 	writeback_exec
> 	writeback_start
> 	writeback_queue_io
> 	writeback_written
> 	writeback_pages_written
> 
> basically I'm trying to see if we've got all the BDI events as we'd
> expect then to be queued and run for sync, and when the ->sync_fs
> call occurs during the sync process before shutdown and unmount...

I collected two versions of trace info with crc enabled.

http://128.199.137.77/writeback-crc/

This version traced the same events as previous runs.

http://128.199.137.77/writeback-crc-v2/

And this version only traced the events you listed above.


And the results of other tests to check(all done with v4 xfs, with no
tracepoints enabled):

> Other things to check (separately):
>	- change godown to godown -f

Passed 100 loops.

>	- add a "sleep 5" before running godown after sync

Failed, if you need the trace info please let me know.

>	- add a "sleep 5; sync" before running godown

Passed 100 loops.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
