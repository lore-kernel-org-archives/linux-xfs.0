Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfBBUqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 15:46:09 -0500
Date: Sat, 2 Feb 2019 12:46:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: hoist unlinked list search and mapping to a
 separate function
Message-ID: <20190202204600.GU5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897670777.26065.9017810401812180528.stgit@magnolia>
 <20190201190137.GE31203@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201190137.GE31203@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 02:01:38PM -0500, Brian Foster wrote:
> On Thu, Jan 31, 2019 at 03:18:27PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a loop that searches an unlinked bucket list to find the inode
> > that points to a given inode.  Hoist this into a separate function;
> > later we'll use our iunlink backref cache to bypass the slow list
> > operation.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |  136 ++++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 99 insertions(+), 37 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index ea38b66fbc59..d5b3f8fdac7e 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2084,6 +2084,100 @@ xfs_iunlink(
> >  	return error;
> >  }
> >  
> > +/* Return the imap, dinode pointer, and buffer for an inode. */
> > +STATIC int
> > +xfs_iunlink_map_ino(
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		next_ino,
> 
> Might be good to clean up some of these variable names as this code gets
> factored out. E.g., "next_ino" doesn't mean much more than "ino" in the
> context of this helper.

Ok.

> > +	struct xfs_imap		*imap,
> > +	struct xfs_dinode	**dipp,
> > +	struct xfs_buf		**bpp)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	int			error;
> > +
> > +	imap->im_blkno = 0;
> > +	error = xfs_imap(mp, tp, next_ino, imap, 0);
> > +	if (error) {
> > +		xfs_warn(mp, "%s: xfs_imap returned error %d.",
> > +				__func__, error);
> > +		return error;
> > +	}
> > +
> > +	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
> > +	if (error) {
> > +		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> > +				__func__, error);
> > +		return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Walk the unlinked chain from @head_agino until we find the inode that
> > + * points to @target_ino.  Return the inode number, map, dinode pointer,
> > + * and inode cluster buffer of that inode as @ino, @imap, @dipp, and @bpp.
> > + *
> > + * Do not call this function if @target_agino is the head of the list.
> > + */
> > +STATIC int
> > +xfs_iunlink_map_prev(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_perag	*pag,
> > +	xfs_agino_t		head_agino,
> > +	xfs_agino_t		target_agino,
> > +	xfs_ino_t		*ino,
> > +	struct xfs_imap		*imap,
> > +	struct xfs_dinode	**dipp,
> > +	struct xfs_buf		**bpp)
> > +{
> 
> It would also be nice to have some oneline comments next to the params
> of some of these functions.

In addition to the description given above the function?

> > +	struct xfs_imap		last_imap;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_buf		*last_ibp = NULL;
> > +	struct xfs_dinode	*last_dip;
> > +	xfs_ino_t		next_ino = NULLFSINO;
> > +	xfs_agino_t		next_agino;
> > +	int			error;
> > +
> > +	ASSERT(head_agino != target_agino);
> > +
> > +	next_agino = head_agino;
> > +	while (next_agino != target_agino) {
> > +		xfs_agino_t	unlinked_agino;
> > +
> > +		if (last_ibp)
> > +			xfs_trans_brelse(tp, last_ibp);
> > +
> > +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> > +		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
> > +				&last_dip, &last_ibp);
> > +		if (error)
> > +			return error;
> > +
> > +		unlinked_agino = be32_to_cpu(last_dip->di_next_unlinked);
> > +		if (!xfs_verify_agino(mp, pag->pag_agno, next_agino) ||
> 
> Should the next_agino above be unlinked_agino? Also is the == check
> below a loop check (comment pls)?

Yes, fixed.

/*
 * Make sure this pointer is valid and isn't an obvious
 * infinite loop.
 */


> > +		    next_agino == unlinked_agino) {
> > +			XFS_CORRUPTION_ERROR(__func__,
> > +					XFS_ERRLEVEL_LOW, mp,
> > +					last_dip, sizeof(*last_dip));
> > +			error = -EFSCORRUPTED;
> > +			return error;
> > +		}
> > +		next_agino = unlinked_agino;
> > +	}
> > +
> > +	/* Should never happen, but don't return garbage. */
> > +	if (next_ino == NULLFSINO)
> > +		return -EFSCORRUPTED;
> > +
> > +	*ino = next_ino;
> > +	memcpy(imap, &last_imap, sizeof(last_imap));
> > +	*dipp = last_dip;
> > +	*bpp = last_ibp;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Pull the on-disk inode from the AGI unlinked list.
> >   */
> > @@ -2153,43 +2247,11 @@ xfs_iunlink_remove(
> >  	} else {
> >  		struct xfs_imap	imap;
> >  
> > -		/*
> > -		 * We need to search the list for the inode being freed.
> > -		 */
> > -		last_ibp = NULL;
> > -		while (next_agino != agino) {
> > -			if (last_ibp)
> > -				xfs_trans_brelse(tp, last_ibp);
> > -
> > -			imap.im_blkno = 0;
> > -			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
> > -
> > -			error = xfs_imap(mp, tp, next_ino, &imap, 0);
> > -			if (error) {
> > -				xfs_warn(mp,
> > -	"%s: xfs_imap returned error %d.",
> > -					 __func__, error);
> > -				goto out_unlock;
> > -			}
> > -
> > -			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
> > -					       &last_ibp, 0, 0);
> > -			if (error) {
> > -				xfs_warn(mp,
> > -	"%s: xfs_imap_to_bp returned error %d.",
> > -					__func__, error);
> > -				goto out_unlock;
> > -			}
> > -
> > -			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
> > -			if (!xfs_verify_agino(mp, agno, next_agino)) {
> > -				XFS_CORRUPTION_ERROR(__func__,
> > -						XFS_ERRLEVEL_LOW, mp,
> > -						last_dip, sizeof(*last_dip));
> > -				error = -EFSCORRUPTED;
> > -				goto out_unlock;
> > -			}
> > -		}
> > +		/* We need to search the list for the inode being freed. */
> > +		error = xfs_iunlink_map_prev(tp, pag, next_agino, agino,
> > +				&next_ino, &imap, &last_dip, &last_ibp);
> 
> Another variable nit... next_ino is kind of confusing here, particularly
> where we still use next_agino as well. The former is actually the "prev"
> ino output, right?

Yep, will fix.

--D

> Brian
> 
> > +		if (error)
> > +			goto out_unlock;
> >  
> >  		/*
> >  		 * Now last_ibp points to the buffer previous to us on the
> > 
