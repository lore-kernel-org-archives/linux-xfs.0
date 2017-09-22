Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32290 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751795AbdIVHQL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 03:16:11 -0400
Date: Fri, 22 Sep 2017 17:16:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/27] xfs: create helpers to record and deal with scrub
 problems
Message-ID: <20170922071608.GG10955@dastard>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595309448.18473.17367425546613617113.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150595309448.18473.17367425546613617113.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 05:18:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create helper functions to record crc and corruption problems, and
> deal with any other runtime errors that arise.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/common.c |  243 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/common.h |   39 ++++++++
>  fs/xfs/scrub/trace.h  |  193 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 475 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 13ccb36..cf3f1365 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -47,6 +47,249 @@
>  
>  /* Common code for the metadata scrubbers. */
>  
> +/* Check for operational errors. */
> +bool
> +xfs_scrub_op_ok(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agnumber_t			agno,
> +	xfs_agblock_t			bno,
> +	int				*error)
> +{
> +	switch (*error) {
> +	case 0:
> +		return true;
> +	case -EDEADLOCK:
> +		/* Used to restart an op with deadlock avoidance. */
> +		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
> +		break;
> +	case -EFSBADCRC:
> +	case -EFSCORRUPTED:
> +		/* Note the badness but don't abort. */
> +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +		*error = 0;
> +		/* fall through */
> +	default:
> +		trace_xfs_scrub_op_error(sc, agno, bno, *error,
> +				__return_address);
> +		break;
> +	}
> +	return false;
> +}

What are the semantics here w.r.t. *error? on some errors it's
cleared before we return, on others it's ignored. It's as clear as
mud what we should expect from these functions...

> +/* Check for metadata block optimization possibilities. */
> +bool
> +xfs_scrub_block_preen_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*bp,
> +	bool				fs_ok)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_fsblock_t			fsbno;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			bno;
> +
> +	if (fs_ok)
> +		return fs_ok;
> +
> +	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> +
> +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> +	trace_xfs_scrub_block_preen(sc, agno, bno, __return_address);
> +	return fs_ok;
> +}

Again, I'm not sure what the return value semantics of the functioon
are? Why does the fs_ok return shortcut exist?

Same for all the other functions...

> +
> +/* Check for inode metadata non-corruption problems. */
> +bool
> +xfs_scrub_ino_warn_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*bp,
> +	bool				fs_ok)

Confusing. What's the difference between a corruption problem and a
"non-corruption problem" that requires a warning?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
