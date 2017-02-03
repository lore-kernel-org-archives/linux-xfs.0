Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdBCPWs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 10:22:48 -0500
Date: Fri, 3 Feb 2017 10:22:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: improve busy extent sorting
Message-ID: <20170203152242.GD45388@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485715421-17182-4-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 29, 2017 at 07:43:40PM +0100, Christoph Hellwig wrote:
> Sort busy extents by the full block number instead of just the AGNO so
> that we can issue consecutive discard requests that the block layer could
> merge (although we'll need additional block layer fixes for fast devices).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_extent_busy.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 8251359..d64dd4c 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -629,9 +629,13 @@ xfs_extent_busy_flush(
>  int
>  xfs_extent_busy_ag_cmp(
>  	void			*priv,
> -	struct list_head	*a,
> -	struct list_head	*b)
> +	struct list_head	*l1,
> +	struct list_head	*l2)
>  {
> -	return container_of(a, struct xfs_extent_busy, list)->agno -
> -		container_of(b, struct xfs_extent_busy, list)->agno;
> +	struct xfs_extent_busy	*b1 =
> +		container_of(l1, struct xfs_extent_busy, list);
> +	struct xfs_extent_busy	*b2 =
> +		container_of(l2, struct xfs_extent_busy, list);
> +
> +	return b1->agno - b2->agno || b1->bno - b2->bno;

When will this ever return negative?

Brian

>  }
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
