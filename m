Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC34530569B
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411184; cv=none; b=YZQAgRqV1CS1LGAoC+KolV1cKa/rSMPWKzBTQ4afPcp2FjlYevosChOp3MS2P56gSsVnum4carHxjY/LP9MbJtAq4T1OH9OXE3oDci7ItiRT9w8dYSyMshtQKE+O9bjHz4H/q1BLxDssJb6BHIumJTwVPbZGjEyTVW9P+UOBES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411184; c=relaxed/simple;
	bh=VNZs/0Kl99qbhXtKqdFfD4mC+JvXM2j+vjg38T4psdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OovT2+WzAc85sk1qmSXZ8FfXM1ZEr2uZhKvu7loW/O7qlBxtgRmwA2O9VhQxNvHlqN41h2yq3wNk9KvCi8EtjJKG+Ad/awW4KoVXBKEWbQe+j2q80SvYq9sr9ec2B9SfxpdI9RHXCiSAF83AomW0GLySM8qAIDbiVGQQ70JF9NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MC6u1dv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MC6u1dv2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4D741F000E9;
	Thu, 25 Jun 2026 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411183;
	bh=o0B1txZSpFHOswkCbV2vT2+cA74hRb4UNoOXwziO/Q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MC6u1dv20Oo/aQVdlOgJsQchJI+PzVrVfB+fytqEnVG76rdrJLkzn1r3TOfNwIlem
	 fER6UjbkRjun0bngSnoXnfMMKwGZD5A3ko5CNisyDrUPYECxzvnTnVdnwpcPaOHomn
	 87Y/pAkcYgz02ZlHIu924WCCSCAU7iYU10oM3ywvq+s+vWvEpwBZjjjBrFJIh2NCl7
	 StAF3PhNCDReXreVLJEVTW8MIqdGJ6bjPdS+YUyFXXVu7x6Fz7IjDJmQW48bQWcfY4
	 +wJ2sKwZaf+zGhRWpFeILYfwuJ2cH5B3Q8TvQ29ibUkHKZ6KICCqAEze2ddPIOfJ9O
	 e6c85l1F9KkOg==
Date: Thu, 25 Jun 2026 11:13:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>, OM@magnolia.djwong.org
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] xfs: fix handling of synchronous errors in
 xfs_buf_submit
Message-ID: <20260625181303.GJ6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625135849.2494779-6-hch@lst.de>

On Thu, Jun 25, 2026 at 03:58:35PM +0200, Christoph Hellwig wrote:
> Synchronous readers and writers already run __xfs_buf_ioend from
> xfs_buf_iowait after being woken through bp->b_iowait, so we
> should not call it here, which can lead to double completions.

How hard is it to trip the double completion?  I guess all you need is
an IO failure (or a verifier failure) on a synchronous read?

> Fixes: 4b90de5bc0f5 ("xfs: reduce context switches for synchronous buffered I/O")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

If so, then

Cc: <stable@vger.kernel.org> # v6.14
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3eea9d9ea829..83549573e2cc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1403,12 +1403,12 @@ xfs_buf_submit(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  end_io:
> -	if (!__xfs_buf_ioend(bp))
> -		return;
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> +	if (bp->b_flags & XBF_ASYNC) {
> +		if (__xfs_buf_ioend(bp))
> +			xfs_buf_relse(bp);
> +	} else {
>  		complete(&bp->b_iowait);
> +	}
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
