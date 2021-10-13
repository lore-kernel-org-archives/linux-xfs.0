Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5B6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 21:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA12F61154
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 21:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhJMVQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:16:39 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:53956 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJMVQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 17:16:38 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 2830910698E3;
        Thu, 14 Oct 2021 08:14:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mala3-005uBm-OA; Thu, 14 Oct 2021 08:14:31 +1100
Date:   Thu, 14 Oct 2021 08:14:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: support dynamic btree cursor heights
Message-ID: <20211013211431.GK2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408158126.4151249.1899753599807152513.stgit@magnolia>
 <20211013053122.GX2361455@dread.disaster.area>
 <20211013165218.GV24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013165218.GV24307@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61674c39
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=t6GgW1ErH5tUXTEaQsgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 09:52:18AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 13, 2021 at 04:31:22PM +1100, Dave Chinner wrote:
> > On Tue, Oct 12, 2021 at 04:33:01PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Split out the btree level information into a separate struct and put it
> > > at the end of the cursor structure as a VLA.  The realtime rmap btree
> > > (which is rooted in an inode) will require the ability to support many
> > > more levels than a per-AG btree cursor, which means that we're going to
> > > create two btree cursor caches to conserve memory for the more common
> > > case.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c |    6 +-
> > >  fs/xfs/libxfs/xfs_bmap.c  |   10 +--
> > >  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++----------------------
> > >  fs/xfs/libxfs/xfs_btree.h |   28 ++++++--
> > >  fs/xfs/scrub/bitmap.c     |   22 +++---
> > >  fs/xfs/scrub/bmap.c       |    2 -
> > >  fs/xfs/scrub/btree.c      |   47 +++++++------
> > >  fs/xfs/scrub/trace.c      |    7 +-
> > >  fs/xfs/scrub/trace.h      |   10 +--
> > >  fs/xfs/xfs_super.c        |    2 -
> > >  fs/xfs/xfs_trace.h        |    2 -
> > >  11 files changed, 164 insertions(+), 140 deletions(-)
> > 
> > Hmmm - subject of the patch doesn't really match the changes being
> > made - there's nothing here that makes the btree cursor heights
> > dynamic. It's just a structure layout change...
> 
> "xfs: prepare xfs_btree_cur for dynamic cursor heights" ?

*nod*

> > > @@ -922,11 +922,11 @@ xfs_btree_readahead(
> > >  	    (lev == cur->bc_nlevels - 1))
> > >  		return 0;
> > >  
> > > -	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
> > > +	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
> > >  		return 0;
> > 
> > That's whacky logic. Surely that's just:
> > 
> > 	if (cur->bc_levels[lev].ra & lr)
> > 		return 0;
> 
> This is an early-exit test, which means the careful check is necessary.
> 
> If (some day) someone calls this function with (LEFTRA|RIGHTRA) to
> readahead both siblings on a btree level where one sibling has been ra'd
> but not the other, we must avoid taking the branch.

Which I didn't see any callers do, so I ignored that possibility.
Regardless, it's the use of "|" to do an additive mask match that
makes it look wierd. i.e.  the normal way of writing a multi-biti
mask match is to apply the mask and check that the returned value
matches the mask, like so:

	if ((cur->bc_levels[lev].ra & lr) == lr)
		return 0;

Really, though, this was just another "ObHuh" comment, and you don't
need to "fix" it now...

> > > @@ -242,8 +250,17 @@ struct xfs_btree_cur
> > >  		struct xfs_btree_cur_ag	bc_ag;
> > >  		struct xfs_btree_cur_ino bc_ino;
> > >  	};
> > > +
> > > +	/* Must be at the end of the struct! */
> > > +	struct xfs_btree_level	bc_levels[];
> > >  };
> > >  
> > > +static inline size_t
> > > +xfs_btree_cur_sizeof(unsigned int nlevels)
> > > +{
> > > +	return struct_size((struct xfs_btree_cur *)NULL, bc_levels, nlevels);
> > > +}
> > 
> > Ooooh, yeah, we really need comments explaining how many btree
> > levels these VLAs are tracking, because this one doesn't have a "-
> > 1" in it like the previous one I commented on....
> 
> /*
>  * Compute the size of a btree cursor that can handle a btree of a given
>  * height.  The bc_levels array handles node and leaf blocks, so its
>  * size is exactly nlevels.
>  */

Nice. Thanks!

> > > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > > index c0ef53fe6611..816dfc8e5a80 100644
> > > --- a/fs/xfs/scrub/trace.c
> > > +++ b/fs/xfs/scrub/trace.c
> > > @@ -21,10 +21,11 @@ xchk_btree_cur_fsbno(
> > >  	struct xfs_btree_cur	*cur,
> > >  	int			level)
> > >  {
> > > -	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> > > +	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
> > >  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> > > -				xfs_buf_daddr(cur->bc_bufs[level]));
> > > -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > > +				xfs_buf_daddr(cur->bc_levels[level].bp));
> > > +	else if (level == cur->bc_nlevels - 1 &&
> > > +		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > 
> > No need for an else there as the first if () clause returns.
> > Also, needs more () around that "a & b" second line.
> 
> TBH I think we check the wrong flag, and that last bit should be:
> 
> 	if (level == cur->bc_nlevels - 1 &&
> 	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> 		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> 
> 	return NULLFSBLOCK;

Yup, true, long ptrs and inodes are currently interchangable so it
works, but that's a landmine waiting to pounce....

> But for now I'll stick to the straight replacement and tack on another
> patch to fix that.

*nod*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
