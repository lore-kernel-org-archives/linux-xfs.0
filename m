Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A79AD7F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 11:15:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41D3FAC003
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 09:15:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id XhqOTqs5ncZEUjOF for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 09:14:59 -0700 (PDT)
Date: Mon, 12 Aug 2013 18:14:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Message-ID: <20130812161455.GA19471@quack.suse.cz>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
	<20130712004421.GE3438@dastard>
	<20130716210027.GA9595@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130716210027.GA9595@quack.suse.cz>
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

  Hi Dave,

  I remembered about this patch set and realized I didn't get reply from
you regarding the following question (see quoted email below for details):
Do you really need to defer completion of appending direct IO? Because
generic code makes sure appending direct IO isn't async and thus
dio_complete() -> xfs_end_io_direct_write() gets called directly from
do_blockdev_direct_IO(). I.e. from a normal context and not from interrupt.

I've already addressed rest of your comments so this is the only item that
is remaining.

On Tue 16-07-13 23:00:27, Jan Kara wrote:
> > > -static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
> > > +static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
> > > +		bool is_async)
> > >  {
> > >  	ssize_t transferred = 0;
> > >  
> > > @@ -258,19 +262,26 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
> > >  	if (ret == 0)
> > >  		ret = transferred;
> > >  
> > > -	if (dio->end_io && dio->result) {
> > > -		dio->end_io(dio->iocb, offset, transferred,
> > > -			    dio->private, ret, is_async);
> > > -	} else {
> > > -		inode_dio_done(dio->inode);
> > > -		if (is_async)
> > > -			aio_complete(dio->iocb, ret, 0);
> > > -	}
> > > +	if (dio->end_io && dio->result)
> > > +		dio->end_io(dio->iocb, offset, transferred, dio->private);
> > 
> > Ok, so by here we are assuming all filesystem IO completion
> > processing is completed.
>   Yes.
> 
> > > +
> > > +	inode_dio_done(dio->inode);
> > > +	if (is_async)
> > > +		aio_complete(dio->iocb, ret, 0);
> > >  
> > > +	kmem_cache_free(dio_cache, dio);
> > >  	return ret;
> > 
> > Hmmm. I started wonder if this is valid, because XFS is supposed to
> > be doing workqueue based IO completion for appending writes and they
> > are supposed to be run in a workqueue.
> > 
> > But, looking at the XFS code, there's actually a bug in the direct
> > IO completion code and we are not defering completion to a workqueue
> > like we should be for the append case.  This code in
> > xfs_finish_ioend() demonstrates the intent:
> > 
> >                 if (ioend->io_type == XFS_IO_UNWRITTEN)
> >                         queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
> >                 else if (ioend->io_append_trans ||
> > >>>>>>                   (ioend->io_isdirect && xfs_ioend_is_append(ioend)))
> >                         queue_work(mp->m_data_workqueue, &ioend->io_work);
> > 
> > The problem is that we only ever call xfs_finish_ioend() if is_async
> > is true, and that will never be true for direct IO beyond the current
> > EOF. That's a bug, and is Bad(tm).
> > 
> > [ Interestingly, it turns out that dio->is_async is never set for
> > writes beyond EOF because of filesystems that update file sizes
> > before data IO completion occurs (stale data exposure issues). For
> > XFS, that can't happen and so dio->is_async could always be set.... ]
> > 
> > What this means is that there's a condition for work queue deferral
> > of DIO IO completion that this patch doesn't handle. Setting deferral
> > only on unwritten extents like this:
> > 
> > > @@ -1292,8 +1281,10 @@ __xfs_get_blocks(
> > >  		if (create || !ISUNWRITTEN(&imap))
> > >  			xfs_map_buffer(inode, bh_result, &imap, offset);
> > >  		if (create && ISUNWRITTEN(&imap)) {
> > > -			if (direct)
> > > +			if (direct) {
> > >  				bh_result->b_private = inode;
> > > +				set_buffer_defer_completion(bh_result);
> > > +			}
> > >  			set_buffer_unwritten(bh_result);
> > >  		}
> > >  	}
> > 
> > misses that case. I suspect Christoph's original patch predated the
> > changes to XFS that added transactional file size updates to IO
> > completion and so didn't take it into account.
>   OK, thanks for catching this. Doing the i_size check in
> _xfs_get_blocks() would be somewhat cumbersome I presume so I guess we can
> handle that case by adding __blockdev_direct_IO() flag to defer dio
> completion to a workqueue. XFS can then set the flag when it sees it needs
> and i_size update. OK?
> 
> > > @@ -1390,9 +1381,7 @@ xfs_end_io_direct_write(
> > >  	struct kiocb		*iocb,
> > >  	loff_t			offset,
> > >  	ssize_t			size,
> > > -	void			*private,
> > > -	int			ret,
> > > -	bool			is_async)
> > > +	void			*private)
> > >  {
> > >  	struct xfs_ioend	*ioend = iocb->private;
> > >  
> > > @@ -1414,17 +1403,10 @@ xfs_end_io_direct_write(
> > >  
> > >  	ioend->io_offset = offset;
> > >  	ioend->io_size = size;
> > > -	ioend->io_iocb = iocb;
> > > -	ioend->io_result = ret;
> > >  	if (private && size > 0)
> > >  		ioend->io_type = XFS_IO_UNWRITTEN;
> > >  
> > > -	if (is_async) {
> > > -		ioend->io_isasync = 1;
> > > -		xfs_finish_ioend(ioend);
> > > -	} else {
> > > -		xfs_finish_ioend_sync(ioend);
> > > -	}
> > > +	xfs_finish_ioend_sync(ioend);
> > >  }
> > 
> > As i mentioned, the existing code here is buggy. What we should be
> > doing here is:
> > 
> > 	if (is_async) {
> > 		ioend->io_isasync = 1;
> > 		xfs_finish_ioend(ioend);
> > 	} else if (xfs_ioend_is_append(ioend))) {
> > 		xfs_finish_ioend(ioend);
> > 	} else {
> > 		xfs_finish_ioend_sync(ioend);
> > 	}
>   Umm, I started to wonder why do you actually need to defer the completion
> for appending ioend. Because if DIO isn't async, dio_complete() won't be
> called from interrupt context but from __blockdev_direct_IO(). So it seems
> you can do everything you need directly there without deferring to a
> workqueue. But maybe there's some locking subtlety I'm missing.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
