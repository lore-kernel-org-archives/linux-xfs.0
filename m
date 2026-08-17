Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496534EF0D
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 22:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787007329; cv=none; b=E98FEx3RPN94QAAqwPrbcfcPEtjcFnuRF6tUF6FUThfvM+j+hI2Jo7GYZt3+39Znzhf+oq5pYYtJ5qG9eXkcGnD64EPKxL42LXowFUkBSp14GvHoK6slpKMPrfHU4LjcbEPPZZfkBi1CHI1JDDEZFTpaY2OUxVxJItCNjjq84L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787007329; c=relaxed/simple;
	bh=gg2abzKHsAnI2K7qrW9EDSVDpnOLCF7bL8q9BkkqFlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imcPqay/Nwj0FhkW9+SCVB51IOITWZDk1eDqxT/iX4LV1Ln1j2w9JbiYi0Us9NhtZAW/gSwxYXLMOhoFsIuUwTzKR+2tu06fSRdN5kwrS4gbtXOuRb42ptKF5+2lVxS18TgM2JmO4yZD/s1lXQpCGnqdW8CHTv9NLFD7ZR53HLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ms5UaSAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ms5UaSAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759AA1F000E9;
	Mon, 17 Aug 2026 22:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787007327;
	bh=RvMnvpJVdBmx1cf9rElqTHyaAUSxwKsEwnMnsQ4r2vc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ms5UaSAxK4OWI/AZWcKZd6fB54iGBnj5uhRHqnXTa/OYgnDjjrk1wUjdLnpP+1mYz
	 P2M8G81FentFIlmdawscuV5SEZDCFyoNfAYcxbrsGLI1sUM5Q1AuIG0ChjZ6AuNmmd
	 pX47twjVmVwZOX4YhRIPSdSjXEG0nsYbryjcddjdTx3mfejS371HrAvqy7rmcTT96S
	 DxmZI0kjoJ4NpG0fiokYulwCrJlzFbTPovElFAo+oiqVwyuQzikKO9ywA+Jd8+CHvH
	 wewYskp6YLi/TfoMWwiazc2ndF7pFm2h//Vl63wEeBUdbIG4O2Yp433HH6E6s09NN3
	 PVJspb8BfGdMA==
Date: Tue, 18 Aug 2026 08:55:19 +1000
From: Dave Chinner <dgc@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 3/3] xfs: incorporate increased AGFL min requirement
 for minleft allocs
Message-ID: <aoORV3bgMqDs5rUC@dread>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814132239.271492-4-bfoster@redhat.com>

