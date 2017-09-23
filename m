Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49912 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdIWHYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Sep 2017 03:24:08 -0400
Date: Sat, 23 Sep 2017 00:24:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/27] xfs: create helpers to record and deal with scrub
 problems
Message-ID: <20170923072403.GO5728@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595309448.18473.17367425546613617113.stgit@magnolia>
 <20170922071608.GG10955@dastard>
 <20170922164418.GG5728@magnolia>
 <20170923072228.GI10955@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923072228.GI10955@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 23, 2017 at 05:22:28PM +1000, Dave Chinner wrote:
> Darrick,
> 
> Excuse the nasty top post, but can you wrap all this up in comments
> in the code? It all makes sense now you explain it, but I'm not
> going to remember all that in a couple of months time...

Already done.

(FWIW top-posting doesn't bother me...)

--D

> 
> -Dave.
> 
> On Fri, Sep 22, 2017 at 09:44:18AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 22, 2017 at 05:16:08PM +1000, Dave Chinner wrote:
> > > On Wed, Sep 20, 2017 at 05:18:14PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create helper functions to record crc and corruption problems, and
> > > > deal with any other runtime errors that arise.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/common.c |  243 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/common.h |   39 ++++++++
> > > >  fs/xfs/scrub/trace.h  |  193 +++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 475 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > > > index 13ccb36..cf3f1365 100644
> > > > --- a/fs/xfs/scrub/common.c
> > > > +++ b/fs/xfs/scrub/common.c
> > > > @@ -47,6 +47,249 @@
> > > >  
> > > >  /* Common code for the metadata scrubbers. */
> > > >  
> > > > +/* Check for operational errors. */
> > > > +bool
> > > > +xfs_scrub_op_ok(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	xfs_agnumber_t			agno,
> > > > +	xfs_agblock_t			bno,
> > > > +	int				*error)
> > > > +{
> > > > +	switch (*error) {
> > > > +	case 0:
> > > > +		return true;
> > > > +	case -EDEADLOCK:
> > > > +		/* Used to restart an op with deadlock avoidance. */
> > > > +		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
> > > > +		break;
> > > > +	case -EFSBADCRC:
> > > > +	case -EFSCORRUPTED:
> > > > +		/* Note the badness but don't abort. */
> > > > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > > > +		*error = 0;
> > > > +		/* fall through */
> > > > +	default:
> > > > +		trace_xfs_scrub_op_error(sc, agno, bno, *error,
> > > > +				__return_address);
> > > > +		break;
> > > > +	}
> > > > +	return false;
> > > > +}
> > > 
> > > What are the semantics here w.r.t. *error? on some errors it's
> > > cleared before we return, on others it's ignored. It's as clear as
> > > mud what we should expect from these functions...
> > 
> > If there's no error, we return true to tell the caller that it's ok to
> > move on to the next check in its list.
> > 
> > For non-verifier errors (e.g. ENOMEM) we return false to tell the caller
> > that there's no point in it continuing, and we preserve *error so that
> > the caller can return the *error up the stack.  Checking stops
> > immediately and the error is handed to userspace.
> > 
> > Verifier errors (EFSBADCRC/EFSCORRUPTED) are recorded in sm_flags and
> > the *error is cleared.  We return false to tell the caller that there's
> > point in it continuing with this record.  The caller returns zero to its
> > caller, which means that checking continues, having skipped whatever
> > block failed the verifier.
> > 
> > > > +/* Check for metadata block optimization possibilities. */
> > > > +bool
> > > > +xfs_scrub_block_preen_ok(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_buf			*bp,
> > > > +	bool				fs_ok)
> > > > +{
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	xfs_fsblock_t			fsbno;
> > > > +	xfs_agnumber_t			agno;
> > > > +	xfs_agblock_t			bno;
> > > > +
> > > > +	if (fs_ok)
> > > > +		return fs_ok;
> > > > +
> > > > +	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> > > > +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > > > +	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > > > +
> > > > +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> > > > +	trace_xfs_scrub_block_preen(sc, agno, bno, __return_address);
> > > > +	return fs_ok;
> > > > +}
> > > 
> > > Again, I'm not sure what the return value semantics of the functioon
> > > are? Why does the fs_ok return shortcut exist?
> > 
> > The fs_ok functions are wrappers around an if test; the results of the
> > if test are passed in as fs_ok.
> > 
> > Therefore, if fs_ok then things are fine and we just skip out.
> > 
> > Otherwise, we found something and we should set sm_flags and jump out.
> > 
> > > Same for all the other functions...
> > > 
> > > > +
> > > > +/* Check for inode metadata non-corruption problems. */
> > > > +bool
> > > > +xfs_scrub_ino_warn_ok(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_buf			*bp,
> > > > +	bool				fs_ok)
> > > 
> > > Confusing. What's the difference between a corruption problem and a
> > > "non-corruption problem" that requires a warning?
> > 
> > Anything that's less severe than "your fs is corrupt" but otherwise
> > requires administrator review.  The inode scrubber sets this for inodes
> > with a -1 uid/gid.  XFS seems fine with it, but the VFS treats -1ULL as
> > a magic "doesn't exist" value, and then userspace can't change it.
> > The quota code sets warnings if it detects quota usage exceeding the
> > hard limit, or if the limits are larger than the fs, etc.
> > 
> > In these cases I'd want the administrator to have a look and/or take
> > corrective action, but XFS doesn't flag those situations as fs
> > corruption nor does xfs_repair complain about them as corruption.
> > 
> > --D
> > 
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
