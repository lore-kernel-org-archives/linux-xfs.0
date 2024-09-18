Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7A61607A4
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 19:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726688503; cv=none; b=RG4XImNL+1jOcVn5IgS4Ha+UZ4bCMAttnCAOBqdb7b1DTLeNmpaPTTUXOGbSr4zbGDM7n6NrhYSy4sHtk6sLVlyfvGHzzFXC/iS++l9Tl0xzyX9ZPKln6Y8fUMcAGTjccVs961SeyFtiy6lpArJmuUzF9dHNzmZU+dUyCT4jK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726688503; c=relaxed/simple;
	bh=W4m8BSsoMljeSRo9jiObwa60ZgJfzIaTPPp8kx9hoxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqqmVRRcQF/bQYQrW9PIIZPMp+tWAgQK6g2PwfkZpumiPUGj4UlJquQW62ovUmY1h3FsL0nbmyQ92ggMkICEr4qfv6ntbhiPT0o4/cgbzjuq8waiBQnrwAEVbEkc/GhOrCws4T4q62o8ATAmdVxOngaCqJQk/IEnQDXjm2w8FzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyXdxucO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyXdxucO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2D5C4CEC2;
	Wed, 18 Sep 2024 19:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726688502;
	bh=W4m8BSsoMljeSRo9jiObwa60ZgJfzIaTPPp8kx9hoxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kyXdxucOZc5fUQ5XiDczAPS/eS64O76iVyCAzn44+0dNOR3AZm7rzDVjnNlhrjmL9
	 xM8Z33tM56NSh7RS64O1TWcRkOsqhXliL+A8CczcBdVbU9vC82QuzdfsOPpAt4K/4D
	 /gO69XSGlJG5y/bdJOHN1dkuNKacdLmh2BfaGEH7wMVkIaFqWVIATJqJMsd87D48Bm
	 kSvvTBeSaRTwEmu4vQIKQTFqdnLy9OGUc70DJMcXLPdjjwiRaXWO749/EQcrRkiVx2
	 MdI8xJzGHtWirFjpvPaNrc/wwClBjuQRImrPgewsaCtg5fIKN6mgf3kCfxpDDBJC7A
	 23CFHRT62HsIg==
Date: Wed, 18 Sep 2024 12:41:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/6] debian: Add Build-Depends on pkg with systemd.pc
Message-ID: <20240918194141.GO182194@frogsfrogsfrogs>
References: <20240918143640.29981-1-bage@debian.org>
 <20240918143640.29981-5-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918143640.29981-5-bage@debian.org>

On Wed, Sep 18, 2024 at 04:36:16PM +0200, Bastian Germann wrote:
> The detection for the systemd unit installation searches for systemd.pc.
> This file was moved after the bookworm release, so we depend on two
> alternative packages.
> 
> Fixes: 45cc055588 ("debian: enable xfs_scrub_all systemd timer services by default")
> Signed-off-by: Bastian Germann <bage@debian.org>

Thanks for modifying this! :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 369d11a4..3f05d4e3 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
> -Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
> +Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
> -- 
> 2.45.2
> 
> 
