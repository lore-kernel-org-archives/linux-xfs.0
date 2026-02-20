Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F0366047
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771609103; cv=none; b=kSe0idbQCxTwMQ7yCXGZbB80kXuWyxyDW79WlMhIAF1ixcspGLiLcFSHiobirG9/I8PXIAeJJg4XKe7l8feT7EHZXur7PR5C1O3gzz4ecHLKSaRYwg6YQVdxEVlSl1we45zosv0dSQkvnEDilJAer0wbtvxupTZNbGT24pI4bf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771609103; c=relaxed/simple;
	bh=XdDTaFoSe9mc1fD2fv/JClDi2RenbGpk6mud6CDwyOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/7Ff0a0vPyqrnHdQnKJcwDzioBAEIJsLve8WcipW5twmZmOLZfzG7tcNP2mNzFdi3TURT0dBSxhHIh9f/dABJ1P61N8RtL6MvNcUUD/hvTaeNW7OM1wgSacxr1SluockNB5Ny84aaYMcSkGx3p4OYDFe0UaLl9qIs2SXX6bkE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8pYTnRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8pYTnRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B5C116C6;
	Fri, 20 Feb 2026 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771609103;
	bh=XdDTaFoSe9mc1fD2fv/JClDi2RenbGpk6mud6CDwyOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p8pYTnRQoJbN6pEFCRW19ilZu5oW/cGCukDdccjUM6fnZZjxVf6BjHDjhHh3z+Yio
	 GSTJcuXdF2OI+iNbGGI22N43zI+q/GXJFiOIJ8Co0aZqD7m6892N+azOuCYjVxPlwS
	 h8G83AV0vgcKA1DkWvMl2OUGIyMQs005FW1qVqEXw8lI8Vc9L5vvxym6humZegl5RC
	 5xd+4v2MAytG7lzjXnzaJj6C2j8uk+kgSXilztf9fLVjvFVyGPDTA5QOfiTMz1KT9R
	 kvlSSfzgGdZbd5nbfvlIsUj3o97Lmgw3cphCWOssgGprU8sJhwXhnVJdHt7Mr1Fe/I
	 1xta/PC/6K26Q==
Date: Fri, 20 Feb 2026 09:38:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] debian: Drop Uploader: Bastian Germann
Message-ID: <20260220173822.GA6490@frogsfrogsfrogs>
References: <20260220171714.852017-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220171714.852017-1-bage@debian.org>

On Fri, Feb 20, 2026 at 06:17:10PM +0100, Bastian Germann wrote:
> I am no longer uploading the package to Debian.
> The package is the same except for debian/upstream/signing-key.asc
> which I have kept on the actual signer's key for the releases.

Thanks for all your packaging help over the years!

> Signed-off-by: Bastian Germann <bage@debian.org>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 66b0a47a..6473c10b 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -2,7 +2,7 @@ Source: xfsprogs
>  Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
> -Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
> +Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
>  Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
> 
