Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfBBTPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 14:15:41 -0500
Date: Sat, 2 Feb 2019 11:15:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: clean up iunlink functions
Message-ID: <20190202191524.GO5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897667679.26065.17995098675615600714.stgit@magnolia>
 <20190201080136.GC22295@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201080136.GC22295@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 12:01:36AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 31, 2019 at 03:17:56PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix some indentation issues with the iunlink functions and reorganize
> > the tops of the functions to be identical.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   77 +++++++++++++++++++++++++++-------------------------
> >  1 file changed, 40 insertions(+), 37 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c8bf02be0003..d18354517320 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1892,26 +1892,32 @@ xfs_inactive(
> >   */
> >  STATIC int
> >  xfs_iunlink(
> > -	struct xfs_trans *tp,
> > -	struct xfs_inode *ip)
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip)
> >  {
> > -	xfs_mount_t	*mp = tp->t_mountp;
> > -	xfs_agi_t	*agi;
> > -	xfs_dinode_t	*dip;
> > -	xfs_buf_t	*agibp;
> > -	xfs_buf_t	*ibp;
> > -	xfs_agino_t	agino;
> > -	short		bucket_index;
> > -	int		offset;
> > -	int		error;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_dinode	*dip;
> > +	struct xfs_buf		*agibp;
> > +	struct xfs_buf		*ibp;
> > +	xfs_agnumber_t		agno;
> > +	xfs_agino_t		agino;
> > +	short			bucket_index;
> > +	int			offset;
> > +	int			error;
> >  
> >  	ASSERT(VFS_I(ip)->i_mode != 0);
> > +	ASSERT(xfs_verify_ino(mp, ip->i_ino));
> 
> This verify_ino calls seems odd given that we pass in an initialized
> inode struct..
> 
> > +
> > +	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> 
> And then we could move these initializations up int othe lines with
> the variable declarations.
> 
> > +	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> >  
> >  	/*
> >  	 * Get the agi buffer first.  It ensures lock ordering
> >  	 * on the list.
> >  	 */
> 
> If you are touching this anyway, the whole comment could be changed
> into a single line..
> 
> > +	if (!xfs_verify_ino(mp, ip->i_ino))
> > +		return -EFSCORRUPTED;
> >  
> > -	mp = tp->t_mountp;
> >  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> 
> Same here.

Fixed all of these.

--D
