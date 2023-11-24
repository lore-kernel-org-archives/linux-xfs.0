Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95796FBEA
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eh52nm4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEF0C433C7;
	Fri, 24 Nov 2023 09:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817381;
	bh=ttZkJ2N5HRVYmQsTL5JzWy3B0L1qQYjxtw8JoQVnIvk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=Eh52nm4FjkYqD7cunUUirdAlnoRakIFhMRTJTk82aK90PQBX9xeHIJ1YVraKpkZu7
	 4BFoyx9snKkdAWAPCIZc7IxgPcUmMOSi49IuKvAdqE0+jrB6ecXbTUdr5KHPMuTwTV
	 Fd4/CgasYbwQY+kRjsOLgXoqZkmptxDGqTjBXfvRmm7Dw0oAT/4vuzoo8k162NLpr0
	 m/ntwnex7Z6YLC5u7Of/y4JKSdkrhxbXfUcOwqzr1FSYHFD5viALYRDcazz7iSyiom
	 FqOVJbngdv6vn8AWCJ48z4BvmL+VwyP5bh0a1zN6aTvL6B1liKSbxW/MaA/c9EGW/4
	 kKjhiat48eW0g==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Date: Fri, 24 Nov 2023 14:44:06 +0530
In-reply-to: <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
Message-ID: <878r6nwly5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:07:33 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix this check to look at the correct header field.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mdrestore/xfs_mdrestore.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
>
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 3190e07e478..3f761e8fe8d 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -268,8 +268,6 @@ read_header_v2(
>  	union mdrestore_headers		*h,
>  	FILE				*md_fp)
>  {
> -	bool				want_external_log;
> -
>  	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
>  			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
> @@ -280,10 +278,8 @@ read_header_v2(
>  	if (h->v2.xmh_reserved != 0)
>  		fatal("Metadump header's reserved field has a non-zero value\n");
>  
> -	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
> -			XFS_MD2_COMPAT_EXTERNALLOG);
> -
> -	if (want_external_log && !mdrestore.external_log)
> +	if ((h->v2.xmh_compat_flags & cpu_to_be32(XFS_MD2_COMPAT_EXTERNALLOG)) &&
> +	    !mdrestore.external_log)
>  		fatal("External Log device is required\n");
>  }
>  


-- 
Chandan
