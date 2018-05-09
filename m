Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933383AbeEIHkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:40:10 -0400
Date: Wed, 9 May 2018 00:40:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] xfs: skip online discard during eofblocks trims
Message-ID: <20180509074009.GA19933@infradead.org>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508172231.53570-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 01:22:30PM -0400, Brian Foster wrote:
> We've had reports of online discard operations being sent from XFS
> on write-only workloads. These discards occur as a result of
> eofblocks trims that can occur after a large file copy completes.
> 
> These discards are slightly confusing for users who might be paying
> close attention to online discards (i.e., vdo) due to performance
> sensitivity. They also happen to be spurious because freed post-eof
> blocks by definition have not been written to during the current
> allocation cycle.
> 
> Update xfs_free_eofblocks() to skip discards that are purely
> attributed to eofblocks trims. This cuts down the number of spurious
> discards that may occur on write-only workloads due to normal
> preallocation activity.
> 
> Note that discards of post-eof extents can still occur from other
> codepaths that do not isolate handling of post-eof blocks from those
> within eof. For example, file unlinks and truncates may still cause
> discards for any file blocks affected by the operation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  4 ++--
>  fs/xfs/xfs_inode.c     | 19 +++++++++++--------
>  fs/xfs/xfs_inode.h     | 24 ++++++++++++++++++++++--
>  3 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 8cd8c412f52d..696c3b6bd2c9 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -871,8 +871,8 @@ xfs_free_eofblocks(
>  		 * contents of the file are flushed to disk then the files
>  		 * may be full of holes (ie NULL files bug).
>  		 */
> -		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
> -					      XFS_ISIZE(ip));
> +		error = xfs_itruncate_extents_nodiscard(&tp, ip, XFS_DATA_FORK,
> +							XFS_ISIZE(ip));
>  		if (error) {
>  			/*
>  			 * If we get an error at this point we simply don't
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2b70c8b4cee2..d63ddd806074 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1534,11 +1534,12 @@ xfs_itruncate_clear_reflink_flags(
>   * dirty on error so that transactions can be easily aborted if possible.
>   */
>  int
> -xfs_itruncate_extents(
> +__xfs_itruncate_extents(
>  	struct xfs_trans	**tpp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	xfs_fsize_t		new_size)
> +	xfs_fsize_t		new_size,
> +	bool			skip_discard)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp = *tpp;
> @@ -1549,6 +1550,7 @@ xfs_itruncate_extents(
>  	xfs_filblks_t		unmap_len;
>  	int			error = 0;
>  	int			done = 0;
> +	int			flags;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> @@ -1561,6 +1563,10 @@ xfs_itruncate_extents(
>  
>  	trace_xfs_itruncate_extents_start(ip, new_size);
>  
> +	flags = xfs_bmapi_aflag(whichfork);
> +	if (skip_discard)
> +		flags |= XFS_BMAPI_NODISCARD;

Please just replace the whichfork argument to xfs_itruncate_extents
with a bmapi_flags one, and e'll get a much simpler interface.
