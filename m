Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D51A4F3C
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765215403; cv=none; b=WD+7ZXN6jsixt3xqoaSrhETcuUSMXmSUirSt9fPQnGrrJytgYIP/VIQU2F/nSrYnvQH3nYoHWYFb+mnQ+EX0mT7rLv0AIiTDxbmLO/d5en46SSMSnxXziLdXEnzYTy0D8X3++CKgaBGra3+CDiaJaK+g+Oo33RAoGkON1JjJBa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765215403; c=relaxed/simple;
	bh=KFIrCyhfSB9+XLyriWuHLPZxb6I2E+PXbCqZHOvAni0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prfNq04lxNKnNkQDC/r14L2TPDJ4rib3dMLLHXwPaDA91NP0maW/vhc9r6ybX1r+5tu94FEn08+K08QkqkVS6+nVs2sm35U5RH0SZsn0gG4yawZuEpWrCh4yzTBw7EA4tBo2XVs9tusM/Ndxz6M8+SVPdYTF92Yae6Jug0UMH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MADMDsIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MADMDsIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC478C4CEF1;
	Mon,  8 Dec 2025 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765215402;
	bh=KFIrCyhfSB9+XLyriWuHLPZxb6I2E+PXbCqZHOvAni0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MADMDsIwolA0D/rhrEA65BP2WaFuNj+pp7+s81EfotYC5b/KPweoT8/x+l1ZafA5l
	 VR+lSrDw3mb5SdLT3J8umvgc5lLlde+4wAMAw0sAFS1KbJMBNsAfbu5GYWImti90PC
	 F8ZSkaj5fuuHM8V6AJtlQIqZLW966+dvqseZo88P4jTlS5TDs5MqRP6YJX/0uA/XI6
	 i4ke2pa/bI3iJaLZ0G+SSNFedWzVh48Wnpz8MjLr0TQa6OXbTK94V0eYIk0xqPNcPm
	 EUnJd+0QBGvmKVP3PaAh6AbxFNTf6xRY8o+kpbmLuQjjeTTO+Pcx3EPfqZ2Khk+2xe
	 aKqFtZfSrCV+Q==
Date: Mon, 8 Dec 2025 09:36:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251208173642.GS89472@frogsfrogsfrogs>
References: <20251208071128.3137486-1-hch@lst.de>
 <20251208071128.3137486-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208071128.3137486-3-hch@lst.de>

