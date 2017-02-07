Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30102 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932101AbdBGWBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 17:01:23 -0500
Date: Tue, 7 Feb 2017 14:01:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs: improve busy extent sorting
Message-ID: <20170207220116.GH12378@birch.djwong.org>
References: <20170207171501.4268-1-hch@lst.de>
 <20170207171501.4268-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207171501.4268-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 07, 2017 at 06:15:00PM +0100, Christoph Hellwig wrote:
> Sort busy extents by the full block number instead of just the AGNO so
> that we can issue consecutive discard requests that the block layer could
> merge (although we'll need additional block layer fixes for fast devices).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_extent_busy.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 4d850e27095e..ab062610234e 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -656,9 +656,17 @@ xfs_extent_busy_wait_all(
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
> +	s32 diff;
> +
> +	diff = b1->agno - b2->agno;
> +	if (!diff)
> +		diff = b1->bno - b2->bno;
> +	return diff;
>  }
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
