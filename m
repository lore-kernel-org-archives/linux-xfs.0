Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBE217C203
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764316865; cv=none; b=KNth5RIJdR9fydu+t22Ttc3VeYvDWNW1M/uXsQGfE71Eo89Xeb1heY3egQl6YGg5PhpHfl92vN5N4XgwFfM98+PrZ6ZGerQqLQFh5b4Pi8QIrJ1pxRMZkawhWsmffeZbW/1xT4rn/72SYAtx2XoqMmxs8kDjVkZ74/DfnfXsDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764316865; c=relaxed/simple;
	bh=NmgZpmYn4j5ybO1IIp6sD/Yw/xvmcABypTRWO1bh6Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5iEJSRTplsUx7EPUJSXhX9DkvwufEr4XmyYCmlr+WSKBdzn8qq8h0AumnteoBzamiBxs4kVUwbEDuYl/AJdZy/36+PXBDVTWVbTMQGTtBgSRekRGsUCjl4vvQfS5PC10YAVv1uMK2Ij/yktMvfFGEmI3cQFOvje46OjAIH7wWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO20gE6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO20gE6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F917C4CEF1;
	Fri, 28 Nov 2025 08:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764316864;
	bh=NmgZpmYn4j5ybO1IIp6sD/Yw/xvmcABypTRWO1bh6Vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MO20gE6UplBt/C03yiZNCvguLjdNkBlglX4hWv340estOd07AjbQ19jNxNZJ29hyV
	 /EoUJQ51DB9gu/IQQp7gQFu5aKZOPv3MCfXdN0o0ScxGuicPvs9KRj2KU9Gglx77bv
	 MHEdqfVNmKv1mVn77dglS8SP7XvWld4LsPWlaODYNhoVy6sEtaTz3EgITihaUY1D1i
	 U5M8vTyR0mTIblLrEgiPiAT91PSZM0k8tiQa/Z/x1WXA8UVs+cWwY+7UfcmCrzkllP
	 rAb7XwcyzYCLwRQEkIKmXeIGBkFV8O6X8qR2fsKWDJeWPbOqxxlISiXeznodylrDgd
	 nTkdWiE18pR2Q==
Date: Fri, 28 Nov 2025 09:00:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <z4sbdrflefzmzgshjhynq3mrvospl5mkipp4ogajqp44sntazc@cot4zzdmnqql>
References: <20251128063719.1495736-1-hch@lst.de>
 <PkROJYgxikcR723QVoiHcf9IdPujc43prjwQuZH2Fs6gkkraq53H1Ae-Rz1uWFfbvV0E60UCWAU6DCX5F-Pt1g==@protonmail.internalid>
 <20251128063719.1495736-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063719.1495736-3-hch@lst.de>

On Fri, Nov 28, 2025 at 07:37:00AM +0100, Christoph Hellwig wrote:
> Add an array with the canonical name for each inode type so that code
> doesn't have to implement switch statements for that, and remove the now
> trivial process_misc_ino_types and process_misc_ino_types_blocks
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> -


>  static inline int
>  dinode_fmt(
>  	struct xfs_dinode *dino)
> @@ -2261,16 +2180,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
>  	case XR_INO_BLKDEV:
>  	case XR_INO_SOCK:
>  	case XR_INO_FIFO:
> -		if (process_misc_ino_types(mp, dino, lino, type))
> -			return 1;
> -		break;
> -
>  	case XR_INO_UQUOTA:
>  	case XR_INO_GQUOTA:
>  	case XR_INO_PQUOTA:
> -		/* Quota inodes have same restrictions as above types */
> -		if (process_misc_ino_types(mp, dino, lino, type))
> +		/*
> +		 * Misc inode types that have no associated data storage (fifos,
> +		 * pipes, devices, etc.) mad thus must also have a zero size.

		Perhaps is my non-native English, but this sentence
		doesn't make much sense to me. Not sure if 'mad' has
		some special meaning in this context?

Other than that, the patch looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> +		 */
> +		if (dino->di_size != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> +				xr_ino_type_name[type], lino,
> +				(int64_t)be64_to_cpu(dino->di_size));
>  			return 1;
> +		}
>  		break;
> 
>  	case XR_INO_RTDATA:
> @@ -3704,10 +3627,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	dino = *dinop;
> 
>  	/*
> -	 * enforce totblocks is 0 for misc types
> +	 * Enforce totblocks is 0 for misc types.
> +	 *
> +	 * Note that di_nblocks includes attribute fork blocks, so we can only
> +	 * do this here instead of when reading the inode.
>  	 */
> -	if (process_misc_ino_types_blocks(totblocks, lino, type))
> -		goto clear_bad_out;
> +	switch (type)  {
> +	case XR_INO_CHRDEV:
> +	case XR_INO_BLKDEV:
> +	case XR_INO_SOCK:
> +	case XR_INO_FIFO:
> +		if (totblocks != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> +				xr_ino_type_name[type], lino, totblocks);
> +			goto clear_bad_out;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> 
>  	/*
>  	 * correct space counters if required
> --
> 2.47.3
> 
> 
