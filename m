Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbeDRPYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 11:24:45 -0400
Date: Wed, 18 Apr 2018 08:24:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: make xfs_buf_incore out of line
Message-ID: <20180418152442.GO24738@magnolia>
References: <20180418002111.11637-1-david@fromorbit.com>
 <20180418002111.11637-2-david@fromorbit.com>
 <20180418114658.agqbu2uf2ti6hly7@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418114658.agqbu2uf2ti6hly7@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 01:46:58PM +0200, Carlos Maiolino wrote:
> On Wed, Apr 18, 2018 at 10:21:10AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Move xfs_buf_incore out of line and make it the only way to look up
> > a buffer in the buffer cache from outside the buffer cache. Convert
> > the external users of _xfs_buf_find() to xfs_buf_incore() and make
> > _xfs_buf_find() static.
> > 
> 
> Looks good, but shouldn't it be xfs_incore() instead of xfs_buf_incore() in the
> Subject/description?

I wonder if this function really should be named xfs_buf_incore because
xfs maintains a lot of incore state besides buffers, but as far as this
patch goes I'll fix the commit message on the way in.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Otherwise
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 21 ++++++++++++++++-----
> >  fs/xfs/xfs_buf.h | 17 +++--------------
> >  fs/xfs/xfs_qm.c  |  5 ++---
> >  3 files changed, 21 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 55661cbdb51b..2ca8e2c7fbc4 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -549,17 +549,17 @@ xfs_buf_hash_destroy(
> >  }
> >  
> >  /*
> > - *	Look up, and creates if absent, a lockable buffer for
> > - *	a given range of an inode.  The buffer is returned
> > - *	locked.	No I/O is implied by this call.
> > + * Look up (and insert if absent), a lockable buffer for a given
> > + * range of an inode.  The buffer is returned locked. No I/O is
> > + * implied by this call.
> >   */
> > -xfs_buf_t *
> > +static struct xfs_buf *
> >  _xfs_buf_find(
> >  	struct xfs_buftarg	*btp,
> >  	struct xfs_buf_map	*map,
> >  	int			nmaps,
> >  	xfs_buf_flags_t		flags,
> > -	xfs_buf_t		*new_bp)
> > +	struct xfs_buf		*new_bp)
> >  {
> >  	struct xfs_perag	*pag;
> >  	xfs_buf_t		*bp;
> > @@ -649,6 +649,17 @@ _xfs_buf_find(
> >  	return bp;
> >  }
> >  
> > +struct xfs_buf *
> > +xfs_incore(
> > +	struct xfs_buftarg	*target,
> > +	xfs_daddr_t		blkno,
> > +	size_t			numblks,
> > +	xfs_buf_flags_t		flags)
> > +{
> > +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > +	return _xfs_buf_find(target, &map, 1, flags, NULL);
> > +}
> > +
> >  /*
> >   * Assembles a buffer covering the specified range. The code is optimised for
> >   * cache hits, as metadata intensive workloads will see 3 orders of magnitude
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index edced162a674..e8947c1adac0 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -218,20 +218,9 @@ typedef struct xfs_buf {
> >  } xfs_buf_t;
> >  
> >  /* Finding and Reading Buffers */
> > -struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target,
> > -			      struct xfs_buf_map *map, int nmaps,
> > -			      xfs_buf_flags_t flags, struct xfs_buf *new_bp);
> > -
> > -static inline struct xfs_buf *
> > -xfs_incore(
> > -	struct xfs_buftarg	*target,
> > -	xfs_daddr_t		blkno,
> > -	size_t			numblks,
> > -	xfs_buf_flags_t		flags)
> > -{
> > -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > -	return _xfs_buf_find(target, &map, 1, flags, NULL);
> > -}
> > +struct xfs_buf *xfs_incore(struct xfs_buftarg *target,
> > +			   xfs_daddr_t blkno, size_t numblks,
> > +			   xfs_buf_flags_t flags);
> >  
> >  struct xfs_buf *_xfs_buf_alloc(struct xfs_buftarg *target,
> >  			       struct xfs_buf_map *map, int nmaps,
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index ec39ae274c78..aff4924f637f 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1247,9 +1247,8 @@ xfs_qm_flush_one(
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
> > -- 
> > 2.16.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
