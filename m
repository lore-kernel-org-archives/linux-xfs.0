Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46854 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753228AbeAJT1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 14:27:21 -0500
Date: Wed, 10 Jan 2018 11:17:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't leak perag metadata reservation on finobt
 block free
Message-ID: <20180110191704.GS5602@magnolia>
References: <20180109183558.13344-1-bfoster@redhat.com>
 <20180109201619.GG5602@magnolia>
 <20180109214242.GA14500@bfoster.bfoster>
 <20180110120616.GA17232@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180110120616.GA17232@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 10, 2018 at 07:06:16AM -0500, Brian Foster wrote:
> On Tue, Jan 09, 2018 at 04:42:42PM -0500, Brian Foster wrote:
> > On Tue, Jan 09, 2018 at 12:16:19PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 09, 2018 at 01:35:58PM -0500, Brian Foster wrote:
> > > > We started using the perag metadata reservation for free inode btree
> > > > blocks in commit 76d771b4cbe33 ("xfs: use per-AG reservations for
> > > > the finobt"). While this change consumes metadata res. for finobt
> > > > block allocations, we still don't replenish the res. pool when
> > > > finobt blocks are freed. This leads to leaking reservation as finobt
> > > > blocks are allocated and freed over time, which in turn can lead to
> > > > overruse of blocks that should be protected by the reservation.
> > > > 
> > > > Update the finobt free block path to specify the metadata
> > > > reservation type as done in the allocation path.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.c | 25 +++++++++++++++++++++----
> > > >  1 file changed, 21 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > > index 47f44d624cb1..18fe6b3a7802 100644
> > > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > > @@ -146,16 +146,33 @@ xfs_finobt_alloc_block(
> > > >  }
> > > >  
> > > >  STATIC int
> > > > -xfs_inobt_free_block(
> > > > +__xfs_inobt_free_block(
> > > >  	struct xfs_btree_cur	*cur,
> > > > -	struct xfs_buf		*bp)
> > > > +	struct xfs_buf		*bp,
> > > > +	enum xfs_ag_resv_type	resv)
> > > >  {
> > > >  	struct xfs_owner_info	oinfo;
> > > >  
> > > >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> > > >  	return xfs_free_extent(cur->bc_tp,
> > > >  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> > > > -			&oinfo, XFS_AG_RESV_NONE);
> > > > +			&oinfo, resv);
> > > > +}
> > > > +
> > > > +STATIC int
> > > > +xfs_inobt_free_block(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_NONE);
> > > > +}
> > > > +
> > > > +STATIC int
> > > > +xfs_finobt_free_block(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
> > > 
> > > cur->bc_mp->m_inotbt_nores ? XFS_AG_RESV_NONE : XFS_AG_RESV_METADATA
> > > 
> > > Since we don't use the finobt reservation if there wasn't room.
> > > 
> > 
> > Yep.. will send a v2. Thanks!
> > 
> 
> Wait, I don't think that is right.. ->m_inotbt_nores is set at perag
> init time based on whether the reservation is fulfilled or not. If not,
> the xfs_ag_resv fields are initialized to zero to indicate there is no
> reservation.

ARGH... finobt allocations always pass RESV_METADATA, even if
!m_inotbt_nores, which means that we always draw from that perag
reservation, even if we didn't actually make one for the finobt, but
someone else did!

This can happen on a reflink+finobt filesystem where there's enough
space to grant the refcountbt's reservation request but not enough to
grant the finobt's request (i.e. the !m_inotbt_nores case).  So the
alloc case is broken too.

> From there, the xfs_ag_resv_[alloc|free]_extent() functions
> effectively no-op the accounting for such block allocations. Since there
> is no reservation in this case, xfs_inactive_ifree() reverts to the
> older behavior of reserving a block in the transaction (which starts to
> smell like this is a bit of a hack to avoid tx res failures in this
> particular context, since the inode allocation side of things still
> always reserves blocks for finobt operations despite the reservation
> :/).

Yeah.  Smelly.  Sorry about this whole mess. :/

> So anyways, shouldn't ->alloc_block()/->free_block() be consistent in
> unconditionally tagging the allocation as RESV_METADATA? Am I missing
> something?
> 
> Brian
> 
> > Brian
> > 
> > > --D
> > > 
> > > >  }
> > > >  
> > > >  STATIC int
> > > > @@ -380,7 +397,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
> > > >  	.dup_cursor		= xfs_inobt_dup_cursor,
> > > >  	.set_root		= xfs_finobt_set_root,
> > > >  	.alloc_block		= xfs_finobt_alloc_block,
> > > > -	.free_block		= xfs_inobt_free_block,
> > > > +	.free_block		= xfs_finobt_free_block,
> > > >  	.get_minrecs		= xfs_inobt_get_minrecs,
> > > >  	.get_maxrecs		= xfs_inobt_get_maxrecs,
> > > >  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> > > > -- 
> > > > 2.13.6
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
