Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54D307F55
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:32:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28AFF8F8064
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id edoT6QT1LEDCDCwy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:31 -0800 (PST)
Date: Thu, 14 Jan 2016 12:32:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: move buffer invalidation to xfs_btree_free_block
Message-ID: <20160114173228.GC11448@bfoster.bfoster>
References: <1452707454-15229-1-git-send-email-hch@lst.de>
	<1452707454-15229-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452707454-15229-4-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 06:50:54PM +0100, Christoph Hellwig wrote:
> ... instead of leaving it in the methods.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc_btree.c  |  2 --
>  fs/xfs/libxfs/xfs_bmap_btree.c   |  1 -
>  fs/xfs/libxfs/xfs_btree.c        |  4 +++-
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 12 ++----------
>  4 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 444626d..d9b42425 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -118,8 +118,6 @@ xfs_allocbt_free_block(
>  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> -
> -	xfs_trans_binval(cur->bc_tp, bp);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 1637c37..e37508a 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -531,7 +531,6 @@ xfs_bmbt_free_block(
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> -	xfs_trans_binval(tp, bp);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 77afb4a..1f88e1c 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -302,8 +302,10 @@ xfs_btree_free_block(
>  	int			error;
>  
>  	error = cur->bc_ops->free_block(cur, bp);
> -	if (!error)
> +	if (!error) {
> +		xfs_trans_binval(cur->bc_tp, bp);
>  		XFS_BTREE_STATS_INC(cur, free);
> +	}
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index c679f3c..89c21d7 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -125,16 +125,8 @@ xfs_inobt_free_block(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_buf		*bp)
>  {
> -	xfs_fsblock_t		fsbno;
> -	int			error;
> -
> -	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
> -	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
> -	if (error)
> -		return error;
> -
> -	xfs_trans_binval(cur->bc_tp, bp);
> -	return error;
> +	return xfs_free_extent(cur->bc_tp,
> +			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
>  }
>  
>  STATIC int
> -- 
> 1.9.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
