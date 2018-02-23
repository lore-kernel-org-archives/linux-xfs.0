Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27887 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbeBWBEE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 20:04:04 -0500
Date: Fri, 23 Feb 2018 12:03:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't block on the ilock for RWF_NOWAIT
Message-ID: <20180223010326.GL7000@dastard>
References: <20180222150653.18479-1-hch@lst.de>
 <20180223000819.GJ7000@dastard>
 <20180223002242.GA4007@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180223002242.GA4007@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 23, 2018 at 01:22:42AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 23, 2018 at 11:08:19AM +1100, Dave Chinner wrote:
> > There's also a bug in the code where we take the ILOCK exclusive for
> > direct IO writes only to then have to demote it before calling
> > xfs_iomap_write_direct() if allocation is required.  This was a
> > regression introduced with the iomap direct IO path rework...
> 
> I actually have a fix for that and a few related bits pending in
> the O_ATOMIC tree, but that still has a few other items to fix..
> The relevant commit is attached below for reference.

OK.

> 
> > +xfs_ilock_for_iomap(
> > +	struct xfs_inode	*ip,
> > +	unsigned		flags,
> > +	unsigned		*lockmode)
> >  {
> > +	unsigned		mode = XFS_ILOCK_SHARED;
> > +
> > +	/* Modifications to reflink files require exclusive access */
> > +	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO))) {
> > +		/*
> > +		 * A reflinked inode will result in CoW alloc.
> > +		 * FIXME: It could still overwrite on unshared extents
> > +		 * and not need allocation in the direct IO path.
> > +		 */
> > +		if ((flags & IOMAP_NOWAIT) && (flags & IOMAP_DIRECT))
> > +			return -EAGAIN;
> 
> The IOMAP_DIRECT check here doesn't really make sense - currently we
> will only get IOMAP_NOWAIT if IOMAP_DIRECT also is set, but if at some
> point that is not true there is no point in depending on IOMAP_DIRECT
> either.

Fair enough, this was just a transposition of the existing logic.

> 
> > +		mode = XFS_ILOCK_EXCL;
> > +	}
> > +
> > +	/* Non-direct IO modifications require exclusive access */
> > +	if (!(flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
> > +		mode = XFS_ILOCK_EXCL;
> 
> There is no point in taking the lock exclusively in the main
> xfs_file_iomap_begin for !IOMAP_DIRECT at all.  We only need it for the
> reflink case that is handled above, or if we call
> into xfs_file_iomap_begin_delay, which does its own locking.

Again, this was just transposition of the existing logic. I think
this shows just how convoluted the code was that we couldn't see
things like this in it....

> > +	if (!xfs_ilock_nowait(ip, mode)) {
> > +		if (flags & IOMAP_NOWAIT)
> > +			return -EAGAIN;
> > +		xfs_ilock(ip, mode);
> > +	}
> 
> This pattern has caused some nasty performance regressions, which is
> why we removed it again elsewhere.  See the "xfs: fix AIM7 regression"
> commit (942491c9e6d631c012f3c4ea8e7777b0b02edeab).

Ah, I wondered why there was a different, more verbose locking
pattern elsewhere. This needs a comment somewhere....

> > +	/* Non-modifying mapping requested, so we are done */
> > +	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
> > +		goto iomap_found;
> 
> This should probably separate from any locking changes.

*nod*

> I thought about
> just splitting the pure read case from the direct / extsz allocate
> case but haven't looked into it yet.  In fact the read only case could
> probably share code with xfs_xattr_iomap_begin.

Yeah, I've been thinking the same thing, but I wanted to untangle
this first...

> Note that we also have another bug in this area, in that we allocate
> blocks for holes or unwritten extents in reflink files, see the
> other attached patch.
>
> From 584c49543b2376cc46a6d4a640fd7123df987607 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 12 Feb 2018 10:19:41 -0800
> Subject: xfs: don't allocate COW blocks for zeroing holes or unwritten extents
> 
> The iomap zeroing interface is smart enough to skip zeroing holes or
> unwritten extents.  Don't subvert this logic for reflink files.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 66e1edbfb2b2..4e771e0f1170 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -955,6 +955,13 @@ static inline bool imap_needs_alloc(struct inode *inode,
>  		(IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN);
>  }
>  
> +static inline bool needs_cow_for_zeroing(struct xfs_bmbt_irec *imap, int nimaps)
> +{
> +	return nimaps &&
> +		imap->br_startblock != HOLESTARTBLOCK &&
> +		imap->br_state != XFS_EXT_UNWRITTEN;
> +}
> +
>  static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
>  {
>  	/*
> @@ -1024,7 +1031,9 @@ xfs_file_iomap_begin(
>  			goto out_unlock;
>  	}
>  
> -	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> +	if (xfs_is_reflink_inode(ip) &&
> +	    ((flags & IOMAP_WRITE) ||
> +	     ((flags & IOMAP_ZERO) && needs_cow_for_zeroing(&imap, nimaps)))) {

Yeah, that looks like it's needed.

> From 24220b8b4a18ff60e509ab640fbe2a48b6a4fa51 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 12 Feb 2018 10:24:10 -0800
> Subject: xfs: don't start out with the exclusive ilock for direct I/O
> 
> There is no reason to take the ilock exclusively at the start of
> xfs_file_iomap_begin for direct I/O, given that it will be demoted
> just before calling xfs_iomap_write_direct anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4e771e0f1170..bc9ff5d8efea 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -962,19 +962,6 @@ static inline bool needs_cow_for_zeroing(struct xfs_bmbt_irec *imap, int nimaps)
>  		imap->br_state != XFS_EXT_UNWRITTEN;
>  }
>  
> -static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
> -{
> -	/*
> -	 * COW writes will allocate delalloc space, so we need to make sure
> -	 * to take the lock exclusively here.
> -	 */
> -	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
> -		return true;
> -	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
> -		return true;
> -	return false;
> -}
> -
>  static int
>  xfs_file_iomap_begin(
>  	struct inode		*inode,
> @@ -1000,7 +987,11 @@ xfs_file_iomap_begin(
>  		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
>  	}
>  
> -	if (need_excl_ilock(ip, flags)) {
> +	/*
> +	 * COW writes may allocate delalloc space or convert unwritten COW
> +	 * extents, so we need to make sure to take the lock exclusively here.
> +	 */
> +	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO))) {
>  		lockmode = XFS_ILOCK_EXCL;
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	} else {

Ok, so that's simpler logic. I still think we should pull this out
into a helper that also avoids all the IOMAP_NOWAIT cases we can
as well.

Where can I find all of your patches, because it seems we're
unnecessarily duplicating a lot of work in this area...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
