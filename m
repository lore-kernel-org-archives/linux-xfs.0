Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbeIUCHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 22:07:51 -0400
Date: Thu, 20 Sep 2018 13:22:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs: skip delalloc COW blocks in xfs_reflink_end_cow
Message-ID: <20180920202233.GO20086@magnolia>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920144220.2181-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 04:42:17PM +0200, Christoph Hellwig wrote:
> The iomap direct I/O code issues a single ->end_io call for the whole
> I/O request, and if some of the extents cowered needed a COW operation
> it will call xfs_reflink_end_cow over the whole range.
> 
> When we do AIO writes we drop the iolock after doing the initial setup,
> but before the I/O completion.  Between dropping the lock and completing
> the I/O we can have a racing buffered write create new delalloc COW fork
> extents in the region covered by the outstanding direct I/O write, and
> thus see delalloc COW fork extents in xfs_reflink_end_cow.  As
> concurrent writes are fundamentally racy and no guarantees are given we
> can simply skip those.
> 
> This can be easily reproduced with xfstests generic/208 in always_cow
> mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_reflink.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index ac94ace45424..d1758771f21a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -686,14 +686,12 @@ xfs_reflink_end_cow(
>  		if (!del.br_blockcount)
>  			goto prev_extent;
>  
> -		ASSERT(!isnullstartblock(got.br_startblock));
> -
>  		/*
> -		 * Don't remap unwritten extents; these are
> -		 * speculatively preallocated CoW extents that have been
> -		 * allocated but have not yet been involved in a write.
> +		 * Only remap real extent that contain data.  With AIO
> +		 * speculatively preallocations can leak into the range we
> +		 * are called upon, and we need to skip them.
>  		 */
> -		if (got.br_state == XFS_EXT_UNWRITTEN)
> +		if (!xfs_bmap_is_real_extent(&got))
>  			goto prev_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
> -- 
> 2.18.0
> 
