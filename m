Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46911 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdJDRtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 13:49:03 -0400
Date: Wed, 4 Oct 2017 10:48:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/25] xfs: scrub the shape of a metadata btree
Message-ID: <20171004174853.GQ6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706328772.19351.6405488670699092537.stgit@magnolia>
 <20171004001535.GT3666@dastard>
 <20171004035117.GK6503@magnolia>
 <20171004054813.GZ3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004054813.GZ3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 04:48:13PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 08:51:17PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 04, 2017 at 11:15:35AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:41:27PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a function that can check the shape of a btree -- each block
> > > > passes basic inspection and all the pointers look ok.  In the next patch
> > > > we'll add the ability to check the actual keys and records stored within
> > > > the btree.  Add some helper functions so that we report detailed scrub
> > > > errors in a uniform manner in dmesg.  These are helper functions for
> > > > subsequent patches.
> > > .....
> > > >  
> > > > +/* Check a btree pointer.  Returns true if it's ok to use this pointer. */
> > > > +static bool
> > > > +xfs_scrub_btree_ptr_ok(
> > > > +	struct xfs_scrub_btree		*bs,
> > > > +	int				level,
> > > > +	union xfs_btree_ptr		*ptr)
> > > > +{
> > > > +	struct xfs_btree_cur		*cur = bs->cur;
> > > > +	xfs_daddr_t			daddr;
> > > > +	xfs_daddr_t			eofs;
> > > > +
> > > > +	if (xfs_btree_ptr_is_null(cur, ptr)) {
> > > > +		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> > > > +		return false;
> > > > +	}
> > > > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > > > +		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
> > > > +	} else {
> > > > +		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
> > > > +		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
> > > > +				be32_to_cpu(ptr->s));
> > > > +	}
> > > > +	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
> > > > +	if (daddr == 0 || daddr >= eofs) {
> > > > +		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> > > > +		return false;
> > > > +	}
> > > > +
> > > > +	return true;
> > > > +}
> > > 
> > > There seems to be quite a bit of overlap here with
> > > xfs_btree_check_ptr(). Indeed, for the short pointers the above code
> > > fails to check it is within the bounds of the AG size. I'd suggest
> > > both of these should use the same validity checking functions....
> > 
> > Hmm... you're right that the short pointer needs to be checked against
> > the AG size.  That said, the regular xfs_btree_check_ptr function will
> > log a XFS_ERROR_REPORT to dmesg, which we don't want, since we're going
> > to report the scrub failure to userspace anyway.
> > 
> > I think I prefer to fix this existing function since it's silent and
> > we can maintain the current behavior where a failure in regular
> > operation gets logged to dmesg.
> 
> I'd prefer a core function that doesn't ERROR_REPORT, and a version
> with the error report wrapped around the outside to replace the
> existing users....
> 
> > > ....
> > > > +/*
> > > > + * Grab and scrub a btree block given a btree pointer.  Returns block
> > > > + * and buffer pointers (if applicable) if they're ok to use.
> > > > + */
> > > > +STATIC int
> > > > +xfs_scrub_btree_get_block(
> > > > +	struct xfs_scrub_btree		*bs,
> > > > +	int				level,
> > > > +	union xfs_btree_ptr		*pp,
> > > > +	struct xfs_btree_block		**pblock,
> > > > +	struct xfs_buf			**pbp)
> > > > +{
> > > > +	int				error;
> > > > +
> > > > +	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
> > > > +	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, level, &error) || !pblock)
> > > > +		return error;
> > > > +
> > > > +	xfs_btree_get_block(bs->cur, level, pbp);
> > > > +	error = xfs_btree_check_block(bs->cur, *pblock, level, *pbp);
> > > > +	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, level, &error))
> > > > +		return error;
> > > 
> > > xfs_btree_check_block() will throw error reports to dmesg for each
> > > corrupt block that is found. Do we want scrub to do this, or should
> > > it just report the corrupt block to userspace?
> > 
> > Having looked at xfs_btree_check_block again, I prefer not to spew to
> > dmesg at all for scrub operations in favor of simply reporting the
> > corruption back to userland.  I think I'll copy it to scrub so that we
> > can have better tracepointing and eliminate the XFS_TEST_ERROR that will
> > get in the way.
> 
> As above, I'd much prefer we don't copy-n-paste extremely similar
> checks just to avoid a ERROR_REPORT. Factor out the error report,
> call the common code here, make xfs_btree_check_block() wrap the
> common code with an error report...

Sure.

> > > Which makes me ask the question - why aren't we validating the
> > > initial pointer when the root is in an inode?
> > 
> > What /is/ the correct initial pointer value for when the root is an
> > inode?
> 
> Somewhere between FSB 1 and sb_dblocks....?
> 
> > xfs_bmbt_init_ptr_from_cur returns a pointer to fsb 0, which to
> > seems wrong.  Maybe it should return NULLFSBLOCK since the root of the
> > btree isn't a block anyway?  But perhaps it returns zero to avoid
> > tripping up xfs_btree_check_lptr....
> > 
> > What if I rewrite the start of xfs_scrub_btree_ptr_ok to be:
> > 
> > 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> > 	    level == cur->bc_nlevels - 1) {
> > 		if (ptr->l != 0) {
> > 			xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> > 			return false;
> > 		}
> > 		return true;
> > 	}
> > 
> > 	if (xfs_btree_ptr_is_null(cur, ptr)) {
> > 		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> > 		return false;
> > 	}
> > 
> > and then your suggested callsite in xfs_scrub_btree becomes:
> > 
> > 	level = cur->bc_nlevels - 1;
> > 	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> > 	if (!xfs_scrub_btree_ptr_ok(&bs, level, &ptr))
> > 		goto out;
> > 
> 
> Makes more sense.

OK.

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