On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
> Matt Fleming reports a filesystem shutdown due to inobt block
> allocation failure during sparse chunk allocation. Inode creation
> can involve multiple allocations in a transaction: the initial chunk
> allocation and inode btree blocks via inobt record insertion. This
> is expected to be safe by using the minleft parameter on the chunk
> allocation to guarantee the selected AG has blocks available for
> a followup inobt insertion.
> 
> The sequence that leads to this failure is that the alloc and inode
> btrees are all full (require a full split on next insertion) and the
> AG has just enough free space to satisfy a sparse chunk allocation
> with minleft set (i.e. 7 blocks in this example). The chunk
> allocation splits a free extent, triggers full allocbt splits, and
> consumes 4 free blocks for the chunk and 4 AGFL blocks for the
> btrees.
> 
> Next, the inobt record insertion triggers an inobt split. The AG has
> enough free blocks, but the allocbt splits caused by the chunk
> allocation have increased the min AGFL requirement for the AG due to
> btree level increases. The AGFL requirement as calculated by
> xfs_alloc_fix_freelist() is:
> 
> 	free + AGFL - res - minfree - minleft = avail
> 
> This evaluates to the following on initial chunk allocation:
> 
> 	2514 + 8 - 2505 - 8 - 2 = 7
> 
> ... and then after the chunk allocation but before the inobt block
> allocation:
> 
> 	2510 + 4 - 2505 - 12 - 0 = -3
> 
> This causes the inobt alloc to fail despite minleft being set in the
> first allocation. The error path cancels the dirty transaction and
> shuts down the fs.
> 
> The problem here is that while minleft ensures free blocks are
> available for the inobt insert, it is not sufficient to cover the
> increase of the AGFL min free requirement. To address this, create a
> variant of the AGFL min free calculation for minleft allocations
> that incorporates an additional allocbt level increase.
> 
> We do not add the additional blocks directly to min_free because
> this would lead to spurious AGFL block allocations and frees in the
> common case (i.e. no btree splits). Instead, add the surplus block
> requirement to the minleft value used to select the AG. This ensures
> the AG has enough blocks for the caller's minleft value plus the
> worst case increase in the AGFL. In the example above, the initial
> calculation now evaluates to 3 blocks available instead of 7 and the
> sparse inode allocation fails gracefully with -ENOSPC.
> 
> Reported-by: Matt Fleming <matt@readmodwrite.com>
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 29 ++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc.h |  2 ++
>  fs/xfs/libxfs/xfs_bmap.c  |  2 +-
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index dbb85fb6314b..74c5b587c87b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2500,6 +2500,20 @@ xfs_alloc_min_freelist(
>  	return __xfs_alloc_min_freelist(mp, pag, 0);
>  }
>  
> +/*
> + * Return the minimum freelist requirement considering a potential allocbt split
> + * from the current allocation. Use this when computing longest free extent for
> + * allocations with minleft set to ensure that the available extent length
> + * accounts for the subsequent allocation's increased AGFL requirement.
> + */
> +unsigned int
> +xfs_alloc_min_freelist_minleft(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
> +{
> +	return __xfs_alloc_min_freelist(mp, pag, 1);
> +}
> +
>  /*
>   * Check if the operation we are fixing up the freelist for should go ahead or
>   * not. If we are freeing blocks, we always allow it, otherwise the allocation
> @@ -2517,6 +2531,7 @@ xfs_alloc_space_available(
>  	xfs_extlen_t		reservation; /* blocks that are still reserved */
>  	int			available;
>  	xfs_extlen_t		agflcount;
> +	xfs_extlen_t		minleft;
>  
>  	if (flags & XFS_ALLOC_FLAG_FREEING)
>  		return true;
> @@ -2533,10 +2548,22 @@ xfs_alloc_space_available(
>  	 * Do we have enough free space remaining for the allocation? Don't
>  	 * account extra agfl blocks because we are about to defer free them,
>  	 * making them unavailable until the current transaction commits.
> +	 *
> +	 * If minleft is set, this allocation might cause an allocbt split that
> +	 * increases the AGFL minimum for the next allocation in the
> +	 * transaction. Reserve that space from the available block count
> +	 * (without prematurely growing the AGFL) to prevent the subsequent
> +	 * allocation from failing due to an increased min_free requirement.
>  	 */
> +	minleft = args->minleft;
> +	if (minleft) {
> +		minleft += xfs_alloc_min_freelist_minleft(args->mp, pag) -
> +					min_free;
> +	}

This seems fragile to me. It is based on the assumption that
min_free is calculated from xfs_alloc_min_freelist() by the caller,
and then this calculates the difference between what the caller should
have calculated and what is actually needed.

Where this mod is placed also results in the longest available
extent check not taking into account this modified min_free
requirement, whereas the check in xfs_bmap_longest_free_extent() is
modified to take this modified minleft value into account. i.e. the
checks w.r.t. minleft and longest extents are no longer consistent
across the layers.

I'm also concerned that this results in the
xfs_alloc_space_available() caller using different values of "need"
and "minleft" to what the actual space availablity calculation is
using; that feels like a future landmine to me.

i.e. the xfs_alloc_space_available() caller already knows is minleft
is set, so if it were to use xfs_alloc_min_freelist_minleft(), then
there would not need to be this "correction" in this code and all
the values would be consistent.

Unless I'm missing something subtle, I think that the callers should
not need to know it should call xfs_alloc_min_freelist_minleft() or
xfs_alloc_min_freelist() as it feels like exposing internal AGFL
space/btree accounting requirements into an external API. All the
caller needs to signal is whether this is the first of a chain of
allocations or not (i.e. args->minleft != 0), and the internal alloc
code should handle it from there.

Hence I suspect it would be much cleaner just to add a 'bool
multialloc' parameter to xfs_alloc_min_freelist() and have all
callers set it appropriately. That would avoid the need for the
wrapper functions and keep this AGFL reservation wart
completely internal to the AGFL reservation calculation....

Thoughts?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
