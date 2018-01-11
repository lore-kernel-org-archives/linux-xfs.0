Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbeAKUFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 15:05:34 -0500
Date: Thu, 11 Jan 2018 12:05:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/8] libxfs: add function to free all bufferse in bcache
Message-ID: <20180111200530.GF5602@magnolia>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-8-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515699458-6925-8-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 01:37:37PM -0600, Eric Sandeen wrote:
> Subject: libxfs: add function to free all bufferse in bcache

s/bufferse/buffers/

> libxfs_bcache_purge simply moves all "free" buffers
> onto the xfs_buf_freelist mru list; add a new function to
> actually free them when we tear everything down, so leak
> checkers don't go nuts about lots of unfreed xfs_bufs
> at exit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  libxfs/init.c      |  2 ++
>  libxfs/libxfs_io.h |  1 +
>  libxfs/rdwr.c      | 16 ++++++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 7bde8b7..aea308b 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -889,6 +889,8 @@ void
>  libxfs_destroy(void)
>  {
>  	manage_zones(1);
> +	libxfs_bcache_purge();
> +	libxfs_bcache_free();
>  	cache_destroy(libxfs_bcache);
>  }
>  
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 2fce04d..81d2804 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -191,6 +191,7 @@ extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
>  			const struct xfs_buf_ops *ops);
>  extern xfs_buf_t *libxfs_getsb(struct xfs_mount *, int);
>  extern void	libxfs_bcache_purge(void);
> +extern void	libxfs_bcache_free(void);
>  extern void	libxfs_bcache_flush(void);
>  extern void	libxfs_purgebuf(xfs_buf_t *);
>  extern int	libxfs_bcache_overflowed(void);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index c5ffd4d..1dcabdd 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1278,6 +1278,22 @@ libxfs_bulkrelse(
>  }
>  
>  /*
> + * Free everything from the xfs_buf_freelist MRU, used at final teardown
> + */
> +void
> +libxfs_bcache_free(void)
> +{
> +	struct list_head	*cm_list;
> +	xfs_buf_t		*bp, *next;
> +
> + 	cm_list = &xfs_buf_freelist.cm_list;
> +	list_for_each_entry_safe(bp, next, cm_list, b_node.cn_mru) {
> +		free(bp->b_addr);

Hm, do we need to free bp->b_maps here?  Just looking at
__libxfs_getbufr (aka the other function that can tear down a
bp->b_addr).

> +		free(bp);

kmem_zone_free, since we got the bp from kmem_zone_alloc.

Do we need to reinit xfs_buf_freelist.cm_list, since ->next now points
to freed list items?

--D

> +	}
> +}
> +
> +/*
>   * When a buffer is marked dirty, the error is cleared. Hence if we are trying
>   * to flush a buffer prior to cache reclaim that has an error on it it means
>   * we've already tried to flush it and it failed. Prevent repeated corruption
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
