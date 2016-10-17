Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36524 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754759AbcJQSep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 14:34:45 -0400
Date: Mon, 17 Oct 2016 11:34:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/9] xfs: remove xfs_bunmapi_cow
Message-ID: <20161017183434.GM1120@birch.djwong.org>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-10-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-10-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Sat, Oct 15, 2016 at 10:52:34AM +0200, Christoph Hellwig wrote:
> Since no one uses it anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 22 ----------------------
>  fs/xfs/libxfs/xfs_bmap.h |  1 -
>  2 files changed, 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 64f82c8..cc193e6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5417,28 +5417,6 @@ xfs_bmap_del_extent(
>  	return error;
>  }
>  
> -/* Remove an extent from the CoW fork.  Similar to xfs_bmap_del_extent. */
> -int
> -xfs_bunmapi_cow(
> -	struct xfs_inode		*ip,
> -	struct xfs_bmbt_irec		*del)
> -{
> -	struct xfs_bmbt_rec_host	*ep;
> -	struct xfs_bmbt_irec		got;
> -	struct xfs_bmbt_irec		new;
> -	int				eof;
> -	xfs_extnum_t			eidx;
> -
> -	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
> -				&eidx, &got, &new);
> -	ASSERT(ep);
> -	if (isnullstartblock(got.br_startblock))
> -		xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &eidx, &got, del);
> -	else
> -		xfs_bmap_del_extent_cow(ip, &eidx, &got, del);
> -	return 0;
> -}
> -
>  /*
>   * Unmap (remove) blocks from a file.
>   * If nexts is nonzero then the number of extents to remove is limited to
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 5f18248..7cae6ec 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -223,7 +223,6 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
>  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
>  		struct xfs_defer_ops *dfops, int *done);
> -int	xfs_bunmapi_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *del);
>  int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		xfs_extnum_t *idx, struct xfs_bmbt_irec *got,
>  		struct xfs_bmbt_irec *del);
> -- 
> 2.1.4
> 
