Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378A132B13F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138434; cv=none; b=o7VLDsOpEJKwfr1e/eS4ZZx3DlmHth4viMDOv9Ta0Wcg3vE4jNhSDlcrBStvWpD3qHbgMT0xL0yYUrv1zpYnrMluzSRMv47k4FIKDMGuyxiAqCn9s4NB5tuG3VCAvrxxgzFxmUdw/HMjqvqNawGPZ0Az5YXjpsYclzX/YJxPgkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138434; c=relaxed/simple;
	bh=yPe2INlMf23O16RxHu4/zRTfaQFiKb089aNVYemTCRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIwQ4c0/nSlWHIYocr4+Q2ekVx0cP/vAwCi8YNwA7RsSnAts33N98caQ3nPUuC2a2JgUCBWIwGHRPFNeAzzk7mc54+G2Bff+iXqMsefeNI4+G5PbEzsYTQ8W9pJddl+K6z2b/FMk3/xKL5qGG4LVcKBTY3UJ3TZCbbyp7R6Y7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEr96t1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEr96t1N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CC37B1F000FF;
	Fri, 11 Sep 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138432;
	bh=7jkxwSksAET19WY7ptx3YxYwtLw2idtT8ymcTNcJK5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HEr96t1NdldSt6Wu+HNEXeMGcooRp/g42W+5MUCDkxcAe4tuML2g25lJ44JqJn3Af
	 EkkM8BUJNTVt4jmiebbiU8EJFJUzpJhrz1iJUn9GudW52/NEnNdfPUeT7Yh2wXlPcy
	 8/eyuTibPJYcSi/DrrbJ4TycyI6FFNbLDRyiJTLy7M5LWz9hjb/cuaV3dIdh/DbJn+
	 xb2HCfVoW4sKe3/KQqK+Yez/FDq5QiJTB0Hz9uynF6zZMtVc8V5FNYnVJIMO2aJK6x
	 O7FbZgzJLr4kx4oBAppm7bxoKGNgJAp33lzJqGpqvTvEn1BptDd02Dy2DrjJQliG4/
	 jA8Zs7cMbjZIQ==
Date: Fri, 11 Sep 2026 07:53:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libxfs: better describe why m_ddev_targp can be set
 in libxfs_buftarg_init
Message-ID: <20260911145352.GD6265@frogsfrogsfrogs>
References: <20260911144559.1959740-1-hch@lst.de>
 <20260911144559.1959740-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911144559.1959740-3-hch@lst.de>

On Fri, Sep 11, 2026 at 04:45:43PM +0200, Christoph Hellwig wrote:
> I had to wade through this to understand what is going on here, so dump
> the thoughts in a comment to make it easier for the next person to
> understand the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/init.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 2a46ddf086ed..a47e610934e9 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -534,7 +534,12 @@ libxfs_buftarg_init(
>  	}
>  
>  	if (mp->m_ddev_targp) {
> -		/* should already have all buftargs initialised */
> +		/*
> +		 * This can happen if the utility called libxfs_buftarg_init
> +		 * manually before libxfs_mount, which calls us again.

That's much clearer about how we get into this state. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		 *
> +		 * In this case all buftargs should be initialized already.
> +		 */
>  		if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
>  		    mp->m_ddev_targp->bt_mount != mp) {
>  			fprintf(stderr,
> -- 
> 2.53.0
> 
> 
