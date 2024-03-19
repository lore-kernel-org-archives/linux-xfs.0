Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DBA39FC6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710874200; cv=none; b=WNGdxGm9dhYoqW0PpdBden4IBAQEYT3jAGurgKS3sNxezb8nbm59sJ2hUQNroAHEwC2FUSsj3x/D0e6xGi4XYLkhuMgTU24Y2yn1c5vm4QtiodLkkbK0AxBBAACgK58l5zmCQH0VQtKmYd94NiI6FjcY7n/LvR3NZlK0LDlsn50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710874200; c=relaxed/simple;
	bh=V1Y0V04vFhSQnt0mi7B4dNnhanHlty43UunLqUTBgv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wygm4YN4sHozZTMF1CJNkJ5oWADEzjCSb12TMlSVf7rxe8kqTSdlRchWU2UKWevXTJlEGiI7kfA2omA9xV+4MKzAI4dTXEaA2GS1vVCI7Ym5M06Ut/1zzvp6vDhnTYRXStcbUYQX4bYhhFu/oThQg2nNReo6HFkuIPTYnhYCyKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuTSLqxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuTSLqxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD26C433C7;
	Tue, 19 Mar 2024 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710874199;
	bh=V1Y0V04vFhSQnt0mi7B4dNnhanHlty43UunLqUTBgv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UuTSLqxF6GVuAByjAzpyvAb0Rnfx03cIU8rcrosSr7B//ItDBTxUha91G+H9tVYxF
	 csobMD9SdZkmOoApKqagBe0BTyt3zNV0Qx3HJUqG/9/JaB+28sP0jwtzwhTL1SqkVA
	 l5CCUywyomJlKeedTnnqHGZ1NPHF9E2Eix4V3cUj4o/YKRt/itOZw2ckQskE9pnqGg
	 leLIjc4B9XgSJhT1MdRessaD/GZj0AxWqgT13c7WZYPtKwJ5U/5efttXAHou+HiX+l
	 miiuLN/oRO6wm+3HgiuMAnQBO8UtMVhXF2Z5cmMJdlaY75x1KZBtY10hOBUra/KJsQ
	 uefJ8h1aoDujw==
Date: Tue, 19 Mar 2024 11:49:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: recover dquot buffers unconditionally
Message-ID: <20240319184958.GD1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-4-david@fromorbit.com>

