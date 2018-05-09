Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933847AbeEIK64 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 06:58:56 -0400
Date: Wed, 9 May 2018 06:58:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180509105853.GD64624@bfoster.bfoster>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
 <20180509074629.GC19933@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509074629.GC19933@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, May 09, 2018 at 12:46:29AM -0700, Christoph Hellwig wrote:
> On Tue, May 08, 2018 at 01:22:29PM -0400, Brian Foster wrote:
> > Freed extents are unconditionally discarded when online discard is
> > enabled. Define XFS_BMAPI_NODISCARD to allow callers to bypass
> > discards when unnecessary. For example, this will be useful for
> > eofblocks trimming.
> > 
> > This patch does not change behavior.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  | 10 +++++++---
> >  fs/xfs/libxfs/xfs_alloc.h  | 27 +++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_bmap.c   | 17 +++++++++++++----
> >  fs/xfs/libxfs/xfs_bmap.h   | 30 ++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_extfree_item.c  |  2 +-
> >  fs/xfs/xfs_trans.h         |  3 ++-
> >  fs/xfs/xfs_trans_extfree.c | 13 +++++++++----
> >  7 files changed, 85 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 4bcc095fe44a..06e4b0c47c01 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2949,18 +2949,20 @@ xfs_free_extent_fix_freelist(
> >   * after fixing up the freelist.
> >   */
> >  int				/* error */
> > -xfs_free_extent(
> > +__xfs_free_extent(
> >  	struct xfs_trans	*tp,	/* transaction pointer */
> >  	xfs_fsblock_t		bno,	/* starting block number of extent */
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	struct xfs_owner_info	*oinfo,	/* extent owner */
> > -	enum xfs_ag_resv_type	type)	/* block reservation type */
> > +	enum xfs_ag_resv_type	type,	/* block reservation type */
> > +	bool			skip_discard)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_buf		*agbp;
> >  	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
> >  	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
> >  	int			error;
> > +	unsigned int		busy_flags = 0;
> >  
> >  	ASSERT(len != 0);
> >  	ASSERT(type != XFS_AG_RESV_AGFL);
> > @@ -2984,7 +2986,9 @@ xfs_free_extent(
> >  	if (error)
> >  		goto err;
> >  
> > -	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
> > +	if (skip_discard)
> > +		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
> 
> Please just add an busy_flags argument to xfs_free_extent, and pass 0 in
> the oter callers.  That removes a lot of the boilerplate code.  Then just
> add an assert to xfs_free_extent that no flag other than
> XFS_EXTENT_BUSY_SKIP_DISCARD is passed for now.
> 

I deliberately went away from that approach based on Dave's feedback
(similarly with the xfs_itruncate_extents() comment in the subsequent
patch). I used the bool that is used here rather than pass the flag
directly, but it's essentially the same idea in terms of exposing the
function signature change to callers.

TBH, I don't much care which of the N possible variants of code
factoring we use here, but I think we're officially bikeshedding once
the feedback starts to go in circles as such. ;) So unless I see some
broader/mutual agreement (or a strong preference from the maintainer) on
a change back to something like the original factoring (perhaps using a
flag instead of a bool), I'm going to assume changing it back will
simply reintroduce the previous feedback and leave this as is.

Brian

> >  void
> > -xfs_bmap_add_free(
> > +__xfs_bmap_add_free(
> >  	struct xfs_mount		*mp,
> >  	struct xfs_defer_ops		*dfops,
> >  	xfs_fsblock_t			bno,
> >  	xfs_filblks_t			len,
> > -	struct xfs_owner_info		*oinfo)
> > +	struct xfs_owner_info		*oinfo,
> > +	bool				skip_discard)
> >  {
> >  	struct xfs_extent_free_item	*new;		/* new element */
> >  #ifdef DEBUG
> > @@ -574,6 +575,7 @@ xfs_bmap_add_free(
> >  		new->xefi_oinfo = *oinfo;
> >  	else
> >  		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
> > +	new->xefi_skip_discard = skip_discard;
> 
> Similarly here, I think we should just pass through the bmapi
> flags.  But given the number of callers I think just adding
> a xfs_bmap_add_free_flags as the low-level interface with a higher
> level xfs_bmap_add_free wrapper for all other callers is fine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
