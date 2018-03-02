Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33031 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933561AbeCBWzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 17:55:17 -0500
Date: Sat, 3 Mar 2018 09:55:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
Message-ID: <20180302225514.GX30854@dastard>
References: <20180301223632.28742-1-david@fromorbit.com>
 <20180302225050.GA25395@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302225050.GA25395@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 02:50:50PM -0800, Christoph Hellwig wrote:
> >  /*
> > + * Look up a buffer in the buffer cache and return it referenced and locked.
> > + *
> > + * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
> > + * cache.
> > + *
> > + * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
> > + * -EAGAIN if we fail to lock it.
> > + *
> > + * Return values are:
> > + *	-EFSCORRUPTED if have been supplied with an invalid address
> > + *	-EAGAIN on trylock failure
> > + *	NULL if we fail to find a match and @new_bp was NULL
> > + *	@new_bp if we inserted it into the cache
> > + *	the buffer we found and locked.
> 
> NULL or error calling conventions are nasty.  Can we switch to always
> return an ERR_PTR?

Ok, I'll return bp as a parameter and just use the return variable
as a pure error code.

> > +	switch (PTR_ERR(bp)) {
> > +		case 0:
> > +			/* cache miss, need to insert new buffer */
> > +			break;
> > +
> > +		case -EAGAIN:
> > +			/* cache hit, trylock failure, caller handles failure */
> > +			ASSERT(flags & XBF_TRYLOCK);
> > +			return NULL;
> > +
> > +		case -EFSCORRUPTED:
> > +		default:
> > +			/*
> > +			 * None of the higher layers understand failure types
> > +			 * yet, so return NULL to signal a fatal lookup error.
> > +			 */
> > +			return NULL;
> > +	}
> 
> Usual style is to not indent the switch labels.

*nod*

> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 2f4c91452861..db87ad0b9b79 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -229,8 +229,14 @@ xfs_incore(
> >  	size_t			numblks,
> >  	xfs_buf_flags_t		flags)
> >  {
> > +	struct xfs_buf		*bp;
> > +
> >  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > -	return _xfs_buf_find(target, &map, 1, flags, NULL);
> > +
> > +	bp = _xfs_buf_find(target, &map, 1, flags, NULL);
> > +	if (IS_ERR_OR_NULL(bp))
> > +		return NULL;
> > +	return bp;
> >  }
> 
> Can we move xfs_incore to xfs_buf.c and stop exporting _xfs_buf_find
> while we're at it?

Yes. :)

> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 5b848f4b637f..8d90d19684a7 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1249,9 +1249,8 @@ xfs_qm_flush_one(
> >  	 */
> >  	if (!xfs_dqflock_nowait(dqp)) {
> >  		/* buf is pinned in-core by delwri list */
> > -		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> > -				      mp->m_quotainfo->qi_dqchunklen);
> > -		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> > +		bp = xfs_incore(mp->m_ddev_targp, dqp->q_blkno,
> > +				mp->m_quotainfo->qi_dqchunklen, 0);
> >  		if (!bp) {
> >  			error = -EINVAL;
> >  			goto out_unlock;
> 
> Make this a separate prep patch, please.  Maybe together with moving
> xfs_incore out of line.

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
