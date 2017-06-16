Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39524 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753241AbdFPSND (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 14:13:03 -0400
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
References: <20170616175337.GE5421@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <351d0c66-4969-7ce9-da9c-6d2901e1bdef@sandeen.net>
Date: Fri, 16 Jun 2017 13:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <20170616175337.GE5421@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, list@jonas-server.de, David Shaw <dshaw@jabberwocky.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On 6/16/17 12:53 PM, Darrick J. Wong wrote:
> Hi all,
> 
> So I /think/ the xfs_attr_inactive crashes that both of you have been
> seeing are a result of XFS assuming that there aren't ever any mapping
> holes in the extended attribute fork and crashing when it tries to
> grab a buffer for the hole and fails to notice that holes don't have
> buffers.  This lightly tested patch gets rid of /that/ problem.
> 
> So, if you're willing, can you try this out and see if the crashes go
> away?  Granted, this might only enable us to lurch on whatever's next...

If it's unexpected, does that mean something else is wrong?  If so,
should there be a warning or a corrupted state, or anything like that?

-Eric

> --D
> 
> ---
> In quite a few places we call xfs_da_read_buf with a mappedbno that we
> don't control, then assume that the function passes back either an error
> code or a buffer pointer.  Unfortunately, if mappedbno == -2 and bno
> maps to a hole, we get a return code of zero and a NULL buffer, which
> means that we crash if we actually try to use that buffer pointer.  This
> happens immediately when we set the buffer type for transaction context.
> 
> Therefore, check that we have no error code and a non-NULL bp before
> trying to use bp.  This patch is a follow-up to an incomplete fix in
> 96a3aefb8ffde231 ("xfs: don't crash if reading a directory results in an
> unexpected hole").
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |    2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c |    2 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |    4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2852521..c6c15e5 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -351,7 +351,7 @@ xfs_attr3_leaf_read(
>  
>  	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
>  				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
> -	if (!err && tp)
> +	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
>  	return err;
>  }
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 356f21d..6d43358 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -263,7 +263,7 @@ xfs_da3_node_read(
>  
>  	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
>  					which_fork, &xfs_da3_node_buf_ops);
> -	if (!err && tp) {
> +	if (!err && tp && *bpp) {
>  		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
>  		int			type;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index aa17cb7..43c902f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -139,7 +139,7 @@ xfs_dir3_block_read(
>  
>  	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
>  				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
> -	if (!err && tp)
> +	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
>  	return err;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 7002024..27297a6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -268,7 +268,7 @@ xfs_dir3_leaf_read(
>  
>  	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
>  				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
> -	if (!err && tp)
> +	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
>  	return err;
>  }
> @@ -285,7 +285,7 @@ xfs_dir3_leafn_read(
>  
>  	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
>  				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
> -	if (!err && tp)
> +	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
>  	return err;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
