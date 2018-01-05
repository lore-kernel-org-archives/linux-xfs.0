Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:40938 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751400AbeAECI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 21:08:29 -0500
Date: Fri, 5 Jan 2018 13:08:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/21] xfs: set up scrub cross-referencing helpers
Message-ID: <20180105020826.GX30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398983388.18741.9974351544672577036.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398983388.18741.9974351544672577036.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some helper functions that we'll use later to deal with problems
> we might encounter while cross referencing metadata with other metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/btree.c  |   72 +++++++++++++++++++++-----
>  fs/xfs/scrub/btree.h  |    9 +++
>  fs/xfs/scrub/common.c |  138 +++++++++++++++++++++++++++++++++++++++++++++----
>  fs/xfs/scrub/common.h |   28 ++++++++++
>  fs/xfs/scrub/scrub.c  |   10 ++++
>  fs/xfs/scrub/trace.h  |   22 ++++++++
>  6 files changed, 257 insertions(+), 22 deletions(-)

....

> -bool
> -xfs_scrub_btree_process_error(
> +static bool
> +__xfs_scrub_btree_process_error(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_btree_cur		*cur,
>  	int				level,
> -	int				*error)
> +	int				*error,
> +	bool				xref,
> +	void				*ret_ip)
>  {
>  	if (*error == 0)
>  		return true;
> @@ -60,36 +62,81 @@ xfs_scrub_btree_process_error(
>  	case -EFSBADCRC:
>  	case -EFSCORRUPTED:
>  		/* Note the badness but don't abort. */
> -		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +		sc->sm->sm_flags |= xfs_scrub_process_error_flag(xref);

Hmmmm.

WHy not just pass in the relevant error flag, rather than a boolean
used to choose the error flag?

>  		*error = 0;
>  		/* fall through */
>  	default:
>  		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
>  			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
> -					*error, __return_address);
> +					*error, ret_ip);
>  		else
>  			trace_xfs_scrub_btree_op_error(sc, cur, level,
> -					*error, __return_address);
> +					*error, ret_ip);
>  		break;
>  	}
>  	return false;
>  }
>  
> +bool
> +xfs_scrub_btree_process_error(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	int				*error)
> +{
> +	return __xfs_scrub_btree_process_error(sc, cur, level, error, false,
> +			__return_address);

These then get easier to read, because there isn't a boolean that
you don't know what it means without looking at the function being
called. i.e

	return __xfs_scrub_btree_process_error(sc, cur, level, error,
						XFS_SCRUB_OFLAG_CORRUPT,
						__return_address);
> +}
> +
> +bool
> +xfs_scrub_btree_xref_process_error(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	int				*error)
> +{
> +	return __xfs_scrub_btree_process_error(sc, cur, level, error, true,
> +			__return_address);

	return __xfs_scrub_btree_process_error(sc, cur, level, error,
						XFS_SCRUB_OFLAG_XFAIL,
						__return_address);
> +}
> +
>  /* Record btree block corruption. */
> -void
> -xfs_scrub_btree_set_corrupt(
> +static void
> +__xfs_scrub_btree_set_corrupt(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_btree_cur		*cur,
> -	int				level)
> +	int				level,
> +	bool				xref,
> +	void				*ret_ip)
>  {
> -	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +	if (xref)
> +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
> +	else
> +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  
>  	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
>  		trace_xfs_scrub_ifork_btree_error(sc, cur, level,
> -				__return_address);
> +				ret_ip);
>  	else
>  		trace_xfs_scrub_btree_error(sc, cur, level,
> -				__return_address);
> +				ret_ip);
> +}
> +
> +void
> +xfs_scrub_btree_set_corrupt(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level)
> +{
> +	__xfs_scrub_btree_set_corrupt(sc, cur, level, false, __return_address);
> +}
> +
> +void
> +xfs_scrub_btree_xref_set_corrupt(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level)
> +{
> +	__xfs_scrub_btree_set_corrupt(sc, cur, level, true, __return_address);
>  }

Same for these (and the other equivalent wrapper sets in the patch).

> +
> +/*
> + * Predicate that decides if we need to evaluate the cross-reference check.
> + * If there was an error accessing the cross-reference btree, just delete
> + * the cursor and skip the check.
> + */
> +bool
> +xfs_scrub_should_xref(
> +	struct xfs_scrub_context	*sc,
> +	int				*error,
> +	struct xfs_btree_cur		**curpp)
> +{
> +	/* If not a btree cross-reference, just check the error code. */
> +	if (curpp == NULL) {
> +		if (*error == 0)
> +			return true;
> +		goto fail;
> +	}
> +
> +	ASSERT(*curpp != NULL);
> +	/* If no error or we've already given up on xref, just bail out. */
> +	if (*error == 0 || *curpp == NULL)
> +		return true;

Why the assert if we handle the null case just fine?

> +
> +	/* xref error, delete cursor and bail out. */
> +	xfs_btree_del_cursor(*curpp, XFS_BTREE_ERROR);
> +	*curpp = NULL;
> +fail:

I think the logic up to this point can be cleaned up to be:

	if (*error == 0)
		return true;

	if (curpp) {
		/* If we've already given up on xref, just bail out. */
		if (!*curpp)
			return true;

		/* xref error, delete cursor and bail out. */
		xfs_btree_del_cursor(*curpp, XFS_BTREE_ERROR);
		*curpp = NULL;
	}


> +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
> +	trace_xfs_scrub_xref_error(sc, *error, __return_address);
> +
> +	/*
> +	 * Errors encountered during cross-referencing with another
> +	 * data structure should not cause this scrubber to abort.
> +	 */
> +	*error = 0;
> +	return false;
> +}

.....

> @@ -139,4 +155,16 @@ int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
>  int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
>  				   struct xfs_inode *ip, unsigned int resblks);
>  
> +/*
> + * A libxfs function returned an error while scrubbing an object.
> + * If the function failed while operating on the object (!xref) then
> + * mark the object itself corrupt.  If the function failed while
> + * collecting cross-referencing data from other metadata (xref), then
> + * mark that the cross referencing failed.
> + */
> +static inline __u32 xfs_scrub_process_error_flag(bool xref)
> +{
> +	return xref ? XFS_SCRUB_OFLAG_XFAIL : XFS_SCRUB_OFLAG_CORRUPT;
> +}

If this is really needed, I'd like a better name - "process" doesn't
read right. Maybe  xfs_scrub_xref_fail_flag()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
