Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D06143748
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227347; cv=none; b=FoQjHOBZuB/7qIPbABtvclJ7SH0/VF1eoaQ8D8ThcR6a4vlaRydEGjXww+0iLL5ceEwNsGk7pHwkeTSCnq9xCHCaHIAF6JkSmq55NbCUbKftm4B3zYNfZIkvL/Be/Hk0kf/eB7eyhq4s0GlBeSdfvkU2iYEmWFW7vtcoes/JOJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227347; c=relaxed/simple;
	bh=zfFB/5PzGkBDj9ZmXVNyi5r49h0Ez/sTcArhBaXp5MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLP47bDTgzUWFxGUrxR1kcy1uzgUqZYP22irUHn0OsPbgEG1ns8TQU7V2RWis01MW903NYPrt3e8oTpdi1Y0QmwcQGM7x8QY8w5saXO+sgkesxPEAReophRsG0VkUa9+Q3KLN3IxuFdQKEYSLygw/xDcPqxrFsgwFGt9S0US87s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6UYPVts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6UYPVts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167BFC4CEE2;
	Wed,  9 Apr 2025 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744227347;
	bh=zfFB/5PzGkBDj9ZmXVNyi5r49h0Ez/sTcArhBaXp5MM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6UYPVts0uKvpgO5U7ZzshU5WjagvsDtwkC59JlfbqDl8M6KHebQb7HWq1PX83O01
	 IZlM5iAjVR9wFvgZ91GuvgRey6zC2ZTATCP0bR1m7VBkLh7WxMF1AEDwM3HpE2cAwq
	 bAwxBCSEOvAphhLnTgmT+60B+E0p0yLmZH0EagoXLzyAd6JKxITmUPTPpK7kBQxozs
	 dXisD6FMR9x51EsqUjMuYLpEaKPmv45x+Kc9K9BFaUCTgKlyCGIQwF9PoJqyO/TvLp
	 ZCow8k+ZE1jDzZ9BiMvfVerjWDEHB0r/EX1rKqGC1HwPEkDvWlQInro1Lv9byT72tN
	 iCjUA5J7Ma7OA==
Date: Wed, 9 Apr 2025 12:35:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 45/45] xfs_growfs: support internal RT devices
Message-ID: <20250409193546.GP6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-46-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-46-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:48AM +0200, Christoph Hellwig wrote:
> Allow RT growfs when rtstart is set in the geomety, and adjust the
> queried size for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  growfs/xfs_growfs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 4b941403e2fd..0d0b2ae3e739 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -202,7 +202,7 @@ main(int argc, char **argv)
>  			progname, fname);
>  		exit(1);
>  	}
> -	if (rflag && !xi.rt.dev) {
> +	if (rflag && (!xi.rt.dev && !geo.rtstart)) {
>  		fprintf(stderr,
>  			_("%s: failed to access realtime device for %s\n"),
>  			progname, fname);
> @@ -211,6 +211,13 @@ main(int argc, char **argv)
>  
>  	xfs_report_geom(&geo, datadev, logdev, rtdev);
>  
> +	if (geo.rtstart) {
> +		xfs_daddr_t rtstart = geo.rtstart * (geo.blocksize / BBSIZE);
> +
> +		xi.rt.size = xi.data.size - rtstart;
> +		xi.data.size = rtstart;
> +	}
> +
>  	ddsize = xi.data.size;
>  	dlsize = (xi.log.size ? xi.log.size :
>  			geo.logblocks * (geo.blocksize / BBSIZE) );
> -- 
> 2.47.2
> 
> 
