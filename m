Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbfDOT1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 15:27:50 -0400
Date: Mon, 15 Apr 2019 12:27:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: implement per-inode writeback completion queues
Message-ID: <20190415192739.GE4752@magnolia>
References: <155529406249.243484.1307333973877627694.stgit@magnolia>
 <155529406877.243484.8074329168835632578.stgit@magnolia>
 <20190415144925.GA4222@bfoster>
 <20190415155320.GA4752@magnolia>
 <20190415161347.GD4222@bfoster>
 <20190415170935.GC4752@magnolia>
 <20190415173150.GE4222@bfoster>
 <20190415180042.GD4752@magnolia>
 <20190415181327.GF4222@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415181327.GF4222@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 15, 2019 at 02:13:27PM -0400, Brian Foster wrote:
> On Mon, Apr 15, 2019 at 11:00:43AM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 15, 2019 at 01:31:50PM -0400, Brian Foster wrote:
> > > On Mon, Apr 15, 2019 at 10:09:35AM -0700, Darrick J. Wong wrote:
> > > > On Mon, Apr 15, 2019 at 12:13:47PM -0400, Brian Foster wrote:
> > > > > On Mon, Apr 15, 2019 at 08:53:20AM -0700, Darrick J. Wong wrote:
> > > > > > On Mon, Apr 15, 2019 at 10:49:28AM -0400, Brian Foster wrote:
> > > > > > > On Sun, Apr 14, 2019 at 07:07:48PM -0700, Darrick J. Wong wrote:
> > > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > > 
> > > > > > > > When scheduling writeback of dirty file data in the page cache, XFS uses
> > > > > > > > IO completion workqueue items to ensure that filesystem metadata only
> > > > > > > > updates after the write completes successfully.  This is essential for
> > > > > > > > converting unwritten extents to real extents at the right time and
> > > > > > > > performing COW remappings.
> > > > > > > > 
> > > > > > > > Unfortunately, XFS queues each IO completion work item to an unbounded
> > > > > > > > workqueue, which means that the kernel can spawn dozens of threads to
> > > > > > > > try to handle the items quickly.  These threads need to take the ILOCK
> > > > > > > > to update file metadata, which results in heavy ILOCK contention if a
> > > > > > > > large number of the work items target a single file, which is
> > > > > > > > inefficient.
> > > > > > > > 
> > > > > > > > Worse yet, the writeback completion threads get stuck waiting for the
> > > > > > > > ILOCK while holding transaction reservations, which can use up all
> > > > > > > > available log reservation space.  When that happens, metadata updates to
> > > > > > > > other parts of the filesystem grind to a halt, even if the filesystem
> > > > > > > > could otherwise have handled it.
> > > > > > > > 
> > > > > > > > Even worse, if one of the things grinding to a halt happens to be a
> > > > > > > > thread in the middle of a defer-ops finish holding the same ILOCK and
> > > > > > > > trying to obtain more log reservation having exhausted the permanent
> > > > > > > > reservation, we now have an ABBA deadlock - writeback has a transaction
> > > > > > > > reserved and wants the ILOCK, and someone else has the ILOCk and wants a
> > > > > > > > transaction reservation.
> > > > > > > > 
> > > > > > > > Therefore, we create a per-inode writeback io completion queue + work
> > > > > > > > item.  When writeback finishes, it can add the ioend to the per-inode
> > > > > > > > queue and let the single worker item process that queue.  This
> > > > > > > > dramatically cuts down on the number of kworkers and ILOCK contention in
> > > > > > > > the system, and seems to have eliminated an occasional deadlock I was
> > > > > > > > seeing while running generic/476.
> > > > > > > > 
> > > > > > > > Testing with a program that simulates a heavy random-write workload to a
> > > > > > > > single file demonstrates that the number of kworkers drops from
> > > > > > > > approximately 120 threads per file to 1, without dramatically changing
> > > > > > > > write bandwidth or pagecache access latency.
> > > > > > > > 
> > > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > > ---
> > > > > > > 
> > > > > > > Thanks for the updated commit log. It looks like a couple nits from the
> > > > > > > rfc weren't addressed though. Specifically, to rename the workqueue and
> > > > > > > iodone bits to ioend_[workqueue|list|lock] so as to not confuse with log
> > > > > > > buf (iodone) completion callbacks.
> > > > > > 
> > > > > > Oops, I did forget to rename the iodone part.  Will fix.
> > > > > > 
> > > > > > > Also, this patch essentially turns the unbound completion work queue
> > > > > > > into something that should only expect one task running at a time,
> > > > > > > right? If so, it might make sense to fix up the max_active parameter to
> > > > > > > the alloc_workqueue() call and ...
> > > > > > 
> > > > > > It's fine to leave max_active == 0 (i.e. "spawn as many kworker threads
> > > > > > as you decide are necessary to handle the queued work items") here
> > > > > > because while we only want to have one ioend worker per inode, we still
> > > > > > want to have as many inodes undergoing ioend processing simultaneously
> > > > > > as the storage can handle.
> > > > > > 
> > > > > 
> > > > > Ah, right. For some reason I was thinking this would be per-work..
> > > > > disregard the thinko..
> > > > > 
> > > > > > > 
> > > > > > > >  fs/xfs/xfs_aops.c   |   48 +++++++++++++++++++++++++++++++++++++-----------
> > > > > > > >  fs/xfs/xfs_aops.h   |    1 -
> > > > > > > >  fs/xfs/xfs_icache.c |    3 +++
> > > > > > > >  fs/xfs/xfs_inode.h  |    7 +++++++
> > > > > > > >  4 files changed, 47 insertions(+), 12 deletions(-)
> > > > > > > > 
> > > > > > > > 
> > > > > > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > > > > > index 3619e9e8d359..f7a9bb661826 100644
> > > > > > > > --- a/fs/xfs/xfs_aops.c
> > > > > > > > +++ b/fs/xfs/xfs_aops.c
> > > > > > > ...
> > > > > > > > @@ -278,19 +276,48 @@ xfs_end_io(
> > > > > > > ...
> > > > > > > >  STATIC void
> > > > > > > >  xfs_end_bio(
> > > > > > > >  	struct bio		*bio)
> > > > > > > >  {
> > > > > > > >  	struct xfs_ioend	*ioend = bio->bi_private;
> > > > > > > > -	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> > > > > > > > +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> > > > > > > > +	struct xfs_mount	*mp = ip->i_mount;
> > > > > > > > +	unsigned long		flags;
> > > > > > > >  
> > > > > > > >  	if (ioend->io_fork == XFS_COW_FORK ||
> > > > > > > > -	    ioend->io_state == XFS_EXT_UNWRITTEN)
> > > > > > > > -		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
> > > > > > > > -	else if (ioend->io_append_trans)
> > > > > > > > -		queue_work(mp->m_data_workqueue, &ioend->io_work);
> > > > > > > > -	else
> > > > > > > > +	    ioend->io_state == XFS_EXT_UNWRITTEN ||
> > > > > > > > +	    ioend->io_append_trans != NULL) {
> > > > > > > > +		spin_lock_irqsave(&ip->i_iodone_lock, flags);
> > > > > > > > +		if (list_empty(&ip->i_iodone_list))
> > > > > > > > +			queue_work(mp->m_unwritten_workqueue, &ip->i_iodone_work);
> > > > > > > 
> > > > > > > ... assert that queue_work() always returns true.
> > > > > > 
> > > > > > queue_work can return false here because the worker function only holds
> > > > > > i_ioend_lock long enough to move the i_ioend_list onto a function-local
> > > > > > list head.  Once it drops the lock and begins issuing ioend transactions,
> > > > > > there's nothing preventing another xfs_end_bio from taking the lock,
> > > > > > seeing the empty list, and (re)queuing i_ioend_work while the worker is
> > > > > > running.
> > > > > > 
> > > > > 
> > > > > So I'm not familiar with the details of the wq implementation, but I was
> > > > > assuming that the return value essentially tells us if we've scheduled a
> > > > > new execution of this work or not. IOW, that the case above would return
> > > > > true because the current execution has already dequeued the work and
> > > > > began running it.
> > > > 
> > > > It does return true if we've scheduled a new execution of work.  If the
> > > > work has already been dequeued and is running then it'll queue it again,
> > > > because process_one_work calls set_work_pool_and_clear_pending to clear
> > > > the PENDING bit after it's decided to run the work item but before it
> > > > actually invokes the work function.
> > > > 
> > > > > Is that not the case? FWIW, if the queue_work() call doesn't actually
> > > > > requeue the task if it happens to be running (aside from the semantics
> > > > 
> > > > As far as queue_work is concerned there's no difference between a work
> > > > item that is currently running and a work item that has never been
> > > > queued -- the result for both cases is to put it on the queue.  So I
> > > > think the answer to "is that not the case?" is "no, you got it right in
> > > > the previous paragraph".
> > > > 
> > > > But maybe I'll just work out some examples to satisfy my own sense of
> > > > "egad I looked at the workqueue code and OH MY EYES" :)
> > > > 
> > > 
> > > ;)
> > > 
> > > > If queue_work observes that the PENDING bit was set, it'll return false
> > > > immediately because we know that the work function hasn't been called
> > > > yet, so whatever we just added to the i_ioend_list will get picked up
> > > > when the work function gets called.
> > > > 
> > > > If queue_work observes that PENDING was not set and the work item isn't
> > > > queued or being processed anywhere in the system, it'll add the work
> > > > item to the queue and xfs_end_io can pick up the work from the ioend
> > > > list whenever it does get called.
> > > > 
> > > > If queue_work observes that PENDING was not set and process_one_work has
> > > > picked up the work item and it is after the point where it clears the
> > > > bit but before the work function picks up the ioend list, then we'll
> > > > reqeueue the work item, but the current the work function invocation
> > > > will process our ioend.  The requeued item will be called again, but it
> > > > won't find any work and returns.
> > > > 
> > > 
> > > Wouldn't we skip the queue_work() call in this case because the list is
> > > presumably not empty (since the work being dequeued hasn't run yet to
> > > empty it)?
> > 
> > Oh, right.  Missed the forest for the weeds, ignore this case. :)
> > 
> > > > If queue_work observes that PENDING was not set and process_one_work has
> > > > picked up the work item and it is after the point where the work
> > > > function picks up the ioend list, then we'll reqeueue the work item, the
> > > > current work function invocation won't see our new ioend, and the
> > > > requeued item will be called again and it'll process our new ioend.
> > > > 
> > > 
> > > Doesn't this mean that our queue_work() call should always return true?
> > > We're only calling it if the list is empty, which means either nothing
> > > was queued yet or a work item is currently running and is processing
> > > ioends.
> > 
> > Oh. Yep.  I think you're right that it should always return true.  But,
> > how would we set up an assert that won't just trigger unused variable
> > warnings if we're #defining away ASSERT?
> > 
> 
> Ok. I guess we'd have to ifdef it (or use a WARN_ON[_ONCE]() or
> something), but now that we're on the same page, it's probably not worth
> resending again just for this anyways.

