Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E163769EC;
	Thu, 25 Jun 2026 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376966; cv=none; b=ODLE4BnCcGNo5XcJfIiigX/8kdSKsyusdEnFK7thQsm36QYPJG8G9hcOhOBKr5zgzfoirTrJWysjFgb+gpprctM8Wqp1vw8rJEdWitk2a5l3IxRtH/B3avGTRky29+uLMAdb6Evj54jBbBR8RJ+VKH3JcaAHpcpoMUdFkNHiklA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376966; c=relaxed/simple;
	bh=g2MsiXMQ5MnvwjUZvcxAX9P7ui7dB7pbbu5Ko6RUb+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwOtAjW3sTw2NUytVYtaw2S0+nuJnktMNeBVlOVLXiBvkHNnkBa81cjk8hT+PWveojQUwjbAJ67fR6JHB6aT2IM8zhi8XvBoCjUaSv9/mBDo0IXMqaxIiK0MQQC6n1ibhY7VC1E/7jhwq+aA1bil0Y2u6YoGxD7q077vOYn8oG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2IrWLKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2IrWLKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F71F00A3A;
	Thu, 25 Jun 2026 08:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782376965;
	bh=nOJf0y96q+9PJDfCJkeTc9JjoAXIbCDUD4zbVGafP3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f2IrWLKPcWnb2yWYd5NuJzAJPm3sxDTfD3aHlcSITfQW98Q2DzGwFLek78CXlFH2A
	 5MvlINhq+1bIJLZ3Ukdf2eISr4o74wr++596UXDzH0G6am7Gpn5VrIhMUzHsfPittz
	 t7m4Mo98oezOUizCAYGvNXoPlrzPLisT7eAm33/7rw06F0RmQ9ROsTlIrv8h0Q/pIi
	 dYRZUYuRqNg/AzY8SWrLhL7FtQggjRoL+oH5KIP4gKjrglur5bm/O1DRs/Zm2rDP7S
	 8VgCvmF29iUJRBvG76a4F5IOewkJJJ05AmsGA7W9z6Mt5/ERlGA0WiIwSK2AB1Q68p
	 OucffIAbiLuMg==
Date: Thu, 25 Jun 2026 10:42:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: djwong@kernel.org, hch@infradead.org, kees@kernel.org, 
	linux-kernel@vger.kernel.org, gouhaojake@163.com, kernel@uniontech.com, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove dead NULL check after __GFP_NOFAIL allocation
Message-ID: <ajzp1ZlI54I7hgTo@nidhogg.toxiclabs.cc>
References: <20260624135155.326834-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624135155.326834-1-gouhao@uniontech.com>

On Wed, Jun 24, 2026 at 09:51:55PM +0800, Gou Hao wrote:
> kmalloc with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent ENOMEM check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>

Looks fine.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/libxfs/xfs_dir2.c     | 12 ------------
>  fs/xfs/libxfs/xfs_exchmaps.c |  5 -----
>  fs/xfs/xfs_buf.c             |  3 ---
>  fs/xfs/xfs_mru_cache.c       |  8 --------
>  4 files changed, 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 0c0402a29b6b..6009ec26843d 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -249,9 +249,6 @@ xfs_dir_init(
>  		return error;
>  
>  	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!args)
> -		return -ENOMEM;
> -
>  	args->geo = dp->i_mount->m_dir_geo;
>  	args->dp = dp;
>  	args->trans = tp;
> @@ -342,9 +339,6 @@ xfs_dir_createname(
>  	}
>  
>  	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!args)
> -		return -ENOMEM;
> -
>  	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
> @@ -503,9 +497,6 @@ xfs_dir_removename(
>  	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
>  
>  	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!args)
> -		return -ENOMEM;
> -
>  	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
> @@ -563,9 +554,6 @@ xfs_dir_replace(
>  		return rval;
>  
>  	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!args)
> -		return -ENOMEM;
> -
>  	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index dcd0bd0b13b4..bd897676e38a 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -500,11 +500,6 @@ xfs_exchmaps_link_to_sf(
>  	/* Read the current symlink target into a buffer. */
>  	buf = kmalloc(ip->i_disk_size + 1,
>  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> -	if (!buf) {
> -		ASSERT(0);
> -		return -ENOMEM;
> -	}
> -
>  	error = xfs_symlink_remote_read(ip, buf);
>  	if (error)
>  		goto free;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3ce12fe1c307..5583139d7478 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -130,9 +130,6 @@ xfs_buf_alloc_kmem(
>  	ASSERT(size < PAGE_SIZE);
>  
>  	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
> -	if (!bp->b_addr)
> -		return -ENOMEM;
> -
>  	/*
>  	 * Slab guarantees that we get back naturally aligned allocations for
>  	 * power of two sizes.  Keep this check as the canary in the coal mine
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index d61ec8cb126d..258c07da73e1 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -334,18 +334,10 @@ xfs_mru_cache_create(
>  		return -EINVAL;
>  
>  	mru = kzalloc_obj(*mru, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!mru)
> -		return -ENOMEM;
> -
>  	/* An extra list is needed to avoid reaping up to a grp_time early. */
>  	mru->grp_count = grp_count + 1;
>  	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
>  				GFP_KERNEL | __GFP_NOFAIL);
> -	if (!mru->lists) {
> -		kfree(mru);
> -		return -ENOMEM;
> -	}
> -
>  	for (grp = 0; grp < mru->grp_count; grp++)
>  		INIT_LIST_HEAD(mru->lists + grp);
>  
> -- 
> 2.20.1
> 
> 
