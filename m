Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A54C9D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214327; cv=none; b=SrjtXzKIBqubAgoa6iK8pDjrqa0SCLxok4vW3PC+oh4jh5HVrHiV/khEtqdAIrLn7zgDxXVslKPJc5HE2UknMRLlNXocbl886Cz9EFwWhhCL8x2bj3glmSSNcXhSxXQlTZ043EpycxStrj1yrnl8ad1xyc9e6xQ5UL1RW561TLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214327; c=relaxed/simple;
	bh=PYrgD5Uw8zxYVGHREqkHAnPNevmWgo+krQSvywITaI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWsDhEVZ0qwE9BgVsmkqoxHRTXRbWsNg0EyqtRV/yvoMdwBs7FHOl4Mx7j41EYRY9Tt59T1/hX7mV1baFZRrrFHTDYL1CD/MUZqrbvHfhcUdQfY1usPlLbjqQvqU8P7yiWu2JRq0YBRfTJzqWDQ/ou2xuhCajm/+ABte9IbiCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTqjOfRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTqjOfRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9136BC4CEE2;
	Wed,  9 Apr 2025 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214326;
	bh=PYrgD5Uw8zxYVGHREqkHAnPNevmWgo+krQSvywITaI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTqjOfRiWwcvnEtUvGYt9VYK+nm/TlsbUKKOr9ZG3pWa9SBoUdynU/XohqViPD3ZO
	 sgXeUnIWxhK0DzrszYRLn1HFNf2xD/QDcQQXBL/1lf9CmQQyvPslsIMd2EKXC8Y1oj
	 kil9br83Vfa9UJP+YQShzhfQuxLHAHkovH6GtmVogtb4oybEpn3Sk1xDec0T9sPmyn
	 J2wEA5MGpz3F7QfHXixV4EAjMjdjoEQzeWthwPKFVMoCi6TxOr6s2Ldg5pvxUS/dij
	 ErS8xdeEk5IT3t2gCNbRy9FflSnnT3i7tattpXQOcgMQNpdbwHbumFPXMl5pqY7zGa
	 OHPtMy7LKhLBw==
Date: Wed, 9 Apr 2025 08:58:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] libfrog: report the zoned flag
Message-ID: <20250409155846.GZ6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-27-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:29AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I wonder why the other xfs_report_geom change (about the realtime device
name reporting) wasn't in this patch?

Anyway the changes here seem reasonable to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/fsgeom.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 13df88ae43a7..5c4ba29ca9ac 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -34,6 +34,7 @@ xfs_report_geom(
>  	int			exchangerange;
>  	int			parent;
>  	int			metadir;
> +	int			zoned;
>  
>  	isint = geo->logstart > 0;
>  	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
> @@ -55,6 +56,7 @@ xfs_report_geom(
>  	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
>  	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
>  	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
> +	zoned = geo->flags & XFS_FSOP_GEOM_FLAGS_ZONED ? 1 : 0;
>  
>  	printf(_(
>  "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
> @@ -68,7 +70,7 @@ xfs_report_geom(
>  "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
>  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
> -"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
> +"         =%-22s rgcount=%-4d rgsize=%u extents, zoned=%d\n"),
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> @@ -84,7 +86,7 @@ xfs_report_geom(
>  		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents,
> -		"", geo->rgcount, geo->rgextents);
> +		"", geo->rgcount, geo->rgextents, zoned);
>  }
>  
>  /* Try to obtain the xfs geometry.  On error returns a negative error code. */
> -- 
> 2.47.2
> 
> 
