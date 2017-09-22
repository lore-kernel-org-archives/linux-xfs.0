Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48767 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdIVQ7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 12:59:19 -0400
Date: Fri, 22 Sep 2017 09:59:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/27] xfs: create helpers to scrub a metadata btree
Message-ID: <20170922165915.GH5728@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595310060.18473.12973800380739754286.stgit@magnolia>
 <20170922072322.GH10955@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922072322.GH10955@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 05:23:22PM +1000, Dave Chinner wrote:
> On Wed, Sep 20, 2017 at 05:18:20PM -0700, Darrick J. Wong wrote:
> > +/* Check for btree operation errors . */
> > +bool
> > +xfs_scrub_btree_op_ok(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_btree_cur		*cur,
> > +	int				level,
> > +	int				*error)
> > +{
> > +	if (*error == 0)
> > +		return true;
> > +
> > +	switch (*error) {
> > +	case -EDEADLOCK:
> > +		/* Used to restart an op with deadlock avoidance. */
> > +		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
> > +		break;
> > +	case -EFSBADCRC:
> > +	case -EFSCORRUPTED:
> > +		/* Note the badness but don't abort. */
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > +		*error = 0;
> > +		/* fall through */
> > +	default:
> > +		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > +			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
> > +					*error, __return_address);
> > +		else
> > +			trace_xfs_scrub_btree_op_error(sc, cur, level,
> > +					*error, __return_address);
> 
> Why different tracepoints when you could just output the
> cur->bc_flags in the trace output and use the same tracepoint?
> Doing that looks like it would simplify the tracepoint code
> in this patch....

The ifork_btree_op_error tracepoint records the inode number and
whichfork, whereas the btree_op_error of course does not.  I don't know
how to write a tracepoint that changes the TP_printk format string &
arguments based on the inputs.  If the bmap scrubber sees a problem with
an inode's fork, I want to know which inode and which fork without
having to go find the previous xfs_scrub_start trace.

> 
> > +/* Figure out which block the btree cursor was pointing to. */
> > +static inline xfs_fsblock_t
> > +xfs_scrub_btree_cur_fsbno(
> > +	struct xfs_btree_cur		*cur,
> > +	int				level)
> > +{
> > +	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> > +		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
> > +	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> 
> no need for "else if", just "if" will do.
> 
> > +		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_private.b.ip->i_ino);
> 
> This makes no sense to me. Why are we returning the block address of
> the inode here? It's not part of the btree....
> 
> 
> > +	return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno, 0);
> 
> Nor is the first block of the AG....

I should've written into the comment that the fsb returned by this
function is used only for tracepoint output.

These two clauses are fallbacks to handle the case that this level of
the btree cursor doesn't point to a buffer.  If there is no xfs_buf and
this is a long-pointer btree then either we're looking at the btree root
in the inode or staring into space, for either of these we might as well
report the block that contains the inode.  If there is no xfs_buf and
it's a short-pointer btree then it must be an AG tree and so report the
AG.

I could be persuaded that if we don't have a buffer and it's not the
inode root then just report NULLFSBLOCK in the tracepoint, since I
revised all the tracepoints to contain the inum/agno anyway.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
