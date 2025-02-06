Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61807136352
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872894; cv=none; b=KzJ3L83LXBYDIDPTgFA/IeysLUMLSalB21CrA0qIMaui6O3x4+mACCv8sQ9xP1nLQ5fcsDrwwb7J0R0MTmc552PQ4zePfsCAAN99lNINA2RU16wujxGEz96AIjpGdPCFLhNP0Kt0Oie6E16RsblMfY8FB+6FYpIvUvxFO38lPY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872894; c=relaxed/simple;
	bh=zZYa5J+zOSsoSwxaEdSwbMKRxBMaO/mQq59ITrPp4rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TS8iMUvLF5V6AosQOm6G2m7Bfr2AONJGAfurIy6NRm7bvFTEK7PlaE8EHijjUkMjJIVfddVKPo5jr13J56DXeAL3t0Lq4gMcKVmHaBhanSqMj+mrqC4RAEJp+oVFhDvINVqOKVLL9uPgNdBO9N1ilPLxsynQkNcGTFGgrwOtxl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgBXK6YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgBXK6YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD21C4CEDD;
	Thu,  6 Feb 2025 20:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738872893;
	bh=zZYa5J+zOSsoSwxaEdSwbMKRxBMaO/mQq59ITrPp4rU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HgBXK6YY5sr2rFQarpgkMozo+Lf4CQAyeK+ckYrr4Xj9cMFx7M4HACEnvq4OVQR2Z
	 HqD3MZP1Nl+GzS74CQxwn8vbr6wZk06S2eQLnuf8by3GHWuXQJTGna1/nE1u9D30qD
	 d9UJ0jJaiZrFHJ/UtT1DCTqdTpjptA2iXvhnSPSzpyZFlZwLKJqCDZ+XshawMq40LR
	 zg+DyunqYmzSgRikeZUQ8vZ21F4KB8Shl2WK3N5a76Lfp7xYBoRgmUot1sAA2ftBfL
	 JisHeektfAr0eAczinX4NO6Sd8hrvke6cDWAoOnx+Ai/bn1c6xq7C+u2hJEHDGyP2P
	 z7ceAPUpEJH/Q==
Date: Thu, 6 Feb 2025 12:14:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/43] xfs: reflow xfs_dec_freecounter
Message-ID: <20250206201453.GJ21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-9-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:24AM +0100, Christoph Hellwig wrote:
> Let the successful allocation be the main path through the function
> with exception handling in branches to make the code easier to
> follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 26793d4f2707..65123f4ffc2a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1329,28 +1329,29 @@ xfs_dec_freecounter(
>  	set_aside = xfs_freecounter_unavailable(mp, ctr);
>  	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
>  	if (__percpu_counter_compare(counter, set_aside,
> -				     XFS_FDBLOCKS_BATCH) >= 0) {
> -		/* we had space! */
> -		return 0;
> -	}
> -
> -	/*
> -	 * lock up the sb for dipping into reserves before releasing the space
> -	 * that took us to ENOSPC.
> -	 */
> -	spin_lock(&mp->m_sb_lock);
> -	percpu_counter_add(counter, delta);
> -	if (!rsvd)
> -		goto fdblocks_enospc;
> +			XFS_FDBLOCKS_BATCH) < 0) {
> +		/*
> +		 * Lock up the sb for dipping into reserves before releasing the
> +		 * space that took us to ENOSPC.
> +		 */
> +		spin_lock(&mp->m_sb_lock);
> +		percpu_counter_add(counter, delta);
> +		if (!rsvd)
> +			goto fdblocks_enospc;
> +
> +		lcounter = (long long)mp->m_resblks[ctr].avail - delta;
> +		if (lcounter < 0) {
> +			xfs_warn_once(mp,
> +"Reserve blocks depleted! Consider increasing reserve pool size.");
> +			goto fdblocks_enospc;
> +		}
>  
> -	lcounter = (long long)mp->m_resblks[ctr].avail - delta;
> -	if (lcounter >= 0) {
>  		mp->m_resblks[ctr].avail = lcounter;
>  		spin_unlock(&mp->m_sb_lock);
> -		return 0;
>  	}
> -	xfs_warn_once(mp,
> -"Reserve blocks depleted! Consider increasing reserve pool size.");
> +
> +	/* we had space! */
> +	return 0;
>  
>  fdblocks_enospc:
>  	spin_unlock(&mp->m_sb_lock);
> -- 
> 2.45.2
> 
> 
