Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D573539FC1
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710873602; cv=none; b=T3KtGW/m+Ra63ZBizD9tV/LKPg4szBNytbdfPc5o7vM5RSVGtmQdfk/KoxNOftx8QPYckU9gvg9BLnUSesauXyn+IngxCbclYrPP+glez7KlNCs6vnkIGWJf6LIvJlX+6zgWx8NhNAeXyqlsdKsLzn7lO8N67dmHF3VquAiIMQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710873602; c=relaxed/simple;
	bh=E9Li3Lruqt7L60M83fSydUyLomOYR9lci6sNMHBEYIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qhf+i1ZNB0K6BZRTQ4KAVXxrzW3pVoG87txt0Z/+7tgoEuYkoDw9RInt362r6hwDspxrlrUSR0N6LAGU9kmgRThvilg/xJBObUFUb1nF0QiBVR7yxK9cstZlRgbbczKyimjoKeB4+tZHjfJftAgCNnljV8CO7zqZ5vcZ6OGzWBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SybZ6LpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SybZ6LpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612D5C433C7;
	Tue, 19 Mar 2024 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710873602;
	bh=E9Li3Lruqt7L60M83fSydUyLomOYR9lci6sNMHBEYIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SybZ6LpQEbux67OJuDShVa+Pr6O5AxzgZadFpLh52dOvRZq+cT1ROBHTdj1mi6T2M
	 OtaxhGGZdzCYDfWwh55OfHnwWk4B5qUxWTPMikAJlQao6DEy87rZzDY/K3Yn9mYpb9
	 7cWTb1ppIqRiA6HCLzbbL9ZwoeAiYT2fzLGzkSSRsVdzGXA3HspQJiHbIgVDC+J3zZ
	 mrXspTzLvNwWkC74gUxtdZQYCzsa2OBC6yLmJWUJ3fSfCTMKY1drZPtGZ5k4eIhxkY
	 QE98xmAu9ilcBuVweBZPQ8srjwwuGEcBdJiZ33TflbglkC7LYfBOg8hMaZR8msiCCk
	 JRTAgB72o3mfA==
Date: Tue, 19 Mar 2024 11:40:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate out inode buffer recovery a bit more
Message-ID: <20240319184001.GC1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-3-david@fromorbit.com>

