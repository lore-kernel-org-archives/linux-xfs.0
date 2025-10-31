Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3726F2264B8
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920186; cv=none; b=ukKWnzhmb7dLQFxSaEfuj4oBMcTiykteD8Aeb7gRa17aNqBHNOqc3Qpwg5Y/tUwJ6orHfbUdNPNzdxlJHuAivjY9F4rFbshiZXZmqqlOoUlGHDo5HCuLEDifYcRFarIEirO17Ws5itgyO4xg8Y79i8xWsRSSyFLiS+wegTQhVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920186; c=relaxed/simple;
	bh=PWeSX6V/dYBpilIWPpaIIFvHmG085hMSM5Us0ecxeww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSBSEv0BpkQmvgMmOurkIGWUKZziDPzF6yEih40fK0HnhvO5NzVZcmdU9lxnnvA0AcapdycTfFZaW2xqo8zF3heU9yEHy064q2DrVbi2eNFVksCHWnMGh23L+Cy4Me64C+uwE1U6rjSj20nMiAauNt4bVbc1cQSY/AjIk7R7MtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlUnVYh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlUnVYh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE949C4CEE7;
	Fri, 31 Oct 2025 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761920186;
	bh=PWeSX6V/dYBpilIWPpaIIFvHmG085hMSM5Us0ecxeww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlUnVYh8eo5Q+dZnDJoaxBx5BBEdXi6k2RciEpImi2d9sEOutG+GJgMscx2iJuMQP
	 WWqQV2se6ujgP3yxlm5YRbV8mWwn90SrSA09spqafsvmRO+WPgDg6W6lJv2KsMLyNS
	 gJ70NJFT/p+LPicZE8unZDFXgWb1lQz5QwR21uFfGddhBn9AC/NH2tnic31SJEjIT9
	 lQ2DO1/HjShm8XuMLPVMHRCAutPCeRK0MkxDN/UgT70GXexA1e0mD3PqJVmGfXK7uy
	 BqVouO7VlaWjuzYrn96bz4ZTomChselTtUZh7AAn+oDKeGK+hRU0/CxHI+xII2UlZr
	 Masjk9YWx30yQ==
Date: Fri, 31 Oct 2025 15:16:21 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 9/9] xfs: remove the xlog_in_core_t typedef
Message-ID: <sif3sjnwcetl74rmhef3c2d2mjq7agsa4qzup6vhmvnttyid2e@sniewzc4rxm3>
References: <20251027070610.729960-1-hch@lst.de>
 <Hu2STDddEzjNMGoiSDKj4mMiMR8jII1H5d7FTWeJfm1AOT20jKk7mA4BBsaEQkadm1nTxilHuJbGEUVkzBl3PA==@protonmail.internalid>
 <20251027070610.729960-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-10-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:56AM +0100, Christoph Hellwig wrote:
> Switch the few remaining users to use the underlying struct directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c      | 18 +++++++++---------
>  fs/xfs/xfs_log_priv.h |  6 +++---
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 47a8e74c8c5c..a311385b23d8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1368,8 +1368,8 @@ xlog_alloc_log(
>  	int			num_bblks)
>  {
>  	struct xlog		*log;
> -	xlog_in_core_t		**iclogp;
> -	xlog_in_core_t		*iclog, *prev_iclog=NULL;
> +	struct xlog_in_core	**iclogp;
> +	struct xlog_in_core	*iclog, *prev_iclog = NULL;
>  	int			i;
>  	int			error = -ENOMEM;
>  	uint			log2_size = 0;
> @@ -1813,10 +1813,10 @@ xlog_sync(
>   */
>  STATIC void
>  xlog_dealloc_log(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xlog_in_core_t	*iclog, *next_iclog;
> -	int		i;
> +	struct xlog_in_core	*iclog, *next_iclog;
> +	int			i;
> 
>  	/*
>  	 * Destroy the CIL after waiting for iclog IO completion because an
> @@ -3293,7 +3293,7 @@ xlog_verify_iclog(
>  	int			count)
>  {
>  	struct xlog_rec_header	*rhead = iclog->ic_header;
> -	xlog_in_core_t		*icptr;
> +	struct xlog_in_core	*icptr;
>  	void			*base_ptr, *ptr;
>  	ptrdiff_t		field_offset;
>  	uint8_t			clientid;
> @@ -3481,11 +3481,10 @@ xlog_force_shutdown(
> 
>  STATIC int
>  xlog_iclogs_empty(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xlog_in_core_t	*iclog;
> +	struct xlog_in_core	*iclog = log->l_iclog;
> 
> -	iclog = log->l_iclog;
>  	do {
>  		/* endianness does not matter here, zero is zero in
>  		 * any language.
> @@ -3494,6 +3493,7 @@ xlog_iclogs_empty(
>  			return 0;
>  		iclog = iclog->ic_next;
>  	} while (iclog != log->l_iclog);
> +
>  	return 1;
>  }
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 17733ba7f251..0fe59f0525aa 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -181,7 +181,7 @@ struct xlog_ticket {
>   * We'll put all the read-only and l_icloglock fields in the first cacheline,
>   * and move everything else out to subsequent cachelines.
>   */
> -typedef struct xlog_in_core {
> +struct xlog_in_core {
>  	wait_queue_head_t	ic_force_wait;
>  	wait_queue_head_t	ic_write_wait;
>  	struct xlog_in_core	*ic_next;
> @@ -204,7 +204,7 @@ typedef struct xlog_in_core {
>  	struct work_struct	ic_end_io_work;
>  	struct bio		ic_bio;
>  	struct bio_vec		ic_bvec[];
> -} xlog_in_core_t;
> +};
> 
>  /*
>   * The CIL context is used to aggregate per-transaction details as well be
> @@ -418,7 +418,7 @@ struct xlog {
>  						/* waiting for iclog flush */
>  	int			l_covered_state;/* state of "covering disk
>  						 * log entries" */
> -	xlog_in_core_t		*l_iclog;       /* head log queue	*/
> +	struct xlog_in_core	*l_iclog;       /* head log queue	*/
>  	spinlock_t		l_icloglock;    /* grab to change iclog state */
>  	int			l_curr_cycle;   /* Cycle number of log writes */
>  	int			l_prev_cycle;   /* Cycle number before last
> --
> 2.47.3
> 
