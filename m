Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A8B3D64
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337048; cv=none; b=LYXDNeQCXHLPLSYlJ3PQ4NNJcP4GNcfAK15MHBQGnUHAAD0rwpNqqtVn0HUMlxy5JSmscuW5FXNGaJY4wR4s6jIw1ERyt5L9ADSL47MtrgHI9tGG6ZVbIir+no3mq0Eu6IK+5dtbS7gxqUVGjazn6/ScLgHZwAxWjHq2yTi53Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337048; c=relaxed/simple;
	bh=BPRtno/f0W4qzXDzGFal2XHJyNsNdMRVQaeFsH2gJmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMEyDkaz9bFd4gWjEmlxG8b7mcMVwFGWkMZ0JMsqqN+5h3HBO2+53Jb0l0QtfarmJNrQu1+5c3jFAUhVjIQUpv684M2BC3xDKE4UgjMXlAuySeGouLX+SjBmw7mrRflbjZaNrd4EWdT7MqIJL+b0Cp1HIVPIU+7eyfUJgl7cQFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVMfPKYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVMfPKYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CF5C2BD10;
	Fri, 14 Jun 2024 03:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718337048;
	bh=BPRtno/f0W4qzXDzGFal2XHJyNsNdMRVQaeFsH2gJmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVMfPKYHGUgZsm9zsf0lvFwfXklE4TJSxA5WQKc3kU/9H3d54gkNVaCOzI9Rr3AN+
	 UnmtsAN3Uxajwfz3aC0y6tzU1p3+SN37jeFXsclO+0NLS3VoIaTFMwJgZclu2rUKN9
	 dGo2GvtMEiyo62Ri669RGvw+0nuXujuoCDrCJAiOr/GfCBi1r85vrurFJpw6WkDGwN
	 0NIWdq8lBMqZqNlrwCa77b7pIjw4N8BczU83Ff8p+pmhL2j18Iu+W7isLdJ15Vvfsx
	 O4vbT7OEbHs/5iqSwuUE8vUnX74tbv0oXdicSrc+bWhgqSeX4rPQPaA753/lphEc7u
	 uC4WGT8eU2LZA==
Date: Thu, 13 Jun 2024 20:50:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v2 2/4] xfs_db: fix unitialized automatic struct ifake to
 0.
Message-ID: <20240614035047.GC6125@frogsfrogsfrogs>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
 <20240613211933.1169581-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613211933.1169581-3-bodonnel@redhat.com>

On Thu, Jun 13, 2024 at 04:09:16PM -0500, Bill O'Donnell wrote:
> Ensure automatic struct ifake is properly initialized.
> 
> Coverity-id: 1596600, 1596597
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/bmap_inflate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
> index 33b0c954..219f9bbf 100644
> --- a/db/bmap_inflate.c
> +++ b/db/bmap_inflate.c
> @@ -340,7 +340,7 @@ build_new_datafork(
>  	const struct xfs_bmbt_irec	*irec,
>  	xfs_extnum_t			nextents)
>  {
> -	struct xbtree_ifakeroot		ifake;
> +	struct xbtree_ifakeroot		ifake = {};
>  	struct xfs_btree_cur		*bmap_cur;
>  	int				error;
>  
> @@ -394,7 +394,7 @@ estimate_size(
>  		.leaf_slack		= 1,
>  		.node_slack		= 1,
>  	};
> -	struct xbtree_ifakeroot		ifake;
> +	struct xbtree_ifakeroot		ifake = {};
>  	struct xfs_btree_cur		*bmap_cur;
>  	int				error;
>  
> -- 
> 2.45.2
> 
> 
