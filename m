Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80C64FB9C4
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376162; cv=none; b=NniHKXa/GRi/3qBw9R1vW7O4fn0GijKzz9t5GFK/Ur+aN7Kuw4RiN07q3ea9mjnabF/H/LCKG7XqO7Mk0Es18gmYCkYf9ssfoURfJFMdPkvGPgu8aiErDQDvk7NAbzOxKA5dQwQcMNQxHsya0zggcRj3ABE3/7ll2KnR2pQk/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376162; c=relaxed/simple;
	bh=C1sC7mmJ/kndqOnT5Kc4fJ0cjomd9exQgziQRBGf8Qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5NVgmrhrZbKlbZEAHjOcDTlFNg5+onPrLgwx4qG+5jQxv+8My1dxbUoF92kSqJsvqA+ZxZI/phZ+b7D9geT/u79zyRJCxHuxfZlnM6/kqau+hGMgCMN9ZE3/PTrXgemHMWkwe1L7gSdDG3JoPgBeex3w63L8I+m3F3P/plNF+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WemHV0bM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WemHV0bM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8339E1F000FF;
	Fri, 25 Sep 2026 22:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376158;
	bh=EuenrW+Tzd8JEl1J5t6gSscYCvisVo2PzIo+TBbpKq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WemHV0bMzeJI7g9KQ7ItKbwg0K0zEwyAfgDTIConnPShhqcNGlChosj6hVtBI2e+I
	 LcLBmBXrU0+S5fIj2r4S6QhZBc0aOPlS87vp6C1HMBP8Ljez/porhpcq43v2gryJCN
	 f2Z+6laPPOmz6I/lS/eX6mxFOZiVGWnGa+3HyVxttCdt8U8Fpph3bkmxqJnKEK76n4
	 NNt6bDC2yCIrI2l11pLIRNb7K4ykraFrxwtnfdfbDjbxWgjMgdsASCyIMKpBUG2+bK
	 ZsigolkV164F2d9G5etvLXO7XRo/d1p0RQw+bFm3s0iBHsSV8ziTHLkP7AuLmQcqxX
	 eHsKRwe7QNGUw==
Date: Fri, 25 Sep 2026 15:42:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] libxfs: fix buftarg initialization for the RT
 device
Message-ID: <20260925224238.GV2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260925051336.2997014-8-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:53AM +0200, Christoph Hellwig wrote:
> libxfs_buftarg_init currently sets the rtdev targp to the ddev one when
> no explicit RT device is provided, which allows tools like repair to
> proceed without a specified RT device when they should not, and
> potentially can cause data corruption.
> 
> Fix this by delaying the RT buftarg initialization to libxfs_mount,
> where we can check if the superblock indicates an internal RT device.
> This works because all external callers of libxfs_buftarg_init never
> need the RT device as they just examine the sb and/or log,
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

😬😬😬
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 842a2e1e09a9..97c5286c00a9 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -554,8 +554,7 @@ libxfs_buftarg_reinit(
>  	}
>  
>  	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> -		if ((xi->rt.dev && xi->rt.dev == xi->data.dev) ||
> -		    mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> +		if (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
>  		    mp->m_rtdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, rtdev\n"),
> @@ -587,10 +586,6 @@ libxfs_buftarg_init(
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	else
>  		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log);
> -	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
> -		mp->m_rtdev_targp = mp->m_ddev_targp;
> -	else
> -		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
>  }
>  
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> @@ -739,6 +734,10 @@ libxfs_mount(
>  	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
>  		xfs_set_reporting_corruption(mp);
>  	libxfs_buftarg_init(mp, xi);
> +	if (sb->sb_rtstart)
> +		mp->m_rtdev_targp = mp->m_ddev_targp;
> +	else if (xi->rt.dev)
> +		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
>  	libxfs_setup_write_error_injection(mp);
>  
>  	if (xi->data.name)
> -- 
> 2.53.0
> 
> 