On Tue, Mar 19, 2024 at 01:15:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It really is a unique snowflake, so peal off from normal buffer
> recovery earlier and shuffle all the unique bits into the inode
> buffer recovery function.
> 
> Also, it looks like the handling of mismatched inode cluster buffer
> sizes is wrong - we have to write the recovered buffer -before- we
> mark it stale as we're not supposed to write stale buffers. I don't
> think we check that anywhere in the buffer IO path, but lets do it
> the right way anyway.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item_recover.c | 99 ++++++++++++++++++++++-------------
>  1 file changed, 63 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index dba57ee6fa6d..f994a303ad0a 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -229,7 +229,7 @@ xlog_recover_validate_buf_type(
>  	 * just avoid the verification stage for non-crc filesystems
>  	 */
>  	if (!xfs_has_crc(mp))
> -		return;
> +		return 0;
>  
>  	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
>  	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
> @@ -407,7 +407,7 @@ xlog_recover_validate_buf_type(
>  	 * skipped.
>  	 */
>  	if (current_lsn == NULLCOMMITLSN)
> -		return 0;;
> +		return 0;
>  
>  	if (warnmsg) {
>  		xfs_warn(mp, warnmsg);
> @@ -567,18 +567,22 @@ xlog_recover_this_dquot_buffer(
>  }
>  
>  /*
> - * Perform recovery for a buffer full of inodes.  In these buffers, the only
> - * data which should be recovered is that which corresponds to the
> - * di_next_unlinked pointers in the on disk inode structures.  The rest of the
> - * data for the inodes is always logged through the inodes themselves rather
> - * than the inode buffer and is recovered in xlog_recover_inode_pass2().
> + * Perform recovery for a buffer full of inodes. We don't have inode cluster
> + * buffer specific LSNs, so we always recover inode buffers if they contain
> + * inodes.
> + *
> + * In these buffers, the only inode data which should be recovered is that which
> + * corresponds to the di_next_unlinked pointers in the on disk inode structures.
> + * The rest of the data for the inodes is always logged through the inodes
> + * themselves rather than the inode buffer and is recovered in
> + * xlog_recover_inode_pass2().
>   *
>   * The only time when buffers full of inodes are fully recovered is when the
> - * buffer is full of newly allocated inodes.  In this case the buffer will
> - * not be marked as an inode buffer and so will be sent to
> - * xlog_recover_do_reg_buffer() below during recovery.
> + * buffer is full of newly allocated inodes.  In this case the buffer will not
> + * be marked as an inode buffer and so xlog_recover_do_reg_buffer() will be used
> + * instead.
>   */
> -STATIC int
> +static int
>  xlog_recover_do_inode_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog_recover_item	*item,
> @@ -598,6 +602,13 @@ xlog_recover_do_inode_buffer(
>  
>  	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
>  
> +	/*
> +	 * If the magic number doesn't match, something has gone wrong. Don't
> +	 * recover the buffer.
> +	 */
> +	if (cpu_to_be16(XFS_DINODE_MAGIC) != *((__be16 *)bp->b_addr))
> +		return -EFSCORRUPTED;
> +
>  	/*
>  	 * Post recovery validation only works properly on CRC enabled
>  	 * filesystems.
> @@ -677,6 +688,31 @@ xlog_recover_do_inode_buffer(
>  
>  	}
>  
> +	/*
> +	 * Make sure that only inode buffers with good sizes remain valid after
> +	 * recovering this buffer item.
> +	 *
> +	 * The kernel moves inodes in buffers of 1 block or inode_cluster_size
> +	 * bytes, whichever is bigger.  The inode buffers in the log can be a
> +	 * different size if the log was generated by an older kernel using
> +	 * unclustered inode buffers or a newer kernel running with a different
> +	 * inode cluster size.  Regardless, if the inode buffer size isn't
> +	 * max(blocksize, inode_cluster_size) for *our* value of
> +	 * inode_cluster_size, then we need to keep the buffer out of the buffer
> +	 * cache so that the buffer won't overlap with future reads of those
> +	 * inodes.
> +	 *
> +	 * To acheive this, we write the buffer ito recover the inodes then mark
> +	 * it stale so that it won't be found on overlapping buffer lookups and
> +	 * caller knows not to queue it for delayed write.
> +	 */
> +	if (BBTOB(bp->b_length) != M_IGEO(mp)->inode_cluster_size) {
> +		int error;
> +
> +		error = xfs_bwrite(bp);
> +		xfs_buf_stale(bp);
> +		return error;
> +	}
>  	return 0;
>  }
>  
> @@ -840,7 +876,6 @@ xlog_recover_get_buf_lsn(
>  	magic16 = be16_to_cpu(*(__be16 *)blk);
>  	switch (magic16) {
>  	case XFS_DQUOT_MAGIC:
> -	case XFS_DINODE_MAGIC:
>  		goto recover_immediately;
>  	default:
>  		break;
> @@ -910,6 +945,17 @@ xlog_recover_buf_commit_pass2(
>  	if (error)
>  		return error;
>  
> +	/*
> +	 * Inode buffer recovery is quite unique, so go out separate ways here
> +	 * to simplify the rest of the code.
> +	 */
> +	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
> +		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
> +		if (error || (bp->b_flags & XBF_STALE))
> +			goto out_release;
> +		goto out_write;
> +	}
> +
>  	/*
>  	 * Recover the buffer only if we get an LSN from it and it's less than
>  	 * the lsn of the transaction we are replaying.
> @@ -946,9 +992,7 @@ xlog_recover_buf_commit_pass2(
>  		goto out_release;
>  	}
>  
> -	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
> -		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
> -	} else if (buf_f->blf_flags &
> +	if (buf_f->blf_flags &
>  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
>  		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
>  			goto out_release;
> @@ -965,28 +1009,11 @@ xlog_recover_buf_commit_pass2(
>  	/*
>  	 * Perform delayed write on the buffer.  Asynchronous writes will be
>  	 * slower when taking into account all the buffers to be flushed.
> -	 *
> -	 * Also make sure that only inode buffers with good sizes stay in
> -	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
> -	 * or inode_cluster_size bytes, whichever is bigger.  The inode
> -	 * buffers in the log can be a different size if the log was generated
> -	 * by an older kernel using unclustered inode buffers or a newer kernel
> -	 * running with a different inode cluster size.  Regardless, if
> -	 * the inode buffer size isn't max(blocksize, inode_cluster_size)
> -	 * for *our* value of inode_cluster_size, then we need to keep
> -	 * the buffer out of the buffer cache so that the buffer won't
> -	 * overlap with future reads of those inodes.
>  	 */
> -	if (XFS_DINODE_MAGIC ==
> -	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
> -	    (BBTOB(bp->b_length) != M_IGEO(log->l_mp)->inode_cluster_size)) {
> -		xfs_buf_stale(bp);
> -		error = xfs_bwrite(bp);
> -	} else {
> -		ASSERT(bp->b_mount == mp);
> -		bp->b_flags |= _XBF_LOGRECOVERY;
> -		xfs_buf_delwri_queue(bp, buffer_list);
> -	}
> +out_write:
> +	ASSERT(bp->b_mount == mp);
> +	bp->b_flags |= _XBF_LOGRECOVERY;
> +	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
>  	xfs_buf_relse(bp);
> -- 
> 2.43.0
> 
> 
