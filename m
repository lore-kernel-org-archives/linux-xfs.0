Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CBB1DB13A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 19:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765825801; cv=none; b=RL0Owk9OYuB/yw2v6DmPGJbClf47o6oJMiRXiYR4Bq/rAbO4aUtEd2dfgWSlw23ADVypL+EDtRs/HL/dMxVgkbe1bHU4tm4K+mZ1Y6EhBxFWVlw7BYWKJz1Djjv+my2C52yWBt8F1fudYLd7BW/mp9QeSEhnBL+JUvc6DJQoIjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765825801; c=relaxed/simple;
	bh=XGCVnvQzY6PSlQYa/ezOdVd7xIZjDL7vGVCW/aV99e0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaKcHNOwSKIox3J0F7qBdYd1DFk9YUqxQ+NxCGnUTKMTsN23FD4+Wt3e+V+/EW9zBuJmVMRh7W36tV9KXpqpFEiKzFY2QMKGhejFf9UH2CxFCTAqxXKyexppHk6vZ3F6bxFwudPRjd2J1LWsAYDo5HJjX3Z0dLHrzSVJnYxrjB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ktm2rELM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ktm2rELM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B404EC4CEF5;
	Mon, 15 Dec 2025 19:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765825799;
	bh=XGCVnvQzY6PSlQYa/ezOdVd7xIZjDL7vGVCW/aV99e0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ktm2rELMMN1O5MvgVdR7yGT9OxqP8KpAFLqqDAZ11GkW4NmMACsoriLA6krX9HBEz
	 yGCm3R2p+QloIJjfUgP6E5IQn+BAal6yxrsawFSMz525g/HbJ169cekPOZvxQH8Kf/
	 XXVmX/5QWUXNfYN+/zmyLnq/EjIUdj41fdgWwUVF5lesoKE4qPcnAnDOEdaCtM8pZ4
	 RpWl26dNsY+paL2CODMkesWSiVXkau0kDdwDHYbCejV8JEl76ck8ScBiNLPuQZLpd/
	 WlrdPUfMjQiBq5ncKzKtlnr3zGJiiYDQ91zbwqhLngc44DHicakJ9930AAPEcknXq7
	 5aaVr07HcgnJA==
Date: Mon, 15 Dec 2025 11:09:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix the zoned RT growfs check for zone alignment
Message-ID: <20251215190959.GH7725@frogsfrogsfrogs>
References: <20251215094843.537721-1-hch@lst.de>
 <20251215094843.537721-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215094843.537721-3-hch@lst.de>

On Mon, Dec 15, 2025 at 10:48:37AM +0100, Christoph Hellwig wrote:
> The grofs code for zoned RT subvolums already tries to check for zone
> alignment, but gets it wrong by using the old instead of the new mount
> structure.

Please add
Cc: <stable@vger.kernel.org> # v6.15

> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6907e871fa15..e063f4f2f2e6 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1255,12 +1255,10 @@ xfs_growfs_check_rtgeom(
>  	min_logfsbs = min_t(xfs_extlen_t, xfs_log_calc_minimum_size(nmp),
>  			nmp->m_rsumblocks * 2);
>  
> -	kfree(nmp);
> -
>  	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
>  
>  	if (min_logfsbs > mp->m_sb.sb_logblocks)
> -		return -EINVAL;
> +		goto out_inval;
>  
>  	if (xfs_has_zoned(mp)) {
>  		uint32_t	gblocks = mp->m_groups[XG_TYPE_RTG].blocks;
> @@ -1268,16 +1266,20 @@ xfs_growfs_check_rtgeom(
>  
>  		if (rextsize != 1)
>  			return -EINVAL;
> -		div_u64_rem(mp->m_sb.sb_rblocks, gblocks, &rem);
> +		div_u64_rem(nmp->m_sb.sb_rblocks, gblocks, &rem);
>  		if (rem) {
>  			xfs_warn(mp,
>  "new RT volume size (%lld) not aligned to RT group size (%d)",
> -				mp->m_sb.sb_rblocks, gblocks);
> -			return -EINVAL;
> +				nmp->m_sb.sb_rblocks, gblocks);
> +			goto out_inval;
>  		}
>  	}
>  
> +	kfree(nmp);
>  	return 0;
> +out_inval:
> +	kfree(nmp);
> +	return -EINVAL;
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 
