Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441B1346790
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761917103; cv=none; b=vCC9IPlZKU9KdHkmGfMHkVZAcq4CVZqPP4jCZljeIavZrLKmDrsflLbtLOIEO7DBibVjfd0fn9Hgdw9z/I8S15IBTdplGVCjOu9G1g38Z1QBr01T1/4wKmI4FyBnD4AjPHI+wptu81WSq3PvXIj4wC8f/Z6Y1Y8j/RRiT1hp1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761917103; c=relaxed/simple;
	bh=FQko4w9N2D+UNEqAtcWjSR66zvQCb/CHVESgMfnR6mU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDW4QZ0s90jS8MpW03MO+ZjrGojA46dGenUSS7cvXdaA729hxxA7v2PDJ4dgbKtD1MBis7pmXWaYxa96i8igM9SEoo9Ge0gL7Gxr5kLE8nzVMeMO+Dm8mFirLGNmJBRJ9xIrBTBhb6Sdg8feNeSdttgyU+qTt3QkwHBK/mUrkUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBS84Bno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBS84Bno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C20C4CEE7;
	Fri, 31 Oct 2025 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761917102;
	bh=FQko4w9N2D+UNEqAtcWjSR66zvQCb/CHVESgMfnR6mU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RBS84BnoXoChS3/rSW2USSyO/ySLLfVrhIkpmOKOFQxeQRxOupQEcP773zWn/1MwQ
	 NrUmS1BiRtJjfD6VuuRKN9VCjgIy0PHxIQkPF498VL16OmBy2Ai+dBHsfhICX9hnZO
	 y+3iqiCFXk+uTE+9XQXYfQvIvQ9nLYw6DzZtKV4Z00JXH/cpyOulaEcO4fpgylqd7T
	 qd3nbUWOOpvR4OG4BR6JhXXkm+3cdUofhpcubHF28juFk8lMvoC87H/BN7LgiIAZ0K
	 mYXJjA+iGfIJxVp7nhqODSPWA4hDT+tVMJKKe/RD+c7izjJeDSBy6SS8g/RT5gDH88
	 nUCeoIpzNcZIg==
Date: Fri, 31 Oct 2025 14:24:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/9] xfs: add a XLOG_CYCLE_DATA_SIZE constant
Message-ID: <7xdi7nnwhkqe464ylbxoxwayxo77phvuy5nvxpa74ekx7wv3xv@73mm7kx4yatl>
References: <20251027070610.729960-1-hch@lst.de>
 <kwdAy7x86lbi-aOr_Z2CpoqXjtLR86kxKo6EZCG8tKycJlgtiOhuogvWOwERKG4IZY2Y7g9f_npsRYfjJxaxAw==@protonmail.internalid>
 <20251027070610.729960-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-2-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:48AM +0100, Christoph Hellwig wrote:
> The XLOG_HEADER_CYCLE_SIZE / BBSIZE expression is used a lot
> in the log code, give it a symbolic name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
