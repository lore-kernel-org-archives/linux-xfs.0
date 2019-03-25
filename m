Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfCYNv1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Mar 2019 09:51:27 -0400
Date: Mon, 25 Mar 2019 09:51:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: serialize unaligned dio writes against all other
 dio writes
Message-ID: <20190325135124.GD52167@bfoster>
References: <20190322165242.40662-1-bfoster@redhat.com>
 <20190325110646.GA7890@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325110646.GA7890@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>

On Mon, Mar 25, 2019 at 04:06:46AM -0700, Christoph Hellwig wrote:
> >  	if (unaligned_io) {
> > +		/* unaligned dio always waits, bail */
> > +		if (iocb->ki_flags & IOCB_NOWAIT)
> > +			return -EAGAIN;
> > +		else
> >  			inode_dio_wait(inode);
> 
> No need for the else here.
> 

Ack.

> >  	} else if (iolock == XFS_IOLOCK_EXCL) {
> >  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> >  		iolock = XFS_IOLOCK_SHARED;
> > @@ -548,6 +549,8 @@ xfs_file_dio_aio_write(
> >  
> >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
> >  	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
> > +	if (unaligned_io && !is_sync_kiocb(iocb))
> > +		inode_dio_wait(inode);
> 
> Instead of explicittly waiting here I'd much rather just mark the
> I/O as sync before submitting it.  The only thing needed for that
> is to clear iocb->ki_complete.  To avoid too much low-level hacking
> that is probably best done with a:
> 
> static inline void mark_kiocb_sync(struct kiocb *kiocb)
> {
> 	kiocb->ki_complete = NULL;
> }
> 
> helper in fs.h.

It's not quite that simple..

FWIW, the discussion (between Dave and I) for how best to solve this
started offline prior to sending the patch and pretty much started with
the idea of changing the async I/O to sync as you suggest here. I backed
off from that because it's too subtle given the semantics between the
higher level aio code and lower level dio code for async I/O. By that I
mean either can be responsible for calling the ->ki_complete() callback
in the iocb on I/O completion.

IOW, if we receive an async direct I/O, clear ->ki_complete() as you
describe above and submit it, the dio code will wait on I/O and return
the size of the I/O on successful completion. It will not have called
->ki_complete(), however. Rather, the >0 return value indicates that
aio_rw_done() must call ->ki_complete() after xfs_file_write_iter()
returns, but we would have already cleared the function pointer.

I think it is technically possible to use this technique by clearing and
restoring ->ki_complete(), but in general we've visited this "change the
I/O type" approach twice now and we've (collectively) got it wrong both
times (the first error in thinking was that XFS would need to call
->ki_complete()). IMO, this demonstrates that it's not worth the
complexity to insert ourselves into this dependency chain when we can
accomplish the same thing with a simple dio wait call.

Brian
