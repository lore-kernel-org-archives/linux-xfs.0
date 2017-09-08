Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756639AbdIHRTO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:19:14 -0400
Date: Fri, 8 Sep 2017 13:19:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/17] xfs: replace xfs_bmbt_lookup_ge with
 xfs_bmbt_lookup_first
Message-ID: <20170908171912.GE905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-16-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:54AM +0200, Christoph Hellwig wrote:
> We only use xfs_bmbt_lookup_ge to look up the first bmap record in an
> inode, so replace xfs_bmbt_lookup_ge with a special purpose helper that
> is a bit more descriptive.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 05c0cde3f415..54b9f18f0dab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -121,16 +121,13 @@ xfs_bmbt_lookup_eq(
>  }
>  
>  STATIC int				/* error */
> -xfs_bmbt_lookup_ge(
> +xfs_bmbt_lookup_first(
>  	struct xfs_btree_cur	*cur,
> -	xfs_fileoff_t		off,
> -	xfs_fsblock_t		bno,
> -	xfs_filblks_t		len,
>  	int			*stat)	/* success/failure */
>  {
> -	cur->bc_rec.b.br_startoff = off;
> -	cur->bc_rec.b.br_startblock = bno;
> -	cur->bc_rec.b.br_blockcount = len;
> +	cur->bc_rec.b.br_startoff = 0;
> +	cur->bc_rec.b.br_startblock = 0;
> +	cur->bc_rec.b.br_blockcount = 0;
>  	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
>  }
>  
> @@ -978,7 +975,8 @@ xfs_bmap_add_attrfork_btree(
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
>  		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.firstblock = *firstblock;
> -		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
> +		error = xfs_bmbt_lookup_first(cur, &stat);
> +		if (error)
>  			goto error0;
>  		/* must be at least one entry */
>  		XFS_WANT_CORRUPTED_GOTO(mp, stat == 1, error0);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
