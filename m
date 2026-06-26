Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF4279329
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 05:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450230; cv=none; b=fvxAJExt+MXSOXE6JoI166XzOj6Rf4Zi1lc68zBjtaf+EbZTB6TLHj83hQrMKFCGsbWIrqmPzYnIcaSd9Ou+N25P4PukB/gF8uSeXY3oNN3C7XFvvxQrUxQ7rTUyvDa73wL9/WyFX/Io/IAhQMU6zCrzTxDksePiAD3HgEXZv6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450230; c=relaxed/simple;
	bh=38kKSu60/4uFbCm/0/o+G5jbCG9N4lZBKuynOU4FBdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCXBKSuo2yP0NTDRUb2jEtWNCsp0XsRUWdxAVQyuy7kL3vnaI7KGblQiKhok7AdQWMog+9spMhxX6OhuO9MsrO/s4RFi4uJ/+aTgm3Hr7YeSCWB8jxlWHoP9PweUgcipHhQznzFnIa+KntPyK1AoaHQ52YNT8e53SFAXe1oaWPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C562A68B05; Fri, 26 Jun 2026 07:03:45 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:03:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/8] xfs_scrub: fix spacemap external log device scan
 dev key
Message-ID: <20260626050345.GD8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801378.1981574.12871573702305819173.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801378.1981574.12871573702305819173.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:55:15PM -0700, Darrick J. Wong wrote:
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -213,7 +213,7 @@ scan_rt_rmaps(
>  	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
>  }
>  
> -/* Iterate all the reverse mappings of the log device. */
> +/* Iterate all the reverse mappings of the external log device. */
>  static void
>  scan_log_rmaps(
>  	struct workqueue	*wq,
> @@ -222,7 +222,12 @@ scan_log_rmaps(
>  {
>  	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
>  
> -	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? 2 : ctx->fsinfo.fs_logdev,
> +	/*
> +	 * Internal rt sections (rtstart != 0) means we use synthetic device
> +	 * keys for external devices.
> +	 */
> +	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? XFS_DEV_LOG :
> +						      ctx->fsinfo.fs_logdev,

Maybe this should be using to_fsmap_dev instead?  Move the call
to to_fsmap_dev into scan_dev_rmaps for further simplification.

scan_rt_rmaps seems to have similar issues.

