Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbeLRVpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 16:45:23 -0500
Date: Tue, 18 Dec 2018 13:45:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/11] xfs: remove xfs_trim_extent_eof
Message-ID: <20181218214513.GM27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:53PM -0500, Christoph Hellwig wrote:
> Opencoding this function in the only caller makes it blindly obvious
> what is going on instead of having to look at two files for that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 11 -----------
>  fs/xfs/libxfs/xfs_bmap.h |  1 -
>  fs/xfs/xfs_aops.c        |  2 +-
>  3 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 19e921d1586f..f16d42abc500 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3685,17 +3685,6 @@ xfs_trim_extent(
>  	}
>  }
>  
> -/* trim extent to within eof */
> -void
> -xfs_trim_extent_eof(
> -	struct xfs_bmbt_irec	*irec,
> -	struct xfs_inode	*ip)
> -
> -{
> -	xfs_trim_extent(irec, 0, XFS_B_TO_FSB(ip->i_mount,
> -					      i_size_read(VFS_I(ip))));
> -}
> -
>  /*
>   * Trim the returned map to the required bounds
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 488dc8860fd7..f9a925caa70e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -181,7 +181,6 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
>  
>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
> -void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 338b9d9984e0..d7275075878e 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -329,7 +329,7 @@ xfs_map_blocks(
>  	 * mechanism to protect us from arbitrary extent modifying contexts, not
>  	 * just eofblocks.
>  	 */
> -	xfs_trim_extent_eof(&wpc->imap, ip);
> +	xfs_trim_extent(&wpc->imap, 0, XFS_B_TO_FSB(mp, i_size_read(inode)));
>  
>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
> -- 
> 2.19.1
> 
