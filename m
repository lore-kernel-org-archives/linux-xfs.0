Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4336D24
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiY9Xuet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACDAC433C7;
	Tue, 19 Dec 2023 05:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702963651;
	bh=LqbY3oJHMIVB4+uu++4ZVbzkoBNeBV/MeRkWtJv6o6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TiY9Xuett6QZZV3IPaDSXuVPNdlClqC71cbCDjWdfR7mMtr/5Br2xnyDcOi5G4v6A
	 9UUiTzrGR/cLwQU3h5l/3XHci5m3fNa6RjeebS04jICj/ntpqSojjIw9FngsGanaDE
	 7WnnxvdKDVzh1xtNTXdhTPXb2EyaEHU71B0K3E742K0tDFXFqYZT9c63DmyrDaUt2T
	 BbxfXUJgLIOcJo5SWlp8fMqW6r4ESM51FJG32v0I+JUnqfviOc35Q1gGeNtVCcTBos
	 SkgwRKejNOFRLWikedRQ7C1E6Y9pEy9Z4M433Mf1Gv6S9UYx3WcdMqkQ6ifpzdo9bD
	 8IvzC2DomaEYQ==
Date: Mon, 18 Dec 2023 21:27:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] build: Request 64-bit time_t where possible
Message-ID: <20231219052730.GK361584@frogsfrogsfrogs>
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-3-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215013657.1995699-3-sam@gentoo.org>

On Fri, Dec 15, 2023 at 01:36:42AM +0000, Sam James wrote:
> Suggested by Darrick during LFS review. We take the same approach as in
> 5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
> to avoid autoconf hell - just take the tried & tested approach which is working
> fine for us with LFS already.
> 
> Signed-off-by: Sam James <sam@gentoo.org>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/builddefs.in | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 147c9b98..969254f3 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -13,8 +13,8 @@ OPTIMIZER = @opt_build@
>  MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
> -CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
> -BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
> +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
> +BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
>  
>  # make sure we don't pick up whacky LDFLAGS from the make environment and
>  # only use what we calculate from the configured options above.
> -- 
> 2.43.0
> 
> 
