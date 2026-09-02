Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E6B48CD71
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365941; cv=none; b=HtIeqSbI/vpqauVRKwaqSR/PRbkasLdtFzsLV/iRdWKeFJlOpWC8CnOPArs5ei01WgLThOLo/fL46G73dwqwK1a7OIlRCKfKNymiKAstfTaDIOz9pzR5YDu3XYinf4lALaKCz+fiV0oNhVgygCYWEiKps3pQtpVuG9/oxrJK7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365941; c=relaxed/simple;
	bh=6Xpq6H6lXm+zOC9dQTsQYhSXEckX7gwkQDQvMf2G/X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6ktlEBkkMBx1E4mkfNMwn576CMc9EU1YqzAOcllJUW8tVGaKHQdhcgIT9LvzPZFJfSZlPV/+ii46WvM7ijoQ9XEgR4viFKL6BPo5CxdL1E/FHVLuP6Q4t568e3gCiP+khZgXjn8rQvX3NZS2m73RAsgc1nVkuir2mu4qDEjFcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZfz6dZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZfz6dZE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4D36B1F000E9;
	Wed,  2 Sep 2026 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365939;
	bh=HsYB6TWwoYdq7yCZj9n36A0AJcSfteJnur9yqHynmlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QZfz6dZE3j3oOcsYKTtSq5itDTtLWdeA6xoJFB8XddShCI88JK1BwT9R9rx292TuM
	 HkJ/KTP/vqZccSEZpHwGXgo+mJzq1vLgNzkrjXmHgTAzaw3eBntWj38A1SdJZ9fBtS
	 zS/JXZp+3CmW86FtN2SlGWLmuxHuPme7KjPkr4dgoqOGSyUuYeo9j4hJ7CN3jHDETa
	 1mbchjKoajIqIaFFRLJu4ZSplmEJCxdQ2ldHJ15PjRE9uYC0wwGNluSdfj7BMPpFBF
	 F+0UcFegvd2tvNTEP2kwUFQMTK9mgb8w+pA22DFcFf5uNXlhWUNNy2hkQtqj7xmTwP
	 ZvwkKHVtrkQFg==
Date: Wed, 2 Sep 2026 09:18:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: flush multiple device caches in parallel in
 xlog_write_iclog
Message-ID: <20260902161858.GT1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-7-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:20AM +0300, Christoph Hellwig wrote:
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

That looks like a neat trick.  Do you see any performance speedups from
flushing in parallel?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 78 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 71 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a5870877baed..b392a45d38c6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1538,6 +1538,47 @@ xlog_bio_end_io(
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
> @@ -1551,17 +1592,39 @@ xlog_bio_end_io(
>   */
>  static int
>  xlog_flush_data_caches(
> -	struct xlog		*log)
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
>  {
>  	struct xfs_mount	*mp = log->l_mp;
> +	struct xlog_flush_done done = {
> +		.pending	= ATOMIC_INIT(1),
> +		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
> +	};
> +	bool			did_flush = false;
>  
> -	if (log->l_targ != mp->m_ddev_targp) {
> -		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
> -			return -EIO;
> +	if (mp->m_ddev_targp != log->l_targ &&
> +	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
> +		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
> +		did_flush = true;
> +	}
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
> +	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
> +		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
> +		did_flush = true;
>  	}
> -	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> -		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
> +
> +	if (did_flush) {
> +		/*
> +		 * If we flushed any other device, also use an async flush for
> +		 * the log device so that all flushes happen in parallel.
> +		 */
> +		xlog_flush_async(&done, log->l_targ->bt_bdev);
> +
> +		xlog_flush_done(&done);
> +		wait_for_completion(&done.done);
> +		if (done.status)
>  			return -EIO;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  	}
>  
>  	return 0;
> @@ -1611,8 +1674,9 @@ xlog_write_iclog(
>  	iclog->ic_bio.bi_private = iclog;
>  
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> -		if (xlog_flush_data_caches(log))
> +		if (xlog_flush_data_caches(log, iclog))
>  			goto shutdown;
> +		/* xlog_flush_data_caches may clear XLOG_ICL_NEED_FLUSH */
>  	}
>  	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> -- 
> 2.53.0
> 
> 
