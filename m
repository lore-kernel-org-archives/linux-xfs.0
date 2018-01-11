Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932766AbeAKUUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 15:20:32 -0500
Date: Thu, 11 Jan 2018 12:20:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] libxfs: manage xfs_buf_zone count within cache
Message-ID: <20180111202026.GG5602@magnolia>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-7-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515699458-6925-7-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 01:37:36PM -0600, Eric Sandeen wrote:
> Fake up the xfs_buf_zone allocated count a bit to account
> for buffers freed to and allocated from cache.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  libxfs/rdwr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 474e5eb..c5ffd4d 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -665,6 +665,7 @@ __libxfs_getbufr(int blen)
>  				free(bp->b_maps);
>  			bp->b_maps = NULL;
>  		}
> +		xfs_buf_zone->allocated++;

I'm confused.  kmem_zone_zalloc increments zone->allocated and
kmem_zone_free decrements it.  Now we're messing with ->allocated
ourselves, which means that buffers that have ended up on
xfs_buf_freelist are still allocated (according to the heap) but the
zone accounting thinks the buffer is freed?

<goes away, reviews the next patch, comes back>

The next patch has xfs_buf_freelist frees the buffer directly and
bypassing kmem_zone_free.  So I wonder, if you change the next patch to
call kmem_zone_free and kill this patch, won't the accounting work out?

(xfs buf zone allocated == 0)

bp = _zone_alloc()
xfs_buf_zone->allocated++

...do stuff with buffer...

xfs_buf_relse(bp)
list_add(bp, xfs_buf_freelist)

...buffer still allocated, xfs_buf_zone->allocated == 1...

libxfs_bcache_free()
_zone_free(bp)
xfs_buf_zone->allocated--

...exit program, and:
xfs_buf_zone->allocated == 0

I think killing this patch and teaching the next one to kmem_zone_free
the buffer works, right?  Or am I missing some subtlety here, in which
case said subtlety needs comments.

--D

>  	} else
>  		bp = kmem_zone_zalloc(xfs_buf_zone, 0);
>  	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
> @@ -1245,6 +1246,7 @@ libxfs_brelse(
>  			"releasing dirty buffer to free list!");
>  
>  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
> +	xfs_buf_zone->allocated--;
>  	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
>  	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
>  }
> @@ -1268,6 +1270,7 @@ libxfs_bulkrelse(
>  	}
>  
>  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
> +	xfs_buf_zone->allocated -= count;
>  	list_splice(list, &xfs_buf_freelist.cm_list);
>  	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
