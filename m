Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45135 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfDPBQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 21:16:04 -0400
Date: Tue, 16 Apr 2019 11:16:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: scrub should only cross-reference with healthy
 btrees
Message-ID: <20190416011600.GK29573@dread.disaster.area>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
 <155537400192.27935.5071586825961103642.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155537400192.27935.5071586825961103642.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Apr 15, 2019 at 05:20:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip cross-referencing with a btree if the health report tells us that
> it's known to be bad.  This should reduce the dmesg spew considerably.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -174,3 +174,79 @@ xchk_update_health(
>  		break;
>  	}
>  }
> +
> +/* Is the given per-AG btree healthy enough for scanning? */
> +bool
> +xchk_ag_btree_healthy_enough(
> +	struct xfs_scrub	*sc,
> +	struct xfs_perag	*pag,
> +	xfs_btnum_t		btnum)
> +{
> +	unsigned int		mask = 0;
> +
> +	/*
> +	 * We always want the cursor if it's the same type as whatever we're
> +	 * scrubbing, even if we already know the structure is corrupt.
> +	 */
> +	switch (sc->sm->sm_type) {
> +	case XFS_SCRUB_TYPE_BNOBT:
> +		if (btnum == XFS_BTNUM_BNO)
> +			return true;
> +		break;
> +	case XFS_SCRUB_TYPE_CNTBT:
> +		if (btnum == XFS_BTNUM_CNT)
> +			return true;
> +		break;
> +	case XFS_SCRUB_TYPE_INOBT:
> +		if (btnum == XFS_BTNUM_INO)
> +			return true;
> +		break;
> +	case XFS_SCRUB_TYPE_FINOBT:
> +		if (btnum == XFS_BTNUM_FINO)
> +			return true;
> +		break;
> +	case XFS_SCRUB_TYPE_RMAPBT:
> +		if (btnum == XFS_BTNUM_RMAP)
> +			return true;
> +		break;
> +	case XFS_SCRUB_TYPE_REFCNTBT:
> +		if (btnum == XFS_BTNUM_REFC)
> +			return true;
> +		break;
> +	}
> +
> +	/*
> +	 * Otherwise, we're only interested in the btree for cross-referencing.
> +	 * If we know the btree is bad then don't bother, just set XFAIL.
> +	 */
> +	switch (btnum) {
> +	case XFS_BTNUM_BNO:
> +		mask = XFS_SICK_AG_BNOBT;
> +		break;
> +	case XFS_BTNUM_CNT:
> +		mask = XFS_SICK_AG_CNTBT;
> +		break;
> +	case XFS_BTNUM_INO:
> +		mask = XFS_SICK_AG_INOBT;
> +		break;
> +	case XFS_BTNUM_FINO:
> +		mask = XFS_SICK_AG_FINOBT;
> +		break;
> +	case XFS_BTNUM_RMAP:
> +		mask = XFS_SICK_AG_RMAPBT;
> +		break;
> +	case XFS_BTNUM_REFC:
> +		mask = XFS_SICK_AG_REFCNTBT;
> +		break;
> +	default:
> +		ASSERT(0);
> +		return true;
> +	}
> +
> +	if (xfs_ag_has_sickness(pag, mask)) {
> +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
> +		return false;
> +	}
> +
> +	return true;

THis could be done with a single switch statement:

	switch (btnum) {
	case XFS_BTNUM_BNO:
		if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
			return true;
		mask = XFS_SICK_AG_BNOBT;
		break;
	case XFS_BTNUM_CNT:
		if (sc->sm->sm_type == XFS_SCRUB_TYPE_CNTBT)
			return true;
		mask = XFS_SICK_AG_CNTBT;
		break;
.....

Otherwise it is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
