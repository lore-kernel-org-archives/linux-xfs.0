Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719110;
	b=Za0B/dwS7grzAXNsGEt6PxzeACc4QAyWKFTkZXFioYVrySGCE+9QWgUw/OymgS4aixSD
	 yU0lJ2Ti2IOJZfKh1GKuQRAvOZ3G9Pox9nUwSDUrUwCFr7WO7Hlzi7fzyNcfERpv+jLu4
	 UDEeTb7QqLyYgQsTSkAB7dJBgqOjYI1tZjGmC1Ly+lPUEZvxhLiCoqqbCs6XuDFd8aBlv
	 Td7P569X+LzmzafAM9X4Cx8ROe1RkWANSn3WCa4aJSXhPgjrvk95ooakXSCfQlI7jq7ea
	 6wpkKFYI79z8S+E4RtVHpeAUhi9XZtiNGmQvAk40CDKiMMAVahD27uBVHwiMmOEswzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719110;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DXnBHb/0q4x9IXkCpbic8r1G+p3MOY7gXyDnu9DstNg=;
	b=5rkoxF2ldyEAJ9+WrhTcwcjdyQ5lBPegETyVYdHMXLyruU7OelX7eJpGKMRc6A4dsy8F
	 FDCEQ9cG6XhLgSg3hoyBIG0zFqQt/xGTg02wFsdYxXNKlgXYh6S/FcJP22xPxg+5SPd0h
	 EVDn6cC2cNChE00Hny+J0AmmT7/2DAyxnEF1oAWLVCEkWE5ejv4RG3Lifev2L35odhhXy
	 lEppSrSVREtVtgHHWPxEmOLJcWIQogz09ZpzDO8icrn1SSP9A3XL3UFGs9OdDkU5+PP4k
	 JVw2qmNXEt2thz3+HEWGEVDw7m2IV4D6cCi/VovrBgm4mXdisQnTBltP76Q/QAAJk+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HK8/15g/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71C9606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HK8/15g/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B521F000D8;
	Thu, 26 Nov 2026 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719110;
	bh=DXnBHb/0q4x9IXkCpbic8r1G+p3MOY7gXyDnu9DstNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HK8/15g/Ek6M8XW87u+yJbAz7fKE/jnXTpkEfRlJ4otnn3dCwWB4bxFpxLf/9BY9A
	 Msa7aJjwyP220gXxio9aO8UPBL2jQXS2jQ1IOJSyZzXGcPsU2K8F+dqhDhzqtdPTb6
	 10j1tyS9qEZOMuJd8SPsTi3N472PbsMS6mj/PhHPEDXtjOJ9Wg+h+3bZv2157cyO1T
	 rNbIDRmG1JTLcsCCci9/QRJWlowm77UiBp24tcYsJFVFjl5W/pvDAoVnnDtx36diK2
	 gJqMN+hIAywuVpxoTIAnmGGpoJI0kks4rVnhiG/GmMigOnMGhdP0dIy8MadpvDuUSt
	 aEspALz/SG6Ww==
Date: Thu, 26 Nov 2026 19:51:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: factor out a xlog_write_cont_ophdr helper
Message-ID: <awh_wueCbvrnwqNq@cronus.toxiclabs.cc>
References: <20261125144430.728485-1-hch@lst.de>
 <20261125144430.728485-6-hch@lst.de>
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
In-Reply-To: <20261125144430.728485-6-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:26PM +0100, Christoph Hellwig wrote:
> Factor out the continuation opheader formatting code into a helper so
> that the formatting logic is separate from the processing loop in
> xlog_write_partial.  This prepares for generating the opheaders on the
> fly, but also helps the code structure as-is.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 54 +++++++++++++++++++++++++-----------------------
>  1 file changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 68934406a48d..9c2c02880384 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2006,6 +2006,33 @@ xlog_write_ophdr(
>  		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  }
>  
> +static uint32_t
> +xlog_write_cont_ophdr(
> +	struct xlog_write_data	*data,
> +	uint32_t		rlen)
> +{
> +	struct xlog_op_header	*ophdr;
> +
> +	ophdr = xlog_write_space_advance(data, sizeof(struct xlog_op_header));
> +	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> +	ophdr->oh_clientid = XFS_TRANSACTION;
> +	ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
> +	ophdr->oh_res2 = 0;
> +

	Shouldn't the new helper also update the ticket reservation?


> +	/*
> +	 * If rlen fits in the iclog, then end the region continuation.
> +	 * Otherwise we're going around again.
> +	 */
> +	if (rlen <= xlog_write_space_left(data)) {
> +		ophdr->oh_flags |= XLOG_END_TRANS;
> +	} else {
> +		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> +		rlen = xlog_write_space_left(data);
> +	}
> +	ophdr->oh_len = cpu_to_be32(rlen);
> +	return rlen;
> +}
> +
>  static inline void
>  xlog_write_iovec(
>  	struct xlog_write_data	*data,
> @@ -2077,7 +2104,6 @@ xlog_write_partial(
>  	struct xfs_log_vec	*lv,
>  	struct xlog_write_data	*data)
>  {
> -	struct xlog_op_header	*ophdr;
>  	int			index = 0;
>  	uint32_t		rlen;
>  	int			error;
> @@ -2145,31 +2171,7 @@ xlog_write_partial(
>  			error = xlog_write_get_more_iclog_space(data);
>  			if (error)
>  				return error;
> -
> -			ophdr = xlog_write_space_advance(data,
> -					sizeof(struct xlog_op_header));
> -			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> -			ophdr->oh_clientid = XFS_TRANSACTION;
> -			ophdr->oh_res2 = 0;
> -			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
> -
> -			data->ticket->t_curr_res -=
> -				sizeof(struct xlog_op_header);
> -
> -			/*
> -			 * If rlen fits in the iclog, then end the region
> -			 * continuation. Otherwise we're going around again.
> -			 */
> -			rlen = reg->i_len - offset;
> -			if (rlen <= xlog_write_space_left(data))
> -				ophdr->oh_flags |= XLOG_END_TRANS;
> -			else
> -				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> -
> -			rlen = min_t(uint32_t, rlen,
> -					xlog_write_space_left(data));
> -			ophdr->oh_len = cpu_to_be32(rlen);
> -
> +			rlen = xlog_write_cont_ophdr(data, reg->i_len - offset);
>  			xlog_write_iovec(data, reg->i_addr + offset, rlen);
>  		}
>  	}
> -- 
> 2.53.0
> 
