Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21502 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758564AbdKOSqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 13:46:38 -0500
Date: Wed, 15 Nov 2017 10:46:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171115184624.GE5119@magnolia>
References: <20171114214625.GB5119@magnolia>
 <20171115121227.GA7877@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171115121227.GA7877@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 15, 2017 at 07:12:28AM -0500, Brian Foster wrote:
> On Tue, Nov 14, 2017 at 01:46:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If two programs simultaneously try to write to the same part of a file
> > via direct IO and buffered IO, there's a chance that the post-diowrite
> > pagecache invalidation will fail on the dirty page.  When this happens,
> > the dio write succeeded, which means that the page cache is no longer
> > coherent with the disk!  Programs are not supposed to mix IO types and
> > this is a clear case of data corruption, so store an EIO which will be
> > reflected to userspace during the next fsync.  Get rid of the WARN_ON
> > to assuage the fuzz-tester complaints.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/iomap.c |   19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index d4801f8..61b2eca 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -710,6 +710,13 @@ struct iomap_dio {
> >  	};
> >  };
> >  
> > +static void iomap_warn_stale_pagecache(struct inode *inode)
> > +{
> > +	errseq_set(&inode->i_mapping->wb_err, -EIO);
> > +	pr_crit_ratelimited("Stale pagecache contents after collision "
> > +			    "between direct and buffered write!\n");
> > +}
> 
> Is stale pagecache always necessarily the end result of the race? For
> example, is it possible that the page is under writeback and is about to
> overwrite the range just written by the dio? Or what about one of those
> weird cases where we check for whether the page mapping has changed down
> in the invalidate code? I'm wondering if it's appropriate to set an
> error if any such other cases are possible.
> 
> As a nit, I guess I'd just prefer a bit more generic of a warning
> message. E.g., something like:
> 
> "Cache invalidation failure on direct I/O. Possible data corruption due
> to collision with buffered I/O!"
> 
> ... but feel free to rephrase that however. Otherwise that bit seems
> reasonable enough to me.

Sure, that seems like a more accurate description of what's going on anyway.

--D

> Brian
> 
> > +
> >  static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >  {
> >  	struct kiocb *iocb = dio->iocb;
> > @@ -752,7 +759,8 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >  		err = invalidate_inode_pages2_range(inode->i_mapping,
> >  				offset >> PAGE_SHIFT,
> >  				(offset + dio->size - 1) >> PAGE_SHIFT);
> > -		WARN_ON_ONCE(err);
> > +		if (err)
> > +			iomap_warn_stale_pagecache(inode);
> >  	}
> >  
> >  	inode_dio_end(file_inode(iocb->ki_filp));
> > @@ -1011,9 +1019,16 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  	if (ret)
> >  		goto out_free_dio;
> >  
> > +	/*
> > +	 * Try to invalidate cache pages for the range we're direct
> > +	 * writing.  If this invalidation fails, tough, the write will
> > +	 * still work, but racing two incompatible write paths is a
> > +	 * pretty crazy thing to do, so we don't support it 100%.
> > +	 */
> >  	ret = invalidate_inode_pages2_range(mapping,
> >  			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
> > -	WARN_ON_ONCE(ret);
> > +	if (ret)
> > +		iomap_warn_stale_pagecache(inode);
> >  	ret = 0;
> >  
> >  	if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
