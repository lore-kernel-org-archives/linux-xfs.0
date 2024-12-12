Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E42F2F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041248; cv=none; b=n++wz9AvzC3lKy/uRemI3CCQS4YS04eOkZpIZR1+bdy5f9w7EdX3hKCcSY39t3SvxArDksLcEa/VnEtvvKk6vIBXBh2LxMZosirZQ7epdV9rw5C/k0drN6/UpPUv0NoqTx2uK455awk2PaOfNfZ9/1d9UheIBPaUvgMbY4Rckgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041248; c=relaxed/simple;
	bh=QZXn1HGmESWE1QIOb4zGSYcs5oYLafBtzGWbGnpDyEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qe3q3vqFQSuh5wDcGtGOI2mj3soI24GuA+uul8xDwBbboZwRow1dLoNR+rK/jeoWyjMr/G8NV6iqd+t8kSQ7Dq99v4ZUZ9Yp5VJiVbAypgxXR4JyiLapAJrlUty8oHjgN8oDVMAP4v1wGLeIG/ZA3UyWo3w0RoRvx+t2uc4O3XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV7t+mhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV7t+mhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A09CC4CECE;
	Thu, 12 Dec 2024 22:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041247;
	bh=QZXn1HGmESWE1QIOb4zGSYcs5oYLafBtzGWbGnpDyEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hV7t+mhbkd2h8scTBg25oolbWKd9QD/cgXKGhvUfqhn0x19XWKWSBKfWdrenqtCsK
	 pSEUsZ0q50b40mjZD0jJTe3LiJ/2m1ERTmNgo6GANNmXA6+gWuXiX/wjUcjVt76KAt
	 nZB1DCUUzFvtD2HYRrRd2qvB9NVoWi9IMgd/FewXR/UXb/9UUPHO/6ryMX7WEMVGEd
	 gAx5WgdQSxqt+HUWbtgvGqcCIV93L0ljH2YzUEhlCkW1tHhDlPPVBl0ijbav2u2en0
	 q7/i1qHo7ZQf3sv2Al7B72n5IMpwctAq36PvQJw2jGvoZQGq18idRxbqMTmyR284zS
	 //4rY8l/4Ns+w==
Date: Thu, 12 Dec 2024 14:07:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/43] xfs: don't allow growfs of the data device with
 internal RT device
Message-ID: <20241212220727.GC6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-18-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:42AM +0100, Christoph Hellwig wrote:
> Because the RT blocks follow right after.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Aha, I was wondering about that.  Does this belong in the previous
patch?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsops.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index bb2e31e338b8..3c04fee284e2 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -307,6 +307,10 @@ xfs_growfs_data(
>  	if (!mutex_trylock(&mp->m_growlock))
>  		return -EWOULDBLOCK;
>  
> +	/* we can't grow the data section when an internal RT section exists */
> +	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
> +		return -EINVAL;
> +
>  	/* update imaxpct separately to the physical grow of the filesystem */
>  	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
>  		error = xfs_growfs_imaxpct(mp, in->imaxpct);
> -- 
> 2.45.2
> 
> 
