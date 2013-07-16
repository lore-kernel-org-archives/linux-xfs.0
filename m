Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 370847F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 16:00:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2C92304043
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 14:00:30 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CHQizBgmnjz3Bv7z for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 14:00:28 -0700 (PDT)
Date: Tue, 16 Jul 2013 23:00:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Message-ID: <20130716210027.GA9595@quack.suse.cz>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
	<20130712004421.GE3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130712004421.GE3438@dastard>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri 12-07-13 10:44:21, Dave Chinner wrote:
> On Thu, Jul 11, 2013 at 12:02:18AM +0200, Jan Kara wrote:
> > From: Christoph Hellwig <hch@infradead.org>
> > 
> > Add support to the core direct-io code to defer AIO completions to user
> > context using a workqueue.  This replaces opencoded and less efficient
> > code in XFS and ext4 and will be needed to properly support O_(D)SYNC
> > for AIO.
> 
> I don't see how this is any more efficient than the deferral
> that XFS already does for direct IO completion - it just changes
> what queues IO for completions.
  I didn't change the changelog so it's upto Christoph to tell. But I can
remove the 'less efficient' part from the changelog if you want.

> And on that topic:
> 
> > Currently this creates a per-superblock unbound workqueue for these
> > completions, which is taken from an earlier patch by Jan Kara.  I'm
> > not really convinced about this use and would prefer a "normal" global
> > workqueue with a high concurrency limit, but this needs further discussion.
> 
> Unbound workqueues sacrifice locality for immediate dispatch.
> AIO-DIO performance at the high end is determined by IO submission
> and completion locality - we want submission and completion to occur
> on the same CPU as much as possible so cachelines are not bounced
> aroundi needlessly. An unbound workqueue would seem to be the wrong
> choice on this basis alone.
> 
> Further the use of @max_active = 1 means that it is a global, single
> threaded workqueue. While ext4 might require single threaded
> execution of unwritten extent completion, it would be introducing a
> massive bottleneck into XFS which currently uses the default
> concurrency depth of 256 worker threads per CPU per superblock just
> for unwritten extent conversion.
> 
> Hmmmm. I notice that the next patch then does generic_write_sync()
> is the IO completion handler, too. In XFS that causes log forces and
> will block, so that's yet more concurrency required that is required
> for this workqueue. Doing this in a single threaded workqueue and
> marshalling all sync AIO through it is highly unfriendly to
> concurrent IO completion.
> 
> FWIW, in XFS we queue unwritten extent conversion completions on a
> different workqueue to EOF size update completions because the
> latter are small, fast and rarely require IO or get blocked. The
> data IO completion workqueue for EOF updates has the same
> concurrency and depth as the unwritten extent work queue (i.e. 256
> workers per cpu per superblock). So pushing all of this DIO and EOF
> completion work into a single threaded global workqueue that can
> block in every IO completion doesn't seem like a very smart idea to
> me...
  OK, so you'd rather have the workqueue created like:

alloc_workqueue("dio-sync", WQ_MEM_RECLAIM, 0)

  I can certainly try that. ext4 should handle that fine. And I agree with
your arguments for high end devices. I'm just wondering whether it won't do
some harm to a simple SATA drive. Having more threads trying to do extent
conversion in parallel might cause the drive to seek more.

