Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23954 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751795AbdIVHXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 03:23:41 -0400
Date: Fri, 22 Sep 2017 17:23:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/27] xfs: create helpers to scrub a metadata btree
Message-ID: <20170922072322.GH10955@dastard>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595310060.18473.12973800380739754286.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150595310060.18473.12973800380739754286.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 05:18:20PM -0700, Darrick J. Wong wrote:
> +/* Check for btree operation errors . */
> +bool
> +xfs_scrub_btree_op_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	int				*error)
> +{
> +	if (*error == 0)
> +		return true;
> +
> +	switch (*error) {
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
> +		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
> +					*error, __return_address);
> +		else
> +			trace_xfs_scrub_btree_op_error(sc, cur, level,
> +					*error, __return_address);

Why different tracepoints when you could just output the
cur->bc_flags in the trace output and use the same tracepoint?
Doing that looks like it would simplify the tracepoint code
in this patch....

> +/* Figure out which block the btree cursor was pointing to. */
> +static inline xfs_fsblock_t
> +xfs_scrub_btree_cur_fsbno(
> +	struct xfs_btree_cur		*cur,
> +	int				level)
> +{
> +	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> +		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
> +	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)

no need for "else if", just "if" will do.

> +		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_private.b.ip->i_ino);

This makes no sense to me. Why are we returning the block address of
the inode here? It's not part of the btree....


> +	return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno, 0);

Nor is the first block of the AG....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
