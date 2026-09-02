Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1B4A9D46
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364886; cv=none; b=brwrbXpitWG04YgV1hBPa0vEI4y0jYl3zUs3U10YynAwTOERxYx+kd4Kllgyusjl/qOrCjvPrB6lXsqnIr2+hw/5ttNj367y0MZD0+IrFjvrnYZrpbYpGVyOhTzsfEDBwIrDocy2TjFX4cAd1Ew7YBmWigz3Pw9S6ZiQHbEz0nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364886; c=relaxed/simple;
	bh=uaUY4kuNMubKC4g1XtOlOXP2pnv/yrfl1d61TvDbPck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=us32ZVMvaiv7j1/8ZkaHdy7I3B3kDKAPRuJgoyXZGX4tGyYyKzIzpyJENeGPHQwdTkcZJYEjhCgzTiCp4YGzaRlQaRfaJ39pVV7OdCcGP5Ou2+zBYbevw7XzBIvlbfDPIwJkYaFhfDKj4Tl/SE+BZCM01rMrV8Ms3O6ktTpGAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzNd+5ib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzNd+5ib"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 263201F000E9;
	Wed,  2 Sep 2026 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364884;
	bh=/jkJCUI77JDKWIFBcilqqQS9d93dM+RcXRJH87fUPso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NzNd+5ib6ihRI4UalFhHvtcDkCsjfiXfUOn8LouIYqyHdLSnOI5dPYbV1gL7SpybZ
	 bl+AccLttS7mEbpMRG69ur6n7r/81xQ0cf3XsPxXZ5BozpvcJ9rmmw4IKNW2rNvV8v
	 e70FM7j18vaRg3FQrZSG6Ttf1ZPhkWsAEyhfm6T93my0+ad3Ks1EWvx5mukgwCZ5KC
	 yV5HktoAQRoqZQdPptI43XtQ/oKPktD5dsTuFBQLgT5uG1MybshTxmppivT5wflVAD
	 r7MPS6N5rGnWBEr4KEBUk0NJjkA/KGUsjrKzWyBhU9xgJ2sfTPuf2j/m2sKlzpZuhm
	 QWazrio7DA3gA==
Date: Wed, 2 Sep 2026 09:01:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: also flush the RT device cache in
 xlog_write_iclog
Message-ID: <20260902160123.GO1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-2-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:15AM +0300, Christoph Hellwig wrote:
> The cache flush before writing the CIL start record no only needs to
> ensure any metadata covered by the overwritten part of the log is on
> stable storage, but also that any data pointed to by metadata logged
> is on stable storage, as otherwise log recovery could created allocated
> blocks that point to stale data.  Fortunately the code already
> handles this right for the data device, but it also needs to flush
> the RT device for this to work for data on the RT device.
> 
> Also update the comments to explicitly mention this case.
> 
> This omission goes back to the first days of cache control in XFS.

Yikes.

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me agrees that we should be flushing the rt device after persisting
metadata that might affect it.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c     | 45 ++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log_cil.c |  7 ++++---
>  2 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f807f8f4f705..8079f2e003db 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1538,6 +1538,35 @@ xlog_bio_end_io(
>  		   &iclog->ic_end_io_work);
>  }
>  
> +/*
> + * When using multiple devices, we also need to flush the data and RT device
> + * caches first to ensure that all metadata writeback covered by the LSN in
> + * this iclog is on stable storage. This is slow, but it *must* complete
> + * before we issue the external log IO.
> + *
> + * If the flush fails, we cannot conclude that past metadata writeback from
> + * the log succeeded.  Repeating the flush is not possible, hence we must
> + * shut down with log IO error to avoid shutdown re-entering this path and
> + * erroring out again.
> + */
> +static int
> +xlog_flush_data_caches(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +
> +	if (log->l_targ != mp->m_ddev_targp) {
> +		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
> +			return -EIO;
> +	}
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> +		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>  STATIC void
>  xlog_write_iclog(
>  	struct xlog		*log,
> @@ -1582,21 +1611,9 @@ xlog_write_iclog(
>  	iclog->ic_bio.bi_private = iclog;
>  
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> -		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> -		/*
> -		 * For external log devices, we also need to flush the data
> -		 * device cache first to ensure all metadata writeback covered
> -		 * by the LSN in this iclog is on stable storage. This is slow,
> -		 * but it *must* complete before we issue the external log IO.
> -		 *
> -		 * If the flush fails, we cannot conclude that past metadata
> -		 * writeback from the log succeeded.  Repeating the flush is
> -		 * not possible, hence we must shut down with log IO error to
> -		 * avoid shutdown re-entering this path and erroring out again.
> -		 */
> -		if (log->l_targ != log->l_mp->m_ddev_targp &&
> -		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
> +		if (xlog_flush_data_caches(log))
>  			goto shutdown;
> +		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	}
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 639f875a8fb2..3d159b1350df 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1055,9 +1055,10 @@ xlog_cil_set_ctx_write_state(
>  		spin_unlock(&cil->xc_push_lock);
>  
>  		/*
> -		 * Make sure the metadata we are about to overwrite in the log
> -		 * has been flushed to stable storage before this iclog is
> -		 * issued.
> +		 * Flush the write cache before writing the start record so that
> +		 * the metadata we are about to overwrite in the log and the
> +		 * data that new allocations in this context refer to are
> +		 * persisted to stable storage before this iclog is written.
>  		 */
>  		spin_lock(&cil->xc_log->l_icloglock);
>  		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> -- 
> 2.53.0
> 
> 
