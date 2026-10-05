Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2237742CB1E
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 09:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191588; cv=none; b=AmuCy9uCvYCwQ7SIY7YMhx1fiHCGZur7dX6DU3j52hGZftnJryHIDZIBfvvcC670RBcogC/TakDFtAE9ksJdGKKWu+1PFTpnj9Eaq9I4ZwX+87WWXptst35ZQ54RJzi+bFpr/aCHa55pWlB76PCIps/NhNx3YRrmvhgz/LHl52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191588; c=relaxed/simple;
	bh=d+TpL5QNGsBO6aUwOAAzFEQi1PO+bcOxnbJSI/ihtug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAJ6zZKtaDVHOSd6RboWfElUZqO8LxieSCKBgksRJGZHPCDqyWf6+Khxk3AMqDPwYyXJm+c/WnmCyIii7apR5e7V2j31rCpHWO8WKQ23aIgMMFWXJNOQd+Z0TIaAvW9R1mTAYrE6O/WlJZ+722RExe8RJtsXN8GX6LmAboF1xoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKtLRsQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKtLRsQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA06B1F000FF;
	Mon,  5 Oct 2026 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791191586;
	bh=I7UyBi+Vd7hIQDBw2cqf3dfwF6Fj5m3P8op+Jxv6hkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JKtLRsQYBLpWd8NgL3ZO927SKTfA1zOzA83G4BmOAFEalDLnnsWZnoNFomQr3Go5c
	 z4dk05unNluukhcwum2P+3eMofb/zzWButJTesxkCHdEhae1eFeO8RMgL99U7ZIyxH
	 MI/57VL8NuPUWKjrTvdRNLSAPosQ/Ka1D72EIEFWB1TszTKBaSDdD5hJ1/0SQN8v9u
	 +JfZIfiJ3O5aXZWKb1iXiWxv6xHEUQmtqjAL2WetxuOZyoC0sgPePTLznC4TYhg+C5
	 /pt/OZZUD5Dz4hMOEFW6geXHoLKaDG0FaO7z5/HNNBq+Abgwjhx6v7mI5NGzJIU1I6
	 A0kfo71oFYBXw==
Date: Mon, 5 Oct 2026 11:13:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: optimize cache flushing for CIL commits on
 multi-device file systems
Message-ID: <asNqGFpAiZz3LyDO@nidhogg.toxiclabs.cc>
References: <20260925151543.3382123-1-hch@lst.de>
 <20260925151543.3382123-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925151543.3382123-3-hch@lst.de>

On Fri, Sep 25, 2026 at 05:15:37PM +0200, Christoph Hellwig wrote:
> While the flush before writing a start record needs to cover data on the
> data and possibly RT devices, the flush before writing the commit record
> iclog only needs to ensure previous iclogs are stable on disk.
> 
> Split out a new XLOG_ICL_NEED_FLUSH_LOG flag out of XLOG_ICL_NEED_FLUSH
> to signal that only the log device needs to be flushed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c      |  6 ++++--
>  fs/xfs/xfs_log_cil.c  |  9 ++++++---
>  fs/xfs/xfs_log_priv.h | 10 ++++++----
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f4f81d893e8c..893ea899a0a8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1619,12 +1619,14 @@ xlog_write_iclog(
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
> index 9446ac44ba88..b54a421cab63 100644
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
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 6d9673c41cdf..529720a4984b 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -71,12 +71,14 @@ enum xlog_iclog_state {
>  /*
>   * In core log flags
>   */
> -#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
> -#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
> +#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* all devs need REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FLUSH_LOG	(1u << 1)	/* logdev needs REQ_PREFLUSH */
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
