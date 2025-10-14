Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21118C933
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476570; cv=none; b=aZGMs3X3ZRrvlR52MTqV2e4faBVYWQO0seXAZsVwj0N2gK+Yzj9EVroegeiEOQ0UwDMp3YThnUzo4lV3byBRGAMJLeVEwAch1Y98nU+00sJBS1WHVz4GXJza4eDb5LbXbovQNbNhVxM3CTVw580Z18I6O13znRrali/OyEMhgVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476570; c=relaxed/simple;
	bh=X6Xn8tZ9Drk7wDvcGevJgw2jPWGZkRkc+O6DPw/MQLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBbhm8dezaYmGlQb8gZAkwSqeleVqtwWfYieOvV+lfDy1f/UpOvzKW2yrFVPM4dRkiqvROn2JeqjPjDNotKCAFiQLFK8AmL5yEBfF5QHyNoGAEL/OGWLDwJaIDGNGglbBu6UkhKBZNI+n5GcV0p5vR0UeFq9AdBFzerfLUFR4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtNShOgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtNShOgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E75C4CEF9;
	Tue, 14 Oct 2025 21:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476569;
	bh=X6Xn8tZ9Drk7wDvcGevJgw2jPWGZkRkc+O6DPw/MQLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mtNShOgr8xMh/7QrAxbycNb7SOmn4vdXAaI01UmySU3bWaSmwDYrkdsmjQkBal8ld
	 USs07LB4YQ6p2fitvbzxIdyd+hY8NHnH+KEHOTFBkwdhHDjPGpqMHeSAg078xqdgX5
	 gIF7ebXeC1rnNPP2ge2Y1A34b1qVe5Z8+6hh88jRMJuEPZMwImUMApgvbrydxNMaHW
	 9YtFz4jKQBOMaQDIBC/greB5eK16zg9OsXgxC/mBbjxkYelWB7ovpWqqto8ugY1bcx
	 nfajaBg3GxYbR/zT5AeYjnOmtiRqU4AxJ30l12Z0hjAAiOlCVUYg/xc43B66yM8+zY
	 6o2gWPKNeEGbA==
Date: Tue, 14 Oct 2025 14:16:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>, f@magnolia.djwong.org
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: add a XLOG_CYCLE_DATA_SIZE constant
Message-ID: <20251014211609.GG6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-2-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:05AM +0900, Christoph Hellwig wrote:
> The XLOG_HEADER_CYCLE_SIZE / BBSIZE expression is used a lot
> in the log code, give it a symbolic name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Simple enough conversion...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
>  fs/xfs/xfs_log.c               | 18 +++++++++---------
>  fs/xfs/xfs_log_recover.c       |  6 +++---
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 6c50cb2ece19..91a841ea5bb3 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -31,6 +31,7 @@ typedef uint32_t xlog_tid_t;
>  #define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
>  #define XLOG_MAX_RECORD_BSIZE	(256*1024)
>  #define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
> +#define XLOG_CYCLE_DATA_SIZE	(XLOG_HEADER_CYCLE_SIZE / BBSIZE)
>  #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
>  #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
>  #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
> @@ -135,7 +136,7 @@ typedef struct xlog_rec_header {
>  	__le32	  h_crc;	/* crc of log record                    :  4 */
>  	__be32	  h_prev_block; /* block number to previous LR		:  4 */
>  	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
> -	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
> +	__be32	  h_cycle_data[XLOG_CYCLE_DATA_SIZE];
>  
>  	/* fields added by the Linux port: */
>  	__be32    h_fmt;        /* format of log record                 :  4 */
> @@ -172,7 +173,7 @@ typedef struct xlog_rec_header {
>  
>  typedef struct xlog_rec_ext_header {
>  	__be32	  xh_cycle;	/* write cycle of log			: 4 */
> -	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
> +	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
>  } xlog_rec_ext_header_t;
>  
>  /*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 603e85c1ab4c..e09e5f71ed8c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1533,7 +1533,7 @@ xlog_pack_data(
>  
>  	dp = iclog->ic_datap;
>  	for (i = 0; i < BTOBB(size); i++) {
> -		if (i >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE))
> +		if (i >= XLOG_CYCLE_DATA_SIZE)
>  			break;
>  		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
>  		*(__be32 *)dp = cycle_lsn;
> @@ -1544,8 +1544,8 @@ xlog_pack_data(
>  		xlog_in_core_2_t *xhdr = iclog->ic_data;
>  
>  		for ( ; i < BTOBB(size); i++) {
> -			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> -			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> +			j = i / XLOG_CYCLE_DATA_SIZE;
> +			k = i % XLOG_CYCLE_DATA_SIZE;
>  			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
>  			*(__be32 *)dp = cycle_lsn;
>  			dp += BBSIZE;
> @@ -3368,9 +3368,9 @@ xlog_verify_iclog(
>  			clientid = ophead->oh_clientid;
>  		} else {
>  			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
> -			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
> -				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> -				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> +			if (idx >= XLOG_CYCLE_DATA_SIZE) {
> +				j = idx / XLOG_CYCLE_DATA_SIZE;
> +				k = idx % XLOG_CYCLE_DATA_SIZE;
>  				clientid = xlog_get_client_id(
>  					xhdr[j].hic_xheader.xh_cycle_data[k]);
>  			} else {
> @@ -3392,9 +3392,9 @@ xlog_verify_iclog(
>  			op_len = be32_to_cpu(ophead->oh_len);
>  		} else {
>  			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
> -			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
> -				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> -				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> +			if (idx >= XLOG_CYCLE_DATA_SIZE) {
> +				j = idx / XLOG_CYCLE_DATA_SIZE;
> +				k = idx % XLOG_CYCLE_DATA_SIZE;
>  				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
>  			} else {
>  				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 549d60959aee..bb2b3f976deb 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2866,7 +2866,7 @@ xlog_unpack_data(
>  	int			i, j, k;
>  
>  	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
> -		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
> +		  i < XLOG_CYCLE_DATA_SIZE; i++) {
>  		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
>  		dp += BBSIZE;
>  	}
> @@ -2874,8 +2874,8 @@ xlog_unpack_data(
>  	if (xfs_has_logv2(log->l_mp)) {
>  		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
>  		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
> -			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> -			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> +			j = i / XLOG_CYCLE_DATA_SIZE;
> +			k = i % XLOG_CYCLE_DATA_SIZE;
>  			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
>  			dp += BBSIZE;
>  		}
> -- 
> 2.47.3
> 
> 
