Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34603 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751397AbdJIC2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 22:28:07 -0400
Date: Mon, 9 Oct 2017 13:28:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/25] xfs: scrub realtime bitmap/summary
Message-ID: <20171009022804.GE3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706340125.19351.13494381752104107446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706340125.19351.13494381752104107446.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:43:21PM -0700, Darrick J. Wong wrote:
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 154c3dd..d4d9bef 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -315,6 +315,11 @@ static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
>  	return false;
>  }
>  
> +static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
> +{
> +	return sbp->sb_rblocks > 0;
> +}

How much can we rely on that? do we allow a fs to mount with that
being > 0 but no rtdev= mount option?

> +/* Set us up with the realtime metadata locked. */
> +int
> +xfs_scrub_setup_rt(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				lockmode;
> +	int				error = 0;
> +
> +	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> +		return -EINVAL;

I've forgotten what this means already :/

> +	error = xfs_scrub_setup_fs(sc, ip);
> +	if (error)
> +		return error;
> +
> +	lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
> +	xfs_ilock(mp->m_rbmip, lockmode);
> +	xfs_trans_ijoin(sc->tp, mp->m_rbmip, lockmode);

Ok, so why do we join this inode to the transaction and not use
the sc->ilock_flags field to track how we've locked it?

> +
> +	return 0;
> +}
> +
> +/* Realtime bitmap. */
> +
> +/* Scrub a free extent record from the realtime bitmap. */
> +STATIC int
> +xfs_scrub_rtbitmap_helper(
> +	struct xfs_trans		*tp,
> +	struct xfs_rtalloc_rec		*rec,
> +	void				*priv)
> +{
> +	return 0;
> +}

Check the extent record returned is within the range of the rtdev
address space?

> +
> +/* Scrub the realtime bitmap. */
> +int
> +xfs_scrub_rtbitmap(
> +	struct xfs_scrub_context	*sc)
> +{
> +	int				error;
> +
> +	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_helper, NULL);
> +	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, 0, &error))
> +		goto out;
> +
> +out:
> +	return error;
> +}
> +
> +/* Scrub the realtime summary. */
> +int
> +xfs_scrub_rtsummary(
> +	struct xfs_scrub_context	*sc)
> +{
> +	/* XXX: implement this some day */
> +	return -ENOENT;
> +}

Alright, this is all just a stub that doesn't really do any real
scrubbing yet. I guess it's better that nothing in that it walks
the rtbitmap....

> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -241,6 +241,21 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>  		.setup	= xfs_scrub_setup_parent,
>  		.scrub	= xfs_scrub_parent,
>  	},
> +#ifdef CONFIG_XFS_RT
> +	{ /* realtime bitmap */
> +		.setup	= xfs_scrub_setup_rt,
> +		.scrub	= xfs_scrub_rtbitmap,
> +		.has	= xfs_sb_version_hasrealtime,
> +	},
> +	{ /* realtime summary */
> +		.setup	= xfs_scrub_setup_rt,
> +		.scrub	= xfs_scrub_rtsummary,
> +		.has	= xfs_sb_version_hasrealtime,
> +	},
> +#else
> +	{ NULL },
> +	{ NULL },
> +#endif

I think I'd prefer that you supply stub functions when
CONFIG_XFS_RT=n so this table doesn't require ifdefs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
