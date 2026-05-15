Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F0403149
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 17:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778866385; cv=none; b=hMKbRNyVyocOhgNwz+XYglu3/iezh1Ls7AC6jNrNjKbsaTcxcJfp0V3wxY0wV2qKmUv1yxVKhioUbucEaf3Aa0bbwW3OeqAVVqFn2yqeLUOuVOdtaQKJP8aFn04bQNGW7iPerMW5PVHmx42B0CKCUmkIxRCetm9KYQX3jEasQPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778866385; c=relaxed/simple;
	bh=RObeO/wPdTxkWQ4+0o0ujAtNpChBuEKYCMTvVrpJ7Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElhT5EPthkeSP2iv7qPWvOiiJNwMOuDOf/F5jIIAa5FkmPn0yTPR3FD6d7hW/kV38WWaI0kF6YO3BGoyD8ap2+5ySfdaRUViEDZxd7UEocJvzcPnpic0sH5/XlXi7Mn3fTClBzqgo9X9SnRnxc/LGWCL0AoyrHbmV2oXDGkgjO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4P2ShzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4P2ShzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5125BC2BCC7;
	Fri, 15 May 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778866385;
	bh=RObeO/wPdTxkWQ4+0o0ujAtNpChBuEKYCMTvVrpJ7Dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4P2ShzMiY6FsqnPomYf6xpgJx9Fp5H9CGQvg5vsqRIip/MS/nVX+ofpB+Y3KSIqH
	 dcMGkz/Vq9bR4kM10XuuujlG9gFQRJGUXWca1cwkxP7HAVOCK68UijLgS0vCBW0rhU
	 2ZZvKtWEjz8zVGUFklr5d7lQ/jzjpnIihe9buas9xmDRqvssmX9Q7uRTHJxKZ9Yjbr
	 CrzZ9aaAAFZT31UaRKboH3SXQe1E8a4vRA/VhfxCMx2uDDBn9Kis/LuTSe74ysJ7uU
	 ztCL+FoPxQrmpezEvJPlVgptvx6KVZvWhzfB3UM3eC8YP2QC7yzR5WTgZgcClhzS/6
	 mOfzRq7QYJY+A==
Date: Fri, 15 May 2026 10:33:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ailiop@suse.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: add missing HAVE_LISTMOUNT flag
Message-ID: <20260515173304.GD9555@frogsfrogsfrogs>
References: <20260515102357.90358-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515102357.90358-1-aalbersh@kernel.org>

On Fri, May 15, 2026 at 12:23:56PM +0200, Andrey Albershteyn wrote:
> New stubs are wrapped with HAVE_LISTMOUNT, but this flag is not
> added if HAVE_LISTMOUNT is set.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Makes sense to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index 22668212f22b..6ada83407e48 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -97,6 +97,7 @@ CFLAGS += -DHAVE_CLOSE_RANGE
>  endif
>  
>  ifeq ($(HAVE_LISTMOUNT),yes)
> +CFLAGS += -DHAVE_LISTMOUNT
>  CFILES += statmount.c
>  HFILES += statmount.h
>  endif
> -- 
> 2.51.2
> 
> 
