Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757822AbeDXNIK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:08:10 -0400
Date: Tue, 24 Apr 2018 09:08:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/13] xfs: refactor dquot iteration
Message-ID: <20180424130808.GC50204@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440964413.29601.4956532853947603949.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440964413.29601.4956532853947603949.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:07:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper function to iterate all the dquots of a given type in
> the system, and refactor the dquot scrub to use it.  This will get more
> use in the quota repair code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/quota.c |   45 +++++++++++++++++++++------------------------
>  fs/xfs/xfs_dquot.c   |   32 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_dquot.h   |    5 +++++
>  3 files changed, 58 insertions(+), 24 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7ce3dbd..1f1139d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1213,3 +1213,35 @@ xfs_qm_exit(void)
>  	kmem_zone_destroy(xfs_qm_dqtrxzone);
>  	kmem_zone_destroy(xfs_qm_dqzone);
>  }
> +
> +/*
> + * Iterate every dquot of a particular type.  The caller must ensure that the
> + * particular quota type is active.  iter_fn can return negative error codes,
> + * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
> + */
> +int
> +xfs_qm_dqiterate(
> +	struct xfs_mount	*mp,
> +	uint			dqtype,
> +	xfs_qm_dqiterate_fn	iter_fn,
> +	void			*priv)
> +{
> +	struct xfs_dquot	*dq;
> +	xfs_dqid_t		id = 0;
> +	int			error;
> +
> +	do {
> +		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
> +		if (error == -ENOENT)
> +			return 0;
> +		if (error)
> +			return error;
> +
> +		id = be32_to_cpu(dq->q_core.d_id);
> +		error = iter_fn(dq, dqtype, id, priv);

This passes the id from the dquot into the scrub function, which goes
and does:

        if (id > be32_to_cpu(d->d_id))
                xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);

Is the intent to pass the search id into the iterator callback? If so,
perhaps a more descriptive name might be helpful (i.e., search_id, key,
whatever..). Otherwise looks Ok to me.

Brian

> +		xfs_qm_dqput(dq);
> +		id++;
> +	} while (error == 0 && id != 0);
> +
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index fe99e43..5427355 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -194,4 +194,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
>  	return dqp;
>  }
>  
> +typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq, uint dqtype,
> +		xfs_dqid_t id, void *priv);
> +int xfs_qm_dqiterate(struct xfs_mount *mp, uint dqtype,
> +		xfs_qm_dqiterate_fn iter_fn, void *priv);
> +
>  #endif /* __XFS_DQUOT_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