On Mon, Dec 08, 2025 at 08:11:05AM +0100, Christoph Hellwig wrote:
> Add an array with the canonical name for each inode type so that code
> doesn't have to implement switch statements for that, and remove the now
> trivial process_misc_ino_types and process_misc_ino_types_blocks
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  repair/dinode.c | 159 +++++++++++++++---------------------------------
>  1 file changed, 50 insertions(+), 109 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index b824dfc0a59f..bf2739a6eae5 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -41,8 +41,29 @@ enum xr_ino_type {
>  	XR_INO_PQUOTA,		/* project quota inode */
>  	XR_INO_RTRMAP,		/* realtime rmap */
>  	XR_INO_RTREFC,		/* realtime refcount */
> +	XR_INO_MAX
>  };
>  
> +static const char *xr_ino_type_name[] = {
> +	[XR_INO_UNKNOWN]	= N_("unknown"),
> +	[XR_INO_DIR]		= N_("directory"),
> +	[XR_INO_RTDATA]		= N_("realtime file"),
> +	[XR_INO_RTBITMAP]	= N_("realtime bitmap"),
> +	[XR_INO_RTSUM]		= N_("realtime summary"),
> +	[XR_INO_DATA]		= N_("regular file"),
> +	[XR_INO_SYMLINK]	= N_("symlink"),
> +	[XR_INO_CHRDEV]		= N_("character device"),
> +	[XR_INO_BLKDEV]		= N_("block device"),
> +	[XR_INO_SOCK]		= N_("socket"),
> +	[XR_INO_FIFO]		= N_("fifo"),
> +	[XR_INO_UQUOTA]		= N_("user quota"),
> +	[XR_INO_GQUOTA]		= N_("group quota"),
> +	[XR_INO_PQUOTA]		= N_("project quota"),
> +	[XR_INO_RTRMAP]		= N_("realtime rmap"),
> +	[XR_INO_RTREFC]		= N_("realtime refcount"),
> +};
> +static_assert(ARRAY_SIZE(xr_ino_type_name) == XR_INO_MAX);
> +
>  /*
>   * gettext lookups for translations of strings use mutexes internally to
>   * the library. Hence when we come through here doing parallel scans in
> @@ -1946,106 +1967,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
>  	return(0);
>  }
>  
> -/*
> - * called to process the set of misc inode special inode types
> - * that have no associated data storage (fifos, pipes, devices, etc.).
> - */
> -static int
> -process_misc_ino_types(
> -	xfs_mount_t		*mp,
> -	struct xfs_dinode	*dino,
> -	xfs_ino_t		lino,
> -	enum xr_ino_type	type)
> -{
> -	/*
> -	 * must also have a zero size
> -	 */
> -	if (be64_to_cpu(dino->di_size) != 0)  {
> -		switch (type)  {
> -		case XR_INO_CHRDEV:
> -			do_warn(
> -_("size of character device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
> -				(int64_t)be64_to_cpu(dino->di_size));
> -			break;
> -		case XR_INO_BLKDEV:
> -			do_warn(
> -_("size of block device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
> -				(int64_t)be64_to_cpu(dino->di_size));
> -			break;
> -		case XR_INO_SOCK:
> -			do_warn(
> -_("size of socket inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
> -				(int64_t)be64_to_cpu(dino->di_size));
> -			break;
> -		case XR_INO_FIFO:
> -			do_warn(
> -_("size of fifo inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
> -				(int64_t)be64_to_cpu(dino->di_size));
> -			break;
> -		case XR_INO_UQUOTA:
> -		case XR_INO_GQUOTA:
> -		case XR_INO_PQUOTA:
> -			do_warn(
> -_("size of quota inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
> -				(int64_t)be64_to_cpu(dino->di_size));
> -			break;
> -		default:
> -			do_warn(_("Internal error - process_misc_ino_types, "
> -				  "illegal type %d\n"), type);
> -			abort();
> -		}
> -
> -		return(1);
> -	}
> -
> -	return(0);
> -}
> -
> -static int
> -process_misc_ino_types_blocks(
> -	xfs_rfsblock_t		totblocks,
> -	xfs_ino_t		lino,
> -	enum xr_ino_type	type)
> -{
> -	/*
> -	 * you can not enforce all misc types have zero data fork blocks
> -	 * by checking dino->di_nblocks because atotblocks (attribute
> -	 * blocks) are part of nblocks. We must check this later when atotblocks
> -	 * has been calculated or by doing a simple check that anExtents == 0.
> -	 * We must also guarantee that totblocks is 0. Thus nblocks checking
> -	 * will be done later in process_dinode_int for misc types.
> -	 */
> -
> -	if (totblocks != 0)  {
> -		switch (type)  {
> -		case XR_INO_CHRDEV:
> -			do_warn(
> -_("size of character device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> -				lino, totblocks);
> -			break;
> -		case XR_INO_BLKDEV:
> -			do_warn(
> -_("size of block device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> -				lino, totblocks);
> -			break;
> -		case XR_INO_SOCK:
> -			do_warn(
> -_("size of socket inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> -				lino, totblocks);
> -			break;
> -		case XR_INO_FIFO:
> -			do_warn(
> -_("size of fifo inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> -				lino, totblocks);
> -			break;
> -		default:
> -			return(0);
> -		}
> -		return(1);
> -	}
> -	return (0);
> -}
> -
>  static inline int
>  dinode_fmt(
>  	struct xfs_dinode *dino)
> @@ -2261,16 +2182,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
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
> +		 * pipes, devices, etc.) and thus must also have a zero size.
> +		 */
> +		if (dino->di_size != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> +				xr_ino_type_name[type], lino,

The %s parameter still needs to call _() (aka gettext()) to perform the
message catalog lookup:

				_(xr_ino_type_name[type]), lino,

With this and the printf below fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +				(int64_t)be64_to_cpu(dino->di_size));
>  			return 1;
> +		}
>  		break;
>  
>  	case XR_INO_RTDATA:
> @@ -3704,10 +3629,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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
