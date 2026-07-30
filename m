Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB7423782
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426279; cv=none; b=rmGoFLc83/PGwmvbdRz3WVFC2yiigO6Nbm1uJywWVR/pV3qZEwTvNwp+s5WNjJ1g1QxZ/nc8x3EQ740r58udbIhJS0sh8V+wvW4kOTKz+dCtWql8gexDtJ/WCSqE2OJ2E31DJHhTyCo0+5Yhu31EBaIUduc+oaTorb7BDZZOIUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426279; c=relaxed/simple;
	bh=B+6JSa74sQKo6nbI8+OGkxIhZytJjW1odF4XjiA1joc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVOHpb+AFlYjw2T2soTxQ9Xxn3ET1zHPnUW1cSaWVleNBllrtNKECRKK/kFWOVgkmdQ5j1ns6znP8YOI5stv/4B9vxcUBu9IDb4lSThh+8eLGfc6jsfoqEes5qB2aMh38+td68P2XEGGdk9ZGTc+aaXkkUeJtvpKJwyKLf3Zt2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2w4kcVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2w4kcVp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A63E1F00A3A;
	Thu, 30 Jul 2026 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785426278;
	bh=c9mP9SkmUmWRTMudI/+aMcsmzPGUoJk13YCD4/ppvCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U2w4kcVpnXpRheyyzAYyI7pZ7GJJouK2z1ZoM+y/KE5VsXpfP93osTDVW3L+zxV/3
	 ezjqR6sZyv+J6A9FXK7jnfjzPSHofGFoOZFXsRnUtJ93dca16ZLTQ6uun/qLJHdYk6
	 ta8yb4In1pleBoVOfNYWjE8Q5srXD3qlvuJGMpzbb4WeV0qm4C6A8AeRtAozwcbj2q
	 jCptxhap1eJtA1hoty3/5uxU5446H19CVIed+DMJHUjyprndrEMcDyaxEN+qkUcm7O
	 2zKJ2hYirqYlcmieVwdKfpNAUI0Fsss6V/NGHsnnfZ7iayuU218jxD+BHqinEtGyw+
	 5ozlpqaHMdRvA==
Date: Thu, 30 Jul 2026 08:44:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] growfs: clarify the man page a bit
Message-ID: <20260730154438.GC3556460@frogsfrogsfrogs>
References: <20260730122841.2591200-1-hch@lst.de>
 <20260730122841.2591200-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730122841.2591200-3-hch@lst.de>

On Thu, Jul 30, 2026 at 02:28:16PM +0200, Christoph Hellwig wrote:
> While no RT section needs to exist for GROWFS_RT to work, the buftarg
> must point to a block device already.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  man/man8/xfs_growfs.8 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> index d6e5fe13e943..1aa57fb0308f 100644
> --- a/man/man8/xfs_growfs.8
> +++ b/man/man8/xfs_growfs.8
> @@ -151,7 +151,8 @@ the real-time section is grown to the largest size possible with the
>  option. The filesystem does not need to have contained a real-time section
>  before the
>  .B xfs_growfs
> -operation.
> +operation, but it must have been mounted with the -o rtdev option pointing
> +to a block device.

Can you grow an internal rt section?

--D

>  .TP
>  .B \-t
>  Specifies an alternate mount table file (default is
> -- 
> 2.53.0
> 
> 
