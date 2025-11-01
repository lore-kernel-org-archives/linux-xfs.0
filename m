Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7CB635
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 00:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761955450; cv=none; b=kQALVaOjIN6xlvExASJc8o4bSsWa83fiTDlpLofgqcIO5i00QR6G/RRsXx8qm56gdyRJXRmFXI41/kxDvdpgaXEta5gt8kS5IxDHH3esRwZO97z1BPhruyhq792wYyf0Aj+81bRxpFeEUmA93jHXjBKPRtHIIEn3m0f4vnXVakY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761955450; c=relaxed/simple;
	bh=oR79pwl51yj/9QQzugL2CscfO8FqPkrqPdlMChr8fI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYGj96xgCZUgox2CxXIaW4Vg42pFdJHIJfjXMx7Sy1nXCfE5pUDh58aGtcFDAM/DzTJbKqwn/nDIeuqd/HM+bgEpdm7vo8YcdI8O9KIYdf8W8ujz19vPkTsuqIqe2y3qFRrDPp/V+Cgauu3XG1b51r1w6OnMBsimGBjkssQgBb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olzdDxRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olzdDxRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F4FC4CEE7;
	Sat,  1 Nov 2025 00:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761955450;
	bh=oR79pwl51yj/9QQzugL2CscfO8FqPkrqPdlMChr8fI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=olzdDxRMG+1KLsTnIcBrTHusotIwMNVjhUw7YMBZ3h+MW26WHnJrvAbAlJIjbCB1z
	 DRpkq/KOW0e5QwjGmKX6xpLCDhhfwnARmT2evMVt1xngbwOIiwsDenUhO2Otb2yAqw
	 uATxItVOM2w0r3yqeSzU/V0kkFcOvjwFubsyCPgZSCW0ujB8aD/HbOtUNTPqa5uTNX
	 YdLCGt4nAkO2K4mo2F7lVD88C445GqZ9oDukm6sXxEx6l7yYV1bJS15w1mEFlxcjvZ
	 I+enIYkuXimUsKSAJfUuTg57L36l7LICqV7OdnNrPiAisxcZc37W+bBcw4iMUoU/I9
	 Rx2G34T6eRaIQ==
Date: Fri, 31 Oct 2025 17:04:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251101000409.GR3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-3-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:12PM +0100, Christoph Hellwig wrote:
> lv_bytes is mostly just use by the CIL code, but has crept into the
> low-level log writing code to decide on a full or partial iclog
> write.  Ensure it is valid even for the special log writes that don't
> go through the CIL by initializing it in xlog_write_one_vec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ed83a0e3578e..382c55f4d8d2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -858,14 +858,15 @@ xlog_write_one_vec(
>  	struct xfs_log_vec	lv = {
>  		.lv_niovecs	= 1,
>  		.lv_iovecp	= reg,
> +		.lv_bytes	= reg->i_len,

I'm surprised that nothing's noticed the zero lv_bytes, but I guess
unmount and commit record writes have always wanted a full write anyway?

Question: if lv_bytes is no longer zero, can this fall into the
xlog_write_partial branch?

--D

>  	};
>  	LIST_HEAD		(lv_chain);
>  
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= reg->i_len;
> +	ticket->t_curr_res -= lv.lv_bytes;
>  
>  	list_add(&lv.lv_list, &lv_chain);
> -	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
> +	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 
