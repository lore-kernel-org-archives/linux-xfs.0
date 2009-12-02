Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2FHGIp008701 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 09:17:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76DAB12DC202
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 07:17:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HSrZkjxXf92AUxFE for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 07:17:47 -0800 (PST)
Date: Wed, 2 Dec 2009 10:17:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [XFS] Free buffer pages array unconditionally
Message-ID: <20091202151742.GA1263@infradead.org>
References: <1259734333-20581-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734333-20581-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 05:12:13PM +1100, Dave Chinner wrote:
> The code in xfs_free_buf() only attempts to free the b_pages array if the
> buffer is a page cache backed or page allocated buffer. The extra log buffer
> that is used when the log wraps uses pages that are allocated to a different
> log buffer, but it still has a b_pages array allocated when those pages
> are associated to with the extra buffer in xfs_buf_associate_memory.
> 
> Hence we need to always attempt to free the b_pages array when tearing
> down a buffer, not just on buffers that are explicitly marked as page bearing
> buffers. This fixes a leak detected by the kernel memory leak code.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 4ddc973..4b84bbc 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -316,7 +316,7 @@ STATIC void
>  _xfs_buf_free_pages(
>  	xfs_buf_t	*bp)
>  {
> -	if (bp->b_pages != bp->b_page_array) {
> +	if (bp->b_pages && bp->b_pages != bp->b_page_array) {
>  		kmem_free(bp->b_pages);

kmem_free happily takes a NULL pointer, so this is unessecary.

> @@ -349,9 +349,9 @@ xfs_buf_free(
>  				ASSERT(!PagePrivate(page));
>  			page_cache_release(page);
>  		}
> -		_xfs_buf_free_pages(bp);
>  	}
>  
> +	_xfs_buf_free_pages(bp);

This part looks correct, good catch.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
