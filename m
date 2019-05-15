Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26209 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfEOMkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:40:07 -0400
Date: Wed, 15 May 2019 08:40:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: merge xfs_buf_zero and xfs_buf_iomove
Message-ID: <20190515124005.GB2898@bfoster>
References: <20190515081020.3293-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515081020.3293-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 10:10:20AM +0200, Christoph Hellwig wrote:
> xfs_buf_zero is the only caller of xfs_buf_iomove.  Remove support
> for copying from or to the buffer in xfs_buf_iomove and merge the
> two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 18 +++---------------
>  fs/xfs/xfs_buf.h | 11 +----------
>  2 files changed, 4 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 548344e25128..c66788dbaaba 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1617,12 +1617,10 @@ xfs_buf_offset(
>   *	Move data into or out of a buffer.
>   */

This comment is now stale.

>  void
> -xfs_buf_iomove(
> +xfs_buf_zero(
>  	xfs_buf_t		*bp,	/* buffer to process		*/

Can we kill off this typedef too? Nits aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	size_t			boff,	/* starting buffer offset	*/
> -	size_t			bsize,	/* length to copy		*/
> -	void			*data,	/* data address			*/
> -	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
> +	size_t			bsize)	/* length to copy		*/
>  {
>  	size_t			bend;
>  
> @@ -1639,19 +1637,9 @@ xfs_buf_iomove(
>  
>  		ASSERT((csize + page_offset) <= PAGE_SIZE);
>  
> -		switch (mode) {
> -		case XBRW_ZERO:
> -			memset(page_address(page) + page_offset, 0, csize);
> -			break;
> -		case XBRW_READ:
> -			memcpy(data, page_address(page) + page_offset, csize);
> -			break;
> -		case XBRW_WRITE:
> -			memcpy(page_address(page) + page_offset, data, csize);
> -		}
> +		memset(page_address(page) + page_offset, 0, csize);
>  
>  		boff += csize;
> -		data += csize;
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d0b96e071cec..1701efee4fd4 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -21,12 +21,6 @@
>  
>  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>  
> -typedef enum {
> -	XBRW_READ = 1,			/* transfer into target memory */
> -	XBRW_WRITE = 2,			/* transfer from target memory */
> -	XBRW_ZERO = 3,			/* Zero target memory */
> -} xfs_buf_rw_t;
> -
>  #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
>  #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
>  #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
> @@ -305,10 +299,7 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
>  	return __xfs_buf_submit(bp, wait);
>  }
>  
> -extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
> -				xfs_buf_rw_t);
> -#define xfs_buf_zero(bp, off, len) \
> -	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
> +void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
>  
>  /* Buffer Utility Routines */
>  extern void *xfs_buf_offset(struct xfs_buf *, size_t);
> -- 
> 2.20.1
> 
