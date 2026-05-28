Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6582F8E92;
	Thu, 28 May 2026 04:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779943528; cv=none; b=XjMIlsub9FySf6e2V0jey2yV6YAhZektrJLOJBruqv+3FiUTCgtGzyh7F7r6fXhfwk/49udJ5c3NQhWLJKXxaA7n6bPAR4IE9lPAgtP1igOv/DtqEh8A1hbl6UR99F6so5AnwotNpIR7uQ28ajMR5S3ruGbj/cvet41NUAgvh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779943528; c=relaxed/simple;
	bh=mo70hTOT5D2soqKNPOqk8UubqdZD8P+SFMkIJwR8bZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftu4V2I/w9UlNdMy/rRvIjSvMe1ET2Zy91Y/NJM49BBprVHPHGlfIwlw+nK+PlJPPsN7E+72PIUUxexbYQmEzulwzsesIr+JrklVRuoLBdtDdqYuvehr19jjQNrN61OROjJ7hn59+4u9Ys9Mkkn9Qc0j4Jc9n8ZQhouWfJ7OEWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FB9x1fgh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FB9x1fgh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2EF7C1F000E9;
	Thu, 28 May 2026 04:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779943527;
	bh=hEHXpUcTD3G+u+eJu0+jYZ6CAdLCjjPoTCnuVSepv5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FB9x1fghxOeh6XCRJ4EE7BILghz2tM03MooEUnfzaPljA0pIO0PRg8Jatu+xXXGFX
	 N40Jw6J5mA+NcmAZS9bgFtCvmR0maOw/SnzmM9hve+s8qrgMgt8IAR2mOYiYJ54se9
	 OtaQ99o5wjhNSmMjJ/NUAoJESl+qoZyv9MazyT22XHNj97139Lj67aGUY9H/h+Jnre
	 vCYQZHguj0/Y+CupCpFZHeb0H4fjVMY3QLDaJrNMS5S4gPmbTDOu2EikrGEHj/TGUK
	 LppYQwge1yVmKUdR8sJ5SlzI313CvBdQ8n6H7fBNRVUO5PvkK/YKiB1xxWsd2SvqCC
	 bWvFftNUq+H3A==
Date: Wed, 27 May 2026 21:45:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] xfs: fix rtgroup cleanup in CoW fork repair
Message-ID: <20260528044526.GB6078@frogsfrogsfrogs>
References: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-3-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527043134.1550710-3-gaoyingjie@uniontech.com>

On Wed, May 27, 2026 at 12:31:34PM +0800, Yingjie Gao wrote:
> xrep_cow_find_bad_rt() initializes scrub rtgroup state before the
> force-rebuild path calls xrep_cow_mark_file_range(). If that call
> fails, the code jumps directly to out_rtg, which skips the scrub
> rtgroup cleanup and only drops the local rtgroup reference.
> 
> Remove the unnecessary jump so the function falls through to out_sr,
> ensuring the realtime cursors, lock state, and sr->rtg reference are
> released before returning.

Cc: <stable@vger.kernel.org> # v6.14

> Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>

With the cc tag, this looks good to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/cow_repair.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index a6ff09ace43d..c25716fc4fee 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -382,12 +382,9 @@ xrep_cow_find_bad_rt(
>  	 * CoW fork and then scan for staging extents in the refcountbt.
>  	 */
>  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
> -	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> +	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
> -		if (error)
> -			goto out_rtg;
> -	}
>  
>  out_sr:
>  	xchk_rtgroup_btcur_free(&sc->sr);
> -- 
> 2.20.1
> 
> 
