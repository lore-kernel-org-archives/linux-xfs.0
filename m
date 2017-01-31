Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56640 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdAaEMY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 23:12:24 -0500
Subject: Re: [PATCH 2/7] xfs: fail _dir_open when readahead fails
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219640.12293.12536546233357325085.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7a5ce10b-ea0b-11e2-1ed9-5abdfdfc6d3d@sandeen.net>
Date: Mon, 30 Jan 2017 22:12:18 -0600
MIME-Version: 1.0
In-Reply-To: <148582219640.12293.12536546233357325085.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/30/17 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we open a directory, we try to readahead block 0 of the directory
> on the assumption that we're going to need it soon.  If the bmbt is
> corrupt, the directory will never be usable and the readahead fails
> immediately, so we might as well prevent the directory from being opened
> at all.  This prevents a subsequent read or modify operation from
> hitting it and taking the fs offline.

Seems fine.  I did want to make sure I understood the error returns
from xfs_dabuf_map w.r.t. mappedbno & holes etc, but it looks ok.

xfs_da_reada_buf return type & meaning changes but nobody looks
at it until now...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c |    6 ++----
>  fs/xfs/libxfs/xfs_da_btree.h |    2 +-
>  fs/xfs/xfs_file.c            |    4 ++--
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index f2dc1a9..1bdf288 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2633,7 +2633,7 @@ xfs_da_read_buf(
>  /*
>   * Readahead the dir/attr block.
>   */
> -xfs_daddr_t
> +int
>  xfs_da_reada_buf(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> @@ -2664,7 +2664,5 @@ xfs_da_reada_buf(
>  	if (mapp != &map)
>  		kmem_free(mapp);
>  
> -	if (error)
> -		return -1;
> -	return mappedbno;
> +	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 98c75cb..4e29cb6 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -201,7 +201,7 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
>  			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
>  			       struct xfs_buf **bpp, int whichfork,
>  			       const struct xfs_buf_ops *ops);
> -xfs_daddr_t	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
> +int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
>  				xfs_daddr_t mapped_bno, int whichfork,
>  				const struct xfs_buf_ops *ops);
>  int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index bbb9eb6..4c87e60f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -908,9 +908,9 @@ xfs_dir_open(
>  	 */
>  	mode = xfs_ilock_data_map_shared(ip);
>  	if (ip->i_d.di_nextents > 0)
> -		xfs_dir3_data_readahead(ip, 0, -1);
> +		error = xfs_dir3_data_readahead(ip, 0, -1);
>  	xfs_iunlock(ip, mode);
> -	return 0;
> +	return error;
>  }
>  
>  STATIC int
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
