Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807164;
	b=c6vfm6DXaoAu3MGibBUd1uRreKusIGkDrmVC0JhPqedujrYCiDnY3mhHe5G2Z7e/pgCO
	 WRTlaCoE4IO/prQXY1fASPR2NVVirpaqWfZBRo/zj8qr2Rf0Ky6U1wkGE2Lu3IxqX2l1v
	 rIrglce7ZX8g1H5aaV+KOpBOT4UdStkYmWdlYIUrZ8bKGtBnrLnj59w/Wo/S5bq5jHHkv
	 rShwf+TCB1y5EkDZhZ/MxLPScO9wv8Roj6XbbuQn3ozTLu/OPSk20zQ003ipVMwZgZ8Mq
	 DjSKJfOX90BqZmIhh5+tzN1ApAGY42xLJUkjUPoY65jTL54hpLf89HOD3daVrBMW8zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807164;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kTTIIZQ4xKgjpFowVG88Jmgc7wbdES5UMEopFJ2IzRc=;
	b=Fv5wnRfWBDigzgs/z6GR3cZhxloarsOCgTJapqDrfu0hhiLrzbQ4i0ZS48tqrcW7658X
	 dfFJ+e6T+gNSu7bLGmc1z42QpVV6+6j9XcvXL6IvXucoZbfR6wk4dCPy0mZBgKzPSf6GS
	 ENttwk5v/3JzzLaG+uJ5Lpj2m0Xf1WIYXjekYpG97mBepaqa+yhO/924QMOEKiKzIGQjz
	 FqYWV979PXfNaLqqhM4urqEfwDVa2m76zD773D61lyJJDxvpoUqepHZqKPBU0tDOjouWg
	 d4x945Zj+5Av0/GtFS92Bf+tk6c8T6/bsZE0Hpehy4y8W452ZNlfHLN4HYr+CdOK1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="a+EeV/5d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD565606A31B;
	Wed,  4 Nov 2026 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a+EeV/5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DD21F00919;
	Wed,  4 Nov 2026 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807163;
	bh=kTTIIZQ4xKgjpFowVG88Jmgc7wbdES5UMEopFJ2IzRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a+EeV/5doQGzknDGeXAOMunBtwIq79V+A1mlf9F8kaFtk6LCrCSjL7qRhy2THX08R
	 k6k3P6jqXn6c2SJwm7WQPIWZk8fD/M75vTwBApItzIRbFxMR78JjLP6hPPefdyq7um
	 6Yj4+hoj6DBv3y8Dd19VKx/yWZdZNAj3pQ6q8abKDwecYM7+EO42IFxns+DsyenHSq
	 vaYhPf5Il9tQnp4wlGndAUshVtv3jGwt8kqowzU4agczUgdmn9wv7r2f/Ru9kB7mbP
	 ZJJ4d4TxxJjG6xMkznWGbxy5nZ3Zy5I7zmFhgCUuHW/4Qi30qTRaviDpvvuQp1wk7K
	 cZiHiidCHTWDQ==
Date: Wed, 4 Nov 2026 16:45:58 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, kernel-team@meta.com, 
	Christian Andres Saide <csaide@meta.com>
Subject: Re: [PATCH] xfs: keep successful near rt allocations
Message-ID: <autTB937zQMYxbBb@nidhogg.toxiclabs.cc>
References: <20261104100115.36bf7d28@fangorn>
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
In-Reply-To: <20261104100115.36bf7d28@fangorn>

On Wed, Nov 04, 2026 at 10:01:15AM -0500, Rik van Riel wrote:
> XFS realtime allocations first attempt to allocate space near where
> other parts of a file already are. If that allocation succeeds, it
> does not have to do a global search for free space.
> 
> Unfortunately, a code cleanup a while ago causes xfs_rtallocate_rtg
> to unconditionally do the global search, even when the search for a
> nearby extent has succeeded.
> 
> Fix it by running the global search only when the near search did
> not find available space.
> 
> Found by noticing higher kernel CPU use and examining the profile.
> 
> Fixes: fd048a1bb391d ("xfs: rework the rtalloc fallback handling")
> Cc: stable@vger.kernel.org # v6.12
> Reported-by: Christian Andres Saide <csaide@meta.com>
> Signed-off-by: Rik van Riel <riel@surriel.com>

This sounds correct yes.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/xfs_rtalloc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 84efe5a8fb11..31d90828b4e9 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1997,10 +1997,14 @@ xfs_rtallocate_rtg(
>  		if (error == -ENOSPC) {
>  			xfs_rtbuf_cache_relse(&args);
>  			error = 0;
> +			start = 0;
>  		}
>  	}
>  
> -	if (!error) {
> +	/*
> +	 * Global search, runs when the near search did not find space.
> +	 */
> +	if (!error && !start) {
>  		error = xfs_rtallocate_extent_size(&args, minlen, maxlen, &len,
>  				prod, &rtx);
>  	}
> -- 
> 2.56.0
> 
> 
