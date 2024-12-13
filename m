Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0021946AA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130196; cv=none; b=HpY9L9jgX+AKdGGwGHeJ83BJCniBxpFsmB2TbtfrSvu3d8rvsvNxMhLcHHWO8dQXgKTX0OWi0KzBbndUz5jAr0mQtSpOquZhzAdzSF7ICvGJJQJgKO+JXhcu99CWaVhJ9i/xjRn124a+lfedqKw+eBuB/xnx9a2vw7fXGiYc0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130196; c=relaxed/simple;
	bh=ThuH3KrIGP7q6pOpRuVkyvjBjkuhtuN/tgA92GE6/ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7U2L1eGIj6FEtS6r70P24j9qsbzmBDJIMOJYjYiVTANfLt6YsoxQV57MlHRt3rqCtnKTrNdnB/eZblIhV/qHaE+HFY61mhrK6dO+8i1C5uHq02ZmlzSBIwfKCFBzt6vVbaUihOLY8D3z6bF1ErQyOdJbA4B4jKHbmZfHZw6VNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQR+/umP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQR+/umP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2015DC4CED4;
	Fri, 13 Dec 2024 22:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130196;
	bh=ThuH3KrIGP7q6pOpRuVkyvjBjkuhtuN/tgA92GE6/ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQR+/umPc4mXtupar1hDz3vR+VFj9yp0Q519LYfquB/zQJ9FWLJ7zOSWwQM5I06iM
	 8xSTtIFdJPCEVFzWytUIjiDYaSoLAXb1C048EY86GrqQk4ro5apQhoH/79619XNteQ
	 TNz0AQW7p7juLGL5WcG2I8DY36r/Gr26uZm97LYNzfWQpGWEDXYDbK0DwgSe5NIVZF
	 OXy6vy4Mn95+il2jxYJY/7+u66yQCLZN5a2JcUrS4I8OyVk0WDWnZmNVNGA6cFmVTm
	 QDRJ+bj4LlGwN3tOOa/Z8++UKbk+1bhDTn7DoxINzPgOT8kRc7MRwqOyHNd5eVh7s8
	 vhxKLLsJUV96Q==
Date: Fri, 13 Dec 2024 14:49:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/43] xfs: support xrep_require_rtext_inuse on zoned
 file systems
Message-ID: <20241213224955.GX6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-35-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-35-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:59AM +0100, Christoph Hellwig wrote:
> Space usage is tracked by the rmap, which already is separately
> cross-reference.  But on top of that we have the write pointer and can
> do a basic sanity check here that the block is not beyond the write
> pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/repair.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 90740718ac70..dd88a237d629 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -43,6 +43,7 @@
>  #include "xfs_rtalloc.h"
>  #include "xfs_metafile.h"
>  #include "xfs_rtrefcount_btree.h"
> +#include "xfs_zone_alloc.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> @@ -1048,7 +1049,13 @@ xrep_require_rtext_inuse(
>  	xfs_rtxnum_t		startrtx;
>  	xfs_rtxnum_t		endrtx;
>  	bool			is_free = false;
> -	int			error;
> +	int			error = 0;
> +
> +	if (xfs_has_zoned(mp)) {
> +		if (!xfs_zone_rgbno_is_valid(sc->sr.rtg, rgbno + len - 1))
> +			return -EFSCORRUPTED;
> +		return 0;
> +	}
>  
>  	startrtx = xfs_rgbno_to_rtx(mp, rgbno);
>  	endrtx = xfs_rgbno_to_rtx(mp, rgbno + len - 1);
> -- 
> 2.45.2
> 
> 
