Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87954AEDA;
	Mon, 24 Jun 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719242730; cv=none; b=OAz7Pig9ncOH8nOhYFJoNZnJz9cizZQb4tRgOp0QBkTKV3xNyUkcUa8nirMuD+jgc6rQZrKb1fM+d5RQ5OtmYx3dRBcX4CGcU/qw2XAMWl8K2zgHC3/cTAWUQsjuM2j8YEyIjzxybKq93l4xf7imfPm+/toPMxBYT18lSI0sjGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719242730; c=relaxed/simple;
	bh=8vvF8G6bkOZtXWk8JOMgHF4/zUuJ0Ub3kvj37ix4CRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=arF1eWuut/lt4f1c1guoJX1cYiKFDlbPyXizZkZai9qcJfsfwNoGyZN+CrmJ1+iSO9Z1B86NQPuiTpPvXPOkfilCj++DG+UBGco2ySv7N2RgaGWEA2GRJb6sTC382AfAwkiv9T+0Z1sCaoOLd9ItZyLDmjkMkrMwkIBa8W1Hbv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZFrBt93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZFrBt93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F71C2BBFC;
	Mon, 24 Jun 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719242730;
	bh=8vvF8G6bkOZtXWk8JOMgHF4/zUuJ0Ub3kvj37ix4CRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZFrBt93joTHiFr1wb93EMD2Efhnc5oCtDEH5XTGsfCCpNvi6XWIrXbGz2vy4U4e2
	 HG4SQe4NF2aGnZfoQyddN5rfZl0V9re2a0UHR8Hdg1lVjsr7yIqmNCf9w3TuRpmZC4
	 rGozSW9CS7AjgKw0W7RomM05miKcfm5OdJ/mcCspGz+udQh6u9LWpebbQBbR657mzE
	 ZMI8+yNnksdH2OBVvMFZ0otc8g63Trac1V5w75CpBoBvDxWRSC7AA00y95Wh32o2hy
	 NuCUK8VyZ7hp6VvaXL4CDTYIZZ6xCAnWL2/1tN+EBeYRRUeBJgeBWHrJLiPBOvVUmp
	 Off/drZW8E6cg==
Date: Mon, 24 Jun 2024 08:25:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: alexjlzheng@gmail.com
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexjlzheng@tencent.com
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and
 release it early
Message-ID: <20240624152529.GD3058325@frogsfrogsfrogs>
References: <20240623123119.3562031-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623123119.3562031-1-alexjlzheng@tencent.com>

On Sun, Jun 23, 2024 at 08:31:19PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> In the current implementation, in most cases, the memory of xfs_log_vec
> and xfs_log_iovec is allocated together. Therefore the life cycle of
> xfs_log_iovec has to remain the same as xfs_log_vec.
> 
> But this is not necessary. When the content in xfs_log_iovec is written
> to iclog by xlog_write(), it no longer needs to exist in the memory. But
> xfs_log_vec is still useful, because after we flush the iclog into the
> disk log space, we need to find the corresponding xfs_log_item through
> the xfs_log_vec->lv_item field and add it to AIL.
> 
> This patch separates the memory allocation of xfs_log_iovec from
> xfs_log_vec, and releases the memory of xfs_log_iovec in advance after
> the content in xfs_log_iovec is written to iclog.

Why would anyone care?  This makes lifecycle reasoning more complicated
but no justification is provided.

--D

> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/xfs/xfs_log.c     |  2 ++
>  fs/xfs/xfs_log.h     |  8 ++++++--
>  fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++----------
>  3 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 416c15494983..f7af9550c17b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2526,6 +2526,8 @@ xlog_write(
>  			xlog_write_full(lv, ticket, iclog, &log_offset,
>  					 &len, &record_cnt, &data_cnt);
>  		}
> +		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
> +			kvfree(lv->lv_iovecp);
>  	}
>  	ASSERT(len == 0);
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index d69acf881153..f052c7fdb3e9 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -6,6 +6,8 @@
>  #ifndef	__XFS_LOG_H__
>  #define __XFS_LOG_H__
>  
> +#define XFS_LOG_VEC_DYNAMIC	(1 << 0)
> +
>  struct xfs_cil_ctx;
>  
>  struct xfs_log_vec {
> @@ -17,7 +19,8 @@ struct xfs_log_vec {
>  	char			*lv_buf;	/* formatted buffer */
>  	int			lv_bytes;	/* accounted space in buffer */
>  	int			lv_buf_len;	/* aligned size of buffer */
> -	int			lv_size;	/* size of allocated lv */
> +	int			lv_size;	/* size of allocated iovec + buffer */
> +	int			lv_flags;	/* lv flags */
>  };
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
> @@ -40,6 +43,7 @@ static inline void
>  xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
>  		int data_len)
>  {
> +	struct xfs_log_iovec	*lvec = lv->lv_iovecp;
>  	struct xlog_op_header	*oph = vec->i_addr;
>  	int			len;
>  
> @@ -69,7 +73,7 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
>  	vec->i_len = len;
>  
>  	/* Catch buffer overruns */
> -	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
> +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lvec + lv->lv_size);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f51cbc6405c1..3be9f86ce655 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -219,8 +219,7 @@ static inline int
>  xlog_cil_iovec_space(
>  	uint	niovecs)
>  {
> -	return round_up((sizeof(struct xfs_log_vec) +
> -					niovecs * sizeof(struct xfs_log_iovec)),
> +	return round_up(niovecs * sizeof(struct xfs_log_iovec),
>  			sizeof(uint64_t));
>  }
>  
> @@ -279,6 +278,7 @@ xlog_cil_alloc_shadow_bufs(
>  
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv;
> +		struct xfs_log_iovec *lvec;
>  		int	niovecs = 0;
>  		int	nbytes = 0;
>  		int	buf_size;
> @@ -339,18 +339,23 @@ xlog_cil_alloc_shadow_bufs(
>  			 * the buffer, only the log vector header and the iovec
>  			 * storage.
>  			 */
> -			kvfree(lip->li_lv_shadow);
> -			lv = xlog_kvmalloc(buf_size);
> -
> -			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> +			if (lip->li_lv_shadow) {
> +				kvfree(lip->li_lv_shadow->lv_iovecp);
> +				kvfree(lip->li_lv_shadow);
> +			}
> +			lv = xlog_kvmalloc(sizeof(struct xfs_log_vec));
> +			memset(lv, 0, sizeof(struct xfs_log_vec));
> +			lvec = xlog_kvmalloc(buf_size);
> +			memset(lvec, 0, xlog_cil_iovec_space(niovecs));
>  
> +			lv->lv_flags |= XFS_LOG_VEC_DYNAMIC;
>  			INIT_LIST_HEAD(&lv->lv_list);
>  			lv->lv_item = lip;
>  			lv->lv_size = buf_size;
>  			if (ordered)
>  				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
>  			else
> -				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
> +				lv->lv_iovecp = lvec;
>  			lip->li_lv_shadow = lv;
>  		} else {
>  			/* same or smaller, optimise common overwrite case */
> @@ -366,9 +371,9 @@ xlog_cil_alloc_shadow_bufs(
>  		lv->lv_niovecs = niovecs;
>  
>  		/* The allocated data region lies beyond the iovec region */
> -		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
> +		lv->lv_buf = (char *)lv->lv_iovecp +
> +				xlog_cil_iovec_space(niovecs);
>  	}
> -
>  }
>  
>  /*
> @@ -502,7 +507,7 @@ xlog_cil_insert_format_items(
>  			/* reset the lv buffer information for new formatting */
>  			lv->lv_buf_len = 0;
>  			lv->lv_bytes = 0;
> -			lv->lv_buf = (char *)lv +
> +			lv->lv_buf = (char *)lv->lv_iovecp +
>  					xlog_cil_iovec_space(lv->lv_niovecs);
>  		} else {
>  			/* switch to shadow buffer! */
> @@ -1544,6 +1549,7 @@ xlog_cil_process_intents(
>  		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
>  		trace_xfs_cil_whiteout_mark(ilip);
>  		len += ilip->li_lv->lv_bytes;
> +		kvfree(ilip->li_lv->lv_iovecp);
>  		kvfree(ilip->li_lv);
>  		ilip->li_lv = NULL;
>  
> -- 
> 2.39.3
> 
> 
