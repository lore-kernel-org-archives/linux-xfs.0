Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbeAWSTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 13:19:45 -0500
Date: Tue, 23 Jan 2018 10:19:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: reflink should break pnfs leases before sharing
 blocks
Message-ID: <20180123181941.GP25805@magnolia>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
 <151651283574.28390.7095577838603162643.stgit@magnolia>
 <20180123120519.GA31825@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180123120519.GA31825@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 07:05:20AM -0500, Brian Foster wrote:
> On Sat, Jan 20, 2018 at 09:33:55PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Before we share blocks between files, we need to break the pnfs leases
> > on the layout before we start slicing and dicing the block map.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_reflink.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 45 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 47aea2e..ce523dd 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1245,6 +1245,48 @@ xfs_reflink_remap_blocks(
> >  }
> >  
> >  /*
> > + * Grab the exclusive iolock for a data copy from src to dest, making
> > + * sure to abide vfs locking order (lowest pointer value goes first) and
> > + * breaking the pnfs layout leases on dest before proceeding.
> > + */
> > +static int
> > +xfs_iolock_two_inodes_and_break_layout(
> > +	struct inode		*src,
> > +	struct inode		*dest)
> > +{
> > +	bool			src_first = src < dest;
> > +	bool			src_last = src > dest;
> > +	int			error;
> > +
> > +retry:
> > +	if (src_first) {
> > +		inode_lock(src);
> > +		inode_lock_nested(dest, I_MUTEX_NONDIR2);
> > +	} else {
> > +		inode_lock(dest);
> > +	}
> > +
> > +	error = break_layout(dest, false);
> > +	if (error == -EWOULDBLOCK) {
> > +		inode_unlock(dest);
> > +		if (src_first)
> > +			inode_unlock(src);
> > +		error = break_layout(dest, true);
> > +		if (error)
> > +			return error;
> > +		goto retry;
> > +	} else if (error) {
> > +		inode_unlock(dest);
> > +		if (src_first)
> > +			inode_unlock(src);
> > +		return error;
> > +	}
> > +	if (src_last)
> > +		inode_lock_nested(src, I_MUTEX_NONDIR2);
> > +	return 0;
> > +}
> > +
> 
> I'm not really familiar with the lease code so it's not clear to me, for
> example, why the loop is necessary here and whatnot.

Christoph objected to the original version of this patch grabbing
IOLOCK_EXCL (or any lock) and then spinning on a break-unlock-break-lock
loop trying to break the leases on dest.  I didn't see anything obvious
that could stall in break_layout for a long time, but the fact that it
has a 'wait' parameter strongly implies that something in that path
could sleep.

> But it seems the above could be factored into a slightly more generic
> helper patterned after xfs_break_layouts(). For example, create an
> xfs_break_two_nondir_layouts() in xfs_pnfs.c with the exact same
> semantics/structure as the former, just replace the iolock calls with
> the lock/unlock_two_nondir() calls..?

The awkward part of this patch is that we really only need a function
like this to do things like reflink (read from one file, write to
another) so that's why it's in xfs_reflink.c... but I'll move on to the
next patch for more of a reply. :)

--D

> Brian
> 
> > +/*
> >   * Link a range of blocks from one file to another.
> >   */
> >  int
> > @@ -1274,7 +1316,9 @@ xfs_reflink_remap_range(
> >  		return -EIO;
> >  
> >  	/* Lock both files against IO */
> > -	lock_two_nondirectories(inode_in, inode_out);
> > +	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
> > +	if (ret)
> > +		return ret;
> >  	if (same_inode)
> >  		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> >  	else
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
