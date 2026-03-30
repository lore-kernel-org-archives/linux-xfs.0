Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6953C3CAE93
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873595; cv=none; b=SCnD7sv9HZbrN9VIHd2H53ogSJMyvSRm6P9dIRY7DlXZYRWFtpQa9mTprueWgEdmV25tkwzRZ+E+1H2n6CLICDm0JTVNQ+C+0BfPfFkTiWf2FhLTOQA9I2Q/pTGQU0w06fmqXGgVCeREMBXPfG2j7I2hn0IyvyEyTLV5CSSebhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873595; c=relaxed/simple;
	bh=wLD5dZF2LsjhGxepZgfMN7ZbmKN92zc9FPsVshx+kc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmHkUVw2Nmt4gRr0Dn0I3A30prWBJaqanWwXNo+A3Wqz2E1WferhE4xYRx+wWZEhkqyJ7hL70rR3oYSVJdCZ2L9aDnMsc0Up6EzzY8pGklzzJh8I3idulhZVkKKfuWi0gliyc6IL4ZUviVXCQdzzWIHPKNVe6DiRtL30uGfYo/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyfC9nbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyfC9nbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2116C4CEF7;
	Mon, 30 Mar 2026 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873595;
	bh=wLD5dZF2LsjhGxepZgfMN7ZbmKN92zc9FPsVshx+kc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyfC9nbHpDq6oQoju84hn9DPyJBCgxoNuXLSFv2b7S7XjK9ZOYEjiRWucLZBR9+8h
	 cxnyWGl6Qr/FWLDlJwxIib4IN+dyRLVlkA5tj6WM6weTelC21qD/+Y+yrYj8ArjbM3
	 ktL1wYgpQrKLexYNwZfVFiYbLLFytVoE+C9XAnWKGehQFZCa29QdBhUeZReiSEO7wC
	 AmZ8JVctI1FpV0qZMSBPhqtMoUiflp9HE2qdIIpd6aRqiDjRcDLwBsbNunxWDvMEFa
	 kEAdAdU72uBUvhsFCENflTYQEhztvoZdfbfSwlDEwJKJyEI8NHnu12KHUTKcfXEq4X
	 /VWbrZS6J135A==
Date: Mon, 30 Mar 2026 14:26:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: rename xfs_zone_gc_iter_next to
 xfs_zone_gc_iter_irec
Message-ID: <acpr8Ei9u2d3elL9@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-5-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:14AM +0200, Christoph Hellwig wrote:
> This function returns the current iterator position, which makes the
> _next postfix a bit misleading.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_gc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 273c496c2f1c..3723f5293a64 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -374,7 +374,7 @@ xfs_zone_gc_query(
>  }
>  
>  static bool
> -xfs_zone_gc_iter_next(
> +xfs_zone_gc_iter_irec(
>  	struct xfs_mount	*mp,
>  	struct xfs_zone_gc_iter	*iter,
>  	struct xfs_rmap_irec	*chunk_rec,
> @@ -691,7 +691,7 @@ xfs_zone_gc_start_chunk(
>  	if (xfs_is_shutdown(mp))
>  		return false;
>  
> -	if (!xfs_zone_gc_iter_next(mp, iter, &irec, &ip))
> +	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
>  		return false;
>  	oz = xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
>  			&is_seq);
> -- 
> 2.47.3
> 
> 
