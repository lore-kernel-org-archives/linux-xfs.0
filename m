Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:22502 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750951AbdJDGQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 02:16:40 -0400
Date: Wed, 4 Oct 2017 17:13:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/25] xfs: scrub the backup superblocks
Message-ID: <20171004061300.GB3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706330624.19351.11752175372525617518.stgit@magnolia>
 <20171004005709.GV3666@dastard>
 <20171004040646.GM6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004040646.GM6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 09:06:46PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 04, 2017 at 11:57:09AM +1100, Dave Chinner wrote:
> > On Tue, Oct 03, 2017 at 01:41:46PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Ensure that the geometry presented in the backup superblocks matches
> > > the primary superblock so that repair can recover the filesystem if
> > > that primary gets corrupted.
.....

> > > +
> > > +/* Set us up to check an AG header. */
> > > +int
> > > +xfs_scrub_setup_ag_header(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_inode		*ip)
> > > +{
> > 
> > Not immediately clear what "AG header" is being set up here?
> 
> AGF/AGFL/AGI.  All three of them.  Maybe I ought to split them into
> three separate files...?

No, just clarify the comment.

/*
 * Set up scrub to check all the static metadata in each AG. These
 * are the SB, AGF, AGI and AGFL header structures.
 */

> > > +	sb = XFS_BUF_TO_SBP(bp);
> > > +
> > > +	/*
> > > +	 * Verify the geometries match.  Fields that are permanently
> > > +	 * set by mkfs are checked; fields that can be updated later
> > > +	 * (and are not propagated to backup superblocks) are preen
> > > +	 * checked.
> > > +	 */
> > > +	if (sb->sb_blocksize != cpu_to_be32(mp->m_sb.sb_blocksize))
> > > +		xfs_scrub_block_set_corrupt(sc, bp);
> > > +
> > > +	if (sb->sb_dblocks != cpu_to_be64(mp->m_sb.sb_dblocks))
> > > +		xfs_scrub_block_set_corrupt(sc, bp);
> > 
> > Just wondering - once we've set the corrupt flag, do we need to
> > bother checking any of the other fields? It makes no difference to
> > what is reported to userspace or the action it is going to take,
> > so couldn't we just do something like:
> 
> This is something I've also struggled with for quite a while.  The most
> pragmatic reaction is to set the corrupt flag and jump out immediately
> on any failure since we really only care about whether or not we have to
> react to bad metadata either by fixing it or shutting down.

*nod*

> On the other hand, continuing with the checks gives us the ability to
> report /everything/ that's broken in the data structure, which could be
> useful for online forensics (cough) to correlate scrub's report against
> anything else that has popped up in dmesg.

Report where, exactly? The only detailed report we get out of this
is tracepoint information, isn't it? And we'll have to convert the
return address in the tracepoint to a line number to work out what
actually was reported as corrupt. I really can't see myself spending
the time to do that for every corruption in a single structure. Once
I know the structure is corrupt, I don't care about other
corruptions I just want to move on to repair.

IMO, scrub is for detecting errors so they can be repaired or
analysed, not for doing fault analysis. For actual forensics work
we'll still be using xfs_db - analysis processes that require manual
decoding of tracepoints, structures and/or error reports is just not
going to be efficient or usuable by the average developer....

> A downside of having everything jump to a single call to
> xfs_scrub_block_set_corrupt at the end of the function is that the
> return address that we record in the tracepoint will be the end of the
> function instead of right after the failing check.

That's the same optimisation issue we solved for the verifiers
tracing, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
