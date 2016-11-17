Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753058AbcKQSL4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 13:11:56 -0500
Date: Thu, 17 Nov 2016 13:11:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/14] xfs: cleanup xfs_bmap_last_before
Message-ID: <20161117181153.GD49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:33PM +0100, Christoph Hellwig wrote:
> Rewrite the function using xfs_iext_lookup_extent and xfs_iext_get_extent,
> and massage the flow into something easily understandable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 64 ++++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5c3c4dd..98f490b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1523,44 +1523,44 @@ xfs_bmap_first_unused(
>   */
>  int						/* error */
>  xfs_bmap_last_before(
> -	xfs_trans_t	*tp,			/* transaction pointer */
> -	xfs_inode_t	*ip,			/* incore inode */
> -	xfs_fileoff_t	*last_block,		/* last block */
> -	int		whichfork)		/* data or attr fork */
> +	struct xfs_trans	*tp,		/* transaction pointer */
> +	struct xfs_inode	*ip,		/* incore inode */
> +	xfs_fileoff_t		*last_block,	/* last block */
> +	int			whichfork)	/* data or attr fork */
>  {
> -	xfs_fileoff_t	bno;			/* input file offset */
> -	int		eof;			/* hit end of file */
> -	xfs_bmbt_rec_host_t *ep;		/* pointer to last extent */
> -	int		error;			/* error return value */
> -	xfs_bmbt_irec_t	got;			/* current extent value */
> -	xfs_ifork_t	*ifp;			/* inode fork pointer */
> -	xfs_extnum_t	lastx;			/* last extent used */
> -	xfs_bmbt_irec_t	prev;			/* previous extent value */
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_bmbt_irec	got;
> +	xfs_extnum_t		idx;
> +	int			error;
>  
> -	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> -	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> -	       return -EIO;
> -	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
> +	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> +	case XFS_DINODE_FMT_LOCAL:
>  		*last_block = 0;
>  		return 0;
> +	case XFS_DINODE_FMT_BTREE:
> +	case XFS_DINODE_FMT_EXTENTS:
> +		break;
> +	default:
> +		return -EIO;
>  	}
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> -	    (error = xfs_iread_extents(tp, ip, whichfork)))
> -		return error;
> -	bno = *last_block - 1;
> -	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
> -		&prev);
> -	if (eof || xfs_bmbt_get_startoff(ep) > bno) {
> -		if (prev.br_startoff == NULLFILEOFF)
> -			*last_block = 0;
> -		else
> -			*last_block = prev.br_startoff + prev.br_blockcount;
> +
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(tp, ip, whichfork);
> +		if (error)
> +			return error;
>  	}
> -	/*
> -	 * Otherwise *last_block is already the right answer.
> -	 */
> +
> +	if (xfs_iext_lookup_extent(ip, ifp, *last_block - 1, &idx, &got)) {
> +		if (got.br_startoff <= *last_block - 1)
> +			return 0;
> +	}
> +
> +	if (xfs_iext_get_extent(ifp, idx - 1, &got)) {

It may not be an issue in current usage, but I think we should check for
idx here (i.e., 'if (idx && xfs_iext_get_extent(..))').

Brian

> +		*last_block = got.br_startoff + got.br_blockcount;
> +		return 0;
> +	}
> +
> +	*last_block = 0;
>  	return 0;
>  }
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
