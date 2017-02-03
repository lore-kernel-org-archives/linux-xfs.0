Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdBCPUx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 10:20:53 -0500
Date: Fri, 3 Feb 2017 10:20:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: don't fail xfs_extent_busy allocation
Message-ID: <20170203152052.GB45388@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485715421-17182-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 29, 2017 at 07:43:38PM +0100, Christoph Hellwig wrote:
> We don't just need the structure to track busy extents which can be
> avoided with a synchronous transaction, but also to keep track of
> pending discard.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks fine, though I wonder if we should create a kmem_cache similar to
all of the other log item structures and whatnot...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extent_busy.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 162dc18..29c2f99 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -45,18 +45,7 @@ xfs_extent_busy_insert(
>  	struct rb_node		**rbp;
>  	struct rb_node		*parent = NULL;
>  
> -	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_MAYFAIL);
> -	if (!new) {
> -		/*
> -		 * No Memory!  Since it is now not possible to track the free
> -		 * block, make this a synchronous transaction to insure that
> -		 * the block is not reused before this transaction commits.
> -		 */
> -		trace_xfs_extent_busy_enomem(tp->t_mountp, agno, bno, len);
> -		xfs_trans_set_sync(tp);
> -		return;
> -	}
> -
> +	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_SLEEP);
>  	new->agno = agno;
>  	new->bno = bno;
>  	new->length = len;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
