Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117F3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jul 2022 01:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiGFBYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 21:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFBYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 21:24:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 632701835B
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 18:24:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 398795ED08F;
        Wed,  6 Jul 2022 11:24:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o8tmJ-00F331-Re; Wed, 06 Jul 2022 11:24:31 +1000
Date:   Wed, 6 Jul 2022 11:24:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Message-ID: <20220706012431.GJ227878@dread.disaster.area>
References: <20220629060755.25537-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629060755.25537-1-wen.gang.wang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c4e452
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=bt8W1AqANHfWmyx2OUgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 11:07:55PM -0700, Wengang Wang wrote:
> During a reflink operation, the IOLOCK and MMAPLOCK of the source file
> are held in exclusive mode for the duration. This prevents reads on the
> source file, which could be a very long time if the source file has
> millions of extents.
> 
> As the source of copy, besides some necessary modification (say dirty page
> flushing), it plays readonly role. Locking source file exclusively through
> out the full reflink copy is unreasonable.
> 
> This patch downgrades exclusive locks on source file to shared modes after
> page cache flushing and before cloning the extents. To avoid source file
> change after lock downgradation, direct write paths take IOLOCK_EXCL on
> seeing reflink copy happening to the files.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> V2 changes:
>  Commit message
>  Make direct write paths take IOLOCK_EXCL when reflink copy is happening
>  Tiny changes
> ---
>  fs/xfs/xfs_file.c  | 33 ++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_inode.c | 31 +++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h | 11 +++++++++++
>  3 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5a171c0b244b..6ca7118ee274 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -514,8 +514,10 @@ xfs_file_dio_write_aligned(
>  	struct iov_iter		*from)
>  {
>  	unsigned int		iolock = XFS_IOLOCK_SHARED;
> +	int			remapping;
>  	ssize_t			ret;
>  
> +relock:
>  	ret = xfs_ilock_iocb(iocb, iolock);
>  	if (ret)
>  		return ret;
> @@ -523,14 +525,25 @@ xfs_file_dio_write_aligned(
>  	if (ret)
>  		goto out_unlock;
>  
> +	remapping = xfs_iflags_test(ip, XFS_IREMAPPING);
> +
>  	/*
>  	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
>  	 * the iolock back to shared if we had to take the exclusive lock in
>  	 * xfs_file_write_checks() for other reasons.
> +	 * But take IOLOCK_EXCL when reflink copy is going on
>  	 */
>  	if (iolock == XFS_IOLOCK_EXCL) {
> -		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -		iolock = XFS_IOLOCK_SHARED;
> +		if (!remapping) {
> +			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +			iolock = XFS_IOLOCK_SHARED;
> +		}
> +	} else { /* iolock == XFS_ILOCK_SHARED */
> +		if (remapping) {
> +			xfs_iunlock(ip, iolock);
> +			iolock = XFS_IOLOCK_EXCL;
> +			goto relock;
> +		}
>  	}

I'm not sure we can do relocking here. We've already run
xfs_file_write_checks() once which means we've already called
file_modified() and made changes to the inode.

Indeed, if we know that remapping is going on, why are we even
starting with XFS_IOLOCK_SHARED? i.e. shouldn't this just be:

	unsigned int		iolock = XFS_IOLOCK_SHARED;
	ssize_t			ret;

	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
		iolock = XFS_IOLOCK_EXCL;

retry:
	ret = xfs_ilock_iocb(iocb, iolock);
	if (ret)
		return ret;
	if (xfs_iflags_test(ip, XFS_IREMAPPING) &&
	    iolock == XFS_IOLOCK_SHARED) {
		/* Raced with a remap operation starting! */
		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
		iolock = XFS_IOLOCK_EXCL;
		goto restart;
	}
	....

And no other changes need to be made? i.e. we can downgrade the
XFS_IOLOCK_EXCL safely at any time in this path because the barrier
to reflink starting and setting the XFS_IREMAPPING flag is that it
has to be holding XFS_IOLOCK_EXCL and holding the IOLOCK in any mode
will hold off any reflink starting.

However, the key thing to note is that holding the IOLOCK in either
EXCL or SHARED does not not actually guarantee that there are no
DIO writes in progress. We only have to hold the lock over
submission to ensure the inode_dio_begin() call is serialised
correctly.....

i.e. when we do AIO DIO writes, we hold the IOLOCK_SHARED over
submission while the inode->i_dio_count is incremented, but then
drop the IOLOCK before completion occurs.

Hence the only way to guarantee that there is no DIO writes in
progress is to take IOLOCK_EXCL to stop new DIO writes from
starting, and then call inode_dio_wait() to wait for i_dio_count to
fall to zero. Once inode_dio_wait() returns, we're guaranteed that
there are no DIO writes in progress.

IOWs, the demotion from EXCL to SHARED in
xfs_file_dio_write_aligned() code is completely irrelevant from the
perspective of serialising against DIO writes in progress, so we
don't need to touch that code.

However, if we are going to demote the IOLOCK in the reflink code,
we now need a separate barrier to prevent dio writes from starting
while the reflink is in progress. As you've implemented, the
IREMAPPING flag provides this barrier, but your code didn't handle
the TOCTOU races in gaining the IOLOCK in the correct mode in the
DIO path....

>  	trace_xfs_file_direct_write(iocb, from);
>  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> @@ -1125,6 +1138,19 @@ xfs_file_remap_range(
>  	if (ret || len == 0)
>  		return ret;
>  
> +	/*
> +	 * Set XFS_IREMAPPING flag to source file before we downgrade
> +	 * the locks, so that all direct writes know they have to take
> +	 * IOLOCK_EXCL.
> +	 */
> +	xfs_iflags_set(src, XFS_IREMAPPING);
> +
> +	/*
> +	 * From now on, we read only from src, so downgrade locks to allow
> +	 * read operations go.
> +	 */
> +	xfs_ilock_io_mmap_downgrade_src(src, dest);

Oh, you've been lucky here. :) xfs_reflink_remap_prep() ->
generic_remap_file_range_prep() calls inode_dio_wait() on both
inodes while they are locked exclusively.

However, I don't think you can downgrade the mmap lock here - that
will allow page faults to dirty the pages in the source file. I'm
also not sure that we can even take the mmap lock exclusively in
the page fault path like we can the IOLOCK in the IO path....

Hence I think it is simplest just to consider it unsafe to downgrade
the mmap lock here and so only the IO lock can be downgraded. For
read IO, that's the only one that needs to be downgraded, anyway.

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 7be6f8e705ab..c07d4b42cf9d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -262,6 +262,13 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>   */
>  #define XFS_INACTIVATING	(1 << 13)
>  
> +/*
> + * A flag indicating reflink copy / remapping is happening to the file as
> + * source. When set, all direct IOs should take IOLOCK_EXCL to avoid
> + * interphering the remapping.
> + */
> +#define XFS_IREMAPPING		(1 << 14)
> +
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
>  				 XFS_IRECLAIM | \
> @@ -512,5 +519,9 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_ilock_io_mmap_downgrade_src(struct xfs_inode *src,
> +					struct xfs_inode *dest);
> +void xfs_iunlock2_io_mmap_src_shared(struct xfs_inode *src,
> +					struct xfs_inode *dest);

I suspect we are at the point where we really need to move all the
inode locking out of xfs_inode.[ch] and into separate
xfs_inode_locking.[ch] files. Not necessary for this patchset, but
if we keep adding more locking helpers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
