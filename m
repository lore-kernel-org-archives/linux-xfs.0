Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAH7e57D024786 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 01:40:05 -0600
Date: Thu, 17 Nov 2011 02:40:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111117074003.GC3733@infradead.org>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.686729205@bombadil.infradead.org>
	<20111116190120.GG29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111116190120.GG29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 16, 2011 at 01:01:20PM -0600, Ben Myers wrote:
> On Tue, Nov 15, 2011 at 03:14:09PM -0500, Christoph Hellwig wrote:
> > commit 77d7a0c "xfs: Non-blocking inode locking in IO completion" introduced
> > a trylocked and defer scheme in xfs_setfilesize to avoid deadlocks when on
> > XFS filesystem is used ontop of another using the loop device, and we
> > fsync in the loop filesystem.
> > 
> > Now that we have the cheap enough concurrency managed workqueues, we can
> > create per-filesystem instead of global workqueues and remove this scheme
> > again, given that it has the potential of delaying size updates and is not
> > helpful once we start to log the inode size.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ...
> 
> >  /*
> > @@ -168,10 +161,12 @@ xfs_finish_ioend(
> >  	struct xfs_ioend	*ioend)
> >  {
> >  	if (atomic_dec_and_test(&ioend->io_remaining)) {
> > +		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> > +
> >  		if (ioend->io_type == IO_UNWRITTEN)
> > -			queue_work(xfsconvertd_workqueue, &ioend->io_work);
> > +			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
> >  		else if (xfs_ioend_is_append(ioend))
> 
> I wonder if we could skip size updates due to the 'fast and loose'
> nature of xfs_ioend_is_append, and end up destroying the ioend below,
> without updating the file size.  It's not strictly related to your patch
> though.

No - xfs_ioend_is_append check that the offset is beyond the on-disk
inode size.  The loose part is that we don't bother with the in-core
i_size and i_new_size which could change due to I/O errors.  di_size
on the other hand will only go downwards during truncate, and we make
sure all outstanding buffered I/Os have finished first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
