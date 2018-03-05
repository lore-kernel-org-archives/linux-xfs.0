Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61470 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933011AbeCEViY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 16:38:24 -0500
Date: Tue, 6 Mar 2018 08:38:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix transaction allocation deadlock in IO path
Message-ID: <20180305213822.GD18129@dastard>
References: <20180305041120.4224-1-david@fromorbit.com>
 <20180305144022.GB6135@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305144022.GB6135@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 05, 2018 at 09:40:23AM -0500, Brian Foster wrote:
> On Mon, Mar 05, 2018 at 03:11:20PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_trans_alloc() does GFP_KERNEL allocation, and we can call it
> > while holding pages locked for writeback in the ->writepages path.
> > The memory allocation is allowed to wait on pages under writeback,
> > and so can wait on pages that are held locked in writeback by the
> > caller.
> > 
> 
> It looks like xfs_start_page_writeback() sets the page as writeback and
> unlocks it. I suspect this doesn't affect the actual problem if
> allocation waits on writeback, but rather something like "tagged as
> writeback" might be more clear than "held locked in writeback."

Yeah, taht's what I meant.

> Otherwise this seems fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > This affects both pre-IO submission and post-IO submission paths.
> > Hence xfs_setsize_trans_alloc(), xfs_reflink_end_cow(),
> > xfs_iomap_write_unwritten() and xfs_reflink_cancel_cow_range().
> > xfs_iomap_write_unwritten() already does the right thing, but the
> > others don't. Fix them.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c    | 3 ++-
> >  fs/xfs/xfs_reflink.c | 4 ++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 9c6a830da0ee..a0afb6411417 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -209,7 +209,8 @@ xfs_setfilesize_trans_alloc(
> >  	struct xfs_trans	*tp;
> >  	int			error;
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0,
> > +				XFS_TRANS_NOFS, &tp);
> 
> Was there another reason we preallocate this transaction where we don't
> seem to for others?

Because it happens all the time for buffered IO and this prevents
stalling the completion workqueue for a simple size update.
Unwritten conversion and COW completion are less frequently done,
are much larger pieces of work, can require multiple transactions
and have many more potential blocking points, and so such an
optimisation is much less beneficial in those cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
