Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36960 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbeEUSke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 14:40:34 -0400
Date: Mon, 21 May 2018 11:39:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/12] xfs: convert to bioset_init()/mempool_init()
Message-ID: <20180521183936.GJ23858@magnolia>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-12-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520222558.7053-12-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Sun, May 20, 2018 at 06:25:57PM -0400, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

Looks ok, I guess...
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c  |  2 +-
>  fs/xfs/xfs_aops.h  |  2 +-
>  fs/xfs/xfs_super.c | 11 +++++------
>  3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 0ab824f574..102463543d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -594,7 +594,7 @@ xfs_alloc_ioend(
>  	struct xfs_ioend	*ioend;
>  	struct bio		*bio;
>  
> -	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, xfs_ioend_bioset);
> +	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &xfs_ioend_bioset);
>  	xfs_init_bio_from_bh(bio, bh);
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 69346d460d..694c85b038 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -18,7 +18,7 @@
>  #ifndef __XFS_AOPS_H__
>  #define __XFS_AOPS_H__
>  
> -extern struct bio_set *xfs_ioend_bioset;
> +extern struct bio_set xfs_ioend_bioset;
>  
>  /*
>   * Types of I/O for bmap clustering and I/O completion tracking.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d714240529..f643d76db5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -63,7 +63,7 @@
>  #include <linux/parser.h>
>  
>  static const struct super_operations xfs_super_operations;
> -struct bio_set *xfs_ioend_bioset;
> +struct bio_set xfs_ioend_bioset;
>  
>  static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  #ifdef DEBUG
> @@ -1845,10 +1845,9 @@ MODULE_ALIAS_FS("xfs");
>  STATIC int __init
>  xfs_init_zones(void)
>  {
> -	xfs_ioend_bioset = bioset_create(4 * MAX_BUF_PER_PAGE,
> +	if (bioset_init(&xfs_ioend_bioset, 4 * MAX_BUF_PER_PAGE,
>  			offsetof(struct xfs_ioend, io_inline_bio),
> -			BIOSET_NEED_BVECS);
> -	if (!xfs_ioend_bioset)
> +			BIOSET_NEED_BVECS))
>  		goto out;
>  
>  	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
> @@ -1997,7 +1996,7 @@ xfs_init_zones(void)
>   out_destroy_log_ticket_zone:
>  	kmem_zone_destroy(xfs_log_ticket_zone);
>   out_free_ioend_bioset:
> -	bioset_free(xfs_ioend_bioset);
> +	bioset_exit(&xfs_ioend_bioset);
>   out:
>  	return -ENOMEM;
>  }
> @@ -2029,7 +2028,7 @@ xfs_destroy_zones(void)
>  	kmem_zone_destroy(xfs_btree_cur_zone);
>  	kmem_zone_destroy(xfs_bmap_free_item_zone);
>  	kmem_zone_destroy(xfs_log_ticket_zone);
> -	bioset_free(xfs_ioend_bioset);
> +	bioset_exit(&xfs_ioend_bioset);
>  }
>  
>  STATIC int __init
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
