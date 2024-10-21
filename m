Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57483EEB3
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729523666; cv=none; b=auFqG9ZSeqKTGDCS7CdxGwVu2KGsTsnDpHGHhwOMeekAYJ/cVCWDrFbbAhUw/UYJuQHD3MlIgrXfJdxp3ZHxfGr7F9cqdtzOJ8uJvJB4ya1Pc9Y0//qzh3ZwKQvLafv7120Nty0HqH0oXfPNu8IVZEBVe6ax3Yr4ig1ufdNZe08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729523666; c=relaxed/simple;
	bh=Oan4SNZo+aCJnEResXEJCTH+lk1jSDGHWfjPVYMr9ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9f2Y5MFiWVOiUTMqbWyS7y0uFl/1XKCYFBN7ayvpg82q3R7aIGCSl92HUbI9miaxK7EgZl/YjvaKZBh+3qYFd2QLbu/vp8k2faySJHHMuRGXOdz89bolVB9y6dYadrtOjf4SpYItKU4lojwWET33lueeqRMV/8H3lRfRzq9kog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgUYYvo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgUYYvo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6981C4CEC3;
	Mon, 21 Oct 2024 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729523666;
	bh=Oan4SNZo+aCJnEResXEJCTH+lk1jSDGHWfjPVYMr9ro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NgUYYvo7vbsIcVgpz1ZOACmrMaif0Cc6XvSpHTZSnepcJPYDdGkowCJWTdV+ezLqR
	 aJxyxs8piFkjsGvytAfNgbQ72BuOuSbuwj2LYA/HGR0pmh8ji7V8ywHn5tf2uVHjId
	 OwXm0S2o8I1Y3X+frdqClFdIALt7cxgZVC9XFvpLkU7JboKshjHpzuHWm7CjcGU1E8
	 0pm8hstrnYTYmzv+LT+B7dCpBwOkQ9/MczWPVKI3RRo+yCOyz2h2JKte2ueCjPHFHR
	 qRBidJGuTzzPnXa9ABrK71bt9zzuygHj8m52t464myeWGsZV921VZTqSF6dPwhneuQ
	 g3vPVKJ4lD/og==
Date: Mon, 21 Oct 2024 08:14:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Palus <jpalus@fastmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_spaceman: add dependency on libhandle target
Message-ID: <20241021151425.GZ21853@frogsfrogsfrogs>
References: <20241019182320.2164208-1-jpalus@fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241019182320.2164208-1-jpalus@fastmail.com>

On Sat, Oct 19, 2024 at 08:23:19PM +0200, Jan Palus wrote:
> Fixes: 764d8cb8 ("xfs_spaceman: report file paths")
> Signed-off-by: Jan Palus <jpalus@fastmail.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index c40728d9..c73aa391 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -97,7 +97,7 @@ quota: libxcmd
>  repair: libxlog libxcmd
>  copy: libxlog
>  mkfs: libxcmd
> -spaceman: libxcmd
> +spaceman: libxcmd libhandle
>  scrub: libhandle libxcmd
>  rtcp: libfrog
>  
> -- 
> 2.47.0
> 
> 