Yeah, I'll add a WARN_ON_ONCE on the way in.  Thanks for reviewing! :)

--D

> 
> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > > of the return value), ISTM that we're at risk of leaving ioends around
> > > > > until something else comes along to kick the handler. A quick look at
> > > > > the wq code suggests queue_work() returns false only when a particular
> > > > > queued bit is set and thus the call is essentially a no-op, but that
> > > > > state appears to be cleared (via set_work_pool_and_clear_pending())
> > > > > before the work callback is invoked. Hm?
> > > > 
> > > > <nod> Does that clear things up?  The wq documentation isn't
> > > > particularly clear in its description of how queues work for end users
> > > > like us. :)
> > > > 
> > > > --D
> > > > 
> > > > > 
> > > > > Brian
> > > > > 
> > > > > > --D
> > > > > > 
> > > > > > > Brian
> > > > > > > 
> > > > > > > > +		list_add_tail(&ioend->io_list, &ip->i_iodone_list);
> > > > > > > > +		spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
> > > > > > > > +	} else
> > > > > > > >  		xfs_destroy_ioend(ioend, blk_status_to_errno(bio->bi_status));
> > > > > > > >  }
> > > > > > > >  
> > > > > > > > @@ -594,7 +621,6 @@ xfs_alloc_ioend(
> > > > > > > >  	ioend->io_inode = inode;
> > > > > > > >  	ioend->io_size = 0;
> > > > > > > >  	ioend->io_offset = offset;
> > > > > > > > -	INIT_WORK(&ioend->io_work, xfs_end_io);
> > > > > > > >  	ioend->io_append_trans = NULL;
> > > > > > > >  	ioend->io_bio = bio;
> > > > > > > >  	return ioend;
> > > > > > > > diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> > > > > > > > index 6c2615b83c5d..f62b03186c62 100644
> > > > > > > > --- a/fs/xfs/xfs_aops.h
> > > > > > > > +++ b/fs/xfs/xfs_aops.h
> > > > > > > > @@ -18,7 +18,6 @@ struct xfs_ioend {
> > > > > > > >  	struct inode		*io_inode;	/* file being written to */
> > > > > > > >  	size_t			io_size;	/* size of the extent */
> > > > > > > >  	xfs_off_t		io_offset;	/* offset in the file */
> > > > > > > > -	struct work_struct	io_work;	/* xfsdatad work queue */
> > > > > > > >  	struct xfs_trans	*io_append_trans;/* xact. for size update */
> > > > > > > >  	struct bio		*io_bio;	/* bio being built */
> > > > > > > >  	struct bio		io_inline_bio;	/* MUST BE LAST! */
> > > > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > > > index 245483cc282b..e70e7db29026 100644
> > > > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > > > > @@ -70,6 +70,9 @@ xfs_inode_alloc(
> > > > > > > >  	ip->i_flags = 0;
> > > > > > > >  	ip->i_delayed_blks = 0;
> > > > > > > >  	memset(&ip->i_d, 0, sizeof(ip->i_d));
> > > > > > > > +	INIT_WORK(&ip->i_iodone_work, xfs_end_io);
> > > > > > > > +	INIT_LIST_HEAD(&ip->i_iodone_list);
> > > > > > > > +	spin_lock_init(&ip->i_iodone_lock);
> > > > > > > >  
> > > > > > > >  	return ip;
> > > > > > > >  }
> > > > > > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > > > > > index e62074a5257c..88239c2dd824 100644
> > > > > > > > --- a/fs/xfs/xfs_inode.h
> > > > > > > > +++ b/fs/xfs/xfs_inode.h
> > > > > > > > @@ -57,6 +57,11 @@ typedef struct xfs_inode {
> > > > > > > >  
> > > > > > > >  	/* VFS inode */
> > > > > > > >  	struct inode		i_vnode;	/* embedded VFS inode */
> > > > > > > > +
> > > > > > > > +	/* pending io completions */
> > > > > > > > +	spinlock_t		i_iodone_lock;
> > > > > > > > +	struct work_struct	i_iodone_work;
> > > > > > > > +	struct list_head	i_iodone_list;
> > > > > > > >  } xfs_inode_t;
> > > > > > > >  
> > > > > > > >  /* Convert from vfs inode to xfs inode */
> > > > > > > > @@ -503,4 +508,6 @@ bool xfs_inode_verify_forks(struct xfs_inode *ip);
> > > > > > > >  int xfs_iunlink_init(struct xfs_perag *pag);
> > > > > > > >  void xfs_iunlink_destroy(struct xfs_perag *pag);
> > > > > > > >  
> > > > > > > > +void xfs_end_io(struct work_struct *work);
> > > > > > > > +
> > > > > > > >  #endif	/* __XFS_INODE_H__ */
> > > > > > > > 
