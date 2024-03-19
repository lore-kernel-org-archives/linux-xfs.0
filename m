Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747E3CF4F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880767; cv=none; b=dGT6B10IPFDm3FKu6+QuL/8IcCcLzvPEWAq+xZwdBJ7GtDU+Mn5zT8REq9FxN5McEkqjEG08aRjehEEE3w0y+/auRFv1NijhKpkbe04sl9cRcXwpxIZPU/wnXHGAtn4XEqLQAWWjomaJUuWww1Gxho7QW2CBHxmT/VIP1XxrnEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880767; c=relaxed/simple;
	bh=U7kGLFTKyHWvTihyS/3ta1qqIRdbs1QUY8QSlm50om8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=La5HvWsoPYZO3WNGVdtVGSrH2rXF0GtgJ23nFbuH/1s7V1v4mTZREN/zWik3E+rU8l+0/G+AEHazlvEwdpvc4un4XOCZ9IL9BjriejJZhojL0cKWcNLTSR6ckpPx3i1nnjyHjkfycsHD9NLru8t2/3/Gw7qtQ8zIeZ37CfApqOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPVvQwYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPVvQwYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4EAC433C7;
	Tue, 19 Mar 2024 20:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710880766;
	bh=U7kGLFTKyHWvTihyS/3ta1qqIRdbs1QUY8QSlm50om8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lPVvQwYK6nqsIRW1YwQCzO5lE6qUaZZFLjU/xiV5f/nc1kPHmF1QNiW3DN4K9/6ij
	 f2YvLkB/lEnfSUtVGx5DAKNYJXf0ZRG4dam9n2IF/O7s25zPpUfnkDuf3GxpSQr5rX
	 DedJ/TkWF9z5p25+KiIMuhFI78EnZ+HDdVk1QjPhsyurll7hIMXFJLLSbI6l+eeonf
	 8YEJbr+m55Ax3a+0p61HA8Gg+gSl8RgxpB+d9JdkeAMzRFUXssXJeH6nSDNgslMElD
	 jNqGZlmTTYtJpMAzNFw9ojgXPovPo0DfWlEag8KmqZf81DoNV1wWuwuyk0Y0z8UYdz
	 E7k7KkzWsGMUw==
Date: Tue, 19 Mar 2024 13:39:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: detect partial buffer recovery operations
Message-ID: <20240319203925.GE1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-5-david@fromorbit.com>

