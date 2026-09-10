Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA67456290
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 10:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036810; cv=none; b=e8KFv8E+F/DHCGF8A7VLSAxGZsGaNHtLizZ40fdpm510qVaKdrU5iTSpYE0s5Mmq0+WRrawnbuV5PFf4MdFvxv2cbrSXAXDkDjWGSsNoo5qrjCEC6ysiFCTmZ632IsSI3EAdLXm/XcxbKUFHzG2fYwptDSFUocn9/v8Fd0XJ5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036810; c=relaxed/simple;
	bh=eODZx7t2k7qZ/vaHEW5GJcT1+Lo7XL/fMxyqjo23XvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMvQxxCmEovTyJ/yhFRuA8w1qENv3mXcUiNLJa3yZ1iB4iIt4DnwYIKtbvaieOiBStDm+jZub7qaV1v50hYfsEU207b3gVROcSaUqoPizswPn/gdOMnsojP3+1FTNHb1mskeY+KVj9MWjOrk7lnCHCNE95kdmWow8ZZvryXeRUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m49kV01o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m49kV01o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEEF1F000FF;
	Thu, 10 Sep 2026 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036808;
	bh=NOEBTdxstV+d5BiWn0L23pUQNYbD27GyFMPt0LVjrZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m49kV01oqoikFzSvyMCXbB3yXpksGcrEeY1Q2Zcvoy37NTNCbuXEm/SPlFBpGxcqq
	 5htqLbiXwvdep+7vuJtYLOAJTZI6CuIhHP956tvkdpEgPz8cz6GOjN/oDRsC8D0R5q
	 Uebc9Ir6NG7eL2sN+qh/u5SY7ujsdpla+Dz8p/I6EKSb6USqaEyoWjXvojryMU8hY+
	 AY5+pH6CHE+q1qaFlaHKMo9xZCuCSGN0JGunGntgSsTQpJ15+rwq0Kr1Xm8JqUDdoz
	 74Vcl5qL4wD//M64XU0HZHEZEnX2Y40llXqbK4+/q3+xIV3QVQLICkJpqbMwEo+Vfc
	 v+SlkwDvzQ7hw==
Date: Thu, 10 Sep 2026 12:40:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: also flush the RT device cache in
 xlog_write_iclog
Message-ID: <aqKH6E2TRw2AeKVz@andromeda.toxiclabs.cc>
References: <20260907073427.719935-1-hch@lst.de>
 <20260907073427.719935-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907073427.719935-2-hch@lst.de>

On Mon, Sep 07, 2026 at 10:33:07AM +0300, Christoph Hellwig wrote:
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
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_log.c     | 45 ++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log_cil.c |  7 ++++---
>  2 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a34611d81f6..f4f81d893e8c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1544,6 +1544,35 @@ xlog_bio_end_io(
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
> @@ -1588,21 +1617,9 @@ xlog_write_iclog(
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
> index 166531018ce4..f9e07a32f60f 100644
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
