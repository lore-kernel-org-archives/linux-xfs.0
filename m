Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbeJAU6K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 16:58:10 -0400
Date: Mon, 1 Oct 2018 10:20:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] xfs: handle zeroing in xfs_file_iomap_begin_delay
Message-ID: <20181001142005.GE53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:37AM -0700, Christoph Hellwig wrote:
> We only need to allocate blocks for zeroing for reflink inodes,
> and for we currently have a special case for reflink files in
> the otherwise direct I/O path that I'd like to get rid of.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 10fc93cebc42..7cbebcf61fa7 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -62,6 +62,21 @@ xfs_bmbt_to_iomap(
>  	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
>  }
>  
> +static void
> +xfs_hole_to_iomap(
> +	struct xfs_inode	*ip,
> +	struct iomap		*iomap,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		end_fsb)
> +{
> +	iomap->addr = IOMAP_NULL_ADDR;
> +	iomap->type = IOMAP_HOLE;
> +	iomap->offset = XFS_FSB_TO_B(ip->i_mount, offset_fsb);
> +	iomap->length = XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
> +	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> +	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
> +}
> +
>  xfs_extlen_t
>  xfs_eof_alignment(
>  	struct xfs_inode	*ip,
> @@ -502,6 +517,7 @@ xfs_file_iomap_begin_delay(
>  	struct inode		*inode,
>  	loff_t			offset,
>  	loff_t			count,
> +	unsigned		flags,
>  	struct iomap		*iomap)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> @@ -539,8 +555,12 @@ xfs_file_iomap_begin_delay(
>  	}
>  
>  	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
> -	if (!eof && got.br_startoff <= offset_fsb) {
> -		if (xfs_is_reflink_inode(ip)) {
> +	if (eof)
> +		got.br_startoff = maxbytes_fsb;

What's the purpose of this? Can't we just continue to use eof in the
logic below and report holes up through the requested range (offset +
length) just like the other branch does (via xfs_bmapi_read())?

> +	if (got.br_startoff <= offset_fsb) {
> +		if (xfs_is_reflink_inode(ip) &&
> +		    ((flags & IOMAP_WRITE) ||
> +		     got.br_state != XFS_EXT_UNWRITTEN)) {

I think a small comment is useful here due to the implicit logic. For
example:

/* reservation is required for writes and zeroing over normal extents */

Otherwise this seems fine.

Brian

>  			bool		shared;
>  
>  			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
> @@ -555,6 +575,11 @@ xfs_file_iomap_begin_delay(
>  		goto done;
>  	}
>  
> +	if (flags & IOMAP_ZERO) {
> +		xfs_hole_to_iomap(ip, iomap, offset_fsb, got.br_startoff);
> +		goto out_unlock;
> +	}
> +
>  	error = xfs_qm_dqattach_locked(ip, false);
>  	if (error)
>  		goto out_unlock;
> @@ -1009,10 +1034,11 @@ xfs_file_iomap_begin(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> +	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
>  			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>  		/* Reserve delalloc blocks for regular writeback. */
> -		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
> +		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> +				iomap);
>  	}
>  
>  	/*
> -- 
> 2.19.0
> 
