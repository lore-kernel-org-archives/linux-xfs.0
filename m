Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719097;
	b=Es431GmYcqb5AH7c0yLaJQ7dnL+2gPeRDqqzc6Ydeno/fExAVqG9ACV2mOYC33puqEY5
	 PTeQDG2wFXEZpIfMAvHLwLlCym/SEHnUuPULev32e6YcUy8Jf79gWlEUGPT05X+XcjNWK
	 H7w5xC4B65MWWGDCz9DK47WsrZPulcrazboo5DcHpKfwjBnvs89RJf+Elf9dalcAxIQ21
	 a8XazvOmbi1xs92d8DZtyos6im2/JOleFrTFcBYrAXFVvB1yjTELlvpUT/EWmI1ICJsRy
	 irP8Bq98tiovunLh5QpePlbTbYiWcha3LDaC0VWAiVzIEIG/NDCLwXx8F4LeTYQY+8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719097;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OQ7wBtyaTzNDXpAJLl0QZ6AID9FrxDZ8+rz87O0ABEQ=;
	b=s9CjBHgW6iqjNQsBOyx1YYVjNR5lOULJZtZHW4QTtZGFFaE1tTwCkVVhM9rM+WkfuhCn
	 gTept/FDTjYlFDKokrcz75NbiPEVu8xu0u5XZoc1a1iLnxmkOrGL6nesjz7Ej+gIyJqNQ
	 V9JcN7/e/ooAxSYOCuy5fLTStW7Ho8/ocnu/uG+onx5YB2aalBbljuzhiRjkwJhdWguJY
	 ZlmUIvQ6snu2IttBRvZ+MAvb9Xd3AsfO82TlI3Ng+QpFx/rFiQYjLQ+Uj3tP7MEhBFQsC
	 C3tSWk5RQX8k5FIR5h5cxQo7CwWrNR5IPkBhu5To9J2YbzGCk14K9f/scy1VymUrjFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WM0sM5Tc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89466606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WM0sM5Tc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B21F000D8;
	Thu, 26 Nov 2026 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719097;
	bh=OQ7wBtyaTzNDXpAJLl0QZ6AID9FrxDZ8+rz87O0ABEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WM0sM5Tc3a8As09MowB1mC0yU8gdal0tvsxLODIZ+l2SRMgc7sCF1wzJw30eemJZk
	 gqJbEYuoBJxnxtXwhE3p8Jy/IpZSWzRpytjS+xglAn4+eomkVCqAdu9Za5/vPhZ2ML
	 a1VpkWVZo8Y+R6XSyKeak7W5+ounO3526F6xC2aofHJJ9Ov12v8jQU2iatbAVhOy/8
	 FgYcuFln3imu2ByIdhAPbKI7pPaGLfctWShuIwId8Rp72lIDpazjG18XBqiu/CTD1u
	 20zpsuLzdFTbMY1rFbNecJ6mLRWzxRAHI2mbioPeI5lYkBDJfVxTYU/5U5Vk/IF8px
	 W2axY2LLNQlzA==
Date: Thu, 26 Nov 2026 19:51:33 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: factor out a xlog_write_ophdr helper
Message-ID: <awh_tVjLikfuAmzn@cronus.toxiclabs.cc>
References: <20261125144430.728485-1-hch@lst.de>
 <20261125144430.728485-5-hch@lst.de>
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
In-Reply-To: <20261125144430.728485-5-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:25PM +0100, Christoph Hellwig wrote:
> Add a helper to format common bits of the opheader into a helper
> function to prepare for moving the opheader construction to common
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/xfs/xfs_log.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e6dbd532bbdd..68934406a48d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1992,6 +1992,20 @@ xlog_write_space_advance(
>  	return p;
>  }
>  
> +static void
> +xlog_write_ophdr(
> +	struct xlog_write_data	*data,
> +	struct xfs_log_iovec	*reg,
> +	unsigned int		rlen)
> +{
> +	struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> +	ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> +	if (rlen != reg->i_len)
> +		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> +}
> +
>  static inline void
>  xlog_write_iovec(
>  	struct xlog_write_data	*data,
> @@ -2022,11 +2036,8 @@ xlog_write_full(
>  	 */
>  	for (index = 0; index < lv->lv_niovecs; index++) {
>  		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> -		struct xlog_op_header	*ophdr = reg->i_addr;
>  
> -		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> -		ophdr->oh_len =
> -			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
> +		xlog_write_ophdr(data, reg, reg->i_len);
>  		xlog_write_iovec(data, reg->i_addr, reg->i_len);
>  	}
>  }
> @@ -2094,14 +2105,9 @@ xlog_write_partial(
>  				return error;
>  		}
>  
> -		ophdr = reg->i_addr;
>  		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
>  
> -		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> -		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> -		if (rlen != reg->i_len)
> -			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> -
> +		xlog_write_ophdr(data, reg, rlen);
>  		xlog_write_iovec(data, reg->i_addr, rlen);
>  
>  		/*
> -- 
> 2.53.0
> 
