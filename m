Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4991 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752161AbdJICwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 22:52:16 -0400
Date: Mon, 9 Oct 2017 13:51:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/25] xfs: scrub quota information
Message-ID: <20171009025151.GF3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706340739.19351.4078240552236189694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706340739.19351.4078240552236189694.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:43:27PM -0700, Darrick J. Wong wrote:
> +xfs_scrub_quota_to_dqtype(
> +	struct xfs_scrub_context	*sc)
> +{
> +	switch (sc->sm->sm_type) {
> +	case XFS_SCRUB_TYPE_UQUOTA:
> +		return XFS_DQ_USER;
> +	case XFS_SCRUB_TYPE_GQUOTA:
> +		return XFS_DQ_GROUP;
> +	case XFS_SCRUB_TYPE_PQUOTA:
> +		return XFS_DQ_PROJ;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +/* Set us up to scrub a quota. */
> +int
> +xfs_scrub_setup_quota(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	uint				dqtype;
> +
> +	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> +		return -EINVAL;
> +
> +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> +	if (dqtype == 0)
> +		return -EINVAL;
> +	return 0;
> +}

Should this check whether the quota type is actually enabled, and
return ENOENT if it's not? i.e move the check out of
xfs_scrub_quota() and into the setup function?

> +
> +/* Quotas. */
> +
> +/* Scrub the fields in an individual quota item. */
> +STATIC void
> +xfs_scrub_quota_item(
> +	struct xfs_scrub_context	*sc,
> +	uint				dqtype,
> +	struct xfs_dquot		*dq,
> +	xfs_dqid_t			id)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_disk_dquot		*d = &dq->q_core;
> +	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> +	xfs_fileoff_t			offset;
> +	unsigned long long		bsoft;
> +	unsigned long long		isoft;
> +	unsigned long long		rsoft;
> +	unsigned long long		bhard;
> +	unsigned long long		ihard;
> +	unsigned long long		rhard;
> +	unsigned long long		bcount;
> +	unsigned long long		icount;
> +	unsigned long long		rcount;
> +	xfs_ino_t			inodes;
> +
> +	/* Did we get the dquot we wanted? */
> +	offset = id * qi->qi_dqperchunk;
> +	if (id > be32_to_cpu(d->d_id) ||

Why is this a ">" check rather than "!="?

> +	    dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> +
> +	/* Check the limits. */
> +	bhard = be64_to_cpu(d->d_blk_hardlimit);
> +	ihard = be64_to_cpu(d->d_ino_hardlimit);
> +	rhard = be64_to_cpu(d->d_rtb_hardlimit);
> +
> +	bsoft = be64_to_cpu(d->d_blk_softlimit);
> +	isoft = be64_to_cpu(d->d_ino_softlimit);
> +	rsoft = be64_to_cpu(d->d_rtb_softlimit);
> +
> +	inodes = XFS_AGINO_TO_INO(mp, mp->m_sb.sb_agcount, 0);

Allocated inode counts should check against the filesystem inode
limit (mp->m_maxicount) rather than the physical last inode number
(which is wrong, anyway, for a small last AG).

> +
> +	/*
> +	 * Warn if the limits are larger than the fs.  Administrators
> +	 * can do this, though in production this seems suspect.
> +	 */
> +	if (bhard > mp->m_sb.sb_dblocks || bsoft > mp->m_sb.sb_dblocks)
> +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> +	if (ihard > inodes || isoft > inodes)
> +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> +	if (rhard > mp->m_sb.sb_rblocks || rsoft > mp->m_sb.sb_rblocks)
> +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);

Can you stack these so there's one per line? i.e.:

	if (bhard > mp->m_sb.sb_dblocks ||
	    bsoft > mp->m_sb.sb_dblocks)
		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);

> +
> +	/* Soft limit must be less than the hard limit. */
> +	if (bsoft > bhard || isoft > ihard || rsoft > rhard)
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);

Though with this check, I suspect you only need to check the hard
limits against their upper limits because if the hard limit is valid
and the soft is above then it's going to trigger corruption. Do we
need a warning as well in that case?

> +	/* Check the resource counts. */
> +	bcount = be64_to_cpu(d->d_bcount);
> +	icount = be64_to_cpu(d->d_icount);
> +	rcount = be64_to_cpu(d->d_rtbcount);
> +	inodes = percpu_counter_sum(&mp->m_icount);

Can we use different variable names for "inodes" here? One is the
maximum allowed, the other is currently allocated.

> +/* Scrub all of a quota type's items. */
> +int
> +xfs_scrub_quota(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_bmbt_irec		irec = { 0 };
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_inode		*ip;
> +	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> +	struct xfs_dquot		*dq;
> +	xfs_fileoff_t			max_dqid_off;
> +	xfs_fileoff_t			off = 0;
> +	xfs_dqid_t			id = 0;
> +	uint				dqtype;
> +	int				nimaps;
> +	int				error;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> +		return -ENOENT;
> +
> +	mutex_lock(&qi->qi_quotaofflock);
> +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> +	if (!xfs_this_quota_on(sc->mp, dqtype)) {
> +		error = -ENOENT;
> +		goto out;

goto out_unlock_quota

> +	}
> +
> +	/* Attach to the quota inode and set sc->ip so that reporting works. */
> +	ip = xfs_quota_inode(sc->mp, dqtype);
> +	sc->ip = ip;
> +
> +	/* Look for problem extents. */
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
> +	while (1) {
> +		if (xfs_scrub_should_terminate(sc, &error))
> +			break;

goto out_unlock_inode

> +
> +		off = irec.br_startoff + irec.br_blockcount;
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, off, -1, &irec, &nimaps,
> +				XFS_BMAPI_ENTIRE);
> +		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, off, &error))
> +			goto out_unlock;

out_unlock_inode

> +		if (!nimaps)
> +			break;
> +		if (irec.br_startblock == HOLESTARTBLOCK)
> +			continue;
> +
> +		/*
> +		 * Unwritten extents or blocks mapped above the highest
> +		 * quota id shouldn't happen.
> +		 */
> +		if (isnullstartblock(irec.br_startblock) ||
> +		    irec.br_startoff > max_dqid_off ||
> +		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
> +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
> +	}
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	/* Check all the quota items. */
> +	while (id < ((xfs_dqid_t)-1ULL)) {
> +		if (xfs_scrub_should_terminate(sc, &error))
> +			break;
> +
> +		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
> +				&dq);
> +		if (error == -ENOENT)
> +			break;
> +		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK,
> +				id * qi->qi_dqperchunk, &error))
> +			goto out;

break

> +
> +		xfs_scrub_quota_item(sc, dqtype, dq, id);
> +
> +		id = be32_to_cpu(dq->q_core.d_id) + 1;
> +		xfs_qm_dqput(dq);
> +		if (!id)
> +			break;
> +	}

out_unlock_quota:
	sc->ip = NULL;
	mutex_unlock(&qi->qi_quotaofflock);
	return error;

out_unlock_inode:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	goto out_unlock_quota;
}

> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 348e3c3..0849b3f 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -256,6 +256,24 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>  	{ NULL },
>  	{ NULL },
>  #endif
> +#ifdef CONFIG_XFS_QUOTA
> +	{ /* user quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +	{ /* group quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +	{ /* project quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +#else
> +	{ NULL },
> +	{ NULL },
> +	{ NULL },
> +#endif
>  };

Again, I think stub functions are in order here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
