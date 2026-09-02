Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0D13D34AC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365753; cv=none; b=vFDCqv3pJqxkfAljVWfB3npNiLbveTYRxB9J8SDJL18M80EBi7fSsyMRcFXUuOgJA4sL0nTfFtCMbqu14Q2bG4oZnkSC1WP1Gqy5rHISwhbH6Q7pc7aglFrkbOupXVIE2eGKkE4Z/W9PC4dXMa4qsiGFvywQMvcpwan9qJ1mVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365753; c=relaxed/simple;
	bh=VQn82JBsZV47VtbRR9qev4n5r3PEop9Ou4ogN7UN8PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+pr+kXamVTL7Evu3xQIolzKCrEfzuo+XTfzuhIodpHB9Jg4m0K+tSbLSCxuqbc9z5QOaztEODixr9ewwiiTn1QBFnlNvjin1510pM4ddzX9fkcS0Z9ReJBarRF1H7zsrlKiKAtuQ+xUaVG+NmRxRGxk3P21mDWJCC/jlWAmhKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4CiZv71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4CiZv71"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B5D721F000E9;
	Wed,  2 Sep 2026 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365751;
	bh=5mIci0wV3rItb9x+zztP3pkm28vqkMGn5y8FHosBOl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j4CiZv711y7l2OcDQdg53unLDV+ElxSO49lKhOKKEHKdjypRf6wxj3ztMIqRqRmFD
	 2FsmTCBwsotuLAKRyk3QYGFRM2fRaMW1fyldSF+p3bGGa+OCqSxMJ8MIGoZhr6u6Pz
	 e6oDrV6HS+iGDcIs1DCeIHI19eZQlOZph6hgi3FuG+OcigDRvR3uWATsz0Yunef1JN
	 jYiA9KXjB9GIW2oNspcB8WMtgbUUh5tkHDcRG38d1ibKcCWNd7l+Wy1c0bn6fpHCi3
	 89XDZDGp1uK3MwAsM/SFGVnEOexk76SLPhz4bYPvha5b1TVSkLctjaTQrc4lHyi2N7
	 Uxo/mCGy+wDFA==
Date: Wed, 2 Sep 2026 09:15:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: optimize cache flushing for CIL commits on
 multi-device file systems
Message-ID: <20260902161551.GS1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-6-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:19AM +0300, Christoph Hellwig wrote:
> While the flush before writing a start record needs to cover data on the
> data and possibly RT devices, the flush before writing the commit record
> iclog only needs to ensure previous iclogs are stable on disk.
> 
> Split out a new XLOG_ICL_NEED_FLUSH_LOG flag out of XLOG_ICL_NEED_FLUSH
> to signal that only the log device needs to be flushed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      |  6 ++++--
>  fs/xfs/xfs_log_cil.c  |  9 ++++++---
>  fs/xfs/xfs_log_priv.h | 10 ++++++----
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8079f2e003db..a5870877baed 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1613,12 +1613,14 @@ xlog_write_iclog(
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
>  		if (xlog_flush_data_caches(log))
>  			goto shutdown;
> -		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	}
> +	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
> +		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
>  
> -	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> +	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG |
> +			     XLOG_ICL_NEED_FUA);
>  
>  	if (is_vmalloc_addr(iclog->ic_header)) {
>  		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_header, count))
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3d159b1350df..e05b77fbfc3d 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1562,10 +1562,13 @@ xlog_cil_push_work(
>  		}
>  
>  		/*
> -		 * We need to issue a pre-flush so that the ordering for this
> -		 * checkpoint is correctly preserved down to stable storage.
> +		 * We need to issue a pre-flush on the device containing the log
> +		 * so that the ordering for this checkpoint is correctly
> +		 * preserved down to stable storage.
> +		 * There is no need for an extra flush on devices that only
> +		 * contain data or non-log metadata.
>  		 */
> -		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH_LOG;

This is the "wait for all previous iclogs" case, so yes, we only need to
flush the log device.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index cf1e4ce61a8c..7c72c3b3ffe1 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -71,12 +71,14 @@ enum xlog_iclog_state {
>  /*
>   * In core log flags
>   */
> -#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
> -#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
> +#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* all devs need REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FLUSH_LOG	(1u << 0)	/* logdev needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1u << 2)	/* iclog needs REQ_FUA */
>  
>  #define XLOG_ICL_STRINGS \
> -	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
> -	{ XLOG_ICL_NEED_FUA,	"XLOG_ICL_NEED_FUA" }
> +	{ XLOG_ICL_NEED_FLUSH,		"XLOG_ICL_NEED_FLUSH" }, \
> +	{ XLOG_ICL_NEED_FLUSH_LOG,	"XLOG_ICL_NEED_FLUSH_LOG" }, \
> +	{ XLOG_ICL_NEED_FUA,		"XLOG_ICL_NEED_FUA" }
>  
>  
>  /*
> -- 
> 2.53.0
> 
> 
