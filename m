Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5M19Jjl040762 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 20:09:20 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA05E2055A
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 18:09:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6k8WoruMpFjHMScr for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2011 18:09:16 -0700 (PDT)
Date: Wed, 22 Jun 2011 11:09:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Message-ID: <20110622010911.GS32466@dastard>
References: <20110617131401.GC2141@infradead.org>
	<20110620081802.GA27111@infradead.org>
	<20110621003343.GJ32466@dastard>
	<20110621092920.GA24540@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110621092920.GA24540@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, xfs@oss.sgi.com

On Tue, Jun 21, 2011 at 05:29:20AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 21, 2011 at 10:33:43AM +1000, Dave Chinner wrote:
> > > The minor one is that we always flush all work items and not just those
> > > on the filesystem to be flushed.  This might become an issue for lager
> > > systems, or when we apply a similar scheme to fsync, which has the same
> > > underlying issue.
> > 
> > For sync, I don't think it matters if we flush a few extra IO
> > completions on a busy system. For fsync, it could increase fsync
> > completion latency significantly, though I'd suggest we should
> > address that problem when we apply the scheme to fsync.
> 
> > > The major one is that flush_workqueue only flushed work items that were
> > > queued before it was called, but we can requeue completions when we fail
> > > to get the ilock in xfs_setfilesize, which can lead to losing i_size
> > > updates when it happens.
> > 
> > Yes, I can see that will cause problems....
> > 
> > > I see two ways to fix this:  either we implement our own workqueue
> > > look-alike based on the old workqueue code.  This would allow flushing
> > > queues per-sb or even per-inode, and allow us to special case flushing
> > > requeues as well before returning.
> > 
> > No need for a look-alike.  With the CMWQ infrastructure, there is no
> > reason why we need global workqueues anymore. The log, data and
> > convert wqs were global to minimise the number of per-cpu threads
> > XFS required to operate. CMWQ prevents the explosion of mostly idle
> > kernel threads, so we could move all these workqueues to per- struct
> > xfs_mount without undue impact.
> 
> That helps to work around the impact of syncs on other filesystems, but
> it does not help with the EAGAIN requeueing.

Right. I wasn't suggesting that it would. I was just talking out
loud about why we have the current structure and how the reasons for
it existing weren't relevant anymore. Hence changing the workqueue
context is something we should be able to do with little impact....

> > I don't think we want to go to per-inode work contexts. One
> > possibility is that for fsync related writeback (e.g. WB_SYNC_ALL)
> 
> WB_SYNC_ALL is also used for the second pass of sync.

Sure, but that is effectively the same case as fsync as most of the
dirty pages would already be written by the WB_SYNC_NONE pass.
Regardless, all and extra fsync completion queue would mean is that
that sync would also need to flush the fsync-completion queue.....

> > we could have a separate "fsync-completion" wqs that we queue
> > completions to rather than the more widely used data workqueue. Then
> > for fsync we'd only need to flush the fsync-completion workqueue
> > rather than the mount wide data and convert wqs, and hence we
> > wouldn't stall on IO completion for IO outside of fsync scope...
> 
> One thing I've thought about is abusing current->journal_info to
> complete ioends in-processes for fsync.

Oh, now that is devious. I've never considered abusing that field
in the task context before ;)

> That will need Josefs patch
> to move the filemap_write_and_wait call into ->fsync.  At that point
> we can do:
> 
> xfs_fsync() {
> 
> 	current->journal_info = &ioend_end_list;
> 
> 	filemap_write_and_wait();
> 
> 	list_for_each_entry_reverse(ioend_end_list) {
> 		process_ioend();
> 	}
> 
> 	current->journal_info = NULL;
> 
> which means there's no context switch involved, and as an added benefit
> we processing the list reverse means we minimize the number of i_size
> updates, which will be especially interesting with my changes to always
> log these directly and get rid of the unlogged metadata changes.

All good, except I think there's a small problem with this - we have
to process the ioends before pages will transition from WRITEBACK to
clean. i.e. it is not until xfs_ioend_destroy() that we call the
bh->b_end_io() function to update the page state. Hence it would
have to be:

xfs_fsync() {

	current->journal_info = &ioend_end_list;

	filemap_fdatawrite();

	list_for_each_entry_reverse(ioend_end_list) {
		/* process_ioend also waits for ioend completion */
		process_ioend();
	}

	current->journal_info = NULL;

	filemap_fdatawait();
}

> It does not cover ioends always pending before we called fsync, but
> I hope we can live with that.

That is not a problem - those pages will be marked WRITEBACK so the
filemap_fdatawait() will catch them. All that will happen is we'll
take a latency hit when there is a concurrent cleaner running.

Direct IO is another matter, but we've already got an
xfs_ioend_wait() in xfs_fsync() to deal with that. Perhaps that
could be moved over to your new DIO counter so we do block on all
pending IO?

> What we still need to sort out with the workqueue scheme is a way to
> deal with the EAGAIN returns from xfs_setfilesize.  From reading your
> changelog for that change it seems we can simply kill it once we move
> to per-mount completion queues, as the loop device would have it's own
> workqueue. 

Yes, that was the primary issue it was intended to solve. per-mount
work queues was rejected at the time because of the thread explosion
it would cause. That's not a problem now ;)

I'm just trying to remember if there were other problems that the
requeue also solved. I think it was to do with blocking IO
completions when memory is low (ie. something it holding the ilock
but blocking on memory allocation), but that, once again, is solved
with CMWQ allowing multiple outstanding work items to be in
progress concurrently.

> If that sounds reasonable I'll respin a series to move to
> per-mount workqueues, remove the EAGAIN case, and use the workqueue
> flush in sync.  Fsync will be left for later, and I'll ping Josef to
> resend his fsync prototype change.

Yes, sounds like a plan.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
