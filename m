Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932557AbeE3Fg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 01:36:27 -0400
Date: Tue, 29 May 2018 22:36:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/34] fs: remove the buffer_unwritten check in
 page_seek_hole_data
Message-ID: <20180530053620.GS30110@magnolia>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523144357.18985-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 04:43:27PM +0200, Christoph Hellwig wrote:
> We only call into this function through the iomap iterators, so we already
> know the buffer is unwritten.  In addition to that we always require the
> uptodate flag that is ORed with the result anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though it took me a while to dig through all the twisty
bits...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4a01d2f4e8e9..bef5e91d40bf 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -611,14 +611,9 @@ page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
>  			continue;
>  
>  		/*
> -		 * Unwritten extents that have data in the page cache covering
> -		 * them can be identified by the BH_Unwritten state flag.
> -		 * Pages with multiple buffers might have a mix of holes, data
> -		 * and unwritten extents - any buffer with valid data in it
> -		 * should have BH_Uptodate flag set on it.
> +		 * Any buffer with valid data in it should have BH_Uptodate set.
>  		 */
> -
> -		if ((buffer_unwritten(bh) || buffer_uptodate(bh)) == seek_data)
> +		if (buffer_uptodate(bh) == seek_data)
>  			return lastoff;
>  
>  		lastoff = offset;
> @@ -630,8 +625,8 @@ page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
>   * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
>   *
>   * Within unwritten extents, the page cache determines which parts are holes
> - * and which are data: unwritten and uptodate buffer heads count as data;
> - * everything else counts as a hole.
> + * and which are data: uptodate buffer heads count as data; everything else
> + * counts as a hole.
>   *
>   * Returns the resulting offset on successs, and -ENOENT otherwise.
>   */
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
