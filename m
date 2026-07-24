Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A4D224F3
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784911746; cv=none; b=Z4SDaoAqkd8EMFcEqLV247TvGn9rQsWNd+QUqaSTNwaqOkN1o4mb7SV1m270DjNZckyAW2vvGJSzDyCq4ZV8NTMJKepVcMsUQAwe1ONriY3lCYOoz0UhV8TE7LkcICxL1dVbA268mQiMLL45+TRfLJCE4srhZFJsmbWe80uQ33Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784911746; c=relaxed/simple;
	bh=wrZRU12PL5lc9J1Hw0LZzGoatT+XzByIhG3wrhwAn8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOqGrVa1sTmbJiZHUQe/M4BuKFtl4vQYvjuYWv6PV1z81vOkf+D41csc4tEkmIV9ZH9FPFeGsQrLu6AZP4qaiQAF/8mLfZCK+mbHTFGwFpDu+O23C9k8dty02lgHp3abfvY2XeJkmlG95TjIVnmUrelPoChlP6koBLEWJ0OlQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLPppVAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLPppVAa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA00D1F000E9;
	Fri, 24 Jul 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911744;
	bh=i4PAhU1/LVMTZNZunVsFIz8pBshrB/BCYi7R8gTy+d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LLPppVAaPMytTxJlkYt8Mefmail1nfKiEB4Ja5PeyYHXNfeChuFbYLeFY6d+M1caB
	 EtWdtj2bn+fuV0a+lmgKT6GgC8BKy8RFAMtxaVItA8r2+t5vDfVt8kZ8nFG7cflK5g
	 fdkpq0MiP2oIwELcIxtAzGKFakqeZy4OSuBWAGRVhmwANwFsrzo9EIDGIEPtQHg4Vw
	 fRNVeDuzkZqhe3q4Fq3Lb93CstaJFtUXQRUp8SkmPkRbzDTfU08R7qzUqjkGZPkY4b
	 YaF27uBnhvbw0I7KEZQzKBHnRhV7QSMY+RXZGrkLfQhrPXr3cS/ss8dZMOrwyCvLvL
	 srAf4TVmCGM9Q==
Date: Fri, 24 Jul 2026 09:49:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: remove _XBF_LOGRECOVERY
Message-ID: <20260724164904.GS2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-6-hch@lst.de>

On Wed, Jul 15, 2026 at 04:50:58PM +0200, Christoph Hellwig wrote:
> Adding _XBF_LOGRECOVERY to every buffer write from log recovery is error
> prone.  Instead key off the behavior on log recovery being active with
> indirecting that through a flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense.  I suppose if anyone wants to capture ftrace data
they'll see the printk log stating that we're starting and ending
recovery, right?

If yes then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c                |  5 ++---
>  fs/xfs/xfs_buf.h                |  4 ----
>  fs/xfs/xfs_buf_item.c           | 10 ++++++----
>  fs/xfs/xfs_buf_item_recover.c   |  3 ---
>  fs/xfs/xfs_dquot_item_recover.c |  1 -
>  fs/xfs/xfs_inode_item_recover.c |  1 -
>  fs/xfs/xfs_log_recover.c        |  5 ++---
>  7 files changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2cf359b4c446..d0146d4fb3d3 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1017,7 +1017,7 @@ xfs_buf_ioend_handle_error(
>  	 * We're not going to bother about retrying this during recovery.
>  	 * One strike!
>  	 */
> -	if (bp->b_flags & _XBF_LOGRECOVERY) {
> +	if (mp->m_log && xlog_in_recovery(mp->m_log)) {
>  		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
>  		return false;
>  	}
> @@ -1124,8 +1124,7 @@ xfs_buf_ioend(
>  			bp->b_iodone(bp);
>  	}
>  
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
> -			 _XBF_LOGRECOVERY);
> +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
>  	if (async)
>  		xfs_buf_relse(bp);
>  }
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 79cc9c3f0254..e440f97cf3e1 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -34,9 +34,6 @@ struct xfs_buf;
>  #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
>  #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
>  
> -/* buffer type flags for write callbacks */
> -#define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
> -
>  /* flags used only internally */
>  #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
> @@ -61,7 +58,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> -	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1f055cd6732e..1a4ef34af8d5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1066,6 +1066,8 @@ void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
>  	/*
>  	 * If we are forcibly shutting down, this may well be off the AIL
>  	 * already. That's because we simulate the log-committed callbacks to
> @@ -1078,8 +1080,8 @@ xfs_buf_item_done(
>  	 * Note that log recovery writes might have buffer items that are not on
>  	 * the AIL even when the file system is not shut down.
>  	 */
> -	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
> -			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
> -			     SHUTDOWN_CORRUPT_INCORE);
> -	xfs_buf_item_relse(bp->b_log_item);
> +	xfs_trans_ail_delete(&bip->bli_item,
> +			     xlog_in_recovery(bip->bli_item.li_log) ?
> +			     0 : SHUTDOWN_CORRUPT_INCORE);
> +	xfs_buf_item_relse(bip);
>  }
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..0a3ab33b0e74 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -448,7 +448,6 @@ xlog_recover_validate_buf_type(
>  	if (bp->b_ops) {
>  		struct xfs_buf_log_item	*bip;
>  
> -		bp->b_flags |= _XBF_LOGRECOVERY;
>  		xfs_buf_item_init(bp, mp);
>  		bip = bp->b_log_item;
>  		bip->bli_item.li_lsn = current_lsn;
> @@ -1100,7 +1099,6 @@ xlog_recover_buf_commit_pass2(
>  			xfs_buf_lock(rtsb_bp);
>  			xfs_buf_hold(rtsb_bp);
>  			xfs_update_rtsb(rtsb_bp, bp);
> -			rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
>  			xfs_buf_delwri_queue(rtsb_bp, buffer_list);
>  			xfs_buf_relse(rtsb_bp);
>  		}
> @@ -1139,7 +1137,6 @@ xlog_recover_buf_commit_pass2(
>  		error = xfs_bwrite(bp);
>  	} else {
>  		ASSERT(bp->b_mount == mp);
> -		bp->b_flags |= _XBF_LOGRECOVERY;
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  	}
>  
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index fe419b28de22..d4dfe1885666 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -168,7 +168,6 @@ xlog_recover_dquot_commit_pass2(
>  
>  	ASSERT(dq_f->qlf_size == 2);
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_flags |= _XBF_LOGRECOVERY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 169a8fe3bf0a..1d2319ad15c5 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -586,7 +586,6 @@ xlog_recover_inode_commit_pass2(
>  	}
>  
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_flags |= _XBF_LOGRECOVERY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fdb011e6ef60..e7e49529658b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3279,9 +3279,8 @@ xlog_do_recovery_pass(
>  			 * checkpoints at this start LSN.
>  			 *
>  			 * Note: Shutting down the filesystem will result in the
> -			 * delwri submission marking all the buffers stale,
> -			 * completing them and cleaning up _XBF_LOGRECOVERY
> -			 * state without doing any IO.
> +			 * delwri submission marking all the buffers stale and
> +			 * completing them without doing any IO.
>  			 */
>  			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  		}
> -- 
> 2.53.0
> 
> 
