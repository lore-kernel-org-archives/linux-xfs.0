Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25E362132
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 08:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773822829; cv=none; b=oF820qkFJiSM2Z1SSZJBZQQdTtHP4yM07bNle5JvdIyGzQH/fUEXjTyEJ2FqP9eUuXsxUVMX2+zs7xATXPqtvyaIvU3uSKufuRGCXIDKdNqcbYZTvjimZphAN96YWUR2J1LX/7EDoyirqg7IezFDzB4CcprkCavZ5P6tQO01aSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773822829; c=relaxed/simple;
	bh=a1jt4hGVolhEGok1iCFWBazdDNaC2KURW4GXDz7VwEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5ZVQy2T1RUH/YCFZymXphRZHAVZomFq3pG49SjmPzWXbSxehQsW/5dLLAYoA9AzlB9L/vfRrwfCwz8v7G+SPSqlvA4gL/oRe2zECD4MQ0NkHhdnfFRxP9RZR/SGlVu47GYtJMDd6qijZxZ/ExK9oAE6cPUzQnqogVS+N7LO1b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNgtZemH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNgtZemH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E0EC19421;
	Wed, 18 Mar 2026 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773822829;
	bh=a1jt4hGVolhEGok1iCFWBazdDNaC2KURW4GXDz7VwEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNgtZemHTCKIuWltuH4+u4ALZGJnMd9w2+2038AcAFIG1qHaCQ43nKbnKNadEU345
	 UyeQ3jp1MVsUTiVgW2jKZmdW6B1KPoYKZ1tDfC/wF8H/dYmSyxqZIoFe8CmNUzsG7E
	 t4ATGiBK/2BgHcX304JU/mwyxQSDVwuJ/7k+tWa1Z4fJqybbj2Wf2DMSrm1WM4OceB
	 0RxODj3WHR5vXrsGEeNmGr58/XHJ/s/L7CcCiynk1UAMEMzVf+pIgcdgMH31vbh8tT
	 8Zfmo29B4HB3ow9y1+QE3QuICu5M1WlvaqlXJlcfjlwt9+H3MEiWFYveNPCa/w4KAr
	 BhK3t4kEMQVww==
Date: Wed, 18 Mar 2026 09:33:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, dlemoal@kernel.org
Subject: Re: [PATCH v2 4/4] xfs: opencode xfs_zone_record_blocks
Message-ID: <abpjRgx9rysND3-k@nidhogg.toxiclabs.cc>
References: <20260310173709.457047-1-cem@kernel.org>
 <20260310173709.457047-5-cem@kernel.org>
 <20260318081431.GA26117@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318081431.GA26117@lst.de>

On Wed, Mar 18, 2026 at 09:14:31AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 10, 2026 at 06:36:49PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > We only have a single caller, no need to keep it in its own function.
> 
> This accidentally dropped the record_blocks trace event.  The patch
> below adds it back.  Feel free to fold it in if that works for you.

Woops, thanks. I'm folding it into the original patch adding a small
note there.
Thanks!

> 
> ---
> From 6e413887a36cd91af3684d8af357b50538106bea Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 18 Mar 2026 08:58:38 +0100
> Subject: xfs: add back the xfs_zone_record_blocks trace event
> 
> Commit 54514abb9891 ("xfs: opencode xfs_zone_record_blocks")
> accidentally removed it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 7d712d5a5ce0..9d02160c5334 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -291,6 +291,9 @@ xfs_zoned_map_extent(
>  		}
>  	}
>  
> +	trace_xfs_zone_record_blocks(oz,
> +		xfs_rtb_to_rgbno(tp->t_mountp, new->br_startblock),
> +		new->br_blockcount);
>  	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
>  	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
>  	rmapip->i_used_blocks += new->br_blockcount;
> -- 
> 2.47.3
> 
> 
