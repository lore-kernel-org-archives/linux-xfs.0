Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754595AbcJQPfq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:35:46 -0400
Date: Mon, 17 Oct 2016 11:35:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/9] iomap: add IOMAP_REPORT
Message-ID: <20161017153542.GB12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:26AM +0200, Christoph Hellwig wrote:
> This allows the file system to tell a FIEMAP from a read operation, and thus
> avoids the need to report flags that aren't actually used in the read path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/iomap.c            |  2 +-
>  include/linux/iomap.h | 17 +++++++++++------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 013d1d3..a922040 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -561,7 +561,7 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  	}
>  
>  	while (len > 0) {
> -		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
> +		ret = iomap_apply(inode, start, len, IOMAP_REPORT, ops, &ctx,
>  				iomap_fiemap_actor);
>  		/* inode with no (attribute) mapping will give ENOENT */
>  		if (ret == -ENOENT)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index e63e288..7892f55 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -19,11 +19,15 @@ struct vm_fault;
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
>  
>  /*
> - * Flags for iomap mappings:
> + * Flags for all iomap mappings:
>   */
> -#define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
> -#define IOMAP_F_SHARED	0x02	/* block shared with another file */
> -#define IOMAP_F_NEW	0x04	/* blocks have been newly allocated */
> +#define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
> +
> +/*
> + * Flags that only need to be reported for IOMAP_REPORT requests:
> + */
> +#define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
> +#define IOMAP_F_SHARED	0x20	/* block shared with another file */
>  
>  /*
>   * Magic value for blkno:
> @@ -42,8 +46,9 @@ struct iomap {
>  /*
>   * Flags for iomap_begin / iomap_end.  No flag implies a read.
>   */
> -#define IOMAP_WRITE		(1 << 0)
> -#define IOMAP_ZERO		(1 << 1)
> +#define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
> +#define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
> +#define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
