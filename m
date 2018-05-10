Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeEJNyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 09:54:11 -0400
Date: Thu, 10 May 2018 06:54:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: factor out nodiscard helpers
Message-ID: <20180510135410.GA3074@infradead.org>
References: <20180510125223.77364-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510125223.77364-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

This looks much better, and I think the diffstat speaks for itself..

Reviewed-by: Christoph Hellwig <hch@lst.de>

> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 24f60ee810e4..fd3c3be4d64a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5107,15 +5107,15 @@ xfs_bmap_del_extent_real(
>  			if (error)
>  				goto done;
>  		} else {
> +			bool	skip_discard = false;
> +
>  			if ((bflags & XFS_BMAPI_NODISCARD) ||
> +			    (del->br_state == XFS_EXT_UNWRITTEN))

No need for the inner braces in the second statement.

> +				skip_discard = true;
> +
> +			__xfs_bmap_add_free(mp, dfops, del->br_startblock,
> +					    del->br_blockcount, NULL,
> +					    skip_discard);

In fact I'd avoid the variable entirely:

			__xfs_bmap_add_free(mp, dfops, del->br_startblock,
					del->br_blockcount, NULL,
					del->br_state == XFS_EXT_UNWRITTEN ||
					(bflags & XFS_BMAPI_NODISCARD));