> > -static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
> > +static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
> > +		bool is_async)
> >  {
> >  	ssize_t transferred = 0;
> >  
> > @@ -258,19 +262,26 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
> >  	if (ret == 0)
> >  		ret = transferred;
> >  
> > -	if (dio->end_io && dio->result) {
> > -		dio->end_io(dio->iocb, offset, transferred,
> > -			    dio->private, ret, is_async);
> > -	} else {
> > -		inode_dio_done(dio->inode);
> > -		if (is_async)
> > -			aio_complete(dio->iocb, ret, 0);
> > -	}
> > +	if (dio->end_io && dio->result)
> > +		dio->end_io(dio->iocb, offset, transferred, dio->private);
> 
> Ok, so by here we are assuming all filesystem IO completion
> processing is completed.
  Yes.

> > +
> > +	inode_dio_done(dio->inode);
> > +	if (is_async)
> > +		aio_complete(dio->iocb, ret, 0);
> >  
> > +	kmem_cache_free(dio_cache, dio);
> >  	return ret;
> 
> Hmmm. I started wonder if this is valid, because XFS is supposed to
> be doing workqueue based IO completion for appending writes and they
> are supposed to be run in a workqueue.
> 
> But, looking at the XFS code, there's actually a bug in the direct
> IO completion code and we are not defering completion to a workqueue
> like we should be for the append case.  This code in
> xfs_finish_ioend() demonstrates the intent:
> 
>                 if (ioend->io_type == XFS_IO_UNWRITTEN)
>                         queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>                 else if (ioend->io_append_trans ||
> >>>>>>                   (ioend->io_isdirect && xfs_ioend_is_append(ioend)))
>                         queue_work(mp->m_data_workqueue, &ioend->io_work);
> 
> The problem is that we only ever call xfs_finish_ioend() if is_async
> is true, and that will never be true for direct IO beyond the current
> EOF. That's a bug, and is Bad(tm).
> 
> [ Interestingly, it turns out that dio->is_async is never set for
> writes beyond EOF because of filesystems that update file sizes
> before data IO completion occurs (stale data exposure issues). For
> XFS, that can't happen and so dio->is_async could always be set.... ]
> 
> What this means is that there's a condition for work queue deferral
> of DIO IO completion that this patch doesn't handle. Setting deferral
> only on unwritten extents like this:
> 
> > @@ -1292,8 +1281,10 @@ __xfs_get_blocks(
> >  		if (create || !ISUNWRITTEN(&imap))
> >  			xfs_map_buffer(inode, bh_result, &imap, offset);
> >  		if (create && ISUNWRITTEN(&imap)) {
> > -			if (direct)
> > +			if (direct) {
> >  				bh_result->b_private = inode;
> > +				set_buffer_defer_completion(bh_result);
> > +			}
> >  			set_buffer_unwritten(bh_result);
> >  		}
> >  	}
> 
> misses that case. I suspect Christoph's original patch predated the
> changes to XFS that added transactional file size updates to IO
> completion and so didn't take it into account.
  OK, thanks for catching this. Doing the i_size check in
_xfs_get_blocks() would be somewhat cumbersome I presume so I guess we can
handle that case by adding __blockdev_direct_IO() flag to defer dio
completion to a workqueue. XFS can then set the flag when it sees it needs
and i_size update. OK?

> > @@ -1390,9 +1381,7 @@ xfs_end_io_direct_write(
> >  	struct kiocb		*iocb,
> >  	loff_t			offset,
> >  	ssize_t			size,
> > -	void			*private,
> > -	int			ret,
> > -	bool			is_async)
> > +	void			*private)
> >  {
> >  	struct xfs_ioend	*ioend = iocb->private;
> >  
> > @@ -1414,17 +1403,10 @@ xfs_end_io_direct_write(
> >  
> >  	ioend->io_offset = offset;
> >  	ioend->io_size = size;
> > -	ioend->io_iocb = iocb;
> > -	ioend->io_result = ret;
> >  	if (private && size > 0)
> >  		ioend->io_type = XFS_IO_UNWRITTEN;
> >  
> > -	if (is_async) {
> > -		ioend->io_isasync = 1;
> > -		xfs_finish_ioend(ioend);
> > -	} else {
> > -		xfs_finish_ioend_sync(ioend);
> > -	}
> > +	xfs_finish_ioend_sync(ioend);
> >  }
> 
> As i mentioned, the existing code here is buggy. What we should be
> doing here is:
> 
> 	if (is_async) {
> 		ioend->io_isasync = 1;
> 		xfs_finish_ioend(ioend);
> 	} else if (xfs_ioend_is_append(ioend))) {
> 		xfs_finish_ioend(ioend);
> 	} else {
> 		xfs_finish_ioend_sync(ioend);
> 	}
  Umm, I started to wonder why do you actually need to defer the completion
for appending ioend. Because if DIO isn't async, dio_complete() won't be
called from interrupt context but from __blockdev_direct_IO(). So it seems
you can do everything you need directly there without deferring to a
workqueue. But maybe there's some locking subtlety I'm missing.

> Which means that the new code boils down to:
> 
> 	if (xfs_ioend_is_append(ioend)))
> 		xfs_finish_ioend(ioend);
> 	else
> 		xfs_finish_ioend_sync(ioend);
> 
> And now we see the problem with the only defering unwritten IO -
> the new direct IO code will think IO is completed when all we've
> done is queued it to another workqueue.
  I agree. New direct IO completion handlers have to really finish
everything without deferring to a separate workqueue. ext4 had a same bug
but there I caught it and fixed.

> I'm not sure we can handle this in get_blocks - we don't have the
> context to know how to treat allocation beyond the current EOF.
> Indeed, the current block being mapped might not be beyond EOF, but
> some of the IO might be (e.g. lies across an extent boundary),
> so setting the deferred completion in get_blocks doesn't allow the
> entire IO to be treated the same.
> 
> So I think there's a bit of re-thinking needed to aspects of this
> patch to be done.
  Additional flag to __blockdev_direct_IO() should solve this as I wrote
above (if you really need it).

> > +		 * avoids problems with pseudo filesystems which get initialized
> > +		 * before workqueues can be created
> > +		 */
> > +		if (type->fs_flags & FS_REQUIRES_DEV) {
> > +			s->s_dio_done_wq =
> > +				alloc_workqueue("dio-sync", WQ_UNBOUND, 1);
> 
> The workqueue name needs to be combined with the fs_name so we know
> what filesystem is having problems in sysrq-w output.
  Yes, that's reasonable. However that means we'll have to initialize the
workqueue later. Hum.. I think I will return to the on-demand creation of
the workqueue as I originally had in my patch set.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
