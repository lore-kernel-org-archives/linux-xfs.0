Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61BA18E36F
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727271879; cv=none; b=pE7FgcK4TSC2/nnOV01UKTgO4WKqUz+X5ViKnOsntNFX4ETC3bWyX2Vmw/syMxTeein6P42AJExgQD3NcZVTHgqmBFWGanp7VObXzwBUl7JwV3qdry047Q/OAxWwrGsHvntdMf3ueCOAHNM2++0MUtu4YOtP5praeaRhJKauKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727271879; c=relaxed/simple;
	bh=bjfX+W9ecYLv2KQyc3vgCwpL46k/Rza0dMtW8zcvyXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGdg4JjbWZCqdc7Zm+9uHtb3JjXRgpfji9nuP1vXGuHF4Pu2pmOEgVGAmDtfV2GMUK+0jJ1dw6YUNzwym383dBmrnHJMdsa0nVQUkZrodHYfamTXBI3Cq4gBnqHGQMHNGojpiAfYwW3wxT5c0hF23yfnN44Bn7AEKY18fKbsrEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXapPhDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXapPhDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE0FC4CEC3;
	Wed, 25 Sep 2024 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727271879;
	bh=bjfX+W9ecYLv2KQyc3vgCwpL46k/Rza0dMtW8zcvyXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PXapPhDJZWWxmbgXVAyOD/F1r4OouUXCOUSH32VONV9dkpjXvqnrvr7RVpkWw0dxh
	 AV+dJtqUJ59vYmF5/HEgxLRvh0x+n2SF2X0+aWk4rTwMBeedk4k+ZIzTanyjuLE1VZ
	 X71EI03x9uZFA3SGuXEXG0jFTF+5oP0XJT4qZLKIqbey7qmWts33mZRnfawhp4udAE
	 RsBJzRXJ6xL3PNSqnkDpNeMBtP6thZsWx0GRemryVYemZRtY7Bf7TVWqQJ390mxODF
	 24PcMpP5G/zZdWntObhGPwjSL1hCQFV7vIwgwzb9o2aL+0KRNOMpoIB66sj5NWrgyD
	 7K7mqo7mFKtlQ==
Date: Wed, 25 Sep 2024 15:44:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Carlos Maiolino as XFS release manager
Message-ID: <tndiwahfjnavpwo2oscfhqkkk6lszw7pttlbow75ld4dkfrvv6@r7rdt6rsdosy>
References: <20240925115512.2313780-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925115512.2313780-1-chandanbabu@kernel.org>

On Wed, Sep 25, 2024 at 05:25:09PM GMT, Chandan Babu R wrote:
> I nominate Carlos Maiolino to take over linux-xfs tree maintainer role for
> upstream kernel's XFS code. He has enough experience in Linux kernel and he's
> been maintaining xfsprogs and xfsdump trees for a few years now, so he has
> sufficient experience with xfs workflow to take over this role.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

Acked-by: Carlos Maiolino <cem@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7387afe8f7ea..9d6ae8df2dc3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25297,7 +25297,7 @@ F:	include/xen/arm/swiotlb-xen.h
>  F:	include/xen/swiotlb-xen.h
>  
>  XFS FILESYSTEM
> -M:	Chandan Babu R <chandan.babu@oracle.com>
> +M:	Carlos Maiolino <cem@kernel.org>
>  R:	Darrick J. Wong <djwong@kernel.org>
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
> -- 
> 2.43.0
> 
> 
