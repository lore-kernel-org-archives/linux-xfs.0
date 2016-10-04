Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753978AbcJDMoJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Oct 2016 08:44:09 -0400
Date: Tue, 4 Oct 2016 08:44:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 25/63] xfs: return work remaining at the end of a bunmapi
 operation
Message-ID: <20161004124406.GC55212@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520490339.29434.11775509253578580319.stgit@birch.djwong.org>
 <20161003190431.GC49915@bfoster.bfoster>
 <20161004003056.GD14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161004003056.GD14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Mon, Oct 03, 2016 at 05:30:56PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 03, 2016 at 03:04:31PM -0400, Brian Foster wrote:
> > On Thu, Sep 29, 2016 at 08:08:23PM -0700, Darrick J. Wong wrote:
> > > Return the range of file blocks that bunmapi didn't free.  This hint
> > > is used by CoW and reflink to figure out what part of an extent
> > > actually got freed so that it can set up the appropriate atomic
> > > remapping of just the freed range.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c |   36 ++++++++++++++++++++++++++++++------
> > >  fs/xfs/libxfs/xfs_bmap.h |    4 ++++
> > >  2 files changed, 34 insertions(+), 6 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index a5e429e..1e4f1a1 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > ...
> > > @@ -5478,6 +5481,27 @@ xfs_bunmapi(
> > >  	return error;
> > >  }
> > >  
> > > +/* Unmap a range of a file. */
> > > +int
> > > +xfs_bunmapi(
> > > +	xfs_trans_t		*tp,
> > > +	struct xfs_inode	*ip,
> > > +	xfs_fileoff_t		bno,
> > > +	xfs_filblks_t		len,
> > > +	int			flags,
> > > +	xfs_extnum_t		nexts,
> > > +	xfs_fsblock_t		*firstblock,
> > > +	struct xfs_defer_ops	*dfops,
> > > +	int			*done)
> > > +{
> > > +	int			error;
> > > +
> > > +	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts, firstblock,
> > > +			dfops);
> > > +	*done = (len == 0);
> > > +	return error;
> > > +}
> > > +
> > 
> > I wonder if we really need such a wrapper for this. There aren't too
> > many xfs_bunmapi() callers and at least a couple of the few that I
> > checked don't even use 'done.' That can always get fixed up later
> > though.
> 
> Perhaps not, but hch said he'll probably end up refactoring the bunmapi code
> soon anyway.
> 

Ok, sounds good.

Brian

> --D
> 
> > 
> > Brian
> > 
> > >  /*
> > >   * Determine whether an extent shift can be accomplished by a merge with the
> > >   * extent that precedes the target hole of the shift.
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > > index 53970b1..48ba3ed 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.h
> > > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > > @@ -197,6 +197,10 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
> > >  		xfs_fsblock_t *firstblock, xfs_extlen_t total,
> > >  		struct xfs_bmbt_irec *mval, int *nmap,
> > >  		struct xfs_defer_ops *dfops);
> > > +int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
> > > +		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
> > > +		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
> > > +		struct xfs_defer_ops *dfops);
> > >  int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
> > >  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
> > >  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
