Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA656F06B
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727446165; cv=none; b=kQ4jaQd46Y+NRhganwoBwlPYKpTXGeFfSnQBVo415hHdAMBasCOwoCC4NLLL8Gbm5XgJwP87WVxBvoEHi2Psw/1rqE6objpe2i5srZpZxmFPsuWGTm6EqvGWzC0pGiZoI3/M8oATL49VY8+kUF7NiE+vxnZ//wvbLD+gcyoJFSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727446165; c=relaxed/simple;
	bh=J6bLG3d+iy/Z28EMkfUv9Yg/QJ3p69k56lyaLUuQm58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxM0eu+QZJtXlqL6fpYx6CZ2RV6AGrsW7uyjtS/9VLdhhqby0qJSVOma/msMZxVvKgRwUjc3G0DyEqpY7ypeNsnQaBTrh3b+TmvUq7lCPMtXV3syAdLdeci1S6HSCzMwO4GNsaHPdKjGtBrzvDSLLShf6gk1o4Nhl0ql8bmfhi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kD945rF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kD945rF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC1AC4CEC4;
	Fri, 27 Sep 2024 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727446164;
	bh=J6bLG3d+iy/Z28EMkfUv9Yg/QJ3p69k56lyaLUuQm58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kD945rF/Hqni2DoSPhZDBchOdaY5LjB0p1lFerS8MSrFuVDb4wXIYOw1Rog/HNEgW
	 ZUwqqU80Gs9irI+5I6Ab/fai8TUsARZzPNsPfHzTZFa7aKqxpwcaBOuo/1B+9QP/2B
	 yzPJNShWiaC9fV7xj0YTH2gDFN7LhmabNvZP7mKHDiEq+yvJ1d9ybFDxABdUMvoq9Z
	 4mFocCGvWuUWxMXJHT5vfMVxFjpXdAU2Dzn5boEGeOfnQYtEu8amgpiyo9NqyW6mbr
	 /2EhRxCQFsVbfTltP0Xx0ozGx4jgLco1kfS+V1ON4DJ6fUMIk8nwSObaBZoPne2paV
	 52pWvK8krv08g==
Date: Fri, 27 Sep 2024 16:09:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 2/2] xfsprogs: update gitignore
Message-ID: <65wlm36uziggutarpnmmy3uxbnrwdrv6bf3co54gjipbwxp2ej@r2sbabrc5m23>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927134142.200642-4-aalbersh@redhat.com>

On Fri, Sep 27, 2024 at 03:41:43PM GMT, Andrey Albershteyn wrote:
> Building xfsprogs seems to produce many build artifacts which are
> not tracked by git. Ignore them.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  .gitignore | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index fd131b6fde52..26a7339add42 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -33,6 +33,7 @@
>  /config.status
>  /config.sub
>  /configure
> +/configure~

This smells like your vim configuration, not the make system.

Carlos

>  
>  # libtool
>  /libtool
> @@ -73,9 +74,20 @@ cscope.*
>  /scrub/xfs_scrub_all
>  /scrub/xfs_scrub_all.cron
>  /scrub/xfs_scrub_all.service
> +/scrub/xfs_scrub_all_fail.service
> +/scrub/xfs_scrub_fail
>  /scrub/xfs_scrub_fail@.service
> +/scrub/xfs_scrub_media@.service
> +/scrub/xfs_scrub_media_fail@.service
>  
>  # generated crc files
> +/libxfs/crc32selftest
> +/libxfs/crc32table.h
> +/libxfs/gen_crc32table
>  /libfrog/crc32selftest
>  /libfrog/crc32table.h
>  /libfrog/gen_crc32table
> +
> +# docs
> +/man/man8/mkfs.xfs.8
> +/man/man8/xfs_scrub_all.8
> -- 
> 2.44.1
> 
> 
