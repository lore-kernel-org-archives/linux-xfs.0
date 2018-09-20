Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCQt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 22:16:49 -0400
Date: Thu, 20 Sep 2018 13:31:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/10] xfs: remove XFS_IO_INVALID
Message-ID: <20180920203127.GQ20086@magnolia>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917205354.15401-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:47PM +0200, Christoph Hellwig wrote:
> The invalid state isn't any different from a hole, so merge the two
> states.  Use the more descriptive hole name, but keep it as the first
> value of the enum to catch uninitialized fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It's probably worth mentioning that I'm just reading patches *without*
having previously shoved all the day's patches into a branch, built it,
and started xfstests.... :)

> ---
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

Hm.  So I guess if we ever saw XFS_IO_INVALID that meant "we never did
find any extents and so never set io_type", right?

Just checking assumptions here, having let everything page out of my
brain these past 6 weeks...

--D

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
> 2.18.0
> 
