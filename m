Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751879AbdIYLdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Sep 2017 07:33:22 -0400
Date: Mon, 25 Sep 2017 07:33:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: always swap the cow forks when swapping extents
Message-ID: <20170925113321.GB12869@bfoster.bfoster>
References: <20170923071208.GN5728@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923071208.GN5728@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sat, Sep 23, 2017 at 12:12:08AM -0700, Darrick J. Wong wrote:
> Since the CoW fork exists as a secondary data structure to the data
> fork, we must always swap cow forks during swapext.  We also need to
> swap the extent counts and reset the cowblocks tags.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c |   24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index bc6c6e1..e9db7fc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -2122,11 +2122,31 @@ xfs_swap_extents(
>  		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
>  		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>  		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
> +	}
> +
> +	/* Swap the cow forks. */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		xfs_extnum_t	extnum;
> +
> +		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
> +		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
> +
> +		extnum = ip->i_cnextents;
> +		ip->i_cnextents = tip->i_cnextents;
> +		tip->i_cnextents = extnum;
> +
>  		cowfp = ip->i_cowfp;
>  		ip->i_cowfp = tip->i_cowfp;
>  		tip->i_cowfp = cowfp;
> -		xfs_inode_set_cowblocks_tag(ip);
> -		xfs_inode_set_cowblocks_tag(tip);
> +
> +		if (ip->i_cowfp && ip->i_cnextents)
> +			xfs_inode_set_cowblocks_tag(ip);
> +		else
> +			xfs_inode_clear_cowblocks_tag(ip);
> +		if (tip->i_cowfp && tip->i_cnextents)
> +			xfs_inode_set_cowblocks_tag(tip);
> +		else
> +			xfs_inode_clear_cowblocks_tag(tip);
>  	}
>  
>  	xfs_trans_log_inode(tp, ip,  src_log_flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
