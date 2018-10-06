Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20659 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726759AbeJFKOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 06:14:44 -0400
Date: Sat, 6 Oct 2018 13:13:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 02/28] xfs: Add helper function xfs_attr_try_sf_addname
Message-ID: <20181006031305.GD17046@dastard>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
 <1537956907-10244-3-git-send-email-allison.henderson@oracle.com>
 <20181006030119.GC28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006030119.GC28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 08:01:19PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 26, 2018 at 03:14:41AM -0700, Allison Henderson wrote:
> > This patch adds a subroutine xfs_attr_try_sf_addname
> > used by xfs_attr_set.  This subrotine will attempt to
> > add the attribute name specified in args in shortform,
> > as well and perform error handling previously done in
> > xfs_attr_set.
> > 
> > This patch helps to pre-simplify xfs_attr_set for reviewing
> > purposes and reduce indentation.  New function will be added
> > in the next patch.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 61 +++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 40 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1e671d4..f0675be 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -191,6 +191,42 @@ xfs_attr_calc_size(
> >  	return nblks;
> >  }
> >  
> > +STATIC int
> > +xfs_attr_try_sf_addname(
> > +	struct xfs_inode	*dp,
> > +	struct xfs_da_args	*args)
> > +{
> > +
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +	int			error;
> > +
> > +	error = xfs_attr_shortform_addname(args);
> 
> I wonder, what error codes can come out of this function?  -ENOSPC,
> -EEXIST, zero...?

-ENOATTR, -EFSCORRUPTED, -EIO, etc.

ENOSPC here says "attr doesn't fit in shortform, try leaf format",
while every other error needs to be handled as a shortform addition
error.

> 
> > +	if (error == -ENOSPC)
> > +		return error;
> > +
> > +	/*
> > +	 * Commit the shortform mods, and we're done.
> > +	 * NOTE: this is also the error path
> > +	 * (EEXIST, etc).
> > +	 */
> > +	ASSERT(args->trans != NULL);
> 
> <urk> Um... I get that this is just mechanical code refactoring, but...
> 
> > +
> > +	/*
> > +	 * If this is a synchronous mount, make sure
> > +	 * that the transaction goes to disk before
> > +	 * returning to the user.
> > +	 */
> > +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > +		xfs_trans_set_sync(args->trans);
> 
> ...let's say we're on the error path.  Why would we care about making the
> transaction synchronous?

Because we've already modified the inode to add an attr fork, and
we have to obey WSYNC rules for inode changes whether the attr was
added or not.

> > +	if (!error && (args->flags & ATTR_KERNOTIME) == 0) {
> > +		xfs_trans_ichgtime(args->trans, dp,
> > +				XFS_ICHGTIME_CHG);
> > +	}
> 
> And what's the point of updating ctime if we do?

This is only run if there wasn't an error - it's skipped if we
didn't add the attribute to the inode.

> And can we restructure this to follow the usual pattern:
> 
> error = xfs_blabhablhablah(...);
> if (error)
> 	bail out;
> 
> <keep going>

Not quite that simple, some errors still require us to commit the
transaction. And if we've got a fatal error, then the commit will
fail anyway.

> >  			err2 = xfs_trans_commit(args.trans);
> > -			xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > +			error = error ? error : err2;
> >  
> > -			return error ? error : err2;
> > +			xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > +			return error;
> 
> Huh, so we commit the transaction on error?? Why?

So we don't shut down the filesystem by cancelling a dirty
transaction on an -EEXIST or -ENOATTR error after we added the attr
fork to the inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
