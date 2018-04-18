Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeDRWVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 18:21:11 -0400
Date: Wed, 18 Apr 2018 15:20:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] xfs: refactor dquot iteration
Message-ID: <20180418222051.GU24738@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401920165.11465.7352161536009977149.stgit@magnolia>
 <20180418183429.GC22375@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418183429.GC22375@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 02:34:30PM -0400, Brian Foster wrote:
> On Tue, Apr 17, 2018 at 07:40:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a helper function to iterate all the dquots of a given type in
> > the system, and refactor the dquot scrub to use it.  This will get more
> > use in the quota repair code.  Note that the new function differs from
> > xfs_qm_dqiterate in that _dqiterate iterates dquot buffers, not the
> > in-core structures themselves.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/quota.c |   46 +++++++++++++++++++++-------------------------
> >  fs/xfs/xfs_dquot.c   |   41 +++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_dquot.h   |    5 +++++
> >  3 files changed, 67 insertions(+), 25 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index ed2e37c..ec00402 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1127,3 +1127,44 @@ xfs_qm_exit(void)
> >  	kmem_zone_destroy(xfs_qm_dqtrxzone);
> >  	kmem_zone_destroy(xfs_qm_dqzone);
> >  }
> > +
> > +/*
> > + * Iterate every dquot of a particular type.  The caller must ensure that the
> > + * particular quota type is active.  iter_fn can return negative error codes,
> > + * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
> > + *
> > + * Note that xfs_qm_dqiterate iterates all the dquot bufs, not the dquots
> > + * themselves.
> > + */
> > +int
> > +xfs_dquot_iterate(
> > +	struct xfs_mount	*mp,
> > +	uint			dqtype,
> > +	uint			iter_flags,
> > +	xfs_dquot_iterate_fn	iter_fn,
> > +	void			*priv)
> > +{
> > +	struct xfs_dquot	*dq;
> > +	xfs_dqid_t		id = 0;
> > +	int			error;
> > +
> > +	while (id < ((xfs_dqid_t)-1ULL)) {
> > +		error = xfs_qm_dqget(mp, NULL, id, dqtype,
> > +				XFS_QMOPT_DQNEXT | iter_flags, &dq);
> > +		if (error == -ENOENT) {
> > +			error = 0;
> > +			break;
> > +		}
> > +		if (error)
> > +			break;
> > +
> 
> It looks like this logic could be simplified a bit. E.g.:
> 
> 	while ((error = xfs_qm_dqget(mp, NULL, id, dqtype,
> 				XFS_QMOPT_DQNEXT | iter_flags, &dq)) == 0) {
> 		id = be32_to_cpu(dq->q_core.d_id);
> 		...
> 
> 	}
> 	return error == -ENOENT ? 0 : error;

The downside of this (the return line specifically) is we'll squash
iter_fn returning -ENOENT, even though the function comment says iter_fn
is allowed to return that.

That said, the current while loop test is wrong anyway; 0xFFFFFFFF is a
valid project id because the kernel will let you set it, even if
xfs_quota/xfs_io won't.

So I think this loop can become:

do {
	error = xfs_qm_dqget(mp, NULL, id, dqtype,
			XFS_QMOPT_DQNEXT | iter_flags, &dq);
	if (error == -ENOENT)
		return 0;
	if (error)
		return error;

	id = be32_to_cpu(dq->q_core.d_id);
	error = iter_fn(dq, dqtype, id, priv);
	xfs_qm_dqput(dq);
	id++;
} while (error == 0 && id != 0);

--D

> 
> Otherwise looks good.
> 
> Brian
> 
> > +		id = be32_to_cpu(dq->q_core.d_id);
> > +		error = iter_fn(dq, dqtype, id, priv);
> > +		xfs_qm_dqput(dq);
> > +		id++;
> > +		if (error || id == 0)
> > +			break;
> > +	}
> > +
> > +	return error;
> > +}
> > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > index 2f536f3..db0511e 100644
> > --- a/fs/xfs/xfs_dquot.h
> > +++ b/fs/xfs/xfs_dquot.h
> > @@ -185,4 +185,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
> >  	return dqp;
> >  }
> >  
> > +typedef int (*xfs_dquot_iterate_fn)(struct xfs_dquot *dq, uint dqtype,
> > +		xfs_dqid_t id, void *priv);
> > +int xfs_dquot_iterate(struct xfs_mount *mp, uint dqtype, uint iter_flags,
> > +		xfs_dquot_iterate_fn iter_fn, void *priv);
> > +
> >  #endif /* __XFS_DQUOT_H__ */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
