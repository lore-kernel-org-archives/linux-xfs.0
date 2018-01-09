Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753701AbeAIVmy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 16:42:54 -0500
Date: Tue, 9 Jan 2018 16:42:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't leak perag metadata reservation on finobt
 block free
Message-ID: <20180109214242.GA14500@bfoster.bfoster>
References: <20180109183558.13344-1-bfoster@redhat.com>
 <20180109201619.GG5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109201619.GG5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 12:16:19PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 09, 2018 at 01:35:58PM -0500, Brian Foster wrote:
> > We started using the perag metadata reservation for free inode btree
> > blocks in commit 76d771b4cbe33 ("xfs: use per-AG reservations for
> > the finobt"). While this change consumes metadata res. for finobt
> > block allocations, we still don't replenish the res. pool when
> > finobt blocks are freed. This leads to leaking reservation as finobt
> > blocks are allocated and freed over time, which in turn can lead to
> > overruse of blocks that should be protected by the reservation.
> > 
> > Update the finobt free block path to specify the metadata
> > reservation type as done in the allocation path.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc_btree.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 47f44d624cb1..18fe6b3a7802 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -146,16 +146,33 @@ xfs_finobt_alloc_block(
> >  }
> >  
> >  STATIC int
> > -xfs_inobt_free_block(
> > +__xfs_inobt_free_block(
> >  	struct xfs_btree_cur	*cur,
> > -	struct xfs_buf		*bp)
> > +	struct xfs_buf		*bp,
> > +	enum xfs_ag_resv_type	resv)
> >  {
> >  	struct xfs_owner_info	oinfo;
> >  
> >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> >  	return xfs_free_extent(cur->bc_tp,
> >  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> > -			&oinfo, XFS_AG_RESV_NONE);
> > +			&oinfo, resv);
> > +}
> > +
> > +STATIC int
> > +xfs_inobt_free_block(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_buf		*bp)
> > +{
> > +	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_NONE);
> > +}
> > +
> > +STATIC int
> > +xfs_finobt_free_block(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_buf		*bp)
> > +{
> > +	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
> 
> cur->bc_mp->m_inotbt_nores ? XFS_AG_RESV_NONE : XFS_AG_RESV_METADATA
> 
> Since we don't use the finobt reservation if there wasn't room.
> 

Yep.. will send a v2. Thanks!

Brian

> --D
> 
> >  }
> >  
> >  STATIC int
> > @@ -380,7 +397,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
> >  	.dup_cursor		= xfs_inobt_dup_cursor,
> >  	.set_root		= xfs_finobt_set_root,
> >  	.alloc_block		= xfs_finobt_alloc_block,
> > -	.free_block		= xfs_inobt_free_block,
> > +	.free_block		= xfs_finobt_free_block,
> >  	.get_minrecs		= xfs_inobt_get_minrecs,
> >  	.get_maxrecs		= xfs_inobt_get_maxrecs,
> >  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
