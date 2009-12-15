Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFJL2I3252874 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 13:21:02 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] XFS: Free buffer pages array unconditionally
Date: Tue, 15 Dec 2009 13:21:36 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6866@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1260832317-14977-1-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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

Dave Chinner wrote:
> The code in xfs_free_buf() only attempts to free the b_pages array if the
> buffer is a page cache backed or page allocated buffer. The extra log buffer
> that is used when the log wraps uses pages that are allocated to a different
> log buffer, but it still has a b_pages array allocated when those pages
> are associated to with the extra buffer in xfs_buf_associate_memory.
> 
> Hence we need to always attempt to free the b_pages array when tearing
> down a buffer, not just on buffers that are explicitly marked as page bearing
> buffers. This fixes a leak detected by the kernel memory leak code.

Three places call xfs_buf_get_pages();
- _xfs_buf_lookup_pages(), which sets the _XBF_PAGE_CACHE flag in the
  buffer after the call
- xfs_buf_associate_memory(), which sets no flag bit
- xfs_buf_get_noaddr(), which sets the _XBF_PAGES flag.

The only place that checks for _XBF_PAGES is xfs_buf_free().

Given that, I have two comments:
- You could just as easily have set the _XBF_PAGES flag in
  xfs_buf_associate_memory, thereby making that flag indicate
  consistently that the buffer has allocated pages
- Or, since you are proposing unconditionally freeing the
  pages, we can perhaps drop the _XBF_PAGES flag altogether
  since it no longer serves much purpose.  (I prefer this.)

					-Alex

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 4ddc973..529d6a6 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -318,6 +318,7 @@ _xfs_buf_free_pages(
>  {
>  	if (bp->b_pages != bp->b_page_array) {
>  		kmem_free(bp->b_pages);
> +		bp->b_pages = NULL;
>  	}
>  }
> 
> @@ -349,9 +350,8 @@ xfs_buf_free(
>  				ASSERT(!PagePrivate(page));
>  			page_cache_release(page);
>  		}
> -		_xfs_buf_free_pages(bp);
>  	}
> -
> +	_xfs_buf_free_pages(bp);
>  	xfs_buf_deallocate(bp);
>  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
