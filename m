Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754628AbdIGPqk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 11:46:40 -0400
Date: Thu, 7 Sep 2017 11:46:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/17] xfs: fix incorrect extent state in
 xfs_bmap_add_extent_unwritten_real
Message-ID: <20170907154637.GA61662@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:40AM +0200, Christoph Hellwig wrote:
> There was one spot in xfs_bmap_add_extent_unwritten_real that didn't use the
> passed in new extent state but always converted to normal, leading to wrong
> behavior when converting from normal to unwritten.
> 
> Only found by code inspection, it seems like this code path to move partial
> extent from written to unwritten while merging it with the next extent is
> rarely exercised.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9558f5ee1bf9..a60744a46bdf 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2573,7 +2573,7 @@ xfs_bmap_add_extent_unwritten_real(
>  					&i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			cur->bc_rec.b.br_state = XFS_EXT_NORM;
> +			cur->bc_rec.b.br_state = new->br_state;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
