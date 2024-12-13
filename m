Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEBE18D65F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130153; cv=none; b=hML9A934EbnpY14uwcZw3Cfm1DGje3wDKBR/akRNQT6xVKnnyxAvZFTVvUUUwrMCv73PpZ1FOO8zS1gwNr9jSOAvdensrV3mrHfMEOVpnCUfjSwq2y8u/7h9LwBnfo5UEYPTZxRZXlDRkGH1wlhQdPmAZHbQ9dOvhs2QUJ1no/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130153; c=relaxed/simple;
	bh=5TFVXUQ910XwpwnU3kqhjVey7FE2k70bGjGd6C3h7s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPj3G24X50AQVgxz8zC7vcZCjd5ufF0D4yO+JR8l2metJn6LOyQZZo85UKnjctnQxT1t0+2Htx/omYMqC6TJfW30SWJml7+G75MSTpAPtL1M42i6AuLnNC1PlRa7jC94nfjiDHoabSdXAmh9klKS4GACKeWXRr84Jr8v4t5OPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+kNdd3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+kNdd3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5333C4CED0;
	Fri, 13 Dec 2024 22:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130152;
	bh=5TFVXUQ910XwpwnU3kqhjVey7FE2k70bGjGd6C3h7s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+kNdd3jEduXdcwD1zyk88fOjTrnkF2ryBG8j/bD1BxGOCzsgSnJIULWqgFz2MM2p
	 b29aYvdTgN+bEitBRs2PMBxpD5KCwHalah0JLOZTlDXoeZ+OH7SckWofopwHaYJTV3
	 P2XsQqzUemZMpN0xEeBEcb71n4oqN7uoRSET7WAOoZNVAoLQl0n/4goTvSbbhRebow
	 CoHj8VTb6/g7cTyz8A9B4VrDAlPbd5mB/nqg+UTWXGCFgUn3fq4q2u67D2kcJCkF3D
	 RNpNnOv13DSrc0klh+zOUwklHmAy0m3PNspmN1A/I6voqskwIAmKmrWv8Jj7pDTi5N
	 zv5nfnox8HOxw==
Date: Fri, 13 Dec 2024 14:49:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: support xchk_xref_is_used_rt_space on zoned
 file systems
Message-ID: <20241213224912.GW6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-34-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-34-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:58AM +0100, Christoph Hellwig wrote:
> Space usage is tracked by the rmap, which already is separately
> cross-reference.  But on top of that we have the write pointer and can

  cross-referenced

> do a basic sanity check here that the block is not beyond the write
> pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/rtbitmap.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index e8c776a34c1d..d5ff8609dbfb 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -21,6 +21,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_exchmaps.h"
> +#include "xfs_zone_alloc.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/repair.h"
> @@ -272,7 +273,6 @@ xchk_xref_is_used_rt_space(
>  	xfs_extlen_t		len)
>  {
>  	struct xfs_rtgroup	*rtg = sc->sr.rtg;
> -	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
>  	xfs_rtxnum_t		startext;
>  	xfs_rtxnum_t		endext;
>  	bool			is_free;
> @@ -281,6 +281,13 @@ xchk_xref_is_used_rt_space(
>  	if (xchk_skip_xref(sc->sm))
>  		return;
>  
> +	if (xfs_has_zoned(sc->mp)) {
> +		if (!xfs_zone_rgbno_is_valid(rtg,
> +				xfs_rtb_to_rgbno(sc->mp, rtbno) + len - 1))
> +			xchk_ino_xref_set_corrupt(sc, rtg_rmap(rtg)->i_ino);
> +		return;
> +	}
> +
>  	startext = xfs_rtb_to_rtx(sc->mp, rtbno);
>  	endext = xfs_rtb_to_rtx(sc->mp, rtbno + len - 1);
>  	error = xfs_rtalloc_extent_is_free(rtg, sc->tp, startext,
> @@ -288,5 +295,5 @@ xchk_xref_is_used_rt_space(
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
>  	if (is_free)
> -		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);

rbmip is already the return value from rtg_bitmap()

--D

>  }
> -- 
> 2.45.2
> 
> 
