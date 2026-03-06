Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27C4219FC;
	Fri,  6 Mar 2026 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772786515; cv=none; b=oVg5WPE47vKL04bd4rHr5pTmSQmmOj6t8n6hZDbhcquomTEgSE3+pd6bRSM85ciJ83/kBy/3miCzCZFsIuBTCEgatfkCqE7RVKT75VcWAxeCDvBiVFqdIywgJZkA4bwfC9TeYo/u8qI/8/IlThLDV4LlARrFO5BsDLL7aHRH8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772786515; c=relaxed/simple;
	bh=6ZySdEZurQ6O7lw/Y1dz1KwNVaclfRbd65mo+puA7jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+CCP+VLAb7Y8kj5yV46T0nx7B7OnvZ3Rvavich2YYmc07Os1cZASlnDSJDiPyGz+kew48fW+T4FZfuFr5nqSi7v+oDBJQXYe+cpESCuwxSiEc8i0vwofrLh10KN3jRT/QvI0bUQgvhUQERXTlN1Huujl1E8RtVC+E2zVodavqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrOw1CJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrOw1CJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E7C4CEF7;
	Fri,  6 Mar 2026 08:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772786514;
	bh=6ZySdEZurQ6O7lw/Y1dz1KwNVaclfRbd65mo+puA7jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrOw1CJveG2+1OVTPhS9qQdz4rUzO1WRUZb9NMgoPSEFyQjXMxw3XO2im1CClsgQd
	 Rzlgt3+pfLk4u7QMgOHgfXdrGdMkFkMJNDovKulkbILgH588EblubkL22ChvuFyEmo
	 q6zXzxEid1qftRbRNlWjLdSepoOhSCXw1d/LywRrRp7tpXvcbavA0h3nPLZ5G5bRGS
	 iQlUkkjbeoihX4slyQHg3pBX/tLZYF/Wl6FRPSJFTt6bJvzNoGtqbch3FjlD+poxby
	 nZl/IcvLcQE1JTJ0j/K+1rYzr/bIg7uCYguztHdCmYnUQcGDjhefVl76Q+MeBh122E
	 SSPPriqHotmFA==
Date: Fri, 6 Mar 2026 09:41:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Convert comma to semicolon
Message-ID: <aaqTLgr3tueoQUGI@nidhogg.toxiclabs.cc>
References: <20260306014800.1257769-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306014800.1257769-1-nichen@iscas.ac.cn>

On Fri, Mar 06, 2026 at 09:48:00AM +0800, Chen Ni wrote:
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it seems best to use ';'
> unless ',' is intended.
> 
> Found by inspection.
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f279055fcea0..79ec98c8f299 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -792,7 +792,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping);
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }

Yup, looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
> -- 
> 2.25.1
> 
> 
