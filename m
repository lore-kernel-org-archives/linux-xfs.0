Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628296;
	b=ZOScQYoI6iAJ4xaLGtghg4YA9Whx2E9sXavdDIyQUjxlC6RFLbwIsP1Zo3+wNzsfLrWo
	 j5NsbWdXgvBWKKijBnajQWgAaVUuF0mljkx0gdQgd50JaqvFwfsvzMIZjnWhwyyhCq0HC
	 0gmirk6Z/uLgMKEhuyxe7/iM0cWOp18II9B9lkYKlmSKxhdy4NJRrPzCWN/FfVDJE1+7O
	 hmwzkykNAk8VLVhc8MXTzF07huqUpQyRNGris9+rSQ7z2SuxLo73fY6pQrhoJp9TIn/Ib
	 PrkXeQvTUNAUyjOLZ3tuxCYpDput2FJNCgm+WsU/GlLyF4OLDfMhwlkSK/mlbwJiPCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628296;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YxMiXLQihJ0asnXw5sRiFB1zGJfVngEqOnCZhjIasaI=;
	b=C/ifw0mNUY93UlCl21y8807C6craJDFiNZfuxRX95AwnZCrardES/mbCo5KPPcjEqdVD
	 ub8GdGVENJ8pS010dVTtGoaIzR1SK3BU7dU3dW4kSuT/4AN8LVgDFgzHz0ygmXXXQ2Nkv
	 fi+J6Sah9C6l+ydQsY8NBaht357/eqECe7dZNtbto2WOIakAHQ0opTu1G0cHJIG2DuwH6
	 ctbxdqUvB6dvKaZCLKXdumA3rEZigvn0N785OmY57Ok16O0Q0/nnGPMaKhEbGRx9eryg0
	 ZIAg+WDKiwCr2uNDtuytfkS8fWTTVY/tlINNXETX68gPqwqi770UTq+aTh3kItYDrFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WNrYdZmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70303606A338
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WNrYdZmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E7F1F000D1;
	Wed, 25 Nov 2026 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628295;
	bh=YxMiXLQihJ0asnXw5sRiFB1zGJfVngEqOnCZhjIasaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WNrYdZmQ+FfD8bNlLHs6lfpeVuChe4YSkes3GDkunJFfSIET1ZMg6fpVlODgPH6hD
	 fMq9EZ4QCHPeLqxHfcFfMYImZMadH+mDxcPuSNZ2HWlbcGgAV4bqMNhUnXNuWcxCWf
	 NB5bUopanHSGe1+NYV0IOvXnR7/5pTvRpUTc4EwcxpFGYZIbJc/U352OcpuLvSU+o+
	 6BqvJEu0zH8hCslTqaFCOp1qB8IaQZ18SDBBAWi+OcDsHO0HMCAoRO3BXKXnIBF5HW
	 ZGGFyMVS88Qfjr3aw/F1c/uxcucLnYoqSTgv3uHblfnsaxEtKVYLnAlG6UAhc+QgWO
	 wViYwi1u2D9Pw==
Date: Wed, 25 Nov 2026 18:38:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awccmN95lHSd7vp2@cronus.toxiclabs.cc>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
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
In-Reply-To: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>

On Wed, Nov 25, 2026 at 06:16:45PM +0100, Alejandro Colomar wrote:
> We want to pass the character array, not a pointer to it.
> 
> This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> "xfs: start creating infrastructure for health monitoring").
> 
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Alejandro Colomar <alx@kernel.org>
> ---
>  fs/xfs/xfs_healthmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 2bdd747f1ead..56d19ffb02b3 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
>  		return false;
>  	if (hmo->format != XFS_HEALTH_MONITOR_FMT_V0)
>  		return false;
> -	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
> +	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
>  		return false;
>  	return true;

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  }
> -- 
> 2.55.0
> 