On Tue, Mar 19, 2024 at 01:15:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a compound buffer is logged (e.g. fragmented large directory
> block) we record it in the log as a series of separate buffer log
> format items in the journal. These get recovered individually, and
> because they are for non-contiguous extent ranges, we cannot use
> buffer addresses to detect that the buffer format items are from the
> same directory block.
> 
> Further, we cannot use LSN checks to determine if the partial
> block buffers should be recovered - apart from the first buffer we
> don't have a header with an LSN in it to check.
> 
> Finally, we cannot add a verifier to a partial block buffer because,
> again, it will fail the verifier checks and report corruption. We
> already skip this step due to bad magic number detection, but we
> should be able to do better here.
> 
> The one thing we can rely on, though, is that each buffer format
> item is written consecutively in the journal. They are built at
> commit time into a single log iovec and chained into the iclog write
> log vector chain as an unbroken sequence. Hence all the parts of a
> compound buffer should be consecutive buf log format items in the
> transaction being recovered.
> 
> Unfortunately, we don't have the information available in recovery
> to do a full compound buffer instantiation for recovery. We only
> have the fragments that contained modifications in the journal, and
> so there may be missing fragments that are still clean and hence are
> not in the journal. Hence we cannot use journal state to rebuild the
> compound buffer entirely and hence recover it as a complete entity
> and run a verifier over it before writeback.
> 
> Hence the first thing we need to do is detect such partial buffer
> recovery situations and track whether we need to skip all the
> partial buffers due to the LSN check in the initial header fragment
> read from disk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 178 +++++++++++++++++++++++++++-------
>  1 file changed, 143 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 90740fcf2fbe..9225baa62755 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -434,18 +434,17 @@ xlog_recover_validate_buf_type(
>  }
>  
>  /*
> - * Perform a 'normal' buffer recovery.  Each logged region of the
> + * Perform recovery of the logged regions. Each logged region of the
>   * buffer should be copied over the corresponding region in the
>   * given buffer.  The bitmap in the buf log format structure indicates
>   * where to place the logged data.
>   */
> -static int
> -xlog_recover_do_reg_buffer(
> +static void
> +xlog_recover_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
> -	struct xfs_buf_log_format	*buf_f,
> -	xfs_lsn_t			current_lsn)
> +	struct xfs_buf_log_format	*buf_f)
>  {
>  	int			i;
>  	int			bit;
> @@ -489,7 +488,17 @@ xlog_recover_do_reg_buffer(
>  
>  	/* Shouldn't be any more regions */
>  	ASSERT(i == item->ri_total);
> +}
>  
> +static int
> +xlog_recover_do_reg_buffer(
> +	struct xfs_mount		*mp,
> +	struct xlog_recover_item	*item,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f,
> +	xfs_lsn_t			current_lsn)
> +{
> +	xlog_recover_buffer(mp, item, bp, buf_f);
>  	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
>  }
>  
> @@ -735,6 +744,67 @@ xlog_recover_do_inode_buffer(
>  	return 0;
>  }
>  
> +static bool
> +xlog_recovery_is_dir_buf(
> +	struct xfs_buf_log_format	*buf_f)
> +{
> +	switch (xfs_blft_from_flags(buf_f)) {

/me wonders if the argument to xlog_recovery_is_dir_buf and
xfs_blft_from_flags ought to be switched to (const xfs_buf_log_format *).

> +	case XFS_BLFT_DIR_BLOCK_BUF:
> +	case XFS_BLFT_DIR_DATA_BUF:
> +	case XFS_BLFT_DIR_FREE_BUF:
> +	case XFS_BLFT_DIR_LEAF1_BUF:
> +	case XFS_BLFT_DIR_LEAFN_BUF:
> +	case XFS_BLFT_DA_NODE_BUF:
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;
> +}
> +
> +/*
> + * Partial dabuf recovery.
> + *
> + * There are two main cases here - a buffer that contains the dabuf header and
> + * hence can be magic number and LSN checked, and then everything else.
> + *
> + * We can determine if the former should be replayed or not via LSN checks, but
> + * we cannot do that with the latter, so the only choice we have here is to
> + * always recover the changes regardless of whether this means metadata on disk
> + * will go backwards in time. This, at least, means that the changes in each
> + * checkpoint are applied consistently to the dabuf and we don't do really
> + * stupid things like skip the header fragment replay and then replay all the
> + * other changes to the dabuf block.
> + *
> + * While this is not ideal, finishing log recovery should them replay all the
> + * remaining changes across this buffer and so bring it back to being consistent
> + * on disk at the completion of recovery. Hence this "going backwards in time"
> + * situation will only be relevant to failed journal replay situations. These
> + * are rare and will require xfs_repair to be run, anyway, so the inconsistency
> + * that results will be corrected before the filesystem goes back into service,
> + * anyway.

Does this means that all fragments of logged discontig dabufs will be
replayed fully?  IOWs, no skipping ahead based on LSNs like we do for
everything else (except the rtbitmap/rtsummary blocks)?

> + *
> + * Important: This partial fragment recovery relies on log recovery purging the
> + * buffer cache after completion of this recovery phase. These partial buffers
> + * are never used at runtime (discontiguous buffers will be used instead), so
> + * they must be removed from the buffer cache to prevent them from causing
> + * overlapping range lookup failures for the entire dabuf range.

Should the comment about the xfs_buftarg_drain call in
xfs_log_mount_finish gain a comment about needing to do this for
consistency of discontig directory blocks?

Also, do we have an easy way to fault-inject discontig directory blocks?

> + */
> +static void
> +xlog_recover_do_partial_dabuf(
> +	struct xfs_mount		*mp,
> +	struct xlog_recover_item	*item,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f)
> +{
> +	/*
> +	 * Always recover without verification or write verifiers. Use delwri
> +	 * and rely on post pass2 recovery cache purge to clean these out of
> +	 * memory.
> +	 */
> +	xlog_recover_buffer(mp, item, bp, buf_f);
> +}
> +
>  /*
>   * V5 filesystems know the age of the buffer on disk being recovered. We can
>   * have newer objects on disk than we are replaying, and so for these cases we
> @@ -886,6 +956,54 @@ xlog_recover_get_buf_lsn(
>  
>  }
>  
> +/*
> + * Recover the buffer only if we get an LSN from it and it's less than the lsn
> + * of the transaction we are replaying.
> + *
> + * Note that we have to be extremely careful of readahead here.  Readahead does
> + * not attach verfiers to the buffers so if we don't actually do any replay

                 verifiers

> + * after readahead because of the LSN we found in the buffer if more recent than

                                                                is more

> + * that current transaction then we need to attach the verifier directly.
> + * Failure to do so can lead to future recovery actions (e.g. EFI and unlinked
> + * list recovery) can operate on the buffers and they won't get the verifier

This sentence reads awkwardly to me.  How about

"Failure to do so can lead to future recovery actions (e.g. EFI and
unlinked list recovery) operating on the buffers without attaching a
verifier."

Also, does 'unlinked' refer to unlinked inode processing?

> + * attached. This can lead to blocks on disk having the correct content but a
> + * stale CRC.
> + *
> + * It is safe to assume these clean buffers are currently up to date.  If the
> + * buffer is dirtied by a later transaction being replayed, then the verifier
> + * will be reset to match whatever recover turns that buffer into.
> + *
> + * Return true if the buffer needs to be recovered, false if it doesn't.
> + */
> +static bool
> +xlog_recover_this_buffer(

I kinda wish this function returned either 0 for "recovery not needed",
1 for "recovery needed", or a negative errno for corruption.  Then the
call site looks a little more regular:

	error = xlog_recover_this_buffer(...);
	if (error)
		goto out_release;

Except for the 'return 1' behavior.  If you were thinking about that
already then go ahead and change it; if not, then leave it.

> +	struct xfs_mount		*mp,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f,
> +	xfs_lsn_t			current_lsn)
> +{
> +	xfs_lsn_t			lsn;
> +
> +	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
> +	if (!lsn)
> +		return true;
> +	if (lsn == -1)
> +		return true;
> +	if (XFS_LSN_CMP(lsn, current_lsn) < 0)
> +		return true;
> +
> +	trace_xfs_log_recover_buf_skip(mp->m_log, buf_f);
> +	xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> +
> +	/*
> +	 * We're skipping replay of this buffer log item due to the log
> +	 * item LSN being behind the ondisk buffer.  Verify the buffer
> +	 * contents since we aren't going to run the write verifier.
> +	 */
> +	if (bp->b_ops)
> +		bp->b_ops->verify_read(bp);
> +	return false;
> +}
>  /*
>   * This routine replays a modification made to a buffer at runtime.
>   * There are actually two types of buffer, regular and inode, which
> @@ -920,7 +1038,6 @@ xlog_recover_buf_commit_pass2(
>  	struct xfs_mount		*mp = log->l_mp;
>  	struct xfs_buf			*bp;
>  	int				error;
> -	xfs_lsn_t			lsn;
>  
>  	/*
>  	 * In this pass we only want to recover all the buffers which have
> @@ -962,7 +1079,8 @@ xlog_recover_buf_commit_pass2(
>  		if (error)
>  			goto out_release;
>  
> -		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> +		xlog_recover_buffer(mp, item, bp, buf_f);
> +		error = xlog_recover_validate_buf_type(mp, bp, buf_f,
>  				NULLCOMMITLSN);
>  		if (error)
>  			goto out_release;
> @@ -970,41 +1088,31 @@ xlog_recover_buf_commit_pass2(
>  	}
>  
>  	/*
> -	 * Recover the buffer only if we get an LSN from it and it's less than
> -	 * the lsn of the transaction we are replaying.
> -	 *
> -	 * Note that we have to be extremely careful of readahead here.
> -	 * Readahead does not attach verfiers to the buffers so if we don't
> -	 * actually do any replay after readahead because of the LSN we found
> -	 * in the buffer if more recent than that current transaction then we
> -	 * need to attach the verifier directly. Failure to do so can lead to
> -	 * future recovery actions (e.g. EFI and unlinked list recovery) can
> -	 * operate on the buffers and they won't get the verifier attached. This
> -	 * can lead to blocks on disk having the correct content but a stale
> -	 * CRC.
> -	 *
> -	 * It is safe to assume these clean buffers are currently up to date.
> -	 * If the buffer is dirtied by a later transaction being replayed, then
> -	 * the verifier will be reset to match whatever recover turns that
> -	 * buffer into.
> +	 * Directory buffers can be larger than a single filesystem block and
> +	 * if they are they can be fragmented. There are lots of concerns about
> +	 * recovering these, so push them out of line where the concerns can be
> +	 * documented clearly.
>  	 */
> -	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
> -	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> -		trace_xfs_log_recover_buf_skip(log, buf_f);
> -		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> +	if (xlog_recovery_is_dir_buf(buf_f) &&
> +	    mp->m_dir_geo->blksize != BBTOB(buf_f->blf_len)) {
> +		xlog_recover_do_partial_dabuf(mp, item, bp, buf_f);
> +		goto out_write;
> +	}
>  
> +	/*
> +	 * Whole buffer recovery, dependent on the LSN in the on-disk structure.
> +	 */
> +	if (!xlog_recover_this_buffer(mp, bp, buf_f, current_lsn)) {
>  		/*
> -		 * We're skipping replay of this buffer log item due to the log
> -		 * item LSN being behind the ondisk buffer.  Verify the buffer
> -		 * contents since we aren't going to run the write verifier.
> +		 * We may have verified this buffer even though we aren't
> +		 * recovering it. Return the verifier error for early detection
> +		 * of recovery inconsistencies.
>  		 */
> -		if (bp->b_ops) {
> -			bp->b_ops->verify_read(bp);
> -			error = bp->b_error;
> -		}
> +		error = bp->b_error;
>  		goto out_release;
>  	}
>  
> +

Extra blank line.

--D

>  	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	if (error)
>  		goto out_release;
> -- 
> 2.43.0
> 
> 
