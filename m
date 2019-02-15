Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfBOXce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 18:32:34 -0500
Date: Fri, 15 Feb 2019 15:32:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: retry COW fork delalloc conversion when no
Message-ID: <20190215233225.GR32253@magnolia>
References: <20190215144725.8894-1-hch@lst.de>
 <20190215144725.8894-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215144725.8894-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Feb 15, 2019 at 03:47:25PM +0100, Christoph Hellwig wrote:
> While we can only truncate a block under the page lock for the current
> page, there is no high-level synchronization for moving extents from the
> COW to the data fork.  This means that for example we can have another
> thread doing a direct I/O completion that moves extents from the COW to
> the data fork race with writeback.  While this race is very hard to hit
> the always_cow seems to reproduce it reasonably well, and it also exists
> without that.  Because of that there is a chance that a delalloc
> conversion for the COW fork might not find any extents to convert.  In
> that case we should retry the whole block lookup and now find the blocks
> in the data fork.

<thinking aloud mode>

I /think/ the way that this series (+ Brian's before that) solve the
truncate/writeback race is that we now only convert existing delalloc
reservations to real extents when we're preparing to do writeback;
_writepage_map only cares about the mapping of the offset_fsb that it
happens to be looping right now (because the page lock serializes with
page cache truncate/punch); and we use the new sequence counters for
both the data and cow forks to decide when our cached mapping might be
invalid and therefore we need to get a new mapping?

Therefore we don't need to keep calling _trim_extent_eof or checking
offset against i_size or any of those other games because writeback
won't go allocating blocks into holes that are being punched and now we
have an explicit mechanism to invalidate wpc->imap instead of the
scattered detection code we had before?

If that's true, then:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a6abb7125203..2ed8733eca49 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -334,7 +334,8 @@ xfs_imap_valid(
>   * extent that maps offset_fsb in wpc->imap.
>   *
>   * The current page is held locked so nothing could have removed the block
> - * backing offset_fsb.
> + * backing offset_fsb, although it could have moved from the COW to the data
> + * fork by another thread.
>   */
>  static int
>  xfs_convert_blocks(
> @@ -375,6 +376,7 @@ xfs_map_blocks(
>  	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_iext_cursor	icur;
> +	int			retries = 0;
>  	int			error = 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -404,6 +406,7 @@ xfs_map_blocks(
>  	 * into real extents.  If we return without a valid map, it means we
>  	 * landed in a hole and we skip the block.
>  	 */
> +retry:
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       (ip->i_df.if_flags & XFS_IFEXTENTS));
> @@ -471,8 +474,19 @@ xfs_map_blocks(
>  	return 0;
>  allocate_blocks:
>  	error = xfs_convert_blocks(wpc, ip, offset_fsb);
> -	if (error)
> +	if (error) {
> +		/*
> +		 * If we failed to find the extent in the COW fork we might have
> +		 * raced with a COW to data fork conversion or truncate.
> +		 * Restart the lookup to catch the extent in the data fork for
> +		 * the former case, but prevent additional retries to avoid
> +		 * looping forever for the latter case.
> +		 */
> +		if (error == -EAGAIN && wpc->fork == XFS_COW_FORK && !retries++)
> +			goto retry;
> +		ASSERT(error != -EAGAIN);
>  		return error;
> +	}
>  
>  	/*
>  	 * Due to merging the return real extent might be larger than the
> -- 
> 2.20.1
> 
