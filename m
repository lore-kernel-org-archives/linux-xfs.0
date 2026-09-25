Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8344EE86A
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790380308; cv=none; b=p3WvhQHJzRLVCqKVxjFb9GF5S4YYmQAyTX1yt2XpDSFSAse2jysKmfjbk87OZzoBFdw7fRIgDRYH79UMf69dMrkga2V9VEE23yxfD1/HlSRdMdI4RWTWXeCBUuXtKzyApXNCX6E4Cr+UdMsbsiHGbZyh8rMDE/+Br/5k8BfGXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790380308; c=relaxed/simple;
	bh=4i+9p3rEiuuNDim3PbcMfT0JwpJfBD/+abfZMG2ISgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpmDGvfDBsddXiNLIszgEk2fwIR+w20juLtmIX9rODhevhEujoIxtbZsJQYYqkSbyqQbG2++PR9RS0p/obc8Uw065KbLo3WZZUjjdhlL8t/VJw3IKQSbzAxufTF5070Vaefqwh+kbuRtH47Rb8qB2/uRHwJ4tXeg8JEi0l2GBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i828E3Nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i828E3Nb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A8A901F000FF;
	Fri, 25 Sep 2026 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790380306;
	bh=08xK5Yp8kZrfpkwyj0Yu1Wg44uG8YeFGM0hdv9x0IF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i828E3NberWX2aCOj6ug8SZYxxvQi3Cfjin6euNsvjh9QY+it+M4PSPn9B1arQbgL
	 RJhjWGreH5LK+SPF/Ie9/sFj++z/Jl42HMtx5NLwGtipvfN2weBXOrAiNuxHuTHxDW
	 dXa7RXzA2byORnzp06erDWtPOYG9g0sNb0MfJ+0TOgy7DHMbT7baYovMlaYt2N11eo
	 eYy4521JCWXyIGp7vt20WPCEScKwePc+ky08rKCc2fb5mGu9v9lTjouYDNh1mo2eEP
	 EiM3IaKy54LKkxGjaS9d943ROpX1MTH1dwtiPTIgL/vdca6dpGKaFGP+0fFzhOF8S0
	 Z7S4aVItfFcbw==
Date: Fri, 25 Sep 2026 16:51:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/32] xfs_scrub: don't merge over unused space when data
 checksums are enabled
Message-ID: <20260925235146.GQ2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-33-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-33-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:22PM +0200, Christoph Hellwig wrote:
> Unused space could be lost space at mount time for which no metadata was
> recorded, and we thus might not have valid checksums for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Pretty straightforward!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  scrub/read_verify.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/scrub/read_verify.c b/scrub/read_verify.c
> index 311ea1c29008..0c3bec104d16 100644
> --- a/scrub/read_verify.c
> +++ b/scrub/read_verify.c
> @@ -542,20 +542,33 @@ try_read_verify_schedule_io(
>  
>  	/*
>  	 * If we have a stashed IO, we haven't changed pools, the error
> -	 * reporting is the same, and the two extents are close,
> -	 * we can combine them.
> +	 * reporting is the same, and the two extents are close, we can combine
> +	 * them.
> +	 *
> +	 * If the file system has data checksums enabled, only merge fully
> +	 * contigous ranges, as unused data might have invalid checksums.
>  	 */
> -	if (rs->rvp == rvp && rs->io_length > 0 &&
> -	    ((start >= rs->io_start && start <= rv_end + locality) ||
> -	     (rs->io_start >= start &&
> -	      rs->io_start <= req_end + locality))) {
> -		rs->io_start = min(rs->io_start, start);
> -		rs->io_length = max(req_end, rv_end) - rs->io_start;
> -
> -		return true;
> +	if (rs->rvp != rvp || !rs->io_length)
> +		return false;
> +
> +	if (rvp->ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_DATA_CSUM) {
> +		if (start == rv_end)
> +			goto merge;
> +		if (rs->io_start == req_end)
> +			goto merge;
> +	} else {
> +		if (start >= rs->io_start && start <= rv_end + locality)
> +			goto merge;
> +		if (rs->io_start >= start && rs->io_start <= req_end + locality)
> +			goto merge;
>  	}
>  
>  	return false;
> +
> +merge:
> +	rs->io_start = min(rs->io_start, start);
> +	rs->io_length = max(req_end, rv_end) - rs->io_start;
> +	return true;
>  }
>  
>  /* Did read verification succeed? */
> -- 
> 2.53.0
> 
> 
