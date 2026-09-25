Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FBF477E4D;
	Fri, 25 Sep 2026 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378476; cv=none; b=XeUAxdJ6rRnSnvcaOhDNPbZTJRtdWDwh3Pga0ezTwSak5GYYzJf7gSDj/yrZx3h28i8BXxVOova53LSYSs1sdGg2Jle7F5b76ejjot7Boddz64/YDBolhDOHPVilqakMvI5DRCuT+yvFHPI7BQDK2NlLsx2wqa0BGfB0ZxfpOJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378476; c=relaxed/simple;
	bh=Rv2SpZ5QA0V5gtnhXRghvD42e9Pw/FRXq2Mt3BvS9o4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVc91RjCSN1/58H/LCpFiD5LEyeCJg7NT4W+YRTemU+VBHARi1CSahMUpeZbNyYDR/Lk5yTRE11PmhnuR0uPeCfZOn91+tofcXiWHcNaEtkVsge1xGCHrHvIGvM3F/hCsFv+m+IQ9GjbOsb69qDDP5BfXkfiq2OdyJAP8l67z2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqRl/rGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqRl/rGF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BEA521F000FF;
	Fri, 25 Sep 2026 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378474;
	bh=ovmOcknURn2NJZqtXCVUpcvQmWzPgsRW8DMfv+Qu9v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gqRl/rGFjp1QgMwN3ACCDV8mMoTMvWroiZkKGhskoR2mQfuWfY9gbwBbi874hrUmK
	 KM10xw6g15PuoDA094OuVr+uzKnuYUo7wvzXV3YpZJ1p+hxmfJ84NiZr3Jkcm/B+dR
	 Jd8pAiIcsRa5DpXmX3LVcWMSMMWictafkaIdiW/BdE8AGOgloo6SC4h5drBv7jKn09
	 fIcsVZOueXUqJn/uP+HcZJC0mrrG9TmROyVhgn5NE5Sm3K0FFHQtQ0r6rxK3MQIz3e
	 ZozNini82Eg6Bo0nTIrTosdU9xa1Ex4Jl1KBZiiQG9NSA4WDO6xtHTUK5Z2LKwLHCK
	 t65o/Oe0Q/XMw==
Date: Fri, 25 Sep 2026 16:21:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/21] xfs: data checksums require stable writes
Message-ID: <20260925232114.GG2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-13-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:44AM +0200, Christoph Hellwig wrote:
> Call mapping_set_stable_writes based on the data checksum flag
> so that the page cache doesn't change data in-flight as that could
> corrupt the checksum.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense that we need to stabilize the pagecache during writeback.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 9ed2fbfe86ff..72582ea9afcc 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -619,7 +619,8 @@ int	xfs_break_layouts(struct inode *inode, uint *iolock,
>  
>  static inline void xfs_update_stable_writes(struct xfs_inode *ip)
>  {
> -	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (xfs_is_rtcsum_inode(ip) ||
> +	    bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
>  		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
>  	else
>  		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
> -- 
> 2.53.0
> 
> 
