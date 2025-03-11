Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B765EC5;
	Tue, 11 Mar 2025 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741708892; cv=none; b=blqa5SKf8ewcUS7hAKteTHLB2/fRPE1YVz/cgJ0wM5qpZJX0N7ZHzQwdSxJ2EorAdPxwtr46qxogiKlJ4pRkGvtpRTIflGypsfpR2ZOQVHaIbhP/gZ1F5R9r+C0FP0Yy32rxvv6zx0HfKSKHeSFec7CIXP09/5X4g67nLrDDiJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741708892; c=relaxed/simple;
	bh=j9FC6CQbngxhHd3AnN4lYjaaHBAXRWlEahyYBKS1F6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDBsTjcXRUpq72P8MOb+Uzhla7/BHH3ednkGiGldc/u0QAOFRLCwk9bysRKBWl/0SoFH/3/NA59XGj0gfwTXoNhlz2GkH5fUPyjNEsH1wU7//RJxIqjn8fgP446hPR5NIA4yb4y86g0bTGNenuP8oMtxtv7p3CrT0vn6Xe2i1tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgIaJz8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgIaJz8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DF4C4CEE9;
	Tue, 11 Mar 2025 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741708892;
	bh=j9FC6CQbngxhHd3AnN4lYjaaHBAXRWlEahyYBKS1F6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OgIaJz8GJgp1/aDUubByLEcCXp63vE+1RVtXaqaaMWEHDT2V/uhX5EPuQamFJY+nZ
	 GfdzuLoo8Ol6SyOqbBNaNZ/yLFHdhR9SVivzUlle9fDDwMM1ER63sPbvZlRYvMWzge
	 0iSUXuSziqpX2a8OFWN/iMuHIuNeN6MpCqKu+9CvKfvjmr6fa/juav19jbMuTkd6OF
	 eTnW/QUZULkLMzo1Yc8xbaeinmtcCB9DdeaRDDDckd0vgK4EcrMtl7Hl9c3Y53BDSL
	 okd5+0DAwksoGgpHpXDLsvwk0EkcWDsN44sZPbi3lYCD2NxidVv6hB5SfZAcgqCxDN
	 WUUG32E2lGyQw==
Date: Tue, 11 Mar 2025 09:01:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unnecessary NULL check before kvfree()
Message-ID: <20250311160131.GW2803749@frogsfrogsfrogs>
References: <20250311071114.1037911-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311071114.1037911-1-nichen@iscas.ac.cn>

On Tue, Mar 11, 2025 at 03:11:14PM +0800, Chen Ni wrote:
> Remove unnecessary NULL check before kvfree() reported by
> Coccinelle/coccicheck and the semantic patch at
> scripts/coccinelle/free/ifnullfree.cocci.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Probably fine, though the line numbers have moved around a lot in
for-next...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 57bef567e011..9688e8ca6915 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1144,8 +1144,7 @@ xfs_growfs_rtg(
>  			goto out_error;
>  	}
>  
> -	if (old_rsum_cache)
> -		kvfree(old_rsum_cache);
> +	kvfree(old_rsum_cache);
>  	xfs_rtgroup_rele(rtg);
>  	return 0;
>  
> -- 
> 2.25.1
> 
> 
