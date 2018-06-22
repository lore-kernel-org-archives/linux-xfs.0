Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVG3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:29:09 -0400
Date: Thu, 21 Jun 2018 23:29:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: ensure post-EOF zeroing happens after zeroing
 part of a file
Message-ID: <20180622062907.GA27254@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960591330.26246.305971181988789033.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960591330.26246.305971181988789033.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 11:31:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a user asks us to zero_range part of a file, the end of the range is
> EOF, and not aligned to a page boundary, invoke writeback of the EOF
> page to ensure that the post-EOF part of the page is zeroed.  This
> ensures that we don't expose stale memory contents via mmap, if in a
> clumsy manner.
> 
> Found by running generic/127 when it runs zero_range and mapread at EOF
> one after the other.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index abc37b0899c0..c94d376e4152 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1208,7 +1208,20 @@ xfs_free_file_space(
>  		return 0;
>  	if (offset + len > XFS_ISIZE(ip))
>  		len = XFS_ISIZE(ip) - offset;
> -	return iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
> +	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If we zeroed right up to EOF and EOF straddles a page boundary we
> +	 * must make sure that the post-EOF area is also zeroed because the
> +	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
> +	 * Writeback of the eof page will do this, albeit clumsily.
> +	 */
> +	if (offset + len < XFS_ISIZE(ip) || ((offset + len) & PAGE_MASK) == 0)
> +		return 0;
> +	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> +			(offset + len) & ~PAGE_MASK, LLONG_MAX);

Total nitpick, but between the kernel logic flow and comment I'd invert
the check:

	if (offset + len >= XFS_ISIZE(ip) && (offset + len) & PAGE_MASK) {
		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
			(offset + len) & ~PAGE_MASK, LLONG_MAX);
	}

	return error;

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
