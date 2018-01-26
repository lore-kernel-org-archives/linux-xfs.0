Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeAZTNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 14:13:05 -0500
Date: Fri, 26 Jan 2018 11:12:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] xfs: fix up cowextsz allocation shortfalls
Message-ID: <20180126191259.GB9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676031559.12349.8327260913918740589.stgit@magnolia>
 <20180125173111.GA44175@bfoster.bfoster>
 <20180125202033.GN9068@magnolia>
 <20180126130625.GC47923@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126130625.GC47923@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 08:06:25AM -0500, Brian Foster wrote:
> On Thu, Jan 25, 2018 at 12:20:33PM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 25, 2018 at 12:31:12PM -0500, Brian Foster wrote:
> > > On Tue, Jan 23, 2018 at 06:18:35PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > In xfs_bmap_btalloc, we try using the CoW extent size hint to force
> > > > allocations to align (offset-wise) to cowextsz granularity to reduce CoW
> > > > fragmentation.  This works fine until we cannot satisfy the allocation
> > > > with enough blocks to cover the requested range and the alignment hints.
> > > > If this happens, return an unaligned region because if we don't the
> > > > extent trim functions cause us to return a zero-length extent to iomap,
> > > > which iomap doesn't catch and thus blows up.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Hmm.. is this a direct I/O thing? The description of the problem had me
> > 
> > Yes.
> > 
> > > wondering how we handle this with regard to dio and traditional extent
> > > size hints. It looks like we just return -ENOSPC if xfs_bmapi_write()
> > > doesn't return a mapping that covers the target range of the write (even
> > > if it apparently attempts to allocate part of the associated extent size
> > > hint range). E.g., see the nimaps == 0 check in
> > > xfs_iomap_write_direct() after we commit the transaction.
> > 
> > I did take a look at that, and didn't like it.
> > 
> > There's enough free space to fill the dio write, but the free space
> > itself is very fragmented so we can't honor the hint.  We did however
> > manage to allocate /some/ blocks, so we might as well return what we got
> > and let the next iteration of the iomap_apply loop try to fill the rest
> > of the write request.  We already reserved enough space, so the write
> > should succeed totally, not return to userspace with either a short
> > write or ENOSPC just because free space is fragmented.
> > 
> 
> I'm not following how a short write can necessarily be prevented, since
> space reservation doesn't guarantee contiguity and afaict we only make a
> single mapping call. I suppose the iomap level can loop, but that's
> outside of the context where blocks are reserved. Hm?
> 
> But regardless, this behavior seems reasonable to me if we apply it
> consistently between cow fork hint behavior and traditional extent size
> hint behavior. They are both hints, after all. I do think an nimaps
> check might still be appropriate in that reflink code path simply to
> cover the case of unexpected behavior or a bug, rather than brace for
> whatever is going to happen if we continue to shuffle a bogus imap
> around.

Yes, the new version makes the behavior consistent for both hints, and
adds the "got no blocks, so sad" check to _reflink_allocate_cow.

--D

> Brian
> 
> > (The other problem is that if we return ENOSPC out of iomap_begin, that
> > error code will bubble all the way back to userspace even if we /did/
> > write something, which means that even the programs that handle short
> > dio writes correctly will see that ENOSPC and bail out.  Goldwyn has
> > been trying to fix that braindamage for some time now.)
> > 
> > > In fact, it looks like just repeating the failed write could eventually
> > > succeed if the issue is that there is actually enough free space
> > > available to allocate the hint range up to where the write is targeted,
> > > just no long enough extent available to fill the extent size hint range
> > > in a single bmapi_write call. That behavior is a bit strange, I admit,
> > > but I'm wondering if we could do the same thing for the cow hint. Would
> > > a similar nimaps check in the xfs_bmapi_write() caller resolve the bug
> > > described here?
> > > 
> > > If so and if we still care to actually change/fix the allocation
> > > behavior with regard to the hints, perhaps we could do that in a
> > > separate patch more generically for both hints..?
> > 
> > I get the feeling we could apply this change to all the data fork
> > bmap_btalloc calls too.  I'll go study that in more depth.
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > >  fs/iomap.c               |    2 +-
> > > >  fs/xfs/libxfs/xfs_bmap.c |   21 +++++++++++++++++++--
> > > >  2 files changed, 20 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/iomap.c b/fs/iomap.c
> > > > index e5de772..aec35a0 100644
> > > > --- a/fs/iomap.c
> > > > +++ b/fs/iomap.c
> > > > @@ -63,7 +63,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> > > >  	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
> > > >  	if (ret)
> > > >  		return ret;
> > > > -	if (WARN_ON(iomap.offset > pos))
> > > > +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
> > > >  		return -EIO;
> > > >  
> > > >  	/*
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 93ce2c6..4ec1fdc5 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -3480,8 +3480,20 @@ xfs_bmap_btalloc_filestreams(
> > > >  static void
> > > >  xfs_bmap_btalloc_cow(
> > > >  	struct xfs_bmalloca	*ap,
> > > > -	struct xfs_alloc_arg	*args)
> > > > +	struct xfs_alloc_arg	*args,
> > > > +	xfs_fileoff_t		orig_offset,
> > > > +	xfs_extlen_t		orig_length)
> > > >  {
> > > > +	/*
> > > > +	 * If we didn't get enough blocks to satisfy the cowextsize
> > > > +	 * aligned request, break the alignment and return whatever we
> > > > +	 * got; it's the best we can do.
> > > > +	 */
> > > > +	if (ap->length <= orig_length)
> > > > +		ap->offset = orig_offset;
> > > > +	else if (ap->offset + ap->length < orig_offset + orig_length)
> > > > +		ap->offset = orig_offset + orig_length - ap->length;
> > > > +
> > > >  	/* Filling a previously reserved extent; nothing to do here. */
> > > >  	if (ap->wasdel)
> > > >  		return;
> > > > @@ -3520,6 +3532,8 @@ xfs_bmap_btalloc(
> > > >  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> > > >  	xfs_agnumber_t	ag;
> > > >  	xfs_alloc_arg_t	args;
> > > > +	xfs_fileoff_t	orig_offset;
> > > > +	xfs_extlen_t	orig_length;
> > > >  	xfs_extlen_t	blen;
> > > >  	xfs_extlen_t	nextminlen = 0;
> > > >  	int		nullfb;		/* true if ap->firstblock isn't set */
> > > > @@ -3529,6 +3543,8 @@ xfs_bmap_btalloc(
> > > >  	int		stripe_align;
> > > >  
> > > >  	ASSERT(ap->length);
> > > > +	orig_offset = ap->offset;
> > > > +	orig_length = ap->length;
> > > >  
> > > >  	mp = ap->ip->i_mount;
> > > >  
> > > > @@ -3745,7 +3761,8 @@ xfs_bmap_btalloc(
> > > >  		ASSERT(nullfb || fb_agno <= args.agno);
> > > >  		ap->length = args.len;
> > > >  		if (ap->flags & XFS_BMAPI_COWFORK) {
> > > > -			xfs_bmap_btalloc_cow(ap, &args);
> > > > +			xfs_bmap_btalloc_cow(ap, &args, orig_offset,
> > > > +					orig_length);
> > > >  		} else {
> > > >  			ap->ip->i_d.di_nblocks += args.len;
> > > >  			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
