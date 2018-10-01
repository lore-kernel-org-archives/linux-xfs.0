Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729272AbeJAU5v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 16:57:51 -0400
Date: Mon, 1 Oct 2018 10:19:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/7] xfs: remove XFS_IO_INVALID
Message-ID: <20181001141946.GC53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:35AM -0700, Christoph Hellwig wrote:
> The invalid state isn't any different from a hole, so merge the two
> states.  Use the more descriptive hole name, but keep it as the first
> value of the enum to catch uninitialized fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c |  4 ++--
>  fs/xfs/xfs_aops.h | 14 ++++++--------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 49f5f5896a43..338b9d9984e0 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -917,7 +917,7 @@ xfs_vm_writepage(
>  	struct writeback_control *wbc)
>  {
>  	struct xfs_writepage_ctx wpc = {
> -		.io_type = XFS_IO_INVALID,
> +		.io_type = XFS_IO_HOLE,
>  	};
>  	int			ret;
>  
> @@ -933,7 +933,7 @@ xfs_vm_writepages(
>  	struct writeback_control *wbc)
>  {
>  	struct xfs_writepage_ctx wpc = {
> -		.io_type = XFS_IO_INVALID,
> +		.io_type = XFS_IO_HOLE,
>  	};
>  	int			ret;
>  
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 9af867951a10..494b4338446e 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -12,21 +12,19 @@ extern struct bio_set xfs_ioend_bioset;
>   * Types of I/O for bmap clustering and I/O completion tracking.
>   */
>  enum {
> -	XFS_IO_INVALID,		/* initial state */
> +	XFS_IO_HOLE,		/* covers region without any block allocation */
>  	XFS_IO_DELALLOC,	/* covers delalloc region */
>  	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
>  	XFS_IO_OVERWRITE,	/* covers already allocated extent */
>  	XFS_IO_COW,		/* covers copy-on-write extent */
> -	XFS_IO_HOLE,		/* covers region without any block allocation */
>  };
>  
>  #define XFS_IO_TYPES \
> -	{ XFS_IO_INVALID,		"invalid" }, \
> -	{ XFS_IO_DELALLOC,		"delalloc" }, \
> -	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
> -	{ XFS_IO_OVERWRITE,		"overwrite" }, \
> -	{ XFS_IO_COW,			"CoW" }, \
> -	{ XFS_IO_HOLE,			"hole" }
> +	{ XFS_IO_HOLE,			"hole" },	\
> +	{ XFS_IO_DELALLOC,		"delalloc" },	\
> +	{ XFS_IO_UNWRITTEN,		"unwritten" },	\
> +	{ XFS_IO_OVERWRITE,		"overwrite" },	\
> +	{ XFS_IO_COW,			"CoW" }
>  
>  /*
>   * Structure for buffered I/O completions.
> -- 
> 2.19.0
> 
