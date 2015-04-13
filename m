Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58A4F7F50
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2015 06:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E89A3AC001
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2015 04:21:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C5fpAGoEZhQ7H4Bg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Apr 2015 04:20:59 -0700 (PDT)
Date: Mon, 13 Apr 2015 07:20:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: direct IO needs to use append ioends
Message-ID: <20150413112055.GA40035@bfoster.bfoster>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-3-git-send-email-david@fromorbit.com>
	<20150411211517.GB4039@bfoster.bfoster>
	<20150412233102.GM15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150412233102.GM15810@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, Apr 13, 2015 at 09:31:02AM +1000, Dave Chinner wrote:
> On Sat, Apr 11, 2015 at 05:15:18PM -0400, Brian Foster wrote:
> > On Fri, Apr 10, 2015 at 11:37:57PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Now we have an ioend being passed unconditionally to the direct IO
> > > write completion context, we can pass a preallocated transaction
> > > handle for on-disk inode size updates that are run in completion.
> .....
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -178,6 +178,25 @@ xfs_setfilesize_ioend(
> > >  	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
> > >  }
> > >  
> > > +STATIC void
> > > +xfs_setfilesize_ioend_cancel(
> > > +	struct xfs_ioend	*ioend)
> > > +{
> > > +	struct xfs_trans	*tp = ioend->io_append_trans;
> > > +
> > > +	/*
> > > +	 * The transaction may have been allocated in the I/O submission thread,
> > > +	 * thus we need to mark ourselves as being in a transaction manually.
> > > +	 * Similarly for freeze protection.
> > > +	 */
> > 
> > This threw me off at first because we can call this from either the
> > submission or the completion context, unlike the commit case where this
> > comment is copied from. Could we move the comment above the function and
> > clarify a bit? E.g., something like the following is a bit more clear to
> > me:
> > 
> > /*
> >  * The process transaction and freeze protection state is cleared immediately
> >  * after setfilesize transaction allocation to support transfer of the tp from
> >  * submission to completion context. Restore the context appropriately to cancel
> >  * the transaction.
> >  */
> 
> OK, I can do that, but given your next comments, it might just go
> away.
> 
> > > +	} else {
> > > +		ioend = xfs_alloc_ioend(inode, type);
> > > +		ioend->io_offset = offset;
> > > +		ioend->io_size = size;
> > > +		bh_result->b_private = ioend;
> > > +		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
> > > +					   imap);
> > > +	}
> > > +
> > > +	/* check if we need an append transaction allocated. */
> > > +	if (ioend->io_type == XFS_IO_OVERWRITE &&
> > > +	    xfs_ioend_is_append(ioend) && !ioend->io_append_trans) {
> > > +		int	error;
> > > +
> > > +		error = xfs_setfilesize_trans_alloc(ioend);
> > 
> > I'm not totally convinced this is safe. We previously moved this tp
> > allocation from before a potential xfs_iomap_direct_write() call to the
> > completion side to avoid nesting this allocation with unwritten extent
> > allocation transactions. See the following for reference:
> > 
> > 	437a255a xfs: fix direct IO nested transaction deadlock
> > 
> > Now we move it after that point of the codepath, and even then we know
> > that this is an overwrite if we do the allocation here. If we continue
> > on and hit a hole, it looks like there's still a sequence to allocate
> > this transaction and call xfs_iomap_write_direct(), nesting the
> > associated transaction reservations. Am I missing something?
> 
> No, I didn't really think this part through fully. I knew that we'd
> get multiple calls, and we'd get multiple allocations, but for some
> reason the penny didn't drop.
> 
> What it comes down to is that either we jump through lots of hoops
> in __xfs_get_blocks() to handle this case (i.e.
> cancel/allocate/reserve on repeat calls) or we just allocate it in
> IO completion context as we currently are doing.
> 

Ok, I figured it would be one of those two approaches. The latter seems
more clean to me in just thinking about it since it's another spot we
have to consider the direct write case (as opposed to having it factored
cleanly into the new helper). Maybe it can be better organized than
that, splitting up the helper perhaps, so I'll reserve judgement. :)

Could we get a v2 of the race fix posted with the proper locking and
reviewed-by tags and whatnot? A reply to the patch in this thread is
fine if the broader rework is still in flux. I'd just like to have an
upstream reference for a backport of that one...

Brian

> I'll have a look at what cancel/allocate/reserve looks like - it
> might actually simplify the logic - and go from there.
> 
> Thanks for catching my silly thinko, Brain!
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
