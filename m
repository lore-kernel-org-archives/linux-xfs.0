Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F0015574D
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720562269; cv=none; b=m2odlcfFijSuhuQPn8SICxQQpwnRYzhx3TNDqRV5suEzwTho/ZwfmBdJRDk8L+7xI2AcFvTVow6cwHNQ1g8xj3BOx4rS0ldP8eNmBnWR09ezC+Q4eK+DXJHpJ2EqHdzgaVLVTQtc/EdIQUPZtHWqhTdtwGAMiVVbGCRLsqOJWfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720562269; c=relaxed/simple;
	bh=cPUToijK5JVO10fs7Dy3ydNXFXyU7AehucSFWFmRg6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgDDsLW8ie24BgSd27fyYVeygjxj72Qhimw5omzGhsyYqDhX1+1uzf5PaX+igq1JGwOiaVmXXjCQzTaMmwWDk+Fc6nkUb3KT0J7GMj7sdvFp/7QHEMXoqBBA0NHCNR/GWXEmZZyDgwfD9gUmu0pmZ4+8nNiUZLeunBZ+OyO3r2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYWgmCqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYWgmCqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CF6C32786;
	Tue,  9 Jul 2024 21:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720562268;
	bh=cPUToijK5JVO10fs7Dy3ydNXFXyU7AehucSFWFmRg6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYWgmCqmU/JDN8NT4MPuYHWHB/S2Ixz0+sj9C3BT4GG8W0edcmru3t3+IYU7Hnnbb
	 VJp1RRG/o/RXynjSndt8c3m6zLRforh3h5LfdhxDbsoe/QZ+TIf84vdosVRrIGUlal
	 H6GgGtsEWqBRSsMLZFM8BvLl7loAeexffOOw8SLRfyuNdsRgSxSDNw9Upm/hl0IgwV
	 iC4lZU6ZEmn6F48auWni9e0n43ffXS/rZXKqRFbnAm8wlVefuujgAQ1Fnv989M27WC
	 AxgbolKCV74jq0gBb5NRJ8Tx99TPX1Q2Kjk1ynbF+blQ3jQaC9/LYHpRHV+POglO7Y
	 Foy0mzvrXpKlA==
Date: Tue, 9 Jul 2024 14:57:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] libxfs: remove duplicate rtalloc declarations in
 libxfs.h
Message-ID: <20240709215747.GB612460@frogsfrogsfrogs>
References: <20240709073444.3023076-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709073444.3023076-1-hch@lst.de>

On Tue, Jul 09, 2024 at 09:34:31AM +0200, Christoph Hellwig wrote:
> These already come from xfs_rtbitmap.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Changes since v1:
>  - now without spurious man page removal
> 
>  include/libxfs.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index fb8efb696..40e41ea77 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -220,11 +220,6 @@ libxfs_bmbt_disk_get_all(
>  		irec->br_state = XFS_EXT_NORM;
>  }
>  
> -/* XXX: this is clearly a bug - a shared header needs to export this */
> -/* xfs_rtalloc.c */
> -int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> -bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> -
>  #include "xfs_attr.h"
>  #include "topology.h"
>  
> -- 
> 2.43.0
> 
> 
