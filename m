Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752390AbeEHMgH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 08:36:07 -0400
Date: Tue, 8 May 2018 08:36:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: don't discard on free of unwritten extents
Message-ID: <20180508123606.GD4764@bfoster.bfoster>
References: <20180507181138.43250-1-bfoster@redhat.com>
 <20180507181138.43250-4-bfoster@redhat.com>
 <20180507233512.GI23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507233512.GI23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 09:35:12AM +1000, Dave Chinner wrote:
> On Mon, May 07, 2018 at 02:11:37PM -0400, Brian Foster wrote:
> > Unwritten extents by definition have not been written to until they
> > are converted to normal written extents. If unwritten extents are
> > freed from a file, it is therefore guaranteed that the blocks have
> > not been written to since allocation (note that zero range punches
> > and reallocates blocks).
> > 
> > To cut down on online discards generated from workloads that make
> > use of preallocation, skip discards of extents if they are in the
> > unwritten state when the extent is freed.
> > 
> > Note that this optimization does not apply to log recovery, during
> > which all freed extents are discarded if online discard is enabled.
> > Also note that it may be possible for a filesystem crash to occur
> > after write completion of an unwritten extent but before unwritten
> > conversion such that the extent remains unwritten after log
> > recovery. Since this pseudo-inconsistency may already be possible
> > after a crash (consider writing to recently allocated blocks where
> > the allocation transaction is lost after a crash), this change
> > shouldn't introduce any fundamental limitations that don't already
> > exist. In short, on storage stacks where discards are important,
> > it's good practice to run an occasional fstrim even with online
> > discard enabled in the filesystem, particularly after a crash.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index b171f4185adb..a50c197d426f 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5107,7 +5107,8 @@ xfs_bmap_del_extent_real(
> >  			if (error)
> >  				goto done;
> >  		} else {
> > -			if (bflags & XFS_BMAPI_NODISCARD)
> > +			if (bflags & XFS_BMAPI_NODISCARD ||
> > +			    del->br_state == XFS_EXT_UNWRITTEN)
> 
> Doesn't gcc warn about parenthesis challenged logic like this by
> default these days?
> 
> I also find code with multi-line function calls easier to follow if
> there are {} aroudn them like so:
> 

Ok, thanks..

Brian

> 			if ((bflags & XFS_BMAPI_NODISCARD) ||
> 			    del->br_state == XFS_EXT_UNWRITTEN) {
> >  				xfs_bmap_add_free_nodiscard(mp, dfops,
> >  					del->br_startblock, del->br_blockcount,
> >  					NULL);
> 			}
> 
> 
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
