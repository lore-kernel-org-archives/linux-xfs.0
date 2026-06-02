Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A722DB798
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375002; cv=none; b=UFSXtRCDt//i5CMyNtPuxVHkDNNhZ93pwt68AwJMRHMsegc0g1eUHuNzmzP2jt5aQUI79MzW8ttcLewDj3+nBkefzDak1KJDMs3EJ8CGnqsbE3CCY7Ii9iiZuHo5lO3dN5CMn0XGfOn1eEJ3MgUnntD+HD2SoOrCV1Yxm3aGGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375002; c=relaxed/simple;
	bh=F4U+c4tbFw8s1PYybqCv9XlXniudUCJc3bLL9JYWgQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trN0GL21UrJXtOitfOj6/PU1LpuIukZKCb/AgkZ8sENGqH4xfMnE1cILqkCfIhvpTLLbGZAD8qkoTrANMO/LQ+2r1CGrrDqr7WLDCjjV8JmOEGyyA9Es6SzUFUXrTT+4WiDfv78hn2wdWjI6Chi6WrWtqiw9jPP+e9aX2n4P5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oS+qeDhM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oS+qeDhM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0BC351F00893;
	Tue,  2 Jun 2026 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375001;
	bh=Cv8IIuDQYP5sjGJlS8qb/y9I0+YNrzOu8LgQ9pGTfC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oS+qeDhMMuNjaghb7AfPphcOLlJGAuM920S8PA3USp6nLHB7X+ij6iRarNLudKWiy
	 HJ0Q0S/V0XtlcurjU7t5qNkFfgeFwhfhW37QT0RHDbVb5e1pW8dvPXFUkcaMXqJa6H
	 bin8Fc1PnI8NT/HpwTSsgQglbBaXtxXIeCmD0rGji5dPpTM5YKeWbMwczWpIKLadAq
	 e/XaU4vPtSJpA8PfuANF5XI9ijw7AEw7kIuCQ6Q4Np0U5k2qj+dK1iCcp1blr/CoK1
	 eQiM/yC5HF77fFuLTVfRVaUd5slBg9rYLcS4A67d0B1LHG8wChNptxvCXRaN8exOuI
	 WhbPM1eNpHOUA==
Date: Mon, 1 Jun 2026 21:36:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: pass back updated nb from
 xfs_growfs_compute_deltas
Message-ID: <20260602043640.GM6078@frogsfrogsfrogs>
References: <20260601110824.3392683-1-hch@lst.de>
 <20260601110824.3392683-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601110824.3392683-2-hch@lst.de>

On Mon, Jun 01, 2026 at 01:07:52PM +0200, Christoph Hellwig wrote:
> xfs_growfs_compute_deltas can update nb for corner cases like a number
> of blocks that would create a less the minimal sized AG, or running
> past the max AG limit.  Pass back the calculated value to the caller,
> as it relies on that for a few things.

A few things, like getting the fs size right after the grow?

Cc: <stable@vger.kernel.org> # v7.0

With that added,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Fixes: a49b7ff63f98 ("xfs: Refactoring the nagcount and delta calculation")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 10 +++++-----
>  fs/xfs/libxfs/xfs_ag.h |  2 +-
>  fs/xfs/xfs_fsops.c     |  2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index dcd2f93b6a6c..0c5f0548021f 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -866,7 +866,7 @@ xfs_ag_shrink_space(
>  void
>  xfs_growfs_compute_deltas(
>  	struct xfs_mount	*mp,
> -	xfs_rfsblock_t		nb,
> +	xfs_rfsblock_t		*nb,
>  	int64_t			*deltap,
>  	xfs_agnumber_t		*nagcountp)
>  {
> @@ -874,19 +874,19 @@ xfs_growfs_compute_deltas(
>  	int64_t		delta;
>  	xfs_agnumber_t	nagcount;
>  
> -	nb_div = nb;
> +	nb_div = *nb;
>  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>  	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>  		nb_div++;
>  	else if (nb_mod)
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> +		*nb = nb_div * mp->m_sb.sb_agblocks;
>  
>  	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>  		nb_div = XFS_MAX_AGNUMBER + 1;
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> +		*nb = nb_div * mp->m_sb.sb_agblocks;
>  	}
>  	nagcount = nb_div;
> -	delta = nb - mp->m_sb.sb_dblocks;
> +	delta = *nb - mp->m_sb.sb_dblocks;
>  	*deltap = delta;
>  	*nagcountp = nagcount;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 16a9b43a3c27..8aa4266c5571 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -330,7 +330,7 @@ int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>  int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>  			xfs_extlen_t delta);
>  void
> -xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
> +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
>  			int64_t *deltap, xfs_agnumber_t *nagcountp);
>  int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>  			xfs_extlen_t len);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 8d64d904d73c..436857356a0a 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -124,7 +124,7 @@ xfs_growfs_data_private(
>  			mp->m_sb.sb_rextsize);
>  	if (error)
>  		return error;
> -	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
> +	xfs_growfs_compute_deltas(mp, &nb, &delta, &nagcount);
>  
>  	/*
>  	 * Reject filesystems with a single AG because they are not
> -- 
> 2.53.0
> 
> 
