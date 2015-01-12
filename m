Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5344A7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:27:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FC00304039
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:27:38 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Lvdaf6yL01P5ial0 for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:27:32 -0800 (PST)
Date: Mon, 12 Jan 2015 14:30:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150112033015.GB29484@destitution>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<20150109232815.GL31508@dastard>
	<20150110174133.GC25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150110174133.GC25319@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jan 10, 2015 at 12:41:33PM -0500, Tejun Heo wrote:
> Hello, Dave.
> 
> On Sat, Jan 10, 2015 at 10:28:15AM +1100, Dave Chinner wrote:
> > process A			kworker (1..N)
> > ilock(excl)
> > alloc
> >   queue work(allocwq)
> >     (work queued as no kworker
> >      threads available)
> >      				execute work from xfsbuf-wq
> >      				xfs_end_io
> > 				  ilock(excl)
> > 				    (blocks waiting on queued work)
> > 
> > No new kworkers are started, so the queue never makes progress,
> > we deadlock.
> 
> But allocwq is a separate workqueue from xfsbuf-wq and should have its
> own rescuer.  The work item queued by process on A is guaranteed to
> make forward progress no matter what work items on xfsbuf-wq are
> doing.  The deadlock as depicted above cannot happen.  A workqueue
> with WQ_MEM_RECLAIM can deadlock iff an executing work item on the
> workqueue deadlocks.

Eric will have to confirm, but I recall asking Eric to check the
recuer threads and that they were idle...

....

> > before the end-io processing of the xfsbuf-wq and unwritten-wq
> > because of this lock inversion, just like we we always want the
> > xfsbufd to run before the unwritten-wq because unwritten extent
> > conversion may block waiting for metadata buffer IO to complete, and
> > we always want the the xfslog-wq works to run before all of them
> > because metadata buffer IO may get blocked waiting for buffers
> > pinned by the log to be unpinned for log Io completion...
> 
> I'm not really following your logic here.  Are you saying that xfs is
> trying to work around cyclic dependency by manipulating execution
> order of specific work items?

No, it's not cyclic. They are different dependencies.

Data IO completion can take the XFS inode i_lock. i.e. in the
mp->m_data_workqueue and the mp->m_unwritten_workqueue.

mp->m_data_workqueue has no other dependencies.

mp->m_unwritten_workqueue reads buffers, so is dependent on
mp->m_buf_workqueue for buffer IO completion.

mp->m_unwritten_workqueue can cause btree splits, which can defer
work to the xfs_alloc_wq.

xfs_alloc_wq reads buffers, so it dependent on the
mp->m_buf_workqueue for buffer IO completion.

So lock/wq ordering dependencies are:

m_data_workqueue -> i_lock
m_unwritten_workqueue -> i_lock -> xfs_alloc_wq -> m_buf_workqueue
syscall -> i_lock -> xfs_alloc_wq -> m_buf_workqueue

The issue we see is:

process A:	write(2) -> i_lock -> xfs_allow_wq
kworkers:	m_data_workqueue -> i_lock
		(blocked on process A work completion)

Queued work:  m_data_workqueue work, xfs_allow_wq work

Queued work does not appear to be dispatched for some reason, wq
concurrency depth does not appear to be exhausted and rescuer
threads do not appear to be active. Something has gone wrong for
the queued work to be stalled like this.

> There no reason to play with priorities to avoid deadlock.  That
> doesn't make any sense to me.  Priority or chained queueing, which is

Prioritised work queuing is what I suggested, not modifying kworker
scheduler priorities...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
