Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51406 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754416AbdJIXIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 19:08:39 -0400
Date: Mon, 9 Oct 2017 16:08:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/25] xfs: scrub quota information
Message-ID: <20171009230834.GX7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706340739.19351.4078240552236189694.stgit@magnolia>
 <20171009025151.GF3666@dastard>
 <20171009200328.GT7122@magnolia>
 <20171009221751.GQ3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009221751.GQ3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 09:17:51AM +1100, Dave Chinner wrote:
> On Mon, Oct 09, 2017 at 01:03:28PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 09, 2017 at 01:51:51PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:43:27PM -0700, Darrick J. Wong wrote:
> > > > +xfs_scrub_quota_to_dqtype(
> > > > +	struct xfs_scrub_context	*sc)
> > > > +{
> > > > +	switch (sc->sm->sm_type) {
> > > > +	case XFS_SCRUB_TYPE_UQUOTA:
> > > > +		return XFS_DQ_USER;
> > > > +	case XFS_SCRUB_TYPE_GQUOTA:
> > > > +		return XFS_DQ_GROUP;
> > > > +	case XFS_SCRUB_TYPE_PQUOTA:
> > > > +		return XFS_DQ_PROJ;
> > > > +	default:
> > > > +		return 0;
> > > > +	}
> > > > +}
> > > > +
> > > > +/* Set us up to scrub a quota. */
> > > > +int
> > > > +xfs_scrub_setup_quota(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_inode		*ip)
> > > > +{
> > > > +	uint				dqtype;
> > > > +
> > > > +	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> > > > +		return -EINVAL;
> > > > +
> > > > +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> > > > +	if (dqtype == 0)
> > > > +		return -EINVAL;
> > > > +	return 0;
> > > > +}
> > > 
> > > Should this check whether the quota type is actually enabled, and
> > > return ENOENT if it's not? i.e move the check out of
> > > xfs_scrub_quota() and into the setup function?
> > 
> > I can add a xfs_this_quota_on check to the setup function, but don't we
> > need xfs_scrub_quota to lock qi_quotaofflock and then recheck that the
> > quota type is still enabled?
> 
> The qi_quotaofflock is held across the entire scrub, right?
> 
> Ah, this is called before the qi_quotaofflock is held - is there
> a teardown callback? If so, would it be better to lock
> qi_quotaofflock in the setup, release it in the teardown? That way
> we can check here in the setup code, and not have to double check
> the user input it in the scrub function itself?

There isn't a generic callback in the teardown.

> > > > +	/*
> > > > +	 * Warn if the limits are larger than the fs.  Administrators
> > > > +	 * can do this, though in production this seems suspect.
> > > > +	 */
> > > > +	if (bhard > mp->m_sb.sb_dblocks || bsoft > mp->m_sb.sb_dblocks)
> > > > +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> > > > +	if (ihard > inodes || isoft > inodes)
> > > > +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> > > > +	if (rhard > mp->m_sb.sb_rblocks || rsoft > mp->m_sb.sb_rblocks)
> > > > +		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> > > 
> > > Can you stack these so there's one per line? i.e.:
> > 
> > Will do.  I'll also change the ihard/isoft check here to check against
> > mp->m_maxicount directly.
> > 
> > > 	if (bhard > mp->m_sb.sb_dblocks ||
> > > 	    bsoft > mp->m_sb.sb_dblocks)
> > > 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> > > 
> > > > +
> > > > +	/* Soft limit must be less than the hard limit. */
> > > > +	if (bsoft > bhard || isoft > ihard || rsoft > rhard)
> > > > +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> > > 
> > > Though with this check, I suspect you only need to check the hard
> > > limits against their upper limits because if the hard limit is valid
> > > and the soft is above then it's going to trigger corruption. Do we
> > > need a warning as well in that case?
> > 
> > I don't follow here ... if the soft limit is above the hard limit, what
> > will trigger corruption? 
> 
> What I mean was this:
> 
> 	if (bhard > mp->m_sb.sb_dblocks)
> 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
> 	if (bsoft > bhard)
> 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> 
> That is, if bhard is over the valid limit, throw a warning and we
> now don't care about bsoft because we've already signalled to
> userspace there's a problem.
> 
> If bsoft is now greater than bhard, regardless of whether it's over
> the valid size, we signal a corruption. If bhard is already an
> invalid number, then this corruption report also implies that bsoft
> is over the limit...
> 
> > The quota syscalls enforce that bhard > bsoft
> > when the admin tries to set new limits, but if the disk is corrupt such
> > that dblocks = 300, bhard = 250, and bsoft = 280, the checks for
> > (bhard > dblocks || bsoft > dblocks) checks won't trigger.  That's why
> > there's an explicit bsoft > bhard check here.
> 
> Right, I wasn't suggesting removing it - I didn't make it very clear
> what I meant.

Ah, ok, I get it now, thanks.

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
