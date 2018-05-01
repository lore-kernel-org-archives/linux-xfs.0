Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755132AbeEARiR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 13:38:17 -0400
Date: Tue, 1 May 2018 13:38:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: skip discard of unwritten extents
Message-ID: <20180501173815.GJ4525@bfoster.bfoster>
References: <20180426180624.6134-1-bfoster@redhat.com>
 <20180430220020.GE13766@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180430220020.GE13766@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 01, 2018 at 08:00:20AM +1000, Dave Chinner wrote:
> On Thu, Apr 26, 2018 at 02:06:24PM -0400, Brian Foster wrote:
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > What do folks think of something like this?
> 
> Definitely sounds like something we need to address.
> 
> > The motivation here is that
> > the VDO (dedup) devs had reported seeing online discards during
> > write-only workloads. These turn out to be related to trimming post-eof
> > preallocation blocks after large file copies. To my knowledge, this
> > isn't really a prevalent or serious issue, but I think that technically
> > these discards are unnecessary and so I was looking into how we could
> > avoid them.
> 
> We simply trucate post-eof extents, right? So we know in
> xfs_itruncate_extents() if the inode size is changing, not to
> mention we know if the extent is beyond EOF? e.g. all calls to
> xfs_itruncate_extents() other than xfs_free_eofblocks() change the
> inode size and so directly indicate they are removing written
> blocks. Anything where the inode size is not changing is doing a
> post-eof removal, and so we can assume no data has been written?
> 

Yes, xfs_free_eofblocks() is the only caller explicitly responsible for
trimming post-eof extents.

> So rather than converting everything to unwritten extents, the "skip
> discard flag" is simply triggered via extents being freed sitting
> beyond the current EOF (not the new EOF) and/or being unwritten?
> 

That was pretty much my initial thought, but note that the extent free
is ultimately deferred down in xfs_free_eofblocks() ->
xfs_itruncate_extents() -> xfs_bunmapi() -> xfs_bmap_del_extent_real()
-> xfs_bmap_add_free(). We can communicate this down to that point with
an itruncate_extents() parameter and XFS_BMAPI_NODISCARD flag or some
such, it just seemed a bit kludgy to pass that down through those layers
when the unwritten state is known in the bunmapi code (but I'll take
that approach if preferred).

> > This behavior is of course not directly related to unwritten extents,
> > but the immediate/obvious solution to bubble up a bmapi flag of some
> > kind to xfs_free_eofblocks() seemed rather crude. From there, I figured
> > that we technically don't need to discard any unwritten extents (within
> > or beyond EOF) because they haven't been written to since being
> > allocated. In fact, I'm not sure we have to even busy them, but it's
> > roughly equivalent logic either way and I'm trying to avoid getting too
> > clever.
> 
> I think we still need to busy them to avoid re-allocating them in
> the same checkpoint, as data extent free/realloc in the same
> checkpoint could result in a failed recovery (i.e. partial
> checkpoint replay) leaving the extent linked into two separate
> files.
> 

Ah, Ok.. I was only thinking about metadata/data reuse. Hm, isn't the
filesystem essentially corrupted on a failed/partial recovery anyways?
(Not that this matters much in this context, I wasn't planning to bypass
the busy sequence...).

> > I also recall that we've discussed using unwritten extents for delalloc
> > -> real conversion to avoid the small stale data exposure window that
> > exists in writeback. Without getting too deep into the reason we don't
> > currently do an initial unwritten allocation [1], I don't think there's
> > anything blocking us from converting any post-eof blocks that happen to
> > be part of the resulting normal allocation. As it is, the imap is
> > already trimmed to EOF by the writeback code for coherency reasons. If
> > we were to convert post-eof blocks (not part of this patch) along with
> > something like this patch, then we'd indirectly prevent discards for
> > eofblocks trims.
> 
> I think we should leave that as a separate problem, as writeback
> currently has issues with the way we manage bufferhead state.
> i.e. things don't work right if we put unwritten extents under
> delalloc buffers and vice versa. [ I have patches to address that
> I'm working on.] And there's also the issue that we need to change
> the delalloc reservations to take into account block allocations
> required by unwritten extent conversion needed by delalloc.
> 

Right.. I wasn't planning to try and solve the whole buffer head state
mismatch thing as a dependency to not discard eofblocks. I was only
going to convert blocks that happened to be post-eof after the
xfs_iomap_write_allocate() allocation because those blocks by definition
don't have buffers. So it's essentially just another xfs_bmapi_write()
call from xfs_iomap_write_allocate() to convert eofblocks if the just
allocated mapping crosses eof.

> Hence I think we should address that as a separate problem, not as
> the solution to avoiding discard of post-eof extents.
> 

Fair enough, I'll look into tacking on a separate patch to also skip
discards for unwritten extents (irrespective of eof).

> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 4bcc095fe44a..942c90ec6747 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2954,13 +2954,15 @@ xfs_free_extent(
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
> > +	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
> >  	return 0;
> 
> Rather than changing xfs_free_extent(), how about adding a
> xfs_free_extent_nodiscard() wrapper, and only call it when
> processing an extent that doesn't need discard? This means none of
> the other code that frees extents needs to be changed. Similarly
> add a xfs_bmap_add_free_nodiscard() wrapper. That will cut down on
> the code churn caused by passing new parameters everywhere....
> 

Ok, I can clean that up. Thanks for the feedback.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
