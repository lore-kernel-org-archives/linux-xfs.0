Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73DC15B0E8
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717109406; cv=none; b=rf5MdRjrFdPUYIx7XlaRRh34EgfYYdJzKkBR4LascFTtcWdzC0FG867tEYemktb5HRYMvDU5XU5vUYUaMSelMUDwvlggsL35IBoy+UsBFb8E/jNGQxtZG0FkDMYWBO1OMUJHfcP2cp1rWzrl/jAMeMZskoqdSfLmDM8GzJkqWb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717109406; c=relaxed/simple;
	bh=qtOPHxDHhpffR92ThVkKravlq7bgBpAT34rsIdWv9/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AY+vYJ1U5vhZ3Xbz+yBgktEDta7D98hnRd3RYY+xLXFHk4u48MTPFnZ6SfatdesVewcOyMA/EF3174NFfhcbU3izDOAVuYYz5fTp90ZufqbNh1cm7K0GIRJcD656wTGnuM3rNIPHTWJ+XWxU6Ra2aVwNSNZ1rAu6QYJ9G86qHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cW18FWy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cW18FWy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69025C2BBFC;
	Thu, 30 May 2024 22:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717109406;
	bh=qtOPHxDHhpffR92ThVkKravlq7bgBpAT34rsIdWv9/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cW18FWy1xIVn4gm8skzd6BN2hxhGTRSYOUoGEG5p9Wjb1jhPdH8cX1Fvq4cD2i3w4
	 rh//8P+4GsQuHnzlE8KlL5tKQeYz5PSjNoHQrhgd0gWqcEmCRkLpRxUBEJP7eKwniI
	 8PmMTXOm0ZLuV61dCbQxzUb1i5LerhpfeMiHg7CSLFmZmufLjghjSlePQXen53Fvkp
	 601xywoOySkSIfmd9hBZOWQj3qXUv32cnAt//9o6I++hInIjPLeB/+ffmN9kTqQzaB
	 XQLcnmJvqveT7YO/7ZaDwcKBqQXxK1dnqzbVDS7eurwmSzouqNZQdNtvpxMI/EHWhr
	 9cdG+c9SBjTOQ==
Date: Thu, 30 May 2024 15:50:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@redhat.com
Subject: Re: [PATCH 1/2] xfs_db: Fix uninicialized error variable
Message-ID: <20240530225005.GB52987@frogsfrogsfrogs>
References: <20240530223819.135697-1-preichl@redhat.com>
 <20240530223819.135697-2-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530223819.135697-2-preichl@redhat.com>

On Fri, May 31, 2024 at 12:38:18AM +0200, Pavel Reichl wrote:
> To silence redhat's covscan checker:
> 
> Error: UNINIT (CWE-457): [#def1] [important]
> xfsprogs-6.4.0/db/hash.c:308:2: var_decl: Declaring variable "error" without initializer.
> xfsprogs-6.4.0/db/hash.c:353:2: uninit_use: Using uninitialized value "error".
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/hash.c b/db/hash.c
> index 05a94f24..9b3fdea6 100644
> --- a/db/hash.c
> +++ b/db/hash.c
> @@ -304,7 +304,7 @@ collide_xattrs(
>  	struct dup_table	*tab = NULL;
>  	xfs_dahash_t		old_hash;
>  	unsigned long		i;
> -	int			error;
> +	int			error = 0;
>  
>  	old_hash = libxfs_da_hashname((uint8_t *)name, namelen);
>  
> -- 
> 2.45.1
> 
> 
