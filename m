Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE24916F8F5;
	Tue, 26 Nov 2024 12:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732623978; cv=none; b=BzWBbXtTVA3i+OH5U80/XR8K7f/djze8QeByEVFPrrao4Y1OWSs5IaHxZ8hThWl/72EwA168htN2K9qhvH0ArKhTkBnxsl6nP1ZASAW+dsgPlCbjTZrANfn6NZiLnu/IGCgCbabJw662lGjkszN0MwEfTfjwFOtDUAzyctRThR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732623978; c=relaxed/simple;
	bh=juROCnqnnvcJF/NO+u0LGmc7W4KPbLX3deCwkBAj++8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxTRnAcjgD6eXXMqi86b/Ozpoxl9SnMYBzGMARZz5aHQlVf8UzR2JHvbd3GAQAU/Ck3RbsOxu90o/J2uBzyMXjTLXxCWLs0RTGQLI/8bl30cUoqQYrvLicBlwnKfi7gRkUynD54nw7SEsbMuoTvKya/QE9rrCa40Ny/OSmCfF3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ui0hC4IZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ui0hC4IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F809C4CECF;
	Tue, 26 Nov 2024 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732623977;
	bh=juROCnqnnvcJF/NO+u0LGmc7W4KPbLX3deCwkBAj++8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ui0hC4IZvmgi5qLfNbI//Wg4TUyRjvvlOcoBAUH8Mvz1wpR11lhuFH4m6z34Fk8vG
	 jiDvjD3xSSmJrq4qp/Dh5AEHJnj4duR3uBM2pBgJE95awovGKhdn0pqQJK9pSSXdqd
	 c7V9cS0LDkRShcuMXuybhWgiVLYH8be+8b/v7MiWr4Yuf/F6DBuCQ+cKKyFzyG5wNA
	 7Z4/oNKf4hYojxwV5fPNut4jNQnOtuuUHYZkj4VJnT0P9DI0WSuolmePqta38lpGHc
	 PzI1iPf5NHq6s56R3maa3/T/M6dkMjDhbPEf0hMXgij+3W/3oR/pXqNzUkvwQxyvng
	 oeUzSUJ4Z8ajQ==
Date: Tue, 26 Nov 2024 13:26:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6.12] MAINTAINERS: appoint myself the XFS maintainer for
 6.12 LTS
Message-ID: <pzbcspuevok7ljq4asry5xevj46kb6dy4in77hdzjm77okdjwp@yfs462ee5fdg>
References: <20241123013828.GA620578@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123013828.GA620578@frogsfrogsfrogs>

On Fri, Nov 22, 2024 at 05:38:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I'm appointing myself to be responsible for getting after people to
> submit their upstream bug fixes with the appropriate Fixes tags and to
> cc stable; to find whatever slips through the cracks; and to keep an eye
> on the automatic QA of all that stuff.
> 
> Cc: <stable@vger.kernel.org> # v6.12
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  MAINTAINERS |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b878ddc99f94e7..23d89f2a3008e2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25358,8 +25358,7 @@ F:	include/xen/arm/swiotlb-xen.h
>  F:	include/xen/swiotlb-xen.h
>  
>  XFS FILESYSTEM
> -M:	Carlos Maiolino <cem@kernel.org>
> -R:	Darrick J. Wong <djwong@kernel.org>
> +M:	Darrick J. Wong <djwong@kernel.org>
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
>  W:	http://xfs.org/
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
