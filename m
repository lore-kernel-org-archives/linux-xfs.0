Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47397 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751411AbdJPBfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 21:35:45 -0400
Date: Mon, 16 Oct 2017 12:29:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/30] xfs: scrub the shape of a metadata btree
Message-ID: <20171016012959.GO3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777251646.1724.4676276998721808182.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777251646.1724.4676276998721808182.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a function that can check the shape of a btree -- each block
> passes basic inspection and all the pointers look ok.  In the next patch
> we'll add the ability to check the actual keys and records stored within
> the btree.  Add some helper functions so that we report detailed scrub
> errors in a uniform manner in dmesg.  These are helper functions for
> subsequent patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Minor thing:

>  /*
> + * Check a btree pointer.  Returns true if it's ok to use this pointer.
> + * Callers do not need to set the corrupt flag.
> + */
> +static bool
> +xfs_scrub_btree_ptr_ok(
> +	struct xfs_scrub_btree		*bs,
> +	int				level,
> +	union xfs_btree_ptr		*ptr)
> +{
> +	bool				res;
> +
> +	/* A btree rooted in an inode has no block pointer to the root. */
> +	if ((bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> +	    level == bs->cur->bc_nlevels)
> +		return true;
> +
> +	/* Otherwise, check the pointers. */
> +	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		res = xfs_btree_check_lptr(bs->cur, be64_to_cpu(ptr->l), level);
> +		if (!res)
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
> +	} else {
> +		res = xfs_btree_check_sptr(bs->cur, be32_to_cpu(ptr->s), level);
> +		if (!res)
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
> +	}

We should already know what type of btree we are scrubbing, so I
think this can be simplified to a single
xfs_scrub_btree_set_corrupt() tracepoint.

> +STATIC int
> +xfs_scrub_btree_get_block(
> +	struct xfs_scrub_btree		*bs,
> +	int				level,
> +	union xfs_btree_ptr		*pp,
> +	struct xfs_btree_block		**pblock,
> +	struct xfs_buf			**pbp)
> +{
> +	void				*failed_at;
> +	int				error;
> +
> +	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
> +	if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, level, &error) ||
> +	    !pblock)
> +		return error;
> +
> +	xfs_btree_get_block(bs->cur, level, pbp);
> +	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		failed_at = __xfs_btree_check_lblock(bs->cur, *pblock,
> +				level, *pbp);
> +		if (failed_at) {
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
> +			return 0;
> +		}
> +	} else {
> +		failed_at = __xfs_btree_check_sblock(bs->cur, *pblock,
> +				 level, *pbp);
> +		if (failed_at) {
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
> +			return 0;
> +		}
> +	}

And same here.

> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index a7c3361..414bbb8 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -21,6 +21,24 @@
>  #define __XFS_SCRUB_COMMON_H__
>  
>  /*
> + * We /could/ terminate a scrub/repair operation early.  If we're not
> + * in a good place to continue (fatal signal, etc.) then bail out.
> + * Note that we're careful not to make any judgements about *error.
> + */
> +static inline bool
> +xfs_scrub_should_terminate(
> +	struct xfs_scrub_context	*sc,
> +	int				*error)
> +{
> +	if (fatal_signal_pending(current)) {
> +		if (*error == 0)
> +			*error = -EAGAIN;
> +		return true;
> +	}
> +	return false;
> +}

Probably should move that to the original scrub infrastructure
patch.

Otherwise looks fine.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
