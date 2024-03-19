Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807DB381CC
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710872182; cv=none; b=YGJSlRVgPX8y3nO59YCmz8wib2AG+vL0kfu6eQ/c4k7oDGofXVfsaMdfzBJi+O+/qZPdnK8kakC13E9dKU54cCbZz6ysM9n4597xiMnfgbU5Vj9gyUj+rjUa+JYMs6hWBTjhn2seTh3PLX5VStixMfXtjogY287+ucNMDcSLuWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710872182; c=relaxed/simple;
	bh=raeLtgwu9/Ue6uCLe1soUDPUFQ7bhTasT63KJW9QeOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0IIafsk3dibv9zEpbVLsKLjrhNLZ/AN3PTjweKKjfoOn1KqalRbfgl2m6/PP+NGi/nOad0TSfhCsmIYIfCRjTcvICWSpjyHnItMJkUOHm+d6gGIb50Y8We1+DS6MnV5FETwALhmy08yJqawLZd0Xr5V6dbyFqR5WSM4uGEG3hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeBmDeSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeBmDeSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474A3C433F1;
	Tue, 19 Mar 2024 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710872182;
	bh=raeLtgwu9/Ue6uCLe1soUDPUFQ7bhTasT63KJW9QeOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MeBmDeSLk7C6qu6emeuKZ15RAXx+24STrfJLLoJclR2JZTXks16gKNyZUb4ch57tJ
	 LY/wf873Gih4qL56NiZvQ7wRIsRUG5NwMcTSh0yCy1qCbFeIWuKg8OneLjvQPuHj8T
	 7gpiVXzO632ZrTWRhiXsk2S/eJ43LreYVO48eVCwAvJJNaDUYJlLJXjsPVLhKag/hi
	 bxgyfwLKNYHz7xXl2A9w5k7Wnanq1M190FLxGOjdNxMLJVcF5+Q9HV0VK18AOZUe2e
	 bvEE3yOYTix0l8jBqVtt3KGBNnCIOLCzBW75i24Gpl34Yb/Pxjsy5Ymi0d4mRvKRp9
	 T7o6B6WS54Mvg==
Date: Tue, 19 Mar 2024 11:16:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: buffer log item type mismatches are corruption
Message-ID: <20240319181621.GB1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-2-david@fromorbit.com>

On Tue, Mar 19, 2024 at 01:15:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We detect when a buffer log format type and the magic number in the
> buffer do not match. We issue a warning, but do not return an error
> nor do we write back the recovered buffer. If no further recover
> action is performed on that buffer, then recovery has left the
> buffer in an inconsistent (out of date) state on disk. i.e. the
> structure is corrupt on disk.
> 
> If this mismatch occurs, return a -EFSCORRUPTED error and cause
> recovery to abort instead of letting recovery corrupt the filesystem
> and continue onwards.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 51 +++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index d74bf7bb7794..dba57ee6fa6d 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -207,7 +207,7 @@ xlog_recover_buf_commit_pass1(
>   *	the first 32 bits of the buffer (most blocks),
>   *	inside a struct xfs_da_blkinfo at the start of the buffer.
>   */
> -static void
> +static int
>  xlog_recover_validate_buf_type(
>  	struct xfs_mount		*mp,
>  	struct xfs_buf			*bp,
> @@ -407,11 +407,12 @@ xlog_recover_validate_buf_type(
>  	 * skipped.
>  	 */
>  	if (current_lsn == NULLCOMMITLSN)
> -		return;
> +		return 0;;

Unnecessary double-semicolon.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  
>  	if (warnmsg) {
>  		xfs_warn(mp, warnmsg);
> -		ASSERT(0);
> +		xfs_buf_corruption_error(bp, __this_address);
> +		return -EFSCORRUPTED;
>  	}
>  
>  	/*
> @@ -425,14 +426,11 @@ xlog_recover_validate_buf_type(
>  	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
>  	 * the verifier.
>  	 */
> -	if (bp->b_ops) {
> -		struct xfs_buf_log_item	*bip;
> -
> -		bp->b_flags |= _XBF_LOGRECOVERY;
> -		xfs_buf_item_init(bp, mp);
> -		bip = bp->b_log_item;
> -		bip->bli_item.li_lsn = current_lsn;
> -	}
> +	ASSERT(bp->b_ops);
> +	bp->b_flags |= _XBF_LOGRECOVERY;
> +	xfs_buf_item_init(bp, mp);
> +	bp->b_log_item->bli_item.li_lsn = current_lsn;
> +	return 0;
>  }
>  
>  /*
> @@ -441,7 +439,7 @@ xlog_recover_validate_buf_type(
>   * given buffer.  The bitmap in the buf log format structure indicates
>   * where to place the logged data.
>   */
> -STATIC void
> +static int
>  xlog_recover_do_reg_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog_recover_item	*item,
> @@ -523,20 +521,20 @@ xlog_recover_do_reg_buffer(
>  	/* Shouldn't be any more regions */
>  	ASSERT(i == item->ri_total);
>  
> -	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
> +	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
>  }
>  
>  /*
> - * Perform a dquot buffer recovery.
> + * Test if this dquot buffer item should be recovered.
>   * Simple algorithm: if we have found a QUOTAOFF log item of the same type
>   * (ie. USR or GRP), then just toss this buffer away; don't recover it.
>   * Else, treat it as a regular buffer and do recovery.
>   *
> - * Return false if the buffer was tossed and true if we recovered the buffer to
> - * indicate to the caller if the buffer needs writing.
> + * Return false if the buffer should be tossed and true if the buffer needs
> + * to be recovered.
>   */
> -STATIC bool
> -xlog_recover_do_dquot_buffer(
> +static bool
> +xlog_recover_this_dquot_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog			*log,
>  	struct xlog_recover_item	*item,
> @@ -565,8 +563,6 @@ xlog_recover_do_dquot_buffer(
>  	 */
>  	if (log->l_quotaoffs_flag & type)
>  		return false;
> -
> -	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
>  	return true;
>  }
>  
> @@ -952,18 +948,19 @@ xlog_recover_buf_commit_pass2(
>  
>  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
>  		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
> -		if (error)
> -			goto out_release;
>  	} else if (buf_f->blf_flags &
>  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> -		bool	dirty;
> -
> -		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> -		if (!dirty)
> +		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
>  			goto out_release;
> +
> +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> +				NULLCOMMITLSN);
>  	} else {
> -		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> +				current_lsn);
>  	}
> +	if (error)
> +		goto out_release;
>  
>  	/*
>  	 * Perform delayed write on the buffer.  Asynchronous writes will be
> -- 
> 2.43.0
> 
> 
