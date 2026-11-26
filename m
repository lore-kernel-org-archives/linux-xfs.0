Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795717789;
	b=h++Ee1ZgAVsTmXAJW5RSklf6cqpMejTD6CYuOjPSc4rPxRATeh+NiiGYWr11fhlTLAXO
	 y3d5oeMUOSjveYuNwfry9Tm8H4d6Kdh7gj3oRLmikpDY2deAAtdpo5W0aVqHjowc4l+Oj
	 W7NyaDmgGUTD9lH7S+PRU68LEhJpyaF19q88+i+Z3Xl70LglklGFkfup8zeiQBKsnMIk2
	 D7vZFLLL+l8hzo0iu4haAwvOH9CEoYmmRY7u7Wo2IaJGmEgZfNHVuIVHGft5bVIX0OuG6
	 X5V5xgoPcE4WJjXDef7A7Z+Q/YnP6MUrTqiya4K0R0kQC1o6yqtXEqGwubDgCJWhntg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795717789;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1xBa9dGYGw8+GHqAY+jPmMhihMdrgV/VRFcTsTA4uD4=;
	b=aO9gsDqE3nyY7ms31B0/+sEEUyVkLJMPctj3BJRweyYadD4v7yT8DbyUbo4pI9aA5ChP
	 F0Rrk4Wh0MEI83SW4SgcYiwEB8UwflscB76OmBtvzO4qBmvvIXfIZ/RKEi5LBJVlS6/Yp
	 4Fd313ZnRnFtLouZLLPL+JS1hI3kUih8mUOnlHEL/clqpBOLKvhat3I9umrVc+b6Te7ak
	 /xqwulwvfRNQx8dZ7YodWffXOAaW6c+kCHUZ6UdNKSyUFxliAkOgWRCcaIQU038riCWqR
	 D5RfIFmhAQYdvVGXJFWeU7gj7Nrbnm3rp4J0PKqJZtj69W7Datocz4V6pIA3jPS488w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnOEJ9Zv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54135606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnOEJ9Zv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213D41F000CA;
	Thu, 26 Nov 2026 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717788;
	bh=1xBa9dGYGw8+GHqAY+jPmMhihMdrgV/VRFcTsTA4uD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WnOEJ9ZvC4wF7eK30ia0wWq7XeT7L7Z23Z168ZbGW08AcmNm2dJC5KsUvsYwPoc4K
	 qWnPIUICTppdtyJsxWK+D9+LrNC34tsL5rx3RTwO5oiWpEesfgZVqX+lCkaHIDzkMl
	 /e65acKmdYqpiO0pM/3ISHa6n0LvBb2pMJV79AEPAotzLXkvNpk/FeRO1zchh5gBrI
	 35Ud6zvaAcfE0S+aCl3OMv248Nxz+eaTKTOiJLo+5ykAZwdxW7WfqTfS30Z1JuGE5u
	 weAd50L2wRfF6W27wJsyjoa868OIgjeK+U5hPElM+Y8OdH2xBfT/pGJeAbVEl4gslU
	 yMRRh7QzrvJXg==
Date: Thu, 26 Nov 2026 19:29:45 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: don't bother setting oh_tid in callers of
 xlog_write
Message-ID: <awh6mZNL7-FTUwQ4@cronus.toxiclabs.cc>
References: <20261125144430.728485-1-hch@lst.de>
 <20261125144430.728485-2-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125144430.728485-2-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:22PM +0100, Christoph Hellwig wrote:
> xlog_write always stamps oh_tid into the ophdr written to the log, so
> don't bother setting in the callers as those values will always be
> overwritten.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c     | 1 -
>  fs/xfs/xfs_log_cil.c | 4 ----
>  2 files changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 74b324f915a1..9029e7856f1c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -841,7 +841,6 @@ xlog_write_unmount_record(
>  	} unmount_rec = {
>  		.ophdr = {
>  			.oh_clientid = XFS_LOG,
> -			.oh_tid = cpu_to_be32(ticket->t_tid),
>  			.oh_flags = XLOG_UNMOUNT_TRANS,
>  		},
>  		.ulf = {
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b54a421cab63..7ba4ef32479c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1189,7 +1189,6 @@ xlog_cil_write_commit_record(
>  	struct xlog		*log = ctx->cil->xc_log;
>  	struct xlog_op_header	ophdr = {
>  		.oh_clientid = XFS_TRANSACTION,
> -		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
>  		.oh_flags = XLOG_COMMIT_TRANS,
>  	};
>  	struct xfs_log_iovec	reg = {
> @@ -1237,12 +1236,10 @@ xlog_cil_build_trans_hdr(
>  	int			num_iovecs)
>  {
>  	struct xlog_ticket	*tic = ctx->ticket;
> -	__be32			tid = cpu_to_be32(tic->t_tid);
>  
>  	memset(hdr, 0, sizeof(*hdr));
>  
>  	/* Log start record */
> -	hdr->oph[0].oh_tid = tid;
>  	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
>  	hdr->oph[0].oh_flags = XLOG_START_TRANS;
>  
> @@ -1252,7 +1249,6 @@ xlog_cil_build_trans_hdr(
>  	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
>  
>  	/* log opheader */
> -	hdr->oph[1].oh_tid = tid;
>  	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
>  	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
>  
> -- 
> 2.53.0
> 
