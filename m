Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBD92EEE85
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138648; cv=none; b=CQFLAnnd2317Ein2NbCDYwk4OxIi8cUed1Px+zi6vnQsrWKCfOUHYy51FSA2E2pHxejiyf1o2qDIzxpBta0chIbysTk7FqqWxExwi0wREbDrYRr055ZHjXsXfPZGXRPflgnPOn14q6wOc9U1C0uX5SWBSVJXMNl65wZ2muNq+wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138648; c=relaxed/simple;
	bh=+aLY/l4+MANWHfIVeG/wrFmE2ctIKDRsBMVKNDrRNF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjIY7+92Jp0zH9tHLvhwOPxu3H27c0Xp3RSMSjBwCWnlX5HofUon4DJzMvxKibFhd0KnwGZP3cup9A9+Z0Fd2ciPzZW8sHZsztcR8g7ZlA4aF2HIYkMNHOkf2Oqnxk4kT0uyag+GC2QrraLWYYZZqf3vJWXpbpixsAhBRoXBfuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noKhl4l2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noKhl4l2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 86C7E1F000FF;
	Fri, 11 Sep 2026 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138646;
	bh=9Um5p6tDk98zPdRBQJ3o25r3JKvtYoeVGE1SYZjFNPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=noKhl4l2rnQCZrl0iZkFvTIWLHCkFnoX1GpomCwa8QE9j2Lzu7/Nf/9G7GBQ2SlKD
	 VGhSsPfgWElQb8hLxga1QJxqKATrpIdMVxC5nDL0/iRv6ym2EY903fPYRWtwy8Nr9D
	 hNI6Sqb3W1NBZz9AHRl9Q8tnkxQF/T6Ull0FuNAkNv64jGbzzM4yd++qtL7U6179gC
	 0CbsbrYDa59L/EBKWElE3Z96eOwU/3vvwHiNGqLFaxWWJ2//e+3SA9ZL7g4axw6VKw
	 o0X0ekKAHiqPq1Ogd1YZwWG/FCoAG0QPwvpUCSjEg6w48fL41DTMXoeymbFGTYvKBO
	 l6DFk39Vla8VA==
Date: Fri, 11 Sep 2026 07:57:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: don't set mp->m_rtdev_targp when no RT
 devices is provided
Message-ID: <20260911145726.GE6265@frogsfrogsfrogs>
References: <20260911144559.1959740-1-hch@lst.de>
 <20260911144559.1959740-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911144559.1959740-2-hch@lst.de>

On Fri, Sep 11, 2026 at 04:45:42PM +0200, Christoph Hellwig wrote:
> The user-space only parts of commit 9840f7e09e2f ("xfs: allow internal
> RT devices for zoned mode") accidentally set m_rtdev_targp to
> m_ddev_targp when not name is set for the RT device, and thus disable
> the check for a non-NULL m_rtdev_targp in rtmount_init.
> 
> This lead to tools working without specifying a RT device when they
> should abort.  For example this can lead to repair trying to read
> and rewrite the rtsb when called without -rc, which will then fail
> in weird ways.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 5d8b4a153e28..2a46ddf086ed 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -573,7 +573,7 @@ libxfs_buftarg_init(
>  	else
>  		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
>  				lfail);
> -	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
> +	if (xi->rt.dev == xi->data.dev)
>  		mp->m_rtdev_targp = mp->m_ddev_targp;
>  	else
>  		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,

Does this mean that m_rtdev_targp is never NULL, even when we don't
specify or have a rt device attached?  I would have expected this to be:

	if (!xi->rt.dev)
		mp->m_rtdev_targp = NULL;
	else if (xi->rt.dev == xi->data.dev)
		mp->m_rtdev_targp = mp->m_ddev_targp;
	else
		mp->m_rtdev_targp = libxfs_buftarg_alloc(...);

--D

> -- 
> 2.53.0
> 
> 
