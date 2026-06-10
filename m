Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827BD2F5A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068340; cv=none; b=pDw8JTGoJTv2w3DPAPZixcDoVCXRTFZb0/VObu1HPK7pY1MIC9VCPSzwN/zCyOfjzwTIAagG4FywRNtDUM9IZoiy2g1nMI447q0w3K0a/jSYmul8bmuqNluU1RPLunWW/teEbecZm/Q8xC3Y7w6of3riSg1sRY6MU/8tUD+62WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068340; c=relaxed/simple;
	bh=oQCHh1vLhQAqeYqdnYxU1jWg06mbMYorSn2UfLoDaSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXD1ymILvSKMFK+FiPyWTzoRdi9V0X2pS9MtJekg+Q/P1tN9PXfz5Nn+cXK+esDyy5LiqDxtYGVai9a4r4HHDoUXO+VTsgoGDOmOgYPpwBiBwJDt85Xp2uHAYu5UYVzPTEP1ufW2SHTHXsk9QuTkhO44lmODhAfH+e2C7LFQtnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUt+BvdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUt+BvdR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 13F771F00893;
	Wed, 10 Jun 2026 05:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781068339;
	bh=gfftEfGbINR4HYAht01T7+Yh++9Z4K2exYP1TvGMf4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oUt+BvdRg2wq3iH5soKsIbuyqgR+8DZuI/r3tbFh33sJBPQScj8U+Sqf7oSMSRgBH
	 RBweolKkrq48NgO82lWTu+/xZckoAIYT8e6INIglfXOz3Noylxq4KdfWRDTRPbmsGR
	 Y/+dKoZKJkrzB9l3R72J8KGGR81LvrBbi16WgOJBZFq/dtxtdg+GbqWzSh8kkhBSO0
	 8Txbq9EkVFXRkdmMFivmWpAeaE85n05mj/wCdz/BnVAN9ZcwCRO3FTuij/mffXXzVK
	 IJImdQH/N5iatVwiOhtlvubl6Y306Avv4rve9fpEK5SmSzQ1oDZKl9KnFV0DQ1VIfs
	 r+Q8s8sr9aSkw==
Date: Tue, 9 Jun 2026 22:12:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: only log freed extents for the current RTG in
 zoned growfs
Message-ID: <20260610051218.GF6078@frogsfrogsfrogs>
References: <20260610050731.1906760-1-hch@lst.de>
 <20260610050731.1906760-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610050731.1906760-4-hch@lst.de>

On Wed, Jun 10, 2026 at 07:07:21AM +0200, Christoph Hellwig wrote:
> Otherwise a power fail or crash during growfs could lead to an
> elevated sb_rblocks counter.
> 
> Note that the step function is much simpler compared to the classic RT
> allocator as zoned RT sections must be aligned to real time group
> boundaries.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index debbcefdf07f..7a3f97686989 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -890,8 +890,7 @@ xfs_growfs_rt_sb_fields(
>  
>  static int
>  xfs_growfs_rt_zoned(
> -	struct xfs_rtgroup	*rtg,
> -	xfs_rfsblock_t		nrblocks)
> +	struct xfs_rtgroup	*rtg)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_mount	*nmp;
> @@ -903,7 +902,8 @@ xfs_growfs_rt_zoned(
>  	 * Calculate new sb and mount fields for this round.  Also ensure the
>  	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
>  	 */
> -	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
> +	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
> +			xfs_rtgs_to_rfsbs(mp, rtg_rgno(rtg) + 1),

Heh, I forgot we had a helper for this!

Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  			mp->m_sb.sb_rextsize);
>  	if (!nmp)
>  		return -ENOMEM;
> @@ -1226,7 +1226,7 @@ xfs_growfs_rtg(
>  	}
>  
>  	if (xfs_has_zoned(mp)) {
> -		error = xfs_growfs_rt_zoned(rtg, nrblocks);
> +		error = xfs_growfs_rt_zoned(rtg);
>  		goto out_rele;
>  	}
>  
> -- 
> 2.53.0
> 
> 
