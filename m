Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4BE44606A
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 09:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791192952; cv=none; b=nTiilLA6V7CIv1rDcw0ZNsGgs7Kbc9uwrEbgrVtSWRWJhayv30kj+ZsuCBNXaXvWtzaPLZdIa/Jo0ZwcWC/EVqYFtCENatp8n+n9rlMlh+9dZQVRoc0N5ue6kKXBaIf+bVU6mdAbP4gHBisTNPUU9FBiG3jQfJ97Tmo7e3QWwTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791192952; c=relaxed/simple;
	bh=z92Hoo9fhzGU85uORoPXWv9LZAOy/7zWCCW68wT33Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl2tn86OSDFvleX9bhaNBVW12Oag/dIQtMUwrRkJBUU7ZmIWgJGGlB6TchOR2yNXhepJh9rmjBwKOF/ycEbjehLVZ2+TkR1RS5zXGK4O9AELdjp+ZKc4k9yBSLY2jFncfgkV3HY1aUknYCUgKhN+2pR9sOvlVSbCJeNcYycViUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAaXJA9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAaXJA9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CE81F000FF;
	Mon,  5 Oct 2026 09:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791192943;
	bh=x1DZdMfMD0yx6FYuYKBKNYF9ZdVubGW+vpcpueiUfZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hAaXJA9mI3jMoqZ9Ne9Vc46S+sp0iSBT/zRz7ZpdrzPYEyYF09Ckq8cC9tnsuwYSP
	 Wi0R3gMZIX1GC6V+FC03KpuNTwYFuyPHDmFf68m+Njb35vD2cNt3hLZMs1TZft5peN
	 LuABVFXtPqrhFmH0qISw1JCVJKsB5edl+qEDiBkfNDEeQClGUu6Vt8CXg8qfS5DGCU
	 D+e3Pwh4JMgB++rd0eXj/akROtQnNAeoXqxZG3wzNmp7Le8QijcMgyjqXp6VJrpqgP
	 4fRmkqkWUl/QnlwTAjARk3PiuXZS7g+Gn2yyjV3TBAL6aYqG/kUZhpp6HSu1XV1//g
	 FB7D8Kqvu/JSw==
Date: Mon, 5 Oct 2026 11:35:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: flush multiple device caches in parallel in
 xlog_write_iclog
Message-ID: <asNvZIeRE8XgjIpZ@nidhogg.toxiclabs.cc>
References: <20260925151543.3382123-1-hch@lst.de>
 <20260925151543.3382123-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925151543.3382123-4-hch@lst.de>

On Fri, Sep 25, 2026 at 05:15:38PM +0200, Christoph Hellwig wrote:
> When xlog_write_iclog needs to flush the cache for more than one devices,
> the current implementations does this sequentially, which adds up the
> flush latency for all devices.  Switch to kicking off all cache flushes
> in parallel so that only the longest latency bounds the time of the log
> I/O.  This removes the REQ_PREFLUSH optimization for the log device,
> but as that flag is never passed on to the device and just very slightly
> reduce the latency by queueing the following write from a lower-level
> context it is trivially shadowed by the latency improvements of the
> parallel flush commands.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c | 82 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 73 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 893ea899a0a8..74b324f915a1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1544,6 +1544,47 @@ xlog_bio_end_io(
>  		   &iclog->ic_end_io_work);
>  }
>  
> +struct xlog_flush_done {
> +	atomic_t		pending;
> +	blk_status_t		status;
> +	struct completion	done;
> +};
> +
> +static void
> +xlog_flush_done(
> +	struct xlog_flush_done	*done)
> +{
> +	if (atomic_dec_and_test(&done->pending))
> +		complete(&done->done);
> +}
> +
> +static void
> +xlog_flush_end_io(
> +	struct bio		*bio)
> +{
> +	struct xlog_flush_done	*done = bio->bi_private;
> +
> +	if (bio->bi_status)
> +		cmpxchg(&done->status, 0, bio->bi_status);
> +	xlog_flush_done(done);
> +	bio_put(bio);
> +}
> +
> +static void
> +xlog_flush_async(
> +	struct xlog_flush_done	*done,
> +	struct block_device	*bdev)
> +{
> +	struct bio		*bio;
> +
> +	bio = bio_alloc(bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
> +			GFP_NOFS);
> +	bio->bi_private = done;
> +	bio->bi_end_io = xlog_flush_end_io;
> +	atomic_inc(&done->pending);
> +	submit_bio(bio);
> +}
> +
>  /*
>   * When using multiple devices, we also need to flush the data and RT device
>   * caches first to ensure that all metadata writeback covered by the LSN in
> @@ -1557,16 +1598,36 @@ xlog_bio_end_io(
>   */
>  static int
>  xlog_flush_data_caches(
> -	struct xlog		*log)
> +	struct xfs_mount	*mp,
> +	bool			*did_flush)
>  {
> -	struct xfs_mount	*mp = log->l_mp;
> +	struct xlog_flush_done done = {
> +		.pending	= ATOMIC_INIT(1),
> +		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
> +	};
>  
> -	if (log->l_targ != mp->m_ddev_targp) {
> -		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
> -			return -EIO;
> +	*did_flush = false;
> +	if (mp->m_ddev_targp != mp->m_logdev_targp &&
> +	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
> +		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
> +		*did_flush = true;
> +	}
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
> +	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
> +		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
> +		*did_flush = true;
>  	}
> -	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> -		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
> +
> +	if (*did_flush) {
> +		/*
> +		 * If we flushed any other device, also use an async flush for
> +		 * the log device so that all flushes happen in parallel.
> +		 */
> +		xlog_flush_async(&done, mp->m_logdev_targp->bt_bdev);
> +
> +		xlog_flush_done(&done);
> +		wait_for_completion(&done.done);
> +		if (done.status)
>  			return -EIO;
>  	}
>  
> @@ -1580,6 +1641,8 @@ xlog_write_iclog(
>  	uint64_t		bno,
>  	unsigned int		count)
>  {
> +	bool			did_flush = false;
> +
>  	ASSERT(bno < log->l_logBBsize);
>  	trace_xlog_iclog_write(iclog, _RET_IP_);
>  
> @@ -1617,10 +1680,11 @@ xlog_write_iclog(
>  	iclog->ic_bio.bi_private = iclog;
>  
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> -		if (xlog_flush_data_caches(log))
> +		if (xlog_flush_data_caches(log->l_mp, &did_flush))
>  			goto shutdown;
>  	}
> -	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
> +	if (!did_flush &&
> +	    (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG)))
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
> -- 
> 2.53.0
> 
