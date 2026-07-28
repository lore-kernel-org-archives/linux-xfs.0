Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29141305057
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252390; cv=none; b=Z6MgMHrubhD0sB56BUP3TFciTkVIedKDNrUMv6GjBxBWorQas71fUnzqkiDN6WBTZPoO4GA/K29x8fRuliXGUUJ2xRiZUBJml6wXs8v+nJ0TXum6ZdYWrpK2NVswCWl7wlDQAZGPa0Fxvhz1QQMxz5vaoQBQzii+VldTvQ/BNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252390; c=relaxed/simple;
	bh=3QnQkzJi9IHtjQYn3ERIT2SpPS0WySmIF48zszwjn5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tnf3CouacFbbj6IocLgRjn8GH5JNTIgquCw5hqozBzEHC3GiE22KLU5+XhiiZExybp40Wr9IF2IFCQXGH5qsr7bQwABRyh/xPD4KPAb0Chy/54GOl5gjExwKHHDeuYFmDzKhv1cZwEEdsKS4M6lcfLz5el17T90L3rOJt0kr2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6RFz7P5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6RFz7P5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECF831F000E9;
	Tue, 28 Jul 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252389;
	bh=dqAuMKVFOOQYLT7qXodg9kjhfob7tf3gC5/+fdsLVL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T6RFz7P5S7EDkIs51FPQFZW/+UMa5LGJO6cUG/tcdK5B34ibLWOpjL//G6R3CqGB9
	 32vBsEhxkB3Zobt4Es994sYBC5urw38UT6lsPQZzV9Z2Cg99oLNtQvgg81nXmTsLu8
	 003H/Qz1JHWYy/d5ET9nAEuHeV+I4QQ/L8JEMQkZGXFXuHMCqwx1zsqGeAuQKlyK+a
	 hCWgVnp4j41+LVlsRUdXvvuGkw6NQ2rXFnwKB0sEADQ0rOAzgWbfWZB4qlhlZl5ddV
	 153tYb/4pJoe4nULTeWnBvqticjAe2pRKUUhCKbGY4R7+oW0KLDLGo9Uz59c+5Wg4t
	 w3Q9//ByZlMbQ==
Date: Tue, 28 Jul 2026 08:26:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check v5 superblock features early
Message-ID: <20260728152628.GN2901224@frogsfrogsfrogs>
References: <20260728080435.1777362-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728080435.1777362-1-hch@lst.de>

On Tue, Jul 28, 2026 at 10:04:35AM +0200, Christoph Hellwig wrote:
> When working on a new features that reuses the existing pad in the
> superblock, I noticed that mounting such a file system on an old kernel
> logs a rather confusing warning:
> 
>     XFS (vdc): Metadir superblock padding fields must be zero.
> 
> This is because we only validate the various feature fields in v5
> superblocks after the common superblock validation helper is called.
> 
> Fix this by calling the feature validation first.  To make this more
> obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
> call it for v5 file systems.

Shouldn't it be called xfs_validate_v5_sb_features then?

Oh.  There's already a xfs_sb_validate_v5_features function that checks
that the v4 feature bits are set correctly for a v5 filesystem, and it
would be confusing to have both.  Could we move the code in
xfs_validate_sb_read into xfs_sb_validate_v5_features instead?

If you do that, then xfs_sb_good_version will validate the feature bit
recognition, which it doesn't do now.  I'm not sure what weird side
effects might result from that though.

> Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Cc: <stable@vger.kernel.org> # v4.19

> ---
>  fs/xfs/libxfs/xfs_sb.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..e3fc19440e0f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -189,15 +189,12 @@ xfs_sb_version_to_features(
>  	return features;
>  }
>  
> -/* Check all the superblock fields we care about when reading one in. */
> +/* Check for compatible v5 superblock features when reading a superblock */
>  STATIC int
> -xfs_validate_sb_read(
> +xfs_validate_sb_features(
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp)
>  {
> -	if (!xfs_sb_is_v5(sbp))
> -		return 0;
> -
>  	/*
>  	 * Version 5 superblock feature mask validation. Reject combinations
>  	 * the kernel cannot support up front before checking anything else.
> @@ -1118,10 +1115,12 @@ xfs_sb_read_verify(
>  	 * because _verify_common checks the on-disk values.
>  	 */
>  	__xfs_sb_from_disk(&sb, dsb, false);
> +	if (xfs_sb_is_v5(&sb)) {
> +		error = xfs_validate_sb_features(mp, &sb);

By putting xfs_validate_sb_features ahead of xfs_validate_sb_common, I
think we now validate the V5 feature bits (if the V5 versionnum is set)
before checking the superblock magic.  Right?

--D

> +		if (error)
> +			goto out_error;
> +	}
>  	error = xfs_validate_sb_common(mp, bp, &sb);
> -	if (error)
> -		goto out_error;
> -	error = xfs_validate_sb_read(mp, &sb);
>  
>  out_error:
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> -- 
> 2.53.0
> 
> 
