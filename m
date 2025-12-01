Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CFE29617D
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 22:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764629237; cv=none; b=CDJt6Nv6PLnxI8WI9jSDbnHzy1tp9BgtHDLkUsaEM4RWQGDzNog0csF7KKu3fI8a6OHJBKTd8dhn8zorTyGuqz82SNNrmscreE4yWWgEU+zbX7j/77fzWEd6i5FGqkX85D2p2Y49GyhDtTozribhpLw2rI11Q/fHvdjk6/+Nokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764629237; c=relaxed/simple;
	bh=9Pj20xDCJAatFQOfusX27QziRqUILAWhEGNKXOzYCs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1vkPJvlRBizHQvLEVtye2rhcypFCmJOBGk8CeZZtT9ECf4ywfQq41KqesxjiPnBMFVWLsh+DKVwa3utCzOpd5Au8af4xsOKBPurzVEaeH3hp0ZdAtAeZYanLEspqX2rX/0XoIinbXN0WNjGNaZYbMBOkW7d2Q3VJQvryNH6OJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE5RbxAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE5RbxAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB7C4CEF1;
	Mon,  1 Dec 2025 22:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764629236;
	bh=9Pj20xDCJAatFQOfusX27QziRqUILAWhEGNKXOzYCs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DE5RbxAzkGKphghZNL4tKJ2zye4x9yYPfbGFbPfDlIHFODV5PzZQHXa1HFQxI18TQ
	 xvUGUbm1aWYvApOr6kB6PFCr9+c3SEbSRZ/QqgpLZ2nu+gdQdQwSSaROVr6Z++VcGh
	 jRWua8AIk4h+sWPzGYhMWeINeZIlCaEBD47hJIACB3vK94pUsfgM72diaGHZmETDlr
	 qL1KEsJEA8Q8fsxvOwaq/9K4XsxisCxxsC0/iXeVmi3E90DaPlZ8wmrPOGlmGhVHv2
	 dNBKIhyyKELOs05c2CzO7gMs0u2B1RJmXUwrDz+6DXoRD08vHPAT4qbOu0dJB/8/He
	 NhL+xw9xklADA==
Date: Mon, 1 Dec 2025 14:47:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251201224716.GC89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128063719.1495736-3-hch@lst.de>

On Fri, Nov 28, 2025 at 07:37:00AM +0100, Christoph Hellwig wrote:
> Add an array with the canonical name for each inode type so that code
> doesn't have to implement switch statements for that, and remove the now
> trivial process_misc_ino_types and process_misc_ino_types_blocks
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/dinode.c | 157 +++++++++++++++---------------------------------
>  1 file changed, 48 insertions(+), 109 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index b824dfc0a59f..fd40fdcce665 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -43,6 +43,25 @@ enum xr_ino_type {
>  	XR_INO_RTREFC,		/* realtime refcount */
>  };
>  
> +static const char *xr_ino_type_name[] = {
> +	[XR_INO_UNKNOWN]	= "unknown",
> +	[XR_INO_DIR]		= "directory",
> +	[XR_INO_RTDATA]		= "realtime file",
> +	[XR_INO_RTBITMAP]	= "realtime bitmap",
> +	[XR_INO_RTSUM]		= "realtime summary",
> +	[XR_INO_DATA]		= "regular file",
> +	[XR_INO_SYMLINK]	= "symlink",
> +	[XR_INO_CHRDEV]		= "character device",
> +	[XR_INO_BLKDEV]		= "block device",
> +	[XR_INO_SOCK]		= "socket",
> +	[XR_INO_FIFO]		= "fifo",
> +	[XR_INO_UQUOTA]		= "user quota",
> +	[XR_INO_GQUOTA]		= "group quota",
> +	[XR_INO_PQUOTA]		= "project quota",
> +	[XR_INO_RTRMAP]		= "realtime rmap",
> +	[XR_INO_RTREFC]		= "realtime refcount",
> +};

Might want a

BUILD_BUG_ON(ARRAY_SIZED(xr_ino_type_name) != XR_INO_MAX);

so that someone adding to the enum won't forget to add a string here.

> +
>  /*
>   * gettext lookups for translations of strings use mutexes internally to
>   * the library. Hence when we come through here doing parallel scans in
> @@ -1946,106 +1965,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
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
> +		 */
> +		if (dino->di_size != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> +				xr_ino_type_name[type], lino,

i18n nit: In the old code, the inode description ("realtime bitmap")
would be translated, now they aren't.  I don't know of a good way to
maintain that though...

"el tamaño del realtime bitmap nodo 55 != 0"

               ^^^^^^^^^^^^^^^ whee, English in the middle of Spanish!

I guess you could write "_(xr_ino_type_name[type])" for that second
argument.

That aside, this is a lot less copy pasta at least.

--D

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
