Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BEF1E32A3
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742548901; cv=none; b=c2hZgTgtONnUwtkiBxdOegnqqYcun9s23boRAICOuQLL9LCpauNxdILcC8qJP8OaToZAE5LomgLl8hgnjUg0huhGtxKaos6Q2tTKob6iIYqLqpfqumRMmLfgM92LWuFgpSHlUH/WHGawaH0erschOtkJQ1+FyZu9ZX0lVyQv4Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742548901; c=relaxed/simple;
	bh=hmX6PYKVR7P54CHqqeN8kbMtqMOhklFsAOXpZcIEzxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M41CUF5d1paAcvXT/0/RkPs4gTDY6txICszxWXu/4jMSvG3BTxOMbj71hGaJFjY14EbhMqr80MNpnDV5UzIcVj43bR2ePvZX6/rjtu1DsqNnS7zpsRAoYntTTD0ZevDXrrUqx4bgAWbP+cS8km9UBuoWXo6Gkw35gg33n03IL9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSeHpMvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSeHpMvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38F5C4CEEA;
	Fri, 21 Mar 2025 09:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742548901;
	bh=hmX6PYKVR7P54CHqqeN8kbMtqMOhklFsAOXpZcIEzxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uSeHpMvwf/SvAaHrvvErbfne6Fymwupm+k5W2KoX/x0G5uUmTmspRk2/y8oPLrgFL
	 2cxZJH6kiOj82CcF44g1qCAgEWlinZRlhArfI5l05hUa9jz2p06tlr/MWFWMkfsscV
	 8Urkl5zsPU+1MKgtuk1lKEQB7+yv5X3bxer4aABVUNBwlrbedLCrttCjBm7yaAzrwC
	 xtPC9W7DuivT9W6CE8w3noOotlaqJJh28CDP4yIMGvSQgDYIi+tDkq4FVGIUbpKD/5
	 eEFN5vSgCGr3AC2pSsgIauHb/rV62k86ew6yqGaZhy0Pk7/4WP+hmLYdcYo4Ft27Kt
	 UeU5CjVpY+xvw==
Date: Fri, 21 Mar 2025 10:21:35 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dchinner@redhat.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: mark xfs_buf_free as might_sleep()
Message-ID: <dswaua7ynkossegyqw25x3ghilbjsxalatbto2xrbek74j7u5o@mxhq3mhukk3j>
References: <20250320075221.1505190-1-hch@lst.de>
 <iehRDkchwLyn5czaoM6iHGrNaM7A235ISuVTw_D6fpn8zuuiMCqofPep2K2Xn0Pgo__30TcjbKGoIBCld0AM1Q==@protonmail.internalid>
 <20250320075221.1505190-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320075221.1505190-3-hch@lst.de>

On Thu, Mar 20, 2025 at 08:52:14AM +0100, Christoph Hellwig wrote:
> xfs_buf_free can call vunmap, which can sleep.  The vunmap path is an
> unlikely one, so add might_sleep to ensure calling xfs_buf_free from
> atomic context gets caught more easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> ---
>  fs/xfs/xfs_buf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8e7f1b324b3b..1a2b3f06fa71 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -105,6 +105,7 @@ xfs_buf_free(
>  {
>  	unsigned int		size = BBTOB(bp->b_length);
> 
> +	might_sleep();
>  	trace_xfs_buf_free(bp, _RET_IP_);
> 
>  	ASSERT(list_empty(&bp->b_lru));

If I followed it correct, vunmap can be caught via
xfs_buf_free_pages(). If that's the case, wouldn't make
more sense to put might_sleep() inside xfs_buf_free_pages()
giving it is not called only from xfs_buf_free()?

Otherwise,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --
> 2.45.2
> 
