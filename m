Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA9318CC15
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227050; cv=none; b=M7c6Lpug/yYnzmWHRdx+L/a2DS8uLEQXmeWruQ4o8k+pt0k4bWyoP2OlBNh6JZJyHbWEJJ67x8bCPrxLwm1Ssnzd2nicJN/YKJxVFx9wvs2VxDOjADVemBlSp4W3aB0+rMdfAGLVM0rvUClYEi4GrHEQHsova7mjBoP4/AS6F34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227050; c=relaxed/simple;
	bh=UtvvRRTD6cjkuq12eKg63apWZ5NbbVYc5r/Xxlth2kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQrcs6W8JdVbZX7LAyxYjc/1C842tBYxZpdkFC9mrlR6WnsheBGKKBNuaytClwN3dWl+OLJAubuNfA5Y7ebBzliu3eKE5XgTN9VV6rNJ8XComAIj1OcOvvI/2VjpJA050fRCfP4ZJsanadu4eK6MGsZK53AXYRuq72VgrHDH2Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEsQp5AQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEsQp5AQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15DEC4CEE2;
	Wed,  9 Apr 2025 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744227050;
	bh=UtvvRRTD6cjkuq12eKg63apWZ5NbbVYc5r/Xxlth2kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEsQp5AQsUzhE7+YlYm7Xvsag35bgnfbsW1jRs8Tr1cLYGQR1tXrLPZLPLISbM6oR
	 4DQGDCRphSSD471WQn5gLz0K9YEfqU+Yr615DokKULmvXHMREONXUBeAFh6qZG5HiV
	 8ef3bxJPdibdxT+HTnXfgBmS1SeNgagglP78t2llLm9Br9cT0yjwbbtBCtPnHuy/x8
	 dNdq8ve/Ri1EvYtrBZ4KsqnXtibW9GLG4lMkbbm8PJ1u+icu9VjMMvcmtUzMssZnC6
	 rn43I8zHWSG61bsAnHaNa6VqjIctGiFB+dQhFo6WcLYGh7UXpjnnwjnR7m60kgth3M
	 wpoKlmY5Rx+0g==
Date: Wed, 9 Apr 2025 12:30:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/45] xfs_scrub: support internal RT sections
Message-ID: <20250409193049.GN6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-43-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-43-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:45AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  scrub/phase1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index d03a9099a217..e71cab7b7d90 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -341,7 +341,8 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
>  _("Unable to find log device path."));
>  		return ECANCELED;
>  	}
> -	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
> +	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL &&
> +	    !(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ZONED)) {

Shouldn't this be gated on ctx->mnt.fsgeom.rtstart == 0 instead of
!ZONED?  I think we still want to be able to do media scans of zoned
external rt devices.

--D

>  		str_error(ctx, ctx->mntpoint,
>  _("Unable to find realtime device path."));
>  		return ECANCELED;
> -- 
> 2.47.2
> 
> 
