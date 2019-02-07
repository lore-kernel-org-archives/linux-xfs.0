Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGQTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 11:19:40 -0500
Date: Thu, 7 Feb 2019 08:19:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] xfs: refactor unlinked list search and mapping to a
 separate function
Message-ID: <20190207161933.GB7991@magnolia>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
 <154947211711.22369.10227484386880189461.stgit@magnolia>
 <20190207142815.GA2880@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207142815.GA2880@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 09:28:15AM -0500, Brian Foster wrote:
> On Wed, Feb 06, 2019 at 08:55:17AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a loop that searches an unlinked bucket list to find the inode
> > that points to a given inode.  Hoist this into a separate function;
> > later we'll use our iunlink backref cache to bypass the slow list
> > operation.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |  135 +++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 96 insertions(+), 39 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index eb51fa33f91a..161d8da459aa 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2082,6 +2082,96 @@ xfs_iunlink(
> >  	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
> >  }
> >  
> ...
> > +STATIC int
> > +xfs_iunlink_map_prev(
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agino_t		head_agino,
> > +	xfs_agino_t		target_agino,
> > +	xfs_agino_t		*agino,
> > +	struct xfs_imap		*imap,
> > +	struct xfs_dinode	**dipp,
> > +	struct xfs_buf		**bpp)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_agino_t		next_agino;
> > +	int			error;
> > +
> > +	ASSERT(head_agino != target_agino);
> > +
> > +	next_agino = head_agino;
> > +	while (next_agino != target_agino) {
> > +		xfs_agino_t	unlinked_agino;
> > +
> > +		if (*bpp)
> > +			xfs_trans_brelse(tp, *bpp);
> 
> Just because we have this check here, it might be appropriate to set
> *bpp to NULL at the start of this function. Otherwise looks fine:

It's set to NULL in the caller but I can move it to the top of
_map_prev to make the connection easier to find.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +
> > +		*agino = next_agino;
> > +		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
> > +				bpp);
> > +		if (error)
> > +			return error;
> > +
> > +		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
> > +		/*
> > +		 * Make sure this pointer is valid and isn't an obvious
> > +		 * infinite loop.
> > +		 */
> > +		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
> > +		    next_agino == unlinked_agino) {
> > +			XFS_CORRUPTION_ERROR(__func__,
> > +					XFS_ERRLEVEL_LOW, mp,
> > +					*dipp, sizeof(**dipp));
> > +			error = -EFSCORRUPTED;
> > +			return error;
> > +		}
> > +		next_agino = unlinked_agino;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Pull the on-disk inode from the AGI unlinked list.
> >   */
> > @@ -2093,9 +2183,8 @@ xfs_iunlink_remove(
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_agi		*agi;
> >  	struct xfs_buf		*agibp;
> > -	struct xfs_buf		*last_ibp;
> > +	struct xfs_buf		*last_ibp = NULL;
> >  	struct xfs_dinode	*last_dip = NULL;
> > -	xfs_ino_t		next_ino;
> >  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> >  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  	xfs_agino_t		next_agino;
> > @@ -2138,43 +2227,11 @@ xfs_iunlink_remove(
> >  		struct xfs_imap	imap;
> >  		xfs_agino_t	prev_agino;
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
> > -				return error;
> > -			}
> > -
> > -			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
> > -					       &last_ibp, 0, 0);
> > -			if (error) {
> > -				xfs_warn(mp,
> > -	"%s: xfs_imap_to_bp returned error %d.",
> > -					__func__, error);
> > -				return error;
> > -			}
> > -
> > -			prev_agino = next_agino;
> > -			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
> > -			if (!xfs_verify_agino(mp, agno, next_agino)) {
> > -				XFS_CORRUPTION_ERROR(__func__,
> > -						XFS_ERRLEVEL_LOW, mp,
> > -						last_dip, sizeof(*last_dip));
> > -				return -EFSCORRUPTED;
> > -			}
> > -		}
> > +		/* We need to search the list for the inode being freed. */
> > +		error = xfs_iunlink_map_prev(tp, agno, next_agino, agino,
> > +				&prev_agino, &imap, &last_dip, &last_ibp);
> > +		if (error)
> > +			return error;
> >  
> >  		/*
> >  		 * Now last_ibp points to the buffer previous to us on the
> > 
