Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AF187F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 15:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04C6730404E
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 13:12:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	R4q9sHIpxVXzexcP for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 13:12:51 -0700 (PDT)
Date: Wed, 15 Apr 2015 06:12:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: handle DIO overwrite EOF update completion
	correctly
Message-ID: <20150414201236.GU15810@dastard>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
	<1428996411-1507-5-git-send-email-david@fromorbit.com>
	<20150414143501.GE36198@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150414143501.GE36198@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 14, 2015 at 10:35:02AM -0400, Brian Foster wrote:
> On Tue, Apr 14, 2015 at 05:26:47PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently a DIO overwrite that extends the EOF (e.g sub-block IO or
> > write into allocated blocks beyond EOF) requires a transaction for
> > the EOF update. Thi is done in IO completion context, but we aren't
> > explicitly handling this situation properly and so it can run in
> > interrupt context. Ensure that we defer IO that spans EOF correctly
> > to the DIO completion workqueue, and now that we have an ioend in IO
> > completion we can use the common ioend completion path to do all the
> > work.
> > 
> > Note: we do not preallocate the append transaction as we can have
> > multiple mapping and allocation calls per direct IO. hence
> > preallocating can still leave us with nested transactions by
> > attempting to map and allocate more blocks after we've preallocated
> > an append transaction.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -1553,40 +1555,37 @@ xfs_end_io_direct_write(
> >  	ioend->io_offset = offset;
> >  
> >  	/*
> > -	 * While the generic direct I/O code updates the inode size, it does
> > -	 * so only after the end_io handler is called, which means our
> > -	 * end_io handler thinks the on-disk size is outside the in-core
> > -	 * size.  To prevent this just update it a little bit earlier here.
> > +	 * The ioend tells us whether we are doing unwritten extent conversion
> > +	 * or an append transaction that updates the on-disk file size. These
> > +	 * cases are the only cases where we should *potentially* be needing
> > +	 * to update the VFS inode size. When the ioend indicates this, we
> > +	 * are *guaranteed* to be running in non-interrupt context.
> > +	 *
> > +	 * We need to update the in-core inode size here so that we don't end up
> > +	 * with the on-disk inode size being outside the in-core inode size.
> > +	 * While we can do this in the process context after the IO has
> > +	 * completed, this does not work for AIO and hence we always update
> > +	 * the in-core inode size here if necessary.
> >  	 */
> > -	if (offset + size > i_size_read(inode))
> > -		i_size_write(inode, offset + size);
> > +	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend)) {
> > +		if (offset + size > i_size_read(inode))
> > +			i_size_write(inode, offset + size);
> > +	} else
> > +		ASSERT(offset + size <= i_size_read(inode));
> 
> The code was obviously incorrect prior to this change, potentially
> running some of these transactions in irq context. That said, it occurs
> to me that one thing that the previous implementation looked to handle
> that this does not is racing of in-flight aio with other operations.
> E.g., what happens now if a non-extending, overwrite aio is submitted
> and races with a truncate that causes it to be extending by the time we
> get here? It looks like it would have been racy regardless, so maybe
> that's just a separate problem...

AIO can't race with truncate, because truncate does inode_dio_wait()
after taking the IOLOCK_EXCL.

As for failing to update if the inode size is extended, we only care
about the in-memory size update if the on-disk inode size is being
extended. If the on-disk size has been extended, then we don't need
to update the in-memory size because it's already been extended by
this code.

> >  	/*
> > -	 * For direct I/O we do not know if we need to allocate blocks or not,
> > -	 * so we can't preallocate an append transaction, as that results in
> > -	 * nested reservations and log space deadlocks. Hence allocate the
> > -	 * transaction here. While this is sub-optimal and can block IO
> > -	 * completion for some time, we're stuck with doing it this way until
> > -	 * we can pass the ioend to the direct IO allocation callbacks and
> > -	 * avoid nesting that way.
> > +	 * If we are doing an append IO that needs to update the EOF on disk,
> > +	 * do the transaction reserve now so we can use common end io
> > +	 * processing. Stashing the error (if there is one) in the ioend will
> > +	 * result in the ioend processing passing on the error if it is
> > +	 * possible as we can't return it from here.
> >  	 */
> > -	if (ioend->io_type == XFS_IO_UNWRITTEN) {
> > -		xfs_iomap_write_unwritten(ip, offset, size);
> > -	} else if (offset + size > ip->i_d.di_size) {
> > -		struct xfs_trans	*tp;
> > -		int			error;
> > -
> > -		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> > -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> > -		if (error) {
> > -			xfs_trans_cancel(tp, 0);
> > -			goto out_destroy_ioend;
> > -		}
> > +	if (ioend->io_type == XFS_IO_OVERWRITE && xfs_ioend_is_append(ioend))
> > +		ioend->io_error = xfs_setfilesize_trans_alloc(ioend);
> 
> As you mentioned previously, we no longer need the transaction context
> manipulation stuff in xfs_setfilesize_trans_alloc() with this approach.
> It's still called from the writepage path though, so I guess it needs to
> stay.

Yes, and if we ever get the eventual DIO rewrite that's been coming
for several years, we'll be able to untangle this code further and
use preallocation for DIO.  As it is, I have a few thoughts on how
to do preallocation regardless, just haven't had time to explore
them.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
