Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986031DE3C8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734042370; cv=none; b=F7DM+4DqB+i4UzMQmXrN7gO6wDlfnpBna1qhL5BRHSOe0cVV50qlKi1ZvRBnrqAtV5wo8jP+3cmpqJx98gcqzfb0tPbYtxBZpqFoV3Qpsla8r5shjlas2PoE1M4sxRwOz2uOom09tSp7R5q6Uh2pq5zY71j6vOkipV2BSBd2RQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734042370; c=relaxed/simple;
	bh=YZ6gamFEZ8jnXGnOPk3mEVPtlL79zMZUFa2JxNIR540=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bzx8I522VvYBomgCCUAShnIGIEPmYwvHhgvTOK95rq3wBAw5gmz5cfGKycXLUU+pt7G99FU6wZlTg7tkM4f+ainUTjJgNi2iXmrhGMYUYbvZ9KYMLulrLWdQXACcvS0GtZ08mOy5Nt2PTMMlsyuKKwc901utqG1GfbWydciN/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPZeOKn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPZeOKn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6313BC4CECE;
	Thu, 12 Dec 2024 22:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734042370;
	bh=YZ6gamFEZ8jnXGnOPk3mEVPtlL79zMZUFa2JxNIR540=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPZeOKn6mADwT/jItyQFpMGtwG0ZfSia2r1cVa3rCB7ENtgFEzBlVU178yFDZVQMa
	 pTk5InVc3OXtHqJBWuYsM5lpTq3TbNVObNL+UukV8OC3F++OJc8rwmWU97u+k0E7Lh
	 uORkDzjZWOjVzGR0jDZ87vAilhakYjZN//johiJ5McbloJ3Vrqz7bibvNF2tVhMJPB
	 xE5EYZrppXSqAK5OCGCpsequwjdsUj06SCnXg/6w/gvT3CICFGQFgk08o2LsyQ/zoG
	 cNzIsvBkOZJweiZ9vIMARmKI1u2P8u5Il+95Mkm6Usf+rtOJUNU4SiMuoA+v14HREg
	 YJlNsvgmbzGNg==
Date: Thu, 12 Dec 2024 14:26:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/43] xfs: disable sb_frextents for zoned file systems
Message-ID: <20241212222609.GH6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-20-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:44AM +0100, Christoph Hellwig wrote:
> Zoned file systems not only don't use the global frextents counter, but
> for them the in-memory percpu counter also includes reservations taken
> before even allocating delalloc extent records, so it will never match
> the per-zone used information.  Disable all updates and verification of
> the sb counter for zoned file systems as it isn't useful for them.

How is XC_FREE_RTEXTENTS initialized at mount time, then?

/me peeks ahead.

Oh, it and XC_FREE_RTAVAILABLE are set in xfs_mount_zones from values
that are computed by querying the hardware zone write pointers (or its
software equivalents if the rt device isn't zoned).  So the two incore
free rt space counters are completely detached from the ondisk
superblock counters.

What should be the value of sb_frextents, then?  Zero?  Please specify
that in the definition of xfs_dsb and update the verifiers to reject
nonzero values.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_sb.c           |  2 +-
>  fs/xfs/scrub/fscounters.c        | 11 +++++++++--
>  fs/xfs/scrub/fscounters_repair.c | 10 ++++++----
>  fs/xfs/xfs_mount.c               |  2 +-
>  fs/xfs/xfs_super.c               |  4 +++-
>  5 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 6fc21c0a332b..ee56fc22fd06 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1305,7 +1305,7 @@ xfs_log_sb(
>  	 * we handle nearly-lockless reservations, so we must use the _positive
>  	 * variant here to avoid writing out nonsense frextents.
>  	 */
> -	if (xfs_has_rtgroups(mp)) {
> +	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
>  		mp->m_sb.sb_frextents =
>  			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
>  	}
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 732658a62a2d..5f5f67947440 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -413,7 +413,13 @@ xchk_fscount_count_frextents(
>  
>  	fsc->frextents = 0;
>  	fsc->frextents_delayed = 0;
> -	if (!xfs_has_realtime(mp))
> +
> +	/*
> +	 * Don't bother verifying and repairing the fs counters for zoned file
> +	 * systems as they don't track an on-disk frextents count, and the
> +	 * in-memory percpu counter also includes reservations.
> +	 */
> +	if (!xfs_has_realtime(mp) || xfs_has_zoned(mp))
>  		return 0;
>  
>  	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> @@ -597,7 +603,8 @@ xchk_fscounters(
>  			try_again = true;
>  	}
>  
> -	if (!xchk_fscount_within_range(sc, frextents,
> +	if (!xfs_has_zoned(mp) &&
> +	    !xchk_fscount_within_range(sc, frextents,
>  			&mp->m_free[XC_FREE_RTEXTENTS],
>  			fsc->frextents - fsc->frextents_delayed)) {
>  		if (fsc->frozen)
> diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
> index 8fb0db78489e..f0d2b04644e4 100644
> --- a/fs/xfs/scrub/fscounters_repair.c
> +++ b/fs/xfs/scrub/fscounters_repair.c
> @@ -74,10 +74,12 @@ xrep_fscounters(
>  	 * track of the delalloc reservations separately, as they are are
>  	 * subtracted from m_frextents, but not included in sb_frextents.
>  	 */
> -	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
> -		fsc->frextents - fsc->frextents_delayed);
> -	if (!xfs_has_rtgroups(mp))
> -		mp->m_sb.sb_frextents = fsc->frextents;
> +	if (!xfs_has_zoned(mp)) {
> +		xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
> +				fsc->frextents - fsc->frextents_delayed);
> +		if (!xfs_has_rtgroups(mp))
> +			mp->m_sb.sb_frextents = fsc->frextents;
> +	}
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index db910ecc1ed4..72fa28263e14 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -551,7 +551,7 @@ xfs_check_summary_counts(
>  	 * If we're mounting the rt volume after recovering the log, recompute
>  	 * frextents from the rtbitmap file to fix the inconsistency.
>  	 */
> -	if (xfs_has_realtime(mp) && !xfs_is_clean(mp)) {
> +	if (xfs_has_realtime(mp) && !xfs_has_zoned(mp) && !xfs_is_clean(mp)) {
>  		error = xfs_rtalloc_reinit_frextents(mp);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 18430e975c53..d0b7e0d02366 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1127,7 +1127,9 @@ xfs_reinit_percpu_counters(
>  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
>  	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
>  	xfs_set_freecounter(mp, XC_FREE_BLOCKS, mp->m_sb.sb_fdblocks);
> -	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
> +	if (!xfs_has_zoned(mp))
> +		xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
> +				mp->m_sb.sb_frextents);
>  }
>  
>  static void
> -- 
> 2.45.2
> 
> 
