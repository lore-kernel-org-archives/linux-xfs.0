Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbeELAjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 20:39:16 -0400
Date: Fri, 11 May 2018 17:39:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/10] xfs: convert growfs AG header init to use buffer
 lists
Message-ID: <20180512003912.GP11261@magnolia>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511225107.27171-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 12, 2018 at 08:51:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently write all new AG headers synchronously, which can be
> slow for large grow operations. All we really need to do is ensure
> all the headers are on disk before we run the growfs transaction, so
> convert this to a buffer list and a delayed write operation. We
> block waiting for the delayed write buffer submission to complete,
> so this will fulfill the requirement to have all the buffers written
> correctly before proceeding.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 391d1938a6c8..4b560caaf397 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -81,7 +81,8 @@ xfs_grow_ag_headers(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
>  	xfs_extlen_t		agsize,
> -	xfs_rfsblock_t		*nfree)
> +	xfs_rfsblock_t		*nfree,
> +	struct list_head	*buffer_list)
>  {
>  	struct xfs_agf		*agf;
>  	struct xfs_agi		*agi;
> @@ -135,11 +136,8 @@ xfs_grow_ag_headers(
>  		agf->agf_refcount_level = cpu_to_be32(1);
>  		agf->agf_refcount_blocks = cpu_to_be32(1);
>  	}
> -
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/*
>  	 * AG freelist header block
> @@ -164,10 +162,8 @@ xfs_grow_ag_headers(
>  	for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
>  		agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
>  
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/*
>  	 * AG inode header block
> @@ -201,10 +197,8 @@ xfs_grow_ag_headers(
>  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
>  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
>  
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/*
>  	 * BNO btree root block
> @@ -226,10 +220,8 @@ xfs_grow_ag_headers(
>  	arec->ar_blockcount = cpu_to_be32(
>  		agsize - be32_to_cpu(arec->ar_startblock));
>  
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/*
>  	 * CNT btree root block
> @@ -251,10 +243,8 @@ xfs_grow_ag_headers(
>  		agsize - be32_to_cpu(arec->ar_startblock));
>  	*nfree += be32_to_cpu(arec->ar_blockcount);
>  
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/* RMAP btree root block */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> @@ -326,10 +316,8 @@ xfs_grow_ag_headers(
>  			be16_add_cpu(&block->bb_numrecs, 1);
>  		}
>  
> -		error = xfs_bwrite(bp);
> +		xfs_buf_delwri_queue(bp, buffer_list);
>  		xfs_buf_relse(bp);
> -		if (error)
> -			goto out_error;
>  	}
>  
>  	/*
> @@ -345,11 +333,8 @@ xfs_grow_ag_headers(
>  	}
>  
>  	xfs_btree_init_block(mp, bp, XFS_BTNUM_INO , 0, 0, agno, 0);
> -
> -	error = xfs_bwrite(bp);
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
> -	if (error)
> -		goto out_error;
>  
>  	/*
>  	 * FINO btree root block
> @@ -364,13 +349,9 @@ xfs_grow_ag_headers(
>  			goto out_error;
>  		}
>  
> -		xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO,
> -					     0, 0, agno, 0);
> -
> -		error = xfs_bwrite(bp);
> +		xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO, 0, 0, agno, 0);
> +		xfs_buf_delwri_queue(bp, buffer_list);
>  		xfs_buf_relse(bp);
> -		if (error)
> -			goto out_error;
>  	}
>  
>  	/*
> @@ -386,13 +367,9 @@ xfs_grow_ag_headers(
>  			goto out_error;
>  		}
>  
> -		xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC,
> -				     0, 0, agno, 0);
> -
> -		error = xfs_bwrite(bp);
> +		xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC, 0, 0, agno, 0);
> +		xfs_buf_delwri_queue(bp, buffer_list);
>  		xfs_buf_relse(bp);
> -		if (error)
> -			goto out_error;
>  	}
>  
>  out_error:
> @@ -419,6 +396,7 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		oagcount;
>  	int			pct;
>  	xfs_trans_t		*tp;
> +	LIST_HEAD		(buffer_list);
>  
>  	nb = in->newblocks;
>  	pct = in->imaxpct;
> @@ -459,9 +437,16 @@ xfs_growfs_data_private(
>  		return error;
>  
>  	/*
> -	 * Write new AG headers to disk. Non-transactional, but written
> -	 * synchronously so they are completed prior to the growfs transaction
> -	 * being logged.
> +	 * Write new AG headers to disk. Non-transactional, but need to be
> +	 * written and completed prior to the growfs transaction being logged.
> +	 * To do this, we use a delayed write buffer list and wait for
> +	 * submission and IO completion of the list as a whole. This allows the
> +	 * IO subsystem to merge all the AG headers in a single AG into a single
> +	 * IO and hide most of the latency of the IO from us.
> +	 *
> +	 * This also means that if we get an error whilst building the buffer
> +	 * list to write, we can cancel the entire list without having written
> +	 * anything.
>  	 */
>  	nfree = 0;
>  	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
> @@ -472,10 +457,17 @@ xfs_growfs_data_private(
>  		else
>  			agsize = mp->m_sb.sb_agblocks;
>  
> -		error = xfs_grow_ag_headers(mp, agno, agsize, &nfree);
> -		if (error)
> +		error = xfs_grow_ag_headers(mp, agno, agsize, &nfree,
> +					    &buffer_list);
> +		if (error) {
> +			xfs_buf_delwri_cancel(&buffer_list);
>  			goto error0;
> +		}
>  	}
> +	error = xfs_buf_delwri_submit(&buffer_list);
> +	if (error)
> +		goto error0;
> +
>  	xfs_trans_agblocks_delta(tp, nfree);
>  
>  	/*
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