On Tue, Mar 19, 2024 at 01:15:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Dquot buffers are only logged when the dquot cluster is allocated.
> Recovery of them is always done and not conditional on an LSN found
> in the buffer because there aren't dquots stamped in the buffer when
> the initialisation is replayed after allocation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks sane,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h |   6 ++
>  fs/xfs/xfs_buf_item_recover.c  | 129 +++++++++++++++++----------------
>  2 files changed, 72 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 16872972e1e9..5ac0c3066930 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -508,6 +508,9 @@ struct xfs_log_dinode {
>  #define XFS_BLF_PDQUOT_BUF	(1<<3)
>  #define	XFS_BLF_GDQUOT_BUF	(1<<4)
>  
> +#define XFS_BLF_DQUOT_BUF	\
> +	(XFS_BLF_UDQUOT_BUF | XFS_BLF_PDQUOT_BUF | XFS_BLF_GDQUOT_BUF)
> +
>  /*
>   * This is the structure used to lay out a buf log item in the log.  The data
>   * map describes which 128 byte chunks of the buffer have been logged.
> @@ -571,6 +574,9 @@ enum xfs_blft {
>  	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
>  };
>  
> +#define XFS_BLFT_DQUOT_BUF	\
> +	(XFS_BLFT_UDQUOT_BUF | XFS_BLFT_PDQUOT_BUF | XFS_BLFT_GDQUOT_BUF)
> +
>  static inline void
>  xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
>  {
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index f994a303ad0a..90740fcf2fbe 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -450,8 +450,6 @@ xlog_recover_do_reg_buffer(
>  	int			i;
>  	int			bit;
>  	int			nbits;
> -	xfs_failaddr_t		fa;
> -	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
>  
>  	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
>  
> @@ -481,39 +479,10 @@ xlog_recover_do_reg_buffer(
>  		if (item->ri_buf[i].i_len < (nbits << XFS_BLF_SHIFT))
>  			nbits = item->ri_buf[i].i_len >> XFS_BLF_SHIFT;
>  
> -		/*
> -		 * Do a sanity check if this is a dquot buffer. Just checking
> -		 * the first dquot in the buffer should do. XXXThis is
> -		 * probably a good thing to do for other buf types also.
> -		 */
> -		fa = NULL;
> -		if (buf_f->blf_flags &
> -		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> -			if (item->ri_buf[i].i_addr == NULL) {
> -				xfs_alert(mp,
> -					"XFS: NULL dquot in %s.", __func__);
> -				goto next;
> -			}
> -			if (item->ri_buf[i].i_len < size_disk_dquot) {
> -				xfs_alert(mp,
> -					"XFS: dquot too small (%d) in %s.",
> -					item->ri_buf[i].i_len, __func__);
> -				goto next;
> -			}
> -			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
> -			if (fa) {
> -				xfs_alert(mp,
> -	"dquot corrupt at %pS trying to replay into block 0x%llx",
> -					fa, xfs_buf_daddr(bp));
> -				goto next;
> -			}
> -		}
> -
>  		memcpy(xfs_buf_offset(bp,
>  			(uint)bit << XFS_BLF_SHIFT),	/* dest */
>  			item->ri_buf[i].i_addr,		/* source */
>  			nbits<<XFS_BLF_SHIFT);		/* length */
> - next:
>  		i++;
>  		bit += nbits;
>  	}
> @@ -566,6 +535,56 @@ xlog_recover_this_dquot_buffer(
>  	return true;
>  }
>  
> +/*
> + * Do a sanity check of each region in the item to ensure we are actually
> + * recovering a dquot buffer item.
> + */
> +static int
> +xlog_recover_verify_dquot_buf_item(
> +	struct xfs_mount		*mp,
> +	struct xlog_recover_item	*item,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f)
> +{
> +	xfs_failaddr_t			fa;
> +	int				i;
> +
> +	switch (xfs_blft_from_flags(buf_f)) {
> +	case XFS_BLFT_UDQUOT_BUF:
> +	case XFS_BLFT_PDQUOT_BUF:
> +	case XFS_BLFT_GDQUOT_BUF:
> +		break;
> +	default:
> +		xfs_alert(mp,
> +			"XFS: dquot buffer log format type mismatch in %s.",
> +			__func__);
> +		xfs_buf_corruption_error(bp, __this_address);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	for (i = 1; i < item->ri_total; i++) {
> +		if (item->ri_buf[i].i_addr == NULL) {
> +			xfs_alert(mp,
> +				"XFS: NULL dquot in %s.", __func__);
> +			return -EFSCORRUPTED;
> +		}
> +		if (item->ri_buf[i].i_len < sizeof(struct xfs_disk_dquot)) {
> +			xfs_alert(mp,
> +				"XFS: dquot too small (%d) in %s.",
> +				item->ri_buf[i].i_len, __func__);
> +			return -EFSCORRUPTED;
> +		}
> +		fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
> +		if (fa) {
> +			xfs_alert(mp,
> +"dquot corrupt at %pS trying to replay into block 0x%llx",
> +				fa, xfs_buf_daddr(bp));
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Perform recovery for a buffer full of inodes. We don't have inode cluster
>   * buffer specific LSNs, so we always recover inode buffers if they contain
> @@ -743,7 +762,6 @@ xlog_recover_get_buf_lsn(
>  	struct xfs_buf_log_format *buf_f)
>  {
>  	uint32_t		magic32;
> -	uint16_t		magic16;
>  	uint16_t		magicda;
>  	void			*blk = bp->b_addr;
>  	uuid_t			*uuid;
> @@ -862,27 +880,7 @@ xlog_recover_get_buf_lsn(
>  		return lsn;
>  	}
>  
> -	/*
> -	 * We do individual object checks on dquot and inode buffers as they
> -	 * have their own individual LSN records. Also, we could have a stale
> -	 * buffer here, so we have to at least recognise these buffer types.
> -	 *
> -	 * A notd complexity here is inode unlinked list processing - it logs
> -	 * the inode directly in the buffer, but we don't know which inodes have
> -	 * been modified, and there is no global buffer LSN. Hence we need to
> -	 * recover all inode buffer types immediately. This problem will be
> -	 * fixed by logical logging of the unlinked list modifications.
> -	 */
> -	magic16 = be16_to_cpu(*(__be16 *)blk);
> -	switch (magic16) {
> -	case XFS_DQUOT_MAGIC:
> -		goto recover_immediately;
> -	default:
> -		break;
> -	}
> -
>  	/* unknown buffer contents, recover immediately */
> -
>  recover_immediately:
>  	return (xfs_lsn_t)-1;
>  
> @@ -956,6 +954,21 @@ xlog_recover_buf_commit_pass2(
>  		goto out_write;
>  	}
>  
> +	if (buf_f->blf_flags & XFS_BLF_DQUOT_BUF) {
> +		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
> +			goto out_release;
> +
> +		error = xlog_recover_verify_dquot_buf_item(mp, item, bp, buf_f);
> +		if (error)
> +			goto out_release;
> +
> +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> +				NULLCOMMITLSN);
> +		if (error)
> +			goto out_release;
> +		goto out_write;
> +	}
> +
>  	/*
>  	 * Recover the buffer only if we get an LSN from it and it's less than
>  	 * the lsn of the transaction we are replaying.
> @@ -992,17 +1005,7 @@ xlog_recover_buf_commit_pass2(
>  		goto out_release;
>  	}
>  
> -	if (buf_f->blf_flags &
> -		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> -		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
> -			goto out_release;
> -
> -		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> -				NULLCOMMITLSN);
> -	} else {
> -		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> -				current_lsn);
> -	}
> +	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	if (error)
>  		goto out_release;
>  
> -- 
> 2.43.0
> 
> 
