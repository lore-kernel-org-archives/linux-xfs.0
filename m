Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbeKUC6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 21:58:02 -0500
Date: Tue, 20 Nov 2018 08:27:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs: const-ify xfs_owner_info arguments
Message-ID: <20181120162758.GA6792@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
 <154171920773.30818.10284610883734405907.stgit@magnolia>
 <20181120161708.GA48509@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120161708.GA48509@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 11:17:08AM -0500, Brian Foster wrote:
> On Thu, Nov 08, 2018 at 03:20:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Only certain functions actually change the contents of an
> > xfs_owner_info; the rest can accept a const struct pointer.  This will
> > enable us to save stack space by hoisting static owner info types to
> > be const global variables.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  |    4 -
> >  fs/xfs/libxfs/xfs_alloc.h  |    4 -
> >  fs/xfs/libxfs/xfs_bmap.c   |    2 
> >  fs/xfs/libxfs/xfs_bmap.h   |    4 -
> >  fs/xfs/libxfs/xfs_rmap.c   |  212 ++++++++++++++++++++++----------------------
> >  fs/xfs/libxfs/xfs_rmap.h   |   12 +-
> >  fs/xfs/scrub/btree.c       |   45 +++++----
> >  fs/xfs/scrub/btree.h       |   22 ++---
> >  fs/xfs/scrub/common.c      |   14 +--
> >  fs/xfs/scrub/common.h      |    2 
> >  fs/xfs/scrub/refcount.c    |   11 +-
> >  fs/xfs/scrub/repair.c      |   50 +++++-----
> >  fs/xfs/scrub/repair.h      |    7 +
> >  fs/xfs/scrub/rmap.c        |   30 +++---
> >  fs/xfs/scrub/scrub.h       |    4 -
> >  fs/xfs/xfs_trace.h         |    4 -
> >  fs/xfs/xfs_trans.h         |    3 -
> >  fs/xfs/xfs_trans_extfree.c |    2 
> >  18 files changed, 218 insertions(+), 214 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index e1c0c0d2f1b0..bce46fa0ee38 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1699,7 +1699,7 @@ xfs_free_ag_extent(
> >  	xfs_agnumber_t		agno,
> >  	xfs_agblock_t		bno,
> >  	xfs_extlen_t		len,
> > -	struct xfs_owner_info	*oinfo,
> > +	const struct xfs_owner_info	*oinfo,
> >  	enum xfs_ag_resv_type	type)
> >  {
> >  	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
> > @@ -3013,7 +3013,7 @@ __xfs_free_extent(
> >  	struct xfs_trans	*tp,	/* transaction pointer */
> >  	xfs_fsblock_t		bno,	/* starting block number of extent */
> >  	xfs_extlen_t		len,	/* length of extent */
> > -	struct xfs_owner_info	*oinfo,	/* extent owner */
> > +	const struct xfs_owner_info	*oinfo,	/* extent owner */
> >  	enum xfs_ag_resv_type	type,	/* block reservation type */
> >  	bool			skip_discard)
> >  {
> 
> Looks like we missed some function arg alignment fixups here.

Oops, yeah, I'll fix those.

> ...
> > diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> > index 157dc722ad35..00e38505037f 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.h
> > +++ b/fs/xfs/libxfs/xfs_rmap.h
> > @@ -52,7 +52,7 @@ xfs_rmap_skip_owner_update(
> >  
> >  static inline bool
> >  xfs_rmap_should_skip_owner_update(
> > -	struct xfs_owner_info	*oi)
> > +	const struct xfs_owner_info	*oi)
> >  {
> >  	return oi->oi_owner == XFS_RMAP_OWN_NULL;
> >  }
> > @@ -103,7 +103,7 @@ xfs_rmap_irec_offset_unpack(
> >  
> >  static inline void
> >  xfs_owner_info_unpack(
> > -	struct xfs_owner_info	*oinfo,
> > +	const struct xfs_owner_info	*oinfo,
> >  	uint64_t		*owner,
> >  	uint64_t		*offset,
> >  	unsigned int		*flags)
> 
> ... and here.
> 
> ...
> > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > index 73b11ed6795e..5210f86a9114 100644
> > --- a/fs/xfs/xfs_trans_extfree.c
> > +++ b/fs/xfs/xfs_trans_extfree.c
> > @@ -57,7 +57,7 @@ xfs_trans_free_extent(
> >  	struct xfs_efd_log_item	*efdp,
> >  	xfs_fsblock_t		start_block,
> >  	xfs_extlen_t		ext_len,
> > -	struct xfs_owner_info	*oinfo,
> > +	const struct xfs_owner_info	*oinfo,
> >  	bool			skip_discard)
> 
> ... and here.

And those.

> With those fixed up:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thank you for the review! :)

--D

> 
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> > 
