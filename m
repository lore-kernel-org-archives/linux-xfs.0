Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B2C1F78E6
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179960; cv=none; b=WFBIaR3wp4mgKS1VTdIoV/RwS0570qg70mkptGYYRjFWglbZCRJU5c8ephLtfusNfkwhBUoFh1+7YSy8EKrPzG4ZoKIpuXlT+lQCr5VrAcEgwnKfHjGJ5kpECVsnqu3+HX35yj2wUBPP2shrfVLoRnKnXz1SLcJKp5vbuS8TPHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179960; c=relaxed/simple;
	bh=d+RRB/BWew7ET+I/VASl+Xkva1cOSXX8pv5dPgbghmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJ9W0Z8zYCcKOu6+HrRlJ2ktwKrn7coTFT6yY5O3uK+L6U5hB7gwB3KGOw8/MfJyyUfG5thE8iyBlRCuMD43v0xZPJArrqL6ZaCXzogLn1OXr4daUGBKQUIQg8bU1xHKwjV9CRxR050DdEjVVEm6jhPs27fx6muHvlIVnvV4L5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ny9ZVKF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ny9ZVKF9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 631121F000C4;
	Fri, 16 Oct 2026 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179959;
	bh=Vh6wvIuvrYOdyFgCbFRcvVPHxD/6sgIrRZkLfACdfvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ny9ZVKF9bbq3J2AlH7iv5siOs4y0VkCzMM0Yi97nnRQbXwECXI2Voj9yv6gvYP3Uk
	 xh/SItqepYU5LqwwVhIWBX7s6wXFaCv4VMS2iHFrtaxi9TUHwbDsOtgygiqYewqjUx
	 BL6LIzzvr7eEGQkocqi7w/FHR4KXaRThuzs69Ok27fbcLAGxSkMmxRjUIrCEFTwPYz
	 1IwfmEVVupw7E7cV/CRmAhxNrmoGZw5/Y6y9akRTfY5sb59towM0Wnk8hJziPZrUSi
	 l9R7MIcFKDoAF+sFjpYZuIvzbP5t8RX6FWmuTHQWFSiDVWuUJNVisaOgTq9kX+n0E1
	 cWPGFGvwiat5w==
Date: Fri, 16 Oct 2026 12:45:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 4/8] xfs: remove redundant stat check after
 rcbagbt_insert()
Message-ID: <20261016194558.GF107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-5-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-5-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:04PM -0500, Eric Sandeen wrote:
> rcbagbt_insert() simply returns the error and status from
> xfs_btree_insert, which has already validated the insert
> or returned an error.
> 
> This makes this instance of this idiom:
> 
> 	error = rcbagbt_insert(cur, &bagrec, &has);
> 	if (error)
> 		goto out_cur;
> 	if (!has) {
> 		error = -EFSCORRUPTED;
> 		goto out_cur;
> 	}
> 
> unnecessary/unreachable code. Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/rcbag.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
> index 8f3a10f7c908..fd9ccb205725 100644
> --- a/fs/xfs/scrub/rcbag.c
> +++ b/fs/xfs/scrub/rcbag.c
> @@ -105,10 +105,6 @@ rcbag_add(
>  		error = rcbagbt_insert(cur, &bagrec, &has);
>  		if (error)
>  			goto out_cur;
> -		if (!has) {
> -			error = -EFSCORRUPTED;
> -			goto out_cur;
> -		}
>  	}
>  
>  	xfs_btree_del_cursor(cur, 0);
> -- 
> 2.55.0
> 
> 
