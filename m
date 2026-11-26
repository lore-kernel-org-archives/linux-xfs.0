Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719087;
	b=XNwjJ2710Z8gajXxYwOkC/JwK1WatpE1pP04NuLIDEL7RpW3uGOX6UXuTlYojBhDwavJ
	 Je7b5zJD0/aCbSErjMw0uXPvky1hHXflJrlYvww4u6VdPOBXP8cxhfr/GCDqDl2G2JQak
	 cO1PedYkY305O9PacPmzTZmZ8tPQju5uzKTGSEHpHifO1o2zs7Rucy5hGtzK07wTV2bd5
	 Qk2scWslEboKQkE9uDEgvKAbTVftIfQ2GLEqNZZpLOm9sX7Ajvt2x77LVQtVUWSHl1Pg1
	 4p/j+ZhlXOdyaDNDHKzVZE/RKxRk9hebb04+1dshiD8W/4pdeBxGPGW+DxgzDiYdZig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719087;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ENLnwlAOzyRpJWBW+00Zdp5OUfWHMTxDSnGxL6GY24k=;
	b=LCEZky42xaTuiGHlkI4QAwhrWSCMlAXgdtZWpZiPYdUhFNRqR+j6aRm54/uOBpG1Ruir
	 15hSLuXX1E0a4+P7Rk+msIzp3H4tI2IqDYXjagZ8WXEqZDiN/NW1K5UrPSGxEt2b9PtwX
	 GFnSaRyDZ3knLgYcitFzz13mbYR/gRPjM9Kgl9tb0BaMqFdjpvgNH+1BomMemaIrnQ9tD
	 j+OTn0qcHI0VUDRQn/SzctDbDu5I3AUh2aI77DcKlO7fcsdeL3krgFeNkizO61H1PWmGO
	 K4RqpbrVFUSZq8R9QC8X6yKVoF8vm0CmSG31WqKW4cK7QlJfLSTaRazRP4qihWCXY7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0cYsdXX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D8E606A323
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0cYsdXX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFF71F000C6;
	Thu, 26 Nov 2026 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719086;
	bh=ENLnwlAOzyRpJWBW+00Zdp5OUfWHMTxDSnGxL6GY24k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l0cYsdXXdxipPpOCb1hva+RnjnOh3YVW5M4xSuqECoviXxU5Vw8SS+up8srEwHPZ2
	 kCgu9KXoE2D+MhSapekwbi2KMy5mLmvTas4rQ212gYMU1UADzq690MC0EyBiG/GdQ0
	 IMLxjnTuA7EBGYAjmncS9CZdiWdMAjAkiwqYc4GC6qo/Olfg9N5qTJpi7UWE1uvq80
	 xdpUlgLoBWkBJ4a914Gt3MJ8UJB/SpHTu77UsNZd4GijENM1uVrjbDTpE47LSmCuvb
	 Sh5e8XLOaiyMdJ98ycyuJ7y6Y+3BPxTPfYm6XvRXNb2nFxYp+oD5s6r7KA17iDhpuQ
	 jkoGTRNJ0B76A==
Date: Thu, 26 Nov 2026 19:51:22 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: always set oh_len in xlog_write
Message-ID: <awh_ql7E0-Ac4E-q@cronus.toxiclabs.cc>
References: <20261125144430.728485-1-hch@lst.de>
 <20261125144430.728485-3-hch@lst.de>
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
In-Reply-To: <20261125144430.728485-3-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:23PM +0100, Christoph Hellwig wrote:
> xlog_write_partial already updates oh_len to match the split regions.
> Also set oh_len based on the log iovec in xlog_write_full so that the
> callers don't have to also set the length.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c     | 2 ++
>  fs/xfs/xfs_log_cil.c | 9 ---------
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9029e7856f1c..7a067cfe59e6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2025,6 +2025,8 @@ xlog_write_full(
>  		struct xlog_op_header	*ophdr = reg->i_addr;
>  
>  		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
> +		ophdr->oh_len =
> +			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
>  		xlog_write_iovec(data, reg->i_addr, reg->i_len);
>  	}
>  }
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7ba4ef32479c..c7c3fa29eaa8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -470,7 +470,6 @@ xlog_format_commit(
>  {
>  	struct xfs_log_vec	*lv = lfb->lv;
>  	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
> -	struct xlog_op_header	*oph = vec->i_addr;
>  	int			len;
>  
>  	/*
> @@ -486,13 +485,6 @@ xlog_format_commit(
>  
>  		memset(buf + data_len, 0, len - data_len);
>  	}
> -
> -	/*
> -	 * The opheader tracks aligned payload length, whilst the logvec tracks
> -	 * the overall region length.
> -	 */
> -	oph->oh_len = cpu_to_be32(len);
> -
>  	len += sizeof(struct xlog_op_header);
>  	lv->lv_buf_used += len;
>  	lv->lv_bytes += len;
> @@ -1250,7 +1242,6 @@ xlog_cil_build_trans_hdr(
>  
>  	/* log opheader */
>  	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
> -	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
>  
>  	/* transaction header in host byte order format */
>  	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
> -- 
> 2.53.0
> 
