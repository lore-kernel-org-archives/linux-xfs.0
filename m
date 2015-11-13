Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39EFD7F6C
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 06:20:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29B758F8033
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 04:20:05 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id aqDnHVixO5PzyY5E (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 04:20:02 -0800 (PST)
Subject: Re: memory reclaim problems on fs usage
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201511111719.44035.arekm@maven.pl>
	<201511120719.EBF35970.OtSOHOVFJMFQFL@I-love.SAKURA.ne.jp>
	<201511120706.10739.arekm@maven.pl>
	<56449E44.7020407@I-love.SAKURA.ne.jp>
	<20151112200641.GR19199@dastard>
In-Reply-To: <20151112200641.GR19199@dastard>
Message-Id: <201511132119.BAG65154.QVHStOOFFMOLFJ@I-love.SAKURA.ne.jp>
Date: Fri, 13 Nov 2015 21:19:46 +0900
Mime-Version: 1.0
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
To: david@fromorbit.com
Cc: htejun@gmail.com, xfs@oss.sgi.com, linux-mm@kvack.org, mhocko@suse.com, cl@linux.com

Dave Chinner wrote:
> So why have we only scanned *176* pages* during reclaim?  On other
> OOM reports in this trace it's as low as 12.  Either that stat is
> completely wrong, or we're not doing sufficient page LRU reclaim
> scanning....
> 
> > [ 9662.234685] MemAlloc-Info: 3 stalling task, 0 dying task, 0 victim task.
> > 
> > vmstat_update() and submit_flushes() remained pending for about 110 seconds.
> > If xlog_cil_push_work() were spinning inside GFP_NOFS allocation, it should be
> > reported as MemAlloc: traces, but no such lines are recorded. I don't know why
> > xlog_cil_push_work() did not call schedule() for so long.
> 
> I'd say it is repeatedly waiting for IO completion on log buffers to
> write out the checkpoint. It's making progress, just if it's taking
> multiple second per journal IO it will take a long time to write a
> checkpoint. All the other blocked tasks in XFS inode reclaim are
> either waiting directly on IO completion or waiting for the log to
> complete a flush, so this really just looks like an overloaded IO
> subsystem to me....

The vmstat statistics can become wrong when vmstat_update() workqueue item
cannot be processed due to in-flight workqueue item not calling schedule().
If in-flight workqueue item (in this case xlog_cil_push_work()) called
schedule(), the pending vmstat_update() workqueue item will be processed
and the vmstat becomes up to dated. Like you expect that xlog_cil_push_work()
was waiting for IO completion on log buffers rather than spinning inside
GFP_NOFS allocation, what should happened is xlog_cil_push_work() called
schedule() and vmstat_update() was processed. But vmstat_update() remained
pending for about 110 seconds. That's strange...

Arkadiusz is trying http://marc.info/?l=linux-mm&m=144725782107096&w=2
which is for making sure that vmstat_update() workqueue item is processed
by changing wait_iff_congested() to call schedule(), and we are waiting
for test results.

Well, one of dependent patches "vmstat: explicitly schedule per-cpu work
on the CPU we need it to run on" might be relevant to this problem.

If http://sprunge.us/GYBb and http://sprunge.us/XWUX solve the problem
(for both with swap case and without swap case), the vmstat statistics
was wrong.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
